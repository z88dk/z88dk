#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# BUG_0043: buffer overflow on constants longer than 128 chars in object file
spew("$test.1.asm", <<END);
		public one
		defc one = 1
END

my $sum = join("+", ('one') x 1000);
z80asm_ok("", "$test.asm $test.1.asm", "", <<END, words(1000));
		extern one
		defw $sum
END

capture_ok("z88dk-z80nm -a $test.o", <<END);
Object  file $test.o at \$0000: Z80RMF16
  Name: $test
  Section "": 2 bytes
    C \$0000: 00 00
  Externs:
    U         one
  Expressions:
    E Cw \$0000 \$0000: $sum (section "") (file $test.asm:2)
END

unlink_testfiles;
done_testing;
