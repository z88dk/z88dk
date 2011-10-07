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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/BUG_0015.t,v 1.1 2011-10-07 17:53:05 pauloscustodio Exp $
# $Log: BUG_0015.t,v $
# Revision 1.1  2011-10-07 17:53:05  pauloscustodio
# BUG_0015 : Relocation issue - dubious addresses come out of linking
# (reported on Tue, Sep 27, 2011 at 8:09 PM by dom)
# - Introduced in version 1.1.8, when the CODESIZE and the codeptr were merged into the same entity.
# - This caused the problem because CODESIZE keeps track of the start offset of each module in the sequence they will appear in the object file, and codeptr is reset to the start of the codearea for each module.
# The effect was that all address calculations at link phase were considering
#  a start offset of zero for all modules.
# - Moreover, when linking modules from a libary, the modules are pulled in to the code area as they are needed, and not in the sequence they will be in the object file. The start offset was being ignored and the modules were being loaded in the incorrect order
# - Consequence of these two issues were all linked addresses wrong.
#
#
# Error in linking of addresses:
# Base address of each module is independent of start address of the module in
# the code area.
# When linking in a module, it has to be loaded at the base address offset into
# the code area, and not immediatelly after the last module. E.g. when linking A, B and
# library L1, the sequence in the object file is A,B,L1; but the load sequence
# is A, L1, B; L1 has to be loaded at the final address.

use strict;
use warnings;
use File::Slurp;
use Test::More;
require 't/test_utils.pl';

my @testfiles = qw( testa.asm testa.lst testa.sym testa.obj testa.map testa.bin
		    testb.asm testb.lst testb.sym testb.obj
		    testl.asm testl.lst testl.sym testl.obj testl.lib
		);

#------------------------------------------------------------------------------
my $testa_asm = "
		xdef a1
		xdef a2
		xref b1
		xref b2
		lib  l1

	    a1:	ld a,1		; 8000  3E 01
		call b1		; 8002  CD 16 80
		call l1		; 8005  CD 2C 80
		jp a2		; 8008  C3 0B 80

	    a2:	ld a,2		; 800B  3E 02
		call b2		; 800D  CD 21 80
		call l1		; 8010  CD 2C 80
		jp a1		; 8013  C3 00 80
				; 8016
	   ";
my $testa_obj = objfile(NAME => 'TESTA',
			EXPR => [['C', 0x0003, 'B1'],
				 ['C', 0x0006, 'L1'],
				 ['C', 0x000E, 'B2'],
				 ['C', 0x0011, 'L1'],
				 ['C', 0x0014, 'A1'],
				 ['C', 0x0009, 'A2']],
			SYMBOLS => [['G', 'A', 0x0000, 'A1'],
				    ['G', 'A', 0x000B, 'A2']],
			LIBS => ['L1'],
			CODE => "\x3E\x01".
				"\xCD\x00\x00".
				"\xCD\x00\x00".
				"\xC3\x0B\x00".
				"\x3E\x02".
				"\xCD\x00\x00".
				"\xCD\x00\x00".
				"\xC3\x00\x00");

#------------------------------------------------------------------------------
my $testb_asm = "
		xdef b1
		xdef b2
		xref a1
		xref a2
		lib  l1

	    b1:	ld b,1		; 8016  06 01
		call a1		; 8018  CD 00 80
		call l1		; 801B  CD 2C 80
		jp b2		; 801E  C3 21 80

	    b2:	ld b,2		; 8021  06 02
		call a2		; 8023  CD 0B 80
		call l1		; 8026  CD 2C 80
		jp b1		; 8029  C3 16 80
				; 802C
	   ";
my $testb_obj = objfile(NAME => 'TESTB',
			EXPR => [['C', 0x0003, 'A1'],
				 ['C', 0x0006, 'L1'],
				 ['C', 0x000E, 'A2'],
				 ['C', 0x0011, 'L1'],
				 ['C', 0x0014, 'B1'],
				 ['C', 0x0009, 'B2']],
			SYMBOLS => [['G', 'A', 0x0000, 'B1'],
				    ['G', 'A', 0x000B, 'B2']],
			LIBS => ['L1'],
			CODE => "\x06\x01".
				"\xCD\x00\x00".
				"\xCD\x00\x00".
				"\xC3\x0B\x00".
				"\x06\x02".
				"\xCD\x00\x00".
				"\xCD\x00\x00".
				"\xC3\x00\x00");

#------------------------------------------------------------------------------
my $testl_asm = "
		xlib l1

	    l1:	ld l,1		; 802C  2E 01
		jp l2		; 802E  C3 31 80

	    l2:	ld l,2		; 8031  2E 02
		jp l1		; 8033  C3 2C 80
				; 8036
	   ";
my $testl_obj = objfile(NAME => 'L1',
			EXPR => [['C', 0x0008, 'L1'],
				 ['C', 0x0003, 'L2']],
			SYMBOLS => [['L', 'A', 0x0005, 'L2'],
				    ['X', 'A', 0x0000, 'L1']],
			CODE => "\x2E\x01".
				"\xC3\x05\x00".
				"\x2E\x02".
				"\xC3\x00\x00");

#------------------------------------------------------------------------------
my $testa_bin =
	"\x3E\x01".
	"\xCD\x16\x80".
	"\xCD\x2C\x80".
	"\xC3\x0B\x80".
	"\x3E\x02".
	"\xCD\x21\x80".
	"\xCD\x2C\x80".
	"\xC3\x00\x80".
	"\x06\x01".
	"\xCD\x00\x80".
	"\xCD\x2C\x80".
	"\xC3\x21\x80".
	"\x06\x02".
	"\xCD\x0B\x80".
	"\xCD\x2C\x80".
	"\xC3\x16\x80".
	"\x2E\x01".
	"\xC3\x31\x80".
	"\x2E\x02".
	"\xC3\x2C\x80";

#------------------------------------------------------------------------------
unlink_testfiles(@testfiles);

write_file('testa.asm', $testa_asm);
t_z80asm_capture("-l testa.asm", "", "", 0);
t_binary(read_binfile('testa.obj'), $testa_obj);

write_file('testb.asm', $testb_asm);
t_z80asm_capture("-l testb.asm", "", "", 0);
t_binary(read_binfile('testb.obj'), $testb_obj);

write_file('testl.asm', $testl_asm);
t_z80asm_capture("-xtestl.lib -l testl.asm", "", "", 0);
t_binary(read_binfile('testl.obj'), $testl_obj);
t_binary(read_binfile('testl.lib'), libfile($testl_obj));

t_z80asm_capture("-itestl.lib -a -r8000 testa.obj testb.obj", "", "", 0);
t_binary(read_binfile('testa.bin'), $testa_bin);

unlink_testfiles(@testfiles);
done_testing();
