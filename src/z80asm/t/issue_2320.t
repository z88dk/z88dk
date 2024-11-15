#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2320
# z80asm: do not link with object files built for a different cpu

#------------------------------------------------------------------------------
# test invalid CPU
#------------------------------------------------------------------------------

unlink_testfiles;
spew("$test.asm", "nop");
sleep(1);

spew("$test.o", objfile(CPU=>-1));

capture_ok("z88dk-z80nm -a $test.o", <<'END');
Object  file test_t_issue_2320.o at $0000: Z80RMF18
  Name: test
  CPU:  (invalid -1) 
END

capture_nok("z88dk-z80asm -b $test.o", <<'END');
error: CPU invalid: file test_t_issue_2320.o, cpu_id = -1
END

capture_nok("z88dk-z80asm -d -b $test.o", <<'END');
error: CPU invalid: file test_t_issue_2320.o, cpu_id = -1
END

sleep(1);
spew("$test.asm", "nop");

capture_ok("z88dk-z80asm -d -b $test.o", "");
check_bin_file("$test.bin", bytes(0));

#------------------------------------------------------------------------------
# -M* and -d are incompatible
#------------------------------------------------------------------------------

unlink_testfiles;
spew("$test.asm", "nop");
capture_nok("z88dk-z80asm -d -m* -x$test.lib $test", <<'END');
error: cannot build libraries with -m* and -d
END

#------------------------------------------------------------------------------
# use -d, different CPU, asm file newer
#------------------------------------------------------------------------------

unlink_testfiles;
spew("$test.asm", "nop");
capture_ok("z88dk-z80asm -mr3k $test.asm", "");
sleep(1);
spew("$test.asm", "nop");
capture_ok("z88dk-z80asm -d -v -x$test.lib -mz80 $test.o", <<'END');
% z88dk-z80asm -d -v -xtest_t_issue_2320.lib -mz80 test_t_issue_2320.o
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Assembling 'test_t_issue_2320.asm'
Writing object file 'test_t_issue_2320.o'

Creating library 'test_t_issue_2320.lib'
Adding test_t_issue_2320.o to library
END

capture_ok("z88dk-z80nm -a $test.lib", <<'END');
Library file test_t_issue_2320.lib at $0000: Z80LMF18
Object  file test_t_issue_2320.lib at $0014: Z80RMF18
  Name: test_t_issue_2320
  CPU:  z80 
  Section "": 1 bytes
    C $0000: 00

END

sleep(1);
spew("$test.asm", "nop");
capture_ok("z88dk-z80asm -d -v -x$test.lib -mz80 $test.asm", <<'END');
% z88dk-z80asm -d -v -xtest_t_issue_2320.lib -mz80 test_t_issue_2320.asm
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Assembling 'test_t_issue_2320.asm'
Writing object file 'test_t_issue_2320.o'

Creating library 'test_t_issue_2320.lib'
Adding test_t_issue_2320.o to library
END

capture_ok("z88dk-z80nm -a $test.lib", <<'END');
Library file test_t_issue_2320.lib at $0000: Z80LMF18
Object  file test_t_issue_2320.lib at $0014: Z80RMF18
  Name: test_t_issue_2320
  CPU:  z80 
  Section "": 1 bytes
    C $0000: 00

END

#------------------------------------------------------------------------------
# use -d, different CPU, o file newer
#------------------------------------------------------------------------------

unlink_testfiles;
spew("$test.asm", "nop");
sleep(1);
capture_ok("z88dk-z80asm -mr3k $test.asm", "");
capture_nok("z88dk-z80asm -d -x$test.lib -mz80 $test.o", <<'END');
error: CPU incompatible: file test_t_issue_2320.o compiled for r3k, incompatible with z80
END

capture_ok("z88dk-z80asm -mr3k $test.asm", "");
capture_nok("z88dk-z80asm -d -x$test.lib -mz80 $test.asm", <<'END');
error: CPU incompatible: file test_t_issue_2320.o compiled for r3k, incompatible with z80
END

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
# building library for diferent compatible cpus - give .o
#------------------------------------------------------------------------------

capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mz80_strict $test.b.asm", "");
capture_ok("z88dk-z80asm -v -x$test.lib -mz80 ".quote_os("$test.*.o"), <<END);
% z88dk-z80asm -v -x$test.lib -mz80 ${\os_quoted("$test.*.o")}
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Appending object file '$test.a.o'
Appending object file '$test.b.o'
Creating library '$test.lib'
Adding $test.a.o to library
Adding $test.b.o to library
END

capture_ok("z88dk-z80nm -a $test.lib", <<'END');
Library file test_t_issue_2320.lib at $0000: Z80LMF18
Object  file test_t_issue_2320.lib at $0014: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $00E4: Z80RMF18
  Name: b
  CPU:  z80_strict 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

END

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
# building library for diferent compatible cpus - give .asm
#------------------------------------------------------------------------------

capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mz80_strict $test.b.asm", "");
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
Library file test_t_issue_2320.lib at $0000: Z80LMF18
Object  file test_t_issue_2320.lib at $0014: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $00E4: Z80RMF18
  Name: b
  CPU:  z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

END

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
# building library for diferent compatible cpus - give basename
#------------------------------------------------------------------------------

capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mz80_strict $test.b.asm", "");
capture_ok("z88dk-z80asm -v -x$test.lib -mz80 $test.a $test.b", <<'END');
% z88dk-z80asm -v -xtest_t_issue_2320.lib -mz80 test_t_issue_2320.a test_t_issue_2320.b
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Creating library 'test_t_issue_2320.lib'
Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library
END

capture_ok("z88dk-z80nm -a $test.lib", <<'END');
Library file test_t_issue_2320.lib at $0000: Z80LMF18
Object  file test_t_issue_2320.lib at $0014: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $00E4: Z80RMF18
  Name: b
  CPU:  z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

END

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
# building library for diferent incompatible cpus - give .o
#------------------------------------------------------------------------------

capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mr3k $test.b.asm", "");
capture_nok("z88dk-z80asm -x$test.lib -mz80 $test.*.o", <<'END');
error: CPU incompatible: file test_t_issue_2320.b.o compiled for r3k, incompatible with z80
END

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
# building library for diferent incompatible cpus - give .asm
#------------------------------------------------------------------------------

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
Library file test_t_issue_2320.lib at $0000: Z80LMF18
Object  file test_t_issue_2320.lib at $0014: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $00E4: Z80RMF18
  Name: b
  CPU:  z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

END

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
# building library for diferent incompatible cpus - give basename
#------------------------------------------------------------------------------

capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mr3k $test.b.asm", "");
capture_ok("z88dk-z80asm -v -x$test.lib -mz80 $test.a $test.b", <<'END');
% z88dk-z80asm -v -xtest_t_issue_2320.lib -mz80 test_t_issue_2320.a test_t_issue_2320.b
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Creating library 'test_t_issue_2320.lib'
Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library
END

capture_ok("z88dk-z80nm -a $test.lib", <<'END');
Library file test_t_issue_2320.lib at $0000: Z80LMF18
Object  file test_t_issue_2320.lib at $0014: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $00E4: Z80RMF18
  Name: b
  CPU:  z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

END


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
# building -m* library - give .o
#------------------------------------------------------------------------------

capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mr3k $test.b.asm", "");
capture_ok("z88dk-z80asm -v -x$test.lib -m* ".quote_os("$test.*.o"), <<'END');
% z88dk-z80asm -v -xtest_t_issue_2320.lib -m* "test_t_issue_2320.*.o"
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Creating library 'test_t_issue_2320.lib'
Predefined constant: __CPU_Z80N__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Adding test_t_issue_2320.a.o to library
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

Predefined constant: __CPU_Z180__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

Predefined constant: __CPU_R800__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

Predefined constant: __CPU_KC160_Z80__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

Predefined constant: __CPU_R3K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

Predefined constant: __CPU_8080__ = 1
Predefined constant: __CPU_INTEL__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

Predefined constant: __CPU_8085__ = 1
Predefined constant: __CPU_INTEL__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

Predefined constant: __CPU_R5K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

Predefined constant: __CPU_EZ80_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

Predefined constant: __CPU_EZ80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

Predefined constant: __CPU_R2KA__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

Predefined constant: __CPU_GBZ80__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

Predefined constant: __CPU_R4K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

Predefined constant: __CPU_KC160__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.a.o - different CPU-IXIY combination
Skipping test_t_issue_2320.b.o - different CPU-IXIY combination

END

capture_ok("z88dk-z80nm -a $test.lib", <<'END');
Library file test_t_issue_2320.lib at $0000: Z80LMF18
Object  file test_t_issue_2320.lib at $0014: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $00E4: Z80RMF18
  Name: b
  CPU:  r3k 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

END


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
capture_ok("z88dk-z80asm -v -x$test.lib -m* ".quote_os("$test.*.asm"), <<'END');
% z88dk-z80asm -v -xtest_t_issue_2320.lib -m* "test_t_issue_2320.*.asm"
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Creating library 'test_t_issue_2320.lib'
Predefined constant: __CPU_Z80N__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_Z180__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_R800__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_KC160_Z80__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_R3K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_8085__ = 1
Predefined constant: __CPU_INTEL__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_8080__ = 1
Predefined constant: __CPU_INTEL__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_R5K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_EZ80_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_EZ80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_R2KA__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_GBZ80__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_R4K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_KC160__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

END

capture_ok("z88dk-z80nm -a $test.lib", <<'END');
Library file test_t_issue_2320.lib at $0000: Z80LMF18
Object  file test_t_issue_2320.lib at $0014: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80n 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $00E4: Z80RMF18
  Name: b
  CPU:  z80n 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $0198: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80n (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $0268: Z80RMF18
  Name: b
  CPU:  z80n (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $031C: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $03EC: Z80RMF18
  Name: b
  CPU:  z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $04A0: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $0570: Z80RMF18
  Name: b
  CPU:  z80 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $0624: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z180 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $06F4: Z80RMF18
  Name: b
  CPU:  z180 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $07A8: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z180 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $0878: Z80RMF18
  Name: b
  CPU:  z180 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $092C: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r800 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $09FC: Z80RMF18
  Name: b
  CPU:  r800 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $0AB0: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r800 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $0B80: Z80RMF18
  Name: b
  CPU:  r800 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $0C34: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  kc160_z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $0D04: Z80RMF18
  Name: b
  CPU:  kc160_z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $0DB8: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  kc160_z80 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $0E88: Z80RMF18
  Name: b
  CPU:  kc160_z80 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $0F3C: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80_strict 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $100C: Z80RMF18
  Name: b
  CPU:  z80_strict 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $10C0: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80_strict (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $1190: Z80RMF18
  Name: b
  CPU:  z80_strict (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $1244: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r3k 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $1314: Z80RMF18
  Name: b
  CPU:  r3k 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $13C8: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r3k (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $1498: Z80RMF18
  Name: b
  CPU:  r3k (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $154C: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  8085 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $161C: Z80RMF18
  Name: b
  CPU:  8085 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $16D0: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  8085 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $17A0: Z80RMF18
  Name: b
  CPU:  8085 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $1854: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r5k 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $1924: Z80RMF18
  Name: b
  CPU:  r5k 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $19D8: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r5k (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $1AA8: Z80RMF18
  Name: b
  CPU:  r5k (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $1B5C: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  ez80_z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $1C2C: Z80RMF18
  Name: b
  CPU:  ez80_z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $1CE0: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  ez80_z80 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $1DB0: Z80RMF18
  Name: b
  CPU:  ez80_z80 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $1E64: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  ez80 
  Section "": 0 bytes
  Section code2: 4 bytes
    C $0000: 21 00 40 00
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $1F34: Z80RMF18
  Name: b
  CPU:  ez80 
  Section "": 0 bytes
  Section code: 4 bytes
    C $0000: 21 00 80 00
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $1FE8: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  ez80 (-IXIY)
  Section "": 0 bytes
  Section code2: 4 bytes
    C $0000: 21 00 40 00
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $20B8: Z80RMF18
  Name: b
  CPU:  ez80 (-IXIY)
  Section "": 0 bytes
  Section code: 4 bytes
    C $0000: 21 00 80 00
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $216C: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r2ka 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $223C: Z80RMF18
  Name: b
  CPU:  r2ka 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $22F0: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r2ka (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $23C0: Z80RMF18
  Name: b
  CPU:  r2ka (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $2474: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  gbz80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $2544: Z80RMF18
  Name: b
  CPU:  gbz80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $25F8: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  gbz80 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $26C8: Z80RMF18
  Name: b
  CPU:  gbz80 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $277C: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  8080 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $284C: Z80RMF18
  Name: b
  CPU:  8080 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $2900: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  8080 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $29D0: Z80RMF18
  Name: b
  CPU:  8080 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $2A84: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r4k 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $2B54: Z80RMF18
  Name: b
  CPU:  r4k 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $2C08: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r4k (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $2CD8: Z80RMF18
  Name: b
  CPU:  r4k (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $2D8C: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  kc160 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $2E5C: Z80RMF18
  Name: b
  CPU:  kc160 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $2F10: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  kc160 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $2FE0: Z80RMF18
  Name: b
  CPU:  kc160 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

END


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
# building -m* library - give .basename
#------------------------------------------------------------------------------

capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mr3k $test.b.asm", "");
capture_ok("z88dk-z80asm -v -x$test.lib -m* $test.a $test.b", <<'END');
% z88dk-z80asm -v -xtest_t_issue_2320.lib -m* test_t_issue_2320.a test_t_issue_2320.b
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Creating library 'test_t_issue_2320.lib'
Predefined constant: __CPU_Z80N__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_Z180__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_R800__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_KC160_Z80__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_Z80_STRICT__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_R3K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_8085__ = 1
Predefined constant: __CPU_INTEL__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_R5K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_EZ80_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_EZ80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_R2KA__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_GBZ80__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_8080__ = 1
Predefined constant: __CPU_INTEL__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_R4K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_KC160__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

END

capture_ok("z88dk-z80nm -a $test.lib", <<'END');
Library file test_t_issue_2320.lib at $0000: Z80LMF18
Object  file test_t_issue_2320.lib at $0014: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80n 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $00E4: Z80RMF18
  Name: b
  CPU:  z80n 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $0198: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80n (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $0268: Z80RMF18
  Name: b
  CPU:  z80n (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $031C: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $03EC: Z80RMF18
  Name: b
  CPU:  z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $04A0: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $0570: Z80RMF18
  Name: b
  CPU:  z80 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $0624: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z180 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $06F4: Z80RMF18
  Name: b
  CPU:  z180 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $07A8: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z180 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $0878: Z80RMF18
  Name: b
  CPU:  z180 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $092C: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r800 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $09FC: Z80RMF18
  Name: b
  CPU:  r800 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $0AB0: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r800 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $0B80: Z80RMF18
  Name: b
  CPU:  r800 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $0C34: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  kc160_z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $0D04: Z80RMF18
  Name: b
  CPU:  kc160_z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $0DB8: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  kc160_z80 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $0E88: Z80RMF18
  Name: b
  CPU:  kc160_z80 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $0F3C: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80_strict 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $100C: Z80RMF18
  Name: b
  CPU:  z80_strict 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $10C0: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80_strict (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $1190: Z80RMF18
  Name: b
  CPU:  z80_strict (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $1244: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r3k 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $1314: Z80RMF18
  Name: b
  CPU:  r3k 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $13C8: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r3k (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $1498: Z80RMF18
  Name: b
  CPU:  r3k (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $154C: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  8085 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $161C: Z80RMF18
  Name: b
  CPU:  8085 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $16D0: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  8085 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $17A0: Z80RMF18
  Name: b
  CPU:  8085 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $1854: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r5k 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $1924: Z80RMF18
  Name: b
  CPU:  r5k 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $19D8: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r5k (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $1AA8: Z80RMF18
  Name: b
  CPU:  r5k (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $1B5C: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  ez80_z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $1C2C: Z80RMF18
  Name: b
  CPU:  ez80_z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $1CE0: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  ez80_z80 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $1DB0: Z80RMF18
  Name: b
  CPU:  ez80_z80 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $1E64: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  ez80 
  Section "": 0 bytes
  Section code2: 4 bytes
    C $0000: 21 00 40 00
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $1F34: Z80RMF18
  Name: b
  CPU:  ez80 
  Section "": 0 bytes
  Section code: 4 bytes
    C $0000: 21 00 80 00
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $1FE8: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  ez80 (-IXIY)
  Section "": 0 bytes
  Section code2: 4 bytes
    C $0000: 21 00 40 00
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $20B8: Z80RMF18
  Name: b
  CPU:  ez80 (-IXIY)
  Section "": 0 bytes
  Section code: 4 bytes
    C $0000: 21 00 80 00
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $216C: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r2ka 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $223C: Z80RMF18
  Name: b
  CPU:  r2ka 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $22F0: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r2ka (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $23C0: Z80RMF18
  Name: b
  CPU:  r2ka (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $2474: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  gbz80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $2544: Z80RMF18
  Name: b
  CPU:  gbz80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $25F8: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  gbz80 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $26C8: Z80RMF18
  Name: b
  CPU:  gbz80 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $277C: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  8080 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $284C: Z80RMF18
  Name: b
  CPU:  8080 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $2900: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  8080 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $29D0: Z80RMF18
  Name: b
  CPU:  8080 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $2A84: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r4k 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $2B54: Z80RMF18
  Name: b
  CPU:  r4k 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $2C08: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r4k (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $2CD8: Z80RMF18
  Name: b
  CPU:  r4k (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $2D8C: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  kc160 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $2E5C: Z80RMF18
  Name: b
  CPU:  kc160 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

Object  file test_t_issue_2320.lib at $2F10: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  kc160 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $2FE0: Z80RMF18
  Name: b
  CPU:  kc160 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

END


#------------------------------------------------------------------------------
# make sources
#------------------------------------------------------------------------------

unlink_testfiles;
spew("$test.a.as", <<'END');
SECTION code2
a:	ld      hl,16384
END

spew("$test.b.as", <<'END');
MODULE b
SECTION code
b:	ld      hl,32768
END


#------------------------------------------------------------------------------
# any extension - give .o
#------------------------------------------------------------------------------

capture_ok("z88dk-z80asm -mz80 $test.a.as", "");
capture_ok("z88dk-z80asm -mr3k $test.b.as", "");
capture_nok("z88dk-z80asm -x$test.lib -mz80 $test.*.o", <<'END');
error: CPU incompatible: file test_t_issue_2320.b.o compiled for r3k, incompatible with z80
END


#------------------------------------------------------------------------------
# make sources
#------------------------------------------------------------------------------

unlink_testfiles;
spew("$test.a.as", <<'END');
SECTION code2
a:	ld      hl,16384
END

spew("$test.b.as", <<'END');
MODULE b
SECTION code
b:	ld      hl,32768
END


#------------------------------------------------------------------------------
# any extension - give source
#------------------------------------------------------------------------------

capture_ok("z88dk-z80asm -mz80 $test.a.as", "");
capture_ok("z88dk-z80asm -mr3k $test.b.as", "");
capture_ok("z88dk-z80asm -v -x$test.lib -mz80 ".quote_os("$test.*.as"), <<END);
% z88dk-z80asm -v -x$test.lib -mz80 ${\os_quoted("$test.*.as")}
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Assembling '$test.a.as'
Writing object file '$test.a.o'

Assembling '$test.b.as'
Writing object file '$test.b.o'

Creating library '$test.lib'
Adding $test.a.o to library
Adding $test.b.o to library
END

capture_ok("z88dk-z80nm -a $test.lib", <<'END');
Library file test_t_issue_2320.lib at $0000: Z80LMF18
Object  file test_t_issue_2320.lib at $0014: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.as:2)

Object  file test_t_issue_2320.lib at $00E0: Z80RMF18
  Name: b
  CPU:  z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.as:3)

END


#------------------------------------------------------------------------------
# make sources
#------------------------------------------------------------------------------

unlink_testfiles;
spew("$test.a.as", <<'END');
SECTION code2
a:	ld      hl,16384
END

spew("$test.b.as", <<'END');
MODULE b
SECTION code
b:	ld      hl,32768
END


#------------------------------------------------------------------------------
# any extension - give basename
#------------------------------------------------------------------------------

capture_ok("z88dk-z80asm -mz80 $test.a.as", "");
capture_ok("z88dk-z80asm -mr3k $test.b.as", "");
capture_nok("z88dk-z80asm -x$test.lib -mz80 $test.a $test.b", <<'END');
error: CPU incompatible: file test_t_issue_2320.b.o compiled for r3k, incompatible with z80
END


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
# invalid object file - give .o
#------------------------------------------------------------------------------

capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mr3k $test.b.asm", "");
spew("$test.b.o", "invalid");
capture_nok("z88dk-z80asm -x$test.lib -mz80 $test.*.o", <<'END');
error: not an object file: test_t_issue_2320.b.o
END


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
# invalid object file - give .asm
#------------------------------------------------------------------------------

capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mr3k $test.b.asm", "");
spew("$test.b.o", "invalid");
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
Library file test_t_issue_2320.lib at $0000: Z80LMF18
Object  file test_t_issue_2320.lib at $0014: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $00E4: Z80RMF18
  Name: b
  CPU:  z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

END


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
# invalid object file - give basename
#------------------------------------------------------------------------------

capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mr3k $test.b.asm", "");
capture_ok("z88dk-z80asm -v -x$test.lib -mz80 $test.a $test.b", <<'END');
% z88dk-z80asm -v -xtest_t_issue_2320.lib -mz80 test_t_issue_2320.a test_t_issue_2320.b
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Creating library 'test_t_issue_2320.lib'
Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library
END

capture_ok("z88dk-z80nm -a $test.lib", <<'END');
Library file test_t_issue_2320.lib at $0000: Z80LMF18
Object  file test_t_issue_2320.lib at $0014: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $00E4: Z80RMF18
  Name: b
  CPU:  z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

END


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
# not-existing object file - give .o
#------------------------------------------------------------------------------

capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mr3k $test.b.asm", "");
unlink("$test.b.o");
capture_nok("z88dk-z80asm -x$test.lib -mz80 $test.a.o $test.b.o", <<'END');
error: file not found: test_t_issue_2320.b.o
END


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
Library file test_t_issue_2320.lib at $0000: Z80LMF18
Object  file test_t_issue_2320.lib at $0014: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $00E4: Z80RMF18
  Name: b
  CPU:  z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

END


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
# not-existing object file - give basename
#------------------------------------------------------------------------------

capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mr3k $test.b.asm", "");
unlink("$test.b.o");
capture_ok("z88dk-z80asm -v -x$test.lib -mz80 $test.a $test.b", <<'END');
% z88dk-z80asm -v -xtest_t_issue_2320.lib -mz80 test_t_issue_2320.a test_t_issue_2320.b
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Assembling 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Creating library 'test_t_issue_2320.lib'
Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library
END

capture_ok("z88dk-z80nm -a $test.lib", <<'END');
Library file test_t_issue_2320.lib at $0000: Z80LMF18
Object  file test_t_issue_2320.lib at $0014: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:2)

Object  file test_t_issue_2320.lib at $00E4: Z80RMF18
  Name: b
  CPU:  z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:3)

END


#------------------------------------------------------------------------------
# allow multi-CPU object files during library creation
#------------------------------------------------------------------------------

for my $has_asm (0 .. 1) {
	unlink_testfiles;
	my @objs;
	for my $cpu (@CPUS) {
		for my $ixiy ("", "-IXIY") {
			my $ixiy_text = $ixiy eq "" ? "" : "($ixiy)";
			my $base = "$test.$cpu$ixiy";
			spew("$base.asm", "nop");
			unlink("$base.o");
			capture_ok("z88dk-z80asm -m$cpu $ixiy $base.asm", "");
			ok -f "$base.o", "$base.o created";
			unlink("$base.asm") unless $has_asm;
			push @objs, "$base.o";
		}
	}

	capture_ok("z88dk-z80asm -v -m* -x$test.1.lib @objs", <<'END');
% z88dk-z80asm -v -m* -xtest_t_issue_2320.1.lib test_t_issue_2320.z80.o test_t_issue_2320.z80-IXIY.o test_t_issue_2320.z80_strict.o test_t_issue_2320.z80_strict-IXIY.o test_t_issue_2320.z80n.o test_t_issue_2320.z80n-IXIY.o test_t_issue_2320.z180.o test_t_issue_2320.z180-IXIY.o test_t_issue_2320.ez80.o test_t_issue_2320.ez80-IXIY.o test_t_issue_2320.ez80_z80.o test_t_issue_2320.ez80_z80-IXIY.o test_t_issue_2320.r800.o test_t_issue_2320.r800-IXIY.o test_t_issue_2320.r2ka.o test_t_issue_2320.r2ka-IXIY.o test_t_issue_2320.r3k.o test_t_issue_2320.r3k-IXIY.o test_t_issue_2320.r4k.o test_t_issue_2320.r4k-IXIY.o test_t_issue_2320.r5k.o test_t_issue_2320.r5k-IXIY.o test_t_issue_2320.8080.o test_t_issue_2320.8080-IXIY.o test_t_issue_2320.8085.o test_t_issue_2320.8085-IXIY.o test_t_issue_2320.gbz80.o test_t_issue_2320.gbz80-IXIY.o test_t_issue_2320.kc160.o test_t_issue_2320.kc160-IXIY.o test_t_issue_2320.kc160_z80.o test_t_issue_2320.kc160_z80-IXIY.o
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Creating library 'test_t_issue_2320.1.lib'
Predefined constant: __CPU_Z80N__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320.z80n.o to library
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Adding test_t_issue_2320.z80n-IXIY.o to library
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Adding test_t_issue_2320.z80.o to library
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Adding test_t_issue_2320.z80-IXIY.o to library
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_Z180__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320.z180.o to library
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Adding test_t_issue_2320.z180-IXIY.o to library
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_R800__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320.r800.o to library
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Adding test_t_issue_2320.r800-IXIY.o to library
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_KC160_Z80__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320.kc160_z80.o to library
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Adding test_t_issue_2320.kc160_z80-IXIY.o to library

Predefined constant: __CPU_Z80_STRICT__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320.z80_strict.o to library
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Adding test_t_issue_2320.z80_strict-IXIY.o to library
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_R3K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320.r3k.o to library
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Adding test_t_issue_2320.r3k-IXIY.o to library
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_8085__ = 1
Predefined constant: __CPU_INTEL__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320.8085.o to library
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Adding test_t_issue_2320.8085-IXIY.o to library
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_R5K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320.r5k.o to library
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Adding test_t_issue_2320.r5k-IXIY.o to library
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_EZ80_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320.ez80_z80.o to library
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Adding test_t_issue_2320.ez80_z80-IXIY.o to library
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_EZ80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320.ez80.o to library
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Adding test_t_issue_2320.ez80-IXIY.o to library
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_R2KA__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320.r2ka.o to library
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Adding test_t_issue_2320.r2ka-IXIY.o to library
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_GBZ80__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320.gbz80.o to library
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Adding test_t_issue_2320.gbz80-IXIY.o to library
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_8080__ = 1
Predefined constant: __CPU_INTEL__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320.8080.o to library
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Adding test_t_issue_2320.8080-IXIY.o to library
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_R4K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320.r4k.o to library
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Adding test_t_issue_2320.r4k-IXIY.o to library
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_KC160__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320.kc160.o to library
Skipping test_t_issue_2320.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160.o - different CPU-IXIY combination
Adding test_t_issue_2320.kc160-IXIY.o to library
Skipping test_t_issue_2320.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.kc160_z80-IXIY.o - different CPU-IXIY combination

END

	capture_ok("z88dk-z80nm -a $test.1.lib", <<'END');
Library file test_t_issue_2320.1.lib at $0000: Z80LMF18
Object  file test_t_issue_2320.1.lib at $0014: Z80RMF18
  Name: test_t_issue_2320.z80n
  CPU:  z80n 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0088: Z80RMF18
  Name: test_t_issue_2320.z80n-IXIY
  CPU:  z80n (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0104: Z80RMF18
  Name: test_t_issue_2320.z80
  CPU:  z80 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0178: Z80RMF18
  Name: test_t_issue_2320.z80-IXIY
  CPU:  z80 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $01F0: Z80RMF18
  Name: test_t_issue_2320.z180
  CPU:  z180 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0264: Z80RMF18
  Name: test_t_issue_2320.z180-IXIY
  CPU:  z180 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $02E0: Z80RMF18
  Name: test_t_issue_2320.r800
  CPU:  r800 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0354: Z80RMF18
  Name: test_t_issue_2320.r800-IXIY
  CPU:  r800 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $03D0: Z80RMF18
  Name: test_t_issue_2320.kc160_z80
  CPU:  kc160_z80 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $044C: Z80RMF18
  Name: test_t_issue_2320.kc160_z80-IXIY
  CPU:  kc160_z80 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $04CC: Z80RMF18
  Name: test_t_issue_2320.z80_strict
  CPU:  z80_strict 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0548: Z80RMF18
  Name: test_t_issue_2320.z80_strict-IXIY
  CPU:  z80_strict (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $05C8: Z80RMF18
  Name: test_t_issue_2320.r3k
  CPU:  r3k 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $063C: Z80RMF18
  Name: test_t_issue_2320.r3k-IXIY
  CPU:  r3k (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $06B4: Z80RMF18
  Name: test_t_issue_2320.8085
  CPU:  8085 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0728: Z80RMF18
  Name: test_t_issue_2320.8085-IXIY
  CPU:  8085 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $07A4: Z80RMF18
  Name: test_t_issue_2320.r5k
  CPU:  r5k 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0818: Z80RMF18
  Name: test_t_issue_2320.r5k-IXIY
  CPU:  r5k (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0890: Z80RMF18
  Name: test_t_issue_2320.ez80_z80
  CPU:  ez80_z80 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0908: Z80RMF18
  Name: test_t_issue_2320.ez80_z80-IXIY
  CPU:  ez80_z80 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0988: Z80RMF18
  Name: test_t_issue_2320.ez80
  CPU:  ez80 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $09FC: Z80RMF18
  Name: test_t_issue_2320.ez80-IXIY
  CPU:  ez80 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0A78: Z80RMF18
  Name: test_t_issue_2320.r2ka
  CPU:  r2ka 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0AEC: Z80RMF18
  Name: test_t_issue_2320.r2ka-IXIY
  CPU:  r2ka (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0B68: Z80RMF18
  Name: test_t_issue_2320.gbz80
  CPU:  gbz80 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0BE0: Z80RMF18
  Name: test_t_issue_2320.gbz80-IXIY
  CPU:  gbz80 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0C5C: Z80RMF18
  Name: test_t_issue_2320.8080
  CPU:  8080 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0CD0: Z80RMF18
  Name: test_t_issue_2320.8080-IXIY
  CPU:  8080 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0D4C: Z80RMF18
  Name: test_t_issue_2320.r4k
  CPU:  r4k 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0DC0: Z80RMF18
  Name: test_t_issue_2320.r4k-IXIY
  CPU:  r4k (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0E38: Z80RMF18
  Name: test_t_issue_2320.kc160
  CPU:  kc160 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0EB0: Z80RMF18
  Name: test_t_issue_2320.kc160-IXIY
  CPU:  kc160 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

END
}


#------------------------------------------------------------------------------
# test use-after-delete modlink - fails on Linux
#------------------------------------------------------------------------------

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
__head                          = $0000 ; const, public, def, , ,
__size                          = $0001 ; const, public, def, , ,
__tail                          = $0001 ; const, public, def, , ,
the_answer                      = $002A ; const, public, , test_t_issue_2320.1, , test_t_issue_2320.1.asm:2
END


#------------------------------------------------------------------------------
# link object files
#------------------------------------------------------------------------------

unlink_testfiles;
for my $lib_ixiy ("", "-IXIY", "-IXIY-soft") {
	my $lib_ixiy_cpu = $lib_ixiy ? "($lib_ixiy)" : "";
	my %IXIY_ERROR = (""=>"(no option)", "-IXIY"=>"-IXIY", "-IXIY-soft"=>"-IXIY-soft");
		
	for my $lib_cpu (@CPUS) {
		spew("$test.1.asm", <<'END');
				public the_answer
		the_answer = 42
END
		# make object file and library
		unlink("$test.1.o", "$test.1.lib");
		capture_ok("z88dk-z80asm -m$lib_cpu -x$test.1.lib $lib_ixiy $test.1.asm", "");
		ok -f "$test.1.o", "$test.1.o created";
		ok -f "$test.1.lib", "$test.1.lib created";
		ok unlink("$test.1.asm"), "remove $test.1.asm";
		
		
		capture_ok("z88dk-z80nm -a $test.1.o", <<END);
Object  file $test.1.o at \$0000: Z80RMF18
  Name: $test.1
  CPU:  $lib_cpu $lib_ixiy_cpu
  Section "": 0 bytes
  Symbols:
    G C \$002A: the_answer (section "") (file $test.1.asm:2)
END

		capture_ok("z88dk-z80nm -a $test.1.lib", <<END);
Library file $test.1.lib at \$0000: Z80LMF18
Object  file $test.1.lib at \$0014: Z80RMF18
  Name: $test.1
  CPU:  $lib_cpu $lib_ixiy_cpu
  Section "": 0 bytes
  Symbols:
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

END

		# link with object and library
		spew("$test.asm", <<'END');
				extern the_answer
				defb the_answer
END

		for my $code_ixiy ("", "-IXIY", "-IXIY-soft") {
			for my $code_cpu (@CPUS) {
				
				if (!cpu_compatible($code_cpu, $lib_cpu)) {
					capture_nok("z88dk-z80asm -b -m$code_cpu $code_ixiy ".
						    "$test.asm $test.1.o", <<END);
error: CPU incompatible: file $test.1.o compiled for $lib_cpu, incompatible with $code_cpu
END

					capture_nok("z88dk-z80asm -b -m$code_cpu $code_ixiy ".
						    "-l$test.1.lib $test.asm", <<END);
$test.asm:2: error: undefined symbol: the_answer
  ^---- the_answer
END
				}
				elsif (!ixiy_compatible($code_ixiy, $lib_ixiy)) {
					capture_nok("z88dk-z80asm -b -m$code_cpu $code_ixiy ".
						    "$test.asm $test.1.o", <<END);
error: -IXIY incompatible: file $test.1.o compiled with $IXIY_ERROR{$lib_ixiy}, incompatible with $IXIY_ERROR{$code_ixiy}
END

					capture_nok("z88dk-z80asm -b -m$code_cpu $code_ixiy ".
						    "-l$test.1.lib $test.asm", <<END);
$test.asm:2: error: undefined symbol: the_answer
  ^---- the_answer
END

				}
				else {
					unlink("$test.bin");
					capture_ok("z88dk-z80asm -b -m$code_cpu $code_ixiy ".
							"$test.asm $test.1.o", "");
					check_bin_file("$test.bin", bytes(42));
					
					unlink("$test.bin");
					capture_ok("z88dk-z80asm -b -m$code_cpu $code_ixiy ".
							"-l$test.1.lib $test.asm", "");
					check_bin_file("$test.bin", bytes(42));
				}
			}
		}
	}
}


#------------------------------------------------------------------------------
# make multi-cpu library
#------------------------------------------------------------------------------

unlink_testfiles;
spew("$test.asm", <<'END');
		extern the_answer
		defb the_answer
END

spew("$test.1.asm", <<'END');
	public the_answer
the_answer = 42
	ifdef __CPU_8080__		: defm "8080 "			: endif
	ifdef __CPU_8085__		: defm "8085 "			: endif
	ifdef __CPU_EZ80__		: defm "ez80 "			: endif
	ifdef __CPU_EZ80_Z80__	: defm "ez80_z80 "		: endif
	ifdef __CPU_GBZ80__		: defm "gbz80 "			: endif
	ifdef __CPU_R800__		: defm "r800 "			: endif
	ifdef __CPU_R2KA__		: defm "r2ka "			: endif
	ifdef __CPU_R3K__		: defm "r3k "			: endif
	ifdef __CPU_R4K__		: defm "r4k "			: endif
	ifdef __CPU_R5K__		: defm "r5k "			: endif
	ifdef __CPU_Z180__		: defm "z180 "			: endif
	ifdef __CPU_Z80__		: defm "z80 "			: endif
	ifdef __CPU_Z80_STRICT__: defm "z80_strict "	: endif
	ifdef __CPU_Z80N__		: defm "z80n " 			: endif
	ifdef __CPU_KC160__		: defm "kc160 "			: endif
	ifdef __CPU_KC160_Z80__	: defm "kc160_z80 " 	: endif
	ifdef __SWAP_IX_IY__	: defm "-IXIY "			: endif
END

for my $lib_ixiy ("", "-IXIY") {
	unlink("$test.1.lib");
	capture_ok("z88dk-z80asm $lib_ixiy -m\"*\" -x$test.1.lib $test.1.asm", "");
	ok -f "$test.1.lib", "$test.1.lib created";
	
	capture_ok("z88dk-z80nm -a $test.1.lib", <<'END');
Library file test_t_issue_2320.1.lib at $0000: Z80LMF18
Object  file test_t_issue_2320.1.lib at $0014: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  z80n 
  Section "": 5 bytes
    C $0000: 7A 38 30 6E 20
  Symbols:
    L C $0001: __CPU_Z80N__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0104: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  z80n (-IXIY)
  Section "": 11 bytes
    C $0000: 7A 38 30 6E 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_Z80N__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0224: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  z80 
  Section "": 4 bytes
    C $0000: 7A 38 30 20
  Symbols:
    L C $0001: __CPU_Z80__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $030C: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  z80 (-IXIY)
  Section "": 10 bytes
    C $0000: 7A 38 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_Z80__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $042C: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  z180 
  Section "": 5 bytes
    C $0000: 7A 31 38 30 20
  Symbols:
    L C $0001: __CPU_Z180__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $051C: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  z180 (-IXIY)
  Section "": 11 bytes
    C $0000: 7A 31 38 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_Z180__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $063C: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  r800 
  Section "": 5 bytes
    C $0000: 72 38 30 30 20
  Symbols:
    L C $0001: __CPU_R800__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $072C: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  r800 (-IXIY)
  Section "": 11 bytes
    C $0000: 72 38 30 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_R800__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $084C: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  kc160_z80 
  Section "": 10 bytes
    C $0000: 6B 63 31 36 30 5F 7A 38 30 20
  Symbols:
    L C $0001: __CPU_KC160_Z80__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0944: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  kc160_z80 (-IXIY)
  Section "": 16 bytes
    C $0000: 6B 63 31 36 30 5F 7A 38 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_KC160_Z80__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0A70: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  z80_strict 
  Section "": 11 bytes
    C $0000: 7A 38 30 5F 73 74 72 69 63 74 20
  Symbols:
    L C $0001: __CPU_Z80_STRICT__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0B68: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  z80_strict (-IXIY)
  Section "": 17 bytes
    C $0000: 7A 38 30 5F 73 74 72 69 63 74 20 2D 49 58 49 59
    C $0010: 20
  Symbols:
    L C $0001: __CPU_Z80_STRICT__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0C98: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  r3k 
  Section "": 4 bytes
    C $0000: 72 33 6B 20
  Symbols:
    L C $0001: __CPU_R3K__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0D80: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  r3k (-IXIY)
  Section "": 10 bytes
    C $0000: 72 33 6B 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_R3K__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0EA0: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  8085 
  Section "": 5 bytes
    C $0000: 38 30 38 35 20
  Symbols:
    L C $0001: __CPU_8085__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0F90: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  8085 (-IXIY)
  Section "": 11 bytes
    C $0000: 38 30 38 35 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_8085__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $10B0: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  r5k 
  Section "": 4 bytes
    C $0000: 72 35 6B 20
  Symbols:
    L C $0001: __CPU_R5K__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $1198: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  r5k (-IXIY)
  Section "": 10 bytes
    C $0000: 72 35 6B 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_R5K__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $12B8: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  ez80_z80 
  Section "": 9 bytes
    C $0000: 65 7A 38 30 5F 7A 38 30 20
  Symbols:
    L C $0001: __CPU_EZ80_Z80__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $13B0: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  ez80_z80 (-IXIY)
  Section "": 15 bytes
    C $0000: 65 7A 38 30 5F 7A 38 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_EZ80_Z80__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $14D8: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  ez80 
  Section "": 5 bytes
    C $0000: 65 7A 38 30 20
  Symbols:
    L C $0001: __CPU_EZ80__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $15C8: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  ez80 (-IXIY)
  Section "": 11 bytes
    C $0000: 65 7A 38 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_EZ80__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $16E8: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  r2ka 
  Section "": 5 bytes
    C $0000: 72 32 6B 61 20
  Symbols:
    L C $0001: __CPU_R2KA__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $17D8: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  r2ka (-IXIY)
  Section "": 11 bytes
    C $0000: 72 32 6B 61 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_R2KA__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $18F8: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  gbz80 
  Section "": 6 bytes
    C $0000: 67 62 7A 38 30 20
  Symbols:
    L C $0001: __CPU_GBZ80__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $19E8: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  gbz80 (-IXIY)
  Section "": 12 bytes
    C $0000: 67 62 7A 38 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_GBZ80__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $1B0C: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  8080 
  Section "": 5 bytes
    C $0000: 38 30 38 30 20
  Symbols:
    L C $0001: __CPU_8080__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $1BFC: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  8080 (-IXIY)
  Section "": 11 bytes
    C $0000: 38 30 38 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_8080__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $1D1C: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  r4k 
  Section "": 4 bytes
    C $0000: 72 34 6B 20
  Symbols:
    L C $0001: __CPU_R4K__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $1E04: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  r4k (-IXIY)
  Section "": 10 bytes
    C $0000: 72 34 6B 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_R4K__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $1F24: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  kc160 
  Section "": 6 bytes
    C $0000: 6B 63 31 36 30 20
  Symbols:
    L C $0001: __CPU_KC160__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $2014: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  kc160 (-IXIY)
  Section "": 12 bytes
    C $0000: 6B 63 31 36 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_KC160__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

END

	for my $code_ixiy ("", "-IXIY", "-IXIY-soft") {
		for my $code_cpu (@CPUS) {
			unlink("$test.bin");
			capture_ok("z88dk-z80asm -b -m$code_cpu $code_ixiy ".
							   "-l$test.1.lib $test.asm", "");
			ok -f "$test.bin", "$test.bin created";
			my %CODE_IXIY = (""=>"", "-IXIY"=>"-IXIY ", "-IXIY-soft"=>"");
			check_bin_file("$test.bin", bytes(42).$code_cpu." ".$CODE_IXIY{$code_ixiy});
		}
	}
}


#------------------------------------------------------------------------------
# make -XIIY-soft library
#------------------------------------------------------------------------------

unlink_testfiles;
spew("$test.asm", <<'END');
		extern the_answer
		defb the_answer
END

spew("$test.1.asm", <<'END');
	public the_answer
the_answer = 42
	ifdef __CPU_8080__		: defm "8080 "		: endif
	ifdef __CPU_8085__		: defm "8085 "		: endif
	ifdef __CPU_EZ80__		: defm "ez80 "		: endif
	ifdef __CPU_EZ80_ADL__	: defm "ez80_adl "	: endif
	ifdef __CPU_EZ80_Z80__	: defm "ez80_z80 "	: endif
	ifdef __CPU_GBZ80__		: defm "gbz80 "		: endif
	ifdef __CPU_R800__		: defm "r800 "		: endif
	ifdef __CPU_R2KA__		: defm "r2ka "		: endif
	ifdef __CPU_R3K__		: defm "r3k "		: endif
	ifdef __CPU_R4K__		: defm "r4k "		: endif
	ifdef __CPU_R5K__		: defm "r5k "		: endif
	ifdef __CPU_Z180__		: defm "z180 "		: endif
	ifdef __CPU_Z80__		: defm "z80 "		: endif
	ifdef __CPU_Z80_STRICT__: defm "z80_strict ": endif
	ifdef __CPU_Z80N__		: defm "z80n " 		: endif
	ifdef __CPU_KC160__		: defm "kc160 " 	: endif
	ifdef __CPU_KC160_EXT__	: defm "kc160_ext "	: endif
	ifdef __CPU_KC160_Z80__	: defm "kc160_z80 " : endif
	ifdef __SWAP_IX_IY__	: defm "-IXIY "		: endif
END

unlink("$test.1.lib");
capture_ok("z88dk-z80asm -IXIY-soft -m\"*\" -x$test.1.lib $test.1.asm", "");
ok -f "$test.1.lib", "$test.1.lib created";

capture_ok("z88dk-z80nm -a $test.1.lib", <<'END');
Library file test_t_issue_2320.1.lib at $0000: Z80LMF18
Object  file test_t_issue_2320.1.lib at $0014: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  z80n (-IXIY-soft)
  Section "": 11 bytes
    C $0000: 7A 38 30 6E 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_Z80N__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0134: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  z80 (-IXIY-soft)
  Section "": 10 bytes
    C $0000: 7A 38 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_Z80__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0254: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  z180 (-IXIY-soft)
  Section "": 11 bytes
    C $0000: 7A 31 38 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_Z180__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0374: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  r800 (-IXIY-soft)
  Section "": 11 bytes
    C $0000: 72 38 30 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_R800__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0494: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  kc160_z80 (-IXIY-soft)
  Section "": 16 bytes
    C $0000: 6B 63 31 36 30 5F 7A 38 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_KC160_Z80__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $05C0: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  z80_strict (-IXIY-soft)
  Section "": 17 bytes
    C $0000: 7A 38 30 5F 73 74 72 69 63 74 20 2D 49 58 49 59
    C $0010: 20
  Symbols:
    L C $0001: __CPU_Z80_STRICT__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $06F0: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  r3k (-IXIY-soft)
  Section "": 10 bytes
    C $0000: 72 33 6B 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_R3K__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0810: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  8085 (-IXIY-soft)
  Section "": 11 bytes
    C $0000: 38 30 38 35 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_8085__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0930: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  r5k (-IXIY-soft)
  Section "": 10 bytes
    C $0000: 72 35 6B 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_R5K__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0A50: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  ez80_z80 (-IXIY-soft)
  Section "": 15 bytes
    C $0000: 65 7A 38 30 5F 7A 38 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_EZ80_Z80__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0B78: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  ez80 (-IXIY-soft)
  Section "": 11 bytes
    C $0000: 65 7A 38 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_EZ80__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0C98: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  r2ka (-IXIY-soft)
  Section "": 11 bytes
    C $0000: 72 32 6B 61 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_R2KA__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0DB8: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  gbz80 (-IXIY-soft)
  Section "": 12 bytes
    C $0000: 67 62 7A 38 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_GBZ80__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0EDC: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  8080 (-IXIY-soft)
  Section "": 11 bytes
    C $0000: 38 30 38 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_8080__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0FFC: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  r4k (-IXIY-soft)
  Section "": 10 bytes
    C $0000: 72 34 6B 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_R4K__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $111C: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  kc160 (-IXIY-soft)
  Section "": 12 bytes
    C $0000: 6B 63 31 36 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_KC160__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

END


for my $code_ixiy ("", "-IXIY", "-IXIY-soft") {
	for my $code_cpu (@CPUS) {
		if ($code_ixiy ne "-IXIY") {
			unlink("$test.bin");
			capture_ok("z88dk-z80asm -b -m$code_cpu $code_ixiy ".
							   "-l$test.1.lib $test.asm", "");
			ok -f "$test.bin", "$test.bin created";
			check_bin_file("$test.bin", bytes(42).$code_cpu." -IXIY ");
		}
		else {
			capture_nok("z88dk-z80asm -b -m$code_cpu -IXIY ".
					"-l$test.1.lib $test.asm", <<END);
$test.asm:2: error: undefined symbol: the_answer
  ^---- the_answer
END
		}
	}
}

#------------------------------------------------------------------------------
# check actual swapping
#------------------------------------------------------------------------------

unlink_testfiles;
for my $code_ixiy ("", "-IXIY", "-IXIY-soft") {
	spew("$test.asm", <<'END');
			ld ix, 0
END
	unlink("$test.bin");
	capture_ok("z88dk-z80asm -b $code_ixiy $test.asm", "");
	ok -f "$test.bin", "$test.bin created";
	my %PREFIX = (""=>0xDD, "-IXIY"=>0xFD, "-IXIY-soft"=>0xFD);
	check_bin_file("$test.bin", bytes($PREFIX{$code_ixiy}, 0x21, 0, 0));
}

unlink_testfiles;
done_testing;
