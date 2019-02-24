#!/bin/sh

echo "---------------------Running vlogan-----------------"
   vlogan -sverilog ../rtl/bin_ext_gcd.v   bin_ext_gcd_tb.v 

echo "---------------------vlogan Done--------------------"
echo "---------------------Running VCS--------------------"
vcs -debug bin_ext_gcd_tb

echo "---------------------VCS    Done--------------------"
#./simv -gui -i ./runtime_bin_ext_gcd.tcl &
./simv -l simv.log
