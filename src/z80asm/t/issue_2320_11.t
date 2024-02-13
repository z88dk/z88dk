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


# building -m* library - give .o

capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mr3k $test.b.asm", "");
capture_ok("z88dk-z80asm -v -x$test.lib -m* ".quote_os("$test.*.o"), <<END);
% z88dk-z80asm -v -x$test.lib -m* ${\os_quoted("$test.*.o")}
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Creating library '$test.lib'
Predefined constant: __CPU_Z80N__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Adding $test.a.o to library
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __CPU_Z180__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __CPU_R800__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __CPU_KC160_Z80__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __CPU_Z80_STRICT__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __CPU_R3K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __CPU_8085__ = 1
Predefined constant: __CPU_INTEL__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __CPU_R5K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __CPU_EZ80_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __CPU_EZ80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __CPU_R2KA__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __CPU_GBZ80__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __CPU_8080__ = 1
Predefined constant: __CPU_INTEL__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __CPU_R4K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __CPU_KC160__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

END

capture_ok("z88dk-z80nm -a $test.lib", <<'END');
Library file test_t_issue_2320_11.lib at $0000: Z80LMF18
Object  file test_t_issue_2320_11.lib at $0014: Z80RMF18
  Name: test_t_issue_2320_11.a
  CPU:  z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_11.a.asm:2)

Object  file test_t_issue_2320_11.lib at $00E8: Z80RMF18
  Name: b
  CPU:  r3k 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_11.b.asm:3)

END


unlink_testfiles;
done_testing;
