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


module log2 #(
  parameter NBITS = 2048) (
  input               clk,
  input               rst_n,
  input               enable_p,
  input  [2048-1  :0] a,
  output [10      :0] y,
  output              done_irq_p
);
  
//---------------------------------------------
//Reg wire declaration
//---------------------------------------------
  reg [10:0]    y_loc; 
  reg [NBITS-1:0]  a_loc;
  reg           done_irq_p_loc;
  reg           done_irq_p_loc_d;

  always @ (posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
      a_loc <= {NBITS{1'b0}};
      y_loc <= 11'b0;
    end 
    else begin
      if (enable_p == 1'b1) begin
        a_loc <= {1'b0, a[NBITS-1 :1]};
      end
      else if (|a_loc) begin
        a_loc <= {1'b0, a_loc[NBITS-1 :1]};
        y_loc <= y_loc + 1;
      end 
      else begin
        a_loc <= {NBITS{1'b0}};
        y_loc <= 11'b0;
      end
    end
  end
  

  always @ (posedge clk or negedge of rst_n) begin
    if (rstn == 1'b0) begin
      done_irq_p_loc    <= 1'b0;
      done_irq_p_loc_d  <= 1'b0;
    end
    else begin
      done_irq_p_loc    <= |a_loc;
      done_irq_p_loc_d  <= done_irq_p_loc  ;
    end
  end

  assign done_irq_p =  done_irq_p_loc_d & ~done_irq_p_loc;
  assign y          =  y_loc;



endmodule
