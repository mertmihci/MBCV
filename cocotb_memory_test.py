import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock
from cocotb.triggers import Timer

@cocotb.test()

async def memory_test(dut):
    await cocotb.start(Clock(dut.clk, 10, 'us').start(start_high=False))
    posedge = RisingEdge(dut.clk)
    
    dut.memoryblock[0b0000_0000_0000].value = 0b0000_1111_0101_1111
    dut.memoryblock[0b0000_0000_0001].value = 0b0000_1111_0101_0000

    dut.AR_wire.value = 0b0000_0000_0000
    dut.D_in.value = 0b1111_0000_1111_0000
    dut.write.value = 0

    await Timer(1, units="ns")

    assert dut.OUT.value == 0b0000_1111_0101_1111, f"Reading failed. Expected 0b0000_1111_0101_1111, got {dut.OUT.value}"

    dut.AR_wire.value = 0b0000_0000_0001
    dut.write.value = 1
    await posedge
    dut.write.value = 0
    await Timer(1, units="ns")

    assert dut.OUT.value == 0b1111_0000_1111_0000, f"Writing failed. Expected 1111_0000_1111_0000, got {dut.OUT.value}"

    dut._log.info("memory test passed!")