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


module ccs0101 #(
  parameter NUM_PADS  = 11,
  parameter NBITS     = 2048)
  (
`ifndef FPGA_SYNTH
  input wire                VDD,
  input wire                DVDD,
  input wire                VSS,
  input wire                DVSS,
`endif
  inout wire [NUM_PADS-1:0] pad
  );

//-------------------------------
//localparam and wire declaration
//-------------------------------
 localparam PAD_CTL_W = 9;
 
 wire [NUM_PADS-1  :3] pad_in;
 wire [NUM_PADS-1  :0] pad_out;
 wire [PAD_CTL_W-1 :0] pad_ctl[NUM_PADS-1 :3];

  padring #(
    .NUM_PADS  (NUM_PADS),
    .PAD_CTL_W (PAD_CTL_W)
    ) u_padring_inst (
`ifndef FPGA_SYNTH
    .VDD       (VDD),
    .DVDD      (DVDD),
    .VSS       (VSS),
    .DVSS      (DVSS),
`endif
    .pad       (pad),
    .pad_in    (pad_in),
    .pad_out   (pad_out),
    .pad_ctl   (pad_ctl)
    );

  chip_core #(
    .NUM_PADS  (NUM_PADS),
    .PAD_CTL_W (PAD_CTL_W),
    .NBITS     (NBITS)
    )u_chip_core_inst (
    .pad_in    (pad_in),
    .pad_out   (pad_out),
    .pad_ctl   (pad_ctl)
    );


endmodule
