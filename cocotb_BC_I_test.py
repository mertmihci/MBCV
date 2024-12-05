import cocotb
from cocotb.clock import Clock
from cocotb.regression import TestFactory
from cocotb.regression import RegressionManager
from cocotb.handle import ModifiableObject
from cocotb.triggers import RisingEdge, Timer

def print_register(dut):
    print(f"\n\
    PC:     {dut.PC.value}\t {hex(dut.PC.value)}\n\
    PC_incr: {dut.Control.PC_incr.value}\n\
    AR:     {dut.AR.value}\t {hex(dut.AR.value)}\n\
    IR: {dut.IR.value}\t {hex(dut.IR.value)}\n\
    AC: {dut.AC.value}\t {hex(dut.AC.value)}\n\
    DR: {dut.DR.value}\t {hex(dut.DR.value)}\n\
    Time Sequence: {dut.Control.T_out.value}\t {hex(dut.Control.T_out.value)}\n\
    ------------------------------------------\n\
")
#Memory: {dut.Datapath.memory_out.value}\t {hex(dut.Datapath.memory_out.value)}\n\

@cocotb.test()

async def BC_I_TEST(dut):
    await cocotb.start(Clock(dut.clk, 10, 'us').start(start_high=False))
    posedge = RisingEdge(dut.clk)
    dut.FGI.value = 1
    await posedge #PC Starts
    
    #**************** 0 LDA 050
    await posedge #T0
    await posedge #T1
    await posedge #T3
    await posedge #T3
    await posedge #T4
    await posedge #T5
    assert dut.AC.value == 0xFFFF, f"LDA execution failed. Expected AC = 0xFFFF, Obtained {hex(dut.AC.value)}"
    dut._log.info("LDA test passed!")
    #**************** 1 AND 051
    await posedge #T0
    await posedge #T1
    await posedge #T2
    await posedge #T3
    await posedge #T4
    await posedge #T5
    assert dut.AC.value == 0x1111, f"AND execution failed. Expected AC = 0x1111, Obtained {hex(dut.AC.value)}"
    dut._log.info("AND test passed!")
    #**************** 0 ADD 053
    await posedge #T0
    await posedge #T1
    await posedge #T2
    await posedge #T3
    await posedge #T4
    await posedge #T5
    assert dut.AC.value == 0x1113, f"ADD execution failed. Expected AC = 0x1113, Obtained {hex(dut.AC.value)}"
    dut._log.info("ADD test passed!")
    #**************** 1 STA 054
    await posedge #T0
    await posedge #T1
    await posedge #T2
    await posedge #T3
    await posedge #T4
    assert dut.Datapath.memory_out.value == dut.AC.value, f"STA execution failed. Expected M[0x0FF] = {hex(dut.AC.value)}, Obtained {hex(dut.Datapath.memory_out.value)}"
    dut._log.info("STA test passed!")
    #**************** 0 BSA 0EF
    await posedge #T0
    await posedge #T1
    await posedge #T2
    await posedge #T3
    await posedge #T4
    await posedge #T5
    assert dut.PC.value == 0x0F0, f"BSA execution failed. Expected PC = 0x0F0, Obtained {hex(dut.PC.value)}"
    dut._log.info("BSA test passed!")
    #**************** 1 BUN 0EF
    await posedge #T0
    await posedge #T1
    await posedge #T2
    await posedge #T3
    await posedge #T4
    assert dut.PC.value == 0x007, f"BUN execution failed. Expected PC = 0x007, Obtained {hex(dut.PC.value)}"
    dut._log.info("BUN test passed!")
    #**************** 0 ISZ 050
    await posedge #T0
    await posedge #T1
    await posedge #T2
    await posedge #T3
    await posedge #T4
    await posedge #T5
    await posedge #T6
    assert dut.PC.value == 0x009, f"ISZ execution failed. Expected PC = 0x009, Obtained {hex(dut.PC.value)}"
    dut._log.info("ISZ test passed!")
    #**************** CLA (7800)
    await posedge #T0
    await posedge #T1
    await posedge #T2
    await posedge #T3
    assert dut.AC.value == 0x0, f"CLA execution failed. Expected AC = 0x0, Obtained {hex(dut.AC.value)}"
    dut._log.info("CLA test passed!")
    #**************** CMA (7200)
    await posedge #T0
    await posedge #T1
    await posedge #T2
    await posedge #T3
    assert dut.AC.value == 0xFFFF, f"CMA execution failed. Expected AC = 0xFFFF, Obtained {hex(dut.AC.value)}"
    dut._log.info("CMA test passed!")
    #**************** CIR (7080)
    await posedge #T0
    await posedge #T1
    await posedge #T2
    await posedge #T3
    assert dut.AC.value == 0x7FFF, f"CIR execution failed. Expected AC = 0x7FFF, Obtained {hex(dut.AC.value)}"
    assert dut.Datapath.E_out.value == 0b1, f"CIR execution failed. Expected E = 0b1, Obtained {hex(dut.Datapath.E_out.value)}"
    dut._log.info("CIR test passed!")
    #**************** CIL (7040)
    await posedge #T0
    await posedge #T1
    await posedge #T2
    await posedge #T3
    assert dut.AC.value == 0xFFFF, f"CIL execution failed. Expected AC = 0xFFFF, Obtained {hex(dut.AC.value)}"
    assert dut.Datapath.E_out.value == 0b0, f"CIL execution failed. Expected E = 0b0, Obtained {hex(dut.Datapath.E_out.value)}"
    dut._log.info("CIL test passed!")
    #**************** CME (7100)
    await posedge #T0
    await posedge #T1
    await posedge #T2
    await posedge #T3
    assert dut.Datapath.E_out.value == 0b1, f"CME execution failed. Expected E = 0b1, Obtained {hex(dut.Datapath.E_out.value)}"
    dut._log.info("CME test passed!")
    #**************** CLA (7800)
    await posedge #T0
    await posedge #T1
    await posedge #T2
    await posedge #T3
    assert dut.AC.value == 0x0, f"CLA execution failed. Expected AC = 0x0, Obtained {hex(dut.AC.value)}"
    dut._log.info("CLA test passed!")
    #**************** SZA (7004)
    await posedge #T0
    await posedge #T1
    await posedge #T2
    await posedge #T3
    assert dut.PC.value == 0x11, f"SZA execution failed. Expected PC = 0x11, Obtained {hex(dut.PC.value)}"
    dut._log.info("SZA test passed!")
    #**************** ION (F080)
    dut.FGI.value = 0   #Disable Interrupts
    await posedge #T0
    await posedge #T1
    await posedge #T2
    await posedge #T3
    assert dut.Datapath.IEN_out.value == 0b1, f"ION execution failed. Expected IEN = 0b1, Obtained {hex(dut.Datapath.IEN_out.value)}"
    dut._log.info("ION test passed!")
    #**************** INCAC (7020)
    await posedge #T0
    await posedge #T1
    await posedge #T2
    await posedge #T3
    assert dut.AC.value == 0x1, f"INCAC execution failed. Expected AC = 0x1, Obtained {hex(dut.AC.value)}"
    dut._log.info("INCAC test passed!")
    #**************** SPA (7010)
    await posedge #T0
    await posedge #T1
    dut.FGI.value = 1 #Enable interrupts 
    await posedge #T2
    await posedge #T3
    assert dut.PC.value == 0x15, f"SPA execution failed. Expected PC = 0x15, Obtained {hex(dut.PC.value)}"
    assert dut.Control.R.value == 0b1, f"Setting R failed."
    dut._log.info("SPA test passed!")
    #**************** ISR STARTS
    #***************************
    await posedge #T0
    await posedge #T1
    await posedge #T2
    assert dut.PC.value == 0x1, f"ISR failed. Expected PC = 0x1, Obtained {hex(dut.PC.value)}"
    assert dut.Control.R.value == 0b0, f"Resetting R failed"
    dut._log.info("ISR initiated")
    #**************** 0 BUN 100
    await posedge #T0
    await posedge #T1
    await posedge #T2
    await posedge #T3
    await posedge #T4
    assert dut.PC.value == 0x100, f"ISR starting failed. Expected PC = 0x100, Obtained {hex(dut.PC.value)}"
    dut._log.info("ISR Branched!")
    #**************** 0 LDA 056
    await posedge #T0
    await posedge #T1
    await posedge #T2
    await posedge #T3
    await posedge #T4
    await posedge #T5
    assert dut.AC.value == 0x1233, f"LDA execution failed. Expected AC = 0x1233, Obtained {hex(dut.AC.value)}"
    dut._log.info("LDA test passed!")
    #**************** INCAC
    await posedge #T0
    await posedge #T1
    await posedge #T2
    await posedge #T3
    assert dut.AC.value == 0x1234, f"INCAC execution failed. Expected AC = 0x1234, Obtained {hex(dut.AC.value)}"
    dut._log.info("INCAC test passed!")
    #**************** 1 BUN 0
    await posedge #T0
    await posedge #T1
    await posedge #T2
    await posedge #T3
    await posedge #T4
    assert dut.PC.value == 0x15, f"BUN execution failed. Expected PC = 0x015, Obtained {hex(dut.PC.value)}"
    dut._log.info("PC restored!")
    #**************** Leaving ISR
    #****************************
    #**************** 0 LDA 057
    await posedge #T0
    await posedge #T1
    await posedge #T2
    await posedge #T3
    await posedge #T4
    await posedge #T5
    assert dut.AC.value == 0xFFFF, f"LDA execution failed. Expected AC = 0xFFFF, Obtained {hex(dut.AC.value)}"
    dut._log.info("LDA test passed!")
    #**************** SNA (7008)
    await posedge #T0
    await posedge #T1
    await posedge #T2
    await posedge #T3
    assert dut.PC.value == 0x18, f"SNA execution failed. Expected PC = 0x18, Obtained {hex(dut.PC.value)}"
    dut._log.info("SNA test passed!")
    #**************** CLE (7400)
    await posedge #T0
    await posedge #T1
    await posedge #T2
    await posedge #T3
    assert dut.Datapath.E_out.value == 0b0, f"CLE execution failed. Expected E = 0b0, Obtained {hex(dut.Datapath.E_out.value)}"
    dut._log.info("CLE test passed!")
    #**************** SZE (7002)
    await posedge #T0
    await posedge #T1
    await posedge #T2
    await posedge #T3
    assert dut.PC.value == 0x1B, f"CME execution failed. Expected PC = 0x01B, Obtained {hex(dut.PC.value)}"
    dut._log.info("SZE test passed!")
    #**************** HALT (7001)
    await posedge #T0
    await posedge #T1
    await posedge #T2
    await posedge #T3
    assert dut.Control.S.value == 0b0, f"HALT execution failed. Expected S = 0b0, Obtained {hex(dut.Control.S.value)}"
    dut._log.info("HALT!")
    #**************** ALL TESTS ARE DONE, YOU COULD OBSERVE PC FOR A WHILE
    """
    await posedge #T0
    print_register(dut)
    await posedge #T1
    print_register(dut)
    await posedge #T2
    print_register(dut)
    """










    
