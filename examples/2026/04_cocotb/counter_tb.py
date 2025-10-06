import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock

@cocotb.test() # Добавляет тест в список тестов для запуска
async def simple(dut):
    '''Тест счетчика'''

    # Создаем объект корутины, переключающей сигнал clk с частотой 1ГГц
    clock = Clock(dut.clk, 1, "ns").start(start_high=False)
    # Планируем запуск корутины, отложенный до следующего await
    cocotb.start_soon(clock)

    dut.rst_n.value = 0       # Записываем 0 в rst_n
    await RisingEdge(dut.clk) # Передаем управление симулятору до след. фронта clk
    dut.rst_n.value = 1       # Записываем 1 в rst_n
    await RisingEdge(dut.clk) # Передаем управление симулятору до след. фронта clk
    
    for i in range(10):
        cocotb.log.info(f"Count: {dut.o_cnt.value}") # Считываем значение o_cnt
        await RisingEdge(dut.clk) # Передаем управление симулятору до след. фронта clk
    
    assert dut.o_cnt.value == 10, f"Value is {dut.o_cnt.value}" #  Проверка

