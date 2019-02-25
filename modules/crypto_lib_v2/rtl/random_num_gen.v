module random_num_gen #(
  parameter  NBITS = 2048 )(
  input  wire               clk,
  input  wire               rst_n,
  input  wire               enable_p,
  input  wire               bypass,
  input  wire [11:0]        maxbits,
  output wire               done_p,
  output wire [NBITS-1 :0]  y
);

wire [4:0]  y_loc;

reg        vn_din;
reg        wait4_done;
reg [2:0]  cnt;
reg [4:0]  en_loc;


trng_wrap trng_wrap_inst0 (
  .clk      (clk),          //input   wire 
  .rst_n    (rst_n),        //input   wire 
  .en       (en_loc[0]),    //input   wire 
  .y        (y_loc[0])      //output  wire 
);

trng_wrap trng_wrap_inst1 (
  .clk      (clk),          //input   wire 
  .rst_n    (rst_n),        //input   wire 
  .en       (en_loc[1]),    //input   wire 
  .y        (y_loc[1])      //output  wire 
);

trng_wrap trng_wrap_inst2 (
  .clk      (clk),          //input   wire 
  .rst_n    (rst_n),        //input   wire 
  .en       (en_loc[2]),    //input   wire 
  .y        (y_loc[2])      //output  wire 
);

trng_wrap trng_wrap_inst3 (
  .clk      (clk),          //input   wire 
  .rst_n    (rst_n),        //input   wire 
  .en       (en_loc[3]),    //input   wire 
  .y        (y_loc[3])      //output  wire 
);

trng_wrap trng_wrap_inst4 (
  .clk      (clk),          //input   wire 
  .rst_n    (rst_n),        //input   wire 
  .en       (en_loc[4]),    //input   wire 
  .y        (y_loc[4])      //output  wire 
);



vn_corrector #(
  .NBITS (NBITS))
  vn_corrector_inst (
  .clk      (clk),         //input                wire 
  .rst_n    (rst_n),       //input                wire 
  .bypass   (bypass),      //input                wire 
  .enable_p (en_trig),     //input                wire 
  .din      (vn_din),      //input                wire 
  .maxbits  (maxbits),
  .done_p   (done_p),      //output               wire 
  .y        (y)            //output [NBITS-1 :0]  wire 
);


 always @* begin
   if (cnt == 3'b011) begin
     vn_din = y_loc[0];
   end
   else if (cnt == 3'b100) begin
     vn_din = y_loc[1];
   end
   else if (cnt == 3'b000) begin
     vn_din = y_loc[2];
   end
   else if (cnt == 3'b001) begin
     vn_din = y_loc[3];
   end
   else if (cnt == 3'b010) begin
     vn_din = y_loc[4];
   end
   else begin
     vn_din = 1'b0;
   end
 end
      
 always @ (posedge clk or negedge rst_n) begin
   if (rst_n == 1'b0) begin
     cnt        <= 3'b111;
     wait4_done <= 1'b0;
   end
   else begin
     if (enable_p == 1'b1) begin
       cnt        <= 3'b0;
       wait4_done <= 1'b1;
     end
     else if (done_p == 1'b1) begin
       cnt        <= 3'b111;
       wait4_done <= 1'b0;
     end
     else if (wait4_done == 1'b1) begin
       if (cnt[2] == 1'b1) begin
         cnt <= 3'b0;
       end
       else begin
         cnt <= cnt + 1'b1;
       end
     end
     else begin
       cnt        <= 3'b111;
       wait4_done <= 1'b0;
     end
   end
 end

 assign en_trig = (cnt < 3'b011) ? 1'b1 : 1'b0; 

 always @ (posedge clk or negedge rst_n) begin
   if (rst_n == 1'b0) begin
     en_loc <= 5'b0;
   end
   else if (done_p == 1'b1) begin
     en_loc <= 5'b0;
   end
   else begin
     en_loc[0] <= en_trig;
     en_loc[1] <= en_loc[0];
     en_loc[2] <= en_loc[1];
     en_loc[3] <= en_loc[2];
     en_loc[4] <= en_loc[3];
   end
 end


endmodule
