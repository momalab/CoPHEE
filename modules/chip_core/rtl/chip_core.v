module chip_core #(
  parameter NUM_PADS  = 11,
  parameter PAD_CTL_W = 9,
  parameter NBITS     = 2048
  )(
  output wire [NUM_PADS-1  :3]  pad_in,
  input  wire [NUM_PADS-1  :0]  pad_out,
  output wire [PAD_CTL_W-1 :0]  pad_ctl[NUM_PADS-1   :3]

);


//----------------------------------------------
//localparameter,genvar and reg/wire delcaration
//----------------------------------------------

  localparam NUM_MASTERS = 2;
  localparam NUM_SLAVES  = 2;

  localparam SPI_M_ID    = 0;
  localparam UARTM_M_ID  = 1;

  localparam GPCFG_S_ID  = 0;
  localparam GPIO_S_ID   = 1;

  localparam GPCFG_BASE  = 32'h4002_0000;
  localparam GPIO_BASE   = 32'h4003_0000;


wire        hclk;
wire        nreset;

wire        nreset_sync;
reg         nreset_sync0;
reg         nreset_sync1;
reg         nreset_sync2;

wire [1:0]  htrans_m0;
wire [31:0] haddr_m0;
wire [2:0]  hsize_m0;
wire [31:0] hwdata_m0;
wire [31:0] hrdata_m0;
wire [31:0] hrdata_gpcfg;
wire [31:0] hrdata_sram_wrap;

wire [31:0] gpcfg_reg[63:0];

wire [ 1:0] htrans_m[NUM_MASTERS-1 :0];      // AHB transfer: non-sequential only
wire [31:0] haddr_m[NUM_MASTERS-1 :0];       // AHB transaction address
wire [ 2:0] hsize_m[NUM_MASTERS-1 :0];       // AHB size: byte, half-word or word
wire [31:0] hwdata_m[NUM_MASTERS-1 :0];      // AHB write-data
wire        hwrite_m[NUM_MASTERS-1 :0];      // AHB write control
wire [31:0] hrdata_m[NUM_MASTERS-1 :0];      // AHB read-data
wire        hready_m[NUM_MASTERS-1 :0];      // AHB stall signal
wire        hresp_m[NUM_MASTERS-1 :0];       // AHB error response
wire        hsel_s[NUM_SLAVES-1 :0];         // AHB transfer: non-sequential only
wire [31:0] haddr_s[NUM_SLAVES-1 :0];        // AHB transaction address
wire [ 2:0] hsize_s[NUM_SLAVES-1 :0];        // AHB size: byte, half-word or word
wire        hwrite_s[NUM_SLAVES-1 :0];       // AHB write control
wire [31:0] hwdata_s[NUM_SLAVES-1 :0];       // AHB write-data
wire [31:0] hrdata_s[NUM_SLAVES-1 :0];       // AHB read-data
wire        hready_s[NUM_SLAVES-1 :0];       // AHB stall signal
wire        hresp_s[NUM_SLAVES-1 :0];        // AHB error response

wire        gpio_irq;
wire [3:0]  gpio_out;
wire [3:0]  gpio_in;

wire [31:0] uarts_rx_data;

wire enable_p_mod_mul_il;
wire enable_p_bin_ext_gcd;
wire done_irq_p_mod_mul_il;
wire done_irq_p_bin_ext_gcd;
wire [11:0]    maxbits;
wire [NBITS-1:0]  arg_a;
wire [NBITS-1:0]  arg_b;
wire [NBITS-1:0]  arg_b_mod_inv;
wire [NBITS-1:0]  modulus;
wire [NBITS-1:0]  mod_mul_il_y;
wire [NBITS+2:0]  x;
//wire [2048:0]  y;
wire [NBITS-1:0]  gcd;
wire [NBITS/2 -1:0]  rng0_y;
wire [NBITS/2 -1:0]  rng1_y;



uartm u_uartm_inst (
  .hclk        (hclk),                  //input  wire            // Clock
  .hresetn     (nreset_sync),             //input  wire            // Asynchronous reset
  .haddr       (haddr_m[UARTM_M_ID]),  //output reg  [31:0]     // AHB transaction address
  .hsize       (hsize_m[UARTM_M_ID]),  //output wire [ 2:0]     // AHB size: byte, half-word or word
  .htrans      (htrans_m[UARTM_M_ID]), //output reg  [ 1:0]     // AHB transfer: non-sequential only
  .hwdata      (hwdata_m[UARTM_M_ID]), //output reg  [31:0]     // AHB write-data
  .hwrite      (hwrite_m[UARTM_M_ID]), //output reg             // AHB write control
  .hrdata      (hrdata_m[UARTM_M_ID]), //input  wire [31:0]     // AHB read-data
  .hready      (hready_m[UARTM_M_ID]), //input  wire            // AHB stall signal
  .hresp       (hresp_m[UARTM_M_ID]),  //input  wire            // AHB error response
  .uartm_baud  (gpcfg_reg[17]),         //input  wire [31:0] 
  .uartm_ctl   (gpcfg_reg[18]),         //input  wire [31:0]   //1:0 : 00 => 8 bit, 01 => 16 bit, 10 => 32 bit, 11 => 8 bit
  .TX          (uartm_tx),            //output wire          // Event output (SEV executed)
  .RX          (uartm_rx)            //input  wire          // Event input
);


uartm u_spis_inst (
  .hclk        (hclk),                  //input  wire            // Clock
  .hresetn     (nreset_sync),             //input  wire            // Asynchronous reset
  .haddr       (haddr_m[SPI_M_ID]),  //output reg  [31:0]     // AHB transaction address
  .hsize       (hsize_m[SPI_M_ID]),  //output wire [ 2:0]     // AHB size: byte, half-word or word
  .htrans      (htrans_m[SPI_M_ID]), //output reg  [ 1:0]     // AHB transfer: non-sequential only
  .hwdata      (hwdata_m[SPI_M_ID]), //output reg  [31:0]     // AHB write-data
  .hwrite      (hwrite_m[SPI_M_ID]), //output reg             // AHB write control
  .hrdata      (hrdata_m[SPI_M_ID]), //input  wire [31:0]     // AHB read-data
  .hready      (hready_m[SPI_M_ID]), //input  wire            // AHB stall signal
  .hresp       (hresp_m[SPI_M_ID]),  //input  wire            // AHB error response
  .uartm_baud  (gpcfg_reg[17]),         //input  wire [31:0] 
  .uartm_ctl   (gpcfg_reg[18]),         //input  wire [31:0]   //1:0 : 00 => 8 bit, 01 => 16 bit, 10 => 32 bit, 11 => 8 bit
  .TX          (),            //output wire          // Event output (SEV executed)
  .RX          (1'b1)            //input  wire          // Event input
);




ahb_ic #(
  .NUM_SLAVES  (NUM_SLAVES),
  .NUM_MASTERS (NUM_MASTERS),
  .SLAVE_BASE  ( {GPIO_BASE,
                  GPCFG_BASE})
  ) u_ahb_ic_inst (  
  .hclk      (hclk),                              //input  wire          Clock
  .hresetn   (nreset_sync),                         //input  wire          Asynchronous reset
  .htrans_m  (htrans_m),      //input   wire [ 1:0]  AHB transfer: non-sequential only
  .haddr_m   (haddr_m),       //input   wire [31:0]  AHB transaction address
  .hsize_m   (hsize_m),       //input   wire [ 2:0]  AHB size: byte, half-word or word
  .hwdata_m  (hwdata_m),      //input   wire [31:0]  AHB write-data
  .hwrite_m  (hwrite_m),      //input   wire         AHB write control
  .hrdata_m  (hrdata_m),      //output  reg  [31:0]  AHB read-data
  .hready_m  (hready_m),      //output  reg          AHB stall signal
  .hresp_m   (hresp_m),       //output  reg          AHB error response
  .hsel_s    (hsel_s),         //output  reg  [ 1:0]  AHB transfer: non-sequential only
  .haddr_s   (haddr_s),        //output  reg  [31:0]  AHB transaction address
  .hsize_s   (hsize_s),        //output  reg  [ 2:0]  AHB size: byte, half-word or word
  .hwrite_s  (hwrite_s),       //output  reg          AHB write control
  .hwdata_s  (hwdata_s),       //output  reg  [31:0]  AHB write-data
  .hrdata_s  (hrdata_s),       //input   reg  [31:0]  AHB read-data
  .hready_s  (hready_s),       //input   reg          AHB stall signal
  .hresp_s   (hresp_s)         //input   reg          AHB error response
);




gpcfg   #(
  .NBITS (NBITS)) u_gpcfg_inst (
  .hclk                     (hclk),              //input  wire          Clock
  .hresetn                  (nreset_sync),         //input  wire          Asynchronous reset
  .hsel                     (hsel_s[GPCFG_S_ID]),       //input   wire [ 1:0]  AHB transfer: non-sequential only
  .haddr                    (haddr_s[GPCFG_S_ID]),      //input   wire [31:0]  AHB transaction address
  .hsize                    (hsize_s[GPCFG_S_ID]),      //input   wire [ 2:0]  AHB size: byte, half-word or word
  .hwdata                   (hwdata_s[GPCFG_S_ID]),     //input   wire [31:0]  AHB write-data
  .hwrite                   (hwrite_s[GPCFG_S_ID]),     //input   wire         AHB write control
  .hrdata                   (hrdata_s[GPCFG_S_ID]),     //output  reg  [31:0]  AHB read-data
  .hready                   (hready_s[GPCFG_S_ID]),     //output  wire         AHB stall signal
  .hresp                    (hresp_s[GPCFG_S_ID]),      //output  wire         AHB error response
  .pad03_ctl_reg            (gpcfg_reg[0]),     //output  reg  [31:0] 
  .pad04_ctl_reg            (gpcfg_reg[1]),     //output  reg  [31:0] 
  .pad05_ctl_reg            (gpcfg_reg[2]),     //output  reg  [31:0] 
  .pad06_ctl_reg            (gpcfg_reg[3]),     //output  reg  [31:0] 
  .pad07_ctl_reg            (gpcfg_reg[4]),     //output  reg  [31:0] 
  .pad08_ctl_reg            (gpcfg_reg[5]),     //output  reg  [31:0] 
  .pad09_ctl_reg            (gpcfg_reg[6]),     //output  reg  [31:0] 
  .pad10_ctl_reg            (gpcfg_reg[7]),     //output  reg  [31:0] 
  .pad11_ctl_reg            (gpcfg_reg[8]),     //output  reg  [31:0] 
  .pad12_ctl_reg            (gpcfg_reg[9]),     //output  reg  [31:0] 
  .pad13_ctl_reg            (gpcfg_reg[10]),     //output  reg  [31:0] 
  .pad14_ctl_reg            (gpcfg_reg[11]),     //output  reg  [31:0] 
  .pad15_ctl_reg            (gpcfg_reg[12]),     //output  reg  [31:0] 
  .pad16_ctl_reg            (gpcfg_reg[13]),     //output  reg  [31:0] 
  .pad17_ctl_reg            (gpcfg_reg[14]),     //output  reg  [31:0] 
  .pad18_ctl_reg            (gpcfg_reg[15]),     //output  reg  [31:0] 
  .pad19_ctl_reg            (gpcfg_reg[16]),     //output  reg  [31:0] 
  .uartm_baud_ctl_reg       (gpcfg_reg[17]),     //output  reg  [31:0] 
  .uartm_ctl_reg            (gpcfg_reg[18]),     //output  reg  [31:0] 
  .uarts_baud_ctl_reg       (gpcfg_reg[34]),    //output  reg  [31:0] 
  .uarts_ctl_reg            (gpcfg_reg[35]),    //output  reg  [31:0] 
  .uarts_tx_data_reg        (gpcfg_reg[36]),    //output  reg  [31:0] 
  //.gpcfg37_reg            (gpcfg_reg[37]),    //output  reg  [31:0] 
  .uarts_rx_data            (uarts_rx_data),
  .uarts_tx_send_reg        (gpcfg_reg[38]),    //output  reg  [31:0] 
  .spare0_reg               (gpcfg_reg[39]),    //output  reg  [31:0] 
  .spare1_reg               (gpcfg_reg[40]),    //output  reg  [31:0] 
  .spare2_reg               (gpcfg_reg[41]),    //output  reg  [31:0] 
  .signature_reg            (gpcfg_reg[51]),    //output  reg  [31:0] 
  .maxbits                  (maxbits),
  .arg_a                    (arg_a),
  .arg_b                    (arg_b),
  .arg_b_mod_inv            (arg_b_mod_inv),
  .modulus                  (modulus),
  .x                        (x),
  .gcd                      (gcd),
  .mod_mul_il_y             (mod_mul_il_y),
  .rng0_y                   (rng0_y),
  .rng1_y                   (rng1_y),
  .bypass_vn                (bypass_vn),
  .enable_p_mod_mul_il      (enable_p_mod_mul_il),
  .enable_p_bin_ext_gcd     (enable_p_bin_ext_gcd),
  .enable_p_rng0            (enable_p_rng0),
  .enable_p_rng1            (enable_p_rng1),
  .cleq_host_irq            (cleq_host_irq),
  .done_irq_p_mod_mul_il    (done_irq_p_mod_mul_il),
  .done_irq_p_bin_ext_gcd   (done_irq_p_bin_ext_gcd),
  .done_irq_p_rng0          (done_irq_p_rng0        ),
  .done_irq_p_rng1          (done_irq_p_rng1        )
);

mod_mul_il #(
  .NBITS (NBITS)
 ) u_mod_mul_il_inst   (
  .clk           (hclk),
  .rst_n         (nreset_sync),
  .enable_p      (enable_p_mod_mul_il),
  .a             (arg_a),
  .b             (arg_b),
  .m             (modulus),
  .y             (mod_mul_il_y),
  .done_irq_p    (done_irq_p_mod_mul_il)
);
   

   
bin_ext_gcd #(
  .NBITS (NBITS)
 ) u_bin_ext_gcd_inst   (
  .clk           (hclk),
  .rst_n         (nreset_sync),
  .enable_p      (enable_p_bin_ext_gcd),
  .x             (arg_a),
  .y             (arg_b_mod_inv),
  .a             (x),
  .b             (),
  .gcd           (gcd),
  .done_irq_p    (done_irq_p_bin_ext_gcd)
);

random_num_gen #(
  .NBITS (NBITS/2) ) u_random_num_gen0_inst (
  .clk            (hclk),
  .rst_n          (nreset_sync),
  .enable_p       (enable_p_rng0),
  .bypass         (bypass_vn),
  .maxbits        (maxbits),
  .done_p         (done_irq_p_rng0),
  .y              (rng0_y)
);

random_num_gen #(
  .NBITS (NBITS/2) ) u_random_num_gen1_inst (
  .clk            (hclk),
  .rst_n          (nreset_sync),
  .enable_p       (enable_p_rng1),
  .bypass         (bypass_vn),
  .maxbits        (maxbits),
  .done_p         (done_irq_p_rng1),
  .y              (rng1_y)
);



gpio u_gpio_inst (
	.hclk        (hclk),                                        //input             
	.hresetn     (nreset_sync),                                 //input             
	.hsel        (hsel_s[GPIO_S_ID]),                           //input         	 whether it's an idle, busy, sequential or non sequential transfer
	.haddr       (haddr_s[GPIO_S_ID]),                          //input [31:0] 	     gives the read/write address
	.hwdata      (hwdata_s[GPIO_S_ID]),                         //input [31:0]  	 data that is being transferred from master-to-slave in a "W"rite
	.hwrite      (hwrite_s[GPIO_S_ID]),                         //input         	 indicates whether the transfer is master-to-slave or slave-to-master
	.hrdata      (hrdata_s[GPIO_S_ID]),                         //output reg [31:0]  data being transferred from slave-to-master in a "R"ead
	.hready      (hready_s[GPIO_S_ID]),                         //output wire	     indicates when transfer is over
	.hresp       (hresp_s[GPIO_S_ID]),                          //output 		     slave's "RESP"onse whether it is ready for transfer or not
	.intc        (gpio_irq),                                    //output wire 	     sends an interrupt to the Cortex M0’s interrupt controller
	.gpio_out    (gpio_out),                                    //output wire [3:0]  which port to enable for output (write)
	.gpio_in     (gpio_in )                                     //input reg [3:0]    which port to enable for input (read)     // shouldn't these be wires too?
	);

uarts u_uarts_inst (
  .hclk             (hclk),
  .hresetn          (nreset_sync),
  .rx_data          (uarts_rx_data),
  .rx_irq           (uarts_rx_irq),
  .tx_data          (gpcfg_reg[36]),
  .tx_send          (gpcfg_reg[38][0]),
  .tx_irq           (uarts_tx_irq),
  .uarts_baud       (gpcfg_reg[34]),
  .uarts_ctl        (gpcfg_reg[35]),
  .TX               (uarts_tx),
  .RX               (uarts_rx)

);

genvar i;


//------------------------------
//Pad to functionality mapping
//------------------------------
//pad1   nRESET
//pad2   clk
//pad3   UARTM_TX
//pad4   UARTM_RX
//pad5   SPIM_MOSI
//pad6   SPIM_MISO
//pad7   SPIM_CLK
//pad8   SPI_CS_N
//pad9   HOST_IRQ
//pad10  GPIO0    
//------------------------------
    //pad_in[*]
    chiplib_mux3 u_uartm_tx_pad_in_mux_inst (.a (uartm_tx),     .b (gpcfg_reg[0][24]), .c (cleq_host_irq),  .s ({gpcfg_reg[0][17], gpcfg_reg[0][16]}), .y (pad_in[3]));  //UARTM_TX pad
    chiplib_mux3 u_uartm_rx_pad_in_mux_inst (.a (1'b0),         .b (gpcfg_reg[1][24]), .c (1'b0),           .s ({gpcfg_reg[1][17], gpcfg_reg[1][16]}), .y (pad_in[4]));  //UARTM_RX pad
    chiplib_mux3 u_uarts_tx_pad_in_mux_inst (.a (uarts_tx),     .b (gpcfg_reg[2][24]), .c (cleq_host_irq),  .s ({gpcfg_reg[2][17], gpcfg_reg[2][16]}), .y (pad_in[5]));  //UARTS_TX pad
    chiplib_mux3 u_uarts_rx_pad_in_mux_inst (.a (1'b0),         .b (gpcfg_reg[3][24]), .c (1'b0),           .s ({gpcfg_reg[3][17], gpcfg_reg[3][16]}), .y (pad_in[6]));  //UARTS_RX pad
    chiplib_mux3 u_gpio0_pad_in_mux_inst    (.a (gpio_out[0]),  .b (gpcfg_reg[4][24]), .c (cleq_host_irq),  .s ({gpcfg_reg[4][17], gpcfg_reg[4][16]}), .y (pad_in[7]));  //GPIO0    pad
    chiplib_mux3 u_gpio1_pad_in_mux_inst    (.a (gpio_out[1]),  .b (gpcfg_reg[5][24]), .c (cleq_host_irq),  .s ({gpcfg_reg[5][17], gpcfg_reg[5][16]}), .y (pad_in[8]));  //GPIO1    pad
    chiplib_mux3 u_gpio2_pad_in_mux_inst    (.a (gpio_out[2]),  .b (gpcfg_reg[6][24]), .c (cleq_host_irq),  .s ({gpcfg_reg[6][17], gpcfg_reg[6][16]}), .y (pad_in[9]));  //GPIO2    pad
    chiplib_mux3 u_gpio3_pad_in_mux_inst    (.a (gpio_out[3]),  .b (gpcfg_reg[7][24]), .c (cleq_host_irq),  .s ({gpcfg_reg[7][17], gpcfg_reg[7][16]}), .y (pad_in[10])); //GPIO3    pad

    assign pad_ctl[3][1:0]   = (gpcfg_reg[0][20] == 1'b1) ? gpcfg_reg[0][1:0] : ((gpcfg_reg[0][17:16] == 2'b01) ? 2'b10 : ((gpcfg_reg[0][17:16] == 2'b10) ? 2'b10 : 2'b10));
    assign pad_ctl[4][1:0]   = (gpcfg_reg[1][20] == 1'b1) ? gpcfg_reg[1][1:0] : ((gpcfg_reg[1][17:16] == 2'b01) ? 2'b10 : ((gpcfg_reg[1][17:16] == 2'b10) ? 2'b11 : 2'b11));
    assign pad_ctl[5][1:0]   = (gpcfg_reg[2][20] == 1'b1) ? gpcfg_reg[2][1:0] : ((gpcfg_reg[2][17:16] == 2'b01) ? 2'b10 : ((gpcfg_reg[2][17:16] == 2'b10) ? 2'b10 : 2'b11));
    assign pad_ctl[6][1:0]   = (gpcfg_reg[3][20] == 1'b1) ? gpcfg_reg[3][1:0] : ((gpcfg_reg[3][17:16] == 2'b01) ? 2'b10 : ((gpcfg_reg[3][17:16] == 2'b10) ? 2'b11 : 2'b11));
    assign pad_ctl[7][1:0]   = (gpcfg_reg[4][20] == 1'b1) ? gpcfg_reg[4][1:0] : ((gpcfg_reg[4][17:16] == 2'b01) ? 2'b10 : ((gpcfg_reg[4][17:16] == 2'b10) ? 2'b10 : 2'b11));
    assign pad_ctl[8][1:0]   = (gpcfg_reg[5][20] == 1'b1) ? gpcfg_reg[5][1:0] : ((gpcfg_reg[5][17:16] == 2'b01) ? 2'b10 : ((gpcfg_reg[5][17:16] == 2'b10) ? 2'b10 : 2'b11));
    assign pad_ctl[9][1:0]   = (gpcfg_reg[6][20] == 1'b1) ? gpcfg_reg[6][1:0] : ((gpcfg_reg[6][17:16] == 2'b01) ? 2'b10 : ((gpcfg_reg[6][17:16] == 2'b10) ? 2'b10 : 2'b11));
    assign pad_ctl[10][1:0]  = (gpcfg_reg[7][20] == 1'b1) ? gpcfg_reg[7][1:0] : ((gpcfg_reg[7][17:16] == 2'b01) ? 2'b10 : ((gpcfg_reg[7][17:16] == 2'b10) ? 2'b10 : 2'b11));

generate
  for (i=3; i<NUM_PADS; i=i+1) begin
    assign pad_ctl[i][PAD_CTL_W-1:2] = gpcfg_reg[i-3][PAD_CTL_W-1:2];
  end
endgenerate


    assign nreset      = pad_out[1]; 

    `ifdef FPGA_SYNTH
       clock_div u_clk_div4_inst ( 
         .CLK_IN1(pad_out[2]),
         .CLK_OUT1(hclk)
       );
    `else
      assign hclk        = pad_out[2]; 
    `endif

    chiplib_mux3 u_uartm_rx_mux_inst (.a (pad_out[4]), .b (1'b1), .c (pad_out[5]),                   .s ({gpcfg_reg[1][17], gpcfg_reg[1][16]}), .y(uartm_rx));  //UARTM_RX pad
    chiplib_mux4 u_uarts_rx_mux_inst (.a (pad_out[6]), .b (1'b1), .c (pad_out[3]), .d (pad_out[5]),  .s ({gpcfg_reg[3][17], gpcfg_reg[3][16]}), .y(uarts_rx));  //UARTS_RX pad

    assign gpio_in[0]  = pad_out[7];      //GPIO0    pad
    assign gpio_in[1]  = pad_out[8];      //GPIO1    pad
    assign gpio_in[2]  = pad_out[9];      //GPIO2    pad
    assign gpio_in[3]  = pad_out[10];     //GPIO3    pad


 always @ (posedge hclk or negedge nreset) begin
   if (nreset == 1'b0) begin
     nreset_sync0 <= 1'b0;
     nreset_sync1 <= 1'b0;
     nreset_sync2 <= 1'b0;
   end
   else begin
     nreset_sync0 <= 1'b1;
     nreset_sync1 <= nreset_sync0;
     nreset_sync2 <= nreset_sync1;
   end
 end

 assign nreset_sync = nreset_sync2 & nreset_sync1 & nreset_sync0 & nreset;


endmodule
