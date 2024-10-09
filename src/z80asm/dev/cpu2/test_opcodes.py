#!/usr/bin/env python3

#------------------------------------------------------------------------------
# z80asm Z80 macro assembler
#
# Copyright (C) Paulo Custodio, 2011-2024
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

# test CPU opcodes

import json
import re
import sys
import subprocess

z80asm = ''
table = {}

def format_opcodes(opcodes):
    output = ""
    code = []
    for bytes in opcodes['opcodes']:
        hex_dump = []
        for byte in bytes:
            if re.match(r'^\d+$', str(byte)):
                hex_dump.append(f"{byte:02X}")
            else:
                if len(byte) != 2:
                    raise ValueError(f"unexpected byte {byte}")
                hex_dump.append(byte)
        code.append(" ".join(hex_dump))
    output += " ".join(code)
    return output

def test_8080_strict():
    global table
    
    bin = []
    with open("test.asm", "w") as f:
        for opcode in sorted(table):
            for cpu in sorted(table[opcode]):
                if cpu == "8080_strict":
                    asm = opcode.replace("%n", "12h").replace("%m", "1234h")
                    bytes = format_opcodes(table[opcode][cpu]).replace("%n", "12").replace("%m %m", "34 12")
                    f.write(f" {asm:15s}; {bytes}\n")
                    for byte in bytes.split():
                        bin.append(int(byte, 16))
                        
    with open("test.bmk", "wb") as f:
        f.write(bytearray(bin))
        
    subprocess.run([z80asm, "-8", "-fb", "-l", "-p0", "test.asm"]).check_returncode()
        
    with open("test.bin", "rb") as f:
        bin2 = f.read()
        if bin2 != bytearray(bin):
            raise ValueError("binary output different")

if len(sys.argv) != 3:
    raise ValueError(f"Usage: test_opcodes.py input.json z80pack-z80asm")
input = sys.argv[1]
z80asm = sys.argv[2]

with open(input, 'r') as f:
    table = json.load(f)
    test_8080_strict()
