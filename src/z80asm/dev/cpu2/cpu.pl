#!/usr/bin/perl

#------------------------------------------------------------------------------
# z80asm assembler
# Generate test code and parsing tables for the cpus supported by z80asm
# Copyright (C) Paulo Custodio, 2011-2019
# License: http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------

use Modern::Perl;
use Path::Tiny;
use Text::Table;
use Test::More;
use Clone 'clone';
use Data::Dump 'dump';
use Config;
use warnings FATAL => 'uninitialized'; 

# make sure to use our z80asm
$ENV{PATH} = join($Config{path_sep}, ".", "../ticks", $ENV{PATH});

#------------------------------------------------------------------------------
# Globals
#------------------------------------------------------------------------------
our @CPUS = sort qw( 8080 8085 gbz80 r2k r3k z180 z80 z80n );
our %CPU_I; for (0 .. $#CPUS) { $CPU_I{$CPUS[$_]} = $_; }
our $cpu = 'z80';
our $ixiy;

our $opcodes_file 			= path(path($0)->dirname, "opcodes.csv");
our $opcodes_by_asm_file 	= path(path($0)->dirname, "opcodes_by_asm.csv");
our $opcodes_by_bytes_file 	= path(path($0)->dirname, "opcodes_by_bytes.csv");
our @opcodes_files 			= ($opcodes_file, $opcodes_by_asm_file, $opcodes_by_bytes_file);

our $cpu_rules_file			= path(path($0)->dirname, "cpu_rules.h");
our $parser_table_file		= path(path($0)->dirname, "parser.csv");
our @parser_files			= ($cpu_rules_file, $parser_table_file);

our $tests_file				= path(path($0)->dirname, "tests.csv");
our @tests_files			= ($tests_file);
our %cpu_test_file;
for $cpu (@CPUS) {
	for $ixiy ('', '_ixiy') {
		for my $ok ('ok', 'err') {
			next if $ixiy && $ok eq 'err';
			my $file 		= path(path($0)->dirname, "cpu_test_${cpu}${ixiy}_${ok}.asm");
			$cpu_test_file{$cpu}{$ixiy}{$ok} = $file;
			push @tests_files, $file;
		}
	}
}

our @all_files 				= (@opcodes_files, @parser_files, @tests_files);

#------------------------------------------------------------------------------
# $Opcodes{$asm}{$cpu} = Prog
# %n	unsigned byte
# %d  	8-bit signed offset in ix|iy indirect addressing
# %s  	8-bit signed offset
# %j 	relative jump offset
# %m	16-bit value
# %c	constant
our %Opcodes;

#------------------------------------------------------------------------------
# $Parser{$tokens}{$cpu}{$parens}{ixiy|iyix} = [$asm, Prog]
our %Parser;			

our $expr_in_parens	= '(expr)';
our $expr_no_parens	= 'expr';
our $no_expr		= '-';

#------------------------------------------------------------------------------
# %Tests: $Tests{$asm}{$cpu} = Prog
our %Tests;

#------------------------------------------------------------------------------
our $table_separator = "|";

#------------------------------------------------------------------------------
# Predicates
#------------------------------------------------------------------------------
sub is8080() 		{ return $cpu eq '8080'; }
sub is8085() 		{ return $cpu eq '8085'; }
sub isintel() 		{ return is8080() || is8085(); }
sub isgbz80()		{ return $cpu eq 'gbz80'; }
sub isz80()			{ return $cpu eq 'z80'; }
sub isz80n() 		{ return $cpu eq 'z80n'; }
sub isz180() 		{ return $cpu eq 'z180'; }
sub iszilog() 		{ return isz80() || isz80n() || isz180(); }
sub isr2k()			{ return $cpu eq 'r2k'; }
sub isr3k()			{ return $cpu eq 'r3k'; }
sub israbbit()		{ return isr2k() || isr3k(); }

sub ixiy_asm_flag()	{ return $ixiy ? "--IXIY " : ""; }
sub restarts()		{ return israbbit ? (          0x10,0x18,0x20,0x28,     0x38) :
									    (0x00,0x08,0x10,0x18,0x20,0x28,0x30,0x38); }
										
#------------------------------------------------------------------------------
# Symbol table for library code
#------------------------------------------------------------------------------
our %symtab;
sub init_symtab() { %symtab = (); }
sub have_symbols() { return !!%symtab; }

#------------------------------------------------------------------------------
# Bytes and Ticks
#------------------------------------------------------------------------------
sub B {
	my(@bytes) = @_;
	for (0 .. $#bytes) {
		if ($bytes[$_] =~ /^\@(\w+)$/) {
			my $sym = $1;
			splice(@bytes, $_, 1, "(\@$sym&0xFF)", "((\@$sym>>8)&0xFF)");
		}
	}		
	return bless [@bytes], 'B';
}

sub B::clone {
	my($self) = @_;
	return B(@$self);
}

sub B::to_string {
	my($self) = @_;
	my @bytes = @$self;
	for (@bytes) {
		if (/\@(?:__z80asm__)?(\w+)&0xFF/) {
			$_ = "\@$1";
		}
		elsif (/\@(?:__z80asm__)?(\w+)>>8/) {
			$_ = undef;
		}
		else {
			s/(\d+)/ sprintf("%02X", $1) /ge;
		}
	}
	return join(' ', grep {defined} @bytes);
}

{ package B; use overload '""' => 'to_string'; }


sub T {
	my(@ticks) = @_;
	die if @ticks < 1;
	push @ticks, $ticks[0] if @ticks == 1;
	die if @ticks > 2;
	return bless [@ticks], 'T';
}

sub T::clone {
	my($self) = @_;
	return T(@$self);
}

sub T::add {
	my($self, $add) = @_;
	ref($self) or die;
	ref($add) and die;
	return T($self->[0]+$add, $self->[1]+$add);
}

sub T::to_string {
	my($self) = @_;
	my @ticks = @$self;
	pop @ticks if $ticks[0]==$ticks[1];
	return sprintf("%7s T", join('/', @ticks));
}

{ package T; use overload '+' => 'add', '""' => 'to_string'; }
	
#------------------------------------------------------------------------------
# Assembly instruction
#------------------------------------------------------------------------------
{
	package Instr;
	use Modern::Perl;
	use Object::Tiny::RW qw( _asm _bytes ticks args asmpc );
	
	sub new {
		my($class, $asm, $bytes, $ticks, %args) = @_;
		return bless { 
			_asm => $asm, _bytes => $bytes->clone, ticks => $ticks->clone, 
			args => \%args, asmpc => 0}, $class;
	}
	
	sub clone {
		my($self, %args) = @_;
		return bless {
			_asm 	=> $self->_asm, 
			_bytes 	=> $self->_bytes->clone, 
			ticks 	=> $self->ticks->clone,
			args 	=> {%{$self->args}, %args}, 
			asmpc 	=> 0}, ref($self);
	}

	sub asm {
		my($self) = @_;
		my $asm = $self->_asm;
		while (my($k, $v) = each %{$self->args}) {
			$asm =~ s/%$k/$v/;
		}
		return $asm;
	}
	
	sub bytes {
		my($self) = @_;
		my @bytes = @{$self->_bytes};
		
		# replace args
		while (my($k, $v) = each %{$self->args}) {
			if ($k eq 'm') {
				array_replace_first(\@bytes, "%$k", $v & 0xFF, "%$k", ($v>>8) & 0xFF);
			}
			else {
				array_replace_first(\@bytes, "%$k", $v & 0xFF);
			}
		}
		
		# replace library symbols
		if (grep {/\@(\w+)/} @bytes) {
			if (::have_symbols()) {		# symbols have values
				for (@bytes) {
					if (/\@(\w+)/) {
						my $sym = $1;
						if (!defined $symtab{$sym}) {
							die "Library symbol $sym not found\n";
						}
						else {
							s/\@$sym/$::symtab{$sym}/g;
						}
					}
				}
			}
		}					
		
		# compute expressions
		for (@bytes) {
			my $val = eval($_);
			$_ = $val if !$@;
		}
		
		return ::B(@bytes);
	}
	
	sub size {
		my($self) = @_;
		return scalar @{$self->_bytes};
	}
	
	sub format_bytes {
		my($self) = @_;
		return $self->bytes->to_string;
	}

	sub array_replace_first {
		my($array, @pairs) = @_;
		while (my($find, $replace) = splice(@pairs, 0, 2)) {
			for (@$array) {
				s/$find/$replace/g and last;
			}
		}
	}
}

#------------------------------------------------------------------------------
# Assembly code
#------------------------------------------------------------------------------
{
	package Prog;
	use Modern::Perl;
	use Object::Tiny::RW qw( prog );
	
	sub new {
		my($class, @prog) = @_;
		my $self = bless { prog => [] }, $class;
		$self->add($_) for @prog;
		return $self;
	}

	sub clone {
		my($self, %args) = @_;
		my $new = ref($self)->new;
		for my $instr (@{$self->prog}) {
			$new->add($instr->clone(%args));
		}
		return $new;
	}
	
	sub add {
		my($self, @prog) = @_;
		for my $instr (@prog) {
			if ($instr->can("prog")) {
				$self->add(@{$instr->prog});		# flatten input program
			}
			else {
				push @{$self->prog}, $instr;
			}
		}
	}
	
	sub asm {
		my($self) = @_;
		my @asm;
		for my $instr (@{$self->prog}) {
			push @asm, $instr->asm;
		}
		return join("\n", @asm);
	}
	
	sub bytes {
		my($self) = @_;
		my @bytes;
		for my $instr (@{$self->prog}) {
			push @bytes, @{$instr->bytes};
		}
		return \@bytes;
	}

	sub size {
		my($self) = @_;
		return scalar @{$self->bytes};
	}
	
	
	sub ticks {
		my($self) = @_;
		my @ticks = (0, 0);
		for my $instr (@{$self->prog}) {
			$ticks[0] += $instr->ticks->[0];
			$ticks[1] += $instr->ticks->[1];
		}
		return ::T(@ticks);
	}
	
	sub format_bytes {
		my($self) = @_;
		my @bytes;
		for my $instr (@{$self->prog}) {
			push @bytes, $instr->format_bytes;
		}
		return join('; ', @bytes);
	}
}

#------------------------------------------------------------------------------
# Opcodes
#------------------------------------------------------------------------------

my %R = (b => 0, c => 1, d => 2, e => 3, h => 4, l => 5, '(hl)' => 6, f => 6, m => 6, a => 7);
sub R($)		{ return $R{$_[0]}; }

my %F = (nz => 0, z => 1, nc => 2, c => 3, po => 4, pe => 5, p => 6, m => 7);
sub F($)		{ return $F{$_[0]}; }

my %RP = (b => 0, bc => 0, d => 1, de => 1, h => 2, hl => 2, sp => 3, af => 3, psw => 3);
sub RP($)		{ return $RP{$_[0]}; }

my %P = (ix => 0xDD, iy => 0xFD);
sub P($)		{ return $P{$_[0]}; }

my %OP = (add => 0, adc => 1, sub => 2, sbc => 3, and => 4, xor => 5, or  => 6, cp  => 7,
										sbb => 3, ana => 4, xra => 5, ora => 6, cmp => 7,
		  adi => 0, aci => 1, sui => 2, sbi => 3, ani => 4, xri => 5, ori => 6, cpi => 7,
		  rlca=> 0, rrca=> 1, rla => 2, rra => 3,
		  rlc => 0, rrc => 1, ral => 2, rar => 3,
		                      rl => 2,  rr => 3, sla => 4, sra => 5, sll => 6, sli => 6, 
		  swap => 6, srl => 7, 
		  bit => 1, res => 2, set => 3);
sub OP($)		{ return $OP{$_[0]}; }

#------------------------------------------------------------------------------
sub init_opcodes {
	for $cpu (@CPUS) {
		my($B, $T, $r, $r1, $r2);
		
		next unless isintel || isgbz80 || isz80 || isz80n;
		say "Build opcodes for $cpu";
		
		#----------------------------------------------------------------------
		# 8-bit load group
		#----------------------------------------------------------------------
		
		# ld r, r
		for $r1 (qw(     b c d e h l a )) {
			for $r2 (qw( b c d e h l a )) {
				next if $cpu eq 'r3k' && "$r1,$r2" eq "e,e";
				
				$B = B(0x40+R($r1)*8+R($r2));
				$T = T(is8080 ? 5 : israbbit ? 2 : 4);
				add(		"ld  $r1, $r2", $B, $T);
				add(		"mov $r1, $r2", $B, $T);
				add_ixh(	"ld $r1, $r2",	$B, $T+4);
			}
		}

		# ld r, n
		for $r (qw( b c d e h l a )) {
			$B = B(0x00+R($r)*8+6, '%n');
			$T = T(isgbz80 ? 8 : 7);
			add(		"ld  $r, %n",	$B, $T);
			add(		"mvi $r, %n",	$B, $T);
			add_ixh(	"ld  $r, %n",	$B, $T+4);
		}

		# ld r, (hl) / (ix+d) / (iy+d)
		for $r (qw( b c d e h l a )) {
			$B = B(0x40+R($r)*8+6);
			$T = T(isgbz80 ? 8 : 7);
			add(		"ld  $r, (hl)",		$B, $T);
			add(		"mov $r, m",		$B, $T);
			add_ix_d(	"ld  $r, (hl)",		$B, $T+12);
		}

		# ld (hl) / (ix+d) / (iy+d), r
		for $r (qw( b c d e h l a )) {
			$B = B(0x40+6*8+R($r));
			$T = T(isgbz80 ? 8 : 7);
			add(		"ld  (hl),  $r",	$B, $T);
			add(		"mov m,     $r",	$B, $T);
			add_ix_d(	"ld  (hl), $r",		$B, $T+12);
		}

		# ld (hl) / (ix+d) / (iy+d), n
		$B = B(0x00+6*8+6, '%n');
		$T = T(isgbz80 ? 12 : 10);
		add(		"ld  (hl), %n",		$B, $T);
		add(		"mvi m,    %n",		$B, $T);
		add_ix_d(	"ld  (hl), %n",		$B, $T+9);

		# ld a, (bc) / (de)
		for $r (qw( bc de )) {
			$B = B(0x0A+RP($r)*16);
			$T = T(isgbz80 ? 8 : 7);
			$r1 = substr($r, 0, 1);
			add("ld a, ($r)",	$B, $T);
			add("ldax $r",		$B, $T);
			add("ldax $r1",		$B, $T);
		}
		
		# ld a, (nn)
		$B = B(isgbz80 ? 0xFA : 0x3A, '%m', '%m');
		$T = T(isgbz80 ? 16 : 13);
		add("lda %m",		$B, $T);
		add("ld a, (%m)",	$B, $T);

		# ld (bc) / (de), a
		for $r (qw( bc de )) {
			$B = B(0x02+RP($r)*16);
			$T = T(isgbz80 ? 8 : 7);
			$r1 = substr($r, 0, 1);
			add("ld ($r), a",	$B, $T);
			add("stax $r",		$B, $T);
			add("stax $r1",		$B, $T);
		}
		
		# ld (nn), a
		$B = B(isgbz80 ? 0xEA : 0x32, '%m', '%m');
		$T = T(isgbz80 ? 16 : 13);
		add("ld (%m), a",	$B, $T);
		add("sta %m",		$B, $T);
		
		# ld a, i / ld a, r / ld i,a / ld r, a
		if (iszilog) {
			add("ld a, i", B(0xED, 0x57), T(9));
			add("ld a, r", B(0xED, 0x5F), T(9));
			add("ld i, a", B(0xED, 0x47), T(9));
			add("ld r, a", B(0xED, 0x4F), T(9));
		}

		if (isgbz80) {
			add("ld  (hl+), a", B(0x22), T(8));
			add("ld  (hli), a", B(0x22), T(8));
			add("ldi (hl), a", 	B(0x22), T(8));

			add("ld  a, (hl+)", B(0x2A), T(8));
			add("ld  a, (hli)", B(0x2A), T(8));
			add("ldi a, (hl)", 	B(0x2A), T(8));

			add("ld  (hl-), a", B(0x32), T(8));
			add("ld  (hld), a", B(0x32), T(8));
			add("ldd (hl), a", 	B(0x32), T(8));

			add("ld  a, (hl-)", B(0x3A), T(8));
			add("ld  a, (hld)", B(0x3A), T(8));
			add("ldd a, (hl)", 	B(0x3A), T(8));
		}

		#----------------------------------------------------------------------
		# 16-bit load group
		#----------------------------------------------------------------------

		# ld dd, nn
		for $r (qw( bc de hl sp )) {
			$B = B(0x01+RP($r)*16, '%m', '%m');
			$T = T(isgbz80 ? 12 : 10);
			$r1 = substr($r, 0, 1);
			add(	"ld  $r, %m",	$B, $T);
			add(	"lxi $r, %m",	$B, $T);
			add(	"lxi $r1, %m",	$B, $T) unless $r eq 'sp';
			add_ix(	"ld  $r, %m",	$B, $T+4);
		}

		# ld hl, (nn)
		if (!isgbz80) {
			$B = B(0x2A, '%m', '%m');
			$T = T(16);
			add(	"ld hl, (%m)",	$B, $T);		
			add(	"lhld   %m",	$B, $T);
			add_ix(	"ld hl, (%m)",	$B, $T+4);
		}
		
		# ld dd, (nn)
		for $r (qw( bc de sp )) {
			if (!isintel && !isgbz80) {
				$B = B(0xED, 0x4B+RP($r)*16, '%m', '%m');
				$T = T(20);
				add(	"ld $r, (%m)",	$B, $T);
			}
		}
			
		# ld (nn), hl
		if (!isgbz80) {
			$B = B(0x22, '%m', '%m');
			$T = T(16);
			add(	"ld (%m), hl",	$B, $T);		
			add(	"shld %m",		$B, $T);
			add_ix(	"ld (%m), hl",	$B, $T+4);
		}
		
		# ld (nn), dd
		if (!isintel && !isgbz80) {
			for $r (qw( bc de sp )) {
				$B = B(0xED, 0x43+RP($r)*16, '%m', '%m');
				$T = T(20);
				add(	"ld (%m), $r",	$B, $T);
			}
		}
		
		# ld sp, hl
		$B = B(0xF9);
		$T = T(is8080 ? 5 : isgbz80 ? 8 : 6);
		add(	"ld sp, hl",	$B, $T);
		add(	"sphl",			$B, $T);
		add_ix(	"ld sp, hl",	$B, $T+4);
		
		# push qq
		for $r (qw( bc de hl af )) {
			$B = B(0xC5+RP($r)*16);
			$T = T(is8085 ? 12 : isgbz80 ? 16 : 11);
			$r1 = ($r eq 'af') ? 'psw' : substr($r, 0, 1);
			add(	"push $r",	$B, $T);
			add(	"push $r1",	$B, $T);
			add_ix(	"push $r",	$B, $T+4);
		}
		
		# pop qq
		for $r (qw( bc de hl af )) {
			$r1 = ($r eq 'af') ? 'psw' : substr($r, 0, 1);
			$B = B(0xC1+RP($r)*16);
			$T = T(isgbz80 ? 12 : 10);
			add(	"pop $r",	$B, $T);
			add(	"pop $r1",	$B, $T);
			add_ix(	"pop $r",	$B, $T+4);
		}
		
		# ld (de), hl
		if (is8085) {
			add("shlx",			B(0xD9), T(10));
			add("shlde",		B(0xD9), T(10));
			add("ld (de), hl",	B(0xD9), T(10));
		}
		
		# ld hl, (de)
		if (is8085) {
			add("lhlx",			B(0xED), T(10));
			add("lhlde",		B(0xED), T(10));
			add("ld hl, (de)",	B(0xED), T(10));
		}

		# ld (nn), sp
		if (isgbz80) {
			add("ld (%m), sp", 	B(0x08, '%m', '%m'), T(20));
		}

		#----------------------------------------------------------------------
		# Exchange
		#----------------------------------------------------------------------

		# ex de, hl
		if (isgbz80) {
			add_compound("ex de, hl" =>	"push hl", 
										"push de",
										"pop hl",
										"pop de");
			add_compound("xchg" =>		"push hl", 
										"push de",
										"pop hl",
										"pop de");
		}
		else {
			add(	"ex de, hl",	B(0xEB), T(4));
			add(	"xchg",			B(0xEB), T(4));
		}

		# ex af, af'
		if (!isintel && !isgbz80) {
			add(	"ex af, af'",	B(0x08), T(4));
			add(	"ex af, af",	B(0x08), T(4));
		}

		# ex (sp), hl / ix / iy
		if (isintel || iszilog) {
			$B = B(0xE3);
			$T = T(is8080 ? 18 : is8085 ? 16 : 19);
			add(	"ex (sp), hl", 	$B, $T);
			add(	"xthl",			$B, $T);
			add_ix(	"ex (sp), hl", 	$B, $T+4);
		}
		elsif (israbbit) {
			#add(	"ex (sp), hl", 			0xED, 0x54);
			#add(	"ex (sp), hl'", 		$V{altd}, 0xED, 0x54);
			#add(	"altd ex (sp), hl", 	$V{altd}, 0xED, 0x54);
		}
		else {
			add(	"ex (sp), hl",	B(0xCD, '@__z80asm__ex_sp_hl'), T(148));
		}

		#----------------------------------------------------------------------
		# Block Transfer
		#----------------------------------------------------------------------

		# ticks for BC=1 and BC=2
		if (isintel || isgbz80) {
			add("ldi", 			B(0xCD, '@__z80asm__ldi' ), 
								is8080 ? T(181,188) : is8085 ? T(180,184) : isgbz80 ? T(80)      : die);
			add("ldir", 		B(0xCD, '@__z80asm__ldir'), 
								is8080 ? T( 96,144) : is8085 ? T( 97,147) : isgbz80 ? T(96,144)  : die);
			add("ldd", 			B(0xCD, '@__z80asm__ldd' ), 
								is8080 ? T(181,188) : is8085 ? T(180,184) : isgbz80 ? T(80)      : die);
			add("lddr", 		B(0xCD, '@__z80asm__lddr'), 
								is8080 ? T( 96,144) : is8085 ? T( 97,147) : isgbz80 ? T(100,152) : die);
		} 
		else {
			add("ldi", 			B(0xED, 0xA0), (isz80||isz80n) ? T(16)    : die);
			add("ldir", 		B(0xED, 0xB0), (isz80||isz80n) ? T(16,47) : die);
			add("ldd", 			B(0xED, 0xA8), (isz80||isz80n) ? T(16)    : die);
			add("lddr", 		B(0xED, 0xB8), (isz80||isz80n) ? T(16,47) : die);
		}
		
		#----------------------------------------------------------------------
		# Search
		#----------------------------------------------------------------------

		# ticks for HL=0x1000, A=0xFF, BC=1 and BC=2
		if (isintel || isgbz80) {
			add("cpi", 			B(0xCD, '@__z80asm__cpi' ), 
								is8080 ? T(164,191) : is8085 ? T(156,181) : isgbz80 ? T(408,424) : die);
			add("cpir", 		B(0xCD, '@__z80asm__cpir'), 
								is8080 ? T(195,353) : is8085 ? T(180,328) : isgbz80 ? T(448,856) : die);
			add("cpd", 			B(0xCD, '@__z80asm__cpd' ), 
								is8080 ? T(164,191) : is8085 ? T(156,181) : isgbz80 ? T(408,424) : die);
			add("cpdr", 		B(0xCD, '@__z80asm__cpdr'), 
								is8080 ? T(195,353) : is8085 ? T(180,328) : isgbz80 ? T(448,856) : die);
		}
		else {
			add("cpi", 			B(0xED, 0xA1), (isz80||isz80n) ? T(16)    : die);
			add("cpir", 		B(0xED, 0xB1), (isz80||isz80n) ? T(16,37) : die);
			add("cpd", 			B(0xED, 0xA9), (isz80||isz80n) ? T(16)    : die);
			add("cpdr", 		B(0xED, 0xB9), (isz80||isz80n) ? T(16,37) : die);
		}
		
		#----------------------------------------------------------------------
		# 8-bit arithmetic
		#----------------------------------------------------------------------
		
		# add... a, r / add... r
		for my $op (qw( add adc sub sbc and xor or  cp  
		                                            cmp )) {
			for $r (qw( b c d e h l a )) {
				$B = B(0x80+OP($op)*8+R($r));
				$T = T(4);
				add("$op a, $r",	$B, $T);
				add("$op    $r",	$B, $T);
			}
		}
		for my $op (qw(             sbb ana xra ora     )) {	
			for $r (qw( b c d e h l a )) {
				$B = B(0x80+OP($op)*8+R($r));
				$T = T(4);
				add("$op $r", 		$B, $T);
			}
		}
		
		# add... a, (hl) / add... m
		for my $op (qw( add adc sub sbc and xor or  cp  
		                                            cmp )) {
			$B = B(0x80+OP($op)*8+6);
			$T = isgbz80 ? T(8) : T(7);
			add(		"$op a, (hl)", 	$B, $T);
			add(		"$op    (hl)", 	$B, $T);
			add_ix_d(	"$op a, (hl)",	$B, $T+12);
			add_ix_d(	"$op    (hl)",	$B, $T+12);
		}
		for my $op (qw( add adc sub sbb ana xra ora cmp )) {	
			$B = B(0x80+OP($op)*8+6);
			$T = isgbz80 ? T(8) : T(7);
			add("$op m", 			$B, $T);
		}
		
		# add... a, n / add... n
		for my $op (qw( add adc sub sbc and xor or  cp  
		                                            cmp )) {
			$B = B(0xC6+OP($op)*8, '%n');
			$T = isgbz80 ? T(8) : T(7);
			add("$op a, %n", 		$B, $T);
			add("$op    %n",		$B, $T);
		}
		for my $op (qw( adi aci sui sbi ani xri ori cpi )) {
			$B = B(0xC6+OP($op)*8, '%n');
			$T = isgbz80 ? T(8) : T(7);
			add("$op %n", 			$B, $T);
		}
		
		# inc r
		for $r (qw( b c d e h l a )) {
			$B = B(0x04+R($r)*8);
			$T = is8080 ? T(5) : T(4);
			add("inr $r", 	$B, $T);
			add("inc $r", 	$B, $T);
		}
		
		# dec r
		for $r (qw( b c d e h l a )) {
			$B = B(0x05+R($r)*8);
			$T = is8080 ? T(5) : T(4);
			add("dcr $r", 	$B, $T);
			add("dec $r", 	$B, $T);
		}
		
		# inc (hl) / (ix+d) / (iy+d)
		$B = B(0x04+6*8);
		$T = isintel ? T(10) : isgbz80 ? T(12) : T(11);
		add(		"inr m", 		$B, $T);
		add(		"inc (hl)", 	$B, $T);
		add_ix_d(	"inc (hl)", 	$B, $T+12);
		
		# dec (hl) / (ix+d) / (iy+d)
		$B = B(0x05+6*8);
		$T = isintel ? T(10) : isgbz80 ? T(12) : T(11);
		add(		"dcr m", 		$B, $T);
		add(		"dec (hl)", 	$B, $T);
		add_ix_d(	"dec (hl)", 	$B, $T+12);
		
		#----------------------------------------------------------------------
		# General Purpose Arithmetic
		#----------------------------------------------------------------------

		# daa
		if (isintel || iszilog || isgbz80) {
			add("daa",		B(0x27), T(4));
		}
		else {
			add("daa",		B(0xCD, '@__z80asm__daa'), T(499));
		}
		
		# cpl
		$B = B(0x2F);
		$T = T(4);
		add("cpl", 		$B, $T);
		add("cma",		$B, $T);
		add("cpl a", 	$B, $T);
		
		# neg
		$B = B(0xED, 0x44);
		$T = T(8);
		if (iszilog || israbbit) {
			add("neg", 		$B, $T);
			add("neg a", 	$B, $T);
		}
		else {
			add_compound("neg"		=> 	"cpl",
										"inc a");
			add_compound("neg a"	=> 	"cpl",
										"inc a");
		}

		# ccf
		$B = B(0x3F);
		$T = T(4);
		add("ccf",			$B, $T);
		add("cmc",			$B, $T);
		
		# scf
		$B = B(0x37);
		$T = T(4);
		add("scf",			$B, $T);
		add("stc",			$B, $T);
		
		#----------------------------------------------------------------------
		# General Purpose CPU Control
		#----------------------------------------------------------------------

		# nop
		add("nop", 			B(0x00), T(4));
		
		# halt
		if (!israbbit) {
			$B = B(0x76);
			$T = is8080 ? T(7) : is8085 ? T(5) : T(4);
			add("hlt",		$B, $T);
			add("halt",		$B, $T);
		}
		
		# ei / di
		if (!israbbit) {
			add("ei",		B(0xFB), T(4));
			add("di",		B(0xF3), T(4));
		}

		# im n
		if (iszilog) {
			add("im %c", 	B(0xED, "%c==0?0x46:%c==1?0x56:0x5E"), T(8));
		}





		
		
		
		
		# bit/res/set b, r
		if (!isintel) {
			for my $op (qw( bit res set )) {
				for $r (qw( b c d e h l a )) {
					$B = B(0xCB, (OP($op)*0x40+R($r))."+%c*8");
					$T = T(8);
					add("$op %c, $r",	$B, $T);
				}
			}
		}

		# bit/res/set b, (hl) / (ix+d) / (iy+d)
		if (!isintel) {
			for my $op (qw( bit res set )) {
				$B = B(0xCB, (OP($op)*0x40+6)."+%c*8");
				if ($op eq 'bit') {
					$T = isgbz80 ? T(16) : T(12);
				} 
				else {
					$T = isgbz80 ? T(16) : T(15);
				}
				add("$op %c, (hl)",		$B, $T);
			}
		}
		
		# restarts
		add("rst %c", 			B(0xC7."+%c"),
								is8085 ? T(12) : isgbz80 ? T(32) : T(11));
		
		next unless isintel || isgbz80;
		next;


		
		

		
		#----------------------------------------------------------------------
		# 8080 opcodes
		#----------------------------------------------------------------------

		# data transfer group

		for $r (qw( b bc d de h hl sp )) {
			add("inx $r",		0x03+RP($r)*16, is8080 ? 5 : is8085 ? 6 : isgbz80 ? 8 : die);
			add("dcx $r",		0x0B+RP($r)*16, is8080 ? 5 : is8085 ? 6 : isgbz80 ? 8 : die);
			add("dad $r",		0x09+RP($r)*16, isintel ? 10 : isgbz80 ? 8 : die);
		}
		
		for $r (qw( bc de hl sp )) {
			add("inc $r",		0x03+RP($r)*16, is8080 ? 5 : is8085 ? 6 : isgbz80 ? 8 : die);
			add("dec $r",		0x0B+RP($r)*16, is8080 ? 5 : is8085 ? 6 : isgbz80 ? 8 : die);
			add("add hl, $r",	0x09+RP($r)*16, isintel ? 10 : isgbz80 ? 8 : die);
		}

		for my $op (qw( rlca rrca rla  rra
						rlc  rrc  ral  rar )) {
			add("$op",			0x07+OP($op)*8, (isintel||isgbz80) ? 4 : die);
		}
		
		add("pchl",				0xE9, is8080 ? 5 : is8085 ? 6 : isgbz80 ? 4 : die);
		add("jp (hl)",			0xE9, is8080 ? 5 : is8085 ? 6 : isgbz80 ? 4 : die);

		add("jmp %m",			[0xC3, '%m', '%m'], isintel ? 10 : isgbz80 ? 12 : die);
		add("jp  %m",			[0xC3, '%m', '%m'], isintel ? 10 : isgbz80 ? 12 : die) 
			unless isintel; # JP in Intel is Jump if Positive

		add("call %m",			[0xCD, '%m', '%m'], 
								is8080 ? 17 : is8085 ? 18 : isgbz80 ? 12 : die);
		add("ret",				0xC9, 
								isintel ? 10 : isgbz80 ? 8 : die);

		for my $f (qw( nz z nc c po pe p m )) {
			next if isgbz80 && F($f) >= 4;
			
			add("j$f    %m",	[0xC2+F($f)*8, '%m', '%m'], 
								is8080 ? 10 : is8085 ? [7,10] : isgbz80 ? 12 : die) 
				unless $f eq 'p' && !isintel;
			add("jp $f, %m",	[0xC2+F($f)*8, '%m', '%m'], 
								is8080 ? 10 : is8085 ? [7,10] : isgbz80 ? 12 : die) 
				unless isintel;		# JP in Intel is Jump if Positive

			add("c$f      %m",	[0xC4+F($f)*8, '%m', '%m'], 
								is8080 ? [11,17] : is8085 ? [9,18] : isgbz80 ? 12 : die) 
				unless $f eq 'p' && !isintel;
			add("call $f, %m",	[0xC4+F($f)*8, '%m', '%m'], 
								is8080 ? [11,17] : is8085 ? [9,18] : isgbz80 ? 12 : die);

			add("r$f",			0xC0+F($f)*8, 
								is8080 ? [5,11] : is8085 ? [6,12] : isgbz80 ? 8 : die);
			add("ret $f",		0xC0+F($f)*8, 
								is8080 ? [5,11] : is8085 ? [6,12] : isgbz80 ? 8 : die);
		}
		
		
		if (isintel||iszilog) {
			add("in %n",		[0xDB, '%n'], isintel ? 10 : die);
			add("in a, (%n)",	[0xDB, '%n'], isintel ? 10 : die);
			
			add("out %n",		[0xD3, '%n'], isintel ? 10 : die);
			add("out (%n), a",	[0xD3, '%n'], isintel ? 10 : die);
		}
		


		#----------------------------------------------------------------------
		# 8085 opcodes
		#----------------------------------------------------------------------
		if (is8085) {
			# interrupt mask
			add("rim", 			0x20, 4);
			add("sim", 			0x30, 4);

			# double subtract
			add("dsub",			0x08, 10);
			add("sub hl, bc",	0x08, 10);
		
			# Rotate HL right
			add("arhl",			0x10, 7);
			add("rrhl",			0x10, 7);
			add("sra hl",		0x10, 7);
			
			# Rotate DE left
			add("rdel",			0x18, 10);
			add("rlde",			0x18, 10);
			add("rl de",		0x18, 10);
			
			# Add 00bb immediate to HL, result to DE (undocumented i8085)
			add("ldhi %n",		[0x28, '%n'], 10);
			add("adi hl, %n",	[0x28, '%n'], 10);
			add("ld de, hl+%n",	[0x28, '%n'], 10);
			
			# Add 00bb immediate to SP, result to DE
			add("ldsi %n",		[0x38, '%n'], 10);
			add("adi sp, %n",	[0x38, '%n'], 10);
			add("ld de, sp+%n",	[0x38, '%n'], 10);
			
			# Restart 8 (0040) if V flag is set
			add("rstv",			0xCB, [6,12]);
			add("ovrst8",		0xCB, [6,12]);
		}
		
		if (is8085) {
			# Jump on flag X5/K is reset
			add("jnx5 %m",		[0xDD, '%m', '%m'], [7,10]);
			add("jnk %m",		[0xDD, '%m', '%m'], [7,10]);

			# Jump on flag X5/K is set
			add("jx5 %m",		[0xFD, '%m', '%m'], [7,10]);
			add("jk %m",		[0xFD, '%m', '%m'], [7,10]);
		}

		#----------------------------------------------------------------------
		# Game Boy opcodes
		#----------------------------------------------------------------------
		if (isgbz80) {
			add("ldh (%n), a", 	[0xE0, '%n'], 12);
			add("ldh a, (%n)", 	[0xF0, '%n'], 12);
			
			# TODO: accept ld ($FF00+n), a; ld a, ($FF00+n)
			
			add("ld  (c), a", 	0xE2, 8);
			add("ldh (c), a", 	0xE2, 8);

			add("ld  a, (c)", 	0xF2, 8);
			add("ldh a, (c)", 	0xF2, 8);
		}
		
		
		if (isgbz80) {
			add("add sp, %s", 	[0xE8, '%s'], 16);
			
			add("ld hl, sp+%s", [0xF8, '%s'], 12);
			add("ldhl sp, %s", 	[0xF8, '%s'], 12);
		}
		
			
		if (isgbz80) {
			add("stop", 		[0x10, 0x00], 4);
		}

		#----------------------------------------------------------------------
		# Zilog opcodes
		#----------------------------------------------------------------------
		if (!isintel) {
			# rotate
			for (qw( rlc rrc rl rr sla sra sll sli srl )) {
				my $op = (/sll/ && isgbz80) ? 'swap' : $_;
				next if $op =~ /sll|sli/ && !iszilog;

				for $r (qw( b c d e h l a )) {
					add("$op $r", 		[0xCB, OP($op)*8+R($r)], 
										isgbz80 ? 8 : die);
				}

				add("$op (hl)", 		[0xCB, OP($op)*8+6], 
										isgbz80 ? 16 : die);
			}
			
			
			# relative jump
			add("jr %j", 				[0x18, '%j'], 
										isgbz80 ? 8 : die);
			for my $f (qw( nz z nc c )) { 
				add("jr $f, %j", 		[0x20+F($f)*8, '%j'], 
										isgbz80 ? 8 : die);
			}
			
			add("reti",					0xD9, 
										isgbz80 ? 8 : die);
		}

		#----------------------------------------------------------------------
		# compound opcodes
		#----------------------------------------------------------------------
		next;
		
		for $r (qw( bc de )) {
			my($rh, $rl) = split(//, $r);

			add_compound("ld a, ($r+)"	=> "ld a, ($r)", "inc $r");
			add_compound("ld ($r+), a"	=> "ld ($r), a", "inc $r");

			add_compound("ldi a, ($r)"	=> "ld a, ($r)", "inc $r");
			add_compound("ldi ($r), a"	=> "ld ($r), a", "inc $r");

			add_compound("ld a, ($r-)"	=> "ld a, ($r)", "dec $r");
			add_compound("ld ($r-), a"	=> "ld ($r), a", "dec $r");

			add_compound("ldd a, ($r)"	=> "ld a, ($r)", "dec $r");
			add_compound("ldd ($r), a"	=> "ld ($r), a", "dec $r");
			
			add_compound("ld $r, (hl)"	=> "ld $rl, (hl)", "inc hl", "ld $rh, (hl)", "dec hl");
			add_compound("ldi $r, (hl)"	=> "ld $rl, (hl)", "inc hl", "ld $rh, (hl)", "inc hl");
			add_compound("ld $r, (hl+)"	=> "ld $rl, (hl)", "inc hl", "ld $rh, (hl)", "inc hl");
			
			add_compound("ld (hl), $r"	=> "ld (hl), $rl", "inc hl", "ld (hl), $rh", "dec hl");
			add_compound("ldi (hl), $r"	=> "ld (hl), $rl", "inc hl", "ld (hl), $rh", "inc hl");
			add_compound("ld (hl+), $r"	=> "ld (hl), $rl", "inc hl", "ld (hl), $rh", "inc hl");
			
			add_compound("jp ($r)"		=> "push $r", "ret");
		}

		for $r1 (qw( bc de hl )) {
			my($r1h, $r1l) = split(//, $r1);
			for $r2 (qw( bc de hl )) {
				my($r2h, $r2l) = split(//, $r2);
				
				add_compound("ld $r1, $r2"	=> "ld $r1h, $r2h", "ld $r1l, $r2l");
			}
		}

		for $r (qw( b c d e h l a )) {
			add_compound("ld $r, (hl+)"	=> "ld $r, (hl)", "inc hl");
			add_compound("ldi $r, (hl)"	=> "ld $r, (hl)", "inc hl");
			
			add_compound("ld $r, (hl-)"	=> "ld $r, (hl)", "dec hl");
			add_compound("ldd $r, (hl)"	=> "ld $r, (hl)", "dec hl");
		}
		
		add_compound("ld (hl+), %n"		=> "ld (hl), %n", "inc hl");
		add_compound("ldi (hl), %n"		=> "ld (hl), %n", "inc hl");

		add_compound("ld (hl-), %n"		=> "ld (hl), %n", "dec hl");
		add_compound("ldd (hl), %n"		=> "ld (hl), %n", "dec hl");

		add_compound("inc (hl+)"		=> "inc (hl)", "inc hl");
		add_compound("inc (hl-)"		=> "inc (hl)", "dec hl");

		add_compound("dec (hl+)"		=> "dec (hl)", "inc hl");
		add_compound("dec (hl-)"		=> "dec (hl)", "dec hl");
		
		for my $op (qw( add adc sub sbc and xor or  cp  )) {
			next if $op eq 'cp' && isintel;	# CP is Call Positive in Intel
			add_compound("$op a, (hl+)"	=> "$op a, (hl)", "inc hl");
			add_compound("$op    (hl+)"	=> "$op a, (hl)", "inc hl");
			
			add_compound("$op a, (hl-)"	=> "$op a, (hl)", "dec hl");
			add_compound("$op    (hl-)"	=> "$op a, (hl)", "dec hl");
		}
	}
}

#------------------------------------------------------------------------------
sub _add_prog {
	my($asm) = @_;
	$asm =~ s/\s+/ /g;
	
	$Opcodes{$asm}{$cpu} and die $asm;
	my $prog = Prog->new;
	$Opcodes{$asm}{$cpu} = $prog;
	
	return $prog;
}

#------------------------------------------------------------------------------
sub add {
	my($asm, $bytes, $ticks) = @_;
	my $prog = _add_prog($asm);
	$prog->add(Instr->new($asm, $bytes, $ticks));
}

#------------------------------------------------------------------------------
# expand ixh, ixl, ...
sub add_ixh {
	my($asm, $bytes, $ticks) = @_;
	if (isz80||isz80n) {
		if ($asm =~ /\b[hl]\b/) {
			for my $x (qw( ix iy )) {
				(my $asm1 = $asm) =~ s/\b([hl])\b/$x$1/g;
				add($asm1, B(P($x), @$bytes), $ticks);
			}
		}
	}
}

#------------------------------------------------------------------------------
# expand (hl) -> (ix+d)
sub add_ix_d {
	my($asm, $bytes, $ticks) = @_;
	if (iszilog||israbbit) {
		if ($asm =~ /\Q(hl)\E/) {
			for my $x (qw( ix iy )) {
				(my $asm1 = $asm) =~ s/\Q(hl)\E/($x+%d)/g;
				my @bytes = @$bytes;
				add($asm1, B(P($x), $bytes[0], '%d', @bytes[1..$#bytes]), $ticks);

				$asm1 =~ s/\Q+%d\E//;
				add($asm1, B(P($x), $bytes[0], 0, @bytes[1..$#bytes]), $ticks);
			}
		}
	}
}

#------------------------------------------------------------------------------
# expand ix
sub add_ix {
	my($asm, $bytes, $ticks) = @_;
	if (iszilog||israbbit) {
		if ($asm =~ /\bhl\b/) {
			for my $x (qw( ix iy )) {
				(my $asm1 = $asm) =~ s/\bhl\b/$x/g;
				my @bytes = @$bytes;
				add($asm1, B(P($x), @bytes), $ticks);
			}
		}
	}
}

#------------------------------------------------------------------------------
sub add_compound {
	my($asm, @prog) = @_;
	my $prog = _add_prog($asm);
	for my $asm1 (@prog) {
		my $prog1 = $Opcodes{$asm1}{$cpu} or die;
		$prog->add(clone($prog1));
	}
}

#------------------------------------------------------------------------------
sub write_opcodes {
	write_opcodes_table();
	write_opcodes_by_asm();
}

#------------------------------------------------------------------------------
sub write_opcodes_table {
	# build list
	my @rows;
	for my $asm (sort keys %Opcodes) {
		for $cpu (sort keys %{$Opcodes{$asm}}) {
			my $prog = $Opcodes{$asm}{$cpu};
			write_opcodes_line(\@rows, $asm, $cpu, $prog);
		}
	}
	
	# sort
	@rows = sort {$a->[0] cmp $b->[0]} @rows;
	
	# create table
	my $tb = Text::Table->new("; Assembly", \$table_separator, "CPU", \$table_separator, 
							  "Bytes", \$table_separator, "T-States");
	for (@rows) {
		$tb->add(@$_);
	}
	
	# write to file
	say "Write ",$opcodes_file;
	$opcodes_file->spew_raw($tb->table);
}

#------------------------------------------------------------------------------
sub write_opcodes_line {
	my($rows, $asm, $cpu, $prog) = @_;
	
	if ($asm =~ /^(bit|res|set) %c/) {
		for my $c (0..7) {
			write_opcodes_line($rows, replace($asm, '%c', $c), $cpu, $prog->clone(c => $c));
		}
	}
	elsif ($asm =~ /^rst %c/) {
		$::cpu = $cpu;
		for my $c (restarts()) {
			write_opcodes_line($rows, replace($asm, '%c', $c), $cpu, $prog->clone(c => $c));
			if ($c != 0) {
				write_opcodes_line($rows, replace($asm, '%c', $c/8), $cpu, $prog->clone(c => $c));
			}
		}
	}
	elsif ($asm =~ /^im %c/) {
		for my $c (0..2) {
			write_opcodes_line($rows, replace($asm, '%c', $c), $cpu, $prog->clone(c => $c));
		}
	}
	else {
		my @row = (format_asm($asm), $cpu, $prog->format_bytes,
				   $prog->ticks->to_string);			
		push(@$rows, \@row);
	}
}

#------------------------------------------------------------------------------
sub write_opcodes_by_asm {
	# build table with assembly per cpu
	my %by_bytes;
	
	# build title
	my %cpu_column;
	my $column;

	my @title = ("; Assembly");
	for (@CPUS) { 
		push @title, \$table_separator, $_;
	}
		
	# build list
	my @rows;
	for my $asm (sort keys %Opcodes) {
		my @progs = ((undef) x (scalar(@CPUS)));
		for $cpu (sort keys %{$Opcodes{$asm}}) {
			my $prog = $Opcodes{$asm}{$cpu};
			$column = $CPU_I{$cpu};
			$progs[$column] = [$cpu, $prog->clone];
		}
		write_opcodes_by_asm_line(\@rows, \%by_bytes, format_asm($asm), @progs);
	}

	# sort
	@rows = sort {$a->[0] cmp $b->[0]} @rows;
	
	# create table
	my $tb = Text::Table->new(@title);
	for (@rows) {
		my($asm, @progs) = @$_;
		
		my @bytes = map {ref($_) ? $_->[1]->format_bytes : " "} @progs;
		$tb->add($asm, span_cells(@bytes));
		
		my @ticks = map {ref($_) ? $_->[1]->ticks->to_string : " "} @progs;
		$tb->add(" ", span_cells(@ticks));
		
		$tb->add((" ") x $tb->n_cols);
	}
	
	# write to file
	say "Write ",$opcodes_by_asm_file;
	$opcodes_by_asm_file->spew_raw($tb->table);
	
	# build table with opcodes per CPU
	$title[0] = ";Bytes";
	$tb = Text::Table->new(@title);
	for my $bytes (sort keys %by_bytes) {
		my @row = ($bytes, (" ") x ($tb->n_cols - 1));
		for $cpu (keys %{$by_bytes{$bytes}}) {
			$column = 1 + $CPU_I{$cpu};
			$row[$column] = $by_bytes{$bytes}{$cpu};
		}
		$tb->add(span_cells(@row));
		$tb->add((" ") x $tb->n_cols);
	}
	say "Write ",$opcodes_by_bytes_file;
	$opcodes_by_bytes_file->spew_raw($tb->table);
}

#------------------------------------------------------------------------------
sub write_opcodes_by_asm_line {
	my($rows, $by_bytes, $asm, @progs) = @_;
	
	if ($asm =~ /^(bit|res|set) %c/) {
		for my $c (0..7) {
			my @progs1 = map {ref($_) ? [$_->[0], $_->[1]->clone(c => $c)] : $_} @progs;
			write_opcodes_by_asm_line($rows, $by_bytes, replace($asm, '%c', $c), @progs1);
		}
	}
	elsif ($asm =~ /^rst %c/) {
		for my $c (0..7) {
			my @progs1 = map {ref($_) ? [$_->[0], $_->[1]->clone(c => $c*8)] : $_} @progs;
			write_opcodes_by_asm_line($rows, $by_bytes, replace($asm, '%c', $c*8), @progs1);
			if ($c != 0) {
				my @progs1 = map {ref($_) ? [$_->[0], $_->[1]->clone(c => $c*8)] : $_} @progs;
				write_opcodes_by_asm_line($rows, $by_bytes, replace($asm, '%c', $c), @progs1);
			}
		}
	}
	elsif ($asm =~ /^im %c/) {
		for my $c (0..2) {
			my @progs1 = map {ref($_) ? [$_->[0], $_->[1]->clone(c => $c)] : $_} @progs;
			write_opcodes_by_asm_line($rows, $by_bytes, replace($asm, '%c', $c), @progs1);
		}
	}
	else {
		my @progs1 = map {ref($_) ? [$_->[0], $_->[1]->clone] : $_} @progs;
		push(@$rows, [$asm, @progs1]);

		for (@progs1) {
			next unless ref($_);
			($cpu, my $prog) = @$_;
			my $f_bytes = $prog->format_bytes;
			
			if ($asm =~ /^rst (\d+)/) {
				my $target = $1; $target *= 8 if $target < 8;
				my @restarts = restarts();
				my %restarts; for (@restarts) { $restarts{$_}=1; }
				next unless $restarts{$target};
			}

			$by_bytes->{$f_bytes}{$cpu} .= "\n" if $by_bytes->{$f_bytes}{$cpu};
			$by_bytes->{$f_bytes}{$cpu} .= $asm;
		}
	}
}

#------------------------------------------------------------------------------
# Parser
#------------------------------------------------------------------------------

sub init_parser {
	for my $asm (sort keys %Opcodes) {
		my $tokens = parser_tokens($asm);
		my $asm_swap = swap_ix_iy($asm);
		
		# check for parens
		my $parens;
		if    ($asm =~ /\(%\w\)/) 	{ $parens = $expr_in_parens; }
		elsif ($asm =~ /%\w/) 		{ $parens = $expr_no_parens; }
		else 						{ $parens = $no_expr; }
			
		for $cpu (sort keys %{$Opcodes{$asm}}) {
			my $prog		= $Opcodes{$asm}{$cpu};
			my $prog_swap	= $Opcodes{$asm_swap}{$cpu};
			
			$Parser{$tokens}{$cpu}{$parens}{'-'} 	= [$asm, clone($prog)];
			$Parser{$tokens}{$cpu}{$parens}{'IXIY'} = [$asm, clone($prog_swap)];
		}
	}
}

#------------------------------------------------------------------------------
sub parser_tokens {
	local($_) = @_;
	my @tokens = ();
	
	while (!/\G \z 				/gcx) {
		if (/\G \s+ 			/gcx) {}
		elsif (/\G    (\w+)	'	/gcx) { push @tokens, "_TK_".uc($1)."1"; }
		elsif (/\G    (\w+)		/gcx) { push @tokens, "_TK_".uc($1); }
		elsif (/\G \( %[nm] \)	/gcx) { push @tokens, "expr"; }
		elsif (/\G    %[snmMj]	/gcx) { push @tokens, "expr"; }
		elsif (/\G \+ %[dsu]	/gcx) { push @tokens, "expr"; }
		elsif (/\G    %c		/gcx) { push @tokens, "const_expr"; }
		elsif (/\G \( (\w+) 	/gcx) { push @tokens, "_TK_IND_".uc($1); }
		elsif (/\G , 			/gcx) { push @tokens, "_TK_COMMA"; }
		elsif (/\G \) 			/gcx) { push @tokens, "_TK_RPAREN"; }
		elsif (/\G \+   		/gcx) { push @tokens, "_TK_PLUS"; }
		elsif (/\G \-   		/gcx) { push @tokens, "_TK_MINUS"; }
		elsif (/\G \.   		/gcx) { push @tokens, "_TK_DOT"; }
		else { die "$_ ; ", substr($_, pos($_)||0) }
	}
	return join(' ', ('| label?', @tokens, "_TK_NEWLINE"));
}

#------------------------------------------------------------------------------
sub write_parser {
	write_parser_table();
	write_cpu_rules();
}

#------------------------------------------------------------------------------
sub write_parser_table {
	my $tb = Text::Table->new("; Tokens", \$table_separator, "CPU", \$table_separator, "Parens", \$table_separator, "IX/IY", \$table_separator, 
							  "Assembly", \$table_separator, "Bytes", \$table_separator, "Ticks");
	for my $tokens (sort keys %Parser) {
		for $cpu (sort keys %{$Parser{$tokens}}) {
			for my $parens (sort keys %{$Parser{$tokens}{$cpu}}) {
				for $ixiy (sort keys %{$Parser{$tokens}{$cpu}{$parens}}) {
					my($asm, $prog) = @{$Parser{$tokens}{$cpu}{$parens}{$ixiy}};
					
					my @row = (format_tokens($tokens), $cpu, $parens, $ixiy, 
							   format_asm($asm), $prog->format_bytes, 
							   $prog->ticks->to_string);
					$tb->add(@row);
				}
			}
		}
	}

	say "Write ", $parser_table_file;
	$parser_table_file->spew_raw($tb->table);
}

#------------------------------------------------------------------------------
sub write_cpu_rules {
	eval {
		say "Write ", $cpu_rules_file;
		open(my $rules, ">:raw", $cpu_rules_file) or die $!;
		for my $tokens (sort keys %Parser) {
			print $rules $tokens, ' @{', "\n";
			print $rules merge_cpu($Parser{$tokens});
			print $rules '}', "\n\n";
		}
		close($rules);
	};
	if ($@) {
		say "Delete ", $cpu_rules_file;
		unlink "cpu_rules.h";
		die $@;
	}
}

#------------------------------------------------------------------------------
sub merge_cpu {
	my($t) = @_;
	my $ret = '';
	my %code;
	
	my $last_code;
	for $cpu (@CPUS) {
		if (exists $t->{$cpu}) {
			my $code = merge_parens($cpu, $t->{$cpu});
			$code{$code}{$cpu} = 1;
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
			for $cpu (sort keys %{$code{$code}}) {
				$ret .= "case CPU_".uc($cpu).": ";
			}
			$ret .= "\n$code\nbreak;\n"
		}
		$ret .= "default: error_illegal_ident(); }\n";
	}
	
	return $ret;
}

#------------------------------------------------------------------------------
sub merge_parens {
	my($cpu, $t) = @_;
	my $ret = '';
	
	if ($t->{$no_expr}) {
		die if $t->{$expr_no_parens} || $t->{$expr_in_parens};
		return merge_ixiy($cpu, $t->{$no_expr});
	}
	elsif (!$t->{$expr_no_parens} && !$t->{$expr_in_parens}) {
		die;
	}
	elsif (!$t->{$expr_no_parens} && $t->{$expr_in_parens}) {
		return "if (!expr_in_parens) return false;\n".
				merge_ixiy($cpu, $t->{$expr_in_parens});			
	}
	elsif ($t->{$expr_no_parens} && !$t->{$expr_in_parens}) {
		return "if (expr_in_parens) warn_expr_in_parens();\n".
				merge_ixiy($cpu, $t->{$expr_no_parens});
	}
	elsif ($t->{$expr_no_parens} && $t->{$expr_in_parens}) {
		my($common, $in_parens, $no_parens) = 
			extract_common(merge_ixiy($cpu, $t->{$expr_in_parens}),
						   merge_ixiy($cpu, $t->{$expr_no_parens}));
		return $common.
				"if (expr_in_parens) { $in_parens } else { $no_parens }";
	}
	else {
		die;
	}
}

#------------------------------------------------------------------------------
sub merge_ixiy {
	my($cpu, $t) = @_;
	
	my $ixiy_code = merge_prog($cpu, @{$t->{'-'}});
	my $iyix_code = merge_prog($cpu, @{$t->{'IXIY'}});
	
	if ($ixiy_code eq $iyix_code) {
		return $ixiy_code;
	}
	else {
		(my $common, $ixiy_code, $iyix_code) = extract_common($ixiy_code, $iyix_code);
		return $common.
				"if (!opts.swap_ix_iy) { $ixiy_code } else { $iyix_code }";
	}
}

#------------------------------------------------------------------------------
sub merge_prog {
	my($cpu, $asm, $prog) = @_;
	my @code;
	
	for my $instr (@{$prog->prog}) {
		push @code, parse_code($cpu, $asm, $instr);
	}
	
	my $code = join("\n", @code);
	return $code;
}

#------------------------------------------------------------------------------
sub parse_code {
	my($cpu, $asm, $instr) = @_;
	my @code;
	my $bytes = join(' ', @{$instr->bytes});

	# special cases
	if ($bytes =~ /\@(\w+)/) {
		my $func = $1;
		push @code, 
			"DO_STMT_LABEL();",
			"add_call_emul_func(\"$func\");";
		my $code = join("\n", @code);
		return $code;
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
	elsif ($asm =~ /^(bit|set|res) /) {
		push @code, 
			"DO_STMT_LABEL();",
			"if (expr_error) { error_expected_const_expr(); expr_value = 0; }",
			"else if (expr_value < 0 || expr_value > 7) { error_int_range(expr_value); expr_value = 0; }";
	}
	elsif ($asm =~ /^im /) {
		push @code, 
			"DO_STMT_LABEL();",
			"if (expr_error) { error_expected_const_expr(); expr_value = 0; }",
			"else if (expr_value < 0 || expr_value > 2) { error_int_range(expr_value); expr_value = 0; }";
	}
	
	# check for argument type
	my($stmt, $extra_arg) = ("", "");

	if ($bytes =~ s/ %d %n$//) {
		$stmt = "DO_stmt_idx_n";
	}
	elsif ($bytes =~ s/ %[nu]$//) {
		$stmt = "DO_stmt_n";
	}
	elsif ($bytes =~ s/ %s$//) {
		$stmt = "DO_stmt_d";
	}
	elsif ($bytes =~ s/ %d//) {
		$stmt = "DO_stmt_idx";
	}
	elsif ($bytes =~ s/ %m %m$//) {
		$stmt = "DO_stmt_nn";
	}
	elsif ($bytes =~ s/ %j$//) {
		$stmt = "DO_stmt_jr";
	}
	else {
		$stmt = "DO_stmt";
	}

	# build statement - need to leave expressions for C compiler
	my @bytes = split(' ', $bytes);
	my @expr;
	for (@bytes) {
		if (/[+*?<>]/) {
			my $offset = 0;
			if (s/^(\d+)\+//) {
				$offset = $1;
			}
			s/%c/expr_value/g;
			s/\b(\d+)\b/ $1 < 10 ? $1 : "0x".format_hex($1) /ge;
			
			push @expr, $_;
			$_ = format_hex($offset);
		}
		else {
			push @expr, undef;
			$_ = eval($_); die "$cpu, $asm, @bytes, $_" if $@;
			$_ = format_hex($_);
		}
	}
	
	my $opc = "0x".join('', @bytes);
	for (0..$#expr) {
		next unless defined $expr[$_];
		my $bytes_shift = scalar(@bytes) - $_ - 1;
		$opc .= '+(('.($expr[$_]).')';
		$opc .= ' << '.($bytes_shift * 8) if $bytes_shift;
		$opc .= ')';
	}
	push @code, $stmt."(".$opc.$extra_arg.");";
	
	my $code = join("\n", @code);
	return $code;
}

#------------------------------------------------------------------------------
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

sub init_tests {
	for my $asm (sort keys %Opcodes) {
		for $cpu (sort keys %{$Opcodes{$asm}}) {
			my $prog = $Opcodes{$asm}{$cpu};
			add_tests($asm, $prog);
		}
	}
}

#------------------------------------------------------------------------------
sub add_tests {
	my($asm, $prog) = @_;

	if ($asm =~ /%([dsunmbr])/) {
		my $k = $1;
		my @range = ($k eq 'd') ? (127, -128) :
					($k eq 's') ? (127, -128) :
					($k eq 'u') ? (0, -255) : 
					($k eq 'n') ? (255, 127, -128) : 
					($k eq 'm') ? (65535, 32767, -32768) : 
					($asm =~ /^(bit|res|set) /) ? (0 .. 7) :
					($asm =~ /^rst /) ? (restarts()) :
					die;
		for my $v (@range) {
			add_tests(replace($asm, "%$k", $v), $prog->clone($k => 0+$v));	# recurse
			if ($asm =~ /^rst/ && $v != 0) {
				add_tests(replace($asm, "%$k", $v/8), $prog->clone($k => 0+$v));	# recurse for rst 1..7
			}
		}
	}
	else {
		$Tests{$asm}{$cpu} = $prog->clone();
	}
}

#------------------------------------------------------------------------------
sub write_tests {
	write_tests_table();
	write_tests_files();
}

#------------------------------------------------------------------------------
sub write_tests_table {
	my $tb = Text::Table->new("; Assembly", \$table_separator, "CPU", \$table_separator, 
							  "IX/IY", \$table_separator, "Bytes", \$table_separator, "T-States");
	
	for my $asm (sort keys %Tests) {
		for $cpu (sort keys %{$Tests{$asm}}) {
			my $prog = $Tests{$asm}{$cpu};
			
			my @row = (format_asm($asm), $cpu, "-", 
					   $prog->format_bytes, $prog->ticks->to_string);
			$tb->add(@row);
			
			my $asm_ixiy = swap_ix_iy($asm);
			$prog = $Tests{$asm_ixiy}{$cpu};
			
			@row = (format_asm($asm), $cpu, "IXIY", 
					$prog->format_bytes, $prog->ticks->to_string);
			$tb->add(@row);
		}
	}

	say "Write ", $tests_file;
	$tests_file->spew_raw($tb->table);
}

#------------------------------------------------------------------------------
sub write_tests_files {
	my %fh;
	my %pc;
	for $cpu (@CPUS) {
		for $ixiy ('', '_ixiy') {
			for my $ok ('ok', 'err') {
				next if $ixiy && $ok eq 'err';
				say "Write ", $cpu_test_file{$cpu}{$ixiy}{$ok};
				open($fh{$cpu}{$ixiy}{$ok}, ">:raw", $cpu_test_file{$cpu}{$ixiy}{$ok}) or die;
			}
		}
	}
	
	for my $asm (sort keys %Tests) {
		my $asm_f = sprintf(" %-31s", $asm);
		for $cpu (@CPUS) {
			if (exists $Tests{$asm}{$cpu}) {
				for $ixiy ('', '_ixiy') {
					my $asm_swap = ($ixiy) ? swap_ix_iy($asm) : $asm;
					my $prog = $Tests{$asm_swap}{$cpu};
					my $size = $prog->size;
					my $next = $pc{$cpu}{$ixiy}{ok}//0 + $size;
					$fh{$cpu}{$ixiy}{ok}->print($asm_f."; ".$prog->format_bytes."\n");
					$pc{$cpu}{$ixiy}{ok} = next;
				}
			}
			else {
				my $prog = Instr->new($asm, B(), T(0));
				$fh{$cpu}{''}{err}->print($asm_f."; Error\n");
			}
		}
	}

}

#------------------------------------------------------------------------------
# Run tests
#------------------------------------------------------------------------------

sub run_tests {
	for $cpu (@CPUS) {
		for $ixiy ("", "--IXIY") {
			my @test;
			for my $asm (sort keys %Opcodes) {
				my $asm_swap = ($ixiy) ? swap_ix_iy($asm) : $asm;
				my $prog = $Opcodes{$asm_swap}{$cpu};
				if ($prog) {
					my $prog_instance = $prog->clone(
						n => 0x12, s => 0x12, d => 0x12, m => 0x1234);
					my $asm_instance = replace($asm, 
						'%n', 0x12, '%s', 0x12, '%d' => 0x12, '%m', 0x1234);
					my $test_asm = sprintf(" %-31s; %s", $asm_instance, $prog_instance->format_bytes);
					
					if ($asm eq 'jp (bc)' || 
						$asm eq 'jp (de)' || 
						$asm eq 'jp (hl)' || 
						$asm eq 'pchl' ||
						$asm eq 'stop') {
						ok run_test($ixiy, 0, [$test_asm, $prog_instance]);
					}
					elsif ($asm eq 'jmp %m' ||
					       $asm eq 'call %m' ||
					       ($asm eq 'jp %m' && !isintel)) {
						ok run_test($ixiy, 0x1234, [$test_asm, $prog_instance]);
					}
					elsif ($asm eq 'jr %j') {
						$prog_instance = $prog->clone(j => 0);		# jr 2 -> offset=0
						$asm_instance = replace($asm, '%j', 2);
						$test_asm = sprintf(" %-31s; %s", $asm_instance, $prog_instance->format_bytes);
						ok run_test($ixiy, 2, [$test_asm, $prog_instance]);
					}
					elsif ($asm =~ /(jp|call) (nz|z), %m|(j|c)(nz|z) %m/) {
						$prog_instance = $prog->clone(m => 5);
						$asm_instance = replace($asm, '%m', 5);
						$test_asm = sprintf(" %-31s; %s", $asm_instance, $prog_instance->format_bytes);
						
						# zero reset
						ok run_test($ixiy, undef, 
								[" xor a",		$Opcodes{"xor a"}{$cpu}->clone()],
								[" inc a",		$Opcodes{"inc a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
						
						# zero set
						ok run_test($ixiy, undef,
								[" xor a",		$Opcodes{"xor a"}{$cpu}->clone()],
								[" nop",		$Opcodes{"nop"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /jr (nz|z), %j/) {
						$prog_instance = $prog->clone(j => 0);		# jr 4 -> offset=0
						$asm_instance = replace($asm, '%j', 4);
						$test_asm = sprintf(" %-31s; %s", $asm_instance, $prog_instance->format_bytes);
						
						# zero reset
						ok run_test($ixiy, undef, 
								[" xor a",		$Opcodes{"xor a"}{$cpu}->clone()],
								[" inc a",		$Opcodes{"inc a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
						
						# zero set
						ok run_test($ixiy, undef,
								[" xor a",		$Opcodes{"xor a"}{$cpu}->clone()],
								[" nop",		$Opcodes{"nop"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /ret (nz|z)|r(nz|z)/) {
						# zero reset
						ok run_test($ixiy, undef, 
								[" ld hl, 7",	$Opcodes{"ld hl, %m"}{$cpu}->clone(m => 7)],
								[" push hl",	$Opcodes{"push hl"}{$cpu}->clone()],
								[" xor a",		$Opcodes{"xor a"}{$cpu}->clone()],
								[" inc a",		$Opcodes{"inc a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
						
						# zero set
						ok run_test($ixiy, undef,
								[" ld hl, 7",	$Opcodes{"ld hl, %m"}{$cpu}->clone(m => 7)],
								[" push hl",	$Opcodes{"push hl"}{$cpu}->clone()],
								[" xor a",		$Opcodes{"xor a"}{$cpu}->clone()],
								[" nop",		$Opcodes{"nop"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /(jp|call) (nc|c), %m|(j|c)(nc|c) %m/) {
						$prog_instance = $prog->clone(m => 4);
						$asm_instance = replace($asm, '%m', 4);
						$test_asm = sprintf(" %-31s; %s", $asm_instance, $prog_instance->format_bytes);
						
						# carry reset
						ok run_test($ixiy, undef, 
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
						
						# carry set
						ok run_test($ixiy, undef,
								[" scf",		$Opcodes{"scf"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /jr (nc|c), %j/) {
						$prog_instance = $prog->clone(j => 0);		# jr 3 -> offset=0
						$asm_instance = replace($asm, '%j', 3);
						$test_asm = sprintf(" %-31s; %s", $asm_instance, $prog_instance->format_bytes);
						
						# carry reset
						ok run_test($ixiy, undef, 
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
						
						# carry set
						ok run_test($ixiy, undef,
								[" scf",		$Opcodes{"scf"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /ret (nc|c)|r(nc|c)/) {
						# carry reset
						ok run_test($ixiy, undef, 
								[" ld hl, 6",	$Opcodes{"ld hl, %m"}{$cpu}->clone(m => 6)],
								[" push hl",	$Opcodes{"push hl"}{$cpu}->clone()],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
						
						# carry set
						ok run_test($ixiy, undef,
								[" ld hl, 6",	$Opcodes{"ld hl, %m"}{$cpu}->clone(m => 6)],
								[" push hl",	$Opcodes{"push hl"}{$cpu}->clone()],
								[" scf",		$Opcodes{"scf"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /(jp|call) (po|pe), %m|(j|c)(po|pe) %m/) {
						$prog_instance = $prog->clone(m => 6);
						$asm_instance = replace($asm, '%m', 6);
						$test_asm = sprintf(" %-31s; %s", $asm_instance, $prog_instance->format_bytes);
						
						# parity odd
						ok run_test($ixiy, undef, 
								[" ld a, 1",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 1)],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
						
						# parity even
						ok run_test($ixiy, undef,
								[" ld a, 0",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 0)],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /ret (po|pe)|r(po|pe)/) {
						# parity odd
						ok run_test($ixiy, undef, 
								[" ld hl, 8",	$Opcodes{"ld hl, %m"}{$cpu}->clone(m => 8)],
								[" push hl",	$Opcodes{"push hl"}{$cpu}->clone()],
								[" ld a, 1",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 1)],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
						
						# parity even
						ok run_test($ixiy, undef,
								[" ld hl, 8",	$Opcodes{"ld hl, %m"}{$cpu}->clone(m => 8)],
								[" push hl",	$Opcodes{"push hl"}{$cpu}->clone()],
								[" ld a, 0",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 0)],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /(jp|call) (p|m), %m|(j|c)(p|m) %m/) {
						$prog_instance = $prog->clone(m => 6);
						$asm_instance = replace($asm, '%m', 6);
						$test_asm = sprintf(" %-31s; %s", $asm_instance, $prog_instance->format_bytes);
						
						# positive
						ok run_test($ixiy, undef, 
								[" ld a, 1",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 1)],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
						
						# negative
						ok run_test($ixiy, undef,
								[" ld a, 255",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 255)],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /ret (p|m)|r(p|m)/) {
						# positive
						ok run_test($ixiy, undef, 
								[" ld hl, 8",	$Opcodes{"ld hl, %m"}{$cpu}->clone(m => 8)],
								[" push hl",	$Opcodes{"push hl"}{$cpu}->clone()],
								[" ld a, 1",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 1)],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
						
						# negative
						ok run_test($ixiy, undef,
								[" ld hl, 8",	$Opcodes{"ld hl, %m"}{$cpu}->clone(m => 8)],
								[" push hl",	$Opcodes{"push hl"}{$cpu}->clone()],
								[" ld a, 255",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 255)],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /rst %c/) {
						for my $target (restarts()) {
							$prog_instance = $prog->clone(c => $target);
							$asm_instance = replace($asm, '%c', $target);
							$test_asm = sprintf(" %-31s; %s", $asm_instance, $prog_instance->format_bytes);
							ok run_test($ixiy, $target, 
									[$test_asm, 	$prog_instance]);

							$asm_instance = replace($asm, '%c', $target/8);
							$test_asm = sprintf(" %-31s; %s", $asm_instance, $prog_instance->format_bytes);
							ok run_test($ixiy, $target, 
									[$test_asm, 	$prog_instance]);
						}
					}
					elsif ($asm =~ /im %c/) {
						for my $c (0..2) {
							$prog_instance = $prog->clone(c => $c);
							$asm_instance = replace($asm, '%c', $c);
							$test_asm = sprintf(" %-31s; %s", $asm_instance, $prog_instance->format_bytes);
							push @test, [$test_asm, $prog_instance];	
						}
					}
					elsif ($asm eq 'ret' ||
					       $asm eq 'reti' ||
						   $asm eq 'retn') {
						ok run_test($ixiy, 0, 
								[" push hl",	$Opcodes{"push hl"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /^(bit|set|res) /) {
						for my $c (0..7) {
							$prog_instance = $prog->clone(c => $c);
							$asm_instance = replace($asm, '%c', $c);
							$test_asm = sprintf(" %-31s; %s", $asm_instance, $prog_instance->format_bytes);
							push @test, [$test_asm, $prog_instance];	
						}
					}
					elsif ($asm eq 'halt' ||
						   $asm eq 'hlt') {
						ok run_test($ixiy, 0, 
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm eq 'ldi' ||
						   $asm eq 'ldir' ||
						   $asm eq 'ldd' ||
						   $asm eq 'lddr') {
						# BC = 1
						ok run_test($ixiy, undef, 
								[" ld bc, 1",	$Opcodes{"ld bc, %m"}{$cpu}->clone(m => 1)],
								[$test_asm, 	$prog_instance]);
								
						# BC = 2
						ok run_test($ixiy, undef, 
								[" ld bc, 2",	$Opcodes{"ld bc, %m"}{$cpu}->clone(m => 2)],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm eq 'cpi' ||
						   $asm eq 'cpir' ||
						   $asm eq 'cpd' ||
						   $asm eq 'cpdr') {
						# BC = 1, carry cleared
						ok run_test($ixiy, undef, 
								[" ld bc, 1",	$Opcodes{"ld bc, %m"}{$cpu}->clone(m => 1)],
								[" ld hl,1000h",$Opcodes{"ld hl, %m"}{$cpu}->clone(m => 0x1000)],
								[" ld a, 0FFh",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 0xFF)],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
								
						# BC = 1, carry set
						ok run_test($ixiy, undef, 
								[" ld bc, 1",	$Opcodes{"ld bc, %m"}{$cpu}->clone(m => 1)],
								[" ld hl,1000h",$Opcodes{"ld hl, %m"}{$cpu}->clone(m => 0x1000)],
								[" ld a, 0FFh",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 0xFF)],
								[" scf",		$Opcodes{"scf"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
								
						# BC = 2, carry cleared
						ok run_test($ixiy, undef, 
								[" ld bc, 2",	$Opcodes{"ld bc, %m"}{$cpu}->clone(m => 2)],
								[" ld hl,1000h",$Opcodes{"ld hl, %m"}{$cpu}->clone(m => 0x1000)],
								[" ld a, 0FFh",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 0xFF)],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
								
						# BC = 2, carry set
						ok run_test($ixiy, undef, 
								[" ld bc, 2",	$Opcodes{"ld bc, %m"}{$cpu}->clone(m => 2)],
								[" ld hl,1000h",$Opcodes{"ld hl, %m"}{$cpu}->clone(m => 0x1000)],
								[" ld a, 0FFh",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 0xFF)],
								[" scf",		$Opcodes{"scf"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
					}
					else {
						push @test, [$test_asm, $prog_instance];	
					}
				}
			}
			
			ok run_test($ixiy, undef, @test);
		}
	}
}

#------------------------------------------------------------------------------
sub run_test {
	my($ixiy, $end, @test) = @_;
	
	my $test = "run $cpu $ixiy ".scalar(@test)." opcodes";
	#diag $test;

	my $ok = assemble_and_run($cpu, $ixiy, $end, @test);
	ok $ok, $test;
	return $ok if $ok;

	# drill down to find error
	diag "Failed:\n".path('test.lis')->slurp;
	
	if (@test <= 1) {
		diag "Error in:\n", path('test.lis')->slurp, "\n";
		die "failed\n";
	}
	else {
		my $mid = int(@test / 2);
		return 0 if !run_test($ixiy, $end, @test[0 .. $mid-1]);
		return 0 if !run_test($ixiy, $end, @test[$mid .. $#test]);
		die "failed, both halves pass\n";
	}
}	

#------------------------------------------------------------------------------
sub assemble_and_run {
	my($cpu_, $ixiy, $end, @test) = @_;
	$cpu = $cpu_;	# set global so that isxxx() work
	
	my $ok = 1;
	return 1 if @test==0;
	
	# assembly
	my $asm = ""; 
	for (@test) { $asm .= $_->[0]."\n"; }
	$asm .= " nop\n";	# separate our code from library code by one byte
						# so that end address of ticks is not start of library

	#diag "assemble $cpu $ixiy ",scalar(@test)," opcodes, $size bytes, ",join("/", @ticks)," T\n";

	# assemble
	path('test.asm')->spew($asm);
	$ok &&= run("z80asm -m$cpu $ixiy -l -b -m test.asm");
	$ok or return;
		
	# read map file
	init_symtab();
	for (path('test.map')->lines) {
		/^(\w+)\s*=\s*\$([0-9A-F]+)/ and $symtab{$1} = hex($2);
	}

	# build object code - uses symtab
	my $prog = Prog->new;
	for (@test) { $prog->add($_->[1]); }
	my @bytes = @{$prog->bytes};
	my $bytes = join('', map {chr} @bytes);
	
	init_symtab();		# symtab no longer needed
	
	my $size = $prog->size; 
	$size == length($bytes) or die;
	
	my $size_hex = sprintf("%04X", $size);
	
	my @ticks = @{$prog->ticks};
	
	# use z80asm2 if building for z80 and no library calls
	my $got_bytes = path('test.bin')->slurp_raw;
	if (length($got_bytes) == $size+1 && !$ixiy && isz80()) {	# final nop is not counted in $size
		$ok &&= run("z80asm2 test.asm");
		$ok or return;

		my $got_bytes2 = path('test.bin')->slurp_raw;
		$got_bytes2 = substr($got_bytes2, 0, $size);
		$ok &&= check_bin($got_bytes2, $bytes);
	}
	$got_bytes = substr($got_bytes, 0, $size);		# ignore code after bytes - library
	$ok &&= check_bin($got_bytes, $bytes);
	
	# run
	my $ticks_cpu = ($cpu eq 'r3k') ? 'r2k' : $cpu;	# ticks does not support r3k
	my $ticks_end = defined($end) ? sprintf("%04X", $end) : $size_hex;
	$ok &&= run("z88dk-ticks test.bin -m$ticks_cpu -rom $size_hex -end $ticks_end >test.out");

	$ok or return;

	my $got_ticks = 0+path('test.out')->slurp;
	
	my $test = "got $got_ticks ticks, expected ".join("/", @ticks)." ticks";
	if ($got_ticks >= $ticks[0] && $got_ticks <= $ticks[1]) {
		ok 1, $test;
	}
	else {
		ok 0, $test;
		$ok = 0;
	}

	unlink "test.asm", "test.lis", "test.bin", "test.map", "test.o", "test.out" if $ok;
	return $ok;
}

#------------------------------------------------------------------------------
sub run {
	my($cmd) = @_;
	my $ok = (system($cmd)==0);
	ok $ok, $cmd;
	return $ok;
}

#------------------------------------------------------------------------------
sub check_bin {
	my($got, $expected) = @_;
	my $ok = ($got eq $expected);
	ok $ok, "check bin";
	if (!$ok) {
		my $addr = 0;
		while ($addr < length($got) && $addr < length($expected) 
				&& substr($got, $addr, 1) eq substr($expected, $addr, 1)) {
			$addr++;
		}
		diag sprintf("Output difers at \$%04X:", $addr);
		diag "expected ", hexdump(substr($expected, $addr, 10));
		diag "got      ", hexdump(substr($got, $addr, 10));
	}
	return $ok;
}

#------------------------------------------------------------------------------
sub hexdump {
	my($str) = @_;
	my $ret = '';
	my @bytes = map {ord} split //, $str;
	while (@bytes) {
		$ret .= sprintf("%02X ", shift @bytes);
	}
	$ret .= "\n";
	return $ret;
}

#------------------------------------------------------------------------------
sub replace {
	my($text, @pairs) = @_;
	while (my($find, $replace) = splice(@pairs, 0, 2)) {
		$text =~ s/$find/$replace/g;
	}
	return $text;
}

#------------------------------------------------------------------------------
sub swap_ix_iy {
	my($asm) = @_;
	$asm =~ s/\b(ix|iy)/ $1 eq 'ix' ? 'iy' : 'ix' /ge;
	return $asm;
}

#------------------------------------------------------------------------------
sub format_asm {
	my($asm) = @_;
	#$asm =~ s/^(((altd|ioi|ioe)\s+)*\w+\s*)/ sprintf("%-4s ", $1) /e;
	return $asm;
}

#------------------------------------------------------------------------------
sub format_tokens {
	my($tokens) = @_;
	$tokens =~ s/^\Q| label? //;
	$tokens =~ s/ _TK_NEWLINE$//;
	$tokens =~ s/_TK_//g;
	return $tokens;
}

#------------------------------------------------------------------------------
sub format_hex {
	return join(' ', map {/^\d+$/ ? sprintf('%02X', $_) : $_} @_);
}

#------------------------------------------------------------------------------
sub span_cells {
	my(@row) = @_;
	
	for my $i (1 .. $#row - 1) {
		for my $j ($i + 1 .. $#row) {
			last if $row[$i] =~ /^\s*$/;
			last if $row[$i] ne $row[$j];
			$row[$j] = "~";
		}
	}

	return @row;
}

#------------------------------------------------------------------------------
sub any_older {
	my(@files) = @_;
	for (@files) {
		return 1 if !-f $_;
		return 1 if (-M $0 < -M $_);
	}
	return 0;
}

#------------------------------------------------------------------------------
# main
#------------------------------------------------------------------------------
init_symtab();
init_opcodes(); 	#dump \%Opcodes;
init_parser(); 		#dump \%Parser;
init_tests();		#dump \%Tests;

if (any_older(@all_files)) {
	write_opcodes();
	write_parser();
	write_tests();
}

if (@ARGV && $ARGV[0] eq 'run') {
	ok 1;
	run_tests();
	done_testing();
}
