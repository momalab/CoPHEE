#!/bin/sh

echo "---------------------Running vlogan-----------------"
   vlogan -sverilog ../rtl/montgomery_mul.v   montgomery_mul_tb.v 

echo "---------------------vlogan Done--------------------"
echo "---------------------Running VCS--------------------"
vcs -debug montgomery_mul_tb

echo "---------------------VCS    Done--------------------"
./simv -gui -i ./runtime_montgomery_mul.tcl &
