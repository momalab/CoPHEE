module B4ISH1025_EW (
  inout  wire PADIO,
  output wire DOUT,
  input  wire DIN,
  input  wire EN,
  input  wire R_EN,
  input  wire PULL_UP,
  input  wire PULL_DOWN
);

//synopsy translate_off
//pragma  translate_off
assign PADIO = EN   ? DIN   : 1'bZ;
assign DOUT  = R_EN ? PADIO : 1'b0;

//synopsy translate_on
//pragma  translate_on

endmodule
