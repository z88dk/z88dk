#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2320
# z80asm: do not link with object files built for a different cpu


# test invalid CPU

unlink_testfiles;
spew("$test.asm", "nop");
sleep(1);

spew("$test.o", objfile(CPU=>-1));

capture_ok("z88dk-z80nm -a $test.o", <<'END');
Object  file test_t_issue_2320_01.o at $0000: Z80RMF18
  Name: test
  CPU:  (invalid -1) 
END

capture_nok("z88dk-z80asm -b $test.o", <<'END');
error: CPU invalid: file test_t_issue_2320_01.o, cpu_id = -1
END

capture_nok("z88dk-z80asm -d -b $test.o", <<'END');
error: CPU invalid: file test_t_issue_2320_01.o, cpu_id = -1
END

sleep(1);
spew("$test.asm", "nop");

capture_ok("z88dk-z80asm -d -b $test.o", "");
check_bin_file("$test.bin", bytes(0));


unlink_testfiles;
done_testing;
