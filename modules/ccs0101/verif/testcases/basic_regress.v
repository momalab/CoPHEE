        $display($time, " #------------------TESTCASE basic_regress STARTED---------------------*");
uartm_read     (.addr(32'h400200CC),  .data(rx_reg));

for (j=0; j < 500; j = j+1) begin
  seed = j;

  $display($time, "---------------Iteration %d SEED %d-----------------", j,j);
  N              = ($random(seed)%2147483648 << 1) + 2'b11;
  nsq            = N*N;
  arga           = $random(seed)%nsq + 1'b1;
  argb           = $random(seed)%nsq + 1'b1;
  fkf            = $random(seed)%nsq;
  rand0          = $random(seed)%N;
  rand1          = $random(seed)%N;
  log2ofn        = $clog2(N);
  log2ofn2       = $clog2(N*N);
  r_for_egcd     = 1'b1 << log2ofn2;
  r_red_for_egcd = r_for_egcd - nsq;


  $display($time, " << ARGA               %d", arga);
  $display($time, " << ARGB               %d", argb);
  $display($time, " << NSQ                %d", nsq);
  $display($time, " << FKF                %d", fkf);
  $display($time, " << RAND0              %d", rand0);
  $display($time, " << RAND1              %d", rand1);
  $display($time, " << LOG2ofN            %d", log2ofn);
  $display($time, " << LOG2ofNSQ          %d", log2ofn2);
  $display($time, " << R_for_EGCD         %d", r_for_egcd);
  $display($time, " << R_RED_FOR_EGCD     %d", r_red_for_egcd);


  cleq_init (.n (N), .nsq (nsq), .fkf (fkf), .rand0 (rand0), .rand1 (rand1), .log2ofn(log2ofn), .maxbits (log2ofn2), .nsq_modulus (1'b1), .hw_rand (1'b0), .bypvn (1'b1));
  uartm_write (.addr(GPCFG_CLCTLP_ADDR),           .data(32'h0 | CLCTLP_UPDTRNG));
  uartm_modmul (.arga (arga),.argb (argb));
//  uartm_modexp (.arga (arga),.argb (argb));
  uartm_modinv (.arga (arga),.argb (argb));
  uartm_gfunc  (.arga (arga),.argb (argb));

end
