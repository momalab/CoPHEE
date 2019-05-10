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


module gpcfg_rd_wr_p (
  input               hclk,
  input               hresetn,
  input               wr_en,
  input               rd_en,
  input      [3:0]    byte_en,
  input      [31:0]   wr_addr,
  input      [31:0]   rd_addr,
  input      [31:0]   wdata,
  output reg [31:0]   wr_reg,
  output     [31:0]   rdata
);


  parameter RESET_VAL     = 32'b0;
  parameter CFG_ADDR      = 16'h0;

  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      wr_reg  <= RESET_VAL;
    end
    else begin
      if (wr_en == 1'b1) begin
        if (wr_addr[15:0] == CFG_ADDR) begin
          if (byte_en[0] == 1'b1) begin
            wr_reg[7:0] <= wdata[7:0];
          end
          if (byte_en[1] == 1'b1) begin
            wr_reg[15:8] <= wdata[15:8];
          end
          if (byte_en[2] == 1'b1) begin
            wr_reg[23:16] <= wdata[23:16];
          end
          if (byte_en[3] == 1'b1) begin
            wr_reg[31:24] <= wdata[31:24];
          end
        end
      end
      else begin
        wr_reg  <= RESET_VAL;
      end
    end
  end

  
  assign rdata = (rd_en & (rd_addr[15:0] == CFG_ADDR)) ? wr_reg : 32'b0;

endmodule
