module gpcfg_rd (
  //input                hclk,
  //input                hresetn,
  //input                wr_en,
  input                rd_en,
  //input       [3:0]    byte_en,
  //input       [31:0]   wr_addr,
  input       [31:0]   rd_addr,
  input       [31:0]   wdata,
  //output reg  [31:0]   wr_reg,
  output      [31:0]   rdata
);

  parameter CFG_ADDR      = 16'h0;

  //reg [31:0]  wr_reg;

  //always @ (posedge hclk or negedge hresetn) begin
  //  if (hresetn == 1'b0) begin
  //    wr_reg  <= RESET_VAL;
  //  end
  //  else begin
  //    if (wr_en == 1'b1) begin
  //      wr_reg <= wdata;
  //    end
  //  end
  //end

  //assign rdata = (rd_en & (rd_addr == CFG_ADDR)) ? wr_reg : 32'b0;
  assign rdata = (rd_en & (rd_addr[15:0] == CFG_ADDR)) ? wdata : 32'b0;

endmodule
