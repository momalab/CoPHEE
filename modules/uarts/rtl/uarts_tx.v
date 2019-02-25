
module uarts_tx (
  // CLOCK AND RESETS ------------------
  input  wire        hclk,              // Clock
  input  wire        hresetn,           // Asynchronous reset

  // AHB-LITE MASTER PORT --------------
  input  wire        tx_send,            // AHB write control
  input  wire [31:0] tx_data,

  // MISCELLANEOUS ---------------------
  input  wire [31:0] uarts_baud,
  input  wire [31:0] uarts_ctl,       //1:0 : 00 => 8 bit, 01 => 16 bit, 10 => 32 bit, 11 => 8 bit
                                      //  2 : 0  => No parity,  1 => parity enabled
                                      //  3 : 0  => Odd parity, 1 => Even parity
  input  wire [7:0]  uarts_dw,
  input  wire [7:0]  uarts_plw,

  // IO ---------------------
  output  reg        tx_irq,
  output  reg        TX              // Event input

);

//-------------------------------------
//localparams, reg and wire declaration
//-------------------------------------

  
  `include "uarts_params.v"

reg        parity;

reg         send_data_bit;
reg         trans_val;
reg         trans_val_d;
reg [7:0]   bit_cnt;
reg [31:0]  tx_reg;
reg [4:0]   shift_cnt;
reg [31:0]  baud_clk_cnt;

reg start_bit;
reg start_bit_d;

//----------------
//TX counter
//----------------

   always @ (posedge hclk or negedge hresetn) begin
     if (hresetn == 1'b0) begin
       baud_clk_cnt <= 32'b0;
     end
     else begin
       if (baud_clk_cnt == uarts_baud) begin
         baud_clk_cnt <= 32'b0;
       end
       else if (trans_val == 1'b1) begin
         baud_clk_cnt <= baud_clk_cnt + 1;
       end
       else begin
         baud_clk_cnt <= 32'b0;
       end
     end
   end

   always @ (posedge hclk or negedge hresetn) begin
     if (hresetn == 1'b0) begin
       trans_val <= 1'b0;
     end
     else begin
       if (tx_send == 1'b1) begin
         trans_val <= 1'b1;
       end
       else if (bit_cnt == (uarts_plw-1)) begin
         trans_val <= 1'b0;
       end
     end
   end

   always @ (posedge hclk or negedge hresetn) begin
     if (hresetn == 1'b0) begin
       trans_val_d <= 1'b0;
     end
     else begin
         trans_val_d <= trans_val;
     end
   end

   always @ (posedge hclk or negedge hresetn) begin
     if (hresetn == 1'b0) begin
       send_data_bit   <= 1'b0;
     end
     else begin
       if (baud_clk_cnt == uarts_baud) begin
         send_data_bit <= 1'b1;
       end
       else begin
         send_data_bit <= 1'b0;
       end
     end
   end

   always @ (posedge hclk or negedge hresetn) begin
     if (hresetn == 1'b0) begin
       bit_cnt <= 8'b0;
     end
     else begin
       if (bit_cnt == (uarts_plw-1)) begin
         bit_cnt <= 8'b0;
       end
       else if (send_data_bit == 1'b1) begin
         bit_cnt <= bit_cnt + 1;
       end
     end
   end
 
 //Capture  Rdata to TX shift register
   always @ (posedge hclk or negedge hresetn) begin
     if (hresetn == 1'b0) begin
       tx_reg    <= 32'hFFFF_FFFF;
       shift_cnt <= 5'b0;
       parity    <= 1'b0;
     end
     else begin
       if (tx_send == 1'b1) begin
         tx_reg[31:0]  <= tx_data;
         parity        <= ~(^tx_data ^ uarts_ctl[3]);
       end
       else if ((send_data_bit == 1'b1) && (bit_cnt <= uarts_dw) && (start_bit_d == 1'b0)) begin
         tx_reg     <= {1'b1, tx_reg[31:1]};
         shift_cnt  <= shift_cnt + 1'b1;
       end
     end
   end

  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      start_bit  <= 1'b0;
    end
    else begin
      if ((trans_val == 1'b1) && (trans_val_d == 1'b0)) begin //Start Bit
        start_bit <= 1'b1;
      end
      else if  (baud_clk_cnt == uarts_baud) begin
        start_bit <= 1'b0;
      end
    end
  end

  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      start_bit_d <= 1'b0;
    end
    else begin
      start_bit_d <= start_bit;
    end
  end


  

  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      TX <= 1'b1;
    end
    else begin
      if (start_bit == 1'b1) begin //Start Bit
        TX <= 1'b0;
      end
      else if (bit_cnt == (uarts_plw-1)) begin
        TX <= 1'b1;
      end
      else if ((bit_cnt == (uarts_dw+1)) && (uarts_ctl[2] == 1'b1)) begin //parity
        TX <= parity;
      end
      else if (trans_val == 1'b1) begin
        TX <= tx_reg[0];
      end
      else begin
        TX <= 1'b1;
      end
    end
  end
 
  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      tx_irq <= 1'b0;
    end
    else begin
      if (bit_cnt == (uarts_plw-1)) begin
        tx_irq <= 1'b1;
      end
      else begin
        tx_irq <= 1'b0;
      end
    end
  end
 



endmodule
