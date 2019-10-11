#!/usr/bin/perl

# Z88DK Z80 Module Assembler
#
# Copyright (C) Paulo Custodio, 2011-2019
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test DEFDB - big-endian word

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

z80asm("xx: defdb", "", 1, "", <<END);
Error at file 'test.asm' line 1: syntax error
END

unlink_testfiles();
z80asm("xx: defdb xx");
check_bin_file("test.bin", pack("C*", 0, 0));

z80asm("xx: defdb xx,", "", 1, "", <<END);
Error at file 'test.asm' line 1: syntax error
END

unlink_testfiles();
z80asm("xx: defdb xx,xx+1,255,256");
check_bin_file("test.bin", pack("C*", 0,0, 0,1, 0,255, 1,0));

unlink_testfiles();
done_testing();
