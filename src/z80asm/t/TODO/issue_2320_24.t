#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2320
# z80asm: do not link with object files built for a different cpu


# test use-after-delete modlink - fails on Linux

unlink_testfiles;
spew("$test.1.asm", <<'END');
			public the_answer
	the_answer = 42
END

unlink("$test.1.o", "$test.1.lib");
capture_ok("z88dk-z80asm -x$test.1.lib $test.1.asm", "");
unlink("$test.1.o", "$test.1.asm");

spew("$test.asm", <<'END');
	extern the_answer
	defb the_answer
END

unlink("$test.o", "$test.bin");
capture_ok("z88dk-z80asm -b -m -l$test.1.lib $test.asm", "");
check_bin_file("$test.bin", bytes(42));
check_text_file("$test.map", <<'END');
the_answer                      = $002A ; const, public, , test_t_issue_2320_24.1, , test_t_issue_2320_24.1.asm:2
__head                          = $0000 ; const, public, def, , ,
__tail                          = $0001 ; const, public, def, , ,
__size                          = $0001 ; const, public, def, , ,
END


unlink_testfiles;
done_testing;
