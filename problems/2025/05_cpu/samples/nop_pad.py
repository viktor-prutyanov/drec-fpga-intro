import sys

lines = []

with open(sys.argv[1], 'r') as f:
    lines = f.readlines()

def clog2(x):
    return 2**((x - 1).bit_length())

print(len(lines), "->", clog2(len(lines)))

for i in range(len(lines), clog2(len(lines))):
    lines.append("00000013\n")

with open(sys.argv[1], 'w') as f:
    f.writelines(lines)