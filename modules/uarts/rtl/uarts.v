
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------
module uarts (
  // CLOCK AND RESETS ------------------
  input  wire        hclk,              // Clock
  input  wire        hresetn,           // Asynchronous reset

  // AHB-LITE MASTER PORT --------------
  output wire [31:0] rx_data,
  output wire        rx_irq,
  input  wire [31:0] tx_data,
  input wire         tx_send,
  output wire        tx_irq,

  // MISCELLANEOUS ---------------------
  input  wire [31:0] uarts_baud,
  input  wire [31:0] uarts_ctl,       //1:0 : 00 => 8 bit, 01 => 16 bit, 10 => 32 bit, 11 => 8 bit
                                      //  2 : 0  => No parity,  1 => parity enabled
                                      //  3 : 0  => Odd parity, 1 => Even parity

  // IO ---------------------
  output wire        TX,              // Event output (SEV executed)
  input  wire        RX               // Event input

);


//-------------------------------------
//localparams, reg and wire declaration
//-------------------------------------

  `include "uarts_params.v"


wire        start_bit_det;
wire [7:0]  uarts_plw;
wire [7:0]  uarts_dw;

reg [31:0]  baud_clk_cnt;
reg [7:0]   bit_cnt;
reg         poll_start_bit;
reg         sample_data_bit;

reg         rx_d1;
reg         rx_d2;
reg         rx_d3;


//--------------------------------------------------------------
//uarts_ctl
//1:0 : 00 => 8 bit, 01 => 16 bit, 10 => 32 bit, 11 => 8 bit
//  2 : 0  => No parity,  1 => parity enabled
//  3 : 0  => Odd parity, 1 => Even parity
//--------------------------------------------------------------

assign uarts_dw = (uarts_ctl[1:0] == 2'b10) ?
                                             ((uarts_ctl[1:0] == 2'b01) ?
                                                                          8'b0001_0000  //16 bit
                                                                        : 8'b0010_0000) //32 bit
                                            : 8'b0000_1000; //8 bit



//---------------------------------------------------------------------------
//Pay load width = data_width + Start bit + Stop bit +  parity bit if enabled
//Adder is not used as the synthesis tool may not optimize the adder as below
//---------------------------------------------------------------------------

assign uarts_plw = (uarts_ctl[1:0] == 2'b10) ?
                                             ((uarts_ctl[1:0] == 2'b01) ?
                                                                          ({7'b0001_001, uarts_ctl[2]})  //Same as (8'b0001_0010 + {7'b0, uarts_ctl[2]})
                                                                        : ({7'b0010_001, uarts_ctl[2]})) //Same as (8'b0010_0010 + {7'b0, uarts_ctl[2]}))
                                            : ({7'b0000_101, uarts_ctl[2]}); // Same as (8'b0000_1010 + {7'b0, uarts_ctl[2]});

//---------------------------------------------------------------------------
//Synchronize the Input 
//---------------------------------------------------------------------------
   always @ (posedge hclk or negedge hresetn) begin
     if (hresetn == 1'b0) begin
        rx_d1 <= 1'b1;
        rx_d2 <= 1'b1;
        rx_d3 <= 1'b1;
     end
     else begin
        rx_d1 <= RX;
        rx_d2 <= rx_d1;
        rx_d3 <= rx_d2;
     end
   end

//---------------------------------------------------------------------------
//Check for Start bit
//---------------------------------------------------------------------------
   assign start_bit_det = poll_start_bit ? (~rx_d3 & ~RX) : 1'b0;

   always @ (posedge hclk or negedge hresetn) begin
     if (hresetn == 1'b0) begin
       baud_clk_cnt    <= 32'b0;
       poll_start_bit  <= 1'b1;
       sample_data_bit <= 1'b0;
     end
     else begin
       if ((bit_cnt  == 8'b0) && (baud_clk_cnt == {1'b0, uarts_baud[31:1]})) begin  //count for only half the baud rate upon detecting start_bit
         baud_clk_cnt <= 32'b0;
       end
       else if (start_bit_det == 1'b1) begin
         baud_clk_cnt   <= baud_clk_cnt + 1;
         poll_start_bit <= 1'b0;
       end
       else if ((bit_cnt == uarts_plw[7:0]) || (poll_start_bit == 1'b1)) begin     //Disable the counter whenever there current transaction reaches stop bit or there is no transaction
         baud_clk_cnt    <= 32'b0;
         poll_start_bit  <= 1'b1;
         sample_data_bit <= 1'b0;
       end
       else if ((baud_clk_cnt == uarts_baud)) begin
         baud_clk_cnt    <= 32'b0;
         sample_data_bit <= 1'b1;
       end
       else begin
         baud_clk_cnt    <= baud_clk_cnt + 1;
         sample_data_bit <= 1'b0;
       end
     end
   end

   always @ (posedge hclk or negedge hresetn) begin
     if (hresetn == 1'b0) begin
       bit_cnt <= 8'b0;
     end
     else begin
       if ((bit_cnt  == 8'b0) && (baud_clk_cnt == {1'b0, uarts_baud[31:1]})) begin
         bit_cnt <= bit_cnt + 1;
       end
       else if ((bit_cnt == uarts_plw[7:0]) || (poll_start_bit == 1'b1)) begin
         bit_cnt <= 8'b0;
       end
       else if (sample_data_bit == 1'b1) begin
         bit_cnt <= bit_cnt + 1;
       end
     end
   end
 


uarts_rx u_uarts_rx_inst (
  .hclk             (hclk),            //input  wire          // Clock
  .hresetn          (hresetn),         //input  wire          // Asynchronous reset
  .uarts_baud       (uarts_baud),      //input  wire [31:0] 
  .uarts_ctl        (uarts_ctl),       //input  wire [31:0] //1:0 : 00 => 8 bit, 01 => 16 bit, 10 => 32 bit, 11 => 8 bit
  .sample_data_bit  (sample_data_bit), //input  wire        // AHB stall signal
  .bit_cnt          (bit_cnt),         //input  wire [7:0]  
  .uarts_dw         (uarts_dw),        //input  wire [7:0]  
  .uarts_plw        (uarts_plw),       //input  wire [7:0]  
  .RX               (RX),              //input  wire        // Event input
  .rx_irq           (rx_irq),          //output reg
  .rx_data          (rx_data)          //output reg  [31:0] 

);

uarts_tx u_uarts_tx_inst (
  .hclk           (hclk),           //input  wire        // Clock
  .hresetn        (hresetn),        //input  wire        // Asynchronous reset
  .tx_send        (tx_send),        //input  wire [1:0]  // AHB write control
  .tx_data        (tx_data),        //input  wire [31:0] 
  .uarts_baud     (uarts_baud),     //input  wire [31:0] 
  .uarts_ctl      (uarts_ctl),      //input  wire [31:0] //1:0 : 00 => 8 bit, 01 => 16 bit, 10 => 32 bit, 11 => 8 bit
  .uarts_dw       (uarts_dw),       //input  wire [7:0]  
  .uarts_plw      (uarts_plw),      //input  wire [7:0]  
  .tx_irq         (tx_irq),         //output  reg
  .TX             (TX)              //output  reg        // Event input

);



endmodule
