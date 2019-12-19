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
use Getopt::Std;

#------------------------------------------------------------------------------
our $opt_s;		# stop on first error
getopts('s') or die "Usage: cpu.pl [-s] [test]\n";
#------------------------------------------------------------------------------

# make sure to use our z80asm
$ENV{PATH} = join($Config{path_sep}, ".", "../ticks", $ENV{PATH});

#------------------------------------------------------------------------------
# Globals
#------------------------------------------------------------------------------
our @CPUS = sort qw( 8080 8085 gbz80 r2k r3k z180 z80 z80n );
our %CPU_I; for (0 .. $#CPUS) { $CPU_I{$CPUS[$_]} = $_; }
our $cpu = 'z80';
our $ixiy;

our $opcodes_asm_file 		= path(path($0)->dirname, "opcodes_asm.csv");
our $opcodes_bytes_file 	= path(path($0)->dirname, "opcodes_bytes.csv");
our @opcodes_files 			= ($opcodes_asm_file, $opcodes_bytes_file);

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
			splice(@bytes, $_, 1, "(\@$sym&0xff)", "((\@$sym>>8)&0xff)");
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
		if (/\@(?:__z80asm__)?(\w+)&0xff/) {
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
				array_replace_first(\@bytes, "%$k", $v & 0xff, "%$k", ($v>>8) & 0xff);
			}
			else {
				array_replace_first(\@bytes, "%$k", $v & 0xff);
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

    sub word_to_unsigned_byte_arg {
		my($self) = @_;
        $self->{_asm} =~ s/%m/%n/;
        for (@{$self->_bytes}) { s/%m/%n/ and last; }
        for (@{$self->_bytes}) { s/%m/0/ and last; }
    }
    
    sub word_to_signed_byte_arg {
		my($self) = @_;
        $self->{_asm} =~ s/%m/%n/;
        for (@{$self->_bytes}) { s/%m/%s/ and last; }
        for (@{$self->_bytes}) { s/%m/0/ and last; }
    }
    
    sub instanciate {
        my($self, %args) = @_;

		while (my($k, $v) = each %args) {
			if ($k eq 'm') {
				array_replace_first($self->_bytes, "%$k", $v & 0xff, "%$k", ($v>>8) & 0xff);
			}
			else {
				array_replace_first($self->_bytes, "%$k", $v & 0xff);
			}
            $self->{_asm} =~ s/%$k/$v/;
		}
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

    sub word_to_unsigned_byte_arg {
		my($self) = @_;
		for my $instr (@{$self->prog}) {
			$instr->word_to_unsigned_byte_arg();
		}
    }
    
    sub word_to_signed_byte_arg {
		my($self) = @_;
		for my $instr (@{$self->prog}) {
			$instr->word_to_signed_byte_arg();
		}
    }
    
    sub instanciate {
        my($self, %args) = @_;
		for my $instr (@{$self->prog}) {
			$instr->instanciate(%args);
		}
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

my %F = (nz => 0, z => 1, nc => 2, c => 3, po => 4, pe => 5, 
										   nv => 4, v  => 5, p => 6, m => 7);
sub F($)		{ return $F{$_[0]}; }

my %RP = (b => 0, bc => 0, d => 1, de => 1, h => 2, hl => 2, sp => 3, af => 3, psw => 3);
sub RP($)		{ return $RP{$_[0]}; }

my %P = (ix => 0xdd, iy => 0xfd);
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
    
        if (israbbit||isz180) {
            for my $r (qw( bc de hl sp )) {
                add(	"ld  $r,  %m", B(0x01+RP($r)*16, '%m', '%m'), T(israbbit ? 6 : 9));
            }
        }
        
		next unless isintel || isgbz80 || isz80 || isz80n;
		say "Build opcodes for $cpu";
		
		#----------------------------------------------------------------------
		# 8-bit load group
		#----------------------------------------------------------------------
		
		# ld r, r
		for my $r1 (qw(     b c d e h l a )) {
			for my $r2 (qw( b c d e h l a )) {
				next if $cpu eq 'r3k' && "$r1,$r2" eq "e,e";
				add(	"ld  $r1, $r2", B(0x40+R($r1)*8+R($r2)), T(is8080 ? 5 : israbbit ? 2 : 4));
				add(	"mov $r1, $r2", B(0x40+R($r1)*8+R($r2)), T(is8080 ? 5 : israbbit ? 2 : 4));
				add_ixh("ld  $r1, $r2",	B(0x40+R($r1)*8+R($r2)), T(is8080 ? 5 : israbbit ? 2 : 4)+4);
			}
		}

		# ld r, n
		for my $r (qw( b c d e h l a )) {
			add(	"ld  $r, %n", B(0x00+R($r)*8+6, '%n'), T(isgbz80 ? 8 : 7));
			add(	"mvi $r, %n", B(0x00+R($r)*8+6, '%n'), T(isgbz80 ? 8 : 7));
			add_ixh("ld  $r, %n", B(0x00+R($r)*8+6, '%n'), T(isgbz80 ? 8 : 7)+4);
		}

		# ld r, (hl) / (ix+d) / (iy+d)
		for my $r (qw( b c d e h l a )) {
			add(	 "ld  $r, (hl)", B(0x40+R($r)*8+6), T(isgbz80 ? 8 : 7));
			add(	 "mov $r,  m",	 B(0x40+R($r)*8+6), T(isgbz80 ? 8 : 7));
			add_ix_d("ld  $r, (hl)", B(0x40+R($r)*8+6), T(isgbz80 ? 8 : 7)+12);
		}

		# ld (hl) / (ix+d) / (iy+d), r
		for my $r (qw( b c d e h l a )) {
			add(	 "ld  (hl), $r", B(0x40+6*8+R($r)), T(isgbz80 ? 8 : 7));
			add(	 "mov  m,   $r", B(0x40+6*8+R($r)), T(isgbz80 ? 8 : 7));
			add_ix_d("ld  (hl), $r", B(0x40+6*8+R($r)), T(isgbz80 ? 8 : 7)+12);
		}

		# ld (hl) / (ix+d) / (iy+d), n
		add(	 "ld  (hl), %n", B(0x00+6*8+6, '%n'), T(isgbz80 ? 12 : 10));
		add(	 "mvi  m,   %n", B(0x00+6*8+6, '%n'), T(isgbz80 ? 12 : 10));
		add_ix_d("ld  (hl), %n", B(0x00+6*8+6, '%n'), T(isgbz80 ? 12 : 10)+9);

		# ld a, (bc) / (de)
		for my $r (qw( bc de )) {
			my $r1 = substr($r, 0, 1);
			add("ld a, ($r)", B(0x0a+RP($r)*16), T(isgbz80 ? 8 : 7));
			add("ldax $r",	  B(0x0a+RP($r)*16), T(isgbz80 ? 8 : 7));
			add("ldax $r1",	  B(0x0a+RP($r)*16), T(isgbz80 ? 8 : 7));
		}
		
		# ld a, (nn)
		add("lda %m",	  B(isgbz80 ? 0xfa : 0x3a, '%m', '%m'), T(isgbz80 ? 16 : 13));
		add("ld a, (%m)", B(isgbz80 ? 0xfa : 0x3a, '%m', '%m'), T(isgbz80 ? 16 : 13));

		# ld (bc) / (de), a
		for my $r (qw( bc de )) {
			my $r1 = substr($r, 0, 1);
			add("ld ($r), a", B(0x02+RP($r)*16), T(isgbz80 ? 8 : 7));
			add("stax $r",	  B(0x02+RP($r)*16), T(isgbz80 ? 8 : 7));
			add("stax $r1",	  B(0x02+RP($r)*16), T(isgbz80 ? 8 : 7));
		}
		
		# ld (nn), a
		add("ld (%m), a", B(isgbz80 ? 0xea : 0x32, '%m', '%m'), T(isgbz80 ? 16 : 13));
		add("sta %m",     B(isgbz80 ? 0xea : 0x32, '%m', '%m'), T(isgbz80 ? 16 : 13));
		
		# ld a, i / ld a, r / ld i,a / ld r, a
		if (iszilog) {
			add("ld a, i", B(0xed, 0x57), T(9));
			add("ld a, r", B(0xed, 0x5f), T(9));
			add("ld i, a", B(0xed, 0x47), T(9));
			add("ld r, a", B(0xed, 0x4f), T(9));
		}

		if (isgbz80) {
			add("ld  (hl+), a", B(0x22), T(8));
			add("ld  (hli), a", B(0x22), T(8));
			add("ldi (hl), a", 	B(0x22), T(8));

			add("ld  a, (hl+)", B(0x2a), T(8));
			add("ld  a, (hli)", B(0x2a), T(8));
			add("ldi a, (hl)", 	B(0x2a), T(8));

			add("ld  (hl-), a", B(0x32), T(8));
			add("ld  (hld), a", B(0x32), T(8));
			add("ldd (hl), a", 	B(0x32), T(8));

			add("ld  a, (hl-)", B(0x3a), T(8));
			add("ld  a, (hld)", B(0x3a), T(8));
			add("ldd a, (hl)", 	B(0x3a), T(8));
		}

		#----------------------------------------------------------------------
		# 16-bit load group
		#----------------------------------------------------------------------

		# ld dd, nn
		for my $r (qw( bc de hl sp )) {
			my $r1 = substr($r, 0, 1);
			add(	"ld  $r,  %m", B(0x01+RP($r)*16, '%m', '%m'), T(isgbz80 ? 12 : 10));
			add(	"lxi $r,  %m", B(0x01+RP($r)*16, '%m', '%m'), T(isgbz80 ? 12 : 10));
			add(	"lxi $r1, %m", B(0x01+RP($r)*16, '%m', '%m'), T(isgbz80 ? 12 : 10)) unless $r eq 'sp';
			add_ix(	"ld  $r,  %m", B(0x01+RP($r)*16, '%m', '%m'), T(isgbz80 ? 12 : 10)+4);
		}

		# ld hl, (nn)
		if (!isgbz80) {
			add(	"ld hl, (%m)",	B(0x2a, '%m', '%m'), T(16));		
			add(	"lhld   %m",	B(0x2a, '%m', '%m'), T(16));
			add_ix(	"ld hl, (%m)",	B(0x2a, '%m', '%m'), T(16)+4);
		}
		
		# ld dd, (nn)
		for my $r (qw( bc de sp )) {
			if (!isintel && !isgbz80) {
				add(	"ld $r, (%m)",	B(0xed, 0x4b+RP($r)*16, '%m', '%m'), T(20));
			}
		}
			
		# ld (nn), hl
		if (!isgbz80) {
			add(	"ld (%m), hl",	B(0x22, '%m', '%m'), T(16));		
			add(	"shld %m",		B(0x22, '%m', '%m'), T(16));
			add_ix(	"ld (%m), hl",	B(0x22, '%m', '%m'), T(16)+4);
		}
		
		# ld (nn), dd
		if (!isintel && !isgbz80) {
			for my $r (qw( bc de sp )) {
				add(	"ld (%m), $r",	B(0xed, 0x43+RP($r)*16, '%m', '%m'), T(20));
			}
		}
		
		# ld sp, hl
		add(	"ld sp, hl",	B(0xf9), T(is8080 ? 5 : isgbz80 ? 8 : 6));
		add(	"sphl",			B(0xf9), T(is8080 ? 5 : isgbz80 ? 8 : 6));
		add_ix(	"ld sp, hl",	B(0xf9), T(is8080 ? 5 : isgbz80 ? 8 : 6)+4);
		
		# push qq
		for my $r (qw( bc de hl af )) {
			my $r1 = ($r eq 'af') ? 'psw' : substr($r, 0, 1);
			add(	"push $r",	B(0xc5+RP($r)*16), T(is8085 ? 12 : isgbz80 ? 16 : 11));
			add(	"push $r1",	B(0xc5+RP($r)*16), T(is8085 ? 12 : isgbz80 ? 16 : 11));
			add_ix(	"push $r",	B(0xc5+RP($r)*16), T(is8085 ? 12 : isgbz80 ? 16 : 11)+4);
		}
		
		# pop qq
		for my $r (qw( bc de hl af )) {
			my $r1 = ($r eq 'af') ? 'psw' : substr($r, 0, 1);
			add(	"pop $r",	B(0xc1+RP($r)*16), T(isgbz80 ? 12 : 10));
			add(	"pop $r1",	B(0xc1+RP($r)*16), T(isgbz80 ? 12 : 10));
			add_ix(	"pop $r",	B(0xc1+RP($r)*16), T(isgbz80 ? 12 : 10)+4);
		}
		
		# ld (de), hl
		if (is8085) {
			add("shlx",			B(0xd9), T(10));
			add("shlde",		B(0xd9), T(10));
			add("ld (de), hl",	B(0xd9), T(10));
		}
		
		# ld hl, (de)
		if (is8085) {
			add("lhlx",			B(0xed), T(10));
			add("lhlde",		B(0xed), T(10));
			add("ld hl, (de)",	B(0xed), T(10));
		}

		# ld (nn), sp
		if (isgbz80) {
			add("ld (%m), sp", 	B(0x08, '%m', '%m'), T(20));
		}

        # ld ss,ss
        add_compound("ld bc, de"        => "ld b, d", "ld c, e");
        add_compound("ld bc, hl"        => "ld b, h", "ld c, l");
        
        if (isz80||isz80n) {
            add_compound("ld bc, ix"    => "ld b, ixh", "ld c, ixl");
            add_compound("ld bc, iy"    => "ld b, iyh", "ld c, iyl");
        }
        elsif (iszilog||israbbit) {
            add_compound("ld bc, ix"    => "push ix", "pop bc");
            add_compound("ld bc, iy"    => "push iy", "pop bc");
        }
        
        add_compound("ld de, bc"        => "ld d, b", "ld e, c");
        
        if (is8085) {
			# Add 00bb immediate to HL, result to DE (undocumented i8085)
			add("ldhi %n",		B(0x28, '%n'), T(10));
			add("adi hl, %n",	B(0x28, '%n'), T(10));
			add("ld de, hl+%n",	B(0x28, '%n'), T(10));
		}
        else {
            add_compound("ld de, hl"    => "ld d, h", "ld e, l");
        }

        if (isz80||isz80n) {
            add_compound("ld de, ix"    => "ld d, ixh", "ld e, ixl");
            add_compound("ld de, iy"    => "ld d, iyh", "ld e, iyl");
        }
        elsif (iszilog||israbbit) {
            add_compound("ld de, ix"    => "push ix", "pop de");
            add_compound("ld de, iy"    => "push iy", "pop de");
        }

        add_compound("ld hl, bc"        => "ld h, b", "ld l, c");
        add_compound("ld hl, de"        => "ld h, d", "ld l, e");

        if (iszilog||israbbit) {
            add_compound("ld hl, ix"    => "push ix", "pop hl");
            add_compound("ld hl, iy"    => "push iy", "pop hl");
        }
        
        if (isz80||isz80n) {
            add_compound("ld ix, bc"    => "ld ixh, b", "ld ixl, c");
            add_compound("ld iy, bc"    => "ld iyh, b", "ld iyl, c");
        }
        elsif (iszilog||israbbit) {
            add_compound("ld ix, bc"    => "push bc", "pop ix");
            add_compound("ld iy, bc"    => "push bc", "pop iy");
        }
        
        if (isz80||isz80n) {
            add_compound("ld ix, de"    => "ld ixh, d", "ld ixl, e");
            add_compound("ld iy, de"    => "ld iyh, d", "ld iyl, e");
        }
        elsif (iszilog||israbbit) {
            add_compound("ld ix, de"    => "push de", "pop ix");
            add_compound("ld iy, de"    => "push de", "pop iy");
        }

        if (iszilog||israbbit) {
            add_compound("ld ix, hl"    => "push hl", "pop ix");
            add_compound("ld iy, hl"    => "push hl", "pop iy");
            add_compound("ld ix, iy"    => "push iy", "pop ix");
            add_compound("ld iy, ix"    => "push ix", "pop iy");
        }
        
        # Add unsigned immediate byte to SP, result to DE (undocumented i8085)
		if (is8085) {
			add("ldsi %n",		B(0x38, '%n'), T(10));
			add("adi sp, %n",	B(0x38, '%n'), T(10));

			add("ld de, sp+%n",	B(0x38, '%n'), T(10));
			add("ld de, sp",	B(0x38, 0),    T(10));
        }
        else {
            add_compound("ld de, sp+%n" =>  "ex de, hl",
                                            "ld hl, %n",
                                            "add hl, sp",
                                            "ex de, hl");
            add_compound("ld de, sp" =>     "ex de, hl",
                                            "ld hl, 0",
                                            "add hl, sp",
                                            "ex de, hl");
        }

        # Add signed immediate byte to SP, result to HL (gbz80)
		if (isgbz80) {
			add("ldhl sp, %s", 	B(0xf8, '%s'), T(12));

			add("ld hl, sp+%s", B(0xf8, '%s'), T(12));
			add("ld hl, sp",    B(0xf8, 0),    T(12));
		}
        else {
            add_compound("ld hl, sp+%s" =>  "ld hl, %s",
                                            "add hl, sp");
            add_compound("ld hl, sp" =>     "ld hl, 0",
                                            "add hl, sp");
        }

		#----------------------------------------------------------------------
		# Exchange group
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
			add(	"ex de, hl",	B(0xeb), T(4));
			add(	"xchg",			B(0xeb), T(4));
		}

		# ex af, af'
		if (!isintel && !isgbz80) {
			add(	"ex af, af'",	B(0x08), T(4));
			add(	"ex af, af",	B(0x08), T(4));
		}

		# ex (sp), hl / ix / iy
		if (isintel || iszilog) {
			add(	"ex (sp), hl", 	B(0xe3), T(is8080 ? 18 : is8085 ? 16 : 19));
			add(	"xthl",			B(0xe3), T(is8080 ? 18 : is8085 ? 16 : 19));
			add_ix(	"ex (sp), hl", 	B(0xe3), T(is8080 ? 18 : is8085 ? 16 : 19)+4);
		}
		elsif (israbbit) {
			#add(	"ex (sp), hl", 			0xed, 0x54);
			#add(	"ex (sp), hl'", 		$V{altd}, 0xed, 0x54);
			#add(	"altd ex (sp), hl", 	$V{altd}, 0xed, 0x54);
		}
		else {
			add(	"ex (sp), hl",	B(0xcd, '@__z80asm__ex_sp_hl'), T(148));
		}

		# exx
		if (!isintel && !isgbz80) {
			add(	"exx",			B(0xd9), T(4));
		}
		
		#----------------------------------------------------------------------
		# Block Transfer
		#----------------------------------------------------------------------

		# ticks for BC=1 and BC=2
		if (isintel || isgbz80) {
			add("ldi", 			B(0xcd, '@__z80asm__ldi' ), 
								is8080 ? T(181,188) : is8085 ? T(180,184) : isgbz80 ? T(80)      : die);
			add("ldir", 		B(0xcd, '@__z80asm__ldir'), 
								is8080 ? T( 96,144) : is8085 ? T( 97,147) : isgbz80 ? T(96,144)  : die);
			add("ldd", 			B(0xcd, '@__z80asm__ldd' ), 
								is8080 ? T(181,188) : is8085 ? T(180,184) : isgbz80 ? T(80)      : die);
			add("lddr", 		B(0xcd, '@__z80asm__lddr'), 
								is8080 ? T( 96,144) : is8085 ? T( 97,147) : isgbz80 ? T(100,152) : die);
		} 
		else {
			add("ldi", 			B(0xed, 0xa0), (isz80||isz80n) ? T(16)    : die);
			add("ldir", 		B(0xed, 0xb0), (isz80||isz80n) ? T(16,47) : die);
			add("ldd", 			B(0xed, 0xa8), (isz80||isz80n) ? T(16)    : die);
			add("lddr", 		B(0xed, 0xb8), (isz80||isz80n) ? T(16,47) : die);
		}
		
		#----------------------------------------------------------------------
		# Search
		#----------------------------------------------------------------------

		# ticks for HL=0x1000, A=0xff, BC=1 and BC=2
		if (isintel || isgbz80) {
			add("cpi", 			B(0xcd, '@__z80asm__cpi' ), 
								is8080 ? T(164,191) : is8085 ? T(156,181) : isgbz80 ? T(408,424) : die);
			add("cpir", 		B(0xcd, '@__z80asm__cpir'), 
								is8080 ? T(195,353) : is8085 ? T(180,328) : isgbz80 ? T(448,856) : die);
			add("cpd", 			B(0xcd, '@__z80asm__cpd' ), 
								is8080 ? T(164,191) : is8085 ? T(156,181) : isgbz80 ? T(408,424) : die);
			add("cpdr", 		B(0xcd, '@__z80asm__cpdr'), 
								is8080 ? T(195,353) : is8085 ? T(180,328) : isgbz80 ? T(448,856) : die);
		}
		else {
			add("cpi", 			B(0xed, 0xa1), (isz80||isz80n) ? T(16)    : die);
			add("cpir", 		B(0xed, 0xb1), (isz80||isz80n) ? T(16,37) : die);
			add("cpd", 			B(0xed, 0xa9), (isz80||isz80n) ? T(16)    : die);
			add("cpdr", 		B(0xed, 0xb9), (isz80||isz80n) ? T(16,37) : die);
		}
		
		#----------------------------------------------------------------------
		# 8-bit arithmetic
		#----------------------------------------------------------------------
		
		# add... a, r / add... r
		for my $op (qw( add adc sub sbc and xor or  cp  
		                                            cmp )) {
			for my $r (qw( b c d e h l a )) {
				add("$op a, $r",	B(0x80+OP($op)*8+R($r)), T(4));
				add("$op    $r",	B(0x80+OP($op)*8+R($r)), T(4));
			}
		}
		for my $op (qw(             sbb ana xra ora     )) {	
			for my $r (qw( b c d e h l a )) {
				add("$op $r", 		B(0x80+OP($op)*8+R($r)), T(4));
			}
		}
		
		# add... a, (hl) / add... m
		for my $op (qw( add adc sub sbc and xor or  cp  
		                                            cmp )) {
			add(		"$op a, (hl)", 	B(0x80+OP($op)*8+6), isgbz80 ? T(8) : T(7));
			add(		"$op    (hl)", 	B(0x80+OP($op)*8+6), isgbz80 ? T(8) : T(7));
			add_ix_d(	"$op a, (hl)",	B(0x80+OP($op)*8+6), isgbz80 ? T(8) : T(7)+12);
			add_ix_d(	"$op    (hl)",	B(0x80+OP($op)*8+6), isgbz80 ? T(8) : T(7)+12);
		}
		for my $op (qw( add adc sub sbb ana xra ora cmp )) {	
			add("$op m", 			B(0x80+OP($op)*8+6), isgbz80 ? T(8) : T(7));
		}
		
		# add... a, n / add... n
		for my $op (qw( add adc sub sbc and xor or  cp  
		                                            cmp )) {
			add("$op a, %n", 		B(0xc6+OP($op)*8, '%n'), isgbz80 ? T(8) : T(7));
			add("$op    %n",		B(0xc6+OP($op)*8, '%n'), isgbz80 ? T(8) : T(7));
		}
		for my $op (qw( adi aci sui sbi ani xri ori cpi )) {
			add("$op %n", 			B(0xc6+OP($op)*8, '%n'), isgbz80 ? T(8) : T(7));
		}
		
		# inc r
		for my $r (qw( b c d e h l a )) {
			add("inr $r", 	B(0x04+R($r)*8), is8080 ? T(5) : T(4));
			add("inc $r", 	B(0x04+R($r)*8), is8080 ? T(5) : T(4));
		}
		
		# dec r
		for my $r (qw( b c d e h l a )) {
			add("dcr $r", 	B(0x05+R($r)*8), is8080 ? T(5) : T(4));
			add("dec $r", 	B(0x05+R($r)*8), is8080 ? T(5) : T(4));
		}
		
		# inc (hl) / (ix+d) / (iy+d)
		add(		"inr m", 		B(0x04+6*8), isintel ? T(10) : isgbz80 ? T(12) : T(11));
		add(		"inc (hl)", 	B(0x04+6*8), isintel ? T(10) : isgbz80 ? T(12) : T(11));
		add_ix_d(	"inc (hl)", 	B(0x04+6*8), isintel ? T(10) : isgbz80 ? T(12) : T(11)+12);
		
		# dec (hl) / (ix+d) / (iy+d)
		add(		"dcr m", 		B(0x05+6*8), isintel ? T(10) : isgbz80 ? T(12) : T(11));
		add(		"dec (hl)", 	B(0x05+6*8), isintel ? T(10) : isgbz80 ? T(12) : T(11));
		add_ix_d(	"dec (hl)", 	B(0x05+6*8), isintel ? T(10) : isgbz80 ? T(12) : T(11)+12);
		
		#----------------------------------------------------------------------
		# General Purpose Arithmetic
		#----------------------------------------------------------------------

		# daa
		if (isintel || iszilog || isgbz80) {
			add("daa",		B(0x27), T(4));
		}
		else {
			add("daa",		B(0xcd, '@__z80asm__daa'), T(499));
		}
		
		# cpl
		add("cpl", 		B(0x2f), T(4));
		add("cma",		B(0x2f), T(4));
		add("cpl a", 	B(0x2f), T(4));
		
		# neg
		if (iszilog || israbbit) {
			add("neg", 		B(0xed, 0x44), T(8));
			add("neg a", 	B(0xed, 0x44), T(8));
		}
		else {
			add_compound("neg"		=> 	"cpl",
										"inc a");
			add_compound("neg a"	=> 	"cpl",
										"inc a");
		}

		# ccf
		add("ccf",			B(0x3f), T(4));
		add("cmc",			B(0x3f), T(4));
		
		# scf
		add("scf",			B(0x37), T(4));
		add("stc",			B(0x37), T(4));

		#----------------------------------------------------------------------
		# 16-bit arithmetic
		#----------------------------------------------------------------------
		
		# add hl/ix/iy, ss
		for my $r (qw( bc de hl sp )) {
			my $r1 = substr($r, 0, 1);
            add(    "dad $r",		B(0x09+RP($r)*16), isintel ? T(10) : isgbz80 ? T(8) : T(11));
            add(    "dad $r1",		B(0x09+RP($r)*16), isintel ? T(10) : isgbz80 ? T(8) : T(11)) if $r ne 'sp';
			add(	"add hl, $r",	B(0x09+RP($r)*16), isintel ? T(10) : isgbz80 ? T(8) : T(11));
			add_ix(	"add hl, $r",	B(0x09+RP($r)*16), isintel ? T(10) : isgbz80 ? T(8) : T(11)+4);
		}

		# adc hl, ss
		for my $r (qw( bc de hl sp )) {
			if (isintel||isgbz80) {
				add("adc hl, $r", B(0xcd, '@__z80asm__adc_hl_'.$r),
					($r eq 'bc' || $r eq 'de') ? (is8080 ? T(47,52) : is8085 ? T(48,51) : T(36,44)) :
					($r eq 'hl') 			   ? (is8080 ? T(110)   : is8085 ? T(111)   : T(84))    :
					 			   				 (is8080 ? T(57,62) : is8085 ? T(60,63) : T(52,60)));
		
			}
			else {
				add("adc hl, $r",	B(0xed, 0x4a+RP($r)*16), T(15));
			}
		}
		
		# sbc hl, ss
		for my $r (qw( bc de hl sp )) {
			if (isintel||isgbz80) {
				add("sbc hl, $r", B(0xcd, '@__z80asm__sbc_hl_'.$r),
					($r eq 'bc') ? (is8080 ? T(86)    : is8085 ? T(82)    : T(80))    :
					($r eq 'de') ? (is8080 ? T(86)    : is8085 ? T(82)    : T(80))    :
					($r eq 'hl') ? (is8080 ? T(38,47) : is8085 ? T(40,50) : T(32,48)) :
								   (is8080 ? T(156)   : is8085 ? T(152)   : T(232)));
			}
			else {
				add("sbc hl, $r",	B(0xed, 0x42+RP($r)*16), T(15));
			}
		}
        
        # sub hl, ss
        for my $r (qw( bc de hl sp )) {
            if (is8085 && $r eq 'bc') {
                # 8085 undocumented opcode: double subtract
                add("dsub",			B(0x08), T(10));
                add("sub hl, bc",	B(0x08), T(10));
            }
            else {
				add("sub hl, $r", B(0xcd, '@__z80asm__sub_hl_'.$r),
					($r eq 'bc') ? (is8080 ? T(86)  : is8085 ? T(10)  : isgbz80 ? T(80)  : T(80)) :
					($r eq 'de') ? (is8080 ? T(86)  : is8085 ? T(82)  : isgbz80 ? T(80)  : T(80)) :
					($r eq 'hl') ? (is8080 ? T(86)  : is8085 ? T(82)  : isgbz80 ? T(80)  : T(80)) :
								   (is8080 ? T(156) : is8085 ? T(152) : isgbz80 ? T(232) : T(151)));
            }
        }
        if (!is8085) {
            add_compound("dsub" => "sub hl, bc");
        }

        # add sp, %n
		if (isgbz80) {
			add("add sp, %s", 	B(0xe8, '%s'), T(16));
        }
        elsif (israbbit) {
            add("add sp, %s", 	B(0x27, '%s'), T(16));
        }

		# inc ss
		for my $r (qw( bc de hl sp )) {
			my $r1 = substr($r, 0, 1);
			add(	"inc $r", 	B(0x03+RP($r)*16), is8080 ? T(5) : is8085 ? T(6) : isgbz80 ? T(8) : T(6));
			add_ix(	"inc $r", 	B(0x03+RP($r)*16), is8080 ? T(5) : is8085 ? T(6) : isgbz80 ? T(8) : T(6)+4);
			
			add(	"inx $r", 	B(0x03+RP($r)*16), is8080 ? T(5) : is8085 ? T(6) : isgbz80 ? T(8) : T(6));
			add(	"inx $r1", 	B(0x03+RP($r)*16), is8080 ? T(5) : is8085 ? T(6) : isgbz80 ? T(8) : T(6)) if $r ne 'sp';
		}
		
		# dec ss
		for my $r (qw( bc de hl sp )) {
			my $r1 = substr($r, 0, 1);
			add(	"dec $r", 	B(0x0b+RP($r)*16), is8080 ? T(5) : is8085 ? T(6) : isgbz80 ? T(8) : T(6));
			add_ix(	"dec $r", 	B(0x0b+RP($r)*16), is8080 ? T(5) : is8085 ? T(6) : isgbz80 ? T(8) : T(6)+4);

			add(	"dcx $r", 	B(0x0b+RP($r)*16), is8080 ? T(5) : is8085 ? T(6) : isgbz80 ? T(8) : T(6));
			add(	"dcx $r1", 	B(0x0b+RP($r)*16), is8080 ? T(5) : is8085 ? T(6) : isgbz80 ? T(8) : T(6)) if $r ne 'sp';
		}
		
		#----------------------------------------------------------------------
		# Rotate and Shift Group
		#----------------------------------------------------------------------
		
		# rlca/rrca/rla/rra
		for my $op (qw( rlca rrca rla rra 
					 rlc  rrc  ral rar )) {
			add($op,		B(0x07+OP($op)*8), T(4));
		}		
		
		# rlc/rrc/rl/rr/sla/sra/sll/sli/srl
		if (!isintel) {
			my @ops;
			if    (iszilog) { @ops = qw( rlc rrc rl rr sla sra sll  sli srl ); }
			elsif (isgbz80) { @ops = qw( rlc rrc rl rr sla sra swap     srl ); }
			else  			{ @ops = qw( rlc rrc rl rr sla sra          srl ); }
			for my $op (@ops) {
				for my $r (qw( b c d e h l a )) {
					add("$op $r", 	B(0xcb, OP($op)*8+R($r)), T(8));
				}

				add(		"$op (hl)", 	B(0xcb, OP($op)*8+6), isgbz80 ? T(16) : T(15));
				add_ix_d(	"$op (hl)", 	B(0xcb, OP($op)*8+6), isgbz80 ? T(16) : T(15)+8);
			}
		}
		
		# rld/rrd
		if (iszilog) {
			add("rrd", B(0xed, 0x67), T(18));
			add("rld", B(0xed, 0x6f), T(18));
		}
		else {
			add("rrd",		B(0xcd, '@__z80asm__rrd'), is8080 ? T(229,260) : is8085 ? T(224,253) : isgbz80 ? T(136,160) : T(18));
			
			add("rld",		B(0xcd, '@__z80asm__rld'), is8080 ? T(201,232) : is8085 ? T(197,226) : isgbz80 ? T(164,188) : T(18));
		}

		#----------------------------------------------------------------------
		# 16-bit Rotate and Shift Group
		#----------------------------------------------------------------------
		
        # sra bc/de
        if (isintel) {
            add("sra bc", B(0xcd, '@__z80asm__sra_bc'), T(is8080?99:is8085?96:israbbit?8:isz180?14:16));
            add("sra de", B(0xcd, '@__z80asm__sra_de'), T(is8080?99:is8085?96:israbbit?8:isz180?14:16));
        } 
        else {
            add_compound("sra bc" => "sra b", "rr c");
            add_compound("sra de" => "sra d", "rr e");
        }

        # sra hl (undocumented i8085)
		if (is8085) {
			add("sra hl",	B(0x10), T(is8080?99:is8085?7:israbbit?8:isz180?14:16));
		}
        elsif (isintel) {
            add("sra hl", B(0xcd, '@__z80asm__sra_hl'), T(is8080?99:is8085?96:israbbit?8:isz180?14:16));
        }
        else {
            add_compound("sra hl" => "sra h", "rr l");
        }
        add_compound("arhl" => "sra hl");
        add_compound("rrhl" => "sra hl");
        
        # rl bc
        if (isintel) {
            add("rl bc",    B(0xcd, '@__z80asm__rl_bc'), T(is8080?90:is8085?88:israbbit?8:isz180?14:16));
        }
        else {
            add_compound("rl bc" => "rl c", "rl b");
        }
        
        # rl de (undocumented i8085)
		if (is8085) {
			add("rl de",	B(0x18), T(10));
        }
        elsif (isintel) {
            add("rl de",    B(0xcd, '@__z80asm__rl_de'), T(is8080?90:is8085?10:israbbit?2:isz180?14:16));
        }
        else {
            add_compound("rl de" => "rl e", "rl d");
        }
        add_compound("rdel" => "rl de");
        add_compound("rlde" => "rl de");

        # rl hl
        if (isintel) {
            add("rl hl",    B(0xcd, '@__z80asm__rl_hl'), T(is8080?90:is8085?88:israbbit?8:isz180?14:16));
        }
        else {
            add_compound("rl hl" => "rl l", "rl h");
        }
        
        # rr bc
        if (isintel) {
            add("rr bc",    B(0xcd, '@__z80asm__rr_bc'), T(is8080?90:is8085?88:israbbit?8:isz180?14:16));
        }
        else {
            add_compound("rr bc" => "rr b", "rr c");
        }

        # rr de
        if (isintel) {
            add("rr de",    B(0xcd, '@__z80asm__rr_de'), T(is8080?90:is8085?88:israbbit?8:isz180?14:16));
        }
        else {
            add_compound("rr de" => "rr d", "rr e");
        }

        # rr hl
        if (isintel) {
            add("rr hl",    B(0xcd, '@__z80asm__rr_hl'), T(is8080?90:is8085?88:israbbit?8:isz180?14:16));
        }
        else {
            add_compound("rr hl" => "rr h", "rr l");
        }

		#----------------------------------------------------------------------
		# Bit Set, Reset and Test Group
		#----------------------------------------------------------------------
		
		# bit/res/set b, r
		if (!isintel) {
			for my $op (qw( bit res set )) {
				for my $r (qw( b c d e h l a )) {
					add("$op %c, $r",	B(0xcb, (OP($op)*0x40+R($r))."+%c*8"), T(8));
				}
			}
		}

		# bit/res/set b, (hl) / (ix+d) / (iy+d)
		if (!isintel) {
			for my $op (qw( bit res set )) {
				add("$op %c, (hl)",	B(0xcb, (OP($op)*0x40+6)."+%c*8"),
					($op eq 'bit')	? T(isgbz80 ? 16 : 12) :
									  T(isgbz80 ? 16 : 15));
			}
		}
		
		#----------------------------------------------------------------------
		# Call and Return Group
		#----------------------------------------------------------------------

		# call nn
		add("call %m",		B(0xcd, '%m', '%m'), is8080 ? T(17) : is8085 ? T(18) : isgbz80 ? T(12) : T(17));

		# call f, nn
		for my $f (qw( nz z nc c po pe nv v p m )) {
			next if isgbz80 && F($f) >= 4;

			add("call $f, %m",	B(0xc4+F($f)*8, '%m', '%m'), is8080 ? T(11,17) : is8085 ? T(9,18) : isgbz80 ? T(12) : T(10,17));			
			add("c$f %m",		B(0xc4+F($f)*8, '%m', '%m'), is8080 ? T(11,17) : is8085 ? T(9,18) : isgbz80 ? T(12) : T(10,17)) if $f ne 'p';	# Intel's cp is ambiguous
		}

		# ret
		add("ret",		B(0xc9), isgbz80 ? T(8) : T(10));
		
		# ret f
		for my $f (qw( nz z nc c po pe nv v p m )) {
			next if isgbz80 && F($f) >= 4;
		
			add("ret $f",	B(0xc0+F($f)*8), is8080 ? T(5,11) : is8085 ? T(6,12) : isgbz80 ? T(8) : T(5,11));
			add("r$f",		B(0xc0+F($f)*8), is8080 ? T(5,11) : is8085 ? T(6,12) : isgbz80 ? T(8) : T(5,11));
		}

		# reti
		if (isgbz80) {
			add("reti",		B(0xd9), T(8));
		}
		elsif (iszilog) {
			add("reti",		B(0xed, 0x4d), T(14));
		}
		
		# retn
		if (iszilog) {
			add("retn",		B(0xed, 0x45), T(14));
		}
		
		# rst
		add("rst %c", 		B(0xc7."+%c"), is8085 ? T(12) : isgbz80 ? T(32) : T(11));

		if (is8085) {
			# Restart 8 (0040) if V flag is set
			add("rstv",		B(0xcb), T(6,12));
			add("ovrst8",	B(0xcb), T(6,12));
		}

		#----------------------------------------------------------------------
		# Jump Group
		#----------------------------------------------------------------------

		# jp/jmp nn
		add("jmp %m",		B(0xc3, '%m', '%m'), isintel ? T(10) : isgbz80 ? T(12) : T(10));
		add("jp  %m",		B(0xc3, '%m', '%m'), isintel ? T(10) : isgbz80 ? T(12) : T(10)); 	# do not define JP as Jump Positive in Intel

		# jp f, nn
		for my $f (qw( nz z nc c po pe nv v p m )) {
			next if isgbz80 && F($f) >= 4;		# gbz80 only has carry and zero flags
			
			add("jp $f, %m",	B(0xc2+F($f)*8, '%m', '%m'), is8080 ? T(10) : is8085 ? T(7,10) : isgbz80 ? T(12) : T(10));
			add("j$f %m",		B(0xc2+F($f)*8, '%m', '%m'), is8080 ? T(10) : is8085 ? T(7,10) : isgbz80 ? T(12) : T(10)) if $f ne 'p';	# Intel's jp is ambiguous
		}
		
		# jr nn
		if (isintel) {
			add_compound("jr %m"			=> "jp %m");
		}
		else {
			add("jr %j",					B(0x18, '%j'), isgbz80 ? T(8) : T(12));
		}
		
		# jr f, nn
		for my $f (qw( nz z nc c )) {
			if (isintel) {
				add_compound("jr $f, %m"	=> "jp $f, %m");
			}
			else {
				add("jr $f, %j",			B(0x20+F($f)*8, '%j'), isgbz80 ? T(8) : T(7,12));
			}
		}
		
		# jp (hl) / jp (ix) / jp (iy)
		add(	"pchl",				B(0xe9), is8080 ? T(5) : is8085 ? T(6) : T(4));
		add(	"jp (hl)",			B(0xe9), is8080 ? T(5) : is8085 ? T(6) : T(4));
		add_ix(	"jp (hl)",			B(0xe9), is8080 ? T(5) : is8085 ? T(6) : T(4)+4);
	
		# jp (bc) / jp (de)
		for my $r (qw( bc de )) {
			add_compound("jp ($r)"	=> "push $r", "ret");
		}
		
		# djnz nn
		if (isintel) {
			add_compound("djnz %m"		=> "dec b", "jp nz, %m");
			add_compound("djnz b, %m"	=> "dec b", "jp nz, %m");
		}
		elsif (isgbz80) {
			add_compound("djnz %j"		=> "dec b", "jr nz, %j");
			add_compound("djnz b, %j"	=> "dec b", "jr nz, %j");
		}
		else {
			add("djnz %j",			B(0x10, '%j'), T(8,13));
			add("djnz b, %j",		B(0x10, '%j'), T(8,13));
		}
        
		if (is8085) {
			# Jump on flag X5/K is reset
			add("jnx5 %m",		    B(0xdd, '%m', '%m'), T(7,10));
			add("jnk %m",		    B(0xdd, '%m', '%m'), T(7,10));

			# Jump on flag X5/K is set
			add("jx5 %m",		    B(0xfd, '%m', '%m'), T(7,10));
			add("jk %m",		    B(0xfd, '%m', '%m'), T(7,10));
		}

		#----------------------------------------------------------------------
		# Input and Output Group
		#----------------------------------------------------------------------

		# in a, (n)
		if (isintel||iszilog) {
			add("in %n",		B(0xdb, '%n'), isintel ? T(10) : T(11));
			add("in a, (%n)",	B(0xdb, '%n'), isintel ? T(10) : T(11));
		}
		
		# in (c)
		if (iszilog) {
			add("in (c)",		B(0xed, 0x40+R('f')*8), T(12));
		}
		
		# in r, (c)
		if (iszilog) {
			for my $r (qw( b c d e h l f a )) {
				add("in $r, (c)", 	B(0xed, 0x40+R($r)*8), T(12));
			}
		}

        # gbz80 input/output
		if (isgbz80) {
			add("ldh (%n), a", 	B(0xe0, '%n'), T(12));
			add("ldh a, (%n)", 	B(0xf0, '%n'), T(12));
			
			# TODO: accept ld ($FF00+n), a; ld a, ($FF00+n)
			
			add("ld  (c), a", 	B(0xe2), T(8));
			add("ldh (c), a", 	B(0xe2), T(8));

			add("ld  a, (c)", 	B(0xf2), T(8));
			add("ldh a, (c)", 	B(0xf2), T(8));
		}
		
		# ini/inir/ind/indr
		if (iszilog) {
			add("ini", 			B(0xed, 0xa2), T(16));
			add("inir",			B(0xed, 0xb2), T(16,44));	# b=1, b=2
			add("ind", 			B(0xed, 0xaa), T(16));
			add("indr", 		B(0xed, 0xba), T(16,44));	# b=1, b=2
		}		
		
		# out (n), a
		if (isintel||iszilog) {
			add("out %n",		B(0xd3, '%n'), isintel ? T(10) : T(11));
			add("out (%n), a",	B(0xd3, '%n'), isintel ? T(10) : T(11));
		}
		
		# out (c), r
		if (iszilog) {
			for my $r (qw( b c d e h l a )) {
				add("out (c), $r", 	B(0xed, 0x41+R($r)*8), T(12));
			}
			add("out (c), %c", 	B(0xed, 0x41+6*8), T(12));
		}
		
		# outi/otir/outd/otdr
		if (iszilog) {
			add("outi", 		B(0xed, 0xa3), T(16));
			add("otir",			B(0xed, 0xb3), T(16,44));	# b=1, b=2
			add("outd", 		B(0xed, 0xab), T(16));
			add("otdr", 		B(0xed, 0xbb), T(16,44));	# b=1, b=2
		}		
		
		#----------------------------------------------------------------------
		# General Purpose CPU Control
		#----------------------------------------------------------------------

		# nop
		add("nop", 			B(0x00), T(4));
		
		# halt
		if (!israbbit) {
			add("hlt",		B(0x76), is8080 ? T(7) : is8085 ? T(5) : T(4));
			add("halt",		B(0x76), is8080 ? T(7) : is8085 ? T(5) : T(4));
		}

        # stop
		if (isgbz80) {
			add("stop", 	B(0x10, 0x00), T(4));
		}
		
		# ei / di
		if (!israbbit) {
			add("ei",		B(0xfb), T(4));
			add("di",		B(0xf3), T(4));
		}

		# im n
		if (iszilog) {
			add("im %c", 	B(0xed, "%c==0?0x46:%c==1?0x56:0x5e"), T(8));
		}

        # interrupt mask
		if (is8085) {
			add("rim", 		B(0x20), T(4));
			add("sim", 		B(0x30), T(4));
        }
        
next unless isintel || isgbz80;
next;

		#----------------------------------------------------------------------
		# compound opcodes
		#----------------------------------------------------------------------
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
    
    do_compound();
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

sub _remove_prog {
	my($asm) = @_;
	$asm =~ s/\s+/ /g;

	delete $Opcodes{$asm}{$cpu};
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
    our @compound_queue;

    my $prog = try_add_compound($asm, @prog);
    return $prog if $prog; # true

    push @compound_queue, [$cpu, $ixiy, $asm, @prog];
    return; # false
}

sub try_add_compound {
    my($asm, @prog) = @_;
    my $prog;
    ### <where>: $asm
    eval {
        $prog = _add_prog($asm);
        for my $asm1 (@prog) {
            ### <where>: $asm1
            if ($asm1 =~ /^ld (bc|de|hl), %n$/) {
                $asm1 =~ s/%n/%m/;
                my $prog1 = $Opcodes{$asm1}{$cpu} or die;
                $prog1 = $prog1->clone;
                $prog1->word_to_unsigned_byte_arg();
                $prog->add($prog1);
            }
            elsif ($asm1 =~ /^ld (bc|de|hl), %s$/) {
                $asm1 =~ s/%s/%m/;
                my $prog1 = $Opcodes{$asm1}{$cpu} or die;
                $prog1 = $prog1->clone;
                $prog1->word_to_signed_byte_arg();
                $prog->add($prog1);
            }
            elsif ($asm1 =~ /^ld (bc|de|hl), (\d+)$/) {
                my $m = $2;
                $asm1 =~ s/$m/%m/; 
                my $prog1 = $Opcodes{$asm1}{$cpu} or die;
                $prog1 = $prog1->clone;
                $prog1->instanciate(m => $m);
                $prog->add($prog1);
            }
            else {
                my $prog1 = $Opcodes{$asm1}{$cpu} or die;
                $prog->add($prog1->clone);
            }
        }
    };
    if ($@) {   # failed
        _remove_prog($asm);
        return; # false
    }
    else {
        return $prog; # true
    }
}

sub do_compound {
    our @compound_queue;
    my %tried;
    while (@compound_queue) {
        my($cpu_, $ixiy_, $asm, @prog) = @{shift @compound_queue};
        ($cpu, $ixiy) = ($cpu_, $ixiy_);
        #dump $cpu_, $ixiy_, $asm, \@prog;
        
        my $prog = try_add_compound($asm, @prog);
        if (!$prog) {
            $tried{$asm}++;
            die "not found: $asm: ",join(" \\ ",@prog),"\n" if $tried{$asm} > 2;
            push @compound_queue, [$cpu_, $ixiy_, $asm, @prog];
        }
    }
}

#------------------------------------------------------------------------------
sub write_opcodes {
	# build list
	my @rows;
	for my $asm (sort keys %Opcodes) {
		for $cpu (@CPUS) {
			if (exists $Opcodes{$asm}{$cpu}) {
				my $prog = $Opcodes{$asm}{$cpu};
				write_opcodes_line(\@rows, $asm, $cpu, $prog);
			}
			else {
				write_opcodes_line(\@rows, $asm, $cpu, undef);
			}
		}
	}
	
	# by asm
	my @rows_asm = sort {$a->[0] cmp $b->[0]} @rows;
	insert_separator_lines(\@rows_asm);
	my $tb_asm = Text::Table->new("; Assembly", \$table_separator, "CPU", \$table_separator, 
								  "Bytes", \$table_separator, "T-States");
	write_table($tb_asm, \@rows_asm, $opcodes_asm_file);
	
	# by opcodes
	my @rows_bytes = sort {$a->[0] cmp $b->[0]} 
					grep {$_->[0] =~ /^\w+/} 
					map {[ @{$_}[2,1,0,3] ]} @rows;
	insert_separator_lines(\@rows_bytes);
	my $tb_bytes = Text::Table->new("; Bytes", \$table_separator, "CPU", \$table_separator, 
								  "Assembly", \$table_separator, "T-States");
	write_table($tb_bytes, \@rows_bytes, $opcodes_bytes_file);
}

#------------------------------------------------------------------------------
sub insert_separator_lines {
	my($rows) = @_;
	my $i = 0;
	while ($i+1 < @$rows) {
		if ($rows->[$i][0] ne $rows->[$i+1][0]) {
			splice(@$rows, $i+1, 0, [(" ") x 4]);
			$i++;
		}
		$i++;
	}
}

#------------------------------------------------------------------------------
sub write_table {
	my($tb, $rows, $file) = @_;
	
	for (@$rows) {
		$tb->add(@$_);
	}
	
	say "Write ",$file;
	$file->spew_raw($tb->table);
}	

#------------------------------------------------------------------------------
sub write_opcodes_line {
	my($rows, $asm, $cpu, $prog) = @_;
	
	if ($asm =~ /^(bit|res|set) %c/) {
		for my $c (0..7) {
			write_opcodes_line($rows, replace($asm, '%c', $c), $cpu, 
							   defined($prog) ? $prog->clone(c => $c) : undef);
		}
	}
	elsif ($asm =~ /^rst %c/) {
		$::cpu = $cpu;
		for my $c (restarts()) {
			write_opcodes_line($rows, replace($asm, '%c', $c), $cpu, 
							   defined($prog) ? $prog->clone(c => $c) : undef);
			if ($c != 0) {
				write_opcodes_line($rows, replace($asm, '%c', $c/8), $cpu, 
								   defined($prog) ? $prog->clone(c => $c) : undef);
			}
		}
	}
	elsif ($asm =~ /^im %c/) {
		for my $c (0..2) {
			write_opcodes_line($rows, replace($asm, '%c', $c), $cpu, 
							   defined($prog) ? $prog->clone(c => $c) : undef);
		}
	}
	elsif ($asm =~ /^out \(c\), %c/) {
		for my $c (0) {
			write_opcodes_line($rows, replace($asm, '%c', $c), $cpu, 
							   defined($prog) ? $prog->clone(c => $c) : undef);
		}
	}
	else {
		my @row = (format_asm($asm), $cpu, 
				   defined($prog) ? $prog->format_bytes : "   **",
				   defined($prog) ? $prog->ticks->to_string : "   **");			
		push(@$rows, \@row);
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
			"    DO_stmt(0xcd0000 + (expr_value << 8));",
			"  else",
			"    DO_stmt(0xc7 + expr_value);",
			"  break;",
			"case 0x10: case 0x18: case 0x20: case 0x28: case 0x38:",
			"  DO_stmt(0xc7 + expr_value); break;",
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
    
    ### <where> bytes: $bytes
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
	elsif ($bytes =~ s/ %n 0$//) {
		$stmt = "DO_stmt_n_0";
	}
	elsif ($bytes =~ s/ %s 0$//) {
		$stmt = "DO_stmt_s_0";
	}
	elsif ($bytes =~ s/ %j$//) {
		$stmt = "DO_stmt_jr";
	}
	else {
		$stmt = "DO_stmt";
	}
    ### <where> bytes: $bytes

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
            ### <where> expr: $_
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
			my @test = [" ld sp, 0c000h",  $Opcodes{"ld sp, %m"}{$cpu}->clone(m => 0xc000)];
                
			for my $asm (sort keys %Opcodes) {
				my $asm_swap = ($ixiy) ? swap_ix_iy($asm) : $asm;
				my $prog = $Opcodes{$asm_swap}{$cpu};
				if ($prog) {
					my $prog_instance = $prog->clone(
						n => 0x12, s => 0x12, d => 0x12, m => 0x1234);
					my $asm_instance = replace($asm, 
						'%n', 0x12, '%s', 0x12, '%d' => 0x12, '%m', 0x1234);
					my $test_asm = sprintf(" %-31s; %s", $asm_instance, $prog_instance->format_bytes);
					
					if ($asm =~ /^(jp \(bc\)|jp \(de\)|jp \(hl\)|jp \(ix\)|jp \(iy\)|pchl|stop)$/) {
						run_test($ixiy, 0, [$test_asm, $prog_instance]);
					}
					elsif ($asm eq 'jmp %m' ||
					       $asm eq 'call %m' ||
					       $asm eq 'jp %m' ||		# zilog
						   $asm eq 'jr %m') {		# intel
						run_test($ixiy, 0x1234, [$test_asm, $prog_instance]);
					}
					elsif ($asm =~ /^(djnz b, %j|djnz %j)$/) {
						my $target = $prog->size + 2;				# ld b,1:djnz
						$prog_instance = $prog->clone(j => 0);		# jr target -> offset=0
						$asm_instance = replace($asm, '%j', $target);
						$test_asm = sprintf(" %-31s; %s", $asm_instance, $prog_instance->format_bytes);
						run_test($ixiy, $target,
								[" ld b, 1",	$Opcodes{"ld b, %n"}{$cpu}->clone(n => 1)],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /^(djnz b, %m|djnz %m)$/) {
						my $target = $prog->size + 2;				# ld b,1:djnz
						$prog_instance = $prog->clone(m => $target);
						$asm_instance = replace($asm, '%m', $target);
						$test_asm = sprintf(" %-31s; %s", $asm_instance, $prog_instance->format_bytes);
						run_test($ixiy, $target,
								[" ld b, 1",	$Opcodes{"ld b, %n"}{$cpu}->clone(n => 1)],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm eq 'jr %j') {
						$prog_instance = $prog->clone(j => 0);		# jr 2 -> offset=0
						$asm_instance = replace($asm, '%j', 2);
						$test_asm = sprintf(" %-31s; %s", $asm_instance, $prog_instance->format_bytes);
						run_test($ixiy, 2, [$test_asm, $prog_instance]);
					}
					elsif ($asm =~ /(jp|call|jr) (nz|z), %m|(j|c)(nz|z) %m/) {
						$prog_instance = $prog->clone(m => 5);
						$asm_instance = replace($asm, '%m', 5);
						$test_asm = sprintf(" %-31s; %s", $asm_instance, $prog_instance->format_bytes);
						
						# zero reset
						run_test($ixiy, undef, 
								[" xor a",		$Opcodes{"xor a"}{$cpu}->clone()],
								[" inc a",		$Opcodes{"inc a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
						
						# zero set
						run_test($ixiy, undef,
								[" xor a",		$Opcodes{"xor a"}{$cpu}->clone()],
								[" nop",		$Opcodes{"nop"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /jr (nz|z), %j/) {
						$prog_instance = $prog->clone(j => 0);		# jr 4 -> offset=0
						$asm_instance = replace($asm, '%j', 4);
						$test_asm = sprintf(" %-31s; %s", $asm_instance, $prog_instance->format_bytes);
						
						# zero reset
						run_test($ixiy, undef, 
								[" xor a",		$Opcodes{"xor a"}{$cpu}->clone()],
								[" inc a",		$Opcodes{"inc a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
						
						# zero set
						run_test($ixiy, undef,
								[" xor a",		$Opcodes{"xor a"}{$cpu}->clone()],
								[" nop",		$Opcodes{"nop"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /ret (nz|z)|r(nz|z)/) {
						# zero reset
						run_test($ixiy, undef, 
								[" ld hl, 7",	$Opcodes{"ld hl, %m"}{$cpu}->clone(m => 7)],
								[" push hl",	$Opcodes{"push hl"}{$cpu}->clone()],
								[" xor a",		$Opcodes{"xor a"}{$cpu}->clone()],
								[" inc a",		$Opcodes{"inc a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
						
						# zero set
						run_test($ixiy, undef,
								[" ld hl, 7",	$Opcodes{"ld hl, %m"}{$cpu}->clone(m => 7)],
								[" push hl",	$Opcodes{"push hl"}{$cpu}->clone()],
								[" xor a",		$Opcodes{"xor a"}{$cpu}->clone()],
								[" nop",		$Opcodes{"nop"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /(jp|call|jr) (nc|c), %m|(j|c)(nc|c) %m/) {
						$prog_instance = $prog->clone(m => 4);
						$asm_instance = replace($asm, '%m', 4);
						$test_asm = sprintf(" %-31s; %s", $asm_instance, $prog_instance->format_bytes);
						
						# carry reset
						run_test($ixiy, undef, 
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
						
						# carry set
						run_test($ixiy, undef,
								[" scf",		$Opcodes{"scf"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /jr (nc|c), %j/) {
						$prog_instance = $prog->clone(j => 0);		# jr 3 -> offset=0
						$asm_instance = replace($asm, '%j', 3);
						$test_asm = sprintf(" %-31s; %s", $asm_instance, $prog_instance->format_bytes);
						
						# carry reset
						run_test($ixiy, undef, 
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
						
						# carry set
						run_test($ixiy, undef,
								[" scf",		$Opcodes{"scf"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /ret (nc|c)|r(nc|c)/) {
						# carry reset
						run_test($ixiy, undef, 
								[" ld hl, 6",	$Opcodes{"ld hl, %m"}{$cpu}->clone(m => 6)],
								[" push hl",	$Opcodes{"push hl"}{$cpu}->clone()],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
						
						# carry set
						run_test($ixiy, undef,
								[" ld hl, 6",	$Opcodes{"ld hl, %m"}{$cpu}->clone(m => 6)],
								[" push hl",	$Opcodes{"push hl"}{$cpu}->clone()],
								[" scf",		$Opcodes{"scf"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /(jp|call) (po|pe|nv|v), %m|(j|c)(po|pe|nv|v) %m/) {
						$prog_instance = $prog->clone(m => 6);
						$asm_instance = replace($asm, '%m', 6);
						$test_asm = sprintf(" %-31s; %s", $asm_instance, $prog_instance->format_bytes);
						
						# parity odd
						run_test($ixiy, undef, 
								[" ld a, 1",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 1)],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
						
						# parity even
						run_test($ixiy, undef,
								[" ld a, 0",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 0)],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /ret (po|pe|nv|v)|r(po|pe|nv|v)/) {
						# parity odd
						run_test($ixiy, undef, 
								[" ld hl, 8",	$Opcodes{"ld hl, %m"}{$cpu}->clone(m => 8)],
								[" push hl",	$Opcodes{"push hl"}{$cpu}->clone()],
								[" ld a, 1",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 1)],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
						
						# parity even
						run_test($ixiy, undef,
								[" ld hl, 8",	$Opcodes{"ld hl, %m"}{$cpu}->clone(m => 8)],
								[" push hl",	$Opcodes{"push hl"}{$cpu}->clone()],
								[" ld a, 0",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 0)],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /(jp|call) (p|m), %m|(j|c)m %m/) {
						$prog_instance = $prog->clone(m => 6);
						$asm_instance = replace($asm, '%m', 6);
						$test_asm = sprintf(" %-31s; %s", $asm_instance, $prog_instance->format_bytes);
						
						# positive
						run_test($ixiy, undef, 
								[" ld a, 1",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 1)],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
						
						# negative
						run_test($ixiy, undef,
								[" ld a, 255",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 255)],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /ret (p|m)|r(p|m)/) {
						# positive
						run_test($ixiy, undef, 
								[" ld hl, 8",	$Opcodes{"ld hl, %m"}{$cpu}->clone(m => 8)],
								[" push hl",	$Opcodes{"push hl"}{$cpu}->clone()],
								[" ld a, 1",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 1)],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
						
						# negative
						run_test($ixiy, undef,
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
							run_test($ixiy, $target, 
									[$test_asm, 	$prog_instance]);

							$asm_instance = replace($asm, '%c', $target/8);
							$test_asm = sprintf(" %-31s; %s", $asm_instance, $prog_instance->format_bytes);
							run_test($ixiy, $target, 
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
					elsif ($asm =~ /out \(c\), %c/) {
						for my $c (0) {
							$prog_instance = $prog->clone(c => $c);
							$asm_instance = replace($asm, '%c', $c);
							$test_asm = sprintf(" %-31s; %s", $asm_instance, $prog_instance->format_bytes);
							push @test, [$test_asm, $prog_instance];	
						}
					}
					elsif ($asm =~ /^(ret|reti|retn)$/) {
						run_test($ixiy, 0, 
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
					elsif ($asm =~ /^(halt|hlt)$/) {
						run_test($ixiy, 0, 
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /^(ldi|ldir|ldd|lddr)$/) {
						# BC = 1
						run_test($ixiy, undef, 
								[" ld bc, 1",	$Opcodes{"ld bc, %m"}{$cpu}->clone(m => 1)],
								[$test_asm, 	$prog_instance]);
								
						# BC = 2
						run_test($ixiy, undef, 
								[" ld bc, 2",	$Opcodes{"ld bc, %m"}{$cpu}->clone(m => 2)],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /^(ini|inir|ind|indr|outi|otir|outd|otdr)$/) {
						# B = 1
						run_test($ixiy, undef, 
								[" ld b, 1",	$Opcodes{"ld b, %n"}{$cpu}->clone(n => 1)],
								[$test_asm, 	$prog_instance]);
								
						# B = 2
						run_test($ixiy, undef, 
								[" ld b, 2",	$Opcodes{"ld b, %n"}{$cpu}->clone(n => 2)],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /^(cpi|cpir|cpd|cpdr)$/) {
						# BC = 1, carry cleared
						run_test($ixiy, undef, 
								[" ld bc, 1",	$Opcodes{"ld bc, %m"}{$cpu}->clone(m => 1)],
								[" ld hl,1000h",$Opcodes{"ld hl, %m"}{$cpu}->clone(m => 0x1000)],
								[" ld a, 0FFh",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 0xff)],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
								
						# BC = 1, carry set
						run_test($ixiy, undef, 
								[" ld bc, 1",	$Opcodes{"ld bc, %m"}{$cpu}->clone(m => 1)],
								[" ld hl,1000h",$Opcodes{"ld hl, %m"}{$cpu}->clone(m => 0x1000)],
								[" ld a, 0FFh",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 0xff)],
								[" scf",		$Opcodes{"scf"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
								
						# BC = 2, carry cleared
						run_test($ixiy, undef, 
								[" ld bc, 2",	$Opcodes{"ld bc, %m"}{$cpu}->clone(m => 2)],
								[" ld hl,1000h",$Opcodes{"ld hl, %m"}{$cpu}->clone(m => 0x1000)],
								[" ld a, 0FFh",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 0xff)],
								[" and a",		$Opcodes{"and a"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
								
						# BC = 2, carry set
						run_test($ixiy, undef, 
								[" ld bc, 2",	$Opcodes{"ld bc, %m"}{$cpu}->clone(m => 2)],
								[" ld hl,1000h",$Opcodes{"ld hl, %m"}{$cpu}->clone(m => 0x1000)],
								[" ld a, 0FFh",	$Opcodes{"ld a, %n"}{$cpu}->clone(n => 0xff)],
								[" scf",		$Opcodes{"scf"}{$cpu}->clone()],
								[$test_asm, 	$prog_instance]);
					}
					elsif ($asm =~ /^stop$/) {
						run_test($ixiy, undef, [$test_asm, 	$prog_instance]);
					}
					else {
						push @test, [$test_asm, $prog_instance];	
					}
				}
			}
			
			run_test($ixiy, undef, @test);
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
	die "Stopped.\n" if $opt_s;
	
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
	
	# linked object size in hex
	my $linked_size_hex = sprintf("%04X", -s "test.bin");
	
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
	my $ticks_end = sprintf("%04X", defined($end) ? $end : $size);
	$ok &&= run("z88dk-ticks test.bin -m$ticks_cpu -rom $linked_size_hex -end $ticks_end >test.out");

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

if (@ARGV && $ARGV[0] eq 'test') {
	run_tests();
	done_testing();
}
