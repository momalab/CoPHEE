#!/bin/sh

echo "---------------------Running vlogan-----------------"
   vlogan -sverilog ../rtl/montgomery_wrap.v  ../rtl/montgomery_mul.v ../rtl/mod_mul_il.v ../rtl/montgomery_from_conv.v ../rtl/montgomery_to_conv.v  montgomery_wrap_tb.v 

echo "---------------------vlogan Done--------------------"
echo "---------------------Running VCS--------------------"
vcs -debug montgomery_wrap_tb

echo "---------------------VCS    Done--------------------"
./simv -gui -i ./runtime_montgomery_wrap.tcl &
