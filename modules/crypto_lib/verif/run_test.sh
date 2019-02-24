#!/bin/sh

function usage()
{
    echo "Script to run testcases for $PROJECT_NAME"
    echo "./run_test.sh --test <IAR workspace dir name presetnt @  $PROJECT_MODULES/ccs0001/sw/>"
    echo "\t-h --help"
    echo "\t--test=Enter the IAR workspace dir name presetnt @  $PROJECT_MODULES/ccs0001/sw/"
    echo ""
}

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $2 | awk -F= '{print $1}'`

    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        -test | --test)
            TEST_CASE=$VALUE
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
    shift
done

#DIRNAME=`echo $HEX_FILE | sed 's/\.hex//'`


if [ ! -d test_$TEST_CASE ]
then
 mkdir  $PROJECT_MODULES/ccs0001/verif/test_$TEST_CASE
fi

if [ -L $PROJECT_MODULES/ccs0001/verif/hex/test.hex ]
then
 rm $PROJECT_MODULES/ccs0001/verif/hex/test.hex
fi

if [ -L $PROJECT_MODULES/ccs0001/sw/$TEST_CASE/Debug/Exe/project.bin ]
then
 rm $PROJECT_MODULES/ccs0001/sw/$TEST_CASE/Debug/Exe/project.bin
fi


if [ -L $PROJECT_MODULES/ccs0001/verif/test_$TEST_CASE/test.txt ]
then
 rm $PROJECT_MODULES/ccs0001/verif/test_$TEST_CASE/test.txt
fi

echo "---------------------Running hexdump-----------------"
#hexdump  -e  '/4 "%08_ax "' -e '/4 "%08X" "\n"'  $PROJECT_MODULES/ccs0001/sw/$TEST_CASE/Debug/Exe/project.bin   | grep -v "*" | awk  '{print "uartm_write","\(" ".addr\(32'\h" $1 "\)\,", ".data\(32\'h" $2 "\)\);"}' > $PROJECT_MODULES/ccs0001/verif/test_$TEST_CASE/test.hex
unzip -o $PROJECT_MODULES/ccs0001/sw/$TEST_CASE/Debug/Exe/project.zip -d  $PROJECT_MODULES/ccs0001/sw/$TEST_CASE/Debug/Exe/
hexdump -n 200                 -v -e  '/4 "%08_ax "' -e '/4 "%08X" "\n"'  $PROJECT_MODULES/ccs0001/sw/$TEST_CASE/Debug/Exe/project.bin >  $PROJECT_MODULES/ccs0001/verif/test_$TEST_CASE/test.txt
hexdump -n 32768 -s 536870912  -v -e  '/4 "%08_ax "' -e '/4 "%08X" "\n"'  $PROJECT_MODULES/ccs0001/sw/$TEST_CASE/Debug/Exe/project.bin >> $PROJECT_MODULES/ccs0001/verif/test_$TEST_CASE/test.txt
$PROJECT_MODULES/ccs0001/verif/hexdump.py  $PROJECT_MODULES/ccs0001/verif/test_$TEST_CASE/test.txt $PROJECT_MODULES/ccs0001/verif/test_$TEST_CASE/test.hex




#cp     $PROJECT_MODULES/ccs0001/verif/hex/$HEX_FILE           $PROJECT_MODULES/ccs0001/verif/test_$TEST_CASE/test.hex
ln -s  $PROJECT_MODULES/ccs0001/verif/test_$TEST_CASE/test.hex  $PROJECT_MODULES/ccs0001/verif/hex/test.hex

if [ -f inter.vpd ]
then
 rm -rf inter.vpd simv session.inter.vpd.tcl simv.log  vlogan.log vcs.log csrc ucli.key DVEfiles simv.daidir
fi

echo "---------------------Running vlogan-----------------"

vlogan -sverilog  /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/verilog/sc9_cmos10lpe_base_hvt.v ccs0001_tb.v padring_tb.v   $PROJECT_MODULES/ccs00xx_defines/rtl/ccs0001_define.v $PROJECT_MODULES/chiplib/rtl/chiplib.v  $PROJECT_MODULES/ccs0001/rtl/ccs0001.v $PROJECT_MODULES/padring/rtl/padring.v $PROJECT_MODULES/padring/rtl/rgo_csm65_25v33_50.v  $PROJECT_MODULES/chip_core/rtl/chip_core.v $PROJECT_MODULES/chip_core/rtl/CORTEXM0DS_wrap.v $PROJECT_MODULES/cortexm0/rtl/CORTEXM0DS.v $PROJECT_MODULES/cortexm0/rtl/cortexm0ds_logic.v $PROJECT_MODULES/uartm/rtl/uartm.v $PROJECT_MODULES/uartm/rtl/uartm_ahb.v  $PROJECT_MODULES/uartm/rtl/uartm_rx.v $PROJECT_MODULES/uartm/rtl/uartm_tx.v $PROJECT_MODULES/chip_core/rtl/gpcfg.v $PROJECT_MODULES/memss/rtl/sram_wrap.v $PROJECT_MODULES/memss/rtl/sram_sp_hde_64k.v   $PROJECT_MODULES/ahb_ic/rtl/ahb_ic.v $PROJECT_MODULES/memss/rtl/pram.v $PROJECT_MODULES/gpio/rtl/gpio.v $PROJECT_MODULES/uarts/rtl/uarts.v $PROJECT_MODULES/uarts/rtl/uarts_tx.v $PROJECT_MODULES/uarts/rtl/uarts_rx.v $PROJECT_MODULES/timer/rtl/timer.v  +incdir+/home/projects/vlsi/ccs0001/design/modules/uartm/rtl  +incdir+/home/projects/vlsi/ccs0001/design/modules/uarts/rtl  | tee vlogan.log

echo "---------------------vlogan Done--------------------"
echo "---------------------Running VCS--------------------"
vcs -debug ccs0001_tb | tee vcs.log

echo "---------------------VCS    Done--------------------"
./simv -gui -i ./runtime.tcl &
