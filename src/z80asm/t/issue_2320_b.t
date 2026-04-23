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
# building -m* library - give .asm
#------------------------------------------------------------------------------

capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mr3k $test.b.asm", "");
capture_ok("z88dk-z80asm -v -x$test.lib -m* ".quote_os("$test.*.asm"), <<END);
% z88dk-z80asm -v -xtest_t_issue_2320_b_t.lib -m* ${\os_quoted("test_t_issue_2320_b_t.*.asm")}
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Creating library 'test_t_issue_2320_b_t.lib'
Predefined constant: __CPU_Z80N__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __CPU_R6K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __CPU_Z180__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __CPU_R3K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __CPU_8085__ = 1
Predefined constant: __CPU_INTEL__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __CPU_R800__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __CPU_R5K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __CPU_KC160_Z80__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __CPU_EZ80_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __CPU_EZ80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __CPU_R2KA__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __CPU_GBZ80__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __CPU_8080__ = 1
Predefined constant: __CPU_INTEL__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __CPU_R4K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __CPU_KC160__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320_b_t.a.asm'
Writing object file 'test_t_issue_2320_b_t.a.o'

Assembling 'test_t_issue_2320_b_t.b.asm'
Writing object file 'test_t_issue_2320_b_t.b.o'

Adding test_t_issue_2320_b_t.a.o to library
Adding test_t_issue_2320_b_t.b.o to library

Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
END

capture_ok("z88dk-z80nm -a $test.lib", <<'END');
Library file test_t_issue_2320_b_t.lib at $0000: Z80LMF18
Object  file test_t_issue_2320_b_t.lib at $0014: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  z80n 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $00EC: Z80RMF18
  Name: b
  CPU:  z80n 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $01A4: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  z80n (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $027C: Z80RMF18
  Name: b
  CPU:  z80n (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $0334: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  r6k 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $040C: Z80RMF18
  Name: b
  CPU:  r6k 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $04C4: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  r6k (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $059C: Z80RMF18
  Name: b
  CPU:  r6k (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $0654: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $072C: Z80RMF18
  Name: b
  CPU:  z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $07E4: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  z80 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $08BC: Z80RMF18
  Name: b
  CPU:  z80 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $0974: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  z180 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $0A4C: Z80RMF18
  Name: b
  CPU:  z180 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $0B04: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  z180 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $0BDC: Z80RMF18
  Name: b
  CPU:  z180 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $0C94: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  r3k 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $0D6C: Z80RMF18
  Name: b
  CPU:  r3k 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $0E24: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  r3k (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $0EFC: Z80RMF18
  Name: b
  CPU:  r3k (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $0FB4: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  8085 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $108C: Z80RMF18
  Name: b
  CPU:  8085 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $1144: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  8085 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $121C: Z80RMF18
  Name: b
  CPU:  8085 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $12D4: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  r800 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $13AC: Z80RMF18
  Name: b
  CPU:  r800 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $1464: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  r800 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $153C: Z80RMF18
  Name: b
  CPU:  r800 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $15F4: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  r5k 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $16CC: Z80RMF18
  Name: b
  CPU:  r5k 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $1784: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  r5k (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $185C: Z80RMF18
  Name: b
  CPU:  r5k (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $1914: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  kc160_z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $19EC: Z80RMF18
  Name: b
  CPU:  kc160_z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $1AA4: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  kc160_z80 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $1B7C: Z80RMF18
  Name: b
  CPU:  kc160_z80 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $1C34: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  ez80_z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $1D0C: Z80RMF18
  Name: b
  CPU:  ez80_z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $1DC4: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  ez80_z80 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $1E9C: Z80RMF18
  Name: b
  CPU:  ez80_z80 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $1F54: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  ez80 
  Section "": 0 bytes
  Section code2: 4 bytes
    C $0000: 21 00 40 00
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $202C: Z80RMF18
  Name: b
  CPU:  ez80 
  Section "": 0 bytes
  Section code: 4 bytes
    C $0000: 21 00 80 00
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $20E4: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  ez80 (-IXIY)
  Section "": 0 bytes
  Section code2: 4 bytes
    C $0000: 21 00 40 00
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $21BC: Z80RMF18
  Name: b
  CPU:  ez80 (-IXIY)
  Section "": 0 bytes
  Section code: 4 bytes
    C $0000: 21 00 80 00
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $2274: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  r2ka 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $234C: Z80RMF18
  Name: b
  CPU:  r2ka 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $2404: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  r2ka (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $24DC: Z80RMF18
  Name: b
  CPU:  r2ka (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $2594: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  gbz80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $266C: Z80RMF18
  Name: b
  CPU:  gbz80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $2724: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  gbz80 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $27FC: Z80RMF18
  Name: b
  CPU:  gbz80 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $28B4: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  8080 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $298C: Z80RMF18
  Name: b
  CPU:  8080 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $2A44: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  8080 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $2B1C: Z80RMF18
  Name: b
  CPU:  8080 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $2BD4: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  r4k 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $2CAC: Z80RMF18
  Name: b
  CPU:  r4k 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $2D64: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  r4k (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $2E3C: Z80RMF18
  Name: b
  CPU:  r4k (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $2EF4: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  kc160 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $2FCC: Z80RMF18
  Name: b
  CPU:  kc160 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

Object  file test_t_issue_2320_b_t.lib at $3084: Z80RMF18
  Name: test_t_issue_2320_b_t.a
  CPU:  kc160 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_b_t.a.asm:2)

Object  file test_t_issue_2320_b_t.lib at $315C: Z80RMF18
  Name: b
  CPU:  kc160 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_b_t.b.asm:3)

END

unlink_testfiles;
done_testing;
