#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

spew("${test}.asm", <<'END');
	ld ixh, 0
END

capture_ok("z88dk-z80asm -mz80 -b ${test}.asm", "");
check_bin_file("${test}.bin", bytes(0xdd, 0x26, 0x00));

capture_nok("z88dk-z80asm -mz80_strict -b ${test}.asm", <<END);
$test.asm:1: error: illegal identifier
  ^---- ld ixh, 0
END

capture_nok("z88dk-z80asm -mz80 -strict -b ${test}.asm", <<END);
$test.asm:1: error: illegal identifier
  ^---- ld ixh, 0
END

spew("${test}.asm", <<'END');
	ld bc, de
END

capture_ok("z88dk-z80asm -mz180 -b ${test}.asm", "");
check_bin_file("${test}.bin", bytes(0x26, 0x00));

capture_nok("z88dk-z80asm -mz180_strict -b ${test}.asm", <<END);
$test.asm:1: error: illegal identifier
  ^---- ld bc, de
END

capture_nok("z88dk-z80asm -mz180 -strict -b ${test}.asm", <<END);
$test.asm:1: error: illegal identifier
  ^---- ld bc, de
END

unlink_testfiles;
done_testing;
