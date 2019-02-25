module gpio (
// 	CLOCK-RESET SIGNALS
	input hclk,
	input hresetn,
// 	BUS-GPIO SIGNALS
	input [31:0] 	  haddr, // gives the read/write address
	input         	  hsel, // whether it's an idle, busy, sequential or non sequential transfer
	input [31:0]  	  hwdata, // data that is being transferred from master-to-slave in a "W"rite
	input         	  hwrite, // indicates whether the transfer is master-to-slave or slave-to-master
	output reg [31:0] hrdata, // data being transferred from slave-to-master in a "R"ead
	output reg   	  hready, // indicates when transfer is over
	output 		      hresp, // slave's "RESP"onse whether it is ready for transfer or not

// 	VECTOR INTERRUPT CONTROLLER SIGNALS

	output wire 	  intc, // sends an interrupt to the Cortex M0’s interrupt controller
				// assuming we have an active high interrupt
// 	I/O PAD SIGNALS

// 				I'm not sure if the gpio control register is needed then. 
	output wire [3:0] gpio_out, // which port to enable for output (write)
	input  wire [3:0]   gpio_in   // which port to enable for input (read)     // shouldn't these be wires too?
	);
	

// ***************************************************************************************************
// Localparam , reg, wire declaration
// ***************************************************************************************************
	wire       valid_write; // the "assign" keyword automatically allocates valid_write as a wire, but it's still good practice to define it as a wire in the module for now
	wire       valid_read;
	reg[31:0]  write_addr;
	reg[31:0]  read_addr;
	reg        valid_write_lat;
	reg[31:0]  read_data;

	reg	   err_dec_rd_d1;
	reg	   err_dec_rd_d2;

	reg        err_dec_rd;
	wire       err_dec_wr;

	reg 	   gpio0_sync1;
	reg 	   gpio1_sync1;
	reg 	   gpio2_sync1;
	reg 	   gpio3_sync1;

	reg 	   gpio0_sync2;
	reg 	   gpio1_sync2;
	reg 	   gpio2_sync2;
	reg 	   gpio3_sync2;

	reg 	   gpio0_in;
	reg 	   gpio1_in;
	reg 	   gpio2_in;
	reg 	   gpio3_in;


	reg        gpio0_ctl_wr_en;
	reg	   gpio0_out_wr_en;
	reg 	   gpio1_ctl_wr_en;
	reg 	   gpio1_out_wr_en;
	reg 	   gpio2_ctl_wr_en;
	reg 	   gpio2_out_wr_en;
	reg	   gpio3_ctl_wr_en;
	reg	   gpio3_out_wr_en;




        wire[31:0]  gpio0_in_data; // we use wires for the in_data because we use an assign statement to pad the data from the gpio_in[i] input reg 
	wire[31:0]  gpio1_in_data;
	wire[31:0]  gpio2_in_data;
	wire[31:0]  gpio3_in_data;




	reg[31:0]  gpio0_ctl_data; // we use regs for the out_data and ctrl_data because these are assigned in the sequential always block 
	reg[31:0]  gpio0_out_data;
	reg[31:0]  gpio1_ctl_data;
	reg[31:0]  gpio1_out_data;
	reg[31:0]  gpio2_ctl_data;
	reg[31:0]  gpio2_out_data;
	reg[31:0]  gpio3_ctl_data;
	reg[31:0]  gpio3_out_data;

	reg[3:0]  intc_loc;



	
    localparam GPIO0_CTL_ADDR = 16'h0000;
    localparam GPIO0_OUT_ADDR = 16'h0004;
    localparam GPIO0_IN_ADDR  = 16'h0008;
 	localparam GPIO1_CTL_ADDR = 16'h000C;
 	localparam GPIO1_OUT_ADDR = 16'h0010;
 	localparam GPIO1_IN_ADDR  = 16'h0014;
 	localparam GPIO2_CTL_ADDR = 16'h0018;
 	localparam GPIO2_OUT_ADDR = 16'h001C;
 	localparam GPIO2_IN_ADDR  = 16'h0020;
 	localparam GPIO3_CTL_ADDR = 16'h0024;
 	localparam GPIO3_OUT_ADDR = 16'h0028;
 	localparam GPIO3_IN_ADDR  = 16'h002C;
// ***************************************************************************************************
// 	Write Transaction:					
// ***************************************************************************************************

assign valid_write = hsel & hwrite; // we'll use hresp to check whether the previous transfer was OKAY-ed by the slave later
assign valid_read  = hsel & ~hwrite;

// ***************************************************************************************************
//  Store Write Address: (because first comes address phase where you hold the address, and ONLY THEN comes the data phase 
// ***************************************************************************************************

always @(posedge hclk or negedge hresetn) begin		// shouldn't it be negedge hresetn here as well then?
  if (hresetn == 1'b0) begin
    write_addr       <= 32'b0;
    valid_write_lat  <= 1'b0;
  end
  else if (valid_write) begin
    write_addr       <= haddr;
    valid_write_lat  <= valid_write;
  end
  else begin
    write_addr       <= 32'b0;
    valid_write_lat  <= 1'b0;
  end 
end


// ***************************************************************************************************
// Similarily, we should be storing the read address. However, the read is simple, we don't need to latch the address for it, only the data. 
// ***************************************************************************************************


// ***************************************************************************************************
/* The reason that we're using 16 bits for addressing these registers is because we're using the first 16 bits for accessing the peripherals from the HADDR signal.
The registers themselves will be 32 bits in order to carry the read or write data.
We don't really need 16 bits for accessing all these registers; we've 4 control, 4 input and 4 output regs (a total of 12 regs) so we just need 4 bits for accessing them. 
The reason why we're still using 16 bits for addressing the peripherals, and 16 bits for their regs is because of the way the SRAM in this M0 has been defined. 
Since the SRAM is 64KBytes, (1KB = 1024 bytes = 2^10) and (64 = 8^2 = (2^3)^2 = 2^6). 
Traditionally, we use multiples of 1K to access peripherals in the microprocessor. 
So for instance, 1K requires 10 bits, 2K requires 11 bits, etc. 
Now if we access something in between, like 1 - 1.2K and 1.2 - 2K for the peripherals, addressing 1.2K requires 11 bits, and so both the peripherals would be changing the same bits twice. 
Now when the SRAM is 64K, we'll use a similar logic and use the upper 16 bits for addressing peripherals, giving each of them an address space for their regs, code, etc. 64K.
Since M0 follows 32 bit addressing, size of a word = 4 bytes.
Thus, each peripheral can have 64KB/4B = 16K words, or 16K regs. We're only using 12 of these regs for our I/O pads, so any address accessed beyond this should give an error. */
// Name          Address      R,W,R/W
// gpio0_ctl_reg 16'h0000      R/W
// gpio0_out_reg 16'h0010      R/W    The reason we're making the OUT reg Readable is so that we can read the value that we write into it as well, for testing purposes.
// gpio0_in_reg  16'h0014      R
// gpio1_ctl_reg 16'h0018      R/W
// gpio1_out_reg 16'h0010      R/W      
// gpio1_in_reg  16'h0014      R
// gpio2_ctl_reg 16'h0018      R/W
// gpio2_out_reg 16'h001C      R/W       
// gpio2_in_reg  16'h0020      R
// gpio3_ctl_reg 16'h0024      R/W
// gpio3_out_reg 16'h0028      R/W     
// gpio3_in_reg  16'h002C      R
// ***************************************************************************************************


/* Now, we use a CASE statement - if case gpio0_ctl_reg then do this, etc. and last case would be error.
DOUBT: Can we include both, the case statements for write and read in one case statement itself?
READ PHASE: The way this works is that either the address of the peripheral and the corresponding register are stored in a register, which is then MUX-ed like a SELECT line to reach the correct register, which then outputs the ReadData as the output of the MUX.
The other alternative is to send all these address to a MUX directly without storing it in a flip flop, use this address as a SELECT line to reach the correct register which will lead us to the ReadData output, WHICH we then store in a register (flip-flop). 
Now, the way timing works is from one flop to another, which should be T. In case 1, it encounters the ADDRESS flop and thus time t_1, which is less than the time t_1 + t_2 that it takes in case 2 to reach the ReadData flop. 

For the AMBA AHB-3 Lite protocol, the address phase is not as time critical since the address is simply broadcasted by the master to all the slaves.
It is the Data phase in READ which is more time critical, since it has more combinational logic and hence more delays. 
Since it is the Data phase that is more timing critical, hence we don't need to have the flop in the ADDRESS phase to save time there; we need it in the READDATA phase instead. */





// ***************************************************************************************************
// Enable regs for Write
// ***************************************************************************************************

 always @ (write_addr, valid_write_lat) begin
   gpio0_ctl_wr_en = 1'b0;  			// the reason why we're doing this is because suppose it doesn't enter the default case in the first go
   gpio0_out_wr_en = 1'b0;			// then we need to ensure that the other write enables are 0.
   gpio1_ctl_wr_en = 1'b0;
   gpio1_out_wr_en = 1'b0;
   gpio2_ctl_wr_en = 1'b0;
   gpio2_out_wr_en = 1'b0;
   gpio3_ctl_wr_en = 1'b0;
   gpio3_out_wr_en = 1'b0;
   case(write_addr[15:0])			/*This will automatically check the lower 16 bits of the write address with the writable registers of the GPIO
						i.e. the control and write registers*/
     GPIO0_CTL_ADDR : begin			// If valid_write_lat is 1, only then will the ctl_wr be enabled. 
       gpio0_ctl_wr_en = valid_write_lat;	// always block is used for combinational logic. Now copying the date into the out register will be a different, sequential block.
     end
     GPIO0_OUT_ADDR : begin
	gpio0_out_wr_en = valid_write_lat;
     end
     GPIO1_CTL_ADDR : begin
	gpio1_ctl_wr_en = valid_write_lat;
     end
     GPIO1_OUT_ADDR : begin
	gpio1_out_wr_en = valid_write_lat;
     end
     GPIO2_CTL_ADDR : begin
	gpio2_ctl_wr_en = valid_write_lat;
     end
     GPIO2_OUT_ADDR : begin
	gpio2_out_wr_en = valid_write_lat;
     end
     GPIO3_CTL_ADDR : begin
	gpio3_ctl_wr_en = valid_write_lat;
     end
     GPIO3_OUT_ADDR : begin
	gpio3_out_wr_en = valid_write_lat;
     end
     default : begin
       gpio0_ctl_wr_en = 1'b0;
       gpio0_out_wr_en = 1'b0;
       gpio1_ctl_wr_en = 1'b0;
       gpio1_out_wr_en = 1'b0;
       gpio2_ctl_wr_en = 1'b0;
       gpio2_out_wr_en = 1'b0;
       gpio3_ctl_wr_en = 1'b0;
       gpio3_out_wr_en = 1'b0;
     end
   endcase  
 end







// ***************************************************************************************************
// Generate interrupts for Read
// ***************************************************************************************************
always @* begin
  if (gpio0_ctl_data[0] == 1'b1) begin  // gpio0_in instead of gpio0_in_data because former is reg, latter is wire, gpio0_ctl_data is reg
     if (gpio0_sync2 & ~gpio0_in & gpio0_ctl_data[1]) begin // gives interrupt on rising edge
	intc_loc[0] = 1'b1;
      end
      else if (~gpio0_sync2 & gpio0_in & ~gpio0_ctl_data[1]) begin  // gives interrupt on falling edge
    	intc_loc[0] = 1'b1;
      end
      else begin
 	intc_loc[0] = 1'b0; 
      end
  end
  else begin
 	  intc_loc[0] = 1'b0; 
  end
end

always @* begin
  if (gpio1_ctl_data[0] == 1'b1) begin     
      if (gpio1_sync2 &  ~gpio1_in & gpio1_ctl_data[1]) begin 
        intc_loc[1] = 1'b1;
      end
      else if (~gpio1_sync2 & gpio1_in & ~gpio1_ctl_data[1]) begin 
        intc_loc[1] = 1'b1;
      end
      else begin
        intc_loc[1] = 1'b0;
      end
  end
  else begin
          intc_loc[1] = 1'b0;
  end
end


always @* begin
  if (gpio2_ctl_data[0] == 1'b1) begin
      if (gpio2_sync2 & ~gpio2_in & gpio2_ctl_data[1]) begin
        intc_loc[2] = 1'b1;
      end
      else if (~gpio2_sync2 & gpio2_in & ~gpio2_ctl_data[1]) begin
        intc_loc[2] = 1'b1;
      end
      else begin
        intc_loc[2] = 1'b0;
      end
  end
  else begin
          intc_loc[2] = 1'b0;
  end
end


always @* begin
  if (gpio3_ctl_data[0] == 1'b1) begin
      if (gpio3_sync2 & ~gpio3_in & gpio3_ctl_data[1]) begin
        intc_loc[3] = 1'b1;
      end
      else if (~gpio2_sync2 & gpio2_in & ~gpio3_ctl_data[1]) begin
        intc_loc[3] = 1'b1;
      end
      else begin
        intc_loc[3] = 1'b0;
      end
  end
  else begin
          intc_loc[3] = 1'b0;
  end
end


assign intc = intc_loc[0] | intc_loc[1] | intc_loc[2] | intc_loc[3];







// ***************************************************************************************************
// Similarily, Enable MUX  for Read
// ***************************************************************************************************


always @*  begin
 err_dec_rd = 1'b0;
 if (valid_read == 1) begin
   case(haddr[15:0])  //synopsys parallel_case
     GPIO0_CTL_ADDR  : begin
	   read_data = gpio0_ctl_data;
     end
     GPIO0_OUT_ADDR  : begin
	   read_data = gpio0_out_data;
     end
     GPIO0_IN_ADDR  : begin
	   read_data = gpio0_in_data;
     end
     GPIO1_CTL_ADDR : begin
       read_data = gpio1_ctl_data;
     end
     GPIO1_OUT_ADDR  : begin
	   read_data = gpio1_out_data;
     end
     GPIO1_IN_ADDR  : begin
	   read_data = gpio1_in_data;
     end
     GPIO2_CTL_ADDR  : begin
       read_data = gpio2_ctl_data;     
     end
     GPIO2_OUT_ADDR  : begin
       read_data = gpio2_out_data;
     end
     GPIO2_IN_ADDR  : begin
       read_data = gpio2_in_data;
     end
     GPIO3_CTL_ADDR  : begin
       read_data = gpio3_ctl_data;
     end
     GPIO3_OUT_ADDR  : begin
       read_data = gpio3_out_data;
     end
     GPIO3_IN_ADDR  : begin
       read_data = gpio3_in_data;
     end
     default : begin
       read_data = 32'h0;
       err_dec_rd = 1'b1;
     end
  endcase
 end
 else begin
   read_data = 32'h0;
 end
end












// ***************************************************************************************************
// Write the data into the regs
// ***************************************************************************************************

  
 always @ (posedge hclk or negedge hresetn) begin	// the always@ "*" takes care of the sensitivity list - read up more on this later
   if (hresetn == 1'b0) begin
     gpio0_ctl_data <= 32'h0;
     gpio0_out_data <= 32'h0;
     gpio1_ctl_data <= 32'h0;
     gpio1_out_data <= 32'h0;
     gpio2_ctl_data <= 32'h0;
     gpio2_out_data <= 32'h0;
     gpio3_ctl_data <= 32'h0;
     gpio3_out_data <= 32'h0;
   end
   else begin
     if (gpio0_ctl_wr_en == 1'b1) begin
       gpio0_ctl_data <= hwdata;
     end
     if (gpio0_out_wr_en == 1'b1) begin
       gpio0_out_data <= hwdata;
     end
     if (gpio1_ctl_wr_en == 1'b1) begin
	gpio1_ctl_data <= hwdata;
     end
     if (gpio1_out_wr_en == 1'b1) begin
	gpio1_out_data <= hwdata;
     end
     if (gpio2_ctl_wr_en == 1'b1) begin
	gpio2_ctl_data <= hwdata;
     end
     if (gpio2_out_wr_en == 1'b1) begin
	gpio2_out_data <= hwdata;
     end
     if (gpio3_ctl_wr_en == 1'b1) begin
	gpio3_ctl_data <= hwdata;
     end
     if (gpio3_out_wr_en == 1'b1) begin
	 gpio3_out_data <= hwdata;
     end
   end
 end
	

// ***************************************************************************************************
// GPIO Out Data Capture
// ***************************************************************************************************
assign gpio_out[0] = gpio0_out_data[0];
assign gpio_out[1] = gpio1_out_data[0];
assign gpio_out[2] = gpio2_out_data[0];
assign gpio_out[3] = gpio3_out_data[0];



// ***************************************************************************************************
// GPIO In Data Capture
// ***************************************************************************************************


 always @ (posedge hclk or negedge hresetn) begin       
   if (hresetn == 1'b0) begin
	gpio0_sync1 <= 1'b0;
	gpio1_sync1 <= 1'b0;	// why is this sequential? Because we're storing this bit in a latch before padding it.
	gpio2_sync1 <= 1'b0;
	gpio3_sync1 <= 1'b0;
	gpio0_sync2 <= 1'b0;
	gpio1_sync2 <= 1'b0;	// why is this sequential? Because we're storing this bit in a latch before padding it.
	gpio2_sync2 <= 1'b0;
	gpio3_sync2 <= 1'b0;
	gpio0_in    <= 1'b0;
	gpio1_in    <= 1'b0;	// why is this sequential? Because we're storing this bit in a latch before padding it.
	gpio2_in    <= 1'b0;
	gpio3_in    <= 1'b0;
   end
   else begin
    gpio0_sync1 <= gpio_in[0];
	gpio1_sync1 <= gpio_in[1];
	gpio2_sync1 <= gpio_in[2];
	gpio3_sync1 <= gpio_in[3];      
    gpio0_sync2 <= gpio0_sync1;
	gpio1_sync2 <= gpio1_sync1;
	gpio2_sync2 <= gpio2_sync1;
	gpio3_sync2 <= gpio3_sync1;      
    gpio0_in    <= gpio0_sync2;
	gpio1_in    <= gpio1_sync2;
	gpio2_in    <= gpio2_sync2;
	gpio3_in    <= gpio3_sync2;      
   end
 end

 assign gpio0_in_data = {31'b0, gpio0_in};
 assign gpio1_in_data = {31'b0, gpio1_in};
 assign gpio2_in_data = {31'b0, gpio2_in};
 assign gpio3_in_data = {31'b0, gpio3_in};




// ***************************************************************************************************
// Read the data back to the master
// ***************************************************************************************************


 always @ (posedge hclk or negedge hresetn) begin       
   if (hresetn == 1'b0) begin
	 hrdata <= 32'h0;	// shouldn't we make hrdata <= 32'h0 as well?
   end
   else begin
     hrdata    <= read_data;      
   end
 end




// ********************************************************************************************************************
// Generate error response from slave, interdependent external hready signal for master  (WHEN THERE IS AN ERROR!)
// *******************************************************************************************************************


//assign hresp = ~(err_dec_rd & valid_read); 
//we can't do this because err_dec_rd will be valid for only one clock cycle, we need hresp to be valid for two; also, err_dec_rd already depends on valid_read 
//so we don't need to "&" with it. Hence, create a latch for hresp. 


always @(posedge hclk or negedge hresetn) begin         
  if (hresetn == 1'b0) begin
    err_dec_rd_d1  <= 1'b0;
    err_dec_rd_d2  <= 1'b0;
  end
  else begin
    err_dec_rd_d1  <= err_dec_rd;
    err_dec_rd_d2  <= err_dec_rd_d1;
  end
end

assign hresp = err_dec_rd_d1 | err_dec_rd_d2;


always @(posedge hclk or negedge hresetn) begin         
  if (hresetn == 1'b0) begin
    hready  <= 1'b1;
  end
  else if (err_dec_rd) begin
    hready  <= 1'b0;
  end
  else begin
    hready  <= 1'b1;
  end
end



endmodule
