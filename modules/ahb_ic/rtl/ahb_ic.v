//---------------------------------------------------------------------------------------------------
//This module implements AHB-Lite Bus matrix interconnect. Arbitration is fixed priority where Master0
//have higher priority and Master[NUM_MASTERS-1] have least priority. Arbitration happens every cycle.
//Its a full crossbar where any master can access any slave and there can be multiple master accessing multiple slave
//in a given point of time unlike a bus , where only one transaction is allowed at a time.
//And if there is a contention between 2 masters accessing same slave higher priority master wins the arbitration.
//This module expects the hrdata from not selected slave to be 0
//The code is made generic to support any number of masters and slave. It has 3 main logic
//1. Decoder logic to identify which master is accessing which slave and muxing logic for address control singal
//   --Hsel to every slave is generated for all the masters. If there are N masters, there will be N hsel for each slave.
//   --If an higher priority master is accessing a slave hsel of that slave by a lower priority master is made 0
//   --Final Hsel to a slave is or of all the hsel from all the masters to this slave
//   --Based on Hsel address/control muxing is done
//2. Address/Ctl latching of the master who lost the arbitration
//   --For the masters who lost the arbitration, address control signals are latched.
//   --These latched values will partcipate in next arbitration cycle and will have priority over the new transaction by
//     the "same master". But will have lower priority compared to the new transaction by higher priority master.
//   --This latched value will be held until hready correspond to this latched transaction is recieved from the slave.
//2. Hwdata Muxing
//   --isel generated to each slave is latched to do the Hwdata muxing to the slave.
//   --Incase Hready is low from the slave in data phase, mux select for hwdata is extended until hready
//     from the slave is high.
//3. Hready, Hrdata and Hresp Muxing
//---------------------------------------------------------------------------------------------------


module ahb_ic #(
  parameter NUM_SLAVES   = 2,
  parameter NUM_MASTERS  = 2,
  parameter [31:0] SLAVE_BASE [NUM_SLAVES-1 :0]   ='{
                                                     32'h4003_0000,
                                                     32'h4002_0000}
)(  
  // CLOCK AND RESETS ------------------
  input  wire         hclk,              // Clock
  input  wire         hresetn,           // Asynchronous reset
  // MASTER PORT --------------
  input   wire [ 1:0] htrans_m[NUM_MASTERS-1 :0],      // AHB transfer: non-sequential only
  input   wire [31:0] haddr_m[NUM_MASTERS-1 :0],       // AHB transaction address
  input   wire [ 2:0] hsize_m[NUM_MASTERS-1 :0],       // AHB size: byte, half-word or word
  input   wire [31:0] hwdata_m[NUM_MASTERS-1 :0],      // AHB write-data
  input   wire        hwrite_m[NUM_MASTERS-1 :0],      // AHB write control
  output  reg  [31:0] hrdata_m[NUM_MASTERS-1 :0],      // AHB read-data
  output  reg         hready_m[NUM_MASTERS-1 :0],      // AHB stall signal
  output  reg         hresp_m[NUM_MASTERS-1 :0],       // AHB error response
  //Slave Port ---------------
  output  reg         hsel_s[NUM_SLAVES-1 :0],         // AHB transfer: non-sequential only
  output  reg  [31:0] haddr_s[NUM_SLAVES-1 :0],        // AHB transaction address
  output  reg  [ 2:0] hsize_s[NUM_SLAVES-1 :0],        // AHB size: byte, half-word or word
  output  reg         hwrite_s[NUM_SLAVES-1 :0],       // AHB write control
  output  reg  [31:0] hwdata_s[NUM_SLAVES-1 :0],       // AHB write-data
  input   wire [31:0] hrdata_s[NUM_SLAVES-1 :0],       // AHB read-data
  input   wire        hready_s[NUM_SLAVES-1 :0],       // AHB stall signal
  input   wire        hresp_s[NUM_SLAVES-1 :0]         // AHB error response
);


  wire [31 :0]            slave_base[NUM_SLAVES-1 :0];

  wire                    vlaid_trans_s_by_m[NUM_SLAVES-1 :0][NUM_MASTERS-1 :0];
  wire                    hsel_s_by_m[NUM_SLAVES-1 :0][NUM_MASTERS-1 :0];
  wire                    hsel_s_by_hpm[NUM_SLAVES-1 :0][NUM_MASTERS-1 :0]; //hpm = higher priority masters
  wire [31 :0]            haddr_s_by_m[NUM_SLAVES-1 :0][NUM_MASTERS-1 :0];
  wire [2 :0]             hsize_s_by_m[NUM_SLAVES-1 :0][NUM_MASTERS-1 :0];
  wire                    hwrite_s_by_m[NUM_SLAVES-1 :0][NUM_MASTERS-1 :0];
  wire [31 :0]            hwdata_s_by_m[NUM_SLAVES-1 :0][NUM_MASTERS-1 :0];

  wire                   latch_addr_ctl[NUM_SLAVES-1 :0][NUM_MASTERS-1 :0];
  reg                    hsel_s_by_lpm_lat[NUM_SLAVES-1 :0][NUM_MASTERS-1 :0]; //lpm = low priority masters
  reg [31 :0]            haddr_s_by_lpm_lat[NUM_SLAVES-1 :0][NUM_MASTERS-1 :0];
  reg [2 :0]             hsize_s_by_lpm_lat[NUM_SLAVES-1 :0][NUM_MASTERS-1 :0];
  reg                    hwrite_s_by_lpm_lat[NUM_SLAVES-1 :0][NUM_MASTERS-1 :0];

  reg                     hsel_s_by_m_lat[NUM_SLAVES-1 :0][NUM_MASTERS-1 :0];
  reg  [31 :0]            hwdata_s_by_m_lat[NUM_SLAVES-1 :0][NUM_MASTERS-1 :0];

//-------------------------------------------
//Address Map
//-------------------------------------------
//32'h0000_0000 to 32'h0000_0FFF  program Ram
//32'h2000_0000 to 32'h2000_0FFF  On Chip Ram
//32'h4000_0000 to 32'h4000_0FFF  wdog
//32'h4001_0000 to 32'h4001_0FFF  gptimer
//32'h4002_0000 to 32'h4002_0FFF  gpcfg
//32'h4003_0000 to 32'h4003_0FFF  gpio
//32'h4004_0000 to 32'h4004_0FFF  uartm
//32'h4005_0000 to 32'h4005_0FFF  uarts
//--------------------------------------------

//------------------------------------------------------
//Hsel, haddr, hsize and hwrite generation for each slave for each master address
//------------------------------------------------------

  genvar s,m;

  //-----------------------------------------------------------
  //hsel, haddr, hsize and hwrite for each slave for MASTER[0] is checked first
  //-----------------------------------------------------------
 
  assign slave_base  = SLAVE_BASE;
  generate
    for (s=0; s<NUM_SLAVES; s=s+1) begin
      assign vlaid_trans_s_by_m[s][0]   = (haddr_m[0][31:16] == slave_base[s][31:16]) & htrans_m[0][1] & hready_s[s];
      assign latch_addr_ctl[s][0]       = vlaid_trans_s_by_m[s][0] & ~hready_s[s];
      assign hsel_s_by_m[s][0]          = vlaid_trans_s_by_m[s][0];
      assign hsel_s_by_hpm[s][0]        = hsel_s_by_m[s][0];
      assign haddr_s_by_m[s][0]         = hsel_s_by_m[s][0] ? haddr_m[0]  : 32'b0;
      assign hsize_s_by_m[s][0]         = hsel_s_by_m[s][0] ? hsize_m[0]  : 3'b0;
      assign hwrite_s_by_m[s][0]        = hsel_s_by_m[s][0] ? hwrite_m[0] : 1'b0;
    end
  endgenerate

  //-----------------------------------------------------------
  //Now generate for rest of the masters
  //-----------------------------------------------------------
  generate
    for (m=1; m<NUM_MASTERS; m=m+1) begin
      for (s=0; s<NUM_SLAVES; s=s+1) begin
        assign vlaid_trans_s_by_m[s][m]    =   (haddr_m[m][31:16] == slave_base[s][31:16]) & htrans_m[m][1];
        assign latch_addr_ctl[s][m]        =   vlaid_trans_s_by_m[s][m] & (hsel_s_by_hpm[s][m-1] | ~hready_s[s]);
        assign hsel_s_by_m[s][m]           =   hsel_s_by_lpm_lat[s][m] | (~hsel_s_by_hpm[s][m-1] & vlaid_trans_s_by_m[s][m]);
        assign haddr_s_by_m[s][m]          =   hsel_s_by_m[s][m] ? (hsel_s_by_lpm_lat[s][m] ? haddr_s_by_lpm_lat[s][m]  : haddr_m[m] ): 32'b0;
        assign hsize_s_by_m[s][m]          =   hsel_s_by_m[s][m] ? (hsel_s_by_lpm_lat[s][m] ? hsize_s_by_lpm_lat[s][m]  : hsize_m[m] ): 3'b0;
        assign hwrite_s_by_m[s][m]         =   hsel_s_by_m[s][m] ? (hsel_s_by_lpm_lat[s][m] ? hwrite_s_by_lpm_lat[s][m] : hwrite_m[m]): 1'b0;

        assign hsel_s_by_hpm[s][m]         =   hsel_s_by_m[s][m] | hsel_s_by_hpm[s][m-1];
      end
    end
  endgenerate

  //------------------------------------------------------------------------
  //latch the address and control signal of the masters who lost arbitration
  //------------------------------------------------------------------------
  generate
    for (m=0; m<NUM_MASTERS; m=m+1) begin
      for (s=0; s<NUM_SLAVES; s=s+1) begin
        always @ (posedge hclk or negedge hresetn) begin
          if (hresetn == 1'b0) begin
            hsel_s_by_lpm_lat[s][m]   = 1'b0;
            haddr_s_by_lpm_lat[s][m]  = 32'b0;
            hsize_s_by_lpm_lat[s][m]  = 3'b0;
            hwrite_s_by_lpm_lat[s][m] = 1'b0;
          end
          else if (latch_addr_ctl[s][m]) begin
            hsel_s_by_lpm_lat[s][m]   = hsel_s_by_m[s][m];
            haddr_s_by_lpm_lat[s][m]  = haddr_s_by_m[s][m];
            hsize_s_by_lpm_lat[s][m]  = hsize_s_by_m[s][m];
            hwrite_s_by_lpm_lat[s][m] = hwrite_s_by_m[s][m];
          end
          else if (hsel_s_by_m[s][m]) begin
            hsel_s_by_lpm_lat[s][m]   = 1'b0;
            haddr_s_by_lpm_lat[s][m]  = 32'b0;
            hsize_s_by_lpm_lat[s][m]  = 3'b0;
            hwrite_s_by_lpm_lat[s][m] = 1'b0;
          end
        end
      end
    end
  endgenerate


  //-----------------------------------------------------------
  //Now generate final hsel, haddr, hsize and hwrite
  //-----------------------------------------------------------
  integer j;
  generate
    for (s=0; s<NUM_SLAVES; s=s+1) begin
      always@* begin
        hsel_s[s]    = 1'b0;
        haddr_s[s]   = 32'b0;
        hwrite_s[s]  = 1'b0;
        hsize_s[s]   = 1'b0;
        for (j=0; j<NUM_MASTERS; j=j+1) begin
          hsel_s[s]    = hsel_s[s]   | hsel_s_by_m[s][j];
          haddr_s[s]   = haddr_s[s]  | haddr_s_by_m[s][j];
          hsize_s[s]   = hsize_s[s]  | hsize_s_by_m[s][j];
          hwrite_s[s]  = hwrite_s[s] | hwrite_s_by_m[s][j];
        end
      end
    end
  endgenerate

//-----------------------------------------------------------
//hwdata generation to slave
//-----------------------------------------------------------

  //-----------------------------------------------------------
  //latch hsel to mux the hwdata
  //-----------------------------------------------------------
  generate
    for (m=0; m<NUM_MASTERS; m=m+1) begin
      for (s=0; s<NUM_SLAVES; s=s+1) begin
        always @ (posedge hclk or negedge hresetn) begin
          if (hresetn == 1'b0) begin
            hsel_s_by_m_lat[s][m] = 1'b0;
          end
          else if (hsel_s_by_m_lat[s][m] & !hready_s[s]) begin
            hsel_s_by_m_lat[s][m] = 1'b1;
          end
          else begin
            hsel_s_by_m_lat[s][m] = hsel_s_by_m[s][m];
          end
        end
      end
    end
  endgenerate

  generate
    for (s=0; s<NUM_SLAVES; s=s+1) begin
      always@* begin
        hwdata_s[s]  = 32'b0;
        for (j=0; j<NUM_MASTERS; j=j+1) begin
          hwdata_s[s]  = hwdata_s[s] | (hwdata_m[j] & {32{hsel_s_by_m_lat[s][j]}});
        end
      end
    end
  endgenerate

//-----------------------------------------------------------
//HREADY, Hrdata and HRESP
//-----------------------------------------------------------
  generate
    for (m=0; m<NUM_MASTERS; m=m+1) begin
      always@* begin
        hready_m[m]  = 1'b1;
        for (j=0; j<NUM_SLAVES; j=j+1) begin
          hready_m[m] = ~hsel_s_by_lpm_lat[j][m] & ~(hsel_s_by_m_lat[j][m] & ~hready_s[j]) & hready_m[m] ;
        end
      end
    end
  endgenerate

  generate
    for (m=0; m<NUM_MASTERS; m=m+1) begin
      always@* begin
        hrdata_m[m]  = 32'b0;
        hresp_m[m]  = 32'b0;
        for (j=0; j<NUM_SLAVES; j=j+1) begin
          hrdata_m[m] = ({32{hsel_s_by_m_lat[j][m]}} & hrdata_s[j]) | hrdata_m[m];
          hresp_m[m]  = (hsel_s_by_m_lat[j][m] & hresp_s[j]) | hresp_m[m];
        end
      end
    end
  endgenerate



endmodule
