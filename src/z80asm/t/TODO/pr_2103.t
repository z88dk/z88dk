#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;
use CPU::Z80::Assembler;

# make l_bsearch and l_qsort work for 8080 and gbz80 CPUs
# https://github.com/z88dk/z88dk/pull/2103

# Question: does z80asm allow ix and iy in a gbz80 compile in a non-active IF
# section?

spew("$test.asm", <<END);
IF __CPU_ZILOG__||__CPU_RABBIT__
	section code
	ld a, (ix+3)
ELIF __CPU_GBZ80__
	section code
	ld hl, ix_
	ld c, (hl)
	inc hl
	ld b, (hl)
	ld hl, 3
	add hl, bc
	ld a, (hl)

	section data
ix_:defw 0
ELSE
	section code
	ld hl, (ix_)
	ld bc, 3
	add hl, bc
	ld a, (hl)

	section data
ix_:defw 0
ENDIF

END

my $bin = z80asm(<<END);
	ld a, (ix+3)
END
for my $cpu (qw( z80 z80n z180 r2ka r3k  ti83 ti83plus )) {
	run_ok("./z88dk-z80asm -m$cpu -b $test.asm");
	check_bin_file("$test.bin", $bin);
	
	die unless Test::More->builder->is_passing;
}

$bin = z80asm(<<END);
	ld hl, (ix_)
	ld bc, 3
	add hl, bc
	ld a, (hl)
ix_:defw 0
END
for my $cpu (qw( 8080 8085 )) {
	run_ok("./z88dk-z80asm -m$cpu -b $test.asm");
	check_bin_file("$test.bin", $bin);
	
	die unless Test::More->builder->is_passing;
}

$bin = z80asm(<<END);
	ld hl, ix_
	ld c, (hl)
	inc hl
	ld b, (hl)
	ld hl, 3
	add hl, bc
	ld a, (hl)
ix_:defw 0
END
for my $cpu (qw( gbz80 )) {
	run_ok("./z88dk-z80asm -m$cpu -b $test.asm");
	check_bin_file("$test.bin", $bin);
	
	die unless Test::More->builder->is_passing;
}

unlink_testfiles;
done_testing;
