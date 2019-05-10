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


module chiplib_mux2 ( 
  input  a,
  input  b,
  input  s,
  output y
  );

`ifdef FPGA_SYNTH
assign y = (s == 1'b1) ? b : a;
`else
  MX2_X4M_A9TH u_DONT_TOUCH_mux2_inst (
     .A   (a),
     .B   (b),
     .Y   (y),
     .S0  (s)
  );
`endif


endmodule

module chiplib_mux3 ( 
  input        a,
  input        b,
  input        c,
  input  [1:0] s,
  output       y
  );

`ifdef FPGA_SYNTH
assign y = (s == 2'b10) ? c : ((s == 2'b01) ? b : a);
`else
  MX2_X4M_A9TH u_DONT_TOUCH_mux2_inst0 (
     .A   (a),
     .B   (b),
     .Y   (y_int),
     .S0  (s[0])
  );

  MX2_X4M_A9TH u_DONT_TOUCH_mux2_inst1 (
     .A   (y_int),
     .B   (c),
     .Y   (y),
     .S0  (s[1])
  );
`endif

endmodule


module chiplib_mux4 ( 
  input        a,
  input        b,
  input        c,
  input        d,
  input  [1:0] s,
  output       y
  );

`ifdef FPGA_SYNTH
assign y = (s == 2'b11) ? d : ((s == 2'b10) ? c : ((s == 2'b01) ? b : a));
`else
  MX2_X4M_A9TH u_DONT_TOUCH_mux2_inst0 (
     .A   (a),
     .B   (b),
     .Y   (y_int1),
     .S0  (s[0])
  );

  MX2_X4M_A9TH u_DONT_TOUCH_mux2_inst1 (
     .A   (c),
     .B   (d),
     .Y   (y_int2),
     .S0  (s[0])
  );

  MX2_X4M_A9TH u_DONT_TOUCH_mux2_inst2 (
     .A   (y_int1),
     .B   (y_int2),
     .Y   (y),
     .S0  (s[1])
  );

`endif


endmodule


