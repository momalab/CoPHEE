Project Presentation Overleaf Link
https://www.overleaf.com/project/632aadf3ab08f97b1824fc45

# CoPHEE
Research Paper Link
https://nyuad.nyu.edu/content/dam/nyuad/news/news/2019/june/CoPHEE-report.pdf

# Encrypted Data Processor Using Partial Homomorphic Encryption


# Creating GitHub Account
•	Open https://github.com in a web browser, and then select Sign up.
•	Enter your email address
•	Create a password for your new GitHub account, and Enter a username, too. 
•	Next, choose whether you want to receive updates and announcements via email.
•	select Continue.
•	Verify your account by solving a puzzle. 
•	Select the Start Puzzle button to do so, and then follow the prompts.
•	After you verify your account, 
•	select the Create account button.
•	Next, GitHub sends a launch code to your email address.
•	ype that launch code in the Enter code dialog, and then press Enter.
•	Congratulations! You've successfully created your GitHub account.

# Creating Overleaf Account
•	Open https://www.overleaf.com/ in a web browser, and then select Sign up
•	Add an email address from a university, college, or other higher education institution, and confirm your role and department.
•	Check your email for a message from Overleaf to verify and complete signup.

#AND_Gate

#4_bit_Full_Adder

Get Clone Code


#IEEE Standard for Verilog®
Hardware Description Language
IEEE Computer Society
Sponsored by the
Design Automation Standards Committee

HEAD
IEEE Std 1364™-2005
(Revision of IEEE Std 1364-2001)

#Aim
Understand the verilog module base on 2005 to find out the syntex error in the Encrypted data processor and correct the module for sucessfully run.


All the RTL directories are present under:
https://github.com/momalab/CoPHEE/tree/master/modules 

Final Set of RTL Files:

  #Chip Top File
  ./modules/ccs0101/rtl/ccs0101.v
  ./modules/ccs0101/rtl/ccs0101_define.v

  #Chip IO File
  ./modules/padring/rtl/padring.v

  #Chip Core File
  ./modules/chip_core/rtl/chip_core.v

  #Bus Matrix
  ./modules/ahb_ic/rtl/ahb_ic.v

  #Uart Master
  ./modules/uartm/rtl/uartm.v
  ./modules/uartm/rtl/uartm_ahb.v
  ./modules/uartm/rtl/uartm_rx.v
  ./modules/uartm/rtl/uartm_tx.v

  #Chip Configuration Space
  ./modules/gpcfg/rtl/gpcfg_rd.v
  ./modules/gpcfg/rtl/gpcfg_rd_wr.v
  ./modules/gpcfg/rtl/gpcfg_rd_wr_p.v
  ./modules/gpcfg/rtl/hw_rng_fsm.v
  ./modules/gpcfg/rtl/gpcfg.v

  #Modular Interleaved Multiplier
  ./modules/crypto_lib/rtl/mod_mul_il.v

  #Montgomery Multiplier
  ./modules/crypto_lib/rtl/montgomery_to_conv.v
  ./modules/crypto_lib/rtl/montgomery_mul.v
  ./modules/crypto_lib/rtl/montgomery_from_conv.v

  #Modular Inverse/Binary Exended GCD
  ./modules/crypto_lib/rtl/bin_ext_gcd.v

  #Modular Exponentiation
  ./modules/gpcfg/rtl/mod_exp.v

  #TRNG
  ./modules/crypto_lib/rtl/trng_wrap.v
  ./modules/crypto_lib/rtl/trng.v
  ./modules/crypto_lib/rtl/random_num_gen.v
  ./modules/crypto_lib/rtl/vn_corrector.v

  #UART SLAVE
  ./modules/uarts/rtl/uarts.v
  ./modules/uarts/rtl/uarts_tx.v
  ./modules/uarts/rtl/uarts_rx.v

  #Technology Library Cells directly used in ./modules/chip_core/rtl/chip_core.v 
  ./modules/chiplib/rtl/chiplib.v
  ./modules/padring/rtl/rgo_csm65_25v33_50.v

  #GPIO
  ./modules/gpio/rtl/gpio.v

  #Top Level Test Bench
  ./modules/ccs0101/verif/ccs0101_tb.v
  ./modules/ccs0101/verif/pad_model.v
  ./modules/ccs0101/verif/padring_tb.v
  
  #Include directories/Search path needed for compilation
  +incdir+./design/modules/uartm/rtl
  +incdir+./design/modules/uarts/rtl
  +incdir+./design/modules/gpcfg/rtl


  #Run Files 
After running the verilog code we get the the following files
The next task to understand those files.

designs/<design_name>
├─ config.tcl
├─runs
│    ├── <tag>
│   │   ├── config.tcl
│   │    ├── logs
│   │   │      ├── cts
│   │   │      ├── cvc
│   │   │      ├── floorplan
│   │   │      ├── magic
│   │   │      ├── placement
│   │   │      ├── routing
│   │   │      └── synthesis
│   │   ├── reports
│   │   │      ├── cts
│   │   │      ├── cvc
│   │   │      ├── floorplan
│   │   │      ├── magic
│   │   │      ├── placement
│   │   │      ├── routing
│   │   │     └── synthesis
│   │   ├── results
│   │   │           ├── cts
│   │   │           ├── cvc
│   │   │           ├── floorplan
│   │   │           ├── magic
│   │   │           ├── placement
│   │   │           ├── routing
│   │   │          └── synthesis
│   │   └── tmp
│   │             ├── cts
│   │             ├── cvc
│   │             ├── floorplan
│   │             ├── magic
│   │             ├── placement
│   │             ├── routing
│   │             └── synthesis

# Adding an MMIO Peripheral

•	Project Task
•	Parameters and Keys
•	IO ports - a Bundle and a trait
•	Chisel Module (the actual circuit)
•	Memory Mapping
•	Enabling TileLink
•	Cake Pattern
•	Mix in the MMIO Peripheral
•	Verification
•	Final Remarks 

# Chisel Bootcamp

• Introduction to Scala
• Chisel designs
• Hardware description language embedded in Scala
• Basics and some advanced features of Chisel
