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


# building -m* library - give .asm

capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mr3k $test.b.asm", "");
capture_ok("z88dk-z80asm -v -x$test.lib -m* ".quote_os("$test.*.asm"), <<END);
% z88dk-z80asm -v -x$test.lib -m* ${\os_quoted("$test.*.asm")}
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Creating library '$test.lib'
Predefined constant: __CPU_Z80N__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __CPU_Z180__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __CPU_R800__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __CPU_KC160_Z80__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __CPU_Z80_STRICT__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __CPU_R3K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __CPU_8085__ = 1
Predefined constant: __CPU_INTEL__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __CPU_R5K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __CPU_EZ80_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __CPU_EZ80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __CPU_R2KA__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __CPU_GBZ80__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __CPU_8080__ = 1
Predefined constant: __CPU_INTEL__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __CPU_R4K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __CPU_KC160__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

END

capture_ok("z88dk-z80nm -a $test.lib", <<'END');
Library file test_t_issue_2320_12.lib at $0000: Z80LMF18
Object  file test_t_issue_2320_12.lib at $0014: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  z80n 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $00E8: Z80RMF18
  Name: b
  CPU:  z80n 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $01A0: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  z80n (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $0274: Z80RMF18
  Name: b
  CPU:  z80n (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $032C: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $0400: Z80RMF18
  Name: b
  CPU:  z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $04B8: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  z80 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $058C: Z80RMF18
  Name: b
  CPU:  z80 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $0644: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  z180 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $0718: Z80RMF18
  Name: b
  CPU:  z180 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $07D0: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  z180 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $08A4: Z80RMF18
  Name: b
  CPU:  z180 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $095C: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  r800 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $0A30: Z80RMF18
  Name: b
  CPU:  r800 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $0AE8: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  r800 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $0BBC: Z80RMF18
  Name: b
  CPU:  r800 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $0C74: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  kc160_z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $0D48: Z80RMF18
  Name: b
  CPU:  kc160_z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $0E00: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  kc160_z80 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $0ED4: Z80RMF18
  Name: b
  CPU:  kc160_z80 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $0F8C: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  z80_strict 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $1060: Z80RMF18
  Name: b
  CPU:  z80_strict 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $1118: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  z80_strict (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $11EC: Z80RMF18
  Name: b
  CPU:  z80_strict (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $12A4: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  r3k 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $1378: Z80RMF18
  Name: b
  CPU:  r3k 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $1430: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  r3k (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $1504: Z80RMF18
  Name: b
  CPU:  r3k (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $15BC: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  8085 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $1690: Z80RMF18
  Name: b
  CPU:  8085 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $1748: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  8085 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $181C: Z80RMF18
  Name: b
  CPU:  8085 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $18D4: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  r5k 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $19A8: Z80RMF18
  Name: b
  CPU:  r5k 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $1A60: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  r5k (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $1B34: Z80RMF18
  Name: b
  CPU:  r5k (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $1BEC: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  ez80_z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $1CC0: Z80RMF18
  Name: b
  CPU:  ez80_z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $1D78: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  ez80_z80 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $1E4C: Z80RMF18
  Name: b
  CPU:  ez80_z80 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $1F04: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  ez80 
  Section "": 0 bytes
  Section code2: 4 bytes
    C $0000: 21 00 40 00
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $1FD8: Z80RMF18
  Name: b
  CPU:  ez80 
  Section "": 0 bytes
  Section code: 4 bytes
    C $0000: 21 00 80 00
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $2090: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  ez80 (-IXIY)
  Section "": 0 bytes
  Section code2: 4 bytes
    C $0000: 21 00 40 00
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $2164: Z80RMF18
  Name: b
  CPU:  ez80 (-IXIY)
  Section "": 0 bytes
  Section code: 4 bytes
    C $0000: 21 00 80 00
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $221C: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  r2ka 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $22F0: Z80RMF18
  Name: b
  CPU:  r2ka 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $23A8: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  r2ka (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $247C: Z80RMF18
  Name: b
  CPU:  r2ka (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $2534: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  gbz80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $2608: Z80RMF18
  Name: b
  CPU:  gbz80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $26C0: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  gbz80 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $2794: Z80RMF18
  Name: b
  CPU:  gbz80 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $284C: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  8080 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $2920: Z80RMF18
  Name: b
  CPU:  8080 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $29D8: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  8080 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $2AAC: Z80RMF18
  Name: b
  CPU:  8080 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $2B64: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  r4k 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $2C38: Z80RMF18
  Name: b
  CPU:  r4k 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $2CF0: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  r4k (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $2DC4: Z80RMF18
  Name: b
  CPU:  r4k (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $2E7C: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  kc160 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $2F50: Z80RMF18
  Name: b
  CPU:  kc160 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

Object  file test_t_issue_2320_12.lib at $3008: Z80RMF18
  Name: test_t_issue_2320_12.a
  CPU:  kc160 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320_12.a.asm:2)

Object  file test_t_issue_2320_12.lib at $30DC: Z80RMF18
  Name: b
  CPU:  kc160 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320_12.b.asm:3)

END


unlink_testfiles;
done_testing;
