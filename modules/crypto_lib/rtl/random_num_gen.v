/**********************************************************************************
    This module is part of the project CoPHEE.
    CoPHEE: A co-processor for partially homomorphic encrypted encryption
    Copyright (C) 2019  Michail Maniatakos
    New York University Abu Dhabi, wp.nyu.edu/momalab/

    If find any of our work useful, please cite our publication:
      M. Nabeel, M. Ashraf, E. Chielle, N.G. Tsoutsos, and M. Maniatakos.
      "CoPHEE: Co-processor for Partially Homomorphic Encrypted Execution". 
      In: IEEE Hardware-Oriented Security and Trust (HOST). 

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
**********************************************************************************/


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
