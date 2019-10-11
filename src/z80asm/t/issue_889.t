#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2019
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/889
# z80asm: premature range check during calculation of defb

use Modern::Perl;
use Test::More;
use Path::Tiny;
require './t/testlib.pl';

z80asm(<<'END');
defc MAIN = 45678
defb (MAIN - 1) / 10 % 10 + '0'
END
check_bin_file("test.bin", "7");

unlink_testfiles();
spew("test.asm", <<'END');
PUBLIC MAIN
defc MAIN = 45678
END

spew("test1.asm", <<'END');
EXTERN MAIN
defb (MAIN - 1) / 10 % 10 + '0'
END

run("z80asm -b test.asm test1.asm");
check_bin_file("test.bin", "7");

unlink_testfiles();
done_testing();
