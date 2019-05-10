/**********************************************************************************
    This module is part of the project CoPHEE.
    CoPHEE: A co-processor for partially homomorphic encrypted encryption
    Copyright (C) 2019  Michail Maniatakos
    New York University Abu Dhabi, wp.nyu.edu/momalab/

    If find any of our work useful, please cite our publication:
      M. Nabeel, M. Ashraf, E. Chielle, N.G. Tsoutsos, and M. Maniatakos.
      "CoPHEE: Co-processor for Partially Homomorphic Encrypted Execution". 
      In: IEEE Hardware-Oriented Security and Trust (HOST). 

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
**********************************************************************************/


`timescale 1 ns/1 ps

module bin_ext_gcd_tb (
);

//---------------------------------
//Local param reg/wire declaration
//---------------------------------

localparam  CLK_PERIOD   = 4.167;   //24 Mhz

//localparam  NBITS        = 10;
localparam  NBITS        = 2048;

wire [NBITS/2-1:0]   N       = 2**(NBITS/2)-1;
wire [NBITS-1  :0]   nsq     = N*N;
reg  [NBITS-1  :0]   arga    = 2048'd31991428308526611240433162825835197570415908850032843634533826238802567420617814505416207798835946747958184032973216141925741489557077378946824592678204465678336347358294319601807069844671220129770981926595699128529287884818824468919577200471684671563025359943502466874551407777080797467767501004745671469153750963456728941783012075071998973988072817152987412308046513755818688113601293618200831361269477700884296652844481497370280781484194361561379081848067467914310113169369004391616870427518438824921000987494073592333286189873770055152042161445469283146785513903943396111613963361948111184946058243051515715516770;
reg  [NBITS-1  :0]   argb    = 2048'd 17749307280602236253430331721061771798208863231545199761573330957649320657903137373391112314215287908786279857393892690593490398163331505606239081339907790840896979917377477821441639505288876965839663287038727309282636516270258005547103455568281929878995427177051232172100948352507172205527107914808598364624938774304945035822187768131012493745649669772387581990294724031710080201500080335745019530652910696219909083953772730422583912087733123912136911856573355208995245783205556650690318238273746271840023734023466714493203550184942668088766444349765327953483395492616479912741875077443666448921258455917508043054543;
//reg  [NBITS-1  :0]   arga    = 10'd220;
//reg  [NBITS-1  :0]   argb    = 10'd961;

integer        j;
integer        seed;

reg              CLK; 
reg              nRESET; 
reg [NBITS-1 :0] a; 
reg [NBITS-1 :0] b; 
reg [NBITS-1 :0] gcd; 
reg              enable_p; 

wire [NBITS+2  :0] x; 
wire [NBITS+2  :0] y; 

integer no_of_clocks; 
reg [NBITS-1 :0] a_loc; 
reg [NBITS-1 :0] b_loc; 

wire                 done_irq_p;
reg [NBITS+2 :0] inv; 
reg [NBITS+2 :0] inv_other; 
reg [NBITS*2-1:0] check; 

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
  $display($time, " << Waiting 1");
   nRESET   = 1'b1;
   enable_p = 1'b0;
   a        = {NBITS{1'b0}};
   b        = {NBITS{1'b0}};
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
  $display($time, " << Waiting 2");

  //for (j=1; j < nsq; j = j+1) begin
    seed = j;

    $display($time, "---------------Iteration %d SEED %d-----------------", j,j);
    //arga           = j;
    //argb           = nsq;

    enable_p = 1'b1;
    @(posedge CLK);
    #1
    enable_p = 1'b0;

    $display($time, " << Value of ARGA  %d", arga);
    $display($time, " << Value of ARGB  %d", argb);
    $display($time, " << Waiting");
    @(posedge done_irq_p);
    @(posedge CLK);
    $display($time, " << Value of GCD  %d", gcd);
    $display($time, " << Inverse Value %d", x);
    inv = x;
    inv_other = y;
    //if (x[NBITS+2] == 1) begin
    //  inv = x + argb;
    //end
    //else begin
    //  while (x > argb) begin
    //    inv   = x - argb;   
    //  end
    //end
    check = inv*arga%argb;
    $display($time, " << FINAL INV %d", inv);
    $display($time, " << FINAL INV OTHER %d", inv_other);
    $display($time, " << FINAL ARGA %d", arga);
    $display($time, " << CHECK %d", check);
    if (gcd == 1) begin
      if(check == 1) begin
      $display($time, " << INFO: PASSED");
      end
      else begin
      $display($time, " << ERROR: FAILED");
      end
    end
    else begin
      $display($time, " << WARNGIN: GCD is not 1");
    end
    @(posedge CLK);
    @(posedge CLK);
    @(posedge CLK);
  //end
  $finish; 

end



//------------------------------
//DUT
//------------------------------
bin_ext_gcd #(
  .NBITS (NBITS)
 ) u_dut_inst   (
  .clk           (CLK),
  .rst_n         (nRESET),
  .enable_p      (enable_p),
  .x             (arga),
  .y             (argb),
  .a             (x),
  .b             (y),
  .gcd           (gcd),
  .done_irq_p    (done_irq_p)
);


//------------------------------
//Track number of clocks
//------------------------------
initial begin
  no_of_clocks = 0; 
  a_loc        = 2048'b0; 
  b_loc        = 2048'b0; 
end


always@(posedge CLK)  begin
  if (enable_p == 1'b1) begin
    a_loc        = a; 
    b_loc        = b; 
  end
  if (a_loc > b_loc) begin
     a_loc = a_loc - b_loc ; 
  end
  else if (b_loc > a_loc) begin
    b_loc  = b_loc - a_loc;
  end
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
