# Begin_DVE_Session_Save_Info
# DVE view(Wave.1 ) session
# Saved on Mon May 1 14:09:51 2017
# Toplevel windows open: 2
# 	TopLevel.1
# 	TopLevel.2
#   Wave.1: 35 signals
# End_DVE_Session_Save_Info

# DVE version: E-2011.03
# DVE build date: Feb 23 2011 21:19:20


#<Session mode="View" path="/home/projects/vlsi/ccs0101/design/modules/crypto_lib/verif/random_num_gen.inter.vpd.tcl" type="Debug">

#<Database>

#</Database>

# DVE View/pane content session: 

# Begin_DVE_Session_Save_Info (Wave.1)
# DVE wave signals session
# Saved on Mon May 1 14:09:51 2017
# 35 signals
# End_DVE_Session_Save_Info

# DVE version: E-2011.03
# DVE build date: Feb 23 2011 21:19:20


#Add ncecessay scopes

gui_set_time_units 1ps
set Group1 Group1
if {[gui_sg_is_group -name Group1]} {
    set Group1 [gui_sg_generate_new_name]
}

gui_sg_addsignal -group "$Group1" { {Sim:random_num_gen_tb.u_dut_inst.cnt} {Sim:random_num_gen_tb.u_dut_inst.clk} {Sim:random_num_gen_tb.u_dut_inst.rst_n} {Sim:random_num_gen_tb.u_dut_inst.enable_p} {Sim:random_num_gen_tb.u_dut_inst.bypass} {Sim:random_num_gen_tb.u_dut_inst.done_p} {Sim:random_num_gen_tb.u_dut_inst.y} {Sim:random_num_gen_tb.u_dut_inst.cnt} }
set Group2 Group2
if {[gui_sg_is_group -name Group2]} {
    set Group2 [gui_sg_generate_new_name]
}

gui_sg_addsignal -group "$Group2" { {Sim:random_num_gen_tb.u_dut_inst.vn_corrector_inst.clk} {Sim:random_num_gen_tb.u_dut_inst.vn_corrector_inst.rst_n} {Sim:random_num_gen_tb.u_dut_inst.vn_corrector_inst.bypass} {Sim:random_num_gen_tb.u_dut_inst.vn_corrector_inst.enable_p} {Sim:random_num_gen_tb.u_dut_inst.vn_corrector_inst.din} {Sim:random_num_gen_tb.u_dut_inst.vn_corrector_inst.done_p} {Sim:random_num_gen_tb.u_dut_inst.vn_corrector_inst.y} }
set Group3 Group3
if {[gui_sg_is_group -name Group3]} {
    set Group3 [gui_sg_generate_new_name]
}

gui_sg_addsignal -group "$Group3" { {Sim:random_num_gen_tb.u_dut_inst.trng_wrap_inst0.clk} {Sim:random_num_gen_tb.u_dut_inst.trng_wrap_inst0.rst_n} {Sim:random_num_gen_tb.u_dut_inst.trng_wrap_inst0.en} {Sim:random_num_gen_tb.u_dut_inst.trng_wrap_inst0.y} }
set Group4 Group7
if {[gui_sg_is_group -name Group7]} {
    set Group4 [gui_sg_generate_new_name]
}

gui_sg_addsignal -group "$Group4" { {Sim:random_num_gen_tb.u_dut_inst.trng_wrap_inst1.clk} {Sim:random_num_gen_tb.u_dut_inst.trng_wrap_inst1.rst_n} {Sim:random_num_gen_tb.u_dut_inst.trng_wrap_inst1.en} {Sim:random_num_gen_tb.u_dut_inst.trng_wrap_inst1.y} }
set Group5 Group4
if {[gui_sg_is_group -name Group4]} {
    set Group5 [gui_sg_generate_new_name]
}

gui_sg_addsignal -group "$Group5" { {Sim:random_num_gen_tb.u_dut_inst.trng_wrap_inst2.clk} {Sim:random_num_gen_tb.u_dut_inst.trng_wrap_inst2.rst_n} {Sim:random_num_gen_tb.u_dut_inst.trng_wrap_inst2.en} {Sim:random_num_gen_tb.u_dut_inst.trng_wrap_inst2.y} }
set Group6 Group5
if {[gui_sg_is_group -name Group5]} {
    set Group6 [gui_sg_generate_new_name]
}

gui_sg_addsignal -group "$Group6" { {Sim:random_num_gen_tb.u_dut_inst.trng_wrap_inst3.clk} {Sim:random_num_gen_tb.u_dut_inst.trng_wrap_inst3.rst_n} {Sim:random_num_gen_tb.u_dut_inst.trng_wrap_inst3.en} {Sim:random_num_gen_tb.u_dut_inst.trng_wrap_inst3.y} }
set Group7 Group6
if {[gui_sg_is_group -name Group6]} {
    set Group7 [gui_sg_generate_new_name]
}

gui_sg_addsignal -group "$Group7" { {Sim:random_num_gen_tb.u_dut_inst.trng_wrap_inst4.clk} {Sim:random_num_gen_tb.u_dut_inst.trng_wrap_inst4.rst_n} {Sim:random_num_gen_tb.u_dut_inst.trng_wrap_inst4.en} {Sim:random_num_gen_tb.u_dut_inst.trng_wrap_inst4.y} }
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
gui_wv_zoom_timerange -id ${Wave.1} 14299 160887
gui_list_add_group -id ${Wave.1} -after {New Group} [list $Group1]
gui_list_add_group -id ${Wave.1} -after {New Group} [list $Group2]
gui_list_add_group -id ${Wave.1} -after {New Group} [list $Group3]
gui_list_add_group -id ${Wave.1} -after {New Group} [list $Group4]
gui_list_add_group -id ${Wave.1} -after {New Group} [list $Group5]
gui_list_add_group -id ${Wave.1} -after {New Group} [list $Group6]
gui_list_add_group -id ${Wave.1} -after {New Group} [list $Group7]
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
gui_list_set_insertion_bar  -id ${Wave.1} -group $Group1  -item {random_num_gen_tb.u_dut_inst.cnt[2:0]} -position below

gui_marker_move -id ${Wave.1} {C1} 68772
gui_view_scroll -id ${Wave.1} -vertical -set 0
gui_show_grid -id ${Wave.1} -enable false
#</Session>

