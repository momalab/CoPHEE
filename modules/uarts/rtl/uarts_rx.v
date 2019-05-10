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



  module uarts_rx (
  // CLOCK AND RESETS ------------------
  input  wire        hclk,              // Clock
  input  wire        hresetn,           // Asynchronous reset

  // MISCELLANEOUS ---------------------
  input  wire [31:0] uarts_baud,
  input  wire [31:0] uarts_ctl,       //1:0 : 00 => 8 bit, 01 => 16 bit, 10 => 32 bit, 11 => 8 bit
                                      //  2 : 0  => No parity,  1 => parity enabled
                                      //  3 : 0  => Odd parity, 1 => Even parity
  input  wire        sample_data_bit,
  input  wire [7:0]  bit_cnt,
  input  wire [7:0]  uarts_dw,
  input  wire [7:0]  uarts_plw,

  // IO ---------------------
  input  wire        RX,              // Event input

  output reg [31:0]  rx_data,
  output reg         rx_irq
);

//-------------------------------------
//localparams, reg and wire declaration
//-------------------------------------

reg [31:0]  rx_reg;
reg [2:0]   rx_curr_st;
reg [2:0]   rx_nxt_st;

  `include "uarts_params.v"

 //RX shift register
   always @ (posedge hclk or negedge hresetn) begin
     if (hresetn == 1'b0) begin
       rx_reg = 32'b0;
     end
     else begin
       if ((sample_data_bit == 1'b1) && (bit_cnt <= uarts_dw)) begin
         rx_reg = {RX, rx_reg[31:1]};
       end
     end
   end
 
 //--------------------------------------------------------
 //RX FSM States
 //--------------------------------------------------------
 //RX_IDLE
 //RX_CHECK  
 //RX_WAIT1  Intermediate wait cycle for address and wdata
 //RX_WAIT2  Intermediate wait cycle for address and wdata
 //RX_WAIT3  Intermediate wait cycle for address and wdata
 //--------------------------------------------------------
 
 always @* begin
   rx_nxt_st = rx_curr_st;
   case (rx_curr_st) //synopsys parallel_case
     RX_IDLE : begin
       if (bit_cnt == uarts_plw[7:0])  begin
         if (uarts_ctl[1:0] == 2'b10) begin
           rx_nxt_st = RX_CHECK;
         end
         else begin
           rx_nxt_st = RX_WAIT1;
         end
       end
     end //RX_IDLE
     RX_CHECK : begin
       rx_nxt_st = RX_IDLE;
     end //RX_CHECK
     RX_WAIT1 : begin
       if (bit_cnt == uarts_plw[7:0])  begin
         if (uarts_ctl[1:0] == 2'b01) begin
           rx_nxt_st = RX_CHECK;
         end
         else begin
           rx_nxt_st = RX_WAIT2;
         end
       end
     end //RX_WAIT1
     RX_WAIT2 : begin
       if (bit_cnt == uarts_plw[7:0])  begin
         rx_nxt_st = RX_WAIT3;
       end
     end //RX_WAIT2
     RX_WAIT3 : begin
       if (bit_cnt == uarts_plw[7:0])  begin
           rx_nxt_st = RX_CHECK;
       end
     end //RX_WAIT3
     default : begin
       rx_nxt_st = RX_IDLE;
     end //default
   endcase
 end

 always @ (posedge hclk or negedge hresetn) begin
   if (hresetn == 1'b0) begin
     rx_curr_st <= 3'b0;
   end
   else begin
     rx_curr_st <= rx_nxt_st;
   end
 end
  
 always @ (posedge hclk or negedge hresetn) begin
   if (hresetn == 1'b0) begin
     rx_irq <= 1'b0;
   end
   else begin
     if ((rx_curr_st != RX_CHECK) && (rx_nxt_st == RX_CHECK)) begin
       rx_irq <= 1'b1;
     end
     else begin
       rx_irq <= 1'b0;
     end
   end
 end
  
 always @ (posedge hclk or negedge hresetn) begin
   if (hresetn == 1'b0) begin
     rx_data <= 32'b0;
   end
   else begin
    if ((rx_curr_st != RX_CHECK) && (rx_nxt_st == RX_CHECK)) begin
      rx_data <= rx_reg[31:0];
    end
   end
 end
 


 
endmodule
