module padring_tb #(
  parameter NUM_PADS  = 100,
  parameter PAD_CTL_W = 2
  )(
  inout  wire [NUM_PADS-1 :0] pad,
  input  wire [NUM_PADS-1 :0] pad_in,
  output wire [NUM_PADS-1 :0] pad_out,
  input  wire [3:0]  pad_ctl[NUM_PADS-1:0]
);


//-------------------------------------------
//localparam, genvar and wire/reg declaration
//-------------------------------------------

genvar i;

generate
  for (i=0; i<NUM_PADS; i=i+1) begin
    B4ISH1025_EW u_pad_inst (
      .PADIO      (pad[i]),
      .DOUT       (pad_out[i]),
      .DIN        (pad_in[i]),
      .EN         (pad_ctl[i][0]),
      .R_EN       (pad_ctl[i][1]),
      .PULL_UP    (pad_ctl[i][2]),
      .PULL_DOWN  (pad_ctl[i][3])
    );
  end
endgenerate

endmodule
