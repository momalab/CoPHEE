# Begin_DVE_Session_Save_Info
# DVE view(Wave.1 ) session
# Saved on Sun Feb 26 22:34:17 2017
# Toplevel windows open: 2
# 	TopLevel.1
# 	TopLevel.2
#   Wave.1: 19 signals
# End_DVE_Session_Save_Info

# DVE version: E-2011.03
# DVE build date: Feb 23 2011 21:19:20


#<Session mode="View" path="/home/projects/vlsi/ccs0101/design/modules/crypto_lib/verif/montgomary_wrap.inter.vpd.tcl" type="Debug">

#<Database>

#</Database>

# DVE View/pane content session: 

# Begin_DVE_Session_Save_Info (Wave.1)
# DVE wave signals session
# Saved on Sun Feb 26 22:34:17 2017
# 19 signals
# End_DVE_Session_Save_Info

# DVE version: E-2011.03
# DVE build date: Feb 23 2011 21:19:20


#Add ncecessay scopes

gui_set_time_units 1ps
set Group1 Group1
if {[gui_sg_is_group -name Group1]} {
    set Group1 [gui_sg_generate_new_name]
}

gui_sg_addsignal -group "$Group1" { {Sim:montgomery_wrap_tb.u_dut_inst.clk} {Sim:montgomery_wrap_tb.u_dut_inst.rst_n} {Sim:montgomery_wrap_tb.u_dut_inst.enable_p} {Sim:montgomery_wrap_tb.u_dut_inst.a} {Sim:montgomery_wrap_tb.u_dut_inst.b} {Sim:montgomery_wrap_tb.u_dut_inst.m} {Sim:montgomery_wrap_tb.u_dut_inst.m_size} {Sim:montgomery_wrap_tb.u_dut_inst.r_red} {Sim:montgomery_wrap_tb.u_dut_inst.y} {Sim:montgomery_wrap_tb.u_dut_inst.done_irq_p} {Sim:montgomery_wrap_tb.u_dut_inst.a_conv} {Sim:montgomery_wrap_tb.u_dut_inst.b_conv} {Sim:montgomery_wrap_tb.u_dut_inst.y_inter} {Sim:montgomery_wrap_tb.u_dut_inst.done_irq_p_a} {Sim:montgomery_wrap_tb.u_dut_inst.done_irq_p_b} {Sim:montgomery_wrap_tb.u_dut_inst.done_irq_p_mul} {Sim:montgomery_wrap_tb.u_dut_inst.u_montgomery_mul_inst.m_size_cnt} {Sim:montgomery_wrap_tb.u_dut_inst.u_montgomery_mul_inst.y_loc} {Sim:montgomery_wrap_tb.u_dut_inst.u_montgomery_mul_inst.a_loc} }
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
gui_wv_zoom_timerange -id ${Wave.1} 195556 219743
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
gui_list_set_insertion_bar  -id ${Wave.1} -group $Group1  -position in

gui_marker_move -id ${Wave.1} {C1} 135460
gui_view_scroll -id ${Wave.1} -vertical -set 0
gui_show_grid -id ${Wave.1} -enable false
#</Session>

