#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2015
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm

use strict;
use warnings;
use File::Slurp;
use Test::More;
use Test::Differences; 
require 't/test_utils.pl';

my $inc_file = "testinclude.inc";

# use after defined, local
list_push_asm("defc A1 = 1");
list_push_asm("defb A1", 1);
list_push_asm("defw A1", 1, 0);
list_push_asm("defl A1", 1, 0, 0, 0);

# use before defined, global
list_push_asm("defb B1", 2);
list_push_asm("defw B1", 2, 0);
list_push_asm("defl B1", 2, 0, 0, 0);
list_push_asm("defc B1 = 2");
list_push_asm("PUBLIC B1");

# create several pages of local and global referenced
for (0..255) {
	my $label = sprintf("%03d", $_);
	list_push_asm("PUBLIC C$label");
	list_push_asm("C$label: defb $_", $_);
	list_push_asm("D$label: defb $_", $_);
}

# create a reference list with more than two lines in listing file
for (0 .. 18*3*61) {		# 18 references per line, 3 lines, 61 lines per page
	list_push_asm("defw E1", 3, 0);
}
list_push_asm("defc E1 = 3");

# add labels of all sizes
for (1..255) {
	my $label = substr("X_".sprintf("%03d", $_).('_X' x $_), 0, $_);
			
	my $asm = "$label: defb $_";
	last if length($asm) >= get_max_line();
	
	list_push_asm($asm, $_);
}		

# include a file
write_file($inc_file, <<END);
ld a,+A1
ld b,+B1
add a,b
END
list_push_include($inc_file);
list_push_asm("ld a,+A1", 0x3E, 0x01);
list_push_asm("ld b,+B1", 0x06, 0x02);
list_push_asm("add a,b", 0x80);
list_pop_include();

# DEFVARS
list_push_asm("defvars 0x4000");
list_push_asm("{");
list_push_asm(" RUNTIMEFLAGS1 ds.b 1");
list_push_asm(" RUNTIMEFLAGS2 ds.b 1");
list_push_asm("}");

# DEFGROUP
list_push_asm("defgroup");
list_push_asm("{");
list_push_asm("  SYM_NULL, SYM_DQUOTE, SYM_SQUOTE, SYM_SEMICOLON,");
list_push_asm("  SYM_COMMA, SYM_FULLSTOP, SYM_LPAREN, SYM_LCURLY, SYM_RCURLY");
list_push_asm("}");

# LSTON LSTOFF
list_push_asm("lstoff");
list_push_asm("ld bc,0", 1, 0, 0);
list_push_asm("lston");

# IF ELSE ENDIF 
list_push_asm("if 0");
list_push_asm("ld bc,0");
list_push_asm("else");
list_push_asm("ld bc,1", 1, 1, 0);
list_push_asm("endif");
list_push_asm("if 1");
list_push_asm("ld hl,1", 0x21, 1, 0);
list_push_asm("else");
list_push_asm("ld hl,0");
list_push_asm("endif");

# list with more than 10000 lines - last test
while (get_num_lines() <= 10000) {
	list_push_asm("nop", 0);
}

list_test();

unlink_testfiles($inc_file);
done_testing();
