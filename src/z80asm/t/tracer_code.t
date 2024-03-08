#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# test the minimal assembler as it evolves
spew("$test.asm", <<END);
.l1
l1:
END

capture_nok("z88dk-z80asm $test.asm", <<END);
test_t_tracer_code.asm:2: error: duplicate definition: l1
  ^---- l1:
END

spew("$test.asm", <<END);

	nop
.l1	nop
l2:	nop

END

capture_nok("z88dk-z80asm $test.asm", <<END);
test_t_tracer_code.o: error: file not found: test_t_tracer_code.o
END

unlink_testfiles;
done_testing;
