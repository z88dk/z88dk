#!/usr/bin/perl

# Z88DK Z80 Module Assembler
#
# Copyright (C) Paulo Custodio, 2011-2021
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test BINARY

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

unlink_testfiles();
spew("test1.dat", pack("C*", 0, 0x0A, 0x0D, 0xFF));
z80asm(<<END);
		ld bc,101h			;; 01 01 01
		binary "test1.dat"	;; 00 0A 0D FF
		ld de,1111h			;; 11 11 11
END
check_bin_file("test.bin", pack("C*", 
				1, 1, 1, 
				0, 0x0A, 0x0D, 0xFF,
				0x11, 0x11, 0x11));
				
unlink_testfiles();
spew("test1.dat", pack("C*", 0, 0x0A, 0x0D, 0xFF));
z80asm(<<END);
		ld bc,101h			;; 01 01 01
lbl:	binary "test1.dat"	;; 00 0A 0D FF
		ld de,1111h			;; 11 11 11
END
check_bin_file("test.bin", pack("C*", 
				1, 1, 1, 
				0, 0x0A, 0x0D, 0xFF,
				0x11, 0x11, 0x11));
				
unlink_testfiles();
spew("test1.dat", pack("C*", 0, 0x0A, 0x0D, 0xFF));
z80asm(<<END);
		ld bc,101h			;; 01 01 01
		incbin "test1.dat"	;; 00 0A 0D FF
		ld de,1111h			;; 11 11 11
END
check_bin_file("test.bin", pack("C*", 
				1, 1, 1, 
				0, 0x0A, 0x0D, 0xFF,
				0x11, 0x11, 0x11));
				
unlink_testfiles();
spew("test1.dat", pack("C*", 0, 0x0A, 0x0D, 0xFF));
z80asm(<<END);
		ld bc,101h			;; 01 01 01
lbl:	incbin "test1.dat"	;; 00 0A 0D FF
		ld de,1111h			;; 11 11 11
END
check_bin_file("test.bin", pack("C*", 
				1, 1, 1, 
				0, 0x0A, 0x0D, 0xFF,
				0x11, 0x11, 0x11));
				
unlink_testfiles();
spew("test1.dat", "a" x 0x10000);
z80asm(<<END);
		binary "test1.dat"
END
check_bin_file("test.bin", "a" x 0x10000);
				
z80asm(<<END, "-b", 1, "", <<END);
		nop
		binary "test1.dat"
END
Error at file 'test.asm' line 2: max. code size of 65536 bytes reached
END

unlink_testfiles();
spew("test1.dat", "a" x 0x10001);
z80asm(<<END, "-b", 1, "", <<END);
		binary "test1.dat"
END
Error at file 'test.asm' line 1: max. code size of 65536 bytes reached
END

# -I; more complete tests in INCLUDE
unlink_testfiles();
mkdir("test_dir");

spew("test_dir/test1.dat", "hello");

z80asm(<<END, "-b", 1, "", <<END);
		binary "test1.dat"
END
Error at file 'test.asm' line 1: cannot read file 'test1.dat'
END

z80asm(<<END, "-b -Itest_dir");
		binary "test1.dat"
END
check_bin_file("test.bin", "hello");

unlink_testfiles();
done_testing();
