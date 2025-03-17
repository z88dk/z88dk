#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

spew("${test}.asm", <<'END');
    cp 0
    jp 0
END

capture_ok("z88dk-z80asm -m8080 -b ${test}.asm", "");
check_bin_file("${test}.bin", bytes(0xfe, 0x00,
									0xc3, 0x00, 0x00));

capture_ok("z88dk-z80asm -m8080_strict -b ${test}.asm", "");
check_bin_file("${test}.bin", bytes(0xf4, 0x00, 0x00,
									0xf2, 0x00, 0x00));

spew("${test}.asm", <<'END');
    add 0x42
END

capture_ok("z88dk-z80asm -mz80 -b ${test}.asm", "");
check_bin_file("${test}.bin", bytes(0xc6, 0x42));

capture_nok("z88dk-z80asm -mz80_strict -b ${test}.asm", <<END);
$test.asm:1: error: illegal identifier
  ^---- add 0x42
      ^---- add 66
END

spew("${test}.asm", <<'END');
    ld ixh, 0
END

capture_ok("z88dk-z80asm -mz80 -b ${test}.asm", "");
check_bin_file("${test}.bin", bytes(0xdd, 0x26, 0x00));

capture_nok("z88dk-z80asm -mz80_strict -b ${test}.asm", <<END);
$test.asm:1: error: illegal identifier
  ^---- ld ixh, 0
END

spew("${test}.asm", <<'END');
    ld bc, de
END

capture_ok("z88dk-z80asm -mz80 -b ${test}.asm", "");
check_bin_file("${test}.bin", bytes(0x42, 0x4b));

capture_nok("z88dk-z80asm -mz80_strict -b ${test}.asm", <<END);
$test.asm:1: error: illegal identifier
  ^---- ld bc, de
END

capture_nok("z88dk-z80asm -mz80 -no-synth -b ${test}.asm", <<END);
$test.asm:1: error: illegal identifier
  ^---- ld bc, de
END

capture_nok("z88dk-z80asm -mz80_strict -no-synth -b ${test}.asm", <<END);
$test.asm:1: error: illegal identifier
  ^---- ld bc, de
END

unlink_testfiles;
done_testing;
