#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# BUG_0024 : (ix+128) should show warning message
z80asm_ok("", "", <<END_WARN, 
$test.asm:1: warning: integer range: \$ff
  ^---- 255
END_WARN
		"inc (ix + 255)",		bytes(0xdd, 0x34, 0xff),
);

unlink_testfiles;
done_testing;
