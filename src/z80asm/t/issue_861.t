#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2018
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/861
# allow "jr $+offset" to parse code for other assemblers

use strict;
use warnings;
use v5.10;
use Test::More;
require './t/testlib.pl';

unlink_testfiles();
z80asm(<<'...');
		jr l1
		jr l1
l1:		jr l1
		jr l1
...
check_bin_file("test.bin", pack("C*", 0x18, 2, 0x18, 0, 0x18, -2 & 0xFF, 0x18, -4 & 0xFF));

unlink_testfiles();
z80asm(<<'...');
		jr ASMPC+4
		jr ASMPC+2
l1:		jr ASMPC
		jr ASMPC-2
...
check_bin_file("test.bin", pack("C*", 0x18, 2, 0x18, 0, 0x18, -2 & 0xFF, 0x18, -4 & 0xFF));

unlink_testfiles();
z80asm(<<'...');
		jr $+4
		jr $+2
l1:		jr $
		jr $-2
...
check_bin_file("test.bin", pack("C*", 0x18, 2, 0x18, 0, 0x18, -2 & 0xFF, 0x18, -4 & 0xFF));

#unlink_testfiles();
done_testing();

__END__
check_bin_file("test.bin", pack("C*", 0x18, -2));

z80asm('jr $', 0, '', '');
check_bin_file("test.bin", pack("C*", 0x18, -2));

z80asm('jr ASMPC', 0, '', '');

z80asm('jr lbl', 0, '', '');
check_bin_file("test.bin", pack("C*", 0x18, -2));

z80asm('jr $', 0, '', '');
check_bin_file("test.bin", pack("C*", 0x18, -2));

z80asm('jr ASMPC', 0, '', '');
check_bin_file("test.bin", pack("C*", 0x18, -2));



run('z80asm -xtest.lib "test*.asm"', 1, '', <<'...');
Error: pattern 'test*.asm' returned no files
1 errors occurred during assembly
...

# force the error and check behaviour
spew("test.asm", "");
run('z80asm -xtest.lib "test.asm"', 0, '', '');
ok -f "test.lib";
my $bytes = slurp("test.lib");
spew("test.lib", substr($bytes, 0, 8));		# invalid lib, only header

spew("test.asm", <<'...');
	extern main
	jp main
...
run('z80asm -b -itest.lib test.asm', 1, '', <<'...');
Error at file 'test.asm' line 2: symbol 'main' not defined
1 errors occurred during assembly
...

