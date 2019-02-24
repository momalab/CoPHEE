#!/bin/sh

echo "---------------------Running vlogan-----------------"
   vlogan -sverilog ../rtl/mod_mul_il.v   mod_mul_il_tb.v 

echo "---------------------vlogan Done--------------------"
echo "---------------------Running VCS--------------------"
vcs -debug mod_mul_il_tb

echo "---------------------VCS    Done--------------------"
./simv -gui -i ./runtime_mod_mul_il.tcl &
