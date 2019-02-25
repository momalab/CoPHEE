module gpcfg (  
  // CLOCK AND RESETS ------------------
  input  wire         hclk,              // Clock
  input  wire         hresetn,           // Asynchronous reset
  // AHB-LITE MASTER PORT --------------
  input   wire        hsel,              // AHB transfer: non-sequential only
  input   wire [31:0] haddr,             // AHB transaction address
  input   wire [ 2:0] hsize,             // AHB size: byte, half-word or word
  input   wire [31:0] hwdata,            // AHB write-data
  input   wire        hwrite,            // AHB write control
  output  reg  [31:0] hrdata,            // AHB read-data
  output  reg         hready,            // AHB stall signal
  output  reg         hresp,             // AHB error response
  output  reg  [31:0] pad03_ctl_reg,
  output  reg  [31:0] pad04_ctl_reg,
  output  reg  [31:0] pad05_ctl_reg,
  output  reg  [31:0] pad06_ctl_reg,
  output  reg  [31:0] pad07_ctl_reg,
  output  reg  [31:0] pad08_ctl_reg,
  output  reg  [31:0] pad09_ctl_reg,
  output  reg  [31:0] pad10_ctl_reg,
  output  reg  [31:0] pad11_ctl_reg,
  output  reg  [31:0] pad12_ctl_reg,
  output  reg  [31:0] pad13_ctl_reg,
  output  reg  [31:0] pad14_ctl_reg,
  output  reg  [31:0] pad15_ctl_reg,
  output  reg  [31:0] pad16_ctl_reg,
  output  reg  [31:0] pad17_ctl_reg,
  output  reg  [31:0] pad18_ctl_reg,
  output  reg  [31:0] pad19_ctl_reg,
  output  reg  [31:0] uartm_baud_ctl_reg,
  output  reg  [31:0] uartm_ctl_reg,
  output  reg  [31:0] uarts_baud_ctl_reg,
  output  reg  [31:0] uarts_ctl_reg,
  output  reg  [31:0] uarts_tx_data_reg,
  input   wire [31:0] uarts_rx_data,
  output  reg  [31:0] uarts_tx_send_reg,
  output  reg  [31:0] spare0_reg,
  output  reg  [31:0] spare1_reg,
  output  reg  [31:0] spare2_reg,
  output  reg  [31:0] spare3_reg,
  output  reg  [31:0] signature_reg,
  output  wire [2047:0] arg_a,
  output  wire [2047:0] arg_b,
  output  wire [2047:0] exp,
  output  wire [2047:0] modulus,
  output  wire [10:0]   maxbits,
  output  wire [2047:0] r_red_extgcd,
  output  wire          bypass_vn,
  output  wire          enable_p_mod_mul_il,
  output  wire          enable_p_mod_exp,
  output  wire          enable_p_bin_ext_gcd,
  output  wire          enable_p_rng,
  input   wire [2048:0] x,
  input   wire [2047:0] gcd,
  input   wire [2047:0] mod_mul_il_y,
  input   wire [2047:0] mod_exp_y,
  input   wire [2047:0] rng_y,
  input   wire          done_irq_p_mod_mul_il,
  input   wire          done_irq_p_mod_exp,
  input   wire          done_irq_p_bin_ext_gcd

);

//----------------------------------------------
//localparameter, genva and wire/reg declaration
//----------------------------------------------
  localparam GPCFG0_ADDR   = 16'h0000;  //PAD03_CTL  UARTM_TX  0_0001_0000
  localparam GPCFG1_ADDR   = 16'h0001;  //PAD04_CTL  UARTM_RX  0_0000_0111
  localparam GPCFG2_ADDR   = 16'h0002;  //PAD05_CTL  UARTS_TX  0_0001_0000
  localparam GPCFG3_ADDR   = 16'h0003;  //PAD06_CTL  UARTS_RX  0_0000_0111
  localparam GPCFG4_ADDR   = 16'h0004;  //PAD07_CTL  GPIO0     0_0000_0001
  localparam GPCFG5_ADDR   = 16'h0005;  //PAD08_CTL  GPIO1     0_0000_0001
  localparam GPCFG6_ADDR   = 16'h0006;  //PAD09_CTL  GPIO2     0_0000_0001
  localparam GPCFG7_ADDR   = 16'h0007;  //PAD10_CTL  GPIO3     0_0000_0001
  localparam GPCFG8_ADDR   = 16'h0008;  //PAD11_CTL
  localparam GPCFG9_ADDR   = 16'h0009;  //PAD12_CTL
  localparam GPCFG10_ADDR  = 16'h000A;  //PAD13_CTL
  localparam GPCFG11_ADDR  = 16'h000B;  //PAD14_CTL
  localparam GPCFG12_ADDR  = 16'h000C;  //PAD15_CTL
  localparam GPCFG13_ADDR  = 16'h000D;  //PAD16_CTL
  localparam GPCFG14_ADDR  = 16'h000E;  //PAD17_CTL
  localparam GPCFG15_ADDR  = 16'h000F;  //PAD18_CTL
  localparam GPCFG16_ADDR  = 16'h0010;  //PAD19_CTL

  localparam GPCFG17_ADDR = 16'h0011;  //UARTM_BAUD Reset value for master clock of 25 Mhz and baud rate of 9600
  localparam GPCFG18_ADDR = 16'h0012;  //UARTM_CTL
  localparam GPCFG34_ADDR = 16'h0022;  //UARTS_BAUD Reset value for master clock of 25 Mhz and baud rate of 9600
  localparam GPCFG35_ADDR = 16'h0023;  //UARTS_CTL
  localparam GPCFG36_ADDR = 16'h0024;  //UARTS_TXDATA
  localparam GPCFG37_ADDR = 16'h0025;  //UARTS_RXDATA
  localparam GPCFG38_ADDR = 16'h0026;  //UARTS_TX_SEND
  localparam GPCFG39_ADDR = 16'h0027;  //SPARE0
  localparam GPCFG40_ADDR = 16'h0028;  //SPARE1
  localparam GPCFG41_ADDR = 16'h0029;  //SPARE2
  localparam GPCFG42_ADDR = 16'h002A;  //SPARE3
  localparam GPCFG51_ADDR = 16'h0033;  //SIGNATURE

  localparam GPCFG_CLCTL_ADDR    = 16'h8000;
  localparam GPCFG_CLMAXBITS_ADDR  = 16'h8004;
  localparam GPCFG_CLSTATUS_ADDR = 16'h8008;

  parameter [15:0] GPCFG_N_ADDR = '{16'h9000,
                                    16'h9004,
                                    16'h9008,
                                    16'h900C,
                                    16'h9010,
                                    16'h9014,
                                    16'h9018,
                                    16'h901C,
                                    16'h9020,
                                    16'h9024,
                                    16'h9028,
                                    16'h902C,
                                    16'h9030,
                                    16'h9034,
                                    16'h9038,
                                    16'h903C,
                                    16'h9040,
                                    16'h9044,
                                    16'h9048,
                                    16'h904C,
                                    16'h9050,
                                    16'h9054,
                                    16'h9058,
                                    16'h905C,
                                    16'h9060,
                                    16'h9064,
                                    16'h9068,
                                    16'h906C,
                                    16'h9070,
                                    16'h9074,
                                    16'h9078,
                                    16'h907C};

  localparam GPCFG_R_ADDR0  = 16'h9080;
  localparam GPCFG_R_ADDR1  = 16'h9084;
  localparam GPCFG_R_ADDR2  = 16'h9088;
  localparam GPCFG_R_ADDR3  = 16'h908C;
  localparam GPCFG_R_ADDR4  = 16'h9090;
  localparam GPCFG_R_ADDR5  = 16'h9094;
  localparam GPCFG_R_ADDR6  = 16'h9098;
  localparam GPCFG_R_ADDR7  = 16'h909C;
  localparam GPCFG_R_ADDR8  = 16'h90A0;
  localparam GPCFG_R_ADDR9  = 16'h90A4;
  localparam GPCFG_R_ADDR10 = 16'h90A8;
  localparam GPCFG_R_ADDR11 = 16'h90AC;
  localparam GPCFG_R_ADDR12 = 16'h90B0;
  localparam GPCFG_R_ADDR13 = 16'h90B4;
  localparam GPCFG_R_ADDR14 = 16'h90B8;
  localparam GPCFG_R_ADDR15 = 16'h90BC;
  localparam GPCFG_R_ADDR16 = 16'h90C0;
  localparam GPCFG_R_ADDR17 = 16'h90C4;
  localparam GPCFG_R_ADDR18 = 16'h90C8;
  localparam GPCFG_R_ADDR19 = 16'h90CC;
  localparam GPCFG_R_ADDR20 = 16'h90D0;
  localparam GPCFG_R_ADDR21 = 16'h90D4;
  localparam GPCFG_R_ADDR22 = 16'h90D8;
  localparam GPCFG_R_ADDR23 = 16'h90DC;
  localparam GPCFG_R_ADDR24 = 16'h90E0;
  localparam GPCFG_R_ADDR25 = 16'h90E4;
  localparam GPCFG_R_ADDR26 = 16'h90E8;
  localparam GPCFG_R_ADDR27 = 16'h90EC;
  localparam GPCFG_R_ADDR28 = 16'h90F0;
  localparam GPCFG_R_ADDR29 = 16'h90F4;
  localparam GPCFG_R_ADDR30 = 16'h90F8;
  localparam GPCFG_R_ADDR31 = 16'h90FC;

  localparam GPCFG_NSQ_ADDR0  = 16'h9100;
  localparam GPCFG_NSQ_ADDR1  = 16'h9104;
  localparam GPCFG_NSQ_ADDR2  = 16'h9108;
  localparam GPCFG_NSQ_ADDR3  = 16'h910C;
  localparam GPCFG_NSQ_ADDR4  = 16'h9110;
  localparam GPCFG_NSQ_ADDR5  = 16'h9114;
  localparam GPCFG_NSQ_ADDR6  = 16'h9118;
  localparam GPCFG_NSQ_ADDR7  = 16'h911C;
  localparam GPCFG_NSQ_ADDR8  = 16'h9120;
  localparam GPCFG_NSQ_ADDR9  = 16'h9124;
  localparam GPCFG_NSQ_ADDR10 = 16'h9128;
  localparam GPCFG_NSQ_ADDR11 = 16'h912C;
  localparam GPCFG_NSQ_ADDR12 = 16'h9130;
  localparam GPCFG_NSQ_ADDR13 = 16'h9134;
  localparam GPCFG_NSQ_ADDR14 = 16'h9138;
  localparam GPCFG_NSQ_ADDR15 = 16'h913C;
  localparam GPCFG_NSQ_ADDR16 = 16'h9140;
  localparam GPCFG_NSQ_ADDR17 = 16'h9144;
  localparam GPCFG_NSQ_ADDR18 = 16'h9148;
  localparam GPCFG_NSQ_ADDR19 = 16'h914C;
  localparam GPCFG_NSQ_ADDR20 = 16'h9150;
  localparam GPCFG_NSQ_ADDR21 = 16'h9154;
  localparam GPCFG_NSQ_ADDR22 = 16'h9158;
  localparam GPCFG_NSQ_ADDR23 = 16'h915C;
  localparam GPCFG_NSQ_ADDR24 = 16'h9160;
  localparam GPCFG_NSQ_ADDR25 = 16'h9164;
  localparam GPCFG_NSQ_ADDR26 = 16'h9168;
  localparam GPCFG_NSQ_ADDR27 = 16'h916C;
  localparam GPCFG_NSQ_ADDR28 = 16'h9170;
  localparam GPCFG_NSQ_ADDR29 = 16'h9174;
  localparam GPCFG_NSQ_ADDR30 = 16'h9178;
  localparam GPCFG_NSQ_ADDR31 = 16'h917C;
  localparam GPCFG_NSQ_ADDR32 = 16'h9180;
  localparam GPCFG_NSQ_ADDR33 = 16'h9184;
  localparam GPCFG_NSQ_ADDR34 = 16'h9188;
  localparam GPCFG_NSQ_ADDR35 = 16'h918C;
  localparam GPCFG_NSQ_ADDR36 = 16'h9190;
  localparam GPCFG_NSQ_ADDR37 = 16'h9194;
  localparam GPCFG_NSQ_ADDR38 = 16'h9198;
  localparam GPCFG_NSQ_ADDR39 = 16'h919C;
  localparam GPCFG_NSQ_ADDR40 = 16'h91A0;
  localparam GPCFG_NSQ_ADDR41 = 16'h91A4;
  localparam GPCFG_NSQ_ADDR42 = 16'h91A8;
  localparam GPCFG_NSQ_ADDR43 = 16'h91AC;
  localparam GPCFG_NSQ_ADDR44 = 16'h91B0;
  localparam GPCFG_NSQ_ADDR45 = 16'h91B4;
  localparam GPCFG_NSQ_ADDR46 = 16'h91B8;
  localparam GPCFG_NSQ_ADDR47 = 16'h91BC;
  localparam GPCFG_NSQ_ADDR48 = 16'h91C0;
  localparam GPCFG_NSQ_ADDR49 = 16'h91C4;
  localparam GPCFG_NSQ_ADDR50 = 16'h91C8;
  localparam GPCFG_NSQ_ADDR51 = 16'h91CC;
  localparam GPCFG_NSQ_ADDR52 = 16'h91D0;
  localparam GPCFG_NSQ_ADDR53 = 16'h91D4;
  localparam GPCFG_NSQ_ADDR54 = 16'h91D8;
  localparam GPCFG_NSQ_ADDR55 = 16'h91DC;
  localparam GPCFG_NSQ_ADDR56 = 16'h91E0;
  localparam GPCFG_NSQ_ADDR57 = 16'h91E4;
  localparam GPCFG_NSQ_ADDR58 = 16'h91E8;
  localparam GPCFG_NSQ_ADDR59 = 16'h91EC;
  localparam GPCFG_NSQ_ADDR60 = 16'h91F0;
  localparam GPCFG_NSQ_ADDR61 = 16'h91F4;
  localparam GPCFG_NSQ_ADDR62 = 16'h91F8;
  localparam GPCFG_NSQ_ADDR63 = 16'h91FC;

  localparam GPCFG_FKF_ADDR0  = 16'h9200;
  localparam GPCFG_FKF_ADDR1  = 16'h9204;
  localparam GPCFG_FKF_ADDR2  = 16'h9208;
  localparam GPCFG_FKF_ADDR3  = 16'h920C;
  localparam GPCFG_FKF_ADDR4  = 16'h9210;
  localparam GPCFG_FKF_ADDR5  = 16'h9214;
  localparam GPCFG_FKF_ADDR6  = 16'h9218;
  localparam GPCFG_FKF_ADDR7  = 16'h921C;
  localparam GPCFG_FKF_ADDR8  = 16'h9220;
  localparam GPCFG_FKF_ADDR9  = 16'h9224;
  localparam GPCFG_FKF_ADDR10 = 16'h9228;
  localparam GPCFG_FKF_ADDR11 = 16'h922C;
  localparam GPCFG_FKF_ADDR12 = 16'h9230;
  localparam GPCFG_FKF_ADDR13 = 16'h9234;
  localparam GPCFG_FKF_ADDR14 = 16'h9238;
  localparam GPCFG_FKF_ADDR15 = 16'h923C;
  localparam GPCFG_FKF_ADDR16 = 16'h9240;
  localparam GPCFG_FKF_ADDR17 = 16'h9244;
  localparam GPCFG_FKF_ADDR18 = 16'h9248;
  localparam GPCFG_FKF_ADDR19 = 16'h924C;
  localparam GPCFG_FKF_ADDR20 = 16'h9250;
  localparam GPCFG_FKF_ADDR21 = 16'h9254;
  localparam GPCFG_FKF_ADDR22 = 16'h9258;
  localparam GPCFG_FKF_ADDR23 = 16'h925C;
  localparam GPCFG_FKF_ADDR24 = 16'h9260;
  localparam GPCFG_FKF_ADDR25 = 16'h9264;
  localparam GPCFG_FKF_ADDR26 = 16'h9268;
  localparam GPCFG_FKF_ADDR27 = 16'h926C;
  localparam GPCFG_FKF_ADDR28 = 16'h9270;
  localparam GPCFG_FKF_ADDR29 = 16'h9274;
  localparam GPCFG_FKF_ADDR30 = 16'h9278;
  localparam GPCFG_FKF_ADDR31 = 16'h927C;
  localparam GPCFG_FKF_ADDR32 = 16'h9280;
  localparam GPCFG_FKF_ADDR33 = 16'h9284;
  localparam GPCFG_FKF_ADDR34 = 16'h9288;
  localparam GPCFG_FKF_ADDR35 = 16'h928C;
  localparam GPCFG_FKF_ADDR36 = 16'h9290;
  localparam GPCFG_FKF_ADDR37 = 16'h9294;
  localparam GPCFG_FKF_ADDR38 = 16'h9298;
  localparam GPCFG_FKF_ADDR39 = 16'h929C;
  localparam GPCFG_FKF_ADDR40 = 16'h92A0;
  localparam GPCFG_FKF_ADDR41 = 16'h92A4;
  localparam GPCFG_FKF_ADDR42 = 16'h92A8;
  localparam GPCFG_FKF_ADDR43 = 16'h92AC;
  localparam GPCFG_FKF_ADDR44 = 16'h92B0;
  localparam GPCFG_FKF_ADDR45 = 16'h92B4;
  localparam GPCFG_FKF_ADDR46 = 16'h92B8;
  localparam GPCFG_FKF_ADDR47 = 16'h92BC;
  localparam GPCFG_FKF_ADDR48 = 16'h92C0;
  localparam GPCFG_FKF_ADDR49 = 16'h92C4;
  localparam GPCFG_FKF_ADDR50 = 16'h92C8;
  localparam GPCFG_FKF_ADDR51 = 16'h92CC;
  localparam GPCFG_FKF_ADDR52 = 16'h92D0;
  localparam GPCFG_FKF_ADDR53 = 16'h92D4;
  localparam GPCFG_FKF_ADDR54 = 16'h92D8;
  localparam GPCFG_FKF_ADDR55 = 16'h92DC;
  localparam GPCFG_FKF_ADDR56 = 16'h92E0;
  localparam GPCFG_FKF_ADDR57 = 16'h92E4;
  localparam GPCFG_FKF_ADDR58 = 16'h92E8;
  localparam GPCFG_FKF_ADDR59 = 16'h92EC;
  localparam GPCFG_FKF_ADDR60 = 16'h92F0;
  localparam GPCFG_FKF_ADDR61 = 16'h92F4;
  localparam GPCFG_FKF_ADDR62 = 16'h92F8;
  localparam GPCFG_FKF_ADDR63 = 16'h92FC;

  localparam GPCFG_ARGA_ADDR0  = 16'h9300;
  localparam GPCFG_ARGA_ADDR1  = 16'h9304;
  localparam GPCFG_ARGA_ADDR2  = 16'h9308;
  localparam GPCFG_ARGA_ADDR3  = 16'h930C;
  localparam GPCFG_ARGA_ADDR4  = 16'h9310;
  localparam GPCFG_ARGA_ADDR5  = 16'h9314;
  localparam GPCFG_ARGA_ADDR6  = 16'h9318;
  localparam GPCFG_ARGA_ADDR7  = 16'h931C;
  localparam GPCFG_ARGA_ADDR8  = 16'h9320;
  localparam GPCFG_ARGA_ADDR9  = 16'h9324;
  localparam GPCFG_ARGA_ADDR10 = 16'h9328;
  localparam GPCFG_ARGA_ADDR11 = 16'h932C;
  localparam GPCFG_ARGA_ADDR12 = 16'h9330;
  localparam GPCFG_ARGA_ADDR13 = 16'h9334;
  localparam GPCFG_ARGA_ADDR14 = 16'h9338;
  localparam GPCFG_ARGA_ADDR15 = 16'h933C;
  localparam GPCFG_ARGA_ADDR16 = 16'h9340;
  localparam GPCFG_ARGA_ADDR17 = 16'h9344;
  localparam GPCFG_ARGA_ADDR18 = 16'h9348;
  localparam GPCFG_ARGA_ADDR19 = 16'h934C;
  localparam GPCFG_ARGA_ADDR20 = 16'h9350;
  localparam GPCFG_ARGA_ADDR21 = 16'h9354;
  localparam GPCFG_ARGA_ADDR22 = 16'h9358;
  localparam GPCFG_ARGA_ADDR23 = 16'h935C;
  localparam GPCFG_ARGA_ADDR24 = 16'h9360;
  localparam GPCFG_ARGA_ADDR25 = 16'h9364;
  localparam GPCFG_ARGA_ADDR26 = 16'h9368;
  localparam GPCFG_ARGA_ADDR27 = 16'h936C;
  localparam GPCFG_ARGA_ADDR28 = 16'h9370;
  localparam GPCFG_ARGA_ADDR29 = 16'h9374;
  localparam GPCFG_ARGA_ADDR30 = 16'h9378;
  localparam GPCFG_ARGA_ADDR31 = 16'h937C;
  localparam GPCFG_ARGA_ADDR32 = 16'h9380;
  localparam GPCFG_ARGA_ADDR33 = 16'h9384;
  localparam GPCFG_ARGA_ADDR34 = 16'h9388;
  localparam GPCFG_ARGA_ADDR35 = 16'h938C;
  localparam GPCFG_ARGA_ADDR36 = 16'h9390;
  localparam GPCFG_ARGA_ADDR37 = 16'h9394;
  localparam GPCFG_ARGA_ADDR38 = 16'h9398;
  localparam GPCFG_ARGA_ADDR39 = 16'h939C;
  localparam GPCFG_ARGA_ADDR40 = 16'h93A0;
  localparam GPCFG_ARGA_ADDR41 = 16'h93A4;
  localparam GPCFG_ARGA_ADDR42 = 16'h93A8;
  localparam GPCFG_ARGA_ADDR43 = 16'h93AC;
  localparam GPCFG_ARGA_ADDR44 = 16'h93B0;
  localparam GPCFG_ARGA_ADDR45 = 16'h93B4;
  localparam GPCFG_ARGA_ADDR46 = 16'h93B8;
  localparam GPCFG_ARGA_ADDR47 = 16'h93BC;
  localparam GPCFG_ARGA_ADDR48 = 16'h93C0;
  localparam GPCFG_ARGA_ADDR49 = 16'h93C4;
  localparam GPCFG_ARGA_ADDR50 = 16'h93C8;
  localparam GPCFG_ARGA_ADDR51 = 16'h93CC;
  localparam GPCFG_ARGA_ADDR52 = 16'h93D0;
  localparam GPCFG_ARGA_ADDR53 = 16'h93D4;
  localparam GPCFG_ARGA_ADDR54 = 16'h93D8;
  localparam GPCFG_ARGA_ADDR55 = 16'h93DC;
  localparam GPCFG_ARGA_ADDR56 = 16'h93E0;
  localparam GPCFG_ARGA_ADDR57 = 16'h93E4;
  localparam GPCFG_ARGA_ADDR58 = 16'h93E8;
  localparam GPCFG_ARGA_ADDR59 = 16'h93EC;
  localparam GPCFG_ARGA_ADDR60 = 16'h93F0;
  localparam GPCFG_ARGA_ADDR61 = 16'h93F4;
  localparam GPCFG_ARGA_ADDR62 = 16'h93F8;
  localparam GPCFG_ARGA_ADDR63 = 16'h93FC;

  localparam GPCFG_ARGB_ADDR0  = 16'h9400;
  localparam GPCFG_ARGB_ADDR1  = 16'h9404;
  localparam GPCFG_ARGB_ADDR2  = 16'h9408;
  localparam GPCFG_ARGB_ADDR3  = 16'h940C;
  localparam GPCFG_ARGB_ADDR4  = 16'h9410;
  localparam GPCFG_ARGB_ADDR5  = 16'h9414;
  localparam GPCFG_ARGB_ADDR6  = 16'h9418;
  localparam GPCFG_ARGB_ADDR7  = 16'h941C;
  localparam GPCFG_ARGB_ADDR8  = 16'h9420;
  localparam GPCFG_ARGB_ADDR9  = 16'h9424;
  localparam GPCFG_ARGB_ADDR10 = 16'h9428;
  localparam GPCFG_ARGB_ADDR11 = 16'h942C;
  localparam GPCFG_ARGB_ADDR12 = 16'h9430;
  localparam GPCFG_ARGB_ADDR13 = 16'h9434;
  localparam GPCFG_ARGB_ADDR14 = 16'h9438;
  localparam GPCFG_ARGB_ADDR15 = 16'h943C;
  localparam GPCFG_ARGB_ADDR16 = 16'h9440;
  localparam GPCFG_ARGB_ADDR17 = 16'h9444;
  localparam GPCFG_ARGB_ADDR18 = 16'h9448;
  localparam GPCFG_ARGB_ADDR19 = 16'h944C;
  localparam GPCFG_ARGB_ADDR20 = 16'h9450;
  localparam GPCFG_ARGB_ADDR21 = 16'h9454;
  localparam GPCFG_ARGB_ADDR22 = 16'h9458;
  localparam GPCFG_ARGB_ADDR23 = 16'h945C;
  localparam GPCFG_ARGB_ADDR24 = 16'h9460;
  localparam GPCFG_ARGB_ADDR25 = 16'h9464;
  localparam GPCFG_ARGB_ADDR26 = 16'h9468;
  localparam GPCFG_ARGB_ADDR27 = 16'h946C;
  localparam GPCFG_ARGB_ADDR28 = 16'h9470;
  localparam GPCFG_ARGB_ADDR29 = 16'h9474;
  localparam GPCFG_ARGB_ADDR30 = 16'h9478;
  localparam GPCFG_ARGB_ADDR31 = 16'h947C;
  localparam GPCFG_ARGB_ADDR32 = 16'h9480;
  localparam GPCFG_ARGB_ADDR33 = 16'h9484;
  localparam GPCFG_ARGB_ADDR34 = 16'h9488;
  localparam GPCFG_ARGB_ADDR35 = 16'h948C;
  localparam GPCFG_ARGB_ADDR36 = 16'h9490;
  localparam GPCFG_ARGB_ADDR37 = 16'h9494;
  localparam GPCFG_ARGB_ADDR38 = 16'h9498;
  localparam GPCFG_ARGB_ADDR39 = 16'h949C;
  localparam GPCFG_ARGB_ADDR40 = 16'h94A0;
  localparam GPCFG_ARGB_ADDR41 = 16'h94A4;
  localparam GPCFG_ARGB_ADDR42 = 16'h94A8;
  localparam GPCFG_ARGB_ADDR43 = 16'h94AC;
  localparam GPCFG_ARGB_ADDR44 = 16'h94B0;
  localparam GPCFG_ARGB_ADDR45 = 16'h94B4;
  localparam GPCFG_ARGB_ADDR46 = 16'h94B8;
  localparam GPCFG_ARGB_ADDR47 = 16'h94BC;
  localparam GPCFG_ARGB_ADDR48 = 16'h94C0;
  localparam GPCFG_ARGB_ADDR49 = 16'h94C4;
  localparam GPCFG_ARGB_ADDR50 = 16'h94C8;
  localparam GPCFG_ARGB_ADDR51 = 16'h94CC;
  localparam GPCFG_ARGB_ADDR52 = 16'h94D0;
  localparam GPCFG_ARGB_ADDR53 = 16'h94D4;
  localparam GPCFG_ARGB_ADDR54 = 16'h94D8;
  localparam GPCFG_ARGB_ADDR55 = 16'h94DC;
  localparam GPCFG_ARGB_ADDR56 = 16'h94E0;
  localparam GPCFG_ARGB_ADDR57 = 16'h94E4;
  localparam GPCFG_ARGB_ADDR58 = 16'h94E8;
  localparam GPCFG_ARGB_ADDR59 = 16'h94EC;
  localparam GPCFG_ARGB_ADDR60 = 16'h94F0;
  localparam GPCFG_ARGB_ADDR61 = 16'h94F4;
  localparam GPCFG_ARGB_ADDR62 = 16'h94F8;
  localparam GPCFG_ARGB_ADDR63 = 16'h94FC;

  localparam GPCFG_ARGC_ADDR0  = 16'h9500;
  localparam GPCFG_ARGC_ADDR1  = 16'h9504;
  localparam GPCFG_ARGC_ADDR2  = 16'h9508;
  localparam GPCFG_ARGC_ADDR3  = 16'h950C;
  localparam GPCFG_ARGC_ADDR4  = 16'h9510;
  localparam GPCFG_ARGC_ADDR5  = 16'h9514;
  localparam GPCFG_ARGC_ADDR6  = 16'h9518;
  localparam GPCFG_ARGC_ADDR7  = 16'h951C;
  localparam GPCFG_ARGC_ADDR8  = 16'h9520;
  localparam GPCFG_ARGC_ADDR9  = 16'h9524;
  localparam GPCFG_ARGC_ADDR10 = 16'h9528;
  localparam GPCFG_ARGC_ADDR11 = 16'h952C;
  localparam GPCFG_ARGC_ADDR12 = 16'h9530;
  localparam GPCFG_ARGC_ADDR13 = 16'h9534;
  localparam GPCFG_ARGC_ADDR14 = 16'h9538;
  localparam GPCFG_ARGC_ADDR15 = 16'h953C;
  localparam GPCFG_ARGC_ADDR16 = 16'h9540;
  localparam GPCFG_ARGC_ADDR17 = 16'h9544;
  localparam GPCFG_ARGC_ADDR18 = 16'h9548;
  localparam GPCFG_ARGC_ADDR19 = 16'h954C;
  localparam GPCFG_ARGC_ADDR20 = 16'h9550;
  localparam GPCFG_ARGC_ADDR21 = 16'h9554;
  localparam GPCFG_ARGC_ADDR22 = 16'h9558;
  localparam GPCFG_ARGC_ADDR23 = 16'h955C;
  localparam GPCFG_ARGC_ADDR24 = 16'h9560;
  localparam GPCFG_ARGC_ADDR25 = 16'h9564;
  localparam GPCFG_ARGC_ADDR26 = 16'h9568;
  localparam GPCFG_ARGC_ADDR27 = 16'h956C;
  localparam GPCFG_ARGC_ADDR28 = 16'h9570;
  localparam GPCFG_ARGC_ADDR29 = 16'h9574;
  localparam GPCFG_ARGC_ADDR30 = 16'h9578;
  localparam GPCFG_ARGC_ADDR31 = 16'h957C;
  localparam GPCFG_ARGC_ADDR32 = 16'h9580;
  localparam GPCFG_ARGC_ADDR33 = 16'h9584;
  localparam GPCFG_ARGC_ADDR34 = 16'h9588;
  localparam GPCFG_ARGC_ADDR35 = 16'h958C;
  localparam GPCFG_ARGC_ADDR36 = 16'h9590;
  localparam GPCFG_ARGC_ADDR37 = 16'h9594;
  localparam GPCFG_ARGC_ADDR38 = 16'h9598;
  localparam GPCFG_ARGC_ADDR39 = 16'h959C;
  localparam GPCFG_ARGC_ADDR40 = 16'h95A0;
  localparam GPCFG_ARGC_ADDR41 = 16'h95A4;
  localparam GPCFG_ARGC_ADDR42 = 16'h95A8;
  localparam GPCFG_ARGC_ADDR43 = 16'h95AC;
  localparam GPCFG_ARGC_ADDR44 = 16'h95B0;
  localparam GPCFG_ARGC_ADDR45 = 16'h95B4;
  localparam GPCFG_ARGC_ADDR46 = 16'h95B8;
  localparam GPCFG_ARGC_ADDR47 = 16'h95BC;
  localparam GPCFG_ARGC_ADDR48 = 16'h95C0;
  localparam GPCFG_ARGC_ADDR49 = 16'h95C4;
  localparam GPCFG_ARGC_ADDR50 = 16'h95C8;
  localparam GPCFG_ARGC_ADDR51 = 16'h95CC;
  localparam GPCFG_ARGC_ADDR52 = 16'h95D0;
  localparam GPCFG_ARGC_ADDR53 = 16'h95D4;
  localparam GPCFG_ARGC_ADDR54 = 16'h95D8;
  localparam GPCFG_ARGC_ADDR55 = 16'h95DC;
  localparam GPCFG_ARGC_ADDR56 = 16'h95E0;
  localparam GPCFG_ARGC_ADDR57 = 16'h95E4;
  localparam GPCFG_ARGC_ADDR58 = 16'h95E8;
  localparam GPCFG_ARGC_ADDR59 = 16'h95EC;
  localparam GPCFG_ARGC_ADDR60 = 16'h95F0;
  localparam GPCFG_ARGC_ADDR61 = 16'h95F4;
  localparam GPCFG_ARGC_ADDR62 = 16'h95F8;
  localparam GPCFG_ARGC_ADDR63 = 16'h95FC;
  
  localparam GPCFG_T_ADDR0  = 16'h9600;
  localparam GPCFG_T_ADDR1  = 16'h9604;
  localparam GPCFG_T_ADDR2  = 16'h9608;
  localparam GPCFG_T_ADDR3  = 16'h960C;
  localparam GPCFG_T_ADDR4  = 16'h9610;
  localparam GPCFG_T_ADDR5  = 16'h9614;
  localparam GPCFG_T_ADDR6  = 16'h9618;
  localparam GPCFG_T_ADDR7  = 16'h961C;
  localparam GPCFG_T_ADDR8  = 16'h9620;
  localparam GPCFG_T_ADDR9  = 16'h9624;
  localparam GPCFG_T_ADDR10 = 16'h9628;
  localparam GPCFG_T_ADDR11 = 16'h962C;
  localparam GPCFG_T_ADDR12 = 16'h9630;
  localparam GPCFG_T_ADDR13 = 16'h9634;
  localparam GPCFG_T_ADDR14 = 16'h9638;
  localparam GPCFG_T_ADDR15 = 16'h963C;
  localparam GPCFG_T_ADDR16 = 16'h9640;
  localparam GPCFG_T_ADDR17 = 16'h9644;
  localparam GPCFG_T_ADDR18 = 16'h9648;
  localparam GPCFG_T_ADDR19 = 16'h964C;
  localparam GPCFG_T_ADDR20 = 16'h9650;
  localparam GPCFG_T_ADDR21 = 16'h9654;
  localparam GPCFG_T_ADDR22 = 16'h9658;
  localparam GPCFG_T_ADDR23 = 16'h965C;
  localparam GPCFG_T_ADDR24 = 16'h9660;
  localparam GPCFG_T_ADDR25 = 16'h9664;
  localparam GPCFG_T_ADDR26 = 16'h9668;
  localparam GPCFG_T_ADDR27 = 16'h966C;
  localparam GPCFG_T_ADDR28 = 16'h9670;
  localparam GPCFG_T_ADDR29 = 16'h9674;
  localparam GPCFG_T_ADDR30 = 16'h9678;
  localparam GPCFG_T_ADDR31 = 16'h967C;
  localparam GPCFG_S_ADDR0  = 16'h9680;
  localparam GPCFG_S_ADDR1  = 16'h9684;
  localparam GPCFG_S_ADDR2  = 16'h9688;
  localparam GPCFG_S_ADDR3  = 16'h968C;
  localparam GPCFG_S_ADDR4  = 16'h9690;
  localparam GPCFG_S_ADDR5  = 16'h9694;
  localparam GPCFG_S_ADDR6  = 16'h9698;
  localparam GPCFG_S_ADDR7  = 16'h969C;
  localparam GPCFG_S_ADDR8  = 16'h96A0;
  localparam GPCFG_S_ADDR9  = 16'h96A4;
  localparam GPCFG_S_ADDR10 = 16'h96A8;
  localparam GPCFG_S_ADDR11 = 16'h96AC;
  localparam GPCFG_S_ADDR12 = 16'h96B0;
  localparam GPCFG_S_ADDR13 = 16'h96B4;
  localparam GPCFG_S_ADDR14 = 16'h96B8;
  localparam GPCFG_S_ADDR15 = 16'h96BC;
  localparam GPCFG_S_ADDR16 = 16'h96C0;
  localparam GPCFG_S_ADDR17 = 16'h96C4;
  localparam GPCFG_S_ADDR18 = 16'h96C8;
  localparam GPCFG_S_ADDR19 = 16'h96CC;
  localparam GPCFG_S_ADDR20 = 16'h96D0;
  localparam GPCFG_S_ADDR21 = 16'h96D4;
  localparam GPCFG_S_ADDR22 = 16'h96D8;
  localparam GPCFG_S_ADDR23 = 16'h96DC;
  localparam GPCFG_S_ADDR24 = 16'h96E0;
  localparam GPCFG_S_ADDR25 = 16'h96E4;
  localparam GPCFG_S_ADDR26 = 16'h96E8;
  localparam GPCFG_S_ADDR27 = 16'h96EC;
  localparam GPCFG_S_ADDR28 = 16'h96F0;
  localparam GPCFG_S_ADDR29 = 16'h96F4;
  localparam GPCFG_S_ADDR30 = 16'h96F8;
  localparam GPCFG_S_ADDR31 = 16'h96FC;

  localparam GPCFG_PC_ADDR0  = 16'h9700;
  localparam GPCFG_PC_ADDR1  = 16'h9704;
  localparam GPCFG_PC_ADDR2  = 16'h9708;
  localparam GPCFG_PC_ADDR3  = 16'h970C;
  localparam GPCFG_PC_ADDR4  = 16'h9710;
  localparam GPCFG_PC_ADDR5  = 16'h9714;
  localparam GPCFG_PC_ADDR6  = 16'h9718;
  localparam GPCFG_PC_ADDR7  = 16'h971C;
  localparam GPCFG_PC_ADDR8  = 16'h9720;
  localparam GPCFG_PC_ADDR9  = 16'h9724;
  localparam GPCFG_PC_ADDR10 = 16'h9728;
  localparam GPCFG_PC_ADDR11 = 16'h972C;
  localparam GPCFG_PC_ADDR12 = 16'h9730;
  localparam GPCFG_PC_ADDR13 = 16'h9734;
  localparam GPCFG_PC_ADDR14 = 16'h9738;
  localparam GPCFG_PC_ADDR15 = 16'h973C;
  localparam GPCFG_PC_ADDR16 = 16'h9740;
  localparam GPCFG_PC_ADDR17 = 16'h9744;
  localparam GPCFG_PC_ADDR18 = 16'h9748;
  localparam GPCFG_PC_ADDR19 = 16'h974C;
  localparam GPCFG_PC_ADDR20 = 16'h9750;
  localparam GPCFG_PC_ADDR21 = 16'h9754;
  localparam GPCFG_PC_ADDR22 = 16'h9758;
  localparam GPCFG_PC_ADDR23 = 16'h975C;
  localparam GPCFG_PC_ADDR24 = 16'h9760;
  localparam GPCFG_PC_ADDR25 = 16'h9764;
  localparam GPCFG_PC_ADDR26 = 16'h9768;
  localparam GPCFG_PC_ADDR27 = 16'h976C;
  localparam GPCFG_PC_ADDR28 = 16'h9770;
  localparam GPCFG_PC_ADDR29 = 16'h9774;
  localparam GPCFG_PC_ADDR30 = 16'h9778;
  localparam GPCFG_PC_ADDR31 = 16'h977C;
  localparam GPCFG_PC_ADDR32 = 16'h9780;
  localparam GPCFG_PC_ADDR33 = 16'h9784;
  localparam GPCFG_PC_ADDR34 = 16'h9788;
  localparam GPCFG_PC_ADDR35 = 16'h978C;
  localparam GPCFG_PC_ADDR36 = 16'h9790;
  localparam GPCFG_PC_ADDR37 = 16'h9794;
  localparam GPCFG_PC_ADDR38 = 16'h9798;
  localparam GPCFG_PC_ADDR39 = 16'h979C;
  localparam GPCFG_PC_ADDR40 = 16'h97A0;
  localparam GPCFG_PC_ADDR41 = 16'h97A4;
  localparam GPCFG_PC_ADDR42 = 16'h97A8;
  localparam GPCFG_PC_ADDR43 = 16'h97AC;
  localparam GPCFG_PC_ADDR44 = 16'h97B0;
  localparam GPCFG_PC_ADDR45 = 16'h97B4;
  localparam GPCFG_PC_ADDR46 = 16'h97B8;
  localparam GPCFG_PC_ADDR47 = 16'h97BC;
  localparam GPCFG_PC_ADDR48 = 16'h97C0;
  localparam GPCFG_PC_ADDR49 = 16'h97C4;
  localparam GPCFG_PC_ADDR50 = 16'h97C8;
  localparam GPCFG_PC_ADDR51 = 16'h97CC;
  localparam GPCFG_PC_ADDR52 = 16'h97D0;
  localparam GPCFG_PC_ADDR53 = 16'h97D4;
  localparam GPCFG_PC_ADDR54 = 16'h97D8;
  localparam GPCFG_PC_ADDR55 = 16'h97DC;
  localparam GPCFG_PC_ADDR56 = 16'h97E0;
  localparam GPCFG_PC_ADDR57 = 16'h97E4;
  localparam GPCFG_PC_ADDR58 = 16'h97E8;
  localparam GPCFG_PC_ADDR59 = 16'h97EC;
  localparam GPCFG_PC_ADDR60 = 16'h97F0;
  localparam GPCFG_PC_ADDR61 = 16'h97F4;
  localparam GPCFG_PC_ADDR62 = 16'h97F8;
  localparam GPCFG_PC_ADDR63 = 16'h97FC;

  localparam GPCFG_MUL_ADDR0  = 16'h9800;
  localparam GPCFG_MUL_ADDR1  = 16'h9804;
  localparam GPCFG_MUL_ADDR2  = 16'h9808;
  localparam GPCFG_MUL_ADDR3  = 16'h980C;
  localparam GPCFG_MUL_ADDR4  = 16'h9810;
  localparam GPCFG_MUL_ADDR5  = 16'h9814;
  localparam GPCFG_MUL_ADDR6  = 16'h9818;
  localparam GPCFG_MUL_ADDR7  = 16'h981C;
  localparam GPCFG_MUL_ADDR8  = 16'h9820;
  localparam GPCFG_MUL_ADDR9  = 16'h9824;
  localparam GPCFG_MUL_ADDR10 = 16'h9828;
  localparam GPCFG_MUL_ADDR11 = 16'h982C;
  localparam GPCFG_MUL_ADDR12 = 16'h9830;
  localparam GPCFG_MUL_ADDR13 = 16'h9834;
  localparam GPCFG_MUL_ADDR14 = 16'h9838;
  localparam GPCFG_MUL_ADDR15 = 16'h983C;
  localparam GPCFG_MUL_ADDR16 = 16'h9840;
  localparam GPCFG_MUL_ADDR17 = 16'h9844;
  localparam GPCFG_MUL_ADDR18 = 16'h9848;
  localparam GPCFG_MUL_ADDR19 = 16'h984C;
  localparam GPCFG_MUL_ADDR20 = 16'h9850;
  localparam GPCFG_MUL_ADDR21 = 16'h9854;
  localparam GPCFG_MUL_ADDR22 = 16'h9858;
  localparam GPCFG_MUL_ADDR23 = 16'h985C;
  localparam GPCFG_MUL_ADDR24 = 16'h9860;
  localparam GPCFG_MUL_ADDR25 = 16'h9864;
  localparam GPCFG_MUL_ADDR26 = 16'h9868;
  localparam GPCFG_MUL_ADDR27 = 16'h986C;
  localparam GPCFG_MUL_ADDR28 = 16'h9870;
  localparam GPCFG_MUL_ADDR29 = 16'h9874;
  localparam GPCFG_MUL_ADDR30 = 16'h9878;
  localparam GPCFG_MUL_ADDR31 = 16'h987C;
  localparam GPCFG_MUL_ADDR32 = 16'h9880;
  localparam GPCFG_MUL_ADDR33 = 16'h9884;
  localparam GPCFG_MUL_ADDR34 = 16'h9888;
  localparam GPCFG_MUL_ADDR35 = 16'h988C;
  localparam GPCFG_MUL_ADDR36 = 16'h9890;
  localparam GPCFG_MUL_ADDR37 = 16'h9894;
  localparam GPCFG_MUL_ADDR38 = 16'h9898;
  localparam GPCFG_MUL_ADDR39 = 16'h989C;
  localparam GPCFG_MUL_ADDR40 = 16'h98A0;
  localparam GPCFG_MUL_ADDR41 = 16'h98A4;
  localparam GPCFG_MUL_ADDR42 = 16'h98A8;
  localparam GPCFG_MUL_ADDR43 = 16'h98AC;
  localparam GPCFG_MUL_ADDR44 = 16'h98B0;
  localparam GPCFG_MUL_ADDR45 = 16'h98B4;
  localparam GPCFG_MUL_ADDR46 = 16'h98B8;
  localparam GPCFG_MUL_ADDR47 = 16'h98BC;
  localparam GPCFG_MUL_ADDR48 = 16'h98C0;
  localparam GPCFG_MUL_ADDR49 = 16'h98C4;
  localparam GPCFG_MUL_ADDR50 = 16'h98C8;
  localparam GPCFG_MUL_ADDR51 = 16'h98CC;
  localparam GPCFG_MUL_ADDR52 = 16'h98D0;
  localparam GPCFG_MUL_ADDR53 = 16'h98D4;
  localparam GPCFG_MUL_ADDR54 = 16'h98D8;
  localparam GPCFG_MUL_ADDR55 = 16'h98DC;
  localparam GPCFG_MUL_ADDR56 = 16'h98E0;
  localparam GPCFG_MUL_ADDR57 = 16'h98E4;
  localparam GPCFG_MUL_ADDR58 = 16'h98E8;
  localparam GPCFG_MUL_ADDR59 = 16'h98EC;
  localparam GPCFG_MUL_ADDR60 = 16'h98F0;
  localparam GPCFG_MUL_ADDR61 = 16'h98F4;
  localparam GPCFG_MUL_ADDR62 = 16'h98F8;
  localparam GPCFG_MUL_ADDR63 = 16'h98FC;

  localparam GPCFG_EXP_ADDR0  = 16'h9900;
  localparam GPCFG_EXP_ADDR1  = 16'h9904;
  localparam GPCFG_EXP_ADDR2  = 16'h9908;
  localparam GPCFG_EXP_ADDR3  = 16'h990C;
  localparam GPCFG_EXP_ADDR4  = 16'h9910;
  localparam GPCFG_EXP_ADDR5  = 16'h9914;
  localparam GPCFG_EXP_ADDR6  = 16'h9918;
  localparam GPCFG_EXP_ADDR7  = 16'h991C;
  localparam GPCFG_EXP_ADDR8  = 16'h9920;
  localparam GPCFG_EXP_ADDR9  = 16'h9924;
  localparam GPCFG_EXP_ADDR10 = 16'h9928;
  localparam GPCFG_EXP_ADDR11 = 16'h992C;
  localparam GPCFG_EXP_ADDR12 = 16'h9930;
  localparam GPCFG_EXP_ADDR13 = 16'h9934;
  localparam GPCFG_EXP_ADDR14 = 16'h9938;
  localparam GPCFG_EXP_ADDR15 = 16'h993C;
  localparam GPCFG_EXP_ADDR16 = 16'h9940;
  localparam GPCFG_EXP_ADDR17 = 16'h9944;
  localparam GPCFG_EXP_ADDR18 = 16'h9948;
  localparam GPCFG_EXP_ADDR19 = 16'h994C;
  localparam GPCFG_EXP_ADDR20 = 16'h9950;
  localparam GPCFG_EXP_ADDR21 = 16'h9954;
  localparam GPCFG_EXP_ADDR22 = 16'h9958;
  localparam GPCFG_EXP_ADDR23 = 16'h995C;
  localparam GPCFG_EXP_ADDR24 = 16'h9960;
  localparam GPCFG_EXP_ADDR25 = 16'h9964;
  localparam GPCFG_EXP_ADDR26 = 16'h9968;
  localparam GPCFG_EXP_ADDR27 = 16'h996C;
  localparam GPCFG_EXP_ADDR28 = 16'h9970;
  localparam GPCFG_EXP_ADDR29 = 16'h9974;
  localparam GPCFG_EXP_ADDR30 = 16'h9978;
  localparam GPCFG_EXP_ADDR31 = 16'h997C;
  localparam GPCFG_EXP_ADDR32 = 16'h9980;
  localparam GPCFG_EXP_ADDR33 = 16'h9984;
  localparam GPCFG_EXP_ADDR34 = 16'h9988;
  localparam GPCFG_EXP_ADDR35 = 16'h998C;
  localparam GPCFG_EXP_ADDR36 = 16'h9990;
  localparam GPCFG_EXP_ADDR37 = 16'h9994;
  localparam GPCFG_EXP_ADDR38 = 16'h9998;
  localparam GPCFG_EXP_ADDR39 = 16'h999C;
  localparam GPCFG_EXP_ADDR40 = 16'h99A0;
  localparam GPCFG_EXP_ADDR41 = 16'h99A4;
  localparam GPCFG_EXP_ADDR42 = 16'h99A8;
  localparam GPCFG_EXP_ADDR43 = 16'h99AC;
  localparam GPCFG_EXP_ADDR44 = 16'h99B0;
  localparam GPCFG_EXP_ADDR45 = 16'h99B4;
  localparam GPCFG_EXP_ADDR46 = 16'h99B8;
  localparam GPCFG_EXP_ADDR47 = 16'h99BC;
  localparam GPCFG_EXP_ADDR48 = 16'h99C0;
  localparam GPCFG_EXP_ADDR49 = 16'h99C4;
  localparam GPCFG_EXP_ADDR50 = 16'h99C8;
  localparam GPCFG_EXP_ADDR51 = 16'h99CC;
  localparam GPCFG_EXP_ADDR52 = 16'h99D0;
  localparam GPCFG_EXP_ADDR53 = 16'h99D4;
  localparam GPCFG_EXP_ADDR54 = 16'h99D8;
  localparam GPCFG_EXP_ADDR55 = 16'h99DC;
  localparam GPCFG_EXP_ADDR56 = 16'h99E0;
  localparam GPCFG_EXP_ADDR57 = 16'h99E4;
  localparam GPCFG_EXP_ADDR58 = 16'h99E8;
  localparam GPCFG_EXP_ADDR59 = 16'h99EC;
  localparam GPCFG_EXP_ADDR60 = 16'h99F0;
  localparam GPCFG_EXP_ADDR61 = 16'h99F4;
  localparam GPCFG_EXP_ADDR62 = 16'h99F8;
  localparam GPCFG_EXP_ADDR63 = 16'h99FC;

  localparam GPCFG_INV_ADDR0  = 16'h9A00;
  localparam GPCFG_INV_ADDR1  = 16'h9A04;
  localparam GPCFG_INV_ADDR2  = 16'h9A08;
  localparam GPCFG_INV_ADDR3  = 16'h9A0C;
  localparam GPCFG_INV_ADDR4  = 16'h9A10;
  localparam GPCFG_INV_ADDR5  = 16'h9A14;
  localparam GPCFG_INV_ADDR6  = 16'h9A18;
  localparam GPCFG_INV_ADDR7  = 16'h9A1C;
  localparam GPCFG_INV_ADDR8  = 16'h9A20;
  localparam GPCFG_INV_ADDR9  = 16'h9A24;
  localparam GPCFG_INV_ADDR10 = 16'h9A28;
  localparam GPCFG_INV_ADDR11 = 16'h9A2C;
  localparam GPCFG_INV_ADDR12 = 16'h9A30;
  localparam GPCFG_INV_ADDR13 = 16'h9A34;
  localparam GPCFG_INV_ADDR14 = 16'h9A38;
  localparam GPCFG_INV_ADDR15 = 16'h9A3C;
  localparam GPCFG_INV_ADDR16 = 16'h9A40;
  localparam GPCFG_INV_ADDR17 = 16'h9A44;
  localparam GPCFG_INV_ADDR18 = 16'h9A48;
  localparam GPCFG_INV_ADDR19 = 16'h9A4C;
  localparam GPCFG_INV_ADDR20 = 16'h9A50;
  localparam GPCFG_INV_ADDR21 = 16'h9A54;
  localparam GPCFG_INV_ADDR22 = 16'h9A58;
  localparam GPCFG_INV_ADDR23 = 16'h9A5C;
  localparam GPCFG_INV_ADDR24 = 16'h9A60;
  localparam GPCFG_INV_ADDR25 = 16'h9A64;
  localparam GPCFG_INV_ADDR26 = 16'h9A68;
  localparam GPCFG_INV_ADDR27 = 16'h9A6C;
  localparam GPCFG_INV_ADDR28 = 16'h9A70;
  localparam GPCFG_INV_ADDR29 = 16'h9A74;
  localparam GPCFG_INV_ADDR30 = 16'h9A78;
  localparam GPCFG_INV_ADDR31 = 16'h9A7C;
  localparam GPCFG_INV_ADDR32 = 16'h9A80;
  localparam GPCFG_INV_ADDR33 = 16'h9A84;
  localparam GPCFG_INV_ADDR34 = 16'h9A88;
  localparam GPCFG_INV_ADDR35 = 16'h9A8C;
  localparam GPCFG_INV_ADDR36 = 16'h9A90;
  localparam GPCFG_INV_ADDR37 = 16'h9A94;
  localparam GPCFG_INV_ADDR38 = 16'h9A98;
  localparam GPCFG_INV_ADDR39 = 16'h9A9C;
  localparam GPCFG_INV_ADDR40 = 16'h9AA0;
  localparam GPCFG_INV_ADDR41 = 16'h9AA4;
  localparam GPCFG_INV_ADDR42 = 16'h9AA8;
  localparam GPCFG_INV_ADDR43 = 16'h9AAC;
  localparam GPCFG_INV_ADDR44 = 16'h9AB0;
  localparam GPCFG_INV_ADDR45 = 16'h9AB4;
  localparam GPCFG_INV_ADDR46 = 16'h9AB8;
  localparam GPCFG_INV_ADDR47 = 16'h9ABC;
  localparam GPCFG_INV_ADDR48 = 16'h9AC0;
  localparam GPCFG_INV_ADDR49 = 16'h9AC4;
  localparam GPCFG_INV_ADDR50 = 16'h9AC8;
  localparam GPCFG_INV_ADDR51 = 16'h9ACC;
  localparam GPCFG_INV_ADDR52 = 16'h9AD0;
  localparam GPCFG_INV_ADDR53 = 16'h9AD4;
  localparam GPCFG_INV_ADDR54 = 16'h9AD8;
  localparam GPCFG_INV_ADDR55 = 16'h9ADC;
  localparam GPCFG_INV_ADDR56 = 16'h9AE0;
  localparam GPCFG_INV_ADDR57 = 16'h9AE4;
  localparam GPCFG_INV_ADDR58 = 16'h9AE8;
  localparam GPCFG_INV_ADDR59 = 16'h9AEC;
  localparam GPCFG_INV_ADDR60 = 16'h9AF0;
  localparam GPCFG_INV_ADDR61 = 16'h9AF4;
  localparam GPCFG_INV_ADDR62 = 16'h9AF8;
  localparam GPCFG_INV_ADDR63 = 16'h9AFC;


  reg [31:0] read_data;


  reg [31:0] haddr_lat;
  reg        valid_wr_lat;
  reg        dec_err;

  reg [3:0]  wbyte_en;
  reg [3:0]  wbyte_en_lat;

  reg  [31:0] cleq_ctl_reg;
  reg  [31:0] cleq_maxbits_reg;

  reg  [1023:0] cleq_n_reg;
  reg  [2047:0] cleq_nsq_reg;
  reg  [2047:0] gpcfg_fkf_reg;

  wire  [1023:0] n_loc;
  wire  [2047:0] nsq_loc;
  wire  [2047:0] fkf_loc;

  reg  [1023:0] cleq_rand_reg;

  reg  [2047:0] cleq_arga_reg;
  reg  [2047:0] cleq_argb_reg;
  reg  [2047:0] cleq_argc_reg;
  reg  [2047:0] cleq_pc_reg;

  reg  [1023:0] gpcfg_t_reg;
  reg  [1023:0] gpcfg_s_reg;

  reg  [2047:0] mod_inv;
  reg  [2047:0] r_hw;
  reg           cl_busy; 
  reg           cl_inverr; 

  wire [1023:0] n; 
  wire [2047:0] nsq; 
  wire [2048:0] r_egcd; 
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


//----------------------------
// Logic for getting read data
//----------------------------
gpcfg_rd_wr #( .RESET_VAL (32'h16), .CFG_ADDR (GPCFG0_ADDR)) u_cfg_pad03_ctl_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (pad03_ctl_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'h17), .CFG_ADDR (GPCFG1_ADDR)) u_cfg_pad04_ctl_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (pad04_ctl_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_0017), .CFG_ADDR (GPCFG2_ADDR)) u_cfg_pad05_ctl_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (pad05_ctl_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_0017), .CFG_ADDR (GPCFG3_ADDR)) u_cfg_pad06_ctl_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (pad06_ctl_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_001B), .CFG_ADDR (GPCFG4_ADDR)) u_cfg_pad07_ctl_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (pad07_ctl_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_001B), .CFG_ADDR (GPCFG5_ADDR)) u_cfg_pad08_ctl_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (pad08_ctl_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_001B), .CFG_ADDR (GPCFG6_ADDR)) u_cfg_pad09_ctl_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (pad09_ctl_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_001B), .CFG_ADDR (GPCFG7_ADDR)) u_cfg_pad10_ctl_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (pad10_ctl_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_001B), .CFG_ADDR (GPCFG8_ADDR)) u_cfg_pad11_ctl_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (pad11_ctl_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_001B), .CFG_ADDR (GPCFG9_ADDR)) u_cfg_pad12_ctl_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (pad12_ctl_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_001B), .CFG_ADDR (GPCFG10_ADDR)) u_cfg_pad13_ctl_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (pad13_ctl_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_001B), .CFG_ADDR (GPCFG11_ADDR)) u_cfg_pad14_ctl_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (pad14_ctl_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_001B), .CFG_ADDR (GPCFG12_ADDR)) u_cfg_pad15_ctl_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (pad15_ctl_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_001B), .CFG_ADDR (GPCFG13_ADDR)) u_cfg_pad16_ctl_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (pad16_ctl_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_001B), .CFG_ADDR (GPCFG14_ADDR)) u_cfg_pad17_ctl_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (pad17_ctl_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_001B), .CFG_ADDR (GPCFG15_ADDR)) u_cfg_pad18_ctl_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (pad18_ctl_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'h10_001B), .CFG_ADDR (GPCFG16_ADDR)) u_cfg_pad19_ctl_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (pad19_ctl_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'd2500), .CFG_ADDR (GPCFG17_ADDR)) u_cfg_uartm_baud_ctl_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (uartm_baud_ctl_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'h0), .CFG_ADDR (GPCFG18_ADDR)) u_cfg_uartm_ctl_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (uartm_ctl_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'h9C4), .CFG_ADDR (GPCFG34_ADDR)) u_cfg_uarts_baud_ctl_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (uarts_baud_ctl_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'h0), .CFG_ADDR (GPCFG35_ADDR)) u_cfg_uarts_ctl_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (uarts_ctl_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'h0), .CFG_ADDR (GPCFG36_ADDR)) u_cfg_uarts_tx_data_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (uarts_tx_data_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'h0), .CFG_ADDR (GPCFG38_ADDR)) u_cfg_uarts_tx_send_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (uarts_tx_send_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'h0), .CFG_ADDR (GPCFG39_ADDR)) u_cfg_spare0_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (spare0_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'h0), .CFG_ADDR (GPCFG40_ADDR)) u_cfg_spare1_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (spare1_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'hFFFF_FFFF), .CFG_ADDR (GPCFG41_ADDR)) u_cfg_spare2_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (spare2_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'hFFFF_FFFF), .CFG_ADDR (GPCFG42_ADDR)) u_cfg_spare3_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (spare3_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'h0CC5_0101), .CFG_ADDR (0])) u_cfg_signature_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (1'b0),         .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (signature_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'h0), .CFG_ADDR (GPCFG_CLCTL_ADDR)) u_cfg_cleq_ctl_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (cleq_ctl_reg),              .rdata (rdata[]));


gpcfg_rd_wr #( .RESET_VAL (32'h7FF), .CFG_ADDR (GPCFG_CLMAXBITS_ADDR)) u_cfg_cleq_maxbits_reg_inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (cleq_maxbits_reg),              .rdata (rdata[]));

genvar i

generate
  for (i =0, i < 32, i =i +1) begin : cfg_cleq_n_gen
    gpcfg_rd_wr #( .RESET_VAL (32'd0), .CFG_ADDR (GPCFG_N_ADDR[i])) u_cfg_cleq_n_reg_inst (
      .hclk    (hclk),                       .hresetn (hresetn),
      .wr_en   (valid_wr_lat),               .rd_en (valid_rd),
      .byte_en (wbyte_en_lat),               .wr_addr (haddr_lat),
      .rd_addr (haddr),                      .wdata (hwdata),
      .wr_reg  (cleq_n_reg[31+32*i:32*i]),   .rdata (rdata[+1+i]));
  end
endgenerate


generate
  for (i =0, i < 32, i =i +1) begin : cfg_cleq_rand_gen
    gpcfg_rd_wr #( .RESET_VAL (32'd0), .CFG_ADDR (GPCFG_R_ADDR[i])) u_cfg_cleq_rand_reg_inst (
      .hclk    (hclk),                                      .hresetn (hresetn),
      .wr_en   (valid_wr_lat),                              .rd_en (valid_rd),
      .byte_en (wbyte_en_lat),                              .wr_addr (haddr_lat),
      .rd_addr (haddr),                                     .wdata (hwdata),
      .wr_reg  (cleq_rand_reg[31+32*i:32*i]),               .rdata (rdata[+1+i]));
  end
endgenerate


gpcfg_rd_wr #( .RESET_VAL (), .CFG_ADDR ()) u_cfg__inst (
  .hclk    (hclk),         .hresetn (hresetn),
  .wr_en   (valid_wr_lat), .rd_en (valid_rd),
  .byte_en (wbyte_en_lat), .wr_addr (haddr_lat),
  .rd_addr (haddr),        .wdata (hwdata),
  .wr_reg (),              .rdata ());

     
  parameter RESET_VAL     = 32'b0,
  parameter CFG_ADDR      = 32'h0)(
  input                hclk,
  input                hresetn,
  input                wr_en,
  input                rd_en,
  input       [3:0]    byte_en,
  input       [31:0]   addr,
  input       [31:0]   wdata,
  output reg  [31:0]   wr_reg,
  output      [31:0]   rdata
);


  

  always @*  begin
    if (hsel) begin
      case (haddr[9:2]) //synopsys parallel_case 
        GPCFG0_ADDR  : begin
          read_data  = pad03_ctl_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG1_ADDR  : begin
          read_data  = pad04_ctl_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG2_ADDR  : begin
          read_data  = pad05_ctl_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG3_ADDR  : begin
          read_data  = pad06_ctl_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG4_ADDR  : begin
          read_data  = pad07_ctl_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG5_ADDR  : begin
          read_data  = pad08_ctl_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG6_ADDR  : begin
          read_data  = pad09_ctl_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG7_ADDR  : begin
          read_data  = pad10_ctl_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG8_ADDR  : begin
          read_data  = pad11_ctl_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG9_ADDR  : begin
          read_data  = pad12_ctl_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG10_ADDR  : begin
          read_data  = pad13_ctl_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG11_ADDR  : begin
          read_data  = pad14_ctl_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG12_ADDR  : begin
          read_data  = pad15_ctl_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG13_ADDR  : begin
          read_data  = pad16_ctl_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG14_ADDR  : begin
          read_data  = pad17_ctl_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG15_ADDR  : begin
          read_data  = pad18_ctl_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG16_ADDR  : begin
          read_data  = pad19_ctl_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG17_ADDR  : begin
          read_data  = uartm_baud_ctl_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG18_ADDR  : begin
          read_data  = uartm_ctl_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG34_ADDR : begin
          read_data  = uarts_baud_ctl_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG35_ADDR : begin
          read_data  = uarts_ctl_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG36_ADDR : begin
          read_data  = uarts_tx_data_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG37_ADDR : begin
          read_data  = uarts_rx_data & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG38_ADDR : begin
          read_data  = uarts_tx_send_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG39_ADDR : begin
          read_data  = spare0_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG40_ADDR : begin
          read_data  = spare1_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG41_ADDR : begin
          read_data  = spare2_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG42_ADDR : begin
          read_data  = spare3_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG51_ADDR : begin
          read_data  = signature_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_CLCTL_ADDR : begin
          read_data  = cleq_ctl_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_CLMAXBITS_ADDR : begin
          read_data  = cleq_maxbits_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_CLSTATUS_ADDR : begin
          read_data  = {30'b0, cl_inverr, cl_busy} & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR0 : begin
          read_data  = mod_mul_il_y[31:0] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR1 : begin
          read_data  = mod_mul_il_y[63:32] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR2 : begin
          read_data  = mod_mul_il_y[95:64] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR3 : begin
          read_data  = mod_mul_il_y[127:96] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR4 : begin
          read_data  = mod_mul_il_y[159:128] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR5 : begin
          read_data  = mod_mul_il_y[191:160] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR6 : begin
          read_data  = mod_mul_il_y[223:192] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR7 : begin
          read_data  = mod_mul_il_y[255:224] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR8 : begin
          read_data  = mod_mul_il_y[287:256] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR9 : begin
          read_data  = mod_mul_il_y[319:288] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR10 : begin
          read_data  = mod_mul_il_y[351:320] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR11 : begin
          read_data  = mod_mul_il_y[383:352] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR12 : begin
          read_data  = mod_mul_il_y[415:384] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR13 : begin
          read_data  = mod_mul_il_y[447:416] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR14 : begin
          read_data  = mod_mul_il_y[479:448] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR15 : begin
          read_data  = mod_mul_il_y[511:480] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR16 : begin
          read_data  = mod_mul_il_y[543:512] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR17 : begin
          read_data  = mod_mul_il_y[575:544] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR18 : begin
          read_data  = mod_mul_il_y[607:576] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR19 : begin
          read_data  = mod_mul_il_y[639:608] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR20 : begin
          read_data  = mod_mul_il_y[671:640] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR21 : begin
          read_data  = mod_mul_il_y[703:672] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR22 : begin
          read_data  = mod_mul_il_y[735:704] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR23 : begin
          read_data  = mod_mul_il_y[767:736] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR24 : begin
          read_data  = mod_mul_il_y[799:768] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR25 : begin
          read_data  = mod_mul_il_y[831:800] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR26 : begin
          read_data  = mod_mul_il_y[863:832] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR27 : begin
          read_data  = mod_mul_il_y[895:864] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR28 : begin
          read_data  = mod_mul_il_y[927:896] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR29 : begin
          read_data  = mod_mul_il_y[959:928] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR30 : begin
          read_data  = mod_mul_il_y[991:960] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR31 : begin
          read_data  = mod_mul_il_y[1023:992] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR32 : begin
          read_data  = mod_mul_il_y[1055:1024] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR33 : begin
          read_data  = mod_mul_il_y[1087:1056] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR34 : begin
          read_data  = mod_mul_il_y[1119:1088] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR35 : begin
          read_data  = mod_mul_il_y[1151:1120] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR36 : begin
          read_data  = mod_mul_il_y[1183:1152] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR37 : begin
          read_data  = mod_mul_il_y[1215:1184] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR38 : begin
          read_data  = mod_mul_il_y[1247:1216] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR39 : begin
          read_data  = mod_mul_il_y[1279:1248] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR40 : begin
          read_data  = mod_mul_il_y[1311:1280] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR41 : begin
          read_data  = mod_mul_il_y[1343:1312] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR42 : begin
          read_data  = mod_mul_il_y[1375:1344] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR43 : begin
          read_data  = mod_mul_il_y[1407:1376] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR44 : begin
          read_data  = mod_mul_il_y[1439:1408] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR45 : begin
          read_data  = mod_mul_il_y[1471:1440] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR46 : begin
          read_data  = mod_mul_il_y[1503:1472] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR47 : begin
          read_data  = mod_mul_il_y[1535:1504] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR48 : begin
          read_data  = mod_mul_il_y[1567:1536] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR49 : begin
          read_data  = mod_mul_il_y[1599:1568] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR50 : begin
          read_data  = mod_mul_il_y[1631:1600] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR51 : begin
          read_data  = mod_mul_il_y[1663:1632] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR52 : begin
          read_data  = mod_mul_il_y[1695:1664] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR53 : begin
          read_data  = mod_mul_il_y[1727:1696] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR54 : begin
          read_data  = mod_mul_il_y[1759:1728] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR55 : begin
          read_data  = mod_mul_il_y[1791:1760] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR56 : begin
          read_data  = mod_mul_il_y[1823:1792] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR57 : begin
          read_data  = mod_mul_il_y[1855:1824] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR58 : begin
          read_data  = mod_mul_il_y[1887:1856] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR59 : begin
          read_data  = mod_mul_il_y[1919:1888] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR60 : begin
          read_data  = mod_mul_il_y[1951:1920] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR61 : begin
          read_data  = mod_mul_il_y[1983:1952] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR62 : begin
          read_data  = mod_mul_il_y[2015:1984] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_MUL_ADDR63 : begin
          read_data  = mod_mul_il_y[2047:2016] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR0 : begin
          read_data  = mod_exp_y[31:0] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR1 : begin
          read_data  = mod_exp_y[63:32] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR2 : begin
          read_data  = mod_exp_y[95:64] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR3 : begin
          read_data  = mod_exp_y[127:96] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR4 : begin
          read_data  = mod_exp_y[159:128] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR5 : begin
          read_data  = mod_exp_y[191:160] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR6 : begin
          read_data  = mod_exp_y[223:192] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR7 : begin
          read_data  = mod_exp_y[255:224] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR8 : begin
          read_data  = mod_exp_y[287:256] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR9 : begin
          read_data  = mod_exp_y[319:288] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR10 : begin
          read_data  = mod_exp_y[351:320] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR11 : begin
          read_data  = mod_exp_y[383:352] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR12 : begin
          read_data  = mod_exp_y[415:384] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR13 : begin
          read_data  = mod_exp_y[447:416] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR14 : begin
          read_data  = mod_exp_y[479:448] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR15 : begin
          read_data  = mod_exp_y[511:480] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR16 : begin
          read_data  = mod_exp_y[543:512] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR17 : begin
          read_data  = mod_exp_y[575:544] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR18 : begin
          read_data  = mod_exp_y[607:576] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR19 : begin
          read_data  = mod_exp_y[639:608] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR20 : begin
          read_data  = mod_exp_y[671:640] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR21 : begin
          read_data  = mod_exp_y[703:672] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR22 : begin
          read_data  = mod_exp_y[735:704] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR23 : begin
          read_data  = mod_exp_y[767:736] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR24 : begin
          read_data  = mod_exp_y[799:768] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR25 : begin
          read_data  = mod_exp_y[831:800] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR26 : begin
          read_data  = mod_exp_y[863:832] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR27 : begin
          read_data  = mod_exp_y[895:864] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR28 : begin
          read_data  = mod_exp_y[927:896] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR29 : begin
          read_data  = mod_exp_y[959:928] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR30 : begin
          read_data  = mod_exp_y[991:960] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR31 : begin
          read_data  = mod_exp_y[1023:992] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR32 : begin
          read_data  = mod_exp_y[1055:1024] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR33 : begin
          read_data  = mod_exp_y[1087:1056] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR34 : begin
          read_data  = mod_exp_y[1119:1088] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR35 : begin
          read_data  = mod_exp_y[1151:1120] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR36 : begin
          read_data  = mod_exp_y[1183:1152] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR37 : begin
          read_data  = mod_exp_y[1215:1184] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR38 : begin
          read_data  = mod_exp_y[1247:1216] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR39 : begin
          read_data  = mod_exp_y[1279:1248] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR40 : begin
          read_data  = mod_exp_y[1311:1280] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR41 : begin
          read_data  = mod_exp_y[1343:1312] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR42 : begin
          read_data  = mod_exp_y[1375:1344] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR43 : begin
          read_data  = mod_exp_y[1407:1376] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR44 : begin
          read_data  = mod_exp_y[1439:1408] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR45 : begin
          read_data  = mod_exp_y[1471:1440] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR46 : begin
          read_data  = mod_exp_y[1503:1472] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR47 : begin
          read_data  = mod_exp_y[1535:1504] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR48 : begin
          read_data  = mod_exp_y[1567:1536] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR49 : begin
          read_data  = mod_exp_y[1599:1568] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR50 : begin
          read_data  = mod_exp_y[1631:1600] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR51 : begin
          read_data  = mod_exp_y[1663:1632] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR52 : begin
          read_data  = mod_exp_y[1695:1664] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR53 : begin
          read_data  = mod_exp_y[1727:1696] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR54 : begin
          read_data  = mod_exp_y[1759:1728] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR55 : begin
          read_data  = mod_exp_y[1791:1760] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR56 : begin
          read_data  = mod_exp_y[1823:1792] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR57 : begin
          read_data  = mod_exp_y[1855:1824] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR58 : begin
          read_data  = mod_exp_y[1887:1856] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR59 : begin
          read_data  = mod_exp_y[1919:1888] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR60 : begin
          read_data  = mod_exp_y[1951:1920] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR61 : begin
          read_data  = mod_exp_y[1983:1952] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR62 : begin
          read_data  = mod_exp_y[2015:1984] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_EXP_ADDR63 : begin
          read_data  = mod_exp_y[2047:2016] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
       GPCFG_INV_ADDR0 : begin
          read_data  = mod_inv[31:0] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR1 : begin
          read_data  = mod_inv[63:32] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR2 : begin
          read_data  = mod_inv[95:64] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR3 : begin
          read_data  = mod_inv[127:96] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR4 : begin
          read_data  = mod_inv[159:128] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR5 : begin
          read_data  = mod_inv[191:160] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR6 : begin
          read_data  = mod_inv[223:192] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR7 : begin
          read_data  = mod_inv[255:224] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR8 : begin
          read_data  = mod_inv[287:256] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR9 : begin
          read_data  = mod_inv[319:288] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR10 : begin
          read_data  = mod_inv[351:320] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR11 : begin
          read_data  = mod_inv[383:352] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR12 : begin
          read_data  = mod_inv[415:384] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR13 : begin
          read_data  = mod_inv[447:416] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR14 : begin
          read_data  = mod_inv[479:448] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR15 : begin
          read_data  = mod_inv[511:480] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR16 : begin
          read_data  = mod_inv[543:512] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR17 : begin
          read_data  = mod_inv[575:544] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR18 : begin
          read_data  = mod_inv[607:576] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR19 : begin
          read_data  = mod_inv[639:608] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR20 : begin
          read_data  = mod_inv[671:640] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR21 : begin
          read_data  = mod_inv[703:672] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR22 : begin
          read_data  = mod_inv[735:704] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR23 : begin
          read_data  = mod_inv[767:736] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR24 : begin
          read_data  = mod_inv[799:768] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR25 : begin
          read_data  = mod_inv[831:800] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR26 : begin
          read_data  = mod_inv[863:832] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR27 : begin
          read_data  = mod_inv[895:864] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR28 : begin
          read_data  = mod_inv[927:896] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR29 : begin
          read_data  = mod_inv[959:928] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR30 : begin
          read_data  = mod_inv[991:960] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR31 : begin
          read_data  = mod_inv[1023:992] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR32 : begin
          read_data  = mod_inv[1055:1024] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR33 : begin
          read_data  = mod_inv[1087:1056] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR34 : begin
          read_data  = mod_inv[1119:1088] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR35 : begin
          read_data  = mod_inv[1151:1120] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR36 : begin
          read_data  = mod_inv[1183:1152] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR37 : begin
          read_data  = mod_inv[1215:1184] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR38 : begin
          read_data  = mod_inv[1247:1216] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR39 : begin
          read_data  = mod_inv[1279:1248] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR40 : begin
          read_data  = mod_inv[1311:1280] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR41 : begin
          read_data  = mod_inv[1343:1312] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR42 : begin
          read_data  = mod_inv[1375:1344] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR43 : begin
          read_data  = mod_inv[1407:1376] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR44 : begin
          read_data  = mod_inv[1439:1408] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR45 : begin
          read_data  = mod_inv[1471:1440] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR46 : begin
          read_data  = mod_inv[1503:1472] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR47 : begin
          read_data  = mod_inv[1535:1504] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR48 : begin
          read_data  = mod_inv[1567:1536] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR49 : begin
          read_data  = mod_inv[1599:1568] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR50 : begin
          read_data  = mod_inv[1631:1600] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR51 : begin
          read_data  = mod_inv[1663:1632] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR52 : begin
          read_data  = mod_inv[1695:1664] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR53 : begin
          read_data  = mod_inv[1727:1696] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR54 : begin
          read_data  = mod_inv[1759:1728] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR55 : begin
          read_data  = mod_inv[1791:1760] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR56 : begin
          read_data  = mod_inv[1823:1792] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR57 : begin
          read_data  = mod_inv[1855:1824] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR58 : begin
          read_data  = mod_inv[1887:1856] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR59 : begin
          read_data  = mod_inv[1919:1888] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR60 : begin
          read_data  = mod_inv[1951:1920] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR61 : begin
          read_data  = mod_inv[1983:1952] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR62 : begin
          read_data  = mod_inv[2015:1984] & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG_INV_ADDR63 : begin
          read_data  = mod_inv[2047:2016] & {32{valid_rd}};
          dec_err    = 1'b0;
        end


        default      : begin
          read_data  = 32'b0;
          dec_err    = 1'b1;
        end
      endcase
    end
    else begin
      read_data = 32'b0;
      dec_err    = 1'b0;
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

//----------------------------
// Logic for write data
//----------------------------

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
  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin                                     //                      OEN       REN        Pull     Drive     Override
      pad03_ctl_reg     <= 32'h16;            //PAD03_CTL  UARTM_TX 0000_0000_0000_0001_0110, Enabled   Enabled     Pull Up,   4mA,     Disabled
      pad04_ctl_reg     <= 32'h17;            //PAD04_CTL  UARTM_RX 0000_0000_0000_0001_0111  Disabled  Enabled     Pull Up,   4ma,     Disabled
      pad05_ctl_reg     <= 32'h10_0017;       //PAD05_CTL  UARTS_TX 0001_0000_0000_0001_0111  Disabled  Enabled     Pull Up,   4mA,     Enabled
      pad06_ctl_reg     <= 32'h10_0017;       //PAD06_CTL  UARTS_RX 0001_0000_0000_0001_0111  Disabled  Enabled     Pull Up,   4mA,     Enabled
      pad07_ctl_reg     <= 32'h10_001B;       //PAD07_CTL  GPIO0    0001_0000_0000_0001_1011  Disabled  Enabled     Pull Down, 4mA,     Enabled
      pad08_ctl_reg     <= 32'h10_001B;       //PAD08_CTL  GPIO1    0001_0000_0000_0001_1011  Disabled  Enabled     Pull Down, 4mA,     Enabled
      pad09_ctl_reg     <= 32'h10_001B;       //PAD09_CTL  GPIO2    0001_0000_0000_0001_1011  Disabled  Enabled     Pull Down, 4mA,     Enabled
      pad10_ctl_reg     <= 32'h10_001B;       //PAD10_CTL  GPIO3    0001_0000_0000_0001_1011  Disabled  Enabled     Pull Down, 4mA,     Enabled
      pad11_ctl_reg     <= 32'h10_001B;       //PAD11_CTL
      pad12_ctl_reg     <= 32'h10_001B;       //PAD12_CTL
      pad13_ctl_reg     <= 32'h10_001B;       //PAD13_CTL
      pad14_ctl_reg     <= 32'h10_001B;       //PAD14_CTL
      pad15_ctl_reg     <= 32'h10_001B;       //PAD15_CTL
      pad16_ctl_reg     <= 32'h10_001B;       //PAD16_CTL
      pad17_ctl_reg     <= 32'h10_001B;       //PAD17_CTL
      pad18_ctl_reg     <= 32'h10_001B;       //PAD18_CTL
      pad19_ctl_reg     <= 32'h10_001B;       //PAD19_CTL

      uartm_baud_ctl_reg     <= 32'd2500;          //UARTM_BAUD Reset value for master clock of 24 Mhz and baud rate of 9600
      uartm_ctl_reg          <= 32'h0;             //UARTM_CTL
      uarts_baud_ctl_reg     <= 32'h9C4;           //UARTS_BAUD Reset value for master clock of 24 Mhz and baud rate of 9600
      uarts_ctl_reg          <= 32'h0;             //UARTS_CTL
      uarts_tx_data_reg      <= 32'h0;             //UARTS_TXDATA
      //gpcfg37_reg          <= 32'h0;             //UARTS_RXDATA
      uarts_tx_send_reg      <= 32'h0;             //UARTS_TX_SEND
      spare0_reg             <= 32'h0;             //SPARE0
      spare1_reg             <= 32'h0;             //SPARE1
      spare2_reg             <= 32'hFFFF_FFFF;     //SPARE2
      spare3_reg             <= 32'hFFFF_FFFF;     //SPARE3
      signature_reg          <= 32'h0CC5_0101;     //SIGNATURE  0x0CC50001
      cleq_ctl_reg           <= 32'h0;
      cleq_maxbits_reg       <= 32'h7FF;
      //gpcfg_clstatus_reg   <= 32'h0;
      cleq_n_reg             <= 1024'd0;
      cleq_rand_reg          <= 1024'd0;
      cleq_nsq_reg           <= 2048'd0;
      gpcfg_fkf_reg          <= 2048'd0;
      cleq_arga_reg          <= 2048'd0;
      cleq_argb_reg          <= 2048'd0;
      cleq_argc_reg          <= 2048'd0;
      gpcfg_t_reg            <= 1024'd0;
      gpcfg_s_reg            <= 1024'd0;
      cleq_pc_reg            <= 2048'd0;
    end
    else if (valid_wr_lat == 1'b1) begin // (
      if (haddr_lat[15:2] == GPCFG0_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          pad03_ctl_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          pad03_ctl_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          pad03_ctl_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          pad03_ctl_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG1_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          pad04_ctl_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          pad04_ctl_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          pad04_ctl_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          pad04_ctl_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG2_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          pad05_ctl_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          pad05_ctl_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          pad05_ctl_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          pad05_ctl_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG3_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          pad06_ctl_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          pad06_ctl_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          pad06_ctl_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          pad06_ctl_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG4_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          pad07_ctl_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          pad07_ctl_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          pad07_ctl_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          pad07_ctl_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG5_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          pad08_ctl_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          pad08_ctl_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          pad08_ctl_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          pad08_ctl_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG6_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          pad09_ctl_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          pad09_ctl_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          pad09_ctl_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          pad09_ctl_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG7_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          pad10_ctl_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          pad10_ctl_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          pad10_ctl_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          pad10_ctl_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG8_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          pad11_ctl_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          pad11_ctl_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          pad11_ctl_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          pad11_ctl_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG9_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          pad12_ctl_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          pad12_ctl_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          pad12_ctl_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          pad12_ctl_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG10_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          pad13_ctl_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          pad13_ctl_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          pad13_ctl_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          pad13_ctl_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG11_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          pad14_ctl_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          pad14_ctl_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          pad14_ctl_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          pad14_ctl_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG12_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          pad15_ctl_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          pad15_ctl_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          pad15_ctl_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          pad15_ctl_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG13_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          pad16_ctl_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          pad16_ctl_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          pad16_ctl_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          pad16_ctl_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG14_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          pad17_ctl_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          pad17_ctl_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          pad17_ctl_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          pad17_ctl_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG15_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          pad18_ctl_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          pad18_ctl_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          pad18_ctl_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          pad18_ctl_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG16_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          pad19_ctl_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          pad19_ctl_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          pad19_ctl_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          pad19_ctl_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG17_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          uartm_baud_ctl_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          uartm_baud_ctl_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          uartm_baud_ctl_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          uartm_baud_ctl_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG18_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          uartm_ctl_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          uartm_ctl_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          uartm_ctl_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          uartm_ctl_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG34_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          uarts_baud_ctl_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          uarts_baud_ctl_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          uarts_baud_ctl_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          uarts_baud_ctl_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG35_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          uarts_ctl_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          uarts_ctl_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          uarts_ctl_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          uarts_ctl_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG36_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          uarts_tx_data_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          uarts_tx_data_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          uarts_tx_data_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          uarts_tx_data_reg[31:24] <= hwdata[31:24];
        end
      end
      //if (haddr_lat[15:2] == GPCFG37_ADDR) begin
      //  if (wbyte_en_lat[0] == 1'b1) begin
      //    gpcfg37_reg[7:0] <= hwdata[7:0];
      //  end
      //  if (wbyte_en_lat[1] == 1'b1) begin
      //    gpcfg37_reg[15:8] <= hwdata[15:8];
      //  end
      //  if (wbyte_en_lat[2] == 1'b1) begin
      //    gpcfg37_reg[23:16] <= hwdata[23:16];
      //  end
      //  if (wbyte_en_lat[3] == 1'b1) begin
      //    gpcfg37_reg[31:24] <= hwdata[31:24];
      //  end
      //end
      if (haddr_lat[15:2] == GPCFG38_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          uarts_tx_send_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          uarts_tx_send_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          uarts_tx_send_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          uarts_tx_send_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG39_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          spare0_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          spare0_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          spare0_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          spare0_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG40_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          spare1_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          spare1_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          spare1_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          spare1_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG41_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          spare2_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          spare2_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          spare2_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          spare2_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG42_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          spare3_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          spare3_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          spare3_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          spare3_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_CLCTL_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_ctl_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_ctl_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_ctl_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_ctl_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_CLMAXBITS_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_maxbits_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_maxbits_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_maxbits_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_maxbits_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR0) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR1) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[39:32] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[47:40] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[55:48] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[63:56] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR2) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[71:64] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[79:72] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[87:80] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[95:88] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR3) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[103:96] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[111:104] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[119:112] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[127:120] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR4) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[135:128] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[143:136] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[151:144] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[159:152] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR5) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[167:160] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[175:168] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[183:176] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[191:184] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR6) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[199:192] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[207:200] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[215:208] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[223:216] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR7) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[231:224] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[239:232] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[247:240] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[255:248] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR8) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[263:256] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[271:264] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[279:272] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[287:280] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR9) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[295:288] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[303:296] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[311:304] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[319:312] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR10) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[327:320] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[335:328] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[343:336] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[351:344] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR11) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[359:352] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[367:360] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[375:368] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[383:376] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR12) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[391:384] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[399:392] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[407:400] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[415:408] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR13) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[423:416] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[431:424] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[439:432] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[447:440] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR14) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[455:448] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[463:456] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[471:464] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[479:472] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR15) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[487:480] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[495:488] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[503:496] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[511:504] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR16) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[519:512] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[527:520] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[535:528] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[543:536] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR17) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[551:544] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[559:552] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[567:560] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[575:568] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR18) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[583:576] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[591:584] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[599:592] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[607:600] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR19) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[615:608] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[623:616] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[631:624] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[639:632] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR20) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[647:640] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[655:648] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[663:656] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[671:664] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR21) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[679:672] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[687:680] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[695:688] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[703:696] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR22) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[711:704] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[719:712] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[727:720] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[735:728] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR23) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[743:736] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[751:744] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[759:752] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[767:760] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR24) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[775:768] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[783:776] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[791:784] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[799:792] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR25) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[807:800] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[815:808] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[823:816] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[831:824] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR26) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[839:832] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[847:840] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[855:848] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[863:856] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR27) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[871:864] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[879:872] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[887:880] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[895:888] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR28) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[903:896] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[911:904] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[919:912] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[927:920] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR29) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[935:928] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[943:936] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[951:944] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[959:952] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR30) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[967:960] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[975:968] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[983:976] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[991:984] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_N_ADDR31) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_n_reg[999:992] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_n_reg[1007:1000] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_n_reg[1015:1008] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_n_reg[1023:1016] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR0) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR1) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[39:32] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[47:40] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[55:48] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[63:56] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR2) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[71:64] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[79:72] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[87:80] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[95:88] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR3) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[103:96] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[111:104] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[119:112] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[127:120] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR4) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[135:128] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[143:136] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[151:144] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[159:152] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR5) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[167:160] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[175:168] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[183:176] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[191:184] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR6) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[199:192] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[207:200] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[215:208] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[223:216] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR7) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[231:224] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[239:232] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[247:240] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[255:248] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR8) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[263:256] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[271:264] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[279:272] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[287:280] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR9) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[295:288] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[303:296] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[311:304] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[319:312] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR10) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[327:320] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[335:328] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[343:336] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[351:344] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR11) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[359:352] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[367:360] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[375:368] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[383:376] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR12) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[391:384] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[399:392] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[407:400] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[415:408] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR13) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[423:416] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[431:424] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[439:432] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[447:440] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR14) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[455:448] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[463:456] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[471:464] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[479:472] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR15) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[487:480] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[495:488] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[503:496] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[511:504] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR16) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[519:512] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[527:520] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[535:528] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[543:536] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR17) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[551:544] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[559:552] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[567:560] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[575:568] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR18) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[583:576] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[591:584] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[599:592] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[607:600] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR19) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[615:608] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[623:616] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[631:624] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[639:632] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR20) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[647:640] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[655:648] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[663:656] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[671:664] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR21) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[679:672] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[687:680] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[695:688] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[703:696] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR22) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[711:704] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[719:712] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[727:720] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[735:728] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR23) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[743:736] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[751:744] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[759:752] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[767:760] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR24) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[775:768] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[783:776] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[791:784] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[799:792] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR25) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[807:800] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[815:808] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[823:816] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[831:824] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR26) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[839:832] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[847:840] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[855:848] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[863:856] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR27) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[871:864] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[879:872] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[887:880] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[895:888] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR28) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[903:896] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[911:904] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[919:912] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[927:920] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR29) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[935:928] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[943:936] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[951:944] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[959:952] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR30) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[967:960] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[975:968] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[983:976] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[991:984] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_R_ADDR31) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_rand_reg[999:992] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_rand_reg[1007:1000] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_rand_reg[1015:1008] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_rand_reg[1023:1016] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR0) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR1) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[39:32] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[47:40] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[55:48] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[63:56] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR2) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[71:64] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[79:72] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[87:80] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[95:88] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR3) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[103:96] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[111:104] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[119:112] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[127:120] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR4) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[135:128] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[143:136] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[151:144] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[159:152] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR5) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[167:160] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[175:168] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[183:176] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[191:184] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR6) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[199:192] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[207:200] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[215:208] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[223:216] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR7) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[231:224] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[239:232] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[247:240] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[255:248] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR8) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[263:256] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[271:264] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[279:272] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[287:280] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR9) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[295:288] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[303:296] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[311:304] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[319:312] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR10) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[327:320] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[335:328] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[343:336] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[351:344] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR11) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[359:352] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[367:360] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[375:368] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[383:376] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR12) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[391:384] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[399:392] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[407:400] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[415:408] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR13) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[423:416] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[431:424] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[439:432] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[447:440] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR14) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[455:448] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[463:456] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[471:464] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[479:472] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR15) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[487:480] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[495:488] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[503:496] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[511:504] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR16) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[519:512] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[527:520] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[535:528] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[543:536] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR17) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[551:544] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[559:552] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[567:560] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[575:568] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR18) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[583:576] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[591:584] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[599:592] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[607:600] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR19) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[615:608] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[623:616] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[631:624] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[639:632] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR20) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[647:640] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[655:648] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[663:656] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[671:664] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR21) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[679:672] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[687:680] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[695:688] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[703:696] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR22) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[711:704] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[719:712] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[727:720] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[735:728] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR23) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[743:736] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[751:744] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[759:752] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[767:760] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR24) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[775:768] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[783:776] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[791:784] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[799:792] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR25) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[807:800] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[815:808] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[823:816] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[831:824] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR26) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[839:832] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[847:840] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[855:848] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[863:856] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR27) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[871:864] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[879:872] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[887:880] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[895:888] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR28) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[903:896] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[911:904] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[919:912] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[927:920] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR29) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[935:928] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[943:936] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[951:944] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[959:952] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR30) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[967:960] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[975:968] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[983:976] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[991:984] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR31) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[999:992] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1007:1000] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1015:1008] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1023:1016] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR32) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1031:1024] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1039:1032] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1047:1040] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1055:1048] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR33) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1063:1056] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1071:1064] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1079:1072] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1087:1080] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR34) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1095:1088] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1103:1096] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1111:1104] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1119:1112] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR35) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1127:1120] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1135:1128] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1143:1136] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1151:1144] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR36) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1159:1152] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1167:1160] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1175:1168] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1183:1176] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR37) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1191:1184] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1199:1192] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1207:1200] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1215:1208] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR38) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1223:1216] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1231:1224] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1239:1232] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1247:1240] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR39) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1255:1248] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1263:1256] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1271:1264] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1279:1272] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR40) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1287:1280] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1295:1288] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1303:1296] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1311:1304] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR41) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1319:1312] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1327:1320] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1335:1328] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1343:1336] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR42) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1351:1344] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1359:1352] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1367:1360] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1375:1368] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR43) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1383:1376] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1391:1384] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1399:1392] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1407:1400] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR44) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1415:1408] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1423:1416] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1431:1424] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1439:1432] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR45) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1447:1440] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1455:1448] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1463:1456] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1471:1464] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR46) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1479:1472] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1487:1480] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1495:1488] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1503:1496] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR47) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1511:1504] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1519:1512] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1527:1520] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1535:1528] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR48) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1543:1536] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1551:1544] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1559:1552] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1567:1560] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR49) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1575:1568] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1583:1576] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1591:1584] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1599:1592] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR50) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1607:1600] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1615:1608] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1623:1616] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1631:1624] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR51) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1639:1632] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1647:1640] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1655:1648] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1663:1656] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR52) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1671:1664] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1679:1672] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1687:1680] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1695:1688] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR53) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1703:1696] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1711:1704] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1719:1712] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1727:1720] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR54) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1735:1728] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1743:1736] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1751:1744] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1759:1752] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR55) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1767:1760] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1775:1768] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1783:1776] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1791:1784] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR56) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1799:1792] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1807:1800] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1815:1808] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1823:1816] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR57) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1831:1824] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1839:1832] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1847:1840] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1855:1848] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR58) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1863:1856] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1871:1864] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1879:1872] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1887:1880] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR59) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1895:1888] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1903:1896] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1911:1904] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1919:1912] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR60) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1927:1920] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1935:1928] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1943:1936] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1951:1944] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR61) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1959:1952] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1967:1960] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[1975:1968] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[1983:1976] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR62) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[1991:1984] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[1999:1992] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[2007:2000] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[2015:2008] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_NSQ_ADDR63) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          cleq_nsq_reg[2023:2016] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          cleq_nsq_reg[2031:2024] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          cleq_nsq_reg[2039:2032] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          cleq_nsq_reg[2047:2040] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR0) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR1) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[39:32] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[47:40] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[55:48] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[63:56] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR2) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[71:64] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[79:72] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[87:80] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[95:88] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR3) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[103:96] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[111:104] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[119:112] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[127:120] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR4) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[135:128] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[143:136] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[151:144] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[159:152] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR5) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[167:160] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[175:168] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[183:176] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[191:184] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR6) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[199:192] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[207:200] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[215:208] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[223:216] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR7) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[231:224] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[239:232] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[247:240] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[255:248] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR8) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[263:256] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[271:264] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[279:272] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[287:280] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR9) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[295:288] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[303:296] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[311:304] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[319:312] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR10) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[327:320] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[335:328] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[343:336] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[351:344] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR11) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[359:352] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[367:360] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[375:368] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[383:376] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR12) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[391:384] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[399:392] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[407:400] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[415:408] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR13) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[423:416] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[431:424] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[439:432] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[447:440] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR14) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[455:448] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[463:456] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[471:464] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[479:472] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR15) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[487:480] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[495:488] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[503:496] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[511:504] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR16) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[519:512] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[527:520] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[535:528] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[543:536] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR17) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[551:544] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[559:552] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[567:560] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[575:568] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR18) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[583:576] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[591:584] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[599:592] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[607:600] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR19) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[615:608] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[623:616] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[631:624] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[639:632] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR20) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[647:640] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[655:648] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[663:656] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[671:664] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR21) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[679:672] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[687:680] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[695:688] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[703:696] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR22) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[711:704] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[719:712] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[727:720] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[735:728] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR23) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[743:736] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[751:744] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[759:752] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[767:760] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR24) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[775:768] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[783:776] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[791:784] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[799:792] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR25) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[807:800] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[815:808] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[823:816] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[831:824] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR26) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[839:832] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[847:840] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[855:848] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[863:856] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR27) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[871:864] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[879:872] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[887:880] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[895:888] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR28) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[903:896] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[911:904] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[919:912] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[927:920] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR29) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[935:928] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[943:936] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[951:944] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[959:952] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR30) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[967:960] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[975:968] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[983:976] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[991:984] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR31) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[999:992] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1007:1000] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1015:1008] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1023:1016] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR32) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1031:1024] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1039:1032] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1047:1040] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1055:1048] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR33) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1063:1056] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1071:1064] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1079:1072] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1087:1080] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR34) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1095:1088] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1103:1096] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1111:1104] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1119:1112] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR35) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1127:1120] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1135:1128] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1143:1136] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1151:1144] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR36) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1159:1152] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1167:1160] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1175:1168] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1183:1176] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR37) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1191:1184] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1199:1192] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1207:1200] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1215:1208] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR38) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1223:1216] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1231:1224] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1239:1232] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1247:1240] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR39) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1255:1248] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1263:1256] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1271:1264] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1279:1272] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR40) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1287:1280] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1295:1288] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1303:1296] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1311:1304] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR41) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1319:1312] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1327:1320] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1335:1328] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1343:1336] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR42) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1351:1344] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1359:1352] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1367:1360] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1375:1368] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR43) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1383:1376] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1391:1384] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1399:1392] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1407:1400] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR44) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1415:1408] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1423:1416] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1431:1424] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1439:1432] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR45) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1447:1440] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1455:1448] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1463:1456] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1471:1464] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR46) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1479:1472] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1487:1480] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1495:1488] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1503:1496] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR47) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1511:1504] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1519:1512] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1527:1520] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1535:1528] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR48) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1543:1536] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1551:1544] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1559:1552] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1567:1560] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR49) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1575:1568] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1583:1576] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1591:1584] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1599:1592] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR50) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1607:1600] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1615:1608] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1623:1616] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1631:1624] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR51) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1639:1632] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1647:1640] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1655:1648] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1663:1656] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR52) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1671:1664] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1679:1672] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1687:1680] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1695:1688] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR53) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1703:1696] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1711:1704] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1719:1712] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1727:1720] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR54) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1735:1728] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1743:1736] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1751:1744] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1759:1752] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR55) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1767:1760] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1775:1768] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1783:1776] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1791:1784] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR56) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1799:1792] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1807:1800] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1815:1808] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1823:1816] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR57) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1831:1824] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1839:1832] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1847:1840] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1855:1848] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR58) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1863:1856] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1871:1864] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1879:1872] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1887:1880] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR59) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1895:1888] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1903:1896] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1911:1904] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1919:1912] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR60) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1927:1920] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1935:1928] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1943:1936] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1951:1944] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR61) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1959:1952] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1967:1960] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[1975:1968] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[1983:1976] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR62) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[1991:1984] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[1999:1992] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[2007:2000] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[2015:2008] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:2] == GPCFG_FKF_ADDR63) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg_fkf_reg[2023:2016] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg_fkf_reg[2031:2024] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg_fkf_reg[2039:2032] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg_fkf_reg[2047:2040] <= hwdata[31:24];
        end
      end


    end // )
    else begin
      uarts_tx_send_reg     <= 32'h0;             //UARTS_TX_SEND
      cleq_ctl_reg <= 32'b0;
    end
  end

//------------------------------------
// Logic to generate hresp and hready
//------------------------------------
   
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
 

  
  assign n       = cleq_maxbits_reg[16] ? 1024'b0 : cleq_n_reg;
  assign nsq     = cleq_maxbits_reg[16] ? 2048'b0 : cleq_nsq_reg;
  assign arg_a   = cleq_arga_reg;
  assign arg_b   = cleq_argb_reg;
  assign modulus = cleq_maxbits_reg[17] ? nsq : {1024'b0, n};

  assign maxbits      = cleq_maxbits_reg[10:0];
  assign r_egcd       = 1'b1 << maxbits;
  assign r_red_extgcd = r_egcd - modulus;

  assign bypass_vn = cleq_maxbits_reg[24];

  assign enable_p_mod_mul_il       = cleq_ctl_reg[0];
  assign enable_p_mod_exp          = cleq_ctl_reg[8];
  assign enable_p_bin_ext_gcd      = cleq_ctl_reg[16];
  assign enable_p_rng              = cleq_ctl_reg[24];

  assign exp     = arg_b;  //TODO



  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      cl_busy   <= 1'b0;
    end
    else if (enable_p_mod_mul_il | enable_p_mod_exp | enable_p_bin_ext_gcd) begin
      cl_busy  <= 1'b1;
    end
    else if (done_irq_p_mod_mul_il | done_irq_p_mod_exp | done_irq_p_bin_ext_gcd) begin
      cl_busy  <= 1'b0;
    end
  end

  
  
  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      cl_inverr   <= 1'b0;
    end
    else if (done_irq_p_bin_ext_gcd) begin
      if (gcd == 2048'b1) begin
        cl_inverr   <= 1'b0;
      end
      else begin
        cl_inverr   <= 1'b1;
      end
    end
  end
  
  
  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      mod_inv   <= 2048'b0;
    end
    else if (done_irq_p_bin_ext_gcd) begin
      if (x[2048] == 1'b1) begin  //If negative
        mod_inv   <= x + modulus;   
      end
      else begin
        mod_inv   <= x;
      end
    end
  end
 
  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      r_hw   <= 2048'b0;
    end
    else if (done_irq_p_rng) begin
      r_hw   <= rng_y;   
    end
  end


 //Check if random number is co-prime with n
  localparam RNG_IDLE  = 2'b00;
  localparam GCD_CALC  = 2'b01;
  localparam GCD_CHECK = 2'b01;
  localparam RNG_REGEN = 2'b01;
  reg [1:0] rng_curr_state;
  reg [1:0] rng_nxt_state;

  always @* begin
    case (rng_curr_state) begin
      RNG_IDLE :  begin
        if (done_irq_p_rng) begin
          rng_nxt_state = GCD_CALC;
        end
        else begin
          rng_nxt_state = IDLE;
        end
      end
      GCD_CALC :  begin
        if (done_irq_p_bin_ext_gcd) begin
          rng_nxt_state = GCD_CHECK;
        end
        else begin
          rng_nxt_state = GCD_CALC;
        end
      end
      GCD_CHECK :  begin
        if (cl_inverr == 1'b1) begin
          rng_nxt_state = RNG_REGEN;
        end
        else begin
          rng_nxt_state = IDLE;
        end
      end
      RNG_REGEN :  begin
        if (done_irq_p_rng) begin
          rng_nxt_state = GCD_CALC;
        end
        else begin
          rng_nxt_state = RNG_REGEN;
        end
      end
    endcase
  end



endmodule
