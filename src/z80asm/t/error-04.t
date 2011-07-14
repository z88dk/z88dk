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
# Copyright (C) Paulo Custodio, 2011

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/error-04.t,v 1.2 2011-07-14 01:32:09 pauloscustodio Exp $
# $Log: error-04.t,v $
# Revision 1.2  2011-07-14 01:32:09  pauloscustodio
#     - Unified "Integer out of range" and "Out of range" errors; they are the same error.
#     - Unified ReportIOError as ReportError(ERR_FILE_OPEN)
#     CH_0003 : Error messages should be more informative
#         - Added printf-args to error messages, added "Error:" prefix.
#     BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
#         - Raise ERR_UNBALANCED_PAREN instead
#
# Revision 1.1  2011/07/12 22:47:59  pauloscustodio
# - Moved all error variables and error reporting code to a separate module errors.c,
#   replaced all extern declarations of these variables by include errors.h,
#   created symbolic constants for error codes.
# - Added test scripts for error messages.
#
#
#
# Test error 4

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

# Integer out of range (pass 1)
t_z80asm_error("ld a,-129",	"Error: File 'test.asm', at line 1, Integer '-129' out of range");
t_z80asm_ok(0, "ld a,-128", 	"\x3E\x80");
t_z80asm_ok(0, "ld a,255", 	"\x3E\xFF");
t_z80asm_error("ld a,256", 	"Error: File 'test.asm', at line 1, Integer '256' out of range");

t_z80asm_error("ld bc,-32769", 	"Error: File 'test.asm', at line 1, Integer '-32769' out of range");
t_z80asm_ok(0, "ld bc,-32768", 	"\x01\x00\x80");
t_z80asm_ok(0, "ld bc,65535", 	"\x01\xFF\xFF");
t_z80asm_error("ld bc,65536", 	"Error: File 'test.asm', at line 1, Integer '65536' out of range");

# Integer out of range (pass 2)
t_z80asm_error("ld a,N \n defc N = -129", 	
				"Error: File 'test.asm', Module 'TEST', at line 1, Integer '-129' out of range");
t_z80asm_ok(0, "ld a,N \n defc N = -128", 	"\x3E\x80");
t_z80asm_ok(0, "ld a,N \n defc N = 255", 	"\x3E\xFF");
t_z80asm_error("ld a,N \n defc N = 256",	
				"Error: File 'test.asm', Module 'TEST', at line 1, Integer '256' out of range");

t_z80asm_error("ld bc,N \n defc N = -32769", 	
				"Error: File 'test.asm', Module 'TEST', at line 1, Integer '-32769' out of range");
t_z80asm_ok(0, "ld bc,N \n defc N = -32768", 	"\x01\x00\x80");
t_z80asm_ok(0, "ld bc,N \n defc N = 65535", 	"\x01\xFF\xFF");
t_z80asm_error("ld bc,N \n defc N = 65536", 	
				"Error: File 'test.asm', Module 'TEST', at line 1, Integer '65536' out of range");

# index register offset
t_z80asm_error("ld (ix-129),-1", "Error: File 'test.asm', at line 1, Integer '-129' out of range");
t_z80asm_ok(0, "ld (ix-128),-1", "\xDD\x36\x80\xFF");
t_z80asm_ok(0, "ld (ix+255),-1", "\xDD\x36\xFF\xFF");
t_z80asm_error("ld (ix+256),-1", "Error: File 'test.asm', at line 1, Integer '256' out of range");

t_z80asm_error("ld (ix+value),-1 \n defc value = -129", 
				"Error: File 'test.asm', Module 'TEST', at line 1, Integer '-129' out of range");
t_z80asm_ok(0, "ld (ix+value),-1 \n defc value = -128", "\xDD\x36\x80\xFF");
t_z80asm_ok(0, "ld (ix+value),-1 \n defc value =  255", "\xDD\x36\xFF\xFF");
t_z80asm_error("ld (ix+value),-1 \n defc value =  256", 
				"Error: File 'test.asm', Module 'TEST', at line 1, Integer '256' out of range");

# 32-bit arithmetic, long range is not tested on a 32bit long
t_z80asm_ok(0, "defl 0xFFFFFFFF+1", "\0\0\0\0");

# call out of range
t_z80asm_error("call -32769", 	"Error: File 'test.asm', at line 1, Integer '-32769' out of range");
t_z80asm_ok(0, "call -32768", 	"\xCD\x00\x80");
t_z80asm_ok(0, "call 65535", 	"\xCD\xFF\xFF");
t_z80asm_error("call 65536", 	"Error: File 'test.asm', at line 1, Integer '65536' out of range");

# RST out of range
for ([0x00 => 0xC7], [0x08 => 0xCF], [0x10 => 0xD7], [0x18 => 0xDF], 
     [0x20 => 0xE7], [0x28 => 0xEF], [0x30 => 0xF7], [0x38 => 0xFF]) {
    my($rst, $opcode) = @$_;
    t_z80asm_error("rst ".($rst-1), "Error: File 'test.asm', at line 1, Integer '".($rst-1)."' out of range");
    t_z80asm_ok(0, "rst $rst", chr($opcode));
    t_z80asm_error("rst ".($rst+1), "Error: File 'test.asm', at line 1, Integer '".($rst+1)."' out of range");
}

# bit out of range
t_z80asm_error("bit -1,a", 	"Error: File 'test.asm', at line 1, Integer '-1' out of range");
t_z80asm_ok(0, "bit 0,a",	"\xCB\x47");
t_z80asm_ok(0, "bit 7,a",	"\xCB\x7F");
t_z80asm_error("bit 8,a", 	"Error: File 'test.asm', at line 1, Integer '8' out of range");

# defvar out of range
t_z80asm_ok(0, "
	defvars 0
	{
	    s1  ds.b 1
	    s2  ds.b 65536
	    s3  ds.b 1
	}
	defl s1, s2, s3
	", "\0\0\0\0"."\1\0\0\0"."\1\0\1\0");
t_z80asm_error("
	defvars 0
	{
	    s1  ds.b 0
	}
	", "Error: File 'test.asm', at line 4, Integer '0' out of range");
t_z80asm_error("
	defvars 0
	{
	    s1  ds.b 65537
	}
	", "Error: File 'test.asm', at line 4, Integer '65537' out of range");

# defs out of range
t_z80asm_error("defs -1", 	"Error: File 'test.asm', at line 1, Integer '-1' out of range");
t_z80asm_ok(0, "defs 0",	"");
t_z80asm_ok(0, "defs 1",	"\x00");
t_z80asm_ok(0, "defs 1, 0xAA",	"\xAA");
t_z80asm_ok(0, "defs 65536",	"\x00" x 65536);
t_z80asm_ok(0, "defs 65536,0xAA", "\xAA" x 65536);
t_z80asm_error("defs 65537", 	"Error: File 'test.asm', at line 1, Max. code size of 65536 bytes reached");

# org out of range
t_z80asm_error("org -1", 	"Error: File 'test.asm', at line 1, Integer '-1' out of range");
t_z80asm_ok(0, "org 0",		"");
t_z80asm_ok(0, "org 65534",	"");
# t_z80asm_ok(0, "org 65535",	""); # NOTE: 0xFFFF is used as a marker for ORG not defined
t_z80asm_error("org 65536", 	"Error: File 'test.asm', at line 1, Integer '65536' out of range");


# link phase
my $asm2 = asm_file(); $asm2 =~ s/\.asm$/2.asm/i;
my $obj2 = obj_file(); $obj2 =~ s/\.obj$/2.obj/i;
my $sym2 = sym_file(); $sym2 =~ s/\.sym$/2.sym/i;

SKIP: {
    diag "This test should not fail, BUG in z80asm"; 
    skip "This test should not fail, BUG in z80asm", 1; 
unlink_testfiles($asm2, $obj2, $sym2);
write_file($asm2, 	"xdef value \n defc value = -129");
write_file(asm_file(), 	"xref value \n ld a,value");
t_z80asm_capture("-b -r0 ".asm_file()." ".$asm2, "", 
		"Error: File 'test.asm', Module 'TEST', at line 1, Integer '-129' out of range\n".
		"1 errors occurred during assembly\n", 
		1);
};

SKIP: {
    diag "This test should not fail, BUG in z80asm"; 
    skip "This test should not fail, BUG in z80asm", 1; 
unlink_testfiles($asm2, $obj2, $sym2);
write_file($asm2, 	"xdef value \n defc value = 0");
write_file(asm_file(), 	"xref value \n ld a,value-129");
t_z80asm_capture("-b -r0 ".asm_file()." ".$asm2, "", 
		"Error: File 'test.asm', Module 'TEST', at line 1, Integer '-129' out of range\n".
		"1 errors occurred during assembly\n", 
		1);
};

unlink_testfiles($asm2, $obj2, $sym2);
write_file($asm2, 	"xdef value \n defc value = -128");
write_file(asm_file(), 	"xref value \n ld a,value");
t_z80asm_capture("-b -r0 ".asm_file()." ".$asm2, "", "", 0);
t_binary(read_file(bin_file(), binary => ':raw'), "\x3E\x80");

SKIP: {
    diag "This test should not fail, BUG in z80asm"; 
    skip "This test should not fail, BUG in z80asm", 1; 
unlink_testfiles($asm2, $obj2, $sym2);
write_file($asm2, 	"xdef value \n defc value = 0");
write_file(asm_file(), 	"xref value \n ld a,value-128");
t_z80asm_capture("-b -r0 ".asm_file()." ".$asm2, "", "", 0);
t_binary(read_file(bin_file(), binary => ':raw'), "\x3E\x80");
};

unlink_testfiles($asm2, $obj2, $sym2);
write_file($asm2, 	"xdef value \n defc value = 255");
write_file(asm_file(), 	"xref value \n ld a,value");
t_z80asm_capture("-b -r0 ".asm_file()." ".$asm2, "", "", 0);
t_binary(read_file(bin_file(), binary => ':raw'), "\x3E\xFF");

SKIP: {
    diag "This test should not fail, BUG in z80asm"; 
    skip "This test should not fail, BUG in z80asm", 1; 
unlink_testfiles($asm2, $obj2, $sym2);
write_file($asm2, 	"xdef value \n defc value = 0");
write_file(asm_file(), 	"xref value \n ld a,value+255");
t_z80asm_capture("-b -r0 ".asm_file()." ".$asm2, "", "", 0);
t_binary(read_file(bin_file(), binary => ':raw'), "\x3E\xFF");
};

SKIP: {
    diag "This test should not fail, BUG in z80asm"; 
    skip "This test should not fail, BUG in z80asm", 1; 
unlink_testfiles($asm2, $obj2, $sym2);
write_file($asm2, 	"xdef value \n defc value = 256");
write_file(asm_file(), 	"xref value \n ld a,value");
t_z80asm_capture("-b -r0 ".asm_file()." ".$asm2, "", 
		"Error: File 'test.asm', Module 'TEST', at line 1, Integer '256' out of range\n".
		"1 errors occurred during assembly\n", 
		1);
};

SKIP: {
    diag "This test should not fail, BUG in z80asm"; 
    skip "This test should not fail, BUG in z80asm", 1; 
unlink_testfiles($asm2, $obj2, $sym2);
write_file($asm2, 	"xdef value \n defc value = 0");
write_file(asm_file(), 	"xref value \n ld a,value+256");
t_z80asm_capture("-b -r0 ".asm_file()." ".$asm2, "", 
		"Error: File 'test.asm', Module 'TEST', at line 1, Integer '256' out of range\n".
		"1 errors occurred during assembly\n", 
		1);
};

unlink_testfiles($asm2, $obj2, $sym2);
write_file($asm2, 	"xdef value \n defc value = -32769");
write_file(asm_file(), 	"xref value \n ld bc,value");
t_z80asm_capture("-b -r0 ".asm_file()." ".$asm2, "", 
		"Error: File 'test.asm', Module 'TEST', Integer '-32769' out of range\n".
		"1 errors occurred during assembly\n", 
		1);

SKIP: {
    diag "This test should not fail, BUG in z80asm"; 
    skip "This test should not fail, BUG in z80asm", 1; 
unlink_testfiles($asm2, $obj2, $sym2);
write_file($asm2, 	"xdef value \n defc value = 0");
write_file(asm_file(), 	"xref value \n ld bc,value-32769");
t_z80asm_capture("-b -r0 ".asm_file()." ".$asm2, "", 
		"Error: File 'test.asm', Module 'TEST', Integer '-32769' out of range\n".
		"1 errors occurred during assembly\n", 
		1);
};

unlink_testfiles($asm2, $obj2, $sym2);
write_file($asm2, 	"xdef value \n defc value = -32768");
write_file(asm_file(), 	"xref value \n ld bc,value");
t_z80asm_capture("-b -r0 ".asm_file()." ".$asm2, "", "", 0);
t_binary(read_file(bin_file(), binary => ':raw'), "\x01\x00\x80");

SKIP: {
    diag "This test should not fail, BUG in z80asm"; 
    skip "This test should not fail, BUG in z80asm", 1; 
unlink_testfiles($asm2, $obj2, $sym2);
write_file($asm2, 	"xdef value \n defc value = 0");
write_file(asm_file(), 	"xref value \n ld bc,value-32768");
t_z80asm_capture("-b -r0 ".asm_file()." ".$asm2, "", "", 0);
t_binary(read_file(bin_file(), binary => ':raw'), "\x01\x00\x80");
};

unlink_testfiles($asm2, $obj2, $sym2);
write_file($asm2, 	"xdef value \n defc value = 65535");
write_file(asm_file(), 	"xref value \n ld bc,value");
t_z80asm_capture("-b -r0 ".asm_file()." ".$asm2, "", "", 0);
t_binary(read_file(bin_file(), binary => ':raw'), "\x01\xFF\xFF");

SKIP: {
    diag "This test should not fail, BUG in z80asm"; 
    skip "This test should not fail, BUG in z80asm", 1; 
unlink_testfiles($asm2, $obj2, $sym2);
write_file($asm2, 	"xdef value \n defc value = 0");
write_file(asm_file(), 	"xref value \n ld bc,value+65535");
t_z80asm_capture("-b -r0 ".asm_file()." ".$asm2, "", "", 0);
t_binary(read_file(bin_file(), binary => ':raw'), "\x01\xFF\xFF");
};

unlink_testfiles($asm2, $obj2, $sym2);
write_file($asm2, 	"xdef value \n defc value = 65536");
write_file(asm_file(), 	"xref value \n ld bc,value");
t_z80asm_capture("-b -r0 ".asm_file()." ".$asm2, "", 
		"Error: File 'test.asm', Module 'TEST', Integer '65536' out of range\n".
		"1 errors occurred during assembly\n", 
		1);

SKIP: {
    diag "This test should not fail, BUG in z80asm"; 
    skip "This test should not fail, BUG in z80asm", 1; 
unlink_testfiles($asm2, $obj2, $sym2);
write_file($asm2, 	"xdef value \n defc value = 0");
write_file(asm_file(), 	"xref value \n ld bc,value+65536");
t_z80asm_capture("-b -r0 ".asm_file()." ".$asm2, "", 
		"Error: File 'test.asm', Module 'TEST', Integer '65536' out of range\n".
		"1 errors occurred during assembly\n", 
		1);
}

# JR
t_z80asm_error("jr asmpc+2-129", "Error: File 'test.asm', at line 1, Integer '-129' out of range");
t_z80asm_ok(100, "jr asmpc+2-128", "\x18\x80");
t_z80asm_ok(100, "jr asmpc+2+127", "\x18\x7F");
t_z80asm_error("jr asmpc+2+128", "Error: File 'test.asm', at line 1, Integer '128' out of range");

# DJNZ
t_z80asm_error("djnz asmpc+2-129", "Error: File 'test.asm', at line 1, Integer '-129' out of range");
t_z80asm_ok(100, "djnz asmpc+2-128", "\x10\x80");
t_z80asm_ok(100, "djnz asmpc+2+127", "\x10\x7F");
t_z80asm_error("djnz asmpc+2+128", "Error: File 'test.asm', at line 1, Integer '128' out of range");

# JR pass2
t_z80asm_error("jr label \n defc label = asmpc-129", 
		"Error: File 'test.asm', Module 'TEST', at line 1, Integer '-129' out of range");
t_z80asm_ok(100, "jr label \n defc label = asmpc-128", "\x18\x80");
t_z80asm_ok(100, "jr label \n defc label = asmpc+127", "\x18\x7F");
t_z80asm_error("jr label \n defc label = asmpc+128", 
		"Error: File 'test.asm', Module 'TEST', at line 1, Integer '128' out of range");

# DJNZ pass2
t_z80asm_error("djnz label \n defc label = asmpc-129", 
		"Error: File 'test.asm', Module 'TEST', at line 1, Integer '-129' out of range");
t_z80asm_ok(100, "djnz label \n defc label = asmpc-128", "\x10\x80");
t_z80asm_ok(100, "djnz label \n defc label = asmpc+127", "\x10\x7F");
t_z80asm_error("djnz label \n defc label = asmpc+128", 
		"Error: File 'test.asm', Module 'TEST', at line 1, Integer '128' out of range");


unlink_testfiles($asm2, $obj2, $sym2);
done_testing();
