#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2020
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
    if ($n == 0) {
        check_bin_file("test.bin", pack("C*", 
                (0x28, $n & 0xFF) x 2,
                0x54, 0x5D,
                (0x38, $n & 0xFF) x 3));
    }
    else {
        check_bin_file("test.bin", pack("C*", 
                (0x28, $n & 0xFF) x 3,
                (0x38, $n & 0xFF) x 3));
    }
    
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

# check warnings
for my $n (-129, -128, 0, 255, 256) {
	my $offset = $n > 0 ? "+$n" : $n < 0 ? "$n" : "";
	my $warning = ($n >= -128 && $n < 256) ? "" : "Warning at file 'test.asm' line 1: integer '$n' out of range\n";

	ok 1, "n=$n";
	
    if ($n != 0) {
        unlink_testfiles();
        z80asm("ld de, hl$offset",		'-b -m8085', 0, "", $warning); 	
        check_bin_file("test.bin", pack("C*", 0x28, $n & 0xFF));
    }
    
	unlink_testfiles();
	z80asm("ld de, sp$offset",		'-b -m8085', 0, "", $warning); 	
	check_bin_file("test.bin", pack("C*", 0x38, $n & 0xFF));

	unlink_testfiles();
	z80asm("ld hl, (sp$offset)",		'-b -mr2k', 0, "", $warning); 	
	check_bin_file("test.bin", pack("C*", 0xC4, $n & 0xFF));

	unlink_testfiles();
	z80asm("ld (sp$offset), hl",		'-b -mr2k', 0, "", $warning); 	
	check_bin_file("test.bin", pack("C*", 0xD4, $n & 0xFF));
}

for my $n (-129, -128, 0, 127, 128) {
	my $offset = $n > 0 ? "+$n" : $n < 0 ? "$n" : "";
	my $warning = ($n >= -128 && $n < 128) ? "" : "Warning at file 'test.asm' line 1: integer '$n' out of range\n";

	ok 1, "n=$n";

 	unlink_testfiles();
	z80asm("ld hl, (ix$offset)",		'-b -mr2k', 0, "", $warning); 	
	check_bin_file("test.bin", pack("C*", 0xE4, $n & 0xFF));

	unlink_testfiles();
	z80asm("ld (ix$offset), hl",		'-b -mr2k', 0, "", $warning); 	
	check_bin_file("test.bin", pack("C*", 0xF4, $n & 0xFF));
}

unlink_testfiles();
done_testing();
