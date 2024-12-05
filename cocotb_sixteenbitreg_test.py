import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock
from cocotb.triggers import Timer

@cocotb.test()
async def test_sixteenbitreg(dut):
    """Test the sixteen-bit register."""
    # Set initial values for control signals
    await cocotb.start(Clock(dut.clk, 10, 'us').start(start_high=False))
    posedge = RisingEdge(dut.clk)

    dut.reset.value = 0
    dut.load.value = 0
    dut.incr.value = 0
    dut.D_in.value = 0

    # Apply a reset and verify OUT is 0
    dut.reset.value = 1
    await posedge
    await Timer(1, units="ns")
    dut.reset.value = 0
    assert dut.OUT.value == 0, f"Reset failed. Expected 0, got {dut.OUT.value}"

    # Load a value into the register
    load_value = 0b0111_1110_0000_1111  # Random 16-bit value
    dut.D_in.value = load_value
    dut.load.value = 1
    await posedge
    await Timer(1, units="ns")
    dut.load.value = 0
    assert dut.OUT.value == load_value, f"Load failed. Expected {load_value}, got {dut.OUT.value}"

    # Increment the register
    expected_value = load_value + 1
    dut.incr.value = 1
    await posedge
    await Timer(1, units="ns")
    dut.incr.value = 0
    assert dut.OUT.value == expected_value, f"Increment failed. Expected {expected_value}, got {dut.OUT.value}"

    # Check that OUT remains unchanged when no control signals are active
    await posedge
    await Timer(1, units="ns")
    assert dut.OUT.value == expected_value, f"OUT changed unexpectedly. Expected {expected_value}, got {dut.OUT.value}"

    # Test reset again
    dut.reset.value = 1
    await posedge
    await Timer(1, units="ns")
    dut.reset.value = 0
    assert dut.OUT.value == 0, f"Reset failed. Expected 0, got {dut.OUT.value}"

    dut._log.info("sixteenbitreg test passed!")
