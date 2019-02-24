#!/bin/sh

echo "---------------------Running vlogan-----------------"
   vlogan -sverilog ../rtl/random_num_gen.v  ../rtl/vn_corrector.v ../rtl/trng.v  ../rtl/trng_wrap.v random_num_gen_tb.v 

echo "---------------------vlogan Done--------------------"
echo "---------------------Running VCS--------------------"
vcs -debug random_num_gen_tb

echo "---------------------VCS    Done--------------------"
./simv -gui -i ./runtime_random_num_gen.tcl &
