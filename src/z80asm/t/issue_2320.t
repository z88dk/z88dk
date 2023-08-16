#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2320
# z80asm: do not link with object files built for a different cpu

my @CPUS = qw( z80 z80_strict z80n z180 ez80 ez80_z80 r800 r2ka r3k 8080 8085 gbz80 );

# test invalid CPU

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


# -M* and -d are incompatible

unlink_testfiles;
spew("$test.asm", "nop");
capture_nok("z88dk-z80asm -d -m* -x$test.lib $test", <<'END');
error: cannot build libraries with -m* and -d
END


# use -d, different CPU, asm file newer
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
Assembling 'test_t_issue_2320.asm' to 'test_t_issue_2320.o'
Reading 'test_t_issue_2320.asm' = 'test_t_issue_2320.asm'
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
Assembling 'test_t_issue_2320.asm' to 'test_t_issue_2320.o'
Reading 'test_t_issue_2320.asm' = 'test_t_issue_2320.asm'
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


# use -d, different CPU, o file newer
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



# building library for diferent compatible cpus - give .o

make_asm_sources();
capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mz80_strict $test.b.asm", "");
capture_ok("z88dk-z80asm -v -x$test.lib -mz80 ".quote_os("$test.*.o"), <<END);
% z88dk-z80asm -v -x$test.lib -mz80 ${\os_quoted("$test.*.o")}
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Append object file $test.a.o...
Append object file $test.b.o...
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
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $00E4: Z80RMF18
  Name: b
  CPU:  z80_strict 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

END

# building library for diferent compatible cpus - give .asm

make_asm_sources();
capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mz80_strict $test.b.asm", "");
capture_ok("z88dk-z80asm -v -x$test.lib -mz80 ".quote_os("$test.*.asm"), <<END);
% z88dk-z80asm -v -x$test.lib -mz80 ${\os_quoted("$test.*.asm")}
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Assembling '$test.a.asm' to '$test.a.o'
Reading '$test.a.asm' = '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm' to '$test.b.o'
Reading '$test.b.asm' = '$test.b.asm'
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
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $00E4: Z80RMF18
  Name: b
  CPU:  z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

END

# building library for diferent compatible cpus - give basename

make_asm_sources();
capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mz80_strict $test.b.asm", "");
capture_ok("z88dk-z80asm -v -x$test.lib -mz80 $test.a $test.b", <<'END');
% z88dk-z80asm -v -xtest_t_issue_2320.lib -mz80 test_t_issue_2320.a test_t_issue_2320.b
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Assembling 'test_t_issue_2320.a.asm' to 'test_t_issue_2320.a.o'
Reading 'test_t_issue_2320.a.asm' = 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm' to 'test_t_issue_2320.b.o'
Reading 'test_t_issue_2320.b.asm' = 'test_t_issue_2320.b.asm'
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
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $00E4: Z80RMF18
  Name: b
  CPU:  z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

END



# building library for diferent incompatible cpus - give .o

make_asm_sources();
capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mr3k $test.b.asm", "");
capture_nok("z88dk-z80asm -x$test.lib -mz80 $test.*.o", <<'END');
error: CPU incompatible: file test_t_issue_2320.b.o compiled for r3k, incompatible with z80
END

# building library for diferent incompatible cpus - give .asm

make_asm_sources();
capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mr3k $test.b.asm", "");
capture_ok("z88dk-z80asm -v -x$test.lib -mz80 ".quote_os("$test.*.asm"), <<END);
% z88dk-z80asm -v -x$test.lib -mz80 ${\os_quoted("$test.*.asm")}
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Assembling '$test.a.asm' to '$test.a.o'
Reading '$test.a.asm' = '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm' to '$test.b.o'
Reading '$test.b.asm' = '$test.b.asm'
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
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $00E4: Z80RMF18
  Name: b
  CPU:  z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

END

# building library for diferent incompatible cpus - give basename

make_asm_sources();
capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mr3k $test.b.asm", "");
capture_ok("z88dk-z80asm -v -x$test.lib -mz80 $test.a $test.b", <<'END');
% z88dk-z80asm -v -xtest_t_issue_2320.lib -mz80 test_t_issue_2320.a test_t_issue_2320.b
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Assembling 'test_t_issue_2320.a.asm' to 'test_t_issue_2320.a.o'
Reading 'test_t_issue_2320.a.asm' = 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm' to 'test_t_issue_2320.b.o'
Reading 'test_t_issue_2320.b.asm' = 'test_t_issue_2320.b.asm'
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
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $00E4: Z80RMF18
  Name: b
  CPU:  z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

END


# building -m* library - give .o

make_asm_sources();
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

Predefined constant: __CPU_EZ80__ = 1
Predefined constant: __CPU_EZ80_Z80__ = 1
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

Predefined constant: __CPU_Z180__ = 1
Predefined constant: __CPU_ZILOG__ = 1
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

Predefined constant: __CPU_8085__ = 1
Predefined constant: __CPU_INTEL__ = 1
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

Predefined constant: __CPU_GBZ80__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __CPU_EZ80__ = 1
Predefined constant: __CPU_EZ80_ADL__ = 1
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

Predefined constant: __CPU_8080__ = 1
Predefined constant: __CPU_INTEL__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.a.o - different CPU-IXIY combination
Skipping $test.b.o - different CPU-IXIY combination

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
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $00E4: Z80RMF18
  Name: b
  CPU:  r3k 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

END


# building -m* library - give .asm

make_asm_sources();
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
Assembling '$test.a.asm' to '$test.a.o'
Reading '$test.a.asm' = '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm' to '$test.b.o'
Reading '$test.b.asm' = '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling '$test.a.asm' to '$test.a.o'
Reading '$test.a.asm' = '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm' to '$test.b.o'
Reading '$test.b.asm' = '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling '$test.a.asm' to '$test.a.o'
Reading '$test.a.asm' = '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm' to '$test.b.o'
Reading '$test.b.asm' = '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling '$test.a.asm' to '$test.a.o'
Reading '$test.a.asm' = '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm' to '$test.b.o'
Reading '$test.b.asm' = '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __CPU_EZ80__ = 1
Predefined constant: __CPU_EZ80_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling '$test.a.asm' to '$test.a.o'
Reading '$test.a.asm' = '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm' to '$test.b.o'
Reading '$test.b.asm' = '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling '$test.a.asm' to '$test.a.o'
Reading '$test.a.asm' = '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm' to '$test.b.o'
Reading '$test.b.asm' = '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __CPU_R800__ = 1
Assembling '$test.a.asm' to '$test.a.o'
Reading '$test.a.asm' = '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm' to '$test.b.o'
Reading '$test.b.asm' = '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling '$test.a.asm' to '$test.a.o'
Reading '$test.a.asm' = '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm' to '$test.b.o'
Reading '$test.b.asm' = '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __CPU_Z180__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling '$test.a.asm' to '$test.a.o'
Reading '$test.a.asm' = '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm' to '$test.b.o'
Reading '$test.b.asm' = '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling '$test.a.asm' to '$test.a.o'
Reading '$test.a.asm' = '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm' to '$test.b.o'
Reading '$test.b.asm' = '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __CPU_Z80_STRICT__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling '$test.a.asm' to '$test.a.o'
Reading '$test.a.asm' = '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm' to '$test.b.o'
Reading '$test.b.asm' = '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling '$test.a.asm' to '$test.a.o'
Reading '$test.a.asm' = '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm' to '$test.b.o'
Reading '$test.b.asm' = '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __CPU_8085__ = 1
Predefined constant: __CPU_INTEL__ = 1
Assembling '$test.a.asm' to '$test.a.o'
Reading '$test.a.asm' = '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm' to '$test.b.o'
Reading '$test.b.asm' = '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling '$test.a.asm' to '$test.a.o'
Reading '$test.a.asm' = '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm' to '$test.b.o'
Reading '$test.b.asm' = '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __CPU_R3K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Assembling '$test.a.asm' to '$test.a.o'
Reading '$test.a.asm' = '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm' to '$test.b.o'
Reading '$test.b.asm' = '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling '$test.a.asm' to '$test.a.o'
Reading '$test.a.asm' = '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm' to '$test.b.o'
Reading '$test.b.asm' = '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __CPU_GBZ80__ = 1
Assembling '$test.a.asm' to '$test.a.o'
Reading '$test.a.asm' = '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm' to '$test.b.o'
Reading '$test.b.asm' = '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling '$test.a.asm' to '$test.a.o'
Reading '$test.a.asm' = '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm' to '$test.b.o'
Reading '$test.b.asm' = '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __CPU_EZ80__ = 1
Predefined constant: __CPU_EZ80_ADL__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling '$test.a.asm' to '$test.a.o'
Reading '$test.a.asm' = '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm' to '$test.b.o'
Reading '$test.b.asm' = '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling '$test.a.asm' to '$test.a.o'
Reading '$test.a.asm' = '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm' to '$test.b.o'
Reading '$test.b.asm' = '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __CPU_R2KA__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Assembling '$test.a.asm' to '$test.a.o'
Reading '$test.a.asm' = '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm' to '$test.b.o'
Reading '$test.b.asm' = '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling '$test.a.asm' to '$test.a.o'
Reading '$test.a.asm' = '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm' to '$test.b.o'
Reading '$test.b.asm' = '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __CPU_8080__ = 1
Predefined constant: __CPU_INTEL__ = 1
Assembling '$test.a.asm' to '$test.a.o'
Reading '$test.a.asm' = '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm' to '$test.b.o'
Reading '$test.b.asm' = '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling '$test.a.asm' to '$test.a.o'
Reading '$test.a.asm' = '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm' to '$test.b.o'
Reading '$test.b.asm' = '$test.b.asm'
Writing object file '$test.b.o'

Adding $test.a.o to library
Adding $test.b.o to library

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
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $00E4: Z80RMF18
  Name: b
  CPU:  z80n 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $0198: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80n (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $0268: Z80RMF18
  Name: b
  CPU:  z80n (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $031C: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $03EC: Z80RMF18
  Name: b
  CPU:  z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $04A0: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $0570: Z80RMF18
  Name: b
  CPU:  z80 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $0624: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  ez80_z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $06F4: Z80RMF18
  Name: b
  CPU:  ez80_z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $07A8: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  ez80_z80 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $0878: Z80RMF18
  Name: b
  CPU:  ez80_z80 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $092C: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r800 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $09FC: Z80RMF18
  Name: b
  CPU:  r800 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $0AB0: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r800 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $0B80: Z80RMF18
  Name: b
  CPU:  r800 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $0C34: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z180 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $0D04: Z80RMF18
  Name: b
  CPU:  z180 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $0DB8: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z180 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $0E88: Z80RMF18
  Name: b
  CPU:  z180 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $0F3C: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80_strict 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $100C: Z80RMF18
  Name: b
  CPU:  z80_strict 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $10C0: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80_strict (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $1190: Z80RMF18
  Name: b
  CPU:  z80_strict (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $1244: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  8085 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $1314: Z80RMF18
  Name: b
  CPU:  8085 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $13C8: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  8085 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $1498: Z80RMF18
  Name: b
  CPU:  8085 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $154C: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r3k 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $161C: Z80RMF18
  Name: b
  CPU:  r3k 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $16D0: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r3k (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $17A0: Z80RMF18
  Name: b
  CPU:  r3k (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $1854: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  gbz80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $1924: Z80RMF18
  Name: b
  CPU:  gbz80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $19D8: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  gbz80 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $1AA8: Z80RMF18
  Name: b
  CPU:  gbz80 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $1B5C: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  ez80 
  Section "": 0 bytes
  Section code2: 4 bytes
    C $0000: 21 00 40 00
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $1C2C: Z80RMF18
  Name: b
  CPU:  ez80 
  Section "": 0 bytes
  Section code: 4 bytes
    C $0000: 21 00 80 00
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $1CE0: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  ez80 (-IXIY)
  Section "": 0 bytes
  Section code2: 4 bytes
    C $0000: 21 00 40 00
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $1DB0: Z80RMF18
  Name: b
  CPU:  ez80 (-IXIY)
  Section "": 0 bytes
  Section code: 4 bytes
    C $0000: 21 00 80 00
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $1E64: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r2ka 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $1F34: Z80RMF18
  Name: b
  CPU:  r2ka 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $1FE8: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r2ka (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $20B8: Z80RMF18
  Name: b
  CPU:  r2ka (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $216C: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  8080 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $223C: Z80RMF18
  Name: b
  CPU:  8080 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $22F0: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  8080 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $23C0: Z80RMF18
  Name: b
  CPU:  8080 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

END


# building -m* library - give .basename

make_asm_sources();
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
Assembling 'test_t_issue_2320.a.asm' to 'test_t_issue_2320.a.o'
Reading 'test_t_issue_2320.a.asm' = 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm' to 'test_t_issue_2320.b.o'
Reading 'test_t_issue_2320.b.asm' = 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm' to 'test_t_issue_2320.a.o'
Reading 'test_t_issue_2320.a.asm' = 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm' to 'test_t_issue_2320.b.o'
Reading 'test_t_issue_2320.b.asm' = 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling 'test_t_issue_2320.a.asm' to 'test_t_issue_2320.a.o'
Reading 'test_t_issue_2320.a.asm' = 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm' to 'test_t_issue_2320.b.o'
Reading 'test_t_issue_2320.b.asm' = 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm' to 'test_t_issue_2320.a.o'
Reading 'test_t_issue_2320.a.asm' = 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm' to 'test_t_issue_2320.b.o'
Reading 'test_t_issue_2320.b.asm' = 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_EZ80__ = 1
Predefined constant: __CPU_EZ80_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling 'test_t_issue_2320.a.asm' to 'test_t_issue_2320.a.o'
Reading 'test_t_issue_2320.a.asm' = 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm' to 'test_t_issue_2320.b.o'
Reading 'test_t_issue_2320.b.asm' = 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm' to 'test_t_issue_2320.a.o'
Reading 'test_t_issue_2320.a.asm' = 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm' to 'test_t_issue_2320.b.o'
Reading 'test_t_issue_2320.b.asm' = 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_R800__ = 1
Assembling 'test_t_issue_2320.a.asm' to 'test_t_issue_2320.a.o'
Reading 'test_t_issue_2320.a.asm' = 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm' to 'test_t_issue_2320.b.o'
Reading 'test_t_issue_2320.b.asm' = 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm' to 'test_t_issue_2320.a.o'
Reading 'test_t_issue_2320.a.asm' = 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm' to 'test_t_issue_2320.b.o'
Reading 'test_t_issue_2320.b.asm' = 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_Z180__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling 'test_t_issue_2320.a.asm' to 'test_t_issue_2320.a.o'
Reading 'test_t_issue_2320.a.asm' = 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm' to 'test_t_issue_2320.b.o'
Reading 'test_t_issue_2320.b.asm' = 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm' to 'test_t_issue_2320.a.o'
Reading 'test_t_issue_2320.a.asm' = 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm' to 'test_t_issue_2320.b.o'
Reading 'test_t_issue_2320.b.asm' = 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_Z80_STRICT__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling 'test_t_issue_2320.a.asm' to 'test_t_issue_2320.a.o'
Reading 'test_t_issue_2320.a.asm' = 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm' to 'test_t_issue_2320.b.o'
Reading 'test_t_issue_2320.b.asm' = 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm' to 'test_t_issue_2320.a.o'
Reading 'test_t_issue_2320.a.asm' = 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm' to 'test_t_issue_2320.b.o'
Reading 'test_t_issue_2320.b.asm' = 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_8085__ = 1
Predefined constant: __CPU_INTEL__ = 1
Assembling 'test_t_issue_2320.a.asm' to 'test_t_issue_2320.a.o'
Reading 'test_t_issue_2320.a.asm' = 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm' to 'test_t_issue_2320.b.o'
Reading 'test_t_issue_2320.b.asm' = 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm' to 'test_t_issue_2320.a.o'
Reading 'test_t_issue_2320.a.asm' = 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm' to 'test_t_issue_2320.b.o'
Reading 'test_t_issue_2320.b.asm' = 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_R3K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Assembling 'test_t_issue_2320.a.asm' to 'test_t_issue_2320.a.o'
Reading 'test_t_issue_2320.a.asm' = 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm' to 'test_t_issue_2320.b.o'
Reading 'test_t_issue_2320.b.asm' = 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm' to 'test_t_issue_2320.a.o'
Reading 'test_t_issue_2320.a.asm' = 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm' to 'test_t_issue_2320.b.o'
Reading 'test_t_issue_2320.b.asm' = 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_GBZ80__ = 1
Assembling 'test_t_issue_2320.a.asm' to 'test_t_issue_2320.a.o'
Reading 'test_t_issue_2320.a.asm' = 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm' to 'test_t_issue_2320.b.o'
Reading 'test_t_issue_2320.b.asm' = 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm' to 'test_t_issue_2320.a.o'
Reading 'test_t_issue_2320.a.asm' = 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm' to 'test_t_issue_2320.b.o'
Reading 'test_t_issue_2320.b.asm' = 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_EZ80__ = 1
Predefined constant: __CPU_EZ80_ADL__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Assembling 'test_t_issue_2320.a.asm' to 'test_t_issue_2320.a.o'
Reading 'test_t_issue_2320.a.asm' = 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm' to 'test_t_issue_2320.b.o'
Reading 'test_t_issue_2320.b.asm' = 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm' to 'test_t_issue_2320.a.o'
Reading 'test_t_issue_2320.a.asm' = 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm' to 'test_t_issue_2320.b.o'
Reading 'test_t_issue_2320.b.asm' = 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_R2KA__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Assembling 'test_t_issue_2320.a.asm' to 'test_t_issue_2320.a.o'
Reading 'test_t_issue_2320.a.asm' = 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm' to 'test_t_issue_2320.b.o'
Reading 'test_t_issue_2320.b.asm' = 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm' to 'test_t_issue_2320.a.o'
Reading 'test_t_issue_2320.a.asm' = 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm' to 'test_t_issue_2320.b.o'
Reading 'test_t_issue_2320.b.asm' = 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __CPU_8080__ = 1
Predefined constant: __CPU_INTEL__ = 1
Assembling 'test_t_issue_2320.a.asm' to 'test_t_issue_2320.a.o'
Reading 'test_t_issue_2320.a.asm' = 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm' to 'test_t_issue_2320.b.o'
Reading 'test_t_issue_2320.b.asm' = 'test_t_issue_2320.b.asm'
Writing object file 'test_t_issue_2320.b.o'

Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library

Predefined constant: __SWAP_IX_IY__ = 1
Assembling 'test_t_issue_2320.a.asm' to 'test_t_issue_2320.a.o'
Reading 'test_t_issue_2320.a.asm' = 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm' to 'test_t_issue_2320.b.o'
Reading 'test_t_issue_2320.b.asm' = 'test_t_issue_2320.b.asm'
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
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $00E4: Z80RMF18
  Name: b
  CPU:  z80n 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $0198: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80n (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $0268: Z80RMF18
  Name: b
  CPU:  z80n (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $031C: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $03EC: Z80RMF18
  Name: b
  CPU:  z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $04A0: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $0570: Z80RMF18
  Name: b
  CPU:  z80 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $0624: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  ez80_z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $06F4: Z80RMF18
  Name: b
  CPU:  ez80_z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $07A8: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  ez80_z80 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $0878: Z80RMF18
  Name: b
  CPU:  ez80_z80 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $092C: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r800 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $09FC: Z80RMF18
  Name: b
  CPU:  r800 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $0AB0: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r800 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $0B80: Z80RMF18
  Name: b
  CPU:  r800 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $0C34: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z180 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $0D04: Z80RMF18
  Name: b
  CPU:  z180 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $0DB8: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z180 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $0E88: Z80RMF18
  Name: b
  CPU:  z180 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $0F3C: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80_strict 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $100C: Z80RMF18
  Name: b
  CPU:  z80_strict 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $10C0: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  z80_strict (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $1190: Z80RMF18
  Name: b
  CPU:  z80_strict (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $1244: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  8085 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $1314: Z80RMF18
  Name: b
  CPU:  8085 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $13C8: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  8085 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $1498: Z80RMF18
  Name: b
  CPU:  8085 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $154C: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r3k 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $161C: Z80RMF18
  Name: b
  CPU:  r3k 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $16D0: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r3k (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $17A0: Z80RMF18
  Name: b
  CPU:  r3k (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $1854: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  gbz80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $1924: Z80RMF18
  Name: b
  CPU:  gbz80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $19D8: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  gbz80 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $1AA8: Z80RMF18
  Name: b
  CPU:  gbz80 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $1B5C: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  ez80 
  Section "": 0 bytes
  Section code2: 4 bytes
    C $0000: 21 00 40 00
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $1C2C: Z80RMF18
  Name: b
  CPU:  ez80 
  Section "": 0 bytes
  Section code: 4 bytes
    C $0000: 21 00 80 00
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $1CE0: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  ez80 (-IXIY)
  Section "": 0 bytes
  Section code2: 4 bytes
    C $0000: 21 00 40 00
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $1DB0: Z80RMF18
  Name: b
  CPU:  ez80 (-IXIY)
  Section "": 0 bytes
  Section code: 4 bytes
    C $0000: 21 00 80 00
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $1E64: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r2ka 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $1F34: Z80RMF18
  Name: b
  CPU:  r2ka 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $1FE8: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  r2ka (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $20B8: Z80RMF18
  Name: b
  CPU:  r2ka (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $216C: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  8080 
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $223C: Z80RMF18
  Name: b
  CPU:  8080 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

Object  file test_t_issue_2320.lib at $22F0: Z80RMF18
  Name: test_t_issue_2320.a
  CPU:  8080 (-IXIY)
  Section "": 0 bytes
  Section code2: 3 bytes
    C $0000: 21 00 40
  Symbols:
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $23C0: Z80RMF18
  Name: b
  CPU:  8080 (-IXIY)
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

END


# any extension - give .o

make_asm_sources(".as");
capture_ok("z88dk-z80asm -mz80 $test.a.as", "");
capture_ok("z88dk-z80asm -mr3k $test.b.as", "");
capture_nok("z88dk-z80asm -x$test.lib -mz80 $test.*.o", <<'END');
error: CPU incompatible: file test_t_issue_2320.b.o compiled for r3k, incompatible with z80
END


# any extension - give source

make_asm_sources(".as");
capture_ok("z88dk-z80asm -mz80 $test.a.as", "");
capture_ok("z88dk-z80asm -mr3k $test.b.as", "");
capture_ok("z88dk-z80asm -v -x$test.lib -mz80 ".quote_os("$test.*.as"), <<END);
% z88dk-z80asm -v -x$test.lib -mz80 ${\os_quoted("$test.*.as")}
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Assembling '$test.a.as' to '$test.a.o'
Reading '$test.a.as' = '$test.a.as'
Writing object file '$test.a.o'

Assembling '$test.b.as' to '$test.b.o'
Reading '$test.b.as' = '$test.b.as'
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
    L A $0000: a (section code2) (file test_t_issue_2320.a.as:3)

Object  file test_t_issue_2320.lib at $00E0: Z80RMF18
  Name: b
  CPU:  z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.as:5)

END


# any extension - give basename

make_asm_sources(".as");
capture_ok("z88dk-z80asm -mz80 $test.a.as", "");
capture_ok("z88dk-z80asm -mr3k $test.b.as", "");
capture_nok("z88dk-z80asm -x$test.lib -mz80 $test.a $test.b", <<'END');
error: CPU incompatible: file test_t_issue_2320.b.o compiled for r3k, incompatible with z80
END


# invalid object file - give .o

make_asm_sources();
capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mr3k $test.b.asm", "");
spew("$test.b.o", "invalid");
capture_nok("z88dk-z80asm -x$test.lib -mz80 $test.*.o", <<'END');
error: not an object file: test_t_issue_2320.b.o
END


# invalid object file - give .asm

make_asm_sources();
capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mr3k $test.b.asm", "");
spew("$test.b.o", "invalid");
capture_ok("z88dk-z80asm -v -x$test.lib -mz80 ".quote_os("$test.*.asm"), <<END);
% z88dk-z80asm -v -x$test.lib -mz80 ${\os_quoted("$test.*.asm")}
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Assembling '$test.a.asm' to '$test.a.o'
Reading '$test.a.asm' = '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm' to '$test.b.o'
Reading '$test.b.asm' = '$test.b.asm'
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
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $00E4: Z80RMF18
  Name: b
  CPU:  z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

END

# invalid object file - give basename

make_asm_sources();
capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mr3k $test.b.asm", "");
capture_ok("z88dk-z80asm -v -x$test.lib -mz80 $test.a $test.b", <<'END');
% z88dk-z80asm -v -xtest_t_issue_2320.lib -mz80 test_t_issue_2320.a test_t_issue_2320.b
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Assembling 'test_t_issue_2320.a.asm' to 'test_t_issue_2320.a.o'
Reading 'test_t_issue_2320.a.asm' = 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm' to 'test_t_issue_2320.b.o'
Reading 'test_t_issue_2320.b.asm' = 'test_t_issue_2320.b.asm'
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
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $00E4: Z80RMF18
  Name: b
  CPU:  z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

END


# not-existing object file - give .o

make_asm_sources();
capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mr3k $test.b.asm", "");
unlink("$test.b.o");
capture_nok("z88dk-z80asm -x$test.lib -mz80 $test.a.o $test.b.o", <<'END');
error: file not found: test_t_issue_2320.b.o
END


# not-existing object file - give .asm

make_asm_sources();
capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mr3k $test.b.asm", "");
unlink("$test.b.o");
capture_ok("z88dk-z80asm -v -x$test.lib -mz80 ".quote_os("$test.*.asm"), <<END);
% z88dk-z80asm -v -x$test.lib -mz80 ${\os_quoted("$test.*.asm")}
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Assembling '$test.a.asm' to '$test.a.o'
Reading '$test.a.asm' = '$test.a.asm'
Writing object file '$test.a.o'

Assembling '$test.b.asm' to '$test.b.o'
Reading '$test.b.asm' = '$test.b.asm'
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
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $00E4: Z80RMF18
  Name: b
  CPU:  z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

END

# not-existing object file - give basename

make_asm_sources();
capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mr3k $test.b.asm", "");
unlink("$test.b.o");
capture_ok("z88dk-z80asm -v -x$test.lib -mz80 $test.a $test.b", <<'END');
% z88dk-z80asm -v -xtest_t_issue_2320.lib -mz80 test_t_issue_2320.a test_t_issue_2320.b
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Assembling 'test_t_issue_2320.a.asm' to 'test_t_issue_2320.a.o'
Reading 'test_t_issue_2320.a.asm' = 'test_t_issue_2320.a.asm'
Writing object file 'test_t_issue_2320.a.o'

Assembling 'test_t_issue_2320.b.asm' to 'test_t_issue_2320.b.o'
Reading 'test_t_issue_2320.b.asm' = 'test_t_issue_2320.b.asm'
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
    L A $0000: a (section code2) (file test_t_issue_2320.a.asm:3)

Object  file test_t_issue_2320.lib at $00E4: Z80RMF18
  Name: b
  CPU:  z80 
  Section "": 0 bytes
  Section code: 3 bytes
    C $0000: 21 00 80
  Symbols:
    L A $0000: b (section code) (file test_t_issue_2320.b.asm:5)

END



# allow multi-CPU object files during library creation

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

	capture_ok("z88dk-z80asm -v -m* -x$test.1.lib @objs", <<END);
% z88dk-z80asm -v -m* -xtest_t_issue_2320.1.lib @objs
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
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination

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
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination

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
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination

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
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_EZ80__ = 1
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
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination

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
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination

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
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination

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
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination

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
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination

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
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination

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
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination

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
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination

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
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320.8085.o to library
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination

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
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Adding test_t_issue_2320.8085-IXIY.o to library
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination

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
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination

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
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination

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
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320.gbz80.o to library
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination

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
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Adding test_t_issue_2320.gbz80-IXIY.o to library

Predefined constant: __CPU_EZ80__ = 1
Predefined constant: __CPU_EZ80_ADL__ = 1
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
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination

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
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination

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
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination

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
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination

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
Adding test_t_issue_2320.8080.o to library
Skipping test_t_issue_2320.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination

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
Skipping test_t_issue_2320.8080.o - different CPU-IXIY combination
Adding test_t_issue_2320.8080-IXIY.o to library
Skipping test_t_issue_2320.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320.gbz80-IXIY.o - different CPU-IXIY combination

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
  Name: test_t_issue_2320.ez80_z80
  CPU:  ez80_z80 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0268: Z80RMF18
  Name: test_t_issue_2320.ez80_z80-IXIY
  CPU:  ez80_z80 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $02E8: Z80RMF18
  Name: test_t_issue_2320.r800
  CPU:  r800 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $035C: Z80RMF18
  Name: test_t_issue_2320.r800-IXIY
  CPU:  r800 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $03D8: Z80RMF18
  Name: test_t_issue_2320.z180
  CPU:  z180 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $044C: Z80RMF18
  Name: test_t_issue_2320.z180-IXIY
  CPU:  z180 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $04C8: Z80RMF18
  Name: test_t_issue_2320.z80_strict
  CPU:  z80_strict 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0544: Z80RMF18
  Name: test_t_issue_2320.z80_strict-IXIY
  CPU:  z80_strict (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $05C4: Z80RMF18
  Name: test_t_issue_2320.8085
  CPU:  8085 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0638: Z80RMF18
  Name: test_t_issue_2320.8085-IXIY
  CPU:  8085 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $06B4: Z80RMF18
  Name: test_t_issue_2320.r3k
  CPU:  r3k 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0728: Z80RMF18
  Name: test_t_issue_2320.r3k-IXIY
  CPU:  r3k (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $07A0: Z80RMF18
  Name: test_t_issue_2320.gbz80
  CPU:  gbz80 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0818: Z80RMF18
  Name: test_t_issue_2320.gbz80-IXIY
  CPU:  gbz80 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0894: Z80RMF18
  Name: test_t_issue_2320.ez80
  CPU:  ez80 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0908: Z80RMF18
  Name: test_t_issue_2320.ez80-IXIY
  CPU:  ez80 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0984: Z80RMF18
  Name: test_t_issue_2320.r2ka
  CPU:  r2ka 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $09F8: Z80RMF18
  Name: test_t_issue_2320.r2ka-IXIY
  CPU:  r2ka (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0A74: Z80RMF18
  Name: test_t_issue_2320.8080
  CPU:  8080 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320.1.lib at $0AE8: Z80RMF18
  Name: test_t_issue_2320.8080-IXIY
  CPU:  8080 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

END
}


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
the_answer                      = $002A ; const, public, , test_t_issue_2320.1, , test_t_issue_2320.1.asm:2
__head                          = $0000 ; const, public, def, , ,
__tail                          = $0001 ; const, public, def, , ,
__size                          = $0001 ; const, public, def, , ,
END



# link object files

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


# make multi-cpu library

unlink_testfiles;
spew("$test.asm", <<'END');
		extern the_answer
		defb the_answer
END

spew("$test.1.asm", <<'END');
	public the_answer
the_answer = 42
	ifdef __CPU_8080__		: defm "8080"		: endif
	ifdef __CPU_8085__		: defm "8085"		: endif
	ifdef __CPU_EZ80_ADL__	: defm "ez80"		: endif
	ifdef __CPU_EZ80_Z80__	: defm "ez80_z80"	: endif
	ifdef __CPU_GBZ80__		: defm "gbz80"		: endif
	ifdef __CPU_R800__		: defm "r800"		: endif
	ifdef __CPU_R2KA__		: defm "r2ka"		: endif
	ifdef __CPU_R3K__		: defm "r3k"		: endif
	ifdef __CPU_Z180__		: defm "z180"		: endif
	ifdef __CPU_Z80__		: defm "z80"		: endif
	ifdef __CPU_Z80_STRICT__: defm "z80_strict"	: endif
	ifdef __CPU_Z80N__		: defm "z80n" 		: endif
	ifdef __SWAP_IX_IY__	: defm "-IXIY"		: endif
END

spew("$test.asm", <<'END');
	extern the_answer
	defb the_answer
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
  Section "": 4 bytes
    C $0000: 7A 38 30 6E
  Symbols:
    L C $0001: __CPU_Z80N__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0100: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  z80n (-IXIY)
  Section "": 9 bytes
    C $0000: 7A 38 30 6E 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_Z80N__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0220: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  z80 
  Section "": 3 bytes
    C $0000: 7A 38 30
  Symbols:
    L C $0001: __CPU_Z80__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0308: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  z80 (-IXIY)
  Section "": 8 bytes
    C $0000: 7A 38 30 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_Z80__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0424: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  ez80_z80 
  Section "": 8 bytes
    C $0000: 65 7A 38 30 5F 7A 38 30
  Symbols:
    L C $0001: __CPU_EZ80_Z80__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0518: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  ez80_z80 (-IXIY)
  Section "": 13 bytes
    C $0000: 65 7A 38 30 5F 7A 38 30 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_EZ80_Z80__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0640: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  r800 
  Section "": 4 bytes
    C $0000: 72 38 30 30
  Symbols:
    L C $0001: __CPU_R800__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $072C: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  r800 (-IXIY)
  Section "": 9 bytes
    C $0000: 72 38 30 30 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_R800__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $084C: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  z180 
  Section "": 4 bytes
    C $0000: 7A 31 38 30
  Symbols:
    L C $0001: __CPU_Z180__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0938: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  z180 (-IXIY)
  Section "": 9 bytes
    C $0000: 7A 31 38 30 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_Z180__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0A58: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  z80_strict 
  Section "": 10 bytes
    C $0000: 7A 38 30 5F 73 74 72 69 63 74
  Symbols:
    L C $0001: __CPU_Z80_STRICT__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0B50: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  z80_strict (-IXIY)
  Section "": 15 bytes
    C $0000: 7A 38 30 5F 73 74 72 69 63 74 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_Z80_STRICT__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0C7C: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  8085 
  Section "": 4 bytes
    C $0000: 38 30 38 35
  Symbols:
    L C $0001: __CPU_8085__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0D68: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  8085 (-IXIY)
  Section "": 9 bytes
    C $0000: 38 30 38 35 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_8085__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0E88: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  r3k 
  Section "": 3 bytes
    C $0000: 72 33 6B
  Symbols:
    L C $0001: __CPU_R3K__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0F70: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  r3k (-IXIY)
  Section "": 8 bytes
    C $0000: 72 33 6B 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_R3K__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $108C: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  gbz80 
  Section "": 5 bytes
    C $0000: 67 62 7A 38 30
  Symbols:
    L C $0001: __CPU_GBZ80__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $117C: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  gbz80 (-IXIY)
  Section "": 10 bytes
    C $0000: 67 62 7A 38 30 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_GBZ80__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $12A0: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  ez80 
  Section "": 4 bytes
    C $0000: 65 7A 38 30
  Symbols:
    L C $0001: __CPU_EZ80_ADL__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $1390: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  ez80 (-IXIY)
  Section "": 9 bytes
    C $0000: 65 7A 38 30 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_EZ80_ADL__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $14B4: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  r2ka 
  Section "": 4 bytes
    C $0000: 72 32 6B 61
  Symbols:
    L C $0001: __CPU_R2KA__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $15A0: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  r2ka (-IXIY)
  Section "": 9 bytes
    C $0000: 72 32 6B 61 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_R2KA__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $16C0: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  8080 
  Section "": 4 bytes
    C $0000: 38 30 38 30
  Symbols:
    L C $0001: __CPU_8080__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $17AC: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  8080 (-IXIY)
  Section "": 9 bytes
    C $0000: 38 30 38 30 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_8080__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

END

	for my $code_ixiy ("", "-IXIY", "-IXIY-soft") {
		for my $code_cpu (@CPUS) {
			unlink("$test.bin");
			capture_ok("z88dk-z80asm -b -m$code_cpu $code_ixiy ".
							   "-l$test.1.lib $test.asm", "");
			ok -f "$test.bin", "$test.bin created";
			my %CODE_IXIY = (""=>"", "-IXIY"=>"-IXIY", "-IXIY-soft"=>"");
			check_bin_file("$test.bin", bytes(42).$code_cpu.$CODE_IXIY{$code_ixiy});
		}
	}
}


# make -XIIY-soft library

unlink("$test.1.lib");
capture_ok("z88dk-z80asm -IXIY-soft -m\"*\" -x$test.1.lib $test.1.asm", "");
ok -f "$test.1.lib", "$test.1.lib created";

capture_ok("z88dk-z80nm -a $test.1.lib", <<'END');
Library file test_t_issue_2320.1.lib at $0000: Z80LMF18
Object  file test_t_issue_2320.1.lib at $0014: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  z80n (-IXIY-soft)
  Section "": 9 bytes
    C $0000: 7A 38 30 6E 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_Z80N__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0134: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  z80 (-IXIY-soft)
  Section "": 8 bytes
    C $0000: 7A 38 30 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_Z80__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0250: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  ez80_z80 (-IXIY-soft)
  Section "": 13 bytes
    C $0000: 65 7A 38 30 5F 7A 38 30 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_EZ80_Z80__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0378: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  r800 (-IXIY-soft)
  Section "": 9 bytes
    C $0000: 72 38 30 30 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_R800__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0498: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  z180 (-IXIY-soft)
  Section "": 9 bytes
    C $0000: 7A 31 38 30 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_Z180__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $05B8: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  z80_strict (-IXIY-soft)
  Section "": 15 bytes
    C $0000: 7A 38 30 5F 73 74 72 69 63 74 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_Z80_STRICT__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $06E4: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  8085 (-IXIY-soft)
  Section "": 9 bytes
    C $0000: 38 30 38 35 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_8085__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0804: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  r3k (-IXIY-soft)
  Section "": 8 bytes
    C $0000: 72 33 6B 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_R3K__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0920: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  gbz80 (-IXIY-soft)
  Section "": 10 bytes
    C $0000: 67 62 7A 38 30 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_GBZ80__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0A44: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  ez80 (-IXIY-soft)
  Section "": 9 bytes
    C $0000: 65 7A 38 30 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_EZ80_ADL__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0B68: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  r2ka (-IXIY-soft)
  Section "": 9 bytes
    C $0000: 72 32 6B 61 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_R2KA__ (section "") (file test_t_issue_2320.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320.1.asm:2)

Object  file test_t_issue_2320.1.lib at $0C88: Z80RMF18
  Name: test_t_issue_2320.1
  CPU:  8080 (-IXIY-soft)
  Section "": 9 bytes
    C $0000: 38 30 38 30 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_8080__ (section "") (file test_t_issue_2320.1.asm)
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
			check_bin_file("$test.bin", bytes(42).$code_cpu."-IXIY");
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


# check actual swapping

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


sub cpu_compatible {
	my($code_cpu, $lib_cpu) = @_;
	if ($code_cpu eq $lib_cpu) {
		return 1;
	}
	elsif ($code_cpu eq "z80_strict" && $lib_cpu eq "8080") {
		return 1;
	}
	elsif ($code_cpu eq "z80" && ($lib_cpu eq "8080" || $lib_cpu eq "z80_strict")) {
		return 1;
	}
	elsif ($code_cpu eq "z80n" && ($lib_cpu eq "8080" || $lib_cpu eq "z80" || $lib_cpu eq "z80_strict")) {
		return 1;
	}
	elsif ($code_cpu eq "z180" && ($lib_cpu eq "8080" || $lib_cpu eq "z80_strict")) {
		return 1;
	}
	elsif ($code_cpu eq "ez80") {
		return 0;
	}
	elsif ($code_cpu eq "ez80_z80" && ($lib_cpu eq "8080" || $lib_cpu eq "z180" || $lib_cpu eq "z80_strict")) {
		return 1;
	}
	elsif ($code_cpu eq "r800" && ($lib_cpu eq "8080" || $lib_cpu eq "z80_strict")) {
		return 1;
	}
	elsif ($code_cpu eq "r2ka") {
		return 0;
	}
	elsif ($code_cpu eq "r3k" && $lib_cpu eq "r2ka") {
		return 1;
	}
	elsif ($code_cpu eq "8080") {
		return 0;
	}
	elsif ($code_cpu eq "8085" && $lib_cpu eq "8080") {
		return 1;
	}
	elsif ($code_cpu eq "gbz80") {
		return 0;
	}
	else {
		return 0;
	}
}

sub ixiy_compatible {
	my($code_ixiy, $lib_ixiy) = @_;
	if ($code_ixiy eq $lib_ixiy) {
		return 1;
	}
	elsif ($code_ixiy eq "" && $lib_ixiy eq "-IXIY-soft") {
		return 1;
	}
	elsif ($code_ixiy eq "-IXIY-soft" && $lib_ixiy eq "") {
		return 1;
	}
	else {
		return 0;
	}
}

sub make_asm_sources {
	my($ext) = @_;
	$ext //= ".asm";
	
	unlink_testfiles;
	spew("$test.a$ext", <<'END');
SECTION code2

a:
        ld      hl,16384
END

	spew("$test.b$ext", <<'END');
MODULE b
SECTION code


b:
        ld      hl,32768
END
}

