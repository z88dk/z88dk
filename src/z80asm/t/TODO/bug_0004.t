#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# BUG_0004 : 8bit unsigned constants are not checked for out-of-range
z80asm_ok("", "", <<END_WARN, 
$test.asm:1: warning: integer range: -\$81
  ^---- -129
$test.asm:2: warning: integer range: \$100
  ^---- 256
$test.asm:3: warning: integer range: -\$81
  ^---- -129
$test.asm:4: warning: integer range: \$80
  ^---- 128
END_WARN
		"ld a, -129",		bytes(0x3e, 0x7f),
		"ld a,256",			bytes(0x3e, 0x00),
		"ld (ix-129),-1",	bytes(0xdd, 0x36, 0x7f, 0xff),
		"ld (ix+128),-1",	bytes(0xdd, 0x36, 0x80, 0xff),
);

unlink_testfiles;
done_testing;
