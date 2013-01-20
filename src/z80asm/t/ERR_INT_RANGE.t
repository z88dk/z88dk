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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/ERR_INT_RANGE.t,v 1.4 2013-01-20 13:18:10 pauloscustodio Exp $
# $Log: ERR_INT_RANGE.t,v $
# Revision 1.4  2013-01-20 13:18:10  pauloscustodio
# BUG_0024 : (ix+128) should show warning message
# Signed integer range was wrongly checked to -128..255 instead
# of -128..127
#
# Revision 1.3  2013/01/14 00:29:37  pauloscustodio
# CH_0015 : integer out of range error replaced by warning
#
# Revision 1.2  2012/05/26 18:51:10  pauloscustodio
# CH_0012 : wrappers on OS calls to raise fatal error
# CH_0013 : new errors interface to decouple calling code from errors.c
#
# Revision 1.1  2012/05/23 18:07:51  pauloscustodio
# Unlink test files for errors from error numbers, to be able to change
# error numbers.
#
# Revision 1.3  2011/07/14 23:49:50  pauloscustodio
#     BUG_0001(a) : during correction of BUG_0001, new symbol colon was introduced in enum symbols,
# 	causing expressions stored in object files to be wrong, e.g. VALUE-1 was stored as
# 	VALUE*1. This caused problems in expression evaluation in link phase.
#
# Revision 1.2  2011/07/14 01:32:09  pauloscustodio
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

# Byte = -129
t_z80asm(
	asm		=> "ld a,-129",
	bin		=> "\x3E\x7F",
	err		=> "Warning at file 'test.asm' line 1: Integer '-129' out of range",
);

t_z80asm(
	asm  	=> "ld a,N : defc N = -129",
	bin		=> "\x3E\x7F",
	err		=> "Warning at file 'test.asm' module 'TEST' line 1: Integer '-129' out of range",
);

t_z80asm(
	asm  	=> "xref value : ld a,value",
	asm1	=> "xdef value : defc value = -129",
	bin		=> "\x3E\x7F",
	err		=> "Warning at file 'test.asm' module 'TEST': Integer '-129' out of range in expression 'VALUE'",
);

t_z80asm(
	asm		=> "xdef value : defc value = 0",
	asm1	=> "xref value : ld a,value-129",
	bin		=> "\x3E\x7F",
	err		=> "Warning at file 'test1.asm' module 'TEST1': Integer '-129' out of range in expression 'VALUE-129'",
);

# Byte = -128
t_z80asm(
	asm		=> "ld a,-128",
	bin		=> "\x3E\x80",
);

t_z80asm(
	asm		=> "ld a,N : defc N = -128",
	bin		=> "\x3E\x80",
);

t_z80asm(
	asm 	=> "xref value : ld a,value",
	asm1	=> "xdef value : defc value = -128",
	bin		=> "\x3E\x80",
);

t_z80asm(
	asm 	=> "xref value : ld a,value-128",
	asm1	=> "xdef value : defc value = 0",
	bin		=> "\x3E\x80",
);


# Byte = 255
t_z80asm(
	asm		=> "ld a,255",
	bin		=> "\x3E\xFF",
);

t_z80asm(
	asm		=> "ld a,N : defc N = 255",
	bin		=> "\x3E\xFF",
);

t_z80asm(
	asm 	=> "xref value : ld a,value",
	asm1	=> "xdef value : defc value = 255",
	bin		=> "\x3E\xFF",
);

t_z80asm(
	asm 	=> "xref value : ld a,value+255",
	asm1	=> "xdef value : defc value = 0",
	bin		=> "\x3E\xFF",
);


# Byte = 256
t_z80asm(
	asm		=> "ld a,256",
	bin		=> "\x3E\x00",
	err		=> "Warning at file 'test.asm' line 1: Integer '256' out of range",
);

t_z80asm(
	asm  	=> "ld a,N : defc N = 256",
	bin		=> "\x3E\x00",
	err		=> "Warning at file 'test.asm' module 'TEST' line 1: Integer '256' out of range",
);

t_z80asm(
	asm  	=> "xref value : ld a,value",
	asm1	=> "xdef value : defc value = 256",
	bin		=> "\x3E\x00",
	err		=> "Warning at file 'test.asm' module 'TEST': Integer '256' out of range in expression 'VALUE'",
);

t_z80asm(
	asm		=> "xdef value : defc value = 0",
	asm1	=> "xref value : ld a,value+256",
	bin		=> "\x3E\x00",
	err		=> "Warning at file 'test1.asm' module 'TEST1': Integer '256' out of range in expression 'VALUE+256'",
);


# SignedByte = -129
t_z80asm(
	asm  	=> "ld (ix-129),-1",
	bin		=> "\xDD\x36\x7F\xFF",
	err		=> "Warning at file 'test.asm' line 1: Integer '-129' out of range",
);

t_z80asm(
	asm  	=> "ld (ix+value),-1 : defc value = -129",
	bin		=> "\xDD\x36\x7F\xFF",
	err		=> "Warning at file 'test.asm' module 'TEST' line 1: Integer '-129' out of range",
);

t_z80asm(
	asm  	=> "xref value : ld (ix+value),-1",
	asm1	=> "xdef value : defc value = -129",
	bin		=> "\xDD\x36\x7F\xFF",
	err		=> "Warning at file 'test.asm' module 'TEST': Integer '-129' out of range in expression 'VALUE'",
);

t_z80asm(
	asm		=> "xref value : ld (ix+value-129),-1",
	asm1	=> "xdef value : defc value = 0",
	bin		=> "\xDD\x36\x7F\xFF",
	err		=> "Warning at file 'test.asm' module 'TEST': Integer '-129' out of range in expression 'VALUE-129'",
);


# SignedByte = -128
t_z80asm(
	asm		=> "ld (ix-128),-1",
	bin		=> "\xDD\x36\x80\xFF",
);

t_z80asm(
	asm		=> "ld (ix+value),-1 : defc value = -128",
	bin		=> "\xDD\x36\x80\xFF",
);

t_z80asm(
	asm 	=> "xref value : ld (ix+value),-1",
	asm1	=> "xdef value : defc value = -128",
	bin		=> "\xDD\x36\x80\xFF",
);

t_z80asm(
	asm 	=> "xref value : ld (ix+value-128),-1",
	asm1	=> "xdef value : defc value = 0",
	bin		=> "\xDD\x36\x80\xFF",
);


# SignedByte = 127
t_z80asm(
	asm		=> "ld (ix+127),-1",
	bin		=> "\xDD\x36\x7F\xFF",
);

t_z80asm(
	asm		=> "ld (ix+value),-1 : defc value = 127",
	bin		=> "\xDD\x36\x7F\xFF",
);

t_z80asm(
	asm 	=> "xref value : ld (ix+value),-1",
	asm1	=> "xdef value : defc value = 127",
	bin		=> "\xDD\x36\x7F\xFF",
);

t_z80asm(
	asm 	=> "xref value : ld (ix+value+127),-1",
	asm1	=> "xdef value : defc value = 0",
	bin		=> "\xDD\x36\x7F\xFF",
);


# SignedByte = 128
t_z80asm(
	asm		=> "ld (ix+128),-1",
	bin		=> "\xDD\x36\x80\xFF",
	err		=> "Warning at file 'test.asm' line 1: Integer '128' out of range",
);

t_z80asm(
	asm		=> "ld (ix+value),-1 : defc value = 128",
	bin		=> "\xDD\x36\x80\xFF",
	err		=> "Warning at file 'test.asm' module 'TEST' line 1: Integer '128' out of range",
);

t_z80asm(
	asm 	=> "xref value : ld (ix+value),-1",
	asm1	=> "xdef value : defc value = 128",
	bin		=> "\xDD\x36\x80\xFF",
	err		=> "Warning at file 'test.asm' module 'TEST': Integer '128' out of range in expression 'VALUE'",
);

t_z80asm(
	asm 	=> "xref value : ld (ix+value+128),-1",
	asm1	=> "xdef value : defc value = 0",
	bin		=> "\xDD\x36\x80\xFF",
	err		=> "Warning at file 'test.asm' module 'TEST': Integer '128' out of range in expression 'VALUE+128'",
);


# Word = -32769
t_z80asm(
	asm		=> "ld bc,-32769",
	bin		=> "\x01\xFF\x7F",
	err		=> "Warning at file 'test.asm' line 1: Integer '-32769' out of range",
);

t_z80asm(
	asm		=> "ld bc,N : defc N = -32769",
	bin		=> "\x01\xFF\x7F",
	err		=> "Warning at file 'test.asm' module 'TEST' line 1: Integer '-32769' out of range",
);

t_z80asm(
	asm 	=> "xref value : ld bc,value",
	asm1	=> "xdef value : defc value = -32769",
	bin		=> "\x01\xFF\x7F",
	err		=> "Warning at file 'test.asm' module 'TEST': Integer '-32769' out of range in expression 'VALUE'",
);

t_z80asm(
	asm 	=> "xref value : ld bc,value-32769",
	asm1	=> "xdef value : defc value = 0",
	bin		=> "\x01\xFF\x7F",
	err		=> "Warning at file 'test.asm' module 'TEST': Integer '-32769' out of range in expression 'VALUE-32769'",
);


# Word = -32768
t_z80asm(
	asm		=> "ld bc,-32768",
	bin		=> "\x01\x00\x80",
);

t_z80asm(
	asm		=> "ld bc,N : defc N = -32768",
	bin		=> "\x01\x00\x80",
);

t_z80asm(
	asm 	=> "xref value : ld bc,value",
	asm1	=> "xdef value : defc value = -32768",
	bin		=> "\x01\x00\x80",
);

t_z80asm(
	asm 	=> "xref value : ld bc,value-32768",
	asm1	=> "xdef value : defc value = 0",
	bin		=> "\x01\x00\x80",
);


# Word = 65535
t_z80asm(
	asm		=> "ld bc,65535",
	bin		=> "\x01\xFF\xFF",
);

t_z80asm(
	asm		=> "ld bc,N : defc N = 65535",
	bin		=> "\x01\xFF\xFF",
);

t_z80asm(
	asm 	=> "xref value : ld bc,value",
	asm1	=> "xdef value : defc value = 65535",
	bin		=> "\x01\xFF\xFF",
);

t_z80asm(
	asm 	=> "xref value : ld bc,value+65535",
	asm1	=> "xdef value : defc value = 0",
	bin		=> "\x01\xFF\xFF",
);


# Word = 65536
t_z80asm(
	asm		=> "ld bc,65536",
	bin		=> "\x01\x00\x00",
	err		=> "Warning at file 'test.asm' line 1: Integer '65536' out of range",
);

t_z80asm(
	asm		=> "ld bc,N : defc N = 65536",
	bin		=> "\x01\x00\x00",
	err		=> "Warning at file 'test.asm' module 'TEST' line 1: Integer '65536' out of range",
);

t_z80asm(
	asm 	=> "xref value : ld bc,value",
	asm1	=> "xdef value : defc value = 65536",
	bin		=> "\x01\x00\x00",
	err		=> "Warning at file 'test.asm' module 'TEST': Integer '65536' out of range in expression 'VALUE'",
);

t_z80asm(
	asm 	=> "xref value : ld bc,value+65536",
	asm1	=> "xdef value : defc value = 0",
	bin		=> "\x01\x00\x00",
	err		=> "Warning at file 'test.asm' module 'TEST': Integer '65536' out of range in expression 'VALUE+65536'",
);


# 32-bit arithmetic, long range is not tested on a 32bit long
t_z80asm(
	asm		=> "defl 0xFFFFFFFF+1", 
	bin		=> "\0\0\0\0",
);


# call out of range
t_z80asm(
	asm		=> "call -32769", 
	bin		=> "\xCD\xFF\x7F",
	err		=> "Warning at file 'test.asm' line 1: Integer '-32769' out of range",
);

t_z80asm(
	asm		=> "call -32768", 
	bin		=> "\xCD\x00\x80",
);

t_z80asm(
	asm		=> "call 65536", 
	bin		=> "\xCD\x00\x00",
	err		=> "Warning at file 'test.asm' line 1: Integer '65536' out of range",
);


# RST out of range
for ([0x00 => 0xC7], [0x08 => 0xCF], [0x10 => 0xD7], [0x18 => 0xDF], 
     [0x20 => 0xE7], [0x28 => 0xEF], [0x30 => 0xF7], [0x38 => 0xFF])
{
    my($rst, $opcode) = @$_;
	
    t_z80asm(
		asm		=> "rst ".($rst-1), 
		err		=> "Error at file 'test.asm' line 1: Integer '".($rst-1)."' out of range",
	);
	
    t_z80asm(
		asm		=> "rst $rst", 
		bin		=> chr($opcode),
	);
	
    t_z80asm(
		asm		=> "rst ".($rst+1), 
		err		=> "Error at file 'test.asm' line 1: Integer '".($rst+1)."' out of range",
	);
}


# bit out of range
t_z80asm(
	asm		=> "bit -1,a",
	err		=> "Error at file 'test.asm' line 1: Integer '-1' out of range",
);

t_z80asm(
	asm		=> "bit 0,a",
	bin		=> "\xCB\x47",
);

t_z80asm(
	asm		=> "bit 7,a",
	bin		=> "\xCB\x7F",
);

t_z80asm(
	asm		=> "bit 8,a",
	err		=> "Error at file 'test.asm' line 1: Integer '8' out of range",
);


# defvar out of range
t_z80asm(
	asm		=> "defvars 0
				{
					s1  ds.b 1
					s2  ds.b 65536
					s3  ds.b 1
				}
				defl s1, s2, s3
			   ",
	bin		=> "\0\0\0\0"."\1\0\0\0"."\1\0\1\0",
);

t_z80asm(
	asm		=> "defvars 0
				{
					s1  ds.b 0
				}
			   ",
	err		=> "Error at file 'test.asm' line 3: Integer '0' out of range",
);

t_z80asm(
	asm		=> "defvars 0
				{
					s1  ds.b 65537
				}
			   ",
	err		=> "Error at file 'test.asm' line 3: Integer '65537' out of range",
);


# defs out of range
t_z80asm(
	asm		=> "defs -1",
	err		=> "Error at file 'test.asm' line 1: Integer '-1' out of range",
);

t_z80asm(
	asm		=> "defs 0",
	bin		=> "",
);

t_z80asm(
	asm		=> "defs 1",
	bin		=> "\x00",
);

t_z80asm(
	asm		=> "defs 1, 0xAA",
	bin		=> "\xAA",
);

t_z80asm(
	asm		=> "defs 65536",
	bin		=> "\x00" x 65536,
);

t_z80asm(
	asm		=> "defs 65536,0xAA",
	bin		=> "\xAA" x 65536,
);

t_z80asm(
	asm		=> "defs 65537",
	err		=> "Error at file 'test.asm' line 1: Max. code size of 65536 bytes reached",
);


# org out of range
t_z80asm(
	asm		=> "org -1",
	err		=> "Error at file 'test.asm' line 1: Integer '-1' out of range",
);

t_z80asm(
	asm		=> "org 0",
	bin		=> "",
);

diag "BUG org 65535 does not work, 0xFFFF is used as a marker for ORG not defined";

t_z80asm(
	asm		=> "org 65534",
	bin		=> "",
);

t_z80asm(
	asm		=> "org 65536",
	err		=> "Error at file 'test.asm' line 1: Integer '65536' out of range",
);


# JR / DJNZ
for ([jr => chr(0x18)], [djnz => chr(0x10)])
{
	my($jump, $opcode) = @$_;
		
	t_z80asm(
		asm		=> "$jump asmpc+2-129",
		err		=> "Error at file 'test.asm' line 1: Integer '-129' out of range",
	);

	t_z80asm(
		asm		=> "$jump label : defc label = asmpc-129",
		err		=> "Error at file 'test.asm' module 'TEST' line 1: Integer '-129' out of range",
	);

	t_z80asm(
		asm		=> "$jump asmpc+2+128",
		err		=> "Error at file 'test.asm' line 1: Integer '128' out of range",
	);

	t_z80asm(
		asm		=> "$jump label : defc label = asmpc+128",
		err		=> "Error at file 'test.asm' module 'TEST' line 1: Integer '128' out of range",
	);

	for my $org (0, 0x8000, 0xFFFE) {
		t_z80asm(
			org		=> $org,
			asm		=> "$jump asmpc+2-128",
			bin		=> "$opcode\x80",
		);

		t_z80asm(
			org		=> $org,
			asm		=> "$jump label : defc label = asmpc-128",
			bin		=> "$opcode\x80",
		);

		t_z80asm(
			org		=> $org, 
			asm		=> "$jump asmpc+2+127",
			bin		=> "$opcode\x7F",
		);

		t_z80asm(
			org		=> $org, 
			asm		=> "$jump label : defc label = asmpc+127",
			bin		=> "$opcode\x7F",
		);

	}
	
}

unlink_testfiles();
done_testing();
