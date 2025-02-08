## Задание

1. Умножитель `fp16mul.v` для нормализованных FP16 чисел (применяются DAZ и FTZ) с округлением roundTowardsZero или roundTiesToEven
2. Сумматор `fp16add.v` для нормализованных FP16 чисел (применяются DAZ и FTZ) с округлением roundTowardsZero или roundTiesToEven

Тестовый генератор `test.py` и тестбенч `fp16u_tb.v` запускаются через `make sim` и проверяют результаты с точностью ±1 бит.

Фильтр `fp16filter.py` добавляет в GTKWave поддержку формата FP16.