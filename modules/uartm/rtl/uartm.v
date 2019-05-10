/**********************************************************************************
    This module is part of the project CoPHEE.
    CoPHEE: A co-processor for partially homomorphic encrypted encryption
    Copyright (C) 2019  Michail Maniatakos
    New York University Abu Dhabi, wp.nyu.edu/momalab/

    If find any of our work useful, please cite our publication:
      M. Nabeel, M. Ashraf, E. Chielle, N.G. Tsoutsos, and M. Maniatakos.
      "CoPHEE: Co-processor for Partially Homomorphic Encrypted Execution". 
      In: IEEE Hardware-Oriented Security and Trust (HOST). 

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
**********************************************************************************/


//------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//This Block sits as master on the bus matrix. Idea is user can access any memory region of the device through a simple uart interface.
//Which can be used for memory loading and debug.
//The code have 2 part, Rx and Tx. Rx will wait for the start bit - i.e RX line should go from 1 to 0.
//Once the Start bit is detected, it will kick off the counter and resets after reaching half of the baud count (uart_baud_rate/bus_clock_rate)
//After this expiry counter will run again and resets after reaching baud count. And this will be repeated Num_data_bits times + 1 (for stop bit)
//and at every counter expiry it will sample the RX data. As the counter expiry happens around in mid way of the data bit period,
//the data will be stable by then. No need to over sample it.
//
//Expected Sequence of Rx is - Read or write operation preamble - For read : "4D", For Write : "34"
//Next 4 transfer will be  Address Trans 1: lower byte of address, Trans 2 : first byte, Trans 3 : Second byte and Trans 4 : Upper byte of the address
//If it is a write, next 4 transfer will be write data. Trans 1: lower byte of wdata, Trans 2 : first byte, Trans 3 : Second byte and Trans 4 : Upper byte of the wdata
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------
module uartm (
  // CLOCK AND RESETS ------------------
  input  wire        hclk,              // Clock
  input  wire        hresetn,           // Asynchronous reset

  // AHB-LITE MASTER PORT --------------
  output wire [31:0] haddr,             // AHB transaction address
  output wire [ 2:0] hsize,             // AHB size: byte, half-word or word
  output wire [ 1:0] htrans,            // AHB transfer: non-sequential only
  output wire [31:0] hwdata,            // AHB write-data
  output wire        hwrite,            // AHB write control
  input  wire [31:0] hrdata,            // AHB read-data
  input  wire        hready,            // AHB stall signal
  input  wire        hresp,             // AHB error response

  // MISCELLANEOUS ---------------------
  input  wire [31:0] uartm_baud,
  input  wire [31:0] uartm_ctl,       //1:0 : 00 => 8 bit, 01 => 16 bit, 10 => 32 bit, 11 => 8 bit
                                      //  2 : 0  => No parity,  1 => parity enabled
                                      //  3 : 0  => Odd parity, 1 => Even parity

  // IO ---------------------
  output wire        TX,              // Event output (SEV executed)
  input  wire        RX               // Event input

);


//-------------------------------------
//localparams, reg and wire declaration
//-------------------------------------

  `include "uartm_params.v"


wire        start_bit_det;
wire [7:0]  uartm_plw;
wire [7:0]  uartm_dw;

reg [31:0]  baud_clk_cnt;
reg [7:0]   bit_cnt;
reg         poll_start_bit;
reg         sample_data_bit;

wire [31:0] rx_reg;
reg         rx_d1;
reg         rx_d2;
reg         rx_d3;

wire [2:0]  rx_curr_st;
wire [2:0]  rx_nxt_st;
wire [2:0]  rx_prev_st;

//--------------------------------------------------------------
//uartm_ctl
//1:0 : 00 => 8 bit, 01 => 16 bit, 10 => 32 bit, 11 => 8 bit
//  2 : 0  => No parity,  1 => parity enabled
//  3 : 0  => Odd parity, 1 => Even parity
//--------------------------------------------------------------

assign uartm_dw = (uartm_ctl[1:0] == 2'b10) ?
                                             ((uartm_ctl[1:0] == 2'b01) ?
                                                                          8'b0001_0000  //16 bit
                                                                        : 8'b0010_0000) //32 bit
                                            : 8'b0000_1000; //8 bit



//---------------------------------------------------------------------------
//Pay load width = data_width + Start bit + Stop bit +  parity bit if enabled
//Adder is not used as the synthesis tool may not optimize the adder as below
//---------------------------------------------------------------------------

assign uartm_plw = (uartm_ctl[1:0] == 2'b10) ?
                                             ((uartm_ctl[1:0] == 2'b01) ?
                                                                          ({7'b0001_001, uartm_ctl[2]})  //Same as (8'b0001_0010 + {7'b0, uartm_ctl[2]})
                                                                        : ({7'b0010_001, uartm_ctl[2]})) //Same as (8'b0010_0010 + {7'b0, uartm_ctl[2]}))
                                            : ({7'b0000_101, uartm_ctl[2]}); // Same as (8'b0000_1010 + {7'b0, uartm_ctl[2]});

//---------------------------------------------------------------------------
//Synchronize the Input 
//---------------------------------------------------------------------------
   always @ (posedge hclk or negedge hresetn) begin
     if (hresetn == 1'b0) begin
        rx_d1 <= 1'b1;
        rx_d2 <= 1'b1;
        rx_d3 <= 1'b1;
     end
     else begin
        rx_d1 <= RX;
        rx_d2 <= rx_d1;
        rx_d3 <= rx_d2;
     end
   end

//---------------------------------------------------------------------------
//Check for Start bit
//---------------------------------------------------------------------------
   assign start_bit_det = poll_start_bit ? (~rx_d3 & ~RX) : 1'b0;

   always @ (posedge hclk or negedge hresetn) begin
     if (hresetn == 1'b0) begin
       baud_clk_cnt    <= 32'b0;
       poll_start_bit  <= 1'b1;
       sample_data_bit <= 1'b0;
     end
     else begin
       if ((bit_cnt  == 8'b0) && (baud_clk_cnt == {1'b0, uartm_baud[31:1]})) begin  //count for only half the baud rate upon detecting start_bit
         baud_clk_cnt <= 32'b0;
       end
       else if (start_bit_det == 1'b1) begin
         baud_clk_cnt   <= baud_clk_cnt + 1;
         poll_start_bit <= 1'b0;
       end
       else if ((bit_cnt == uartm_plw[7:0]) || (poll_start_bit == 1'b1)) begin     //Disable the counter whenever there current transaction reaches stop bit or there is no transaction
         baud_clk_cnt    <= 32'b0;
         poll_start_bit  <= 1'b1;
         sample_data_bit <= 1'b0;
       end
       else if ((baud_clk_cnt == uartm_baud)) begin
         baud_clk_cnt    <= 32'b0;
         sample_data_bit <= 1'b1;
       end
       else begin
         baud_clk_cnt    <= baud_clk_cnt + 1;
         sample_data_bit <= 1'b0;
       end
     end
   end

   always @ (posedge hclk or negedge hresetn) begin
     if (hresetn == 1'b0) begin
       bit_cnt <= 8'b0;
     end
     else begin
       if ((bit_cnt  == 8'b0) && (baud_clk_cnt == {1'b0, uartm_baud[31:1]})) begin
         bit_cnt <= bit_cnt + 1;
       end
       else if ((bit_cnt == uartm_plw[7:0]) || (poll_start_bit == 1'b1)) begin
         bit_cnt <= 8'b0;
       end
       else if (sample_data_bit == 1'b1) begin
         bit_cnt <= bit_cnt + 1;
       end
     end
   end
 

uartm_ahb u_uartm_ahb_inst (
  .hclk             (hclk),            //input  wire         // Clock
  .hresetn          (hresetn),         //input  wire         // Asynchronous reset
  .haddr            (haddr),           //output reg  [31:0]  // AHB transaction address
  .hsize            (hsize),           //output wire [ 2:0]  // AHB size: byte, half-word or word
  .htrans           (htrans),          //output reg  [ 1:0]  // AHB transfer: non-sequential only
  .hwdata           (hwdata),          //output reg  [31:0]  // AHB write-data
  .hwrite           (hwrite),          //output reg          // AHB write control
  .hrdata           (hrdata),          //input  wire [31:0]  // AHB read-data
  .hready           (hready),          //input  wire         // AHB stall signal
  .hresp            (hresp),           //input  wire         // AHB error response
  .rx_curr_st       (rx_curr_st),      //input  wire [2:0]  
  .rx_nxt_st        (rx_nxt_st),       //input  wire [2:0]  
  .rx_reg           (rx_reg)           //input  wire [31:0] 


);

uartm_rx u_uartm_rx_inst (
  .hclk             (hclk),            //input  wire          // Clock
  .hresetn          (hresetn),         //input  wire          // Asynchronous reset
  .hwrite           (hwrite),          //input  wire          // AHB write control
  .hready           (hready),          //input  wire          // AHB stall signal
  .uartm_baud       (uartm_baud),      //input  wire [31:0] 
  .uartm_ctl        (uartm_ctl),       //input  wire [31:0] //1:0 : 00 => 8 bit, 01 => 16 bit, 10 => 32 bit, 11 => 8 bit
  .sample_data_bit  (sample_data_bit), //input  wire        // AHB stall signal
  .bit_cnt          (bit_cnt),         //input  wire [7:0]  
  .uartm_dw         (uartm_dw),        //input  wire [7:0]  
  .uartm_plw        (uartm_plw),      //input  wire [7:0]  
  .RX               (RX),              //input  wire        // Event input
  .rx_curr_st       (rx_curr_st),      //output reg [2:0]  
  .rx_nxt_st        (rx_nxt_st),       //output reg [2:0]  
  .rx_reg           (rx_reg)           //output reg  [31:0] 

);

uartm_tx u_uartm_tx_inst (
  .hclk           (hclk),           //input  wire        // Clock
  .hresetn        (hresetn),        //input  wire        // Asynchronous reset
  .htrans         (htrans),         //input  wire [1:0]  // AHB write control
  .hwrite         (hwrite),         //input  wire        // AHB write control
  .hready         (hready),         //input  wire        // AHB stall signal
  .hrdata         (hrdata),         //input  wire [31:0] 
  .uartm_baud     (uartm_baud),     //input  wire [31:0] 
  .uartm_ctl      (uartm_ctl),      //input  wire [31:0] //1:0 : 00 => 8 bit, 01 => 16 bit, 10 => 32 bit, 11 => 8 bit
  .uartm_dw       (uartm_dw),       //input  wire [7:0]  
  .uartm_plw      (uartm_plw),      //input  wire [7:0]  
  .TX             (TX)              //output  reg        // Event input

);



endmodule
