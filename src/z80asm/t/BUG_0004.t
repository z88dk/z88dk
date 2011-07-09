#!/usr/bin/perl

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/BUG_0004.t,v 1.2 2011-07-09 17:36:09 pauloscustodio Exp $
# $Log: BUG_0004.t,v $
# Revision 1.2  2011-07-09 17:36:09  pauloscustodio
# Copied cvs log into $Log$ history
#
# Revision 1.1  2011/07/09 01:02:45  pauloscustodio
# Started to build test suite in t/ *.t unsing Perl prove. Included test for all standard
# Z80 opcodes; need to be extended with directives and opcodes for Z80 variants.
#
# Test correction of BUG_0004, see hist.c for description

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

# Integer out of range
t_z80asm_error("ld a,-129", 		"File 'test.asm', at line 1, Integer out of range");
t_z80asm_error("ld a,N \n defc N = -129", 	"File 'test.asm', Module 'TEST', at line 1, Out of range");

t_z80asm_ok(0, "ld a,-128", 			"\x3E\x80");
t_z80asm_ok(0, "ld a,N \n defc N = -128", 	"\x3E\x80");

t_z80asm_ok(0, "ld a,255", 			"\x3E\xFF");
t_z80asm_ok(0, "ld a,N \n defc N = 255", 	"\x3E\xFF");

t_z80asm_error("ld a,256", 			"File 'test.asm', at line 1, Integer out of range");
t_z80asm_error("ld a,N \n defc N = 256",	"File 'test.asm', Module 'TEST', at line 1, Out of range");

t_z80asm_error("ld bc,-32769", 			"File 'test.asm', at line 1, Integer out of range");
t_z80asm_error("ld bc,N \n defc N = -32769", 	"File 'test.asm', Module 'TEST', at line 1, Out of range");

t_z80asm_ok(0, "ld bc,-32768", 			"\x01\x00\x80");
t_z80asm_ok(0, "ld bc,N \n defc N = -32768", 	"\x01\x00\x80");

t_z80asm_error("ld bc,65536", 			"File 'test.asm', at line 1, Integer out of range");
t_z80asm_error("ld bc,N \n defc N = 65536", 	"File 'test.asm', Module 'TEST', at line 1, Out of range");

t_z80asm_ok(0, "ld bc,65535", 			"\x01\xFF\xFF");
t_z80asm_ok(0, "ld bc,N \n defc N = 65535", 	"\x01\xFF\xFF");

unlink_testfiles();
done_testing();
