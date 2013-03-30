#!/usr/bin/perl

#     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
#   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
#                ZZZZZ      888           888  0000         0000
#              ZZZZZ        88888888888888888  0000         0000
#            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
#          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
#        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
#      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
#    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
#  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM
#
# Copyright (C) Paulo Custodio, 2011-2013

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-strpool.t,v 1.6 2013-03-30 00:00:26 pauloscustodio Exp $
# $Log: whitebox-strpool.t,v $
# Revision 1.6  2013-03-30 00:00:26  pauloscustodio
# Accept special case NULL in strpool_add, return NULL
#
# Revision 1.5  2013/01/20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.4  2013/01/19 01:33:16  pauloscustodio
# Clean-up strpool code
#
# Revision 1.3  2012/06/14 15:01:27  pauloscustodio
# Split safe strings from strutil.c to safestr.c
#
# Revision 1.2  2012/05/26 18:50:26  pauloscustodio
# Use .o instead of .c to build test program, faster compilation.
# Use gcc to compile instead of cc.
#
# Revision 1.1  2012/05/24 17:50:02  pauloscustodio
# CH_0010 : new string pool to hold strings for all program duration
#
# Revision 1.1  2012/05/24 17:16:28  pauloscustodio
# CH_0009 : new CLASS to define simple classes
#
#
# Test strpool

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

# test strpool
my $objs = "strpool.o die.o strutil.o safestr.o except.o";
ok ! system "make $objs";
my $compile = "-DCLASS_DEBUG -DMEMALLOC_DEBUG class.c memalloc.c $objs";

t_compile_module(<<'END_INIT', <<'END', $compile);
#define ERROR return __LINE__

struct strings {
	char 	*source, *pool;
}
strings[] = {
	{ "A",		NULL },
	{ "ADC",	NULL },
	{ "ADD",	NULL },
	{ "AF",		NULL },
	{ "AND",	NULL },
	{ "B",		NULL },
	{ "BC",		NULL },
	{ "BIT",	NULL },
	{ "C",		NULL },
	{ "CALL",	NULL },
	{ "CCF",	NULL },
	{ "CP",		NULL },
	{ "CPDR",	NULL },
	{ "CPL",	NULL },
	{ "D",		NULL },
	{ "DAA",	NULL },
	{ "DE",		NULL },
	{ "DEC",	NULL },
	{ "DEFB",	NULL },
	{ "DEFM",	NULL },
	{ "DEFW",	NULL },
	{ "DI",		NULL },
	{ "DJNZ",	NULL },
	{ "E",		NULL },
	{ "EI",		NULL },
	{ "EX",		NULL },
	{ "EXX",	NULL },
	{ "H",		NULL },
	{ "HALT",	NULL },
	{ "HL",		NULL },
	{ "I",		NULL },
	{ "IM",		NULL },
	{ "IN",		NULL },
	{ "INC",	NULL },
	{ "IX",		NULL },
	{ "IY",		NULL },
	{ "JP",		NULL },
	{ "JR",		NULL },
	{ "L",		NULL },
	{ "LD",		NULL },
	{ "LDDR",	NULL },
	{ "LDIR",	NULL },
	{ "M",		NULL },
	{ "NC",		NULL },
	{ "NEG",	NULL },
	{ "NOP",	NULL },
	{ "NZ",		NULL },
	{ "OR",		NULL },
	{ "ORG",	NULL },
	{ "OUT",	NULL },
	{ "P",		NULL },
	{ "PO",		NULL },
	{ "POP",	NULL },
	{ "PUSH",	NULL },
	{ "RES",	NULL },
	{ "RET",	NULL },
	{ "RETN",	NULL },
	{ "RL",		NULL },
	{ "RLA",	NULL },
	{ "RLC",	NULL },
	{ "RLCA",	NULL },
	{ "RLD",	NULL },
	{ "RR",		NULL },
	{ "RRA",	NULL },
	{ "RRC",	NULL },
	{ "RRCA",	NULL },
	{ "RST",	NULL },
	{ "SBC",	NULL },
	{ "SCF",	NULL },
	{ "SET",	NULL },
	{ "SLA",	NULL },
	{ "SP",		NULL },
	{ "SRA",	NULL },
	{ "SRL",	NULL },
	{ "SUB",	NULL },
	{ "XOR",	NULL },
	{ "Z",		NULL },
	{ "L0000",	NULL },
	{ "L0008",	NULL },
	{ "L0010",	NULL },
	{ "L0018",	NULL },
	{ "L001C",	NULL },
	{ "L0020",	NULL },
	{ "L0028",	NULL },
	{ "L0030",	NULL },
	{ "L0038",	NULL },
	{ "L0048",	NULL },
	{ "L0053",	NULL },
	{ "L0055",	NULL },
	{ "L0066",	NULL },
	{ "L0070",	NULL },
	{ "L0074",	NULL },
	{ "L0077",	NULL },
	{ "L0078",	NULL },
	{ "L007D",	NULL },
	{ "L0090",	NULL },
	{ "L0095",	NULL },
	{ "L0205",	NULL },
	{ "L022C",	NULL },
	{ "L0246",	NULL },
	{ "L0260",	NULL },
	{ "L026A",	NULL },
	{ "L0284",	NULL },
	{ "L028E",	NULL },
	{ "L0296",	NULL },
	{ "L029F",	NULL },
	{ "L02A1",	NULL },
	{ "L02AB",	NULL },
	{ "L02BF",	NULL },
	{ "L02C6",	NULL },
	{ "L02D1",	NULL },
	{ "L02F1",	NULL },
	{ "L0308",	NULL },
	{ "L0310",	NULL },
	{ "L031E",	NULL },
	{ "L032C",	NULL },
	{ "L0333",	NULL },
	{ "L0341",	NULL },
	{ "L034A",	NULL },
	{ "L034F",	NULL },
	{ "L0364",	NULL },
	{ "L0367",	NULL },
	{ "L0382",	NULL },
	{ "L0389",	NULL },
	{ "L039D",	NULL },
	{ "L03B2",	NULL },
	{ "L03B5",	NULL },
	{ "L03D1",	NULL },
	{ "L03D2",	NULL },
	{ "L03D3",	NULL },
	{ "L03D4",	NULL },
	{ "L03D6",	NULL },
	{ "L03F2",	NULL },
	{ "L03F6",	NULL },
	{ "L03F8",	NULL },
	{ "L0425",	NULL },
	{ "L0427",	NULL },
	{ "L046C",	NULL },
	{ "L046E",	NULL },
	{ "L04AA",	NULL },
	{ "L04C2",	NULL },
	{ "L04D0",	NULL },
	{ "L04D8",	NULL },
	{ "L04EA",	NULL },
	{ "L04F2",	NULL },
	{ "L04FE",	NULL },
	{ "L0505",	NULL },
	{ "L0507",	NULL },
	{ "L050E",	NULL },
	{ "L0511",	NULL },
	{ "L0514",	NULL },
	{ "L051A",	NULL },
	{ "L051C",	NULL },
	{ "L0525",	NULL },
	{ "L053C",	NULL },
	{ "L053F",	NULL },
	{ "L0552",	NULL },
	{ "L0554",	NULL },
	{ "L0556",	NULL },
	{ "L056B",	NULL },
	{ "L056C",	NULL },
	{ "L0574",	NULL },
	{ "L0580",	NULL },
	{ "L058F",	NULL },
	{ "L05A9",	NULL },
	{ "L05B3",	NULL },
	{ "L05BD",	NULL },
	{ "L05C2",	NULL },
	{ "L05C4",	NULL },
	{ "L05C8",	NULL },
	{ "L05CA",	NULL },
	{ "L05E3",	NULL },
	{ "L05E7",	NULL },
	{ "L05E9",	NULL },
	{ "L05ED",	NULL },
	{ "L0605",	NULL },
	{ "L0609",	NULL },
	{ "L0621",	NULL },
	{ "L0629",	NULL },
	{ "L0642",	NULL },
	{ "L0644",	NULL },
	{ "L064B",	NULL },
	{ "L0652",	NULL },
	{ "L0670",	NULL },
	{ "L0672",	NULL },
	{ "L0685",	NULL },
	{ "L068F",	NULL },
	{ "L0692",	NULL },
	{ "L06A0",	NULL },
	{ "L06C3",	NULL },
	{ "L06E1",	NULL },
	{ "L06F0",	NULL },
	{ "L06F5",	NULL },
	{ "L06F9",	NULL },
	{ "L0710",	NULL },
	{ "L0716",	NULL },
	{ "L0723",	NULL },
	{ "L073A",	NULL },
	{ "L075A",	NULL },
	{ "L0767",	NULL },
	{ "L078A",	NULL },
	{ "L07A6",	NULL },
	{ "L07AD",	NULL },
	{ "L07CB",	NULL },
	{ "L07E9",	NULL },
	{ "L07F4",	NULL },
	{ "L0800",	NULL },
	{ "L0802",	NULL },
	{ "L0806",	NULL },
	{ "L0808",	NULL },
	{ "L0819",	NULL },
	{ "L0825",	NULL },
	{ "L082E",	NULL },
	{ "L084C",	NULL },
	{ "L0873",	NULL },
	{ "L08AD",	NULL },
	{ "L08B6",	NULL },
	{ "L08D2",	NULL },
	{ "L08D7",	NULL },
	{ "L08DF",	NULL },
	{ "L08EB",	NULL },
	{ "L08F0",	NULL },
	{ "L08F9",	NULL },
	{ "L0901",	NULL },
	{ "L0909",	NULL },
	{ "L0912",	NULL },
	{ "L091E",	NULL },
	{ "L0921",	NULL },
	{ "L0923",	NULL },
	{ "L092C",	NULL },
	{ "L093E",	NULL },
	{ "L0955",	NULL },
	{ "L0958",	NULL },
	{ "L0970",	NULL },
	{ "L0991",	NULL },
	{ "L09A1",	NULL },
	{ "L09C0",	NULL },
	{ "L09F4",	NULL },
	{ "L0A11",	NULL },
	{ "L0A23",	NULL },
	{ "L0A38",	NULL },
	{ "L0A3A",	NULL },
	{ "L0A3D",	NULL },
	{ "L0A4F",	NULL },
	{ "L0A5F",	NULL },
	{ "L0A69",	NULL },
	{ "L0A6D",	NULL },
	{ "L0A75",	NULL },
	{ "L0A7A",	NULL },
	{ "L0A7D",	NULL },
	{ "L0A80",	NULL },
	{ "L0A87",	NULL },
	{ "L0AAC",	NULL },
	{ "L0ABF",	NULL },
	{ "L0AC2",	NULL },
	{ "L0AC3",	NULL },
	{ "L0AD0",	NULL },
	{ "L0AD9",	NULL },
	{ "L0ADC",	NULL },
	{ "L0AF0",	NULL },
	{ "L0AFC",	NULL },
	{ "L0B03",	NULL },
	{ "L0B1D",	NULL },
	{ "L0B24",	NULL },
	{ "L0B38",	NULL },
	{ "L0B3E",	NULL },
	{ "L0B4C",	NULL },
	{ "L0B52",	NULL },
	{ "L0B5F",	NULL },
	{ "L0B65",	NULL },
	{ "L0B6A",	NULL },
	{ "L0B76",	NULL },
	{ "L0B7F",	NULL },
	{ "L0B93",	NULL },
	{ "L0BA4",	NULL },
	{ "L0BB6",	NULL },
	{ "L0BB7",	NULL },
	{ "L0BC1",	NULL },
	{ "L0BD3",	NULL },
	{ "L0BDB",	NULL },
	{ "L0BFA",	NULL },
	{ "L0C08",	NULL },
	{ "L0C0A",	NULL },
	{ "L0C10",	NULL },
	{ "L0C14",	NULL },
	{ "L0C22",	NULL },
	{ "L0C35",	NULL },
	{ "L0C3B",	NULL },
	{ "L0C41",	NULL },
	{ "L0C44",	NULL },
	{ "L0C55",	NULL },
	{ "L0C86",	NULL },
	{ "L0C88",	NULL },
	{ "L0CD2",	NULL },
	{ "L0CF0",	NULL },
	{ "L0CF8",	NULL },
	{ "L0D00",	NULL },
	{ "L0D02",	NULL },
	{ "L0D1C",	NULL },
	{ "L0D2D",	NULL },
	{ "L0D4D",	NULL },
	{ "L0D5B",	NULL },
	{ "L0D65",	NULL },
	{ "L0D6B",	NULL },
	{ "L0D6E",	NULL },
	{ "L0D87",	NULL },
	{ "L0D89",	NULL },
	{ "L0D8E",	NULL },
	{ "L0D94",	NULL },
	{ "L0DA0",	NULL },
	{ "L0DAF",	NULL },
	{ "L0DD9",	NULL },
	{ "L0DEE",	NULL },
	{ "L0DF4",	NULL },
	{ "L0DFE",	NULL },
	{ "L0E00",	NULL },
	{ "L0E05",	NULL },
	{ "L0E0D",	NULL },
	{ "L0E19",	NULL },
	{ "L0E44",	NULL },
	{ "L0E4A",	NULL },
	{ "L0E4D",	NULL },
	{ "L0E80",	NULL },
	{ "L0E88",	NULL },
	{ "L0E9B",	NULL },
	{ "L0EAC",	NULL },
	{ "L0EAF",	NULL },
	{ "L0EB2",	NULL },
	{ "L0EC9",	NULL },
	{ "L0ECD",	NULL },
	{ "L0ED3",	NULL },
	{ "L0EDA",	NULL },
	{ "L0EDF",	NULL },
	{ "L0EE7",	NULL },
	{ "L0EF4",	NULL },
	{ "L0EFD",	NULL },
	{ "L0F0A",	NULL },
	{ "L0F0C",	NULL },
	{ "L0F14",	NULL },
	{ "L0F18",	NULL },
	{ "L0F1E",	NULL },
	{ "L0F2C",	NULL },
	{ "L0F30",	NULL },
	{ "L0F38",	NULL },
	{ "L0F6C",	NULL },
	{ "L0F81",	NULL },
	{ "L0F8B",	NULL },
	{ "L0F92",	NULL },
	{ "L0FA0",	NULL },
	{ "L0FA9",	NULL },
	{ "L0FF3",	NULL },
	{ NULL,		NULL },
};
	
END_INIT
	/* main */
	char *pool;
	int i;
	
	warn("first run - create pool for all strings\n");
	for (i = 0; strings[i].source; i++) {
		pool = strpool_add(strings[i].source);
		if (pool == NULL) ERROR;
		if (pool == strings[i].source) ERROR;
		if (strcmp(strings[i].source, pool)) ERROR;
		strings[i].pool = pool;
	}
	
	warn("second run - check that pool did not move\n");
	for (i = 0; strings[i].source; i++) {
		pool = strpool_add(strings[i].source);
		if (pool == NULL) ERROR;
		if (pool == strings[i].source) ERROR;
		if (strcmp(strings[i].source, pool)) ERROR;
		if (pool != strings[i].pool) ERROR;
	}
	
	warn("check NULL case\n");
	pool = strpool_add(NULL);
	if (pool != NULL) ERROR;
	
	return 0;
END

t_run_module([], "", <<ERR, 0);
first run - create pool for all strings
memalloc: init
memalloc strpool.c(1): alloc 32 bytes at ADDR_1
class: init
class strpool.c(1): new class StrPool at ADDR_1
memalloc strpool.c(2): alloc 36 bytes at ADDR_2
memalloc strpool.c(3): alloc 2 bytes at ADDR_3
memalloc strpool.c(4): alloc 44 bytes at ADDR_4
memalloc strpool.c(4): alloc 384 bytes at ADDR_5
memalloc strpool.c(2): alloc 36 bytes at ADDR_6
memalloc strpool.c(3): alloc 4 bytes at ADDR_7
memalloc strpool.c(2): alloc 36 bytes at ADDR_8
memalloc strpool.c(3): alloc 4 bytes at ADDR_9
memalloc strpool.c(2): alloc 36 bytes at ADDR_10
memalloc strpool.c(3): alloc 3 bytes at ADDR_11
memalloc strpool.c(2): alloc 36 bytes at ADDR_12
memalloc strpool.c(3): alloc 4 bytes at ADDR_13
memalloc strpool.c(2): alloc 36 bytes at ADDR_14
memalloc strpool.c(3): alloc 2 bytes at ADDR_15
memalloc strpool.c(2): alloc 36 bytes at ADDR_16
memalloc strpool.c(3): alloc 3 bytes at ADDR_17
memalloc strpool.c(2): alloc 36 bytes at ADDR_18
memalloc strpool.c(3): alloc 4 bytes at ADDR_19
memalloc strpool.c(2): alloc 36 bytes at ADDR_20
memalloc strpool.c(3): alloc 2 bytes at ADDR_21
memalloc strpool.c(2): alloc 36 bytes at ADDR_22
memalloc strpool.c(3): alloc 5 bytes at ADDR_23
memalloc strpool.c(2): alloc 36 bytes at ADDR_24
memalloc strpool.c(3): alloc 4 bytes at ADDR_25
memalloc strpool.c(2): alloc 36 bytes at ADDR_26
memalloc strpool.c(3): alloc 3 bytes at ADDR_27
memalloc strpool.c(2): alloc 36 bytes at ADDR_28
memalloc strpool.c(3): alloc 5 bytes at ADDR_29
memalloc strpool.c(2): alloc 36 bytes at ADDR_30
memalloc strpool.c(3): alloc 4 bytes at ADDR_31
memalloc strpool.c(2): alloc 36 bytes at ADDR_32
memalloc strpool.c(3): alloc 2 bytes at ADDR_33
memalloc strpool.c(2): alloc 36 bytes at ADDR_34
memalloc strpool.c(3): alloc 4 bytes at ADDR_35
memalloc strpool.c(2): alloc 36 bytes at ADDR_36
memalloc strpool.c(3): alloc 3 bytes at ADDR_37
memalloc strpool.c(2): alloc 36 bytes at ADDR_38
memalloc strpool.c(3): alloc 4 bytes at ADDR_39
memalloc strpool.c(2): alloc 36 bytes at ADDR_40
memalloc strpool.c(3): alloc 5 bytes at ADDR_41
memalloc strpool.c(2): alloc 36 bytes at ADDR_42
memalloc strpool.c(3): alloc 5 bytes at ADDR_43
memalloc strpool.c(2): alloc 36 bytes at ADDR_44
memalloc strpool.c(3): alloc 5 bytes at ADDR_45
memalloc strpool.c(2): alloc 36 bytes at ADDR_46
memalloc strpool.c(3): alloc 3 bytes at ADDR_47
memalloc strpool.c(2): alloc 36 bytes at ADDR_48
memalloc strpool.c(3): alloc 5 bytes at ADDR_49
memalloc strpool.c(2): alloc 36 bytes at ADDR_50
memalloc strpool.c(3): alloc 2 bytes at ADDR_51
memalloc strpool.c(2): alloc 36 bytes at ADDR_52
memalloc strpool.c(3): alloc 3 bytes at ADDR_53
memalloc strpool.c(2): alloc 36 bytes at ADDR_54
memalloc strpool.c(3): alloc 3 bytes at ADDR_55
memalloc strpool.c(2): alloc 36 bytes at ADDR_56
memalloc strpool.c(3): alloc 4 bytes at ADDR_57
memalloc strpool.c(2): alloc 36 bytes at ADDR_58
memalloc strpool.c(3): alloc 2 bytes at ADDR_59
memalloc strpool.c(2): alloc 36 bytes at ADDR_60
memalloc strpool.c(3): alloc 5 bytes at ADDR_61
memalloc strpool.c(2): alloc 36 bytes at ADDR_62
memalloc strpool.c(3): alloc 3 bytes at ADDR_63
memalloc strpool.c(2): alloc 36 bytes at ADDR_64
memalloc strpool.c(3): alloc 2 bytes at ADDR_65
memalloc strpool.c(2): alloc 36 bytes at ADDR_66
memalloc strpool.c(3): alloc 3 bytes at ADDR_67
memalloc strpool.c(2): alloc 36 bytes at ADDR_68
memalloc strpool.c(3): alloc 3 bytes at ADDR_69
memalloc strpool.c(2): alloc 36 bytes at ADDR_70
memalloc strpool.c(3): alloc 4 bytes at ADDR_71
memalloc strpool.c(2): alloc 36 bytes at ADDR_72
memalloc strpool.c(3): alloc 3 bytes at ADDR_73
memalloc strpool.c(2): alloc 36 bytes at ADDR_74
memalloc strpool.c(3): alloc 3 bytes at ADDR_75
memalloc strpool.c(2): alloc 36 bytes at ADDR_76
memalloc strpool.c(3): alloc 3 bytes at ADDR_77
memalloc strpool.c(2): alloc 36 bytes at ADDR_78
memalloc strpool.c(3): alloc 3 bytes at ADDR_79
memalloc strpool.c(2): alloc 36 bytes at ADDR_80
memalloc strpool.c(3): alloc 2 bytes at ADDR_81
memalloc strpool.c(2): alloc 36 bytes at ADDR_82
memalloc strpool.c(3): alloc 3 bytes at ADDR_83
memalloc strpool.c(2): alloc 36 bytes at ADDR_84
memalloc strpool.c(3): alloc 5 bytes at ADDR_85
memalloc strpool.c(2): alloc 36 bytes at ADDR_86
memalloc strpool.c(3): alloc 5 bytes at ADDR_87
memalloc strpool.c(2): alloc 36 bytes at ADDR_88
memalloc strpool.c(3): alloc 2 bytes at ADDR_89
memalloc strpool.c(2): alloc 36 bytes at ADDR_90
memalloc strpool.c(3): alloc 3 bytes at ADDR_91
memalloc strpool.c(2): alloc 36 bytes at ADDR_92
memalloc strpool.c(3): alloc 4 bytes at ADDR_93
memalloc strpool.c(2): alloc 36 bytes at ADDR_94
memalloc strpool.c(3): alloc 4 bytes at ADDR_95
memalloc strpool.c(2): alloc 36 bytes at ADDR_96
memalloc strpool.c(3): alloc 3 bytes at ADDR_97
memalloc strpool.c(2): alloc 36 bytes at ADDR_98
memalloc strpool.c(3): alloc 3 bytes at ADDR_99
memalloc strpool.c(2): alloc 36 bytes at ADDR_100
memalloc strpool.c(3): alloc 4 bytes at ADDR_101
memalloc strpool.c(2): alloc 36 bytes at ADDR_102
memalloc strpool.c(3): alloc 4 bytes at ADDR_103
memalloc strpool.c(2): alloc 36 bytes at ADDR_104
memalloc strpool.c(3): alloc 2 bytes at ADDR_105
memalloc strpool.c(2): alloc 36 bytes at ADDR_106
memalloc strpool.c(3): alloc 3 bytes at ADDR_107
memalloc strpool.c(2): alloc 36 bytes at ADDR_108
memalloc strpool.c(3): alloc 4 bytes at ADDR_109
memalloc strpool.c(2): alloc 36 bytes at ADDR_110
memalloc strpool.c(3): alloc 5 bytes at ADDR_111
memalloc strpool.c(2): alloc 36 bytes at ADDR_112
memalloc strpool.c(3): alloc 4 bytes at ADDR_113
memalloc strpool.c(2): alloc 36 bytes at ADDR_114
memalloc strpool.c(3): alloc 4 bytes at ADDR_115
memalloc strpool.c(2): alloc 36 bytes at ADDR_116
memalloc strpool.c(3): alloc 5 bytes at ADDR_117
memalloc strpool.c(2): alloc 36 bytes at ADDR_118
memalloc strpool.c(3): alloc 3 bytes at ADDR_119
memalloc strpool.c(2): alloc 36 bytes at ADDR_120
memalloc strpool.c(3): alloc 4 bytes at ADDR_121
memalloc strpool.c(2): alloc 36 bytes at ADDR_122
memalloc strpool.c(3): alloc 4 bytes at ADDR_123
memalloc strpool.c(2): alloc 36 bytes at ADDR_124
memalloc strpool.c(3): alloc 5 bytes at ADDR_125
memalloc strpool.c(2): alloc 36 bytes at ADDR_126
memalloc strpool.c(3): alloc 4 bytes at ADDR_127
memalloc strpool.c(2): alloc 36 bytes at ADDR_128
memalloc strpool.c(3): alloc 3 bytes at ADDR_129
memalloc strpool.c(2): alloc 36 bytes at ADDR_130
memalloc strpool.c(3): alloc 4 bytes at ADDR_131
memalloc strpool.c(2): alloc 36 bytes at ADDR_132
memalloc strpool.c(3): alloc 4 bytes at ADDR_133
memalloc strpool.c(2): alloc 36 bytes at ADDR_134
memalloc strpool.c(3): alloc 5 bytes at ADDR_135
memalloc strpool.c(2): alloc 36 bytes at ADDR_136
memalloc strpool.c(3): alloc 4 bytes at ADDR_137
memalloc strpool.c(2): alloc 36 bytes at ADDR_138
memalloc strpool.c(3): alloc 4 bytes at ADDR_139
memalloc strpool.c(2): alloc 36 bytes at ADDR_140
memalloc strpool.c(3): alloc 4 bytes at ADDR_141
memalloc strpool.c(2): alloc 36 bytes at ADDR_142
memalloc strpool.c(3): alloc 4 bytes at ADDR_143
memalloc strpool.c(2): alloc 36 bytes at ADDR_144
memalloc strpool.c(3): alloc 4 bytes at ADDR_145
memalloc strpool.c(2): alloc 36 bytes at ADDR_146
memalloc strpool.c(3): alloc 3 bytes at ADDR_147
memalloc strpool.c(2): alloc 36 bytes at ADDR_148
memalloc strpool.c(3): alloc 4 bytes at ADDR_149
memalloc strpool.c(2): alloc 36 bytes at ADDR_150
memalloc strpool.c(3): alloc 4 bytes at ADDR_151
memalloc strpool.c(2): alloc 36 bytes at ADDR_152
memalloc strpool.c(3): alloc 4 bytes at ADDR_153
memalloc strpool.c(2): alloc 36 bytes at ADDR_154
memalloc strpool.c(3): alloc 4 bytes at ADDR_155
memalloc strpool.c(2): alloc 36 bytes at ADDR_156
memalloc strpool.c(3): alloc 2 bytes at ADDR_157
memalloc strpool.c(2): alloc 36 bytes at ADDR_158
memalloc strpool.c(3): alloc 6 bytes at ADDR_159
memalloc strpool.c(2): alloc 36 bytes at ADDR_160
memalloc strpool.c(3): alloc 6 bytes at ADDR_161
memalloc strpool.c(2): alloc 36 bytes at ADDR_162
memalloc strpool.c(3): alloc 6 bytes at ADDR_163
memalloc strpool.c(2): alloc 36 bytes at ADDR_164
memalloc strpool.c(3): alloc 6 bytes at ADDR_165
memalloc strpool.c(2): alloc 36 bytes at ADDR_166
memalloc strpool.c(3): alloc 6 bytes at ADDR_167
memalloc strpool.c(2): alloc 36 bytes at ADDR_168
memalloc strpool.c(3): alloc 6 bytes at ADDR_169
memalloc strpool.c(2): alloc 36 bytes at ADDR_170
memalloc strpool.c(3): alloc 6 bytes at ADDR_171
memalloc strpool.c(2): alloc 36 bytes at ADDR_172
memalloc strpool.c(3): alloc 6 bytes at ADDR_173
memalloc strpool.c(2): alloc 36 bytes at ADDR_174
memalloc strpool.c(3): alloc 6 bytes at ADDR_175
memalloc strpool.c(2): alloc 36 bytes at ADDR_176
memalloc strpool.c(3): alloc 6 bytes at ADDR_177
memalloc strpool.c(2): alloc 36 bytes at ADDR_178
memalloc strpool.c(3): alloc 6 bytes at ADDR_179
memalloc strpool.c(2): alloc 36 bytes at ADDR_180
memalloc strpool.c(3): alloc 6 bytes at ADDR_181
memalloc strpool.c(2): alloc 36 bytes at ADDR_182
memalloc strpool.c(3): alloc 6 bytes at ADDR_183
memalloc strpool.c(2): alloc 36 bytes at ADDR_184
memalloc strpool.c(3): alloc 6 bytes at ADDR_185
memalloc strpool.c(2): alloc 36 bytes at ADDR_186
memalloc strpool.c(3): alloc 6 bytes at ADDR_187
memalloc strpool.c(2): alloc 36 bytes at ADDR_188
memalloc strpool.c(3): alloc 6 bytes at ADDR_189
memalloc strpool.c(2): alloc 36 bytes at ADDR_190
memalloc strpool.c(3): alloc 6 bytes at ADDR_191
memalloc strpool.c(2): alloc 36 bytes at ADDR_192
memalloc strpool.c(3): alloc 6 bytes at ADDR_193
memalloc strpool.c(2): alloc 36 bytes at ADDR_194
memalloc strpool.c(3): alloc 6 bytes at ADDR_195
memalloc strpool.c(2): alloc 36 bytes at ADDR_196
memalloc strpool.c(3): alloc 6 bytes at ADDR_197
memalloc strpool.c(2): alloc 36 bytes at ADDR_198
memalloc strpool.c(3): alloc 6 bytes at ADDR_199
memalloc strpool.c(2): alloc 36 bytes at ADDR_200
memalloc strpool.c(3): alloc 6 bytes at ADDR_201
memalloc strpool.c(2): alloc 36 bytes at ADDR_202
memalloc strpool.c(3): alloc 6 bytes at ADDR_203
memalloc strpool.c(2): alloc 36 bytes at ADDR_204
memalloc strpool.c(3): alloc 6 bytes at ADDR_205
memalloc strpool.c(2): alloc 36 bytes at ADDR_206
memalloc strpool.c(3): alloc 6 bytes at ADDR_207
memalloc strpool.c(2): alloc 36 bytes at ADDR_208
memalloc strpool.c(3): alloc 6 bytes at ADDR_209
memalloc strpool.c(2): alloc 36 bytes at ADDR_210
memalloc strpool.c(3): alloc 6 bytes at ADDR_211
memalloc strpool.c(2): alloc 36 bytes at ADDR_212
memalloc strpool.c(3): alloc 6 bytes at ADDR_213
memalloc strpool.c(2): alloc 36 bytes at ADDR_214
memalloc strpool.c(3): alloc 6 bytes at ADDR_215
memalloc strpool.c(2): alloc 36 bytes at ADDR_216
memalloc strpool.c(3): alloc 6 bytes at ADDR_217
memalloc strpool.c(2): alloc 36 bytes at ADDR_218
memalloc strpool.c(3): alloc 6 bytes at ADDR_219
memalloc strpool.c(2): alloc 36 bytes at ADDR_220
memalloc strpool.c(3): alloc 6 bytes at ADDR_221
memalloc strpool.c(2): alloc 36 bytes at ADDR_222
memalloc strpool.c(3): alloc 6 bytes at ADDR_223
memalloc strpool.c(2): alloc 36 bytes at ADDR_224
memalloc strpool.c(3): alloc 6 bytes at ADDR_225
memalloc strpool.c(2): alloc 36 bytes at ADDR_226
memalloc strpool.c(3): alloc 6 bytes at ADDR_227
memalloc strpool.c(2): alloc 36 bytes at ADDR_228
memalloc strpool.c(3): alloc 6 bytes at ADDR_229
memalloc strpool.c(2): alloc 36 bytes at ADDR_230
memalloc strpool.c(3): alloc 6 bytes at ADDR_231
memalloc strpool.c(2): alloc 36 bytes at ADDR_232
memalloc strpool.c(3): alloc 6 bytes at ADDR_233
memalloc strpool.c(2): alloc 36 bytes at ADDR_234
memalloc strpool.c(3): alloc 6 bytes at ADDR_235
memalloc strpool.c(2): alloc 36 bytes at ADDR_236
memalloc strpool.c(3): alloc 6 bytes at ADDR_237
memalloc strpool.c(2): alloc 36 bytes at ADDR_238
memalloc strpool.c(3): alloc 6 bytes at ADDR_239
memalloc strpool.c(2): alloc 36 bytes at ADDR_240
memalloc strpool.c(3): alloc 6 bytes at ADDR_241
memalloc strpool.c(2): alloc 36 bytes at ADDR_242
memalloc strpool.c(3): alloc 6 bytes at ADDR_243
memalloc strpool.c(2): alloc 36 bytes at ADDR_244
memalloc strpool.c(3): alloc 6 bytes at ADDR_245
memalloc strpool.c(2): alloc 36 bytes at ADDR_246
memalloc strpool.c(3): alloc 6 bytes at ADDR_247
memalloc strpool.c(2): alloc 36 bytes at ADDR_248
memalloc strpool.c(3): alloc 6 bytes at ADDR_249
memalloc strpool.c(2): alloc 36 bytes at ADDR_250
memalloc strpool.c(3): alloc 6 bytes at ADDR_251
memalloc strpool.c(2): alloc 36 bytes at ADDR_252
memalloc strpool.c(3): alloc 6 bytes at ADDR_253
memalloc strpool.c(2): alloc 36 bytes at ADDR_254
memalloc strpool.c(3): alloc 6 bytes at ADDR_255
memalloc strpool.c(2): alloc 36 bytes at ADDR_256
memalloc strpool.c(3): alloc 6 bytes at ADDR_257
memalloc strpool.c(2): alloc 36 bytes at ADDR_258
memalloc strpool.c(3): alloc 6 bytes at ADDR_259
memalloc strpool.c(2): alloc 36 bytes at ADDR_260
memalloc strpool.c(3): alloc 6 bytes at ADDR_261
memalloc strpool.c(2): alloc 36 bytes at ADDR_262
memalloc strpool.c(3): alloc 6 bytes at ADDR_263
memalloc strpool.c(2): alloc 36 bytes at ADDR_264
memalloc strpool.c(3): alloc 6 bytes at ADDR_265
memalloc strpool.c(2): alloc 36 bytes at ADDR_266
memalloc strpool.c(3): alloc 6 bytes at ADDR_267
memalloc strpool.c(2): alloc 36 bytes at ADDR_268
memalloc strpool.c(3): alloc 6 bytes at ADDR_269
memalloc strpool.c(2): alloc 36 bytes at ADDR_270
memalloc strpool.c(3): alloc 6 bytes at ADDR_271
memalloc strpool.c(2): alloc 36 bytes at ADDR_272
memalloc strpool.c(3): alloc 6 bytes at ADDR_273
memalloc strpool.c(2): alloc 36 bytes at ADDR_274
memalloc strpool.c(3): alloc 6 bytes at ADDR_275
memalloc strpool.c(2): alloc 36 bytes at ADDR_276
memalloc strpool.c(3): alloc 6 bytes at ADDR_277
memalloc strpool.c(2): alloc 36 bytes at ADDR_278
memalloc strpool.c(3): alloc 6 bytes at ADDR_279
memalloc strpool.c(2): alloc 36 bytes at ADDR_280
memalloc strpool.c(3): alloc 6 bytes at ADDR_281
memalloc strpool.c(2): alloc 36 bytes at ADDR_282
memalloc strpool.c(3): alloc 6 bytes at ADDR_283
memalloc strpool.c(2): alloc 36 bytes at ADDR_284
memalloc strpool.c(3): alloc 6 bytes at ADDR_285
memalloc strpool.c(2): alloc 36 bytes at ADDR_286
memalloc strpool.c(3): alloc 6 bytes at ADDR_287
memalloc strpool.c(2): alloc 36 bytes at ADDR_288
memalloc strpool.c(3): alloc 6 bytes at ADDR_289
memalloc strpool.c(2): alloc 36 bytes at ADDR_290
memalloc strpool.c(3): alloc 6 bytes at ADDR_291
memalloc strpool.c(2): alloc 36 bytes at ADDR_292
memalloc strpool.c(3): alloc 6 bytes at ADDR_293
memalloc strpool.c(2): alloc 36 bytes at ADDR_294
memalloc strpool.c(3): alloc 6 bytes at ADDR_295
memalloc strpool.c(2): alloc 36 bytes at ADDR_296
memalloc strpool.c(3): alloc 6 bytes at ADDR_297
memalloc strpool.c(2): alloc 36 bytes at ADDR_298
memalloc strpool.c(3): alloc 6 bytes at ADDR_299
memalloc strpool.c(2): alloc 36 bytes at ADDR_300
memalloc strpool.c(3): alloc 6 bytes at ADDR_301
memalloc strpool.c(2): alloc 36 bytes at ADDR_302
memalloc strpool.c(3): alloc 6 bytes at ADDR_303
memalloc strpool.c(2): alloc 36 bytes at ADDR_304
memalloc strpool.c(3): alloc 6 bytes at ADDR_305
memalloc strpool.c(2): alloc 36 bytes at ADDR_306
memalloc strpool.c(3): alloc 6 bytes at ADDR_307
memalloc strpool.c(2): alloc 36 bytes at ADDR_308
memalloc strpool.c(3): alloc 6 bytes at ADDR_309
memalloc strpool.c(2): alloc 36 bytes at ADDR_310
memalloc strpool.c(3): alloc 6 bytes at ADDR_311
memalloc strpool.c(2): alloc 36 bytes at ADDR_312
memalloc strpool.c(3): alloc 6 bytes at ADDR_313
memalloc strpool.c(2): alloc 36 bytes at ADDR_314
memalloc strpool.c(3): alloc 6 bytes at ADDR_315
memalloc strpool.c(2): alloc 36 bytes at ADDR_316
memalloc strpool.c(3): alloc 6 bytes at ADDR_317
memalloc strpool.c(2): alloc 36 bytes at ADDR_318
memalloc strpool.c(3): alloc 6 bytes at ADDR_319
memalloc strpool.c(2): alloc 36 bytes at ADDR_320
memalloc strpool.c(3): alloc 6 bytes at ADDR_321
memalloc strpool.c(2): alloc 36 bytes at ADDR_322
memalloc strpool.c(3): alloc 6 bytes at ADDR_323
memalloc strpool.c(2): alloc 36 bytes at ADDR_324
memalloc strpool.c(3): alloc 6 bytes at ADDR_325
memalloc strpool.c(2): alloc 36 bytes at ADDR_326
memalloc strpool.c(3): alloc 6 bytes at ADDR_327
memalloc strpool.c(2): alloc 36 bytes at ADDR_328
memalloc strpool.c(3): alloc 6 bytes at ADDR_329
memalloc strpool.c(2): alloc 36 bytes at ADDR_330
memalloc strpool.c(3): alloc 6 bytes at ADDR_331
memalloc strpool.c(2): alloc 36 bytes at ADDR_332
memalloc strpool.c(3): alloc 6 bytes at ADDR_333
memalloc strpool.c(2): alloc 36 bytes at ADDR_334
memalloc strpool.c(3): alloc 6 bytes at ADDR_335
memalloc strpool.c(4): alloc 768 bytes at ADDR_336
memalloc strpool.c(4): free 384 bytes at ADDR_5 allocated at strpool.c(4)
memalloc strpool.c(2): alloc 36 bytes at ADDR_337
memalloc strpool.c(3): alloc 6 bytes at ADDR_338
memalloc strpool.c(2): alloc 36 bytes at ADDR_339
memalloc strpool.c(3): alloc 6 bytes at ADDR_340
memalloc strpool.c(2): alloc 36 bytes at ADDR_341
memalloc strpool.c(3): alloc 6 bytes at ADDR_342
memalloc strpool.c(2): alloc 36 bytes at ADDR_343
memalloc strpool.c(3): alloc 6 bytes at ADDR_344
memalloc strpool.c(2): alloc 36 bytes at ADDR_345
memalloc strpool.c(3): alloc 6 bytes at ADDR_346
memalloc strpool.c(2): alloc 36 bytes at ADDR_347
memalloc strpool.c(3): alloc 6 bytes at ADDR_348
memalloc strpool.c(2): alloc 36 bytes at ADDR_349
memalloc strpool.c(3): alloc 6 bytes at ADDR_350
memalloc strpool.c(2): alloc 36 bytes at ADDR_351
memalloc strpool.c(3): alloc 6 bytes at ADDR_352
memalloc strpool.c(2): alloc 36 bytes at ADDR_353
memalloc strpool.c(3): alloc 6 bytes at ADDR_354
memalloc strpool.c(2): alloc 36 bytes at ADDR_355
memalloc strpool.c(3): alloc 6 bytes at ADDR_356
memalloc strpool.c(2): alloc 36 bytes at ADDR_357
memalloc strpool.c(3): alloc 6 bytes at ADDR_358
memalloc strpool.c(2): alloc 36 bytes at ADDR_359
memalloc strpool.c(3): alloc 6 bytes at ADDR_360
memalloc strpool.c(2): alloc 36 bytes at ADDR_361
memalloc strpool.c(3): alloc 6 bytes at ADDR_362
memalloc strpool.c(2): alloc 36 bytes at ADDR_363
memalloc strpool.c(3): alloc 6 bytes at ADDR_364
memalloc strpool.c(2): alloc 36 bytes at ADDR_365
memalloc strpool.c(3): alloc 6 bytes at ADDR_366
memalloc strpool.c(2): alloc 36 bytes at ADDR_367
memalloc strpool.c(3): alloc 6 bytes at ADDR_368
memalloc strpool.c(2): alloc 36 bytes at ADDR_369
memalloc strpool.c(3): alloc 6 bytes at ADDR_370
memalloc strpool.c(2): alloc 36 bytes at ADDR_371
memalloc strpool.c(3): alloc 6 bytes at ADDR_372
memalloc strpool.c(2): alloc 36 bytes at ADDR_373
memalloc strpool.c(3): alloc 6 bytes at ADDR_374
memalloc strpool.c(2): alloc 36 bytes at ADDR_375
memalloc strpool.c(3): alloc 6 bytes at ADDR_376
memalloc strpool.c(2): alloc 36 bytes at ADDR_377
memalloc strpool.c(3): alloc 6 bytes at ADDR_378
memalloc strpool.c(2): alloc 36 bytes at ADDR_379
memalloc strpool.c(3): alloc 6 bytes at ADDR_380
memalloc strpool.c(2): alloc 36 bytes at ADDR_381
memalloc strpool.c(3): alloc 6 bytes at ADDR_382
memalloc strpool.c(2): alloc 36 bytes at ADDR_383
memalloc strpool.c(3): alloc 6 bytes at ADDR_384
memalloc strpool.c(2): alloc 36 bytes at ADDR_385
memalloc strpool.c(3): alloc 6 bytes at ADDR_386
memalloc strpool.c(2): alloc 36 bytes at ADDR_387
memalloc strpool.c(3): alloc 6 bytes at ADDR_388
memalloc strpool.c(2): alloc 36 bytes at ADDR_389
memalloc strpool.c(3): alloc 6 bytes at ADDR_390
memalloc strpool.c(2): alloc 36 bytes at ADDR_391
memalloc strpool.c(3): alloc 6 bytes at ADDR_392
memalloc strpool.c(2): alloc 36 bytes at ADDR_393
memalloc strpool.c(3): alloc 6 bytes at ADDR_394
memalloc strpool.c(2): alloc 36 bytes at ADDR_395
memalloc strpool.c(3): alloc 6 bytes at ADDR_396
memalloc strpool.c(2): alloc 36 bytes at ADDR_397
memalloc strpool.c(3): alloc 6 bytes at ADDR_398
memalloc strpool.c(2): alloc 36 bytes at ADDR_399
memalloc strpool.c(3): alloc 6 bytes at ADDR_400
memalloc strpool.c(2): alloc 36 bytes at ADDR_401
memalloc strpool.c(3): alloc 6 bytes at ADDR_402
memalloc strpool.c(2): alloc 36 bytes at ADDR_403
memalloc strpool.c(3): alloc 6 bytes at ADDR_404
memalloc strpool.c(2): alloc 36 bytes at ADDR_405
memalloc strpool.c(3): alloc 6 bytes at ADDR_406
memalloc strpool.c(2): alloc 36 bytes at ADDR_407
memalloc strpool.c(3): alloc 6 bytes at ADDR_408
memalloc strpool.c(2): alloc 36 bytes at ADDR_409
memalloc strpool.c(3): alloc 6 bytes at ADDR_410
memalloc strpool.c(2): alloc 36 bytes at ADDR_411
memalloc strpool.c(3): alloc 6 bytes at ADDR_412
memalloc strpool.c(2): alloc 36 bytes at ADDR_413
memalloc strpool.c(3): alloc 6 bytes at ADDR_414
memalloc strpool.c(2): alloc 36 bytes at ADDR_415
memalloc strpool.c(3): alloc 6 bytes at ADDR_416
memalloc strpool.c(2): alloc 36 bytes at ADDR_417
memalloc strpool.c(3): alloc 6 bytes at ADDR_418
memalloc strpool.c(2): alloc 36 bytes at ADDR_419
memalloc strpool.c(3): alloc 6 bytes at ADDR_420
memalloc strpool.c(2): alloc 36 bytes at ADDR_421
memalloc strpool.c(3): alloc 6 bytes at ADDR_422
memalloc strpool.c(2): alloc 36 bytes at ADDR_423
memalloc strpool.c(3): alloc 6 bytes at ADDR_424
memalloc strpool.c(2): alloc 36 bytes at ADDR_425
memalloc strpool.c(3): alloc 6 bytes at ADDR_426
memalloc strpool.c(2): alloc 36 bytes at ADDR_427
memalloc strpool.c(3): alloc 6 bytes at ADDR_428
memalloc strpool.c(2): alloc 36 bytes at ADDR_429
memalloc strpool.c(3): alloc 6 bytes at ADDR_430
memalloc strpool.c(2): alloc 36 bytes at ADDR_431
memalloc strpool.c(3): alloc 6 bytes at ADDR_432
memalloc strpool.c(2): alloc 36 bytes at ADDR_433
memalloc strpool.c(3): alloc 6 bytes at ADDR_434
memalloc strpool.c(2): alloc 36 bytes at ADDR_435
memalloc strpool.c(3): alloc 6 bytes at ADDR_436
memalloc strpool.c(2): alloc 36 bytes at ADDR_437
memalloc strpool.c(3): alloc 6 bytes at ADDR_438
memalloc strpool.c(2): alloc 36 bytes at ADDR_439
memalloc strpool.c(3): alloc 6 bytes at ADDR_440
memalloc strpool.c(2): alloc 36 bytes at ADDR_441
memalloc strpool.c(3): alloc 6 bytes at ADDR_442
memalloc strpool.c(2): alloc 36 bytes at ADDR_443
memalloc strpool.c(3): alloc 6 bytes at ADDR_444
memalloc strpool.c(2): alloc 36 bytes at ADDR_445
memalloc strpool.c(3): alloc 6 bytes at ADDR_446
memalloc strpool.c(2): alloc 36 bytes at ADDR_447
memalloc strpool.c(3): alloc 6 bytes at ADDR_448
memalloc strpool.c(2): alloc 36 bytes at ADDR_449
memalloc strpool.c(3): alloc 6 bytes at ADDR_450
memalloc strpool.c(2): alloc 36 bytes at ADDR_451
memalloc strpool.c(3): alloc 6 bytes at ADDR_452
memalloc strpool.c(2): alloc 36 bytes at ADDR_453
memalloc strpool.c(3): alloc 6 bytes at ADDR_454
memalloc strpool.c(2): alloc 36 bytes at ADDR_455
memalloc strpool.c(3): alloc 6 bytes at ADDR_456
memalloc strpool.c(2): alloc 36 bytes at ADDR_457
memalloc strpool.c(3): alloc 6 bytes at ADDR_458
memalloc strpool.c(2): alloc 36 bytes at ADDR_459
memalloc strpool.c(3): alloc 6 bytes at ADDR_460
memalloc strpool.c(2): alloc 36 bytes at ADDR_461
memalloc strpool.c(3): alloc 6 bytes at ADDR_462
memalloc strpool.c(2): alloc 36 bytes at ADDR_463
memalloc strpool.c(3): alloc 6 bytes at ADDR_464
memalloc strpool.c(2): alloc 36 bytes at ADDR_465
memalloc strpool.c(3): alloc 6 bytes at ADDR_466
memalloc strpool.c(2): alloc 36 bytes at ADDR_467
memalloc strpool.c(3): alloc 6 bytes at ADDR_468
memalloc strpool.c(2): alloc 36 bytes at ADDR_469
memalloc strpool.c(3): alloc 6 bytes at ADDR_470
memalloc strpool.c(2): alloc 36 bytes at ADDR_471
memalloc strpool.c(3): alloc 6 bytes at ADDR_472
memalloc strpool.c(2): alloc 36 bytes at ADDR_473
memalloc strpool.c(3): alloc 6 bytes at ADDR_474
memalloc strpool.c(2): alloc 36 bytes at ADDR_475
memalloc strpool.c(3): alloc 6 bytes at ADDR_476
memalloc strpool.c(2): alloc 36 bytes at ADDR_477
memalloc strpool.c(3): alloc 6 bytes at ADDR_478
memalloc strpool.c(2): alloc 36 bytes at ADDR_479
memalloc strpool.c(3): alloc 6 bytes at ADDR_480
memalloc strpool.c(2): alloc 36 bytes at ADDR_481
memalloc strpool.c(3): alloc 6 bytes at ADDR_482
memalloc strpool.c(2): alloc 36 bytes at ADDR_483
memalloc strpool.c(3): alloc 6 bytes at ADDR_484
memalloc strpool.c(2): alloc 36 bytes at ADDR_485
memalloc strpool.c(3): alloc 6 bytes at ADDR_486
memalloc strpool.c(2): alloc 36 bytes at ADDR_487
memalloc strpool.c(3): alloc 6 bytes at ADDR_488
memalloc strpool.c(2): alloc 36 bytes at ADDR_489
memalloc strpool.c(3): alloc 6 bytes at ADDR_490
memalloc strpool.c(2): alloc 36 bytes at ADDR_491
memalloc strpool.c(3): alloc 6 bytes at ADDR_492
memalloc strpool.c(2): alloc 36 bytes at ADDR_493
memalloc strpool.c(3): alloc 6 bytes at ADDR_494
memalloc strpool.c(2): alloc 36 bytes at ADDR_495
memalloc strpool.c(3): alloc 6 bytes at ADDR_496
memalloc strpool.c(2): alloc 36 bytes at ADDR_497
memalloc strpool.c(3): alloc 6 bytes at ADDR_498
memalloc strpool.c(2): alloc 36 bytes at ADDR_499
memalloc strpool.c(3): alloc 6 bytes at ADDR_500
memalloc strpool.c(2): alloc 36 bytes at ADDR_501
memalloc strpool.c(3): alloc 6 bytes at ADDR_502
memalloc strpool.c(2): alloc 36 bytes at ADDR_503
memalloc strpool.c(3): alloc 6 bytes at ADDR_504
memalloc strpool.c(2): alloc 36 bytes at ADDR_505
memalloc strpool.c(3): alloc 6 bytes at ADDR_506
memalloc strpool.c(2): alloc 36 bytes at ADDR_507
memalloc strpool.c(3): alloc 6 bytes at ADDR_508
memalloc strpool.c(2): alloc 36 bytes at ADDR_509
memalloc strpool.c(3): alloc 6 bytes at ADDR_510
memalloc strpool.c(2): alloc 36 bytes at ADDR_511
memalloc strpool.c(3): alloc 6 bytes at ADDR_512
memalloc strpool.c(2): alloc 36 bytes at ADDR_513
memalloc strpool.c(3): alloc 6 bytes at ADDR_514
memalloc strpool.c(2): alloc 36 bytes at ADDR_515
memalloc strpool.c(3): alloc 6 bytes at ADDR_516
memalloc strpool.c(2): alloc 36 bytes at ADDR_517
memalloc strpool.c(3): alloc 6 bytes at ADDR_518
memalloc strpool.c(2): alloc 36 bytes at ADDR_519
memalloc strpool.c(3): alloc 6 bytes at ADDR_520
memalloc strpool.c(2): alloc 36 bytes at ADDR_521
memalloc strpool.c(3): alloc 6 bytes at ADDR_522
memalloc strpool.c(2): alloc 36 bytes at ADDR_523
memalloc strpool.c(3): alloc 6 bytes at ADDR_524
memalloc strpool.c(2): alloc 36 bytes at ADDR_525
memalloc strpool.c(3): alloc 6 bytes at ADDR_526
memalloc strpool.c(2): alloc 36 bytes at ADDR_527
memalloc strpool.c(3): alloc 6 bytes at ADDR_528
memalloc strpool.c(2): alloc 36 bytes at ADDR_529
memalloc strpool.c(3): alloc 6 bytes at ADDR_530
memalloc strpool.c(2): alloc 36 bytes at ADDR_531
memalloc strpool.c(3): alloc 6 bytes at ADDR_532
memalloc strpool.c(2): alloc 36 bytes at ADDR_533
memalloc strpool.c(3): alloc 6 bytes at ADDR_534
memalloc strpool.c(2): alloc 36 bytes at ADDR_535
memalloc strpool.c(3): alloc 6 bytes at ADDR_536
memalloc strpool.c(2): alloc 36 bytes at ADDR_537
memalloc strpool.c(3): alloc 6 bytes at ADDR_538
memalloc strpool.c(2): alloc 36 bytes at ADDR_539
memalloc strpool.c(3): alloc 6 bytes at ADDR_540
memalloc strpool.c(2): alloc 36 bytes at ADDR_541
memalloc strpool.c(3): alloc 6 bytes at ADDR_542
memalloc strpool.c(2): alloc 36 bytes at ADDR_543
memalloc strpool.c(3): alloc 6 bytes at ADDR_544
memalloc strpool.c(2): alloc 36 bytes at ADDR_545
memalloc strpool.c(3): alloc 6 bytes at ADDR_546
memalloc strpool.c(2): alloc 36 bytes at ADDR_547
memalloc strpool.c(3): alloc 6 bytes at ADDR_548
memalloc strpool.c(2): alloc 36 bytes at ADDR_549
memalloc strpool.c(3): alloc 6 bytes at ADDR_550
memalloc strpool.c(2): alloc 36 bytes at ADDR_551
memalloc strpool.c(3): alloc 6 bytes at ADDR_552
memalloc strpool.c(2): alloc 36 bytes at ADDR_553
memalloc strpool.c(3): alloc 6 bytes at ADDR_554
memalloc strpool.c(2): alloc 36 bytes at ADDR_555
memalloc strpool.c(3): alloc 6 bytes at ADDR_556
memalloc strpool.c(2): alloc 36 bytes at ADDR_557
memalloc strpool.c(3): alloc 6 bytes at ADDR_558
memalloc strpool.c(2): alloc 36 bytes at ADDR_559
memalloc strpool.c(3): alloc 6 bytes at ADDR_560
memalloc strpool.c(2): alloc 36 bytes at ADDR_561
memalloc strpool.c(3): alloc 6 bytes at ADDR_562
memalloc strpool.c(2): alloc 36 bytes at ADDR_563
memalloc strpool.c(3): alloc 6 bytes at ADDR_564
memalloc strpool.c(2): alloc 36 bytes at ADDR_565
memalloc strpool.c(3): alloc 6 bytes at ADDR_566
memalloc strpool.c(2): alloc 36 bytes at ADDR_567
memalloc strpool.c(3): alloc 6 bytes at ADDR_568
memalloc strpool.c(2): alloc 36 bytes at ADDR_569
memalloc strpool.c(3): alloc 6 bytes at ADDR_570
memalloc strpool.c(2): alloc 36 bytes at ADDR_571
memalloc strpool.c(3): alloc 6 bytes at ADDR_572
memalloc strpool.c(2): alloc 36 bytes at ADDR_573
memalloc strpool.c(3): alloc 6 bytes at ADDR_574
memalloc strpool.c(2): alloc 36 bytes at ADDR_575
memalloc strpool.c(3): alloc 6 bytes at ADDR_576
memalloc strpool.c(2): alloc 36 bytes at ADDR_577
memalloc strpool.c(3): alloc 6 bytes at ADDR_578
memalloc strpool.c(2): alloc 36 bytes at ADDR_579
memalloc strpool.c(3): alloc 6 bytes at ADDR_580
memalloc strpool.c(2): alloc 36 bytes at ADDR_581
memalloc strpool.c(3): alloc 6 bytes at ADDR_582
memalloc strpool.c(2): alloc 36 bytes at ADDR_583
memalloc strpool.c(3): alloc 6 bytes at ADDR_584
memalloc strpool.c(2): alloc 36 bytes at ADDR_585
memalloc strpool.c(3): alloc 6 bytes at ADDR_586
memalloc strpool.c(2): alloc 36 bytes at ADDR_587
memalloc strpool.c(3): alloc 6 bytes at ADDR_588
memalloc strpool.c(2): alloc 36 bytes at ADDR_589
memalloc strpool.c(3): alloc 6 bytes at ADDR_590
memalloc strpool.c(2): alloc 36 bytes at ADDR_591
memalloc strpool.c(3): alloc 6 bytes at ADDR_592
memalloc strpool.c(2): alloc 36 bytes at ADDR_593
memalloc strpool.c(3): alloc 6 bytes at ADDR_594
memalloc strpool.c(2): alloc 36 bytes at ADDR_595
memalloc strpool.c(3): alloc 6 bytes at ADDR_596
memalloc strpool.c(2): alloc 36 bytes at ADDR_597
memalloc strpool.c(3): alloc 6 bytes at ADDR_598
memalloc strpool.c(2): alloc 36 bytes at ADDR_599
memalloc strpool.c(3): alloc 6 bytes at ADDR_600
memalloc strpool.c(2): alloc 36 bytes at ADDR_601
memalloc strpool.c(3): alloc 6 bytes at ADDR_602
memalloc strpool.c(2): alloc 36 bytes at ADDR_603
memalloc strpool.c(3): alloc 6 bytes at ADDR_604
memalloc strpool.c(2): alloc 36 bytes at ADDR_605
memalloc strpool.c(3): alloc 6 bytes at ADDR_606
memalloc strpool.c(2): alloc 36 bytes at ADDR_607
memalloc strpool.c(3): alloc 6 bytes at ADDR_608
memalloc strpool.c(2): alloc 36 bytes at ADDR_609
memalloc strpool.c(3): alloc 6 bytes at ADDR_610
memalloc strpool.c(2): alloc 36 bytes at ADDR_611
memalloc strpool.c(3): alloc 6 bytes at ADDR_612
memalloc strpool.c(2): alloc 36 bytes at ADDR_613
memalloc strpool.c(3): alloc 6 bytes at ADDR_614
memalloc strpool.c(2): alloc 36 bytes at ADDR_615
memalloc strpool.c(3): alloc 6 bytes at ADDR_616
memalloc strpool.c(2): alloc 36 bytes at ADDR_617
memalloc strpool.c(3): alloc 6 bytes at ADDR_618
memalloc strpool.c(2): alloc 36 bytes at ADDR_619
memalloc strpool.c(3): alloc 6 bytes at ADDR_620
memalloc strpool.c(2): alloc 36 bytes at ADDR_621
memalloc strpool.c(3): alloc 6 bytes at ADDR_622
memalloc strpool.c(2): alloc 36 bytes at ADDR_623
memalloc strpool.c(3): alloc 6 bytes at ADDR_624
memalloc strpool.c(2): alloc 36 bytes at ADDR_625
memalloc strpool.c(3): alloc 6 bytes at ADDR_626
memalloc strpool.c(2): alloc 36 bytes at ADDR_627
memalloc strpool.c(3): alloc 6 bytes at ADDR_628
memalloc strpool.c(2): alloc 36 bytes at ADDR_629
memalloc strpool.c(3): alloc 6 bytes at ADDR_630
memalloc strpool.c(2): alloc 36 bytes at ADDR_631
memalloc strpool.c(3): alloc 6 bytes at ADDR_632
memalloc strpool.c(2): alloc 36 bytes at ADDR_633
memalloc strpool.c(3): alloc 6 bytes at ADDR_634
memalloc strpool.c(2): alloc 36 bytes at ADDR_635
memalloc strpool.c(3): alloc 6 bytes at ADDR_636
memalloc strpool.c(2): alloc 36 bytes at ADDR_637
memalloc strpool.c(3): alloc 6 bytes at ADDR_638
memalloc strpool.c(2): alloc 36 bytes at ADDR_639
memalloc strpool.c(3): alloc 6 bytes at ADDR_640
memalloc strpool.c(2): alloc 36 bytes at ADDR_641
memalloc strpool.c(3): alloc 6 bytes at ADDR_642
memalloc strpool.c(2): alloc 36 bytes at ADDR_643
memalloc strpool.c(3): alloc 6 bytes at ADDR_644
memalloc strpool.c(2): alloc 36 bytes at ADDR_645
memalloc strpool.c(3): alloc 6 bytes at ADDR_646
memalloc strpool.c(2): alloc 36 bytes at ADDR_647
memalloc strpool.c(3): alloc 6 bytes at ADDR_648
memalloc strpool.c(2): alloc 36 bytes at ADDR_649
memalloc strpool.c(3): alloc 6 bytes at ADDR_650
memalloc strpool.c(2): alloc 36 bytes at ADDR_651
memalloc strpool.c(3): alloc 6 bytes at ADDR_652
memalloc strpool.c(2): alloc 36 bytes at ADDR_653
memalloc strpool.c(3): alloc 6 bytes at ADDR_654
memalloc strpool.c(2): alloc 36 bytes at ADDR_655
memalloc strpool.c(3): alloc 6 bytes at ADDR_656
memalloc strpool.c(2): alloc 36 bytes at ADDR_657
memalloc strpool.c(3): alloc 6 bytes at ADDR_658
memalloc strpool.c(2): alloc 36 bytes at ADDR_659
memalloc strpool.c(3): alloc 6 bytes at ADDR_660
memalloc strpool.c(2): alloc 36 bytes at ADDR_661
memalloc strpool.c(3): alloc 6 bytes at ADDR_662
memalloc strpool.c(2): alloc 36 bytes at ADDR_663
memalloc strpool.c(3): alloc 6 bytes at ADDR_664
memalloc strpool.c(2): alloc 36 bytes at ADDR_665
memalloc strpool.c(3): alloc 6 bytes at ADDR_666
memalloc strpool.c(2): alloc 36 bytes at ADDR_667
memalloc strpool.c(3): alloc 6 bytes at ADDR_668
memalloc strpool.c(2): alloc 36 bytes at ADDR_669
memalloc strpool.c(3): alloc 6 bytes at ADDR_670
memalloc strpool.c(2): alloc 36 bytes at ADDR_671
memalloc strpool.c(3): alloc 6 bytes at ADDR_672
memalloc strpool.c(2): alloc 36 bytes at ADDR_673
memalloc strpool.c(3): alloc 6 bytes at ADDR_674
memalloc strpool.c(2): alloc 36 bytes at ADDR_675
memalloc strpool.c(3): alloc 6 bytes at ADDR_676
memalloc strpool.c(2): alloc 36 bytes at ADDR_677
memalloc strpool.c(3): alloc 6 bytes at ADDR_678
memalloc strpool.c(2): alloc 36 bytes at ADDR_679
memalloc strpool.c(3): alloc 6 bytes at ADDR_680
memalloc strpool.c(2): alloc 36 bytes at ADDR_681
memalloc strpool.c(3): alloc 6 bytes at ADDR_682
memalloc strpool.c(2): alloc 36 bytes at ADDR_683
memalloc strpool.c(3): alloc 6 bytes at ADDR_684
memalloc strpool.c(2): alloc 36 bytes at ADDR_685
memalloc strpool.c(3): alloc 6 bytes at ADDR_686
memalloc strpool.c(2): alloc 36 bytes at ADDR_687
memalloc strpool.c(3): alloc 6 bytes at ADDR_688
memalloc strpool.c(2): alloc 36 bytes at ADDR_689
memalloc strpool.c(3): alloc 6 bytes at ADDR_690
memalloc strpool.c(2): alloc 36 bytes at ADDR_691
memalloc strpool.c(3): alloc 6 bytes at ADDR_692
memalloc strpool.c(2): alloc 36 bytes at ADDR_693
memalloc strpool.c(3): alloc 6 bytes at ADDR_694
memalloc strpool.c(2): alloc 36 bytes at ADDR_695
memalloc strpool.c(3): alloc 6 bytes at ADDR_696
memalloc strpool.c(2): alloc 36 bytes at ADDR_697
memalloc strpool.c(3): alloc 6 bytes at ADDR_698
memalloc strpool.c(2): alloc 36 bytes at ADDR_699
memalloc strpool.c(3): alloc 6 bytes at ADDR_700
memalloc strpool.c(2): alloc 36 bytes at ADDR_701
memalloc strpool.c(3): alloc 6 bytes at ADDR_702
memalloc strpool.c(2): alloc 36 bytes at ADDR_703
memalloc strpool.c(3): alloc 6 bytes at ADDR_704
memalloc strpool.c(2): alloc 36 bytes at ADDR_705
memalloc strpool.c(3): alloc 6 bytes at ADDR_706
second run - check that pool did not move
check NULL case
class: cleanup
class strpool.c(1): delete class StrPool at ADDR_1 created at strpool.c(1)
memalloc strpool.c(6): free 2 bytes at ADDR_3 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_2 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_7 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_6 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_9 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_8 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_11 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_10 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_13 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_12 allocated at strpool.c(2)
memalloc strpool.c(6): free 2 bytes at ADDR_15 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_14 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_17 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_16 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_19 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_18 allocated at strpool.c(2)
memalloc strpool.c(6): free 2 bytes at ADDR_21 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_20 allocated at strpool.c(2)
memalloc strpool.c(6): free 5 bytes at ADDR_23 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_22 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_25 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_24 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_27 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_26 allocated at strpool.c(2)
memalloc strpool.c(6): free 5 bytes at ADDR_29 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_28 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_31 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_30 allocated at strpool.c(2)
memalloc strpool.c(6): free 2 bytes at ADDR_33 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_32 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_35 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_34 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_37 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_36 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_39 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_38 allocated at strpool.c(2)
memalloc strpool.c(6): free 5 bytes at ADDR_41 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_40 allocated at strpool.c(2)
memalloc strpool.c(6): free 5 bytes at ADDR_43 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_42 allocated at strpool.c(2)
memalloc strpool.c(6): free 5 bytes at ADDR_45 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_44 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_47 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_46 allocated at strpool.c(2)
memalloc strpool.c(6): free 5 bytes at ADDR_49 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_48 allocated at strpool.c(2)
memalloc strpool.c(6): free 2 bytes at ADDR_51 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_50 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_53 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_52 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_55 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_54 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_57 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_56 allocated at strpool.c(2)
memalloc strpool.c(6): free 2 bytes at ADDR_59 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_58 allocated at strpool.c(2)
memalloc strpool.c(6): free 5 bytes at ADDR_61 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_60 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_63 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_62 allocated at strpool.c(2)
memalloc strpool.c(6): free 2 bytes at ADDR_65 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_64 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_67 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_66 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_69 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_68 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_71 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_70 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_73 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_72 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_75 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_74 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_77 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_76 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_79 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_78 allocated at strpool.c(2)
memalloc strpool.c(6): free 2 bytes at ADDR_81 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_80 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_83 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_82 allocated at strpool.c(2)
memalloc strpool.c(6): free 5 bytes at ADDR_85 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_84 allocated at strpool.c(2)
memalloc strpool.c(6): free 5 bytes at ADDR_87 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_86 allocated at strpool.c(2)
memalloc strpool.c(6): free 2 bytes at ADDR_89 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_88 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_91 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_90 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_93 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_92 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_95 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_94 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_97 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_96 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_99 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_98 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_101 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_100 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_103 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_102 allocated at strpool.c(2)
memalloc strpool.c(6): free 2 bytes at ADDR_105 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_104 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_107 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_106 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_109 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_108 allocated at strpool.c(2)
memalloc strpool.c(6): free 5 bytes at ADDR_111 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_110 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_113 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_112 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_115 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_114 allocated at strpool.c(2)
memalloc strpool.c(6): free 5 bytes at ADDR_117 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_116 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_119 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_118 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_121 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_120 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_123 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_122 allocated at strpool.c(2)
memalloc strpool.c(6): free 5 bytes at ADDR_125 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_124 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_127 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_126 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_129 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_128 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_131 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_130 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_133 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_132 allocated at strpool.c(2)
memalloc strpool.c(6): free 5 bytes at ADDR_135 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_134 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_137 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_136 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_139 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_138 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_141 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_140 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_143 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_142 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_145 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_144 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_147 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_146 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_149 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_148 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_151 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_150 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_153 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_152 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_155 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_154 allocated at strpool.c(2)
memalloc strpool.c(6): free 2 bytes at ADDR_157 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_156 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_159 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_158 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_161 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_160 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_163 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_162 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_165 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_164 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_167 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_166 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_169 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_168 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_171 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_170 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_173 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_172 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_175 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_174 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_177 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_176 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_179 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_178 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_181 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_180 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_183 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_182 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_185 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_184 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_187 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_186 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_189 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_188 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_191 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_190 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_193 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_192 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_195 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_194 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_197 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_196 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_199 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_198 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_201 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_200 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_203 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_202 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_205 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_204 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_207 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_206 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_209 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_208 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_211 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_210 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_213 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_212 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_215 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_214 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_217 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_216 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_219 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_218 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_221 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_220 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_223 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_222 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_225 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_224 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_227 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_226 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_229 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_228 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_231 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_230 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_233 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_232 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_235 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_234 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_237 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_236 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_239 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_238 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_241 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_240 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_243 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_242 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_245 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_244 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_247 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_246 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_249 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_248 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_251 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_250 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_253 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_252 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_255 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_254 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_257 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_256 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_259 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_258 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_261 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_260 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_263 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_262 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_265 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_264 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_267 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_266 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_269 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_268 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_271 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_270 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_273 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_272 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_275 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_274 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_277 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_276 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_279 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_278 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_281 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_280 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_283 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_282 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_285 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_284 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_287 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_286 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_289 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_288 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_291 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_290 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_293 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_292 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_295 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_294 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_297 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_296 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_299 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_298 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_301 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_300 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_303 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_302 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_305 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_304 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_307 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_306 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_309 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_308 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_311 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_310 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_313 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_312 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_315 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_314 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_317 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_316 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_319 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_318 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_321 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_320 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_323 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_322 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_325 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_324 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_327 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_326 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_329 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_328 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_331 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_330 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_333 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_332 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_335 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_334 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_338 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_337 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_340 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_339 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_342 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_341 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_344 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_343 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_346 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_345 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_348 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_347 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_350 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_349 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_352 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_351 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_354 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_353 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_356 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_355 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_358 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_357 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_360 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_359 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_362 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_361 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_364 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_363 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_366 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_365 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_368 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_367 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_370 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_369 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_372 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_371 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_374 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_373 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_376 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_375 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_378 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_377 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_380 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_379 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_382 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_381 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_384 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_383 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_386 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_385 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_388 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_387 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_390 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_389 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_392 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_391 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_394 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_393 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_396 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_395 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_398 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_397 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_400 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_399 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_402 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_401 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_404 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_403 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_406 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_405 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_408 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_407 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_410 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_409 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_412 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_411 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_414 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_413 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_416 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_415 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_418 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_417 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_420 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_419 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_422 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_421 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_424 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_423 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_426 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_425 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_428 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_427 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_430 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_429 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_432 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_431 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_434 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_433 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_436 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_435 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_438 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_437 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_440 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_439 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_442 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_441 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_444 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_443 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_446 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_445 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_448 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_447 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_450 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_449 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_452 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_451 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_454 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_453 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_456 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_455 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_458 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_457 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_460 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_459 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_462 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_461 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_464 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_463 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_466 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_465 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_468 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_467 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_470 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_469 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_472 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_471 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_474 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_473 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_476 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_475 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_478 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_477 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_480 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_479 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_482 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_481 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_484 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_483 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_486 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_485 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_488 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_487 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_490 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_489 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_492 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_491 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_494 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_493 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_496 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_495 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_498 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_497 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_500 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_499 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_502 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_501 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_504 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_503 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_506 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_505 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_508 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_507 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_510 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_509 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_512 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_511 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_514 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_513 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_516 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_515 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_518 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_517 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_520 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_519 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_522 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_521 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_524 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_523 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_526 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_525 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_528 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_527 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_530 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_529 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_532 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_531 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_534 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_533 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_536 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_535 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_538 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_537 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_540 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_539 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_542 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_541 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_544 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_543 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_546 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_545 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_548 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_547 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_550 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_549 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_552 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_551 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_554 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_553 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_556 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_555 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_558 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_557 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_560 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_559 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_562 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_561 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_564 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_563 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_566 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_565 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_568 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_567 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_570 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_569 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_572 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_571 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_574 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_573 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_576 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_575 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_578 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_577 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_580 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_579 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_582 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_581 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_584 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_583 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_586 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_585 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_588 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_587 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_590 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_589 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_592 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_591 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_594 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_593 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_596 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_595 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_598 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_597 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_600 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_599 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_602 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_601 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_604 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_603 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_606 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_605 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_608 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_607 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_610 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_609 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_612 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_611 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_614 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_613 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_616 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_615 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_618 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_617 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_620 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_619 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_622 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_621 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_624 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_623 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_626 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_625 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_628 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_627 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_630 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_629 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_632 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_631 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_634 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_633 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_636 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_635 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_638 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_637 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_640 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_639 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_642 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_641 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_644 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_643 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_646 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_645 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_648 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_647 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_650 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_649 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_652 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_651 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_654 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_653 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_656 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_655 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_658 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_657 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_660 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_659 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_662 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_661 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_664 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_663 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_666 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_665 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_668 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_667 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_670 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_669 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_672 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_671 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_674 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_673 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_676 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_675 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_678 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_677 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_680 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_679 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_682 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_681 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_684 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_683 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_686 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_685 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_688 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_687 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_690 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_689 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_692 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_691 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_694 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_693 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_696 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_695 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_698 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_697 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_700 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_699 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_702 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_701 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_704 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_703 allocated at strpool.c(2)
memalloc strpool.c(5): free 768 bytes at ADDR_336 allocated at strpool.c(4)
memalloc strpool.c(5): free 44 bytes at ADDR_4 allocated at strpool.c(4)
memalloc strpool.c(6): free 6 bytes at ADDR_706 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_705 allocated at strpool.c(2)
memalloc strpool.c(1): free 32 bytes at ADDR_1 allocated at strpool.c(1)
memalloc: cleanup
ERR


unlink_testfiles();
done_testing;
