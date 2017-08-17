/* Copyright (C) 2014-2016 Ben Kurtovic <ben.kurtovic@gmail.com>
   Released under the terms of the MIT License. See LICENSE for details. */

#include "mnemonics.h"

static char* const instr_mnemonics[256] = {
    /* 00 */ "nop",  "ld",   "ld",   "inc",  "inc",  "dec",  "ld",   "rlca",
    /* 08 */ "ex",   "add",  "ld",   "dec",  "inc",  "dec",  "ld",   "rrca",
    /* 10 */ "djnz", "ld",   "ld",   "inc",  "inc",  "dec",  "ld",   "rla",
    /* 18 */ "jr",   "add",  "ld",   "dec",  "inc",  "dec",  "ld",   "rra",
    /* 20 */ "jr",   "ld",   "ld",   "inc",  "inc",  "dec",  "ld",   "daa",
    /* 28 */ "jr",   "add",  "ld",   "dec",  "inc",  "dec",  "ld",   "cpl",
    /* 30 */ "jr",   "ld",   "ld",   "inc",  "inc",  "dec",  "ld",   "scf",
    /* 38 */ "jr",   "add",  "ld",   "dec",  "inc",  "dec",  "ld",   "ccf",
    /* 40 */ "ld",   "ld",   "ld",   "ld",   "ld",   "ld",   "ld",   "ld",
    /* 48 */ "ld",   "ld",   "ld",   "ld",   "ld",   "ld",   "ld",   "ld",
    /* 50 */ "ld",   "ld",   "ld",   "ld",   "ld",   "ld",   "ld",   "ld",
    /* 58 */ "ld",   "ld",   "ld",   "ld",   "ld",   "ld",   "ld",   "ld",
    /* 60 */ "ld",   "ld",   "ld",   "ld",   "ld",   "ld",   "ld",   "ld",
    /* 68 */ "ld",   "ld",   "ld",   "ld",   "ld",   "ld",   "ld",   "ld",
    /* 70 */ "ld",   "ld",   "ld",   "ld",   "ld",   "ld",   "halt", "ld",
    /* 78 */ "ld",   "ld",   "ld",   "ld",   "ld",   "ld",   "ld",   "ld",
    /* 80 */ "add",  "add",  "add",  "add",  "add",  "add",  "add",  "add",
    /* 88 */ "adc",  "adc",  "adc",  "adc",  "adc",  "adc",  "adc",  "adc",
    /* 90 */ "sub",  "sub",  "sub",  "sub",  "sub",  "sub",  "sub",  "sub",
    /* 98 */ "sbc",  "sbc",  "sbc",  "sbc",  "sbc",  "sbc",  "sbc",  "sbc",
    /* A0 */ "and",  "and",  "and",  "and",  "and",  "and",  "and",  "and",
    /* A8 */ "xor",  "xor",  "xor",  "xor",  "xor",  "xor",  "xor",  "xor",
    /* B0 */ "or",   "or",   "or",   "or",   "or",   "or",   "or",   "or",
    /* B8 */ "cp",   "cp",   "cp",   "cp",   "cp",   "cp",   "cp",   "cp",
    /* C0 */ "ret",  "pop",  "jp",   "jp",   "call", "push", "add",  "rst",
    /* C8 */ "ret",  "ret",  "jp",   "",     "call", "call", "adc",  "rst",
    /* D0 */ "ret",  "pop",  "jp",   "out",  "call", "push", "sub",  "rst",
    /* D8 */ "ret",  "exx",  "jp",   "in",   "call", "",     "sbc",  "rst",
    /* E0 */ "ret",  "pop",  "jp",   "ex",   "call", "push", "and",  "rst",
    /* E8 */ "ret",  "jp",   "jp",   "ex",   "call", "",     "xor",  "rst",
    /* F0 */ "ret",  "pop",  "jp",   "di",   "call", "push", "or",   "rst",
    /* F8 */ "ret",  "ld",   "jp",   "ei",   "call", "",     "cp",   "rst"
};

static char* const instr_mnemonics_extended[256] = {
    /* 00 */ "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* 08 */ "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* 10 */ "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* 18 */ "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* 20 */ "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* 28 */ "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* 30 */ "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* 38 */ "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* 40 */ "in",   "out",  "sbc",  "ld",   "neg",  "retn", "im",   "ld",
    /* 48 */ "in",   "out",  "adc",  "ld",   "neg",  "reti", "im",   "ld",
    /* 50 */ "in",   "out",  "sbc",  "ld",   "neg",  "retn", "im",   "ld",
    /* 58 */ "in",   "out",  "adc",  "ld",   "neg",  "retn", "im",   "ld",
    /* 60 */ "in",   "out",  "sbc",  "ld",   "neg",  "retn", "im",   "rrd",
    /* 68 */ "in",   "out",  "adc",  "ld",   "neg",  "retn", "im",   "rld",
    /* 70 */ "in",   "out",  "sbc",  "ld",   "neg",  "retn", "im",   "nop",
    /* 78 */ "in",   "out",  "adc",  "ld",   "neg",  "retn", "im",   "nop",
    /* 80 */ "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* 88 */ "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* 90 */ "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* 98 */ "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* A0 */ "ldi",  "cpi",  "ini",  "outi", "nop",  "nop",  "nop",  "nop",
    /* A8 */ "ldd",  "cpd",  "ind",  "outd", "nop",  "nop",  "nop",  "nop",
    /* B0 */ "ldir", "cpir", "inir", "otir", "nop",  "nop",  "nop",  "nop",
    /* B8 */ "lddr", "cpdr", "indr", "otdr", "nop",  "nop",  "nop",  "nop",
    /* C0 */ "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* C8 */ "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* D0 */ "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* D8 */ "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* E0 */ "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* E8 */ "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* F0 */ "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* F8 */ "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop"
};

static char* const instr_mnemonics_bits[256] = {
    /* 00 */ "rlc",  "rlc",  "rlc",  "rlc",  "rlc",  "rlc",  "rlc",  "rlc",
    /* 08 */ "rrc",  "rrc",  "rrc",  "rrc",  "rrc",  "rrc",  "rrc",  "rrc",
    /* 10 */ "rl",   "rl",   "rl",   "rl",   "rl",   "rl",   "rl",   "rl",
    /* 18 */ "rr",   "rr",   "rr",   "rr",   "rr",   "rr",   "rr",   "rr",
    /* 20 */ "sla",  "sla",  "sla",  "sla",  "sla",  "sla",  "sla",  "sla",
    /* 28 */ "sra",  "sra",  "sra",  "sra",  "sra",  "sra",  "sra",  "sra",
    /* 30 */ "sl1",  "sl1",  "sl1",  "sl1",  "sl1",  "sl1",  "sl1",  "sl1",
    /* 38 */ "srl",  "srl",  "srl",  "srl",  "srl",  "srl",  "srl",  "srl",
    /* 40 */ "bit",  "bit",  "bit",  "bit",  "bit",  "bit",  "bit",  "bit",
    /* 48 */ "bit",  "bit",  "bit",  "bit",  "bit",  "bit",  "bit",  "bit",
    /* 50 */ "bit",  "bit",  "bit",  "bit",  "bit",  "bit",  "bit",  "bit",
    /* 58 */ "bit",  "bit",  "bit",  "bit",  "bit",  "bit",  "bit",  "bit",
    /* 60 */ "bit",  "bit",  "bit",  "bit",  "bit",  "bit",  "bit",  "bit",
    /* 68 */ "bit",  "bit",  "bit",  "bit",  "bit",  "bit",  "bit",  "bit",
    /* 70 */ "bit",  "bit",  "bit",  "bit",  "bit",  "bit",  "bit",  "bit",
    /* 78 */ "bit",  "bit",  "bit",  "bit",  "bit",  "bit",  "bit",  "bit",
    /* 80 */ "res",  "res",  "res",  "res",  "res",  "res",  "res",  "res",
    /* 88 */ "res",  "res",  "res",  "res",  "res",  "res",  "res",  "res",
    /* 90 */ "res",  "res",  "res",  "res",  "res",  "res",  "res",  "res",
    /* 98 */ "res",  "res",  "res",  "res",  "res",  "res",  "res",  "res",
    /* A0 */ "res",  "res",  "res",  "res",  "res",  "res",  "res",  "res",
    /* A8 */ "res",  "res",  "res",  "res",  "res",  "res",  "res",  "res",
    /* B0 */ "res",  "res",  "res",  "res",  "res",  "res",  "res",  "res",
    /* B8 */ "res",  "res",  "res",  "res",  "res",  "res",  "res",  "res",
    /* C0 */ "set",  "set",  "set",  "set",  "set",  "set",  "set",  "set",
    /* C8 */ "set",  "set",  "set",  "set",  "set",  "set",  "set",  "set",
    /* D0 */ "set",  "set",  "set",  "set",  "set",  "set",  "set",  "set",
    /* D8 */ "set",  "set",  "set",  "set",  "set",  "set",  "set",  "set",
    /* E0 */ "set",  "set",  "set",  "set",  "set",  "set",  "set",  "set",
    /* E8 */ "set",  "set",  "set",  "set",  "set",  "set",  "set",  "set",
    /* F0 */ "set",  "set",  "set",  "set",  "set",  "set",  "set",  "set",
    /* F8 */ "set",  "set",  "set",  "set",  "set",  "set",  "set",  "set"
};

static char* const instr_mnemonics_index[256] = {
    /* 00 */ "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* 08 */ "nop",  "add",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* 10 */ "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* 18 */ "nop",  "add",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* 20 */ "nop",  "ld",   "ld",   "inc",  "inc",  "dec",  "ld",   "nop",
    /* 28 */ "nop",  "add",  "ld",   "dec",  "inc",  "dec",  "ld",   "nop",
    /* 30 */ "nop",  "nop",  "nop",  "nop",  "inc",  "dec",  "ld",   "nop",
    /* 38 */ "nop",  "add",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* 40 */ "nop",  "nop",  "nop",  "nop",  "ld",   "ld",   "ld",   "nop",
    /* 48 */ "nop",  "nop",  "nop",  "nop",  "ld",   "ld",   "ld",   "nop",
    /* 50 */ "nop",  "nop",  "nop",  "nop",  "ld",   "ld",   "ld",   "nop",
    /* 58 */ "nop",  "nop",  "nop",  "nop",  "ld",   "ld",   "ld",   "nop",
    /* 60 */ "ld",   "ld",   "ld",   "ld",   "ld",   "ld",   "ld",   "ld",
    /* 68 */ "ld",   "ld",   "ld",   "ld",   "ld",   "ld",   "ld",   "ld",
    /* 70 */ "ld",   "ld",   "ld",   "ld",   "ld",   "ld",   "nop",  "ld",
    /* 78 */ "nop",  "nop",  "nop",  "nop",  "ld",   "ld",   "ld",   "nop",
    /* 80 */ "nop",  "nop",  "nop",  "nop",  "add",  "add",  "add",  "nop",
    /* 88 */ "nop",  "nop",  "nop",  "nop",  "adc",  "adc",  "adc",  "nop",
    /* 90 */ "nop",  "nop",  "nop",  "nop",  "sub",  "sub",  "sub",  "nop",
    /* 98 */ "nop",  "nop",  "nop",  "nop",  "sbc",  "sbc",  "sbc",  "nop",
    /* A0 */ "nop",  "nop",  "nop",  "nop",  "and",  "and",  "and",  "nop",
    /* A8 */ "nop",  "nop",  "nop",  "nop",  "xor",  "xor",  "xor",  "nop",
    /* B0 */ "nop",  "nop",  "nop",  "nop",  "or",   "or",   "or",   "nop",
    /* B8 */ "nop",  "nop",  "nop",  "nop",  "cp",   "cp",   "cp",   "nop",
    /* C0 */ "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* C8 */ "nop",  "nop",  "nop",  "",     "nop",  "nop",  "nop",  "nop",
    /* D0 */ "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* D8 */ "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* E0 */ "nop",  "pop",  "nop",  "ex",   "nop",  "push", "nop",  "nop",
    /* E8 */ "nop",  "jp",   "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* F0 */ "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",  "nop",
    /* F8 */ "nop",  "ld",   "nop",  "nop",  "nop",  "nop",  "nop",  "nop"
};

/*
    Extract the assembly mnemonic for the given opcode.

    The return value is a string literal and should not be freed.
*/
char* decode_mnemonic(const uint8_t *bytes)
{
    uint8_t b = bytes[0];

    if (b == 0xED)
        return instr_mnemonics_extended[bytes[1]];
    if (b == 0xCB)
        return instr_mnemonics_bits[bytes[1]];
    if (b == 0xDD || b == 0xFD) {
        if (bytes[1] == 0xCB)
            return instr_mnemonics_bits[bytes[3]];
        return instr_mnemonics_index[bytes[1]];
    }
    return instr_mnemonics[b];
}
