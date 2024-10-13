#!/usr/bin/env python3

#------------------------------------------------------------------------------
# z80asm Z80 macro assembler
#
# Copyright (C) Paulo Custodio, 2011-2024
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

# Build table of all opcodes

import json
import re
import sys

table = {}

ASSEMBLY_SIZE = 28-1
CPU_SIZE = 12-1
OPCODES_SIZE = 60-1

def align(size, text):
    if len(text) > size:
        raise ValueError(f"{text} length > {size}")
    return text + " "*(size - len(text))

def write_row(f, assembly, cpu, opcodes):
    f.write("|" + align(ASSEMBLY_SIZE, assembly)
          + "|" + align(CPU_SIZE, cpu)
          + "|" + align(OPCODES_SIZE, opcodes) 
          + "|\n")

def format_opcodes(opcodes):
    output = "* " if opcodes['synth'] else "  "
    code = []
    for bytes in opcodes['opcodes']:
        hex_dump = []
        for byte in bytes:
            if re.match(r'^\d+$', str(byte)):
                hex_dump.append(f"{byte:02X}")
            elif re.match(r'@\w+', str(byte)):
                hex_dump.append(str(byte))
            else:
                if len(byte) != 2:
                    raise ValueError(f"unexpected byte {byte}")
                hex_dump.append(byte)
        code.append(" ".join(hex_dump))
    output += ",".join(code)
    return output

def write_table(f):
    global table
    
    write_row(f, "="*ASSEMBLY_SIZE, "="*CPU_SIZE, "="*OPCODES_SIZE)
    write_row(f, "Assembly", "CPU", "S Opcodes")
    write_row(f, "="*ASSEMBLY_SIZE, "="*CPU_SIZE, "="*OPCODES_SIZE)
    
    for opcode in sorted(table):
        for cpu in sorted(table[opcode]):
            write_row(f, opcode, cpu, format_opcodes(table[opcode][cpu]))

    write_row(f, "="*ASSEMBLY_SIZE, "="*CPU_SIZE, "="*OPCODES_SIZE)

if len(sys.argv) != 3:
    raise ValueError(f"Usage: make_table.py input.json output.txt")
input = sys.argv[1]
output = sys.argv[2]

with open(input, 'r') as f:
    table = json.load(f)
with open(output, 'w') as f:
    write_table(f)
