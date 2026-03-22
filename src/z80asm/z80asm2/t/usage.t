#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

capture_ok("z88dk-z80asm", <<END);
Usage: z88dk-z80asm [options] files...
Copyright (C) Paulo Custodio, 2011-2026
END

capture_nok("z88dk-z80asm -d", <<END);
error: No input files specified
END

for my $help ('-h', '--help', '-?') {
	capture_ok("z88dk-z80asm $help", <<END);
Usage: z88dk-z80asm [options] files...
Copyright (C) Paulo Custodio, 2011-2026
Assembles Z80 assembly source files into binary output.

Options:
  -cpp=OPTS    Options when calling cpp
  -d           Do not assemble if .o is newer
  -E           Only run the preprocessor, generate file.i
  -D=SYM[=EXPR]Define constant, EXPR defaults to 1
  -h           Show this screen
  -I=DIR       Add directory to search for source/include files
  -IXIY        Swap IX and IY registers
  -m4=OPTS     Options when calling m4
  -O=DIR       Set directory to store output files
  -perl=OPTS   Options when calling perl
  -ucase       Convert labels to uppercase
  -v           Enable verbose output
END
}

path("$test.asm")->spew("");
capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
% z88dk-z80asm -v -E test_t_usage_t.asm
END
#Preprocessing file: test_t_usage_t.asm -> test_t_usage_t.i

unlink_testfiles if Test::More->builder->is_passing;
done_testing;

