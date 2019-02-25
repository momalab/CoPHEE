module gpcfg #(
parameter NBITS = 2048) (  
  // CLOCK AND RESETS ------------------
  input  wire           hclk,              // Clock
  input  wire           hresetn,           // Asynchronous reset
 // AHB-LITE MASTER PORT --------------
  input   wire          hsel,              // AHB transfer: non-sequential only
  input   wire [31:0]   haddr,             // AHB transaction address
  input   wire [ 2:0]   hsize,             // AHB size: byte, half-word or word
  input   wire [31:0]   hwdata,            // AHB write-data
  input   wire          hwrite,            // AHB write control
  output  reg  [31:0]   hrdata,            // AHB read-data
  output  reg           hready,            // AHB stall signal
  output  reg           hresp,             // AHB error response
  output  reg  [31:0]   pad03_ctl_reg,
  output  reg  [31:0]   pad04_ctl_reg,
  output  reg  [31:0]   pad05_ctl_reg,
  output  reg  [31:0]   pad06_ctl_reg,
  output  reg  [31:0]   pad07_ctl_reg,
  output  reg  [31:0]   pad08_ctl_reg,
  output  reg  [31:0]   pad09_ctl_reg,
  output  reg  [31:0]   pad10_ctl_reg,
  output  reg  [31:0]   pad11_ctl_reg,
  output  reg  [31:0]   pad12_ctl_reg,
  output  reg  [31:0]   pad13_ctl_reg,
  output  reg  [31:0]   pad14_ctl_reg,
  output  reg  [31:0]   pad15_ctl_reg,
  output  reg  [31:0]   pad16_ctl_reg,
  output  reg  [31:0]   pad17_ctl_reg,
  output  reg  [31:0]   pad18_ctl_reg,
  output  reg  [31:0]   pad19_ctl_reg,
  output  reg  [31:0]   uartm_baud_ctl_reg,
  output  reg  [31:0]   uartm_ctl_reg,
  output  reg  [31:0]   uarts_baud_ctl_reg,
  output  reg  [31:0]   uarts_ctl_reg,
  output  reg  [31:0]   uarts_tx_data_reg,
  input   wire [31:0]   uarts_rx_data,
  output  reg  [31:0]   uarts_tx_send_reg,
  output  reg  [31:0]   spare0_reg,
  output  reg  [31:0]   spare1_reg,
  output  reg  [31:0]   spare2_reg,
  output  reg  [31:0]   signature_reg,
  output  wire [NBITS-1:0] arg_a,
  output  wire [NBITS-1:0] arg_b,
  output  wire [NBITS-1:0] arg_b_mod_inv,		
  output  wire [NBITS-1:0] modulus,
  output  wire [11:0]      maxbits,
  output  wire             bypass_vn,
  output  wire             enable_p_mod_mul_il,
  output  wire             enable_p_bin_ext_gcd,
  output  wire             enable_p_rng0,
  output  wire             enable_p_rng1,
  output  reg              cleq_host_irq,
  input   wire [NBITS+2  :0] x,
  input   wire [NBITS-1  :0] gcd,
  input   wire [NBITS-1  :0] mod_mul_il_y,
  input   wire [NBITS/2-1:0] rng0_y,
  input   wire [NBITS/2-1:0] rng1_y,
  input   wire               done_irq_p_mod_mul_il,
  input   wire               done_irq_p_bin_ext_gcd,
  input   wire               done_irq_p_rng0,
  input   wire               done_irq_p_rng1

);

//----------------------------------------------
//localparameter, genva and wire/reg declaration
//----------------------------------------------

  `include "gpcfg_addr_params.v"

  localparam GFUNC_IDLE      = 3'b000;
  localparam GFUNC_RAND0EXP  = 3'b001;
  localparam GFUNC_RAND1EXP  = 3'b010;
  localparam GFUNC_ARGXEXP   = 3'b011;
  localparam GFUNC_LEQ       = 3'b100;
  localparam GFUNC_MODMUL    = 3'b101;
  localparam GFUNC_BBS0      = 3'b110;
  localparam GFUNC_BBS1      = 3'b111;




  reg [31:0] read_data;


  reg [31:0] haddr_lat;
  reg        valid_wr_lat;
  wire       dec_err;

  reg [3:0]  wbyte_en;
  reg [3:0]  wbyte_en_lat;

  reg  [31:0] cleq_ctl_p_reg;
  reg  [31:0] cleq_ctl_reg;
  reg  [31:0] cleq_ctl2_reg;

  reg  [NBITS/2 -1:0] cleq_n_reg;
  reg  [NBITS   -1:0] cleq_nsq_reg;
  reg  [NBITS   -1:0] cleq_fkf_reg;

  wire  [NBITS/2 -1:0] n_loc;
  wire  [NBITS   -1:0] nsq_loc;
  wire  [NBITS   -1:0] fkf_loc;

  reg  [NBITS/2 -1:0] cleq_rand_reg;

  wire [NBITS   -1:0] cleq_arga_reg;
  wire [NBITS   -1:0] cleq_argb_reg;
  wire [NBITS   -1:0] cleq_argc_reg;
  wire [NBITS   -1:0] cleq_pc_reg;

  wire [NBITS/2 -1:0] cleq_rand0_reg;
  wire [NBITS/2 -1:0] cleq_rand1_reg;

  wire [NBITS/2 -1:0] cleq_rand0_init;
  wire [NBITS/2 -1:0] cleq_rand1_init;

  reg [NBITS/2 -1:0] cleq_rand0;
  reg [NBITS/2 -1:0] cleq_rand1;

  reg  [NBITS+2   :0] mod_inv;
  reg                 cl_busy; 
  reg                 cl_busy_d; 
  reg                 cl_inverr; 

  wire [NBITS/2 -1:0] cleq_n; 
  wire [NBITS   -1:0] cleq_nsq; 
  wire [NBITS   -1:0] cleq_fkf; 
  wire [NBITS:0] r_egcd; 

  wire [NBITS/2 -1:0] cleq_rand0_hw;
  wire [NBITS/2 -1:0] cleq_rand1_hw;
  wire [7:0]          rng_errcnt_max;
  
  reg   [4:0] busy_flag_set;
  wire  busy_flag_rel;

  wire [NBITS   -1:0] cleq_leqlo;
  wire [NBITS   -1:0] cleq_leqhi;

  reg  [NBITS   -1:0] gfunc_r0n; 
  reg  [NBITS   -1:0] gfunc_r1n; 
  reg  [NBITS   -1:0] gfunc_x; 
  reg  [NBITS   -1:0] gfunc_res; 

  reg [2:0]    gfunc_curr_state;
  reg [2:0]    gfunc_nxt_state;
  reg [2:0]    gfunc_prev_state;
  reg          gfunc_mul_sel; 
  reg          done_irq_p_gfunc; 

  wire [11:0]   cleq_log2ofn;
  wire          host_irq_clr;
  wire          enable_p_gfunc;
  wire          update_rng;
  wire          run_rng_bbs;
  wire          byp_rng_bbs;

  wire [NBITS   -1:0] r_red_extgcd;
  wire [NBITS   -1:0] mod_exp_y;
  wire done_irq_p_mod_exp;
  wire enable_p_mod_exp;

  reg  [NBITS   -1:0] dbg_data; 
  wire [2         :0] dbg_data_sel; 
 
  parameter MAX_RDATA = 703;
  reg [31:0] rdata [0: MAX_RDATA];
//--------------------------
//Identify valid transaction
//--------------------------
  assign valid_wr = hsel &  hwrite & hready & ~dec_err;
  assign valid_rd = hsel & ~hwrite & hready & ~dec_err;

//--------------------------
//Capture write address
//--------------------------

  always @(posedge hclk or negedge hresetn) begin 
    if (hresetn == 1'b0) begin
      haddr_lat    <= 32'b0;
      wbyte_en_lat <= 3'b0;
    end
    else if (valid_wr == 1'b1) begin
      haddr_lat    <= haddr;
      wbyte_en_lat <= wbyte_en;
    end
  end

  always @(posedge hclk or negedge hresetn) begin 
    if (hresetn == 1'b0) begin
      valid_wr_lat <= 1'b0;
    end
    else begin
      valid_wr_lat <= valid_wr;
    end
  end


     //.OEN  (pad_ctl[i][0]),  //Output Enable
     //.REN  (pad_ctl[i][1]),  //RX     Enable
     //.P1   (pad_ctl[i][2]),  //pull settting Z, pull up, pull down Repeater
     //.P2   (pad_ctl[i][3]),  //pull settting
     //.E1   (pad_ctl[i][4]),  //drive strength 2,4,8,12ma
     //.E2   (pad_ctl[i][5]),  //drive strength
     //.SMT  (pad_ctl[i][6]),  //Schmitt trigger
     //.SR   (pad_ctl[i][7]),  //Slew Rate Control
     //.POS  (pad_ctl[i][8]),  //Power on state control, state of pad when VDD goes down
     //
                          //                      OEN       REN        Pull     Drive     Override
     //PAD03_CTL  UARTM_TX 0000_0000_0000_0001_0110, Enabled   Enabled     Pull Up,   4mA,     Disabled
     //PAD04_CTL  UARTM_RX 0000_0000_0000_0001_0111  Disabled  Enabled     Pull Up,   4ma,     Disabled
     //PAD05_CTL  UARTS_TX 0001_0000_0000_0001_0111  Disabled  Enabled     Pull Up,   4mA,     Enabled
     //PAD06_CTL  UARTS_RX 0001_0000_0000_0001_0111  Disabled  Enabled     Pull Up,   4mA,     Enabled
     //PAD07_CTL  GPIO0    0001_0000_0000_0001_1011  Disabled  Enabled     Pull Down, 4mA,     Enabled
     //PAD08_CTL  GPIO1    0001_0000_0000_0001_1011  Disabled  Enabled     Pull Down, 4mA,     Enabled
     //PAD09_CTL  GPIO2    0001_0000_0000_0001_1011  Disabled  Enabled     Pull Down, 4mA,     Enabled
     //PAD10_CTL  GPIO3    0001_0000_0000_0001_1011  Disabled  Enabled     Pull Down, 4mA,     Enabled
     //PAD11_CTL
     //PAD12_CTL
     //PAD13_CTL
     //PAD14_CTL
     //PAD15_CTL
     //PAD16_CTL
     //PAD17_CTL
     //PAD18_CTL
     //PAD19_CTL


//----------------------------
// Logic for getting read data
//----------------------------
gpcfg_rd_wr #( .RESET_VAL (32'h16), .CFG_ADDR (GPCFG0_ADDR)) u_cfg_pad03_ctl_reg_inst (
  .hclk    (hclk),          .hresetn (hresetn),
  .wr_en   (valid_wr_lat),  .rd_en (valid_rd),
  .byte_en (wbyte_en_lat),  .wr_addr (haddr_lat),
  .rd_addr (haddr),   .wdata (hwdata),
  .wr_reg  (pad03_ctl_reg), .rdata (rdata[0][31:0]));


gpcfg_rd_wr #( .RESET_VAL (32'h17), .CFG_ADDR (GPCFG1_ADDR)) u_cfg_pad04_ctl_reg_inst (
  .hclk    (hclk),          .hresetn (hresetn),
  .wr_en   (valid_wr_lat),  .rd_en (valid_rd),
  .byte_en (wbyte_en_lat),  .wr_addr (haddr_lat),
  .rd_addr (haddr),   .wdata (hwdata),
  .wr_reg  (pad04_ctl_reg), .rdata (rdata[1][31:0]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_0017), .CFG_ADDR (GPCFG2_ADDR)) u_cfg_pad05_ctl_reg_inst (
  .hclk    (hclk),          .hresetn (hresetn),
  .wr_en   (valid_wr_lat),  .rd_en (valid_rd),
  .byte_en (wbyte_en_lat),  .wr_addr (haddr_lat),
  .rd_addr (haddr),   .wdata (hwdata),
  .wr_reg  (pad05_ctl_reg), .rdata (rdata[2][31:0]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_0017), .CFG_ADDR (GPCFG3_ADDR)) u_cfg_pad06_ctl_reg_inst (
  .hclk    (hclk),          .hresetn (hresetn),
  .wr_en   (valid_wr_lat),  .rd_en (valid_rd),
  .byte_en (wbyte_en_lat),  .wr_addr (haddr_lat),
  .rd_addr (haddr),   .wdata (hwdata),
  .wr_reg  (pad06_ctl_reg), .rdata (rdata[3][31:0]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_001B), .CFG_ADDR (GPCFG4_ADDR)) u_cfg_pad07_ctl_reg_inst (
  .hclk    (hclk),          .hresetn (hresetn),
  .wr_en   (valid_wr_lat),  .rd_en (valid_rd),
  .byte_en (wbyte_en_lat),  .wr_addr (haddr_lat),
  .rd_addr (haddr),   .wdata (hwdata),
  .wr_reg  (pad07_ctl_reg), .rdata (rdata[4][31:0]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_001B), .CFG_ADDR (GPCFG5_ADDR)) u_cfg_pad08_ctl_reg_inst (
  .hclk    (hclk),          .hresetn (hresetn),
  .wr_en   (valid_wr_lat),  .rd_en (valid_rd),
  .byte_en (wbyte_en_lat),  .wr_addr (haddr_lat),
  .rd_addr (haddr),   .wdata (hwdata),
  .wr_reg  (pad08_ctl_reg), .rdata (rdata[5][31:0]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_001B), .CFG_ADDR (GPCFG6_ADDR)) u_cfg_pad09_ctl_reg_inst (
  .hclk    (hclk),          .hresetn (hresetn),
  .wr_en   (valid_wr_lat),  .rd_en (valid_rd),
  .byte_en (wbyte_en_lat),  .wr_addr (haddr_lat),
  .rd_addr (haddr),   .wdata (hwdata),
  .wr_reg  (pad09_ctl_reg), .rdata (rdata[6][31:0]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_001B), .CFG_ADDR (GPCFG7_ADDR)) u_cfg_pad10_ctl_reg_inst (
  .hclk    (hclk),           .hresetn (hresetn),
  .wr_en   (valid_wr_lat),   .rd_en (valid_rd),
  .byte_en (wbyte_en_lat),   .wr_addr (haddr_lat),
  .rd_addr (haddr),   .wdata (hwdata),
  .wr_reg  (pad10_ctl_reg), .rdata (rdata[7][31:0]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_001B), .CFG_ADDR (GPCFG8_ADDR)) u_cfg_pad11_ctl_reg_inst (
  .hclk    (hclk),          .hresetn (hresetn),
  .wr_en   (valid_wr_lat),  .rd_en (valid_rd),
  .byte_en (wbyte_en_lat),  .wr_addr (haddr_lat),
  .rd_addr (haddr),   .wdata (hwdata),
  .wr_reg  (pad11_ctl_reg), .rdata (rdata[8][31:0]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_001B), .CFG_ADDR (GPCFG9_ADDR)) u_cfg_pad12_ctl_reg_inst (
  .hclk    (hclk),          .hresetn (hresetn),
  .wr_en   (valid_wr_lat),  .rd_en (valid_rd),
  .byte_en (wbyte_en_lat),  .wr_addr (haddr_lat),
  .rd_addr (haddr),   .wdata (hwdata),
  .wr_reg  (pad12_ctl_reg), .rdata (rdata[9][31:0]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_001B), .CFG_ADDR (GPCFG10_ADDR)) u_cfg_pad13_ctl_reg_inst (
  .hclk    (hclk),           .hresetn (hresetn),
  .wr_en   (valid_wr_lat),   .rd_en (valid_rd),
  .byte_en (wbyte_en_lat),   .wr_addr (haddr_lat),
  .rd_addr (haddr),    .wdata (hwdata),
  .wr_reg  (pad13_ctl_reg),  .rdata (rdata[10][31:0]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_001B), .CFG_ADDR (GPCFG11_ADDR)) u_cfg_pad14_ctl_reg_inst (
  .hclk    (hclk),          .hresetn (hresetn),
  .wr_en   (valid_wr_lat),  .rd_en (valid_rd),
  .byte_en (wbyte_en_lat),  .wr_addr (haddr_lat),
  .rd_addr (haddr),   .wdata (hwdata),
  .wr_reg  (pad14_ctl_reg), .rdata (rdata[11][31:0]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_001B), .CFG_ADDR (GPCFG12_ADDR)) u_cfg_pad15_ctl_reg_inst (
  .hclk    (hclk),          .hresetn (hresetn),
  .wr_en   (valid_wr_lat),  .rd_en (valid_rd),
  .byte_en (wbyte_en_lat),  .wr_addr (haddr_lat),
  .rd_addr (haddr),   .wdata (hwdata),
  .wr_reg  (pad15_ctl_reg), .rdata (rdata[12][31:0]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_001B), .CFG_ADDR (GPCFG13_ADDR)) u_cfg_pad16_ctl_reg_inst (
  .hclk    (hclk),          .hresetn (hresetn),
  .wr_en   (valid_wr_lat),  .rd_en (valid_rd),
  .byte_en (wbyte_en_lat),  .wr_addr (haddr_lat),
  .rd_addr (haddr),   .wdata (hwdata),
  .wr_reg  (pad16_ctl_reg), .rdata (rdata[13][31:0]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_001B), .CFG_ADDR (GPCFG14_ADDR)) u_cfg_pad17_ctl_reg_inst (
  .hclk    (hclk),          .hresetn (hresetn),
  .wr_en   (valid_wr_lat),  .rd_en (valid_rd),
  .byte_en (wbyte_en_lat),  .wr_addr (haddr_lat),
  .rd_addr (haddr),   .wdata (hwdata),
  .wr_reg  (pad17_ctl_reg), .rdata (rdata[14][31:0]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_001B), .CFG_ADDR (GPCFG15_ADDR)) u_cfg_pad18_ctl_reg_inst (
  .hclk    (hclk),          .hresetn (hresetn),
  .wr_en   (valid_wr_lat),  .rd_en (valid_rd),
  .byte_en (wbyte_en_lat),  .wr_addr (haddr_lat),
  .rd_addr (haddr),   .wdata (hwdata),
  .wr_reg  (pad18_ctl_reg), .rdata (rdata[15][31:0]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_001B), .CFG_ADDR (GPCFG16_ADDR)) u_cfg_pad19_ctl_reg_inst (
  .hclk    (hclk),          .hresetn (hresetn),
  .wr_en   (valid_wr_lat),  .rd_en (valid_rd),
  .byte_en (wbyte_en_lat),  .wr_addr (haddr_lat),
  .rd_addr (haddr),         .wdata (hwdata),
  .wr_reg  (pad19_ctl_reg), .rdata (rdata[16][31:0]));


gpcfg_rd_wr #( .RESET_VAL (32'd2500), .CFG_ADDR (GPCFG17_ADDR)) u_cfg_uartm_baud_ctl_reg_inst (
  .hclk    (hclk),               .hresetn (hresetn),
  .wr_en   (valid_wr_lat),       .rd_en (valid_rd),
  .byte_en (wbyte_en_lat),       .wr_addr (haddr_lat),
  .rd_addr (haddr),              .wdata (hwdata),
  .wr_reg  (uartm_baud_ctl_reg), .rdata (rdata[17][31:0]));


gpcfg_rd_wr #( .RESET_VAL (32'h0), .CFG_ADDR (GPCFG18_ADDR)) u_cfg_uartm_ctl_reg_inst (
  .hclk    (hclk),          .hresetn (hresetn),
  .wr_en   (valid_wr_lat),  .rd_en (valid_rd),
  .byte_en (wbyte_en_lat),  .wr_addr (haddr_lat),
  .rd_addr (haddr),   .wdata (hwdata),
  .wr_reg  (uartm_ctl_reg), .rdata (rdata[18][31:0]));


gpcfg_rd_wr #( .RESET_VAL (32'h9C4), .CFG_ADDR (GPCFG34_ADDR)) u_cfg_uarts_baud_ctl_reg_inst (
  .hclk    (hclk),               .hresetn (hresetn),
  .wr_en   (valid_wr_lat),       .rd_en (valid_rd),
  .byte_en (wbyte_en_lat),       .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg  (uarts_baud_ctl_reg), .rdata (rdata[19][31:0]));


gpcfg_rd_wr #( .RESET_VAL (32'h0), .CFG_ADDR (GPCFG35_ADDR)) u_cfg_uarts_ctl_reg_inst (
  .hclk    (hclk),          .hresetn (hresetn),
  .wr_en   (valid_wr_lat),  .rd_en (valid_rd),
  .byte_en (wbyte_en_lat),  .wr_addr (haddr_lat),
  .rd_addr (haddr),   .wdata (hwdata),
  .wr_reg  (uarts_ctl_reg), .rdata (rdata[20][31:0]));


gpcfg_rd_wr #( .RESET_VAL (32'h0), .CFG_ADDR (GPCFG36_ADDR)) u_cfg_uarts_tx_data_reg_inst (
  .hclk    (hclk),              .hresetn (hresetn),
  .wr_en   (valid_wr_lat),      .rd_en (valid_rd),
  .byte_en (wbyte_en_lat),      .wr_addr (haddr_lat),
  .rd_addr (haddr),       .wdata (hwdata),
  .wr_reg  (uarts_tx_data_reg), .rdata (rdata[21][31:0]));


gpcfg_rd_wr_p #( .RESET_VAL (32'h0), .CFG_ADDR (GPCFG38_ADDR)) u_cfg_uarts_tx_send_reg_inst (
  .hclk    (hclk),              .hresetn (hresetn),
  .wr_en   (valid_wr_lat),      .rd_en (valid_rd),
  .byte_en (wbyte_en_lat),      .wr_addr (haddr_lat),
  .rd_addr (haddr),             .wdata (hwdata),
  .wr_reg  (uarts_tx_send_reg), .rdata (rdata[22][31:0]));


gpcfg_rd_wr #( .RESET_VAL (32'h0), .CFG_ADDR (GPCFG39_ADDR)) u_cfg_spare0_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),  .wdata (hwdata),
  .wr_reg  (spare0_reg),   .rdata (rdata[23][31:0]));


gpcfg_rd_wr #( .RESET_VAL (32'h0), .CFG_ADDR (GPCFG40_ADDR)) u_cfg_spare1_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),  .wdata (hwdata),
  .wr_reg  (spare1_reg),   .rdata (rdata[24][31:0]));


gpcfg_rd_wr #( .RESET_VAL (32'hFFFF_FFFF), .CFG_ADDR (GPCFG41_ADDR)) u_cfg_spare2_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),  .wdata (hwdata),
  .wr_reg  (spare2_reg),   .rdata (rdata[25][31:0]));


gpcfg_rd_wr #( .RESET_VAL (32'h0), .CFG_ADDR (GPCFG42_ADDR)) u_cfg_cleq_ctl2_reg_inst (
  .hclk    (hclk),          .hresetn (hresetn),
  .wr_en   (valid_wr_lat),  .rd_en (valid_rd),
  .byte_en (wbyte_en_lat),  .wr_addr (haddr_lat),
  .rd_addr (haddr),   .wdata (hwdata),
  .wr_reg  (cleq_ctl2_reg), .rdata (rdata[26][31:0]));


gpcfg_rd_wr #( .RESET_VAL (32'h0CC5_0101), .CFG_ADDR (GPCFG51_ADDR)) u_cfg_signature_reg_inst (
  .hclk    (hclk),          .hresetn (hresetn),
  .wr_en   (1'b0),          .rd_en (valid_rd),
  .byte_en (wbyte_en_lat),  .wr_addr (haddr_lat),
  .rd_addr (haddr),         .wdata (hwdata),
  .wr_reg  (signature_reg), .rdata (rdata[27][31:0]));


gpcfg_rd_wr_p #( .RESET_VAL (32'h0), .CFG_ADDR (GPCFG_CLCTLP_ADDR)) u_cfg_cleq_ctl_p_reg_inst (
  .hclk    (hclk),           .hresetn (hresetn),
  .wr_en   (valid_wr_lat),   .rd_en (valid_rd),
  .byte_en (wbyte_en_lat),   .wr_addr (haddr_lat),
  .rd_addr (haddr),          .wdata (hwdata),
  .wr_reg  (cleq_ctl_p_reg), .rdata (rdata[28][31:0]));


gpcfg_rd_wr #( .RESET_VAL (32'hFF06_0800), .CFG_ADDR (GPCFG_CLCTL_ADDR)) u_cfg_cleq_ctl_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en   (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata   (hwdata),
  .wr_reg  (cleq_ctl_reg), .rdata   (rdata[29][31:0]));


gpcfg_rd #(.CFG_ADDR (GPCFG37_ADDR)) u_gpcfg_rd_uarts_rx_data_inst  (
  .rd_en     (valid_rd),
  .rd_addr   (haddr),
  .wdata     (uarts_rx_data),
  .rdata     (rdata[30][31:0])
);

gpcfg_rd #(.CFG_ADDR (GPCFG_CLSTATUS_ADDR)) u_gpcfg_rd_cleq_status_inst  (
  .rd_en     (valid_rd),
  .rd_addr   (haddr),
  .wdata     ({30'b0, cl_inverr, cl_busy} ),
  .rdata     (rdata[31][31:0])
);



genvar i;

generate
  for (i =0; i < NBITS/64; i =i +1) begin : cfg_cleq_n_gen
    gpcfg_rd_wr #( .RESET_VAL (32'd0), .CFG_ADDR (GPCFG_N_ADDR[0][15:0] + 4*i)) u_cfg_cleq_n_reg_inst (
      .hclk    (hclk),                     .hresetn (hresetn),
      .wr_en   (valid_wr_lat),             .rd_en   (valid_rd),
      .byte_en (wbyte_en_lat),             .wr_addr (haddr_lat),
      .rd_addr (haddr),                    .wdata   (hwdata),
      .wr_reg  (cleq_n_reg[31+32*i:32*i]), .rdata   (rdata[32+i][31:0]));
  end
endgenerate

localparam INDX0 = 32 + NBITS/64;

generate
  for (i =0; i < NBITS/64; i =i +1) begin : cfg_cleq_rand_gen
    gpcfg_rd_wr #( .RESET_VAL (32'd0), .CFG_ADDR (GPCFG_R_ADDR[0][15:0] + 4*i)) u_cfg_cleq_rand_reg_inst (
      .hclk    (hclk),                        .hresetn (hresetn),
      .wr_en   (valid_wr_lat),                .rd_en   (valid_rd),
      .byte_en (wbyte_en_lat),                .wr_addr (haddr_lat),
      .rd_addr (haddr),                       .wdata   (hwdata),
      .wr_reg  (cleq_rand_reg[31+32*i:32*i]), .rdata   (rdata[INDX0+i][31:0]));
  end
endgenerate

localparam INDX1 = INDX0 + NBITS/64;

generate
  for (i =0; i < NBITS/32; i =i +1) begin : cfg_cleq_nsq_gen
    gpcfg_rd_wr #( .RESET_VAL (32'd0), .CFG_ADDR (GPCFG_NSQ_ADDR[0][15:0] + 4*i)) u_cfg_cleq_nsq_reg_inst (
      .hclk    (hclk),                       .hresetn (hresetn),
      .wr_en   (valid_wr_lat),               .rd_en   (valid_rd),
      .byte_en (wbyte_en_lat),               .wr_addr (haddr_lat),
      .rd_addr (haddr),                      .wdata   (hwdata),
      .wr_reg  (cleq_nsq_reg[31+32*i:32*i]), .rdata   (rdata[INDX1+i][31:0]));
  end
endgenerate

localparam INDX2 = INDX1 + NBITS/32;

generate
  for (i =0; i < NBITS/32; i =i +1) begin : cfg_cleq_fkf_gen
    gpcfg_rd_wr #( .RESET_VAL (32'd0), .CFG_ADDR (GPCFG_FKF_ADDR[0][15:0] + 4*i)) u_cfg_gpcfg_fkf_reg_inst (
      .hclk    (hclk),                       .hresetn (hresetn),
      .wr_en   (valid_wr_lat),               .rd_en   (valid_rd),
      .byte_en (wbyte_en_lat),               .wr_addr (haddr_lat),
      .rd_addr (haddr),                      .wdata   (hwdata),
      .wr_reg  (cleq_fkf_reg[31+32*i:32*i]), .rdata   (rdata[INDX2+i][31:0]));
  end
endgenerate

localparam INDX3 = INDX2 + NBITS/32;

generate
  for (i =0; i < NBITS/32; i =i +1) begin : cfg_cleq_arga_gen
    gpcfg_rd_wr #( .RESET_VAL (32'd0), .CFG_ADDR (GPCFG_ARGA_ADDR[0][15:0] + 4*i)) u_cfg_cleq_arga_reg_inst (
      .hclk    (hclk),                        .hresetn (hresetn),
      .wr_en   (valid_wr_lat),                .rd_en   (valid_rd),
      .byte_en (wbyte_en_lat),                .wr_addr (haddr_lat),
      .rd_addr (haddr),                       .wdata   (hwdata),
      .wr_reg  (cleq_arga_reg[31+32*i:32*i]), .rdata   (rdata[INDX3+i][31:0]));
  end
endgenerate

localparam INDX4 = INDX3 + NBITS/32;

generate
  for (i =0; i < NBITS/32; i =i +1) begin : cfg_cleq_argb_gen
    gpcfg_rd_wr #( .RESET_VAL (32'd0), .CFG_ADDR (GPCFG_ARGB_ADDR[0][15:0] + 4*i)) u_cfg_cleq_argb_reg_inst (
      .hclk    (hclk),                        .hresetn (hresetn),
      .wr_en   (valid_wr_lat),                .rd_en   (valid_rd),
      .byte_en (wbyte_en_lat),                .wr_addr (haddr_lat),
      .rd_addr (haddr),                       .wdata   (hwdata),
      .wr_reg  (cleq_argb_reg[31+32*i:32*i]), .rdata   (rdata[INDX4+i][31:0]));
  end
endgenerate

localparam INDX5 = INDX4 + NBITS/32;

generate
  for (i =0; i < NBITS/64; i =i +1) begin : cfg_cleq_argc_gen
    gpcfg_rd_wr #( .RESET_VAL (32'd0), .CFG_ADDR (GPCFG_ARGC_ADDR[0][15:0] + 4*i)) u_cfg_cleq_argc_reg_inst (
      .hclk    (hclk),                        .hresetn (hresetn),
      .wr_en   (valid_wr_lat),                .rd_en   (valid_rd),
      .byte_en (wbyte_en_lat),                .wr_addr (haddr_lat),
      .rd_addr (haddr),                       .wdata   (hwdata),
      .wr_reg  (cleq_argc_reg[31+32*i:32*i]), .rdata   (rdata[INDX5+i][31:0]));
  end
endgenerate

localparam INDX6 = INDX5 + NBITS/64;

generate
  for (i =0; i < NBITS/64; i =i +1) begin : cfg_cleq_rand0_gen
    gpcfg_rd_wr #( .RESET_VAL (32'd0), .CFG_ADDR (GPCFG_RAND0_ADDR[0][15:0] + 4*i)) u_cfg_gpcfg_rand0_reg_inst (
      .hclk    (hclk),                         .hresetn (hresetn),
      .wr_en   (valid_wr_lat),                 .rd_en   (valid_rd),
      .byte_en (wbyte_en_lat),                 .wr_addr (haddr_lat),
      .rd_addr (haddr),                        .wdata   (hwdata),
      .wr_reg  (cleq_rand0_reg[31+32*i:32*i]), .rdata   (rdata[INDX6+i][31:0]));
  end
endgenerate

localparam INDX7 = INDX6 + NBITS/64;

generate
  for (i =0; i < NBITS/64; i =i +1) begin : cfg_cleq_rand1_gen
    gpcfg_rd_wr #( .RESET_VAL (32'd0), .CFG_ADDR (GPCFG_RAND1_ADDR[0][15:0] + 4*i)) u_cfg_gpcfg_rand1_reg_inst (
      .hclk    (hclk),                         .hresetn (hresetn),
      .wr_en   (valid_wr_lat),                 .rd_en   (valid_rd),
      .byte_en (wbyte_en_lat),                 .wr_addr (haddr_lat),
      .rd_addr (haddr),                        .wdata   (hwdata),
      .wr_reg  (cleq_rand1_reg[31+32*i:32*i]), .rdata   (rdata[INDX7+i][31:0]));
  end
endgenerate

localparam INDX8 = INDX7 + NBITS/64;

//gpcfg_rd_wr #( .RESET_VAL (), .CFG_ADDR ()) u_cfg__inst (
//  .hclk    (hclk),         .hresetn (hresetn),
//  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
//  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
//  .rd_addr (haddr),        .wdata (hwdata),
//  .wr_reg (),              .rdata ());

generate
  for (i =0; i < NBITS/32; i =i +1) begin : cfg_mod_mul_gen
    gpcfg_rd #(.CFG_ADDR (GPCFG_MUL_ADDR[0][15:0] + 4*i)) u_gpcfg_rd_cfg_mod_mul_inst  (
      .rd_en     (valid_rd),
      .rd_addr   (haddr),
      .wdata     (mod_mul_il_y[31+32*i:32*i]),
      .rdata     (rdata[INDX8+i][31:0])
    );
  end
endgenerate

localparam INDX9 = INDX8 + NBITS/32;

generate
  for (i =0; i < NBITS/32; i =i +1) begin : cfg_mod_exp_gen
    gpcfg_rd #(.CFG_ADDR (GPCFG_EXP_ADDR[0][15:0] + 4*i)) u_gpcfg_rd_cfg_mod_exp_inst  (
      .rd_en     (valid_rd),
      .rd_addr   (haddr),
      .wdata     (mod_exp_y[31+32*i:32*i]),
      .rdata     (rdata[INDX9+i][31:0])
    );
  end
endgenerate

localparam INDX10 = INDX9 + NBITS/32;

generate
  for (i =0; i < NBITS/32; i =i +1) begin : cfg_mod_inv_gen
    gpcfg_rd #(.CFG_ADDR (GPCFG_INV_ADDR[0][15:0] + 4*i)) u_gpcfg_rd_cfg_mod_inv_inst  (
      .rd_en     (valid_rd),
      .rd_addr   (haddr),
      .wdata     (mod_inv[31+32*i:32*i]),
      .rdata     (rdata[INDX10+i][31:0])
    );
  end
endgenerate

localparam INDX11 = INDX10 + NBITS/32;

generate
  for (i =0; i < NBITS/32; i =i +1) begin : cfg_gfunc_res_gen
    gpcfg_rd #(.CFG_ADDR (GPCFG_RES_ADDR[0][15:0] + 4*i)) u_gpcfg_rd_cfg_gfunc_res_inst  (
      .rd_en     (valid_rd),
      .rd_addr   (haddr),
      .wdata     (gfunc_res[31+32*i:32*i]),
      .rdata     (rdata[INDX11+i][31:0])
    );
  end
endgenerate

localparam INDX12 = INDX11 + NBITS/32;

generate
  for (i =0; i < NBITS/32; i =i +1) begin : cfg_dbg_data_gen
    gpcfg_rd #(.CFG_ADDR (GPCFG_DBG_ADDR[0][15:0] + 4*i)) u_gpcfg_rd_cfg_dbg_data_inst  (
      .rd_en     (valid_rd),
      .rd_addr   (haddr),
      .wdata     (dbg_data[31+32*i:32*i]),
      .rdata     (rdata[INDX12+i][31:0])
    );
  end
endgenerate

localparam INDX13 = INDX12 + NBITS/32;

localparam NUM_RDATA = INDX13-1;

integer j;
always@* begin
  read_data  = 32'b0;
  for (j=0; j<NUM_RDATA; j=j+1) begin
    read_data  = rdata[j][31:0] | read_data;
  end
end


  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      hrdata  <= 32'b0;
    end
    else if (valid_rd == 1'b1) begin
      hrdata  <= read_data;
    end
    else begin
      hrdata  <= 32'b0;
    end
  end


//----------------------------
// Logic for write byte enable
// hsize
// 0000 - byte
// 0001 - hword
// 0010 - word
//----------------------------
   always @* begin
     if (valid_wr == 1'b1) begin
       if (haddr[1:0] == 2'b00) begin
         case (hsize)
           3'b000 : wbyte_en = 4'b0001;
           3'b001 : wbyte_en = 4'b0011;
           3'b010 : wbyte_en = 4'b1111;
           default: wbyte_en = 4'b0000;
         endcase
       end
       else if((haddr[1:0] == 2'b01)) begin
         case (hsize)
           3'b000 : wbyte_en = 4'b0010;
           default: wbyte_en = 4'b0000;
         endcase
       end
       else if((haddr[1:0] == 2'b10)) begin
         case (hsize)
           3'b000 : wbyte_en = 4'b0100;
           3'b001 : wbyte_en = 4'b1100;
           default: wbyte_en = 4'b0000;
         endcase
       end
       else begin
         case (hsize)
           3'b000 : wbyte_en = 4'b1000;
           default: wbyte_en = 4'b0000;
         endcase
       end
     end
     else begin
       wbyte_en = 4'b0000;
     end
   end

//------------------------------------
// Logic to generate hresp and hready
//------------------------------------
  assign dec_err = 1'b0; 
  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      hready <= 1'b1;
      hresp  <= 1'b0;
    end
    else if (dec_err == 1'b1) begin
      hready <= 1'b0;
      hresp  <= 1'b1;
    end
    else begin
      hready <= 1'b1;
      hresp  <= ~hready;
    end
  end
 

//-------------------------------------------------------------------------- 
//arg_a, arg_b and modulus are inputs to multipliers, gcd calc and exponentiation modules, 
//need to select them as per the current execution scenario
//-------------------------------------------------------------------------- 
  assign arg_a          = ((gfunc_nxt_state == GFUNC_RAND0EXP) ||
                           (gfunc_nxt_state == GFUNC_BBS0))  ? {{NBITS/2{1'b0}}, cleq_rand0} : (
                          ((gfunc_nxt_state == GFUNC_RAND1EXP) ||
                           (gfunc_nxt_state == GFUNC_BBS1))  ? {{NBITS/2{1'b0}}, cleq_rand1} : (
                           (gfunc_nxt_state == GFUNC_MODMUL) ? gfunc_r0n :
                            cleq_arga_reg));

  assign arg_b          =  enable_p_mod_exp                      ? r_red_extgcd                  : (
                           ((gfunc_nxt_state == GFUNC_RAND0EXP)  ||
                            (gfunc_nxt_state == GFUNC_RAND1EXP)) ? {{NBITS/2{1'b0}}, cleq_n}     : (
                            (gfunc_nxt_state == GFUNC_ARGXEXP)   ? cleq_fkf                      : (
                            gfunc_mul_sel                        ? gfunc_r1n                     : (
                           ((gfunc_nxt_state == GFUNC_BBS1))     ? {{NBITS/2{1'b0}}, cleq_rand1} : (
                            (gfunc_nxt_state == GFUNC_BBS0)      ? {{NBITS/2{1'b0}}, cleq_rand0} :
                             cleq_argb_reg)))));
  
  assign maxbits        = cleq_ctl_reg[11:0];
  assign cleq_n         = cleq_ctl_reg[12] ? {NBITS/2{1'b0}} : cleq_n_reg;    //fused value of programmed
  assign cleq_nsq       = cleq_ctl_reg[12] ? {NBITS{1'b0}} : cleq_nsq_reg;  //fused value of programmed
  assign cleq_fkf       = cleq_ctl_reg[12] ? {NBITS{1'b0}} : cleq_fkf_reg;  //fused value of programmed
  assign modulus        = ((gfunc_nxt_state == GFUNC_BBS0) || 
                           (gfunc_nxt_state == GFUNC_BBS1)) ? {{NBITS/2{1'b0}}, cleq_n} : (
                           cleq_ctl_reg[13] ? cleq_nsq : {{NBITS/2{1'b0}}, cleq_n});      //1024 bit or 2048 bit modulus?
  assign bypass_vn       = cleq_ctl_reg[14];
  assign cleq_rand0_init = cleq_ctl_reg[15] ? cleq_rand0_hw : cleq_rand0_reg;
  assign cleq_rand1_init = cleq_ctl_reg[15] ? cleq_rand1_hw : cleq_rand1_reg;
  assign arg_b_mod_inv  = (gfunc_curr_state == GFUNC_IDLE) && (cleq_ctl_reg[16] == 1'b1) ? modulus : arg_b;
  assign dbg_data_sel    = cleq_ctl_reg[19:17];
  assign byp_rng_bbs     = cleq_ctl_reg[20];
  assign rng_errcnt_max  = cleq_ctl_reg[31:24];

  assign r_egcd         = 1'b1 << maxbits;
  assign r_red_extgcd   = r_egcd - modulus;

  assign cleq_log2ofn   = cleq_ctl2_reg[11:0];

  assign enable_p_mod_mul_il       = cleq_ctl_p_reg[0] | enable_p_mod_exp  || 
                                     ((gfunc_curr_state == GFUNC_MODMUL)  && 
                                      (gfunc_prev_state != GFUNC_MODMUL)) ||
                                     ((gfunc_curr_state == GFUNC_BBS0)  && 
                                      (gfunc_prev_state != GFUNC_BBS0)) || 
                                     ((gfunc_curr_state == GFUNC_BBS1)  && 
                                      (gfunc_prev_state != GFUNC_BBS1));

  assign enable_p_mod_exp          = cleq_ctl_p_reg[1] ||
                                     ((gfunc_curr_state == GFUNC_RAND0EXP)  && 
                                      (gfunc_prev_state != GFUNC_RAND0EXP)) || 
                                     ((gfunc_curr_state == GFUNC_RAND1EXP)  && 
                                      (gfunc_prev_state != GFUNC_RAND1EXP)) ||
                                     ((gfunc_curr_state == GFUNC_ARGXEXP)  && 
                                      (gfunc_prev_state != GFUNC_ARGXEXP));

  assign enable_p_bin_ext_gcd      = cleq_ctl_p_reg[2];
  assign enable_p_gfunc            = cleq_ctl_p_reg[3];
  assign enable_p_rng0             = cleq_ctl_p_reg[4];
  assign host_irq_clr              = cleq_ctl_p_reg[8];
  assign update_rng                = cleq_ctl_p_reg[9];
  assign run_rng_bbs               = cleq_ctl_p_reg[10];



  assign busy_flag_rel = done_irq_p_mod_mul_il  | done_irq_p_mod_exp |
                         done_irq_p_bin_ext_gcd | done_irq_p_gfunc   |
                         done_irq_p_rng1;

  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      cl_busy       <= 1'b0;
      busy_flag_set <= 5'b0;
    end
    else if (|cleq_ctl_p_reg[4:0]) begin
      cl_busy       <= 1'b1;
      busy_flag_set <= cleq_ctl_p_reg[4:0];
    end
    else if (busy_flag_set[3] == 1'b1) begin
      if (done_irq_p_gfunc) begin
        cl_busy          <= 1'b0;
	    busy_flag_set[3] <= 1'b0;
      end
    end
    else if (busy_flag_set[1] == 1'b1) begin
      if (done_irq_p_mod_exp) begin
        cl_busy          <= 1'b0;
	    busy_flag_set[1] <= 1'b0;
      end
    end     
    else if (busy_flag_rel == 1'b1) begin
      busy_flag_set <= 5'b0;
      cl_busy       <= 1'b0;
    end
  end

  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      cl_busy_d   <= 1'b0;
    end
    else begin
      cl_busy_d  <= cl_busy;
    end
  end

  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      cleq_host_irq   <= 1'b0;
    end
    else if ((cl_busy_d == 1'b1) && (cl_busy == 1'b0)) begin
      cleq_host_irq   <= 1'b1;
    end
    else if (host_irq_clr == 1'b1) begin
      cleq_host_irq   <= 1'b0;
    end
  end


  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      cl_inverr   <= 1'b0;
    end
    else if (done_irq_p_bin_ext_gcd) begin
      if (gcd == {{(NBITS-1){1'b0}}, 1'b1}) begin
        cl_inverr   <= 1'b0;
      end
      else begin
        cl_inverr   <= 1'b1;
      end
    end
  end

  reg done_irq_p_bin_ext_gcd_d;
  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      done_irq_p_bin_ext_gcd_d   <= 1'b0;
    end
    else begin
      done_irq_p_bin_ext_gcd_d   <= done_irq_p_bin_ext_gcd;
    end
  end
  


  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      mod_inv   <= {(NBITS+3){1'b0}};
    end
    else begin
      if (done_irq_p_bin_ext_gcd | done_irq_p_bin_ext_gcd_d) begin
        mod_inv   <= x;   
      end
      else if (mod_inv[NBITS+2] == 1'b1) begin  //If negative
        mod_inv   <= mod_inv + arg_b_mod_inv;   
      end
      else if (mod_inv > arg_b_mod_inv) begin
          mod_inv   <= mod_inv - arg_b_mod_inv;
      end
    end
  end


  //always @ (posedge hclk or negedge hresetn) begin
  //  if (hresetn == 1'b0) begin
  //    mod_inv   <= {(NBITS+3){1'b0}};
  //  end
  //  else begin
  //    if (done_irq_p_bin_ext_gcd | done_irq_p_bin_ext_gcd_d) begin
  //      mod_inv   <= x;   
  //    end
  //  end
  //end


  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      gfunc_curr_state   <= 3'b0;
      gfunc_prev_state   <= 3'b0;
    end
    else begin
      gfunc_curr_state   <= gfunc_nxt_state;
      gfunc_prev_state   <= gfunc_curr_state;
    end
  end
 

always @* begin
    case (gfunc_curr_state)
      GFUNC_IDLE :  begin
        if (run_rng_bbs) begin
          gfunc_nxt_state = GFUNC_BBS0;
        end
        else if (enable_p_gfunc) begin
          gfunc_nxt_state = GFUNC_RAND0EXP;
        end
        else begin
          gfunc_nxt_state = GFUNC_IDLE;
        end
      end
      GFUNC_RAND0EXP :  begin
        if (done_irq_p_mod_exp) begin
          gfunc_nxt_state = GFUNC_RAND1EXP;
        end
        else begin
          gfunc_nxt_state = GFUNC_RAND0EXP;
        end
      end
      GFUNC_RAND1EXP :  begin
        if (done_irq_p_mod_exp) begin
          gfunc_nxt_state = GFUNC_ARGXEXP;
        end
        else begin
          gfunc_nxt_state = GFUNC_RAND1EXP;
        end
      end
      GFUNC_ARGXEXP :  begin
        if (done_irq_p_mod_exp) begin
          gfunc_nxt_state = GFUNC_LEQ;
        end
        else begin
          gfunc_nxt_state = GFUNC_ARGXEXP;
        end
      end
      GFUNC_LEQ :  begin
          gfunc_nxt_state = GFUNC_MODMUL;
      end
      GFUNC_MODMUL :  begin
        if (done_irq_p_mod_mul_il) begin
          if (byp_rng_bbs == 1'b1) begin
            gfunc_nxt_state = GFUNC_IDLE;
          end
          else begin
            gfunc_nxt_state = GFUNC_BBS0;
          end
        end
        else begin
          gfunc_nxt_state = GFUNC_MODMUL;
        end
      end
      GFUNC_BBS0 :  begin
        if (done_irq_p_mod_mul_il) begin
          gfunc_nxt_state = GFUNC_BBS1;
        end
        else begin
          gfunc_nxt_state = GFUNC_BBS0;
        end
      end
      GFUNC_BBS1 :  begin
        if (done_irq_p_mod_mul_il) begin
          gfunc_nxt_state = GFUNC_IDLE;
        end
        else begin
          gfunc_nxt_state = GFUNC_BBS1;
        end
      end
      default : begin
        gfunc_nxt_state = GFUNC_IDLE;
      end
    endcase
  end
 

always @ (posedge hclk or negedge hresetn) begin
  if (hresetn == 1'b0) begin
    cleq_rand0 <= {NBITS/2{1'b0}};
  end
  else if ((gfunc_curr_state == GFUNC_BBS0) && (done_irq_p_mod_mul_il == 1'b1)) begin
    cleq_rand0 <= mod_mul_il_y[NBITS/2-1 :0];
  end
  else if (update_rng == 1'b1) begin
    cleq_rand0 <= cleq_rand0_init;
  end
end

always @ (posedge hclk or negedge hresetn) begin
  if (hresetn == 1'b0) begin
    cleq_rand1 <= {NBITS/2{1'b0}};
  end
  else if ((gfunc_curr_state == GFUNC_BBS1) && (done_irq_p_mod_mul_il == 1'b1)) begin
    cleq_rand1 <= mod_mul_il_y[NBITS/2-1 :0];
  end
  else if (update_rng == 1'b1) begin
    cleq_rand1 <= cleq_rand1_init;
  end
end

always @ (posedge hclk or negedge hresetn) begin
  if (hresetn == 1'b0) begin
    gfunc_r0n   <= {NBITS{1'b0}};
  end
  else if ((gfunc_curr_state == GFUNC_RAND0EXP) && (gfunc_nxt_state != GFUNC_RAND0EXP)) begin
    gfunc_r0n   <= mod_exp_y;
  end
end
  
always @ (posedge hclk or negedge hresetn) begin
  if (hresetn == 1'b0) begin
    gfunc_r1n   <= {NBITS{1'b0}};
  end
  else if ((gfunc_curr_state == GFUNC_RAND1EXP) && (gfunc_nxt_state != GFUNC_RAND1EXP)) begin
    gfunc_r1n   <= mod_exp_y;
  end
end
  
 
//always @ (posedge hclk or negedge hresetn) begin
//  if (hresetn == 1'b0) begin
//    gfunc_x   <= 2048'b0;
//  end
//  else if (gfunc_nxt_state == GFUNC_LEQ) begin
//    gfunc_x   <= mod_exp_y;
//  end
//end
 
always @ (posedge hclk or negedge hresetn) begin
  if (hresetn == 1'b0) begin
    gfunc_res        <= {NBITS{1'b0}};
    done_irq_p_gfunc <= 1'b0;
  end
  else if ((gfunc_curr_state == GFUNC_MODMUL) && (gfunc_nxt_state == GFUNC_BBS0)) begin
    gfunc_res        <= mod_mul_il_y;
    done_irq_p_gfunc <= 1'b1;
  end
  else begin
    done_irq_p_gfunc <= 1'b0;
    gfunc_res        <= gfunc_res;
  end
end
  

assign cleq_leqlo = cleq_n + 1'b1;
assign cleq_leqhi = cleq_n <<  cleq_log2ofn;


always @ (posedge hclk or negedge hresetn) begin
  if (hresetn == 1'b0) begin
    gfunc_mul_sel   <= 1'b0;
  end
  else if (gfunc_curr_state == GFUNC_LEQ) begin
    if ((mod_exp_y < cleq_leqlo) || (mod_exp_y > cleq_leqhi)) begin
      gfunc_mul_sel <= 1'b1;
    end
  end
  else if ((gfunc_curr_state == GFUNC_MODMUL) && (gfunc_nxt_state == GFUNC_BBS0)) begin
    gfunc_mul_sel <= 1'b0;
  end
end
 


hw_rng_fsm #(
 .NBITS  (NBITS/2)) u_hw_rng_fsm_inst (  
 .hclk                   (hclk),
 .hresetn                (hresetn),
 .done_irq_p_rng0        (done_irq_p_rng0),
 .done_irq_p_rng1        (done_irq_p_rng1),
 .done_irq_p_bin_ext_gcd (done_irq_p_bin_ext_gcd),
 .cl_inverr              (cl_inverr),
 .rng_errcnt_max         (rng_errcnt_max),
 .rng0_y                 (rng0_y),
 .rng1_y                 (rng1_y),
 .enable_p_rng1          (enable_p_rng1),
 .cleq_rand0_hw          (cleq_rand0_hw),
 .cleq_rand1_hw          (cleq_rand1_hw)
);

   
mod_exp #(
  .NBITS (NBITS)) u_mod_exp_inst (
  .clk        (hclk),
  .rst_n      (hresetn),
  .enable_p   (enable_p_mod_exp),
  .a          (arg_a),
  .a_conv     (mod_mul_il_y),
  .done_irq_p_a (done_irq_p_mod_mul_il),				 
  .pwr        (arg_b),
  .m          (modulus),
  .m_size     (maxbits),
  .r_red      (r_red_extgcd),
  .y          (mod_exp_y),
  .done_irq_p (done_irq_p_mod_exp)
);


always @* begin
  case (dbg_data_sel)
    3'b000  : dbg_data =  gcd;
    3'b001  : dbg_data = {cleq_rand1_hw, cleq_rand0_hw}; 
    3'b010  : dbg_data = {cleq_rand1, cleq_rand0}; 
    3'b011  : dbg_data = {rng1_y, rng0_y}; 
    3'b100  : dbg_data =  gfunc_r0n;
    3'b101  : dbg_data =  gfunc_r1n;
    3'b110  : dbg_data = {cleq_leqhi, cleq_leqlo};
    3'b111  : dbg_data = {gfunc_mul_sel, gfunc_nxt_state, gfunc_prev_state, gfunc_curr_state}; 
    default : dbg_data =  gcd;
  endcase

end

endmodule
