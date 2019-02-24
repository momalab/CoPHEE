#!/bin/sh

echo "---------------------Running vlogan-----------------"
   vlogan -sverilog ../rtl/mod_exp.v  ../rtl/montgomery_mul.v ../rtl/mod_mul_il.v ../rtl/montgomery_from_conv.v ../rtl/montgomery_to_conv.v  mod_exp_tb.v 

echo "---------------------vlogan Done--------------------"
echo "---------------------Running VCS--------------------"
vcs -debug mod_exp_tb

echo "---------------------VCS    Done--------------------"
./simv -gui -i ./runtime_mod_exp.tcl &
