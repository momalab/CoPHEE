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


module padring #(
  parameter NUM_PADS  = 100,
  parameter PAD_CTL_W = 8
  )(
`ifndef FPGA_SYNTH
  input  wire                 VDD,
  input  wire                 DVDD,
  input  wire                 VSS,
  input  wire                 DVSS,
`endif
  inout  wire [NUM_PADS-1 :0] pad,
  input  wire [NUM_PADS-1 :3] pad_in,
  output wire [NUM_PADS-1 :0] pad_out,
  input  wire [PAD_CTL_W-1:0] pad_ctl[NUM_PADS-1:3]
);


//-------------------------------------------
//localparam, genvar and wire/reg declaration
//-------------------------------------------

genvar i;
`ifdef FPGA_SYNTH

IBUF #(
.IOSTANDARD("LVCMOS33") // Specify the input I/O standard
) u_nPORESET_pad_inst (
    .O(pad_out[0]), // Buffer output
    .I(pad[0])      // Buffer input (connect directly to top-level port)
    );


IBUF #(
.IOSTANDARD("LVCMOS33") // Specify the input I/O standard
) u_nRESET_pad_inst (
    .O(pad_out[1]), // Buffer output
    .I(pad[1])      // Buffer input (connect directly to top-level port)
    );



//IBUF #(
//.IOSTANDARD("LVCMOS33") // Specify the input I/O standard
//) u_CLK_pad_inst (
//    .O(pad_out[2]), // Buffer output
//    .I(pad[2])      // Buffer input (connect directly to top-level port)
//    );

assign pad_out[2] = pad[2];


generate
  for (i=3; i<NUM_PADS; i=i+1) begin

    IOBUF #(
       .DRIVE(2),               // Specify the output drive strength
       .IOSTANDARD("LVCMOS33"), // Specify the I/O standard
       .SLEW("SLOW")            // Specify the output slew rate
    ) u_pad_inst (
        .O  (pad_out[i]),   // Buffer output
        .IO (pad[i]),       // Buffer inout port (connect directly to top-level port)
        .I  (pad_in[i]),    // Buffer input
        .T  (pad_ctl[i][0]) // 3-state enable input, high=input, low=output
        );
  end
endgenerate


`else
 PWC_VD_PDO_33V u_poc_pad_inst (
   .SEL18 (1'b0),        //3p3v IO so tying to 0
   .POC   (POC_HV),
   .HVPS  (HVPS_HV),
   .BIAS  (BIAS_HV),
   .VDD   (VDD),
   .VSS   (VSS),
   .DVDD  (DVDD),
   .DVSS  (DVSS)
 );



 STC_IN_001_33V_NC u_nPORESET_pad_inst (
  .PAD  (pad[0]),
  .C    (pad_out[0]),
  .HVPS (HVPS_HV),
  .POC  (POC_HV),
  .BIAS (BIAS_HV),
  .VDD  (VDD),
  .VSS  (VSS),
  .DVDD (DVDD),
  .DVSS (DVSS)
 );

 STC_IN_001_33V_NC u_nRESET_pad_inst   (
  .PAD  (pad[1]),
  .C    (pad_out[1]),
  .HVPS (HVPS_HV),
  .POC  (POC_HV),
  .BIAS (BIAS_HV),
  .VDD  (VDD),
  .VSS  (VSS),
  .DVDD (DVDD),
  .DVSS (DVSS)
 );

 STC_IN_001_33V_NC u_CLK_pad_inst (
  .PAD  (pad[2]),
  .C    (pad_out[2]),
  .HVPS (HVPS_HV),
  .POC  (POC_HV),
  .BIAS (BIAS_HV),
  .VDD  (VDD),
  .VSS  (VSS),
  .DVDD (DVDD),
  .DVSS (DVSS)
 );

generate
  for (i=3; i<NUM_PADS; i=i+1) begin
    SRC_BI_SDS_33V_STB u_pad_inst (
      .I    (pad_in[i]),
      .C    (pad_out[i]),
      .PAD  (pad[i]),
      .OEN  (pad_ctl[i][0]),  //Output Enable
      .REN  (pad_ctl[i][1]),  //RX     Enable
      .P1   (pad_ctl[i][2]),  //pull settting Z, pull up, pull down Repeater
      .P2   (pad_ctl[i][3]),  //pull settting
      .E1   (pad_ctl[i][4]),  //drive strength 2,4,8,12ma
      .E2   (pad_ctl[i][5]),  //drive strength
      .SMT  (pad_ctl[i][6]),  //Schmitt trigger
      .SR   (pad_ctl[i][7]),  //Slew Rate Control
      .POS  (pad_ctl[i][8]),  //Power on state control, state of pad when VDD goes down
      .HVPS (HVPS_HV),
      .POC  (POC_HV),
      .BIAS (BIAS_HV),
      .VDD  (VDD),
      .VSS  (VSS),
      .DVDD (DVDD),
      .DVSS (DVSS)
    );
  end
endgenerate
`endif
 endmodule
