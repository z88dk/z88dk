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
cpus = []

ASSEMBLY_SIZE = 25
ALL_CPUS_SIZE = 92
CPU_SIZE = 11
OPCODES_SIZE = 51

def collect_cpus():
    global cpus
    
    cpus = []
    for opcode in sorted(table):
        for cpu in sorted(table[opcode]):
            if cpu not in cpus:
                cpus.append(cpu)
    cpus.sort()

def align(size, text):
    if len(text) > size:
        raise ValueError(f"{text} length > {size}")
    return text + " "*(size - len(text))

def write_cpus_row(f, assembly, in_cpus):
    global cpus
    
    output = "|" + align(ASSEMBLY_SIZE, assembly)
    output += "|"
    for cpu in cpus:
        if cpu in in_cpus:
            output += cpu
        else:
            output += "-" + " "*(len(cpu)-1)
        output += " "
    output = output[:-1] + "|\n"
    f.write(output)

def write_cpus_title(f, assembly, cpus):
    f.write("|" + align(ASSEMBLY_SIZE, assembly)
          + "|" + align(ALL_CPUS_SIZE, cpus)
          + "|\n")

def write_opcodes_row(f, assembly, cpu, opcodes):
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

def write_table_cpus():
    global cpus

    write_cpus_title(f, "="*ASSEMBLY_SIZE, "="*ALL_CPUS_SIZE)
    write_cpus_title(f, "Assembly", "CPUs")
    write_cpus_title(f, "="*ASSEMBLY_SIZE, "="*ALL_CPUS_SIZE)

    for opcode in sorted(table):
        write_cpus_row(f, opcode, table[opcode])
    
    write_cpus_title(f, "="*ASSEMBLY_SIZE, "="*ALL_CPUS_SIZE)
    f.write("\n")

def write_table_opcodes():
    global table
    
    write_opcodes_row(f, "="*ASSEMBLY_SIZE, "="*CPU_SIZE, "="*OPCODES_SIZE)
    write_opcodes_row(f, "Assembly", "CPU", "S Opcodes")
    write_opcodes_row(f, "="*ASSEMBLY_SIZE, "="*CPU_SIZE, "="*OPCODES_SIZE)
    
    for opcode in sorted(table):
        for cpu in sorted(table[opcode]):
            write_opcodes_row(f, opcode, cpu, format_opcodes(table[opcode][cpu]))

    write_opcodes_row(f, "="*ASSEMBLY_SIZE, "="*CPU_SIZE, "="*OPCODES_SIZE)
    f.write("\n")

def write_table(f):
    write_table_cpus()
    f.write("\n")
    write_table_opcodes()
    f.write("\n")

if len(sys.argv) != 3:
    raise ValueError(f"Usage: make_table.py input.json output.txt")
input = sys.argv[1]
output = sys.argv[2]

with open(input, 'r') as f:
    table = json.load(f)
    collect_cpus()
with open(output, 'w') as f:
    write_table(f)
