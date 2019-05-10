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


module uartm_ahb (
  // CLOCK AND RESETS ------------------
  input  wire        hclk,              // Clock
  input  wire        hresetn,           // Asynchronous reset

  // AHB-LITE MASTER PORT --------------
  output reg  [31:0] haddr,             // AHB transaction address
  output wire [ 2:0] hsize,             // AHB size: byte, half-word or word
  output reg  [ 1:0] htrans,            // AHB transfer: non-sequential only
  output reg  [31:0] hwdata,            // AHB write-data
  output reg         hwrite,            // AHB write control
  input  wire [31:0] hrdata,            // AHB read-data
  input  wire        hready,            // AHB stall signal
  input  wire        hresp,             // AHB error response

  // MISCELLANEOUS ---------------------
  input  wire [2:0]  rx_curr_st,
  input  wire [2:0]  rx_nxt_st,
  input  wire [31:0] rx_reg


);


//-------------------------------------
//localparams, reg and wire declaration
//-------------------------------------

  `include "uartm_params.v"

 //AHB Master Signal generation
  
 always @ (posedge hclk or negedge hresetn) begin
   if (hresetn == 1'b0) begin
     hwrite <= 1'b0;
   end
   else begin
     if ((rx_curr_st != RX_CHECK) && (rx_nxt_st == RX_CHECK)) begin
       if (rx_reg[7:0] == 8'h34) begin
         hwrite <= 1'b1;
       end
       else begin
         hwrite <= 1'b0;
       end
     end
   end
 end
 
 always @ (posedge hclk or negedge hresetn) begin
   if (hresetn == 1'b0) begin
     haddr <= 32'b0;
   end
   else begin
     if (((rx_nxt_st == RX_READ) && (rx_curr_st != RX_READ)) || ((rx_nxt_st == RX_WRITE) && (rx_curr_st != RX_WRITE))) begin
       haddr <= rx_reg;
     end
   end
 end
  
 always @ (posedge hclk or negedge hresetn) begin
   if (hresetn == 1'b0) begin
     hwdata <= 32'b0;
   end
   else begin
     if ((rx_nxt_st == RX_WDATA) && (rx_curr_st != RX_WDATA)) begin
       hwdata <= rx_reg;
     end
   end
 end
 
 always @ (posedge hclk or negedge hresetn) begin
   if (hresetn == 1'b0) begin
     htrans <= 2'b00;
   end
   else begin
     if ((rx_curr_st == RX_READ) || (rx_curr_st == RX_WDATA)) begin
       htrans <= 2'b10;
     end
     else if (hready == 1'b1) begin
       htrans <= 2'b0;
     end
   end
 end

 
 assign hsize  = 3'b010; //4 bytes - 32 bit


endmodule
