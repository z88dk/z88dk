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
Object  file $test.o at \$0000: Z80RMF18
  Name: $test
  CPU:  z80 
  Section "": 2 bytes
    C \$0000: 00 00
  Externs:
    U         one
  Expressions:
    E U16   \$0000 \$0000 2: $sum (section "") (file $test.asm:2)
  Strings:
    S   1 = "test_t_bug_0043_t.asm"
    S   2 = "$sum"
    S   3 = "one"
    S   4 = "test_t_bug_0043_t"
END

unlink_testfiles;
done_testing;
