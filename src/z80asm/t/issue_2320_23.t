#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2320
# z80asm: do not link with object files built for a different cpu


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

	capture_ok("z88dk-z80asm -v -m* -x$test.1.lib @objs", <<'END');
% z88dk-z80asm -v -m* -xtest_t_issue_2320_23.1.lib test_t_issue_2320_23.z80.o test_t_issue_2320_23.z80-IXIY.o test_t_issue_2320_23.z80_strict.o test_t_issue_2320_23.z80_strict-IXIY.o test_t_issue_2320_23.z80n.o test_t_issue_2320_23.z80n-IXIY.o test_t_issue_2320_23.z180.o test_t_issue_2320_23.z180-IXIY.o test_t_issue_2320_23.ez80.o test_t_issue_2320_23.ez80-IXIY.o test_t_issue_2320_23.ez80_z80.o test_t_issue_2320_23.ez80_z80-IXIY.o test_t_issue_2320_23.r800.o test_t_issue_2320_23.r800-IXIY.o test_t_issue_2320_23.r2ka.o test_t_issue_2320_23.r2ka-IXIY.o test_t_issue_2320_23.r3k.o test_t_issue_2320_23.r3k-IXIY.o test_t_issue_2320_23.r4k.o test_t_issue_2320_23.r4k-IXIY.o test_t_issue_2320_23.r5k.o test_t_issue_2320_23.r5k-IXIY.o test_t_issue_2320_23.8080.o test_t_issue_2320_23.8080-IXIY.o test_t_issue_2320_23.8085.o test_t_issue_2320_23.8085-IXIY.o test_t_issue_2320_23.gbz80.o test_t_issue_2320_23.gbz80-IXIY.o test_t_issue_2320_23.kc160.o test_t_issue_2320_23.kc160-IXIY.o test_t_issue_2320_23.kc160_z80.o test_t_issue_2320_23.kc160_z80-IXIY.o
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Creating library 'test_t_issue_2320_23.1.lib'
Predefined constant: __CPU_Z80N__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.z80n.o to library
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.z80n-IXIY.o to library
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Adding test_t_issue_2320_23.z80.o to library
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.z80-IXIY.o to library
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_Z180__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.z180.o to library
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.z180-IXIY.o to library
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_R800__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.r800.o to library
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.r800-IXIY.o to library
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_KC160_Z80__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.kc160_z80.o to library
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.kc160_z80-IXIY.o to library

Predefined constant: __CPU_Z80_STRICT__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.z80_strict.o to library
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.z80_strict-IXIY.o to library
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_R3K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.r3k.o to library
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.r3k-IXIY.o to library
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_8085__ = 1
Predefined constant: __CPU_INTEL__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.8085.o to library
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.8085-IXIY.o to library
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_R5K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.r5k.o to library
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.r5k-IXIY.o to library
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_EZ80_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.ez80_z80.o to library
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.ez80_z80-IXIY.o to library
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_EZ80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.ez80.o to library
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.ez80-IXIY.o to library
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_R2KA__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.r2ka.o to library
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.r2ka-IXIY.o to library
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_GBZ80__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.gbz80.o to library
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.gbz80-IXIY.o to library
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_8080__ = 1
Predefined constant: __CPU_INTEL__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.8080.o to library
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.8080-IXIY.o to library
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_R4K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.r4k.o to library
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.r4k-IXIY.o to library
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_KC160__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.kc160.o to library
Skipping test_t_issue_2320_23.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_23.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160.o - different CPU-IXIY combination
Adding test_t_issue_2320_23.kc160-IXIY.o to library
Skipping test_t_issue_2320_23.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_23.kc160_z80-IXIY.o - different CPU-IXIY combination

END

	capture_ok("z88dk-z80nm -a $test.1.lib", <<'END');
Library file test_t_issue_2320_23.1.lib at $0000: Z80LMF18
Object  file test_t_issue_2320_23.1.lib at $0014: Z80RMF18
  Name: test_t_issue_2320_23.z80n
  CPU:  z80n 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $008C: Z80RMF18
  Name: test_t_issue_2320_23.z80n-IXIY
  CPU:  z80n (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $0108: Z80RMF18
  Name: test_t_issue_2320_23.z80
  CPU:  z80 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $0180: Z80RMF18
  Name: test_t_issue_2320_23.z80-IXIY
  CPU:  z80 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $01FC: Z80RMF18
  Name: test_t_issue_2320_23.z180
  CPU:  z180 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $0274: Z80RMF18
  Name: test_t_issue_2320_23.z180-IXIY
  CPU:  z180 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $02F0: Z80RMF18
  Name: test_t_issue_2320_23.r800
  CPU:  r800 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $0368: Z80RMF18
  Name: test_t_issue_2320_23.r800-IXIY
  CPU:  r800 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $03E4: Z80RMF18
  Name: test_t_issue_2320_23.kc160_z80
  CPU:  kc160_z80 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $0460: Z80RMF18
  Name: test_t_issue_2320_23.kc160_z80-IXIY
  CPU:  kc160_z80 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $04E4: Z80RMF18
  Name: test_t_issue_2320_23.z80_strict
  CPU:  z80_strict 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $0564: Z80RMF18
  Name: test_t_issue_2320_23.z80_strict-IXIY
  CPU:  z80_strict (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $05E8: Z80RMF18
  Name: test_t_issue_2320_23.r3k
  CPU:  r3k 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $0660: Z80RMF18
  Name: test_t_issue_2320_23.r3k-IXIY
  CPU:  r3k (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $06DC: Z80RMF18
  Name: test_t_issue_2320_23.8085
  CPU:  8085 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $0754: Z80RMF18
  Name: test_t_issue_2320_23.8085-IXIY
  CPU:  8085 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $07D0: Z80RMF18
  Name: test_t_issue_2320_23.r5k
  CPU:  r5k 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $0848: Z80RMF18
  Name: test_t_issue_2320_23.r5k-IXIY
  CPU:  r5k (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $08C4: Z80RMF18
  Name: test_t_issue_2320_23.ez80_z80
  CPU:  ez80_z80 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $0940: Z80RMF18
  Name: test_t_issue_2320_23.ez80_z80-IXIY
  CPU:  ez80_z80 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $09C0: Z80RMF18
  Name: test_t_issue_2320_23.ez80
  CPU:  ez80 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $0A38: Z80RMF18
  Name: test_t_issue_2320_23.ez80-IXIY
  CPU:  ez80 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $0AB4: Z80RMF18
  Name: test_t_issue_2320_23.r2ka
  CPU:  r2ka 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $0B2C: Z80RMF18
  Name: test_t_issue_2320_23.r2ka-IXIY
  CPU:  r2ka (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $0BA8: Z80RMF18
  Name: test_t_issue_2320_23.gbz80
  CPU:  gbz80 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $0C20: Z80RMF18
  Name: test_t_issue_2320_23.gbz80-IXIY
  CPU:  gbz80 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $0CA0: Z80RMF18
  Name: test_t_issue_2320_23.8080
  CPU:  8080 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $0D18: Z80RMF18
  Name: test_t_issue_2320_23.8080-IXIY
  CPU:  8080 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $0D94: Z80RMF18
  Name: test_t_issue_2320_23.r4k
  CPU:  r4k 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $0E0C: Z80RMF18
  Name: test_t_issue_2320_23.r4k-IXIY
  CPU:  r4k (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $0E88: Z80RMF18
  Name: test_t_issue_2320_23.kc160
  CPU:  kc160 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_23.1.lib at $0F00: Z80RMF18
  Name: test_t_issue_2320_23.kc160-IXIY
  CPU:  kc160 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

END
}


unlink_testfiles;
done_testing;
