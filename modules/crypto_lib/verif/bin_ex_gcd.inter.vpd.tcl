# Begin_DVE_Session_Save_Info
# DVE view(Wave.1 ) session
# Saved on Wed Mar 1 19:10:43 2017
# Toplevel windows open: 2
# 	TopLevel.1
# 	TopLevel.2
#   Wave.1: 34 signals
# End_DVE_Session_Save_Info

# DVE version: E-2011.03
# DVE build date: Feb 23 2011 21:19:20


#<Session mode="View" path="/home/projects/vlsi/ccs0101/design/modules/crypto_lib/verif/bin_ex_gcd.inter.vpd.tcl" type="Debug">

#<Database>

#</Database>

# DVE View/pane content session: 

# Begin_DVE_Session_Save_Info (Wave.1)
# DVE wave signals session
# Saved on Wed Mar 1 19:10:43 2017
# 34 signals
# End_DVE_Session_Save_Info

# DVE version: E-2011.03
# DVE build date: Feb 23 2011 21:19:20


#Add ncecessay scopes
gui_load_child_values {bin_ext_gcd_tb.u_dut_inst}

gui_set_time_units 1ps
set Group1 Group1
if {[gui_sg_is_group -name Group1]} {
    set Group1 [gui_sg_generate_new_name]
}

gui_sg_addsignal -group "$Group1" { {Sim:bin_ext_gcd_tb.u_dut_inst.clk} {Sim:bin_ext_gcd_tb.u_dut_inst.rst_n} {Sim:bin_ext_gcd_tb.u_dut_inst.enable_p} {Sim:bin_ext_gcd_tb.u_dut_inst.x} {Sim:bin_ext_gcd_tb.u_dut_inst.y} {Sim:bin_ext_gcd_tb.u_dut_inst.a} {Sim:bin_ext_gcd_tb.u_dut_inst.b} {Sim:bin_ext_gcd_tb.u_dut_inst.gcd} {Sim:bin_ext_gcd_tb.u_dut_inst.done_irq_p} {Sim:bin_ext_gcd_tb.u_dut_inst.x_s} {Sim:bin_ext_gcd_tb.u_dut_inst.y_s} {Sim:bin_ext_gcd_tb.u_dut_inst.x_loc} {Sim:bin_ext_gcd_tb.u_dut_inst.ax_loc} {Sim:bin_ext_gcd_tb.u_dut_inst.bx_loc} {Sim:bin_ext_gcd_tb.u_dut_inst.y_loc} {Sim:bin_ext_gcd_tb.u_dut_inst.ay_loc} {Sim:bin_ext_gcd_tb.u_dut_inst.by_loc} {Sim:bin_ext_gcd_tb.u_dut_inst.ax_loc_ay_loc_diff_arg0} {Sim:bin_ext_gcd_tb.u_dut_inst.ax_loc_ay_loc_diff_arg1} {Sim:bin_ext_gcd_tb.u_dut_inst.ax_loc_ay_loc_diff} {Sim:bin_ext_gcd_tb.u_dut_inst.bx_loc_by_loc_diff_arg0} {Sim:bin_ext_gcd_tb.u_dut_inst.bx_loc_by_loc_diff_arg1} {Sim:bin_ext_gcd_tb.u_dut_inst.bx_loc_by_loc_diff} {Sim:bin_ext_gcd_tb.u_dut_inst.x_loc_y_loc_diff_arg0} {Sim:bin_ext_gcd_tb.u_dut_inst.x_loc_y_loc_diff_arg1} {Sim:bin_ext_gcd_tb.u_dut_inst.x_loc_y_loc_diff} {Sim:bin_ext_gcd_tb.u_dut_inst.a_loc} {Sim:bin_ext_gcd_tb.u_dut_inst.b_loc} {Sim:bin_ext_gcd_tb.u_dut_inst.a_loc_add_y} {Sim:bin_ext_gcd_tb.u_dut_inst.b_loc_sub_x} {Sim:bin_ext_gcd_tb.u_dut_inst.x_loc_y_loc_comp} {Sim:bin_ext_gcd_tb.u_dut_inst.gcd_loc} {Sim:bin_ext_gcd_tb.u_dut_inst.done_irq_p_loc} {Sim:bin_ext_gcd_tb.u_dut_inst.NBITS} }
gui_set_radix -radix {decimal} -signals {Sim:bin_ext_gcd_tb.u_dut_inst.NBITS}
gui_set_radix -radix {twosComplement} -signals {Sim:bin_ext_gcd_tb.u_dut_inst.NBITS}
if {![info exists useOldWindow]} { 
	set useOldWindow true
}
if {$useOldWindow && [string first "Wave" [gui_get_current_window -view]]==0} { 
	set Wave.1 [gui_get_current_window -view] 
} else {
	gui_open_window Wave
set Wave.1 [ gui_get_current_window -view ]
}
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_set_ref -id ${Wave.1}  C1
gui_wv_zoom_timerange -id ${Wave.1} 12531 77210
gui_list_add_group -id ${Wave.1} -after {New Group} [list $Group1]
gui_seek_criteria -id ${Wave.1} {Any Edge}


gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_list_set_filter -id ${Wave.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.1} -text {*}
gui_list_set_insertion_bar  -id ${Wave.1} -group $Group1  -item {bin_ext_gcd_tb.u_dut_inst.x_loc_y_loc_diff[2047:0]} -position below

gui_marker_move -id ${Wave.1} {C1} 23924
gui_view_scroll -id ${Wave.1} -vertical -set 0
gui_show_grid -id ${Wave.1} -enable false
#</Session>

