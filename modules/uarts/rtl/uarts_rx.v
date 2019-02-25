
  module uarts_rx (
  // CLOCK AND RESETS ------------------
  input  wire        hclk,              // Clock
  input  wire        hresetn,           // Asynchronous reset

  // MISCELLANEOUS ---------------------
  input  wire [31:0] uarts_baud,
  input  wire [31:0] uarts_ctl,       //1:0 : 00 => 8 bit, 01 => 16 bit, 10 => 32 bit, 11 => 8 bit
                                      //  2 : 0  => No parity,  1 => parity enabled
                                      //  3 : 0  => Odd parity, 1 => Even parity
  input  wire        sample_data_bit,
  input  wire [7:0]  bit_cnt,
  input  wire [7:0]  uarts_dw,
  input  wire [7:0]  uarts_plw,

  // IO ---------------------
  input  wire        RX,              // Event input

  output reg [31:0]  rx_data,
  output reg         rx_irq
);

//-------------------------------------
//localparams, reg and wire declaration
//-------------------------------------

reg [31:0]  rx_reg;
reg [2:0]   rx_curr_st;
reg [2:0]   rx_nxt_st;

  `include "uarts_params.v"

 //RX shift register
   always @ (posedge hclk or negedge hresetn) begin
     if (hresetn == 1'b0) begin
       rx_reg = 32'b0;
     end
     else begin
       if ((sample_data_bit == 1'b1) && (bit_cnt <= uarts_dw)) begin
         rx_reg = {RX, rx_reg[31:1]};
       end
     end
   end
 
 //--------------------------------------------------------
 //RX FSM States
 //--------------------------------------------------------
 //RX_IDLE
 //RX_CHECK  
 //RX_WAIT1  Intermediate wait cycle for address and wdata
 //RX_WAIT2  Intermediate wait cycle for address and wdata
 //RX_WAIT3  Intermediate wait cycle for address and wdata
 //--------------------------------------------------------
 
 always @* begin
   rx_nxt_st = rx_curr_st;
   case (rx_curr_st) //synopsys parallel_case
     RX_IDLE : begin
       if (bit_cnt == uarts_plw[7:0])  begin
         if (uarts_ctl[1:0] == 2'b10) begin
           rx_nxt_st = RX_CHECK;
         end
         else begin
           rx_nxt_st = RX_WAIT1;
         end
       end
     end //RX_IDLE
     RX_CHECK : begin
       rx_nxt_st = RX_IDLE;
     end //RX_CHECK
     RX_WAIT1 : begin
       if (bit_cnt == uarts_plw[7:0])  begin
         if (uarts_ctl[1:0] == 2'b01) begin
           rx_nxt_st = RX_CHECK;
         end
         else begin
           rx_nxt_st = RX_WAIT2;
         end
       end
     end //RX_WAIT1
     RX_WAIT2 : begin
       if (bit_cnt == uarts_plw[7:0])  begin
         rx_nxt_st = RX_WAIT3;
       end
     end //RX_WAIT2
     RX_WAIT3 : begin
       if (bit_cnt == uarts_plw[7:0])  begin
           rx_nxt_st = RX_CHECK;
       end
     end //RX_WAIT3
     default : begin
       rx_nxt_st = RX_IDLE;
     end //default
   endcase
 end

 always @ (posedge hclk or negedge hresetn) begin
   if (hresetn == 1'b0) begin
     rx_curr_st <= 3'b0;
   end
   else begin
     rx_curr_st <= rx_nxt_st;
   end
 end
  
 always @ (posedge hclk or negedge hresetn) begin
   if (hresetn == 1'b0) begin
     rx_irq <= 1'b0;
   end
   else begin
     if ((rx_curr_st != RX_CHECK) && (rx_nxt_st == RX_CHECK)) begin
       rx_irq <= 1'b1;
     end
     else begin
       rx_irq <= 1'b0;
     end
   end
 end
  
 always @ (posedge hclk or negedge hresetn) begin
   if (hresetn == 1'b0) begin
     rx_data <= 32'b0;
   end
   else begin
    if ((rx_curr_st != RX_CHECK) && (rx_nxt_st == RX_CHECK)) begin
      rx_data <= rx_reg[31:0];
    end
   end
 end
 


 
endmodule
