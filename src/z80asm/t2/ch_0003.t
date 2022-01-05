#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

# test ch_0003
z80asm_nok("", "", <<END_ASM, <<END_ERR);
		ld
END_ASM
$test.asm:1: error: syntax error
  ^---- ld
END_ERR

unlink_testfiles;
done_testing;
