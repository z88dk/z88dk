#!/usr/bin/perl

#------------------------------------------------------------------------------
# z80asm assembler
# Generate test code and parsing tables for the cpus supported by z80asm
# Copyright (C) Paulo Custodio, 2011-2019
# License: http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------

use Modern::Perl;
use Text::Table;

# %Opcodes: $Opcodes{$asm}{$cpu} = [@bin]
my %Opcodes;

# %Parser: $Parser{$tokens}{$cpu}{$parens}{ixiy|iyix} = [$asm, @bin]
my %Parser;

# %Tests: $Tests{$asm}{$cpu} = $bin
my %Tests;

#------------------------------------------------------------------------------
# Programatic opcode generator
# asm placeholders:
#	%s	signed byte
#	%n	unsigned byte
#	%m	unsigned word
#	%M	unsigned word, big-endian
#	%j	jr offset
#	%c	constant (im, bit, rst, ...)
#	%d	signed register indirect offset
#	%u	unsigned register indirect offset
#	%t	temp jump label
#	@label	unsigned word with given global label address
#------------------------------------------------------------------------------
my @CPUS = qw( z80 z80n z180 r2k r3k 8080 8085 gbz80 );

my %INV_FLAG 	= qw( 	_nz	_z 
						_z 	_nz
						_nc _c 
						_c	_nc
						_po _pe 
						_pe	_po
						_nv _v 
						_v	_nv
						_lz _lo 
						_lo	_lz
						_p 	_m
						_m	_p );
my %V = (
	'' => '',
	b => 0, c => 1, d => 2, e => 3, h => 4, l => 5, '(hl)' => 6, f => 6, m => 6, a => 7,
	bc => 0, de => 1, hl => 2, sp => 3, af => 3,
	_nz => 0, _z => 1, _nc => 2, _c => 3, 
	_po => 4, _pe => 5,
	_nv => 4, _v => 5,
	_lz => 4, _lo => 5, _p => 6, _m => 7,
	add => 0, adc => 1, sub => 2, sbc => 3, and => 4, xor => 5, or => 6, cp => 7,
	rlca => 0, rrca => 1, rla => 2, rra => 3,
	rlc => 0, rrc => 1, rl => 2, rr => 3, sla => 4, sra => 5, 
	sll => 6, sli => 6, swap => 6, 
	srl => 7, 
	bit => 1, res => 2, set => 3,
	ix => 0xDD, iy => 0xFD, 
	altd => 0x76, ioi => 0xD3, ioe => 0xDB,
);

sub inc_r { my($r) = @_; return 0x04 + $V{$r}*8; }
sub dec_r { my($r) = @_; return 0x05 + $V{$r}*8; }

# help decode instructions
my @DECODE;		# bytes per instruction

for my $r (qw( b c d e h l (hl) a )) { 
	$DECODE[inc_r($r)] = 1;
	$DECODE[dec_r($r)] = 1;
}

#------------------------------------------------------------------------------
# build %Opcodes
#------------------------------------------------------------------------------
for my $cpu (@CPUS) {
	my $rabbit	= ($cpu =~ /^r/);
	my $r3k		= ($cpu =~ /^r3k/);
	my $z80 	= ($cpu =~ /^z80/);
	my $z80n	= ($cpu =~ /^z80n/);
	my $z180 	= ($cpu =~ /^z180/);
	my $zilog	= ($cpu =~ /^z/);
	my $i8080	= ($cpu =~ /^8080/);
	my $i8085	= ($cpu =~ /^8085/);
	my $intel 	= ($cpu =~ /^80/);
	my $gameboy	= ($cpu =~ /^gbz80/);
	
	# add opcodes per group of Z80 operations
	# implement Intel opcodes for the 8080 in all CPUs to simplify porting of code
	
	# LD r, r / LD r, (hl) / LD (hl), r
	for my $d (qw(     b c d e h l (hl) a )) { 
		for my $s (qw( b c d e h l (hl) a )) {
			if ($d ne '(hl)' || $s ne '(hl)') {
				add_opc($cpu, "ld $d, $s", 0x40 + $V{$d}*8 + $V{$s});
			}
		}
	}
	for my $d (qw(     b c d e h l m a )) {
		for my $s (qw( b c d e h l m a )) {
			if ($d ne 'm' || $s ne 'm') {
				add_opc($cpu, "mov $d, $s",	0x40 + $V{$d}*8 + $V{$s});
			}
		}
	}
	
	# LD r, N
	for my $r (qw( b c d e h l (hl) a )) { 
		add_opc($cpu, "ld $r, %n", 0x06 + $V{$r}*8, '%n');
	}	
	for my $d (qw( b c d e h l m a )) {
		add_opc($cpu, "mvi $d, %n", 0x06 + $V{$d}*8, '%n');
	}

	# LD r, (NN) / ld (NN), r
	if ($gameboy) {
		add_opc($cpu, "ld (%m), a", 0xEA, '%m', '%m');
		add_opc($cpu, "sta %m",		0xEA, '%m', '%m');
		
		add_opc($cpu, "ld a, (%m)", 0xFA, '%m', '%m');
		add_opc($cpu, "lda %m",		0xFA, '%m', '%m');
	}
	else {
		add_opc($cpu, "ld (%m), a", 0x32, '%m', '%m');
		add_opc($cpu, "sta %m",		0x32, '%m', '%m');
		
		add_opc($cpu, "ld a, (%m)", 0x3A, '%m', '%m');
		add_opc($cpu, "lda %m",		0x3A, '%m', '%m');
	}

	# LD r, (dd) / ld (dd), r
	add_opc($cpu, "ld (bc), a", 0x02);
	add_opc($cpu, "stax bc",	0x02);
	add_opc($cpu, "stax b",		0x02);
	
	add_opc($cpu, "ld a, (bc)", 0x0A);
	add_opc($cpu, "ldax bc",	0x0A);
	add_opc($cpu, "ldax b",		0x0A);
	
	add_opc($cpu, "ld (de), a", 0x12);
	add_opc($cpu, "stax de",	0x12);
	add_opc($cpu, "stax d",		0x12);
	
	add_opc($cpu, "ld a, (de)", 0x1A);
	add_opc($cpu, "ldax de",	0x1A);
	add_opc($cpu, "ldax d",		0x1A);
	
	# LD r, (dd+-) / ld (dd+-), r
	add_opc($cpu, "ld (bc+), a", 0x02, 0x03);
	add_opc($cpu, "ldi (bc), a", 0x02, 0x03);

	add_opc($cpu, "ld (bc-), a", 0x02, 0x0B);
	add_opc($cpu, "ldd (bc), a", 0x02, 0x0B);

	add_opc($cpu, "ld a, (bc+)", 0x0A, 0x03);
	add_opc($cpu, "ldi a, (bc)", 0x0A, 0x03);
	
	add_opc($cpu, "ld a, (bc-)", 0x0A, 0x0B);
	add_opc($cpu, "ldd a, (bc)", 0x0A, 0x0B);
	
	add_opc($cpu, "ld (de+), a", 0x12, 0x13);
	add_opc($cpu, "ldi (de), a", 0x12, 0x13);
	
	add_opc($cpu, "ld (de-), a", 0x12, 0x1B);
	add_opc($cpu, "ldd (de), a", 0x12, 0x1B);
	
	add_opc($cpu, "ld a, (de+)", 0x1A, 0x13);
	add_opc($cpu, "ldi a, (de)", 0x1A, 0x13);

	add_opc($cpu, "ld a, (de-)", 0x1A, 0x1B);
	add_opc($cpu, "ldd a, (de)", 0x1A, 0x1B);

	if ($gameboy) {
		add_opc($cpu, "ld (hl+), a", 0x22);
		add_opc($cpu, "ldi (hl), a", 0x22);

		add_opc($cpu, "ld a, (hl+)", 0x2A);
		add_opc($cpu, "ldi a, (hl)", 0x2A);
		
		add_opc($cpu, "ld (hl-), a", 0x32);
		add_opc($cpu, "ldd (hl), a", 0x32);
		
		add_opc($cpu, "ld a, (hl-)", 0x3A);
		add_opc($cpu, "ldd a, (hl)", 0x3A);
	} 
	else {
		add_opc($cpu, "ld (hl+), a", 0x77, 0x23);
		add_opc($cpu, "ldi (hl), a", 0x77, 0x23);

		add_opc($cpu, "ld a, (hl+)", 0x7E, 0x23);
		add_opc($cpu, "ldi a, (hl)", 0x7E, 0x23);
		
		add_opc($cpu, "ld (hl-), a", 0x77, 0x2B);
		add_opc($cpu, "ldd (hl), a", 0x77, 0x2B);
		
		add_opc($cpu, "ld a, (hl-)", 0x7E, 0x2B);
		add_opc($cpu, "ldd a, (hl)", 0x7E, 0x2B);
	}
	
	# LD dd, NN
	for my $r (qw( bc de hl sp )) {
		my $alt_r = ($r eq 'sp') ? $r : substr($r,0,1);		# B, D, H

		add_opc($cpu, "ld $r, %m", 		0x01 + $V{$r}*16, '%m', '%m');
		add_opc($cpu, "lxi $r, %m",		0x01 + $V{$r}*16, '%m', '%m');
		add_opc($cpu, "lxi $alt_r, %m",	0x01 + $V{$r}*16, '%m', '%m');
		
		if ($r eq 'hl') {
			if (!$intel) {
				for my $x (qw( ix iy )) {
					add_opc($cpu, "ld $x, %m", $V{$x}, 0x01 + $V{$r}*16, '%m', '%m');
				}
			}
		}
	}
	
	# LD dd, (NN) / LD (NN), dd
	if (!$gameboy) {
		for my $r (qw( bc de hl sp )) {
			if ($r eq 'hl') {
				add_opc($cpu, "ld (%m), $r", 	0x22, '%m', '%m');
				add_opc($cpu, "shld %m",		0x22, '%m', '%m');

				add_opc($cpu, "ld $r, (%m)", 	0x2A, '%m', '%m');
				add_opc($cpu, "lhld %m",		0x2A, '%m', '%m');
				
				if (!$intel) {
					for my $x (qw( ix iy )) {
						add_opc($cpu, "ld $x, (%m)", $V{$x}, 0x2A, '%m', '%m');
						add_opc($cpu, "ld (%m), $x", $V{$x}, 0x22, '%m', '%m');
					}
				}
			}
			else {
				if (!$intel) {
					add_opc($cpu, "ld $r, (%m)", 0xED, 0x4B + $V{$r}*16, '%m', '%m');
					add_opc($cpu, "ld (%m), $r", 0xED, 0x43 + $V{$r}*16, '%m', '%m');
				}
			}
		}
	}
	
	# LD dd, dd
	add_opc($cpu, "ld bc, de", 0x42, 0x4B);
	add_opc($cpu, "ld bc, hl", 0x44, 0x4D);

	add_opc($cpu, "ld de, bc", 0x50, 0x59);
	
	if ($i8085) {
		# Add 00bb immediate to HL, result to DE (undocumented i8085)
		add_opc($cpu, "ldhi %n",		0x28, '%n');
		add_opc($cpu, "adi hl, %n",		0x28, '%n');
		add_opc($cpu, "ld de, hl+%u",	0x28, '%u');
	}
	else {	
		add_opc($cpu, "ld de, hl", 		0x54, 0x5D);
	}

	add_opc($cpu, "ld hl, bc", 0x60, 0x69);
	add_opc($cpu, "ld hl, de", 0x62, 0x6B);

	# EX DE, HL
	if ($gameboy) {
		add_opc($cpu, "ex de, hl",	0xE5, 0xD5, 0xE1, 0xD1);
	}
	else {
		add_opc($cpu, "ex de, hl",	0xEB);
		add_opc($cpu, "xchg",		0xEB);
		
		if ($rabbit) {
			add_opc($cpu, "ex de', hl", 0xE3);
			add_opc($cpu, "ex de, hl'", 0x76, 0xEB);
			add_opc($cpu, "ex de', hl'", 0x76, 0xE3);
			
			add_opc($cpu, "altd ex de, hl", 0x76, 0xEB);
			add_opc($cpu, "altd ex de', hl", 0x76, 0xE3);
		}
	}
	
	# 8-bit ALU group
	for my $op (qw( add adc sub sbc and xor or cp )) {
		for my $r (qw( b c d e h l (hl) a )) {
			for my $a ('a, ', '') {
				add_opc($cpu, "$op $a$r", 0x80 + $V{$op}*8 + $V{$r});
			}
		}
		for my $a ('a, ', '') {
			add_opc($cpu, "$op $a%n", 0xC6 + $V{$op}*8, '%n');
		}
	}

	for my $r (qw( b c d e h l m a )) {
		add_opc($cpu, "add $r",		0x80 + $V{$r});
		add_opc($cpu, "adc $r",		0x88 + $V{$r});
		add_opc($cpu, "sub $r",		0x90 + $V{$r});
		add_opc($cpu, "sbb $r",		0x98 + $V{$r});

		add_opc($cpu, "ana $r",		0xA0 + $V{$r});
		add_opc($cpu, "ora $r",		0xB0 + $V{$r});
		add_opc($cpu, "xra $r",		0xA8 + $V{$r});
		add_opc($cpu, "cmp $r",		0xB8 + $V{$r});
	}

	add_opc($cpu, "adi %n",			0xC6, '%n');
	add_opc($cpu, "aci %n",			0xCE, '%n');
	add_opc($cpu, "sui %n",			0xD6, '%n');
	add_opc($cpu, "sbi %n",			0xDE, '%n');
	
	add_opc($cpu, "ani %n",			0xE6, '%n');
	add_opc($cpu, "ori %n",			0xF6, '%n');
	add_opc($cpu, "xri %n",			0xEE, '%n');
	add_opc($cpu, "cpi %n",			0xFE, '%n');

	for my $r (qw( b c d e h l (hl) a )) { 
		add_opc($cpu, "inc $r", 	inc_r($r));
		add_opc($cpu, "dec $r", 	dec_r($r));
	}
	for my $r (qw( b c d e h l m a )) {
		add_opc($cpu, "inr $r",		inc_r($r));
		add_opc($cpu, "dcr $r",		dec_r($r));
	}
	
	for my $r (qw( b c d e h l (hl) a )) { 
		for my $op (qw( tst test )) {
			for my $a ('a, ', '') {
				if ($z180) {
					add_opc($cpu, "$op $a$r",  0xED, 0x04 + $V{$r}*8);
					add_opc($cpu, "$op $a%n",  0xED, 0x64, '%n');
				}
				elsif ($z80n) {
					add_opc($cpu, "$op $a%n",  0xED, 0x27, '%n');
				}
			}
		}
	}
	
	if ($intel || $zilog || $gameboy) {
		add_opc($cpu, "daa", 0x27);
	}
	else {
		add_opc($cpu, "daa", 0xCD, '@__z80asm__daa');
	}
	
	if ($zilog) {
		add_opc($cpu, "rrd", 0xED, 0x67);
		add_opc($cpu, "rld", 0xED, 0x6F);
	}
	elsif ($rabbit) {
		add_opc($cpu, "rrd", 0xCD, '@__z80asm__rrd');
		add_opc($cpu, "rld", 0xCD, '@__z80asm__rld');
	}
	
	# cpl
	add_opc($cpu, "cpl", 			0x2F);
	add_opc($cpu, "cma",			0x2F);
	add_opc($cpu, "cpl a", 			0x2F);
	if ($rabbit) {
		add_opc($cpu, "cpl a'", 	$V{altd}, 0x2F);
		add_opc($cpu, "altd cpl",	$V{altd}, 0x2F);
		add_opc($cpu, "altd cpl a",	$V{altd}, 0x2F);
	}
	
	add_opc($cpu, "neg", 		0xED, 0x44) if !$intel && !$gameboy;
	add_opc($cpu, "neg a", 		0xED, 0x44) if !$intel && !$gameboy;
	add_opc($cpu, "neg a'", 	$V{altd}, 0xED, 0x44) if $rabbit;
	add_opc($cpu, "altd neg",	$V{altd}, 0xED, 0x44) if $rabbit;
	add_opc($cpu, "altd neg a",	$V{altd}, 0xED, 0x44) if $rabbit;
	
	add_opc($cpu, "ccf", 		0x3F);
	add_opc($cpu, "cmc",		0x3F);
	add_opc($cpu, "ccf f", 		0x3F);
	
	add_opc($cpu, "ccf'", 		$V{altd}, 0x3F) if $rabbit;
	add_opc($cpu, "ccf f'", 	$V{altd}, 0x3F) if $rabbit;
	add_opc($cpu, "altd ccf",	$V{altd}, 0x3F) if $rabbit;
	add_opc($cpu, "altd ccf f",	$V{altd}, 0x3F) if $rabbit;
	
	add_opc($cpu, "scf", 		0x37);
	add_opc($cpu, "stc",		0x37);
	add_opc($cpu, "scf f", 		0x37);

	add_opc($cpu, "scf'", 		$V{altd}, 0x37) if $rabbit;
	add_opc($cpu, "scf f'", 	$V{altd}, 0x37) if $rabbit;
	add_opc($cpu, "altd scf",	$V{altd}, 0x37) if $rabbit;
	add_opc($cpu, "altd scf f",	$V{altd}, 0x37) if $rabbit;
	
	
	# 16-bit load group
	add_opc($cpu, "ld sp, hl", 		0xF9);
	add_opc($cpu, "sphl",			0xF9) if !$gameboy;

	if (!$intel && !$gameboy) {
		for my $x (qw( ix iy )) {
			add_opc($cpu, "ld sp, $x", $V{$x}, 0xF9);
		}
	}
	
	if ($gameboy) {
		add_opc($cpu, "add sp, %s", 0xE8, '%s');
		
		add_opc($cpu, "ld hl, sp+%s", 	0xF8, '%s');
		add_opc($cpu, "ldhl sp, %s", 	0xF8, '%s');
		
		add_opc($cpu, "ld (%m), sp", 0x08, '%m', '%m');
	}

	for my $r (qw( bc de hl af )) {
		my $alt_r = ($r eq 'af') ? 'psw' : substr($r,0,1);		# B, D, H, PSW

		add_opc($cpu, "push $r",		0xC5 + $V{$r}*16);
		add_opc($cpu, "push $alt_r",	0xC5 + $V{$r}*16);

		add_opc($cpu, "pop $r",			0xC1 + $V{$r}*16);
		add_opc($cpu, "pop $alt_r",		0xC1 + $V{$r}*16);
		
		if (!$intel && !$gameboy) {
			if ($r eq 'hl') {
				for my $x (qw( ix iy )) {
					add_opc($cpu, "push $x", $V{$x}, 0xC5 + $V{$r}*16);
					add_opc($cpu, "pop $x", $V{$x}, 0xC1 + $V{$r}*16);
				}
			}
		}
	}
	
	if ($rabbit) {
		add_opc($cpu, "push ip", 0xED, 0x76);
		add_opc($cpu, "pop ip", 0xED, 0x7E);
	}
	
	if ($r3k) {
		add_opc($cpu, "push su", 0xED, 0x66) if $r3k;
		add_opc($cpu, "pop su", 0xED, 0x6E) if $r3k;
	}
	
	if ($rabbit) {
		for my $x (qw( ix iy )) {
			add_opc($cpu, "ld hl, $x", $V{$x}, 0x7C);
			add_opc($cpu, "ld $x, hl", $V{$x}, 0x7D);
		}
		
		for ([hl => 0xDD], [ix => ()], [iy => 0xFD]) {
			my($r, @pfx) = @$_;
		
			add_opc($cpu, "ld hl, ($r+%d)", @pfx, 0xE4, '%d');
			add_opc($cpu, "ld ($r+%d), hl", @pfx, 0xF4, '%d');
		}
			
		for ([hl => ()], [ix => 0xDD], [iy => 0xFD]) {
			my($r, @pfx) = @$_;
		
			add_opc($cpu, "ld (sp+%u), $r", @pfx, 0xD4, '%u');
			add_opc($cpu, "ld $r, (sp+%u)", @pfx, 0xC4, '%u');
		}
		
		for my $r (qw(bc de hl)) {
			for my $s (qw(bc de)) {
				add_opc($cpu, "ld $r', $s", 	0xED, 0x41 + $V{$r}*16 + (1-$V{$s})*8);
				add_opc($cpu, "altd ld $r, $s", 0xED, 0x41 + $V{$r}*16 + (1-$V{$s})*8);
			}
		}
		
		for ([hl => 0xED], [ix => 0xDD], [iy => 0xFD]) {
			my($r, $pfx) = @$_;
			
			add_opc($cpu, "ldp (%m), $r", $pfx, 0x65, '%m', '%m');
			add_opc($cpu, "ldp $r, (%m)", $pfx, 0x6D, '%m', '%m');
			add_opc($cpu, "ldp ($r), hl", $pfx, 0x64);
			add_opc($cpu, "ldp hl, ($r)", $pfx, 0x6C);
		}
	}
	
	# exchange group
	add_opc($cpu, "ex af, af'", 0x08) if !$intel && !$gameboy;
	add_opc($cpu, "ex af, af",  0x08) if !$intel && !$gameboy;
	
	add_opc($cpu, "exx",  0xD9) if !$intel && !$gameboy;
	
	if ($zilog || $intel) {
		add_opc($cpu, "ex (sp), hl", 	0xE3);
		add_opc($cpu, "xthl",			0xE3) if !$gameboy;
	}
	elsif ($rabbit) {
		add_opc($cpu, "ex (sp), hl", 0xED, 0x54);
		add_opc($cpu, "ex (sp), hl'", $V{altd}, 0xED, 0x54);
		add_opc($cpu, "altd ex (sp), hl", $V{altd}, 0xED, 0x54);
	}
	else {
		add_opc($cpu, "ex (sp), hl", 0xCD, '@__z80asm__ex_sp_hl');
	}
	
	if (!$intel && !$gameboy) {
		for my $x (qw( ix iy )) {
			add_opc($cpu, "ex (sp), $x", $V{$x}, 0xE3);
		}
	}
	
	# 16-bit ALU group
	for my $r (qw( bc de hl sp )) {
		my $alt_r = ($r eq 'sp') ? $r : substr($r,0,1);		# B, D, H
		
		add_opc($cpu, "add hl, $r", 0x09 + $V{$r}*16);
		add_opc($cpu, "dad $r",		0x09 + $V{$r}*16);
		add_opc($cpu, "dad $alt_r",	0x09 + $V{$r}*16);
		
		if ($intel || $gameboy) {
			if ($r ne 'sp') {
				add_opc($cpu, "adc hl, $r",	0xCD, '@__z80asm__adc_hl_'.$r);
			}
		}
		else {
			add_opc($cpu, "adc hl, $r", 	0xED, 0x4A + $V{$r}*16);
		}		
	}	
	
	for my $r (qw( bc de hl sp )) {
		add_opc($cpu, "sbc hl, $r", 0xED, 0x42 + $V{$r}*16) if !$intel && !$gameboy;
		add_opc($cpu, "adc hl, $r", 0xED, 0x4A + $V{$r}*16) if !$intel && !$gameboy;
		
		add_opc($cpu, "inc $r", 0x03 + $V{$r}*16);
		add_opc($cpu, "dec $r", 0x0B + $V{$r}*16);
	}

	for my $r (qw( bc de hl sp )) {
		my $alt_r = ($r eq 'sp') ? $r : substr($r,0,1);		# B, D, H
		add_opc($cpu, "inx $r",		0x03 + $V{$r}*16);
		add_opc($cpu, "inx $alt_r",	0x03 + $V{$r}*16);
		add_opc($cpu, "dcx $r",		0x0B + $V{$r}*16);
		add_opc($cpu, "dcx $alt_r",	0x0B + $V{$r}*16);
	}

	if (!$intel && !$gameboy) {
		for my $x (qw( ix iy )) {
			for my $r (qw( bc de hl sp )) {
				add_opc($cpu, "add $x, ".replace($r, qr/hl/, $x), $V{$x}, 0x09 + $V{$r}*16);
			}
			add_opc($cpu, "inc $x", $V{$x}, 0x03 + 2*16);
			add_opc($cpu, "dec $x", $V{$x}, 0x0B + 2*16);
		}
	}
	
	if ($rabbit) {
		add_opc($cpu, "add sp, %s", 0x27, '%s');
		
		for ([hl => ()], [ix => 0xDD], [iy => 0xFD]) {
			my($r, @pfx) = @$_;
			
			add_opc($cpu, "and $r, de", @pfx, 0xDC);
			add_opc($cpu, "or $r, de", @pfx, 0xEC);
			add_opc($cpu, "bool $r", @pfx, 0xCC);
		}
	}
	
	# Multiply
	if ($z180) {
		for my $r (qw( bc de hl sp )) {
			add_opc($cpu, "mlt $r", 0xED, 0x4C + $V{$r}*16);
		}
	}
	elsif ($z80n) {
		add_opc($cpu, "mul d, e", 0xED, 0x30);
		add_opc($cpu, "mul de",   0xED, 0x30);
		add_opc($cpu, "mlt de",   0xED, 0x30);
	}
	elsif ($rabbit) {
		add_opc($cpu, "mul", 0xF7);
	}
	else {}
	
	if ($r3k) {
		add_opc($cpu, "uma", 0xED, 0xC0);
		add_opc($cpu, "ums", 0xED, 0xC8);
	}
	
	# 8-bit rotate and shift group
	for my $op (qw( rlca rrca rla rra )) {
		add_opc($cpu, $op, 0x07 + $V{$op}*8);
	}

	add_opc($cpu, "rlc",	0x07);
	add_opc($cpu, "rrc",	0x0F);
	add_opc($cpu, "ral",	0x17);
	add_opc($cpu, "rar",	0x1F);
	
	if (!$intel) {
		for (qw( rlc rrc rl rr sla sra sll sli srl )) {
			my $op = (/sll|sli/ && $gameboy) ? 'swap' : $_;
			next if $op =~ /sll|sli/ && !$zilog;

			for my $r (qw( b c d e h l (hl) a )) {
				add_opc($cpu, "$op $r", 0xCB, $V{$op}*8 + $V{$r});
			}
		}
	}
	
	if ($z80) {
		for my $op (qw( rlc rrc rl rr sla sra sll sli srl )) {
			for my $x (qw( ix iy )) {
				for my $r (qw( b c d e h l a )) {
					add_opc($cpu, "$op ($x+%d), $r", $V{$x}, 0xCB, '%d', $V{$op}*8 + $V{$r});
				}
			}
		}			
	}
	
	# bit set, reset and test group
	if (!$intel) {
		for my $op (qw( bit res set )) {
			for my $r (qw( b c d e h l (hl) a )) {
				add_opc($cpu, "$op %c, $r", 0xCB, ($V{$op}*0x40 + $V{$r})."+8*%c(0..7)");
			}
		}
	}
	
	# 16-bit rotate and shift group
	if ($rabbit) {
		add_opc($cpu, "rl de", 0xF3);
		add_opc($cpu, "rr de", 0xFB);
		for ([hl => ()], [ix => 0xDD], [iy => 0xFD]) {
			my($x, @pfx) = @$_;
			add_opc($cpu, "rr $x", @pfx, 0xFC);
		}
	}
	
	# CPU control group
	add_opc($cpu, "nop", 0x00);
	
	if (!$rabbit) {
		add_opc($cpu, "halt",	0x76);
		add_opc($cpu, "hlt",	0x76);
	}
	
	add_opc($cpu, "slp", 	0xED, 0x76) if $z180;
	add_opc($cpu, "stop", 	0x10, 0x00) if $gameboy;
	
	if ($r3k) {
		add_opc($cpu, "rdmode", 0xED, 0x7F);
		add_opc($cpu, "setusr", 0xED, 0x6F);
		add_opc($cpu, "sures", 0xED, 0x7D);
		add_opc($cpu, "syscall", 0xED, 0x75);
	}
	
	# Interrupt control group
	if (!$rabbit) {
		add_opc($cpu, "di", 0xF3);
		add_opc($cpu, "ei", 0xFB);
	}
	
	if ($zilog) {
		add_opc($cpu, "im %c", 0xED, "%c(0..2)==0?0x46:%c==1?0x56:0x5E");

		add_opc($cpu, "ld i, a", 0xED, 0x47);
		add_opc($cpu, "ld a, i", 0xED, 0x57);
		add_opc($cpu, "ld r, a", 0xED, 0x4F);
		add_opc($cpu, "ld a, r", 0xED, 0x5F);
	}

	add_opc($cpu, "rim", 0x20) if $i8085;
	add_opc($cpu, "sim", 0x30) if $i8085;

	if ($intel) {
		add_opc($cpu, "di", 0xF3);
		add_opc($cpu, "ei", 0xFB);
	}
	
	if ($rabbit) {
		add_opc($cpu, "ld eir, a", 0xED, 0x47);
		add_opc($cpu, "ld a, eir", 0xED, 0x57);
		add_opc($cpu, "ld iir, a", 0xED, 0x4F);
		add_opc($cpu, "ld a, iir", 0xED, 0x5F);
	
		add_opc($cpu, "ipset %c", 0xED, "%c(0..3)==0?0x46:%c==1?0x56:%c==2?0x4E:0x5E");
		add_opc($cpu, "ipres", 0xED, 0x5D);
	}

	if ($intel) {
	}
	elsif ($gameboy) {
		add_opc($cpu, "reti", 0xD9);
	}
	else {
		add_opc($cpu, "reti", 0xED, 0x4D);
	}
	
	add_opc($cpu, "retn", 0xED, 0x45) if $zilog;
	add_opc($cpu, "idet", 0x5B) if $r3k;
	
	# Jump and Call group
	if ( $intel ) {
		add_opc($cpu, "jr %m", 	0xC3, '%m', '%m');
	} 
	else {
		add_opc($cpu, "jr %j", 	0x18, '%j');
	}
	
	add_opc($cpu, "jp %m", 		0xC3, '%m', '%m');
	add_opc($cpu, "jmp %m",		0xC3, '%m', '%m');

	add_opc($cpu, "call %m", 	0xCD, '%m', '%m');
	add_opc($cpu, "ret", 		0xC9);

	# TODO: check that address is corretly computed in DJNZ B', LABEL - 76 10 FE or 76 10 FD
	if ($intel) {
		# Emulate with "DEB B / JP NZ, nn" on 8080/8085
		add_opc($cpu, "djnz %m", 	dec_r('b'), 0xC2, '%m', '%m') ;
		add_opc($cpu, "djnz b, %m", dec_r('b'), 0xC2, '%m', '%m');
	} 
	elsif ($gameboy) {
		# Emulate with "DEB B / NR NZ, nn" on 8080/8085
		add_opc($cpu, "djnz %j", 	dec_r('b'), 0x20, '%j') ;
		add_opc($cpu, "djnz b, %j", dec_r('b'), 0x20, '%j');
	} 
	else {
		add_opc($cpu, "djnz %j", 	0x10, '%j');
		add_opc($cpu, "djnz b, %j", 0x10, '%j');
	}
	
	for my $_f (qw( _nz _z _nc _c _po _pe _nv _v _lz _lo _p _m )) {
		my $f = substr($_f, 1);					# remove leading _
		my $_inv_f = $INV_FLAG{$_f};			# inverted flag
		my $inv_f = substr($_inv_f, 1);			# remove leading _
		
		if ($f =~ /^(nz|z|nc|c)$/) {
			if ($intel) {
				add_opc($cpu, "jr $f, %m", 0xC2 + $V{$_f}*8, '%m', '%m');
			} 
			else {
				add_opc($cpu, "jr $f, %j", 0x20 + $V{$_f}*8, '%j');
			}
		}
	
		if ($rabbit) {
			add_opc($cpu, "jp $f, %m", 	0xC2 + $V{$_f}*8, '%m', '%m');
			add_opc($cpu, "j$f %m", 	0xC2 + $V{$_f}*8, '%m', '%m') unless $f eq 'p';
			add_opc($cpu, "j_$f %m", 	0xC2 + $V{$_f}*8, '%m', '%m');
		
			# TODO: LCALL not supported
			if ($f =~ /^(nz|z|nc|c)$/) {
				add_opc($cpu, "call $f, %m", 
								0x20 + $V{$_inv_f}*8, 3,			# jump !flag
								0xCD, '%m', '%m');					# call 
			}
			else {
				add_opc($cpu, "call $f, %m", 
								0xC2 + $V{$_inv_f}*8, '%t', '%t',	# jump !flag, label
								0xCD, '%m', '%m');					# call 
			}			

			add_opc($cpu, "ret $f", 	0xC0 + $V{$_f}*8);
			add_opc($cpu, "r$f",	 	0xC0 + $V{$_f}*8);
			add_opc($cpu, "r_$f",	 	0xC0 + $V{$_f}*8);			
		}
		else {
			next if ($f =~ /lz|lo/);
			next if ($f !~ /^(nz|z|nc|c)$/ && $gameboy);

			add_opc($cpu, "jp $f, %m", 	0xC2 + $V{$_f}*8, '%m', '%m');
			add_opc($cpu, "j$f %m", 	0xC2 + $V{$_f}*8, '%m', '%m') unless $f eq 'p';
			add_opc($cpu, "j_$f %m", 	0xC2 + $V{$_f}*8, '%m', '%m');
			
			add_opc($cpu, "call $f, %m",0xC4 + $V{$_f}*8, '%m', '%m');
			add_opc($cpu, "c$f %m", 	0xC4 + $V{$_f}*8, '%m', '%m') unless $f eq 'p';
			add_opc($cpu, "c_$f %m",	0xC4 + $V{$_f}*8, '%m', '%m');

			add_opc($cpu, "ret $f", 	0xC0 + $V{$_f}*8);
			add_opc($cpu, "r$f",	 	0xC0 + $V{$_f}*8);
			add_opc($cpu, "r_$f",	 	0xC0 + $V{$_f}*8);			
		}
	}

	add_opc($cpu, "rst %c", "0xC7+%c");

	for ([hl => ()]) {
		my($x, @pfx) = @$_;
		add_opc($cpu, "jp ($x)", @pfx, 0xE9);
		add_opc($cpu, "pchl",		   0xE9);
	}
	
	if (!$intel && !$gameboy) {
		for ([ix => 0xDD], [iy => 0xFD]) {
			my($x, @pfx) = @$_;
			add_opc($cpu, "jp ($x)", @pfx, 0xE9);
		}
	} 

	if ($rabbit) {
		# TODO: LJP not supported
		add_opc($cpu, "ld xpc, a", 0xED, 0x67);
		add_opc($cpu, "ld a, xpc", 0xED, 0x77);
	}
	
	# Block transfer group
	if ($intel || $gameboy) {
		add_opc($cpu, "ldi", 	0xCD, '@__z80asm__ldi');
		add_opc($cpu, "ldir", 	0xCD, '@__z80asm__ldir');
		add_opc($cpu, "ldd", 	0xCD, '@__z80asm__ldd');
		add_opc($cpu, "lddr", 	0xCD, '@__z80asm__lddr');
	} 
	else {
		add_opc($cpu, "ldi", 	0xED, 0xA0);
		add_opc($cpu, "ldir", 	0xED, 0xB0);
		add_opc($cpu, "ldd", 	0xED, 0xA8);
		add_opc($cpu, "lddr", 	0xED, 0xB8);
	}

	if ($r3k) {
		add_opc($cpu, "ldisr", 	0xED, 0x90);
		add_opc($cpu, "lddsr", 	0xED, 0x98);
		
		add_opc($cpu, "lsdr", 	0xED, 0xF8);
		add_opc($cpu, "lsir", 	0xED, 0xF0);
		add_opc($cpu, "lsddr", 	0xED, 0xD8);
		add_opc($cpu, "lsidr", 	0xED, 0xD0);
	}

	# Search group
	if ($zilog) {
		add_opc($cpu, "cpi", 	0xED, 0xA1);
		add_opc($cpu, "cpir", 	0xED, 0xB1);
		add_opc($cpu, "cpd", 	0xED, 0xA9);
		add_opc($cpu, "cpdr", 	0xED, 0xB9);
	}
	elsif ($gameboy) {
	}
	else {
		add_opc($cpu, "cpi", 	0xCD, '@__z80asm__cpi');
		add_opc($cpu, "cpir", 	0xCD, '@__z80asm__cpir');
		add_opc($cpu, "cpd", 	0xCD, '@__z80asm__cpd');
		add_opc($cpu, "cpdr", 	0xCD, '@__z80asm__cpdr');
	}

	# Input and Output Group
	if ($intel) {
		add_opc($cpu, "in a, (%n)", 		0xDB, '%n');
		add_opc($cpu, "out (%n), a", 		0xD3, '%n');
	}		
	elsif ($zilog) {
		add_opc($cpu, "in a, (%n)", 		0xDB, '%n');
		add_opc($cpu, "in (c)", 			0xED, 0x40 + $V{f}*8);
		add_opc($cpu, "in0 (%n)", 			0xED, 0x00 + $V{f}*8, '%n') if $z180;
		for my $r (qw( b c d e h l f a )) {
			add_opc($cpu, "in $r, (c)", 	0xED, 0x40 + $V{$r}*8);
			add_opc($cpu, "in0 $r, (%n)", 	0xED, 0x00 + $V{$r}*8, '%n') if $z180;
		}
		
		add_opc($cpu, "out (%n), a", 		0xD3, '%n');
		add_opc($cpu, "out (c), %c", 		0xED, '0x41+%c(0)+6*8');

		for my $r (qw( b c d e h l a )) {
			add_opc($cpu, "out (c), $r", 	0xED, 0x41 + $V{$r}*8);
			add_opc($cpu, "out0 (%n), $r", 	0xED, 0x01 + $V{$r}*8, '%n') if $z180;
		}
		
		add_opc($cpu, "tstio %n", 			0xED, 0x74, '%n') if $z180;

		add_opc($cpu, "ini", 	0xED, 0xA2);
		add_opc($cpu, "inir", 	0xED, 0xB2);
		add_opc($cpu, "ind", 	0xED, 0xAA);
		add_opc($cpu, "indr", 	0xED, 0xBA);

		add_opc($cpu, "outi", 	0xED, 0xA3);
		add_opc($cpu, "otir", 	0xED, 0xB3);
		add_opc($cpu, "outd", 	0xED, 0xAB);
		add_opc($cpu, "otdr", 	0xED, 0xBB);

		if ($z180) {
			add_opc($cpu, "otdm", 	0xED, 0x8B);
			add_opc($cpu, "otdmr", 	0xED, 0x9B);
			add_opc($cpu, "otim", 	0xED, 0x83);
			add_opc($cpu, "otimr", 	0xED, 0x93);
		}
	}
	elsif ($gameboy) {
		add_opc($cpu, "ldh (%n), a", 0xE0, '%n');
		add_opc($cpu, "ldh a, (%n)", 0xF0, '%n');
	
		add_opc($cpu, "ld (c), a", 0xE2);
		add_opc($cpu, "ldh (c), a", 0xE2);
		
		add_opc($cpu, "ld a, (c)", 0xF2);
		add_opc($cpu, "ldh a, (c)", 0xF2);
	}
	else {
	}

	add_opc($cpu, "in %n",			0xDB, '%n') if !$rabbit && !$gameboy;
	add_opc($cpu, "out %n",			0xD3, '%n') if !$rabbit && !$gameboy;

	
	# Z80N opcodes for ZX Next
	if ($z80n) {
		add_opc($cpu, "swapnib", 		0xED, 0x23);
		add_opc($cpu, "mirror a", 		0xED, 0x24);
		add_opc($cpu, "bsla de,b",		0xED, 0x28);
		add_opc($cpu, "bsra de,b",		0xED, 0x29);
		add_opc($cpu, "bsrl de,b",		0xED, 0x2A);
		add_opc($cpu, "bsrf de,b",		0xED, 0x2B);
		add_opc($cpu, "brlc de,b",		0xED, 0x2C);
		
#		add_opc($cpu, "mirror de", 		0xED, 0x26);
		
		add_opc($cpu, "add hl, a",		0xED, 0x31);
		add_opc($cpu, "add de, a",		0xED, 0x32);
		add_opc($cpu, "add bc, a",		0xED, 0x33);
		
		add_opc($cpu, "add hl, %m",		0xED, 0x34, '%m', '%m');
		add_opc($cpu, "add de, %m",		0xED, 0x35, '%m', '%m');
		add_opc($cpu, "add bc, %m",		0xED, 0x36, '%m', '%m');
		
		add_opc($cpu, "push %M",	 	0xED, 0x8A, '%M', '%M');
#		add_opc($cpu, "pop x",		 	0xED, 0x8B);

		add_opc($cpu, "outinb",			0xED, 0x90);

		add_opc($cpu, "mmu %c, %n",		0xED, 0x91, '0x50+%c(0..7)', '%n');
		for my $page (0..7) {
			add_opc($cpu, "mmu$page %n",0xED, 0x91, 0x50+$page, '%n');
		}

		add_opc($cpu, "mmu %c, a",		0xED, 0x92, '0x50+%c(0..7)');
		for my $page (0..7) {
			add_opc($cpu, "mmu$page a",	0xED, 0x92, 0x50+$page);
		}

		add_opc($cpu, "nextreg %n, %n",	0xED, 0x91, '%n', '%n');
		add_opc($cpu, "nextreg %n, a",	0xED, 0x92, '%n');
		
		add_opc($cpu, "pixeldn",		0xED, 0x93);
		add_opc($cpu, "pixelad",		0xED, 0x94);
		add_opc($cpu, "setae",			0xED, 0x95);

		add_opc($cpu, "jp (c)",			0xED, 0x98);

		add_opc($cpu, "ldix",			0xED, 0xA4);
		add_opc($cpu, "ldws",			0xED, 0xA5);
		add_opc($cpu, "lddx",			0xED, 0xAC);
		add_opc($cpu, "ldirx",			0xED, 0xB4);
		add_opc($cpu, "ldpirx",			0xED, 0xB7);
		add_opc($cpu, "lddrx",			0xED, 0xBC);
	}
		
	# undocumented 8085 instructions
	if ($i8085) {
		# double subtract
		add_opc($cpu, "dsub",			0x08);
		add_opc($cpu, "sub hl, bc",		0x08);
		
		# Rotate HL right
		add_opc($cpu, "arhl",			0x10);
		add_opc($cpu, "rrhl",			0x10);
		add_opc($cpu, "sra hl",			0x10);
		
		# Rotate DE left
		add_opc($cpu, "rdel",			0x18);
		add_opc($cpu, "rlde",			0x18);
		add_opc($cpu, "rl de",			0x18);

		# Add 00bb immediate to SP, result to DE
		add_opc($cpu, "ldsi %n",		0x38, '%n');
		add_opc($cpu, "adi sp, %n",		0x38, '%n');
		add_opc($cpu, "ld de, sp+%u",	0x38, '%u');
	
		# Store HL at address pointed by DE
		add_opc($cpu, "shlx",			0xD9);
		add_opc($cpu, "shlde",			0xD9);
		add_opc($cpu, "ld (de), hl",	0xD9);
		
		# Load HL from address pointed by DE
		add_opc($cpu, "lhlx",			0xED);
		add_opc($cpu, "lhlde",			0xED);
		add_opc($cpu, "ld hl, (de)",	0xED);

		# Restart 8 (0040) if V flag is set
		add_opc($cpu, "rstv",			0xCB);
		add_opc($cpu, "ovrst8",			0xCB);

		# Jump on flag X5/K is set
		add_opc($cpu, "jx5 %m",			0xFD, '%m', '%m');
		add_opc($cpu, "j_x5 %m",		0xFD, '%m', '%m');
		add_opc($cpu, "jk %m",			0xFD, '%m', '%m');
		add_opc($cpu, "j_k %m",			0xFD, '%m', '%m');

		add_opc($cpu, "jnx5 %m",		0xDD, '%m', '%m');
		add_opc($cpu, "j_nx5 %m",		0xDD, '%m', '%m');
		add_opc($cpu, "jnk %m",			0xDD, '%m', '%m');
		add_opc($cpu, "j_nk %m",		0xDD, '%m', '%m');
	}
}


#------------------------------------------------------------------------------
# build cpu tables
#------------------------------------------------------------------------------

# get column numbers for cpus
my %cpu_column;
my $column;
for my $cpu (sort @CPUS) {
	$cpu_column{$cpu} = ++$column;
}

# build table with assembly  per cpu
my %by_opcode;

my @title = (\"|", "", \"|");
for (sort @CPUS) { push @title, $_, \"|"; }
my $tb = Text::Table->new(@title);
for my $asm (sort keys %Opcodes) {
	my @c_range = (1);
	if ($asm =~ /rst %c/) {		# special case
		@c_range = map {$_ * 8} (0..7);
	} elsif ($asm =~ /%c/) {	# has %c in $asm and %c(1..7) in $bin
		my $cpu = (keys %{$Opcodes{$asm}})[0];
		my $bin = (grep {/%c/} @{$Opcodes{$asm}{$cpu}})[0];
		$bin =~ / %c \( (\d+) (?: \.\. (\d+) )? \) /x or die "$bin";
		if ($2) {
			@c_range = ($1 .. $2);
		} else {
			@c_range = ($1);
		}
	}
	for my $c (@c_range) {
		(my $asm1 = $asm) =~ s/%c/$c/;
		my @row = ($asm1, ("") x scalar(@CPUS));
		for my $cpu (keys %{$Opcodes{$asm}}) {
			$column = $cpu_column{$cpu};
			my @bin = @{$Opcodes{$asm}{$cpu}};
			for (@bin) { 
				if (s/ %c (?: \( \d+ (?: \.\. \d+ )? \) )? /$c/gx) {
					$_ = eval($_);
					$@ and die "$asm: eval error: $@";
				}
				s/\@__z80asm__/\@/;
			}
			if ($asm =~ /^rst / && $cpu =~ /^r/ && ($c == 0 || $c == 0x08 || $c == 0x30)) {
				@bin = (0xCD, $c, 0);
			}
			my $bin = fmthex(@bin);
			
			# save for later
			$by_opcode{$bin}{$cpu} .= "\n" if $by_opcode{$bin}{$cpu};
			$by_opcode{$bin}{$cpu} .= $asm1;
			
			@bin = split(' ', $bin);
			$row[$column] = "";
			while (@bin) {
				my @row_bin = splice(@bin, 0, 4);
				$row[$column] .= "\n" if $row[$column];
				$row[$column] .= "@row_bin";
			}
		}
		$tb->add(span_cells(@row));
		#say "@row";
	}
}

(my $asm_file = $0) =~ s/\.pl$/_asm.txt/i;
write_table($tb, $asm_file);

# build table with opcodes per CPU
$tb = Text::Table->new(@title);
for my $opcode (sort keys %by_opcode) {
	my @row = ($opcode, ("") x scalar(@CPUS));
	for my $cpu (keys %{$by_opcode{$opcode}}) {
		$column = $cpu_column{$cpu};
		$row[$column] = $by_opcode{$opcode}{$cpu};
	}
	$tb->add(span_cells(@row));
	#say "@row";
}

(my $opcode_file = $0) =~ s/\.pl$/_opcodes.txt/i;
write_table($tb, $opcode_file);

#------------------------------------------------------------------------------
# build %Parser
#------------------------------------------------------------------------------
for my $asm (sort keys %Opcodes) {
	my $tokens = parser_tokens($asm);
	
	# asm for swap_ix_iy
	(my $asm_swap = $asm) =~ s/\b(ix|iy)/ $1 eq 'ix' ? 'iy' : 'ix' /ge;
	
	# check for parens
	my $parens;
	if    ($asm =~ /\(%[nm]\)/) {		$parens = 'expr_in_parens'; }
	elsif ($asm =~ /%[snmjc]/) {		$parens = 'expr_no_parens'; }
	else {								$parens = 'no_expr';   }
		
	for my $cpu (sort keys %{$Opcodes{$asm}}) {
		my @bin = @{$Opcodes{$asm}{$cpu}};
		my @bin_swap = @{$Opcodes{$asm_swap}{$cpu}};
		
		$Parser{$tokens}{$cpu}{$parens}{ixiy} = [$asm, @bin];
		$Parser{$tokens}{$cpu}{$parens}{iyix} = [$asm_swap, @bin_swap];
	}
}

open(my $rules, ">:raw", "dev/cpu/cpu_rules.h") or die $!;
for my $tokens (sort keys %Parser) {
	print $rules $tokens, ' @{', "\n";
	print $rules merge_cpu($Parser{$tokens});
	print $rules '}', "\n\n";
}

#------------------------------------------------------------------------------
# build %Tests
#------------------------------------------------------------------------------
for my $asm (sort keys %Opcodes) {
	for my $cpu (sort keys %{$Opcodes{$asm}}) {
		my $bin = join(' ', @{$Opcodes{$asm}{$cpu}});
		
		add_tests($cpu, $asm, $bin);
	}
}

# open tests files
my %fh;
my %pc;
for my $cpu (@CPUS) {
	for my $ixiy ('', '_ixiy') {
		for my $ok ('ok', 'err') {
			next if $ixiy && $ok eq 'err';
			
			my $filename = "dev/cpu/cpu_test_${cpu}${ixiy}_${ok}.asm";
			open($fh{$cpu}{$ixiy}{$ok}, ">:raw", $filename ) or die "$filename: $!";
		}
	}
}

for my $asm (sort keys %Tests) {
	my $asmf = sprintf(" %-31s", $asm);
	for my $cpu (@CPUS) {
		if (exists $Tests{$asm}{$cpu}) {
			for my $ixiy ('', '_ixiy') {
				my $asm1 = $asm;
				if ($ixiy) {
					$asm1 =~ s/\b(ix|iy)/ $1 eq 'ix' ? 'iy' : 'ix' /ge;
				}
				my $bin1 = $Tests{$asm1}{$cpu};
				
				# build jumps to %t
				my $next = ($pc{$cpu}{$ixiy}{ok} || 0) + scalar(split(' ', $bin1));
				$bin1 =~ s/%t %t/ ($next & 0xFF)." ".(($next >> 8) & 0xFF) /e;
				$bin1 =~ s/%t/3/;
				my @bin = split(' ', $bin1);
			
				$fh{$cpu}{$ixiy}{ok}->print($asmf."; ".fmthex(@bin)."\n");
				$pc{$cpu}{$ixiy}{ok} = $next;
			}
		}
		else {
			# special case: 'djnz ASMPC' is translated to 'djnz NN' in 8080/8085
			my $skip = 0;
			if ($asm =~ /jr|djnz/) {
				if ($cpu =~ /^80/) {
					$skip = 1 if $asm =~ /ASMPC/;	# DIS
				}
				else {
					$skip = 1 if $asm =~ /\d+/;		# nn
				}
			}
			$fh{$cpu}{''}{err}->print($asmf."; Error\n") unless $skip;
		}
	}
	if (exists $Tests{$asm}{''}) {
		for my $cpu (@CPUS) {
			$fh{$cpu}{''}{err}->print($asmf."; Error\n");
		}
	}
}


#------------------------------------------------------------------------------
# Opcodes
#------------------------------------------------------------------------------
sub add_opc {
	my($cpu, $asm, @bin) = @_;

	add_opc_1($cpu, $asm, @bin);
	
	# expand ixh, ixl, ...
	if ($cpu =~ /^z80/ && $asm =~ /\b[hl]\b/ && $asm !~ /\b(hl|ix|iy|in|out|dad)\b/) {
		(my $asm1 = $asm) =~ s/\b([hl])\b/ix$1/g;
		add_opc_1($cpu, $asm1, $V{ix}, @bin);
		(   $asm1 = $asm) =~ s/\b([hl])\b/iy$1/g;
		add_opc_1($cpu, $asm1, $V{iy}, @bin);
	}
}

sub add_opc_1 {
	my($cpu, $asm, @bin) = @_;

	add_opc_2($cpu, $asm, @bin);
	
	# expand (ix+%d)
	return if $asm =~ /^(ldp|jp)/;
	
	if ($asm =~ /\(hl\)/ && $asm !~ /^(ldd|ldi)/ && 
	    $cpu !~ /^80/ && $cpu !~ /^gbz80/) {
		(my $asm1 = $asm) =~ s/\(hl\)/(ix+%d)/g;
		add_opc_2($cpu, $asm1, $V{ix}, $bin[0], '%d', @bin[1..$#bin]);
		(   $asm1 = $asm) =~ s/\(hl\)/(iy+%d)/g;
		add_opc_2($cpu, $asm1, $V{iy}, $bin[0], '%d', @bin[1..$#bin]);
	}
}

sub add_opc_2 {
	my($cpu, $asm, @bin) = @_;

	# (ix+%d) -> (ix)
	if ($asm =~ /\+%[sdu]/) {
		(my $asm1 = $asm) =~ s/\+%[sdu]//;
		my @bin1 = map {/%[sdu]/ ? 0 : $_} @bin;
		add_opc_3($cpu, $asm1, @bin1);
	}

	add_opc_3($cpu, $asm, @bin);
}

sub add_opc_3 {
	my($cpu, $asm, @bin) = @_;

	add_opc_4($cpu, $asm, @bin);

	return unless $cpu =~ /^r/;
	
	# expand ioi ioe
	my $has_io;
	if (($asm =~ /\((ix|iy|hl|bc|de|%m)/ && $asm !~ /^(ldp|jp)/) ||
		($asm =~ /^(ldi|ldir|ldd|lddr|ldisr|lddsr|lsdr|lsir|lsddr|lsidr)$/)) {
		add_opc_4($cpu, "ioi $asm", $V{ioi}, @bin);
		add_opc_4($cpu, "ioe $asm", $V{ioe}, @bin);
		$has_io++;
	}
	
	# expand altd
	if ($asm =~ /^ (?| ( (?:ld|inc|dec|pop|bool|rlc|rrc|rl|rr|sla|sra|sll|sli|srl|djnz) \s+ 
									(?:a|b|c|d|e|h|l|af|bc|de|hl)) ( $ | \b [^'] .*)
					 | ( (?:add|adc|sub|sbc|and|xor|or|neg) \s+ (?:a|hl) )(,.*)
					 | ( (?:ccf|scf) \s+ f)(,.*)
					 | ( (?:rlca|rrca|rla|rra)) (.*)
					 | ( (?:res|set) \s+ %c \s* , \s* (?:a|b|c|d|e|h|l)) ( $ | \b [^'] .*)
				   ) $/x &&
		$asm !~ /^ ld \s+ (bc|de|hl) \s* , \s* (bc|de|hl) /x) {
		if ($has_io) {
			add_opc_4($cpu, "$1'$2", $V{altd}, @bin);
			add_opc_4($cpu, "ioi $1'$2", $V{ioi}, $V{altd}, @bin);
			add_opc_4($cpu, "ioe $1'$2", $V{ioe}, $V{altd}, @bin);
			
			add_opc_4($cpu, "altd $1$2", $V{altd}, @bin);
			add_opc_4($cpu, "altd ioi $1$2", $V{altd}, $V{ioi}, @bin);
			add_opc_4($cpu, "altd ioe $1$2", $V{altd}, $V{ioe}, @bin);
			add_opc_4($cpu, "ioi altd $1$2", $V{ioi}, $V{altd}, @bin);
			add_opc_4($cpu, "ioe altd $1$2", $V{ioe}, $V{altd}, @bin);
		}
		else {
			add_opc_4($cpu, "$1'$2", $V{altd}, @bin);
			add_opc_4($cpu, "altd $1$2", $V{altd}, @bin);
		}
	}
	elsif ($asm =~ /^ (?| ( (?:add|adc|sub|sbc|and|xor|or) \s+ [^,]+ )
						| ( (?:and|or) \s+ (ix|iy) \s* , .* )
						| ( (?:inc|dec) \s+ \( .* )
						| ( (?:bool|rr) \s+ (ix|iy) .* )
					    | ( (?:cp|bit|djnz) \s+ .*) 
						| ( (?:rlc|rrc|rl|rr|sla|sra|sll|sli|srl) \s+ \( .*)
					  ) $/x) {
		if ($has_io) {
			add_opc_4($cpu, "altd $1", $V{altd}, @bin);
			add_opc_4($cpu, "altd ioi $1", $V{altd}, $V{ioi}, @bin);
			add_opc_4($cpu, "altd ioe $1", $V{altd}, $V{ioe}, @bin);
			add_opc_4($cpu, "ioi altd $1", $V{ioi}, $V{altd}, @bin);
			add_opc_4($cpu, "ioe altd $1", $V{ioe}, $V{altd}, @bin);
		}
		else {
			add_opc_4($cpu, "altd $1", $V{altd}, @bin);
		}
	}
}

sub add_opc_4 {
	my($cpu, $asm, @bin) = @_;

	if ($Opcodes{$asm}{$cpu}) {
		my $old = fmthex(@{$Opcodes{$asm}{$cpu}});
		my $new = fmthex(@bin);
		if ($old ne $new) {
			die "$cpu: $asm: ($old) or ($new)?";
		}
	}
	else {
		#say sprintf("%-8s%-24s%s", $cpu, $asm, fmthex(@bin));

		$Opcodes{$asm}{$cpu} = \@bin;
	}
}

#------------------------------------------------------------------------------
# Parser
#------------------------------------------------------------------------------
sub parser_tokens {
	local($_) = @_;
	my @tokens = ();
	
	while (!/\G \z 				/gcx) {
		if (/\G \s+ 			/gcx) {}
		elsif (/\G \( (\w+)		/gcx) { push @tokens, "_TK_IND_".uc($1); }
		elsif (/\G , 			/gcx) { push @tokens, "_TK_COMMA"; }
		elsif (/\G \) 			/gcx) { push @tokens, "_TK_RPAREN"; }
		elsif (/\G \( %[nm] \)	/gcx) { push @tokens, "expr"; }
		elsif (/\G    %[snmMj]	/gcx) { push @tokens, "expr"; }
		elsif (/\G \+ %[dsu]	/gcx) { push @tokens, "expr"; }
		elsif (/\G    %[c]		/gcx) { push @tokens, "const_expr"; }
		elsif (/\G    (\w+)	'	/gcx) { push @tokens, "_TK_".uc($1)."1"; }
		elsif (/\G    (\w+)		/gcx) { push @tokens, "_TK_".uc($1); }
		elsif (/\G \+   		/gcx) { push @tokens, "_TK_PLUS"; }
		elsif (/\G \-   		/gcx) { push @tokens, "_TK_MINUS"; }
		else { die "$_ ; ", substr($_, pos($_)||0) }
	}
	return join(' ', ('| label?', @tokens, "_TK_NEWLINE"));
}

sub parse_code {
	my($cpu, $asm, @bin) = @_;
	my @bin0 = @bin;
	my @code;
	
	# store rabbit prefixes
	if ($cpu =~ /^r/) {
		while (@bin && $bin[0] =~ /^\d+$/ &&
				($bin[0] == $V{altd} ||
				 $bin[0] == $V{ioi} ||
				 $bin[0] == $V{ioe})) {
			push @code, "DO_stmt(0x".fmthex(shift @bin).");"
		}
	}
	
	# store separate instructions
	while (@bin && $bin[0] =~ /^\d+$/) {
		my $num_bytes = $DECODE[$bin[0]];
		if ($num_bytes && @bin > $num_bytes) {
			my @sub_bin = splice(@bin, 0, $num_bytes);
			my $sub_code = parse_code($cpu, '', @sub_bin);
			push @code, split(/\n/, $sub_code);
			@bin==0 and return;
		}
		else {
			last;
		}
	}	
		
	# check for argument type
	my($stmt, $extra_arg) = ("", "");
	my $bin = join(' ', @bin);
	
	if ($bin =~ s/ \@(\w+)//) {
		my $func = $1;
		push @code, 
			"DO_STMT_LABEL();",
			"add_call_emul_func(\"$func\");";
	}
	elsif ($asm =~ /^rst /) {
		push @code, 
			"DO_STMT_LABEL();",
			"if (expr_error) { error_expected_const_expr(); } else {",
			"if (expr_value > 0 && expr_value < 8) expr_value *= 8;",
			"switch (expr_value) {",
			"case 0x00: case 0x08: case 0x30:",
			"  if (opts.cpu & CPU_RABBIT)",
			"    DO_stmt(0xCD0000 + (expr_value << 8));",
			"  else",
			"    DO_stmt(0xC7 + expr_value);",
			"  break;",
			"case 0x10: case 0x18: case 0x20: case 0x28: case 0x38:",
			"  DO_stmt(0xC7 + expr_value); break;",
			"default: error_int_range(expr_value);",
			"}}";
		my $code = join("\n", @code);
		return $code;
	}
	elsif ($asm =~ /^mmu %c, %n/) {
		push @code, 
			"DO_STMT_LABEL();",
			"if (expr_error) { error_expected_const_expr(); } else {",
			"if (expr_value < 0 || expr_value > 7) error_int_range(expr_value);",
			"DO_stmt_n(0xED9150 + expr_value);}";
		my $code = join("\n", @code);
		return $code;
	}
	elsif ($asm =~ /^mmu %c, a/) {
		push @code, 
			"DO_STMT_LABEL();",
			"if (expr_error) { error_expected_const_expr(); } else {",
			"if (expr_value < 0 || expr_value > 7) error_int_range(expr_value);",
			"DO_stmt(0xED9250 + expr_value);}";
		my $code = join("\n", @code);
		return $code;
	}
	elsif ($bin =~ s/ %d %n$//) {
		$stmt = "DO_stmt_idx_n";
	}
	elsif ($bin =~ s/ %n %n$//) {
		$stmt = "DO_stmt_n_n";
	}
	elsif ($bin =~ s/ %n$//) {
		$stmt = "DO_stmt_n";
	}
	elsif ($bin =~ s/ %u$//) {
		$stmt = "DO_stmt_n";
	}
	elsif ($bin =~ s/ %s$//) {
		$stmt = "DO_stmt_d";
	}
	elsif ($bin =~ /%t %t/) {
		push @code,
			"DO_STMT_LABEL();",
			"Expr *target_expr = pop_expr(ctx);",
			"const char *end_label = autolabel();",
			"Expr *end_label_expr = parse_expr(end_label);",
			"add_opcode_nn(0x".fmthex($bin[0]).", end_label_expr);",	# jump over
			"add_opcode_nn(0x".fmthex($bin[3]).", target_expr);",		# call
			"asm_LABEL_offset(end_label, 6);";
		my $code = join("\n", @code);
		return $code;
	}
	elsif ($bin =~ s/ %m %m$//) {
		$stmt = "DO_stmt_nn";
	}
	elsif ($bin =~ s/ %M %M$//) {
		$stmt = "DO_stmt_NN";
	}
	elsif ($bin =~ s/ %j$//) {
		if (@bin0 == 3 &&
		    $bin0[0] == dec_r('b') && $bin0[1] =~ /^\d+$/ &&
		    $bin0[2] eq '%j') {									# special dec b:jr nz,%j
			my $opc = "0x".fmthex($bin[0]);
			push @code, "add_opcode_jr_n($opc, pop_expr(ctx), 1);";	# compensate for extra byte
			my $code = join("\n", @code);
			return $code;
		}
		else {
			$stmt = "DO_stmt_jr";
		}
	}
	elsif ($bin =~ s/%c\((.*?)\)/expr_value/) {
		my @values = eval($1); die "$cpu, $asm, @bin, $1" if $@;
		$bin =~ s/%c/expr_value/g;		# replace all other %c in bin
		push @code,
			"if (expr_error) { error_expected_const_expr(); } else {",
			"switch (expr_value) {",
			join(" ", map {"case $_:"} @values)." break;",
			"default: error_int_range(expr_value);",
			"}}";
			
		if ($bin =~ s/ %d// || $bin =~ s/%d //) {
			$stmt = "DO_stmt_idx";
		} 
		else {
			$stmt = "DO_stmt";
		}
	}
	elsif ($bin =~ s/ %d//) {
		$stmt = "DO_stmt_idx";
	}
	else {
		$stmt = "DO_stmt";
	}

	# build statement - need to leave expressions for C compiler
	@bin = split(' ', $bin);
	my @expr;
	for (@bin) {
		if (/[+*?]/) {
			my $offset = 0;
			if (s/^(\d+)\+//) {
				$offset = $1;
			}
			$_ =~ s/\b(\d+)\b/ $1 < 10 ? $1 : "0x".fmthex($1) /ge;
			push @expr, $_;
			$_ = fmthex($offset);
		}
		else {
			push @expr, undef;
			$_ = eval($_); die "$cpu, $asm, @bin, $_" if $@;
			$_ = fmthex($_);
		}
	}
	
	my $opc = "0x".join('', @bin);
	for (0..$#expr) {
		next unless defined $expr[$_];
		my $bytes_shift = scalar(@bin) - $_ - 1;
		$opc .= '+(('.($expr[$_]).')';
		$opc .= ' << '.($bytes_shift * 8) if $bytes_shift;
		$opc .= ')';
	}
	$stmt and push @code, $stmt."(".$opc.$extra_arg.");";
	
	my $code = join("\n", @code);
	return $code;
}

sub merge_cpu {
	my($t) = @_;
	my $ret = '';
	my %code;
	
	my $last_code;
	for my $cpu (@CPUS) {
		if (exists $t->{$cpu}) {
			my $code = merge_parens($cpu, $t->{$cpu});
			$code{$code}{$cpu}++;
			$last_code = $code;
		}
	}
	
	if (scalar(keys %code) == 1 && 
	    scalar(keys %{$code{$last_code}}) == scalar(@CPUS)) {
		# no variants
		$ret .= $last_code."\n";
	}
	else {
		# variants per CPU
		$ret .= "switch (opts.cpu) {\n";
		for my $code (sort keys %code) {
			for my $cpu (sort keys %{$code{$code}}) {
				$ret .= "case CPU_".uc($cpu).": ";
			}
			$ret .= "\n$code\nbreak;\n"
		}
		$ret .= "default: error_illegal_ident(); }\n";
	}
	
	return $ret;
}

sub merge_parens {
	my($cpu, $t) = @_;
	my $ret = '';
	
	if ($t->{no_expr}) {
		die if $t->{expr_no_parens} || $t->{expr_in_parens};
		return merge_ixiy($cpu, $t->{no_expr});
	}
	elsif (!$t->{expr_no_parens} && !$t->{expr_in_parens}) {
		die;
	}
	elsif (!$t->{expr_no_parens} && $t->{expr_in_parens}) {
		return "if (!expr_in_parens) return false;\n".
				merge_ixiy($cpu, $t->{expr_in_parens});			
	}
	elsif ($t->{expr_no_parens} && !$t->{expr_in_parens}) {
		return "if (expr_in_parens) warn_expr_in_parens();\n".
				merge_ixiy($cpu, $t->{expr_no_parens});
	}
	elsif ($t->{expr_no_parens} && $t->{expr_in_parens}) {
		my($common, $in_parens, $no_parens) = 
			extract_common(merge_ixiy($cpu, $t->{expr_in_parens}),
						   merge_ixiy($cpu, $t->{expr_no_parens}));
		return $common.
				"if (expr_in_parens) { $in_parens } else { $no_parens }";
	}
	else {
		die;
	}
}

sub merge_ixiy {
	my($cpu, $t) = @_;
	
	my $ixiy = parse_code($cpu, @{$t->{ixiy}});
	my $iyix = parse_code($cpu, @{$t->{iyix}});
	
	if ($ixiy eq $iyix) {
		return $ixiy;
	}
	else {
		(my $common, $ixiy, $iyix) = extract_common($ixiy, $iyix);
		return $common.
				"if (!opts.swap_ix_iy) { $ixiy } else { $iyix }";
	}
}

sub extract_common {
	my($a, $b) = @_;
	my $common = '';
	
	while ($a =~ /(.*?[;}])/s && 
			substr($a, 0, length($1)) eq
			substr($b, 0, length($1)) ) {
		$common .= $1;
		
		$a = substr($a, length($&));
		$b = substr($b, length($&));
	}
	$common .= "\n" if $common;
	
	return ($common, $a, $b);
}

#------------------------------------------------------------------------------
# Tests
#------------------------------------------------------------------------------
sub add_tests {
	my($cpu, $asm, $bin) = @_;

	if ($asm =~ /%s/) {
		add_tests($cpu, replace($asm, '%s', 127), replace($bin, '%s', 0x7F));
		add_tests($cpu, replace($asm, '%s', -128), replace($bin, '%s', 0x80));
	}
	elsif ($asm =~ /%n/) {
		add_tests($cpu, replace($asm, '%n', 255), replace($bin, '%n', 0xFF));
		add_tests($cpu, replace($asm, '%n', 127), replace($bin, '%n', 0x7F));
		add_tests($cpu, replace($asm, '%n', -128), replace($bin, '%n', 0x80));
	}
	elsif ($asm =~ /%m/) {
		add_tests($cpu, replace($asm, '%m', 65535), replace($bin, '%m %m', 0xFF." ".0xFF));
		add_tests($cpu, replace($asm, '%m', 32767), replace($bin, '%m %m', 0xFF." ".0x7F));
		add_tests($cpu, replace($asm, '%m',-32768), replace($bin, '%m %m', 0x00." ".0x80));
	}
	elsif ($asm =~ /%M/) {
		add_tests($cpu, replace($asm, '%M', 65535), replace($bin, '%M %M', 0xFF." ".0xFF));
		add_tests($cpu, replace($asm, '%M', 32767), replace($bin, '%M %M', 0x7F." ".0xFF));
		add_tests($cpu, replace($asm, '%M',-32768), replace($bin, '%M %M', 0x80." ".0x00));
	}
	elsif ($asm =~ /%j/) {
		add_tests($cpu, replace($asm, '%j', "ASMPC"), replace($bin, '%j', 0xFE));
	}
	elsif ($asm =~ /^rst %c/) {		# special case
		for my $div (1, 8) {
			if ($cpu =~ /^r/) {
				add_tests($cpu, replace($asm, '%c', 0x00/$div), join(' ', 0xCD, 0x00, 0x00));
				add_tests($cpu, replace($asm, '%c', 0x08/$div), join(' ', 0xCD, 0x08, 0x00));
				add_tests($cpu, replace($asm, '%c', 0x30/$div), join(' ', 0xCD, 0x30, 0x00));
			}
			else {
				add_tests($cpu, replace($asm, '%c', 0x00/$div), join(' ', 0xC7));
				add_tests($cpu, replace($asm, '%c', 0x08/$div), join(' ', 0xCF));
				add_tests($cpu, replace($asm, '%c', 0x30/$div), join(' ', 0xF7));
			}
			add_tests($cpu, replace($asm, '%c', 0x10/$div), join(' ', 0xD7));
			add_tests($cpu, replace($asm, '%c', 0x18/$div), join(' ', 0xDF));
			add_tests($cpu, replace($asm, '%c', 0x20/$div), join(' ', 0xE7));
			add_tests($cpu, replace($asm, '%c', 0x28/$div), join(' ', 0xEF));
			add_tests($cpu, replace($asm, '%c', 0x38/$div), join(' ', 0xFF));
		}
		for my $invalid (-1, 9..15, 17..23, 25..31, 33..39, 41..47, 49..55, 57..64) {
			add_tests('', replace($asm, '%c', $invalid), '');
		}
	}
	elsif ($asm =~ /%c/) {
		$bin =~ s/%c\((.*?)\)/%c/ or die $bin;
		my @values = eval($1); die "$cpu, $asm, $bin, $1" if $@;
		my($min, $max) = ($values[0], $values[-1]);
		for (@values) {
			my @bin = split(' ', replace($bin, '%c', $_));
			for (@bin) {
				$_ = eval($_) if /[+*?]/; die $@ if $@;
			}
			add_tests($cpu, replace($asm, '%c', $_), join(' ', @bin));
			$min = $_ if $_ < $min;
			$max = $_ if $_ > $max;
		}
		add_tests('', replace($asm, '%c', $min-1), '');
		add_tests('', replace($asm, '%c', $max+1), '');
	}
	elsif ($asm =~ /%d/) {
		add_tests($cpu, replace($asm, qr/\+%d/, "+127"), replace($bin, '%d', 0x7F));
		add_tests($cpu, replace($asm, qr/\+%d/, "-128"), replace($bin, '%d', 0x80));
	}
	elsif ($asm =~ /%u/) {
		add_tests($cpu, replace($asm, qr/\+%u/, "+255"), replace($bin, '%u', 0xFF));
		add_tests($cpu, replace($asm, qr/\+%u/, "+0"  ), replace($bin, '%u', 0x00));
	}
	else {
		$Tests{$asm}{$cpu} = $bin;
	}
}

sub fmthex {
	return join(' ', map {/\D/ ? $_ : sprintf('%02X', $_)} @_);
}

sub replace {
	my($text, $find, $replace) = @_;
	$text =~ s/$find/$replace/g;
	return $text;
}

sub span_cells {
	my(@row) = @_;
	
	for my $i (1 .. $#row - 1) {
		for my $j ($i + 1 .. $#row) {
			last if $row[$i] =~ /^\s*$/;
			last if $row[$i] ne $row[$j];
			$row[$j] = "==";
		}
	}

	return @row;
}

sub write_table {
	my($tb, $file) = @_;
	
	open(my $fh, ">", $file) or die "open $file: $!\n";
	my $BY_ROWS = 50000;
	for (my $row = 1; $row < $tb->height; $row += $BY_ROWS) {
		print $fh $tb->rule('-', '+'), 
				  $tb->title, 
				  $tb->rule('-', '+'), 
				  $tb->table($row, $BY_ROWS);
	}
	print $fh $tb->rule('-', '+');
	close $fh;
}
