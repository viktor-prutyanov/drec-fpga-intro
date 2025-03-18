import sys

ascii_file_name = sys.argv[1]
txt_file_name = sys.argv[2]

lines = []

with open(ascii_file_name, 'r') as f:
    lines = f.readlines()

depth = len(lines)

with open(txt_file_name, 'w') as f:
    for l in lines:
        for c in l[:-1]:
            f.write(f"{ord(c):02X}\n")
        f.write(f"{ord('\r'):02X}\n")
        f.write(f"{ord('\n'):02X}\n")
