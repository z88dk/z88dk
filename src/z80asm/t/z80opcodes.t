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
# Copyright (C) Paulo Custodio, 2011-2014

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/z80opcodes.t,v 1.2 2014-04-28 22:14:56 pauloscustodio Exp $

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

# build z80emu.lib
my $z80emu_lib = 'z80emu.lib';
my @z80emu_src = <../../libsrc/z80_crt0s/z80_emu/*.asm>;
t_z80asm_capture("-l -d -x$z80emu_lib @z80emu_src", "", "", 0);

# show bugs tested in z80opcodes.asm
open(my $fh, "t/data/z80opcodes.asm") or die "open t/data/z80opcodes.asm: $!";
while (<$fh>) {
	diag($1) if /;\s+((BUG_|CH_)\d+)/;
}

# external ZERO constant
write_file(asm1_file(), " public zero \n defc zero = 0 \n");

# Z80
t_z80asm_capture("-l -b -otest.bin               t/data/z80opcodes.asm ".asm1_file(), "", "", 0);
t_binary(read_binfile("test.bin"), read_binfile("t/data/z80opcodes.bin"));

# RABBIT
t_z80asm_capture("-l -b -otest.bin -RCMX000 -DRABBIT -i$z80emu_lib t/data/z80opcodes_rabbit.asm ".asm1_file(), "", "", 0);
t_binary(read_binfile("test.bin"), read_binfile("t/data/z80opcodes_rabbit.bin"));

# cleanup
unlink_testfiles( <t/data/z80opcodes*.lst>,
				  <t/data/z80opcodes*.map>, 
				  <t/data/z80opcodes*.obj>, 
				  <t/data/z80opcodes*.sym>,
				  'z80emu.lib',
				  <../../libsrc/z80_crt0s/z80_emu/*.obj>,
				  <../../libsrc/z80_crt0s/z80_emu/*.lst>,
				  );

unlink_testfiles();
done_testing();


# $Log: z80opcodes.t,v $
# Revision 1.2  2014-04-28 22:14:56  pauloscustodio
# Move testing of all opcodes from static z80ops to z80opcodes*.asm that is generated
# by build_z80opcodes.pl, which in turn uses a template file to expand all the Z80 opcodes,
# and calls Udo Munk's assembler to generate the benchmark binary files.
# These are compared to the result of z80asm at test-time.
#
# Revision 1.1  2014/04/25 23:39:14  pauloscustodio
# Create asm and binary files at dev/Makefile using z80pack's assembler as benchmarks
# to test the z80asm assembler. These files are used during testing.
#
# Revision 1.9  2014/04/22 23:32:42  pauloscustodio
# Release 2.2.0 with major fixes:
#
# - Object file format changed to version 03, to include address of start
# of the opcode of each expression stored in the object file, to allow
# ASMPC to refer to the start of the opcode instead of the patch pointer.
# This solves long standing BUG_0011 and BUG_0048.
#
# - ASMPC no longer stored in the symbol table and evaluated as a separate
# token, to allow expressions including ASMPC to be relocated. This solves
# long standing and never detected BUG_0047.
#
# - Handling ASMPC during assembly simplified - no need to call inc_PC() on
# every assembled instruction, no need to store list of JRPC addresses as
# ASMPC is now stored in the expression.
#
# BUG_0047: Expressions including ASMPC not relocated - impacts call po|pe|p|m emulation in RCMX000
# ASMPC is computed on zero-base address of the code section and expressions
# including ASMPC are not relocated at link time.
# "call po, xx" is emulated in --RCMX000 as "jp pe, ASMPC+3; call xx".
# The expression ASMPC+3 is not marked as relocateable, and the resulting
# code only works when linked at address 0.
#
# BUG_0048: ASMPC used in JP/CALL argument does not refer to start of statement
# In "JP ASMPC", ASMPC is coded as instruction-address + 1 instead
# of instruction-address.
#
# BUG_0011 : ASMPC should refer to start of statememnt, not current element in DEFB/DEFW
# Bug only happens with forward references to relative addresses in expressions.
# See example from zx48.asm ROM image in t/BUG_0011.t test file.
# Need to change object file format to correct - need patchptr and address of instruction start.
#
# Revision 1.8  2014/04/18 16:46:19  pauloscustodio
# Add patching of labels to opcodes.t.
# Emulation of call po|pe|p|m in rcmx000 test commented.
#
# Revision 1.7  2014/04/16 22:50:34  pauloscustodio
# Move JR and DJNZ test code to opcodes.t
#
# Revision 1.6  2014/04/15 23:22:18  pauloscustodio
# FPP: no need for special treatment for parenthesis surrounding expression,
# as any axpression can be surrounded by parenthesis
#
# Revision 1.5  2014/04/15 23:12:04  pauloscustodio
# INVOKE: no need for special treatment for parenthesis surrounding expression,
# as any axpression can be surrounded by parenthesis
#
# Revision 1.4  2014/04/15 22:31:17  pauloscustodio
# CALL_PKG: no need for special treatment for parenthesis surrounding expression,
# as any axpression can be surrounded by parenthesis
#
# Revision 1.3  2014/04/15 22:14:27  pauloscustodio
# CALL_OZ: no need for special treatment for parenthesis surrounding expression,
# as any axpression can be surrounded by parenthesis
#
# Revision 1.2  2014/04/15 20:45:05  pauloscustodio
# Added error message for invalid interrupt mode in IM, e.g. for "IM 3":
# Error at file 'test.asm' line 2: integer '3' out of range
#
# Revision 1.1  2014/03/29 01:19:41  pauloscustodio
# Accept both "ex af,af" and "ex af,af'"
#
