import logging
from random import randbytes, getrandbits

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

from cocotbext.axi import AxiLiteBus, AxiLiteMaster

NUM_XFERS = 6
XFER_SIZE = 4

TIMEOUT = 50000

class TB:
    def __init__(self, dut):
        self.dut = dut

        logging.getLogger("cocotb.axil2reg_inc.s_axil").setLevel(logging.WARN)
        self.axil = AxiLiteMaster(
            AxiLiteBus.from_prefix(dut, "s_axil"),
            dut.clk,
            dut.rst_n,
            reset_active_level=False
        )

        cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())
    
    async def reset(self):
        self.dut.rst_n.value = 0
        await RisingEdge(self.dut.clk)
        await RisingEdge(self.dut.clk)
        self.dut.rst_n.value = 1
        await RisingEdge(self.dut.clk)

def gen_rand_bit():
    while True:
        yield getrandbits(1)

@cocotb.test()
async def dummy(dut):
    tb = TB(dut)

    await tb.reset()

@cocotb.test(timeout_time=TIMEOUT, timeout_unit="ns")
async def stress(dut):
    tb = TB(dut)

    for c in [
        tb.axil.write_if.aw_channel,
        tb.axil.write_if.w_channel,
        tb.axil.write_if.b_channel,
        tb.axil.read_if.ar_channel,
        tb.axil.read_if.r_channel
    ]:
        c.set_pause_generator(gen_rand_bit())

    await tb.reset()

    for i in range(NUM_XFERS):
        wr_data = randbytes(XFER_SIZE)
        await tb.axil.write(0x1000, wr_data)
        wr_data = int.from_bytes(wr_data, 'little')
        tb.dut._log.info(f"Write: {wr_data:#x}")

        rd_data = (await tb.axil.read(0x1000, XFER_SIZE)).data
        rd_data = int.from_bytes(rd_data, 'little')
        tb.dut._log.info(f"Read: {rd_data:#x}")
        assert rd_data == (wr_data + 1)
    
