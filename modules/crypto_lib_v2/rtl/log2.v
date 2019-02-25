module log2 #(
  parameter NBITS = 2048) (
  input               clk,
  input               rst_n,
  input               enable_p,
  input  [2048-1  :0] a,
  output [10      :0] y,
  output              done_irq_p
);
  
//---------------------------------------------
//Reg wire declaration
//---------------------------------------------
  reg [10:0]    y_loc; 
  reg [NBITS-1:0]  a_loc;
  reg           done_irq_p_loc;
  reg           done_irq_p_loc_d;

  always @ (posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
      a_loc <= {NBITS{1'b0}};
      y_loc <= 11'b0;
    end 
    else begin
      if (enable_p == 1'b1) begin
        a_loc <= {1'b0, a[NBITS-1 :1]};
      end
      else if (|a_loc) begin
        a_loc <= {1'b0, a_loc[NBITS-1 :1]};
        y_loc <= y_loc + 1;
      end 
      else begin
        a_loc <= {NBITS{1'b0}};
        y_loc <= 11'b0;
      end
    end
  end
  

  always @ (posedge clk or negedge of rst_n) begin
    if (rstn == 1'b0) begin
      done_irq_p_loc    <= 1'b0;
      done_irq_p_loc_d  <= 1'b0;
    end
    else begin
      done_irq_p_loc    <= |a_loc;
      done_irq_p_loc_d  <= done_irq_p_loc  ;
    end
  end

  assign done_irq_p =  done_irq_p_loc_d & ~done_irq_p_loc;
  assign y          =  y_loc;



endmodule
