#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2019
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/1077
# z80asm: ld hl, sp+ -6

use Modern::Perl;
use Test::More;
use Path::Tiny;
require './t/testlib.pl';

for my $n (-4, 0, 4) {
	my $offset = $n > 0 ? "+$n" : $n < 0 ? "$n" : "";
	
	unlink_testfiles();
	z80asm("ld hl, sp$offset",			'-b -mgbz80'); 	
	check_bin_file("test.bin", pack("C*", 0xF8, $n & 0xFF));
	
	unlink_testfiles();
	z80asm("ldhi $n \n".
		   "adi hl,$n \n".
		   "ld de, hl$offset \n".
		   "ldsi $n \n".
		   "adi sp,$n \n".
		   "ld de, sp$offset \n",		'-b -m8085'); 	
	check_bin_file("test.bin", pack("C*", 
			(0x28, $n & 0xFF) x 3,
			(0x38, $n & 0xFF) x 3));
	
	unlink_testfiles();
	z80asm("ld hl, (ix$offset) \n".
		   "ld (ix$offset), hl \n".
		   "ld hl, (sp$offset) \n".
		   "ld (sp$offset), hl \n",		'-b -mr2k'); 	
	check_bin_file("test.bin", pack("C*", 
			0xE4, $n & 0xFF,
			0xF4, $n & 0xFF,
			0xC4, $n & 0xFF,
			0xD4, $n & 0xFF));
}

unlink_testfiles();
done_testing();
