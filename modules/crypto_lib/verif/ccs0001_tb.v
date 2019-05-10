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


`timescale 1 ns/1 ps
`define RELEASE_M0_RESET

module ccs0001_tb (
);

//---------------------------------
//Local param reg/wire declaration
//---------------------------------

localparam  CLK_PERIOD   = 4.167;   //24 Mhz
localparam  UART_BAUD    = 41.67; //9600 bps

localparam  NUM_PADS     = 11;
localparam  PAD_CTL_W    = 4;

wire [NUM_PADS-1  :0] pad;
wire [NUM_PADS-1  :0] pad_in;
wire [NUM_PADS-1  :0] pad_out;
wire [PAD_CTL_W-1 :0] pad_ctl[NUM_PADS-1 :0];

reg     CLK; 
reg     nPORESET; 
reg     nRESET; 

reg       UART_CLK; 
reg [9:0] tx_reg = 10'h3FF; 
reg [7:0] rx_reg; 
wire uartm_rx_data;

integer no_of_clocks; 

reg [31:0] mem [0:16383];


//Address params
`include "./ccs0001_header.v"

//Tasks
`include "./ccs0001_tasks.v"

//Defines
`define ARM_UD_MODEL;

//initial $readmemh("./hex/cm0.hex", mem);

//------------------------------
//Clock and Reset generation
//------------------------------

initial begin
  CLK      = 1'b0; 
  UART_CLK = 1'b0; 
end

always begin
  #(CLK_PERIOD/2) CLK = ~CLK; 
end

always begin
  #(UART_BAUD/2) UART_CLK = ~UART_CLK; 
end


initial begin

#0 nPORESET  = 1'b1;
   nRESET    = 1'b1;
  repeat (10) begin
    @(posedge CLK);
  end
force ccs0001_tb.u_dut_inst.u_chip_core_inst.u_gpcfg_inst.gpcfg17_reg = 32'h9;

   nPORESET  = 1'b0;
   nRESET    = 1'b0;
//release ccs0001_tb.u_dut_inst.u_chip_core_inst.u_sram_wrap_inst.genblk1[0].u_sram_inst.mem[0:16383];

  repeat (20) begin
    @(posedge CLK);
  end

  nPORESET = 1'b1;

  repeat (25) begin
    @(posedge UART_CLK);
  end

`include "./hex/test.hex"

`ifdef RELEASE_M0_RESET
  repeat (10) begin
    @(posedge UART_CLK);
  end

  nRESET   = 1'b1;
`endif

end



//------------------------------
//DUT
//------------------------------
ccs0001 u_dut_inst 
  (
  .pad  (pad),
  .VDD  (1'b1),
  .DVDD (1'b1),
  .VSS  (1'b0),
  .DVSS (1'b0)
  );

//------------------------------
//Pad to functionality mapping
//------------------------------
//pad0  nPORESET
//pad1  nRESET
//pad2  CLK
//pad3  UARTM_TX
//pad4  UARTM_RX
//pad5  UARTS_TX
//pad6  UARTS_RX
//pad7  GPIO0
//pad8  GPIO1
//pad9  GPIO2
//pad10 GPIO3
//------------------------------

assign pad_in[0]  = nPORESET;
assign pad_ctl[0] = 4'h3;

assign pad_in[1]  = nRESET;
assign pad_ctl[1] = 4'h3;

assign pad_in[2]  = CLK;
assign pad_ctl[2] = 4'h3;


wire pad_ctl_3;
wire pad_ctl_4;
wire pad_ctl_5;
wire pad_ctl_6;
wire pad_ctl_7;
wire pad_ctl_8;
wire pad_ctl_9;
wire pad_ctl_10;

initial begin
force ccs0001_tb.pad_ctl_3  = ccs0001_tb.u_dut_inst.u_padring_inst.pad_ctl[3][0];
force ccs0001_tb.pad_ctl_4  = ccs0001_tb.u_dut_inst.u_padring_inst.pad_ctl[4][0];
force ccs0001_tb.pad_ctl_5  = ccs0001_tb.u_dut_inst.u_padring_inst.pad_ctl[5][0];
force ccs0001_tb.pad_ctl_6  = ccs0001_tb.u_dut_inst.u_padring_inst.pad_ctl[6][0];
force ccs0001_tb.pad_ctl_7  = ccs0001_tb.u_dut_inst.u_padring_inst.pad_ctl[7][0];
force ccs0001_tb.pad_ctl_8  = ccs0001_tb.u_dut_inst.u_padring_inst.pad_ctl[8][0];
force ccs0001_tb.pad_ctl_9  = ccs0001_tb.u_dut_inst.u_padring_inst.pad_ctl[9][0];
force ccs0001_tb.pad_ctl_10 = ccs0001_tb.u_dut_inst.u_padring_inst.pad_ctl[10][0];
end

assign pad_in[3]  = 1'b0;
assign pad_ctl[3] = {3'b001,pad_ctl_3};
assign uartm_rx_data = pad_out[3];

assign pad_in[4]  = tx_reg[0];
assign pad_ctl[4] = {3'b001,pad_ctl_4};

assign pad_in[5]  = 1'b0;
assign pad_ctl[5] = {3'b001,pad_ctl_5};

assign pad_in[6]  = 1'b1;
assign pad_ctl[6] = {3'b001,pad_ctl_6};

assign pad_in[7]  = 1'b0;
assign pad_ctl[7] = {3'b001,pad_ctl_7};

assign pad_in[8]  = 1'b0;
assign pad_ctl[8] = {3'b001,pad_ctl_8};

assign pad_in[9]  = 1'b0;
assign pad_ctl[9] = {3'b001,pad_ctl_9};

assign pad_in[10]  = 1'b0;
assign pad_ctl[10] = {3'b001,pad_ctl_10};

padring_tb #(
  .NUM_PADS  (NUM_PADS),
  .PAD_CTL_W (PAD_CTL_W) )
  u_padring_tb_inst (
  .pad       (pad),
  .pad_in    (pad_in),
  .pad_out   (pad_out),
  .pad_ctl   (pad_ctl)
);

//------------------------------
//Track number of clocks
//------------------------------
initial begin
  no_of_clocks = 0; 
end
always@(posedge CLK)  begin
  no_of_clocks = no_of_clocks +1 ; 
  //$display($time, " << Number of Clocks value         %d", no_of_clocks);
  //$display($time, " << htrans_m[0] value              %b", ccs0001_tb.u_dut_inst.u_chip_core_inst.u_ahb_ic_inst.htrans_m[0][1]);
  //$display($time, " << vlaid_trans_s_by_m[s][0] value %b", ccs0001_tb.u_dut_inst.u_chip_core_inst.u_ahb_ic_inst.vlaid_trans_s_by_m[0][0]);
  //$display($time, " << vlaid_trans_s_by_m[s][1] value %b", ccs0001_tb.u_dut_inst.u_chip_core_inst.u_ahb_ic_inst.vlaid_trans_s_by_m[1][0]);
  //$display($time, " << SLAVE_BASE[0] value            %h", ccs0001_tb.u_dut_inst.u_chip_core_inst.u_ahb_ic_inst.SLAVE_BASE[0][31:16]);
  //$display($time, " << SLAVE_BASE[1] value            %h", ccs0001_tb.u_dut_inst.u_chip_core_inst.u_ahb_ic_inst.SLAVE_BASE[1][31:16]);
  //$display($time, " << haddr_m[0]  value              %h", ccs0001_tb.u_dut_inst.u_chip_core_inst.u_ahb_ic_inst.haddr_m[0][31:16]);
  //$display($time, " << memory dump              %h", ccs0001_tb.u_dut_inst.u_chip_core_inst.u_sram_wrap_inst.u_sram_inst.mem[0]);
end

endmodule
