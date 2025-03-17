#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2320
# z80asm: do not link with object files built for a different cpu

#------------------------------------------------------------------------------
# make sources
#------------------------------------------------------------------------------

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

#------------------------------------------------------------------------------
# not-existing object file - give .asm
#------------------------------------------------------------------------------

capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mr3k $test.b.asm", "");
unlink("$test.b.o");
capture_ok("z88dk-z80asm -v -x$test.lib -mz80 ".quote_os("$test.*.asm"), <<END);
% z88dk-z80asm -v -xtest_t_issue_2320_k.lib -mz80 ${\os_quoted("test_t_issue_2320_k.*.asm")}
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Assembling 'test_t_issue_2320_k.a.asm'
Writing object file 'test_t_issue_2320_k.a.o'

Assembling 'test_t_issue_2320_k.b.asm'
Writing object file 'test_t_issue_2320_k.b.o'

Creating library 'test_t_issue_2320_k.lib'
Adding test_t_issue_2320_k.a.o to library
Adding test_t_issue_2320_k.b.o to library
END

capture_ok("z88dk-z80nm -a $test.lib", <<'END');
Library file test_t_issue_2320_k.lib at $0000: Z80LMF18
Object  file test_t_issue_2320_k.lib at $0014: Z80RMF18
  Name: test_t_issue_2320_k.a
  CPU:  z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_k.a.asm:2)

Object  file test_t_issue_2320_k.lib at $00E8: Z80RMF18
  Name: b
  CPU:  z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_k.b.asm:3)

END

unlink_testfiles;
done_testing;
