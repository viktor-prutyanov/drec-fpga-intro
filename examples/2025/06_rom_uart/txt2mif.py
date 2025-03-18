import sys

txt_file_name = sys.argv[1]
mif_file_name = sys.argv[2]
width = int(sys.argv[3])

lines = []

with open(txt_file_name, 'r') as f:
    lines = f.readlines()

depth = len(lines)

with open(mif_file_name, 'w') as f:
    f.write(f'WIDTH={width};\n')
    f.write(f'DEPTH={depth};\n')
    f.write('\n')
    f.write(f'ADDRESS_RADIX=UNS;\n')
    f.write(f'DATA_RADIX=HEX;\n')
    f.write('\n')
    f.write('CONTENT BEGIN\n')
    for i, l in enumerate(lines):
        f.write(f"\t{i} : {l[:-1]};\n")
    f.write('END;')