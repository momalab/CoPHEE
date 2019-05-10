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


module hw_rng_fsm #(
 parameter NBITS = 1024)(  
 input  wire           hclk,
 input  wire           hresetn,
 input  wire           done_irq_p_rng0,
 input  wire           done_irq_p_rng1,
 input  wire           done_irq_p_bin_ext_gcd,
 input  wire           cl_inverr,
 input  wire [7:0]     rng_errcnt_max,
 input  wire [NBITS-1:0]  rng0_y,
 input  wire [NBITS-1:0]  rng1_y,
 output reg               enable_p_rng1,
 output reg  [NBITS-1:0]  cleq_rand0_hw,
 output reg  [NBITS-1:0]  cleq_rand1_hw
);


  localparam RNG_IDLE  = 2'b00;
  localparam GCD_CALC  = 2'b01;
  localparam GCD_CHECK = 2'b10;
  localparam RNG_REGEN = 2'b11;

  reg [1:0]    rng0_curr_state;
  reg [1:0]    rng0_nxt_state;
  reg [1:0]    rng1_curr_state;
  reg [1:0]    rng1_nxt_state;
  reg [10:0]   rand_err_gen_cnt;


  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      rng0_curr_state   <= 2'b0;
      rng1_curr_state   <= 2'b0;
    end
    else begin
      rng0_curr_state   <= rng0_nxt_state;
      rng1_curr_state   <= rng1_nxt_state;
    end
  end
 


  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      cleq_rand0_hw   <= {NBITS{1'b0}};
    end
    else if (done_irq_p_rng0) begin
      cleq_rand0_hw   <= {rng0_y[NBITS-1:1], 1'b1};   
    end
    else if (rng0_curr_state == RNG_REGEN) begin
      cleq_rand0_hw   <= cleq_rand0_hw + 2'b10;
    end
  end
 
  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      cleq_rand1_hw   <= {NBITS{1'b0}};
    end
    else if (done_irq_p_rng1) begin
      cleq_rand1_hw   <= {rng1_y[NBITS-1:1], 1'b1};   
    end
    else if (rng1_curr_state == RNG_REGEN) begin
      cleq_rand1_hw   <= cleq_rand1_hw + 2'b10;
    end
  end



 //Check if random number is co-prime with n
  always @* begin
    case (rng0_curr_state)
      RNG_IDLE :  begin
        if (done_irq_p_rng0) begin
          rng0_nxt_state = GCD_CALC;
        end
        else begin
          rng0_nxt_state = RNG_IDLE;
        end
      end
      GCD_CALC :  begin
        if (done_irq_p_bin_ext_gcd) begin
          rng0_nxt_state = GCD_CHECK;
        end
        else begin
          rng0_nxt_state = GCD_CALC;
        end
      end
      GCD_CHECK :  begin
        if (rand_err_gen_cnt == rng_errcnt_max ) begin
          rng0_nxt_state = RNG_IDLE;
        end
        else if (cl_inverr == 1'b1) begin
          rng0_nxt_state = RNG_REGEN;
        end
        else begin
          rng0_nxt_state = RNG_IDLE;
        end
      end
      RNG_REGEN :  begin
        rng0_nxt_state = GCD_CALC;
      end
      default :  begin
        rng0_nxt_state = RNG_IDLE;
      end
    endcase
  end
  
  always @* begin
    case (rng1_curr_state)
      RNG_IDLE :  begin
        if (done_irq_p_rng1) begin
          rng1_nxt_state = GCD_CALC;
        end
        else begin
          rng1_nxt_state = RNG_IDLE;
        end
      end
      GCD_CALC :  begin
        if (done_irq_p_bin_ext_gcd) begin
          rng1_nxt_state = GCD_CHECK;
        end
        else begin
          rng1_nxt_state = GCD_CALC;
        end
      end
      GCD_CHECK :  begin
        if (rand_err_gen_cnt == rng_errcnt_max ) begin
          rng1_nxt_state = RNG_IDLE;
        end
        else if (cl_inverr == 1'b1) begin
          rng1_nxt_state = RNG_REGEN;
        end
        else begin
          rng1_nxt_state = RNG_IDLE;
        end
      end
      RNG_REGEN :  begin
        rng1_nxt_state = GCD_CALC;
      end
      default :  begin
        rng1_nxt_state = RNG_IDLE;
      end
    endcase
  end
  

  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      enable_p_rng1 = 1'b0;
    end
    else begin
      if ((rng0_curr_state == GCD_CHECK) && (rng0_nxt_state == RNG_IDLE)) begin
        enable_p_rng1 = 1'b1;
      end
      else begin
        enable_p_rng1 = 1'b0;
      end
    end
  end


  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      rand_err_gen_cnt = 10'b0;
    end
    else begin
      if (((rng0_curr_state == GCD_CHECK) || (rng1_curr_state == GCD_CHECK)) && cl_inverr) begin
        rand_err_gen_cnt = rand_err_gen_cnt + 1'b1;
      end
      else if ((rng0_curr_state == GCD_CHECK) && (rng0_nxt_state == RNG_IDLE)) begin
        rand_err_gen_cnt = 10'b0;
      end
      else if ((rng1_curr_state == GCD_CHECK) && (rng1_nxt_state == RNG_IDLE)) begin
        rand_err_gen_cnt = 10'b0;
      end
    end
  end
   
  assign done_irq_p_rng = (rng1_curr_state == GCD_CHECK) && (rng1_nxt_state == RNG_IDLE);

endmodule
