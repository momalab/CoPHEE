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



always @* begin
  if (random_num_gen_tb.u_dut_inst.trng_wrap_inst0.en == 1'b1) begin
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[0].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[0].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[1].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[1].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[2].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[2].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[3].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[3].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[4].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[4].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[5].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[5].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[6].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[6].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[7].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[7].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[8].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[8].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[9].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[9].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[10].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[10].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[11].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[11].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[12].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[12].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[13].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[13].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[14].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[14].u_trng_inst.inv2_a = $urandom%1;
  end
  else begin
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[0].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[0].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[1].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[1].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[2].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[2].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[3].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[3].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[4].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[4].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[5].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[5].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[6].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[6].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[7].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[7].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[8].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[8].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[9].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[9].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[10].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[10].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[11].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[11].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[12].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[12].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[13].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[13].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[14].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst0.trng_inst[14].u_trng_inst.inv2_a = $urandom%1;
  end
end

always @* begin
  if (random_num_gen_tb.u_dut_inst.trng_wrap_inst1.en == 1'b1) begin
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[0].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[0].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[1].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[1].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[2].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[2].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[3].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[3].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[4].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[4].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[5].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[5].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[6].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[6].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[7].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[7].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[8].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[8].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[9].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[9].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[10].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[10].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[11].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[11].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[12].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[12].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[13].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[13].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[14].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[14].u_trng_inst.inv2_a = $urandom%1;
  end
  else begin
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[0].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[0].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[1].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[1].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[2].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[2].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[3].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[3].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[4].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[4].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[5].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[5].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[6].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[6].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[7].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[7].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[8].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[8].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[9].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[9].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[10].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[10].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[11].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[11].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[12].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[12].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[13].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[13].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[14].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst1.trng_inst[14].u_trng_inst.inv2_a = $urandom%1;
  end
end

always @* begin
  if (random_num_gen_tb.u_dut_inst.trng_wrap_inst2.en == 1'b1) begin
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[0].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[0].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[1].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[1].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[2].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[2].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[3].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[3].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[4].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[4].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[5].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[5].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[6].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[6].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[7].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[7].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[8].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[8].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[9].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[9].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[10].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[10].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[11].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[11].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[12].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[12].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[13].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[13].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[14].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[14].u_trng_inst.inv2_a = $urandom%1;
  end
  else begin
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[0].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[0].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[1].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[1].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[2].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[2].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[3].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[3].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[4].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[4].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[5].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[5].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[6].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[6].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[7].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[7].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[8].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[8].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[9].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[9].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[10].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[10].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[11].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[11].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[12].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[12].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[13].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[13].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[14].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst2.trng_inst[14].u_trng_inst.inv2_a = $urandom%1;
  end
end

always @* begin
  if (random_num_gen_tb.u_dut_inst.trng_wrap_inst3.en == 1'b1) begin
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[0].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[0].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[1].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[1].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[2].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[2].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[3].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[3].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[4].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[4].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[5].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[5].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[6].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[6].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[7].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[7].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[8].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[8].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[9].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[9].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[10].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[10].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[11].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[11].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[12].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[12].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[13].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[13].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[14].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[14].u_trng_inst.inv2_a = $urandom%1;
  end
  else begin
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[0].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[0].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[1].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[1].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[2].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[2].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[3].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[3].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[4].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[4].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[5].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[5].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[6].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[6].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[7].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[7].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[8].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[8].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[9].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[9].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[10].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[10].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[11].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[11].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[12].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[12].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[13].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[13].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[14].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst3.trng_inst[14].u_trng_inst.inv2_a = $urandom%1;
  end
end

always @* begin
  if (random_num_gen_tb.u_dut_inst.trng_wrap_inst0.en == 1'b1) begin
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[0].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[0].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[1].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[1].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[2].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[2].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[3].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[3].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[4].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[4].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[5].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[5].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[6].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[6].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[7].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[7].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[8].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[8].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[9].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[9].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[10].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[10].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[11].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[11].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[12].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[12].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[13].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[13].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[14].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[14].u_trng_inst.inv2_a = $urandom%1;
  end
  else begin
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[0].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[0].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[1].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[1].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[2].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[2].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[3].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[3].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[4].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[4].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[5].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[5].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[6].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[6].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[7].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[7].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[8].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[8].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[9].u_trng_inst.inv1_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[9].u_trng_inst.inv2_a  = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[10].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[10].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[11].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[11].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[12].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[12].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[13].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[13].u_trng_inst.inv2_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[14].u_trng_inst.inv1_a = $urandom%1;
    force random_num_gen_tb.u_dut_inst.trng_wrap_inst4.trng_inst[14].u_trng_inst.inv2_a = $urandom%1;
  end
end


