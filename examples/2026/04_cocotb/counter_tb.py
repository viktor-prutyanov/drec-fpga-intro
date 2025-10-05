import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock

@cocotb.test()
async def simple(dut):
    clock = Clock(dut.clk, 1, "ns").start(start_high=False)
    cocotb.start_soon(clock)

    dut.rst_n.value = 0
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)
    
    for i in range(10):
        cocotb.log.info(f"Count: {dut.o_cnt.value}")
        await RisingEdge(dut.clk)
    
    assert dut.o_cnt.value == 10, f"Value is {dut.o_cnt.value}"

