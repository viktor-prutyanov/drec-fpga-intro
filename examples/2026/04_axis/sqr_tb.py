import logging

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

from cocotbext.axi import AxiStreamBus, AxiStreamSource, AxiStreamSink

from random import getrandbits

SIZE = 2
NR_ITERS = 16

TIMEOUT = 500000

class TB:
    def __init__(self, dut):
        self.dut = dut

        logging.getLogger("cocotb.sqr.s_axis").setLevel(logging.INFO)
        self.tx = AxiStreamSource(
            AxiStreamBus.from_prefix(dut, "s_axis"),
            dut.clk,
            dut.rst_n,
            reset_active_level=False
        )

        logging.getLogger("cocotb.sqr.m_axis").setLevel(logging.INFO)
        self.rx = AxiStreamSink(
            AxiStreamBus.from_prefix(dut, "m_axis"),
            dut.clk,
            dut.rst_n,
            reset_active_level=False
        )

        self.clock = Clock(dut.clk, 1, units="ns")

        cocotb.start_soon(self.clock.start())
    
    async def reset(self):
        self.dut.rst_n.setimmediatevalue(0)
        await RisingEdge(self.dut.clk)
        await RisingEdge(self.dut.clk)
        self.dut.rst_n.value = 1
        await RisingEdge(self.dut.clk)
'''
@cocotb.test(timeout_time=TIMEOUT, timeout_unit="ns")
async def simple(dut):
    tb = TB(dut)

    await tb.reset()

    for i in range(NR_ITERS):
        x = 1 << (i % 16)
        pkt = x.to_bytes(SIZE, 'little')
        await tb.tx.send(pkt)
    
    for i in range(NR_ITERS):
        x = 1 << (i % 16)
        pkt = (await tb.rx.recv()).tdata
        x2 = int.from_bytes(pkt, 'little')
        assert x2 == x**2
    
    assert tb.tx.empty()
    assert tb.rx.empty()
'''
def gen_rand_bit():
    while True:
        yield getrandbits(1)
'''
@cocotb.test(timeout_time=TIMEOUT, timeout_unit="ns")
async def idle(dut):
    tb = TB(dut)
    tb.tx.set_pause_generator(gen_rand_bit())

    await tb.reset()

    for i in range(NR_ITERS):
        x = 1 << (i % 16)
        pkt = x.to_bytes(SIZE, 'little')
        await tb.tx.send(pkt)
    
    for i in range(NR_ITERS):
        x = 1 << (i % 16)
        pkt = (await tb.rx.recv()).tdata
        x2 = int.from_bytes(pkt, 'little')
        assert x2 == x**2
    
    assert tb.tx.empty()
    assert tb.rx.empty()

@cocotb.test(timeout_time=TIMEOUT, timeout_unit="ns")
async def backpressure(dut):
    tb = TB(dut)
    tb.rx.set_pause_generator(gen_rand_bit())

    await tb.reset()

    for i in range(NR_ITERS):
        x = 1 << (i % 16)
        pkt = x.to_bytes(SIZE, 'little')
        await tb.tx.send(pkt)
    
    for i in range(NR_ITERS):
        x = 1 << (i % 16)
        pkt = (await tb.rx.recv()).tdata
        x2 = int.from_bytes(pkt, 'little')
        assert x2 == x**2
    
    assert tb.tx.empty()
    assert tb.rx.empty()
'''
@cocotb.test(timeout_time=TIMEOUT, timeout_unit="ns")
async def stress(dut):
    tb = TB(dut)
    tb.tx.set_pause_generator(gen_rand_bit())
    tb.rx.set_pause_generator(gen_rand_bit())

    await tb.reset()

    for i in range(NR_ITERS):
        x = 1 << (i % 16)
        pkt = x.to_bytes(SIZE, 'little')
        await tb.tx.send(pkt)
    
    for i in range(NR_ITERS):
        x = 1 << (i % 16)
        pkt = (await tb.rx.recv()).tdata
        x2 = int.from_bytes(pkt, 'little')
        assert x2 == x**2
    
    assert tb.tx.empty()
    assert tb.rx.empty()