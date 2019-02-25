module uartm_ahb (
  // CLOCK AND RESETS ------------------
  input  wire        hclk,              // Clock
  input  wire        hresetn,           // Asynchronous reset

  // AHB-LITE MASTER PORT --------------
  output reg  [31:0] haddr,             // AHB transaction address
  output wire [ 2:0] hsize,             // AHB size: byte, half-word or word
  output reg  [ 1:0] htrans,            // AHB transfer: non-sequential only
  output reg  [31:0] hwdata,            // AHB write-data
  output reg         hwrite,            // AHB write control
  input  wire [31:0] hrdata,            // AHB read-data
  input  wire        hready,            // AHB stall signal
  input  wire        hresp,             // AHB error response

  // MISCELLANEOUS ---------------------
  input  wire [2:0]  rx_curr_st,
  input  wire [2:0]  rx_nxt_st,
  input  wire [31:0] rx_reg


);


//-------------------------------------
//localparams, reg and wire declaration
//-------------------------------------

  `include "uartm_params.v"

 //AHB Master Signal generation
  
 always @ (posedge hclk or negedge hresetn) begin
   if (hresetn == 1'b0) begin
     hwrite <= 1'b0;
   end
   else begin
     if ((rx_curr_st != RX_CHECK) && (rx_nxt_st == RX_CHECK)) begin
       if (rx_reg[7:0] == 8'h34) begin
         hwrite <= 1'b1;
       end
       else begin
         hwrite <= 1'b0;
       end
     end
   end
 end
 
 always @ (posedge hclk or negedge hresetn) begin
   if (hresetn == 1'b0) begin
     haddr <= 32'b0;
   end
   else begin
     if (((rx_nxt_st == RX_READ) && (rx_curr_st != RX_READ)) || ((rx_nxt_st == RX_WRITE) && (rx_curr_st != RX_WRITE))) begin
       haddr <= rx_reg;
     end
   end
 end
  
 always @ (posedge hclk or negedge hresetn) begin
   if (hresetn == 1'b0) begin
     hwdata <= 32'b0;
   end
   else begin
     if ((rx_nxt_st == RX_WDATA) && (rx_curr_st != RX_WDATA)) begin
       hwdata <= rx_reg;
     end
   end
 end
 
 always @ (posedge hclk or negedge hresetn) begin
   if (hresetn == 1'b0) begin
     htrans <= 2'b00;
   end
   else begin
     if ((rx_curr_st == RX_READ) || (rx_curr_st == RX_WDATA)) begin
       htrans <= 2'b10;
     end
     else if (hready == 1'b1) begin
       htrans <= 2'b0;
     end
   end
 end

 
 assign hsize  = 3'b010; //4 bytes - 32 bit


endmodule
