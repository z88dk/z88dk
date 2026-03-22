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

Help Options:
  -h        Show this screen
  -v        Verbose output

File and Directory Options:
  -I=ARG    Add directory to search for source/include files
  -O=ARG    Set directory to store output files

External Preprocessor Options:
  -cpp=ARG  Pass options to cpp
  -m4=ARG   Pass options to m4
  -perl=ARG Pass options to perl

Preprocessor Options:
  -IXIY     Swap IX and IY registers
  -D=ARG    Define symbol
  -ucase    Uppercase labels
  -E        Preprocess only

Assembly Options:
  -d        Assemble only if newer
END
}

path("$test.asm")->spew("");
capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
% z88dk-z80asm -v -E test_t_usage_t.asm
Assembly completed with 0 error(s)
END
#Preprocessing file: test_t_usage_t.asm -> test_t_usage_t.i

unlink_testfiles if Test::More->builder->is_passing;
done_testing;

