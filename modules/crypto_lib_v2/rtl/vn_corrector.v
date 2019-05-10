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


//Von Neumann corrector
module vn_corrector #(
  parameter NBITS = 2048)(
  input  wire               clk,
  input  wire               rst_n,
  input  wire               bypass,
  input  wire               enable_p,
  input  wire               din,
  input  wire [11:0]        maxbits,
  output reg                done_p,
  output reg [NBITS-1 :0]   y
);


reg        enable;
reg        sample_sp;
reg        sample_sp_d;
reg [1:0]  shftd_pair;
reg [11:0] cnt;
wire[11:0] maxbits_div2;

wire       enable_loc;

assign maxbits_div2 = {1'b0, maxbits[11:1]};

assign enable_loc = enable | enable_p;

always @ (posedge clk or negedge rst_n) begin
  if (rst_n == 1'b0) begin
    enable <= 1'b0;
    done_p <= 1'b0;
  end
  else begin
    if (enable_p == 1'b1) begin
      enable <=  1'b1;
    end
    else if (cnt < maxbits_div2) begin
      enable <= 1'b0;
      done_p <= 1'b1;
    end
    else begin
      done_p <= 1'b0;
    end
  end
end


always @ (posedge clk or negedge rst_n) begin
  if (rst_n == 1'b0) begin
    shftd_pair <= 2'b0;
  end
  else begin
    if (enable_loc == 1'b1) begin
      shftd_pair <= {din, shftd_pair[1]};
    end
    else begin
      shftd_pair <= 2'b0;
    end
  end
end

always @ (posedge clk or negedge rst_n) begin
  if (rst_n == 1'b0) begin
    sample_sp   <= 1'b0;
    sample_sp_d <= 1'b0;
  end
  else begin
    if (enable_loc == 1'b1) begin
      sample_sp   <= ~sample_sp;
      sample_sp_d <=  sample_sp;
    end
    else begin
      sample_sp   <= 1'b0;
      sample_sp_d <= 1'b0;
    end
  end
end



always @ (posedge clk or negedge rst_n) begin
  if (rst_n == 1'b0) begin
    cnt   <= 11'b0;
    y     <= {NBITS{1'b0}};
  end
  else begin
    if (enable_loc == 1'b1) begin
      if (bypass == 1'b1) begin
        cnt <= cnt + 1'b1;
        y   <= {din, y[NBITS-1 :1]};
      end
      else if ((sample_sp_d == 1'b1) && (^shftd_pair == 1'b1)) begin
        cnt <= cnt + 1'b1;
        y   <= {shftd_pair[0], y[NBITS-1 :1]};
      end
    end
    else begin
      cnt   <= 11'b0;
      y     <= {NBITS{1'b0}};
    end
  end
end

endmodule
