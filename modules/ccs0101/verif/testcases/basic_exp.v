
uartm_read     (.addr(32'h400200CC),  .data(rx_reg));

cleq_init (.n (5), .nsq (25), .fkf (23), .rand0 (3), .rand1 (2), .log2ofn(log2ofn), .maxbits (log2ofn2), .nsq_modulus (1'b1), .hw_rand (1'b0), .bypvn (1'b1));
uartm_modmul (.arga (arga),.argb (argb));
uartm_modexp (.arga (arga),.argb (argb));
uartm_modinv (.arga (arga),.argb (argb));
