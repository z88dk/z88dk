#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2320
# z80asm: do not link with object files built for a different cpu


# use -d, different CPU, o file newer
unlink_testfiles;
spew("$test.asm", "nop");
sleep(1);
capture_ok("z88dk-z80asm -mr3k $test.asm", "");
capture_nok("z88dk-z80asm -d -x$test.lib -mz80 $test.o", <<'END');
error: CPU incompatible: file test_t_issue_2320_04.o compiled for r3k, incompatible with z80
END

capture_ok("z88dk-z80asm -mr3k $test.asm", "");
capture_nok("z88dk-z80asm -d -x$test.lib -mz80 $test.asm", <<'END');
error: CPU incompatible: file test_t_issue_2320_04.o compiled for r3k, incompatible with z80
END


unlink_testfiles;
done_testing;
