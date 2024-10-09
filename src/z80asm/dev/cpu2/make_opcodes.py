#!/usr/bin/env python3

#------------------------------------------------------------------------------
# z80asm Z80 macro assembler
#
# Copyright (C) Paulo Custodio, 2011-2024
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

# Build data structure of all opcodes the assembler will parse

import json
import re
import sys

table = {}

def add1(cpu, instr, opcodes, synth):
    global table
    
    if instr in table and cpu in table[instr]:
        raise ValueError(f"duplicate instruction {cpu}: {instr}")
    if not instr in table:
        table[instr] = {}
    table[instr][cpu] = {'synth':synth, 'opcodes':opcodes}

def add(cpu, instr, opcode):
    add1(cpu, instr, [opcode], False)

def add_synth(cpu, instr, sub_instrs):
    opcodes = []
    for sub_instr in sub_instrs:
        info = table[sub_instr][cpu]
        for sub_opcodes in info['opcodes']:
            opcodes.append(sub_opcodes)
    add1(cpu, instr, opcodes, True)

def build_8080_strict(cpu, **kwargs):
    reg8 = {'b':0, 'c':1, 'd':2, 'e':3, 'h':4, 'l':5, 'a':7}
    reg8m = {'b':0, 'c':1, 'd':2, 'e':3, 'h':4, 'l':5, 'm':6, 'a':7}
    reg16bdhsp = {'b':0, 'd':1, 'h':2, 'sp':3}
    reg16bd = {'b':0, 'd':1}
    reg16bdhpsw = {'b':0, 'd':1, 'h':2, 'psw':3}
    if 'zilog' in kwargs:   # cp=compare, jp=jump
        flags={'nz':0, 'z':1, 'nc':2, 'c':3, 'po':4, 'pe':5, 'm':7}
    else:                   # cp=call p, jp=jmp p
        flags={'nz':0, 'z':1, 'nc':2, 'c':3, 'po':4, 'pe':5, 'p':6, 'm':7}
    
    # move, load and store
    for dname, di in reg8.items():
        for sname, si in reg8.items():
            add(cpu, f"mov {dname}, {sname}", [0x40+di*8+si])

    for rname, ri in reg8.items():
        add(cpu, f"mov m, {rname}", [0x70+ri])
        add(cpu, f"mov {rname}, m", [0x46+8*ri])
        
    for rname, ri in reg8m.items():
        add(cpu, f"mvi {rname}, %n", [0x06+8*ri, '%n'])

    for rname, ri in reg16bdhsp.items():
        add(cpu, f"lxi {rname}, %m", [0x01+16*ri, '%m', '%m'])

    for rname, ri in reg16bd.items():
        add(cpu, f"stax {rname}", [0x02+16*ri])
        add(cpu, f"ldax {rname}", [0x0a+16*ri])

    add(cpu, f"sta %m", [0x32, '%m', '%m'])
    add(cpu, f"lda %m", [0x3a, '%m', '%m'])
    add(cpu, f"shld %m", [0x22, '%m', '%m'])
    add(cpu, f"lhld %m", [0x2a, '%m', '%m'])
    add(cpu, f"xchg", [0xeb])

    # stack ops
    for rname, ri in reg16bdhpsw.items():
        add(cpu, f"push {rname}", [0xc5+16*ri])
        add(cpu, f"pop {rname}", [0xc1+16*ri])
        
    add(cpu, f"xthl", [0xe3])
    add(cpu, f"sphl", [0xf9])
    
    # jump
    add(cpu, f"jmp %m", [0xc3, '%m', '%m'])
    for fname, fi in flags.items():
        add(cpu, f"j{fname} %m", [0xc2+8*fi, '%m', '%m'])
    add(cpu, f"pchl", [0xe9])
    
    # call
    add(cpu, f"call %m", [0xcd, '%m', '%m'])
    for fname, fi in flags.items():
        add(cpu, f"c{fname} %m", [0xc4+8*fi, '%m', '%m'])
    
    # return
    add(cpu, f"ret", [0xc9])
    for fname, fi in flags.items():
        add(cpu, f"r{fname}", [0xc0+8*fi])
    
    # restart
    for n in range(8):
        add(cpu, f"rst {n}", [0xc7+8*n])
    
    # increment and decrement
    for rname, ri in reg8m.items():
        add(cpu, f"inr {rname}", [0x04+8*ri])
        add(cpu, f"dcr {rname}", [0x05+8*ri])

    for rname, ri in reg16bdhsp.items():
        add(cpu, f"inx {rname}", [0x03+16*ri])
        add(cpu, f"dcx {rname}", [0x0b+16*ri])
    
    # add
    for rname, ri in reg8m.items():
        add(cpu, f"add {rname}", [0x80+ri])
        add(cpu, f"adc {rname}", [0x88+ri])

    add(cpu, f"adi %n", [0xc6, '%n'])
    add(cpu, f"aci %n", [0xce, '%n'])

    for rname, ri in reg16bdhsp.items():
        add(cpu, f"dad {rname}", [0x09+16*ri])

    # subtract
    for rname, ri in reg8m.items():
        add(cpu, f"sub {rname}", [0x90+ri])
        add(cpu, f"sbb {rname}", [0x98+ri])

    add(cpu, f"sui %n", [0xd6, '%n'])
    add(cpu, f"sbi %n", [0xde, '%n'])

    # logical
    for rname, ri in reg8m.items():
        add(cpu, f"ana {rname}", [0xa0+ri])
        add(cpu, f"xra {rname}", [0xa8+ri])
        add(cpu, f"ora {rname}", [0xb0+ri])
        add(cpu, f"cmp {rname}", [0xb8+ri])
    
    add(cpu, f"ani %n", [0xe6, '%n'])
    add(cpu, f"xri %n", [0xee, '%n'])
    add(cpu, f"ori %n", [0xf6, '%n'])
    add(cpu, f"cpi %n", [0xfe, '%n'])

    # rotate
    add(cpu, f"rlc", [0x07])
    add(cpu, f"rrc", [0x0f])
    add(cpu, f"ral", [0x17])
    add(cpu, f"rar", [0x1f])
    
    # specials
    add(cpu, f"daa", [0x27])
    add(cpu, f"cma", [0x2f])
    add(cpu, f"stc", [0x37])
    add(cpu, f"cmc", [0x3f])
    
    # input/output
    add(cpu, f"in %n", [0xdb, '%n'])
    add(cpu, f"out %n", [0xd3, '%n'])
    
    # control
    add(cpu, f"ei", [0xfb])
    add(cpu, f"di", [0xf3])
    add(cpu, f"nop", [0x00])
    add(cpu, f"hlt", [0x76])

def build_8080_zilog(cpu, **kwargs):
    reg8 = {'b':0, 'c':1, 'd':2, 'e':3, 'h':4, 'l':5, 'a':7}
    reg8m = {'b':0, 'c':1, 'd':2, 'e':3, 'h':4, 'l':5, '(hl)':6, 'a':7}
    reg16bdhsp = {'bc':0, 'de':1, 'hl':2, 'sp':3}
    reg16bd = {'bc':0, 'de':1}
    reg16bdhpsw = {'bc':0, 'de':1, 'hl':2, 'af':3}
    flags={'nz':0, 'z':1, 'nc':2, 'c':3, 'po':4, 'pe':5, 'p':6, 'm':7}
    
    # move, load and store
    for dname, di in reg8.items():
        for sname, si in reg8.items():
            add(cpu, f"ld {dname}, {sname}", [0x40+di*8+si])

    for rname, ri in reg8.items():
        add(cpu, f"ld (hl), {rname}", [0x70+ri])
        add(cpu, f"ld {rname}, (hl)", [0x46+8*ri])
        
    for rname, ri in reg8m.items():
        add(cpu, f"ld {rname}, %n", [0x06+8*ri, '%n'])

    for rname, ri in reg16bdhsp.items():
        add(cpu, f"ld {rname}, %m", [0x01+16*ri, '%m', '%m'])

    for rname, ri in reg16bd.items():
        add(cpu, f"ld ({rname}), a", [0x02+16*ri])
        add(cpu, f"ld a, ({rname})", [0x0a+16*ri])

    add(cpu, f"ld (%m), a", [0x32, '%m', '%m'])
    add(cpu, f"ld a, (%m)", [0x3a, '%m', '%m'])
    add(cpu, f"ld (%m), hl", [0x22, '%m', '%m'])
    add(cpu, f"ld hl, (%m)", [0x2a, '%m', '%m'])
    add(cpu, f"ex de, hl", [0xeb])

    # stack ops
    for rname, ri in reg16bdhpsw.items():
        add(cpu, f"push {rname}", [0xc5+16*ri])
        add(cpu, f"pop {rname}", [0xc1+16*ri])
        
    add(cpu, f"ex (sp), hl", [0xe3])
    add(cpu, f"ld sp, hl", [0xf9])
    
    # jump
    add(cpu, f"jp %m", [0xc3, '%m', '%m'])
    for fname, fi in flags.items():
        add(cpu, f"jp {fname}, %m", [0xc2+8*fi, '%m', '%m'])
    add(cpu, f"jp (hl)", [0xe9])
    
    # call
    for fname, fi in flags.items():
        add(cpu, f"call {fname}, %m", [0xc4+8*fi, '%m', '%m'])
    
    # return
    for fname, fi in flags.items():
        add(cpu, f"ret {fname}", [0xc0+8*fi])
    
    # increment and decrement
    for rname, ri in reg8m.items():
        add(cpu, f"inc {rname}", [0x04+8*ri])
        add(cpu, f"dec {rname}", [0x05+8*ri])

    for rname, ri in reg16bdhsp.items():
        add(cpu, f"inc {rname}", [0x03+16*ri])
        add(cpu, f"dec {rname}", [0x0b+16*ri])
    
    # add
    for rname, ri in reg8m.items():
        add(cpu, f"add a, {rname}", [0x80+ri])
        add(cpu, f"adc a, {rname}", [0x88+ri])

    add(cpu, f"add a, %n", [0xc6, '%n'])
    add(cpu, f"adc a, %n", [0xce, '%n'])

    for rname, ri in reg16bdhsp.items():
        add(cpu, f"add hl, {rname}", [0x09+16*ri])

    # subtract
    for rname, ri in reg8m.items():
        add(cpu, f"sbc a, {rname}", [0x98+ri])

    add(cpu, f"sub %n", [0xd6, '%n'])
    add(cpu, f"sbc a, %n", [0xde, '%n'])

    # logical
    for rname, ri in reg8m.items():
        add(cpu, f"and {rname}", [0xa0+ri])
        add(cpu, f"xor {rname}", [0xa8+ri])
        add(cpu, f"or {rname}", [0xb0+ri])
        add(cpu, f"cp {rname}", [0xb8+ri])
    
    add(cpu, f"and %n", [0xe6, '%n'])
    add(cpu, f"xor %n", [0xee, '%n'])
    add(cpu, f"or %n", [0xf6, '%n'])
    add(cpu, f"cp %n", [0xfe, '%n'])

    # rotate
    add(cpu, f"rlca", [0x07])
    add(cpu, f"rrca", [0x0f])
    add(cpu, f"rla", [0x17])
    add(cpu, f"rra", [0x1f])
    
    # specials
    add(cpu, f"cpl", [0x2f])
    add(cpu, f"scf", [0x37])
    add(cpu, f"ccf", [0x3f])
    
    # input/output
    add(cpu, f"in a, (%n)", [0xdb, '%n'])
    add(cpu, f"out (%n), a", [0xd3, '%n'])
    
    # control
    add(cpu, f"halt", [0x76])

def build_8085_strict(cpu, **kwargs):
    build_8080_strict(cpu, **kwargs)
    
    add(cpu, f"rim", [0x20])
    add(cpu, f"sim", [0x30])

def build_8080(cpu):
    build_8080_strict(cpu, zilog=True)
    build_8080_zilog(cpu)
    
    # synthetic opcodes
    
    # restart
    for addr in range(8, 0x40, 8):
        i = addr // 8
        add_synth(cpu, f"rst {addr:02x}h", [f"rst {i}"])
    
    # register pair names
    for rp in ['bc', 'de', 'hl']:
        add_synth(cpu, f"lxi {rp}, %m", ["lxi "+rp[0]+", %m"])
        for op in ['inx', 'dcx', 'dad']:
            add_synth(cpu, f"{op} {rp}", [op+" "+rp[0]])
            
    for rp in ['bc', 'de']:
        for op in ['stax', 'ldax']:
            add_synth(cpu, f"{op} {rp}", [op+" "+rp[0]])

    # 16-bit mov
    for src in ['bc', 'de', 'hl']:
        for dst in ['bc', 'de', 'hl']:
            if src != dst:
                add_synth(cpu, f"mov {dst}, {src}", 
                               ["mov "+dst[0]+", "+src[0],
                                "mov "+dst[1]+", "+src[1]])
                add_synth(cpu, f"ld {dst}, {src}", 
                               ["ld "+dst[0]+", "+src[0],
                                "ld "+dst[1]+", "+src[1]])

if len(sys.argv) != 2:
    raise ValueError(f"Usage: make_opcodes.py output.json")
output = sys.argv[1]

build_8080_strict("8080_strict")
build_8085_strict("8085_strict")
build_8080("8080")

with open(output, 'w') as f:
    f.write(json.dumps(table, indent=4, sort_keys=True))
