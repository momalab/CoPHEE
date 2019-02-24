`timescale 1 ns/1 ps

module mod_exp_tb (
);

//---------------------------------
//Local param reg/wire declaration
//---------------------------------

localparam  CLK_PERIOD   = 4.167;   //24 Mhz

localparam  NBITS    = 2048;


reg              CLK; 
reg              nRESET; 
reg [NBITS-1 :0] a; 
reg [NBITS-1 :0] b; 
reg [NBITS-1 :0] m; 
reg [11      :0] m_size; 
reg [NBITS-1 :0] r_red; 
reg              enable_p; 

wire [NBITS-1 :0] y; 

integer no_of_clocks; 


//------------------------------
//Clock and Reset generation
//------------------------------

initial begin
  CLK      = 1'b0; 
end

always begin
  #(CLK_PERIOD/2) CLK = ~CLK; 
end



initial begin
   nRESET   = 1'b1;
   enable_p = 1'b0;
   m        = 2048'd0;
   a        = 2048'd0;
   b        = 2048'd0;
   m_size   = 12'd2048;
   r_red    = 2048'd0;
  repeat (2) begin
    @(posedge CLK);
  end
   nRESET    = 1'b0;

  repeat (2) begin
    @(posedge CLK);
  end
  nRESET   = 1'b1;

  repeat (2) begin
    @(posedge CLK);
  end
  #1
  enable_p = 1'b1;
  m        = 2048'd30860300278532209025823596511163411062200222337963629277259312872648527914287513216444681831980372910712728158572014818381959029500373893491760318552264976142068683259160031028722531032103522806384024129432707196458480826555919619547293726154104553095054365072423663880777340419282461011770299806736940635968655017167488044604946854445923668584904351390732872073315824612628769675810155017300463740479859897321367996103089877863383102320910362114970416498093086692279081843726492730263102316018462645725608029622209771738310530189275997596383415353923380599630982587873387766510416447442697877931299399062758535656901;
  a        = 2048'd0;
  b        = 2048'd14258010523966426199517643339163303765777036488925356373329558033535282093297645273480267121096585384687238449180313605297773175716291736217661127374429447171831385697445864958271572845190522488871963785838086236318012530245590771130188975997239160155262528976733306139172599282309770069246596093046100189083088087770070520718751870253015579363602949133259939554265180122519272335241417892809064001534072475209548639248123032235165268003136376004586412466164506995077066338877693799019491245040485888378051961320819012340695545386647006950208934090553152280642077407861157815237042434760092572464244570493441654686860;


  m_size   = 12'd2048;
  r_red    = (1'b1 << m_size) - m;
  @(posedge CLK);
  #1
  enable_p = 1'b0;

end



//------------------------------
//DUT
//------------------------------
mod_exp #(
  .NBITS (NBITS)
 ) u_dut_inst   (
  .clk           (CLK),
  .rst_n         (nRESET),
  .enable_p      (enable_p),
  .a             (a),
  .exp           (b),
  .m             (m),
  .m_size        (m_size),
  .r_red         (r_red),
  .y             (y),
  .done_irq_p    (done_irq_p)
);


//------------------------------
//Track number of clocks
//------------------------------
initial begin
  no_of_clocks = 0; 
end
always@(posedge CLK)  begin
  no_of_clocks = no_of_clocks +1 ; 
  //$display($time, " << Number of Clocks value         %d", no_of_clocks);
  //$display($time, " << htrans_m[0] value              %b", ccs0001_tb.u_dut_inst.u_chip_core_inst.u_ahb_ic_inst.htrans_m[0][1]);
  //$display($time, " << vlaid_trans_s_by_m[s][0] value %b", ccs0001_tb.u_dut_inst.u_chip_core_inst.u_ahb_ic_inst.vlaid_trans_s_by_m[0][0]);
  //$display($time, " << vlaid_trans_s_by_m[s][1] value %b", ccs0001_tb.u_dut_inst.u_chip_core_inst.u_ahb_ic_inst.vlaid_trans_s_by_m[1][0]);
  //$display($time, " << SLAVE_BASE[0] value            %h", ccs0001_tb.u_dut_inst.u_chip_core_inst.u_ahb_ic_inst.SLAVE_BASE[0][31:16]);
  //$display($time, " << SLAVE_BASE[1] value            %h", ccs0001_tb.u_dut_inst.u_chip_core_inst.u_ahb_ic_inst.SLAVE_BASE[1][31:16]);
  //$display($time, " << haddr_m[0]  value              %h", ccs0001_tb.u_dut_inst.u_chip_core_inst.u_ahb_ic_inst.haddr_m[0][31:16]);
  //$display($time, " << memory dump              %h", ccs0001_tb.u_dut_inst.u_chip_core_inst.u_sram_wrap_inst.u_sram_inst.mem[0]);
end

endmodule
