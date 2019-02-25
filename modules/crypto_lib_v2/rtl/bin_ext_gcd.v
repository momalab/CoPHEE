//-------------------------------------------------------------------------------
//INPUT: two positive integers x and y.
//OUTPUT: integers a, b, and v such that ax + by = v, where v = gcd(x, y).
//1. g<-1.
//2. While x and y are both even, do the following: x<-x/2, y<-y/2, g<-2g.
//3. u<-x, v<-y, A<-1, B<-0, C<-0, D<-1.
//4. While u is even do the following:
//   4.1 u<-u/2.
//   4.2 If A = B = 0 (mod 2) then A<-A/2, B<-B/2; otherwise, A<-(A + y)/2,
//       B<-(B - x)/2.
//5. While v is even do the following:
//   5.1 v<-v/2.
//   5.2 If C = D = 0 (mod 2) then C<-C/2, D<-D/2; otherwise, C<-(C +y)/2,
//       D<-(D - x)/2.
//6. If u >= v then u<-u - v, A<-A - C, B<-B - D;
//   otherwise, v<-v - u, C<-C - A, D<-D - B.
//7. If u = 0, then a<-C, b<-D, and return(a, b, g · v); otherwise, go to step 4.
//Example
//x = 49, y = 28, x = qy + r, r = x - qy
//
//01.   49      1         0        x_loc = ax_loc*x + bx_loc*y
//02.   28      0         1        y_loc = ay_loc*x + by_loc*y
//02.1  14    (0+28)/2  (1-49)/2   y_loc = ay_loc*x + by_loc*y
//02.1  14     14        -24       y_loc = ay_loc*x + by_loc*y
//02.2   7      7        -12       y_loc = ay_loc*x + by_loc*y
//03.   42     -6         12       x_loc = ax_loc*x + bx_loc*y
//03.1  21     -3         6        x_loc = ax_loc*x + bx_loc*y
//04.   14     -10        18       x_loc = ax_loc*x + bx_loc*y
//04.1   7     -5         12       x_loc = ax_loc*x + bx_loc*y
//-------------------------------------------------------------------------------
module bin_ext_gcd #(
  parameter NBITS = 2048) (
  input               clk,
  input               rst_n,
  input               enable_p,
  input  [NBITS-1 :0] x,
  input  [NBITS-1 :0] y,
  output [NBITS+2 :0] a,
  output [NBITS+2 :0] b,
  output [NBITS-1 :0] gcd,
  output              done_irq_p
);


//-------------------------------------------------------------------------------
//Register Wire Declaration
//-------------------------------------------------------------------------------
reg signed [NBITS+2 :0] ax_loc;
reg signed [NBITS+2 :0] bx_loc;
reg signed [NBITS+2 :0] ay_loc;
reg signed [NBITS+2 :0] by_loc;

wire signed [NBITS+2 :0] a_loc;
wire signed [NBITS+2 :0] b_loc;

wire signed [NBITS+2 :0] a_loc_add_y;
wire signed [NBITS+2 :0] b_loc_sub_x;


reg [NBITS-1 :0] x_loc;
reg [NBITS-1 :0] y_loc;
reg [NBITS-1 :0] gcd_loc;
reg              done_irq_p_loc;

wire             x_loc_y_loc_comp;
wire [NBITS-1:0] x_loc_y_loc_diff_arg0;
wire [NBITS-1:0] x_loc_y_loc_diff_arg1;
wire [NBITS-1:0] x_loc_y_loc_diff;

wire signed [NBITS+2 :0] ax_loc_ay_loc_diff_arg0;
wire signed [NBITS+2 :0] ax_loc_ay_loc_diff_arg1;
wire signed [NBITS+2 :0] ax_loc_ay_loc_diff;
wire signed [NBITS+2 :0] bx_loc_by_loc_diff_arg0;
wire signed [NBITS+2 :0] bx_loc_by_loc_diff_arg1;
wire signed [NBITS+2 :0] bx_loc_by_loc_diff;

wire [NBITS-1 :0] x_s;
wire [NBITS-1 :0] x_s_loc;
wire [NBITS-1 :0] y_s;


assign x_s = x;
assign y_s = y;

always @ (posedge clk or negedge rst_n) begin
  if (rst_n == 1'b0) begin
    ax_loc   <= {2'b0, {NBITS{1'b0}},     1'b1};
    bx_loc   <= {2'b0, {NBITS{1'b0}},     1'b0};
    ay_loc   <= {2'b0, {NBITS{1'b0}},     1'b0};
    by_loc   <= {2'b0, {NBITS{1'b0}},     1'b1};
    x_loc    <= {NBITS{1'b0}};
    y_loc    <= {NBITS{1'b0}};
    gcd_loc  <= {NBITS{1'b0}};
    done_irq_p_loc <= 1'b0;
  end
  else begin
    if (enable_p == 1'b1) begin
      x_loc    <= x_s;
      y_loc    <= y_s;
      ax_loc   <= {2'b0, {NBITS{1'b0}},     1'b1};
      bx_loc   <= {2'b0, {NBITS{1'b0}},     1'b0};
      ay_loc   <= {2'b0, {NBITS{1'b0}},     1'b0};
      by_loc   <= {2'b0, {NBITS{1'b0}},     1'b1};
      gcd_loc  <= {NBITS{1'b0}};
    end
    else if (|({x_loc,y_loc}) == 1'b1) begin
      if (x_loc == y_loc) begin    //GCD Found
        //if (ay_loc[NBITS+2] == 1'b1) begin
        //  ay_loc <= a_loc_add_y;
        //end
        //else if (ay_loc > y_s) begin
        //  ay_loc <= b_loc_sub_x;
        //end
        //else begin
        x_loc          <= {NBITS{1'b0}};
        y_loc          <= {NBITS{1'b0}};
        gcd_loc        <= x_loc << gcd_loc ;
        done_irq_p_loc <= 1'b1;
        //end
      end 
      else if ((x_loc[0] | y_loc[0]) == 1'b0) begin  //If both are divisible by 2,
        x_loc   <= x_loc >> 1;
        y_loc   <= y_loc >> 1;
        gcd_loc <= gcd_loc + 1'b1;                   // increment the final gcd shift factor
      end
      else if (x_loc[0] == 1'b0) begin               //If x_loc is even
        x_loc   <= x_loc >> 1;
        if ((ax_loc[0] | bx_loc[0]) == 1'b0) begin
          ax_loc <= ax_loc >>> 1;   //div2
          bx_loc <= bx_loc >>> 1;   //div2
        end
        else begin  //ax + by = ax + by + xy - xy = (a+y)x + (b-x)y. Now divide by 2
          ax_loc <= a_loc_add_y >>> 1; 
          bx_loc <= b_loc_sub_x >>> 1;
        end
      end
      else if (y_loc[0] == 1'b0) begin
        y_loc   <= y_loc >> 1;
        if ((ay_loc[0] | by_loc[0]) == 1'b0) begin
          ay_loc <= ay_loc >>> 1;
          by_loc <= by_loc >>> 1;
        end
        else begin
          ay_loc <= a_loc_add_y >>> 1;
          by_loc <= b_loc_sub_x >>> 1;
        end
      end
      else if (x_loc_y_loc_comp == 1'b1) begin
        x_loc   <= x_loc_y_loc_diff;
        ax_loc  <= ax_loc_ay_loc_diff;
        bx_loc  <= bx_loc_by_loc_diff;
      end
      else begin
        y_loc   <= x_loc_y_loc_diff;
        ay_loc  <= ax_loc_ay_loc_diff;
        by_loc  <= bx_loc_by_loc_diff;
      end
    end
    else begin
      done_irq_p_loc <= 1'b0;
    end
  end
end



        assign a_loc       =  (x_loc[0] == 1'b0) ? ax_loc : ay_loc;
        assign b_loc       =  (x_loc[0] == 1'b0) ? bx_loc : by_loc;
        assign x_s_loc     =   x_s;
        assign a_loc_add_y =  (a_loc + y_s);
        assign b_loc_sub_x =  (b_loc - x_s_loc);


        assign x_loc_y_loc_comp        = (x_loc > y_loc)  ? 1'b1 : 1'b0;
        assign x_loc_y_loc_diff_arg0   = x_loc_y_loc_comp ? x_loc : y_loc;
        assign x_loc_y_loc_diff_arg1   = x_loc_y_loc_comp ? y_loc : x_loc;
        assign x_loc_y_loc_diff        = x_loc_y_loc_diff_arg0   - x_loc_y_loc_diff_arg1;

        assign ax_loc_ay_loc_diff_arg0 = x_loc_y_loc_comp ? ax_loc : ay_loc;
        assign ax_loc_ay_loc_diff_arg1 = x_loc_y_loc_comp ? ay_loc : ax_loc;
        assign bx_loc_by_loc_diff_arg0 = x_loc_y_loc_comp ? bx_loc : by_loc;
        assign bx_loc_by_loc_diff_arg1 = x_loc_y_loc_comp ? by_loc : bx_loc;
        assign ax_loc_ay_loc_diff      = ax_loc_ay_loc_diff_arg0 - ax_loc_ay_loc_diff_arg1;
        assign bx_loc_by_loc_diff      = bx_loc_by_loc_diff_arg0 - bx_loc_by_loc_diff_arg1;

        assign a   = ay_loc;
        assign b   = by_loc;
        assign gcd = gcd_loc;
        assign done_irq_p = done_irq_p_loc;

endmodule
