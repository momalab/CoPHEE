
module montgomery_wrap #(
  parameter NBITS = 2048
 ) (
  input               clk,
  input               rst_n,
  input               enable_p,
  input  [NBITS-1 :0] a,
  input  [NBITS-1 :0] b,
  input  [NBITS-1 :0] m,
  input  [10      :0] m_size,
  input  [NBITS-1 :0] r_red,
  output [NBITS-1 :0] y,
  output              done_irq_p
);


wire [NBITS-1 :0] a_conv ;
wire [NBITS-1 :0] b_conv ;
wire [NBITS-1 :0] y_inter ;

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

montgomery_to_conv #(
  .NBITS (NBITS)
 ) u_montgomery_to_conv_b_inst (
  .clk               (clk),             //input               
  .rst_n             (rst_n),           //input               
  .enable_p          (done_irq_p_a),    //input               
  .a                 (b),               //input  [NBITS-1 :0] 
  .m                 (m),               //input  [NBITS-1 :0] 
  .r_red             (r_red),           //input  [NBITS-1 :0] 
  .y                 (b_conv),          //output [NBITS-1 :0] 
  .done_irq_p        (done_irq_p_b)     //output              
);


montgomery_mul #(
  .NBITS (NBITS)
 ) u_montgomery_mul_inst (
  .clk               (clk),             //input               
  .rst_n             (rst_n),           //input               
  .enable_p          (done_irq_p_b),    //input               
  .a                 (a_conv),          //input  [NBITS-1 :0] 
  .b                 (b_conv),          //input  [NBITS-1 :0] 
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
  .enable_p          (done_irq_p_mul),         //input               
  .a                 (y_inter),                //input  [NBITS-1 :0] 
  .m                 (m),                      //input  [NBITS-1 :0] 
  .m_size            (m_size),                 //input  [10      :0] 
  .y                 (y),                      //output [NBITS-1 :0] 
  .done_irq_p        (done_irq_p)              //output              
);


endmodule
