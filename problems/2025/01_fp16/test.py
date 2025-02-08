#!/usr/bin/env python3

import sys
import numpy as np

np.random.seed(0)

N = int(sys.argv[1])

xs = 2**((np.random.rand(N) - 0.5).astype(np.float16) * 15)
xs = xs * (np.random.randint(2, size=N).astype(np.float16) * 2 - 1)
ys = 2**((np.random.rand(N) - 0.5).astype(np.float16) * 15)
ys = ys * (np.random.randint(2, size=N).astype(np.float16) * 2 - 1)

if sys.argv[2] == 'add':
    zs = xs + ys
elif sys.argv[2] == 'mul':
    zs = xs * ys

for x, y, z in zip(xs, ys, zs):
    # print(x, y, z)
    print(bytes(x)[::-1].hex(), bytes(y)[::-1].hex(), bytes(z)[::-1].hex(), sep='')