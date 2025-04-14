#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2320
# z80asm: do not link with object files built for a different cpu

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
% z88dk-z80asm -v -m* -xtest_t_issue_2320_m.1.lib test_t_issue_2320_m.z80.o test_t_issue_2320_m.z80-IXIY.o test_t_issue_2320_m.z80_strict.o test_t_issue_2320_m.z80_strict-IXIY.o test_t_issue_2320_m.z80n.o test_t_issue_2320_m.z80n-IXIY.o test_t_issue_2320_m.z80n_strict.o test_t_issue_2320_m.z80n_strict-IXIY.o test_t_issue_2320_m.z180.o test_t_issue_2320_m.z180-IXIY.o test_t_issue_2320_m.z180_strict.o test_t_issue_2320_m.z180_strict-IXIY.o test_t_issue_2320_m.ez80.o test_t_issue_2320_m.ez80-IXIY.o test_t_issue_2320_m.ez80_strict.o test_t_issue_2320_m.ez80_strict-IXIY.o test_t_issue_2320_m.ez80_z80.o test_t_issue_2320_m.ez80_z80-IXIY.o test_t_issue_2320_m.ez80_z80_strict.o test_t_issue_2320_m.ez80_z80_strict-IXIY.o test_t_issue_2320_m.r800.o test_t_issue_2320_m.r800-IXIY.o test_t_issue_2320_m.r800_strict.o test_t_issue_2320_m.r800_strict-IXIY.o test_t_issue_2320_m.r2ka.o test_t_issue_2320_m.r2ka-IXIY.o test_t_issue_2320_m.r3k.o test_t_issue_2320_m.r3k-IXIY.o test_t_issue_2320_m.r4k.o test_t_issue_2320_m.r4k-IXIY.o test_t_issue_2320_m.r5k.o test_t_issue_2320_m.r5k-IXIY.o test_t_issue_2320_m.8080.o test_t_issue_2320_m.8080-IXIY.o test_t_issue_2320_m.8085.o test_t_issue_2320_m.8085-IXIY.o test_t_issue_2320_m.gbz80.o test_t_issue_2320_m.gbz80-IXIY.o test_t_issue_2320_m.gbz80_strict.o test_t_issue_2320_m.gbz80_strict-IXIY.o test_t_issue_2320_m.kc160.o test_t_issue_2320_m.kc160-IXIY.o test_t_issue_2320_m.kc160_z80.o test_t_issue_2320_m.kc160_z80-IXIY.o
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Creating library 'test_t_issue_2320_m.1.lib'
Predefined constant: __CPU_Z80N__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.z80n.o to library
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.z80n-IXIY.o to library
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Adding test_t_issue_2320_m.z80.o to library
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.z80-IXIY.o to library
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_Z180__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.z180.o to library
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.z180-IXIY.o to library
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_R3K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.r3k.o to library
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.r3k-IXIY.o to library
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_8085__ = 1
Predefined constant: __CPU_INTEL__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.8085.o to library
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.8085-IXIY.o to library
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_R800__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.r800.o to library
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.r800-IXIY.o to library
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_R5K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.r5k.o to library
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.r5k-IXIY.o to library
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_KC160_Z80__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.kc160_z80.o to library
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.kc160_z80-IXIY.o to library

Predefined constant: __CPU_EZ80_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.ez80_z80.o to library
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.ez80_z80-IXIY.o to library
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_EZ80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.ez80.o to library
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.ez80-IXIY.o to library
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_R2KA__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.r2ka.o to library
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.r2ka-IXIY.o to library
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_GBZ80__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.gbz80.o to library
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.gbz80-IXIY.o to library
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_8080__ = 1
Predefined constant: __CPU_INTEL__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.8080.o to library
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.8080-IXIY.o to library
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_R4K__ = 1
Predefined constant: __CPU_RABBIT__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.r4k.o to library
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.r4k-IXIY.o to library
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __CPU_KC160__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.kc160.o to library
Skipping test_t_issue_2320_m.kc160-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

Predefined constant: __SWAP_IX_IY__ = 1
Skipping test_t_issue_2320_m.z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z80n_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.z180_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.ez80_z80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r800_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r2ka-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r3k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r4k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.r5k-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8080-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.8085-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.gbz80_strict-IXIY.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160.o - different CPU-IXIY combination
Adding test_t_issue_2320_m.kc160-IXIY.o to library
Skipping test_t_issue_2320_m.kc160_z80.o - different CPU-IXIY combination
Skipping test_t_issue_2320_m.kc160_z80-IXIY.o - different CPU-IXIY combination

END

	capture_ok("z88dk-z80nm -a $test.1.lib", <<'END');
Library file test_t_issue_2320_m.1.lib at $0000: Z80LMF18
Object  file test_t_issue_2320_m.1.lib at $0014: Z80RMF18
  Name: test_t_issue_2320_m.z80n
  CPU:  z80n 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $008C: Z80RMF18
  Name: test_t_issue_2320_m.z80n-IXIY
  CPU:  z80n (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $0108: Z80RMF18
  Name: test_t_issue_2320_m.z80
  CPU:  z80 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $0180: Z80RMF18
  Name: test_t_issue_2320_m.z80-IXIY
  CPU:  z80 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $01FC: Z80RMF18
  Name: test_t_issue_2320_m.z180
  CPU:  z180 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $0274: Z80RMF18
  Name: test_t_issue_2320_m.z180-IXIY
  CPU:  z180 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $02F0: Z80RMF18
  Name: test_t_issue_2320_m.r3k
  CPU:  r3k 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $0368: Z80RMF18
  Name: test_t_issue_2320_m.r3k-IXIY
  CPU:  r3k (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $03E4: Z80RMF18
  Name: test_t_issue_2320_m.8085
  CPU:  8085 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $045C: Z80RMF18
  Name: test_t_issue_2320_m.8085-IXIY
  CPU:  8085 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $04D8: Z80RMF18
  Name: test_t_issue_2320_m.r800
  CPU:  r800 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $0550: Z80RMF18
  Name: test_t_issue_2320_m.r800-IXIY
  CPU:  r800 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $05CC: Z80RMF18
  Name: test_t_issue_2320_m.r5k
  CPU:  r5k 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $0644: Z80RMF18
  Name: test_t_issue_2320_m.r5k-IXIY
  CPU:  r5k (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $06C0: Z80RMF18
  Name: test_t_issue_2320_m.kc160_z80
  CPU:  kc160_z80 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $073C: Z80RMF18
  Name: test_t_issue_2320_m.kc160_z80-IXIY
  CPU:  kc160_z80 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $07BC: Z80RMF18
  Name: test_t_issue_2320_m.ez80_z80
  CPU:  ez80_z80 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $0838: Z80RMF18
  Name: test_t_issue_2320_m.ez80_z80-IXIY
  CPU:  ez80_z80 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $08B8: Z80RMF18
  Name: test_t_issue_2320_m.ez80
  CPU:  ez80 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $0930: Z80RMF18
  Name: test_t_issue_2320_m.ez80-IXIY
  CPU:  ez80 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $09AC: Z80RMF18
  Name: test_t_issue_2320_m.r2ka
  CPU:  r2ka 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $0A24: Z80RMF18
  Name: test_t_issue_2320_m.r2ka-IXIY
  CPU:  r2ka (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $0AA0: Z80RMF18
  Name: test_t_issue_2320_m.gbz80
  CPU:  gbz80 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $0B18: Z80RMF18
  Name: test_t_issue_2320_m.gbz80-IXIY
  CPU:  gbz80 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $0B94: Z80RMF18
  Name: test_t_issue_2320_m.8080
  CPU:  8080 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $0C0C: Z80RMF18
  Name: test_t_issue_2320_m.8080-IXIY
  CPU:  8080 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $0C88: Z80RMF18
  Name: test_t_issue_2320_m.r4k
  CPU:  r4k 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $0D00: Z80RMF18
  Name: test_t_issue_2320_m.r4k-IXIY
  CPU:  r4k (-IXIY)
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $0D7C: Z80RMF18
  Name: test_t_issue_2320_m.kc160
  CPU:  kc160 
  Section "": 1 bytes
    C $0000: 00

Object  file test_t_issue_2320_m.1.lib at $0DF4: Z80RMF18
  Name: test_t_issue_2320_m.kc160-IXIY
  CPU:  kc160 (-IXIY)
  Section "": 1 bytes
    C $0000: 00

END
}

unlink_testfiles;
done_testing;
