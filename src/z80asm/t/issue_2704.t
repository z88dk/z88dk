#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

spew("$test.asm", <<END);
		rlb a, bcde
		rlb a, jkhl
		rrb a, bcde
		rrb a, jkhl
END

capture_ok("z88dk-z80asm -mr4k -l -b $test.asm", "");
check_bin_file("$test.bin", bytes(0xDD, 0x6F, 0xFD, 0x6F, 0xDD, 0x7F, 0xFD, 0x7F));
check_text_file("$test.lis", <<END);
test_t_issue_2704.asm:
     1  0000  dd6f              		rlb a, bcde
     2  0002  fd6f              		rlb a, jkhl
     3  0004  dd7f              		rrb a, bcde
     4  0006  fd7f              		rrb a, jkhl
     5                          
END

capture_ok("z88dk-dis -mr4k $test.bin", <<END);
                    rlb       a,bcde                        ;[0000] dd 6f
                    rlb       a,jkhl                        ;[0002] fd 6f
                    rrb       a,bcde                        ;[0004] dd 7f
                    rrb       a,jkhl                        ;[0006] fd 7f
END

unlink_testfiles;
done_testing;
