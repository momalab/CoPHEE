date
set_host_options -max_cores 8
set compile_seqmap_propagate_constants     false
set compile_seqmap_propagate_high_effort   false
set compile_enable_register_merging        false
set write_sdc_output_net_resistance        false
set timing_separate_clock_gating_group     true
set verilogout_no_tri tru

set search_path [concat * $search_path]

sh rm -rf ./work
define_design_lib WORK -path ./work

  set_svf ccs0101.svf
  #remove_design -hier *
  set html_log_enable true

  set target_library { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/ccs/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db}
  set link_library { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/ccs/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db\
                     /home/projects/vlsi/libraries/65lpe/ref_lib/aragio/io_pads/timing_lib/nldm/db/rgo_csm65_25v33_lpe_50c_ss_108_297_125.db    \
                     /home/projects/vlsi/libraries/65lpe/ref_lib/arm/memories/sram_sp_hde/timing_lib/USERLIB_ccs_ss_1p08v_1p08v_125c.db \
                   }

  analyze -library WORK -format sverilog { \
                            /home/projects/vlsi/ccs0101/design/modules/ahb_ic/rtl/ahb_ic.v \
                            /home/projects/vlsi/ccs0101/design/modules/uartm/rtl/uartm.v \
                            /home/projects/vlsi/ccs0101/design/modules/uartm/rtl/uartm_rx.v \
                            /home/projects/vlsi/ccs0101/design/modules/uartm/rtl/uartm_tx.v \
                            /home/projects/vlsi/ccs0101/design/modules/uartm/rtl/uartm_ahb.v \
                            /home/projects/vlsi/ccs0101/design/modules/crypto_lib/rtl/montgomery_mul.v \
                            /home/projects/vlsi/ccs0101/design/modules/crypto_lib/rtl/mod_mul_il.v \
                            /home/projects/vlsi/ccs0101/design/modules/gpcfg/rtl/mod_exp.v \
                            /home/projects/vlsi/ccs0101/design/modules/crypto_lib/rtl/montgomery_from_conv.v \
                            /home/projects/vlsi/ccs0101/design/modules/crypto_lib/rtl/montgomery_to_conv.v \
                            /home/projects/vlsi/ccs0101/design/modules/crypto_lib/rtl/bin_ext_gcd.v \
                            /home/projects/vlsi/ccs0101/design/modules/crypto_lib/rtl/trng.v \
                            /home/projects/vlsi/ccs0101/design/modules/crypto_lib/rtl/trng_wrap.v \
                            /home/projects/vlsi/ccs0101/design/modules/crypto_lib/rtl/vn_corrector.v \
                            /home/projects/vlsi/ccs0101/design/modules/crypto_lib/rtl/random_num_gen.v \
                            /home/projects/vlsi/ccs0101/design/modules/gpio/rtl/gpio.v \
                            /home/projects/vlsi/ccs0101/design/modules/uarts/rtl/uarts_rx.v \
                            /home/projects/vlsi/ccs0101/design/modules/uarts/rtl/uarts_tx.v \
                            /home/projects/vlsi/ccs0101/design/modules/uarts/rtl/uarts.v \
                            /home/projects/vlsi/ccs0101/design/modules/chip_core/rtl/chip_core.v \
                            /home/projects/vlsi/ccs0101/design/modules/gpcfg/rtl/gpcfg_rd.v \
                            /home/projects/vlsi/ccs0101/design/modules/gpcfg/rtl/gpcfg_rd_wr.v \
                            /home/projects/vlsi/ccs0101/design/modules/gpcfg/rtl/gpcfg_rd_wr_p.v \
                            /home/projects/vlsi/ccs0101/design/modules/gpcfg/rtl/hw_rng_fsm.v \
                            /home/projects/vlsi/ccs0101/design/modules/gpcfg/rtl/gpcfg.v \
                            /home/projects/vlsi/ccs0101/design/modules/chiplib/rtl/chiplib.v \
                            /home/projects/vlsi/ccs0101/design/modules/ccs0101/rtl/ccs0101.v \
                            /home/projects/vlsi/ccs0101/design/modules/padring/rtl/padring.v }


  elaborate ccs0101

date
set_dont_use [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/*X0P*]

set_dont_touch_network VDD
set_dont_touch_network DVDD
set_dont_touch_network VSS
set_dont_touch_network DVSS
set_dont_touch_network u_padring_inst/u_nRESET_pad_inst/C
set_dont_touch_network u_padring_inst/u_nPORESET_pad_inst/C
set_dont_touch_network u_padring_inst/u_CLK_pad_inst/C

set_dont_touch_network [all_connected [get_nets -hier *_HV]]

link

  set_wire_load_model -name Small
  set_max_area 0
  set_clock_gating_style -sequential_cell latch -positive_edge_logic {nand} -negative_edge_logic {nor} -minimum_bitwidth 5 -max_fanout 64
  set_annotated_delay -net -from  [get_pins u_padring_inst/*u_pad_inst/PAD] -to [get_ports pad*] 0
  set_annotated_delay -net -to  [get_pins u_padring_inst/*u_pad_inst/PAD] -from [get_ports pad*] 0
  foreach_in_collection port [get_ports *] {
    set_resistance 0 [all_connected $port ]
  }


date
  #compile_ultra -no_autoungroup -no_seq_output_inversion -no_boundary_optimization -exact_map -no_design_rule -gate_clock
date
  uniquify
  #compile_ultra -exact_map -no_autoungroup -no_seq_output_inversion -no_boundary_optimization

   foreach_in_collection abc [get_pins u_chip_core_inst/u_random_num_gen*_inst/trng_wrap_inst*/trng_inst*u_trng_inst*/u_trng_mux*_inst/u_DONT_TOUCH_mux2_inst/Y] {
     set pqr [get_attribute $abc full_name]
     set_disable_timing $pqr
   }



  create_clock [get_pins {u_padring_inst/u_CLK_pad_inst/C}]  -name HCLK  -period 10  -waveform {0 5}
  #group_path -to u_chip_core_inst/u_bin_ext_gcd_inst/ay_loc_reg*/D -name ay_loc_reg_bin_ext_gcd

  set_multicycle_path 2 -setup \
                        -through u_chip_core_inst/u_gpcfg_inst/u_mod_exp_inst/done_irq_p \
                        -to      u_chip_core_inst/u_gpcfg_inst/mod_inv*/D


  set_multicycle_path 1 -hold  \
                        -through u_chip_core_inst/u_gpcfg_inst/u_mod_exp_inst/done_irq_p  \
                        -to      u_chip_core_inst/u_gpcfg_inst/mod_inv*/D

  set_multicycle_path 2 -setup \
                        -through u_chip_core_inst/u_gpcfg_inst/done_irq_p_bin_ext_gcd_d*/*  \
                        -to      u_chip_core_inst/u_gpcfg_inst/mod_inv*/D

  set_multicycle_path 1 -hold  \
                        -through u_chip_core_inst/u_gpcfg_inst/done_irq_p_bin_ext_gcd_d*/*  \
                        -to      u_chip_core_inst/u_gpcfg_inst/mod_inv*/D

  set_multicycle_path 2 -setup \
                        -through u_chip_core_inst/u_mod_mul_il_inst/m*


  set_multicycle_path 1  -hold \
                         -through u_chip_core_inst/u_mod_mul_il_inst/m*

  set_multicycle_path 2 -setup \
                        -through u_chip_core_inst/u_gpcfg_inst/u_mod_exp_inst/m*


  set_multicycle_path 1  -hold \
                         -through u_chip_core_inst/u_gpcfg_inst/u_mod_exp_inst/m*


  set_multicycle_path 2 -setup \
                        -through u_chip_core_inst/u_uarts_rx_mux_inst/y

  set_multicycle_path 1 -hold \
                        -through u_chip_core_inst/u_uarts_rx_mux_inst/y

  set_multicycle_path 2 -setup \
                        -through u_chip_core_inst/u_uartm_inst/RX

  set_multicycle_path 1 -hold \
                        -through u_chip_core_inst/u_uartm_inst/RX


  set_multicycle_path 2 -setup \
                        -thr    u_chip_core_inst/u_gpcfg_inst/u_cfg_pad*_ctl_reg_inst/wr_reg*

  set_multicycle_path 1 -hold \
                        -thr    u_chip_core_inst/u_gpcfg_inst/u_cfg_pad*_ctl_reg_inst/wr_reg*


  set_multicycle_path 2 -setup \
                        -through    u_chip_core_inst/u_gpcfg_inst/cleq_host_irq

  set_multicycle_path 1 -hold \
                        -through    u_chip_core_inst/u_gpcfg_inst/cleq_host_irq

  set_multicycle_path 2 -setup \
                        -through  u_chip_core_inst/u_gpcfg_inst/gfunc_curr_state*/Q* \
                        -to       u_chip_core_inst/u_gpcfg_inst/mod_inv*/*

  set_multicycle_path 1 -hold \
                        -through  u_chip_core_inst/u_gpcfg_inst/gfunc_curr_state*/Q* \
                        -to       u_chip_core_inst/u_gpcfg_inst/mod_inv*/*

  set_multicycle_path 2 -setup \
                        -through u_chip_core_inst/u_gpcfg_inst/arg_b_mod_inv*

  set_multicycle_path 1 -hold \
                        -through u_chip_core_inst/u_gpcfg_inst/arg_b_mod_inv*

  set_multicycle_path 2 -setup \
                        -through u_chip_core_inst/u_gpcfg_inst/u_cfg_cleq_ctl_inst/wr_reg*/Q*

  set_multicycle_path 1 -hold \
                        -through u_chip_core_inst/u_gpcfg_inst/u_cfg_cleq_ctl_inst/wr_reg*/Q*

  set_multicycle_path 2 -setup -thr u_chip_core_inst/u_bin_ext_gcd_inst/x
  set_multicycle_path 1 -hold  -thr u_chip_core_inst/u_bin_ext_gcd_inst/x
  set_multicycle_path 2 -setup -thr u_chip_core_inst/u_bin_ext_gcd_inst/y
  set_multicycle_path 1 -hold  -thr u_chip_core_inst/u_bin_ext_gcd_inst/y



for {set i 0} {$i < 12} {incr i } {
  set_multicycle_path 2 -setup \
                        -through    u_chip_core_inst/u_gpcfg_inst/u_cfg_cleq_ctl2_reg_inst/wr_reg[$i]
  set_multicycle_path 1 -hold \
                        -through    u_chip_core_inst/u_gpcfg_inst/u_cfg_cleq_ctl2_reg_inst/wr_reg[$i]
}

  set input_ports [remove_from_collection [all_inputs] {HCLK VDD VSS DVDD DVSS}]
  set output_ports [all_outputs]

  set_input_delay -max 5 [get_ports $input_ports ] -clock HCLK
  set_input_delay -min 1.5 [get_ports $input_ports ] -clock HCLK

  set_output_delay -max 5 [get_ports $output_ports ] -clock HCLK
  set_output_delay -min 3 [get_ports $output_ports ] -clock HCLK

  set_input_transition -max 2 [get_ports $input_ports]
  set_input_transition -min 0 [get_ports $input_ports]


  #set_units -capacitance fF
  set_load -max 10   [get_ports $output_ports]
  set_load -min 2    [get_ports $output_ports]


  group_path -name output_group -to   [all_outputs]
  group_path -name input_group  -from [all_inputs]

  #compile_ultra -no_autoungroup -no_seq_output_inversion -no_boundary_optimization
date
  compile_ultra -no_autoungroup -no_seq_output_inversion -no_boundary_optimization -gate_clock -area_high_effort_script
date
   optimize_netlist -area
date
  compile_ultra -no_autoungroup -no_seq_output_inversion -no_boundary_optimization -incremental
date
   
   change_names -hier -rule verilog

   write_file -hierarchy -format verilog -output "./netlist/ccs0101.v"
   write_sdc "./netlist/ccs0101.sdc"

set_switching_activity -toggle_rate 5 -period 100  -static_probability 0.50 -type inputs
propagate_switching_activity

   report_timing -delay max  -nosplit -input -nets -cap -max_path 10 -nworst 10    > ./reports/report_timing_max.rpt
   report_timing -delay min  -nosplit -input -nets -cap -max_path 10 -nworst 10    > ./reports/report_timing_min.rpt
   report_constraint -all_violators -verbose  -nosplit                             > ./reports/report_constraint.rpt
   check_design -nosplit                                                           > ./reports/check_design.rpt
   report_design                                                                   > ./reports/report_design.rpt
   report_area                                                                     > ./reports/report_area.rpt
   report_timing -loop                                                             > ./reports/timing_loop.rpt
   report_power -analysis_effort high                                              > ./reports/report_power.rpt
   report_qor                                                                      > ./reports/report_qor.rpt

date
