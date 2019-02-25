module trng_wrap (
  input   wire clk,
  input   wire rst_n,
  input   wire en,
  output  wire y
);

wire [14:0] y_loc;

genvar i;

assign y = ^y_loc;

generate
  for (i = 0; i < 15; i= i + 1) begin : trng_inst
    trng #(
      .trng_delay (i))
      u_trng_inst (
      .clk    (clk),
      .rst_n  (rst_n),
      .en     (en),
      .y      (y_loc[i])
    );
  end
endgenerate

endmodule
