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
# %d  	8-bit unsigned offset in ix|iy indirect addressing
# %s  	8-bit signed offset
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
sub isgb()			{ return $cpu eq 'gbz80'; }
sub isz80()			{ return $cpu eq 'z80'; }
sub isz80n() 		{ return $cpu eq 'z80n'; }
sub isz180() 		{ return $cpu eq 'z180'; }
sub iszilog() 		{ return isz80() || isz80n() || isz180(); }
sub isr2k()			{ return $cpu eq 'r2k'; }
sub isr3k()			{ return $cpu eq 'r3k'; }
sub israbbit()		{ return isr2k() || isr3k(); }

sub ixiy_asm_flag 	{ return $ixiy ? "--IXIY " : ""; }

#------------------------------------------------------------------------------
# Assembly instruction
#------------------------------------------------------------------------------
{
	package Instr;
	use Modern::Perl;
	use Object::Tiny::RW qw( _asm _bytes ticks args asmpc );
	
	sub new {
		my($class, $asm, $bytes, $ticks, %args) = @_;
		
		# normalize input
		$bytes = [$bytes] if !ref($bytes);
		ref($bytes) eq 'ARRAY' or die;
		
		$ticks = [$ticks] if !ref($ticks);
		ref($ticks) eq 'ARRAY' or die;
		my @ticks = @$ticks;
		@ticks==1 and push @ticks, $ticks[0];
		@ticks==2 or die;
		
		return bless { 
			_asm => $asm, _bytes => $bytes, ticks => \@ticks, 
			args => \%args, asmpc => 0}, $class;
	}
	
	sub clone {
		my($self, %args) = @_;
		return bless {
			_asm 	=> $self->_asm, 
			_bytes 	=> [@{$self->_bytes}], 
			ticks 	=> [@{$self->ticks}],
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
		while (my($k, $v) = each %{$self->args}) {
			if ($k eq 'm') {
				array_replace_first(\@bytes, "%$k", $v & 0xFF, "%$k", ($v>>8) & 0xFF);
			}
			else {
				array_replace_first(\@bytes, "%$k", $v & 0xFF);
			}
		}
		return \@bytes;
	}
	
	sub size {
		my($self) = @_;
		return scalar @{$self->_bytes};
	}
	
	sub format_bytes {
		my($self) = @_;
		my @bytes = @{$self->bytes};
		for (@bytes) {
			s/(\d+)/ sprintf("%02X", $_) /ge;
		}
		return join(' ', @bytes);
	}

	sub array_replace_first {
		my($array, @pairs) = @_;
		while (my($find, $replace) = splice(@pairs, 0, 2)) {
			for (@$array) {
				s/$find/$replace/ and last;
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
		return \@ticks;
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
		  rlc => 0, rrc => 1, ral => 2, rar => 3);
sub OP($)		{ return $OP{$_[0]}; }

#------------------------------------------------------------------------------
sub init_opcodes {
	for $cpu (@CPUS) {
		next unless $cpu =~ /8080|8085/;

		#----------------------------------------------------------------------
		# 8080 opcodes
		#----------------------------------------------------------------------

		add("nop", 				0x00, isintel ? 4 : die);

		# data transfer group
		for my $r1 (qw( b c d e h l a )) {
			for my $r2 (qw( b c d e h l a )) {
				next if $cpu eq 'r3k' && "$r1,$r2" eq "e,e";
				add("ld  $r1, $r2", 0x40+R($r1)*8+R($r2), is8080 ? 5 : israbbit ? 2 : 4);
				add("mov $r1, $r2", 0x40+R($r1)*8+R($r2), is8080 ? 5 : israbbit ? 2 : 4);
			}
		}

		for my $r (qw( b c d e h l a )) {
			add("ld  $r, (hl)", 0x40+R($r)*8+6, isintel ? 7 : die);
			add("mov $r, m", 	0x40+R($r)*8+6, isintel ? 7 : die);
			
			add("ld  (hl), $r", 0x40+6*8+R($r), isintel ? 7 : die);
			add("mov m, $r", 	0x40+6*8+R($r), isintel ? 7 : die);
			
			add("ld  $r, %n",	[0x00+R($r)*8+6, '%n'], isintel ? 7 : die);
			add("mvi $r, %n",	[0x00+R($r)*8+6, '%n'], isintel ? 7 : die);
		}
			
		add("ld  (hl), %n",		[0x00+6*8+6, '%n'], isintel ? 10 : die);
		add("mvi m, %n",		[0x00+6*8+6, '%n'], isintel ? 10 : die);
	
		for my $r (qw( b bc d de h hl sp )) {
			add("lxi $r, %m",	[0x01+RP($r)*16, '%m', '%m'], isintel ? 10 : die);
		}
		for my $r (qw( bc de hl sp )) {
			add("ld $r, %m",	[0x01+RP($r)*16, '%m', '%m'], isintel ? 10 : die);
		}

		add("lda %m",			[0x3A, '%m', '%m'], isintel ? 13 : die);
		add("ld a, (%m)",		[0x3A, '%m', '%m'], isintel ? 13 : die);
		
		add("sta %m",			[0x32, '%m', '%m'], isintel ? 13 : die);
		add("ld (%m), a",		[0x32, '%m', '%m'], isintel ? 13 : die);
		
		add("lhld %m",			[0x2A, '%m', '%m'], isintel ? 16 : die);
		add("ld hl, (%m)",		[0x2A, '%m', '%m'], isintel ? 16 : die);
		
		add("shld %m",			[0x22, '%m', '%m'], isintel ? 16 : die);
		add("ld (%m), hl",		[0x22, '%m', '%m'], isintel ? 16 : die);
		
		for my $r (qw( b bc d de )) {
			add("ldax $r",		[0x0A+RP($r)*16], isintel ? 7 : die);
			add("stax $r",		[0x02+RP($r)*16], isintel ? 7 : die);
		}
		for my $r (qw( bc de )) {
			add("ld a, ($r)",	0x0A+RP($r)*16, isintel ? 7 : die);
			add("ld ($r), a",	0x02+RP($r)*16, isintel ? 7 : die);
		}

		add("xchg",				0xEB, isintel ? 4 : die);
		add("ex de, hl",		0xEB, isintel ? 4 : die);

		add("xthl",				0xE3, is8080 ? 18 : is8085 ? 16 : die);
		add("ex (sp), hl",		0xE3, is8080 ? 18 : is8085 ? 16 : die);

		add("sphl",				0xF9, is8080 ? 5 : is8085 ? 6 : die);
		add("ld sp, hl",		0xF9, is8080 ? 5 : is8085 ? 6 : die);

		# Zilog
		for my $op (qw( add adc sub sbc and xor or  cp  )) {
			next if $op eq 'cp' && isintel;	# CP is Call Positive in Intel
			for my $r (qw( b c d e h l a )) {
				add("$op a, $r",0x80+OP($op)*8+R($r), isintel ? 4 : die);
				add("$op $r", 	0x80+OP($op)*8+R($r), isintel ? 4 : die);
			}
			add("$op a, (hl)", 	0x80+OP($op)*8+6, isintel ? 7 : die);
			add("$op (hl)", 	0x80+OP($op)*8+6, isintel ? 7 : die);

			add("$op a, %n", 	[0xC6+OP($op)*8, '%n'], isintel ? 7 : die);
			add("$op %n", 		[0xC6+OP($op)*8, '%n'], isintel ? 7 : die);
		}
		
		# Intel
		for my $op (qw( add adc sub sbb ana xra ora cmp )) {	
			for my $r (qw( b c d e h l a )) {
				add("$op $r", 	0x80+OP($op)*8+R($r), isintel ? 4 : die) unless $op =~ /add|adc|sub/; # already done in Zilog
			}
			add("$op m", 		0x80+OP($op)*8+6, isintel ? 7 : die);
		}
		
		for my $op (qw( adi aci sui sbi ani xri ori cpi )) {
			add("$op %n", 		[0xC6+OP($op)*8, '%n'], isintel ? 7 : die);
		}
			
		for my $r (qw( b c d e h l a )) {
			add("inr $r", 		0x04+R($r)*8, is8080 ? 5 : is8085 ? 4 : die);
			add("inc $r", 		0x04+R($r)*8, is8080 ? 5 : is8085 ? 4 : die);

			add("dcr $r", 		0x05+R($r)*8, is8080 ? 5 : is8085 ? 4 : die);
			add("dec $r", 		0x05+R($r)*8, is8080 ? 5 : is8085 ? 4 : die);
		}

		add("inr m", 			0x04+6*8, isintel ? 10 : die);
		add("inc (hl)", 		0x04+6*8, isintel ? 10 : die);

		add("dcr m", 			0x05+6*8, isintel ? 10 : die);
		add("dec (hl)", 		0x05+6*8, isintel ? 10 : die);

		for my $r (qw( b bc d de h hl sp )) {
			add("inx $r",		0x03+RP($r)*16, is8080 ? 5 : is8085 ? 6 : die);
			add("dcx $r",		0x0B+RP($r)*16, is8080 ? 5 : is8085 ? 6 : die);
			add("dad $r",		0x09+RP($r)*16, isintel ? 10 : die);
		}
		
		for my $r (qw( bc de hl sp )) {
			add("inc $r",		0x03+RP($r)*16, is8080 ? 5 : is8085 ? 6 : die);
			add("dec $r",		0x0B+RP($r)*16, is8080 ? 5 : is8085 ? 6 : die);
			add("add hl, $r",	0x09+RP($r)*16, isintel ? 10 : die);
		}

		for my $op (qw( rlca rrca rla  rra
						rlc  rrc  ral  rar )) {
			add("$op",			0x07+OP($op)*8, isintel ? 4 : die);
		}
		
		add("daa",				0x27, isintel ? 4 : die);

		add("cpl",				0x2F, isintel ? 4 : die);
		add("cma",				0x2F, isintel ? 4 : die);
		
		add("scf",				0x37, isintel ? 4 : die);
		add("stc",				0x37, isintel ? 4 : die);
		
		add("ccf",				0x3F, isintel ? 4 : die);
		add("cmc",				0x3F, isintel ? 4 : die);

		add("pchl",				0xE9, is8080 ? 5 : is8085 ? 6 : die);
		add("jp (hl)",			0xE9, is8080 ? 5 : is8085 ? 6 : die);

		for my $r (qw( b bc d de h hl af psw )) {
			add("push $r",		0xC5+RP($r)*16, is8080 ? 11 : is8085 ? 12 : die);
			add("pop $r",		0xC1+RP($r)*16, isintel ? 10 : die);
		}

		add("jmp %m",			[0xC3, '%m', '%m'], isintel ? 10 : die);
		add("jp  %m",			[0xC3, '%m', '%m'], isintel ? 10 : die) unless isintel; # JP in Intel is Jump if Positive

		add("call %m",			[0xCD, '%m', '%m'], is8080 ? 17 : is8085 ? 18 : die);
		add("ret",				0xC9, isintel ? 10 : die);

		for my $f (qw( nz z nc c po pe p m )) {
			add("j$f    %m",	[0xC2+8*F($f), '%m', '%m'], is8080 ? 10 : is8085 ? [7,10] : die) unless $f eq 'p' && !isintel;
			add("jp $f, %m",	[0xC2+8*F($f), '%m', '%m'], is8080 ? 10 : is8085 ? [7,10] : die) unless isintel;		# JP in Intel is Jump if Positive

			add("c$f      %m",	[0xC4+8*F($f), '%m', '%m'], is8080 ? [11,17] : is8085 ? [9,18] : die) unless $f eq 'p' && !isintel;
			add("call $f, %m",	[0xC4+8*F($f), '%m', '%m'], is8080 ? [11,17] : is8085 ? [9,18] : die);

			add("r$f",			0xC0+8*F($f), is8080 ? [5,11] : is8085 ? [6,12] : die);
			add("ret $f",		0xC0+8*F($f), is8080 ? [5,11] : is8085 ? [6,12] : die);
		}
		
		for my $n (0..7) {
			add("rst ".($n*8),	0xC7+$n*8, is8080 ? 11 : is8085 ? 12 : die);
			add("rst ".($n),	0xC7+$n*8, is8080 ? 11 : is8085 ? 12 : die) if $n;
		}
		
		add("in %n",			[0xDB, '%n'], isintel ? 10 : die);
		add("in a, (%n)",		[0xDB, '%n'], isintel ? 10 : die);
		
		add("out %n",			[0xD3, '%n'], isintel ? 10 : die);
		add("out (%n), a",		[0xD3, '%n'], isintel ? 10 : die);

		add("ei",				0xFB, isintel ? 4 : die);
		add("di",				0xF3, isintel ? 4 : die);

		add("hlt",				0x76, is8080 ? 7 : is8085 ? 5 : die);
		add("halt",				0x76, is8080 ? 7 : is8085 ? 5 : die);

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
			
			# Store HL at address pointed by DE
			add("shlx",			0xD9, 10);
			add("shlde",		0xD9, 10);
			add("ld (de), hl",	0xD9, 10);

			# Jump on flag X5/K is reset
			add("jnx5 %m",		[0xDD, '%m', '%m'], [7,10]);
			add("jnk %m",		[0xDD, '%m', '%m'], [7,10]);

			# Load HL from address pointed by DE
			add("lhlx",			0xED, 10);
			add("lhlde",		0xED, 10);
			add("ld hl, (de)",	0xED, 10);

			# Jump on flag X5/K is set
			add("jx5 %m",		[0xFD, '%m', '%m'], [7,10]);
			add("jk %m",		[0xFD, '%m', '%m'], [7,10]);
		}

		#----------------------------------------------------------------------
		# compound opcodes
		next;
		
		for my $r (qw( bc de )) {
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

		for my $r1 (qw( bc de hl )) {
			my($r1h, $r1l) = split(//, $r1);
			for my $r2 (qw( bc de hl )) {
				my($r2h, $r2l) = split(//, $r2);
				
				add_compound("ld $r1, $r2"	=> "ld $r1h, $r2h", "ld $r1l, $r2l");
			}
		}

		for my $r (qw( b c d e h l a )) {
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
	
	$Opcodes{$asm}{$cpu} and die;
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
	my $tb = Text::Table->new("; Assembly", \$table_separator, "CPU", \$table_separator, "Bytes", \$table_separator, "T-States");
	
	for my $asm (sort keys %Opcodes) {
		for $cpu (sort keys %{$Opcodes{$asm}}) {
			my $prog = $Opcodes{$asm}{$cpu};

			my @row = (format_asm($asm), $cpu, $prog->format_bytes,
					   format_ticks($prog->ticks));			
			$tb->add(@row);
		}
	}
	say "Write ",$opcodes_file;
	$opcodes_file->spew_raw($tb->table);
}

#------------------------------------------------------------------------------
sub write_opcodes_by_asm {
	# build table with assembly per cpu
	my %by_bytes;
	
	# build title and collect cpu column numbers
	my %cpu_column;
	my $column;

	my @title = ("; Assembly");
	for (@CPUS) { 
		push @title, \$table_separator, $_;
	}
		
	my $tb = Text::Table->new(@title);
	
	for my $asm (sort keys %Opcodes) {
		my $f_asm = format_asm($asm);
		my @row_bytes 		= ($f_asm, (" ") x ($tb->n_cols - 1));
		my @row_t_states 	= ((" ") x ($tb->n_cols));
		for $cpu (sort keys %{$Opcodes{$asm}}) {
			my $prog = $Opcodes{$asm}{$cpu};
			$column = 1 + $CPU_I{$cpu};
			
			my $f_bytes = $prog->format_bytes;
			$row_bytes[$column] 	= $f_bytes;
			$row_t_states[$column] 	= format_ticks($prog->ticks);

			# save for later
			$by_bytes{$f_bytes}{$cpu} .= "\n" if $by_bytes{$f_bytes}{$cpu};
			$by_bytes{$f_bytes}{$cpu} .= $f_asm;
			
		}
		$tb->add(span_cells(@row_bytes));
		$tb->add(span_cells(@row_t_states));
		$tb->add((" ") x $tb->n_cols);
	}
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
		elsif (/\G    %[c]		/gcx) { push @tokens, "const_expr"; }
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
							   format_ticks($prog->ticks));
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
			$_ =~ s/\b(\d+)\b/ $1 < 10 ? $1 : "0x".format_hex($1) /ge;
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
			add_tests($cpu, $asm, $prog);
		}
	}
}

#------------------------------------------------------------------------------
sub add_tests {
	my($cpu, $asm, $prog) = @_;

	if ($asm =~ /%([dsunm])/) {
		my $k = $1;
		my @range = ($k eq 'd') ? ("+127", "-128") :
					($k eq 's') ? ("+127", "-128") :
					($k eq 'u') ? ("+0", "-255") : 
					($k eq 'n') ? (255, 127, -128) : 
					($k eq 'm') ? (65535, 32767, -32768) : 
					die;
		for my $v (@range) {
			add_tests($cpu, replace($asm, "%$k", $v), $prog->clone($k => 0+$v));	# recurse
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
					   $prog->format_bytes, format_ticks($prog->ticks));
			$tb->add(@row);
			
			my $asm_ixiy = swap_ix_iy($asm);
			$prog = $Tests{$asm_ixiy}{$cpu};
			
			@row = (format_asm($asm), $cpu, "IXIY", 
					$prog->format_bytes, format_ticks($prog->ticks));
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
				my $prog = Instr->new($asm);
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
					my $prog_instance = $prog->clone(n => 0x12, m => 0x1234);
					my $asm_instance = replace($asm, '%n', 0x12, '%m', 0x1234);
					my $test_asm = sprintf(" %-31s; %s", $asm_instance, $prog_instance->format_bytes);
					
					if ($asm eq 'jp (bc)' || 
						$asm eq 'jp (de)' || 
						$asm eq 'jp (hl)' || 
						$asm eq 'pchl') {
						run_test($cpu, $ixiy, 0, [$test_asm, $prog_instance]);
					}
					elsif ($asm eq 'jmp %m' ||
					       $asm eq 'call %m' ||
					       ($asm eq 'jp %m' && !isintel)) {
						run_test($cpu, $ixiy, 0x1234, [$test_asm, $prog_instance]);
					}
					elsif ($asm =~ /(jp|call) (nz|z), %m|(j|c)(nz|z) %m/) {
						$prog_instance = $prog->clone(m => 5);
						$asm_instance = replace($asm, '%m', 5);
						$test_asm = sprintf(" %-31s; %s", $asm_instance, $prog_instance->format_bytes);
						
						# zero reset
						run_test($cpu, $ixiy, undef, 
								[" xor a",		$Opcodes{"xor a"}{$cpu}->clone()],
								[" inc a",		$Opcodes{"inc a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
						
						# zero set
						ok run_test($cpu, $ixiy, undef,
								[" xor a",		$Opcodes{"xor a"}{$cpu}->clone()],
								[" nop",		$Opcodes{"nop"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /ret (nz|z)|r(nz|z)/) {
						# zero reset
						run_test($cpu, $ixiy, undef, 
								[" ld hl, 7",	$Opcodes{"ld hl, %m"}{$cpu}->clone(m => 7)],
								[" push hl",	$Opcodes{"push hl"}{$cpu}->clone()],
								[" xor a",		$Opcodes{"xor a"}{$cpu}->clone()],
								[" inc a",		$Opcodes{"inc a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
						
						# zero set
						ok run_test($cpu, $ixiy, undef,
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
						run_test($cpu, $ixiy, undef, 
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
						
						# carry set
						ok run_test($cpu, $ixiy, undef,
								[" scf",		$Opcodes{"scf"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /ret (nc|c)|r(nc|c)/) {
						# carry reset
						run_test($cpu, $ixiy, undef, 
								[" ld hl, 6",	$Opcodes{"ld hl, %m"}{$cpu}->clone(m => 6)],
								[" push hl",	$Opcodes{"push hl"}{$cpu}->clone()],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
						
						# carry set
						ok run_test($cpu, $ixiy, undef,
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
						run_test($cpu, $ixiy, undef, 
								[" ld a, 1",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 1)],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
						
						# parity even
						ok run_test($cpu, $ixiy, undef,
								[" ld a, 0",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 0)],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /ret (po|pe)|r(po|pe)/) {
						# parity odd
						run_test($cpu, $ixiy, undef, 
								[" ld hl, 8",	$Opcodes{"ld hl, %m"}{$cpu}->clone(m => 8)],
								[" push hl",	$Opcodes{"push hl"}{$cpu}->clone()],
								[" ld a, 1",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 1)],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
						
						# parity even
						ok run_test($cpu, $ixiy, undef,
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
						run_test($cpu, $ixiy, undef, 
								[" ld a, 1",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 1)],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
						
						# negative
						ok run_test($cpu, $ixiy, undef,
								[" ld a, 255",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 255)],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /ret (p|m)|r(p|m)/) {
						# positive
						run_test($cpu, $ixiy, undef, 
								[" ld hl, 8",	$Opcodes{"ld hl, %m"}{$cpu}->clone(m => 8)],
								[" push hl",	$Opcodes{"push hl"}{$cpu}->clone()],
								[" ld a, 1",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 1)],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
						
						# negative
						ok run_test($cpu, $ixiy, undef,
								[" ld hl, 8",	$Opcodes{"ld hl, %m"}{$cpu}->clone(m => 8)],
								[" push hl",	$Opcodes{"push hl"}{$cpu}->clone()],
								[" ld a, 255",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 255)],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /rst (\d+)/) {
						my $target = $1;
						$target *= 8 if $target < 8;
						run_test($cpu, $ixiy, $target, 
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm eq 'ret') {
						run_test($cpu, $ixiy, 0, 
								[" push hl",	$Opcodes{"push hl"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm eq 'halt' ||
						   $asm eq 'hlt') {
						run_test($cpu, $ixiy, 0, 
								[$test_asm, 	$prog_instance]);
					}
					else {
						push @test, [$test_asm, $prog_instance];	
					}
				}
			}
			
			run_test($cpu, $ixiy, undef, @test);
		}
	}
}

#------------------------------------------------------------------------------
sub run_test {
	my($cpu, $ixiy, $end, @test) = @_;
	
	my $test = "run $cpu $ixiy ".scalar(@test)." opcodes";
	#diag $test;

	my $ok = assemble_and_run($cpu, $ixiy, $end, @test);
	ok $ok, $test;
	return $ok if $ok;

	# drill down to find error
	if (@test <= 1) {
		diag "Error in:\n", path('test.lis')->slurp, "\n";
		die "failed\n";
	}
	else {
		my $mid = int(@test / 2);
		return 0 if !run_test($cpu, $ixiy, $end, @test[0 .. $mid-1]);
		return 0 if !run_test($cpu, $ixiy, $end, @test[$mid .. $#test]);
		die "failed, both halves pass\n";
	}
}	

#------------------------------------------------------------------------------
sub assemble_and_run {
	my($cpu, $ixiy, $end, @test) = @_;

	my $ok = 1;
	return 1 if @test==0;
	
	# assembly
	my $asm = ""; 
	for (@test) { $asm .= $_->[0]."\n"; }
	
	# object code
	my $prog = Prog->new;
	for (@test) { $prog->add($_->[1]); }
	my @bytes = @{$prog->bytes};
	my $bytes = join('', map {chr} @bytes);
	
	my $size = $prog->size; 
	$size == length($bytes) or die;
	
	my $size_hex = sprintf("%04X", $size);
	
	my @ticks = @{$prog->ticks};
	
	#diag "assemble $cpu $ixiy ",scalar(@test)," opcodes, $size bytes, ",join("/", @ticks)," T\n";

	# assemble
	path('test.asm')->spew($asm);
	path('test.exp.bin')->spew_raw($bytes);
	$ok &&= run("z80asm -m$cpu $ixiy -l -b test.asm");

	$ok or return;
	
	my $got_bytes = path('test.bin')->slurp_raw;
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

	unlink "test.asm", "test.lis", "test.bin", "test.exp.bin", "test.o", "test.out" if $ok;
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
sub format_ticks {
	my($ticks) = @_;
	my @ticks = @$ticks;
	@ticks==2 or die;
	pop @ticks if $ticks[1]==$ticks[0];
	return sprintf("%5s T", join('/', @ticks));
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
