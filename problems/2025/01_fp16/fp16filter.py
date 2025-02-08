#!/usr/bin/env python3

import sys
import numpy as np

def main():
    while True:
        line = sys.stdin.readline()
        if not line:
            return 0
        
        b = int(line, base=16).to_bytes(2, 'little')
        c = np.frombuffer(b, dtype=np.float16, count=1)

        # outgoing filtered values must have a newline
        sys.stdout.write(f"{c[0]}\n")
        sys.stdout.flush()

if __name__ == '__main__':
	sys.exit(main())