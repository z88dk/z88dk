#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2463
# z80asm: run m4 on file.asm.m4

spew("$test.asm.m4", <<'END');
define(`one', defb 1
)
define(`two', defb 2
)
define(`three', defb 3
)
define(`input', defb INPUT
)
one two three input
END

capture_ok("z88dk-z80asm -v -b -m4=-DINPUT=4 $test.asm.m4", <<'END');
% z88dk-z80asm -v -b -m4=-DINPUT=4 test_t_issue_2463.asm.m4
% m4 -DINPUT=4  "test_t_issue_2463.asm.m4" > "test_t_issue_2463.asm"
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Assembling 'test_t_issue_2463.asm'
Writing object file 'test_t_issue_2463.o'

Code size: 4 bytes ($0000 to $0003)
Creating binary 'test_t_issue_2463.bin'
END

check_bin_file("$test.bin", bytes(1,2,3,4));

unlink_testfiles;
done_testing;

