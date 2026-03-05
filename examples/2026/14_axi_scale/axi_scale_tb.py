import logging
from random import randbytes, getrandbits

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

from cocotbext.axi import AxiBus, AxiLiteWriteBus, AxiRam, AxiLiteMasterWrite

TIMEOUT = 5000

class TB:
    def __init__(self, dut):
        self.dut = dut

        self.axil = AxiLiteMasterWrite(
            AxiLiteWriteBus.from_prefix(dut, "s_axil"),
            dut.clk,
            dut.rst_n,
            reset_active_level=False
        )

        self.axi_ram = AxiRam(
            AxiBus.from_prefix(dut, "m_axi"),
            dut.clk,
            dut.rst_n,
            reset_active_level=False,
            size = 4 * 2**12
        )

        cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())
    
    async def reset(self):
        self.dut.rst_n.setimmediatevalue(0)
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

    tb.axi_ram.write_if.aw_channel.set_pause_generator(gen_rand_bit())
    tb.axi_ram.write_if.w_channel.set_pause_generator(gen_rand_bit())
    tb.axi_ram.write_if.b_channel.set_pause_generator(gen_rand_bit())

    tb.axi_ram.read_if.ar_channel.set_pause_generator(gen_rand_bit())
    tb.axi_ram.read_if.r_channel.set_pause_generator(gen_rand_bit())

    tb.axi_ram.write(0x1000, randbytes(0x100))

    tb.axi_ram.hexdump(0x1000, 0x200, prefix='src. buf: ')

    await tb.reset()

    scale = 3
    await tb.axil.write(0x0,  0x1000.to_bytes(4, 'little'))
    await tb.axil.write(0x4,  0x2000.to_bytes(4, 'little'))
    await tb.axil.write(0x8,   0x100.to_bytes(4, 'little'))
    await tb.axil.write(0xC,   scale.to_bytes(4, 'little'))
    await tb.axil.write(0x10,    0x1.to_bytes(4, 'little'))

    await RisingEdge(tb.dut.o_irq)

    tb.axi_ram.hexdump(0x2000, 0x200, prefix='dst. buf: ')

    await ClockCycles(tb.dut.clk, 10)

    scale = 5
    await tb.axil.write(0x0,  0x1000.to_bytes(4, 'little'))
    await tb.axil.write(0x4,  0x2000.to_bytes(4, 'little'))
    await tb.axil.write(0x8,   0x100.to_bytes(4, 'little'))
    await tb.axil.write(0xC,   scale.to_bytes(4, 'little'))
    await tb.axil.write(0x10,    0x1.to_bytes(4, 'little'))

    await RisingEdge(tb.dut.o_irq)

    tb.axi_ram.hexdump(0x2000, 0x200, prefix='dst. buf: ')

    await ClockCycles(tb.dut.clk, 10)
