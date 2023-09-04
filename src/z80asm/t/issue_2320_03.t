#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2320
# z80asm: do not link with object files built for a different cpu


# use -d, different CPU, asm file newer
unlink_testfiles;
spew("$test.asm", "nop");
capture_ok("z88dk-z80asm -mr3k $test.asm", "");
sleep(1);
spew("$test.asm", "nop");
capture_ok("z88dk-z80asm -d -v -x$test.lib -mz80 $test.o", <<'END');
% z88dk-z80asm -d -v -xtest_t_issue_2320_03.lib -mz80 test_t_issue_2320_03.o
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Assembling 'test_t_issue_2320_03.asm'
Writing object file 'test_t_issue_2320_03.o'

Creating library 'test_t_issue_2320_03.lib'
Adding test_t_issue_2320_03.o to library
END

capture_ok("z88dk-z80nm -a $test.lib", <<'END');
Library file test_t_issue_2320_03.lib at $0000: Z80LMF18
Object  file test_t_issue_2320_03.lib at $0014: Z80RMF18
  Name: test_t_issue_2320_03
  CPU:  z80 
  Section "": 1 bytes
    C $0000: 00

END


sleep(1);
spew("$test.asm", "nop");
capture_ok("z88dk-z80asm -d -v -x$test.lib -mz80 $test.asm", <<'END');
% z88dk-z80asm -d -v -xtest_t_issue_2320_03.lib -mz80 test_t_issue_2320_03.asm
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Assembling 'test_t_issue_2320_03.asm'
Writing object file 'test_t_issue_2320_03.o'

Creating library 'test_t_issue_2320_03.lib'
Adding test_t_issue_2320_03.o to library
END

capture_ok("z88dk-z80nm -a $test.lib", <<'END');
Library file test_t_issue_2320_03.lib at $0000: Z80LMF18
Object  file test_t_issue_2320_03.lib at $0014: Z80RMF18
  Name: test_t_issue_2320_03
  CPU:  z80 
  Section "": 1 bytes
    C $0000: 00

END


unlink_testfiles;
done_testing;
