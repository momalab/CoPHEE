#!/bin/sh

function usage()
{
    echo "Script to run testcases for $PROJECT_NAME"
    echo "./run_test.sh --test <test name in $PROJECT_MODULES/ccs0101/verif/testcases directory>"
    echo "\t-h --help"
    echo "\t--test=test name in $PROJECT_MODULES/ccs0101/verif/testcases directory"
    echo ""
}

    #GUI=  `echo $3 | awk -F= '{print $1}'`
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

if [ ! -f $PROJECT_MODULES/ccs0101/verif/testcases/$TEST_CASE ]
then
echo "---------------------Cannot find \"$TEST_CASE\" in \"$PROJECT_MODULES/ccs0101/verif/testcases\"-----------------"
exit 1
fi

if [ -L $PROJECT_MODULES/ccs0101/verif/hex/test.hex ]
then
 rm $PROJECT_MODULES/ccs0101/verif/hex/test.hex
fi
 ln -s $PROJECT_MODULES/ccs0101/verif/testcases/$TEST_CASE $PROJECT_MODULES/ccs0101/verif/hex/test.hex

if [ -f inter.vpd ]
then
rm -rf inter.vpd simv session.inter.vpd.tcl simv.log  vlogan.log vcs.log csrc ucli.key DVEfiles simv.daidir
fi

echo "---------------------Running vlogan-----------------"

vlogan -sverilog  /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/verilog/sc9_cmos10lpe_base_hvt.v ./ccs0101_tb.v ./pad_model.v ./padring_tb.v $PROJECT_MODULES/ccs0101/rtl/ccs0101_define.v $PROJECT_MODULES/chiplib/rtl/chiplib.v $PROJECT_MODULES/ccs0101/rtl/ccs0101.v $PROJECT_MODULES/padring/rtl/padring.v $PROJECT_MODULES/padring/rtl/rgo_csm65_25v33_50.v $PROJECT_MODULES/chip_core/rtl/chip_core.v $PROJECT_MODULES/uartm/rtl/uartm.v $PROJECT_MODULES/uartm/rtl/uartm_ahb.v $PROJECT_MODULES/uartm/rtl/uartm_rx.v $PROJECT_MODULES/uartm/rtl/uartm_tx.v $PROJECT_MODULES/gpcfg/rtl/gpcfg_rd.v $PROJECT_MODULES/gpcfg/rtl/gpcfg_rd_wr.v $PROJECT_MODULES/gpcfg/rtl/gpcfg_rd_wr_p.v $PROJECT_MODULES/gpcfg/rtl/hw_rng_fsm.v $PROJECT_MODULES/gpcfg/rtl/gpcfg.v $PROJECT_MODULES/crypto_lib/rtl/bin_ext_gcd.v $PROJECT_MODULES/gpcfg/rtl/mod_exp.v $PROJECT_MODULES/crypto_lib/rtl/mod_mul_il.v $PROJECT_MODULES/crypto_lib/rtl/montgomery_from_conv.v $PROJECT_MODULES/crypto_lib/rtl/montgomery_mul.v $PROJECT_MODULES/crypto_lib/rtl/montgomery_to_conv.v $PROJECT_MODULES/crypto_lib/rtl/random_num_gen.v $PROJECT_MODULES/crypto_lib/rtl/trng.v $PROJECT_MODULES/crypto_lib/rtl/trng_wrap.v $PROJECT_MODULES/crypto_lib/rtl/vn_corrector.v $PROJECT_MODULES/ahb_ic/rtl/ahb_ic.v $PROJECT_MODULES/gpio/rtl/gpio.v $PROJECT_MODULES/uarts/rtl/uarts.v $PROJECT_MODULES/uarts/rtl/uarts_tx.v $PROJECT_MODULES/uarts/rtl/uarts_rx.v +incdir+/home/projects/vlsi/ccs0101/design/modules/uartm/rtl +incdir+/home/projects/vlsi/ccs0101/design/modules/uarts/rtl +incdir+/home/projects/vlsi/ccs0101/design/modules/gpcfg/rtl| tee vlogan.log

echo "---------------------vlogan Done--------------------"
echo "---------------------Running VCS--------------------"
vcs +lint=TFIPC-L  -debug ccs0101_tb | tee vcs.log

echo "---------------------VCS    Done--------------------"
#./simv -l -gui -i ./runtime.tcl &
./simv -l simv.log
#./simv
