module mod_add_sub (
  parameter NBITS = 2048) (
  input               clk,
  input               rst_n,
  input               exec_p,
  input               sub,
  input  [10:0]       nbits,
  input  [NBITS-1 :0] a,
  input  [NBITS-1 :0] b,
  input  [NBITS-1 :0] m,
  output [NBITS-1 :0] y,
  output              done_irq_p
);

wire [NBITS :0]   y_loc;

assign b_compl   = ~b + 1'b1;
assign b_compl   = ~b + 1'b1;
assign b_loc     = (sub == 1'b1) ? (b_compl) : b;
assign y_loc     = a + b_loc;
assign y         = y_loc

    
end
