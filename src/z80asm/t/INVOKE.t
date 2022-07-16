#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

z80asm_nok("", "", "invoke 0", <<END);
$test.asm:1: error: illegal identifier
  ^---- invoke 0
END

z80asm_ok("-b -mti83",     "", "", "invoke 0", bytes(0xcd, 0, 0));
z80asm_ok("-b -mti83plus", "", "", "invoke 0", bytes(0xef, 0, 0));

z80asm_ok("-b -mti83",     "", "", "invoke 1", bytes(0xcd, 1, 0));
z80asm_ok("-b -mti83plus", "", "", "invoke 1", bytes(0xef, 1, 0));

z80asm_ok("-b -mti83",     "", "", "invoke 65535", bytes(0xcd, 0xff, 0xff));
z80asm_ok("-b -mti83plus", "", "", "invoke 65535", bytes(0xef, 0xff, 0xff));

z80asm_nok("-b -mti83", "", "invoke -1", <<END);
$test.asm:1: error: integer range: -1
  ^---- invoke -1
END

z80asm_nok("-b -mti83plus", "", "invoke -1", <<END);
$test.asm:1: error: integer range: -1
  ^---- invoke -1
END

unlink_testfiles;
done_testing;
