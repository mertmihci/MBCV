import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock
from cocotb.triggers import Timer

@cocotb.test()

async def PC_to_AR_test(dut):
        # Set initial values for control signals
    await cocotb.start(Clock(dut.clk, 10, 'us').start(start_high=False))
    posedge = RisingEdge(dut.clk)

    dut.bus_sel.value = 0b011
    await(posedge)
    dut.AR_load.value = 1
    await(posedge)
    dut.AR_load.value = 0

    print(dut)

    assert dut.AR_out.value == 1, f"Transfer failed. Expected 1, got {dut.AR_out.value}"
    dut._log.info(f"Result: AR = {dut.AR_out.value}")

@cocotb.test

async def Memory_to_DR(dut):
    await cocotb.start(Clock(dut.clk, 10, 'us').start(start_high=False))
    posedge = RisingEdge(dut.clk)

    dut.bus_sel.value = 0b111
    dut.DR_load.value = 1
    await(posedge)
    dut.DR_load.value = 0
    await Timer(1, units="ns")  # Wait for value to stabilize

    assert dut.memory_out.value == 0xFDEC, f"Memory content failed. Expected 0xFDEC, got {dut.memory_out.value}"
    assert dut.DR_out.value == 0xFDEC, f"Reset failed. Expected 0xFDEC, got {dut.DR_out.value}"

    dut._log.info(f"Result: DR = {dut.DR_out.value}")
    



    


