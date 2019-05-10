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


module padring_tb #(
  parameter NUM_PADS  = 100,
  parameter PAD_CTL_W = 2
  )(
  inout  wire [NUM_PADS-1 :0] pad,
  input  wire [NUM_PADS-1 :0] pad_in,
  output wire [NUM_PADS-1 :0] pad_out,
  input  wire [3:0]  pad_ctl[NUM_PADS-1:0]
);


//-------------------------------------------
//localparam, genvar and wire/reg declaration
//-------------------------------------------

genvar i;

generate
  for (i=0; i<NUM_PADS; i=i+1) begin
    B4ISH1025_EW u_pad_inst (
      .PADIO      (pad[i]),
      .DOUT       (pad_out[i]),
      .DIN        (pad_in[i]),
      .EN         (pad_ctl[i][0]),
      .R_EN       (pad_ctl[i][1]),
      .PULL_UP    (pad_ctl[i][2]),
      .PULL_DOWN  (pad_ctl[i][3])
    );
  end
endgenerate

endmodule
