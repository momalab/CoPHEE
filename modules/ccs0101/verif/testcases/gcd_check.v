uartm_read     (.addr(32'h400200CC),  .data(rx_reg));
cleq_init (.n (N), .nsq (nsq), .fkf (fkf), .rand0 (rand0), .rand1 (rand1), .log2ofn(log2ofn), .maxbits (log2ofn2), .nsq_modulus (1'b1), .hw_rand (1'b0), .bypvn (1'b1));
uartm_modinv (.arga (1983300077),.argb (826020195));
uartm_modinv (.arga (25),.argb (29));
