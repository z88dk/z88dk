#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/738
# z80asm: superfluous section generated in compile
# caused by expressions DEFC aaa = aaa

z80asm_nok("", "", <<ASM, <<ERR);
	defc aaa = aaa
ASM
${test}.asm:1: error: recursive expression
  ^---- defc aaa = aaa
ERR

unlink_testfiles;
done_testing;
