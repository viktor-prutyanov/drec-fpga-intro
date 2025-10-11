import logging
from random import randbytes, getrandbits

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

from cocotbext.axi import AxiBus, AxiRam

NUM_XFERS = 16
XFER_SIZE = 2

TIMEOUT = 500000

class TB:
    def __init__(self, dut):
        self.dut = dut

        logging.getLogger("cocotb.axi_inc.m_axi").setLevel(logging.WARN)
        self.axi_ram = AxiRam(
            AxiBus.from_prefix(dut, "m_axi"),
            dut.clk,
            dut.rst_n,
            reset_active_level=False,
            size = 8 * 2**10
        )

        self.clock = Clock(dut.clk, 1, units="ns")

        cocotb.start_soon(self.clock.start())
    
    async def reset(self):
        self.dut.rst_n.setimmediatevalue(0)
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

    tb.dut.i_start.value = 0

    await tb.reset()

@cocotb.test(timeout_time=TIMEOUT, timeout_unit="ns")
async def stress(dut):
    tb = TB(dut)

    tb.axi_ram.write_if.aw_channel.set_pause_generator(gen_rand_bit())
    tb.axi_ram.write_if.w_channel.set_pause_generator(gen_rand_bit())
    tb.axi_ram.write_if.b_channel.set_pause_generator(gen_rand_bit())

    tb.axi_ram.read_if.ar_channel.set_pause_generator(gen_rand_bit())
    tb.axi_ram.read_if.r_channel.set_pause_generator(gen_rand_bit())

    tb.dut.i_start.value = 0

    for i in range(NUM_XFERS):
        tb.axi_ram.write(i * XFER_SIZE, randbytes(XFER_SIZE))

    tb.axi_ram.hexdump(0x0,    NUM_XFERS * XFER_SIZE, prefix='before: ')
    tb.axi_ram.hexdump(0x1000, NUM_XFERS * XFER_SIZE, prefix='before: ')

    await tb.reset()

    tb.dut.i_start.value = 1
    await RisingEdge(tb.dut.clk)
    tb.dut.i_start.value = 0

    await RisingEdge(tb.dut.o_done)
    await RisingEdge(tb.dut.clk)

    tb.axi_ram.hexdump(0x0,    NUM_XFERS * XFER_SIZE, prefix='after : ')
    tb.axi_ram.hexdump(0x1000, NUM_XFERS * XFER_SIZE, prefix='after : ')