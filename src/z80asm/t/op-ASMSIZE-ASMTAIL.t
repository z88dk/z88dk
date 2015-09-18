#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2015
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Test new ASMTAIL and ASMSIZE keywords

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

my @testfiles = qw( testa.asm testa.lst testa.sym testa.obj testa.map testa.bin
					testb.asm testb.lst testb.sym testb.obj
				);

my $asm = "
	EXTERN ASMHEAD, ASMTAIL, ASMSIZE
	
	DEFW ASMHEAD
	DEFW ASMTAIL
	DEFW ASMSIZE
";

#------------------------------------------------------------------------------
t_z80asm_ok(0, $asm, "\x00\x00\x06\x00\x06\x00", "-r0000 -b");
t_z80asm_ok(0, $asm, "\x00\xF0\x06\xF0\x06\x00", "-rF000 -b");

#------------------------------------------------------------------------------
unlink_testfiles(@testfiles);

write_file('testa.asm', $asm);
write_file('testb.asm', $asm);
t_z80asm_capture("-b -r0000 testa.asm testb.asm", "", "", 0);
t_binary(read_binfile('testa.bin'), 
		"\x00\x00\x0C\x00\x0C\x00".
		"\x00\x00\x0C\x00\x0C\x00");

t_z80asm_capture("-b -rF000 testa.asm testb.asm", "", "", 0);
t_binary(read_binfile('testa.bin'), 
		"\x00\xF0\x0C\xF0\x0C\x00".
		"\x00\xF0\x0C\xF0\x0C\x00");

unlink_testfiles(@testfiles);
done_testing();
