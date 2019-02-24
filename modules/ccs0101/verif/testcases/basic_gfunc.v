uartm_read     (.addr(32'h400200CC),  .data(rx_reg));

cleq_init (.n (N), .nsq (nsq), .fkf (fkf), .rand0 (rand0), .rand1 (rand1), .log2ofn(log2ofn), .maxbits (log2ofn2), .nsq_modulus (1'b1), .hw_rand (1'b0), .bypvn (1'b1));
uartm_write (.addr(GPCFG_CLCTLP_ADDR),           .data(32'h0 | CLCTLP_UPDTRNG));
uartm_gfunc (.arga (arga),.argb (argb));



$display($time, " << Value of N             %d", N);
$display($time, " << Value of NSQ           %d", nsq);
$display($time, " << Value of fkf           %d", fkf);
$display($time, " << Value of rand0         %d", rand0);
$display($time, " << Value of rand1         %d", rand1);
$display($time, " << Value of log2ofn       %d", log2ofn);
$display($time, " << Value of maxbits       %d", log2ofn2);
