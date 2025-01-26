#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

spew("${test}.asm", <<'END');
	ld ixh, 0
	ld bc, de
END

capture_ok("z88dk-z80asm -mz80 -b ${test}.asm", "");
check_bin_file("${test}.bin", bytes(0xdd, 0x26, 0x00, 0x42, 0x4b));

capture_nok("z88dk-z80asm -mz80_strict -b ${test}.asm", <<END);
$test.asm:1: error: illegal identifier
  ^---- ld ixh, 0
END

capture_nok("z88dk-z80asm -mz80 -no-synth -b ${test}.asm", <<END);
$test.asm:2: error: illegal identifier
  ^---- ld bc, de
END

capture_nok("z88dk-z80asm -mz80_strict -no-synth -b ${test}.asm", <<END);
$test.asm:1: error: illegal identifier
  ^---- ld ixh, 0
$test.asm:2: error: illegal identifier
  ^---- ld bc, de
END

unlink_testfiles;
done_testing;
