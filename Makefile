# Makefile

# defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

#Add your sources one by one as below or use *.v to add all verilog files
VERILOG_SOURCES += $(PWD)/BC_I.v
VERILOG_SOURCES += $(PWD)/datapath.v
VERILOG_SOURCES += $(PWD)/control.v
VERILOG_SOURCES += $(PWD)/memory.v
VERILOG_SOURCES += $(PWD)/onebitreg.v 
VERILOG_SOURCES += $(PWD)/sixteenbitreg.v 
VERILOG_SOURCES += $(PWD)/twelvebitreg.v 
VERILOG_SOURCES += $(PWD)/alu.v
VERILOG_SOURCES += $(PWD)/bus_mux.v
VERILOG_SOURCES += $(PWD)/timeseq.v


# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
#Should be the name of the basic computer module for you
TOPLEVEL = BC_I

# MODULE is the basename of the Python test file
#Name of your python file
MODULE = cocotb_BC_I_test

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim