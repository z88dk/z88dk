#!/usr/bin/perl

# Z88DK Z80 Module Assembler
#
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test DEFB, DEFM - more complete tests in build_opcodes.asm

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

for my $DEFB (qw(DEFB DEFM)) {
	ok 1, "Test with $DEFB";

	z80asm("xx: $DEFB", "", 1, "", <<END);
Error at file 'test.asm' line 1: syntax error
END

	unlink_testfiles();
	z80asm("xx: $DEFB xx");
	check_bin_file("test.bin", pack("C*", 0));

	z80asm("xx: $DEFB xx,", "", 1, "", <<END);
Error at file 'test.asm' line 1: syntax error
END

	unlink_testfiles();
	z80asm("xx: $DEFB xx,xx+1");
	check_bin_file("test.bin", pack("C*", 0, 1));

	z80asm("xx: $DEFB \"", "", 1, "", <<END);
Error at file 'test.asm' line 1: unclosed quoted string
END

	z80asm("xx: $DEFB \"hello", "", 1, "", <<END);
Error at file 'test.asm' line 1: unclosed quoted string
END

	# escape chars
	unlink_testfiles();
	z80asm('xx: '.$DEFB.' xx, "\0\1\2", 3, '.
			'"\a\b\e\f\n\r\t\v", '.
			'"\0\1\2\3\4\5\6\7\10\11\12\376\377", '.
			'"\x0\x1\x2\x3\x4\x5\x6\x7\x8\x9\xa\xB\xc\xD\xe\xF\x10\xfe\xFF" ');
	check_bin_file("test.bin",
		pack("C*", 0, 0, 1, 2, 3).
		"\a\b\e\f\n\r\t\x0B".
		pack("C*", 0..10, 254, 255).
		pack("C*", 0..16, 254, 255));
}

unlink_testfiles();
done_testing();
