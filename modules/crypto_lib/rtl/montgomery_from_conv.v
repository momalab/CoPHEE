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


module montgomery_from_conv #(
  parameter NBITS = 2048
 ) (
  input               clk,
  input               rst_n,
  input               enable_p,
  input  [NBITS-1 :0] a,
  input  [NBITS-1 :0] m,
  input  [11      :0] m_size,
  output [NBITS-1 :0] y,
  output              done_irq_p
);

montgomery_mul #(
  .NBITS (NBITS)
 ) u_montgomery_mul_inst (
  .clk               (clk),             //input               
  .rst_n             (rst_n),           //input               
  .enable_p          (enable_p),        //input               
  .a                 (a),               //input  [NBITS-1 :0] 
  .b                 (2048'b1),         //input  [NBITS-1 :0] 
  .m                 (m),               //input  [NBITS-1 :0] 
  .m_size            (m_size),          //input  [10      :0] 
  .y                 (y),               //output [NBITS-1 :0] 
  .done_irq_p        (done_irq_p)       //output              
);



endmodule
