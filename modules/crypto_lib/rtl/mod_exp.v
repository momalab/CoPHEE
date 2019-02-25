module mod_exp #(
  parameter NBITS = 2048) (
  input               clk,
  input               rst_n,
  input               enable_p,
  input  [NBITS-1 :0] a,
  input  [NBITS-1 :0] exp,
  input  [NBITS-1 :0] m,
  input  [11      :0] m_size,
  input  [NBITS-1 :0] r_red,
  output [NBITS-1 :0] y,
  output              done_irq_p
);

//------------------------
//reg/wire declaration
//------------------------
  reg  [NBITS-1 :0] temp_rslt_loc; 
  reg  [NBITS-1 :0] a_loc; 
  reg  [NBITS-1 :0] b_loc; 
  reg  [NBITS-1 :0] sqr_loc; 
  reg  [10 :0]      exp_loc; 
  reg               en_p_frm_mnt; 
  reg               en_montgomery_mul_p; 
  reg  [4 :0]       curr_state; 
  reg  [4 :0]       next_state; 

wire [NBITS-1 :0] a_conv ;
wire [NBITS-1 :0] b_conv ;
wire [NBITS-1 :0] y_inter ;
wire              done_irq_p_mul;
wire              done_irq_p_a;

localparam  IDLE        = 5'b00001;
localparam  CONVTOMONT  = 5'b00010;
localparam  CALCSQR     = 5'b00100;
localparam  CALCMUL     = 5'b01000;
localparam  EXPSHIFT    = 5'b10000;


  always @ (posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
      a_loc         <= {NBITS{1'b0}};
      b_loc         <= {NBITS{1'b0}};
      en_montgomery_mul_p  <= 1'b0;
    end
    else begin
      if ((curr_state == EXPSHIFT) && (next_state == CALCSQR)) begin
        a_loc        <= sqr_loc;
        b_loc        <= sqr_loc;
        en_montgomery_mul_p <= 1'b1;
      end
      else if ((curr_state == CALCSQR) && (next_state == CALCMUL)) begin
        a_loc        <= temp_rslt_loc;
        b_loc        <= y_inter;
        en_montgomery_mul_p <= 1'b1;
      end
      else begin
        en_montgomery_mul_p <= 1'b0;
      end
    end
  end

  always @ (posedge clk or negedge  rst_n) begin
    if (rst_n == 1'b0) begin
      sqr_loc       <= {NBITS{1'b0}};
    end
    else begin
      if ((curr_state == CONVTOMONT) && (done_irq_p_a == 1'b1)) begin
        sqr_loc  <= a_conv;
      end
      if ((curr_state == CALCSQR) && (done_irq_p_mul == 1'b1)) begin
        sqr_loc  <= y_inter;
      end
    end
  end

  always @ (posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
      temp_rslt_loc <= {NBITS{1'b0}};
    end
    else begin
      if (done_irq_p_a == 1'b1) begin
        if(exp_loc[0] == 1'b1) begin
          temp_rslt_loc  <= a_conv;
        end
        else begin
          temp_rslt_loc <= {NBITS{1'b0}};
        end
      end
      else if ((curr_state == CALCMUL) && (done_irq_p_mul == 1'b1)) begin
        temp_rslt_loc  <= y_inter;
      end
    end
  end

  always @ (posedge clk or negedge  rst_n) begin
    if (rst_n == 1'b0) begin
      exp_loc       <= 11'h7FF;
    end
    else begin
      if (enable_p == 1'b1) begin
        exp_loc  <=  exp;
      end
      else if ((next_state == EXPSHIFT)) begin
        exp_loc  <= {1'b0, exp_loc[10:1]};
      end
    end
  end


  always @ (posedge clk or negedge  rst_n) begin
    if (rst_n == 1'b0) begin
      en_p_frm_mnt  <= 1'b0;
    end
    else begin
      if ((curr_state == EXPSHIFT) && (next_state == IDLE)) begin
        en_p_frm_mnt  <= 1'b1;
      end
      else begin
        en_p_frm_mnt  <= 1'b0;
      end
    end
  end

  
  always @* begin
    case (curr_state)
      IDLE : begin
        if (enable_p == 1'b1) begin
          next_state = CONVTOMONT;
        end
        else begin
          next_state = IDLE;
        end
      end
      CONVTOMONT : begin
        if (done_irq_p_a == 1'b1) begin
          next_state = EXPSHIFT;
        end
        else begin
          next_state = CONVTOMONT;
        end
      end
      CALCSQR : begin
        if (done_irq_p_mul == 1'b1) begin
          if (exp_loc[0] == 1'b1) begin
            next_state = CALCMUL;
          end
          else begin
            next_state = EXPSHIFT;
          end
        end
        else begin
          next_state = CALCSQR;
        end
      end
      CALCMUL : begin
        if (done_irq_p_mul == 1'b1) begin
          next_state = EXPSHIFT;
        end
        else begin
          next_state = CALCMUL;
        end
      end
      EXPSHIFT : begin
        if (|exp_loc == 1'b1) begin
          next_state = CALCSQR;
        end
        else begin
          next_state = IDLE;
        end
      end
      default : begin
          next_state = curr_state;
      end
    endcase
  end

 always @ (posedge clk or negedge rst_n) begin
   if (rst_n == 1'b0) begin
     curr_state <= 5'b1;
   end
   else begin
     curr_state <= next_state;
   end
 end
 


montgomery_to_conv #(
  .NBITS (NBITS)
 ) u_montgomery_to_conv_a_inst (
  .clk               (clk),             //input               
  .rst_n             (rst_n),           //input               
  .enable_p          (enable_p),        //input               
  .a                 (a),               //input  [NBITS-1 :0] 
  .m                 (m),               //input  [NBITS-1 :0] 
  .r_red             (r_red),           //input  [NBITS-1 :0] 
  .y                 (a_conv),          //output [NBITS-1 :0] 
  .done_irq_p        (done_irq_p_a)     //output              
);


montgomery_mul #(
  .NBITS (NBITS)
 ) u_montgomery_mul_inst (
  .clk               (clk),             //input               
  .rst_n             (rst_n),           //input               
  .enable_p          (en_montgomery_mul_p),    //input               
  .a                 (a_loc),          //input  [NBITS-1 :0] 
  .b                 (b_loc),          //input  [NBITS-1 :0] 
  .m                 (m),               //input  [NBITS-1 :0] 
  .m_size            (m_size),          //input  [10      :0] 
  .y                 (y_inter),         //output [NBITS-1 :0] 
  .done_irq_p        (done_irq_p_mul)   //output              
);



montgomery_from_conv #(
   .NBITS (NBITS)
 ) u_montgomery_from_conv (
  .clk               (clk),                    //input               
  .rst_n             (rst_n),                  //input               
  .enable_p          (en_p_frm_mnt),           //input               
  .a                 (temp_rslt_loc),          //input  [NBITS-1 :0] 
  .m                 (m),                      //input  [NBITS-1 :0] 
  .m_size            (m_size),                 //input  [10      :0] 
  .y                 (y),                      //output [NBITS-1 :0] 
  .done_irq_p        (done_irq_p)              //output              
);



endmodule


