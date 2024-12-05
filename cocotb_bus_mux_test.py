import cocotb
from cocotb.regression import TestFactory
from cocotb.regression import RegressionManager
from cocotb.handle import ModifiableObject
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def bus_mux_test(dut):
    """Test the functionality of the bus_mux."""
    
    # Apply inputs to the bus_mux (your I0 to I7 and select lines)
    inputs_16bit = [0b0000000000000111, 0b0000000000000110, 
                    0b0000000000000101, 0b0000000000000100, 
                    0b0000000000000011, 0b0000000000000000]  # Replace with your input values for I3 to I7

    inputs_12bit = [0b000000000011, 0b000000000001]  # Replace with your input values for I1 and I2
    
    selectors = [(0, 0, 0), (0, 0, 1), (0, 1, 0), (0, 1, 1),
                 (1, 0, 0), (1, 0, 1), (1, 1, 0), (1, 1, 1)]  # Possible selector combinations
    dut.I1.value = inputs_12bit[0] 
    dut.I2.value = inputs_12bit[1]
    dut.I3.value = inputs_16bit[0]
    dut.I4.value = inputs_16bit[1]
    dut.I5.value = inputs_16bit[2]
    dut.I6.value = inputs_16bit[3]
    dut.I7.value = inputs_16bit[4]
    
    # Apply input values
    for idx, sel in enumerate(selectors):
        dut.s_0.value = sel[2]
        dut.s_1.value = sel[1]
        dut.s_2.value = sel[0]
        
        # Wait a short time for the combinational logic to propagate
        await Timer(1, units='ns')  # Add delay for signal propagation

        # Check the output based on the selector value
        
        if sel == (0, 0, 0):
            expected_output = 0
        elif sel == (0, 0, 1):
            expected_output = inputs_12bit[0]  # For selector (0, 0, 0), the expected output is I1 padded to 16-bits
        elif sel == (0, 1, 0):
            expected_output = inputs_12bit[1]  # For selector (0, 0, 1), the expected output is I2 padded to 16-bits
        elif sel == (0, 1, 1):
            expected_output = inputs_16bit[0]  # For selector (0, 1, 0), expected output is I3
        elif sel == (1, 0, 0):
            expected_output = inputs_16bit[1]  # For selector (0, 1, 1), expected output is I4
        elif sel == (1, 0, 1):
            expected_output = inputs_16bit[2]  # For selector (1, 0, 0), expected output is I5
        elif sel == (1, 1, 0):
            expected_output = inputs_16bit[3]  # For selector (1, 0, 1), expected output is I6
        elif sel == (1, 1, 1):
            expected_output = inputs_16bit[4]  # For selector (1, 1, 0), expected output is I7

        # Assert the output is as expected
        assert dut.OUT.value == expected_output, f"Test failed for selector {sel}. Expected: {expected_output}, Got: {dut.OUT.value}"
    
    # Log the result
    dut._log.info("Bus mux test passed!")
