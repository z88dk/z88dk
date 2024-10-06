#!/usr/bin/env python3

# build data structure of all opcodes the assembler will parse

import json
import re

opcodes = {}

def add(cpu, instr, ops):
    global opcodes
    if instr in opcodes and cpu in opcodes[instr]:
        raise ValueError(f"duplicate instruction {cpu}: {instr}")
    if not instr in opcodes:
        opcodes[instr] = {}
    opcodes[instr][cpu] = ops

def build_8080(cpu):
    reg8 = {'b':0, 'c':1, 'd':2, 'e':3, 'h':4, 'l':5, 'a':7}
    reg8m = {'b':0, 'c':1, 'd':2, 'e':3, 'h':4, 'l':5, 'm':6, 'a':7}
    reg16bdhsp = {'b':0, 'd':1, 'h':2, 'sp':3}
    reg16bd = {'b':0, 'd':1}
    reg16bdhpsw = {'b':0, 'd':1, 'h':2, 'psw':3}
    flags={'nz':0, 'z':1, 'nc':2, 'c':3, 'po':4, 'pe':5, 'p':6, 'm':7}
    
    # move, load and store
    for dname, di in reg8.items():
        for sname, si in reg8.items():
            add(cpu, f"mov {dname}, {sname}", [[0x40+di*8+si]])

    for rname, ri in reg8.items():
        add(cpu, f"mov m, {rname}", [[0x70+ri]])
        add(cpu, f"mov {rname}, m", [[0x46+8*ri]])
        add(cpu, f"mvi {rname}", [[0x06+8*ri]])

    add(cpu, f"mvi m", [[0x36]])

    for rname, ri in reg16bdhsp.items():
        add(cpu, f"lxi {rname}, %m", [[0x01+16*ri, '%m', '%m']])

    for rname, ri in reg16bd.items():
        add(cpu, f"stax {rname}", [[0x02+16*ri]])
        add(cpu, f"ldax {rname}", [[0x0a+16*ri]])

    add(cpu, f"sta %m", [[0x32, '%m', '%m']])
    add(cpu, f"lda %m", [[0x3a, '%m', '%m']])
    add(cpu, f"shld %m", [[0x22, '%m', '%m']])
    add(cpu, f"lhld %m", [[0x2a, '%m', '%m']])
    add(cpu, f"xchg", [[0xeb]])

    # stack ops
    for rname, ri in reg16bdhpsw.items():
        add(cpu, f"push {rname}", [[0xe5+16*ri]])
        add(cpu, f"pop {rname}", [[0xe1+16*ri]])
        
    add(cpu, f"xthl", [[0xe3]])
    add(cpu, f"sphl", [[0xf9]])
    
    # jump
    add(cpu, f"jmp %m", [[0x3c, '%m', '%m']])
    for fname, fi in flags.items():
        add(cpu, f"j{fname} %m", [[0xc2+8*fi, '%m', '%m']])
    add(cpu, f"pchl", [[0xe9]])
    
    # call
    add(cpu, f"call %m", [[0xcd, '%m', '%m']])
    for fname, fi in flags.items():
        add(cpu, f"c{fname} %m", [[0xc4+8*fi, '%m', '%m']])
    
    # return
    add(cpu, f"ret", [[0xc9]])
    for fname, fi in flags.items():
        add(cpu, f"r{fname}", [[0xc0+8*fi]])
    
    # restart
    add(cpu, f"rst %c", [[str(0xe7)+'+%c']])
    
    # increment and decrement
    for rname, ri in reg8m.items():
        add(cpu, f"inr {rname}", [[0x04+8*ri]])
        add(cpu, f"dcr {rname}", [[0x05+8*ri]])

    for rname, ri in reg16bdhsp.items():
        add(cpu, f"inx {rname}", [[0x03+16*ri]])
        add(cpu, f"dcx {rname}", [[0x0b+16*ri]])
    
    # add
    for rname, ri in reg8m.items():
        add(cpu, f"add {rname}", [[0x80+ri]])
        add(cpu, f"adc {rname}", [[0x81+ri]])

    add(cpu, f"adi %n", [[0xc6, '%n']])
    add(cpu, f"aci %n", [[0xce, '%n']])

    for rname, ri in reg16bdhsp.items():
        add(cpu, f"dad {rname}", [[0x09+16*ri]])

    # subtract
    for rname, ri in reg8m.items():
        add(cpu, f"sub {rname}", [[0x90+ri]])
        add(cpu, f"sbb {rname}", [[0x91+ri]])

    add(cpu, f"sui %n", [[0xd6, '%n']])
    add(cpu, f"sbi %n", [[0xde, '%n']])

    # logical
    for rname, ri in reg8m.items():
        add(cpu, f"ana {rname}", [[0xa0+ri]])
        add(cpu, f"xra {rname}", [[0xa8+ri]])
        add(cpu, f"ora {rname}", [[0xb0+ri]])
        add(cpu, f"cmp {rname}", [[0xb8+ri]])
    
    add(cpu, f"ani %n", [[0xe6, '%n']])
    add(cpu, f"xri %n", [[0xee, '%n']])
    add(cpu, f"ori %n", [[0xf6, '%n']])
    add(cpu, f"cpi %n", [[0xfe, '%n']])

    # rotate
    add(cpu, f"rlc", [[0x07]])
    add(cpu, f"rrc", [[0x0f]])
    add(cpu, f"ral", [[0x17]])
    add(cpu, f"rar", [[0x1f]])
    
    # specials
    add(cpu, f"daa", [[0x27]])
    add(cpu, f"cma", [[0x2f]])
    add(cpu, f"stc", [[0x37]])
    add(cpu, f"cmc", [[0x3f]])
    
    # input/output
    add(cpu, f"in %n", [[0xdb, '%n']])
    add(cpu, f"out %n", [[0xd3, '%n']])
    
    # control
    add(cpu, f"ei", [[0xfb]])
    add(cpu, f"di", [[0xf3]])
    add(cpu, f"nop", [[0x00]])
    add(cpu, f"hlt", [[0x76]])


build_8080("8080")

f = open("opcodes.json", "w")
f.write(json.dumps(opcodes, indent=4, sort_keys=True))
