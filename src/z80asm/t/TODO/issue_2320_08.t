#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2320
# z80asm: do not link with object files built for a different cpu


# make sources
unlink_testfiles;
spew("$test.a.asm", <<'END');
SECTION code2
a:	ld      hl,16384
END

spew("$test.b.asm", <<'END');
MODULE b
SECTION code
b:	ld      hl,32768
END


# building library for diferent incompatible cpus - give .o

capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mr3k $test.b.asm", "");
capture_nok("z88dk-z80asm -x$test.lib -mz80 $test.*.o", <<'END');
error: CPU incompatible: file test_t_issue_2320_08.b.o compiled for r3k, incompatible with z80
END


unlink_testfiles;
done_testing;
