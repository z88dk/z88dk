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
#
# Test object file output from z80asm

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/objfile.t,v 1.1 2011-08-19 15:53:59 pauloscustodio Exp $
# $Log: objfile.t,v $
# Revision 1.1  2011-08-19 15:53:59  pauloscustodio
# BUG_0010 : heap corruption when reaching MAXCODESIZE
# - test for overflow of MAXCODESIZE is done before each instruction at parseline(); if only one byte is available in codearea, and a 2 byte instruction is assembled, the heap is corrupted before the exception is raised.
# - Factored all the codearea-accessing code into a new module, checking for MAXCODESIZE on every write.
#
#

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

my $obj;

# simplest object file
unlink_testfiles();
write_file(asm_file(), "");
t_z80asm_capture(asm_file(), "", "", 0);
$obj = read_file(obj_file(), binmode => ':raw');
t_binary($obj, objfile(NAME => 'TEST', CODE => ""));

# add 1 byte of code
unlink_testfiles();
write_file(asm_file(), "nop");
t_z80asm_capture(asm_file(), "", "", 0);
$obj = read_file(obj_file(), binmode => ':raw');
t_binary($obj, objfile(NAME => 'TEST', CODE => "\x00"));

# add 65536 byte of code
unlink_testfiles();
write_file(asm_file(), "nop\n" x 0x10000);
t_z80asm_capture(asm_file(), "", "", 0);
$obj = read_file(obj_file(), binmode => ':raw');
t_binary($obj, objfile(NAME => 'TEST', CODE => "\x00" x 0x10000));

# define org
unlink_testfiles();
write_file(asm_file(), "org 0 \n nop");
t_z80asm_capture(asm_file(), "", "", 0);
$obj = read_file(obj_file(), binmode => ':raw');
t_binary($obj, objfile(NAME => 'TEST', ORG => 0, CODE => "\x00"));

unlink_testfiles();
write_file(asm_file(), "org 0xFFFE \n nop");
t_z80asm_capture(asm_file(), "", "", 0);
$obj = read_file(obj_file(), binmode => ':raw');
t_binary($obj, objfile(NAME => 'TEST', ORG => 0xFFFE, CODE => "\x00"));

# add expressions, one of each type
unlink_testfiles();
write_file(asm_file(), "
	ld a,  3*4
	ld b,  (ix + 3*4)
	ld de, 3*4
	defl   3*4
");
t_z80asm_capture(asm_file(), "", "", 0);
$obj = read_file(obj_file(), binmode => ':raw');
t_binary($obj, objfile(NAME => 'TEST',
		       CODE => "\x3E\x0C".
			       "\xDD\x46\x0C".
			       "\x11\x0C\x00".
			       "\x0C\x00\x00\x00"));

unlink_testfiles();
write_file(asm_file(), "
	defc   value8  = 3
	defc   value16 = 3

	ld a,  value8 * 4
	ld b,  (ix + value8 * 4)
	ld de, value16 * 4
	defl   value16 * 4
");
t_z80asm_capture(asm_file(), "", "", 0);
$obj = read_file(obj_file(), binmode => ':raw');
t_binary($obj, objfile(NAME => 'TEST',
		       SYMBOLS => [["L", "C", 3, "value16"],
				   ["L", "C", 3, "value8"]],
		       CODE => "\x3E\x0C".
			       "\xDD\x46\x0C".
			       "\x11\x0C\x00".
			       "\x0C\x00\x00\x00"));

unlink_testfiles();
write_file(asm_file(), "
	ld a,  value8 *4
	ld b,  (ix + value8 * 4)
	ld de, value16 * 4
	defl   value16 * 4

	defc   value8  = 3
	defc   value16 = 3
");
t_z80asm_capture(asm_file(), "", "", 0);
$obj = read_file(obj_file(), binmode => ':raw');
t_binary($obj, objfile(NAME => 'TEST',
		       SYMBOLS => [["L", "C", 3, "value16"],
				   ["L", "C", 3, "value8"]],
		       CODE => "\x3E\x0C".
			       "\xDD\x46\x0C".
			       "\x11\x0C\x00".
			       "\x0C\x00\x00\x00"));

unlink_testfiles();
write_file(asm_file(), "
	org 3
label:	ld a,  label * 4
	ld b,  (ix + label * 5)
label2:	ld de, label2 * 4
	defl   label2 * 6
");
t_z80asm_capture(asm_file(), "", "", 0);
$obj = read_file(obj_file(), binmode => ':raw');
t_binary($obj, objfile(NAME => 'TEST',
		       ORG => 3,
		       EXPR => [["U", 1, "label*4"],
				["S", 4, "label*5"],
				["C", 6, "label2*4"],
				["L", 8, "label2*6"]],
		       SYMBOLS => [["L", "A", 0, "label"],
				   ["L", "A", 5, "label2"]],
		       CODE => "\x3E\x00".
			       "\xDD\x46\x00".
			       "\x11\x00\x00".
			       "\x00\x00\x00\x00"));

# local and global symbols
unlink_testfiles();
write_file(asm_file(), "
	xdef global
	xref extobj
	lib  extlib

local:	nop
global:	call extobj
	call extlib
");
t_z80asm_capture(asm_file(), "", "", 0);
$obj = read_file(obj_file(), binmode => ':raw');
t_binary($obj, objfile(NAME => 'test',
		       EXPR => [["C", 2, "extobj"],
				["C", 5, "extlib"]],
		       SYMBOLS => [["L", "A", 0, "local"],
				   ["G", "A", 1, "global"]],
		       LIBS => ["extlib"],
		       CODE => "\x00".
		               "\xCD\x00\x00".
		               "\xCD\x00\x00"));

# library
unlink_testfiles();
write_file(asm_file(), "
	xlib mult

mult:	ret
");
t_z80asm_capture(asm_file(), "", "", 0);
$obj = read_file(obj_file(), binmode => ':raw');
t_binary($obj, objfile(NAME => 'mult',
		       SYMBOLS => [["X", "A", 0, "mult"]],
		       CODE => "\xC9"));


unlink_testfiles();
done_testing();
