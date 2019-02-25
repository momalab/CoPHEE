//------------------------------------------------------------
//Input X,Y < p < 2^(k-1)
// with 2^(k-1) < p < 2^n and p = 2t + 1. with t is natural no.
//Output u = X.Y.2^(-k) mod p
//1.  u =0
//2.  for i = 0; i < n; i++ do
//      u = u + xi.Y
//      if u[0] == 1'b1 then
//        u = u + p;
//      end if
//      u = u div 2;
//    end for
//3.  if u >= p then
//      u = u -p
//    end if
//------------------------------------------------------------


module montgomery_mul #(
  parameter NBITS = 2048
 ) (
  input               clk,
  input               rst_n,
  input               enable_p,
  input  [NBITS-1 :0] a,
  input  [NBITS-1 :0] b,
  input  [NBITS-1 :0] m,
  input  [11      :0] m_size,
  output [NBITS-1 :0] y,
  output              done_irq_p
);

//--------------------------------------
//reg/wire declaration
//--------------------------------------

reg [NBITS   :0] y_loc;
reg [NBITS-1 :0] a_loc;
reg              done_irq_p_loc;
reg              done_irq_p_loc_d;
reg [11      :0] m_size_cnt;


wire [NBITS+1 :0] b_loc_mul_a_loc_i ;
wire [NBITS+1 :0] y_loc_for_red ;
//--------------------------------------
//a*b*(2^-n) mod m
//--------------------------------------

//assign b_loc_mul_a_loc_i    = b*a_loc[0] + y_loc;
assign b_loc_mul_a_loc_i    = a_loc[0] ? (b + y_loc) : y_loc;
assign y_loc_for_red        = (b_loc_mul_a_loc_i[0] == 1'b1) ? (b_loc_mul_a_loc_i + m ) : b_loc_mul_a_loc_i;

always @ (posedge clk or negedge rst_n) begin
  if (rst_n == 1'b0) begin
    y_loc          <= {(NBITS+1){1'b0}};
    a_loc          <= {NBITS{1'b1}};
    done_irq_p_loc <= 1'b0;
  end
  else begin
    if (enable_p == 1'b1) begin
      a_loc          <= a;
      y_loc          <= {(NBITS+1){1'b0}};
      done_irq_p_loc <= 1'b0;
    end
    else if (|m_size_cnt[11:0]) begin
      y_loc <= {y_loc_for_red[NBITS+1 :1]};
      a_loc <= {1'b0, a_loc[NBITS-1 :1]};
    end 
    else begin
      if (y_loc >= m) begin
        y_loc <= y_loc - m;
      end
      else begin
        done_irq_p_loc <= 1'b1;
      end
    end
  end
end

  
  always @ (posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
      m_size_cnt    <= 12'b0;
    end
    else begin
      if (enable_p == 1'b1) begin
        m_size_cnt    <= m_size;
      end
      else if (|m_size_cnt[11:0]) begin
        m_size_cnt    <= m_size_cnt-1'b1;//(Ex for 2048 bits, one need to count form 0 to 2047)
      end
    end
  end

  
  always @ (posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
      done_irq_p_loc_d  <= 1'b0;
    end
    else begin
      done_irq_p_loc_d  <= done_irq_p_loc  ;
    end
  end



  assign done_irq_p =  done_irq_p_loc & ~done_irq_p_loc_d;
  assign y          =  y_loc[NBITS-1 :0];



endmodule
 
