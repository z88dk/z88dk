#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# BUG_0005 : Offset of (ix+d) should be optional; '+' or '-' are necessary
z80asm_ok("", "", "",
		"inc (ix)",			bytes(0xdd, 0x34, 0x00),
		"inc (ix + 3)",		bytes(0xdd, 0x34, 0x03),
		"inc (ix - 3)",		bytes(0xdd, 0x34, 0xfd),
);

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		inc (ix 3)
END_ASM
$test.asm:1: error: syntax error
  ^---- inc (ix 3)
END_ERR

unlink_testfiles;
done_testing;
