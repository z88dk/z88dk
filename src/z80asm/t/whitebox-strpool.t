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
#
# Test strpool

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

# test strpool
my $objs = "strpool.o die.o strutil.o safestr.o except.o init.o errors.o file.o strlist.o";
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

t_run_module([], <<OUT, <<END, 0);
GLib Memory statistics (successful operations):
 blocks of | allocated  | freed      | allocated  | freed      | n_bytes   
  n_bytes  | n_times by | n_times by | n_times by | n_times by | remaining 
           | malloc()   | free()     | realloc()  | realloc()  |           
===========|============|============|============|============|===========
        20 |          1 |          1 |          0 |          0 |         +0
        96 |          3 |          3 |          0 |          0 |         +0
       252 |          3 |          0 |          0 |          0 |       +756
       384 |          1 |          1 |          0 |          0 |         +0
       768 |          1 |          1 |          0 |          0 |         +0
      1016 |          1 |          0 |          0 |          0 |      +1016
      1024 |          2 |          2 |          0 |          0 |         +0
      1536 |          1 |          1 |          0 |          0 |         +0
      3072 |          1 |          1 |          0 |          0 |         +0
   >  4096 |          1 |          1 |          0 |          0 |        ***
GLib Memory statistics (failing operations):
 --- none ---
Total bytes: allocated=16032, zero-initialized=13964 (87.10%), freed=14260 (88.95%), remaining=1772
OUT
first run - create pool for all strings
second run - check that pool did not move
check NULL case
END

unlink_testfiles();
done_testing;


__END__
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-strpool.t,v 1.9 2013-09-08 00:43:59 pauloscustodio Exp $
# $Log: whitebox-strpool.t,v $
# Revision 1.9  2013-09-08 00:43:59  pauloscustodio
# New error module with one error function per error, no need for the error
# constants. Allows compiler to type-check error message arguments.
# Included the errors module in the init() mechanism, no need to call
# error initialization from main(). Moved all error-testing scripts to
# one file errors.t.
#
# Revision 1.8  2013/09/01 16:51:26  pauloscustodio
# Replaced strpool code by GLib String Chunks.
#
# Revision 1.7  2013/09/01 11:52:56  pauloscustodio
# Setup memalloc on init.c.
# Setup GLib memory allocation functions to use memalloc functions.
#
# Revision 1.6  2013/03/30 00:00:26  pauloscustodio
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

