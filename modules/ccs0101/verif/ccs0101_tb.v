`timescale 1 ns/1 ps

module ccs0101_tb (
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
reg [7:0] rx_reg = 8'h00; 
reg [2047:0] uartm_rx_tb_data = 2048'h0; 
wire uartm_rx_data;
wire cleq_host_irq;

integer no_of_clocks; 

reg [31:0] mem [0:16383];

parameter NBITS = 64;

//2147483648
//wire [1023:0]  N     = 1024'd5;
//wire [1023:0]  N        = 1024'd5;
reg [1023:0]    N              = 2**NBITS-1;
reg [2047:0]    nsq            = N*N;
reg [2047:0]    arga           = $random%nsq;
reg [2047:0]    argb           = $random%nsq;
reg [2047:0]    fkf            = $random%nsq;
reg [1023:0]    rand0          = $random%N;
reg [1023:0]    rand1          = $random%N;
//reg [2047:0]    arga           = 256'd18608781395245932114937574087653341074582597198811389767319570945121607579899;
//reg [2047:0]    argb           = 256'd9519143240073796394502333428109018670972285608795793409515990629563179495902;
//reg [2047:0]    fkf            = 256'd5963212733281843749254001784136185352822539560219176362921559981225924513656;
//reg [1023:0]    rand0          = 128'd101338759567263860475763588125088181103;
//reg [1023:0]    rand1          = 128'd165677059890582632002361232989129134985;
reg [11:0]      log2ofn        = $clog2(N);
reg [11:0]      log2ofn2       = $clog2(N*N);
reg [2048:0]    r_for_egcd     = 1'b1 << log2ofn2;
reg [2047:0]    r_red_for_egcd = r_for_egcd - nsq;

reg [2047:0]  scratch_pad;
integer        i;
integer        j;
integer        seed;

//Address params
`include "./ccs0101_header.v"

//Tasks
`include "./ccs0101_tasks.v"


   
//Defines
`define ARM_UD_MODEL;
`define RANDSIM;

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
  force ccs0101_tb.pad_ctl_3  = ccs0101_tb.u_dut_inst.u_padring_inst.pad_ctl[3][0];
  force ccs0101_tb.pad_ctl_4  = ccs0101_tb.u_dut_inst.u_padring_inst.pad_ctl[4][0];
  force ccs0101_tb.pad_ctl_5  = ccs0101_tb.u_dut_inst.u_padring_inst.pad_ctl[5][0];
  force ccs0101_tb.pad_ctl_6  = ccs0101_tb.u_dut_inst.u_padring_inst.pad_ctl[6][0];
  force ccs0101_tb.pad_ctl_7  = ccs0101_tb.u_dut_inst.u_padring_inst.pad_ctl[7][0];
  force ccs0101_tb.pad_ctl_8  = ccs0101_tb.u_dut_inst.u_padring_inst.pad_ctl[8][0];
  force ccs0101_tb.pad_ctl_9  = ccs0101_tb.u_dut_inst.u_padring_inst.pad_ctl[9][0];
  force ccs0101_tb.pad_ctl_10 = ccs0101_tb.u_dut_inst.u_padring_inst.pad_ctl[10][0];
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
assign cleq_host_irq = pad_out[9];

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


initial begin

#0 nPORESET  = 1'b1;
   nRESET    = 1'b1;
  repeat (10) begin
    @(posedge CLK);
  end
force ccs0101_tb.u_dut_inst.u_chip_core_inst.u_gpcfg_inst.uartm_baud_ctl_reg = 32'h9;

   nPORESET  = 1'b0;
   nRESET    = 1'b0;
//release ccs0001_tb.u_dut_inst.u_chip_core_inst.u_sram_wrap_inst.genblk1[0].u_sram_inst.mem[0:16383];

  repeat (20) begin
    @(posedge CLK);
  end

  nPORESET = 1'b1;
  nRESET   = 1'b1;

  repeat (25) begin
    @(posedge UART_CLK);
  end

//`include "./hex/test.hex"
    uartm_write    (.addr(GPCFG_SPIMOSI_PAD_CTL),     .data(32'h000018));
$finish; 
end


//------------------------------
//DUT
//------------------------------
ccs0101 #(
  .NBITS (NBITS)) u_dut_inst 
  (
  .pad  (pad),
  .VDD  (1'b1),
  .DVDD (1'b1),
  .VSS  (1'b0),
  .DVSS (1'b0)
  );



endmodule


