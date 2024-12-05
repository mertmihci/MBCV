import cocotb
from cocotb.regression import TestFactory
from cocotb.regression import RegressionManager
from cocotb.handle import ModifiableObject
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()

async def alu_test(dut):

    select_inputs = [(0, 0, 0), (0, 0, 1), (0, 1, 0), (0, 1, 1),
                 (1, 0, 0), (1, 0, 1), (1, 1, 0), (1, 1, 1)]
    
    reg_inputs = [0b1111_1111_1111_1111, 0b0000_0000_0000_0001, 0]

    dut.AC_wire.value = reg_inputs[0]
    dut.DR_wire.value = reg_inputs[1]
    dut.E.value = reg_inputs[2]

    dut.ops_0.value = 0
    dut.ops_1.value = 0
    dut.ops_2.value = 0

    await Timer(1, units='ns')
 
    
    expected_CO = 1
    expected_OVF = 0
    expected_N_flag = 0
    expected_Z_flag = 1

        
    assert dut.OVF.value == expected_OVF, f"Test failed for selector OVF. Expected: {expected_OVF}, Got: {dut.OVF.value}"
    assert dut.N_flag.value == expected_N_flag, f"Test failed for selector N_flag. Expected: {expected_N_flag}, Got: {dut.N_flag.value}"
    assert dut.Z_flag.value == expected_Z_flag, f"Test failed for selector Z_flag. Expected: {expected_Z_flag}, Got: {dut.Z_flag.value}"
    assert dut.CO.value == expected_CO, f"Test failed for selector CO. Expected: {expected_CO}, Got: {dut.CO.value}"
    
    dut._log.info("ALU test passed!")