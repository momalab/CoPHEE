
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


