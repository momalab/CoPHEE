module multiplier #(
  parameter NBITS = 2048;
  ) (
  input  [NBITS-1 :0] a,
  input  [NBITS-1 :0] b,
  input  [NBITS-1 :0] m,
  output [NBITS-1 :0] y
);
  wire [NBITS+1-1 :0] y_int;

  assign y_int = a*b;
  
endmodule
  
