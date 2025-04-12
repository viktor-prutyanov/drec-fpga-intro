import sys

lines = []

with open(sys.argv[1], 'r') as f:
    lines = f.readlines()

def clog2(x):
    return 2**((x - 1).bit_length())

new_len = clog2(len(lines))

if len(sys.argv) > 2:
    new_len = int(sys.argv[2])

print(len(lines), "->", new_len)

for i in range(len(lines), new_len):
    lines.append("00000013\n")

with open(sys.argv[1], 'w') as f:
    f.writelines(lines)