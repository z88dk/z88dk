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


# building library for diferent incompatible cpus - give .asm

capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mr3k $test.b.asm", "");
capture_ok("z88dk-z80asm -v -x$test.lib -mz80 ".quote_os("$test.*.asm"), <<END);
% z88dk-z80asm -v -x$test.lib -mz80 ${\os_quoted("$test.*.asm")}
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Creating library '$test.lib'
Adding $test.a.o to library
Adding $test.b.o to library
END

capture_ok("z88dk-z80nm -a $test.lib", <<'END');
Library file test_t_issue_2320_09.lib at $0000: Z80LMF18
Object  file test_t_issue_2320_09.lib at $0014: Z80RMF18
  Name: test_t_issue_2320_09.a
  CPU:  z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_09.a.asm:2)

Object  file test_t_issue_2320_09.lib at $00E8: Z80RMF18
  Name: b
  CPU:  z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_09.b.asm:3)

END


unlink_testfiles;
done_testing;
