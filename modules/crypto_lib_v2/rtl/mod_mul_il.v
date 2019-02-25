`timescale 1 ns/1 ps
//----------------------------------------
//INPUT: X, Y,M with 0 ? X, Y ? M
//OUTPUT: P = X · Y mod M
//n: number of bits of X
//xi: ith bit of X
//1. P = 0;
//2. for (i = n - 1; i >= 0; i = i - 1){
//3. P = 2· P;
//4. I = xi · Y ;
//5. P = P + I;
//6. if (P >= M) P = P - M;
//7. if (P >= M) P = P - M; }
//----------------------------------------

module mod_mul_il #(
  parameter NBITS = 2048
 ) (
  input               clk,
  input               rst_n,
  input               enable_p,
  input  [NBITS-1 :0] a,
  input  [NBITS-1 :0] b,
  input  [NBITS-1 :0] m,
  output [NBITS-1 :0] y,
  output              done_irq_p
);

//--------------------------------------
//reg/wire declaration
//--------------------------------------

reg  [NBITS-1 :0] a_loc;
reg  [NBITS-1 :0] y_loc;
reg  [NBITS   :0] b_loc;
reg               done_irq_p_loc;
reg               done_irq_p_loc_d;

wire [NBITS   :0] y_loc_accum;
wire [NBITS   :0] y_loc_accum_red;
wire [NBITS-1 :0] b_loc_red;


//calculate (a*b)%m
assign b_loc_red        = (b_loc > m) ? (b_loc - m) : b_loc;
//assign y_loc_accum      =  b_loc_red*a_loc[0] + y_loc;
assign y_loc_accum      =  a_loc[0] ? (b_loc_red + y_loc) : y_loc;
assign y_loc_accum_red  = (y_loc_accum >= m)   ?  (y_loc_accum -  m) :
                           y_loc_accum ;

always @ (posedge clk or negedge rst_n) begin
  if (rst_n == 1'b0) begin
    y_loc <= {NBITS{1'b0}};
    a_loc <= {NBITS{1'b0}};
    b_loc <= {(NBITS+1){1'b0}};
  end
  else begin
      if (enable_p == 1'b1) begin
        a_loc <= {1'b0, a[NBITS-1 :1]};
        b_loc <= {b, 1'b0};
        if (a[0] == 1'b1) begin
          y_loc <= b;
        end
        else begin
          y_loc <= {NBITS{1'b0}};
        end
      end
      else if (|a_loc) begin
        y_loc <= y_loc_accum_red[NBITS-1 :0];
        b_loc <= {b_loc_red, 1'b0};
        a_loc <= {1'b0, a_loc[NBITS-1:1]};
      end 
  end
end

  
  always @ (posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
      done_irq_p_loc    <= 1'b0;
      done_irq_p_loc_d  <= 1'b0;
    end
    else begin
      done_irq_p_loc    <= |a_loc | enable_p;  //enable_p for the case a == 1
      done_irq_p_loc_d  <= done_irq_p_loc  ;
    end
  end

  assign done_irq_p =  done_irq_p_loc_d & ~done_irq_p_loc;
  assign y          =  y_loc;



endmodule
