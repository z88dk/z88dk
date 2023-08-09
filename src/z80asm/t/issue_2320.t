#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2320
# z80asm: do not link with object files built for a different cpu

my @CPUS = qw( z80 z80_strict z80n z180 ez80 ez80_z80 r2ka r3k 8080 8085 gbz80 );

# building library for diferent cpus not showing error message

unlink_testfiles;
spew("$test.a.asm", <<END);
SECTION code2

a:
        ld      hl,16384
END

spew("$test.b.asm", <<END);
MODULE b
SECTION code


b:
        ld      hl,32768
END

capture_ok("z88dk-z80asm -mz80 $test.a.asm", "");
capture_ok("z88dk-z80asm -mz80_strict $test.b.asm", "");
capture_ok("z88dk-z80asm -v -x$test.lib -mz80 $test.*.o", <<END);
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Creating library 'test_t_issue_2320.lib'
Adding test_t_issue_2320.a.o to library
Adding test_t_issue_2320.b.o to library
END

capture_ok("z88dk-z80nm -a $test.lib", <<END);
Library file $test.lib at \$0000: Z80LMF18
Object  file $test.lib at \$0014: Z80RMF18
  Name: $test.a
  CPU:  z80 
  Section "": 0 bytes
  Section code2: 3 bytes
    C \$0000: 21 00 40
  Symbols:
    L A \$0000: a (section code2) (file $test.a.asm:3)

Object  file $test.lib at \$00E4: Z80RMF18
  Name: b
  CPU:  z80_strict 
  Section "": 0 bytes
  Section code: 3 bytes
    C \$0000: 21 00 80
  Symbols:
    L A \$0000: b (section code) (file $test.b.asm:5)

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
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Creating library '$test.1.lib'
Predefined constant: __CPU_Z80N__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Skipping $test.z80.o - different CPU-IXIY combination
Skipping $test.z80-IXIY.o - different CPU-IXIY combination
Skipping $test.z80_strict.o - different CPU-IXIY combination
Skipping $test.z80_strict-IXIY.o - different CPU-IXIY combination
Adding $test.z80n.o to library
Skipping $test.z80n-IXIY.o - different CPU-IXIY combination
Skipping $test.z180.o - different CPU-IXIY combination
Skipping $test.z180-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80.o - different CPU-IXIY combination
Skipping $test.ez80-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80_z80.o - different CPU-IXIY combination
Skipping $test.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping $test.r2ka.o - different CPU-IXIY combination
Skipping $test.r2ka-IXIY.o - different CPU-IXIY combination
Skipping $test.r3k.o - different CPU-IXIY combination
Skipping $test.r3k-IXIY.o - different CPU-IXIY combination
Skipping $test.8080.o - different CPU-IXIY combination
Skipping $test.8080-IXIY.o - different CPU-IXIY combination
Skipping $test.8085.o - different CPU-IXIY combination
Skipping $test.8085-IXIY.o - different CPU-IXIY combination
Skipping $test.gbz80.o - different CPU-IXIY combination
Skipping $test.gbz80-IXIY.o - different CPU-IXIY combination
Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.z80.o - different CPU-IXIY combination
Skipping $test.z80-IXIY.o - different CPU-IXIY combination
Skipping $test.z80_strict.o - different CPU-IXIY combination
Skipping $test.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping $test.z80n.o - different CPU-IXIY combination
Adding $test.z80n-IXIY.o to library
Skipping $test.z180.o - different CPU-IXIY combination
Skipping $test.z180-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80.o - different CPU-IXIY combination
Skipping $test.ez80-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80_z80.o - different CPU-IXIY combination
Skipping $test.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping $test.r2ka.o - different CPU-IXIY combination
Skipping $test.r2ka-IXIY.o - different CPU-IXIY combination
Skipping $test.r3k.o - different CPU-IXIY combination
Skipping $test.r3k-IXIY.o - different CPU-IXIY combination
Skipping $test.8080.o - different CPU-IXIY combination
Skipping $test.8080-IXIY.o - different CPU-IXIY combination
Skipping $test.8085.o - different CPU-IXIY combination
Skipping $test.8085-IXIY.o - different CPU-IXIY combination
Skipping $test.gbz80.o - different CPU-IXIY combination
Skipping $test.gbz80-IXIY.o - different CPU-IXIY combination
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Adding $test.z80.o to library
Skipping $test.z80-IXIY.o - different CPU-IXIY combination
Skipping $test.z80_strict.o - different CPU-IXIY combination
Skipping $test.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping $test.z80n.o - different CPU-IXIY combination
Skipping $test.z80n-IXIY.o - different CPU-IXIY combination
Skipping $test.z180.o - different CPU-IXIY combination
Skipping $test.z180-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80.o - different CPU-IXIY combination
Skipping $test.ez80-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80_z80.o - different CPU-IXIY combination
Skipping $test.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping $test.r2ka.o - different CPU-IXIY combination
Skipping $test.r2ka-IXIY.o - different CPU-IXIY combination
Skipping $test.r3k.o - different CPU-IXIY combination
Skipping $test.r3k-IXIY.o - different CPU-IXIY combination
Skipping $test.8080.o - different CPU-IXIY combination
Skipping $test.8080-IXIY.o - different CPU-IXIY combination
Skipping $test.8085.o - different CPU-IXIY combination
Skipping $test.8085-IXIY.o - different CPU-IXIY combination
Skipping $test.gbz80.o - different CPU-IXIY combination
Skipping $test.gbz80-IXIY.o - different CPU-IXIY combination
Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.z80.o - different CPU-IXIY combination
Adding $test.z80-IXIY.o to library
Skipping $test.z80_strict.o - different CPU-IXIY combination
Skipping $test.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping $test.z80n.o - different CPU-IXIY combination
Skipping $test.z80n-IXIY.o - different CPU-IXIY combination
Skipping $test.z180.o - different CPU-IXIY combination
Skipping $test.z180-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80.o - different CPU-IXIY combination
Skipping $test.ez80-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80_z80.o - different CPU-IXIY combination
Skipping $test.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping $test.r2ka.o - different CPU-IXIY combination
Skipping $test.r2ka-IXIY.o - different CPU-IXIY combination
Skipping $test.r3k.o - different CPU-IXIY combination
Skipping $test.r3k-IXIY.o - different CPU-IXIY combination
Skipping $test.8080.o - different CPU-IXIY combination
Skipping $test.8080-IXIY.o - different CPU-IXIY combination
Skipping $test.8085.o - different CPU-IXIY combination
Skipping $test.8085-IXIY.o - different CPU-IXIY combination
Skipping $test.gbz80.o - different CPU-IXIY combination
Skipping $test.gbz80-IXIY.o - different CPU-IXIY combination
Predefined constant: __CPU_EZ80__ = 1
Predefined constant: __CPU_EZ80_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Skipping $test.z80.o - different CPU-IXIY combination
Skipping $test.z80-IXIY.o - different CPU-IXIY combination
Skipping $test.z80_strict.o - different CPU-IXIY combination
Skipping $test.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping $test.z80n.o - different CPU-IXIY combination
Skipping $test.z80n-IXIY.o - different CPU-IXIY combination
Skipping $test.z180.o - different CPU-IXIY combination
Skipping $test.z180-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80.o - different CPU-IXIY combination
Skipping $test.ez80-IXIY.o - different CPU-IXIY combination
Adding $test.ez80_z80.o to library
Skipping $test.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping $test.r2ka.o - different CPU-IXIY combination
Skipping $test.r2ka-IXIY.o - different CPU-IXIY combination
Skipping $test.r3k.o - different CPU-IXIY combination
Skipping $test.r3k-IXIY.o - different CPU-IXIY combination
Skipping $test.8080.o - different CPU-IXIY combination
Skipping $test.8080-IXIY.o - different CPU-IXIY combination
Skipping $test.8085.o - different CPU-IXIY combination
Skipping $test.8085-IXIY.o - different CPU-IXIY combination
Skipping $test.gbz80.o - different CPU-IXIY combination
Skipping $test.gbz80-IXIY.o - different CPU-IXIY combination
Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.z80.o - different CPU-IXIY combination
Skipping $test.z80-IXIY.o - different CPU-IXIY combination
Skipping $test.z80_strict.o - different CPU-IXIY combination
Skipping $test.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping $test.z80n.o - different CPU-IXIY combination
Skipping $test.z80n-IXIY.o - different CPU-IXIY combination
Skipping $test.z180.o - different CPU-IXIY combination
Skipping $test.z180-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80.o - different CPU-IXIY combination
Skipping $test.ez80-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80_z80.o - different CPU-IXIY combination
Adding $test.ez80_z80-IXIY.o to library
Skipping $test.r2ka.o - different CPU-IXIY combination
Skipping $test.r2ka-IXIY.o - different CPU-IXIY combination
Skipping $test.r3k.o - different CPU-IXIY combination
Skipping $test.r3k-IXIY.o - different CPU-IXIY combination
Skipping $test.8080.o - different CPU-IXIY combination
Skipping $test.8080-IXIY.o - different CPU-IXIY combination
Skipping $test.8085.o - different CPU-IXIY combination
Skipping $test.8085-IXIY.o - different CPU-IXIY combination
Skipping $test.gbz80.o - different CPU-IXIY combination
Skipping $test.gbz80-IXIY.o - different CPU-IXIY combination
Predefined constant: __CPU_Z180__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Skipping $test.z80.o - different CPU-IXIY combination
Skipping $test.z80-IXIY.o - different CPU-IXIY combination
Skipping $test.z80_strict.o - different CPU-IXIY combination
Skipping $test.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping $test.z80n.o - different CPU-IXIY combination
Skipping $test.z80n-IXIY.o - different CPU-IXIY combination
Adding $test.z180.o to library
Skipping $test.z180-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80.o - different CPU-IXIY combination
Skipping $test.ez80-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80_z80.o - different CPU-IXIY combination
Skipping $test.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping $test.r2ka.o - different CPU-IXIY combination
Skipping $test.r2ka-IXIY.o - different CPU-IXIY combination
Skipping $test.r3k.o - different CPU-IXIY combination
Skipping $test.r3k-IXIY.o - different CPU-IXIY combination
Skipping $test.8080.o - different CPU-IXIY combination
Skipping $test.8080-IXIY.o - different CPU-IXIY combination
Skipping $test.8085.o - different CPU-IXIY combination
Skipping $test.8085-IXIY.o - different CPU-IXIY combination
Skipping $test.gbz80.o - different CPU-IXIY combination
Skipping $test.gbz80-IXIY.o - different CPU-IXIY combination
Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.z80.o - different CPU-IXIY combination
Skipping $test.z80-IXIY.o - different CPU-IXIY combination
Skipping $test.z80_strict.o - different CPU-IXIY combination
Skipping $test.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping $test.z80n.o - different CPU-IXIY combination
Skipping $test.z80n-IXIY.o - different CPU-IXIY combination
Skipping $test.z180.o - different CPU-IXIY combination
Adding $test.z180-IXIY.o to library
Skipping $test.ez80.o - different CPU-IXIY combination
Skipping $test.ez80-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80_z80.o - different CPU-IXIY combination
Skipping $test.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping $test.r2ka.o - different CPU-IXIY combination
Skipping $test.r2ka-IXIY.o - different CPU-IXIY combination
Skipping $test.r3k.o - different CPU-IXIY combination
Skipping $test.r3k-IXIY.o - different CPU-IXIY combination
Skipping $test.8080.o - different CPU-IXIY combination
Skipping $test.8080-IXIY.o - different CPU-IXIY combination
Skipping $test.8085.o - different CPU-IXIY combination
Skipping $test.8085-IXIY.o - different CPU-IXIY combination
Skipping $test.gbz80.o - different CPU-IXIY combination
Skipping $test.gbz80-IXIY.o - different CPU-IXIY combination
Predefined constant: __CPU_Z80_STRICT__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Skipping $test.z80.o - different CPU-IXIY combination
Skipping $test.z80-IXIY.o - different CPU-IXIY combination
Adding $test.z80_strict.o to library
Skipping $test.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping $test.z80n.o - different CPU-IXIY combination
Skipping $test.z80n-IXIY.o - different CPU-IXIY combination
Skipping $test.z180.o - different CPU-IXIY combination
Skipping $test.z180-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80.o - different CPU-IXIY combination
Skipping $test.ez80-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80_z80.o - different CPU-IXIY combination
Skipping $test.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping $test.r2ka.o - different CPU-IXIY combination
Skipping $test.r2ka-IXIY.o - different CPU-IXIY combination
Skipping $test.r3k.o - different CPU-IXIY combination
Skipping $test.r3k-IXIY.o - different CPU-IXIY combination
Skipping $test.8080.o - different CPU-IXIY combination
Skipping $test.8080-IXIY.o - different CPU-IXIY combination
Skipping $test.8085.o - different CPU-IXIY combination
Skipping $test.8085-IXIY.o - different CPU-IXIY combination
Skipping $test.gbz80.o - different CPU-IXIY combination
Skipping $test.gbz80-IXIY.o - different CPU-IXIY combination
Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.z80.o - different CPU-IXIY combination
Skipping $test.z80-IXIY.o - different CPU-IXIY combination
Skipping $test.z80_strict.o - different CPU-IXIY combination
Adding $test.z80_strict-IXIY.o to library
Skipping $test.z80n.o - different CPU-IXIY combination
Skipping $test.z80n-IXIY.o - different CPU-IXIY combination
Skipping $test.z180.o - different CPU-IXIY combination
Skipping $test.z180-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80.o - different CPU-IXIY combination
Skipping $test.ez80-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80_z80.o - different CPU-IXIY combination
Skipping $test.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping $test.r2ka.o - different CPU-IXIY combination
Skipping $test.r2ka-IXIY.o - different CPU-IXIY combination
Skipping $test.r3k.o - different CPU-IXIY combination
Skipping $test.r3k-IXIY.o - different CPU-IXIY combination
Skipping $test.8080.o - different CPU-IXIY combination
Skipping $test.8080-IXIY.o - different CPU-IXIY combination
Skipping $test.8085.o - different CPU-IXIY combination
Skipping $test.8085-IXIY.o - different CPU-IXIY combination
Skipping $test.gbz80.o - different CPU-IXIY combination
Skipping $test.gbz80-IXIY.o - different CPU-IXIY combination
Predefined constant: __CPU_8085__ = 1
Predefined constant: __CPU_INTEL__ = 1
Skipping $test.z80.o - different CPU-IXIY combination
Skipping $test.z80-IXIY.o - different CPU-IXIY combination
Skipping $test.z80_strict.o - different CPU-IXIY combination
Skipping $test.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping $test.z80n.o - different CPU-IXIY combination
Skipping $test.z80n-IXIY.o - different CPU-IXIY combination
Skipping $test.z180.o - different CPU-IXIY combination
Skipping $test.z180-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80.o - different CPU-IXIY combination
Skipping $test.ez80-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80_z80.o - different CPU-IXIY combination
Skipping $test.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping $test.r2ka.o - different CPU-IXIY combination
Skipping $test.r2ka-IXIY.o - different CPU-IXIY combination
Skipping $test.r3k.o - different CPU-IXIY combination
Skipping $test.r3k-IXIY.o - different CPU-IXIY combination
Skipping $test.8080.o - different CPU-IXIY combination
Skipping $test.8080-IXIY.o - different CPU-IXIY combination
Adding $test.8085.o to library
Skipping $test.8085-IXIY.o - different CPU-IXIY combination
Skipping $test.gbz80.o - different CPU-IXIY combination
Skipping $test.gbz80-IXIY.o - different CPU-IXIY combination
Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.z80.o - different CPU-IXIY combination
Skipping $test.z80-IXIY.o - different CPU-IXIY combination
Skipping $test.z80_strict.o - different CPU-IXIY combination
Skipping $test.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping $test.z80n.o - different CPU-IXIY combination
Skipping $test.z80n-IXIY.o - different CPU-IXIY combination
Skipping $test.z180.o - different CPU-IXIY combination
Skipping $test.z180-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80.o - different CPU-IXIY combination
Skipping $test.ez80-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80_z80.o - different CPU-IXIY combination
Skipping $test.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping $test.r2ka.o - different CPU-IXIY combination
Skipping $test.r2ka-IXIY.o - different CPU-IXIY combination
Skipping $test.r3k.o - different CPU-IXIY combination
Skipping $test.r3k-IXIY.o - different CPU-IXIY combination
Skipping $test.8080.o - different CPU-IXIY combination
Skipping $test.8080-IXIY.o - different CPU-IXIY combination
Skipping $test.8085.o - different CPU-IXIY combination
Adding $test.8085-IXIY.o to library
Skipping $test.gbz80.o - different CPU-IXIY combination
Skipping $test.gbz80-IXIY.o - different CPU-IXIY combination
Predefined constant: __CPU_R3K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Skipping $test.z80.o - different CPU-IXIY combination
Skipping $test.z80-IXIY.o - different CPU-IXIY combination
Skipping $test.z80_strict.o - different CPU-IXIY combination
Skipping $test.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping $test.z80n.o - different CPU-IXIY combination
Skipping $test.z80n-IXIY.o - different CPU-IXIY combination
Skipping $test.z180.o - different CPU-IXIY combination
Skipping $test.z180-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80.o - different CPU-IXIY combination
Skipping $test.ez80-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80_z80.o - different CPU-IXIY combination
Skipping $test.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping $test.r2ka.o - different CPU-IXIY combination
Skipping $test.r2ka-IXIY.o - different CPU-IXIY combination
Adding $test.r3k.o to library
Skipping $test.r3k-IXIY.o - different CPU-IXIY combination
Skipping $test.8080.o - different CPU-IXIY combination
Skipping $test.8080-IXIY.o - different CPU-IXIY combination
Skipping $test.8085.o - different CPU-IXIY combination
Skipping $test.8085-IXIY.o - different CPU-IXIY combination
Skipping $test.gbz80.o - different CPU-IXIY combination
Skipping $test.gbz80-IXIY.o - different CPU-IXIY combination
Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.z80.o - different CPU-IXIY combination
Skipping $test.z80-IXIY.o - different CPU-IXIY combination
Skipping $test.z80_strict.o - different CPU-IXIY combination
Skipping $test.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping $test.z80n.o - different CPU-IXIY combination
Skipping $test.z80n-IXIY.o - different CPU-IXIY combination
Skipping $test.z180.o - different CPU-IXIY combination
Skipping $test.z180-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80.o - different CPU-IXIY combination
Skipping $test.ez80-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80_z80.o - different CPU-IXIY combination
Skipping $test.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping $test.r2ka.o - different CPU-IXIY combination
Skipping $test.r2ka-IXIY.o - different CPU-IXIY combination
Skipping $test.r3k.o - different CPU-IXIY combination
Adding $test.r3k-IXIY.o to library
Skipping $test.8080.o - different CPU-IXIY combination
Skipping $test.8080-IXIY.o - different CPU-IXIY combination
Skipping $test.8085.o - different CPU-IXIY combination
Skipping $test.8085-IXIY.o - different CPU-IXIY combination
Skipping $test.gbz80.o - different CPU-IXIY combination
Skipping $test.gbz80-IXIY.o - different CPU-IXIY combination
Predefined constant: __CPU_GBZ80__ = 1
Skipping $test.z80.o - different CPU-IXIY combination
Skipping $test.z80-IXIY.o - different CPU-IXIY combination
Skipping $test.z80_strict.o - different CPU-IXIY combination
Skipping $test.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping $test.z80n.o - different CPU-IXIY combination
Skipping $test.z80n-IXIY.o - different CPU-IXIY combination
Skipping $test.z180.o - different CPU-IXIY combination
Skipping $test.z180-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80.o - different CPU-IXIY combination
Skipping $test.ez80-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80_z80.o - different CPU-IXIY combination
Skipping $test.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping $test.r2ka.o - different CPU-IXIY combination
Skipping $test.r2ka-IXIY.o - different CPU-IXIY combination
Skipping $test.r3k.o - different CPU-IXIY combination
Skipping $test.r3k-IXIY.o - different CPU-IXIY combination
Skipping $test.8080.o - different CPU-IXIY combination
Skipping $test.8080-IXIY.o - different CPU-IXIY combination
Skipping $test.8085.o - different CPU-IXIY combination
Skipping $test.8085-IXIY.o - different CPU-IXIY combination
Adding $test.gbz80.o to library
Skipping $test.gbz80-IXIY.o - different CPU-IXIY combination
Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.z80.o - different CPU-IXIY combination
Skipping $test.z80-IXIY.o - different CPU-IXIY combination
Skipping $test.z80_strict.o - different CPU-IXIY combination
Skipping $test.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping $test.z80n.o - different CPU-IXIY combination
Skipping $test.z80n-IXIY.o - different CPU-IXIY combination
Skipping $test.z180.o - different CPU-IXIY combination
Skipping $test.z180-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80.o - different CPU-IXIY combination
Skipping $test.ez80-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80_z80.o - different CPU-IXIY combination
Skipping $test.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping $test.r2ka.o - different CPU-IXIY combination
Skipping $test.r2ka-IXIY.o - different CPU-IXIY combination
Skipping $test.r3k.o - different CPU-IXIY combination
Skipping $test.r3k-IXIY.o - different CPU-IXIY combination
Skipping $test.8080.o - different CPU-IXIY combination
Skipping $test.8080-IXIY.o - different CPU-IXIY combination
Skipping $test.8085.o - different CPU-IXIY combination
Skipping $test.8085-IXIY.o - different CPU-IXIY combination
Skipping $test.gbz80.o - different CPU-IXIY combination
Adding $test.gbz80-IXIY.o to library
Predefined constant: __CPU_EZ80__ = 1
Predefined constant: __CPU_EZ80_ADL__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Skipping $test.z80.o - different CPU-IXIY combination
Skipping $test.z80-IXIY.o - different CPU-IXIY combination
Skipping $test.z80_strict.o - different CPU-IXIY combination
Skipping $test.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping $test.z80n.o - different CPU-IXIY combination
Skipping $test.z80n-IXIY.o - different CPU-IXIY combination
Skipping $test.z180.o - different CPU-IXIY combination
Skipping $test.z180-IXIY.o - different CPU-IXIY combination
Adding $test.ez80.o to library
Skipping $test.ez80-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80_z80.o - different CPU-IXIY combination
Skipping $test.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping $test.r2ka.o - different CPU-IXIY combination
Skipping $test.r2ka-IXIY.o - different CPU-IXIY combination
Skipping $test.r3k.o - different CPU-IXIY combination
Skipping $test.r3k-IXIY.o - different CPU-IXIY combination
Skipping $test.8080.o - different CPU-IXIY combination
Skipping $test.8080-IXIY.o - different CPU-IXIY combination
Skipping $test.8085.o - different CPU-IXIY combination
Skipping $test.8085-IXIY.o - different CPU-IXIY combination
Skipping $test.gbz80.o - different CPU-IXIY combination
Skipping $test.gbz80-IXIY.o - different CPU-IXIY combination
Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.z80.o - different CPU-IXIY combination
Skipping $test.z80-IXIY.o - different CPU-IXIY combination
Skipping $test.z80_strict.o - different CPU-IXIY combination
Skipping $test.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping $test.z80n.o - different CPU-IXIY combination
Skipping $test.z80n-IXIY.o - different CPU-IXIY combination
Skipping $test.z180.o - different CPU-IXIY combination
Skipping $test.z180-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80.o - different CPU-IXIY combination
Adding $test.ez80-IXIY.o to library
Skipping $test.ez80_z80.o - different CPU-IXIY combination
Skipping $test.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping $test.r2ka.o - different CPU-IXIY combination
Skipping $test.r2ka-IXIY.o - different CPU-IXIY combination
Skipping $test.r3k.o - different CPU-IXIY combination
Skipping $test.r3k-IXIY.o - different CPU-IXIY combination
Skipping $test.8080.o - different CPU-IXIY combination
Skipping $test.8080-IXIY.o - different CPU-IXIY combination
Skipping $test.8085.o - different CPU-IXIY combination
Skipping $test.8085-IXIY.o - different CPU-IXIY combination
Skipping $test.gbz80.o - different CPU-IXIY combination
Skipping $test.gbz80-IXIY.o - different CPU-IXIY combination
Predefined constant: __CPU_R2KA__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Skipping $test.z80.o - different CPU-IXIY combination
Skipping $test.z80-IXIY.o - different CPU-IXIY combination
Skipping $test.z80_strict.o - different CPU-IXIY combination
Skipping $test.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping $test.z80n.o - different CPU-IXIY combination
Skipping $test.z80n-IXIY.o - different CPU-IXIY combination
Skipping $test.z180.o - different CPU-IXIY combination
Skipping $test.z180-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80.o - different CPU-IXIY combination
Skipping $test.ez80-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80_z80.o - different CPU-IXIY combination
Skipping $test.ez80_z80-IXIY.o - different CPU-IXIY combination
Adding $test.r2ka.o to library
Skipping $test.r2ka-IXIY.o - different CPU-IXIY combination
Skipping $test.r3k.o - different CPU-IXIY combination
Skipping $test.r3k-IXIY.o - different CPU-IXIY combination
Skipping $test.8080.o - different CPU-IXIY combination
Skipping $test.8080-IXIY.o - different CPU-IXIY combination
Skipping $test.8085.o - different CPU-IXIY combination
Skipping $test.8085-IXIY.o - different CPU-IXIY combination
Skipping $test.gbz80.o - different CPU-IXIY combination
Skipping $test.gbz80-IXIY.o - different CPU-IXIY combination
Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.z80.o - different CPU-IXIY combination
Skipping $test.z80-IXIY.o - different CPU-IXIY combination
Skipping $test.z80_strict.o - different CPU-IXIY combination
Skipping $test.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping $test.z80n.o - different CPU-IXIY combination
Skipping $test.z80n-IXIY.o - different CPU-IXIY combination
Skipping $test.z180.o - different CPU-IXIY combination
Skipping $test.z180-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80.o - different CPU-IXIY combination
Skipping $test.ez80-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80_z80.o - different CPU-IXIY combination
Skipping $test.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping $test.r2ka.o - different CPU-IXIY combination
Adding $test.r2ka-IXIY.o to library
Skipping $test.r3k.o - different CPU-IXIY combination
Skipping $test.r3k-IXIY.o - different CPU-IXIY combination
Skipping $test.8080.o - different CPU-IXIY combination
Skipping $test.8080-IXIY.o - different CPU-IXIY combination
Skipping $test.8085.o - different CPU-IXIY combination
Skipping $test.8085-IXIY.o - different CPU-IXIY combination
Skipping $test.gbz80.o - different CPU-IXIY combination
Skipping $test.gbz80-IXIY.o - different CPU-IXIY combination
Predefined constant: __CPU_8080__ = 1
Predefined constant: __CPU_INTEL__ = 1
Skipping $test.z80.o - different CPU-IXIY combination
Skipping $test.z80-IXIY.o - different CPU-IXIY combination
Skipping $test.z80_strict.o - different CPU-IXIY combination
Skipping $test.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping $test.z80n.o - different CPU-IXIY combination
Skipping $test.z80n-IXIY.o - different CPU-IXIY combination
Skipping $test.z180.o - different CPU-IXIY combination
Skipping $test.z180-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80.o - different CPU-IXIY combination
Skipping $test.ez80-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80_z80.o - different CPU-IXIY combination
Skipping $test.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping $test.r2ka.o - different CPU-IXIY combination
Skipping $test.r2ka-IXIY.o - different CPU-IXIY combination
Skipping $test.r3k.o - different CPU-IXIY combination
Skipping $test.r3k-IXIY.o - different CPU-IXIY combination
Adding $test.8080.o to library
Skipping $test.8080-IXIY.o - different CPU-IXIY combination
Skipping $test.8085.o - different CPU-IXIY combination
Skipping $test.8085-IXIY.o - different CPU-IXIY combination
Skipping $test.gbz80.o - different CPU-IXIY combination
Skipping $test.gbz80-IXIY.o - different CPU-IXIY combination
Predefined constant: __SWAP_IX_IY__ = 1
Skipping $test.z80.o - different CPU-IXIY combination
Skipping $test.z80-IXIY.o - different CPU-IXIY combination
Skipping $test.z80_strict.o - different CPU-IXIY combination
Skipping $test.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping $test.z80n.o - different CPU-IXIY combination
Skipping $test.z80n-IXIY.o - different CPU-IXIY combination
Skipping $test.z180.o - different CPU-IXIY combination
Skipping $test.z180-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80.o - different CPU-IXIY combination
Skipping $test.ez80-IXIY.o - different CPU-IXIY combination
Skipping $test.ez80_z80.o - different CPU-IXIY combination
Skipping $test.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping $test.r2ka.o - different CPU-IXIY combination
Skipping $test.r2ka-IXIY.o - different CPU-IXIY combination
Skipping $test.r3k.o - different CPU-IXIY combination
Skipping $test.r3k-IXIY.o - different CPU-IXIY combination
Skipping $test.8080.o - different CPU-IXIY combination
Adding $test.8080-IXIY.o to library
Skipping $test.8085.o - different CPU-IXIY combination
Skipping $test.8085-IXIY.o - different CPU-IXIY combination
Skipping $test.gbz80.o - different CPU-IXIY combination
Skipping $test.gbz80-IXIY.o - different CPU-IXIY combination
END

	capture_ok("z88dk-z80nm -a $test.1.lib", <<END);
Library file $test.1.lib at \$0000: Z80LMF18
Object  file $test.1.lib at \$0014: Z80RMF18
  Name: $test.z80n
  CPU:  z80n 
  Section "": 1 bytes
    C \$0000: 00

Object  file $test.1.lib at \$0088: Z80RMF18
  Name: $test.z80n-IXIY
  CPU:  z80n (-IXIY)
  Section "": 1 bytes
    C \$0000: 00

Object  file $test.1.lib at \$0104: Z80RMF18
  Name: $test.z80
  CPU:  z80 
  Section "": 1 bytes
    C \$0000: 00

Object  file $test.1.lib at \$0178: Z80RMF18
  Name: $test.z80-IXIY
  CPU:  z80 (-IXIY)
  Section "": 1 bytes
    C \$0000: 00

Object  file $test.1.lib at \$01F0: Z80RMF18
  Name: $test.ez80_z80
  CPU:  ez80_z80 
  Section "": 1 bytes
    C \$0000: 00

Object  file $test.1.lib at \$0268: Z80RMF18
  Name: $test.ez80_z80-IXIY
  CPU:  ez80_z80 (-IXIY)
  Section "": 1 bytes
    C \$0000: 00

Object  file $test.1.lib at \$02E8: Z80RMF18
  Name: $test.z180
  CPU:  z180 
  Section "": 1 bytes
    C \$0000: 00

Object  file $test.1.lib at \$035C: Z80RMF18
  Name: $test.z180-IXIY
  CPU:  z180 (-IXIY)
  Section "": 1 bytes
    C \$0000: 00

Object  file $test.1.lib at \$03D8: Z80RMF18
  Name: $test.z80_strict
  CPU:  z80_strict 
  Section "": 1 bytes
    C \$0000: 00

Object  file $test.1.lib at \$0454: Z80RMF18
  Name: $test.z80_strict-IXIY
  CPU:  z80_strict (-IXIY)
  Section "": 1 bytes
    C \$0000: 00

Object  file $test.1.lib at \$04D4: Z80RMF18
  Name: $test.8085
  CPU:  8085 
  Section "": 1 bytes
    C \$0000: 00

Object  file $test.1.lib at \$0548: Z80RMF18
  Name: $test.8085-IXIY
  CPU:  8085 (-IXIY)
  Section "": 1 bytes
    C \$0000: 00

Object  file $test.1.lib at \$05C4: Z80RMF18
  Name: $test.r3k
  CPU:  r3k 
  Section "": 1 bytes
    C \$0000: 00

Object  file $test.1.lib at \$0638: Z80RMF18
  Name: $test.r3k-IXIY
  CPU:  r3k (-IXIY)
  Section "": 1 bytes
    C \$0000: 00

Object  file $test.1.lib at \$06B0: Z80RMF18
  Name: $test.gbz80
  CPU:  gbz80 
  Section "": 1 bytes
    C \$0000: 00

Object  file $test.1.lib at \$0728: Z80RMF18
  Name: $test.gbz80-IXIY
  CPU:  gbz80 (-IXIY)
  Section "": 1 bytes
    C \$0000: 00

Object  file $test.1.lib at \$07A4: Z80RMF18
  Name: $test.ez80
  CPU:  ez80 
  Section "": 1 bytes
    C \$0000: 00

Object  file $test.1.lib at \$0818: Z80RMF18
  Name: $test.ez80-IXIY
  CPU:  ez80 (-IXIY)
  Section "": 1 bytes
    C \$0000: 00

Object  file $test.1.lib at \$0894: Z80RMF18
  Name: $test.r2ka
  CPU:  r2ka 
  Section "": 1 bytes
    C \$0000: 00

Object  file $test.1.lib at \$0908: Z80RMF18
  Name: $test.r2ka-IXIY
  CPU:  r2ka (-IXIY)
  Section "": 1 bytes
    C \$0000: 00

Object  file $test.1.lib at \$0984: Z80RMF18
  Name: $test.8080
  CPU:  8080 
  Section "": 1 bytes
    C \$0000: 00

Object  file $test.1.lib at \$09F8: Z80RMF18
  Name: $test.8080-IXIY
  CPU:  8080 (-IXIY)
  Section "": 1 bytes
    C \$0000: 00

END
}

# test use-after-delete modlink - fails on Linux

unlink_testfiles;
spew("$test.1.asm", <<END);
			public the_answer
	the_answer = 42
END

unlink("$test.1.o", "$test.1.lib");
capture_ok("z88dk-z80asm -x$test.1.lib $test.1.asm", "");
unlink("$test.1.o", "$test.1.asm");

spew("$test.asm", <<END);
	extern the_answer
	defb the_answer
END

unlink("$test.o", "$test.bin");
capture_ok("z88dk-z80asm -b -m -l$test.1.lib $test.asm", "");
check_bin_file("$test.bin", bytes(42));
check_text_file("$test.map", <<END);
the_answer                      = \$002A ; const, public, , $test.1, , $test.1.asm:2
__head                          = \$0000 ; const, public, def, , ,
__tail                          = \$0001 ; const, public, def, , ,
__size                          = \$0001 ; const, public, def, , ,
END


# link object files

unlink_testfiles;
for my $lib_ixiy ("", "-IXIY", "-IXIY-soft") {
	my $lib_ixiy_cpu = $lib_ixiy ? "($lib_ixiy)" : "";
	my %IXIY_ERROR = (""=>"(no option)", "-IXIY"=>"-IXIY", "-IXIY-soft"=>"-IXIY-soft");
		
	for my $lib_cpu (@CPUS) {
		
		spew("$test.1.asm", <<END);
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
		spew("$test.asm", <<END);
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
spew("$test.asm", <<END);
		extern the_answer
		defb the_answer
END

spew("$test.1.asm", <<END);
	public the_answer
the_answer = 42
	ifdef __CPU_8080__		: defm "8080"		: endif
	ifdef __CPU_8085__		: defm "8085"		: endif
	ifdef __CPU_EZ80_ADL__	: defm "ez80"		: endif
	ifdef __CPU_EZ80_Z80__	: defm "ez80_z80"	: endif
	ifdef __CPU_GBZ80__		: defm "gbz80"		: endif
	ifdef __CPU_R2KA__		: defm "r2ka"		: endif
	ifdef __CPU_R3K__		: defm "r3k"		: endif
	ifdef __CPU_Z180__		: defm "z180"		: endif
	ifdef __CPU_Z80__		: defm "z80"		: endif
	ifdef __CPU_Z80_STRICT__: defm "z80_strict"	: endif
	ifdef __CPU_Z80N__		: defm "z80n" 		: endif
	ifdef __SWAP_IX_IY__	: defm "-IXIY"		: endif
END

spew("$test.asm", <<END);
	extern the_answer
	defb the_answer
END

for my $lib_ixiy ("", "-IXIY") {
	unlink("$test.1.lib");
	capture_ok("z88dk-z80asm $lib_ixiy -m\"*\" -x$test.1.lib $test.1.asm", "");
	ok -f "$test.1.lib", "$test.1.lib created";
	
	capture_ok("z88dk-z80nm -a $test.1.lib", <<END);
Library file $test.1.lib at \$0000: Z80LMF18
Object  file $test.1.lib at \$0014: Z80RMF18
  Name: $test.1
  CPU:  z80n 
  Section "": 4 bytes
    C \$0000: 7A 38 30 6E
  Symbols:
    L C \$0001: __CPU_Z80N__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0100: Z80RMF18
  Name: $test.1
  CPU:  z80n (-IXIY)
  Section "": 9 bytes
    C \$0000: 7A 38 30 6E 2D 49 58 49 59
  Symbols:
    L C \$0001: __CPU_Z80N__ (section "") (file $test.1.asm)
    L C \$0001: __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0220: Z80RMF18
  Name: $test.1
  CPU:  z80 
  Section "": 3 bytes
    C \$0000: 7A 38 30
  Symbols:
    L C \$0001: __CPU_Z80__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0308: Z80RMF18
  Name: $test.1
  CPU:  z80 (-IXIY)
  Section "": 8 bytes
    C \$0000: 7A 38 30 2D 49 58 49 59
  Symbols:
    L C \$0001: __CPU_Z80__ (section "") (file $test.1.asm)
    L C \$0001: __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0424: Z80RMF18
  Name: $test.1
  CPU:  ez80_z80 
  Section "": 8 bytes
    C \$0000: 65 7A 38 30 5F 7A 38 30
  Symbols:
    L C \$0001: __CPU_EZ80_Z80__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0518: Z80RMF18
  Name: $test.1
  CPU:  ez80_z80 (-IXIY)
  Section "": 13 bytes
    C \$0000: 65 7A 38 30 5F 7A 38 30 2D 49 58 49 59
  Symbols:
    L C \$0001: __CPU_EZ80_Z80__ (section "") (file $test.1.asm)
    L C \$0001: __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0640: Z80RMF18
  Name: $test.1
  CPU:  z180 
  Section "": 4 bytes
    C \$0000: 7A 31 38 30
  Symbols:
    L C \$0001: __CPU_Z180__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$072C: Z80RMF18
  Name: $test.1
  CPU:  z180 (-IXIY)
  Section "": 9 bytes
    C \$0000: 7A 31 38 30 2D 49 58 49 59
  Symbols:
    L C \$0001: __CPU_Z180__ (section "") (file $test.1.asm)
    L C \$0001: __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$084C: Z80RMF18
  Name: $test.1
  CPU:  z80_strict 
  Section "": 10 bytes
    C \$0000: 7A 38 30 5F 73 74 72 69 63 74
  Symbols:
    L C \$0001: __CPU_Z80_STRICT__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0944: Z80RMF18
  Name: $test.1
  CPU:  z80_strict (-IXIY)
  Section "": 15 bytes
    C \$0000: 7A 38 30 5F 73 74 72 69 63 74 2D 49 58 49 59
  Symbols:
    L C \$0001: __CPU_Z80_STRICT__ (section "") (file $test.1.asm)
    L C \$0001: __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0A70: Z80RMF18
  Name: $test.1
  CPU:  8085 
  Section "": 4 bytes
    C \$0000: 38 30 38 35
  Symbols:
    L C \$0001: __CPU_8085__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0B5C: Z80RMF18
  Name: $test.1
  CPU:  8085 (-IXIY)
  Section "": 9 bytes
    C \$0000: 38 30 38 35 2D 49 58 49 59
  Symbols:
    L C \$0001: __CPU_8085__ (section "") (file $test.1.asm)
    L C \$0001: __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0C7C: Z80RMF18
  Name: $test.1
  CPU:  r3k 
  Section "": 3 bytes
    C \$0000: 72 33 6B
  Symbols:
    L C \$0001: __CPU_R3K__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0D64: Z80RMF18
  Name: $test.1
  CPU:  r3k (-IXIY)
  Section "": 8 bytes
    C \$0000: 72 33 6B 2D 49 58 49 59
  Symbols:
    L C \$0001: __CPU_R3K__ (section "") (file $test.1.asm)
    L C \$0001: __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0E80: Z80RMF18
  Name: $test.1
  CPU:  gbz80 
  Section "": 5 bytes
    C \$0000: 67 62 7A 38 30
  Symbols:
    L C \$0001: __CPU_GBZ80__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0F70: Z80RMF18
  Name: $test.1
  CPU:  gbz80 (-IXIY)
  Section "": 10 bytes
    C \$0000: 67 62 7A 38 30 2D 49 58 49 59
  Symbols:
    L C \$0001: __CPU_GBZ80__ (section "") (file $test.1.asm)
    L C \$0001: __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$1094: Z80RMF18
  Name: $test.1
  CPU:  ez80 
  Section "": 4 bytes
    C \$0000: 65 7A 38 30
  Symbols:
    L C \$0001: __CPU_EZ80_ADL__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$1184: Z80RMF18
  Name: $test.1
  CPU:  ez80 (-IXIY)
  Section "": 9 bytes
    C \$0000: 65 7A 38 30 2D 49 58 49 59
  Symbols:
    L C \$0001: __CPU_EZ80_ADL__ (section "") (file $test.1.asm)
    L C \$0001: __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$12A8: Z80RMF18
  Name: $test.1
  CPU:  r2ka 
  Section "": 4 bytes
    C \$0000: 72 32 6B 61
  Symbols:
    L C \$0001: __CPU_R2KA__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$1394: Z80RMF18
  Name: $test.1
  CPU:  r2ka (-IXIY)
  Section "": 9 bytes
    C \$0000: 72 32 6B 61 2D 49 58 49 59
  Symbols:
    L C \$0001: __CPU_R2KA__ (section "") (file $test.1.asm)
    L C \$0001: __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$14B4: Z80RMF18
  Name: $test.1
  CPU:  8080 
  Section "": 4 bytes
    C \$0000: 38 30 38 30
  Symbols:
    L C \$0001: __CPU_8080__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$15A0: Z80RMF18
  Name: $test.1
  CPU:  8080 (-IXIY)
  Section "": 9 bytes
    C \$0000: 38 30 38 30 2D 49 58 49 59
  Symbols:
    L C \$0001: __CPU_8080__ (section "") (file $test.1.asm)
    L C \$0001: __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

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

unlink_testfiles;
unlink("$test.1.lib");
capture_ok("z88dk-z80asm -IXIY-soft -m\"*\" -x$test.1.lib $test.1.asm", "");
ok -f "$test.1.lib", "$test.1.lib created";

capture_ok("z88dk-z80nm -a $test.1.lib", <<END);
Library file $test.1.lib at \$0000: Z80LMF18
Object  file $test.1.lib at \$0014: Z80RMF18
  Name: $test.1
  CPU:  z80n (-IXIY-soft)
  Section "": 9 bytes
    C \$0000: 7A 38 30 6E 2D 49 58 49 59
  Symbols:
    L C \$0001: __CPU_Z80N__ (section "") (file $test.1.asm)
    L C \$0001: __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0134: Z80RMF18
  Name: $test.1
  CPU:  z80 (-IXIY-soft)
  Section "": 8 bytes
    C \$0000: 7A 38 30 2D 49 58 49 59
  Symbols:
    L C \$0001: __CPU_Z80__ (section "") (file $test.1.asm)
    L C \$0001: __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0250: Z80RMF18
  Name: $test.1
  CPU:  ez80_z80 (-IXIY-soft)
  Section "": 13 bytes
    C \$0000: 65 7A 38 30 5F 7A 38 30 2D 49 58 49 59
  Symbols:
    L C \$0001: __CPU_EZ80_Z80__ (section "") (file $test.1.asm)
    L C \$0001: __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0378: Z80RMF18
  Name: $test.1
  CPU:  z180 (-IXIY-soft)
  Section "": 9 bytes
    C \$0000: 7A 31 38 30 2D 49 58 49 59
  Symbols:
    L C \$0001: __CPU_Z180__ (section "") (file $test.1.asm)
    L C \$0001: __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0498: Z80RMF18
  Name: $test.1
  CPU:  z80_strict (-IXIY-soft)
  Section "": 15 bytes
    C \$0000: 7A 38 30 5F 73 74 72 69 63 74 2D 49 58 49 59
  Symbols:
    L C \$0001: __CPU_Z80_STRICT__ (section "") (file $test.1.asm)
    L C \$0001: __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$05C4: Z80RMF18
  Name: $test.1
  CPU:  8085 (-IXIY-soft)
  Section "": 9 bytes
    C \$0000: 38 30 38 35 2D 49 58 49 59
  Symbols:
    L C \$0001: __CPU_8085__ (section "") (file $test.1.asm)
    L C \$0001: __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$06E4: Z80RMF18
  Name: $test.1
  CPU:  r3k (-IXIY-soft)
  Section "": 8 bytes
    C \$0000: 72 33 6B 2D 49 58 49 59
  Symbols:
    L C \$0001: __CPU_R3K__ (section "") (file $test.1.asm)
    L C \$0001: __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0800: Z80RMF18
  Name: $test.1
  CPU:  gbz80 (-IXIY-soft)
  Section "": 10 bytes
    C \$0000: 67 62 7A 38 30 2D 49 58 49 59
  Symbols:
    L C \$0001: __CPU_GBZ80__ (section "") (file $test.1.asm)
    L C \$0001: __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0924: Z80RMF18
  Name: $test.1
  CPU:  ez80 (-IXIY-soft)
  Section "": 9 bytes
    C \$0000: 65 7A 38 30 2D 49 58 49 59
  Symbols:
    L C \$0001: __CPU_EZ80_ADL__ (section "") (file $test.1.asm)
    L C \$0001: __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0A48: Z80RMF18
  Name: $test.1
  CPU:  r2ka (-IXIY-soft)
  Section "": 9 bytes
    C \$0000: 72 32 6B 61 2D 49 58 49 59
  Symbols:
    L C \$0001: __CPU_R2KA__ (section "") (file $test.1.asm)
    L C \$0001: __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0B68: Z80RMF18
  Name: $test.1
  CPU:  8080 (-IXIY-soft)
  Section "": 9 bytes
    C \$0000: 38 30 38 30 2D 49 58 49 59
  Symbols:
    L C \$0001: __CPU_8080__ (section "") (file $test.1.asm)
    L C \$0001: __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

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
	spew("$test.asm", <<END);
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
