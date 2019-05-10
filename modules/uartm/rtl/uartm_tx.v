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


module uartm_tx (
  // CLOCK AND RESETS ------------------
  input  wire        hclk,              // Clock
  input  wire        hresetn,           // Asynchronous reset

  // AHB-LITE MASTER PORT --------------
  input  wire [1:0]  htrans,            // AHB write control
  input  wire        hwrite,            // AHB write control
  input  wire        hready,            // AHB stall signal
  input  wire [31:0] hrdata,

  // MISCELLANEOUS ---------------------
  input  wire [31:0] uartm_baud,
  input  wire [31:0] uartm_ctl,       //1:0 : 00 => 8 bit, 01 => 16 bit, 10 => 32 bit, 11 => 8 bit
                                      //  2 : 0  => No parity,  1 => parity enabled
                                      //  3 : 0  => Odd parity, 1 => Even parity
  input  wire [7:0]  uartm_dw,
  input  wire [7:0]  uartm_plw,

  // IO ---------------------
  output  reg        TX              // Event input

);

//-------------------------------------
//localparams, reg and wire declaration
//-------------------------------------

  
  `include "uartm_params.v"

reg        parity;

reg         send_data_bit;
reg         read_trans;
reg         trans_val;
reg         trans_val_d;
reg [7:0]   bit_cnt;
reg [31:0]  tx_reg;
reg [4:0]   shift_cnt;
reg [31:0]  baud_clk_cnt;

reg start_bit;
reg start_bit_d;

//----------------
//TX counter
//----------------

   always @ (posedge hclk or negedge hresetn) begin
     if (hresetn == 1'b0) begin
       baud_clk_cnt <= 32'b0;
     end
     else begin
       if (baud_clk_cnt == uartm_baud) begin
         baud_clk_cnt <= 32'b0;
       end
       else if (trans_val == 1'b1) begin
         baud_clk_cnt <= baud_clk_cnt + 1;
       end
       else begin
         baud_clk_cnt <= 32'b0;
       end
     end
   end

   always @ (posedge hclk or negedge hresetn) begin
     if (hresetn == 1'b0) begin
       trans_val <= 1'b0;
     end
     else begin
       if ((read_trans == 1'b1) || ((|shift_cnt) && (trans_val == 1'b0))) begin
         trans_val <= 1'b1;
       end
       else if (bit_cnt == uartm_plw) begin
         trans_val <= 1'b0;
       end
     end
   end

   always @ (posedge hclk or negedge hresetn) begin
     if (hresetn == 1'b0) begin
       trans_val_d <= 1'b0;
     end
     else begin
         trans_val_d <= trans_val;
     end
   end

   always @ (posedge hclk or negedge hresetn) begin
     if (hresetn == 1'b0) begin
       send_data_bit   <= 1'b0;
     end
     else begin
       if (baud_clk_cnt == uartm_baud) begin
         send_data_bit <= 1'b1;
       end
       else begin
         send_data_bit <= 1'b0;
       end
     end
   end

   always @ (posedge hclk or negedge hresetn) begin
     if (hresetn == 1'b0) begin
       bit_cnt <= 8'b0;
     end
     else begin
       if (bit_cnt == uartm_plw) begin
         bit_cnt <= 8'b0;
       end
       else if (send_data_bit == 1'b1) begin
         bit_cnt <= bit_cnt + 1;
       end
     end
   end
 
 //Capture Read transaction and Read Data from bus
   always @ (posedge hclk or negedge hresetn) begin
     if (hresetn == 1'b0) begin
       read_trans <= 1'b0;
     end
     else begin
       if ((htrans[1] == 1'b1) && (hwrite == 1'b0) && (hready == 1'b1)) begin
           read_trans <= 1'b1;
       end
       else if (hready == 1'b1) begin
         read_trans <= 1'b0;
       end
     end
   end


 //Capture  Rdata to TX shift register
   always @ (posedge hclk or negedge hresetn) begin
     if (hresetn == 1'b0) begin
       tx_reg    <= 32'hFFFF_FFFF;
       shift_cnt <= 5'b0;
       parity    <= 1'b0;
     end
     else begin
       if (read_trans == 1'b1) begin
         tx_reg       <= hrdata;
         parity       <= ~(^hrdata ^ uartm_ctl[3]);
       end
       else if ((send_data_bit == 1'b1) && (bit_cnt <= uartm_dw) && (start_bit_d == 1'b0)) begin
         tx_reg     <= {1'b1, tx_reg[31:1]};
         shift_cnt  <= shift_cnt + 1'b1;
       end
     end
   end

  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      start_bit  <= 1'b0;
    end
    else begin
      if ((trans_val == 1'b1) && (trans_val_d == 1'b0)) begin //Start Bit
        start_bit <= 1'b1;
      end
      else if  (baud_clk_cnt == uartm_baud) begin
        start_bit <= 1'b0;
      end
    end
  end

  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      start_bit_d <= 1'b0;
    end
    else begin
      start_bit_d <= start_bit;
    end
  end


  

  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      TX <= 1'b1;
    end
    else begin
      if (start_bit == 1'b1) begin //Start Bit
        TX <= 1'b0;
      end
      else if ((bit_cnt == uartm_plw-1) || (bit_cnt == uartm_plw)) begin
        TX <= 1'b1;
      end
      else if ((bit_cnt == (uartm_dw)) && (uartm_ctl[2] == 1'b1)) begin //parity
          TX <= parity;
        end
      else if (trans_val == 1'b1) begin
        TX <= tx_reg[0];
      end
      else begin
        TX <= 1'b1;
      end
    end
  end

 

endmodule
