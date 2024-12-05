# Mano-s-Basic-Computer-with-Verilog

This project is an implementation of Mano's Basic Computer, created as part of the EE445 course at METU. The design includes the fundamental components of the Basic Computer but does not include I/O facilities.

Adding I/O Facilities:
If you'd like to extend the project with I/O capabilities, you can follow the flowchart provided (flowchart.drawio). For better visibility, open the file in draw.io or a compatible viewer to examine the flowchart in detail.

Testing:
The testbenches are written in Python using the Cocotb library, allowing for comprehensive testing of the design. The main test file is cocotb_BC_I_test.py, which verifies all features of the Basic Computer.

How to Run Tests:
Ensure you have Icarus Verilog installed as the simulation tool. If you're using a different simulator, adjust the Makefile accordingly.
Navigate to the project folder in your terminal.
Run the following command:
make
This will compile and simulate the design while running the Cocotb-based testbenches
