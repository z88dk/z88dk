#!/usr/bin/env perl

#------------------------------------------------------------------------------
# Build CPU tables
# asm placeholders:
#	%s	signed byte
#	%n	unsigned byte
#   %h  high page offset
#	%m	unsigned word
#	%M	unsigned word, big-endian
#	%j	jr offset
#	%c	constant (im, bit, rst, ...)
#	%d	signed register indirect offset
#	%u	unsigned register indirect offset
#	%t	temp jump label
#------------------------------------------------------------------------------

use Modern::Perl;
use YAML::Tiny;
use Clone 'clone';
use warnings FATAL => 'uninitialized'; 
use Carp (); 
$SIG{__DIE__} = \&Carp::confess;

# %opcodes: $opcodes{$asm}{$cpu} = [[@bin],[@bin]]
my %opcodes;

# operand values
my %V = (
	b=>0, c=>1, d=>2, e=>3, h=>4, l=>5, '(hl)'=>6, f=>6, m=>6, a=>7,
	bc=>0, de=>1, hl=>2, sp=>3, af=>3,
	ix=>0xDD, iy=>0xFD, 
	add=>0, adc=>1, sub=>2, sbc=>3, and=>4, xor=>5, or=>6, cp=>7, 
	                        sbb=>3, ana=>4, xra=>5, ora=>6, cmp=>7,
	adi=>0, aci=>1, sui=>2, sbi=>3, ani=>4, xri=>5, ori=>6, cpi=>7,
	rlca=>0, rrca=>1, rla=>2, rra=>3,
	rlc=>0, rrc=>1, ral=>2, rar=>3,
	                rl=>2, rr=>3, sla=>4, sra=>5, sll=>6, sls=>6, sli=>6, swap=>6,
					srl=>7, 
	bit=>1, res=>2, set=>3,
	_nz=>0, _z=>1, _nc=>2, _c=>3, _po=>4, _pe=>5, _nv=>4, _v=>5, _lz=>4, _lo=>5, 
	_p=>6, _m=>7,
	altd=>0x76, ioi=>0xD3, ioe=>0xDB, 
);

my %INV_FLAG = qw(	_nz	_z	_z 	_nz
					_nc _c 	_c	_nc
					_po _pe _pe	_po
					_nv _v 	_v	_nv
					_lz _lo _lo	_lz
					_p 	_m	_m	_p );

my @CPUS = qw( z80 z80n z180 r2ka r3k 8080 8085 gbz80 );

#------------------------------------------------------------------------------
# for each CPU
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

	#--------------------------------------------------------------------------
	# 8-bit load
	#--------------------------------------------------------------------------

	# LD r, r / LD r, (hl) / LD (hl), r
	for my $d (qw(     b c d e h l (hl) a )) { 
		for my $s (qw( b c d e h l (hl) a )) {
			if ($d ne '(hl)' || $s ne '(hl)') {
				add_x($cpu, "ld $d, $s", [ld_r_r($d, $s)]);
			}
		}
	}
	
	# MOV r, r / MOV r, m / MOV m, r
	for my $d (qw(     b c d e h l m a )) {
		for my $s (qw( b c d e h l m a )) {
			if ($d ne 'm' || $s ne 'm') {
				add($cpu, "mov $d, $s", [ld_r_r($d, $s)]);
			}
		}
	}

	# LD r, N / ld (hl), N
	for my $r (qw( b c d e h l (hl) a )) { 
		add_x($cpu, "ld $r, %n", [ld_r_n($r), '%n']);
	}

	# MVI r, N
	for my $r (qw( b c d e h l m a )) {
		add($cpu, "mvi $r, %n", [ld_r_n($r), '%n']);
	}

	#--------------------------------------------------------------------------
	# 8-bit indirect load
	#--------------------------------------------------------------------------

	for my $dd (qw( bc de )) {
		my $d = substr($dd,0,1);
		
		# LD A, (dd)
		add_x($cpu, "ld a, ($dd)", [ld_a_idd($dd)]);
		add($cpu, "ldax $dd", [ld_a_idd($dd)]);
		add($cpu, "ldax $d", [ld_a_idd($dd)]);
		
		# LD (dd), A
		add_x($cpu, "ld ($dd), a", [ld_idd_a($dd)]);
		add($cpu, "stax $dd", [ld_idd_a($dd)]);
		add($cpu, "stax $d", [ld_idd_a($dd)]);
		
		# LD a, (dd+) / LD a, (dd-)
		add_x($cpu, "ld a, ($dd+)", [ld_a_idd($dd)], [inc_dd($dd)]);
		add_x($cpu, "ldi a, ($dd)", [ld_a_idd($dd)], [inc_dd($dd)]);

		add_x($cpu, "ld a, ($dd-)", [ld_a_idd($dd)], [dec_dd($dd)]);
		add_x($cpu, "ldd a, ($dd)", [ld_a_idd($dd)], [dec_dd($dd)]);

		add_x($cpu, "ld ($dd+), a", [ld_idd_a($dd)], [inc_dd($dd)]);
		add_x($cpu, "ldi ($dd), a", [ld_idd_a($dd)], [inc_dd($dd)]);

		add_x($cpu, "ld ($dd-), a", [ld_idd_a($dd)], [dec_dd($dd)]);
		add_x($cpu, "ldd ($dd), a", [ld_idd_a($dd)], [dec_dd($dd)]);
	}
	
	# LD r, (HL+) / LD (HL+), r
	for my $r (qw( b c d e h l a )) { 
		if ($gameboy && $r eq 'a') {
			add($cpu, "ld (hl+), a", [0x22]);
			add($cpu, "ld (hli), a", [0x22]);
			add($cpu, "ldi (hl), a", [0x22]);
			
			add($cpu, "ld a, (hl+)", [0x2A]);
			add($cpu, "ld a, (hli)", [0x2A]);
			add($cpu, "ldi a, (hl)", [0x2A]);
			
			add($cpu, "ld (hl-), a", [0x32]);
			add($cpu, "ld (hld), a", [0x32]);
			add($cpu, "ldd (hl), a", [0x32]);
			
			add($cpu, "ld a, (hl-)", [0x3A]);
			add($cpu, "ld a, (hld)", [0x3A]);
			add($cpu, "ldd a, (hl)", [0x3A]);
		}
		else {
			add_x($cpu, "ld $r, (hl+)", [ld_r_r($r, '(hl)')], [inc_dd('hl')]);
			add_x($cpu, "ld $r, (hli)", [ld_r_r($r, '(hl)')], [inc_dd('hl')]);
			add_x($cpu, "ldi $r, (hl)", [ld_r_r($r, '(hl)')], [inc_dd('hl')]);
			
			add_x($cpu, "ld $r, (hl-)", [ld_r_r($r, '(hl)')], [dec_dd('hl')]);
			add_x($cpu, "ld $r, (hld)", [ld_r_r($r, '(hl)')], [dec_dd('hl')]);
			add_x($cpu, "ldd $r, (hl)", [ld_r_r($r, '(hl)')], [dec_dd('hl')]);
			
			add_x($cpu, "ld (hl+), $r", [ld_r_r('(hl)', $r)], [inc_dd('hl')]);
			add_x($cpu, "ld (hli), $r", [ld_r_r('(hl)', $r)], [inc_dd('hl')]);
			add_x($cpu, "ldi (hl), $r", [ld_r_r('(hl)', $r)], [inc_dd('hl')]);
			
			add_x($cpu, "ld (hl-), $r", [ld_r_r('(hl)', $r)], [dec_dd('hl')]);
			add_x($cpu, "ld (hld), $r", [ld_r_r('(hl)', $r)], [dec_dd('hl')]);
			add_x($cpu, "ldd (hl), $r", [ld_r_r('(hl)', $r)], [dec_dd('hl')]);
		}
	}

	# LD (HL+), N
	add_x($cpu, "ld (hl+), %n", [ld_r_n('(hl)'), '%n'], [inc_dd('hl')]);
	add_x($cpu, "ldi (hl), %n", [ld_r_n('(hl)'), '%n'], [inc_dd('hl')]);
	
	add_x($cpu, "ld (hl-), %n", [ld_r_n('(hl)'), '%n'], [dec_dd('hl')]);
	add_x($cpu, "ldd (hl), %n", [ld_r_n('(hl)'), '%n'], [dec_dd('hl')]);
	
	# LD (DE), r / LD r, (DE), r != a
	if (!$gameboy) {				# gbz80 does not have ex de, hl
		add($cpu, "ld b, (de)", [ex_de_hl()], [ld_r_r('b', '(hl)')], [ex_de_hl()]);
		add($cpu, "ld c, (de)", [ex_de_hl()], [ld_r_r('c', '(hl)')], [ex_de_hl()]);
		add($cpu, "ld d, (de)", [ex_de_hl()], [ld_r_r('h', '(hl)')], [ex_de_hl()]);
		add($cpu, "ld e, (de)", [ex_de_hl()], [ld_r_r('l', '(hl)')], [ex_de_hl()]);
		add($cpu, "ld h, (de)", [ex_de_hl()], [ld_r_r('d', '(hl)')], [ex_de_hl()]);
		add($cpu, "ld l, (de)", [ex_de_hl()], [ld_r_r('e', '(hl)')], [ex_de_hl()]);
		
		add($cpu, "ld b, (de+)", [ex_de_hl()], [ld_r_r('b', '(hl)')], [ex_de_hl()], [inc_dd('de')]);
		add($cpu, "ld c, (de+)", [ex_de_hl()], [ld_r_r('c', '(hl)')], [ex_de_hl()], [inc_dd('de')]);
		add($cpu, "ld d, (de+)", [ex_de_hl()], [ld_r_r('h', '(hl)')], [ex_de_hl()], [inc_dd('de')]);
		add($cpu, "ld e, (de+)", [ex_de_hl()], [ld_r_r('l', '(hl)')], [ex_de_hl()], [inc_dd('de')]);
		add($cpu, "ld h, (de+)", [ex_de_hl()], [ld_r_r('d', '(hl)')], [ex_de_hl()], [inc_dd('de')]);
		add($cpu, "ld l, (de+)", [ex_de_hl()], [ld_r_r('e', '(hl)')], [ex_de_hl()], [inc_dd('de')]);
		
		add($cpu, "ldi b, (de)", [ex_de_hl()], [ld_r_r('b', '(hl)')], [ex_de_hl()], [inc_dd('de')]);
		add($cpu, "ldi c, (de)", [ex_de_hl()], [ld_r_r('c', '(hl)')], [ex_de_hl()], [inc_dd('de')]);
		add($cpu, "ldi d, (de)", [ex_de_hl()], [ld_r_r('h', '(hl)')], [ex_de_hl()], [inc_dd('de')]);
		add($cpu, "ldi e, (de)", [ex_de_hl()], [ld_r_r('l', '(hl)')], [ex_de_hl()], [inc_dd('de')]);
		add($cpu, "ldi h, (de)", [ex_de_hl()], [ld_r_r('d', '(hl)')], [ex_de_hl()], [inc_dd('de')]);
		add($cpu, "ldi l, (de)", [ex_de_hl()], [ld_r_r('e', '(hl)')], [ex_de_hl()], [inc_dd('de')]);
		
		add($cpu, "ld b, (de-)", [ex_de_hl()], [ld_r_r('b', '(hl)')], [ex_de_hl()], [dec_dd('de')]);
		add($cpu, "ld c, (de-)", [ex_de_hl()], [ld_r_r('c', '(hl)')], [ex_de_hl()], [dec_dd('de')]);
		add($cpu, "ld d, (de-)", [ex_de_hl()], [ld_r_r('h', '(hl)')], [ex_de_hl()], [dec_dd('de')]);
		add($cpu, "ld e, (de-)", [ex_de_hl()], [ld_r_r('l', '(hl)')], [ex_de_hl()], [dec_dd('de')]);
		add($cpu, "ld h, (de-)", [ex_de_hl()], [ld_r_r('d', '(hl)')], [ex_de_hl()], [dec_dd('de')]);
		add($cpu, "ld l, (de-)", [ex_de_hl()], [ld_r_r('e', '(hl)')], [ex_de_hl()], [dec_dd('de')]);
		
		add($cpu, "ldd b, (de)", [ex_de_hl()], [ld_r_r('b', '(hl)')], [ex_de_hl()], [dec_dd('de')]);
		add($cpu, "ldd c, (de)", [ex_de_hl()], [ld_r_r('c', '(hl)')], [ex_de_hl()], [dec_dd('de')]);
		add($cpu, "ldd d, (de)", [ex_de_hl()], [ld_r_r('h', '(hl)')], [ex_de_hl()], [dec_dd('de')]);
		add($cpu, "ldd e, (de)", [ex_de_hl()], [ld_r_r('l', '(hl)')], [ex_de_hl()], [dec_dd('de')]);
		add($cpu, "ldd h, (de)", [ex_de_hl()], [ld_r_r('d', '(hl)')], [ex_de_hl()], [dec_dd('de')]);
		add($cpu, "ldd l, (de)", [ex_de_hl()], [ld_r_r('e', '(hl)')], [ex_de_hl()], [dec_dd('de')]);
		
		add($cpu, "ld (de), b", [ex_de_hl()], [ld_r_r('(hl)', 'b')], [ex_de_hl()]);
		add($cpu, "ld (de), c", [ex_de_hl()], [ld_r_r('(hl)', 'c')], [ex_de_hl()]);
		add($cpu, "ld (de), d", [ex_de_hl()], [ld_r_r('(hl)', 'h')], [ex_de_hl()]);
		add($cpu, "ld (de), e", [ex_de_hl()], [ld_r_r('(hl)', 'l')], [ex_de_hl()]);
		add($cpu, "ld (de), h", [ex_de_hl()], [ld_r_r('(hl)', 'd')], [ex_de_hl()]);
		add($cpu, "ld (de), l", [ex_de_hl()], [ld_r_r('(hl)', 'e')], [ex_de_hl()]);
		
		add($cpu, "ld (de+), b", [ex_de_hl()], [ld_r_r('(hl)', 'b')], [ex_de_hl()], [inc_dd('de')]);
		add($cpu, "ld (de+), c", [ex_de_hl()], [ld_r_r('(hl)', 'c')], [ex_de_hl()], [inc_dd('de')]);
		add($cpu, "ld (de+), d", [ex_de_hl()], [ld_r_r('(hl)', 'h')], [ex_de_hl()], [inc_dd('de')]);
		add($cpu, "ld (de+), e", [ex_de_hl()], [ld_r_r('(hl)', 'l')], [ex_de_hl()], [inc_dd('de')]);
		add($cpu, "ld (de+), h", [ex_de_hl()], [ld_r_r('(hl)', 'd')], [ex_de_hl()], [inc_dd('de')]);
		add($cpu, "ld (de+), l", [ex_de_hl()], [ld_r_r('(hl)', 'e')], [ex_de_hl()], [inc_dd('de')]);
		
		add($cpu, "ldi (de), b", [ex_de_hl()], [ld_r_r('(hl)', 'b')], [ex_de_hl()], [inc_dd('de')]);
		add($cpu, "ldi (de), c", [ex_de_hl()], [ld_r_r('(hl)', 'c')], [ex_de_hl()], [inc_dd('de')]);
		add($cpu, "ldi (de), d", [ex_de_hl()], [ld_r_r('(hl)', 'h')], [ex_de_hl()], [inc_dd('de')]);
		add($cpu, "ldi (de), e", [ex_de_hl()], [ld_r_r('(hl)', 'l')], [ex_de_hl()], [inc_dd('de')]);
		add($cpu, "ldi (de), h", [ex_de_hl()], [ld_r_r('(hl)', 'd')], [ex_de_hl()], [inc_dd('de')]);
		add($cpu, "ldi (de), l", [ex_de_hl()], [ld_r_r('(hl)', 'e')], [ex_de_hl()], [inc_dd('de')]);
		
		add($cpu, "ld (de-), b", [ex_de_hl()], [ld_r_r('(hl)', 'b')], [ex_de_hl()], [dec_dd('de')]);
		add($cpu, "ld (de-), c", [ex_de_hl()], [ld_r_r('(hl)', 'c')], [ex_de_hl()], [dec_dd('de')]);
		add($cpu, "ld (de-), d", [ex_de_hl()], [ld_r_r('(hl)', 'h')], [ex_de_hl()], [dec_dd('de')]);
		add($cpu, "ld (de-), e", [ex_de_hl()], [ld_r_r('(hl)', 'l')], [ex_de_hl()], [dec_dd('de')]);
		add($cpu, "ld (de-), h", [ex_de_hl()], [ld_r_r('(hl)', 'd')], [ex_de_hl()], [dec_dd('de')]);
		add($cpu, "ld (de-), l", [ex_de_hl()], [ld_r_r('(hl)', 'e')], [ex_de_hl()], [dec_dd('de')]);
		
		add($cpu, "ldd (de), b", [ex_de_hl()], [ld_r_r('(hl)', 'b')], [ex_de_hl()], [dec_dd('de')]);
		add($cpu, "ldd (de), c", [ex_de_hl()], [ld_r_r('(hl)', 'c')], [ex_de_hl()], [dec_dd('de')]);
		add($cpu, "ldd (de), d", [ex_de_hl()], [ld_r_r('(hl)', 'h')], [ex_de_hl()], [dec_dd('de')]);
		add($cpu, "ldd (de), e", [ex_de_hl()], [ld_r_r('(hl)', 'l')], [ex_de_hl()], [dec_dd('de')]);
		add($cpu, "ldd (de), h", [ex_de_hl()], [ld_r_r('(hl)', 'd')], [ex_de_hl()], [dec_dd('de')]);
		add($cpu, "ldd (de), l", [ex_de_hl()], [ld_r_r('(hl)', 'e')], [ex_de_hl()], [dec_dd('de')]);
		
		add($cpu, "ld (de), %n",  [ex_de_hl()], [ld_r_n('(hl)'), '%n'], [ex_de_hl()]);
		add($cpu, "ld (de+), %n", [ex_de_hl()], [ld_r_n('(hl)'), '%n'], [ex_de_hl()], [inc_dd('de')]);
		add($cpu, "ldi (de), %n", [ex_de_hl()], [ld_r_n('(hl)'), '%n'], [ex_de_hl()], [inc_dd('de')]);
		add($cpu, "ld (de-), %n", [ex_de_hl()], [ld_r_n('(hl)'), '%n'], [ex_de_hl()], [dec_dd('de')]);
		add($cpu, "ldd (de), %n", [ex_de_hl()], [ld_r_n('(hl)'), '%n'], [ex_de_hl()], [dec_dd('de')]);
	}
	
	# LD (NN), A / LD A, (NN)
	if ($gameboy) {
		add($cpu, "ld (%m), a", [0xEA, '%m', '%m']);
		add($cpu, "sta %m",		[0xEA, '%m', '%m']);
		
		add($cpu, "ld a, (%m)", [0xFA, '%m', '%m']);
		add($cpu, "lda %m",		[0xFA, '%m', '%m']);
	}
	else {
		add_x($cpu, "ld (%m), a", [0x32, '%m', '%m']);
		add($cpu, "sta %m",		[0x32, '%m', '%m']);
		
		add_x($cpu, "ld a, (%m)", [0x3A, '%m', '%m']);
		add($cpu, "lda %m",		[0x3A, '%m', '%m']);
	}
	
	#--------------------------------------------------------------------------
	# 8-bit ALU group
	#--------------------------------------------------------------------------

	for my $op (qw( add adc sub sbc and xor or cp cmp )) {
		for my $r (qw( b c d e h l (hl) a )) {
			for my $a_ ('a, ', '') {
				add_x($cpu, "$op $a_$r", [alu_r($op, $r)]);
			}
		}
		
		for my $a_ ('a, ', '') {
			add_x($cpu, "$op $a_%n", 	[alu_n($op), '%n']);
			add_x($cpu, "$op $a_(hl+)",	[alu_r($op, '(hl)')], [inc_dd('hl')]);
			add_x($cpu, "$op $a_(hl-)",	[alu_r($op, '(hl)')], [dec_dd('hl')]);
		}
	}

	for my $op (qw( add adc sub sbb ana xra ora cmp )) {
		for my $r (qw( b c d e h l m a )) {
			add($cpu, "$op $r", [alu_r($op, $r)]) unless $opcodes{"$op $r"}{$cpu};
		}
	}

	for my $op (qw( adi aci sui sbi ani xri ori cpi )) {
		add($cpu, "$op %n", [alu_n($op), '%n']);
	}

	for my $r (qw( b c d e h l (hl) a )) { 
		add_x($cpu, "inc $r", [inc_r($r)]);
		add_x($cpu, "dec $r", [dec_r($r)]);
	}
	
	for my $r (qw( b c d e h l m a )) {
		add($cpu, "inr $r", [inc_r($r)]);
		add($cpu, "dcr $r", [dec_r($r)]);
	}

	add_x($cpu, "inc (hl+)", 	[inc_r('(hl)')], [inc_dd('hl')]);
	add_x($cpu, "dec (hl+)", 	[dec_r('(hl)')], [inc_dd('hl')]);
	
	add_x($cpu, "inc (hl-)", 	[inc_r('(hl)')], [dec_dd('hl')]);
	add_x($cpu, "dec (hl-)", 	[dec_r('(hl)')], [dec_dd('hl')]);
	
	for my $op (qw( tst test )) {
		for my $a_ ('a, ', '') {
			for my $r (qw( b c d e h l (hl) a )) { 
				if ($z180) {
					add($cpu, "$op $a_$r",  [0xED, 0x04+8*$V{$r}]);
				}
			}
			if ($z180) {
				add($cpu, "$op $a_%n",  [0xED, 0x64, '%n']);
			}
			elsif ($z80n) {
				add($cpu, "$op $a_%n",  [0xED, 0x27, '%n']);
			}
		}
	}
	
	if ($intel || $zilog || $gameboy) {
		add($cpu, "daa", [0x27]);
	}
	else {
		add($cpu, "daa", [call(), '@__z80asm__daa', '']);
	}
	
	if ($zilog) {
		add($cpu, "rrd", [0xED, 0x67]);
		add($cpu, "rld", [0xED, 0x6F]);
	}
	else {
		add($cpu, "rrd", [call(), '@__z80asm__rrd', '']);
		add($cpu, "rld", [call(), '@__z80asm__rld', '']);
	}
	
	# cpl
	add($cpu, "cpl", 			[0x2F]);
	add($cpu, "cma",			[0x2F]);
	add($cpu, "cpl a", 			[0x2F]);
	if ($rabbit) {
		add($cpu, "cpl a'", 	[$V{altd}], [0x2F]);
		add($cpu, "altd cpl",	[$V{altd}], [0x2F]);
		add($cpu, "altd cpl a",	[$V{altd}], [0x2F]);
	}
	
	if (!$intel && !$gameboy) {
		add($cpu, "neg", 		[0xED, 0x44]);
		add($cpu, "neg a", 		[0xED, 0x44]);
	}
	else {
		add($cpu, "neg", 		[0x2F, 0x3C]);
		add($cpu, "neg a", 		[0x2F, 0x3C]);
	}
	
	add($cpu, "neg a'", 	[$V{altd}], [0xED, 0x44]) if $rabbit;
	add($cpu, "altd neg",	[$V{altd}], [0xED, 0x44]) if $rabbit;
	add($cpu, "altd neg a",	[$V{altd}], [0xED, 0x44]) if $rabbit;
	
	add($cpu, "ccf", 		[0x3F]);
	add($cpu, "cmc",		[0x3F]);
	
	add($cpu, "ccf'", 		[$V{altd}], [0x3F]) if $rabbit;
	add($cpu, "altd ccf",	[$V{altd}], [0x3F]) if $rabbit;
	
	add($cpu, "scf", 		[0x37]);
	add($cpu, "stc",		[0x37]);

	add($cpu, "scf'", 		[$V{altd}], [0x37]) if $rabbit;
	add($cpu, "altd scf",	[$V{altd}], [0x37]) if $rabbit;
	
	#--------------------------------------------------------------------------
	# 16-bit load
	#--------------------------------------------------------------------------

	# LD (hl), bc/de
	add($cpu, "ld (hl), bc",  [ld_r_r('(hl)', 'c')], [inc_dd('hl')], [ld_r_r('(hl)', 'b')], [dec_dd('hl')]);
	add($cpu, "ld (hl+), bc", [ld_r_r('(hl)', 'c')], [inc_dd('hl')], [ld_r_r('(hl)', 'b')], [inc_dd('hl')]);
	add($cpu, "ldi (hl), bc", [ld_r_r('(hl)', 'c')], [inc_dd('hl')], [ld_r_r('(hl)', 'b')], [inc_dd('hl')]);
	
	add($cpu, "ld (hl), de",  [ld_r_r('(hl)', 'e')], [inc_dd('hl')], [ld_r_r('(hl)', 'd')], [dec_dd('hl')]);
	add($cpu, "ld (hl+), de", [ld_r_r('(hl)', 'e')], [inc_dd('hl')], [ld_r_r('(hl)', 'd')], [inc_dd('hl')]);
	add($cpu, "ldi (hl), de", [ld_r_r('(hl)', 'e')], [inc_dd('hl')], [ld_r_r('(hl)', 'd')], [inc_dd('hl')]);
	
	# LD dd, NN
	for my $dd (qw( bc de hl sp )) {
		my $d = ($dd eq 'sp') ? $dd : substr($dd,0,1);		# B, D, H

		add_x($cpu, "ld $dd, %m",  [ld_dd_m($dd), '%m', '%m']);
		add($cpu, "lxi $dd, %m", [ld_dd_m($dd), '%m', '%m']);
		add($cpu, "lxi $d, %m",	 [ld_dd_m($dd), '%m', '%m']) if $d ne $dd;
		
		if (!$intel && $dd eq 'hl') {
			for my $x (qw( ix iy )) {
				add_x($cpu, "ld $x, %m", [$V{$x}, ld_dd_m($dd), '%m', '%m']);
			}
		}
	}
	
	# LD dd, (NN) / LD (NN), dd
	if (!$gameboy) {
		for my $r (qw( bc de hl sp )) {
			if ($r eq 'hl') {
				add_x($cpu, "ld (%m), $r", 	[0x22, '%m', '%m']);
				add($cpu, "shld %m",		[0x22, '%m', '%m']);

				add_x($cpu, "ld $r, (%m)", 	[0x2A, '%m', '%m']);
				add($cpu, "lhld %m",		[0x2A, '%m', '%m']);
				
				if (!$intel) {
					for my $x (qw( ix iy )) {
						add_x($cpu, "ld $x, (%m)", [$V{$x}, 0x2A, '%m', '%m']);
						add_x($cpu, "ld (%m), $x", [$V{$x}, 0x22, '%m', '%m']);
					}
				}
			}
			else {
				if ($intel) {
					if ($r eq 'de') {
						# gbz80 lacks the ld hl,(**) and ld (**),hl
						add($cpu, "ld $r, (%m)", [ex_de_hl()], [0x2A, '%m', '%m'], [ex_de_hl()]);
						add($cpu, "ld (%m), $r", [ex_de_hl()], [0x22, '%m', '%m'], [ex_de_hl()]);
					}
				}
				else {
					add_x($cpu, "ld $r, (%m)", [0xED, 0x4B + $V{$r}*16, '%m', '%m']);
					add_x($cpu, "ld (%m), $r", [0xED, 0x43 + $V{$r}*16, '%m', '%m']);
				}
			}
		}
	}

	# LD dd, dd
	add($cpu, "ld bc, de", [ld_r_r('b', 'd')], [ld_r_r('c', 'e')]);
	add($cpu, "ld bc, hl", [ld_r_r('b', 'h')], [ld_r_r('c', 'l')]);
	if ($z80) {
		add($cpu, "ld bc, ix", [$V{ix}, ld_r_r('b', 'h')], [$V{ix}, ld_r_r('c', 'l')]);
		add($cpu, "ld bc, iy", [$V{iy}, ld_r_r('b', 'h')], [$V{iy}, ld_r_r('c', 'l')]);
	}
	
	add($cpu, "ld de, bc", [ld_r_r('d', 'b')], [ld_r_r('e', 'c')]);
	
	if ($i8085) {
		# Add 00bb immediate to HL, result to DE (undocumented i8085)
		add($cpu, "ldhi %n",		[0x28, '%n']);
		add($cpu, "adi hl, %n",		[0x28, '%n']);
		add($cpu, "ld de, hl+%u",	[0x28, '%u']);
	}
    
    # this 8085 instruction is slower, thanks @feilipu
    # add($cpu, "ld de, hl",	0x28, 0);       						# 10 T
    add($cpu, "ld de, hl", 	[ld_r_r('d', 'h')], [ld_r_r('e', 'l')]);	#  8 T

	if ($z80) {
		add($cpu, "ld de, ix", [$V{ix}, ld_r_r('d', 'h')], [$V{ix}, ld_r_r('e', 'l')]);
		add($cpu, "ld de, iy", [$V{iy}, ld_r_r('d', 'h')], [$V{iy}, ld_r_r('e', 'l')]);
	}

	add($cpu, "ld hl, bc", [ld_r_r('h', 'b')], [ld_r_r('l', 'c')]);
	add($cpu, "ld hl, de", [ld_r_r('h', 'd')], [ld_r_r('l', 'e')]);

	if ($z80) {
		add($cpu, "ld ix, bc", [$V{ix}, ld_r_r('h', 'b')], [$V{ix}, ld_r_r('l', 'c')]);
		add($cpu, "ld ix, de", [$V{ix}, ld_r_r('h', 'd')], [$V{ix}, ld_r_r('l', 'e')]);

		add($cpu, "ld iy, bc", [$V{iy}, ld_r_r('h', 'b')], [$V{iy}, ld_r_r('l', 'c')]);
		add($cpu, "ld iy, de", [$V{iy}, ld_r_r('h', 'd')], [$V{iy}, ld_r_r('l', 'e')]);

		add($cpu, "ld ix, hl", [push_dd('hl')], [$V{ix}, pop_dd('hl')]);
		add($cpu, "ld iy, hl", [push_dd('hl')], [$V{iy}, pop_dd('hl')]);
		
        add($cpu, "ld ix, iy", [$V{iy}, push_dd('hl')], [$V{ix}, pop_dd('hl')]);
        add($cpu, "ld iy, ix", [$V{ix}, push_dd('hl')], [$V{iy}, pop_dd('hl')]);

		add($cpu, "ld hl, ix", [$V{ix}, push_dd('hl')], [pop_dd('hl')]);
		add($cpu, "ld hl, iy", [$V{iy}, push_dd('hl')], [pop_dd('hl')]);
	}

	add($cpu, "ld sp, hl", 	[ld_sp_hl()]);
	add($cpu, "sphl",		[ld_sp_hl()]);

	if (!$intel && !$gameboy) {
		for my $x (qw( ix iy )) {
			add($cpu, "ld sp, $x", [$V{$x}, ld_sp_hl()]);
		}
	}
	
    if ($i8085) {
		add($cpu, "ld hl, sp+%u",	[ex_de_hl()], [0x38, '%u'], [ex_de_hl()]);
		add($cpu, "ld hl, sp",		[ex_de_hl()], [0x38, 0], 	[ex_de_hl()]);
    }
	elsif ($gameboy) {
		add($cpu, "ldhl sp, %s",  [0xF8, '%s']);
		add($cpu, "ld hl, sp", 	  [0xF8, 0]);
		add($cpu, "ld hl, sp+%s", [0xF8, '%s']);
    }
    else {
		add($cpu, "ld hl, sp",		[ld_dd_m('hl'), 0, 0],		# ld hl, %n
									[add_hl_dd('sp')]);    		# add hl, sp
		add($cpu, "ld hl, sp+%s",	[ld_dd_m('hl'), '%s', 0],	# ld hl, %s
									[add_hl_dd('sp')]);    		# add hl, sp
    }
    
	if ($gameboy) {
		add($cpu, "ld (%m), sp", [0x08, '%m', '%m']);
	}

	for my $r (qw( bc de hl af )) {
		my $r1 = ($r eq 'af') ? 'psw' : substr($r,0,1);		# B, D, H, PSW

		add($cpu, "push $r",	[push_dd($r)]);
		add($cpu, "push $r1",	[push_dd($r)]);

		add_x($cpu, "pop $r",	[pop_dd($r)]);
		add($cpu, "pop $r1",	[pop_dd($r)]);
		
		if (!$intel && !$gameboy) {
			if ($r eq 'hl') {
				for my $x (qw( ix iy )) {
					add($cpu, "push $x", [$V{$x}, push_dd($r)]);
					add($cpu, "pop $x",  [$V{$x}, pop_dd($r)]);
				}
			}
		}
	}

	if ($z80n) {
		add($cpu, "push %M", 	[0xED, 0x8A, '%M', '%M']);
	}	

	if ($rabbit) {
		add($cpu, "push ip", 	[0xED, 0x76]);
		add($cpu, "pop ip", 	[0xED, 0x7E]);
	}
	
	if ($r3k) {
		add($cpu, "push su", 	[0xED, 0x66]);
		add($cpu, "pop su", 	[0xED, 0x6E]);
	}

	if ($rabbit) {
		for my $x (qw( ix iy )) {
			add_x($cpu, "ld hl, $x", [$V{$x}, 0x7C]);
			add_x($cpu, "ld $x, hl", [$V{$x}, 0x7D]);
		}
		
		for ([hl => 0xDD], [ix => ()], [iy => 0xFD]) {
			my($dd, @pfx) = @$_;
		
			add_x($cpu, "ld hl, ($dd+%d)", [@pfx, 0xE4, '%d']);
			add_x($cpu, "ld ($dd+%d), hl", [@pfx, 0xF4, '%d']);
		}
			
		for ([hl => ()], [ix => 0xDD], [iy => 0xFD]) {
			my($dd, @pfx) = @$_;
		
			add_x($cpu, "ld (sp+%u), $dd", 	[@pfx, 0xD4, '%u']);
			add_x($cpu, "ld (sp), $dd", 	[@pfx, 0xD4, 0]);
			add_x($cpu, "ld $dd, (sp+%u)", 	[@pfx, 0xC4, '%u']);
			add_x($cpu, "ld $dd, (sp)", 	[@pfx, 0xC4, 0]);
		}
		
		for my $dd (qw(bc de hl)) {
			for my $s (qw(bc de)) {
				add($cpu, "ld $dd', $s", 	[0xED, 0x41+16*$V{$dd}+8*(1-$V{$s})]);
				add($cpu, "altd ld $dd, $s", [0xED, 0x41+16*$V{$dd}+8*(1-$V{$s})]);
			}
		}
		
		for ([hl => 0xED], [ix => 0xDD], [iy => 0xFD]) {
			my($dd, $pfx) = @$_;
			
			add($cpu, "ldp (%m), $dd", [$pfx, 0x65, '%m', '%m']);
			add($cpu, "ldp $dd, (%m)", [$pfx, 0x6D, '%m', '%m']);
			add($cpu, "ldp ($dd), hl", [$pfx, 0x64]);
			add($cpu, "ldp hl, ($dd)", [$pfx, 0x6C]);
		}
	}

	# undocumented 8085 instructions
	if ($i8085) {
		# Add 00bb immediate to SP, result to DE
		add($cpu, "ldsi %n",		[0x38, '%n']);
		add($cpu, "adi sp, %n",		[0x38, '%n']);
		add($cpu, "ld de, sp+%u",	[0x38, '%u']);
		add($cpu, "ld de, sp",		[0x38, 0]);
    }
    elsif ($gameboy) {
		for (["+%u", "%u"], ["", 0]) {
			my($off_asm, $off_bin) = @$_;
			add($cpu, "ld de, sp$off_asm",	
						[push_dd('hl')],				# ex de, hl
						[push_dd('de')],
						[pop_dd('hl')],
						[pop_dd('de')],
						[ld_dd_m('hl'), $off_bin, 0],	# ld hl, %n
						[add_hl_dd('sp')],				# add hl, sp
						[push_dd('hl')],				# ex de, hl
						[push_dd('de')],
						[pop_dd('hl')],
						[pop_dd('de')]);
		}
    }
    else {
		for (["+%u", "%u"], ["", 0]) {
			my($off_asm, $off_bin) = @$_;
			add($cpu, "ld de, sp$off_asm",	
						[ex_de_hl()],               	# ex de, hl
						[ld_dd_m('hl'), $off_bin, 0],	# ld hl, %n
						[add_hl_dd('sp')],				# add hl, sp
						[ex_de_hl()]);					# ex de, hl
		}
    }
    
	if ($i8085) {
		# Store HL at address pointed by DE
		add($cpu, "shlx",			[0xD9]);
		add($cpu, "shlde",			[0xD9]);
		add($cpu, "ld (de), hl",	[0xD9]);
		
		# Load HL from address pointed by DE
		add($cpu, "lhlx",			[0xED]);
		add($cpu, "lhlde",			[0xED]);
		add($cpu, "ld hl, (de)",	[0xED]);
	}

	#--------------------------------------------------------------------------
	# Exchange group
	#--------------------------------------------------------------------------

	if (!$intel && !$gameboy) {
		add($cpu, "ex af, af'", [0x08]);
		add($cpu, "ex af, af",  [0x08]);
		
		add($cpu, "exx",  [0xD9]);
	}

	if ($gameboy) {
		add($cpu, "ex de, hl",	[push_dd('hl')], [push_dd('de')],
								[pop_dd('hl')], [pop_dd('de')]);
		add($cpu, "xchg",		[push_dd('hl')], [push_dd('de')],
								[pop_dd('hl')], [pop_dd('de')]);
	}
	else {
		add($cpu, "ex de, hl",	[ex_de_hl()]);
		add($cpu, "xchg",		[ex_de_hl()]);
		
		if ($rabbit) {
			add($cpu, "ex de', hl", 	[0xE3]);
			add($cpu, "ex de, hl'", 	[0x76], [0xEB]);
			add($cpu, "ex de', hl'", 	[0x76], [0xE3]);
			
			add($cpu, "altd ex de, hl", [0x76], [0xEB]);
			add($cpu, "altd ex de', hl",[0x76], [0xE3]);
		}
	}
	
	if ($zilog || $intel) {
		add($cpu, "ex (sp), hl", 		[0xE3]);
		add($cpu, "xthl",				[0xE3]);
	}
	elsif ($rabbit) {
		add($cpu, "ex (sp), hl", 		[0xED, 0x54]);
		add($cpu, "ex (sp), hl'", 		[$V{altd}], [0xED, 0x54]);
		add($cpu, "altd ex (sp), hl", 	[$V{altd}], [0xED, 0x54]);
	}
	else {
		add($cpu, "ex (sp), hl", 		[call(), '@__z80asm__ex_sp_hl', '']);
	}
	
	if (!$intel && !$gameboy) {
		for my $x (qw( ix iy )) {
			add($cpu, "ex (sp), $x", [$V{$x}, 0xE3]);
		}
	}
	
	#--------------------------------------------------------------------------
	# 16-bit ALU group
	#--------------------------------------------------------------------------

	# ADD
	for my $dd (qw( bc de hl sp )) {
		my $dd1 = ($dd eq 'sp') ? $dd : substr($dd,0,1);		# B, D, H
		
		add_x($cpu, "add hl, $dd",[add_hl_dd($dd)]);
		add($cpu, "dad $dd",	[add_hl_dd($dd)]);
		add($cpu, "dad $dd1",	[add_hl_dd($dd)]) if $dd ne $dd1;	
		
		if ($zilog || $rabbit) {
			for my $x (qw( ix iy )) {
				my $dd1 = $dd =~ s/hl/$x/r;
				add($cpu, "add $x, $dd1", [$V{$x}, add_hl_dd($dd)]);
			}
		}	
	}	

	if ($z80n) {
		add($cpu, "add hl, a",	[0xED, 0x31]);
		add($cpu, "add de, a",	[0xED, 0x32]);
		add($cpu, "add bc, a",	[0xED, 0x33]);
	}
	else {
		add($cpu, "add hl, a",	[call(), '@__z80asm__add_hl_a', '']);
		add($cpu, "add de, a",	[call(), '@__z80asm__add_de_a', '']);
		add($cpu, "add bc, a",	[call(), '@__z80asm__add_bc_a', '']);
	}
	
	if ($z80n) {
		add($cpu, "add hl, %m",	[0xED, 0x34, '%m', '%m']);
		add($cpu, "add de, %m",	[0xED, 0x35, '%m', '%m']);
		add($cpu, "add bc, %m",	[0xED, 0x36, '%m', '%m']);
	}
	else {
		add($cpu, "add hl, %m",	[push_dd('de')],				# push de
								[ld_dd_m('de'), '%m', '%m'],	# ld de,%m
								[add_hl_dd('de')],				# add hl,de
								[pop_dd('de')]);				# pop de

		add($cpu, "add de, %m",	[push_dd('hl')],				# push hl
								[ld_dd_m('hl'), '%m', '%m'],	# ld hl,%m
								[add_hl_dd('de')],				# add hl,de
								[ld_r_r('d', 'h')],				# ld de, hl											
								[ld_r_r('e', 'l')],
								[pop_dd('hl')]);				# pop hl

		add($cpu, "add bc, %m",	[push_dd('hl')],				# push hl
								[ld_dd_m('hl'), '%m', '%m'],	# ld hl,%m
								[add_hl_dd('bc')],				# add hl,bc
								[ld_r_r('b', 'h')],				# ld bc, hl											
								[ld_r_r('c', 'l')],
								[pop_dd('hl')]);				# pop hl
	}

	if ($rabbit) {
		add($cpu, "add sp, %s", [0x27, '%s']);
	}
	elsif ($gameboy) {
		add($cpu, "add sp, %s", [0xE8, '%s']);
	}

	# ADC
	for my $dd (qw( bc de hl sp )) {
		if ($intel || $gameboy) {
			add($cpu, "adc hl, $dd", [call(), '@__z80asm__adc_hl_'.$dd, '']);
		}
		else {
			add_x($cpu, "adc hl, $dd", [adc_hl_dd($dd)]);
		}
	}

	# SBC/SUB
	for my $dd (qw( bc de hl sp )) {
		if ($intel || $gameboy) {
			add($cpu, "sbc hl, $dd", [call(), '@__z80asm__sbc_hl_'.$dd, '']);
		}
		else {
			add_x($cpu, "sbc hl, $dd", [sbc_hl_dd($dd)]);
		}
		
        if ($i8085 && $dd eq 'bc') {
            # 8085 undocumented opcode: double subtract
            add($cpu, "dsub",			[0x08]);
            add($cpu, "sub hl, bc",		[0x08]);
        }
        else {
			add($cpu, "dsub",       [call(), '@__z80asm__sub_hl_'.$dd, '']) if $dd eq 'bc';
			add($cpu, "sub hl, $dd",[call(), '@__z80asm__sub_hl_'.$dd, '']);
        }
	}

	# AND
	if ($rabbit) {
		for ([hl => ()], [ix => 0xDD], [iy => 0xFD]) {
			my($dd, @pfx) = @$_;
			if ($dd eq 'hl') {
				add_x($cpu, "and $dd, de", 		[@pfx, 0xDC]);
			}
			else {
				add($cpu, "and $dd, de", 		[@pfx, 0xDC]);
			}
		}
	}

	# INC/DEC
	for my $dd (qw( bc de hl sp )) {
		add_x($cpu, "inc $dd", [inc_dd($dd)]);
		add_x($cpu, "dec $dd", [dec_dd($dd)]);
	}
	
	if ($zilog || $rabbit) {
		for my $x (qw( ix iy )) {
			add($cpu, "inc $x", [$V{$x}, inc_dd('hl')]);
			add($cpu, "dec $x", [$V{$x}, dec_dd('hl')]);
		}
	}				

	for my $dd (qw( bc de hl sp )) {
		my $dd1 = ($dd eq 'sp') ? $dd : substr($dd,0,1);		# B, D, H
		
		add($cpu, "inx $dd",	[inc_dd($dd)]);
		add($cpu, "inx $dd1",	[inc_dd($dd)]) if $dd ne $dd1;
		add($cpu, "dcx $dd",	[dec_dd($dd)]);
		add($cpu, "dcx $dd1",	[dec_dd($dd)]) if $dd ne $dd1;
	}

	# OR/BOOL
	if ($rabbit) {
		for ([hl => ()], [ix => 0xDD], [iy => 0xFD]) {
			my($dd, @pfx) = @$_;
			
			if ($dd eq 'hl') {
				add_x($cpu, "or $dd, de", 	[@pfx, 0xEC]);
				add_x($cpu, "bool $dd", 	[@pfx, 0xCC]);
			}
			else {
				add($cpu, "or $dd, de", 	[@pfx, 0xEC]);
				add($cpu, "bool $dd", 		[@pfx, 0xCC]);
			}
		}
	}

	# Multiply
	if ($z180) {
		for my $dd (qw( bc de hl sp )) {
			add($cpu, "mlt $dd", [0xED, 0x4C+16*$V{$dd}]);
		}
	}
	elsif ($z80n) {
		add($cpu, "mul d, e", [0xED, 0x30]);
		add($cpu, "mul de",   [0xED, 0x30]);
		add($cpu, "mlt de",   [0xED, 0x30]);
	}
	elsif ($rabbit) {
		add($cpu, "mul", [0xF7]);
	}
	else {}
	
	if ($r3k) {
		add($cpu, "uma", [0xED, 0xC0]);
		add($cpu, "ums", [0xED, 0xC8]);
	}
		
	#--------------------------------------------------------------------------
	# 8-bit rotate and shift group
	#--------------------------------------------------------------------------

	for my $op (qw( rlca rrca rla rra )) {
		add_x($cpu, $op, [rot_a($op)]);
	}

	for my $op (qw( rlc  rrc  ral rar )) {
		add($cpu, $op, [rot_a($op)]);
	}

	if (!$intel) {
		for (qw( rlc rrc rl rr sla sra sll sls sli srl )) {
			my $op = (/sll|sls|sli/ && $gameboy) ? 'swap' : $_;
			next if $op =~ /sll|sls|sli/ && !$z80;

			for my $r (qw( b c d e h l (hl) a )) {
				add_x($cpu, "$op $r", [0xCB, 8*$V{$op}+$V{$r}]) 
					unless $opcodes{"$op $r"}{$cpu};
				
				# (ix+d) -> r
				if ($z80 && $r ne '(hl)') {
					for my $x (qw( ix iy )) {
						add($cpu, "$op ($x+%d), $r", [$V{$x}, 0xCB, '%d', 8*$V{$op}+$V{$r}]);
					}
				}
			}
		}
	}

	if ($z80n) {
		add($cpu, "swapnib", 		[0xED, 0x23]);
		add($cpu, "swap a", 		[0xED, 0x23]);
		add($cpu, "swap",	 		[0xED, 0x23]);
		
		add($cpu, "mirror a", 		[0xED, 0x24]);
		add($cpu, "mirr a", 		[0xED, 0x24]);
	}
	
	#--------------------------------------------------------------------------
	# 16-bit rotate and shift group
	#--------------------------------------------------------------------------

    # sra bc/de
    if ($intel) {
        add($cpu, "sra bc",	[call(), '@__z80asm__sra_bc', '']);
        add($cpu, "sra de",	[call(), '@__z80asm__sra_de', '']);
    } 
    else {
        add($cpu, "sra bc",	[0xCB, 0x28], [0xCB, 0x19]);
        add($cpu, "sra de",	[0xCB, 0x2A], [0xCB, 0x1B]);
    }
    
    # sra hl (undocumented 8085)
    if ($i8085) {
        add($cpu, "arhl",	[0x10]);
        add($cpu, "rrhl",	[0x10]);
        add($cpu, "sra hl",	[0x10]);
    }
    elsif ($intel) {
        add($cpu, "arhl",	[call(), '@__z80asm__sra_hl', '']);
        add($cpu, "rrhl",	[call(), '@__z80asm__sra_hl', '']);
        add($cpu, "sra hl",	[call(), '@__z80asm__sra_hl', '']);
    } 
    else {
        add($cpu, "arhl",	[0xCB, 0x2C], [0xCB, 0x1D]);
        add($cpu, "rrhl",	[0xCB, 0x2C], [0xCB, 0x1D]);
        add($cpu, "sra hl",	[0xCB, 0x2C], [0xCB, 0x1D]);
    }
	
	# rl bc
    if ($intel) {
        add($cpu, "rl bc",	[call(), '@__z80asm__rl_bc', '']);
    }
    else {
        add($cpu, "rl bc",	[0xCB, 0x11], [0xCB, 0x10]);
    }
        
	# rl de
    if ($i8085) {                       # undocumented 8085
		add($cpu, "rdel",	[0x18]);
		add($cpu, "rlde",	[0x18]);
		add($cpu, "rl de",	[0x18]);
    }
    elsif ($intel) {
		add($cpu, "rdel",	[call(), '@__z80asm__rl_de', '']);
		add($cpu, "rlde",	[call(), '@__z80asm__rl_de', '']);
        add($cpu, "rl de",	[call(), '@__z80asm__rl_de', '']);
    }
    elsif ($rabbit) {
		add($cpu, "rdel",	[0xF3]);
		add($cpu, "rlde",	[0xF3]);
		add_x($cpu, "rl de",[0xF3]);
    }
    else {
        add($cpu, "rdel",	[0xCB, 0x13], [0xCB, 0x12]);
        add($cpu, "rlde",	[0xCB, 0x13], [0xCB, 0x12]);
        add($cpu, "rl de",	[0xCB, 0x13], [0xCB, 0x12]);
    }
    
    # rl hl
    if ($intel) {
        add($cpu, "rl hl",	[call(), '@__z80asm__rl_hl', '']);
    }
    else {
        add($cpu, "rl hl",	[0xCB, 0x15], [0xCB, 0x14]);
    }
        
	# rr bc
    if ($intel) {
        add($cpu, "rr bc",	[call(), '@__z80asm__rr_bc', '']);
    }
    else {
        add($cpu, "rr bc",	[0xCB, 0x18], [0xCB, 0x19]);
    }
        
    # rr de
    if ($rabbit) {
		add_x($cpu, "rr de",  [0xFB]);
    }
    elsif ($intel) {
        add($cpu, "rr de",	[call(), '@__z80asm__rr_de', '']);
    }
    else {
        add($cpu, "rr de",	[0xCB, 0x1A], [0xCB, 0x1B]);
    }
    
    # rr hl
	if ($rabbit) {
		for ([hl => ()], [ix => 0xDD], [iy => 0xFD]) {
			my($x, @pfx) = @$_;
			if ($x eq 'hl') {
				add_x($cpu, "rr $x", [@pfx, 0xFC]);
			}
			else {
				add($cpu, "rr $x", [@pfx, 0xFC]);
			}
		}
	}
    elsif ($intel) {
        add($cpu, "rr hl",	[call(), '@__z80asm__rr_hl', '']);
    }
    else {
        add($cpu, "rr hl",	[0xCB, 0x1C], [0xCB, 0x1D]);
    }
	
	# z80n
	if ($z80n) {
		add($cpu, "bsla de, b",		[0xED, 0x28]);
		add($cpu, "bsra de, b",		[0xED, 0x29]);
		add($cpu, "bsrl de, b",		[0xED, 0x2A]);
		add($cpu, "bsrf de, b",		[0xED, 0x2B]);
		add($cpu, "brlc de, b",		[0xED, 0x2C]);
	}
	
	#--------------------------------------------------------------------------
	# bit set, reset and test group
	#--------------------------------------------------------------------------

	if (!$intel) {
		for my $op (qw( bit res set )) {
			for my $r (qw( b c d e h l (hl) a )) {
				add_x($cpu, "$op %c, $r", 
					[0xCB, (0x40*$V{$op}+$V{$r})."+8*%c(0..7)"]);

				# (ix+d) -> r
				if ($z80 && $op ne 'bit' && $r ne '(hl)') {
					for my $x (qw( ix iy )) {
						add($cpu, "$op %c, ($x+%d), $r", 
							[$V{$x}, 0xCB, '%d', (0x40*$V{$op}+$V{$r})."+8*%c(0..7)"]);
					}
				}
			}
		}
	}
	
	#--------------------------------------------------------------------------
	# CPU control group
	#--------------------------------------------------------------------------

	add($cpu, "nop", [0]);
	
	if (!$rabbit) {
		add($cpu, "halt",	[0x76]);
		add($cpu, "hlt",	[0x76]);
	}
	
	add($cpu, "slp", 	[0xED, 0x76]) if $z180;
	add($cpu, "stop", 	[0x10, 0x00]) if $gameboy;
	
	if ($r3k) {
		add($cpu, "rdmode",  [0xED, 0x7F]);
		add($cpu, "setusr",  [0xED, 0x6F]);
		add($cpu, "sures", 	 [0xED, 0x7D]);
		add($cpu, "syscall", [0xED, 0x75]);
	}
	
	#--------------------------------------------------------------------------
	# Interrupt control group
	#--------------------------------------------------------------------------

	if (!$rabbit || $intel) {
		add($cpu, "di", [0xF3]);
		add($cpu, "ei", [0xFB]);
	}
	
	if ($zilog) {
		add($cpu, "im %c", [0xED, "%c(0..2)==0?0x46:%c==1?0x56:0x5E"]);

		add($cpu, "ld i, a", [0xED, 0x47]);
		add($cpu, "ld a, i", [0xED, 0x57]);
		add($cpu, "ld r, a", [0xED, 0x4F]);
		add($cpu, "ld a, r", [0xED, 0x5F]);
	}

	add($cpu, "rim", [0x20]) if $i8085;
	add($cpu, "sim", [0x30]) if $i8085;

	if ($rabbit) {
		add_x($cpu, "ld eir, a", [0xED, 0x47]);
		add_x($cpu, "ld a, eir", [0xED, 0x57]);
		add_x($cpu, "ld iir, a", [0xED, 0x4F]);
		add_x($cpu, "ld a, iir", [0xED, 0x5F]);
	
		add($cpu, "ipset %c", [0xED, "%c(0..3)==0?0x46:%c==1?0x56:%c==2?0x4E:0x5E"]);
		add($cpu, "ipres", 	  [0xED, 0x5D]);
	}

	if ($intel) {
	}
	elsif ($gameboy) {
		add($cpu, "reti", [0xD9]);
	}
	else {
		add($cpu, "reti", [0xED, 0x4D]);
	}
	
	add($cpu, "retn", [0xED, 0x45]) if $zilog;
	add($cpu, "idet", [0x5B]) if $r3k;

	#--------------------------------------------------------------------------
	# Jump and Call group
	#--------------------------------------------------------------------------

	# JR
	if ($intel) {
		add($cpu, "jr %j",	[jp(), '%m', '%m']);
		
		for my $_f (qw( _nz _z _nc _c )) { 
			my $f = substr($_f, 1);	# remove leading _
			
			add($cpu, "jr $f, %j",	[jp_f($_f), '%m', '%m']);
		}
	} 
	else {	
		add($cpu, "jr %j",	[jr(), '%j']);
		
		for my $_f (qw( _nz _z _nc _c )) { 
			my $f = substr($_f, 1);	# remove leading _
			
			add($cpu, "jr $f, %j",	[jr_f($_f), '%j']);
		}
	}

	# DJNZ
	# TODO: check that address is correctly computed in DJNZ B', LABEL - 76 10 FE or 76 10 FD
	if ($intel) {
		# Emulate with "DEB B / JP NZ, nn" on 8080/8085
		add($cpu, "djnz %j",	[dec_r('b')], [jp_f('_nz'), '%m', '%m']);
		add($cpu, "djnz b, %j",	[dec_r('b')], [jp_f('_nz'), '%m', '%m']);
	} 
	elsif ($gameboy) {
		# Emulate with "DEB B / JR NZ, nn" on GameBoy
		add($cpu, "djnz %j",	[dec_r('b')], [jr_f('_nz'), '%j']);
		add($cpu, "djnz b, %j",	[dec_r('b')], [jr_f('_nz'), '%j']);
	} 
	elsif ($rabbit) {
		add($cpu, "djnz %j", 		[djnz(), '%j']);
		add($cpu, "djnz b, %j", 	[djnz(), '%j']);
		add($cpu, "djnz b', %j",	[$V{altd}], [djnz(), '%j']);
		add($cpu, "altd djnz %j",	[$V{altd}], [djnz(), '%j']);
		add($cpu, "altd djnz b, %j",[$V{altd}], [djnz(), '%j']);
	}
	else {
		add($cpu, "djnz %j", 		[djnz(), '%j']);
		add($cpu, "djnz b, %j", 	[djnz(), '%j']);
	}
	
	# JP
	add($cpu, "jmp %m",	[jp(), '%m', '%m']);
	add($cpu, "jp %m",	[jp(), '%m', '%m']);

	for my $_f (qw( _nz _z _nc _c _po _pe _nv _v _lz _lo _p _m )) { 
		my $f = substr($_f, 1);			# remove leading _
		
		next if $f =~ /^(lz|lo)$/ && !$rabbit;
		next if $f !~ /^(nz|z|nc|c)$/ && $gameboy;
		
		# TODO: Rabbit LJP not supported
		add($cpu, "jp $f, %m",	[jp_f($_f), '%m', '%m']);
		add($cpu, "j$f %m", 	[jp_f($_f), '%m', '%m']) unless $f eq 'p';
		add($cpu, "j_$f %m", 	[jp_f($_f), '%m', '%m']);
	}
    
	add($cpu, "jp (hl)", 	[0xE9]);
	add($cpu, "pchl",		[0xE9]);
	
	if (!$intel && !$gameboy) {
		for my $x (qw( ix iy )) {
			add($cpu, "jp ($x)", [$V{$x}, 0xE9]);
		}
	} 

	add($cpu, "jp (bc)", [push_dd('bc')], [ret()]);
	add($cpu, "jp (de)", [push_dd('de')], [ret()]);
	
	if ($z80n) {
		add($cpu, "jp (c)",			[0xED, 0x98]);
	}
    
	# CALL
	add($cpu, "call %m", [call(), '%m', '%m']);
	
	for my $_f (qw( _nz _z _nc _c _po _pe _nv _v _lz _lo _p _m )) { 
		my $f = substr($_f, 1);			# remove leading _
		my $_inv_f = $INV_FLAG{$_f};	# inverted flag
		my $inv_f = substr($_inv_f, 1);	# remove leading _

		next if $f =~ /^(lz|lo)$/ && !$rabbit;
		next if $f !~ /^(nz|z|nc|c)$/ && $gameboy;
		
		# TODO: Rabbit LCALL not supported
		if ($rabbit) {
			if ($f =~ /^(nz|z|nc|c)$/) {
				add($cpu, "call $f, %m",[jr_f($_inv_f), 3],		# jump !flag
										[call(), '%m', '%m']);	# call 
				add($cpu, "c$f %m",		[jr_f($_inv_f), 3],		# jump !flag
										[call(), '%m', '%m'])	# call 
					unless $f eq 'p';
				add($cpu, "c_$f %m",	[jr_f($_inv_f), 3],		# jump !flag
										[call(), '%m', '%m']);	# call 
			}
			else {
				add($cpu, "call $f, %m",[jp_f($_inv_f), '%t', '%t'], # jump !flag
										[call(), '%m', '%m']);		 # call 
				add($cpu, "c$f %m",		[jp_f($_inv_f), '%t', '%t'], # jump !flag
										[call(), '%m', '%m'])		 # call 
					unless $f eq 'p';
				add($cpu, "c_$f %m",	[jp_f($_inv_f), '%t', '%t'], # jump !flag
										[call(), '%m', '%m']);		 # call 
			}			
		}
		else {
			add($cpu, "call $f, %m",	[call_f($_f), '%m', '%m']);
			add($cpu, "c$f %m", 		[call_f($_f), '%m', '%m']) 
				unless $f eq 'p';
			add($cpu, "c_$f %m", 		[call_f($_f), '%m', '%m']);
		}
	}
	
	# RST
	add($cpu, "rst %c", ["0xC7+%c"]);
	
	# RET
	add($cpu, "ret", [ret()]);
	
	for my $_f (qw( _nz _z _nc _c _po _pe _nv _v _lz _lo _p _m )) { 
		my $f = substr($_f, 1);			# remove leading _

		next if $f =~ /^(lz|lo)$/ && !$rabbit;
		next if $f !~ /^(nz|z|nc|c)$/ && $gameboy;
		
		add($cpu, "ret $f", [ret_f($_f)]);
		add($cpu, "r$f",	[ret_f($_f)]);
		add($cpu, "r_$f",	[ret_f($_f)]);
	}	

	if ($rabbit) {
		add_x($cpu, "ld xpc, a", [0xED, 0x67]);
		add_x($cpu, "ld a, xpc", [0xED, 0x77]);
	}

	if ($i8085) {
		# Restart 8 (0040) if V flag is set
		add($cpu, "rstv",		[0xCB]);
		add($cpu, "ovrst8",		[0xCB]);

		# Jump on flag X5/K is set
		add($cpu, "jx5 %m",		[0xFD, '%m', '%m']);
		add($cpu, "jp x5,%m",	[0xFD, '%m', '%m']);
		add($cpu, "jk %m",		[0xFD, '%m', '%m']);
		add($cpu, "jp k,%m",	[0xFD, '%m', '%m']);

		add($cpu, "jnx5 %m",	[0xDD, '%m', '%m']);
		add($cpu, "jp nx5,%m",	[0xDD, '%m', '%m']);
		add($cpu, "jnk %m",		[0xDD, '%m', '%m']);
		add($cpu, "jp nk,%m",	[0xDD, '%m', '%m']);
	}

	#--------------------------------------------------------------------------
	# Block transfer group
	#--------------------------------------------------------------------------

	if ($intel || $gameboy) {
		add($cpu, "ldi", 	[call(), '@__z80asm__ldi', '']);
		add($cpu, "ldir", 	[call(), '@__z80asm__ldir', '']);
		add($cpu, "ldd", 	[call(), '@__z80asm__ldd', '']);
		add($cpu, "lddr", 	[call(), '@__z80asm__lddr', '']);
	} 
	else {
		add_x($cpu, "ldi", 	[0xED, 0xA0]);
		add_x($cpu, "ldir", [0xED, 0xB0]);
		add_x($cpu, "ldd", 	[0xED, 0xA8]);
		add_x($cpu, "lddr", [0xED, 0xB8]);
	}

	if ($r3k) {
		add_x($cpu, "ldisr",[0xED, 0x90]);
		add_x($cpu, "lddsr",[0xED, 0x98]);
		
		add_x($cpu, "lsdr", [0xED, 0xF8]);
		add_x($cpu, "lsir", [0xED, 0xF0]);
		add_x($cpu, "lsddr",[0xED, 0xD8]);
		add_x($cpu, "lsidr",[0xED, 0xD0]);
	}

	if ($z80n) {
		add($cpu, "ldix",	[0xED, 0xA4]);
		add($cpu, "ldws",	[0xED, 0xA5]);
		add($cpu, "lddx",	[0xED, 0xAC]);
		add($cpu, "ldirx",	[0xED, 0xB4]);
		add($cpu, "lirx",	[0xED, 0xB4]);
		add($cpu, "ldpirx",	[0xED, 0xB7]);
		add($cpu, "lprx",	[0xED, 0xB7]);
		add($cpu, "lddrx",	[0xED, 0xBC]);
		add($cpu, "ldrx",	[0xED, 0xBC]);
	}

	#--------------------------------------------------------------------------
	# Search group
	#--------------------------------------------------------------------------

	if ($zilog) {
		add($cpu, "cpi", 	[0xED, 0xA1]);
		add($cpu, "cpir", 	[0xED, 0xB1]);
		add($cpu, "cpd", 	[0xED, 0xA9]);
		add($cpu, "cpdr", 	[0xED, 0xB9]);
	}
	else {
		add($cpu, "cpi", 	[call(), '@__z80asm__cpi', '']);
		add($cpu, "cpir", 	[call(), '@__z80asm__cpir', '']);
		add($cpu, "cpd", 	[call(), '@__z80asm__cpd', '']);
		add($cpu, "cpdr", 	[call(), '@__z80asm__cpdr', '']);
	}

	#--------------------------------------------------------------------------
	# Input and Output Group
	#--------------------------------------------------------------------------

	if ($intel) {
		add($cpu, "in a, (%n)", 		[0xDB, '%n']);
		add($cpu, "out (%n), a", 		[0xD3, '%n']);
	}		
	elsif ($zilog) {
		add($cpu, "in a, (%n)", 		[0xDB, '%n']);
		add($cpu, "in (c)", 			[0xED, 0x40+8*$V{f}]);
		add($cpu, "in0 (%n)", 			[0xED, 0x00+8*$V{f}, '%n']) if $z180;
		
		for my $r (qw( b c d e h l f a )) {
			add($cpu, "in $r, (c)", 	[0xED, 0x40+8*$V{$r}]);
			add($cpu, "in0 $r, (%n)", 	[0xED, 0x00+8*$V{$r}, '%n']) if $z180;
		}
		
		add($cpu, "out (%n), a", 		[0xD3, '%n']);
		add($cpu, "out (c), %c", 		[0xED, '0x41+%c(0..0)+6*8']);
		add($cpu, "out (c), f", 		[0xED, 0x71]);

		for my $r (qw( b c d e h l a )) {
			add($cpu, "out (c), $r", 	[0xED, 0x41+8*$V{$r}]);
			add($cpu, "out0 (%n), $r", 	[0xED, 0x01+8*$V{$r}, '%n']) if $z180;
		}
		
		add($cpu, "tstio %n", 			[0xED, 0x74, '%n']) if $z180;

		add($cpu, "ini", 	[0xED, 0xA2]);
		add($cpu, "inir", 	[0xED, 0xB2]);
		add($cpu, "ind", 	[0xED, 0xAA]);
		add($cpu, "indr", 	[0xED, 0xBA]);

		add($cpu, "outi", 	[0xED, 0xA3]);
		add($cpu, "otir", 	[0xED, 0xB3]);
		add($cpu, "outd", 	[0xED, 0xAB]);
		add($cpu, "otdr", 	[0xED, 0xBB]);

		if ($z180) {
			add($cpu, "otdm", 	[0xED, 0x8B]);
			add($cpu, "otdmr", 	[0xED, 0x9B]);
			add($cpu, "otim", 	[0xED, 0x83]);
			add($cpu, "otimr", 	[0xED, 0x93]);
		}
	}
	elsif ($gameboy) {
		add($cpu, "ldh (%h), a", [0xE0, '%h']);
		add($cpu, "ldh a, (%h)", [0xF0, '%h']);
	
		add($cpu, "ld (c), a",  [0xE2]);
		add($cpu, "ldh (c), a", [0xE2]);
		
		add($cpu, "ld a, (c)",  [0xF2]);
		add($cpu, "ldh a, (c)", [0xF2]);
	}
	else {
	}

	if (!$rabbit && !$gameboy) {
		add($cpu, "in %n",	[0xDB, '%n']);
		add($cpu, "out %n",	[0xD3, '%n']);
	}

	if ($z80n) {
		add($cpu, "outinb",			[0xED, 0x90]);
		add($cpu, "otib",			[0xED, 0x90]);
	}

	#--------------------------------------------------------------------------
	# Z80N opcodes for ZX Next
	#--------------------------------------------------------------------------

	if ($z80n) {
		add($cpu, "mmu %c, %n",		[0xED, 0x91, '0x50+%c(0..7)', '%n']);
		for my $page (0..7) {
			add($cpu, "mmu$page %n",[0xED, 0x91, 0x50+$page, '%n']);
		}

		add($cpu, "mmu %c, a",		[0xED, 0x92, '0x50+%c(0..7)']);
		for my $page (0..7) {
			add($cpu, "mmu$page a",	[0xED, 0x92, 0x50+$page]);
		}

		add($cpu, "nextreg %n, %n",	[0xED, 0x91, '%n', '%n']);
		add($cpu, "nreg %n, %n",	[0xED, 0x91, '%n', '%n']);
		
		add($cpu, "nextreg %n, a",	[0xED, 0x92, '%n']);
		add($cpu, "nreg %n, a",		[0xED, 0x92, '%n']);
		
		add($cpu, "pixeldn",		[0xED, 0x93]);
		add($cpu, "pxdn",			[0xED, 0x93]);
		
		add($cpu, "pixelad",		[0xED, 0x94]);
		add($cpu, "pxad",			[0xED, 0x94]);
		
		add($cpu, "setae",			[0xED, 0x95]);
		add($cpu, "stae",			[0xED, 0x95]);
	}
}

#------------------------------------------------------------------------------
# write file
#------------------------------------------------------------------------------
my $yaml = YAML::Tiny->new(\%opcodes);
$yaml->write("opcodes.yaml");

#------------------------------------------------------------------------------
# opcodes
#------------------------------------------------------------------------------
sub adc_hl_dd{my($dd) = @_;		return (0xED, 0x4A+16*$V{$dd}); }
sub add_hl_dd{my($dd) = @_;		return 0x09+16*$V{$dd}; }
sub alu_n 	{ my($op) = @_; 	return 0xC6+8*$V{$op}; }
sub alu_r 	{ my($op, $r) = @_; return 0x80+8*$V{$op}+$V{$r}; }
sub call	{					return 0xCD; }
sub call_f	{ my($_f) = @_;		return 0xC4+8*$V{$_f}; }
sub dec_dd	{ my($dd) = @_; 	return 0x0B+16*$V{$dd}; }
sub dec_r 	{ my($r) = @_; 		return 0x05+8*$V{$r}; }
sub djnz	{					return 0x10; }
sub ex_de_hl{					return 0xEB; }
sub inc_dd	{ my($dd) = @_; 	return 0x03+16*$V{$dd}; }
sub inc_r 	{ my($r) = @_; 		return 0x04+8*$V{$r}; }
sub jp		{					return 0xC3; }
sub jp_f	{ my($_f) = @_;		return 0xC2+8*$V{$_f}; }
sub jr		{					return 0x18; }
sub jr_f	{ my($_f) = @_;		return 0x20+8*$V{$_f}; }
sub ld_a_idd{ my($dd) = @_; 	return 0x0A+16*$V{$dd}; }
sub ld_dd_m { my($dd) = @_; 	return 0x01+16*$V{$dd}; }
sub ld_idd_a{ my($dd) = @_; 	return 0x02+16*$V{$dd}; }
sub ld_r_n 	{ my($r) = @_; 		return 0x06+8*$V{$r}; }
sub ld_r_r 	{ my($d, $s) = @_; 	return 0x40+8*$V{$d}+$V{$s}; }
sub ld_sp_hl{					return 0xF9; }
sub pop_dd	{ my($dd) = @_; 	return 0xC1+16*$V{$dd}; }
sub push_dd	{ my($dd) = @_; 	return 0xC5+16*$V{$dd}; }
sub ret		{					return 0xC9; }
sub ret_f	{ my($_f) = @_;		return 0xC0+8*$V{$_f}; }
sub rot_a	{ my($op) = @_;		return 0x07+8*$V{$op}; }
sub sbc_hl_dd{my($dd) = @_; 	return (0xED, 0x42+16*$V{$dd}); }

#------------------------------------------------------------------------------
# add opcode
#------------------------------------------------------------------------------
sub add {
	my($cpu, $asm, @ops) = @_;
	
	# convert (ix+d) to (ix) with offset 0
	if ($asm =~ /(ix|iy|hl)\+%d/) {
		(my $asm1 = $asm) =~ s/\+%d//;
		my @ops1 = @{clone(\@ops)};
		for (@ops1) { for (@$_) { s/^%d$/0/; } }
		add($cpu, $asm1, @ops1);
	}

	if (defined($opcodes{$asm}{$cpu})) {
		die "$asm $cpu exists";
	}
	$opcodes{$asm}{$cpu} = \@ops;
}

sub add_x {
	my($cpu, $asm, @ops) = @_;
	
	add_1($cpu, $asm, @{clone(\@ops)});
	
	my @bytes = @{$ops[0]};
	my @rest = @{clone([@ops[1..$#ops]])};
	
	# ixh
	if ($cpu =~ /^z80/ && $asm =~ /\b[hl]\b/ && 
		$asm !~ /\(hl|bit|res|set|rlc|rrc|rl|rr|sla|sra|sll|sls|srl|sli/) {
		for my $x (qw( ix iy )) {
			my $asm1 = $asm =~ s/\b([hl])\b/$x$1/gr;
			if ($asm ne $asm1) {
				add_1($cpu, $asm1, [$V{$x}, @bytes], @rest);
			}
		}
	}
	
	# (ix+d)
	if ($cpu =~ /^z|^r/ && $asm =~ /\(hl\)/ && $asm !~ /ldi|ldd/) {
		for my $x (qw( ix iy )) {
			my $asm1 = $asm =~ s/\(hl\)/($x+%d)/gr;
			if ($asm ne $asm1) {
				add_1($cpu, $asm1, 
					[$V{$x}, $bytes[0], '%d', @bytes[1..$#bytes]], @rest);
			}
		}
	}					
}

sub add_1 {
	my($cpu, $asm, @ops) = @_;
	
	add($cpu, $asm, @{clone(\@ops)});
	
	if ($cpu =~ /^r/) {
		# expand ioi ioe
		my $has_io;
		if (($asm =~ /\((ix|iy|hl|bc|de|%m)/ && $asm !~ /^(ldp|jp)/) ||
			($asm =~ /^(ldi|ldir|ldd|lddr|ldisr|lddsr|lsdr|lsir|lsddr|lsidr)$/)) {
			add($cpu, "ioi $asm", [$V{ioi}], @{clone(\@ops)});
			add($cpu, "ioe $asm", [$V{ioe}], @{clone(\@ops)});
			$has_io = 1;
		}

		# expand altd
		if ($asm =~ /^ (?| ( (?:ld|inc|dec|pop|bool) \s+ 
							 (?:a|b|c|d|e|h|l|af|bc|de|hl)) ( $ | \b [^'] .*)
						 | ( (?:rl|rr|rlc|rrc|sla|sra|sll|sls|sli|srl) \s+ 
							 (?:a|b|c|d|e|h|l)) ( $ | \b [^'] .*)
						 | ( (?:rr) \s+ (?:de|hl)) ( $ | \b [^'] .*)
						 | ( (?:rl) \s+ (?:de))    ( $ | \b [^'] .*)
						 | ( (?:add|adc|sub|sbc|and|xor|or|neg) \s+ a )(,.*)
						 | ( (?:rlca|rrca|rla|rra)) (.*)
						 | ( (?:res|set) \s+ %c \s* , \s* 
						     (?:a|b|c|d|e|h|l)) ( $ | \b [^'] .*)
						 | ( (?:add|adc|and|or|sbc) \s+ hl )
						   (, \s* (?:bc|de|hl|sp) )
					   ) $/x &&
			$asm !~ /^ ld \s+ (bc|de|hl) \s* , \s* (bc|de|hl) /x) {
			if ($has_io) {
				add($cpu, "$1'$2", 		[$V{altd}], @{clone(\@ops)});
				add($cpu, "ioi $1'$2", 	[$V{ioi}], [$V{altd}], @{clone(\@ops)});
				add($cpu, "ioe $1'$2", 	[$V{ioe}], [$V{altd}], @{clone(\@ops)});
				
				add($cpu, "altd $1$2", 		[$V{altd}], @{clone(\@ops)});
				add($cpu, "altd ioi $1$2", 	[$V{altd}], [$V{ioi}], @{clone(\@ops)});
				add($cpu, "altd ioe $1$2", 	[$V{altd}], [$V{ioe}], @{clone(\@ops)});
				add($cpu, "ioi altd $1$2", 	[$V{ioi}], [$V{altd}], @{clone(\@ops)});
				add($cpu, "ioe altd $1$2", 	[$V{ioe}], [$V{altd}], @{clone(\@ops)});
			}
			else {
				add($cpu, "$1'$2", 		[$V{altd}], @{clone(\@ops)});
				add($cpu, "altd $1$2", 	[$V{altd}], @{clone(\@ops)});
			}
		}
		elsif ($asm =~ /^ (?| ( (?:add|adc|sub|sbc|and|xor|or) \s+ [^,]+ )
							| ( (?:and|or) \s+ (ix|iy) \s* , .* )
							| ( (?:inc|dec) \s+ \( .* )
							| ( (?:bool|rr) \s+ (ix|iy) .* )
							| ( (?:cp|bit) \s+ .*) 
							| ( (?:rlc|rrc|rl|rr|sla|sra|sll|sls|sli|srl) \s+ \( .*)
						  ) $/x) {
			if ($has_io) {
				add($cpu, "altd $1", 		[$V{altd}], @{clone(\@ops)});
				add($cpu, "altd ioi $1", 	[$V{altd}], [$V{ioi}], @{clone(\@ops)});
				add($cpu, "altd ioe $1", 	[$V{altd}], [$V{ioe}], @{clone(\@ops)});
				add($cpu, "ioi altd $1", 	[$V{ioi}], [$V{altd}], @{clone(\@ops)});
				add($cpu, "ioe altd $1", 	[$V{ioe}], [$V{altd}], @{clone(\@ops)});
			}
			else {
				add($cpu, "altd $1", 	[$V{altd}], @{clone(\@ops)});
			}
		}
	}
}
