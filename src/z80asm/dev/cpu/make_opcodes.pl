#!/usr/bin/env perl

#------------------------------------------------------------------------------
# Build CPU tables
# asm placeholders:
#	%s	signed byte
#	%n	unsigned byte
#   %h  high page offset
#	%m	unsigned word - 16, 24 or 32 bits
#	%M	unsigned word, big-endian
#	%j	jr offset
#	%c	constant (im, bit, rst, ...)
#	%d	signed register indirect offset
#	%D	%d+1
#	%u	unsigned register indirect offset
#	%t	temp jump label to end of statement; %t3 to end of statement - 3
#------------------------------------------------------------------------------

use Modern::Perl;
use YAML::Tiny;
use Clone 'clone';
use warnings FATAL => 'uninitialized'; 
use Carp (); 
$SIG{__DIE__} = \&Carp::confess;
use Data::Dump 'dump';

@ARGV==1 or die "Usage: $0 output_file.yaml\n";
my $output_file = shift;

my @CPUS = qw( z80 z80_strict z80n z180 
			   ez80 ez80_z80 
			   r800 
			   r2ka r3k r4k r5k 
			   8080 8085 
			   gbz80 
			   kc160 kc160_z80
);

# %opcodes: $opcodes{$asm}{$cpu} = [[@bin],[@bin]]
my %opcodes;

# operand values
my %V = (
	b=>0, c=>1, d=>2, e=>3, h=>4, l=>5, '(hl)'=>6, f=>6, m=>6, a=>7,
	bc=>0, de=>1, hl=>2, sp=>3, af=>3,
	pw=>0, px=>1, py=>2, pz=>3,
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
	_ne=>0, _eq=>1, _geu=>2, _ltu=>3, _gtu=>undef, _leu=>undef,
	
	altd=>0x76, ioi=>0xD3, ioe=>0xDB, 
	
	const1_x=>0x40, const1_y=>0x49, const1_a=>0x52, const1_p=>0x5B, const1_z=>0x7F,
	const2_x=>0x40, const2_y=>0x49, const2_a=>0x52,                 const2_z=>0x7F,
);

my %INV_FLAG = qw(	_nz	 _z	  _z   _nz
					_nc  _c   _c   _nc
					_po  _pe  _pe  _po
					_nv  _v   _v   _nv
					_lz  _lo  _lo  _lz
					_p 	 _m	  _m   _p 
					_ne  _eq  _eq  _ne 
					_geu _ltu _ltu _geu 
					_gtu _leu _leu _gtu );

#------------------------------------------------------------------------------
# for each CPU
#------------------------------------------------------------------------------
for my $cpu (@CPUS) {
	my $rabbit		= ($cpu =~ /^r2ka|^r3k|^r4k|^r5k/);
	my $r3k			= ($cpu =~ /^r3k/);
	my $r4k			= ($cpu =~ /^r4k/);
	my $r5k			= ($cpu =~ /^r5k/);
	my $z80 		= ($cpu =~ /^z80$/);
	my $z80_strict	= ($cpu =~ /^z80_strict$/);
	my $r800		= ($cpu =~ /^r800/);
	my $z80n		= ($cpu =~ /^z80n/);
	my $z180 		= ($cpu =~ /^z180/);
	my $ez80_any 	= ($cpu =~ /^ez80/);
	my $ez80_z80	= ($cpu =~ /^ez80_z80/);
	my $ez80_adl	= ($cpu =~ /^ez80$/);
	my $zilog		= ($cpu =~ /^z|^ez|^r800/);
	my $i8080		= ($cpu =~ /^8080/);
	my $i8085		= ($cpu =~ /^8085/);
	my $intel 		= ($cpu =~ /^80/);
	my $gameboy		= ($cpu =~ /^gbz80/);
	my $kc160_any	= ($cpu =~ /^kc160/);
	my $kc160_ext	= ($cpu =~ /^kc160$/);
	my $kc160_z80	= ($cpu =~ /^kc160_z80/);

	#--------------------------------------------------------------------------
	# 8-bit load
	#--------------------------------------------------------------------------

	# LD r, r / LD r, (hl) / LD (hl), r
	for my $d (qw(     b c d e h l (hl) a )) { 
		for my $s (qw( b c d e h l (hl) a )) {
			next if $ez80_any && $d =~ /[bcde]/ && $s eq $d;
			next if $kc160_ext && $d eq $s;
			next if $d eq '(hl)' && $s eq '(hl)';

			if (($r4k || $r5k) && $d ne '(hl)' && $s ne '(hl)') {
				add_x($cpu, "ld $d, $s", [0x7F, ld_r_r($d, $s)]);
			}
			else {
				add_x($cpu, "ld $d, $s", [ld_r_r($d, $s)]);
			}
		}
	}
	
	# MOV r, r / MOV r, m / MOV m, r
	for my $d (qw(     b c d e h l m a )) {
		for my $s (qw( b c d e h l m a )) {
			next if $ez80_any && $d =~ /[bcde]/ && $s eq $d;
			next if $kc160_ext && $d eq $s;
			next if $d eq 'm' && $s eq 'm';

			if (($r4k || $r5k) && $d ne 'm' && $s ne 'm') {
				add($cpu, "mov $d, $s", [0x7F, ld_r_r($d, $s)]);
			}
			else {
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
	elsif ($ez80_z80) {
		add($cpu, "ld (%m), a",		[0x32, '%m', '%m']);
		add($cpu, "ld.il (%m), a",	[0x52], [0x32, '%m', '%m', '%m']);
		add($cpu, "ld.sil (%m), a",	[0x52], [0x32, '%m', '%m', '%m']);
		
		add($cpu, "ld a, (%m)",		[0x3A, '%m', '%m']);
		add($cpu, "ld.il a, (%m)",	[0x52], [0x3A, '%m', '%m', '%m']);
		add($cpu, "ld.sil a, (%m)",	[0x52], [0x3A, '%m', '%m', '%m']);
	}
	elsif ($ez80_adl) {
		add($cpu, "ld (%m), a",		[0x32, '%m', '%m', '%m']);
		add($cpu, "ld.is (%m), a",	[0x49], [0x32, '%m', '%m']);
		add($cpu, "ld.lis (%m), a",	[0x49], [0x32, '%m', '%m']);
		
		add($cpu, "ld a, (%m)",		[0x3A, '%m', '%m', '%m']);
		add($cpu, "ld.is a, (%m)",	[0x49], [0x3A, '%m', '%m']);
		add($cpu, "ld.lis a, (%m)",	[0x49], [0x3A, '%m', '%m']);
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
		for my $a_ ('a, ', '') {
			for my $r (qw( b c d e h l (hl) a )) {
				if ($r4k || $r5k) {
					add_x($cpu, "$op $a_$r", 	[0x7F, alu_r($op, $r)]);
				}
				else {
					add_x($cpu, "$op $a_$r", 	[alu_r($op, $r)]);
				}
			}
			
			if ($kc160_ext) {
				for my $p (qw( x y a p z )) {
					add($cpu, "$op $a_(${p}hl)",[$V{"const1_$p"}], 
												[alu_r($op, '(hl)')]);
					
					for my $x (qw( ix iy )) {
						add($cpu, "$op $a_(${p}${x}+%d)",
												[$V{"const1_$p"}], 
												[$V{$x}, alu_r($op, '(hl)'), '%d']);
					}
				}
			}
		}
		
		for my $a_ ('a, ', '') {
			add_x($cpu, "$op $a_%n", 	[alu_n($op), '%n']);
			if ($r4k || $r5k) {
				add_x($cpu, "$op $a_(hl+)",	[0x7F, alu_r($op, '(hl)')], [inc_dd('hl')]);
				add_x($cpu, "$op $a_(hl-)",	[0x7F, alu_r($op, '(hl)')], [dec_dd('hl')]);
			}
			else {
				add_x($cpu, "$op $a_(hl+)",	[alu_r($op, '(hl)')], [inc_dd('hl')]);
				add_x($cpu, "$op $a_(hl-)",	[alu_r($op, '(hl)')], [dec_dd('hl')]);
			}
		}
	}

	for my $op (qw( add adc sub sbb ana xra ora cmp )) {
		for my $r (qw( b c d e h l m a )) {
			if ($r4k || $r5k) {
				add($cpu, "$op $r", [0x7F, alu_r($op, $r)]) unless $opcodes{"$op $r"}{$cpu};
			}
			else {
				add($cpu, "$op $r", [alu_r($op, $r)]) unless $opcodes{"$op $r"}{$cpu};
			}
		}
	}

	for my $op (qw( adi aci sui sbi ani xri ori cpi )) {
		add($cpu, "$op %n", [alu_n($op), '%n']);
	}

	for my $r (qw( b c d e h l (hl) a )) { 
		add_x($cpu, "inc $r", [inc_r($r)]);
		add_x($cpu, "dec $r", [dec_r($r)]);
	}
	
	if ($kc160_ext) {
		for my $p (qw( x y a p z )) {
			add($cpu, "inc (${p}hl)",	[$V{"const1_$p"}], [inc_r('(hl)')]);
			add($cpu, "dec (${p}hl)",	[$V{"const1_$p"}], [dec_r('(hl)')]);
			
			for my $x (qw( ix iy )) {
				add($cpu, "inc (${p}${x}+%d)",
										[$V{"const1_$p"}], 
										[$V{$x}, inc_r('(hl)'), '%d']);
				add($cpu, "dec (${p}${x}+%d)",
										[$V{"const1_$p"}], 
										[$V{$x}, dec_r('(hl)'), '%d']);
			}
		}
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
				if ($z180 || $ez80_any) {
					add_suf($cpu, "$op $a_$r", [0xED, 0x04+8*$V{$r}]);
				}
			}
			if ($z180 || $ez80_any) {
				add($cpu, "$op $a_%n",  [0xED, 0x64, '%n']);
			}
			elsif ($z80n) {
				add($cpu, "$op $a_%n",  [0xED, 0x27, '%n']);
			}
		}
	}
	
	if ($intel || $zilog || $gameboy || $kc160_any) {
		add($cpu, "daa", [0x27]);
	}
	else {
		add($cpu, "daa", [call(), '@__z80asm__daa', '']);
	}
	
	if ($zilog || $kc160_any) {
		add($cpu, "rrd", [0xED, 0x67]);
		add($cpu, "rld", [0xED, 0x6F]);
	}
	else {
		add($cpu, "rrd", [call(), '@__z80asm__rrd', '']);
		add($cpu, "rld", [call(), '@__z80asm__rld', '']);
	}

	if ($kc160_ext) {
		for my $p (qw( x y a p z )) {
			add($cpu, "rrd (${p}hl)", [$V{"const1_$p"}], [0xED, 0x67]);
			add($cpu, "rld (${p}hl)", [$V{"const1_$p"}], [0xED, 0x6F]);
		}
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

	# LD (hl), bc/de/hl
	if ($ez80_any) {
		add_suf($cpu, "ld (hl), bc",  [0xED, 0x0F]);
		add_suf($cpu, "ld (hl+), bc", [0xED, 0x0F], [inc_dd('hl')], [inc_dd('hl')]);
		add_suf($cpu, "ldi (hl), bc", [0xED, 0x0F], [inc_dd('hl')], [inc_dd('hl')]);

		add_suf($cpu, "ld (hl), de",  [0xED, 0x1F]);
		add_suf($cpu, "ld (hl+), de", [0xED, 0x1F], [inc_dd('hl')], [inc_dd('hl')]);
		add_suf($cpu, "ldi (hl), de", [0xED, 0x1F], [inc_dd('hl')], [inc_dd('hl')]);

		add_suf($cpu, "ld (hl), hl",  [0xED, 0x2F]);
		add_suf($cpu, "ld (hl+), hl", [0xED, 0x2F], [inc_dd('hl')], [inc_dd('hl')]);
		add_suf($cpu, "ldi (hl), hl", [0xED, 0x2F], [inc_dd('hl')], [inc_dd('hl')]);
	}
	else {
		add($cpu, "ld (hl), bc",  [ld_r_r('(hl)', 'c')], [inc_dd('hl')], 
								  [ld_r_r('(hl)', 'b')], [dec_dd('hl')]);
		add($cpu, "ld (hl+), bc", [ld_r_r('(hl)', 'c')], [inc_dd('hl')], 
								  [ld_r_r('(hl)', 'b')], [inc_dd('hl')]);
		add($cpu, "ldi (hl), bc", [ld_r_r('(hl)', 'c')], [inc_dd('hl')], 
							      [ld_r_r('(hl)', 'b')], [inc_dd('hl')]);

		add($cpu, "ld (hl), de",  [ld_r_r('(hl)', 'e')], [inc_dd('hl')], 
								  [ld_r_r('(hl)', 'd')], [dec_dd('hl')]);
		add($cpu, "ld (hl+), de", [ld_r_r('(hl)', 'e')], [inc_dd('hl')], 
								  [ld_r_r('(hl)', 'd')], [inc_dd('hl')]);
		add($cpu, "ldi (hl), de", [ld_r_r('(hl)', 'e')], [inc_dd('hl')], 
								  [ld_r_r('(hl)', 'd')], [inc_dd('hl')]);

		if (!$rabbit) {
			add($cpu, "ld (hl), hl",  [push_dd('af')], 
									  [ld_r_r('a', 'h')], 
									  [ld_r_r('(hl)', 'l')], 
									  [inc_dd('hl')], 
									  [ld_r_r('(hl)', 'a')], 
									  [pop_dd('af')], 
									  [dec_dd('hl')]);
			add($cpu, "ld (hl+), hl", [push_dd('af')], 
									  [ld_r_r('a', 'h')], 
									  [ld_r_r('(hl)', 'l')], 
									  [inc_dd('hl')], 
									  [ld_r_r('(hl)', 'a')], 
									  [pop_dd('af')], 
									  [inc_dd('hl')]);
			add($cpu, "ldi (hl), hl", [push_dd('af')], 
									  [ld_r_r('a', 'h')], 
									  [ld_r_r('(hl)', 'l')], 
									  [inc_dd('hl')], 
									  [ld_r_r('(hl)', 'a')], 
									  [pop_dd('af')], 
									  [inc_dd('hl')]);
		}
	}
	
	# LD (hl), ix/iy
	if ($ez80_any) {
		add_suf($cpu, "ld (hl), ix",  [0xED, 0x3F]);
		add_suf($cpu, "ld (hl+), ix", [0xED, 0x3F], [inc_dd('hl')], [inc_dd('hl')]);
		add_suf($cpu, "ldi (hl), ix", [0xED, 0x3F], [inc_dd('hl')], [inc_dd('hl')]);

		add_suf($cpu, "ld (hl), iy",  [0xED, 0x3E]);
		add_suf($cpu, "ld (hl+), iy", [0xED, 0x3E], [inc_dd('hl')], [inc_dd('hl')]);
		add_suf($cpu, "ldi (hl), iy", [0xED, 0x3E], [inc_dd('hl')], [inc_dd('hl')]);

	}
	elsif ($zilog || $rabbit || $kc160_any) {
		for my $x (qw( ix iy )) {
			add($cpu, "ld (hl), $x",  	[push_dd('de')], 
										[$V{$x}, push_dd('hl')], [pop_dd('de')], 
										[ld_r_r('(hl)', 'e')], [inc_dd('hl')], 
										[ld_r_r('(hl)', 'd')], [dec_dd('hl')], 
										[pop_dd('de')]);
			add($cpu, "ld (hl+), $x", 	[push_dd('de')], 
										[$V{$x}, push_dd('hl')], [pop_dd('de')], 
										[ld_r_r('(hl)', 'e')], [inc_dd('hl')], 
										[ld_r_r('(hl)', 'd')], [inc_dd('hl')], 
										[pop_dd('de')]);
			add($cpu, "ldi (hl), $x", 	[push_dd('de')], 
										[$V{$x}, push_dd('hl')], [pop_dd('de')], 
										[ld_r_r('(hl)', 'e')], [inc_dd('hl')], 
										[ld_r_r('(hl)', 'd')], [inc_dd('hl')], 
										[pop_dd('de')]);
		}
	}
	
	# ld bc/de/hl, (hl)
	if ($ez80_any) {
		add_suf($cpu, "ld bc, (hl)",  [0xED, 0x07]);
		add_suf($cpu, "ld bc, (hl+)", [0xED, 0x07], [inc_dd('hl')], [inc_dd('hl')]);
		add_suf($cpu, "ldi bc, (hl)", [0xED, 0x07], [inc_dd('hl')], [inc_dd('hl')]);
		
		add_suf($cpu, "ld de, (hl)",  [0xED, 0x17]);
		add_suf($cpu, "ld de, (hl+)", [0xED, 0x17], [inc_dd('hl')], [inc_dd('hl')]);
		add_suf($cpu, "ldi de, (hl)", [0xED, 0x17], [inc_dd('hl')], [inc_dd('hl')]);
		
		add_suf($cpu, "ld hl, (hl)",  [0xED, 0x27]);
		add_suf($cpu, "ld hl, (hl+)", [0xED, 0x27], [inc_dd('hl')], [inc_dd('hl')]);
		add_suf($cpu, "ldi hl, (hl)", [0xED, 0x27], [inc_dd('hl')], [inc_dd('hl')]);
	}
	else {
		add($cpu, "ld bc, (hl)",  [ld_r_r('c', '(hl)')], [inc_dd('hl')], 
								  [ld_r_r('b', '(hl)')], [dec_dd('hl')]);
		add($cpu, "ld bc, (hl+)", [ld_r_r('c', '(hl)')], [inc_dd('hl')], 
								  [ld_r_r('b', '(hl)')], [inc_dd('hl')]);
		add($cpu, "ldi bc, (hl)", [ld_r_r('c', '(hl)')], [inc_dd('hl')], 
								  [ld_r_r('b', '(hl)')], [inc_dd('hl')]);
		
		add($cpu, "ld de, (hl)",  [ld_r_r('e', '(hl)')], [inc_dd('hl')], 
								  [ld_r_r('d', '(hl)')], [dec_dd('hl')]);
		add($cpu, "ld de, (hl+)", [ld_r_r('e', '(hl)')], [inc_dd('hl')], 
								  [ld_r_r('d', '(hl)')], [inc_dd('hl')]);
		add($cpu, "ldi de, (hl)", [ld_r_r('e', '(hl)')], [inc_dd('hl')], 
								  [ld_r_r('d', '(hl)')], [inc_dd('hl')]);
		
		if (!$rabbit) {
			add($cpu, "ld hl, (hl)",  [push_dd('af')], [ld_r_r('a', '(hl)')], [inc_dd('hl')], 
									  [ld_r_r('h', '(hl)')], [ld_r_r('l', 'a')], [pop_dd('af')]);
			add($cpu, "ld hl, (hl+)", [push_dd('af')], [ld_r_r('a', '(hl)')], [inc_dd('hl')], 
									  [ld_r_r('h', '(hl)')], [ld_r_r('l', 'a')], [pop_dd('af')]);
			add($cpu, "ldi hl, (hl)", [push_dd('af')], [ld_r_r('a', '(hl)')], [inc_dd('hl')], 
									  [ld_r_r('h', '(hl)')], [ld_r_r('l', 'a')], [pop_dd('af')]);
		}
	}
	
	# ld ix/iy, (hl)
	if ($ez80_any) {
		add_suf($cpu, "ld ix, (hl)",  [0xED, 0x37]);
		add_suf($cpu, "ld ix, (hl+)", [0xED, 0x37], [inc_dd('hl')], [inc_dd('hl')]);
		add_suf($cpu, "ldi ix, (hl)", [0xED, 0x37], [inc_dd('hl')], [inc_dd('hl')]);
		
		add_suf($cpu, "ld iy, (hl)",  [0xED, 0x31]);
		add_suf($cpu, "ld iy, (hl+)", [0xED, 0x31], [inc_dd('hl')], [inc_dd('hl')]);
		add_suf($cpu, "ldi iy, (hl)", [0xED, 0x31], [inc_dd('hl')], [inc_dd('hl')]);

	}
	elsif ($zilog || $rabbit || $kc160_any) {
		for my $x (qw( ix iy )) {
			add($cpu, "ld $x, (hl)",  	[push_dd('de')], 
										[ld_r_r('e', '(hl)')], [inc_dd('hl')], 
										[ld_r_r('d', '(hl)')], [dec_dd('hl')],
										[push_dd('de')], [$V{$x}, pop_dd('hl')],
										[pop_dd('de')]);
			add($cpu, "ld $x, (hl+)", 	[push_dd('de')], 
										[ld_r_r('e', '(hl)')], [inc_dd('hl')], 
										[ld_r_r('d', '(hl)')], [inc_dd('hl')],
										[push_dd('de')], [$V{$x}, pop_dd('hl')],
										[pop_dd('de')]);
			add($cpu, "ldi $x, (hl)", 	[push_dd('de')], 
										[ld_r_r('e', '(hl)')], [inc_dd('hl')], 
										[ld_r_r('d', '(hl)')], [inc_dd('hl')],
										[push_dd('de')], [$V{$x}, pop_dd('hl')],
										[pop_dd('de')]);
		}
	}
	
	# ld bc/de/hl/ix/iy, (ix/iy+d)
	if ($ez80_any) {
		add_suf($cpu, "ld ix, (ix+%d)", [0xDD, 0x37, '%d']);
		add_suf($cpu, "ld iy, (ix+%d)", [0xDD, 0x31, '%d']);
		add_suf($cpu, "ld ix, (iy+%d)", [0xFD, 0x31, '%d']);
		add_suf($cpu, "ld iy, (iy+%d)", [0xFD, 0x37, '%d']);

		add_suf($cpu, "ld bc, (ix+%d)", [0xDD, 0x07, '%d']);
		add_suf($cpu, "ld de, (ix+%d)", [0xDD, 0x17, '%d']);
		add_suf($cpu, "ld hl, (ix+%d)", [0xDD, 0x27, '%d']);

		add_suf($cpu, "ld bc, (iy+%d)", [0xFD, 0x07, '%d']);
		add_suf($cpu, "ld de, (iy+%d)", [0xFD, 0x17, '%d']);
		add_suf($cpu, "ld hl, (iy+%d)", [0xFD, 0x27, '%d']);
	}
	elsif ($kc160_any) {
		add($cpu, "ld ix, (ix+%d)", 	[0xED, 0x89, '%d']);
		add($cpu, "ld ix, (iy+%d)", 	[0xED, 0x88, '%d']);
		add($cpu, "ld iy, (ix+%d)", 	[0xED, 0x99, '%d']);
		add($cpu, "ld iy, (iy+%d)", 	[0xED, 0x98, '%d']);
	
		for my $dd (qw( bc de hl sp )) {
			add($cpu, "ld $dd, (ix+%d)",[0xED, 0x8D+16*$V{$dd}, '%d']);
			add($cpu, "ld $dd, (iy+%d)",[0xED, 0x8C+16*$V{$dd}, '%d']);
		}
	}
	elsif ($zilog || $rabbit) {
		for my $x (qw( ix iy )) {
			add($cpu, "ld bc, ($x+%d)", [$V{$x}, ld_r_r('c', '(hl)'), '%d'],
										[$V{$x}, ld_r_r('b', '(hl)'), '%D']);
			add($cpu, "ld de, ($x+%d)", [$V{$x}, ld_r_r('e', '(hl)'), '%d'],
										[$V{$x}, ld_r_r('d', '(hl)'), '%D']);
			if ($zilog || $kc160_any) {
				add($cpu, "ld hl, ($x+%d)", [$V{$x}, ld_r_r('l', '(hl)'), '%d'],
											[$V{$x}, ld_r_r('h', '(hl)'), '%D']);
			}
			
			for my $x1 (qw( ix iy )) {
				add($cpu, "ld $x1, ($x+%d)",[$V{$x1}, push_dd('hl')],
											[$rabbit ? (0xED, 0x54) : (0xE3)],
											[$V{$x}, ld_r_r('l', '(hl)'), '%d'],
											[$V{$x}, ld_r_r('h', '(hl)'), '%D'],
											[$rabbit ? (0xED, 0x54) : (0xE3)],
											[$V{$x1}, pop_dd('hl')]);
			}
		}
	}
	
	# ld (ix/iy+d), bc/de/hl/ix/iy
	if ($ez80_any) {
		add_suf($cpu, "ld (ix+%d), ix", [0xDD, 0x3F, '%d']);
		add_suf($cpu, "ld (ix+%d), iy", [0xDD, 0x3E, '%d']);
		add_suf($cpu, "ld (iy+%d), ix", [0xFD, 0x3E, '%d']);
		add_suf($cpu, "ld (iy+%d), iy", [0xFD, 0x3F, '%d']);

		add_suf($cpu, "ld (ix+%d), bc", [0xDD, 0x0F, '%d']);
		add_suf($cpu, "ld (ix+%d), de", [0xDD, 0x1F, '%d']);
		add_suf($cpu, "ld (ix+%d), hl", [0xDD, 0x2F, '%d']);

		add_suf($cpu, "ld (iy+%d), bc", [0xFD, 0x0F, '%d']);
		add_suf($cpu, "ld (iy+%d), de", [0xFD, 0x1F, '%d']);
		add_suf($cpu, "ld (iy+%d), hl", [0xFD, 0x2F, '%d']);
	}
	elsif ($kc160_any) {
		add($cpu, "ld (ix+%d), ix", 	[0xED, 0x81, '%d']);
		add($cpu, "ld (iy+%d), ix", 	[0xED, 0x80, '%d']);
	
		add($cpu, "ld (ix+%d), iy", 	[0xED, 0x91, '%d']);
		add($cpu, "ld (iy+%d), iy", 	[0xED, 0x90, '%d']);
	
		for my $dd (qw( bc de hl sp )) {
			add($cpu, "ld (ix+%d), $dd",[0xED, 0x85+16*$V{$dd}, '%d']);
			add($cpu, "ld (iy+%d), $dd",[0xED, 0x84+16*$V{$dd}, '%d']);
		}
	}
	elsif ($zilog || $rabbit | $kc160_z80) {
		for my $x (qw( ix iy )) {
			add($cpu, "ld ($x+%d), bc", [$V{$x}, ld_r_r('(hl)', 'c'), '%d'],
										[$V{$x}, ld_r_r('(hl)', 'b'), '%D']);
			add($cpu, "ld ($x+%d), de", [$V{$x}, ld_r_r('(hl)', 'e'), '%d'],
										[$V{$x}, ld_r_r('(hl)', 'd'), '%D']);
			if (!$rabbit) {
				add($cpu, "ld ($x+%d), hl", [$V{$x}, ld_r_r('(hl)', 'l'), '%d'],
											[$V{$x}, ld_r_r('(hl)', 'h'), '%D']);
			}
			
			for my $x1 (qw( ix iy )) {
				add($cpu, "ld ($x+%d), $x1",[$V{$x1}, push_dd('hl')],
											[$rabbit ? (0xED, 0x54) : (0xE3)],
											[$V{$x}, ld_r_r('(hl)', 'l'), '%d'],
											[$V{$x}, ld_r_r('(hl)', 'h'), '%D'],
											[$rabbit ? (0xED, 0x54) : (0xE3)],
											[$V{$x1}, pop_dd('hl')]);
			}
		}
	}
	
	
	# LD dd, NN
	for my $dd (qw( bc de hl sp )) {
		my $d = ($dd eq 'sp') ? $dd : substr($dd,0,1);		# B, D, H

		if ($ez80_z80) {
			add($cpu, "ld $dd, %m", [ld_dd_m($dd), '%m', '%m']);
			add($cpu, "ld.lil $dd, %m", [0x5B], [ld_dd_m($dd), '%m', '%m', '%m']);
		}
		elsif ($ez80_adl) {
			add($cpu, "ld $dd, %m", [ld_dd_m($dd), '%m', '%m', '%m']);
			add($cpu, "ld.sis $dd, %m", [0x40], [ld_dd_m($dd), '%m', '%m']);
		}
		else {
			add_x($cpu, "ld $dd, %m",  [ld_dd_m($dd), '%m', '%m']);
		}
		
		# #2423 There is an option to load a 2 bytes into an ez80 24 bit register 
		# using the ld.lis opcode
		if ($ez80_any) {
			add($cpu, "ld.lis $dd, %m", [0x49], [ld_dd_m($dd), '%m', '%m']);
		}
		
		add($cpu, "lxi $dd, %m", [ld_dd_m($dd), '%m', '%m']);
		add($cpu, "lxi $d, %m",	 [ld_dd_m($dd), '%m', '%m']) if $d ne $dd;
		
		if (($zilog || $rabbit || $kc160_any) && $dd eq 'hl') {
			for my $x (qw( ix iy )) {
				if ($ez80_z80) {
					add($cpu, "ld $x, %m", [$V{$x}, 0x21, '%m', '%m']);
					add($cpu, "ld.lil $x, %m", [0x5B], [$V{$x}, 0x21, '%m', '%m', '%m']);
				}
				elsif ($ez80_adl) {
					add($cpu, "ld $x, %m", [$V{$x}, 0x21, '%m', '%m', '%m']);
					add($cpu, "ld.sis $x, %m", [0x40], [$V{$x}, 0x21, '%m', '%m']);
				}
				else {
					add_x($cpu, "ld $x, %m", [$V{$x}, ld_dd_m($dd), '%m', '%m']);
				}
			}
		}
	}
	
	# LD (NN), hl
	if ($ez80_z80) {
		for my $opcode ("ld (%m), hl", "shld %m") {
			add($cpu, $opcode,	[0x22, '%m', '%m']);
		}	
		add($cpu, "ld.lil (%m), hl", [0x5B], [0x22, '%m', '%m', '%m']);
	}
	elsif ($ez80_adl) {
		add($cpu, "ld (%m), hl", 	[0x22, '%m', '%m', '%m']);
		add($cpu, "ld.sis (%m), hl", [0x40], [0x22, '%m', '%m']);
	}
	elsif ($gameboy) {
		for my $opcode ("ld (%m), hl", "shld %m") {
			add($cpu, $opcode, 	[push_dd('de')],			# save DE
								[push_dd('hl')],			# save HL
								[ld_r_r('d','h')],
								[ld_r_r('e','l')],			# DE=word to store
								[0x21, '%m', '%m'],			# HL=address to store
								[ld_r_r('(hl)','e')],
								[inc_dd('hl')],
								[ld_r_r('(hl)','d')],
								[pop_dd('hl')],				# restore HL
								[pop_dd('de')]);			# restore DE
		}						
	}
	else {
		add_x($cpu, "ld (%m), hl", 	[0x22, '%m', '%m']);
		add($cpu, "shld %m",		[0x22, '%m', '%m']);
	}

	# LD hl, (NN)
	if ($ez80_z80) {
		for my $opcode ("ld hl, (%m)", "lhld %m") {
			add($cpu, $opcode,	[0x2A, '%m', '%m']);
		}	
		add($cpu, "ld.lil hl, (%m)", [0x5B], [0x2A, '%m', '%m', '%m']);
	}
	elsif ($ez80_adl) {
		add($cpu, "ld hl, (%m)", [0x2A, '%m', '%m', '%m']);
		add($cpu, "ld.sis hl, (%m)", [0x40], [0x2A, '%m', '%m']);
	}
	elsif ($gameboy) {
		for my $opcode ("ld hl, (%m)", "lhld %m") {
			add($cpu, $opcode,	[push_dd('de')],			# save DE
								[0x21, '%m', '%m'],			# HL=address to fetch
								[ld_r_r('e','(hl)')],
								[inc_dd('hl')],
								[ld_r_r('d','(hl)')],		# DE=word fetched
								[ld_r_r('h','d')],
								[ld_r_r('l','e')],			# HL=word fetched
								[pop_dd('de')]);			# restore DE
		}						
	}
	else {
		add_x($cpu, "ld hl, (%m)", 	[0x2A, '%m', '%m']);
		add($cpu, "lhld %m",		[0x2A, '%m', '%m']);
	}

	# LD dd, (NN) / LD (NN), dd
	if (!$gameboy) {
		for my $r (qw( bc de hl sp )) {
			if ($r eq 'hl') {
				if (!$intel) {
					for my $x (qw( ix iy )) {
						if ($ez80_z80) {
							add($cpu, "ld $x, (%m)", [$V{$x}, 0x2A, '%m', '%m']);
							add($cpu, "ld.lil $x, (%m)", [0x5B], [$V{$x}, 0x2A, '%m', '%m', '%m']);

							add($cpu, "ld (%m), $x", [$V{$x}, 0x22, '%m', '%m']);
							add($cpu, "ld.lil (%m), $x", [0x5B], [$V{$x}, 0x22, '%m', '%m', '%m']);
						}
						elsif ($ez80_adl) {
							add($cpu, "ld $x, (%m)", [$V{$x}, 0x2A, '%m', '%m', '%m']);
							add($cpu, "ld.sis $x, (%m)", [0x40], [$V{$x}, 0x2A, '%m', '%m']);

							add($cpu, "ld (%m), $x", [$V{$x}, 0x22, '%m', '%m', '%m']);
							add($cpu, "ld.sis (%m), $x", [0x40], [$V{$x}, 0x22, '%m', '%m']);
						}
						else {
							add_x($cpu, "ld $x, (%m)", [$V{$x}, 0x2A, '%m', '%m']);
							add_x($cpu, "ld (%m), $x", [$V{$x}, 0x22, '%m', '%m']);
						}
					}
				}
			}
			else {
				if ($intel) {
					if ($r eq 'de') {
						# gbz80 lacks the ld hl,(**) and ld (**),hl
						add($cpu, "ld $r, (%m)", [ex_de_hl()], [0x2A, '%m', '%m'], [ex_de_hl()]);
					}
				}
				else {
					if ($ez80_z80) {
						add($cpu, "ld $r, (%m)", [0xED, 0x4B+$V{$r}*16, '%m', '%m']);
						add($cpu, "ld.lil $r, (%m)", [0x5B], [0xED, 0x4B+$V{$r}*16, '%m', '%m', '%m']);

						add($cpu, "ld (%m), $r", [0xED, 0x43+$V{$r}*16, '%m', '%m']);
						add($cpu, "ld.lil (%m), $r", [0x5B], [0xED, 0x43+$V{$r}*16, '%m', '%m', '%m']);
					}
					elsif ($ez80_adl) {
						add($cpu, "ld $r, (%m)", [0xED, 0x4B+$V{$r}*16, '%m', '%m', '%m']);
						add($cpu, "ld.sis $r, (%m)", [0x40], [0xED, 0x4B+$V{$r}*16, '%m', '%m']);

						add($cpu, "ld (%m), $r", [0xED, 0x43+$V{$r}*16, '%m', '%m', '%m']);
						add($cpu, "ld.sis (%m), $r", [0x40], [0xED, 0x43+$V{$r}*16, '%m', '%m']);
					}
					else {
						add_x($cpu, "ld $r, (%m)", [0xED, 0x4B+$V{$r}*16, '%m', '%m']);
						add_x($cpu, "ld (%m), $r", [0xED, 0x43+$V{$r}*16, '%m', '%m']);
					}
				}
			}
		}
	}

	# ld (%m), bc
	if ($intel) {
		add($cpu, "ld (%m), bc",	[push_dd('af')],
									[ld_r_r('a','c')],
									[0x32, '%m', '%m'],		# ld (%m), a
									[ld_r_r('a','b')],
									[0x32, '%m1', '%m1'],	# ld (%m+1), a
									[pop_dd('af')]);
	}
	elsif ($gameboy) {
		add($cpu, "ld (%m), bc",	[push_dd('af')],
									[ld_r_r('a','c')],
									[0xEA, '%m', '%m'],		# ld (%m), a
									[ld_r_r('a','b')],
									[0xEA, '%m1', '%m1'],	# ld (%m+1), a
									[pop_dd('af')]);
	}

	# ld (%m), de
	if ($intel) {
		add($cpu, "ld (%m), de", 	[ex_de_hl()], 
									[0x22, '%m', '%m'],		# ld (%m), hl
									[ex_de_hl()]);
	}
	elsif ($gameboy) {
		add($cpu, "ld (%m), de",	[push_dd('af')],
									[ld_r_r('a','e')],
									[0xEA, '%m', '%m'],		# ld (%m), a
									[ld_r_r('a','d')],
									[0xEA, '%m1', '%m1'],	# ld (%m+1), a
									[pop_dd('af')]);
	}

	# ld (%m), sp
	if ($intel) {
		add($cpu, "ld (%m), sp", 	[push_dd('hl')],
									[ld_dd_m('hl'), 2, 0],	# compensate for push hl
									[add_hl_dd('sp')],		# hl=sp
									[0x22, '%m', '%m'],		# ld (%m), hl
									[pop_dd('hl')]);
	}
	elsif ($gameboy) {
		add($cpu, "ld (%m), sp", 	[0x08, '%m', '%m']);
	}
	
	# LD BC, DE
	if ($r4k || $r5k) {
		add($cpu, "ld bc, de", [0x7F, ld_r_r('b', 'd')], [0x7F, ld_r_r('c', 'e')]);
	}
	else {
		add($cpu, "ld bc, de", [ld_r_r('b', 'd')], [ld_r_r('c', 'e')]);
	}
	
	# LD BC, HL	
	if ($r4k || $r5k) {
		add($cpu, "ld bc, hl", 		[0x91]);
		add($cpu, "altd ld bc, hl", [$V{altd}], [0x91]);
		add($cpu, "ld bc', hl", 	[$V{altd}], [0x91]);
	}
	elsif ($rabbit) {
		add($cpu, "ld bc, hl", 		[ld_r_r('b', 'h')], 
									[ld_r_r('c', 'l')]);
		add($cpu, "altd ld bc, hl", [$V{altd}], [ld_r_r('b', 'h')], 
									[$V{altd}], [ld_r_r('c', 'l')]);
		add($cpu, "ld bc', hl", 	[$V{altd}], [ld_r_r('b', 'h')], 
									[$V{altd}], [ld_r_r('c', 'l')]);
	}
	else {
		add($cpu, "ld bc, hl", [ld_r_r('b', 'h')], [ld_r_r('c', 'l')]);
	}
	
	# LD BC, IXY
	if ($z80 || $z80n || $ez80_any || $r800) {
		add($cpu, "ld bc, ix", [$V{ix}, ld_r_r('b', 'h')], [$V{ix}, ld_r_r('c', 'l')]);
		add($cpu, "ld bc, iy", [$V{iy}, ld_r_r('b', 'h')], [$V{iy}, ld_r_r('c', 'l')]);
	}
	elsif (!$intel && !$gameboy) {
		add($cpu, "ld bc, ix", [$V{ix}, push_dd('hl')], [pop_dd('bc')]);
		add($cpu, "ld bc, iy", [$V{iy}, push_dd('hl')], [pop_dd('bc')]);
	}		
	
	# LD DE, BC
	if ($r4k || $r5k) {
		add($cpu, "ld de, bc", [0x7F, ld_r_r('d', 'b')], [0x7F, ld_r_r('e', 'c')]);
	}
	else {
		add($cpu, "ld de, bc", [ld_r_r('d', 'b')], [ld_r_r('e', 'c')]);
	}

	# LD DE, HL
	if ($r4k || $r5k) {
		add($cpu, "ld de, hl", 		[0xB1]);
		add($cpu, "altd ld de, hl",	[$V{altd}], [0xB1]);
		add($cpu, "ld de', hl", 	[$V{altd}], [0xB1]);
	}
	elsif ($rabbit) {
		add($cpu, "ld de, hl", 		[ld_r_r('d', 'h')], 
									[ld_r_r('e', 'l')]);
		add($cpu, "altd ld de, hl", [$V{altd}], [ld_r_r('d', 'h')], 
									[$V{altd}], [ld_r_r('e', 'l')]);
		add($cpu, "ld de', hl", 	[$V{altd}], [ld_r_r('d', 'h')], 
									[$V{altd}], [ld_r_r('e', 'l')]);
	}
	else {
	    # this 8085 instruction is slower, thanks @feilipu
	    # add($cpu, "ld de, hl",	0x28, 0);       						# 10 T
		add($cpu, "ld de, hl", 	[ld_r_r('d', 'h')], [ld_r_r('e', 'l')]);	#  8 T
	}

	# LD DE, HL+u
	if ($i8085) {
		# Add 00bb immediate to HL, result to DE (undocumented i8085)
		add($cpu, "ldhi %n",		[0x28, '%n']);
		add($cpu, "adi hl, %n",		[0x28, '%n']);
		add($cpu, "ld de, hl+%u",	[0x28, '%u']);
	}
	elsif ($gameboy) {
		add($cpu, "ld de, hl+%u",	[push_dd('hl')],
									[ld_dd_m('de'), '%u', 0],
									[add_hl_dd('de')],
									[push_dd('hl')], [push_dd('de')],
									[pop_dd('hl')], [pop_dd('de')],
									[pop_dd('hl')]);
	}
	else {
		add($cpu, "ld de, hl+%u",	[push_dd('hl')],
									[ld_dd_m('de'), '%u', 0],
									[add_hl_dd('de')],
									[ex_de_hl()],
									[pop_dd('hl')]);
	}
    
    # LD DE, IXY
	if ($z80 || $z80n || $ez80_any || $r800) {
		add($cpu, "ld de, ix", [$V{ix}, ld_r_r('d', 'h')], [$V{ix}, ld_r_r('e', 'l')]);
		add($cpu, "ld de, iy", [$V{iy}, ld_r_r('d', 'h')], [$V{iy}, ld_r_r('e', 'l')]);
	}
	elsif (!$intel && !$gameboy) {
		add($cpu, "ld de, ix", [$V{ix}, push_dd('hl')], [pop_dd('de')]);
		add($cpu, "ld de, iy", [$V{iy}, push_dd('hl')], [pop_dd('de')]);
	}
	
	# LD HL, BC
	if ($r4k || $r5k) {
		add($cpu, "ld hl, bc", 		[0x81]);
		add($cpu, "altd ld hl, bc",	[$V{altd}], [0x81]);
		add($cpu, "ld hl', bc", 	[$V{altd}], [0x81]);
	}
	elsif ($rabbit) {
		add($cpu, "ld hl, bc", 		[ld_r_r('h', 'b')], 
									[ld_r_r('l', 'c')]);
		add($cpu, "ld hl', bc",		[0xED, 0x69]);
		add($cpu, "altd ld hl, bc",	[0xED, 0x69]);
	}
	else {
		add($cpu, "ld hl, bc", [ld_r_r('h', 'b')], [ld_r_r('l', 'c')]);
	}
	
	# LD HL, DE
	if ($r4k || $r5k) {
		add($cpu, "ld hl, de", 		[0xA1]);
		add($cpu, "altd ld hl, de",	[$V{altd}], [0xA1]);
		add($cpu, "ld hl', de", 	[$V{altd}], [0xA1]);
	}
	elsif ($rabbit) {
		add($cpu, "ld hl, de", 		[ld_r_r('h', 'd')], 
									[ld_r_r('l', 'e')]);
		add($cpu, "ld hl', de",		[0xED, 0x61]);
		add($cpu, "altd ld hl, de",	[0xED, 0x61]);
	}
	else {
		add($cpu, "ld hl, de", [ld_r_r('h', 'd')], [ld_r_r('l', 'e')]);
	}

	# LD HL, IXY
	if ($rabbit) {
		for my $x (qw( ix iy )) {
			add_x($cpu, "ld hl, $x", [$V{$x}, 0x7C]);
		}
	}
	elsif (!$intel && !$gameboy) {
		add($cpu, "ld hl, ix", [$V{ix}, push_dd('hl')], [pop_dd('hl')]);
		add($cpu, "ld hl, iy", [$V{iy}, push_dd('hl')], [pop_dd('hl')]);
	}
	
	# LD IXY, BC
	if ($z80 || $z80n || $ez80_any || $r800) {
		add($cpu, "ld ix, bc", [$V{ix}, ld_r_r('h', 'b')], [$V{ix}, ld_r_r('l', 'c')]);
		add($cpu, "ld iy, bc", [$V{iy}, ld_r_r('h', 'b')], [$V{iy}, ld_r_r('l', 'c')]);
	}
	elsif (!$intel && !$gameboy) {
		add($cpu, "ld ix, bc", [push_dd('bc')], [$V{ix}, pop_dd('hl')]);
		add($cpu, "ld iy, bc", [push_dd('bc')], [$V{iy}, pop_dd('hl')]);
	}
	
	# LD IXY, DE
	if ($z80 || $z80n || $ez80_any || $r800) {
		add($cpu, "ld ix, de", [$V{ix}, ld_r_r('h', 'd')], [$V{ix}, ld_r_r('l', 'e')]);
		add($cpu, "ld iy, de", [$V{iy}, ld_r_r('h', 'd')], [$V{iy}, ld_r_r('l', 'e')]);
	}
	elsif (!$intel && !$gameboy) {
		add($cpu, "ld ix, de", [push_dd('de')], [$V{ix}, pop_dd('hl')]);
		add($cpu, "ld iy, de", [push_dd('de')], [$V{iy}, pop_dd('hl')]);
	}
	
	# LD IXY, HL
	if ($rabbit) {
		for my $x (qw( ix iy )) {
			add_x($cpu, "ld $x, hl", [$V{$x}, 0x7D]);
		}
	}
	elsif (!$intel && !$gameboy) {
		add($cpu, "ld ix, hl", [push_dd('hl')], [$V{ix}, pop_dd('hl')]);
		add($cpu, "ld iy, hl", [push_dd('hl')], [$V{iy}, pop_dd('hl')]);
	}
	
	# LD IXY, IXY
	if (!$intel && !$gameboy) {
		add($cpu, "ld ix, iy", [$V{iy}, push_dd('hl')], [$V{ix}, pop_dd('hl')]);
		add($cpu, "ld iy, ix", [$V{ix}, push_dd('hl')], [$V{iy}, pop_dd('hl')]);
	}

	add_suf($cpu, "ld sp, hl", 	[ld_sp_hl()]);
	add($cpu, "sphl",			[ld_sp_hl()]);

	if (!$intel && !$gameboy) {
		for my $x (qw( ix iy )) {
			add_suf($cpu, "ld sp, $x", [$V{$x}, ld_sp_hl()]);
		}
	}
	
	# LD dd', BC
	if ($rabbit) {
		add($cpu, "ld bc', bc",		[0xED, 0x49]);
		add($cpu, "altd ld bc, bc",	[0xED, 0x49]);
		
		add($cpu, "ld de', bc",		[0xED, 0x59]);
		add($cpu, "altd ld de, bc",	[0xED, 0x59]);
	}
	
	# LD dd', DE
	if ($rabbit) {
		add($cpu, "ld bc', de",		[0xED, 0x41]);
		add($cpu, "altd ld bc, de",	[0xED, 0x41]);
		
		add($cpu, "ld de', de",		[0xED, 0x51]);
		add($cpu, "altd ld de, de",	[0xED, 0x51]);
	}
	
	# LD dd', HL
	if ($rabbit) {
		add($cpu, "ld hl', hl",		[push_dd('hl')], 
									[$V{altd}], [pop_dd('hl')]);
	}
	
	# LD dd, dd'
	if ($rabbit) {
		for my $s (qw( bc de hl )) {
			for my $d (qw( bc de hl )) {
				add($cpu, "ld $d, $s'",	[exx()], [push_dd($s)], [exx()], 
										[pop_dd($d)]);
			}
		}
	}
	
	# LD dd', dd'
	if ($rabbit) {
		for my $s (qw( bc de hl )) {
			for my $d (qw( bc de hl )) {
				add($cpu, "ld $d', $s'",[exx()], [push_dd($s)], [exx()], 
										[$V{altd}], [pop_dd($d)]);
			}
		}
	}
	
	# LD IXY, dd'
	if ($rabbit) {
		for my $s (qw( bc de hl )) {
			for my $d (qw( ix iy )) {
				add($cpu, "ld $d, $s'",	[exx()], [push_dd($s)], [exx()], 
										[$V{$d}, pop_dd('hl')]);
			}
		}
	}
	
	# LD dd', IXY
	if ($rabbit) {
		for my $s (qw( ix iy )) {
			for my $d (qw( bc de )) {
				add($cpu, "ld $d', $s",	[$V{$s}, push_dd('hl')], 
										[$V{altd}], [pop_dd($d)]);
			}
		}
	}
	
	# LD HL, SP+n
    if ($i8085) {
		add($cpu, "ld hl, sp+%u",	[ex_de_hl()], [0x38, '%u'], [ex_de_hl()]);
    }
	elsif ($gameboy) {
		add($cpu, "ldhl sp, %s",  	[0xF8, '%s']);
		add($cpu, "ld hl, sp+%s", 	[0xF8, '%s']);
    }
	elsif ($kc160_any) {
		add($cpu, "ld ix, sp", 		[0xED, 0x06]);
		add($cpu, "ld iy, sp", 		[0xED, 0x16]);
		add($cpu, "ld hl, sp", 		[0xED, 0x26]);
		
		add($cpu, "ld hl, sp+%s",	[ld_dd_m('hl'), '%s', 0],	# ld hl, %s
									[add_hl_dd('sp')]);    		# add hl, sp
	}
    else {
		add($cpu, "ld hl, sp+%s",	[ld_dd_m('hl'), '%s', 0],	# ld hl, %s
									[add_hl_dd('sp')]);    		# add hl, sp
    }
    
	# CLR
	for my $r (qw( b c d e h l (hl) a )) {
		add_x($cpu, "clr $r", [ld_r_n($r), 0]);
	}
	
	for my $dd (qw( bc de hl )) {
		if ($dd eq 'hl' && ($r4k || $r5k)) {
			add_x($cpu, "clr hl", [0xBF]);
		}
		else {
			add_x($cpu, "clr $dd", [ld_dd_m($dd), 0, 0]);
		}
	}

	if (!$intel && !$gameboy) {
		for my $x (qw( ix iy )) {
			add($cpu, "clr $x", [$V{$x}, ld_dd_m('hl'), 0, 0]);
		}
	}	

	# PUSH / POP
	for my $r (qw( bc de hl af )) {
		my $r1 = ($r eq 'af') ? 'psw' : substr($r,0,1);		# B, D, H, PSW

		add_x($cpu, "push $r",	[push_dd($r)]);
		add($cpu, "push $r1",	[push_dd($r)]);

		add_x($cpu, "pop $r",	[pop_dd($r)]);
		add($cpu, "pop $r1",	[pop_dd($r)]);
		
		if (!$intel && !$gameboy) {
			if ($r eq 'hl') {
				for my $x (qw( ix iy )) {
					add_x($cpu, "push $x", [$V{$x}, push_dd($r)]);
					add_x($cpu, "pop $x",  [$V{$x}, pop_dd($r)]);
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
		for ([hl => 0xDD], [ix => ()], [iy => 0xFD]) {
			my($dd, @pfx) = @$_;
		
			add_x($cpu, "ld hl, ($dd+%d)", [@pfx, 0xE4, '%d']);
			add_x($cpu, "ld ($dd+%d), hl", [@pfx, 0xF4, '%d']);
		}
			
		for ([hl => ()], [ix => 0xDD], [iy => 0xFD]) {
			my($dd, @pfx) = @$_;
		
			add_x($cpu, "ld (sp+%u), $dd", 	[@pfx, 0xD4, '%u']);
			add_x($cpu, "ld $dd, (sp+%u)", 	[@pfx, 0xC4, '%u']);
		}
		
		for ([hl => 0xED], [ix => 0xDD], [iy => 0xFD]) {
			my($dd, $pfx) = @$_;
			
			add($cpu, "ldp (%m), $dd", [$pfx, 0x65, '%m', '%m']);
			add($cpu, "ldp $dd, (%m)", [$pfx, 0x6D, '%m', '%m']);
			add($cpu, "ldp ($dd), hl", [$pfx, 0x64]);
			add($cpu, "ldp hl, ($dd)", [$pfx, 0x6C]);
		}
	}
	elsif ($kc160_any) {
		for my $dd (qw( bc de hl sp )) {
			add($cpu, "ld (sp+%d), $dd",	[0xED, 0x86+16*$V{$dd}, '%d']);
			add($cpu, "ld $dd, (sp+%d)",	[0xED, 0x8E+16*$V{$dd}, '%d']);
		}
		
		add($cpu, "ld (sp+%d), ix",			[0xED, 0x82, '%d']);
		add($cpu, "ld (sp+%d), iy",			[0xED, 0x92, '%d']);
		
		add($cpu, "ld ix, (sp+%d)",			[0xED, 0x8A, '%d']);
		add($cpu, "ld iy, (sp+%d)",			[0xED, 0x9A, '%d']);
	}

	# undocumented 8085 instructions
	if ($i8085) {
		# Add 00bb immediate to SP, result to DE
		add($cpu, "ldsi %n",		[0x38, '%n']);
		add($cpu, "adi sp, %n",		[0x38, '%n']);
		add($cpu, "ld de, sp+%u",	[0x38, '%u']);
    }
    elsif ($gameboy) {
		add($cpu, "ld de, sp+%u",	
					[push_dd('hl')],				# ex de, hl
					[push_dd('de')],
					[pop_dd('hl')],
					[pop_dd('de')],
					[ld_dd_m('hl'), '%u', 0],		# ld hl, %n
					[add_hl_dd('sp')],				# add hl, sp
					[push_dd('hl')],				# ex de, hl
					[push_dd('de')],
					[pop_dd('hl')],
					[pop_dd('de')]);
    }
    else {
		add($cpu, "ld de, sp+%u",	
					[ex_de_hl()],               	# ex de, hl
					[ld_dd_m('hl'), '%u', 0],		# ld hl, %n
					[add_hl_dd('sp')],				# add hl, sp
					[ex_de_hl()]);					# ex de, hl
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

	# lea
	if ($ez80_any) {
		add_suf($cpu, "lea ix, ix+%d", [0xED, 0x32, '%d']);
		add_suf($cpu, "lea iy, ix+%d", [0xED, 0x55, '%d']);
		add_suf($cpu, "lea bc, ix+%d", [0xED, 0x02, '%d']);
		add_suf($cpu, "lea de, ix+%d", [0xED, 0x12, '%d']);
		add_suf($cpu, "lea hl, ix+%d", [0xED, 0x22, '%d']);
		
		add_suf($cpu, "lea ix, iy+%d", [0xED, 0x54, '%d']);
		add_suf($cpu, "lea iy, iy+%d", [0xED, 0x33, '%d']);
		add_suf($cpu, "lea bc, iy+%d", [0xED, 0x03, '%d']);
		add_suf($cpu, "lea de, iy+%d", [0xED, 0x13, '%d']);
		add_suf($cpu, "lea hl, iy+%d", [0xED, 0x23, '%d']);
	}
	
	# pea
	if ($ez80_any) {
		add_suf($cpu, "pea ix+%d", [0xED, 0x65, '%d']);
		add_suf($cpu, "pea iy+%d", [0xED, 0x66, '%d']);
	}
	
	#--------------------------------------------------------------------------
	# Exchange group
	#--------------------------------------------------------------------------

	if (!$intel && !$gameboy) {
		add($cpu, "ex af, af'", [0x08]);
		add($cpu, "ex af', af", [0x08]);
		add($cpu, "ex af, af",  [0x08]);
		
		add($cpu, "exx",  [exx()]);
	}

	if ($r4k || $r5k) {
		add($cpu, "exp",  [0xED, 0xD9]);
	}
	
	if ($gameboy) {
		add($cpu, "ex de, hl",	[push_dd('hl')], [push_dd('de')],
								[pop_dd('hl')], [pop_dd('de')]);
		add($cpu, "ex hl, de",	[push_dd('hl')], [push_dd('de')],
								[pop_dd('hl')], [pop_dd('de')]);
		add($cpu, "xchg",		[push_dd('hl')], [push_dd('de')],
								[pop_dd('hl')], [pop_dd('de')]);
	}
	else {
		add($cpu, "ex de, hl",	[ex_de_hl()]);
		add($cpu, "ex hl, de",	[ex_de_hl()]);
		add($cpu, "xchg",		[ex_de_hl()]);
		
		if ($rabbit) {
			add($cpu, "ex de', hl", 	[0xE3]);
			add($cpu, "ex hl, de'", 	[0xE3]);
			
			add($cpu, "ex de, hl'", 	[$V{altd}], [0xEB]);
			add($cpu, "ex hl', de", 	[$V{altd}], [0xEB]);
			
			add($cpu, "ex de', hl'", 	[$V{altd}], [0xE3]);
			add($cpu, "ex hl', de'", 	[$V{altd}], [0xE3]);
			
			add($cpu, "altd ex de, hl", [$V{altd}], [0xEB]);
			add($cpu, "altd ex de', hl",[$V{altd}], [0xE3]);
		}
	}
	
	if ($r4k || $r5k) {
		add($cpu, "ex bc, hl", 			[0xB3]);
		add($cpu, "ex hl, bc", 			[0xB3]);
		
		add($cpu, "ex bc, hl'",			[$V{altd}], [0xB3]);
		add($cpu, "ex hl', bc",			[$V{altd}], [0xB3]);
		
		add($cpu, "ex bc', hl",			[0xED, 0x74]);
		add($cpu, "ex hl, bc'",			[0xED, 0x74]);
			
		add($cpu, "ex bc', hl'",		[$V{altd}], [0xED, 0x74]);
		add($cpu, "ex hl', bc'",		[$V{altd}], [0xED, 0x74]);
			
		add($cpu, "altd ex bc, hl", 	[$V{altd}], [0xB3]);
		add($cpu, "altd ex bc', hl", 	[$V{altd}], [0xED, 0x74]);
		
		add($cpu, "ex jk, hl",			[0xB9]);
		add($cpu, "ex hl, jk",			[0xB9]);
		
		add($cpu, "ex jk, hl'",			[$V{altd}], [0xB9]);
		add($cpu, "ex hl', jk",			[$V{altd}], [0xB9]);
		add($cpu, "altd ex jk, hl",		[$V{altd}], [0xB9]);
		
		add($cpu, "ex jk', hl",			[0xED, 0x7C]);
		add($cpu, "ex hl, jk'",			[0xED, 0x7C]);
		
		add($cpu, "ex jk', hl'",		[$V{altd}], [0xED, 0x7C]);
		add($cpu, "ex hl', jk'",		[$V{altd}], [0xED, 0x7C]);
		add($cpu, "altd ex jk', hl",	[$V{altd}], [0xED, 0x7C]);
		
		add($cpu, "ex jkhl, bcde",		[0xB4]);
		add($cpu, "ex bcde, jkhl",		[0xB4]);
	}
	else {
		add($cpu, "ex bc, hl",	[push_dd('hl')], [push_dd('bc')],
								[pop_dd('hl')], [pop_dd('bc')]);
		add($cpu, "ex hl, bc",	[push_dd('hl')], [push_dd('bc')],
								[pop_dd('hl')], [pop_dd('bc')]);
	}
	
	if ($zilog || $intel || $kc160_any) {
		add_suf($cpu, "ex (sp), hl", 	[0xE3]);
		add($cpu, "xthl",				[0xE3]);
	}
	elsif ($rabbit) {
		add($cpu, "ex (sp), hl", 		[0xED, 0x54]);
		add($cpu, "ex (sp), hl'", 		[$V{altd}], [0xED, 0x54]);
		add($cpu, "altd ex (sp), hl", 	[$V{altd}], [0xED, 0x54]);
		add($cpu, "xthl",				[0xED, 0x54]);
	}
	else {
		add($cpu, "ex (sp), hl", 		[call(), '@__z80asm__ex_sp_hl', '']);
		add($cpu, "xthl",				[call(), '@__z80asm__ex_sp_hl', '']);
	}
	
	if (!$intel && !$gameboy) {
		for my $x (qw( ix iy )) {
			add_suf($cpu, "ex (sp), $x", [$V{$x}, 0xE3]);
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
		
		if ($zilog || $rabbit || $kc160_any) {
			for my $x (qw( ix iy )) {
				my $dd1 = $dd =~ s/hl/$x/r;
				add_suf($cpu, "add $x, $dd1", [$V{$x}, add_hl_dd($dd)]);
			}
		}	
		
		if ($kc160_ext) {
			for my $p (qw( x y a z )) {
				add($cpu, "add ${p}hl, $dd", 		[$V{"const2_$p"}], 
													[add_hl_dd($dd)]);
				for my $x (qw( ix iy )) {
					my $dd1 = $dd =~ s/hl/$x/r;
					add($cpu, "add ${p}${x}, $dd1", [$V{"const2_$p"}], 
													[$V{$x}, add_hl_dd($dd)]);
				}
			}
		}
	}
	
	if ($r4k || $r5k) {
		add_x($cpu, "add hl, jk", [0x65]);
		add_x($cpu, "add jkhl, bcde", [0xED, 0xC6]);
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
	elsif ($r4k || $r5k) {
		add($cpu, "add hl, %m",	[push_dd('de')],				# push de
								[ld_dd_m('de'), '%m', '%m'],	# ld de,%m
								[add_hl_dd('de')],				# add hl,de
								[pop_dd('de')]);				# pop de

		add($cpu, "add de, %m",	[push_dd('hl')],				# push hl
								[ld_dd_m('hl'), '%m', '%m'],	# ld hl,%m
								[add_hl_dd('de')],				# add hl,de
								[0x7F, ld_r_r('d', 'h')],		# ld de, hl											
								[0x7F, ld_r_r('e', 'l')],
								[pop_dd('hl')]);				# pop hl

		add($cpu, "add bc, %m",	[push_dd('hl')],				# push hl
								[ld_dd_m('hl'), '%m', '%m'],	# ld hl,%m
								[add_hl_dd('bc')],				# add hl,bc
								[0x7F, ld_r_r('b', 'h')],		# ld bc, hl											
								[0x7F, ld_r_r('c', 'l')],
								[pop_dd('hl')]);				# pop hl
	}
	elsif ($ez80_adl) {
		add($cpu, "add hl, %m",	[push_dd('de')],				# push de
								[ld_dd_m('de'), '%m', '%m', '%m'],	# ld de,%m
								[add_hl_dd('de')],				# add hl,de
								[pop_dd('de')]);				# pop de

		add($cpu, "add de, %m",	[push_dd('hl')],				# push hl
								[ld_dd_m('hl'), '%m', '%m', '%m'],	# ld hl,%m
								[add_hl_dd('de')],				# add hl,de
								[ld_r_r('d', 'h')],				# ld de, hl											
								[ld_r_r('e', 'l')],
								[pop_dd('hl')]);				# pop hl

		add($cpu, "add bc, %m",	[push_dd('hl')],				# push hl
								[ld_dd_m('hl'), '%m', '%m', '%m'],	# ld hl,%m
								[add_hl_dd('bc')],				# add hl,bc
								[ld_r_r('b', 'h')],				# ld bc, hl											
								[ld_r_r('c', 'l')],
								[pop_dd('hl')]);				# pop hl
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
		add_x($cpu, "add sp, %s", [0x27, '%s']);
	}
	elsif ($gameboy) {
		add($cpu, "add sp, %s", [0xE8, '%s']);
	}
	else {
		add($cpu, "add sp, %s", [call(), '@__z80asm__add_sp_s'], ['%s']);
	}

	# ADC
	for my $dd (qw( bc de hl sp )) {
		if ($intel || $gameboy) {
			add($cpu, "adc hl, $dd", [call(), '@__z80asm__adc_hl_'.$dd, '']);
		}
		elsif ($kc160_any) {
			add($cpu, "adc hl, $dd", [adc_hl_dd($dd)]);
			if ($kc160_ext) {
				for my $p (qw( x y a z )) {
					add($cpu, "adc ${p}hl, $dd", [$V{"const2_$p"}], [adc_hl_dd($dd)]);
				}
			}
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
		elsif ($kc160_any) {
			add($cpu, "sbc hl, $dd", [sbc_hl_dd($dd)]);
			if ($kc160_ext) {
				for my $p (qw( x y a z )) {
					add($cpu, "sbc ${p}hl, $dd", [$V{"const2_$p"}], [sbc_hl_dd($dd)]);
				}
			}
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
			if (($r4k || $r5k) && $dd =~ /de/) {
				add_x($cpu, "sub hl, de",[0x55]);
			}
			else {
				add($cpu, "dsub",       [call(), '@__z80asm__sub_hl_'.$dd, '']) if $dd eq 'bc';
				add($cpu, "sub hl, $dd",[call(), '@__z80asm__sub_hl_'.$dd, '']);
			}
        }
	}

	# AND
	if ($rabbit) {
		for ([hl => ()], [ix => 0xDD], [iy => 0xFD]) {
			my($dd, @pfx) = @$_;
			add_x($cpu, "and $dd, de", [@pfx, 0xDC]);
		}
	}
	else {
		add($cpu, "and hl, de",		[push_dd('af')],
									[ld_r_r('a','h')],
									[alu_r('and','d')],
									[ld_r_r('h','a')],
									[ld_r_r('a','l')],
									[alu_r('and','e')],
									[ld_r_r('l','a')],
									[pop_dd('af')]);
	}
	
	if ($r4k || $r5k) {
		add($cpu, "and hl, bc",		[push_dd('af')],
									[0x7F, ld_r_r('a','h')],
									[0x7F, alu_r('and','b')],
									[0x7F, ld_r_r('h','a')],
									[0x7F, ld_r_r('a','l')],
									[0x7F, alu_r('and','c')],
									[0x7F, ld_r_r('l','a')],
									[pop_dd('af')]);
	}
	else {
		add($cpu, "and hl, bc",		[push_dd('af')],
									[ld_r_r('a','h')],
									[alu_r('and','b')],
									[ld_r_r('h','a')],
									[ld_r_r('a','l')],
									[alu_r('and','c')],
									[ld_r_r('l','a')],
									[pop_dd('af')]);
	}
	
	if ($cpu =~ /^z80n?|^ez80|^r800/ && $cpu !~ /z80_strict/) {
		for my $x (qw( ix iy )) {
			add($cpu, "and $x, de",		[push_dd('af')],
										[$V{$x}, ld_r_r('a','h')],
										[alu_r('and','d')],
										[$V{$x}, ld_r_r('h','a')],
										[$V{$x}, ld_r_r('a','l')],
										[alu_r('and','e')],
										[$V{$x}, ld_r_r('l','a')],
										[pop_dd('af')]);

			add($cpu, "and $x, bc",		[push_dd('af')],
										[$V{$x}, ld_r_r('a','h')],
										[alu_r('and','b')],
										[$V{$x}, ld_r_r('h','a')],
										[$V{$x}, ld_r_r('a','l')],
										[alu_r('and','c')],
										[$V{$x}, ld_r_r('l','a')],
										[pop_dd('af')]);
		}
	}
	
	if ($r4k || $r5k) {
		add_x($cpu, "and jkhl, bcde", [0xED, 0xE6]);
	}

	# INC/DEC
	for my $dd (qw( bc de hl sp )) {
		add_x($cpu, "inc $dd", [inc_dd($dd)]);
		add_x($cpu, "dec $dd", [dec_dd($dd)]);

		if ($kc160_ext) {
			for my $p (qw( x y a z )) {
				add($cpu, "inc ${p}${dd}", [$V{"const2_$p"}], [inc_dd($dd)]);
				add($cpu, "dec ${p}${dd}", [$V{"const2_$p"}], [dec_dd($dd)]);
			}
		}
	}
	
	if ($zilog || $rabbit || $kc160_any) {
		for my $x (qw( ix iy )) {
			add_x($cpu, "inc $x", [$V{$x}, inc_dd('hl')]);
			add_x($cpu, "dec $x", [$V{$x}, dec_dd('hl')]);

			if ($kc160_ext) {
				for my $p (qw( x y a z )) {
					add($cpu, "inc ${p}${x}", [$V{"const2_$p"}], [$V{$x}, inc_dd('hl')]);
					add($cpu, "dec ${p}${x}", [$V{"const2_$p"}], [$V{$x}, dec_dd('hl')]);
				}
			}
		}
	}
	
	for my $dd (qw( bc de hl sp )) {
		my $dd1 = ($dd eq 'sp') ? $dd : substr($dd,0,1);		# B, D, H
		
		add($cpu, "inx $dd",	[inc_dd($dd)]);
		add($cpu, "inx $dd1",	[inc_dd($dd)]) if $dd ne $dd1;
		add($cpu, "dcx $dd",	[dec_dd($dd)]);
		add($cpu, "dcx $dd1",	[dec_dd($dd)]) if $dd ne $dd1;
	}

	# OR
	if ($rabbit) {
		for ([hl => ()], [ix => 0xDD], [iy => 0xFD]) {
			my($dd, @pfx) = @$_;
			
			if ($dd eq 'hl') {
				add_x($cpu, "or $dd, de", 	[@pfx, 0xEC]);
			}
			else {
				add($cpu, "or $dd, de", 	[@pfx, 0xEC]);
			}
		}
	}
	else {
		add($cpu, "or hl, de",		[push_dd('af')],
									[ld_r_r('a','h')],
									[alu_r('or','d')],
									[ld_r_r('h','a')],
									[ld_r_r('a','l')],
									[alu_r('or','e')],
									[ld_r_r('l','a')],
									[pop_dd('af')]);
	}
	
	if ($r4k || $r5k) {
		add($cpu, "or hl, bc",		[push_dd('af')],
									[0x7F, ld_r_r('a','h')],
									[0x7F, alu_r('or','b')],
									[0x7F, ld_r_r('h','a')],
									[0x7F, ld_r_r('a','l')],
									[0x7F, alu_r('or','c')],
									[0x7F, ld_r_r('l','a')],
									[pop_dd('af')]);
	}
	else {
		add($cpu, "or hl, bc",		[push_dd('af')],
									[ld_r_r('a','h')],
									[alu_r('or','b')],
									[ld_r_r('h','a')],
									[ld_r_r('a','l')],
									[alu_r('or','c')],
									[ld_r_r('l','a')],
									[pop_dd('af')]);
	}
	
	if ($cpu =~ /^z80n?|^ez80|^r800/ && $cpu !~ /z80_strict/) {
		for my $x (qw( ix iy )) {
			add($cpu, "or $x, de",		[push_dd('af')],
										[$V{$x}, ld_r_r('a','h')],
										[alu_r('or','d')],
										[$V{$x}, ld_r_r('h','a')],
										[$V{$x}, ld_r_r('a','l')],
										[alu_r('or','e')],
										[$V{$x}, ld_r_r('l','a')],
										[pop_dd('af')]);

			add($cpu, "or $x, bc",		[push_dd('af')],
										[$V{$x}, ld_r_r('a','h')],
										[alu_r('or','b')],
										[$V{$x}, ld_r_r('h','a')],
										[$V{$x}, ld_r_r('a','l')],
										[alu_r('or','c')],
										[$V{$x}, ld_r_r('l','a')],
										[pop_dd('af')]);
		}
	}
	
	# XOR
	if ($r4k || $r5k) {
		add_x($cpu, "xor hl, de",				[0x54]);
		add_x($cpu, "xor jkhl, bcde",			[0xED, 0xEE]);
	}
	else {
		add($cpu, "xor hl, de",		[push_dd('af')],
									[ld_r_r('a','h')],
									[alu_r('xor','d')],
									[ld_r_r('h','a')],
									[ld_r_r('a','l')],
									[alu_r('xor','e')],
									[ld_r_r('l','a')],
									[pop_dd('af')]);
	}
	
	if ($r4k || $r5k) {
		add($cpu, "xor hl, bc",		[push_dd('af')],
									[0x7F, ld_r_r('a','h')],
									[0x7F, alu_r('xor','b')],
									[0x7F, ld_r_r('h','a')],
									[0x7F, ld_r_r('a','l')],
									[0x7F, alu_r('xor','c')],
									[0x7F, ld_r_r('l','a')],
									[pop_dd('af')]);
	}
	else {
		add($cpu, "xor hl, bc",		[push_dd('af')],
									[ld_r_r('a','h')],
									[alu_r('xor','b')],
									[ld_r_r('h','a')],
									[ld_r_r('a','l')],
									[alu_r('xor','c')],
									[ld_r_r('l','a')],
									[pop_dd('af')]);
	}
	
	if ($cpu =~ /^z80n?|^ez80|^r800/ && $cpu !~ /z80_strict/) {
		for my $x (qw( ix iy )) {
			add($cpu, "xor $x, de",		[push_dd('af')],
										[$V{$x}, ld_r_r('a','h')],
										[alu_r('xor','d')],
										[$V{$x}, ld_r_r('h','a')],
										[$V{$x}, ld_r_r('a','l')],
										[alu_r('xor','e')],
										[$V{$x}, ld_r_r('l','a')],
										[pop_dd('af')]);

			add($cpu, "xor $x, bc",		[push_dd('af')],
										[$V{$x}, ld_r_r('a','h')],
										[alu_r('xor','b')],
										[$V{$x}, ld_r_r('h','a')],
										[$V{$x}, ld_r_r('a','l')],
										[alu_r('xor','c')],
										[$V{$x}, ld_r_r('l','a')],
										[pop_dd('af')]);
		}
	}
	

	# BOOL
	if ($rabbit) {
		for ([hl => ()], [ix => 0xDD], [iy => 0xFD]) {
			my($dd, @pfx) = @$_;
			
			if ($dd eq 'hl') {
				add_x($cpu, "bool $dd",	[@pfx, 0xCC]);
			}
			else {
				add($cpu, "bool $dd",	[@pfx, 0xCC]);
			}
		}
	}
	elsif ($z80n || $ez80_any || $r800) {
		for ([hl => ()], [ix => 0xDD], [iy => 0xFD]) {
			my($dd, @pfx) = @$_;
			
			add($cpu, "bool $dd", 	[push_dd('af')],
									[@pfx, ld_r_r('a','h')],
									[@pfx, alu_r('or','l')],
									[jr_f('_z'), '%t1'],
									[@pfx, ld_dd_m('hl'), 1, 0],
									[pop_dd('af')]);
		}
	}
	elsif ($intel || $gameboy) {
		add($cpu, "bool hl", 	[push_dd('af')],
								[ld_r_r('a','h')],
								[alu_r('or','l')],
								[jp_f('_z'), '%t1', '%t1'],
								[ld_dd_m('hl'), 1, 0],
								[pop_dd('af')]);
	}
	else {
		add($cpu, "bool hl", 	[push_dd('af')],
								[ld_r_r('a','h')],
								[alu_r('or','l')],
								[jr_f('_z'), '%t1'],
								[ld_dd_m('hl'), 1, 0],
								[pop_dd('af')]);
		for my $x (qw( ix iy )) {
			add($cpu, "bool $x", 	[push_dd('af')],
									[push_dd('hl')],
									[$V{$x}, push_dd('hl')],
									[pop_dd('hl')],
									[ld_r_r('a','h')],
									[alu_r('or','l')],
									[jr_f('_z'), '%t5'],
									[ld_dd_m('hl'), 1, 0],
									[push_dd('hl')],
									[$V{$x}, pop_dd('hl')],
									[pop_dd('hl')],
									[pop_dd('af')]);
		}
	}
	
	# Multiply
	if ($z180 || $ez80_any) {
		for my $dd (qw( bc de hl sp )) {
			if ($dd eq 'sp') {
				add_suf($cpu, "mlt $dd", [0xED, 0x4C+16*$V{$dd}]);
			}
			else {
				add($cpu, "mlt $dd", [0xED, 0x4C+16*$V{$dd}]);
			}
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
	elsif ($r800) {
		add($cpu, "mulub a, a",		[0xED, 0xF9]);
		add($cpu, "mulub a, b",		[0xED, 0xC1]);
		add($cpu, "mulub a, c",		[0xED, 0xC9]);
		add($cpu, "mulub a, d",		[0xED, 0xD1]);
		add($cpu, "mulub a, e",		[0xED, 0xD9]);
		add($cpu, "mulub a, h",		[0xED, 0xE1]);
		add($cpu, "mulub a, l",		[0xED, 0xE9]);
		add($cpu, "muluw hl, bc",	[0xED, 0xC3]);
		add($cpu, "muluw hl, de",	[0xED, 0xD3]);
		add($cpu, "muluw hl, hl",	[0xED, 0xE3]);
		add($cpu, "muluw hl, sp",	[0xED, 0xF3]);
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
			next if $op =~ /sll|sls|sli/ && !($z80 || $z80n);

			for my $r (qw( b c d e h l (hl) a )) {
				add_x($cpu, "$op $r", [0xCB, 8*$V{$op}+$V{$r}]) 
					unless $opcodes{"$op $r"}{$cpu};
				
				# (ix+d) -> r
				if (($z80 || $z80n) && $r ne '(hl)') {
					for my $x (qw( ix iy )) {
						add($cpu, "$op ($x+%d), $r", 	[$V{$x}, 0xCB, '%d', 8*$V{$op}+$V{$r}]);
						add($cpu, "ld $r, $op ($x+%d)", [$V{$x}, 0xCB, '%d', 8*$V{$op}+$V{$r}]);
					}
				}
			}

			if ($kc160_ext) {
				for my $p (qw( x y a p z )) {
					add($cpu, "$op (${p}hl)", 
						[$V{"const1_$p"}], [0xCB, 8*$V{$op}+$V{'(hl)'}]);
					for my $x (qw( ix iy )) {
						add($cpu, "$op (${p}${x}+%d)", 
							[$V{"const1_$p"}], 
							[$V{$x}, 0xCB, '%d', 8*$V{$op}+$V{'(hl)'}]);
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
    elsif ($r4k || $r5k) {
		add_x($cpu, "rl bc",[0x62]);
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
    elsif ($r4k || $r5k) {
		add_x($cpu, "rl hl",[0x42]);
	}
    else {
        add($cpu, "rl hl",	[0xCB, 0x15], [0xCB, 0x14]);
    }
        
	# rr bc
    if ($intel) {
        add($cpu, "rr bc",	[call(), '@__z80asm__rr_bc', '']);
    }
    elsif ($r4k || $r5k) {
		add_x($cpu, "rr bc",[0x63]);
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
				if (($z80 || $z80n) && $op ne 'bit' && $r ne '(hl)') {
					for my $x (qw( ix iy )) {
						add($cpu, "$op %c, ($x+%d), $r", 
							[$V{$x}, 0xCB, '%d', (0x40*$V{$op}+$V{$r})."+8*%c(0..7)"]);
						add($cpu, "ld $r, $op %c, ($x+%d)", 
							[$V{$x}, 0xCB, '%d', (0x40*$V{$op}+$V{$r})."+8*%c(0..7)"]);
					}
				}
			}
				
			if ($kc160_ext) {
				for my $p (qw( x y a p z )) {
					add($cpu, "$op %c, (${p}hl)", 
						[$V{"const1_$p"}], 
						[0xCB, (0x40*$V{$op}+$V{'(hl)'})."+8*%c(0..7)"]);
					for my $x (qw( ix iy )) {
						add($cpu, "$op %c, (${p}${x}+%d)", 
							[$V{"const1_$p"}], 
							[$V{$x}, 0xCB, '%d', (0x40*$V{$op}+$V{'(hl)'})."+8*%c(0..7)"]);
					}				
				}
			}
		}
	}
	
	#--------------------------------------------------------------------------
	# CPU control group
	#--------------------------------------------------------------------------

	add($cpu, "nop", 		[0x00]);
	
	if (!$rabbit) {
		add($cpu, "halt",	[0x76]);
		add($cpu, "hlt",	[0x76]);
	}
	
	add($cpu, "slp", 	[0xED, 0x76]) if $z180 || $ez80_any;
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
	
	if ($zilog || $kc160_any) {
		add($cpu, "ld i, a", [0xED, 0x47]);
		add($cpu, "ld a, i", [0xED, 0x57]);
		add($cpu, "ld r, a", [0xED, 0x4F]);
		add($cpu, "ld a, r", [0xED, 0x5F]);
	}
	
	if ($zilog) {
		add($cpu, "im %c", [0xED, "%c(0..2)==0?0x46:%c==1?0x56:0x5E"]);
	
		if ($ez80_any) {
			add($cpu, "ld hl, i", [0xED, 0xD7]);
			add($cpu, "ld i, hl", [0xED, 0xC7]);
		}
	}
	elsif ($kc160_any) {
		add($cpu, "im %c", [0xED, "%c(0..3)==0?0x46:%c==1?0x56:%c==2?0x5E:0x4E"]);
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
		add($cpu, "reti", 			[0xED, 0x4D]);
		if ($ez80_z80) {
			add($cpu, "reti.l", 	[0x49], [0xED, 0x4D]);
			add($cpu, "reti.lis", 	[0x49], [0xED, 0x4D]);
		}
		elsif ($ez80_adl) {
			add($cpu, "reti.l", 	[0x5B], [0xED, 0x4D]);
			add($cpu, "reti.lil", 	[0x5B], [0xED, 0x4D]);
		}
	}
	
	if ($zilog || $kc160_any) {
		add($cpu, "retn", 			[0xED, 0x45]);
	}
	
	if ($kc160_any) {
		add($cpu, "retn3", 			[0xED, 0x55]);
	}

	if ($ez80_z80) {
		add($cpu, "retn.l", 		[0x49], [0xED, 0x45]);
		add($cpu, "retn.lis", 		[0x49], [0xED, 0x45]);
	}
	elsif ($ez80_adl) {
		add($cpu, "retn.l", 		[0x5B], [0xED, 0x45]);
		add($cpu, "retn.lil", 		[0x5B], [0xED, 0x45]);
	}
	add($cpu, "idet", [0x5B]) if $r3k || $r4k || $r5k;

	# Memory mode
	if ($ez80_any) {
		add($cpu, "ld a, mb",	[0xED, 0x6E]);
		add($cpu, "ld mb, a",	[0xED, 0x6D]);
		add($cpu, "rsmix",		[0xED, 0x7E]);
		add($cpu, "stmix",		[0xED, 0x7D]);
	}
	
	#--------------------------------------------------------------------------
	# Jump and Call group
	#--------------------------------------------------------------------------

	# JR
	if ($intel) {
		add($cpu, "jr %j",	[jp(), '%m', '%m']);
		
		for my $_f (qw( _nz _z _nc _c _ne _eq _geu _ltu _gtu _leu )) { 
			my $f = substr($_f, 1);	# remove leading _
			
			if ($f eq 'gtu') {
				add($cpu, "jr $f, %j",	[jp_f('_eq'),  '%t', '%t'],
										[jp_f('_geu'), '%m', '%m']);
			}
			elsif ($f eq 'leu') {
				add($cpu, "jr $f, %j",	[jp_f('_eq'),  '%m', '%m'],
										[jp_f('_ltu'), '%m', '%m']);
			}
			else {
				add($cpu, "jr $f, %j",	[jp_f($_f), '%m', '%m']);
			}
		}
	} 
	else {	
		add($cpu, "jr %j",	[jr(), '%j']);
		
		for my $_f (qw( _nz _z _nc _c _ne _eq _geu _ltu _gtu _leu )) { 
			my $f = substr($_f, 1);	# remove leading _
			
			next if ($r4k || $r5k) && $f =~ /^(gt|lt|gtu|v)$/;
			
			if ($f eq 'gtu') {
				add($cpu, "jr $f, %j",	[jr_f('_eq'),  '%t'],
										[jr_f('_geu'), '%j']);
			}
			elsif ($f eq 'leu') {
				add($cpu, "jr $f, %j",	[jr_f('_eq'),  '%j'],
										[jr_f('_ltu'), '%j']);
			}
			else {
				add($cpu, "jr $f, %j",	[jr_f($_f), '%j']);
			}
		}
	}
	
	if ($r4k || $r5k) {
		add($cpu, "jre %J",				[0x98, '%J', '%J']);
		
		for ([gt=>0xA0], [lt=>0xB0], [gtu=>0xA8], [v=>0xB8]) {
			my($f, $opc) = @$_;
			add($cpu, "jr $f, %j", 		[$opc, '%j'])
		}
		
		for my $_f (qw( _nz _z _nc _c _ne _eq _geu _ltu )) {
			my $f = $_f =~ s/^_//r;
			add($cpu, "jre $f, %J",		[0xED, 0xC3+8*$V{$_f}, '%J', '%J']);
		}

		for ([gt=>0xA3], [lt=>0xB3], [gtu=>0xAB], [v=>0xBB]) {
			my($f, $opc) = @$_;
			add($cpu, "jre $f, %J",	[0xED, $opc, '%J', '%J']);
		}
	}

	# DJNZ
	if ($intel) {
		# Emulate with "DEB B / JP NZ, nn" on 8080/8085
		add($cpu, "djnz %j",	[dec_r('b'), jp_f('_nz'), '%m', '%m']);
		add($cpu, "djnz b, %j",	[dec_r('b'), jp_f('_nz'), '%m', '%m']);
	} 
	elsif ($gameboy) {
		# Emulate with "DEB B / JR NZ, nn" on GameBoy
		add($cpu, "djnz %j",	[dec_r('b'), jr_f('_nz'), '%j']);
		add($cpu, "djnz b, %j",	[dec_r('b'), jr_f('_nz'), '%j']);
	} 
	elsif ($rabbit) {
		add($cpu, "djnz %j", 		[djnz(), '%j']);
		add($cpu, "djnz b, %j", 	[djnz(), '%j']);
		
		# need 0x76 and 0x10 in same opcode
		add($cpu, "djnz b', %j",	[$V{altd}, djnz(), '%j']);	
		add($cpu, "altd djnz %j",	[$V{altd}, djnz(), '%j']);
		add($cpu, "altd djnz b, %j",[$V{altd}, djnz(), '%j']);
	}
	else {
		add($cpu, "djnz %j", 		[djnz(), '%j']);
		add($cpu, "djnz b, %j", 	[djnz(), '%j']);
	}
	
	if ($r4k || $r5k) {
		add($cpu, "dwjnz %j", 			[0xED, djnz(), '%j']);
		add($cpu, "dwjnz bc, %j", 		[0xED, djnz(), '%j']);
		
		# need 0x76 and 0x10 in same opcode
		add($cpu, "dwjnz bc', %j", 		[$V{altd}, 0xED, djnz(), '%j']);
		add($cpu, "altd dwjnz %j", 		[$V{altd}, 0xED, djnz(), '%j']);
		add($cpu, "altd dwjnz bc, %j", 	[$V{altd}, 0xED, djnz(), '%j']);
	}
	
	# JP
	for my $jump ('jmp', 'jp') {
		if ($ez80_z80) {
			add($cpu, "$jump %m",		[jp(), '%m', '%m']);
		}
		elsif ($ez80_adl) {
			add($cpu, "$jump %m",		[jp(), '%m', '%m', '%m']);
		}
		
		if ($ez80_any) {
			add($cpu, "$jump.sis %m",	[0x40], [jp(), '%m', '%m']);
			add($cpu, "$jump.lil %m",	[0x5B], [jp(), '%m', '%m', '%m']);
		}
		else {
			add($cpu, "$jump %m",		[jp(), '%m', '%m']);
		}
	}
	
	for my $_f (qw( _nz _z _nc _c _po _pe _nv _v _lz _lo _p _m 
				    _ne _eq _geu _ltu _gtu _leu )) { 
		my $f = substr($_f, 1);			# remove leading _
		
		next if $f =~ /^(lz|lo)$/ && !$rabbit;
		next if $f =~ /^(gtu|nv|v)$/ && ($r4k || $r5k);
		next if $f !~ /^(nz|z|nc|c|eq|ne|geu|ltu|gtu|leu)$/ && $gameboy;
		
		# TODO: Rabbit LJP not supported
		for my $jump ('jmp', 'jp') {
			if ($ez80_z80) {
				if ($f eq 'gtu') {
					add($cpu, "$jump $f, %m",	[jp_f('_eq'),  '%t', '%t'],
												[jp_f('_geu'), '%m', '%m']);
				}
				elsif ($f eq 'leu') {
					add($cpu, "$jump $f, %m",	[jp_f('_eq'),  '%m', '%m'],
												[jp_f('_ltu'), '%m', '%m']);
				}
				else {
					add($cpu, "$jump $f, %m",	[jp_f($_f), '%m', '%m']);
				}
			}
			elsif ($ez80_adl) {
				if ($f eq 'gtu') {
					add($cpu, "$jump $f, %m",	[jp_f('_eq'),  '%t', '%t', '%t'],
												[jp_f('_geu'), '%m', '%m', '%m']);
				}
				elsif ($f eq 'leu') {
					add($cpu, "$jump $f, %m",	[jp_f('_eq'),  '%m', '%m', '%m'],
												[jp_f('_ltu'), '%m', '%m', '%m']);
				}
				else {
					add($cpu, "$jump $f, %m",	[jp_f($_f), '%m', '%m', '%m']);
				}
			}
			
			if ($ez80_any) {
				if ($f eq 'gtu') {
					add($cpu, "$jump.sis $f, %m",	[0x40], [jp_f('_eq'),  '%t', '%t'],
													[0x40], [jp_f('_geu'), '%m', '%m']);
				}
				elsif ($f eq 'leu') {
					add($cpu, "$jump.sis $f, %m",	[0x40], [jp_f('_eq'),  '%m', '%m'],
													[0x40], [jp_f('_ltu'), '%m', '%m']);
				}
				else {
					add($cpu, "$jump.sis $f, %m",	[0x40], [jp_f($_f), '%m', '%m']);
				}
			
				if ($f eq 'gtu') {
					add($cpu, "$jump.lil $f, %m",	[0x5B], [jp_f('_eq'),  '%t', '%t', '%t'],
													[0x5B], [jp_f('_geu'), '%m', '%m', '%m']);
				}
				elsif ($f eq 'leu') {
					add($cpu, "$jump.lil $f, %m",	[0x5B], [jp_f('_eq'),  '%m', '%m', '%m'],
													[0x5B], [jp_f('_ltu'), '%m', '%m', '%m']);
				}
				else {
					add($cpu, "$jump.lil $f, %m",	[0x5B], [jp_f($_f), '%m', '%m', '%m']);
				}
			}
			else {
				if ($f eq 'gtu') {
					add($cpu, "$jump $f, %m",	[jp_f('_eq'),  '%t', '%t'],
												[jp_f('_geu'), '%m', '%m']);
				}
				elsif ($f eq 'leu') {
					add($cpu, "$jump $f, %m",	[jp_f('_eq'),  '%m', '%m'],
												[jp_f('_ltu'), '%m', '%m']);
				}
				else {
					add($cpu, "$jump $f, %m",	[jp_f($_f), '%m', '%m']);
				}
			}
		}
		
		if ($f ne 'p') {
			if ($f eq 'gtu') {
				add($cpu, "j$f %m",	[jp_f('_eq'),  '%t', '%t'],
									[jp_f('_geu'), '%m', '%m']);
			}
			elsif ($f eq 'leu') {
				add($cpu, "j$f %m",	[jp_f('_eq'),  '%m', '%m'],
									[jp_f('_ltu'), '%m', '%m']);
			}
			else {
				add($cpu, "j$f %m",	[jp_f($_f), '%m', '%m']);
			}
		}

		if ($f eq 'gtu') {
			add($cpu, "j_$f %m",	[jp_f('_eq'),  '%t', '%t'],
									[jp_f('_geu'), '%m', '%m']);
		}
		elsif ($f eq 'leu') {
			add($cpu, "j_$f %m",	[jp_f('_eq'),  '%m', '%m'],
									[jp_f('_ltu'), '%m', '%m']);
		}
		else {
			add($cpu, "j_$f %m",	[jp_f($_f), '%m', '%m']);
		}
	}
	
	if ($r4k || $r5k) {
		for ([gt=>0xA2], [lt=>0xB2], [gtu=>0xAA], [v=>0xBA]) {
			my($f, $opc) = @$_;
			for my $instr ("jp $f,", "jmp $f,", "j$f", "j_$f") {
				add($cpu, "$instr %m",	[$opc, '%m', '%m']);
			}
		}
	}
    
	for my $jump ('jmp', 'jp') {
		add_suf($cpu, "$jump (hl)",	[0xE9]);
	}
	add($cpu, "pchl",				[0xE9]);
	
	if (!$intel && !$gameboy) {
		for my $jump ('jmp', 'jp') {
			for my $x (qw( ix iy )) {
				add_suf($cpu, "$jump ($x)", [$V{$x}, 0xE9]);
			}
		}
	} 

	if ($kc160_ext) {
		for my $jump ('jmp', 'jp') {
			for my $p (qw( x y a p z )) {
				add($cpu, "$jump (${p}hl)", [$V{"const1_$p"}], [0xE9]);
				for my $x (qw( ix iy )) {
					add($cpu, "$jump (${p}${x})", [$V{"const1_$p"}], [$V{$x}, 0xE9]);
				}				
			}
		}			
	}
	
	for my $jump ('jmp', 'jp') {
		add($cpu, "$jump (bc)", [push_dd('bc')], [ret()]);
		add($cpu, "$jump (de)", [push_dd('de')], [ret()]);
	}
	
	if ($z80n) {
		for my $jump ('jmp', 'jp') {
			add($cpu, "$jump (c)",			[0xED, 0x98]);
		}
	}
    
	# JP3
	if ($kc160_any) {
		add($cpu, "jp3 %m", 	[0xED, 0xC3, '%m', '%m', '%m']);

		for my $_f (qw( _nz _z _nc _c _ne _eq _geu _ltu _gtu _leu )) { 
			my $f = substr($_f, 1);	# remove leading _
			
			if ($f eq 'gtu') {
				add($cpu, "jp3 $f, %m",	[0xED, jp_f('_eq'),  '%t', '%t', '%t'],
										[0xED, jp_f('_geu'), '%m', '%m', '%m']);
			}
			elsif ($f eq 'leu') {
				add($cpu, "jp3 $f, %m",	[0xED, jp_f('_eq'),  '%m', '%m', '%m'],
										[0xED, jp_f('_ltu'), '%m', '%m', '%m']);
			}
			else {
				add($cpu, "jp3 $f, %m",	[0xED, jp_f($_f), '%m', '%m', '%m']);
			}
		}
	}
	
	# CALL
	if ($ez80_z80) {
		add($cpu, "call %m",     [call(), '%m', '%m']);
		add($cpu, "call.is %m",  [0x40], [call(), '%m', '%m']);
		add($cpu, "call.sis %m", [0x40], [call(), '%m', '%m']);
		add($cpu, "call.il %m",  [0x52], [call(), '%m', '%m', '%m']);
		add($cpu, "call.sil %m", [0x52], [call(), '%m', '%m', '%m']);
	}
	elsif ($ez80_adl) {
		add($cpu, "call %m",     [call(), '%m', '%m', '%m']);
		add($cpu, "call.is %m",  [0x49], [call(), '%m', '%m']);
		add($cpu, "call.lis %m", [0x49], [call(), '%m', '%m']);
		add($cpu, "call.il %m",  [0x5B], [call(), '%m', '%m', '%m']);
		add($cpu, "call.lil %m", [0x5B], [call(), '%m', '%m', '%m']);
	}
	else {
		add($cpu, "call %m", [call(), '%m', '%m']);
	}
	
	if ($kc160_any) {
		add($cpu, "call3 %m",	[0xED, 0x4C, '%m', '%m', '%m']);
	}
	
	if ($r4k || $r5k) {
		add($cpu, "call (hl)", [0xED, 0xEA]);
		add($cpu, "call (ix)", [0xDD, 0xEA]);
		add($cpu, "call (iy)", [0xFD, 0xEA]);
	}
	else {
		add($cpu, "call (hl)", [call(), '@__z80asm__call_hl']);
		if (!$intel && !$gameboy) {
			add($cpu, "call (ix)", [call(), '@__z80asm__call_ix']);
			add($cpu, "call (iy)", [call(), '@__z80asm__call_iy']);
		}
	}
	
	for my $_f (qw( _nz _z _nc _c _po _pe _nv _v _lz _lo _p _m 
					_ne _eq _geu _ltu _gtu _leu )) { 
		my $f = substr($_f, 1);			# remove leading _
		my $_inv_f = $INV_FLAG{$_f};	# inverted flag
		my $inv_f = substr($_inv_f, 1);	# remove leading _

		next if $f =~ /^(lz|lo)$/ && !$rabbit;
		next if $f =~ /^(nv|v)$/ && ($r4k || $r5k);
		next if $f !~ /^(nz|z|nc|c|eq|ne|geu|ltu|gtu|leu)$/ && $gameboy;
		
		# TODO: Rabbit LCALL, LRET not supported
		if ($rabbit) {
			if ($f =~ /^(nz|z|nc|c|ne|eq|geu|ltu)$/) {
				for my $call ("call $f,", "c$f", "c_$f") {
					add($cpu, "$call %m",	[jr_f($_inv_f), '%t'],	# jump !flag
											[call(), '%m', '%m']);	# call 
				}
			}		
			elsif ($f eq 'gtu') {
				for my $call ("call $f,", "c$f", "c_$f") {
					add($cpu, "$call %m",	[jr_f('_eq'),  '%t'],
											[jr_f('_ltu'), '%t'],
											[call(), '%m', '%m']);
				}			
			}
			elsif ($f eq 'leu') {
				for my $call ("call $f,", "c$f", "c_$f") {
					add($cpu, "$call %m",	[jr_f('_eq'),  '%t3'],
											[jr_f('_geu'), '%t'],
											[call(), '%m', '%m']);
				}
			}
			else {
				for my $call ("call $f,", "c$f", "c_$f") {
					next if $call eq "cp";
					add($cpu, "$call %m",	[jp_f($_inv_f), '%t', '%t'], # jump !flag
											[call(), '%m', '%m']);		 # call 
				}
			}
		}
		elsif ($ez80_any) {
			if ($ez80_z80) {
				if ($f eq 'gtu') {
					for my $call ("call $f,", "c$f", "c_$f") {
						add($cpu, "$call %m",		[jr_f('_eq'),  '%t'],
													[jr_f('_ltu'), '%t'],
													[call(), '%m', '%m']);
					}
					
					add($cpu, "call.is $f, %m",		[jr_f('_eq'),  '%t'],
													[jr_f('_ltu'), '%t'],
													[0x40], [call(), '%m', '%m']);
					add($cpu, "call.sis $f, %m",	[jr_f('_eq'),  '%t'],
													[jr_f('_ltu'), '%t'],
													[0x40], [call(), '%m', '%m']);
					add($cpu, "call.il $f, %m",		[jr_f('_eq'),  '%t'],
													[jr_f('_ltu'), '%t'],
													[0x52], [call(), '%m', '%m', '%m']);
					add($cpu, "call.sil $f, %m",	[jr_f('_eq'),  '%t'],
													[jr_f('_ltu'), '%t'],
													[0x52], [call(), '%m', '%m', '%m']);
						
											
				}
				elsif ($f eq 'leu') {
					for my $call ("call $f,", "c$f", "c_$f") {
						add($cpu, "$call %m",		[jr_f('_eq'),  '%t3'],
													[jr_f('_geu'), '%t'],
													[call(), '%m', '%m']);
					}

					add($cpu, "call.is $f, %m",		[jr_f('_eq'),  '%t5'],
													[jr_f('_geu'), '%t'],
													[0x40], [call(), '%m', '%m', '%m']);
					add($cpu, "call.sis $f, %m",	[jr_f('_eq'),  '%t5'],
													[jr_f('_geu'), '%t'],
													[0x40], [call(), '%m', '%m', '%m']);
					add($cpu, "call.il $f, %m",		[jr_f('_eq'),  '%t5'],
													[jr_f('_geu'), '%t'],
													[0x52], [call(), '%m', '%m', '%m']);
					add($cpu, "call.sil $f, %m",	[jr_f('_eq'),  '%t5'],
													[jr_f('_geu'), '%t'],
													[0x52], [call(), '%m', '%m', '%m']);
				}
				else {
					for my $call ("call $f,", "c$f", "c_$f") {
						next if $call eq "cp";
						add($cpu, "$call %m",	[call_f($_f), '%m', '%m']);
					}
					
					add($cpu, "call.is $f, %m", [0x40], [call_f($_f), '%m', '%m']);
					add($cpu, "call.sis $f, %m", [0x40], [call_f($_f), '%m', '%m']);
					add($cpu, "call.il $f, %m", [0x52], [call_f($_f), '%m', '%m', '%m']);
					add($cpu, "call.sil $f, %m", [0x52], [call_f($_f), '%m', '%m', '%m']);
				}
			}
			elsif ($ez80_adl) {
				if ($f eq 'gtu') {
					for my $call ("call $f,", "c$f", "c_$f") {
						add($cpu, "$call %m",		[jr_f('_eq'),  '%t'],
													[jr_f('_ltu'), '%t'],
													[call(), '%m', '%m', '%m']);
					}			
					
					add($cpu, "call.is $f, %m",		[jr_f('_eq'),  '%t'],
													[jr_f('_ltu'), '%t'],
													[0x49], [call(), '%m', '%m']);
					add($cpu, "call.lis $f, %m",	[jr_f('_eq'),  '%t'],
													[jr_f('_ltu'), '%t'],
													[0x49], [call(), '%m', '%m']);
					add($cpu, "call.il $f, %m",		[jr_f('_eq'),  '%t'],
													[jr_f('_ltu'), '%t'],
													[0x5B], [call(), '%m', '%m', '%m']);
					add($cpu, "call.lil $f, %m",	[jr_f('_eq'),  '%t'],
													[jr_f('_ltu'), '%t'],
													[0x5B], [call(), '%m', '%m', '%m']);
				}
				elsif ($f eq 'leu') {
					for my $call ("call $f,", "c$f", "c_$f") {
						add($cpu, "$call %m",		[jr_f('_eq'),  '%t4'],
													[jr_f('_geu'), '%t'],
													[call(), '%m', '%m', '%m']);
					}

					add($cpu, "call.is $f, %m",		[jr_f('_eq'),  '%t5'],
													[jr_f('_geu'), '%t'],
													[0x49], [call(), '%m', '%m', '%m']);
					add($cpu, "call.lis $f, %m",	[jr_f('_eq'),  '%t5'],
													[jr_f('_geu'), '%t'],
													[0x49], [call(), '%m', '%m', '%m']);
					add($cpu, "call.il $f, %m",		[jr_f('_eq'),  '%t5'],
													[jr_f('_geu'), '%t'],
													[0x5B], [call(), '%m', '%m', '%m']);
					add($cpu, "call.lil $f, %m",	[jr_f('_eq'),  '%t5'],
													[jr_f('_geu'), '%t'],
													[0x5B], [call(), '%m', '%m', '%m']);
				}
				else {
					for my $call ("call $f,", "c$f", "c_$f") {
						next if $call eq "cp";
						add($cpu, "$call %m",	[call_f($_f), '%m', '%m', '%m']);
					}
					
					add($cpu, "call.is $f, %m", [0x49], [call_f($_f), '%m', '%m']);
					add($cpu, "call.lis $f, %m", [0x49], [call_f($_f), '%m', '%m']);
					add($cpu, "call.il $f, %m", [0x5B], [call_f($_f), '%m', '%m', '%m']);
					add($cpu, "call.lil $f, %m", [0x5B], [call_f($_f), '%m', '%m', '%m']);
				}
			}
		}
		elsif ($intel) {
			if ($f eq 'gtu') {
				for my $call ("call $f,", "c$f", "c_$f") {
					add($cpu, "$call %m",	[jp_f('_eq'),  '%t', '%t'],
											[jp_f('_ltu'), '%t', '%t'],
											[call(), '%m', '%m']);
				}			
			}
			elsif ($f eq 'leu') {
				for my $call ("call $f,", "c$f", "c_$f") {
					add($cpu, "$call %m",	[jp_f('_eq'),  '%t3', '%t3'],
											[jp_f('_geu'), '%t',  '%t'],
											[call(), '%m', '%m']);
				}
			}
			else {
				for my $call ("call $f,", "c$f", "c_$f") {
					next if $call eq "cp";
					add($cpu, "$call %m",	[call_f($_f), '%m', '%m']);
				}
			}
		}
		else {
			if ($f eq 'gtu') {
				for my $call ("call $f,", "c$f", "c_$f") {
					add($cpu, "$call %m",	[jr_f('_eq'),  '%t'],
											[jr_f('_ltu'), '%t'],
											[call(), '%m', '%m']);
				}			
			}
			elsif ($f eq 'leu') {
				for my $call ("call $f,", "c$f", "c_$f") {
					add($cpu, "$call %m",	[jr_f('_eq'),  '%t3'],
											[jr_f('_geu'), '%t'],
											[call(), '%m', '%m']);
				}
			}
			else {
				for my $call ("call $f,", "c$f", "c_$f") {
					next if $call eq "cp";
					add($cpu, "$call %m",	[call_f($_f), '%m', '%m']);
				}
			}
		}
	}
	
	# RST
	add_suf($cpu, "rst %c", ["0xC7+%c"]);
	
	# RET
	add($cpu, "ret", [ret()]);
	if ($ez80_z80) {
		add($cpu, "ret.l", 		[0x49], [ret()]);
		add($cpu, "ret.lis", 	[0x49], [ret()]);
	}
	elsif ($ez80_adl) {
		add($cpu, "ret.l", 		[0x5B], [ret()]);
		add($cpu, "ret.lil", 	[0x5B], [ret()]);
	}
	
	if ($kc160_any) {
		add($cpu, "ret3",		[0xED, 0x5C]);
		add($cpu, "tra",		[0xED, 0x54]);
	}
	
	for my $_f (qw( _nz _z _nc _c _po _pe _nv _v _lz _lo _p _m 
					_ne _eq _geu _ltu _gtu _leu )) { 
		my $f = substr($_f, 1);			# remove leading _

		next if $f =~ /^(lz|lo)$/ && !$rabbit;
		next if $f =~ /^(nv|v)$/ && ($r4k || $r5k);
		next if $f !~ /^(nz|z|nc|c|eq|ne|geu|ltu|gtu|leu)$/ && $gameboy;
		
		if ($intel) {
			if ($f eq 'gtu') {
				for my $ret ("ret $f", "r$f", "r_$f") {
					add($cpu, "$ret",		[jp_f('_eq'),  '%t', '%t'],
											[jp_f('_ltu'), '%t', '%t'],
											[ret()]);
				}
			}
			elsif ($f eq 'leu') {
				for my $ret ("ret $f", "r$f", "r_$f") {
					add($cpu, "$ret",		[ret_f('_eq')],
											[ret_f('_ltu')]);
				}
			}
			else {
				for my $ret ("ret $f", "r$f", "r_$f") {
					add($cpu, "$ret",		[ret_f($_f)]);
				}
			}
		}
		else {
			if ($f eq 'gtu') {
				for my $ret ("ret $f", "r$f", "r_$f") {
					add($cpu, "$ret",		[jr_f('_eq'),  '%t'],
											[jr_f('_ltu'), '%t'],
											[ret()]);
				}
			}
			elsif ($f eq 'leu') {
				for my $ret ("ret $f", "r$f", "r_$f") {
					add($cpu, "$ret",		[ret_f('_eq')],
											[ret_f('_ltu')]);
				}
			}
			else {
				for my $ret ("ret $f", "r$f", "r_$f") {
					add($cpu, "$ret",		[ret_f($_f)]);
				}
			}
		}

		if ($ez80_z80) {
			if ($f eq 'gtu') {
				add($cpu, "ret.l $f",	[jr_f('_eq'),  '%t'],
										[jr_f('_ltu'), '%t'],
										[0x49], [ret()]);
				add($cpu, "ret.lis $f",	[jr_f('_eq'),  '%t'],
										[jr_f('_ltu'), '%t'],
										[0x49], [ret()]);
			}
			elsif ($f eq 'leu') {
				add($cpu, "ret.l $f",	[0x49], [ret_f('_eq')],
										[0x49], [ret_f('_ltu')]);
				add($cpu, "ret.lis $f",	[0x49], [ret_f('_eq')],
										[0x49], [ret_f('_ltu')]);
			}
			else {
				add($cpu, "ret.l $f",	[0x49], [ret_f($_f)]);
				add($cpu, "ret.lis $f",	[0x49], [ret_f($_f)]);
			}
		}
		elsif ($ez80_adl) {
			if ($f eq 'gtu') {
				add($cpu, "ret.l $f",	[jr_f('_eq'),  '%t'],
										[jr_f('_ltu'), '%t'],
										[0x5B], [ret()]);
				add($cpu, "ret.lil $f",	[jr_f('_eq'),  '%t'],
										[jr_f('_ltu'), '%t'],
										[0x5B], [ret()]);
			}
			elsif ($f eq 'leu') {
				add($cpu, "ret.l $f",	[0x5B], [ret_f('_eq')],
										[0x5B], [ret_f('_ltu')]);
				add($cpu, "ret.lil $f",	[0x5B], [ret_f('_eq')],
										[0x5B], [ret_f('_ltu')]);
			}
			else {
				add($cpu, "ret.l $f",	[0x5B], [ret_f($_f)]);
				add($cpu, "ret.lil $f",	[0x5B], [ret_f($_f)]);
			}
		}
	}	

	if ($rabbit) {
		add_x($cpu, "ld xpc, a", [0xED, 0x67]);
		add_x($cpu, "ld a, xpc", [0xED, 0x77]);
	}

	if ($i8085) {
		# Restart 8 (0040) if V flag is set
		add($cpu, "rstv",		[0xCB]);
		add($cpu, "ovrst8",		[0xCB]);
		add($cpu, "rst v, %c",	[(0xCB-0x40).'+%c('.(0x40).'..'.(0x40).')']);

		# Jump on flag X5/K is set
		add($cpu, "jx5 %m",		[0xFD, '%m', '%m']);
		add($cpu, "jp x5,%m",	[0xFD, '%m', '%m']);
		add($cpu, "jmp x5,%m",	[0xFD, '%m', '%m']);
		add($cpu, "jk %m",		[0xFD, '%m', '%m']);
		add($cpu, "jp k,%m",	[0xFD, '%m', '%m']);
		add($cpu, "jmp k,%m",	[0xFD, '%m', '%m']);

		add($cpu, "jnx5 %m",	[0xDD, '%m', '%m']);
		add($cpu, "jp nx5,%m",	[0xDD, '%m', '%m']);
		add($cpu, "jmp nx5,%m",	[0xDD, '%m', '%m']);
		add($cpu, "jnk %m",		[0xDD, '%m', '%m']);
		add($cpu, "jp nk,%m",	[0xDD, '%m', '%m']);
		add($cpu, "jmp nk,%m",	[0xDD, '%m', '%m']);
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

	if ($r3k || $r4k || $r5k) {
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
	
	if ($kc160_any) {
		add($cpu, "ldi xy",		[0xED, 0xE0]);
		add($cpu, "ldir xy",	[0xED, 0xF0]);
		add($cpu, "ldd xy", 	[0xED, 0xE8]);
		add($cpu, "lddr xy",	[0xED, 0xF8]);
	}

	#--------------------------------------------------------------------------
	# Search group
	#--------------------------------------------------------------------------

	if ($zilog || $kc160_any) {
		add_suf($cpu, "cpi", 	[0xED, 0xA1]);
		add_suf($cpu, "cpir", 	[0xED, 0xB1]);
		add_suf($cpu, "cpd", 	[0xED, 0xA9]);
		add_suf($cpu, "cpdr", 	[0xED, 0xB9]);
	}
	else {
		add($cpu, "cpi", 		[call(), '@__z80asm__cpi', '']);
		add($cpu, "cpir", 		[call(), '@__z80asm__cpir', '']);
		add($cpu, "cpd", 		[call(), '@__z80asm__cpd', '']);
		add($cpu, "cpdr", 		[call(), '@__z80asm__cpdr', '']);
	}
	
	if ($kc160_any) {
		add($cpu, "cpi x", 		[0xED, 0xE1]);
		add($cpu, "cpir x", 	[0xED, 0xF1]);
		add($cpu, "cpd x", 		[0xED, 0xE9]);
		add($cpu, "cpdr x", 	[0xED, 0xF9]);
	}

	#--------------------------------------------------------------------------
	# Input and Output Group
	#--------------------------------------------------------------------------

	# IN A, (n) / OUT (n), A
	if ($intel || $zilog || $kc160_any) {
		add($cpu, "in a, (%n)", 		[0xDB, '%n']);
		add($cpu, "out (%n), a", 		[0xD3, '%n']);
	}
	
	# IN (c)
	if ($zilog && !$z80_strict) {
		add($cpu, "in (c)", 			[0xED, 0x40+8*$V{f}]);
		add($cpu, "in (bc)", 			[0xED, 0x40+8*$V{f}]);
		add($cpu, "in0 (%n)", 			[0xED, 0x00+8*$V{f}, '%n']) if $z180;
	}
	
	# IN[0] r, (C) / OUT[0] (C), r
	if ($zilog || $kc160_any) {
		for my $r (qw( b c d e h l a f )) {
			next if $r eq 'f' && ($z80_strict || $ez80_any || $kc160_any);

			add($cpu, "in $r, (c)", 	[0xED, 0x40+8*$V{$r}]);
			add($cpu, "in $r, (bc)", 	[0xED, 0x40+8*$V{$r}]);

			add($cpu, "in0 $r, (%n)", 	[0xED, 0x00+8*$V{$r}, '%n']) if $z180 || $ez80_any;
		}

		for my $r (qw( b c d e h l a f )) {
			next if $r eq 'f' && ($z80_strict || $z180 || $ez80_any || $kc160_any);

			add($cpu, "out (c), $r", 	[0xED, 0x41+8*$V{$r}]);
			add($cpu, "out (bc), $r", 	[0xED, 0x41+8*$V{$r}]);

			add($cpu, "out0 (%n), $r", 	[0xED, 0x01+8*$V{$r}, '%n']) if $z180 || $ez80_any;
		}
	}

	# OUT (C), 0
	if ($zilog && !$z80_strict) {
		add($cpu, "out (c), %c", 		[0xED, '0x41+%c(0..0)+6*8']);
		add($cpu, "out (bc), %c", 		[0xED, '0x41+%c(0..0)+6*8']);
	}
	
	# TSTIO
	if ($z180 || $ez80_any) {
		add($cpu, "tstio %n", 			[0xED, 0x74, '%n']);
	}

	# Block input/output
	if ($zilog || $kc160_any) {
		add_suf($cpu, "ini", 	[0xED, 0xA2]);
		add_suf($cpu, "inir", 	[0xED, 0xB2]);
		add_suf($cpu, "ind", 	[0xED, 0xAA]);
		add_suf($cpu, "indr", 	[0xED, 0xBA]);

		add_suf($cpu, "outi", 	[0xED, 0xA3]);
		add_suf($cpu, "otir", 	[0xED, 0xB3]);
		add_suf($cpu, "outd", 	[0xED, 0xAB]);
		add_suf($cpu, "otdr", 	[0xED, 0xBB]);
	}
	
	if ($kc160_any) {
		add($cpu, "ini x", 		[0xED, 0xE2]);
		add($cpu, "inir x", 	[0xED, 0xF2]);
		add($cpu, "ind x", 		[0xED, 0xEA]);
		add($cpu, "indr x", 	[0xED, 0xFA]);

		add($cpu, "outi x", 	[0xED, 0xE3]);
		add($cpu, "otir x", 	[0xED, 0xF3]);
		add($cpu, "outd x", 	[0xED, 0xEB]);
		add($cpu, "otdr x", 	[0xED, 0xFB]);
	}
	
	if ($zilog) {
		if ($z180 || $ez80_any) {
			add_suf($cpu, "otdm", 	[0xED, 0x8B]);
			add_suf($cpu, "otdmr", 	[0xED, 0x9B]);
			add_suf($cpu, "otim", 	[0xED, 0x83]);
			add_suf($cpu, "otimr", 	[0xED, 0x93]);
		}
		
		if ($ez80_any) {
			add_suf($cpu, "ini2", 	[0xED, 0x84]);
			add_suf($cpu, "ini2r", 	[0xED, 0x94]);
			add_suf($cpu, "ind2", 	[0xED, 0x8C]);
			add_suf($cpu, "ind2r", 	[0xED, 0x9C]);
			add_suf($cpu, "inim", 	[0xED, 0x82]);
			add_suf($cpu, "inimr", 	[0xED, 0x92]);
			add_suf($cpu, "indm", 	[0xED, 0x8A]);
			add_suf($cpu, "indmr", 	[0xED, 0x9A]);
			add_suf($cpu, "inirx", 	[0xED, 0xC2]);
			add_suf($cpu, "indrx", 	[0xED, 0xCA]);
			
			add_suf($cpu, "outd2", 	[0xED, 0xAC]);
			add_suf($cpu, "outi2", 	[0xED, 0xA4]);
			add_suf($cpu, "otd2r", 	[0xED, 0xBC]);
			add_suf($cpu, "otdrx", 	[0xED, 0xCB]);
			add_suf($cpu, "oti2r", 	[0xED, 0xB4]);
			add_suf($cpu, "otirx", 	[0xED, 0xC3]);
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

	if (!$rabbit && !$gameboy) {
		add($cpu, "in %n",	[0xDB, '%n']);
		add($cpu, "out %n",	[0xD3, '%n']);
	}

	if ($z80n) {
		add($cpu, "outinb",			[0xED, 0x90]);
		add($cpu, "otib",			[0xED, 0x90]);
	}
	
	if ($r4k || $r5k) {
		add_x($cpu, "cbm %n", [0xED, 0x00, '%n']);
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

	#--------------------------------------------------------------------------
	# Rabbit
	#--------------------------------------------------------------------------

	if ($r4k || $r5k) {

		# CONVC / CONVD
		for my $p (qw( pw px py pz )) {
			add($cpu, "convc $p", [0xED, 0x0E+16*$V{$p}]);
			add($cpu, "convd $p", [0xED, 0x0F+16*$V{$p}]);
		}
		
		# COPY / COPYR
		add($cpu, "copy", 	[0xED, 0x80]);
		add($cpu, "copyr", 	[0xED, 0x88]);
		
		# CP
		for my $cp (qw( cp cmp )) {
			add($cpu, "$cp hl, %s",				[0x48, '%s']);
			add($cpu, "altd $cp hl, %s",		[$V{altd}], [0x48, '%s']);

			add($cpu, "$cp hl, de",				[0xED, 0x48]);
			add($cpu, "altd $cp hl, de",		[$V{altd}], [0xED, 0x48]);

			add($cpu, "$cp jkhl, bcde",			[0xED, 0x58]);
			add($cpu, "altd $cp jkhl, bcde",	[$V{altd}], [0xED, 0x58]);
		}
		
		# FLAG
		add($cpu, "flag nz, hl",		[0xED, 0xC4]);
		add($cpu, "flag z, hl",			[0xED, 0xCC]);
		add($cpu, "flag nc, hl",		[0xED, 0xD4]);
		add($cpu, "flag c, hl",			[0xED, 0xDC]);
		add($cpu, "flag gt, hl",		[0xED, 0xA4]);
		add($cpu, "flag lt, hl",		[0xED, 0xB4]);
		add($cpu, "flag gtu, hl",		[0xED, 0xAC]);
		add($cpu, "flag v, hl",			[0xED, 0xBC]);
		
		# FSYSCALL
		add($cpu, "fsyscall",			[0xED, 0x55]);
		
		# IBOX
		add($cpu, "ibox a",				[0xED, 0x12]);
		
		# LD
		add_x($cpu, "ld a, htr",		[0xED, 0x50]);
		add($cpu, "ld htr, a",			[0xED, 0x40]);
		
		for my $x (qw( ix iy )) {
			add_x($cpu, "ld a, ($x+a)",	[$V{$x}, 0x06]);
		}
		
		for my $ps (qw( pw px py pz )) {
			add_x($cpu, "ld a, ($ps+%d)",	[0x8D+16*$V{$ps}, '%d']);
			add_x($cpu, "ld a, ($ps+hl)", 	[0x8B+16*$V{$ps}]);
			add_x($cpu, "ld hl, ($ps+bc)",	[0xED, 0x06+16*$V{$ps}]);
			add_x($cpu, "ld hl, ($ps+%d)",	[0x85+16*$V{$ps}, '%d']);
			add($cpu, "ld (sp+%u), $ps",	[0xED, 0x05+16*$V{$ps}, '%u']);
		}
		
		add_x($cpu, "ld hl, (sp+hl)",		[0xED, 0xFE]);
		
		add_x($cpu, "ld lxpc, hl", 			[0x97]);
		add_x($cpu, "ld hl, lxpc", 			[0x9F]);
		
		add_x($cpu, "ld bcde, (hl)",		[0xDD, 0x1A]);
		add_x($cpu, "ld bcde, (ix+%d)",		[0xDD, 0xCE, '%d']);
		add_x($cpu, "ld bcde, (iy+%d)",		[0xDD, 0xDE, '%d']);
		add_x($cpu, "ld bcde, (%m)",		[0x93, '%m', '%m']);
		add_x($cpu, "ld bcde, %s",			[0xA3, '%s']);
		add_x($cpu, "ld bcde, (sp+hl)",		[0xDD, 0xFE]);
		add_x($cpu, "ld bcde, (sp+%u)",		[0xDD, 0xEE, '%u']);

		add_x($cpu, "ld (hl), bcde",		[0xDD, 0x1B]);
		add_x($cpu, "ld (ix+%d), bcde",		[0xDD, 0xCF, '%d']);
		add_x($cpu, "ld (iy+%d), bcde",		[0xDD, 0xDF, '%d']);
		add_x($cpu, "ld (%m), bcde",		[0x83, '%m', '%m']);
		add($cpu, "ld (sp+hl), bcde",		[0xDD, 0xFF]);
		add($cpu, "ld (sp+%u), bcde",		[0xDD, 0xEF, '%u']);

		for my $ps (qw( pw px py pz )) {
			add_x($cpu, "ld bcde, ($ps+%d)",[0xDD, 0x0E+16*$V{$ps}, '%d']);
			add_x($cpu, "ld bcde, ($ps+hl)",[0xDD, 0x0C+16*$V{$ps}]);
			add_x($cpu, "ld bcde, $ps", 	[0xDD, 0xCD+16*$V{$ps}]);
		}
		
		add_x($cpu, "ld jkhl, %s",			[0xA4, '%s']);
		add_x($cpu, "ld jkhl, (hl)",		[0xFD, 0x1A]);
		add_x($cpu, "ld jkhl, (sp+hl)",		[0xFD, 0xFE]);
		add_x($cpu, "ld jkhl, (ix+%d)",		[0xFD, 0xCE, '%d']);
		add_x($cpu, "ld jkhl, (iy+%d)",		[0xFD, 0xDE, '%d']);
		add_x($cpu, "ld jkhl, (sp+%u)",		[0xFD, 0xEE, '%u']);
		add_x($cpu, "ld jkhl, (%m)",		[0x94, '%m', '%m']);
		
		add_x($cpu, "ld (hl), jkhl",		[0xFD, 0x1B]);
		add_x($cpu, "ld (ix+%d), jkhl",		[0xFD, 0xCF, '%d']);
		add_x($cpu, "ld (iy+%d), jkhl",		[0xFD, 0xDF, '%d']);
		add_x($cpu, "ld (%m), jkhl",		[0x84, '%m', '%m']);
		add($cpu, "ld (sp+hl), jkhl",		[0xFD, 0xFF]);
		add($cpu, "ld (sp+%u), jkhl",		[0xFD, 0xEF, '%u']);
		add_x($cpu, "ld (%m), jk",			[0x89, '%m', '%m']);

		for my $ps (qw( pw px py pz )) {
			add_x($cpu, "ld jkhl, $ps",		[0xFD, 0xCD+16*$V{$ps}]);
			add_x($cpu, "ld jkhl, ($ps+%d)",[0xFD, 0x0E+16*$V{$ps}, '%d']);
			add_x($cpu, "ld jkhl, ($ps+hl)",[0xFD, 0x0C+16*$V{$ps}]);
		}
		
		add_x($cpu, "ld jk, %m",			[0xA9, '%m', '%m']);
		add_x($cpu, "ld jk, (%m)",			[0x99, '%m', '%m']);
		
		for my $pd (qw( pw px py pz )) {
			add($cpu, "ld $pd, bcde",		[0xDD, 0x8D+16*$V{$pd}]);
			add($cpu, "ld $pd, jkhl",		[0xFD, 0x8D+16*$V{$pd}]);
			add($cpu, "ld $pd, %m",			[0xED, 0x0C+16*$V{$pd}, '%m', '%m', '%m', '%m']);
			add($cpu, "ld ($pd+bc), hl",	[0xED, 0x07+16*$V{$pd}]);
			add($cpu, "ld ($pd+%d), a",		[0x8E+16*$V{$pd}, '%d']);
			add($cpu, "ld ($pd+%d), bcde",	[0xDD, 0x0F+16*$V{$pd}, '%d']);
			add($cpu, "ld ($pd+%d), hl",	[0x86+16*$V{$pd}, '%d']);
			add($cpu, "ld ($pd+%d), jkhl",	[0xFD, 0x0F+16*$V{$pd}, '%d']);
		}
		
		for my $pd (qw( pw px py pz )) {
			for my $ps (qw( pw px py pz )) {
				add_x($cpu, "ld $pd, $ps", 		[0x6D, 0x07+16*(4*$V{$pd}+$V{$ps})]);
				add_x($cpu, "ld $pd, $ps+de", 	[0x6D, 0x06+16*(4*$V{$pd}+$V{$ps})]);
				add_x($cpu, "ld $pd, $ps+hl", 	[0x6D, 0x0E+16*(4*$V{$pd}+$V{$ps})]);
				add_x($cpu, "ld $pd, $ps+ix", 	[0x6D, 0x04+16*(4*$V{$pd}+$V{$ps})]);
				add_x($cpu, "ld $pd, $ps+iy", 	[0x6D, 0x05+16*(4*$V{$pd}+$V{$ps})]);
				add_x($cpu, "ld $pd, ($ps+%d)",	[0x6D, 0x08+16*(4*$V{$pd}+$V{$ps}), '%d']);
				add_x($cpu, "ld $pd, ($ps+hl)",	[0x6D, 0x0A+16*(4*$V{$pd}+$V{$ps})]);
				add($cpu, "ld $pd, $ps+%s", 	[0x6D, 0x0C+16*(4*$V{$pd}+$V{$ps}), '%s']);
				
				add($cpu, "ld ($pd+%d), $ps", 	[0x6D, 0x09+16*(4*$V{$ps}+$V{$pd}), '%d']);
				add($cpu, "ld ($pd+hl), $ps", 	[0x6D, 0x0B+16*(4*$V{$ps}+$V{$pd})]);
			}
		}

		for my $pd (qw( pw px py pz )) {
			add($cpu, "ld $pd, (htr+hl)", 		[0xED, 0x01+16*$V{$pd}]);
			add($cpu, "ld $pd, (sp+%u)", 		[0xED, 0x04+16*$V{$pd}, '%u']);
			add($cpu, "ld ($pd+hl), a", 		[0x8C+16*$V{$pd}]);
			add($cpu, "ld ($pd+hl), bcde", 		[0xDD, 0x0D+16*$V{$pd}]);
			add($cpu, "ld ($pd+hl), jkhl", 		[0xFD, 0x0D+16*$V{$pd}]);
		}
		
		for ([bc=>0],[de=>1],[ix=>2],[iy=>3]) {
			my($rr, $opc) = @$_;
			
			for my $ps (qw( pw px py pz )) {
				add_x($cpu, "ld $rr, ($ps+%d)",	[0x6D, 00+16*(4*$opc+$V{$ps}), '%d']);
				add_x($cpu, "ld $rr, ($ps+hl)",	[0x6D, 02+16*(4*$opc+$V{$ps})]);
			}
			
			for my $pd (qw( pw px py pz )) {
				add_x($cpu, "ld ($pd+%d), $rr",	[0x6D, 01+16*(4*$opc+$V{$pd}), '%d']);
				add($cpu, "ld ($pd+hl), $rr",	[0x6D, 03+16*(4*$opc+$V{$pd})]);
			}
		}

		# LDF
		add_x($cpu, "ldf a, (%m)",				[0x9A, '%m', '%m', '%m']);
		add_x($cpu, "ldf hl, (%m)",				[0x92, '%m', '%m', '%m']);
		add_x($cpu, "ldf bcde, (%m)",			[0xDD, 0x0A, '%m', '%m', '%m']);
		add_x($cpu, "ldf jkhl, (%m)",			[0xFD, 0x0A, '%m', '%m', '%m']);

		add($cpu, "ldf (%m), a",				[0x8A, '%m', '%m', '%m']);
		add($cpu, "ldf (%m), hl",				[0x82, '%m', '%m', '%m']);
		add($cpu, "ldf (%m), bcde",				[0xDD, 0x0B, '%m', '%m', '%m']);
		add($cpu, "ldf (%m), jkhl",				[0xFD, 0x0B, '%m', '%m', '%m']);
		
		for my $pd (qw( pw px py pz )) {
			add_x($cpu, "ldf $pd, (%m)",		[0xED, 0x08+16*$V{$pd}, '%m', '%m', '%m']);
		}

		for ([bc=>0],[de=>1],[ix=>2],[iy=>3]) {
			my($rr, $opc) = @$_;
			add_x($cpu, "ldf $rr, (%m)",		[0xED, 0x0A+16*$opc, '%m', '%m', '%m']);
			add_x($cpu, "ldf (%m), $rr",		[0xED, 0x0B+16*$opc, '%m', '%m', '%m']);
		}
			
		for my $ps (qw( pw px py pz )) {
			add($cpu, "ldf (%m), $ps",			[0xED, 0x09+16*$V{$ps}, '%m', '%m', '%m']);
		}

		# LDL
		for my $pd (qw( pw px py pz )) {
			add_x($cpu, "ldl $pd, de", 			[0xDD, 0x8F+16*$V{$pd}]);
			add_x($cpu, "ldl $pd, hl", 			[0xFD, 0x8F+16*$V{$pd}]);
			add_x($cpu, "ldl $pd, ix", 			[0xDD, 0x8C+16*$V{$pd}]);
			add_x($cpu, "ldl $pd, iy", 			[0xFD, 0x8C+16*$V{$pd}]);
			add_x($cpu, "ldl $pd, %m", 			[0xED, 0x0D+16*$V{$pd}, '%m', '%m']);
			add_x($cpu, "ldl $pd, (sp+%u)", 	[0xED, 0x03+16*$V{$pd}, '%u']);
		}
		
		# TODO: Rabbit LLCALL, LLRET, LLJP, SJP not supported

		# MULU
		add($cpu, "mulu", 						[0xA7]);
		
		# NEG
		add($cpu, "neg bcde",					[0xDD, 0x4D]);
		add($cpu, "neg bcde'",					[$V{altd}], [0xDD, 0x4D]);
		add($cpu, "altd neg bcde",				[$V{altd}], [0xDD, 0x4D]);
		
		add($cpu, "neg jkhl",					[0xFD, 0x4D]);
		add($cpu, "neg jkhl'",					[$V{altd}], [0xFD, 0x4D]);
		add($cpu, "altd neg jkhl",				[$V{altd}], [0xFD, 0x4D]);
		
		add($cpu, "neg hl",						[0x4D]);
		add($cpu, "neg hl'",					[$V{altd}], [0x4D]);
		add($cpu, "altd neg hl",				[$V{altd}], [0x4D]);
		
		# OR
		add_x($cpu, "or jkhl, bcde",			[0xED, 0xF6]);
		
		# POP
		add_x($cpu, "pop bcde",					[0xDD, 0xF1]);
		add_x($cpu, "pop jkhl",					[0xFD, 0xF1]);

		for my $pd (qw( pw px py pz )) {
			add_x($cpu, "pop $pd", 				[0xED, 0xC1+16*$V{$pd}]);
		}
		
		# PUSH
		add($cpu, "push bcde",					[0xDD, 0xF5]);
		add($cpu, "push jkhl",					[0xFD, 0xF5]);

		add($cpu, "push %m",					[0xED, 0xA5, '%m', '%m']);
		
		for my $ps (qw( pw px py pz )) {
			add($cpu, "push $ps",				[0xED, 0xC5+16*$V{$ps}]);
		}
		
		# rotate 1|2|4|8, bcde|jkhl
		for ([rlc=>0x40,8], [rrc=>0x50,8],  [rl=>0x60,8],  [rr=>0x70,8],
		     [sla=>0x80,4], [sra=>0x90,4], [sll=>0xA0,4], [srl=>0xB0,4]) {
			my($rot, $base, $max_c) = @$_;
			for ([bcde=>0xDD], [jkhl=>0xFD]) {
				my($reg, $pfx) = @$_;
				
				my $expr = sprintf("==1?0x%X:%%c==2?0x%X:%%c==4?0x%X:0x%X", 
								   $base+0x08, $base+0x09, $base+0x0B, $base+0x0F);
				my $cond1 = $max_c==8 ? "%c(1,2,4,8)" : "%c(1,2,4)";
				my $cond2 = "%c(1,2,4)";
				
				add($cpu, "$rot %c, $reg",		[$pfx, $cond1.$expr]);
				add($cpu, "altd $rot %c, $reg",	[$V{altd}], [$pfx, $cond2.$expr]);
				add($cpu, "$rot %c, $reg'",		[$V{altd}], [$pfx, $cond2.$expr]);
			}
		}

		# RLB
		add($cpu, "rlb a, bcde",				[0xDD, 0x6F]);
		add($cpu, "rlb a, jkhl",				[0xFD, 0x6F]);
		
		# RLC
		add_x($cpu, "rlc bc",					[0x60]);
		add_x($cpu, "rlc de",					[0x50]);
	
		# RRB
		add($cpu, "rrb a, bcde",				[0xDD, 0x7F]);
		add($cpu, "rrb a, jkhl",				[0xFD, 0x7F]);
		
		# RRC
		add_x($cpu, "rrc bc",					[0x61]);
		add_x($cpu, "rrc de",					[0x51]);
		
		# SBOX
		add($cpu, "sbox a", 					[0xED, 0x02]);
		add($cpu, "sbox a'", 					[$V{altd}], [0xED, 0x02]);
		add($cpu, "altd sbox a", 				[$V{altd}], [0xED, 0x02]);
		
		# SETSYSP
		add($cpu, "setsysp %m",					[0xED, 0xB1, '%m', '%m']);
		
		# SETUSRP
		add($cpu, "setusrp %m",					[0xED, 0xB5, '%m', '%m']);
		
		# SUB
		add_x($cpu, "sub hl, jk",				[0x45]);
		add_x($cpu, "sub jkhl, bcde",			[0xED, 0xD6]);
		
		# SYSRET
		add($cpu, "sysret",						[0xED, 0x83]);
		add($cpu, "sret",						[0xED, 0x83]);
		
		# TEST
		add($cpu, "test hl",					[0x4C]);
		add($cpu, "altd test hl",				[$V{altd}], [0x4C]);
		
		add($cpu, "test bc",					[0xED, 0x4C]);
		add($cpu, "altd test bc",				[$V{altd}], [0xED, 0x4C]);
		
		add($cpu, "test bcde",					[0xDD, 0x5C]);
		add($cpu, "altd test bcde",				[$V{altd}], [0xDD, 0x5C]);
		
		add($cpu, "test ix",					[0xDD, 0x4C]);
		add($cpu, "altd test ix",				[$V{altd}], [0xDD, 0x4C]);
		
		add($cpu, "test iy",					[0xFD, 0x4C]);
		add($cpu, "altd test iy",				[$V{altd}], [0xFD, 0x4C]);
		
		add($cpu, "test jkhl",					[0xFD, 0x5C]);
		add($cpu, "altd test jkhl",				[$V{altd}], [0xFD, 0x5C]);
	}
	
	#--------------------------------------------------------------------------
	# KC150
	#--------------------------------------------------------------------------
	
	if ($kc160_ext) {
		# LD r, (xHL|xIX+d|xIY+d)
		for my $p (qw( x y a p z )) {
			for my $r (qw( b c d e h l a )) {
				add($cpu, "ld $r, (${p}hl)",	[$V{"const1_$p"}], 
												[0x46+8*$V{$r}]);
				for my $x (qw( ix iy )) {
					add($cpu, "ld $r, ($p$x+%d)",
												[$V{"const1_$p"}], 
												[$V{$x}, 0x46+8*$V{$r}, '%d']);
				}
			}
		}

		# LD (xHL|xIX+d|xIY+d), r
		for my $p (qw( x y a p z )) {
			for my $r (qw( b c d e h l a )) {
				add($cpu, "ld (${p}hl), $r",	[$V{"const1_$p"}], 
												[0x70+$V{$r}]);
				for my $x (qw( ix iy )) {
					add($cpu, "ld ($p$x+%d), $r",
												[$V{"const1_$p"}], 
												[$V{$x}, 0x70+$V{$r}, '%d']);
				}
			}
		}

		# LD (xHL|xIX+d|xIY+d), n
		for my $p (qw( x y a p z )) {
			add($cpu, "ld (${p}hl), %n",	[$V{"const1_$p"}], 
											[0x36, '%n']);
			for my $x (qw( ix iy )) {
				add($cpu, "ld ($p$x+%d), %n",
											[$V{"const1_$p"}], 
											[$V{$x}, 0x36, '%d', '%n']);
			}
		}
		
		# LD A, (xBC|xDE)
		for my $p (qw( x y a p z )) {
			for my $dd (qw( bc de )) {
				add($cpu, "ld a, (${p}${dd})",
											[$V{"const1_$p"}], 
											[0x0A+16*$V{$dd}]);
			}
		}
		
		# LD A, (xP:%m)
		for my $p (qw( x y a p z )) {
			my $t = $p eq 'a' ? $p : $p.'p';
			add($cpu, "ld a, ($t:%m)",		[$V{"const1_$p"}], 
											[0x3A, '%m', '%m']);
		}
		
		# LD (xBC|xDE), A
		for my $p (qw( x y a p z )) {
			for my $dd (qw( bc de )) {
				add($cpu, "ld (${p}${dd}), a",
											[$V{"const1_$p"}], 
											[0x02+16*$V{$dd}]);
			}
		}
		
		# LD (xP:%m), A
		for my $p (qw( x y a p z )) {
			my $t = $p eq 'a' ? $p : $p.'p';
			add($cpu, "ld ($t:%m), a",		[$V{"const1_$p"}], 
											[0x32, '%m', '%m']);
		}
	}
	
	if ($kc160_any) {
		# LD A, xP
		add($cpu, "ld a, zp",				[0xED, 0xC4]);
		add($cpu, "ld a, yp",				[0xED, 0xCC]);
		add($cpu, "ld a, xp",				[0xED, 0xC5]);
		
		add($cpu, "ld xp, yp",				[0xED, 0xD4]);
		add($cpu, "ld xp, zp",				[0xED, 0xDC]);
		add($cpu, "ld xp, a",				[0xED, 0xD5]);
		
		add($cpu, "ld yp, xp",				[0xED, 0xE4]);
		add($cpu, "ld yp, a",				[0xED, 0xEC]);
		add($cpu, "ld yp, zp",				[0xED, 0xE5]);
		
		add($cpu, "ld zp, a",				[0xED, 0xF4]);
		add($cpu, "ld zp, xp",				[0xED, 0xFC]);
		add($cpu, "ld zp, yp",				[0xED, 0xF5]);
		
		# LDF (%m), A
		add($cpu, "ldf (%m), a",			[0xED, 0x33, '%m', '%m', '%m']);
		
		# LDF A, (%m)
		add($cpu, "ldf a, (%m)",			[0xED, 0x3B, '%m', '%m', '%m']);
	}
	
	if ($kc160_ext) {
		# LD HL, (xP:%m)
		for my $p (qw( x y a p z )) {
			my $t = $p eq 'a' ? $p : $p.'p';
			add($cpu, "ld hl, ($t:%m)",		[$V{"const1_$p"}], 
											[0x2A, '%m', '%m']);

			for my $x (qw( ix iy )) {
				add($cpu, "ld $x, ($t:%m)",	[$V{"const1_$p"}], 
											[$V{$x}, 0x2A, '%m', '%m']);
			}
		}
		
		# LD (xP:%m), HL
		for my $p (qw( x y a p z )) {
			my $t = $p eq 'a' ? $p : $p.'p';
			add($cpu, "ld ($t:%m), hl",		[$V{"const1_$p"}], 
											[0x22, '%m', '%m']);

			for my $x (qw( ix iy )) {
				add($cpu, "ld ($t:%m), $x",	[$V{"const1_$p"}], 
											[$V{$x}, 0x22, '%m', '%m']);
			}
		}
		
		# LD dd, (xP:%m)
		for my $p (qw( x y a p z )) {
			for my $dd (qw( bc de hl sp )) {
				next if $dd eq 'hl';
				my $t = $p eq 'a' ? $p : $p.'p';
				add($cpu, "ld $dd, ($t:%m)",
											[$V{"const1_$p"}], 
											[0xED, 0x4B+16*$V{$dd}, '%m', '%m']);
			}
		}
		
		# LD (xP:%m), dd
		for my $p (qw( x y a p z )) {
			for my $dd (qw( bc de hl sp )) {
				next if $dd eq 'hl';
				my $t = $p eq 'a' ? $p : $p.'p';
				add($cpu, "ld ($t:%m), $dd",
											[$V{"const1_$p"}], 
											[0xED, 0x43+16*$V{$dd}, '%m', '%m']);
			}
		}
	}
	
	if ($kc160_any) {
		# LDF (%m), dd|IX|IY
		for my $dd (qw( bc de hl sp )) {
			add($cpu, "ldf (%m), $dd",		[0xED, 0x87+16*$V{$dd}, '%m', '%m', '%m']);
		}
		add($cpu, "ldf (%m), ix",			[0xED, 0x83, '%m', '%m', '%m']);
		add($cpu, "ldf (%m), iy",			[0xED, 0x93, '%m', '%m', '%m']);

		# LDF dd|IX|IY, (%m)
		for my $dd (qw( bc de hl sp )) {
			add($cpu, "ldf $dd, (%m)",		[0xED, 0x8F+16*$V{$dd}, '%m', '%m', '%m']);
		}
		add($cpu, "ldf ix, (%m)",			[0xED, 0x8B, '%m', '%m', '%m']);
		add($cpu, "ldf iy, (%m)",			[0xED, 0x9B, '%m', '%m', '%m']);
	}
	
	if ($kc160_ext) {
		# LD (xIX+d|xIY+d), dd|IX|IY
		for my $p (qw( x y a p z )) {
			for my $dd (qw( bc de hl sp )) {
				add($cpu, "ld (${p}ix+%d), $dd",
											[$V{"const1_$p"}], 
											[0xED, 0x85+16*$V{$dd}, '%d']);
				add($cpu, "ld (${p}iy+%d), $dd",
											[$V{"const1_$p"}], 
											[0xED, 0x84+16*$V{$dd}, '%d']);
			}
			add($cpu, "ld (${p}ix+%d), ix",	[$V{"const1_$p"}], 
											[0xED, 0x81, '%d']);
			add($cpu, "ld (${p}iy+%d), ix",	[$V{"const1_$p"}], 
											[0xED, 0x80, '%d']);
			add($cpu, "ld (${p}ix+%d), iy",	[$V{"const1_$p"}], 
											[0xED, 0x91, '%d']);
			add($cpu, "ld (${p}iy+%d), iy",	[$V{"const1_$p"}], 
											[0xED, 0x90, '%d']);
		}
		
		# LD dd|IX|IY, (xIX+d|xIY+d)
		for my $p (qw( x y a p z )) {
			for my $dd (qw( bc de hl sp )) {
				add($cpu, "ld $dd, (${p}ix+%d)",
											[$V{"const1_$p"}], 
											[0xED, 0x8D+16*$V{$dd}, '%d']);
				add($cpu, "ld $dd, (${p}iy+%d)",
											[$V{"const1_$p"}], 
											[0xED, 0x8C+16*$V{$dd}, '%d']);
			}
			add($cpu, "ld ix, (${p}ix+%d)",	[$V{"const1_$p"}], 
											[0xED, 0x89, '%d']);
			add($cpu, "ld ix, (${p}iy+%d)",	[$V{"const1_$p"}], 
											[0xED, 0x88, '%d']);
			add($cpu, "ld iy, (${p}ix+%d)",	[$V{"const1_$p"}], 
											[0xED, 0x99, '%d']);
			add($cpu, "ld iy, (${p}iy+%d)",	[$V{"const1_$p"}], 
											[0xED, 0x98, '%d']);
		}
	}
	
	if ($kc160_any) {
		for ([xix=>0], [yiy=>1], [ahl=>2]) {
			my($pdd, $code) = @$_;

			# LD (IXY+d), xdd
			add($cpu, "ld (ix+%d), $pdd",	[0xED, 0x01+16*$code, '%d']);
			add($cpu, "ld (iy+%d), $pdd",	[0xED, 0x00+16*$code, '%d']);
			
			# LD (DP+d), xdd
			add($cpu, "ld (sp+%d), $pdd",	[0xED, 0x02+16*$code, '%d']);
		
			# LD (%m), xdd
			add($cpu, "ldf (%m), $pdd",		[0xED, 0x03+16*$code, '%m', '%m', '%m']);

			# LD xdd, (IXY+d)
			add($cpu, "ld $pdd, (ix+%d)",	[0xED, 0x09+16*$code, '%d']);
			add($cpu, "ld $pdd, (iy+%d)",	[0xED, 0x08+16*$code, '%d']);
			
			# LD xdd, (DP+d)
			add($cpu, "ld $pdd, (sp+%d)",	[0xED, 0x0A+16*$code, '%d']);
		
			# LD xdd, (%m)
			add($cpu, "ldf $pdd, (%m)",		[0xED, 0x0B+16*$code, '%m', '%m', '%m']);
		}
	}
	
	if ($kc160_ext) {
		for my $p (qw( x y a p z )) {
			for ([xix=>0], [yiy=>1], [ahl=>2]) {
				my($pdd, $code) = @$_;
				
				# LD (xIXY+d), xdd
				add($cpu, "ld (${p}ix+%d), $pdd",
											[$V{"const1_$p"}], 
											[0xED, 0x01+16*$code, '%d']);
				add($cpu, "ld (${p}iy+%d), $pdd",
											[$V{"const1_$p"}], 
											[0xED, 0x00+16*$code, '%d']);
				
				# LD xdd, (xIXY+d)
				add($cpu, "ld $pdd, (${p}ix+%d)",
											[$V{"const1_$p"}], 
											[0xED, 0x09+16*$code, '%d']);
				add($cpu, "ld $pdd, (${p}iy+%d)",
											[$V{"const1_$p"}], 
											[0xED, 0x08+16*$code, '%d']);
			}
		}
	}
	
	if ($kc160_any) {
		for ([xix=>0], [yiy=>1], [ahl=>2]) {
			my($pdd, $code) = @$_;

			# LD xdd, %m
			add($cpu, "ld $pdd, %m",		[0xED, 0x0E+16*$code, '%m', '%m', '%m']);
			
			# PUSH xdd
			add($cpu, "push $pdd",			[0xED, 0x07+16*$code]);

			# POP xdd
			add($cpu, "pop $pdd",			[0xED, 0x0F+16*$code]);
		}

		# MUL/DIV
		add($cpu, "mul hl",					[0xED, 0x76]);
		add($cpu, "muls hl",				[0xED, 0x7E]);
		add($cpu, "div hl, a",				[0xED, 0x74]);
		add($cpu, "divs hl, a",				[0xED, 0x7C]);
		
		add($cpu, "mul de, hl",				[0xED, 0x77]);
		add($cpu, "muls de, hl",			[0xED, 0x7F]);
		add($cpu, "div dehl, bc",			[0xED, 0x75]);
		add($cpu, "divs dehl, bc",			[0xED, 0x7D]);
	}
}

#------------------------------------------------------------------------------
# write file
#------------------------------------------------------------------------------
my $yaml = YAML::Tiny->new(\%opcodes);
$yaml->write($output_file);

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
sub exx		{					return 0xD9; }

#------------------------------------------------------------------------------
# add opcode
#------------------------------------------------------------------------------
sub add {
	my($cpu, $asm, @ops) = @_;
	
	#use Carp 'longmess';
	#say "$cpu\t$asm\n".dump(longmess()) if $asm =~ /ld \(xhl\), %n/;
	
	# convert (ix+d) to (ix) with offset 0
	if ($asm =~ /[xyapz]?(ix|iy|hl|sp|pw|px|py|pz)\+%[dus]/) {
		if (!($cpu =~ /^kc160/ && $asm eq 'ld hl, sp+%s')) {			
			(my $asm1 = $asm) =~ s/\+%[dus]//;
			if ($asm1 ne "ld de, hl" && $asm1 !~ /ld p[wxyz], p[wxyz]/) {
				my @ops1 = @{clone(\@ops)};
				for (@ops1) { for (@$_) { s/^%[dus]$/0/; s/^%D$/1/; } }
				add($cpu, $asm1, @ops1);
			}
		}
	}

	if (defined($opcodes{$asm}{$cpu})) {
		die "$asm $cpu exists:\n", dump($opcodes{$asm}{$cpu});
	}
	$opcodes{$asm}{$cpu} = \@ops;
}

sub add_x {
	my($cpu, $asm, @ops) = @_;
	
	add_suf($cpu, $asm, @{clone(\@ops)});
	
	my @bytes = @{$ops[0]};
	my @rest = @{clone([@ops[1..$#ops]])};
	
	# ixh
	if ($cpu =~ /^z80n?|^ez80|^r800/ && $cpu !~ /z80_strict/ && $asm =~ /\b[hl]\b/ && 
		$asm !~ /\(hl|bit|res|set|rlc|rrc|rl|rr|sla|sra|sll|sls|srl|sli/) {
		for my $x (qw( ix iy )) {
			my $asm1 = $asm =~ s/\b([hl])\b/$x$1/gr;
			if ($asm ne $asm1) {
				add_suf($cpu, $asm1, [$V{$x}, @bytes], @rest);
			}
		}
	}
	
	# (ix+d)
	if ($cpu =~ /^z|^r2ka|^r3k|^r4k|^r5k|^ez80|^r800|^kc160/ && 
	    $asm =~ /[xyapz]?\(hl\)/ && 
		$asm !~ /ldi|ldd/ && $ops[0][0] != 0xDD && $ops[0][0] != 0xFD) {
		for my $x (qw( ix iy )) {
			my $asm1 = $asm =~ s/([xyapz]?)\(hl\)/($1$x+%d)/gr;
			if ($asm ne $asm1) {
				if ($bytes[0] == 0x7F) {
					add_suf($cpu, $asm1, 
						[$V{$x}, $bytes[1], '%d', @bytes[2..$#bytes]], @rest);
				}
				else {
					add_suf($cpu, $asm1, 
						[$V{$x}, $bytes[0], '%d', @bytes[1..$#bytes]], @rest);
				}
			}
		}
	}					
}

sub add_suf {
	my($cpu, $asm, @ops) = @_;
	
	add($cpu, $asm, @{clone(\@ops)});
	
	# rabbit
	if ($cpu =~ /^r2ka|^r3k|^r4k|^r5k/) {
		# expand ioi ioe
		my $has_io;
		if (($asm =~ /\((ix|iy|hl|bc|de|%m)/ && $asm !~ /^(ldp|jp|jmp|ldf)/) ||
			($asm =~ /^(ldi|ldir|ldd|lddr|ldisr|lddsr|lsdr|lsir|lsddr|lsidr|cbm)\b/)) {
			add($cpu, "ioi $asm", [$V{ioi}], @{clone(\@ops)});
			add($cpu, "ioe $asm", [$V{ioe}], @{clone(\@ops)});
			$has_io = 1;
		}

		# expand altd
		if ($asm =~ /^ (?| ( (?:ld|ldf|ldl|inc|dec|pop|bool|clr) \s+ 
							 (?:a|b|c|d|e|h|l|af|bc|de|hl|jk|bcde|jkhl|pw|px|py|pz)) ( $ | \b [^'] .*)
						 | ( (?:rl|rr|rlc|rrc|sla|sra|sll|sls|sli|srl) \s+ 
							 (?:a|b|c|d|e|h|l)) ( $ | \b [^'] .*)
						 | ( (?:rrc?) \s+ (?:%c,\s*)? (?:bc|de|hl|bcde|jkhl)) ( $ | \b [^'] .*)
						 | ( (?:rlc?) \s+ (?:%c,\s*)? (?:bc|de|hl|bcde|jkhl)) ( $ | \b [^'] .*)
						 | ( (?:add|adc|sub|sbc|and|xor|or|neg) \s+ (?:a|hl|jkhl) )(,.*)
						 | ( (?:rlca|rrca|rla|rra)) (.*)
						 | ( (?:res|set) \s+ %c \s* , \s* 
						     (?:a|b|c|d|e|h|l)) ( $ | \b [^'] .*)
						 | ( (?:add|adc|and|or|sbc) \s+ (?:hl|jkhl|ix|iy|sp) )
						   (, \s* (?:bc|de|hl|jk|sp|bcde|%s) )
					   ) $/x &&
				$asm !~ /^ ld \s+ (bc|de|hl) \s* , \s* (bc|de|hl) /x) {
			if ($has_io) {
				my($a, $b) = ($1, $2);
				if ($a !~ /(?:ix|iy|sp)$/) {
					add($cpu, "$a'$b", 		[$V{altd}], @{clone(\@ops)});
					add($cpu, "ioi $a'$b", 	[$V{ioi}], [$V{altd}], @{clone(\@ops)});
					add($cpu, "ioe $a'$b", 	[$V{ioe}], [$V{altd}], @{clone(\@ops)});
				}				
				add($cpu, "altd $a$b", 		[$V{altd}], @{clone(\@ops)});
				add($cpu, "altd ioi $a$b", 	[$V{altd}], [$V{ioi}], @{clone(\@ops)});
				add($cpu, "altd ioe $a$b", 	[$V{altd}], [$V{ioe}], @{clone(\@ops)});
				add($cpu, "ioi altd $a$b", 	[$V{ioi}], [$V{altd}], @{clone(\@ops)});
				add($cpu, "ioe altd $a$b", 	[$V{ioe}], [$V{altd}], @{clone(\@ops)});
			}
			else {
				my($a, $b) = ($1, $2);
				if ($a !~ /(?:ix|iy|sp)$/) {
					add($cpu, "$a'$b",	[$V{altd}], @{clone(\@ops)});
				}
				add($cpu, "altd $a$b", 	[$V{altd}], @{clone(\@ops)});
			}
		}
		elsif ($asm =~ /^ (?| ( (?:add|adc|sub|sbc|and|xor|or) \s+ [^,]+ )
							| ( (?:and|or) \s+ (ix|iy) \s* , .* )
							| ( (?:inc|dec) \s+ \( .* )
							| ( (?:bool|rr) \s+ (ix|iy) .* )
							| ( (?:cp|cmp|bit) \s+ .*) 
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
	# ez80
	elsif ($cpu =~ /^ez80/) {
		if ($asm =~ /^ (?| (add|adc|inc|dec|ld|lea|pea|mlt|push|pop|sbc) \b 
						   (\s+ (?:bc|de|hl|sp|af|ix|iy)\b .*)
						 | (add|adc|sub|sbc|and|xor|or|cp|cmp|
						    bit|set|res|inc|dec|ex|jp|jmp|ld|ldi|ldd|
							rlc|rrc|rl|rr|sla|sra|srl|tst|test) \b
		                   (.*? \( (?:bc|de|hl|sp|ix|iy) .*? \) .* )
						 | (cpd|cpdr|cpi|cpir|
							ini|inir|ind|indr|
						    ini2|ini2r|ind2|ind2r|
							inim|inimr|indm|indmr|inirx|indrx|
							otd2r|otdm|otdmr|otdr|otdrx|oti2r|otim|otimr|
							otir|otirx|outd|outd2|outi|outi2|
							ldi|ldir|ldd|lddr|
							rst) \b (.*)
						) $/x) {
			if ($cpu eq 'ez80_z80') {
				add($cpu, "$1.l$2", 	[0x49], @{clone(\@ops)});
				add($cpu, "$1.lis$2", 	[0x49], @{clone(\@ops)});
			}
			elsif ($cpu eq 'ez80') {
				add($cpu, "$1.s$2", 	[0x52], @{clone(\@ops)});
				add($cpu, "$1.sil$2", 	[0x52], @{clone(\@ops)});
			}
		}
	}
}
