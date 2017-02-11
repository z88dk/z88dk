#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm

use strict;
use warnings;
use File::Slurp;
use Test::More;
use Test::Differences; 
use t::TestZ80asm;
use t::Listfile;

my $inc_file = "testinclude.inc";

my $list = t::Listfile->new();

# use after defined, local
$list->push_asm("defc A1 = 1");
$list->push_asm("defb A1", 1);
$list->push_asm("defw A1", 1, 0);
$list->push_asm("defq A1", 1, 0, 0, 0);

# use before defined, global
$list->push_asm("defb B1", 2);
$list->push_asm("defw B1", 2, 0);
$list->push_asm("defq B1", 2, 0, 0, 0);
$list->push_asm("defc B1 = 2");
$list->push_asm("PUBLIC B1");

# create several pages of local and global referenced
for (0..255) {
	my $label = sprintf("%03d", $_);
	$list->push_asm("PUBLIC C$label");
	$list->push_asm("C$label: defb $_", $_);
	$list->push_asm("D$label: defb $_", $_);
}

# add labels of all sizes
for (1..255) {
	my $label = substr("X_".sprintf("%03d", $_).('_X' x $_), 0, $_);
			
	my $asm = "$label: defb $_";
	last if length($asm) >= $list->max_line;
	
	$list->push_asm($asm, $_);
}		

# include a file
write_file($inc_file, <<END);
ld a,+A1
ld b,+B1
add a,b
END
$list->push_include($inc_file);
$list->push_asm("ld a,+A1", 0x3E, 0x01);
$list->push_asm("ld b,+B1", 0x06, 0x02);
$list->push_asm("add a,b", 0x80);
$list->pop_include();

# DEFVARS
$list->push_asm("defvars 0x4000");
$list->push_asm("{");
$list->push_asm(" RUNTIMEFLAGS1 ds.b 1");
$list->push_asm(" RUNTIMEFLAGS2 ds.b 1");
$list->push_asm("}");

# DEFGROUP
$list->push_asm("defgroup");
$list->push_asm("{");
$list->push_asm("  SYM_NULL, SYM_DQUOTE, SYM_SQUOTE, SYM_SEMICOLON,");
$list->push_asm("  SYM_COMMA, SYM_FULLSTOP, SYM_LPAREN, SYM_LCURLY, SYM_RCURLY");
$list->push_asm("}");

# LSTON LSTOFF
$list->push_asm("lstoff");
$list->push_asm("ld bc,0", 1, 0, 0);
$list->push_asm("lston");

# IF ELSE ENDIF 
$list->push_asm("if 0");
$list->push_asm("ld bc,0");
$list->push_asm("else");
$list->push_asm("ld bc,1", 1, 1, 0);
$list->push_asm("endif");
$list->push_asm("if 1");
$list->push_asm("ld hl,1", 0x21, 1, 0);
$list->push_asm("else");
$list->push_asm("ld hl,0");
$list->push_asm("endif");

# list with more than 10000 lines - last test
while ($list->line_nr() <= 10000) {
	$list->push_asm("nop", 0);
}

$list->test();	
