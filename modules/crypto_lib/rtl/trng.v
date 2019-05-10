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


module trng #(
  parameter trng_delay = 3)(
  input   wire clk,
  input   wire rst_n,
  input   wire en,
  output  wire y
);


  wire inv1_a;
  wire inv1_y;
  wire inv2_a;
  wire inv2_y;

  reg  trng_sync1;
  reg  trng_sync2;
  reg  trng_sync3;

`ifdef RANDSIM
  reg [31 :0] rand_sim;
  always @ (posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
      rand_sim = 32'b0;
    end
    else begin
      rand_sim = $random;
    end
  end
`endif  
  
  
  assign #trng_delay inv1_y = ~inv1_a;
  //assign #trng_delay inv1_a = en ? inv2_y : inv1_y;
  chiplib_mux2 u_trng_mux1_inst (
    .a (inv1_y),
    .b (inv2_y),
    .s (en),
    .y (inv1_a)
  );

  assign #trng_delay inv2_y = ~inv2_a;
  //assign #trng_delay inv2_a = en ? inv1_y : inv2_y;
  chiplib_mux2 u_trng_mux2_inst (
      .a (inv2_y),
      .b (inv1_y),
      .s (en),
      .y (inv2_a)
    );


  always @ (posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
      trng_sync1 <= 1'b0;
      trng_sync2 <= 1'b0;
      trng_sync3 <= 1'b0;
    end
    else begin
`ifdef RANDSIM
      trng_sync1 <= rand_sim[0];
`else
      trng_sync1 <= inv1_y;
`endif
      trng_sync2 <= trng_sync1;
      trng_sync3 <= trng_sync2;
    end
  end
     assign y = trng_sync3;

endmodule
