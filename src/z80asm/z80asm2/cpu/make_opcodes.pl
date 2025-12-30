#!/usr/bin/env perl

#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2025
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Build CPU tables
# asm placeholders:
#	%n	unsigned byte
#   %h  high page offset
#	%m	unsigned word - 16, 24 or 32 bits
# 	%x	segment, 8 or 16 bits
#	%m1	%m+1
#	%M	unsigned word, big-endian
#	%j	jr offset
#	%J	jre offset
#	%c	constant (im, bit, rst, ...)
#	%d	signed byte
#	%d1 %d+1
#	%t	temp jump label to end of statement; %t3 to end of statement - 3
#------------------------------------------------------------------------------

use Modern::Perl;
BEGIN { 
	use Path::Tiny;
	use lib path($0)->dirname;
	use Opcodes;
}
use Clone 'clone';
use Carp (); 
$SIG{__DIE__} = \&Carp::confess;
use warnings FATAL => 'all';
use Data::Dump 'dump';

@ARGV==1 or die "Usage: $0 output_file.dat\n";
my $output_file = shift;

my $opcodes = Opcodes->new;

#------------------------------------------------------------------------------
# Operand values
#------------------------------------------------------------------------------

sub R {
	return ''.{'b'=>0, 'c'=>1, 'd'=>2, 'e'=>3, 
			   'h'=>4, 'l'=>5, '(hl)'=>6, 'f'=>6, 'm'=>6, 'a'=>7,
			   'ixh'=>4, 'ixl'=>5, 'iyh'=>4, 'iyl'=>5}->{lc($_[0])};
}

sub RP {
	return ''.{'b'=>0, 'd'=>1, 'h'=>2, 'sp'=>3, 'psw'=>3, 
			   'bc'=>0, 'de'=>1, 'hl'=>2, 'af'=>3,
			   'ix'=>2, 'iy'=>2}->{lc($_[0])};
}

sub XRP {
	return ''.{'bc'=>0, 'de'=>1, 'ix'=>2, 'iy'=>3}->{lc($_[0])};
} 
sub F {
	return ''.{'nz'=>0, 'z'=>1, 'nc'=>2, 'c'=>3, 
			   'po'=>4, 'pe'=>5, 'p'=>6, 'm'=>7,
			   'lz'=>4, 'lo'=>5,
			   'nv'=>4, 'v'=>5}->{lc($_[0])};
}

sub XF {
	return ''.{'gt'=>0, 'gtu'=>1, 'lt'=>2, 'v'=>3}->{lc($_[0])};
}

sub ALU {
	return ''.{'add'=>0, 'adc'=>1, 'sub'=>2, 'sbb'=>3,
											 'sbc'=>3,
			   'ana'=>4, 'xra'=>5, 'ora'=>6, 'cmp'=>7,
			   'and'=>4, 'xor'=>5, 'or'=>6,  'cp'=>7,
			   'adi'=>0, 'aci'=>1, 'sui'=>2, 'sbi'=>3,
			   'ani'=>4, 'xri'=>5, 'ori'=>6, 'cpi'=>7}->{lc($_[0])};
}

sub ROT {
	return ''.{'rlc'=>0, 'rrc'=>1, 'rl'=>2, 'rr'=>3,
			   'sla'=>4, 'sra'=>5, 'srl'=>7,
			   'sll'=>6, 'sls'=>6, 'sli'=>6}->{lc($_[0])};
}

sub BIT {
	return ''.{'bit'=>1, 'res'=>2, 'set'=>3}->{lc($_[0])};
}

sub PFX {
	return ''.{'ix'=>0xDD, 'iy'=>0xFD}->{lc($_[0])};
}

sub KC_CONST1 {
	return ''.{ 'x'=>0x40,  'y'=>0x49, 'a'=>0x52,  'p'=>0x5B,  'z'=>0x7F,
			   'xp'=>0x40, 'yp'=>0x49, 'a'=>0x52, 'pp'=>0x5B, 'zp'=>0x7F}->{lc($_[0])};
}

sub KC_CONST2 {
	return ''.{ 'x'=>0x40,  'y'=>0x49, 'a'=>0x52,  'z'=>0x7F,
			   'xp'=>0x40, 'yp'=>0x49, 'a'=>0x52, 'zp'=>0x7F}->{lc($_[0])};
}

sub RABBIT_CONST {
	return ''.{'altd'=>0x76, 'alts'=>0x40, 'altsd'=>0x64, 'ioi'=>0xD3, 'ioe'=>0xDB}->{lc($_[0])};
}

sub RABBIT_PP {
	return ''.{ 'pw'=>0,  'px'=>1, 'py'=>2, 'pz'=>3}->{lc($_[0])};
}

sub cpu_flags {
	my($cpu) = @_;
	if ($cpu =~ /gbz80/) {
		return ('nz', 'z', 'nc', 'c');
	}
	elsif ($cpu =~ /r[23]]k/) {
		return ('nz', 'z', 'nc', 'c', 'po', 'pe', 'lz', 'lo', 'nv', 'v', 'p', 'm');
	}
	elsif ($cpu =~ /r\dk/) {
		return ('nz', 'z', 'nc', 'c', 'po', 'pe', 'lz', 'lo', 'p', 'm');
	}
	else {
		return ('nz', 'z', 'nc', 'c', 'po', 'pe', 'p', 'm');
	}
}

# if asm has (xx+%d), create opcode with (xx)
sub add_opcode {
	my($cpu, $asm, $ops, $const) = @_;

	add_opcode_1($cpu, $asm, $ops, $const);
	if ($asm =~ s/ \( (\w+) \+ %d \) /($1)/x) {
		my $ops1 = clone($ops);			# do not change callers data
		for (@$ops1) {
			s/^%d$/0/;
		}
		add_opcode_1($cpu, $asm, $ops1, $const);
	}
}

sub add_opcode_1 {
	my($cpu, $asm, $ops, $const) = @_;
	$ops = clone($ops);			# do not change caller's data
	$const ||= [];

	# separate prefixes from opcode becuase of (ix+d) with d at 2nd byte
	my @ops;
	while (@$ops > 1 && $ops->[1] =~ /^\d+$/ &&
	    ($ops->[0] == 0x76 || $ops->[0] == 0xD3 || $ops->[0] == 0xDB || # rabbit
		 $ops->[0] == 0x40 || $ops->[0] == 0x64 ||						# rabbit >4k
		 $ops->[0] == 0x40 || $ops->[0] == 0x49 || 
		 $ops->[0] == 0x52 || $ops->[0] == 0x5B ||
		 $ops->[0] == 0x7F)) {						# ez80 / kc160
		my @pfx = shift @$ops;
		push @ops, [@pfx];
	}
	push @ops, [@$ops];
	
	$opcodes->add(Opcode->new(asm=>$asm, cpu=>$cpu, ops=>\@ops, const=>[@$const]));
}

# add ez80 .l and .s suffixes
sub add_opcode_ez80_s_l {
	my($cpu, $asm, $ops, $const) = @_;
	my $adl_mode = $cpu =~ /ez80_z80/ ? 0 : 1;
	
	add_opcode($cpu, $asm, $ops, $const);
	if ($adl_mode) {
		add_opcode($cpu, $asm =~ s/^(\w+)/$1.s/r, [0x52, @$ops], $const);
		add_opcode($cpu, $asm =~ s/^(\w+)/$1.sil/r, [0x52, @$ops], $const);
	}
	else {
		add_opcode($cpu, $asm =~ s/^(\w+)/$1.l/r, [0x49, @$ops], $const);
		add_opcode($cpu, $asm =~ s/^(\w+)/$1.lis/r, [0x49, @$ops], $const);
	}
}

# add ez80 .is and .il suffixes, make '%m' three bytes where applicable
sub add_opcode_ez80_is_il {
	my($cpu, $asm, $ops, $const) = @_;
	my $adl_mode = $cpu =~ /ez80_z80/ ? 0 : 1;

	my @ops2bytes = @{clone($ops)};
	@ops2bytes > 2 && $ops2bytes[-1] eq '%m' && $ops2bytes[-2] eq '%m' &&
					  $ops2bytes[-3] ne '%m'
		or die "expected %m %m, got @ops2bytes";
		
	my @ops3bytes = (@ops2bytes, '%m');
	@ops3bytes > 3 && $ops3bytes[-1] eq '%m' && $ops3bytes[-2] eq '%m' &&
					  $ops3bytes[-3] eq '%m' && $ops3bytes[-4] ne '%m'
		or die "expected %m %m %m, got @ops3bytes";
	
	if ($adl_mode) {
		add_opcode($cpu, $asm, [@ops3bytes], $const);
		add_opcode($cpu, $asm =~ s/^(\w+)/$1.is/r, [0x40, @ops2bytes], $const);
		add_opcode($cpu, $asm =~ s/^(\w+)/$1.sis/r, [0x40, @ops2bytes], $const);
	}
	else {
		add_opcode($cpu, $asm, [@ops2bytes], $const);
		add_opcode($cpu, $asm =~ s/^(\w+)/$1.il/r, [0x5B, @ops3bytes], $const);
		add_opcode($cpu, $asm =~ s/^(\w+)/$1.lil/r, [0x5B, @ops3bytes], $const);
	}
}

# add ez80 .sis and .lil suffixes, make '%m' three bytes where applicable
sub add_opcode_ez80_sis_lil {
	my($cpu, $asm, $ops, $const) = @_;
	my $adl_mode = $cpu =~ /ez80_z80/ ? 0 : 1;

	my @ops2bytes = @{clone($ops)};
	@ops2bytes > 2 && $ops2bytes[-1] eq '%m' && $ops2bytes[-2] eq '%m' &&
					  $ops2bytes[-3] ne '%m'
		or die "expected %m %m, got @ops2bytes";
		
	my @ops3bytes = (@ops2bytes, '%m');
	@ops3bytes > 3 && $ops3bytes[-1] eq '%m' && $ops3bytes[-2] eq '%m' &&
					  $ops3bytes[-3] eq '%m' && $ops3bytes[-4] ne '%m'
		or die "expected %m %m %m, got @ops3bytes";
	
	if ($adl_mode) {
		add_opcode($cpu, $asm, [@ops3bytes], $const);
		add_opcode($cpu, $asm =~ s/^(\w+)/$1.sis/r, [0x40, @ops2bytes], $const);
	}
	else {
		add_opcode($cpu, $asm, [@ops2bytes], $const);
		add_opcode($cpu, $asm =~ s/^(\w+)/$1.lil/r, [0x5B, @ops3bytes], $const);
	}
}

# add ez80 suffixes for call instructions
sub add_opcode_ez80_call {
	my($cpu, $asm, $ops, $const) = @_;
	my $adl_mode = $cpu =~ /ez80_z80/ ? 0 : 1;

	my @ops2bytes = @{clone($ops)};
	@ops2bytes > 2 && $ops2bytes[-1] eq '%m' && $ops2bytes[-2] eq '%m' &&
					  $ops2bytes[-3] ne '%m'
		or die "expected %m %m, got @ops2bytes";
		
	my @ops3bytes = (@ops2bytes, '%m');
	@ops3bytes > 3 && $ops3bytes[-1] eq '%m' && $ops3bytes[-2] eq '%m' &&
					  $ops3bytes[-3] eq '%m' && $ops3bytes[-4] ne '%m'
		or die "expected %m %m %m, got @ops3bytes";
	
	if ($adl_mode) {
		add_opcode($cpu, $asm, [@ops3bytes], $const);
		add_opcode($cpu, $asm =~ s/^(\w+)/$1.is/r, [0x49, @ops2bytes], $const);
		add_opcode($cpu, $asm =~ s/^(\w+)/$1.lis/r, [0x49, @ops2bytes], $const);
		add_opcode($cpu, $asm =~ s/^(\w+)/$1.il/r, [0x5B, @ops3bytes], $const);
		add_opcode($cpu, $asm =~ s/^(\w+)/$1.lil/r, [0x5B, @ops3bytes], $const);
	}
	else {
		add_opcode($cpu, $asm, [@ops2bytes], $const);
		add_opcode($cpu, $asm =~ s/^(\w+)/$1.is/r, [0x40, @ops2bytes], $const);
		add_opcode($cpu, $asm =~ s/^(\w+)/$1.sis/r, [0x40, @ops2bytes], $const);
		add_opcode($cpu, $asm =~ s/^(\w+)/$1.il/r, [0x52, @ops3bytes], $const);
		add_opcode($cpu, $asm =~ s/^(\w+)/$1.sil/r, [0x52, @ops3bytes], $const);
	}
}

# add ez80 suffixes for ret instructions
sub add_opcode_ez80_ret {
	my($cpu, $asm, $ops, $const) = @_;
	my $adl_mode = $cpu =~ /ez80_z80/ ? 0 : 1;

	if ($adl_mode) {
		add_opcode($cpu, $asm, $ops, $const);
		add_opcode($cpu, $asm =~ s/^(\w+)/$1.l/r, [0x5B, @$ops], $const);
		add_opcode($cpu, $asm =~ s/^(\w+)/$1.lil/r, [0x5B, @$ops], $const);
	}
	else {
		add_opcode($cpu, $asm, $ops, $const);
		add_opcode($cpu, $asm =~ s/^(\w+)/$1.l/r, [0x49, @$ops], $const);
		add_opcode($cpu, $asm =~ s/^(\w+)/$1.lis/r, [0x49, @$ops], $const);
	}
}

# add ez80 suffixes for jump instructions
sub add_opcode_ez80_jump {
	my($cpu, $asm, $ops, $const) = @_;
	my $adl_mode = $cpu =~ /ez80_z80/ ? 0 : 1;

	my @ops2bytes = @{clone($ops)};
	@ops2bytes > 2 && $ops2bytes[-1] eq '%m' && $ops2bytes[-2] eq '%m' &&
					  $ops2bytes[-3] ne '%m'
		or die "expected %m %m, got @ops2bytes";
		
	my @ops3bytes = (@ops2bytes, '%m');
	@ops3bytes > 3 && $ops3bytes[-1] eq '%m' && $ops3bytes[-2] eq '%m' &&
					  $ops3bytes[-3] eq '%m' && $ops3bytes[-4] ne '%m'
		or die "expected %m %m %m, got @ops3bytes";
	
	if ($adl_mode) {
		add_opcode($cpu, $asm, [@ops3bytes], $const);
		add_opcode($cpu, $asm =~ s/^(\w+)/$1.sis/r, [0x40, @ops2bytes], $const);
		add_opcode($cpu, $asm =~ s/^(\w+)/$1.lil/r, [0x5B, @ops3bytes], $const);
	}
	else {
		add_opcode($cpu, $asm, [@ops2bytes], $const);
		add_opcode($cpu, $asm =~ s/^(\w+)/$1.sis/r, [0x40, @ops2bytes], $const);
		add_opcode($cpu, $asm =~ s/^(\w+)/$1.lil/r, [0x5B, @ops3bytes], $const);
	}
}

# add Rabbit prefixes/tick
sub altd_reg_tick {
	my($asm) = @_;
	if ($asm =~ /^ ( \w+ \s+ (?: %c \s* , \s* )? ) (a|f|b|c|d|e|h|l|af|bc|de|jk|hl|jkhl|bcde|pw|px|py|pz) \b (.*) /xi) {
		return "$1$2'$3";
	}
	else {
		return;
	}
}

sub add_opcode_rabbit_altd {
	my($cpu, $asm, $ops, $const) = @_;

	add_opcode($cpu, $asm, $ops, $const);
	add_opcode($cpu, "altd $asm", [RABBIT_CONST('altd'), @$ops], $const);

	my $asm1 = altd_reg_tick($asm);
	if ($asm1) {
		add_opcode($cpu, $asm1, [RABBIT_CONST('altd'), @$ops], $const);
	}
}

sub add_opcode_rabbit_io {
	my($cpu, $asm, $ops, $const) = @_;

	add_opcode($cpu, $asm, $ops, $const);
	add_opcode($cpu, "ioi $asm", [RABBIT_CONST('ioi'), @$ops], $const);
	add_opcode($cpu, "ioe $asm", [RABBIT_CONST('ioe'), @$ops], $const);
}

sub add_opcode_rabbit_altd_io {
	my($cpu, $asm, $ops, $const) = @_;

	add_opcode($cpu, $asm, $ops, $const);

	add_opcode($cpu, "altd $asm", [RABBIT_CONST('altd'), @$ops], $const);
	add_opcode($cpu, "ioi $asm", [RABBIT_CONST('ioi'), @$ops], $const);
	add_opcode($cpu, "ioe $asm", [RABBIT_CONST('ioe'), @$ops], $const);

	add_opcode($cpu, "altd ioi $asm", [RABBIT_CONST('altd'), RABBIT_CONST('ioi'), @$ops], $const);
	add_opcode($cpu, "altd ioe $asm", [RABBIT_CONST('altd'), RABBIT_CONST('ioe'), @$ops], $const);
	add_opcode($cpu, "ioi altd $asm", [RABBIT_CONST('ioi'), RABBIT_CONST('altd'), @$ops], $const);
	add_opcode($cpu, "ioe altd $asm", [RABBIT_CONST('ioe'), RABBIT_CONST('altd'), @$ops], $const);

	my $asm1 = altd_reg_tick($asm);
	if ($asm1) {
		add_opcode($cpu, $asm1, [RABBIT_CONST('altd'), @$ops], $const);
		add_opcode($cpu, "ioi $asm1", [RABBIT_CONST('ioi'), RABBIT_CONST('altd'), @$ops], $const);
		add_opcode($cpu, "ioe $asm1", [RABBIT_CONST('ioe'), RABBIT_CONST('altd'), @$ops], $const);
	}
}

sub get_opcode {
	my($cpu, $asm) = @_;
	return $opcodes->opcodes->{$asm}{$cpu};
}

sub cond_add_opcode {
	my($cpu, $asm, $ops, $const) = @_;
	my $ac = Array::Compare->new;
	my $opcode = get_opcode($cpu, $asm);
	if ($opcode && $ac->compare($ops, [$opcode->bytes]) && $ac->compare($const, $opcode->{const})) {
		return;
	}
	elsif ($opcode) {
		die "Duplicate opcode:\n", hex_dump({asm=>$asm, ops=>$ops, const=>$const}), "\n", hex_dump($opcode);
	}
	else {
		add_opcode($cpu, $asm, $ops, $const);
	}
}
		
sub add_synth {
	my($cpu, $asm, @subasm) = @_;
	$opcodes->add_synth($cpu, $asm, @subasm);
}

sub add_emul {
	my($cpu, $asm, @emul) = @_;
	$opcodes->add_emul($cpu, $asm, @emul);
}

sub add_opcodes {
	my($cpu, $key) = @_;
	state $actions = {
		"ld <r>, <r>" => sub {
			my($cpu) = @_;
			for my $d ('b', 'c', 'd', 'e', 'h', 'l', '(hl)', 'a') {
				for my $s ('b', 'c', 'd', 'e', 'h', 'l', '(hl)', 'a') {
					next if $d eq '(hl)' && $d eq $s;
					next if $cpu =~ /ez80/ && "$s$d" =~ /bb|cc|dd|ee/;				# .SIS, .LIS, .SIL, .LIL prefixes
					next if $cpu =~ /^kc160(_strict)?$/ && "$s$d" =~ /bb|cc|dd|ee|hh|ll|aa/;	# x, y, a, p, z prefixes
					if (!get_opcode($cpu, "ld $d, $s")) {
						add_opcode($cpu, "ld $d, $s", [0x40+8*R($d)+R($s)]);
					}
				}
			}
		},
		"mov <r>, <r>" => sub {
			my($cpu) = @_;
			for my $d ('b', 'c', 'd', 'e', 'h', 'l', 'm', 'a') {
				for my $s ('b', 'c', 'd', 'e', 'h', 'l', 'm', 'a') {
					next if $d eq 'm' && $d eq $s;
					next if $cpu =~ /ez80/ && "$s$d" =~ /bb|cc|dd|ee/;				# .SIS, .LIS, .SIL, .LIL prefixes
					next if $cpu =~ /^kc160(_strict)?$/ && "$s$d" =~ /bb|cc|dd|ee|hh|ll|aa/;	# x, y, a, p, z prefixes
					if (!get_opcode($cpu, "mov $d, $s")) {
						add_opcode($cpu, "mov $d, $s", [0x40+8*R($d)+R($s)]);
					}
				}
			}
		},
		"ld <r>, N" => sub {
			my($cpu) = @_;
			for my $r ('b', 'c', 'd', 'e', 'h', 'l', '(hl)', 'a') {
				if (!get_opcode($cpu, "ld $r, %n")) {
					add_opcode($cpu, "ld $r, %n", [0x06+8*R($r), '%n']);
				}
			}
		},
		"mvi <r>, N" => sub {
			my($cpu) = @_;
			for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'm', 'a') {
				if (!get_opcode($cpu, "mvi $r, %n")) {
					add_opcode($cpu, "mvi $r, %n", [0x06+8*R($r), '%n']);
				}
			}
		},
		"ld <rp>, NN" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'hl', 'sp') {
				add_opcode($cpu, "ld $rp, %m", [0x01+16*RP($rp), '%m', '%m']);
			}
		},
		"ld <x>, NN" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode($cpu, "ld $x, %m", [PFX($x), 0x21, '%m', '%m']);
			}
		},
		"lxi <r>, NN" => sub {
			my($cpu) = @_;
			for my $rp ('b', 'd', 'h', 'sp') {
				add_opcode($cpu, "lxi $rp, %m", [0x01+16*RP($rp), '%m', '%m']);
			}
		},
		"lxi <rp>, NN" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'hl') {
				add_opcode($cpu, "lxi $rp, %m", [0x01+16*RP($rp), '%m', '%m']);
			}
		},
		"ld <x8>, <r>" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $d ('b', 'c', 'd', 'e', $x.'h', $x.'l', 'a') {
					for my $s ('b', 'c', 'd', 'e', $x.'h', $x.'l', 'a') {
						next if $d !~ /$x/ && $s !~ /$x/; # no ixh, ixl, iyh, iyl
						add_opcode($cpu, "ld $d, $s", [PFX($x), 0x40+8*R($d)+R($s)]);
					}
				}
			}
		},
		"ld <x8>, N" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $r ($x.'h', $x.'l') {
					add_opcode($cpu, "ld $r, %n", [PFX($x), 0x06+8*R($r), '%n']);
				}
			}
		},
		"ld (<x>+DIS), <r>" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
					add_opcode($cpu, "ld $r, ($x+%d)", [PFX($x), 0x40+8*R($r)+6, '%d']);
					add_opcode($cpu, "ld ($x+%d), $r", [PFX($x), 0x40+8*6+R($r), '%d']);
				}
			}
		},
		"ld (<x>+DIS), N" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode($cpu, "ld ($x+%d), %n", [PFX($x), 0x36, '%d', '%n']);
			}
		},
		"lda/sta [8080]" => sub {
			my($cpu) = @_;
			if ($cpu =~ /gbz80/) {
				add_opcode($cpu, "sta %m", [0xEA, '%m', '%m']);
				add_opcode($cpu, "lda %m", [0xFA, '%m', '%m']);
			} 
			else {
				add_opcode($cpu, "sta %m", [0x32, '%m', '%m']);
				add_opcode($cpu, "lda %m", [0x3A, '%m', '%m']);
			}
		},
		"ld a, (NN)" => sub {
			my($cpu) = @_;
			if ($cpu =~ /gbz80/) {
				add_opcode($cpu, "ld (%m), a", [0xEA, '%m', '%m']);
				add_opcode($cpu, "ld a, (%m)", [0xFA, '%m', '%m']);
			} 
			else {
				add_opcode($cpu, "ld (%m), a", [0x32, '%m', '%m']);
				add_opcode($cpu, "ld a, (%m)", [0x3A, '%m', '%m']);
			}
		},
		"lhld/shld [8080]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "shld %m", [0x22, '%m', '%m']);
			add_opcode($cpu, "lhld %m", [0x2A, '%m', '%m']);
		},
		"ld hl, (NN)" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ld (%m), hl", [0x22, '%m', '%m']);
			add_opcode($cpu, "ld hl, (%m)", [0x2A, '%m', '%m']);
		},
		"ld <x>, (NN)" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode($cpu, "ld (%m), $x", [PFX($x), 0x22, '%m', '%m']);
				add_opcode($cpu, "ld $x, (%m)", [PFX($x), 0x2A, '%m', '%m']);
			}
		},
		"ld <rp>, (NN)" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'sp') {
				add_opcode($cpu, "ld (%m), $rp", [0xED, 0x43+16*RP($rp), '%m', '%m']);
				add_opcode($cpu, "ld $rp, (%m)", [0xED, 0x4B+16*RP($rp), '%m', '%m']);
			}
		},
		"ldax <r>/stax <r> [8080]" => sub {
			my($cpu) = @_;
			for my $rp ('b', 'd') {
				add_opcode($cpu, "ldax $rp", [0x0A+16*RP($rp)]);
				add_opcode($cpu, "stax $rp", [0x02+16*RP($rp)]);
			}
		},
		"ldax <rp>/stax <rp> [8080]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de') {
				add_opcode($cpu, "ldax $rp", [0x0A+16*RP($rp)]);
				add_opcode($cpu, "stax $rp", [0x02+16*RP($rp)]);
			}
		},
		"ld a, (<rp>)" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de') {
				add_opcode($cpu, "ld a, ($rp)", [0x0A+16*RP($rp)]);
				add_opcode($cpu, "ld ($rp), a", [0x02+16*RP($rp)]);
			}
		},
		"xchg [8080]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "xchg", [0xEB]);
		},
		"ex de, hl" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ex de, hl", [0xEB]);
		},
		"ex af, af'" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ex af, af'", [0x08]);
		},
		"exx" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "exx", [0xD9]);
		},
		"<alu> <r> [8080]" => sub {
			my($cpu) = @_;
			for my $alu ('add', 'adc', 'sub', 'sbb', 'ana', 'xra', 'ora', 'cmp') {
				for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'm', 'a') {
					if (!get_opcode($cpu, "$alu $r")) {
						add_opcode($cpu, "$alu $r", [0x80+8*ALU($alu)+R($r)]);
					}
				}
			}
		},
		"<alu> a, <r>" => sub {
			my($cpu) = @_;
			for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp') {
				my $a_ = ($alu =~ /add|adc|sbc/ ? 'a, ' : '');
				for my $r ('b', 'c', 'd', 'e', 'h', 'l', '(hl)', 'a') {
					if (!get_opcode($cpu, "$alu $a_$r")) {
						add_opcode($cpu, "$alu $a_$r", [0x80+8*ALU($alu)+R($r)]);
					}
				}
			}
		},
		"<alu> a, <r> [ez80]" => sub {
			my($cpu) = @_;
			for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp') {
				for my $r ('b', 'c', 'd', 'e', 'h', 'l', '(hl)', 'a') {
					if (!get_opcode($cpu, "$alu a, $r")) {
						add_opcode($cpu, "$alu a, $r", [0x80+8*ALU($alu)+R($r)]);
					}
				}
			}
		},
		"<alu-extra> a, <r>" => sub {
			my($cpu) = @_;
			for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp', 'cmp') {
				for my $a_ ('a, ', '') {
					for my $r ('b', 'c', 'd', 'e', 'h', 'l', '(hl)', 'a') {
						if (!get_opcode($cpu, "$alu $a_$r")) {
							add_opcode($cpu, "$alu $a_$r", [0x80+8*ALU($alu)+R($r)]);
						}
					}
				}
			}
		},
		"<alu> (<x>+DIS)" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp') {
					my $a_ = ($alu =~ /add|adc|sbc/ ? 'a, ' : '');
					if (!get_opcode($cpu, "$alu $a_($x+%d)")) {
						add_opcode($cpu, "$alu $a_($x+%d)", 
									[PFX($x), 0x86+8*ALU($alu), '%d']);
					}
					if (!get_opcode($cpu, "$alu $a_($x)")) {
						add_opcode($cpu, "$alu $a_($x)", 
									[PFX($x), 0x86+8*ALU($alu), 0]);
					}
				}
			}
		},
		"<alu-extra> (<x>+DIS)" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp', 'cmp') {
					for my $a_ ('a, ', '') {
						if (!get_opcode($cpu, "$alu $a_($x+%d)")) {
							add_opcode($cpu, "$alu $a_($x+%d)", 
										[PFX($x), 0x86+8*ALU($alu), '%d']);
						}
						if (!get_opcode($cpu, "$alu $a_($x)")) {
							add_opcode($cpu, "$alu $a_($x)", 
										[PFX($x), 0x86+8*ALU($alu), 0]);
						}
					}
				}
			}
		},
		"<alu> a, <x8>" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp') {
					my $a_ = ($alu =~ /add|adc|sbc/ ? 'a, ' : '');
					for my $r ($x.'h', $x.'l') {
						if (!get_opcode($cpu, "$alu $a_$r")) {
							add_opcode($cpu, "$alu $a_$r", 
										[PFX($x), 0x80+8*ALU($alu)+R($r)]);
						}
					}
				}
			}
		},
		"<alu-extra> a, <x8>" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp', 'cmp') {
					for my $a_ ('a, ', '') {
						for my $r ($x.'h', $x.'l') {
							if (!get_opcode($cpu, "$alu $a_$r")) {
								add_opcode($cpu, "$alu $a_$r", 
											[PFX($x), 0x80+8*ALU($alu)+R($r)]);
							}
						}
					}
				}
			}
		},
		"<alu> N [8080]" => sub {
			my($cpu) = @_;
			for my $alu ('adi', 'aci', 'sui', 'sbi', 'ani', 'xri', 'ori', 'cpi') {
				add_opcode($cpu, "$alu %n", [0xC6+8*ALU($alu), '%n']);
			}
		},
		"<alu> a, N" => sub {
			my($cpu) = @_;
			for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp') {
				my $a_ = ($alu =~ /add|adc|sbc/ ? 'a, ' : '');
				if (!get_opcode($cpu, "$alu $a_%n")) {
					add_opcode($cpu, "$alu $a_%n", [0xC6+8*ALU($alu), '%n']);
				}
			}
		},
		"<alu> a, N [ez80]" => sub {
			my($cpu) = @_;
			for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp') {
				if (!get_opcode($cpu, "$alu a, %n")) {
					add_opcode($cpu, "$alu a, %n", [0xC6+8*ALU($alu), '%n']);
				}
			}
		},
		"<alu-extra> a, N" => sub {
			my($cpu) = @_;
			for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp', 'cmp') {
				for my $a_ ('a, ', '') {
					if (!get_opcode($cpu, "$alu $a_%n")) {
						add_opcode($cpu, "$alu $a_%n", [0xC6+8*ALU($alu), '%n']);
					}
				}
			}
		},
		"inr/dcr <r> [8080]" => sub {
			my($cpu) = @_;
			for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'm', 'a') {
				add_opcode($cpu, "inr $r", [0x04+8*R($r)]);
				add_opcode($cpu, "dcr $r", [0x05+8*R($r)]);
			}
		},
		"inc/dec <r>" => sub {
			my($cpu) = @_;
			for my $r ('b', 'c', 'd', 'e', 'h', 'l', '(hl)', 'a') {
				if (!get_opcode($cpu, "inc $r")) {
					add_opcode($cpu, "inc $r", [0x04+8*R($r)]);
					add_opcode($cpu, "dec $r", [0x05+8*R($r)]);
				}
			}
		},
		"inc/dec (<x>+DIS)" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode($cpu, "inc ($x+%d)", [PFX($x), 0x04+8*6, '%d']);
				add_opcode($cpu, "dec ($x+%d)", [PFX($x), 0x05+8*6, '%d']);
			}
		},
		"inc/dec <x8>" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $r ($x.'h', $x.'l') {
					add_opcode($cpu, "inc $r", [PFX($x), 0x04+8*R($r)]);
					add_opcode($cpu, "dec $r", [PFX($x), 0x05+8*R($r)]);
				}
			}
		},
		"inx/dcx <r> [8080]" => sub {
			my($cpu) = @_;
			for my $rp ('b', 'd', 'h', 'sp') {
				add_opcode($cpu, "inx $rp", [0x03+16*RP($rp)]);
				add_opcode($cpu, "dcx $rp", [0x0B+16*RP($rp)]);
			}
		},
		"inx/dcx <rp> [8080]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'hl') {
				add_opcode($cpu, "inx $rp", [0x03+16*RP($rp)]);
				add_opcode($cpu, "dcx $rp", [0x0B+16*RP($rp)]);
			}
		},
		"inc/dec <rp>" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'hl', 'sp') {
				add_opcode($cpu, "inc $rp", [0x03+16*RP($rp)]);
				add_opcode($cpu, "dec $rp", [0x0B+16*RP($rp)]);
			}
		},
		"inc/dec <x>" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode($cpu, "inc $x", [PFX($x), 0x03+16*2]);
				add_opcode($cpu, "dec $x", [PFX($x), 0x0B+16*2]);
			}
		},
		"dad <r> [8080]" => sub {
			my($cpu) = @_;
			for my $rp ('b', 'd', 'h', 'sp') {
				add_opcode($cpu, "dad $rp", [0x09+16*RP($rp)]);
			}
		},
		"dad <rp> [8080]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'hl') {
				add_opcode($cpu, "dad $rp", [0x09+16*RP($rp)]);
			}
		},
		"add hl, <rp>" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'hl', 'sp') {
				add_opcode($cpu, "add hl, $rp", [0x09+16*RP($rp)]);
			}
		},
		"add <x>, <rp>" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $rp ('bc', 'de', $x, 'sp') {
					add_opcode($cpu, "add $x, $rp", [PFX($x), 0x09+16*RP($rp)]);
				}
			}
		},
		"sbc/adc hl, <rp>" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'hl', 'sp') {
				add_opcode($cpu, "sbc hl, $rp", [0xED, 0x42+16*RP($rp)]);
				add_opcode($cpu, "adc hl, $rp", [0xED, 0x4A+16*RP($rp)]);
			}
		},
		"daa" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "daa", [0x27]);
		},
		"cma [8080]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "cma", [0x2F]);
		},
		"cpl" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "cpl", [0x2F]);
		},
		"cpl a" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "cpl a", [0x2F]);
		},
		"cmc [8080]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "cmc", [0x3F]);
		},
		"ccf" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ccf", [0x3F]);
		},
		"stc [8080]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "stc", [0x37]);
		},
		"scf" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "scf", [0x37]);
		},
		"<rot-a> [8080]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "rlc", [0x07]);
			add_opcode($cpu, "rrc", [0x0F]);
			add_opcode($cpu, "ral", [0x17]);
			add_opcode($cpu, "rar", [0x1F]);
		},
		"<rot-a>" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "rlca", [0x07]);
			add_opcode($cpu, "rrca", [0x0F]);
			add_opcode($cpu, "rla", [0x17]);
			add_opcode($cpu, "rra", [0x1F]);
		},
		"<rot> <r>" => sub {
			my($cpu) = @_;
			for my $op ('rlc', 'rrc', 'rl', 'rr', 'sla', 'sra', 'srl') {
				for my $r ('b', 'c', 'd', 'e', 'h', 'l', '(hl)', 'a') {
					if (!get_opcode($cpu, "$op $r")) {
						add_opcode($cpu, "$op $r", [0xCB, 8*ROT($op)+R($r)]);
					}
				}
			}
		},
		"<rot> (<x>+DIS)" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $op ('rlc', 'rrc', 'rl', 'rr', 'sla', 'sra', 'srl') {
					add_opcode($cpu, "$op ($x+%d)", 
							   [PFX($x), 0xCB, '%d', 8*ROT($op)+6]);
				}
			}
		},
		"<rot> (<x>+DIS) [r2ka]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $op ('rlc', 'rrc', 'rl', 'rr', 'sla', 'sra', 'srl') {
					add_opcode_rabbit_altd_io($cpu, "$op ($x+%d)", 
							   [PFX($x), 0xCB, '%d', 8*ROT($op)+6]);
				}
			}
		},
		"<rot-undoc> <r>" => sub {
			my($cpu) = @_;
			for my $op ('sll', 'sls', 'sli') {
				for my $r ('b', 'c', 'd', 'e', 'h', 'l', '(hl)', 'a') {
					add_opcode($cpu, "$op $r", [0xCB, 8*ROT($op)+R($r)]);
				}
			}
		},			
		"<rot-undoc> (<x>+DIS)" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $op ('sll', 'sls', 'sli') {
					add_opcode($cpu, "$op ($x+%d)", 
							   [PFX($x), 0xCB, '%d', 8*ROT($op)+6]);
				}
			}
		},			
		"<rot-undoc> (<x>+DIS), <r>" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $op ('rlc', 'rrc', 'rl', 'rr', 'sla', 'sra', 'srl',
							'sll', 'sls', 'sli') {
					for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
						add_opcode($cpu, "$op ($x+%d), $r", 
								   [PFX($x), 0xCB, '%d', 8*ROT($op)+R($r)]);
						add_opcode($cpu, "ld $r, $op ($x+%d)", 
								   [PFX($x), 0xCB, '%d', 8*ROT($op)+R($r)]);
					}
				}
			}
		},
		"<bit> <b>, <r>" => sub {
			my($cpu) = @_;
			for my $op ('bit', 'res', 'set') {
				for my $r ('b', 'c', 'd', 'e', 'h', 'l', '(hl)', 'a') {
					if (!get_opcode($cpu, "$op %c, $r")) {
						add_opcode($cpu, "$op %c, $r", 
								   [0xCB, (0x40*BIT($op)+R($r))."+8*%c"],
								   [0, 1, 2, 3, 4, 5, 6, 7]);
					}
				}
			}
		},
		"<bit> <b>, (<x>+DIS)" => sub {
			my($cpu) = @_;
			for my $op ('bit', 'res', 'set') {
				for my $x ('ix', 'iy') {
					add_opcode($cpu, "$op %c, ($x+%d)",
							   [PFX($x), 0xCB, '%d', (0x40*BIT($op)+6)."+8*%c"],
							   [0, 1, 2, 3, 4, 5, 6, 7]);
				}
			}
		},
		"<bit-undoc> <b>, (<x>+DIS), <r>" => sub {
			my($cpu) = @_;
			for my $op ('res', 'set') {
				for my $x ('ix', 'iy') {
					for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
						add_opcode($cpu, "$op %c, ($x+%d), $r",
								   [PFX($x), 0xCB, '%d', (0x40*BIT($op)+R($r))."+8*%c"],
								   [0, 1, 2, 3, 4, 5, 6, 7]);
						add_opcode($cpu, "ld $r, $op %c, ($x+%d)",
								   [PFX($x), 0xCB, '%d', (0x40*BIT($op)+R($r))."+8*%c"],
								   [0, 1, 2, 3, 4, 5, 6, 7]);
					}
				}
			}
		},
		"jr DIS" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "jr %j", [0x18, '%j']);
		},
		"djnz DIS" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "djnz %j", [0x10, '%j']);
		},
		"djnz b, DIS" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "djnz b, %j", [0x10, '%j']);
		},
		"jr <f>, DIS" => sub {
			my($cpu) = @_;
			for my $f ('nz', 'z', 'nc', 'c') {
				add_opcode($cpu, "jr $f, %j", [0x20+8*F($f), '%j']);
			}
		},
		"jmp NN" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "jmp %m", [0xC3, '%m', '%m']);
		},
		"jp NN" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "jp %m", [0xC3, '%m', '%m']);
		},
		"j<f> NN" => sub {
			my($cpu) = @_;
			for my $f (cpu_flags($cpu)) {
				add_opcode($cpu, "j$f %m", [0xC2+8*F($f), '%m', '%m']) if $f ne 'p';
			}
		},
		"j_<f> NN" => sub {
			my($cpu) = @_;
			for my $f (cpu_flags($cpu)) {
				add_opcode($cpu, "j_$f %m", [0xC2+8*F($f), '%m', '%m']);
			}
		},
		"jp NN [8080]" => sub {
			my($cpu) = @_;
			for my $f ('p') {
				add_opcode($cpu, "j$f %m", [0xC2+8*F($f), '%m', '%m']);
			}
		},
		"jmp <f>, NN" => sub {
			my($cpu) = @_;
			for my $f (cpu_flags($cpu)) {
				add_opcode($cpu, "jmp $f, %m", [0xC2+8*F($f), '%m', '%m']);
			}
		},
		"jp <f>, NN" => sub {
			my($cpu) = @_;
			for my $f (cpu_flags($cpu)) {
				add_opcode($cpu, "jp $f, %m", [0xC2+8*F($f), '%m', '%m']);
			}
		},
		"pchl [8080]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "pchl", [0xE9]);
		},
		"jp (hl)" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "jp (hl)", [0xE9]);
		},
		"jp (<x>)" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode($cpu, "jp ($x)", [PFX($x), 0xE9]);
			}
		},
		"jmp (hl)" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "jmp (hl)", [0xE9]);
		},
		"jmp (<x>)" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode($cpu, "jmp ($x)", [PFX($x), 0xE9]);
			}
		},
		"call NN" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "call %m", [0xCD, '%m', '%m']);
		},
		"c<flag> NN" => sub {
			my($cpu) = @_;
			for my $f (cpu_flags($cpu)) {
				add_opcode($cpu, "c$f %m", [0xC4+8*F($f), '%m', '%m']) if $f ne 'p';
			}
		},
		"c_<f> NN" => sub {
			my($cpu) = @_;
			for my $f (cpu_flags($cpu)) {
				add_opcode($cpu, "c_$f %m", [0xC4+8*F($f), '%m', '%m']);
			}
		},
		"cp NN [8080]" => sub {
			my($cpu) = @_;
			for my $f ('p') {
				add_opcode($cpu, "c$f %m", [0xC4+8*F($f), '%m', '%m']);
			}
		},
		"call <f>, NN" => sub {
			my($cpu) = @_;
			for my $f (cpu_flags($cpu)) {
				add_opcode($cpu, "call $f, %m", [0xC4+8*F($f), '%m', '%m']);
			}
		},
		"rst NN" => sub {
			my($cpu) = @_;
			if ($cpu =~ /^r\dk/) {
				add_opcode($cpu, "rst %c", [0xC7."+(%c<8?%c*8:%c)"],
						   [0x10,0x18,0x20,0x28,0x38]);
			}
			elsif ($cpu =~ /^ez80/) {
				add_opcode_ez80_s_l($cpu, "rst %c", [0xC7."+(%c<8?%c*8:%c)"],
						   [0,8,0x10,0x18,0x20,0x28,0x30,0x38]);
			}
			else {
				add_opcode($cpu, "rst %c", [0xC7."+(%c<8?%c*8:%c)"],
						   [0,8,0x10,0x18,0x20,0x28,0x30,0x38]);
			}
		},
		"ret" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ret", [0xC9]);
		},
		"r<f>" => sub {
			my($cpu) = @_;
			for my $f (cpu_flags($cpu)) {
				add_opcode($cpu, "r$f", [0xC0+8*F($f)]);
			}
		},
		"r_<f>" => sub {
			my($cpu) = @_;
			for my $f (cpu_flags($cpu)) {
				add_opcode($cpu, "r_$f", [0xC0+8*F($f)]);
			}
		},
		"ret <f>" => sub {
			my($cpu) = @_;
			for my $f (cpu_flags($cpu)) {
				add_opcode($cpu, "ret $f", [0xC0+8*F($f)]);
			}
		},
		"push/pop <r>" => sub {
			my($cpu) = @_;
			for my $rp ('b', 'd', 'h', 'psw') {
				add_opcode($cpu, "push $rp", [0xC5+16*RP($rp)]);
				add_opcode($cpu, "pop $rp", [0xC1+16*RP($rp)]);
			}
		},
		"push/pop <rp>" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'hl', 'af') {
				add_opcode($cpu, "push $rp", [0xC5+16*RP($rp)]);
				add_opcode($cpu, "pop $rp", [0xC1+16*RP($rp)]);
			}
		},
		"push/pop <x>" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode($cpu, "push $x", [PFX($x), 0xE5]);
				add_opcode($cpu, "pop $x", [PFX($x), 0xE1]);
			}
		},
		"xthl [8080]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "xthl", [0xE3]);
		},
		"ex (sp), hl" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ex (sp), hl", [0xE3]);
		},
		"ex (sp), <x>" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode($cpu, "ex (sp), $x", [PFX($x), 0xE3]);
			}
		},
		"sphl [8080]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "sphl", [0xF9]);
		},
		"ld sp, hl" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ld sp, hl", [0xF9]);
		},
		"ld sp, <x>" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode($cpu, "ld sp, $x", [PFX($x), 0xF9]);
			}
		},
		"in N [8080]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "in %n", [0xDB, '%n']);
		},
		"in a, (N)" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "in a, (%n)", [0xDB, '%n']);
		},
		"out N [8080]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "out %n", [0xD3, '%n']);
		},
		"out (N), a" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "out (%n), a", [0xD3, '%n']);
		},
		"in <r>, (c)" => sub {
			my($cpu) = @_;
			for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
				add_opcode($cpu, "in $r, (c)", [0xED, 0x40+8*R($r)]);
			}
		},
		"in <r>, (bc)" => sub {
			my($cpu) = @_;
			for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
				add_opcode($cpu, "in $r, (bc)", [0xED, 0x40+8*R($r)]);
			}
		},
		"out (c), <r>" => sub {
			my($cpu) = @_;
			for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
				add_opcode($cpu, "out (c), $r", [0xED, 0x41+8*R($r)]);
			}
		},
		"out (bc), <r>" => sub {
			my($cpu) = @_;
			for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
				add_opcode($cpu, "out (bc), $r", [0xED, 0x41+8*R($r)]);
			}
		},
		"in f, (c) [r800]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "in f, (c)", [0xED, 0x40+8*6]);
		},
		"in f, (bc) [r800]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "in f, (bc)", [0xED, 0x40+8*6]);
		},
		"in/out-undoc" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "in (c)", [0xED, 0x40+8*6]);
			add_opcode($cpu, "in (bc)", [0xED, 0x40+8*6]);
			add_opcode($cpu, "in f, (c)", [0xED, 0x40+8*6]);
			add_opcode($cpu, "in f, (bc)", [0xED, 0x40+8*6]);
			add_opcode($cpu, "out (c), %c", [0xED, 0x41+8*6], [0]);
			add_opcode($cpu, "out (bc), %c", [0xED, 0x41+8*6], [0]);
			add_opcode($cpu, "out (c), f", [0xED, 0x41+8*6]);
			add_opcode($cpu, "out (bc), f", [0xED, 0x41+8*6]);
		},
		"in/out-undoc [r800]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "in (c)", [0xED, 0x40+8*6]);
			add_opcode($cpu, "in (bc)", [0xED, 0x40+8*6]);
			add_opcode($cpu, "out (c), %c", [0xED, 0x41+8*6], [0]);
			add_opcode($cpu, "out (bc), %c", [0xED, 0x41+8*6], [0]);
			add_opcode($cpu, "out (c), f", [0xED, 0x41+8*6]);
			add_opcode($cpu, "out (bc), f", [0xED, 0x41+8*6]);
		},
		"ei/di" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ei", [0xFB]);
			add_opcode($cpu, "di", [0xF3]);
		},
		"hlt [8080]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "hlt", [0x76]);
		},
		"halt" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "halt", [0x76]);
		},
		"nop" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "nop", [0x00]);
		},
		"im N" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "im %c", 
					   [0xED, "%c==0?0x46:%c==1?0x56:0x5E"], 
					   [0, 1, 2]);
		},
		"ld i/r, a" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ld i, a", [0xED, 0x47]);
			add_opcode($cpu, "ld a, i", [0xED, 0x57]);
			add_opcode($cpu, "ld r, a", [0xED, 0x4F]);
			add_opcode($cpu, "ld a, r", [0xED, 0x5F]);
		},
		"reti" => sub {
			my($cpu) = @_;
			if ($cpu =~ /gbz80/) {
				add_opcode($cpu, "reti", [0xD9]);
			}
			else {
				add_opcode($cpu, "reti", [0xED, 0x4D]);
			}
		},
		"retn" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "retn", [0xED, 0x45]);
		},
		"neg" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "neg", [0xED, 0x44]);
		},
		"neg a" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "neg a", [0xED, 0x44]);
		},
		"rld/rrd" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "rld", [0xED, 0x6F]);
			add_opcode($cpu, "rrd", [0xED, 0x67]);
		},
		"ldi/ldir/ldd/lddr" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ldi", [0xED, 0xA0]);
			add_opcode($cpu, "ldir", [0xED, 0xB0]);
			add_opcode($cpu, "ldd", [0xED, 0xA8]);
			add_opcode($cpu, "lddr", [0xED, 0xB8]);
		},
		"ldi/ldir/ldd/lddr [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_io($cpu, "ldi", [0xED, 0xA0]);
			add_opcode_rabbit_io($cpu, "ldir", [0xED, 0xB0]);
			add_opcode_rabbit_io($cpu, "ldd", [0xED, 0xA8]);
			add_opcode_rabbit_io($cpu, "lddr", [0xED, 0xB8]);
		},
		"lddsr/ldisr [r3k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_io($cpu, "lddsr", [0xED, 0x98]);
			add_opcode_rabbit_io($cpu, "ldisr", [0xED, 0x90]);
		},
		"cpi/cpir/cpd/cpdr" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "cpi", [0xED, 0xA1]);
			add_opcode($cpu, "cpir", [0xED, 0xB1]);
			add_opcode($cpu, "cpd", [0xED, 0xA9]);
			add_opcode($cpu, "cpdr", [0xED, 0xB9]);
		},
		"ini/inir/ind/indr" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ini", [0xED, 0xA2]);
			add_opcode($cpu, "inir", [0xED, 0xB2]);
			add_opcode($cpu, "ind", [0xED, 0xAA]);
			add_opcode($cpu, "indr", [0xED, 0xBA]);
		},
		"outi/otir/outd/otdr" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "outi", [0xED, 0xA3]);
			add_opcode($cpu, "otir", [0xED, 0xB3]);
			add_opcode($cpu, "outd", [0xED, 0xAB]);
			add_opcode($cpu, "otdr", [0xED, 0xBB]);
		},
		"ld a, (hl+) [gbz80]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ld a, (hl+)", [0x2A]);
			add_opcode($cpu, "ld a, (hli)", [0x2A]);
			add_opcode($cpu, "ldi a, (hl)", [0x2A]);
			add_opcode($cpu, "ld a, (hl-)", [0x3A]);
			add_opcode($cpu, "ld a, (hld)", [0x3A]);
			add_opcode($cpu, "ldd a, (hl)", [0x3A]);
			add_opcode($cpu, "ld (hl-), a", [0x32]);
			add_opcode($cpu, "ld (hld), a", [0x32]);
			add_opcode($cpu, "ldd (hl), a", [0x32]);
			add_opcode($cpu, "ld (hl+), a", [0x22]);
			add_opcode($cpu, "ld (hli), a", [0x22]);
			add_opcode($cpu, "ldi (hl), a", [0x22]);
		},
		"ldh a, (c) [gbz80]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ld a, (c)", [0xF2]);
			add_opcode($cpu, "ld (c), a", [0xE2]);
			add_opcode($cpu, "ldh a, (c)", [0xF2]);
			add_opcode($cpu, "ldh (c), a", [0xE2]);
		},
		"ldh a, (N) [gbz80]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ldh a, (%h)", [0xF0, '%h']);
			add_opcode($cpu, "ldh (%h), a", [0xE0, '%h']);
		},
		"swap <r> [gbz80]" => sub {
			my($cpu) = @_;
			for my $r ('b', 'c', 'd', 'e', 'h', 'l', '(hl)', 'a') {
				add_opcode($cpu, "swap $r", [0xCB, 0x30+R($r)]);
			}
		},
		"stop [gbz80]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "stop", [0x10, 0]);
		},
		"rim/sim [8085]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "rim", [0x20]);
			add_opcode($cpu, "sim", [0x30]);
		},
		"dsub [8085]" => sub {
			my($cpu) = @_;
			for my $asm ('dsub', 'sub hl, bc') {
				add_opcode($cpu, $asm, [0x08]);
			}
		},
		"arhl [8085]" => sub {
			my($cpu) = @_;
			for my $asm ('arhl', 'rrhl', 'sra hl') {
				add_opcode($cpu, $asm, [0x10]);
			}
		},
		"rdel [8085]" => sub {
			my($cpu) = @_;
			for my $asm ('rdel', 'rlde', 'rl de') {
				add_opcode($cpu, $asm, [0x18]);
			}
		},
		"ldhi N [8085]" => sub {
			my($cpu) = @_;
			for my $asm ('ldhi %n', 'adi hl, %n') {
				add_opcode($cpu, $asm, [0x28, '%n']);
			}
			add_opcode($cpu, "ld de, hl+%n", [0x28, '%n']);
		},
		"ldsi N [8085]" => sub {
			my($cpu) = @_;
			for my $asm ('ldsi %n', 'adi sp, %n') {
				add_opcode($cpu, $asm, [0x38, '%n']);
			}
			add_opcode($cpu, "ld de, sp+%n", [0x38, '%n']);
			add_opcode($cpu, "ld de, sp", [0x38, 0]);
		},
		"ldhl sp, N [gbz80]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ldhl sp, %d", [0xF8, '%d']);
			add_opcode($cpu, "ld hl, sp+%d", [0xF8, '%d']);
			add_opcode($cpu, "ld hl, sp", [0xF8, 0]);
		},
		"ld (NN), sp [gbz80]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ld (%m), sp", [0x08, '%m', '%m']);
		},
		"add sp, N [gbz80]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "add sp, %d", [0xE8, '%d']);
		},
		"rstv [8085]" => sub {
			my($cpu) = @_;
			for my $asm ('rstv', 'ovrst8') {
				add_opcode($cpu, $asm, [0xCB]);
			}
			add_opcode($cpu, "rst v, %c", [0xCB], [0x40]);
		},
		"shlx [8085]" => sub {
			my($cpu) = @_;
			for my $asm ('shlx', 'shlde', 'ld (de), hl') {
				add_opcode($cpu, $asm, [0xD9]);
			}
		},
		"lhlx [8085]" => sub {
			my($cpu) = @_;
			for my $asm ('lhlx', 'lhlde', 'ld hl, (de)') {
				add_opcode($cpu, $asm, [0xED]);
			}
		},
		"jx5/jnx5 [8085]" => sub {
			my($cpu) = @_;
			for my $asm ('jx5 %m', 'jk %m', 
						 'jp x5, %m', 'jp k, %m', 
						 'jmp x5, %m', 'jmp k, %m') {
				add_opcode($cpu, $asm, [0xFD, '%m', '%m']);
			}
			for my $asm ('jnx5 %m', 'jnk %m', 
						 'jp nx5, %m', 'jp nk, %m', 
						 'jmp nx5, %m', 'jmp nk, %m') {
				add_opcode($cpu, $asm, [0xDD, '%m', '%m']);
			}
		},
		"in0 <r>, (N) [z180]" => sub {
			my($cpu) = @_;
			for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
				add_opcode($cpu, "in0 $r, (%n)", [0xED, 0x00+8*R($r), '%n']);
			}
		},
		"out0 (N), <r> [z180]" => sub {
			my($cpu) = @_;
			for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
				add_opcode($cpu, "out0 (%n), $r", [0xED, 0x01+8*R($r), '%n']);
			}
		},
		"tst <r> [z180]" => sub {
			my($cpu) = @_;
			for my $r ('b', 'c', 'd', 'e', 'h', 'l', '(hl)', 'a') {
				if (!get_opcode($cpu, "tst $r")) {
					add_opcode($cpu, "tst $r", [0xED, 0x04+8*R($r)]);
				}
			}
		},
		"tst a, <r> [z180]" => sub {
			my($cpu) = @_;
			for my $r ('b', 'c', 'd', 'e', 'h', 'l', '(hl)', 'a') {
				if (!get_opcode($cpu, "tst a, $r")) {
					add_opcode($cpu, "tst a, $r", [0xED, 0x04+8*R($r)]);
				}
			}
		},
		"test <r> [z180]" => sub {
			my($cpu) = @_;
			for my $r ('b', 'c', 'd', 'e', 'h', 'l', '(hl)', 'a') {
				if (!get_opcode($cpu, "test $r")) {
					add_opcode($cpu, "test $r", [0xED, 0x04+8*R($r)]);
				}
			}
		},
		"test a, <r> [z180]" => sub {
			my($cpu) = @_;
			for my $r ('b', 'c', 'd', 'e', 'h', 'l', '(hl)', 'a') {
				if (!get_opcode($cpu, "test a, $r")) {
					add_opcode($cpu, "test a, $r", [0xED, 0x04+8*R($r)]);
				}
			}
		},
		"tst N [z180]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "tst %n", [0xED, 0x64, '%n']);
		},
		"tst a, N [z180]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "tst a, %n", [0xED, 0x64, '%n']);
		},
		"test N [z180]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "test %n", [0xED, 0x64, '%n']);
		},
		"test a, N [z180]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "test a, %n", [0xED, 0x64, '%n']);
		},
		"tstio N [z180]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "tstio %n", [0xED, 0x74, '%n']);
		},
		"slp [z180]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "slp", [0xED, 0x76]);
		},
		"mlt <rp> [z180]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'hl', 'sp') {
				add_opcode($cpu, "mlt $rp", [0xED, 0x4C+16*RP($rp)]);
			}
		},
		"otim/otimr/otdm/otdmr [z180]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "otim",  [0xED, 0x83]);
			add_opcode($cpu, "otimr", [0xED, 0x93]);
			add_opcode($cpu, "otdm",  [0xED, 0x8B]);
			add_opcode($cpu, "otdmr", [0xED, 0x9B]);
		},
		"swapnib [z80n]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "swapnib",  [0xED, 0x23]);
			add_opcode($cpu, "swap",  [0xED, 0x23]);
		},
		"swap a [z80n]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "swap a",  [0xED, 0x23]);
		},
		"mirror a [z80n]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "mirror a",  [0xED, 0x24]);
			add_opcode($cpu, "mirr",  [0xED, 0x24]);
		},
		"test N [z80n]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "test %n",  [0xED, 0x27, '%n']);
		},
		"test a, N [z80n]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "test a, %n",  [0xED, 0x27, '%n']);
		},
		"tst N [z80n]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "tst %n",  [0xED, 0x27, '%n']);
		},
		"tst a, N [z80n]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "tst a, %n",  [0xED, 0x27, '%n']);
		},
		"bsla/bsra/bsrl/bsrf/brlc [z80n]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "bsla de, b",  [0xED, 0x28]);
			add_opcode($cpu, "bsra de, b",  [0xED, 0x29]);
			add_opcode($cpu, "bsrl de, b",  [0xED, 0x2A]);
			add_opcode($cpu, "bsrf de, b",  [0xED, 0x2B]);
			add_opcode($cpu, "brlc de, b",  [0xED, 0x2C]);
		},
		"mul d, e [z80n]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "mul de",  [0xED, 0x30]);
			add_opcode($cpu, "mul d, e",  [0xED, 0x30]);
		},
		"mlt de [z80n]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "mlt de",  [0xED, 0x30]);
		},
		"add <rp>, a [z80n]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "add hl, a",  [0xED, 0x31]);
			add_opcode($cpu, "add de, a",  [0xED, 0x32]);
			add_opcode($cpu, "add bc, a",  [0xED, 0x33]);
		},
		"add <rp>, NN [z80n]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "add hl, %m",  [0xED, 0x34, '%m', '%m']);
			add_opcode($cpu, "add de, %m",  [0xED, 0x35, '%m', '%m']);
			add_opcode($cpu, "add bc, %m",  [0xED, 0x36, '%m', '%m']);
		},
		"push NN [z80n]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "push %M",  [0xED, 0x8A, '%M', '%M']);
		},
		"outinb [z80n]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "outinb",  [0xED, 0x90]);
			add_opcode($cpu, "otib",  [0xED, 0x90]);
		},
		"nextreg N, N [z80n]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "nextreg %n, %n",  [0xED, 0x91, '%n', '%n']);
			add_opcode($cpu, "nreg %n, %n",  [0xED, 0x91, '%n', '%n']);
		},
		"nextreg N, a [z80n]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "nextreg %n, a",  [0xED, 0x92, '%n']);
			add_opcode($cpu, "nreg %n, a",  [0xED, 0x92, '%n']);
		},
		"pixeldn/pixelad [z80n]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "pixeldn",  [0xED, 0x93]);
			add_opcode($cpu, "pxdn",  [0xED, 0x93]);
			add_opcode($cpu, "pixelad",  [0xED, 0x94]);
			add_opcode($cpu, "pxad",  [0xED, 0x94]);
		},
		"setae [z80n]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "setae",  [0xED, 0x95]);
			add_opcode($cpu, "stae",  [0xED, 0x95]);
		},
		"jp (c) [z80n]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "jp (c)",  [0xED, 0x98]);
		},
		"jmp (c) [z80n]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "jmp (c)",  [0xED, 0x98]);
		},
		"ldix/ldws/lddx/ldirx/ldpirx/lddrx [z80n]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ldix",  [0xED, 0xA4]);
			add_opcode($cpu, "ldws",  [0xED, 0xA5]);
			add_opcode($cpu, "lddx",  [0xED, 0xAC]);

			add_opcode($cpu, "ldirx",  [0xED, 0xB4]);
			add_opcode($cpu, "lirx",  [0xED, 0xB4]);

			add_opcode($cpu, "ldpirx",  [0xED, 0xB7]);
			add_opcode($cpu, "lprx",  [0xED, 0xB7]);

			add_opcode($cpu, "lddrx",  [0xED, 0xBC]);
			add_opcode($cpu, "ldrx",  [0xED, 0xBC]);
		},
		"mmu <b>, N [z80n]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "mmu %c, %n",  [0xED, 0x91, 0x50."+%c", '%n'], [0..7]);
		},
		"mmu<b> N [z80n]" => sub {
			my($cpu) = @_;
			for my $b (0..7) {
				add_opcode($cpu, "mmu$b %n",  [0xED, 0x91, 0x50+$b, '%n']);
			}
		},
		"mmu <b>, a [z80n]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "mmu %c, a",  [0xED, 0x92, 0x50."+%c"], [0..7]);
		},
		"mmu<b> a [z80n]" => sub {
			my($cpu) = @_;
			for my $b (0..7) {
				add_opcode($cpu, "mmu$b a",  [0xED, 0x92, 0x50+$b]);
			}
		},
		"<alu> a, (hl) [ez80]" => sub {
			my($cpu) = @_;
			for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp') {
				if (!get_opcode($cpu, "$alu a, (hl)")) {
					add_opcode_ez80_s_l($cpu, "$alu a, (hl)", 
									[0x86+8*ALU($alu)]);
				}
			}
		},
		"<alu-extra> a, (hl) [ez80]" => sub {
			my($cpu) = @_;
			for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp', 'cmp') {
				for my $a_ ("a, ", "") {
					if (!get_opcode($cpu, "$alu $a_(hl)")) {
						add_opcode_ez80_s_l($cpu, "$alu $a_(hl)", 
										[0x86+8*ALU($alu)]);
					}
				}
			}
		},
		"<alu> a, <x8> [ez80]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp') {
					for my $r ($x.'h', $x.'l') {
						if (!get_opcode($cpu, "$alu a, $r")) {
							add_opcode($cpu, "$alu a, $r", 
										[PFX($x), 0x80+8*ALU($alu)+R($r)]);
						}
					}
				}
			}
		},
		"<alu> a, (<x>+DIS) [ez80]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp') {
					if (!get_opcode($cpu, "$alu a, ($x+%d)")) {
						add_opcode_ez80_s_l($cpu, "$alu a, ($x+%d)", 
									[PFX($x), 0x86+8*ALU($alu), '%d']);
					}
				}
			}
		},
		"<alu-extra> a, (<x>+DIS) [ez80]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp', 'cmp') {
					for my $a_ ("a, ", "") {
						if (!get_opcode($cpu, "$alu $a_($x+%d)")) {
							add_opcode_ez80_s_l($cpu, "$alu $a_($x+%d)", 
										[PFX($x), 0x86+8*ALU($alu), '%d']);
						}
					}
				}
			}
		},
		"sbc/adc hl, <rp> [ez80]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'hl', 'sp') {
				add_opcode_ez80_s_l($cpu, "sbc hl, $rp", [0xED, 0x42+16*RP($rp)]);
				add_opcode_ez80_s_l($cpu, "adc hl, $rp", [0xED, 0x4A+16*RP($rp)]);
			}
		},
		"add hl, <rp> [ez80]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'hl', 'sp') {
				add_opcode_ez80_s_l($cpu, "add hl, $rp", [0x09+16*RP($rp)]);
			}
		},
		"add <x>, <rp> [ez80]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $rp ('bc', 'de', $x, 'sp') {
					add_opcode_ez80_s_l($cpu, "add $x, $rp", 
									[PFX($x), 0x09+16*RP($rp)]);
				}
			}
		},
		"<bit> <b>, (hl) [ez80]" => sub {
			my($cpu) = @_;
			for my $op ('bit', 'res', 'set') {				
				add_opcode_ez80_s_l($cpu, "$op %c, (hl)", 
						   [0xCB, (0x40*BIT($op)+6)."+8*%c"],
						   [0, 1, 2, 3, 4, 5, 6, 7]);
			}
		},
		"<bit> <b>, (<x>+DIS) [ez80]" => sub {
			my($cpu) = @_;
			for my $op ('bit', 'res', 'set') {
				for my $x ('ix', 'iy') {
					add_opcode_ez80_s_l($cpu, "$op %c, ($x+%d)",
							   [PFX($x), 0xCB, '%d', (0x40*BIT($op)+6)."+8*%c"],
							   [0, 1, 2, 3, 4, 5, 6, 7]);
				}
			}
		},
		"call <f>, NN [ez80]" => sub {
			my($cpu) = @_;
			for my $f (cpu_flags($cpu)) {
				add_opcode_ez80_call($cpu, "call $f, %m", 
							   [0xC4+8*F($f), '%m', '%m']);
			}
		},
		"call NN [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_call($cpu, "call %m", [0xCD, '%m', '%m']);
		},
		"c<flag> NN [ez80]" => sub {
			my($cpu) = @_;
			my $adl_mode = $cpu =~ /ez80_z80/ ? 0 : 1;
			for my $f (cpu_flags($cpu)) {
				next if $f eq 'p';
				if ($adl_mode) {
					add_opcode($cpu, "c$f %m", [0xC4+8*F($f), '%m', '%m', '%m']);
				}
				else {
					add_opcode($cpu, "c$f %m", [0xC4+8*F($f), '%m', '%m']);
				}
			}
		},
		"c_<f> NN [ez80]" => sub {
			my($cpu) = @_;
			my $adl_mode = $cpu =~ /ez80_z80/ ? 0 : 1;
			for my $f (cpu_flags($cpu)) {
				if ($adl_mode) {
					add_opcode($cpu, "c_$f %m", [0xC4+8*F($f), '%m', '%m', '%m']);
				}
				else {
					add_opcode($cpu, "c_$f %m", [0xC4+8*F($f), '%m', '%m']);
				}
			}
		},
		"cpi/cpir/cpd/cpdr [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_s_l($cpu, "cpi", [0xED, 0xA1]);
			add_opcode_ez80_s_l($cpu, "cpir", [0xED, 0xB1]);
			add_opcode_ez80_s_l($cpu, "cpd", [0xED, 0xA9]);
			add_opcode_ez80_s_l($cpu, "cpdr", [0xED, 0xB9]);
		},
		"inc/dec (hl) [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_s_l($cpu, "inc (hl)", [0x04+8*6]);
			add_opcode_ez80_s_l($cpu, "dec (hl)", [0x05+8*6]);
		},
		"inc/dec <x> [ez80]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode_ez80_s_l($cpu, "inc $x", [PFX($x), 0x03+16*2]);
				add_opcode_ez80_s_l($cpu, "dec $x", [PFX($x), 0x0B+16*2]);
			}
		},
		"inc/dec (<x>+DIS) [ez80]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode_ez80_s_l($cpu, "inc ($x+%d)", 
							[PFX($x), 0x04+8*6, '%d']);
				add_opcode_ez80_s_l($cpu, "dec ($x+%d)", 
							[PFX($x), 0x05+8*6, '%d']);
			}
		},
		"inc/dec <rp> [ez80]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'hl', 'sp') {
				add_opcode_ez80_s_l($cpu, "inc $rp", [0x03+16*RP($rp)]);
				add_opcode_ez80_s_l($cpu, "dec $rp", [0x0B+16*RP($rp)]);
			}
		},
		"ex (sp), hl [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_s_l($cpu, "ex (sp), hl", [0xE3]);
		},
		"ex (sp), <x> [ez80]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode_ez80_s_l($cpu, "ex (sp), $x", [PFX($x), 0xE3]);
			}
		},
		"ini/inir/ind/indr [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_s_l($cpu, "ini", [0xED, 0xA2]);
			add_opcode_ez80_s_l($cpu, "inir", [0xED, 0xB2]);
			add_opcode_ez80_s_l($cpu, "ind", [0xED, 0xAA]);
			add_opcode_ez80_s_l($cpu, "indr", [0xED, 0xBA]);
		},
		"ini2/ini2r/ind2/ind2r [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_s_l($cpu, "ini2", [0xED, 0x84]);
			add_opcode_ez80_s_l($cpu, "ini2r", [0xED, 0x94]);
			add_opcode_ez80_s_l($cpu, "ind2", [0xED, 0x8C]);
			add_opcode_ez80_s_l($cpu, "ind2r", [0xED, 0x9C]);
		},
		"inim/inimr/indm/indmr [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_s_l($cpu, "inim", [0xED, 0x82]);
			add_opcode_ez80_s_l($cpu, "inimr", [0xED, 0x92]);
			add_opcode_ez80_s_l($cpu, "indm", [0xED, 0x8A]);
			add_opcode_ez80_s_l($cpu, "indmr", [0xED, 0x9A]);
		},
		"inirx/indrx [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_s_l($cpu, "inirx", [0xED, 0xC2]);
			add_opcode_ez80_s_l($cpu, "indrx", [0xED, 0xCA]);
		},
		"outi/otir/outd/otdr/outi2/outd2 [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_s_l($cpu, "outi", [0xED, 0xA3]);
			add_opcode_ez80_s_l($cpu, "otir", [0xED, 0xB3]);
			add_opcode_ez80_s_l($cpu, "outd", [0xED, 0xAB]);
			add_opcode_ez80_s_l($cpu, "otdr", [0xED, 0xBB]);
			add_opcode_ez80_s_l($cpu, "outi2", [0xED, 0xA4]);
			add_opcode_ez80_s_l($cpu, "outd2", [0xED, 0xAC]);
		},
		"jp <f>, NN [ez80]" => sub {
			my($cpu) = @_;
			for my $f (cpu_flags($cpu)) {
				add_opcode_ez80_jump($cpu, "jp $f, %m", 
						[0xC2+8*F($f), '%m', '%m']);
			}
		},
		"jmp <f>, NN [ez80]" => sub {
			my($cpu) = @_;
			for my $f (cpu_flags($cpu)) {
				add_opcode_ez80_jump($cpu, "jmp $f, %m", 
						[0xC2+8*F($f), '%m', '%m']);
			}
		},
		"j<f> NN [ez80]" => sub {
			my($cpu) = @_;
			my $adl_mode = $cpu =~ /ez80_z80/ ? 0 : 1;
			for my $f (cpu_flags($cpu)) {
				next if $f eq 'p';
				if ($adl_mode) {
					add_opcode($cpu, "j$f %m", [0xC2+8*F($f), '%m', '%m', '%m']);
				}
				else {
					add_opcode($cpu, "j$f %m", [0xC2+8*F($f), '%m', '%m']);
				}
			}
		},
		"j_<f> NN [ez80]" => sub {
			my($cpu) = @_;
			my $adl_mode = $cpu =~ /ez80_z80/ ? 0 : 1;
			for my $f (cpu_flags($cpu)) {
				if ($adl_mode) {
					add_opcode($cpu, "j_$f %m", [0xC2+8*F($f), '%m', '%m', '%m']);
				}
				else {
					add_opcode($cpu, "j_$f %m", [0xC2+8*F($f), '%m', '%m']);
				}
			}
		},
		"jp (hl) [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_s_l($cpu, "jp (hl)", [0xE9]);
		},
		"jmp (hl) [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_s_l($cpu, "jmp (hl)", [0xE9]);
		},
		"jp (<x>) [ez80]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode_ez80_s_l($cpu, "jp ($x)", [PFX($x), 0xE9]);
			}
		},
		"jmp (<x>) [ez80]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode_ez80_s_l($cpu, "jmp ($x)", [PFX($x), 0xE9]);
			}
		},
		"jp NN [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_jump($cpu, "jp %m", [0xC3, '%m', '%m']);
		},
		"jmp NN [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_jump($cpu, "jmp %m", [0xC3, '%m', '%m']);
		},
		"ld (<x>+DIS), <r> [ez80]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
					add_opcode_ez80_s_l($cpu, "ld $r, ($x+%d)", 
							[PFX($x), 0x40+8*R($r)+6, '%d']);
					add_opcode_ez80_s_l($cpu, "ld ($x+%d), $r", 
							[PFX($x), 0x40+8*6+R($r), '%d']);
				}
			}
		},
		"ld mb, a [ez80]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ld a, mb", [0xED, 0x6E]);
			add_opcode($cpu, "ld mb, a", [0xED, 0x6D]);
		},
		"lda/sta [ez80]" => sub {
			my($cpu) = @_;
			if ($cpu =~ /gbz80/) {
				add_opcode($cpu, "sta %m", [0xEA, '%m', '%m']);
				add_opcode($cpu, "lda %m", [0xFA, '%m', '%m']);
			} 
			else {
				my $adl_mode = $cpu =~ /ez80_z80/ ? 0 : 1;
				if ($adl_mode) {
					add_opcode($cpu, "sta %m", [0x32, '%m', '%m', '%m']);
					add_opcode($cpu, "lda %m", [0x3A, '%m', '%m', '%m']);
				}
				else {
					add_opcode($cpu, "sta %m", [0x32, '%m', '%m']);
					add_opcode($cpu, "lda %m", [0x3A, '%m', '%m']);
				}
			}
		},
		"ld a, (NN) [ez80]" => sub {
			my($cpu) = @_;
			if ($cpu =~ /gbz80/) {
				add_opcode($cpu, "ld (%m), a", [0xEA, '%m', '%m']);
				add_opcode($cpu, "ld a, (%m)", [0xFA, '%m', '%m']);
			} 
			else {
				add_opcode_ez80_is_il($cpu, "ld (%m), a", 
									[0x32, '%m', '%m']);
				add_opcode_ez80_sis_lil($cpu, "ld a, (%m)", 
									[0x3A, '%m', '%m']);
			}
		},
		"ld a, (<rp>) [ez80]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de') {
				add_opcode_ez80_s_l($cpu, "ld a, ($rp)", [0x0A+16*RP($rp)]);
				add_opcode_ez80_s_l($cpu, "ld ($rp), a", [0x02+16*RP($rp)]);
			}
		},
		"ld (hl), <r> [ez80]" => sub {
			my($cpu) = @_;
			for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
				add_opcode_ez80_s_l($cpu, "ld $r, (hl)", [0x40+8*R($r)+6]);
				add_opcode_ez80_s_l($cpu, "ld (hl), $r", [0x40+8*6+R($r)]);
			}
		},
		"ld (hl), <rp> [ez80]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'hl') {
				add_opcode_ez80_s_l($cpu, "ld $rp, (hl)", 
						[0xED, 0x07+16*RP($rp)]);
				add_opcode_ez80_s_l($cpu, "ld (hl), $rp", 
						[0xED, 0x0F+16*RP($rp)]);
			}
		},
		"ld i, hl [ez80]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ld hl, i", [0xED, 0xD7]);
			add_opcode($cpu, "ld i, hl", [0xED, 0xC7]);
		},
		"ld (hl), <x> [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_s_l($cpu, "ld (hl), ix", [0xED, 0x3F]);
			add_opcode_ez80_s_l($cpu, "ld (hl), iy", [0xED, 0x3E]);
			add_opcode_ez80_s_l($cpu, "ld ix, (hl)", [0xED, 0x37]);
			add_opcode_ez80_s_l($cpu, "ld iy, (hl)", [0xED, 0x31]);
		},
		"ld (hl), N [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_s_l($cpu, "ld (hl), %n", [0x36, '%n']);
		},
		"ld (<x>+DIS), <x> [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_s_l($cpu, "ld ix, (ix+%d)", [0xDD, 0x37, '%d']);
			add_opcode_ez80_s_l($cpu, "ld iy, (ix+%d)", [0xDD, 0x31, '%d']);
			add_opcode_ez80_s_l($cpu, "ld ix, (iy+%d)", [0xFD, 0x31, '%d']);
			add_opcode_ez80_s_l($cpu, "ld iy, (iy+%d)", [0xFD, 0x37, '%d']);

			add_opcode_ez80_s_l($cpu, "ld (ix+%d), ix", [0xDD, 0x3F, '%d']);
			add_opcode_ez80_s_l($cpu, "ld (ix+%d), iy", [0xDD, 0x3E, '%d']);
			add_opcode_ez80_s_l($cpu, "ld (iy+%d), ix", [0xFD, 0x3E, '%d']);
			add_opcode_ez80_s_l($cpu, "ld (iy+%d), iy", [0xFD, 0x3F, '%d']);
		},
		"lxi <r>, NN [ez80]" => sub {
			my($cpu) = @_;
			my $adl_mode = $cpu =~ /ez80_z80/ ? 0 : 1;
			for my $rp ('b', 'd', 'h', 'sp') {
				if ($adl_mode) {
					add_opcode($cpu, "lxi $rp, %m", [0x01+16*RP($rp), '%m', '%m', '%m']);
				}
				else {
					add_opcode($cpu, "lxi $rp, %m", [0x01+16*RP($rp), '%m', '%m']);
				}
			}
		},
		"lxi <rp>, NN [ez80]" => sub {
			my($cpu) = @_;
			my $adl_mode = $cpu =~ /ez80_z80/ ? 0 : 1;
			for my $rp ('bc', 'de', 'hl') {
				if ($adl_mode) {
					add_opcode($cpu, "lxi $rp, %m", [0x01+16*RP($rp), '%m', '%m', '%m']);
				}
				else {
					add_opcode($cpu, "lxi $rp, %m", [0x01+16*RP($rp), '%m', '%m']);
				}
			}
		},
		"ld <rp>, NN [ez80]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'hl', 'sp') {
				add_opcode_ez80_sis_lil($cpu, "ld $rp, %m", 
							[0x01+16*RP($rp), '%m', '%m']);
				# issue #2423
				add_opcode($cpu, "ld.lis $rp, %m", 
							[0x49, 0x01+16*RP($rp), '%m', '%m']);
			}
		},
		"ld <x>, NN [ez80]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode_ez80_sis_lil($cpu, "ld $x, %m", 
							[PFX($x), 0x21, '%m', '%m']);
				# issue #2423
				add_opcode($cpu, "ld.lis $x, %m", 
							[0x49, PFX($x), 0x21, '%m', '%m']);
			}
		},
		"lhld/shld [ez80]" => sub {
			my($cpu) = @_;
			my $adl_mode = $cpu =~ /ez80_z80/ ? 0 : 1;
			if ($adl_mode) {
				add_opcode($cpu, "shld %m", [0x22, '%m', '%m', '%m']);
				add_opcode($cpu, "lhld %m", [0x2A, '%m', '%m', '%m']);
			}
			else {
				add_opcode($cpu, "shld %m", [0x22, '%m', '%m']);
				add_opcode($cpu, "lhld %m", [0x2A, '%m', '%m']);
			}
		},
		"ld hl, (NN) [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_sis_lil($cpu, "ld (%m), hl", [0x22, '%m', '%m']);
			add_opcode_ez80_sis_lil($cpu, "ld hl, (%m)", [0x2A, '%m', '%m']);
		},
		"ld <x>, (NN) [ez80]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode_ez80_sis_lil($cpu, "ld (%m), $x", 
						[PFX($x), 0x22, '%m', '%m']);
				add_opcode_ez80_sis_lil($cpu, "ld $x, (%m)", 
						[PFX($x), 0x2A, '%m', '%m']);
			}
		},
		"ld <rp>, (NN) [ez80]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'sp') {
				add_opcode_ez80_sis_lil($cpu, "ld (%m), $rp", 
						[0xED, 0x43+16*RP($rp), '%m', '%m']);
				add_opcode_ez80_sis_lil($cpu, "ld $rp, (%m)", 
						[0xED, 0x4B+16*RP($rp), '%m', '%m']);
			}
		},
		"ld (<x>+DIS), N [ez80]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode_ez80_s_l($cpu, "ld ($x+%d), %n", 
						[PFX($x), 0x36, '%d', '%n']);
			}
		},
		"ld (<x>+DIS), <rp> [ez80]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $rp ('bc', 'de', 'hl') {
					add_opcode_ez80_s_l($cpu, "ld ($x+%d), $rp", 
							[PFX($x), 0x0F+16*RP($rp), '%d']);
					add_opcode_ez80_s_l($cpu, "ld $rp, ($x+%d)", 
							[PFX($x), 0x07+16*RP($rp), '%d']);
				}
			}
		},
		"ld sp, hl [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_s_l($cpu, "ld sp, hl", [0xF9]);
		},
		"ld sp, <x> [ez80]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode_ez80_s_l($cpu, "ld sp, $x", [PFX($x), 0xF9]);
			}
		},
		"ldi/ldir/ldd/lddr [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_s_l($cpu, "ldi", [0xED, 0xA0]);
			add_opcode_ez80_s_l($cpu, "ldir", [0xED, 0xB0]);
			add_opcode_ez80_s_l($cpu, "ldd", [0xED, 0xA8]);
			add_opcode_ez80_s_l($cpu, "lddr", [0xED, 0xB8]);
		},
		"lea <rp>, <x>+DIS [ez80]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'hl') {
				add_opcode_ez80_s_l($cpu, "lea $rp, ix+%d", 
							[0xED, 0x02+16*RP($rp), '%d']);
				add_opcode_ez80_s_l($cpu, "lea $rp, iy+%d", 
							[0xED, 0x03+16*RP($rp), '%d']);

				add_opcode_ez80_s_l($cpu, "lea $rp, ix", 
							[0xED, 0x02+16*RP($rp), 0]);
				add_opcode_ez80_s_l($cpu, "lea $rp, iy", 
							[0xED, 0x03+16*RP($rp), 0]);
			}
		},
		"lea <x>, <x>+DIS [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_s_l($cpu, "lea ix, ix+%d", [0xED, 0x32, '%d']);
			add_opcode_ez80_s_l($cpu, "lea iy, ix+%d", [0xED, 0x55, '%d']);
			add_opcode_ez80_s_l($cpu, "lea ix, iy+%d", [0xED, 0x54, '%d']);
			add_opcode_ez80_s_l($cpu, "lea iy, iy+%d", [0xED, 0x33, '%d']);

			add_opcode_ez80_s_l($cpu, "lea ix, ix", [0xED, 0x32, 0]);
			add_opcode_ez80_s_l($cpu, "lea iy, ix", [0xED, 0x55, 0]);
			add_opcode_ez80_s_l($cpu, "lea ix, iy", [0xED, 0x54, 0]);
			add_opcode_ez80_s_l($cpu, "lea iy, iy", [0xED, 0x33, 0]);
		},
		"pea <x>+DIS [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_s_l($cpu, "pea ix+%d", [0xED, 0x65, '%d']);
			add_opcode_ez80_s_l($cpu, "pea iy+%d", [0xED, 0x66, '%d']);

			add_opcode_ez80_s_l($cpu, "pea ix", [0xED, 0x65, 0]);
			add_opcode_ez80_s_l($cpu, "pea iy", [0xED, 0x66, 0]);
		},
		"otim/otimr/otdm/otdmr [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_s_l($cpu, "otim",  [0xED, 0x83]);
			add_opcode_ez80_s_l($cpu, "otimr", [0xED, 0x93]);
			add_opcode_ez80_s_l($cpu, "otdm",  [0xED, 0x8B]);
			add_opcode_ez80_s_l($cpu, "otdmr", [0xED, 0x9B]);
		},
		"oti2r/otirx/otd2r/otdrx [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_s_l($cpu, "oti2r",  [0xED, 0xB4]);
			add_opcode_ez80_s_l($cpu, "otirx",  [0xED, 0xC3]);
			add_opcode_ez80_s_l($cpu, "otd2r",  [0xED, 0xBC]);
			add_opcode_ez80_s_l($cpu, "otdrx",  [0xED, 0xCB]);
		},
		"push/pop <r> [ez80]" => sub {
			my($cpu) = @_;
			for my $rp ('b', 'd', 'h', 'psw') {
				add_opcode($cpu, "push $rp", [0xC5+16*RP($rp)]);
				add_opcode($cpu, "pop $rp", [0xC1+16*RP($rp)]);
			}
		},
		"push/pop <rp> [ez80]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'hl', 'af') {
				add_opcode_ez80_s_l($cpu, "push $rp", [0xC5+16*RP($rp)]);
				add_opcode_ez80_s_l($cpu, "pop $rp", [0xC1+16*RP($rp)]);
			}
		},
		"push/pop <x> [ez80]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode_ez80_s_l($cpu, "push $x", [PFX($x), 0xE5]);
				add_opcode_ez80_s_l($cpu, "pop $x", [PFX($x), 0xE1]);
			}
		},
		"ret [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_ret($cpu, "ret", [0xC9]);
		},
		"ret <f> [ez80]" => sub {
			my($cpu) = @_;
			for my $f (cpu_flags($cpu)) {
				add_opcode_ez80_ret($cpu, "ret $f", [0xC0+8*F($f)]);
			}
		},
		"reti [ez80]" => sub {
			my($cpu) = @_;
			if ($cpu =~ /gbz80/) {
				add_opcode($cpu, "reti", [0xD9]);
			}
			else {
				add_opcode_ez80_ret($cpu, "reti", [0xED, 0x4D]);
			}
		},
		"retn [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_ret($cpu, "retn", [0xED, 0x45]);
		},
		"<rot> (hl) [ez80]" => sub {
			my($cpu) = @_;
			for my $op ('rlc', 'rrc', 'rl', 'rr', 'sla', 'sra', 'srl') {
				add_opcode_ez80_s_l($cpu, "$op (hl)", [0xCB, 8*ROT($op)+6]);
			}
		},
		"<rot> (<x>+DIS) [ez80]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $op ('rlc', 'rrc', 'rl', 'rr', 'sla', 'sra', 'srl') {
					add_opcode_ez80_s_l($cpu, "$op ($x+%d)", 
							   		[PFX($x), 0xCB, '%d', 8*ROT($op)+6]);
				}
			}
		},
		"rsmix/stmix [ez80]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "rsmix", [0xED, 0x7E]);
			add_opcode($cpu, "stmix", [0xED, 0x7D]);
		},
		"tst a, (hl) [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_s_l($cpu, "tst a, (hl)", [0xED, 0x04+8*6]);
		},
		"tst (hl) [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_s_l($cpu, "tst (hl)", [0xED, 0x04+8*6]);
		},
		"test a, (hl) [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_s_l($cpu, "test a, (hl)", [0xED, 0x04+8*6]);
		},
		"test (hl) [ez80]" => sub {
			my($cpu) = @_;
			add_opcode_ez80_s_l($cpu, "test (hl)", [0xED, 0x04+8*6]);
		},
		"mulub a, <r> [r800]" => sub {
			my($cpu) = @_;
			for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
				add_opcode($cpu, "mulub a, $r", [0xED, 0xC1+8*R($r)]);
			}
		},
		"muluw hl, <rp> [r800]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'hl', 'sp') {
				add_opcode($cpu, "muluw hl, $rp", [0xED, 0xC3+16*RP($rp)]);
			}
		},
		"ld (*hl), <r> [kc160]" => sub {
			my($cpu) = @_;
			for my $p ('x', 'y', 'a', 'p', 'z') {
				for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
					add_opcode($cpu, "ld $r, (${p}hl)", [KC_CONST1($p), 0x46+8*R($r)]);
					add_opcode($cpu, "ld (${p}hl), $r", [KC_CONST1($p), 0x70+R($r)]);
				}
			}
		},
		"ld (*hl), N [kc160]" => sub {
			my($cpu) = @_;
			for my $p ('x', 'y', 'a', 'p', 'z') {
				add_opcode($cpu, "ld (${p}hl), %n", [KC_CONST1($p), 0x36, '%n']);
			}
		},
		"ld (*<x>+DIS), <r> [kc160]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $p ('x', 'y', 'a', 'p', 'z') {
					for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
						add_opcode($cpu, "ld $r, (${p}${x}+%d)", [KC_CONST1($p), PFX($x), 0x46+8*R($r), '%d']);
						add_opcode($cpu, "ld (${p}${x}+%d), $r", [KC_CONST1($p), PFX($x), 0x70+R($r), '%d']);
					}
				}
			}
		},
		"ld (*<x>+DIS), N [kc160]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $p ('x', 'y', 'a', 'p', 'z') {
					add_opcode($cpu, "ld (${p}${x}+%d), %n", [KC_CONST1($p), PFX($x), 0x36, '%d', '%n']);
				}
			}
		},
		"ld (*<rp>), a [kc160]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de') {
				for my $p ('x', 'y', 'a', 'p', 'z') {
					add_opcode($cpu, "ld a, (${p}${rp})", [KC_CONST1($p), 0x0A+16*RP($rp)]);
					add_opcode($cpu, "ld (${p}${rp}), a", [KC_CONST1($p), 0x02+16*RP($rp)]);
				}
			}
		},
		"ld (*p:NN), a [kc160]" => sub {
			my($cpu) = @_;
			for my $p ('xp', 'yp', 'a', 'pp', 'zp') {
				add_opcode($cpu, "ld a, (${p}:%m)", [KC_CONST1($p), 0x3A, '%m', '%m']);
				add_opcode($cpu, "ld (${p}:%m), a", [KC_CONST1($p), 0x32, '%m', '%m']);
			}
		},
		"ld *p, a [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ld a, zp",  [0xED, 0xC4]);
			add_opcode($cpu, "ld a, yp",  [0xED, 0xCC]);
			add_opcode($cpu, "ld a, xp",  [0xED, 0xC5]);
			add_opcode($cpu, "ld xp, yp", [0xED, 0xD4]);
			add_opcode($cpu, "ld xp, zp", [0xED, 0xDC]);
			add_opcode($cpu, "ld xp, a",  [0xED, 0xD5]);
			add_opcode($cpu, "ld yp, xp", [0xED, 0xE4]);
			add_opcode($cpu, "ld yp, a",  [0xED, 0xEC]);
			add_opcode($cpu, "ld yp, zp", [0xED, 0xE5]);
			add_opcode($cpu, "ld zp, a",  [0xED, 0xF4]);
			add_opcode($cpu, "ld zp, xp", [0xED, 0xFC]);
			add_opcode($cpu, "ld zp, yp", [0xED, 0xF5]);
		},
		"ldf (NNN), a [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ldf a, (%m)", [0xED, 0x3B, '%m', '%m', '%m']);
			add_opcode($cpu, "ldf (%m), a", [0xED, 0x33, '%m', '%m', '%m']);		
		},
		"ld (*p:NN), hl [kc160]" => sub {
			my($cpu) = @_;
			for my $p ('xp', 'yp', 'a', 'pp', 'zp') {
				add_opcode($cpu, "ld hl, (${p}:%m)", [KC_CONST1($p), 0x2A, '%m', '%m']);
				add_opcode($cpu, "ld (${p}:%m), hl", [KC_CONST1($p), 0x22, '%m', '%m']);
			}
		},
		"ld (*p:NN), <rp> [kc160]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'sp') {
				for my $p ('xp', 'yp', 'a', 'pp', 'zp') {
					add_opcode($cpu, "ld ${rp}, (${p}:%m)", [KC_CONST1($p), 0xED, 0x4B+16*RP($rp), '%m', '%m']);
					add_opcode($cpu, "ld (${p}:%m), ${rp}", [KC_CONST1($p), 0xED, 0x43+16*RP($rp), '%m', '%m']);
				}
			}
		},
		"ld (*p:NN), <x> [kc160]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $p ('xp', 'yp', 'a', 'pp', 'zp') {
					add_opcode($cpu, "ld ${x}, (${p}:%m)", [KC_CONST1($p), PFX($x), 0x2A, '%m', '%m']);
					add_opcode($cpu, "ld (${p}:%m), ${x}", [KC_CONST1($p), PFX($x), 0x22, '%m', '%m']);
				}
			}
		},
		"ld (<x>+DIS), <rp> [kc160]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'hl', 'sp') {
				add_opcode($cpu, "ld $rp, (ix+%d)", [0xED, 0x8D+16*RP($rp), '%d']);
				add_opcode($cpu, "ld $rp, (iy+%d)", [0xED, 0x8C+16*RP($rp), '%d']);
				add_opcode($cpu, "ld (ix+%d), $rp", [0xED, 0x85+16*RP($rp), '%d']);
				add_opcode($cpu, "ld (iy+%d), $rp", [0xED, 0x84+16*RP($rp), '%d']);
			}
		},
		"ld (sp+DIS), <rp> [kc160]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'hl', 'sp') {
				add_opcode($cpu, "ld $rp, (sp+%d)", [0xED, 0x8E+16*RP($rp), '%d']);
				add_opcode($cpu, "ld (sp+%d), $rp", [0xED, 0x86+16*RP($rp), '%d']);
			}
		},
		"ldf (NNN), <rp> [kc160]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'hl', 'sp') {
				add_opcode($cpu, "ldf $rp, (%m)", [0xED, 0x8F+16*RP($rp), '%m', '%m', '%m']);
				add_opcode($cpu, "ldf (%m), $rp", [0xED, 0x87+16*RP($rp), '%m', '%m', '%m']);
			}
		},
		"ld (<x>+DIS), <x> [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ld (ix+%d), ix", [0xED, 0x81, '%d']);
			add_opcode($cpu, "ld (iy+%d), ix", [0xED, 0x80, '%d']);
			add_opcode($cpu, "ld ix, (ix+%d)", [0xED, 0x89, '%d']);
			add_opcode($cpu, "ld ix, (iy+%d)", [0xED, 0x88, '%d']);

			add_opcode($cpu, "ld (ix+%d), iy", [0xED, 0x91, '%d']);
			add_opcode($cpu, "ld (iy+%d), iy", [0xED, 0x90, '%d']);
			add_opcode($cpu, "ld iy, (ix+%d)", [0xED, 0x99, '%d']);
			add_opcode($cpu, "ld iy, (iy+%d)", [0xED, 0x98, '%d']);
		},
		"ld (sp+DIS), <x> [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ld (sp+%d), ix", [0xED, 0x82, '%d']);
			add_opcode($cpu, "ld (sp+%d), iy", [0xED, 0x92, '%d']);
			add_opcode($cpu, "ld ix, (sp+%d)", [0xED, 0x8A, '%d']);
			add_opcode($cpu, "ld iy, (sp+%d)", [0xED, 0x9A, '%d']);
		},
		"ldf (NNN), <x> [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ldf (%m), ix", [0xED, 0x83, '%m', '%m', '%m']);
			add_opcode($cpu, "ldf (%m), iy", [0xED, 0x93, '%m', '%m', '%m']);
			add_opcode($cpu, "ldf ix, (%m)", [0xED, 0x8B, '%m', '%m', '%m']);
			add_opcode($cpu, "ldf iy, (%m)", [0xED, 0x9B, '%m', '%m', '%m']);
		},
		"ld (*<x>+DIS), <rp> [kc160]" => sub {
			my($cpu) = @_;
			for my $p ('x', 'y', 'a', 'p', 'z') {
				for my $rp ('bc', 'de', 'hl', 'sp') {
					add_opcode($cpu, "ld $rp, (${p}ix+%d)", [KC_CONST1($p), 0xED, 0x8D+16*RP($rp), '%d']);
					add_opcode($cpu, "ld $rp, (${p}iy+%d)", [KC_CONST1($p), 0xED, 0x8C+16*RP($rp), '%d']);
					add_opcode($cpu, "ld (${p}ix+%d), $rp", [KC_CONST1($p), 0xED, 0x85+16*RP($rp), '%d']);
					add_opcode($cpu, "ld (${p}iy+%d), $rp", [KC_CONST1($p), 0xED, 0x84+16*RP($rp), '%d']);
				}
			}
		},
		"ld (*<x>+DIS), <x> [kc160]" => sub {
			my($cpu) = @_;
			for my $p ('x', 'y', 'a', 'p', 'z') {
				add_opcode($cpu, "ld (${p}ix+%d), ix", [KC_CONST1($p), 0xED, 0x81, '%d']);
				add_opcode($cpu, "ld (${p}iy+%d), ix", [KC_CONST1($p), 0xED, 0x80, '%d']);
				add_opcode($cpu, "ld ix, (${p}ix+%d)", [KC_CONST1($p), 0xED, 0x89, '%d']);
				add_opcode($cpu, "ld ix, (${p}iy+%d)", [KC_CONST1($p), 0xED, 0x88, '%d']);

				add_opcode($cpu, "ld (${p}ix+%d), iy", [KC_CONST1($p), 0xED, 0x91, '%d']);
				add_opcode($cpu, "ld (${p}iy+%d), iy", [KC_CONST1($p), 0xED, 0x90, '%d']);
				add_opcode($cpu, "ld iy, (${p}ix+%d)", [KC_CONST1($p), 0xED, 0x99, '%d']);
				add_opcode($cpu, "ld iy, (${p}iy+%d)", [KC_CONST1($p), 0xED, 0x98, '%d']);
			}
		},
		"ld <hl/x>, sp [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ld ix, sp", [0xED, 0x06]);
			add_opcode($cpu, "ld iy, sp", [0xED, 0x16]);
			add_opcode($cpu, "ld hl, sp", [0xED, 0x26]);
		},
		"ld (<x>+DIS), xix [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ld (ix+%d), xix", [0xED, 0x01, '%d']);
			add_opcode($cpu, "ld (iy+%d), xix", [0xED, 0x00, '%d']);
			add_opcode($cpu, "ld xix, (ix+%d)", [0xED, 0x09, '%d']);
			add_opcode($cpu, "ld xix, (iy+%d)", [0xED, 0x08, '%d']);
		},
		"ld (sp+DIS), xix [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ld (sp+%d), xix", [0xED, 0x02, '%d']);
			add_opcode($cpu, "ld xix, (sp+%d)", [0xED, 0x0A, '%d']);
		},
		"ldf (NNN), xix [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ldf (%m), xix", [0xED, 0x03, '%m', '%m', '%m']);
			add_opcode($cpu, "ldf xix, (%m)", [0xED, 0x0B, '%m', '%m', '%m']);
		},
		"ld (<x>+DIS), yiy [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ld (ix+%d), yiy", [0xED, 0x11, '%d']);
			add_opcode($cpu, "ld (iy+%d), yiy", [0xED, 0x10, '%d']);
			add_opcode($cpu, "ld yiy, (ix+%d)", [0xED, 0x19, '%d']);
			add_opcode($cpu, "ld yiy, (iy+%d)", [0xED, 0x18, '%d']);
		},
		"ld (sp+DIS), yiy [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ld (sp+%d), yiy", [0xED, 0x12, '%d']);
			add_opcode($cpu, "ld yiy, (sp+%d)", [0xED, 0x1A, '%d']);
		},
		"ldf (NNN), yiy [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ldf (%m), yiy", [0xED, 0x13, '%m', '%m', '%m']);
			add_opcode($cpu, "ldf yiy, (%m)", [0xED, 0x1B, '%m', '%m', '%m']);
		},
		"ld (<x>+DIS), ahl [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ld (ix+%d), ahl", [0xED, 0x21, '%d']);
			add_opcode($cpu, "ld (iy+%d), ahl", [0xED, 0x20, '%d']);
			add_opcode($cpu, "ld ahl, (ix+%d)", [0xED, 0x29, '%d']);
			add_opcode($cpu, "ld ahl, (iy+%d)", [0xED, 0x28, '%d']);
		},
		"ld (sp+DIS), ahl [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ld (sp+%d), ahl", [0xED, 0x22, '%d']);
			add_opcode($cpu, "ld ahl, (sp+%d)", [0xED, 0x2A, '%d']);
		},
		"ldf (NNN), ahl [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ldf (%m), ahl", [0xED, 0x23, '%m', '%m', '%m']);
			add_opcode($cpu, "ldf ahl, (%m)", [0xED, 0x2B, '%m', '%m', '%m']);
		},
		"ld (*<x>+DIS), xix [kc160]" => sub {
			my($cpu) = @_;
			for my $p ('x', 'y', 'a', 'p', 'z') {
				add_opcode($cpu, "ld xix, (${p}ix+%d)", [KC_CONST1($p), 0xED, 0x09, '%d']);
				add_opcode($cpu, "ld xix, (${p}iy+%d)", [KC_CONST1($p), 0xED, 0x08, '%d']);
				add_opcode($cpu, "ld (${p}ix+%d), xix", [KC_CONST1($p), 0xED, 0x01, '%d']);
				add_opcode($cpu, "ld (${p}iy+%d), xix", [KC_CONST1($p), 0xED, 0x00, '%d']);
			}
		},
		"ld (*<x>+DIS), yiy [kc160]" => sub {
			my($cpu) = @_;
			for my $p ('x', 'y', 'a', 'p', 'z') {
				add_opcode($cpu, "ld yiy, (${p}ix+%d)", [KC_CONST1($p), 0xED, 0x19, '%d']);
				add_opcode($cpu, "ld yiy, (${p}iy+%d)", [KC_CONST1($p), 0xED, 0x18, '%d']);
				add_opcode($cpu, "ld (${p}ix+%d), yiy", [KC_CONST1($p), 0xED, 0x11, '%d']);
				add_opcode($cpu, "ld (${p}iy+%d), yiy", [KC_CONST1($p), 0xED, 0x10, '%d']);
			}
		},
		"ld (*<x>+DIS), ahl [kc160]" => sub {
			my($cpu) = @_;
			for my $p ('x', 'y', 'a', 'p', 'z') {
				add_opcode($cpu, "ld ahl, (${p}ix+%d)", [KC_CONST1($p), 0xED, 0x29, '%d']);
				add_opcode($cpu, "ld ahl, (${p}iy+%d)", [KC_CONST1($p), 0xED, 0x28, '%d']);
				add_opcode($cpu, "ld (${p}ix+%d), ahl", [KC_CONST1($p), 0xED, 0x21, '%d']);
				add_opcode($cpu, "ld (${p}iy+%d), ahl", [KC_CONST1($p), 0xED, 0x20, '%d']);
			}
		},
		"ld <ptr>, NNN [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ld xix, %m", [0xED, 0x0E, '%m', '%m', '%m']);
			add_opcode($cpu, "ld yiy, %m", [0xED, 0x1E, '%m', '%m', '%m']);
			add_opcode($cpu, "ld ahl, %m", [0xED, 0x2E, '%m', '%m', '%m']);
		},
		"push/pop <ptr> [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "push xix", [0xED, 0x07]);
			add_opcode($cpu, "push yiy", [0xED, 0x17]);
			add_opcode($cpu, "push ahl", [0xED, 0x27]);
			add_opcode($cpu, "pop xix",  [0xED, 0x0F]);
			add_opcode($cpu, "pop yiy",  [0xED, 0x1F]);
			add_opcode($cpu, "pop ahl",  [0xED, 0x2F]);
		},
		"ldi/ldir/ldd/lddr xy [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ldi xy", [0xED, 0xE0]);
			add_opcode($cpu, "ldir xy", [0xED, 0xF0]);
			add_opcode($cpu, "ldd xy", [0xED, 0xE8]);
			add_opcode($cpu, "lddr xy", [0xED, 0xF8]);
		},
		"cpi/cpir/cpd/cpdr x [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "cpi x", [0xED, 0xE1]);
			add_opcode($cpu, "cpir x", [0xED, 0xF1]);
			add_opcode($cpu, "cpd x", [0xED, 0xE9]);
			add_opcode($cpu, "cpdr x", [0xED, 0xF9]);
		},
		"ini/inir/ind/indr x [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ini x", [0xED, 0xE2]);
			add_opcode($cpu, "inir x", [0xED, 0xF2]);
			add_opcode($cpu, "ind x", [0xED, 0xEA]);
			add_opcode($cpu, "indr x", [0xED, 0xFA]);
		},
		"outi/otir/outd/otdr x [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "outi x", [0xED, 0xE3]);
			add_opcode($cpu, "otir x", [0xED, 0xF3]);
			add_opcode($cpu, "outd x", [0xED, 0xEB]);
			add_opcode($cpu, "otdr x", [0xED, 0xFB]);
		},
		"<alu> (*hl) [kc160]" => sub {
			my($cpu) = @_;
			for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp') {
				my $a_ = ($alu =~ /add|adc|sbc/ ? 'a, ' : '');
				for my $p ('x', 'y', 'a', 'p', 'z') {
					if (!get_opcode($cpu, "$alu $a_(${p}hl)")) {
						add_opcode($cpu, "$alu $a_(${p}hl)", 
									[KC_CONST1($p), 0x86+8*ALU($alu)]);
					}
				}
			}
		},
		"<alu-extra> (*hl) [kc160]" => sub {
			my($cpu) = @_;
			for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp', 'cmp') {
				for my $a_ ('a, ', '') {
					for my $p ('x', 'y', 'a', 'p', 'z') {
						if (!get_opcode($cpu, "$alu $a_(${p}hl)")) {
							add_opcode($cpu, "$alu $a_(${p}hl)", 
										[KC_CONST1($p), 0x86+8*ALU($alu)]);
						}
					}
				}
			}
		},
		"<alu> (*<x>+DIS) [kc160]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp') {
					my $a_ = ($alu =~ /add|adc|sbc/ ? 'a, ' : '');
					for my $p ('x', 'y', 'a', 'p', 'z') {
						if (!get_opcode($cpu, "$alu $a_($p$x+%d)")) {
							add_opcode($cpu, "$alu $a_($p$x+%d)", 
										[KC_CONST1($p), PFX($x), 0x86+8*ALU($alu), '%d']);
						}
						if (!get_opcode($cpu, "$alu $a_($p$x)")) {
							add_opcode($cpu, "$alu $a_($p$x)", 
										[KC_CONST1($p), PFX($x), 0x86+8*ALU($alu), 0]);
						}
					}
				}
			}
		},
		"<alu-extra> (*<x>+DIS) [kc160]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp', 'cmp') {
					for my $a_ ('a, ', '') {
						for my $p ('x', 'y', 'a', 'p', 'z') {
							if (!get_opcode($cpu, "$alu $a_($p$x+%d)")) {
								add_opcode($cpu, "$alu $a_($p$x+%d)", 
											[KC_CONST1($p), PFX($x), 0x86+8*ALU($alu), '%d']);
							}
							if (!get_opcode($cpu, "$alu $a_($p$x)")) {
								add_opcode($cpu, "$alu $a_($p$x)", 
											[KC_CONST1($p), PFX($x), 0x86+8*ALU($alu), 0]);
							}
						}
					}
				}
			}
		},
		"inc/dec (*hl) [kc160]" => sub {
			my($cpu) = @_;
			for my $p ('x', 'y', 'a', 'p', 'z') {
				add_opcode($cpu, "inc (${p}hl)", [KC_CONST1($p), 0x34]);
				add_opcode($cpu, "dec (${p}hl)", [KC_CONST1($p), 0x35]);
			}
		},
		"inc/dec (*<x>+DIS) [kc160]" => sub {
			my($cpu) = @_;
			for my $p ('x', 'y', 'a', 'p', 'z') {
				for my $x ('ix', 'iy') {
					add_opcode($cpu, "inc ($p$x+%d)", [KC_CONST1($p), PFX($x), 0x34, '%d']);
					add_opcode($cpu, "dec ($p$x+%d)", [KC_CONST1($p), PFX($x), 0x35, '%d']);
				}
			}
		},
		"mul/muls hl [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "mul hl", [0xED, 0x76]);
			add_opcode($cpu, "muls hl", [0xED, 0x7E]);
		},
		"mul/muls de, hl [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "mul de, hl", [0xED, 0x77]);
			add_opcode($cpu, "muls de, hl", [0xED, 0x7F]);
		},
		"div/divs hl, a [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "div hl, a", [0xED, 0x74]);
			add_opcode($cpu, "divs hl, a", [0xED, 0x7C]);
		},
		"div/divs dehl, bc [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "div dehl, bc", [0xED, 0x75]);
			add_opcode($cpu, "divs dehl, bc", [0xED, 0x7D]);
		},
		"add *hl, <rp> [kc160]" => sub {
			my($cpu) = @_;
			for my $p ('x', 'y', 'a', 'z') {
				for my $rp ('bc', 'de', 'hl', 'sp') {
					add_opcode($cpu, "add ${p}hl, $rp", [KC_CONST2($p), 0x09+16*RP($rp)]);
				}
			}
		},
		"add *<x>, <rp> [kc160]" => sub {
			my($cpu) = @_;
			for my $p ('x', 'y', 'a', 'z') {
				for my $x ('ix', 'iy') {
					for my $rp ('bc', 'de', $x, 'sp') {
						add_opcode($cpu, "add $p$x, $rp", [KC_CONST2($p), PFX($x), 0x09+16*RP($rp)]);
					}
				}
			}
		},
		"sbc/adc *hl, <rp> [kc160]" => sub {
			my($cpu) = @_;
			for my $p ('x', 'y', 'a', 'z') {
				for my $rp ('bc', 'de', 'hl', 'sp') {
					add_opcode($cpu, "sbc ${p}hl, $rp", [KC_CONST2($p), 0xED, 0x42+16*RP($rp)]);
					add_opcode($cpu, "adc ${p}hl, $rp", [KC_CONST2($p), 0xED, 0x4A+16*RP($rp)]);
				}
			}
		},
		"inc/dec *<rp> [kc160]" => sub {
			my($cpu) = @_;
			for my $p ('x', 'y', 'a', 'z') {
				for my $rp ('bc', 'de', 'hl', 'sp') {
					add_opcode($cpu, "inc ${p}$rp", [KC_CONST2($p), 0x03+16*RP($rp)]);
					add_opcode($cpu, "dec ${p}$rp", [KC_CONST2($p), 0x0B+16*RP($rp)]);
				}
			}
		},
		"inc/dec *<x> [kc160]" => sub {
			my($cpu) = @_;
			for my $p ('x', 'y', 'a', 'z') {
				for my $x ('ix', 'iy') {
					add_opcode($cpu, "inc ${p}$x", [KC_CONST2($p), PFX($x), 0x03+16*2]);
					add_opcode($cpu, "dec ${p}$x", [KC_CONST2($p), PFX($x), 0x0B+16*2]);
				}
			}
		},
		"<bit> <b>, (*hl) [kc160]" => sub {
			my($cpu) = @_;
			for my $op ('bit', 'res', 'set') {
				for my $p ('x', 'y', 'a', 'p', 'z') {
					add_opcode($cpu, "$op %c, (${p}hl)",
							[KC_CONST1($p), 0xCB, (0x40*BIT($op)+6)."+8*%c"],
							[0, 1, 2, 3, 4, 5, 6, 7]);
				}
			}
		},
		"<bit> <b>, (*<x>+DIS) [kc160]" => sub {
			my($cpu) = @_;
			for my $op ('bit', 'res', 'set') {
				for my $x ('ix', 'iy') {
					for my $p ('x', 'y', 'a', 'p', 'z') {
						add_opcode($cpu, "$op %c, ($p$x+%d)",
								[KC_CONST1($p), PFX($x), 0xCB, '%d', (0x40*BIT($op)+6)."+8*%c"],
								[0, 1, 2, 3, 4, 5, 6, 7]);
					}
				}
			}
		},
		"<rot> (*hl) [kc160]" => sub {
			my($cpu) = @_;
			for my $op ('rlc', 'rrc', 'rl', 'rr', 'sla', 'sra', 'srl') {
				for my $p ('x', 'y', 'a', 'p', 'z') {
					add_opcode($cpu, "$op (${p}hl)", 
							[KC_CONST1($p), 0xCB, 8*ROT($op)+6]);
				}
			}
		},
		"<rot> (*<x>+DIS) [kc160]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $op ('rlc', 'rrc', 'rl', 'rr', 'sla', 'sra', 'srl') {
					for my $p ('x', 'y', 'a', 'p', 'z') {
						add_opcode($cpu, "$op ($p$x+%d)", 
								[KC_CONST1($p), PFX($x), 0xCB, '%d', 8*ROT($op)+6]);
					}
				}
			}
		},
		"rld/rrd (*hl) [kc160]" => sub {
			my($cpu) = @_;
			for my $p ('x', 'y', 'a', 'p', 'z') {
				add_opcode($cpu, "rld (${p}hl)", [KC_CONST1($p), 0xED, 0x6F]);
				add_opcode($cpu, "rrd (${p}hl)", [KC_CONST1($p), 0xED, 0x67]);
			}
		},
		"jp (*hl) [kc160]" => sub {
			my($cpu) = @_;
			for my $p ('x', 'y', 'a', 'p', 'z') {
				add_opcode($cpu, "jp (${p}hl)", [KC_CONST1($p), 0xE9]);
			}
		},
		"jp (*<x>) [kc160]" => sub {
			my($cpu) = @_;
			for my $p ('x', 'y', 'a', 'p', 'z') {
				for my $x ('ix', 'iy') {
					add_opcode($cpu, "jp ($p$x)", [KC_CONST1($p), PFX($x), 0xE9]);
				}
			}
		},
		"jmp (*hl) [kc160]" => sub {
			my($cpu) = @_;
			for my $p ('x', 'y', 'a', 'p', 'z') {
				add_opcode($cpu, "jmp (${p}hl)", [KC_CONST1($p), 0xE9]);
			}
		},
		"jmp (*<x>) [kc160]" => sub {
			my($cpu) = @_;
			for my $p ('x', 'y', 'a', 'p', 'z') {
				for my $x ('ix', 'iy') {
					add_opcode($cpu, "jmp ($p$x)", [KC_CONST1($p), PFX($x), 0xE9]);
				}
			}
		},
		"jp3 NNN [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "jp3 %m", [0xED, 0xC3, '%m', '%m', '%m']);
		},
		"jp3 <f>, NNN [kc160]" => sub {
			my($cpu) = @_;
			for my $f ('nz', 'z', 'nc', 'c') {
				add_opcode($cpu, "jp3 $f, %m", [0xED, 0xC2+8*F($f), '%m', '%m', '%m']);
			}
		},
		"call3 NNN [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "call3 %m", [0xED, 0x4C, '%m', '%m', '%m']);
		},
		"ret3 [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ret3", [0xED, 0x5C]);
		},
		"tra [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "tra", [0xED, 0x54]);
		},
		"retn3 [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "retn3", [0xED, 0x55]);
		},
		"im N [kc160]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "im %c", 
					   [0xED, "%c==0?0x46:%c==1?0x56:%c==2?0x5E:0x4E"], 
					   [0, 1, 2, 3]);
		},
		"<alu> a, N [r2ka]" => sub {
			my($cpu) = @_;
			for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp') {
				my $a_ = ($alu =~ /add|adc|sbc/ ? 'a, ' : '');
				if (!get_opcode($cpu, "$alu $a_%n")) {
					add_opcode_rabbit_altd($cpu, "$alu $a_%n", [0xC6+8*ALU($alu), '%n']);
				}
			}
		},
		"<alu-extra> a, N [r2ka]" => sub {
			my($cpu) = @_;
			for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp', 'cmp') {
				for my $a_ ('a, ', '') {
					if (!get_opcode($cpu, "$alu $a_%n")) {
						add_opcode_rabbit_altd($cpu, "$alu $a_%n", [0xC6+8*ALU($alu), '%n']);
					}
				}
			}
		},
		"<alu> a, <r> [r2ka]" => sub {
			my($cpu) = @_;
			for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp') {
				my $a_ = ($alu =~ /add|adc|sbc/ ? 'a, ' : '');
				for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
					if (!get_opcode($cpu, "$alu $a_$r")) {
						add_opcode_rabbit_altd($cpu, "$alu $a_$r", [0x80+8*ALU($alu)+R($r)]);
					}
				}
			}
		},
		"<alu-extra> a, <r> [r2ka]" => sub {
			my($cpu) = @_;
			for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp', 'cmp') {
				for my $a_ ('a, ', '') {
					for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
						if (!get_opcode($cpu, "$alu $a_$r")) {
							add_opcode_rabbit_altd($cpu, "$alu $a_$r", [0x80+8*ALU($alu)+R($r)]);
						}
					}
				}
			}
		},
		"<alu> a, <r> [r4k]" => sub {
			my($cpu) = @_;
			for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp') {
				my $a_ = ($alu =~ /add|adc|sbc/ ? 'a, ' : '');
				for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
					if (!get_opcode($cpu, "$alu $a_$r")) {
						add_opcode_rabbit_altd($cpu, "$alu $a_$r", [0x7F, 0x80+8*ALU($alu)+R($r)]);
					}
				}
			}
		},
		"<alu-extra> a, <r> [r4k]" => sub {
			my($cpu) = @_;
			for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp', 'cmp') {
				for my $a_ ('a, ', '') {
					for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
						if (!get_opcode($cpu, "$alu $a_$r")) {
							add_opcode_rabbit_altd($cpu, "$alu $a_$r", [0x7F, 0x80+8*ALU($alu)+R($r)]);
						}
					}
				}
			}
		},
		"<alu> a, (hl) [r2ka]" => sub {
			my($cpu) = @_;
			for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp') {
				my $a_ = ($alu =~ /add|adc|sbc/ ? 'a, ' : '');
				if (!get_opcode($cpu, "$alu $a_(hl)")) {
					add_opcode_rabbit_altd_io($cpu, "$alu $a_(hl)", [0x80+8*ALU($alu)+6]);
				}
			}
		},
		"<alu-extra> a, (hl) [r2ka]" => sub {
			my($cpu) = @_;
			for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp', 'cmp') {
				for my $a_ ('a, ', '') {
					if (!get_opcode($cpu, "$alu $a_(hl)")) {
						add_opcode_rabbit_altd_io($cpu, "$alu $a_(hl)", [0x80+8*ALU($alu)+6]);
					}
				}
			}
		},
		"<alu> a, (hl) [r4k]" => sub {
			my($cpu) = @_;
			for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp') {
				my $a_ = ($alu =~ /add|adc|sbc/ ? 'a, ' : '');
				if (!get_opcode($cpu, "$alu $a_(hl)")) {
					add_opcode_rabbit_altd_io($cpu, "$alu $a_(hl)", [0x7F, 0x80+8*ALU($alu)+6]);
				}
			}
		},
		"<alu-extra> a, (hl) [r4k]" => sub {
			my($cpu) = @_;
			for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp', 'cmp') {
				for my $a_ ('a, ', '') {
					if (!get_opcode($cpu, "$alu $a_(hl)")) {
						add_opcode_rabbit_altd_io($cpu, "$alu $a_(hl)", [0x7F, 0x80+8*ALU($alu)+6]);
					}
				}
			}
		},
		"<alu> a, (<x>+DIS) [r2ka]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp') {
					my $a_ = ($alu =~ /add|adc|sbc/ ? 'a, ' : '');
					if (!get_opcode($cpu, "$alu $a_($x+%d)")) {
						add_opcode_rabbit_altd_io($cpu, "$alu $a_($x+%d)", 
									[PFX($x), 0x86+8*ALU($alu), '%d']);
					}
					if (!get_opcode($cpu, "$alu $a_($x)")) {
						add_opcode_rabbit_altd_io($cpu, "$alu $a_($x)", 
									[PFX($x), 0x86+8*ALU($alu), 0]);
					}
				}
			}
		},
		"<alu-extra> a, (<x>+DIS) [r2ka]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $alu ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp', 'cmp') {
					for my $a_ ('a, ', '') {
						if (!get_opcode($cpu, "$alu $a_($x+%d)")) {
							add_opcode_rabbit_altd_io($cpu, "$alu $a_($x+%d)", 
										[PFX($x), 0x86+8*ALU($alu), '%d']);
						}
						if (!get_opcode($cpu, "$alu $a_($x)")) {
							add_opcode_rabbit_altd_io($cpu, "$alu $a_($x)", 
										[PFX($x), 0x86+8*ALU($alu), 0]);
						}
					}
				}
			}
		},
		"<alu> <r> [8080/r4k]" => sub {
			my($cpu) = @_;
			for my $alu ('add', 'adc', 'sub', 'sbb', 'ana', 'xra', 'ora', 'cmp') {
				for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'm', 'a') {
					if (!get_opcode($cpu, "$alu $r")) {
						add_opcode($cpu, "$alu $r", [0x7F, 0x80+8*ALU($alu)+R($r)]);
					}
				}
			}
		},
		"sbc/adc hl, <rp> [r2ka]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'hl', 'sp') {
				add_opcode_rabbit_altd($cpu, "sbc hl, $rp", [0xED, 0x42+16*RP($rp)]);
				add_opcode_rabbit_altd($cpu, "adc hl, $rp", [0xED, 0x4A+16*RP($rp)]);
			}
		},
		"add hl, <rp> [r2ka]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'hl', 'sp') {
				add_opcode_rabbit_altd($cpu, "add hl, $rp", [0x09+16*RP($rp)]);
			}
		},
		"add hl, jk [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "add hl, jk", [0x65]);
		},
		"add <x>, <rp> [r2ka]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $rp ('bc', 'de', $x, 'sp') {
					add_opcode_rabbit_altd($cpu, "add $x, $rp", [PFX($x), 0x09+16*RP($rp)]);
				}
			}
		},
		"add jkhl, bcde [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "add jkhl, bcde", [0xED, 0xC6]);
		},
		"add sp, %d [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "add sp, %d", [0x27, '%d']);
		},
		"and hl, de [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "and hl, de", [0xDC]);
		},
		"and <x>, de [r2ka]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode_rabbit_altd($cpu, "and $x, de", [PFX($x), 0xDC]);
			}
		},
		"and jkhl, bcde [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "and jkhl, bcde", [0xED, 0xE6]);
		},
		"<bit> <b>, <r> [r2ka]" => sub {
			my($cpu) = @_;
			for my $op ('bit', 'res', 'set') {
				for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
					if (!get_opcode($cpu, "$op %c, $r")) {
						add_opcode_rabbit_altd($cpu, "$op %c, $r", 
								   [0xCB, (0x40*BIT($op)+R($r))."+8*%c"],
								   [0, 1, 2, 3, 4, 5, 6, 7]);
					}
				}
			}
		},
		"<bit> <b>, (hl) [r2ka]" => sub {
			my($cpu) = @_;
			for my $op ('bit', 'res', 'set') {
				if (!get_opcode($cpu, "$op %c, (hl)")) {
					add_opcode_rabbit_altd_io($cpu, "$op %c, (hl)", 
								[0xCB, (0x40*BIT($op)+6)."+8*%c"],
								[0, 1, 2, 3, 4, 5, 6, 7]);
				}
			}
		},
		"<bit> <b>, (<x>+DIS) [r2ka]" => sub {
			my($cpu) = @_;
			for my $op ('bit', 'res', 'set') {
				for my $x ('ix', 'iy') {
					add_opcode_rabbit_altd_io($cpu, "$op %c, ($x+%d)",
							   [PFX($x), 0xCB, '%d', (0x40*BIT($op)+6)."+8*%c"],
							   [0, 1, 2, 3, 4, 5, 6, 7]);
				}
			}
		},
		"bool hl [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "bool hl", [0xCC]);
		},
		"bool <x> [r2ka]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode($cpu, "bool $x", [PFX($x), 0xCC]);
			}
		},
		"call (hl) [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "call (hl)", [0xED, 0xEA]);
		},
		"call (<x>) [r4k]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode($cpu, "call ($x)", [PFX($x), 0xEA]);
			}
		},
		"cbm N [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_io($cpu, "cbm %n", [0xED, 0x00, '%n']);
		},
		"ccf' [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ccf'", [RABBIT_CONST('altd'), 0x3F]);
			add_opcode($cpu, "altd ccf", [RABBIT_CONST('altd'), 0x3F]);
		},
		"clr hl [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "clr hl", [0xBF]);
		},
		"convc <pp> [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode($cpu, "convc $pp", [0xED, 0x0E+16*RABBIT_PP($pp)]);
			}
		},
		"convd <pp> [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode($cpu, "convd $pp", [0xED, 0x0F+16*RABBIT_PP($pp)]);
			}
		},
		"copy/copyr [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "copy", [0xED, 0x80]);
			add_opcode($cpu, "copyr", [0xED, 0x88]);
		},
		"cp hl, D [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "cp hl, %d", [0x48, '%d']);
		},
		"cmp hl, D [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "cmp hl, %d", [0x48, '%d']);
		},
		"cp hl, de [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "cp hl, de", [0xED, 0x48]);
		},
		"cmp hl, de [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "cmp hl, de", [0xED, 0x48]);
		},
		"cp jkhl, bcde [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "cp jkhl, bcde", [0xED, 0x58]);
		},
		"cmp jkhl, bcde [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "cmp jkhl, bcde", [0xED, 0x58]);
		},
		"cpl [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "cpl", [0x2F]);
			add_opcode($cpu, "altd cpl", [RABBIT_CONST('altd'), 0x2F]);
			add_opcode_rabbit_altd($cpu, "cpl a", [0x2F]);
		},
		"inc/dec <r> [r2ka]" => sub {
			my($cpu) = @_;
			for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
				add_opcode_rabbit_altd($cpu, "inc $r", [0x04+8*R($r)]);
				add_opcode_rabbit_altd($cpu, "dec $r", [0x05+8*R($r)]);
			}
		},
		"inc/dec (hl) [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd_io($cpu, "inc (hl)", [0x04+8*6]);
			add_opcode_rabbit_altd_io($cpu, "dec (hl)", [0x05+8*6]);
		},
		"inc/dec (<x>+DIS) [r2ka]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode_rabbit_altd_io($cpu, "inc ($x+%d)", [PFX($x), 0x04+8*6, '%d']);
				add_opcode_rabbit_altd_io($cpu, "dec ($x+%d)", [PFX($x), 0x05+8*6, '%d']);
			}
		},
		"inc/dec <rp> [r2ka]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'hl', 'sp') {
				add_opcode_rabbit_altd($cpu, "inc $rp", [0x03+16*RP($rp)]);
				add_opcode_rabbit_altd($cpu, "dec $rp", [0x0B+16*RP($rp)]);
			}
		},
		"djnz b, DIS [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "djnz %j", [0x10, '%j']);
			add_opcode($cpu, "altd djnz %j", [RABBIT_CONST('altd'), 0x10, '%j']);
			add_opcode_rabbit_altd($cpu, "djnz b, %j", [0x10, '%j']);
		},
		"dwjnz bc, DIS [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "dwjnz %j", [0xED, 0x10, '%j']);
			add_opcode($cpu, "altd dwjnz %j", [RABBIT_CONST('altd'), 0xED, 0x10, '%j']);
			add_opcode_rabbit_altd($cpu, "dwjnz bc, %j", [0xED, 0x10, '%j']);
		},
		"ex bc, hl [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ex bc, hl", [0xB3]);
			add_opcode($cpu, "altd ex bc, hl", [RABBIT_CONST('altd'), 0xB3]);
			add_opcode($cpu, "ex bc, hl'", [RABBIT_CONST('altd'), 0xB3]);

			add_opcode($cpu, "ex bc', hl", [0xED, 0x74]);
			add_opcode($cpu, "altd ex bc', hl", [RABBIT_CONST('altd'), 0xED, 0x74]);
			add_opcode($cpu, "ex bc', hl'", [RABBIT_CONST('altd'), 0xED, 0x74]);
		},
		"ex de, hl [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ex de, hl", [0xEB]);
			add_opcode($cpu, "altd ex de, hl", [RABBIT_CONST('altd'), 0xEB]);
			add_opcode($cpu, "ex de, hl'", [RABBIT_CONST('altd'), 0xEB]);

			add_opcode($cpu, "ex de', hl", [0xE3]);
			add_opcode($cpu, "altd ex de', hl", [RABBIT_CONST('altd'), 0xE3]);
			add_opcode($cpu, "ex de', hl'", [RABBIT_CONST('altd'), 0xE3]);
		},
		"ex jk, hl [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ex jk, hl", [0xB9]);
			add_opcode($cpu, "altd ex jk, hl", [RABBIT_CONST('altd'), 0xB9]);
			add_opcode($cpu, "ex jk, hl'", [RABBIT_CONST('altd'), 0xB9]);

			add_opcode($cpu, "ex jk', hl", [0xED, 0x7C]);
			add_opcode($cpu, "altd ex jk', hl", [RABBIT_CONST('altd'), 0xED, 0x7C]);
			add_opcode($cpu, "ex jk', hl'", [RABBIT_CONST('altd'), 0xED, 0x7C]);
		},
		"ex jkhl, bcde [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ex jkhl, bcde", [0xB4]);
		},
		"ex (sp), hl [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ex (sp), hl", [0xED, 0x54]);
			add_opcode($cpu, "altd ex (sp), hl", [RABBIT_CONST('altd'), 0xED, 0x54]);
			add_opcode($cpu, "ex (sp), hl'", [RABBIT_CONST('altd'), 0xED, 0x54]);
		},
		"exp [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "exp", [0xED, 0xD9]);
		},
		"flag <f>, hl [r4k]" => sub {
			my($cpu) = @_;
			for my $f ('nz', 'z', 'nc', 'c') {
				add_opcode($cpu, "flag $f, hl", [0xED, 0xC4+8*F($f)]);
			}
			for my $xf ('gt', 'gtu', 'lt', 'v') {
				add_opcode($cpu, "flag $xf, hl", [0xED, 0xA4+8*XF($xf)]);
			}
		},
		"fsyscall [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "fsyscall", [0xED, 0x55]);
			add_opcode($cpu, "altd fsyscall", [RABBIT_CONST('altd'), 0xED, 0x55]);
		},
		"ibox/sbox a [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "ibox a", [0xED, 0x12]);
			add_opcode_rabbit_altd($cpu, "sbox a", [0xED, 0x02]);
		},
		"idet [r3k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "idet", [0x5B]);
		},
		"ipres [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ipres", [0xED, 0x5D]);
		},
		"ipset N [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ipset %c", [0xED, '%c==0?0x46:%c==1?0x56:%c==2?0x4E:0x5E'], [0, 1, 2, 3]);
			add_opcode($cpu, "ip %c", [0xED, '%c==0?0x46:%c==1?0x56:%c==2?0x4E:0x5E'], [0, 1, 2, 3]);
		},
		"jp <xf>, NN [r4k]" => sub {
			my($cpu) = @_;
			for my $xf ('gt', 'gtu', 'lt', 'v') {
				add_opcode($cpu, "jp $xf, %m", [0xA2+8*XF($xf), '%m', '%m']);
			}
		},
		"j<xf>, NN [r4k]" => sub {
			my($cpu) = @_;
			for my $xf ('gt', 'gtu', 'lt', 'v') {
				add_opcode($cpu, "jmp $xf, %m", [0xA2+8*XF($xf), '%m', '%m']);
				add_opcode($cpu, "j$xf %m", [0xA2+8*XF($xf), '%m', '%m']);
				add_opcode($cpu, "j_$xf %m", [0xA2+8*XF($xf), '%m', '%m']);
			}
		},
		"jp <xf>, NN [r2ka]" => sub {
			my($cpu) = @_;
			for (['nv'=>4],['v'=>5]) {
				my($f, $v) = @$_;
				add_opcode($cpu, "jp $f, %m", [0xC2+8*$v, '%m', '%m']);
			}
		},
		"j<xf>, NN [r2ka]" => sub {
			my($cpu) = @_;
			for (['nv'=>4],['v'=>5]) {
				my($f, $v) = @$_;
				add_opcode($cpu, "jmp $f, %m", [0xC2+8*$v, '%m', '%m']);
				add_opcode($cpu, "j$f %m", [0xC2+8*$v, '%m', '%m']);
				add_opcode($cpu, "j_$f %m", [0xC2+8*$v, '%m', '%m']);
			}
		},
		"jr <xf>, DIS [r4k]" => sub {
			my($cpu) = @_;
			for my $xf ('gt', 'gtu', 'lt', 'v') {
				add_opcode($cpu, "jr $xf, %j", [0xA0+8*XF($xf), '%j']);
			}
		},
		"jre <f>, EDIS [r4k]" => sub {
			my($cpu) = @_;
			for my $f ('nz', 'z', 'nc', 'c') {
				add_opcode($cpu, "jre $f, %J", [0xED, 0xC3+8*F($f), '%J', '%J']);
			}
			for my $xf ('gt', 'gtu', 'lt', 'v') {
				add_opcode($cpu, "jre $xf, %J", [0xED, 0xA3+8*XF($xf), '%J', '%J']);
			}
		},
		"jre EDIS [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "jre %J", [0x98, '%J', '%J']);
		},
		"lcall N, NN [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "lcall %x, %m", [0xCF, '%m', '%m', '%x']);
		},
		"ld eir/iir, a [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "ld a, eir", [0xED, 0x57]);
			add_opcode_rabbit_altd($cpu, "ld a, iir", [0xED, 0x5F]);
			add_opcode($cpu, "ld eir, a", [0xED, 0x47]);
			add_opcode($cpu, "ld iir, a", [0xED, 0x4F]);
		},
		"ld htr, a [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "ld a, htr", [0xED, 0x50]);
			add_opcode($cpu, "ld htr, a", [0xED, 0x40]);
		},
		"ld xpc, a [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "ld a, xpc", [0xED, 0x77]);
			add_opcode($cpu, "ld xpc, a", [0xED, 0x67]);
		},
		"ld a, (<rp>) [r2ka]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de') {
				add_opcode_rabbit_altd_io($cpu, "ld a, ($rp)", [0x0A+16*RP($rp)]);
				add_opcode_rabbit_io($cpu, "ld ($rp), a", [0x02+16*RP($rp)]);
			}
		},
		"ld a, (NN) [r2ka]" => sub {
			my($cpu) = @_;
			if ($cpu =~ /gbz80/) {
				add_opcode($cpu, "ld (%m), a", [0xEA, '%m', '%m']);
				add_opcode($cpu, "ld a, (%m)", [0xFA, '%m', '%m']);
			} 
			else {
				add_opcode_rabbit_io($cpu, "ld (%m), a", [0x32, '%m', '%m']);
				add_opcode_rabbit_altd_io($cpu, "ld a, (%m)", [0x3A, '%m', '%m']);
			}
		},
		"ld a, (<x>+A) [r4k]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode_rabbit_altd_io($cpu, "ld a, ($x+a)", [PFX($x), 0x06]);
			}
		},
		"ld a, (<pp>+DIS) [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode_rabbit_altd($cpu, "ld a, ($pp+%d)", [0x8D+16*RABBIT_PP($pp), '%d']);
			}
		},
		"ld a, (<pp>+HL) [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode_rabbit_altd($cpu, "ld a, ($pp+hl)", [0x8B+16*RABBIT_PP($pp)]);
			}
		},
		"ld bcde, <pd> [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode_rabbit_altd($cpu, "ld bcde, $pp", [0xDD, 0xCD+16*RABBIT_PP($pp)]);
			}
		},
		"ld bcde, (hl) [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd_io($cpu, "ld bcde, (hl)", [0xDD, 0x1A]);
		},
		"ld bcde, (<x>+DIS) [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd_io($cpu, "ld bcde, (ix+%d)", [0xDD, 0xCE, '%d']);
			add_opcode_rabbit_altd_io($cpu, "ld bcde, (iy+%d)", [0xDD, 0xDE, '%d']);
		},
		"ld bcde, (NN) [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd_io($cpu, "ld bcde, (%m)", [0x93, '%m', '%m']);
		},
		"ld bcde, (<pp>+DIS) [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode_rabbit_altd($cpu, "ld bcde, ($pp+%d)", [0xDD, 0x0E+16*RABBIT_PP($pp), '%d']);
			}
		},
		"ld bcde, (<pp>+HL) [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode_rabbit_altd($cpu, "ld bcde, ($pp+hl)", [0xDD, 0x0C+16*RABBIT_PP($pp)]);
			}
		},
		"ld bcde, D [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "ld bcde, %d", [0xA3, '%d']);
		},
		"ld bcde, (sp+hl) [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "ld bcde, (sp+hl)", [0xDD, 0xFE]);
		},
		"ld bcde, (sp+N) [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "ld bcde, (sp+%n)", [0xDD, 0xEE, '%n']);
			add_opcode_rabbit_altd($cpu, "ld bcde, (sp)", [0xDD, 0xEE, 0]);
		},
		"ld (sp+N), bcde [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ld (sp+%n), bcde", [0xDD, 0xEF, '%n']);
			add_opcode($cpu, "ld (sp), bcde", [0xDD, 0xEF, 0]);
		},
		"ld bc, hl [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "ld bc, hl", [0x91]);
		},
		"ld de, hl [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "ld de, hl", [0xB1]);
		},
		"ld hl, bc [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "ld hl, bc", [0x81]);
		},
		"ld hl, de [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "ld hl, de", [0xA1]);
		},
		"ld <rp>', bc|de [r2ka]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'hl') {
				if (!get_opcode($cpu, "ld $rp', bc")) {
					add_opcode($cpu, "ld $rp', bc", [0xED, 0x49+16*RP($rp)]);
					add_opcode($cpu, "altd ld $rp, bc", [0xED, 0x49+16*RP($rp)]);
				}
				if (!get_opcode($cpu, "ld $rp', de")) {
					add_opcode($cpu, "ld $rp', de", [0xED, 0x41+16*RP($rp)]);
					add_opcode($cpu, "altd ld $rp, de", [0xED, 0x41+16*RP($rp)]);
				}
			}
		},
		"ld <rp>, NN [r2ka]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'hl') {
				add_opcode_rabbit_altd($cpu, "ld $rp, %m", [0x01+16*RP($rp), '%m', '%m']);
			}
			for my $rp ('sp') {
				add_opcode($cpu, "ld $rp, %m", [0x01+16*RP($rp), '%m', '%m']);
			}
		},
		"ld <rp>, (NN) [r2ka]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de') {
				add_opcode_rabbit_altd_io($cpu, "ld $rp, (%m)", [0xED, 0x4B+16*RP($rp), '%m', '%m']);
				add_opcode_rabbit_io($cpu, "ld (%m), $rp", [0xED, 0x43+16*RP($rp), '%m', '%m']);
			}
			for my $rp ('sp') {
				add_opcode_rabbit_io($cpu, "ld $rp, (%m)", [0xED, 0x4B+16*RP($rp), '%m', '%m']);
				add_opcode_rabbit_io($cpu, "ld (%m), $rp", [0xED, 0x43+16*RP($rp), '%m', '%m']);
			}
		},
		"ld hl, <x> [r2ka]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode_rabbit_altd($cpu, "ld hl, $x", [PFX($x), 0x7C]);
			}
		},
		"ld <x>, hl [r2ka]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode($cpu, "ld $x, hl", [PFX($x), 0x7D]);
			}
		},
		"ld hl, (NN) [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd_io($cpu, "ld hl, (%m)", [0x2A, '%m', '%m']);
			add_opcode_rabbit_io($cpu, "ld (%m), hl", [0x22, '%m', '%m']);
		},
		"ld hl, (hl+DIS) [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd_io($cpu, "ld hl, (hl+%d)", [0xDD, 0xE4, '%d']);
		},
		"ld hl, (iy+DIS) [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd_io($cpu, "ld hl, (iy+%d)", [0xFD, 0xE4, '%d']);
		},
		"ld hl, (ix+DIS) [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd_io($cpu, "ld hl, (ix+%d)", [0xE4, '%d']);
		},
		"ld hl, (<pp>+bc) [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode_rabbit_altd($cpu, "ld hl, ($pp+bc)", [0xED, 0x06+16*RABBIT_PP($pp)]);
			}
		},
		"ld hl, (<pp>+DIS) [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode_rabbit_altd($cpu, "ld hl, ($pp+%d)", [0x85+16*RABBIT_PP($pp), '%d']);
			}
		},
		"ld hl, (sp+hl) [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "ld hl, (sp+hl)", [0xED, 0xFE]);
		},
		"ld hl, lxpc [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "ld hl, lxpc", [0x9F]);
			add_opcode($cpu, "ld lxpc, hl", [0x97]);
		},
		"ld hl, (sp+N) [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "ld hl, (sp+%n)", [0xC4, '%n']);
			add_opcode_rabbit_altd($cpu, "ld hl, (sp)", [0xC4, 0]);
		},
		"ld (sp+N), hl [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ld (sp+%n), hl", [0xD4, '%n']);
			add_opcode($cpu, "ld (sp), hl", [0xD4, 0]);
		},
		"ld <x>, (NN) [r2ka]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode_rabbit_io($cpu, "ld $x, (%m)", [PFX($x), 0x2A, '%m', '%m']);
			}
		},
		"ld <x>, (sp+N) [r2ka]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode($cpu, "ld $x, (sp+%n)", [PFX($x), 0xC4, '%n']);
				add_opcode($cpu, "ld $x, (sp)", [PFX($x), 0xC4, 0]);
			}
		},
		"ld (sp+N), <x> [r2ka]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode($cpu, "ld (sp+%n), $x", [PFX($x), 0xD4, '%n']);
				add_opcode($cpu, "ld (sp), $x", [PFX($x), 0xD4, 0]);
			}
		},
		"ld jkhl, D [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "ld jkhl, %d", [0xA4, '%d']);
		},
		"ld jkhl, <pd> [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode_rabbit_altd($cpu, "ld jkhl, $pp", [0xFD, 0xCD+16*RABBIT_PP($pp)]);
			}
		},
		"ld jkhl, (hl) [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd_io($cpu, "ld jkhl, (hl)", [0xFD, 0x1A]);
		},
		"ld jkhl, (sp+hl) [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "ld jkhl, (sp+hl)", [0xFD, 0xFE]);
		},
		"ld jkhl, (<x>+DIS) [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd_io($cpu, "ld jkhl, (ix+%d)", [0xFD, 0xCE, '%d']);
			add_opcode_rabbit_altd_io($cpu, "ld jkhl, (iy+%d)", [0xFD, 0xDE, '%d']);
		},
		"ld jkhl, (NN) [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd_io($cpu, "ld jkhl, (%m)", [0x94, '%m', '%m']);
		},
		"ld jkhl, (<pp>+DIS) [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode_rabbit_altd($cpu, "ld jkhl, ($pp+%d)", [0xFD, 0x0E+16*RABBIT_PP($pp), '%d']);
			}
		},
		"ld jkhl, (<pp>+HL) [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode_rabbit_altd($cpu, "ld jkhl, ($pp+hl)", [0xFD, 0x0C+16*RABBIT_PP($pp)]);
			}
		},
		"ld jkhl, (sp+N) [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "ld jkhl, (sp+%n)", [0xFD, 0xEE, '%n']);
			add_opcode_rabbit_altd($cpu, "ld jkhl, (sp)", [0xFD, 0xEE, 0]);
		},
		"ld (sp+N), jkhl [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ld (sp+%n), jkhl", [0xFD, 0xEF, '%n']);
			add_opcode($cpu, "ld (sp), jkhl", [0xFD, 0xEF, 0]);
		},
		"ld jk, NN [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "ld jk, %m", [0xA9, '%m', '%m']);
		},
		"ld jk, (NN) [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd_io($cpu, "ld jk, (%m)", [0x99, '%m', '%m']);
		},
		"ld <pp>, bcde [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode($cpu, "ld $pp, bcde", [0xDD, 0x8D+16*RABBIT_PP($pp)]);
			}
		},
		"ld <pp>, jkhl [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode($cpu, "ld $pp, jkhl", [0xFD, 0x8D+16*RABBIT_PP($pp)]);
			}
		},
		"ld <pp>, NNNN [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode($cpu, "ld $pp, %m", [0xED, 0x0C+16*RABBIT_PP($pp), '%m', '%m', '%m', '%m']);
			}
		},
		"ld <pp>, <pd> [r4k]" => sub {
			my($cpu) = @_;
			for my $pp1 ('pw', 'px', 'py', 'pz') {
				for my $pp2 ('pw', 'px', 'py', 'pz') {
					add_opcode_rabbit_altd($cpu, "ld $pp1, $pp2", [0x6D, 0x07+64*RABBIT_PP($pp1)+16*RABBIT_PP($pp2)]);
				}
			}
		},
		"ld <pp>, <pp>+DIS [r4k]" => sub {
			my($cpu) = @_;
			for my $pp1 ('pw', 'px', 'py', 'pz') {
				for my $pp2 ('pw', 'px', 'py', 'pz') {
					add_opcode($cpu, "ld $pp1, $pp2+%d", [0x6D, 0x0C+64*RABBIT_PP($pp1)+16*RABBIT_PP($pp2), '%d']);
				}
			}
		},
		"ld <pp>, <pp>+de [r4k]" => sub {
			my($cpu) = @_;
			for my $pp1 ('pw', 'px', 'py', 'pz') {
				for my $pp2 ('pw', 'px', 'py', 'pz') {
					add_opcode_rabbit_altd($cpu, "ld $pp1, $pp2+de", [0x6D, 0x06+64*RABBIT_PP($pp1)+16*RABBIT_PP($pp2)]);
				}
			}
		},
		"ld <pp>, <pp>+hl [r4k]" => sub {
			my($cpu) = @_;
			for my $pp1 ('pw', 'px', 'py', 'pz') {
				for my $pp2 ('pw', 'px', 'py', 'pz') {
					add_opcode_rabbit_altd($cpu, "ld $pp1, $pp2+hl", [0x6D, 0x0E+64*RABBIT_PP($pp1)+16*RABBIT_PP($pp2)]);
				}
			}
		},
		"ld <pp>, <pp>+ix [r4k]" => sub {
			my($cpu) = @_;
			for my $pp1 ('pw', 'px', 'py', 'pz') {
				for my $pp2 ('pw', 'px', 'py', 'pz') {
					add_opcode_rabbit_altd($cpu, "ld $pp1, $pp2+ix", [0x6D, 0x04+64*RABBIT_PP($pp1)+16*RABBIT_PP($pp2)]);
				}
			}
		},
		"ld <pp>, <pp>+iy [r4k]" => sub {
			my($cpu) = @_;
			for my $pp1 ('pw', 'px', 'py', 'pz') {
				for my $pp2 ('pw', 'px', 'py', 'pz') {
					add_opcode_rabbit_altd($cpu, "ld $pp1, $pp2+iy", [0x6D, 0x05+64*RABBIT_PP($pp1)+16*RABBIT_PP($pp2)]);
				}
			}
		},
		"ld <pp>, (htr+hl) [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode($cpu, "ld $pp, (htr+hl)", [0xED, 0x01+16*RABBIT_PP($pp)]);
			}
		},
		"ld <pp>, (<pp>+DIS) [r4k]" => sub {
			my($cpu) = @_;
			for my $pp1 ('pw', 'px', 'py', 'pz') {
				for my $pp2 ('pw', 'px', 'py', 'pz') {
					add_opcode_rabbit_altd($cpu, "ld $pp1, ($pp2+%d)", [0x6D, 0x08+64*RABBIT_PP($pp1)+16*RABBIT_PP($pp2), '%d']);
				}
			}
		},
		"ld <pp>, (<pp>+hl) [r4k]" => sub {
			my($cpu) = @_;
			for my $pp1 ('pw', 'px', 'py', 'pz') {
				for my $pp2 ('pw', 'px', 'py', 'pz') {
					add_opcode_rabbit_altd($cpu, "ld $pp1, ($pp2+hl)", [0x6D, 0x0A+64*RABBIT_PP($pp1)+16*RABBIT_PP($pp2)]);
				}
			}
		},
		"ld <pp>, (sp+N) [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode($cpu, "ld $pp, (sp+%n)", [0xED, 0x04+16*RABBIT_PP($pp), '%n']);
				add_opcode($cpu, "ld $pp, (sp)", [0xED, 0x04+16*RABBIT_PP($pp), 0]);
			}
		},
		"ld (sp+N), <pp> [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode($cpu, "ld (sp+%n), $pp", [0xED, 0x05+16*RABBIT_PP($pp), '%n']);
				add_opcode($cpu, "ld (sp), $pp", [0xED, 0x05+16*RABBIT_PP($pp), 0]);
			}
		},
		"ld <rp>, (<pp>+DIS) [r4k]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de') {
				for my $pp ('pw', 'px', 'py', 'pz') {
					add_opcode_rabbit_altd($cpu, "ld $rp, ($pp+%d)", [0x6D, 0x00+16*RABBIT_PP($pp)+64*RP($rp), '%d']);
				}
			}
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode($cpu, "ld ix, ($pp+%d)", [0x6D, 0x80+16*RABBIT_PP($pp), '%d']);
				add_opcode($cpu, "ld iy, ($pp+%d)", [0x6D, 0xC0+16*RABBIT_PP($pp), '%d']);
			}
		},
		"ld <rp>, (<pp>+hl) [r4k]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de') {
				for my $pp ('pw', 'px', 'py', 'pz') {
					add_opcode_rabbit_altd($cpu, "ld $rp, ($pp+hl)", [0x6D, 0x02+16*RABBIT_PP($pp)+64*RP($rp)]);
				}
			}
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode($cpu, "ld ix, ($pp+hl)", [0x6D, 0x82+16*RABBIT_PP($pp)]);
				add_opcode($cpu, "ld iy, ($pp+hl)", [0x6D, 0xC2+16*RABBIT_PP($pp)]);
			}
		},
		"ld <r>, <r> [r2ka]" => sub {
			my($cpu) = @_;
			for my $d ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
				for my $s ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
					next if $d eq '(hl)' && $d eq $s;
					next if $cpu =~ /ez80/ && "$s$d" =~ /bb|cc|dd|ee/;				# .SIS, .LIS, .SIL, .LIL prefixes
					next if $cpu =~ /^kc160(_strict)?$/ && "$s$d" =~ /bb|cc|dd|ee|hh|ll|aa/;	# x, y, a, p, z prefixes
					if (!get_opcode($cpu, "ld $d, $s")) {
						add_opcode_rabbit_altd($cpu, "ld $d, $s", [0x40+8*R($d)+R($s)]);
					}
				}
			}
		},
		"ld <r>, <r> [r4k]" => sub {
			my($cpu) = @_;
			for my $d ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
				for my $s ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
					next if $d eq '(hl)' && $d eq $s;
					next if $cpu =~ /ez80/ && "$s$d" =~ /bb|cc|dd|ee/;				# .SIS, .LIS, .SIL, .LIL prefixes
					next if $cpu =~ /^kc160(_strict)?$/ && "$s$d" =~ /bb|cc|dd|ee|hh|ll|aa/;	# x, y, a, p, z prefixes
					if (!get_opcode($cpu, "ld $d, $s")) {
						add_opcode_rabbit_altd($cpu, "ld $d, $s", [0x7F, 0x40+8*R($d)+R($s)]);
					}
				}
			}
		},
		"ld <r>, N [r2ka]" => sub {
			my($cpu) = @_;
			for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
				if (!get_opcode($cpu, "ld $r, %n")) {
					add_opcode_rabbit_altd($cpu, "ld $r, %n", [0x06+8*R($r), '%n']);
				}
			}
		},
		"mov <r>, <r> [r4k]" => sub {
			my($cpu) = @_;
			for my $d ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
				for my $s ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
					next if $d eq 'm' && $d eq $s;
					next if $cpu =~ /ez80/ && "$s$d" =~ /bb|cc|dd|ee/;				# .SIS, .LIS, .SIL, .LIL prefixes
					next if $cpu =~ /^kc160(_strict)?$/ && "$s$d" =~ /bb|cc|dd|ee|hh|ll|aa/;	# x, y, a, p, z prefixes
					if (!get_opcode($cpu, "mov $d, $s")) {
						add_opcode($cpu, "mov $d, $s", [0x7F, 0x40+8*R($d)+R($s)]);
					}
				}
			}
		},
		"ld <r>, (hl) [r2ka]" => sub {
			my($cpu) = @_;
			for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
				if (!get_opcode($cpu, "ld $r, (hl)")) {
					add_opcode_rabbit_altd_io($cpu, "ld $r, (hl)", [0x46+8*R($r)]);
				}
			}
		},
		"ld <r>, (<x>+DIS) [r2ka]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
					if (!get_opcode($cpu, "ld $r, ($x+%d)")) {
						add_opcode_rabbit_altd_io($cpu, "ld $r, ($x+%d)", [PFX($x), 0x46+8*R($r), '%d']);
					}
				}
			}
		},
		"ld (hl), N [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_io($cpu, "ld (hl), %n", [0x36, '%n']);
		},
		"ld (hl), <r> [r2ka]" => sub {
			my($cpu) = @_;
			for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
				if (!get_opcode($cpu, "ld (hl), $r")) {
					add_opcode_rabbit_io($cpu, "ld (hl), $r", [0x70+R($r)]);
				}
			}
		},
		"ld (hl), bcde [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_io($cpu, "ld (hl), bcde", [0xDD, 0x1B]);
		},
		"ld (hl), jkhl [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_io($cpu, "ld (hl), jkhl", [0xFD, 0x1B]);
		},
		"ld (hl+DIS), hl [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_io($cpu, "ld (hl+%d), hl", [0xDD, 0xF4, '%d']);
		},
		"ld (<x>+DIS), hl [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_io($cpu, "ld (ix+%d), hl", [0xF4, '%d']);
			add_opcode_rabbit_io($cpu, "ld (iy+%d), hl", [0xFD, 0xF4, '%d']);
		},
		"ld (<x>+DIS), N [r2ka]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode_rabbit_io($cpu, "ld ($x+%d), %n", [PFX($x), 0x36, '%d', '%n']);
			}
		},
		"ld (<x>+DIS), <r> [r2ka]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
					add_opcode_rabbit_io($cpu, "ld ($x+%d), $r", [PFX($x), 0x70+R($r), '%d']);
				}
			}
		},
		"ld (<x>+DIS), bcde|jkhl [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_io($cpu, "ld (ix+%d), bcde", [0xDD, 0xCF, '%d']);
			add_opcode_rabbit_io($cpu, "ld (ix+%d), jkhl", [0xFD, 0xCF, '%d']);
			add_opcode_rabbit_io($cpu, "ld (iy+%d), bcde", [0xDD, 0xDF, '%d']);
			add_opcode_rabbit_io($cpu, "ld (iy+%d), jkhl", [0xFD, 0xDF, '%d']);
		},
		"ld (NN), <x> [r2ka]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode_rabbit_io($cpu, "ld (%m), $x", [PFX($x), 0x22, '%m', '%m']);
			}
		},
		"ld (NN), bcde|jkhl [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_io($cpu, "ld (%m), bcde", [0x83, '%m', '%m']);
			add_opcode_rabbit_io($cpu, "ld (%m), jkhl", [0x84, '%m', '%m']);
		},
		"ld (NN), jk [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_io($cpu, "ld (%m), jk", [0x89, '%m', '%m']);
		},
		"ld (<pp>+bc), hl [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode($cpu, "ld ($pp+bc), hl", [0xED, 0x07+16*RABBIT_PP($pp)]);
			}
		},
		"ld (<pp>+DIS), a [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode($cpu, "ld ($pp+%d), a", [0x8E+16*RABBIT_PP($pp), '%d']);
			}
		},
		"ld (<pp>+DIS), bcde [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode($cpu, "ld ($pp+%d), bcde", [0xDD, 0x0F+16*RABBIT_PP($pp), '%d']);
			}
		},
		"ld (<pp>+DIS), hl [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode($cpu, "ld ($pp+%d), hl", [0x86+16*RABBIT_PP($pp), '%d']);
			}
		},
		"ld (<pp>+DIS), jkhl [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode($cpu, "ld ($pp+%d), jkhl", [0xFD, 0x0F+16*RABBIT_PP($pp), '%d']);
			}
		},
		"ld (<pp>+DIS), <pd> [r4k]" => sub {
			my($cpu) = @_;
			for my $pp1 ('pw', 'px', 'py', 'pz') {
				for my $pp2 ('pw', 'px', 'py', 'pz') {
					add_opcode($cpu, "ld ($pp1+%d), $pp2", [0x6D, 0x09+16*RABBIT_PP($pp1)+64*RABBIT_PP($pp2), '%d']);
				}
			}
		},
		"ld (<pp>+DIS), <rp> [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				for my $rp ('bc', 'de') {
					add_opcode($cpu, "ld ($pp+%d), $rp", [0x6D, 0x01+16*RABBIT_PP($pp)+64*RP($rp), '%d']);
				}
				add_opcode($cpu, "ld ($pp+%d), ix", [0x6D, 0x81+16*RABBIT_PP($pp), '%d']);
				add_opcode($cpu, "ld ($pp+%d), iy", [0x6D, 0xC1+16*RABBIT_PP($pp), '%d']);
			}
		},
		"ld (<pp>+hl), a [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode($cpu, "ld ($pp+hl), a", [0x8C+16*RABBIT_PP($pp)]);
			}
		},
		"ld (<pp>+hl), bcde [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode($cpu, "ld ($pp+hl), bcde", [0xDD, 0x0D+16*RABBIT_PP($pp)]);
			}
		},
		"ld (<pp>+hl), jkhl [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode($cpu, "ld ($pp+hl), jkhl", [0xFD, 0x0D+16*RABBIT_PP($pp)]);
			}
		},
		"ld (<pp>+hl), <pd> [r4k]" => sub {
			my($cpu) = @_;
			for my $pp1 ('pw', 'px', 'py', 'pz') {
				for my $pp2 ('pw', 'px', 'py', 'pz') {
					add_opcode($cpu, "ld ($pp1+hl), $pp2", [0x6D, 0x0B+16*RABBIT_PP($pp1)+64*RABBIT_PP($pp2)]);
				}
			}
		},
		"ld (<pp>+hl), <rp> [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				for my $rp ('bc', 'de') {
					add_opcode($cpu, "ld ($pp+hl), $rp", [0x6D, 0x03+16*RABBIT_PP($pp)+64*RP($rp)]);
				}
				add_opcode($cpu, "ld ($pp+hl), ix", [0x6D, 0x83+16*RABBIT_PP($pp)]);
				add_opcode($cpu, "ld ($pp+hl), iy", [0x6D, 0xC3+16*RABBIT_PP($pp)]);
			}
		},
		"ld (sp+hl), bcde [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ld (sp+hl), bcde", [0xDD, 0xFF]);
		},
		"ld (sp+hl), jkhl [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ld (sp+hl), jkhl", [0xFD, 0xFF]);
		},
		"ldf a, (NNN) [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "ldf a, (%m)", [0x9A, '%m', '%m', '%m']);
		},
		"ldf (NNN), a [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ldf (%m), a", [0x8A, '%m', '%m', '%m']);
		},
		"ldf hl, (NNN) [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "ldf hl, (%m)", [0x92, '%m', '%m', '%m']);
		},
		"ldf (NNN), hl [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ldf (%m), hl", [0x82, '%m', '%m', '%m']);
		},
		"ldf bcde, (NNN) [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "ldf bcde, (%m)", [0xDD, 0x0A, '%m', '%m', '%m']);
		},
		"ldf (NNN), bcde [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ldf (%m), bcde", [0xDD, 0x0B, '%m', '%m', '%m']);
		},
		"ldf jkhl, (NNN) [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "ldf jkhl, (%m)", [0xFD, 0x0A, '%m', '%m', '%m']);
		},
		"ldf (NNN), jkhl [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ldf (%m), jkhl", [0xFD, 0x0B, '%m', '%m', '%m']);
		},
		"ldf <pp>, (NNN) [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode_rabbit_altd($cpu, "ldf $pp, (%m)", [0xED, 0x08+16*RABBIT_PP($pp), '%m', '%m', '%m']);
			}
		},
		"ldf (NNN), <pp> [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode($cpu, "ldf (%m), $pp", [0xED, 0x09+16*RABBIT_PP($pp), '%m', '%m', '%m']);
			}
		},
		"ldf <rp>, (NNN) [r4k]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de') {
				add_opcode_rabbit_altd($cpu, "ldf $rp, (%m)", [0xED, 0x0A+16*RP($rp), '%m', '%m', '%m']);
			}
			add_opcode($cpu, "ldf ix, (%m)", [0xED, 0x2A, '%m', '%m', '%m']);
			add_opcode($cpu, "ldf iy, (%m)", [0xED, 0x3A, '%m', '%m', '%m']);
		},
		"ldf (NNN), <rp> [r4k]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de') {
				add_opcode($cpu, "ldf (%m), $rp", [0xED, 0x0B+16*RP($rp), '%m', '%m', '%m']);
			}
			add_opcode($cpu, "ldf (%m), ix", [0xED, 0x2B, '%m', '%m', '%m']);
			add_opcode($cpu, "ldf (%m), iy", [0xED, 0x3B, '%m', '%m', '%m']);
		},
		"ldl <pp>, de [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode_rabbit_altd($cpu, "ldl $pp, de", [0xDD, 0x8F+16*RABBIT_PP($pp)]);
			}
		},
		"ldl <pp>, hl [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode_rabbit_altd($cpu, "ldl $pp, hl", [0xFD, 0x8F+16*RABBIT_PP($pp)]);
			}
		},
		"ldl <pp>, <x> [r4k]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $pp ('pw', 'px', 'py', 'pz') {
					add_opcode_rabbit_altd($cpu, "ldl $pp, $x", [PFX($x), 0x8C+16*RABBIT_PP($pp)]);
				}
			}
		},
		"ldl <pp>, NN [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode_rabbit_altd($cpu, "ldl $pp, %m", [0xED, 0x0D+16*RABBIT_PP($pp), '%m', '%m']);
			}
		},
		"ldl <pp>, (sp+N) [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode_rabbit_altd($cpu, "ldl $pp, (sp+%n)", [0xED, 0x03+16*RABBIT_PP($pp), '%n']);
				add_opcode_rabbit_altd($cpu, "ldl $pp, (sp)", [0xED, 0x03+16*RABBIT_PP($pp), 0]);
			}
		},
		"ldp hl, (hl) [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ldp hl, (hl)", [0xED, 0x6C]);
		},
		"ldp hl, (<x>) [r2ka]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode($cpu, "ldp hl, ($x)", [PFX($x), 0x6C]);
			}
		},
		"ldp hl, (NN) [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ldp hl, (%m)", [0xED, 0x6D, '%m', '%m']);
		},
		"ldp <x>, (NN) [r2ka]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode($cpu, "ldp $x, (%m)", [PFX($x), 0x6D, '%m', '%m']);
			}
		},
		"ldp (hl), hl [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ldp (hl), hl", [0xED, 0x64]);
		},
		"ldp (<x>), hl [r2ka]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode($cpu, "ldp ($x), hl", [PFX($x), 0x64]);
			}
		},
		"ldp (NN), hl [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ldp (%m), hl", [0xED, 0x65, '%m', '%m']);
		},
		"ldp (NN), <x> [r2ka]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode($cpu, "ldp (%m), $x", [PFX($x), 0x65, '%m', '%m']);
			}
		},
		"ljp N, NN [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ljp %x, %m", [0xC7, '%m', '%m', '%x']);
		},
		"llcall NN, NN [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "llcall %x, %m", [0x8F, '%m', '%m', '%x', '%x']);
		},
		"llcall (jkhl) [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "llcall (jkhl)", [0xED, 0xFA]);
		},
		"lljp <f>, NN, NN [r4k]" => sub {
			my($cpu) = @_;
			for my $f ('nz', 'z', 'nc', 'c') {
				add_opcode($cpu, "lljp $f, %x, %m", [0xED, 0xC2+8*F($f), '%m', '%m', '%x', '%x']);
			}
			for my $xf ('gt', 'gtu', 'lt', 'v') {
				add_opcode($cpu, "lljp $xf, %x, %m", [0xED, 0xA2+8*XF($xf), '%m', '%m', '%x', '%x']);
			}
		},
		"lljp NN, NN [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "lljp %x, %m", [0x87, '%m', '%m', '%x', '%x']);
		},
		"llret [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "llret", [0xED, 0x8B]);
		},
		"lret [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "lret", [0xED, 0x45]);
		},
		"lsddr/lsidr [r3k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_io($cpu, "lsddr", [0xED, 0xD8]);
			add_opcode_rabbit_io($cpu, "lsidr", [0xED, 0xD0]);
		},
		"lsdr/lsir [r3k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_io($cpu, "lsdr", [0xED, 0xF8]);
			add_opcode_rabbit_io($cpu, "lsir", [0xED, 0xF0]);
		},
		"mul [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "mul", [0xF7]);
		},
		"mulu [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "mulu", [0xA7]);
		},
		"neg [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "neg", [0xED, 0x44]);
		},
		"neg a [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "neg a", [0xED, 0x44]);
		},
		"neg bcde [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "neg bcde", [0xDD, 0x4D]);
		},
		"neg jkhl [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "neg jkhl", [0xFD, 0x4D]);
		},
		"neg hl [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "neg hl", [0x4D]);
		},
		"or hl, de [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "or hl, de", [0xEC]);
		},
		"or <x>, de [r2ka]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode($cpu, "or $x, de", [PFX($x), 0xEC]);
			}
		},
		"or jkhl, bcde [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "or jkhl, bcde", [0xED, 0xF6]);
		},
		"push/pop <rp> [r2ka]" => sub {
			my($cpu) = @_;
			for my $rp ('bc', 'de', 'hl', 'af') {
				add_opcode($cpu, "push $rp", [0xC5+16*RP($rp)]);
				add_opcode_rabbit_altd($cpu, "pop $rp", [0xC1+16*RP($rp)]);
			}
		},
		"push/pop bcde/jkhl [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "push bcde", [0xDD, 0xF5]);
			add_opcode($cpu, "push jkhl", [0xFD, 0xF5]);
			add_opcode_rabbit_altd($cpu, "pop bcde", [0xDD, 0xF1]);
			add_opcode_rabbit_altd($cpu, "pop jkhl", [0xFD, 0xF1]);
		},
		"push/pop ip [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "push ip", [0xED, 0x76]);
			add_opcode($cpu, "pop ip", [0xED, 0x7E]);
		},
		"push/pop <pp> [r4k]" => sub {
			my($cpu) = @_;
			for my $pp ('pw', 'px', 'py', 'pz') {
				add_opcode($cpu, "push $pp", [0xED, 0xC5+16*RABBIT_PP($pp)]);
				add_opcode_rabbit_altd($cpu, "pop $pp", [0xED, 0xC1+16*RABBIT_PP($pp)]);
			}
		},
		"push/pop su [r3k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "push su", [0xED, 0x66]);
			add_opcode($cpu, "pop su", [0xED, 0x6E]);
		},
		"push NN [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "push %m", [0xED, 0xA5, '%m', '%m']);
		},
		"rdmode [r3k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "rdmode", [0xED, 0x7F]);
		},
		"rl bc/hl [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "rl bc", [0x62]);
			add_opcode_rabbit_altd($cpu, "rl hl", [0x42]);
		},
		"rl B, bcde/jkhl [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "rl %c, bcde", [0xDD, 0x68."+%c-1"], 
								[1, 2, 4]);
			add_opcode_rabbit_altd($cpu, "rl %c, jkhl", [0xFD, 0x68."+%c-1"], 
								[1, 2, 4]);
		},
		"rl de [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "rl de", [0xF3]);
		},
		"<rot> <r> [r2ka]" => sub {
			my($cpu) = @_;
			for my $op ('rlc', 'rrc', 'rl', 'rr', 'sla', 'sra', 'srl') {
				for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
					if (!get_opcode($cpu, "$op $r")) {
						add_opcode_rabbit_altd($cpu, "$op $r", [0xCB, 8*ROT($op)+R($r)]);
					}
				}
			}
		},
		"<rot> (hl) [r2ka]" => sub {
			my($cpu) = @_;
			for my $op ('rlc', 'rrc', 'rl', 'rr', 'sla', 'sra', 'srl') {
				if (!get_opcode($cpu, "$op (hl)")) {
					add_opcode_rabbit_altd_io($cpu, "$op (hl)", [0xCB, 8*ROT($op)+6]);
				}
			}
		},
		"<rot> (<x>+DIS) [r2ka]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				for my $op ('rlc', 'rrc', 'rl', 'rr', 'sla', 'sra', 'srl') {
					add_opcode_rabbit_altd_io($cpu, "$op ($x+%d)", 
							   [PFX($x), 0xCB, '%d', 8*ROT($op)+6]);
				}
			}
		},
		"<rot-a> [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "rlca", [0x07]);
			add_opcode($cpu, "rlca'", [RABBIT_CONST('altd'), 0x07]);
			add_opcode($cpu, "altd rlca", [RABBIT_CONST('altd'), 0x07]);
			
			add_opcode($cpu, "rrca", [0x0F]);
			add_opcode($cpu, "rrca'", [RABBIT_CONST('altd'), 0x0F]);
			add_opcode($cpu, "altd rrca", [RABBIT_CONST('altd'), 0x0F]);
			
			add_opcode($cpu, "rla", [0x17]);
			add_opcode($cpu, "rla'", [RABBIT_CONST('altd'), 0x17]);
			add_opcode($cpu, "altd rla", [RABBIT_CONST('altd'), 0x17]);
			
			add_opcode($cpu, "rra", [0x1F]);
			add_opcode($cpu, "rra'", [RABBIT_CONST('altd'), 0x1F]);
			add_opcode($cpu, "altd rra", [RABBIT_CONST('altd'), 0x1F]);
		},
		"rlb a, bcde/jkhl [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "rlb a, bcde", [0xDD, 0x6F]);
			add_opcode($cpu, "rlb a, jkhl", [0xFD, 0x6F]);
		},
		"rlc bc/de [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "rlc bc", [0x60]);
			add_opcode_rabbit_altd($cpu, "rlc de", [0x50]);
		},
		"rlc B, bcde/jkhl [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "rlc %c, bcde", [0xDD, "%c==8?".0x4F.":".0x48."+%c-1"], 
								[1, 2, 4, 8]);
			add_opcode($cpu, "rlc %c, jkhl", [0xFD, "%c==8?".0x4F.":".0x48."+%c-1"], 
								[1, 2, 4, 8]);
			add_opcode($cpu, "altd rlc %c, bcde", [RABBIT_CONST('altd'), 0xDD, 0x48."+%c-1"], 
								[1, 2, 4]);
			add_opcode($cpu, "altd rlc %c, jkhl", [RABBIT_CONST('altd'), 0xFD, 0x48."+%c-1"], 
								[1, 2, 4]);
			add_opcode($cpu, "rlc %c, bcde'", [RABBIT_CONST('altd'), 0xDD, 0x48."+%c-1"], 
								[1, 2, 4]);
			add_opcode($cpu, "rlc %c, jkhl'", [RABBIT_CONST('altd'), 0xFD, 0x48."+%c-1"], 
								[1, 2, 4]);
		},
		"rr bc [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "rr bc", [0x63]);
		},
		"rr B, bcde/jkhl [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "rr %c, bcde", [0xDD, 0x78."+%c-1"], 
								[1, 2, 4]);
			add_opcode_rabbit_altd($cpu, "rr %c, jkhl", [0xFD, 0x78."+%c-1"], 
								[1, 2, 4]);
		},
		"rr de/hl [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "rr de", [0xFB]);
			add_opcode_rabbit_altd($cpu, "rr hl", [0xFC]);
		},
		"rr <x> [r2ka]" => sub {
			my($cpu) = @_;
			for my $x ('ix', 'iy') {
				add_opcode($cpu, "rr $x", [PFX($x), 0xFC]);
			}
		},
		"rrb a, bcde/jkhl [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "rrb a, bcde", [0xDD, 0x7F]);
			add_opcode($cpu, "rrb a, jkhl", [0xFD, 0x7F]);
		},
		"rrc bc/de [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "rrc bc", [0x61]);
			add_opcode_rabbit_altd($cpu, "rrc de", [0x51]);
		},
		"rrc B, bcde/jkhl [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "rrc %c, bcde", [0xDD, "%c==8?".0x5F.":".0x58."+%c-1"], 
								[1, 2, 4, 8]);
			add_opcode($cpu, "rrc %c, jkhl", [0xFD, "%c==8?".0x5F.":".0x58."+%c-1"], 
								[1, 2, 4, 8]);
			add_opcode($cpu, "altd rrc %c, bcde", [RABBIT_CONST('altd'), 0xDD, 0x58."+%c-1"], 
								[1, 2, 4]);
			add_opcode($cpu, "altd rrc %c, jkhl", [RABBIT_CONST('altd'), 0xFD, 0x58."+%c-1"], 
								[1, 2, 4]);
			add_opcode($cpu, "rrc %c, bcde'", [RABBIT_CONST('altd'), 0xDD, 0x58."+%c-1"], 
								[1, 2, 4]);
			add_opcode($cpu, "rrc %c, jkhl'", [RABBIT_CONST('altd'), 0xFD, 0x58."+%c-1"], 
								[1, 2, 4]);
		},
		"scf' [r2ka]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "scf'", [RABBIT_CONST('altd'), 0x37]);
			add_opcode($cpu, "altd scf", [RABBIT_CONST('altd'), 0x37]);
		},
		"setsysp NN [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "setsysp %m", [0xED, 0xB1, '%m', '%m']);
		},
		"setusr [r3k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "setusr", [0xED, 0x6F]);
		},
		"setusrp NN [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "setusrp %m", [0xED, 0xB5, '%m', '%m']);
		},
		"sla B, bcde/jkhl [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "sla %c, bcde", [0xDD, 0x88."+%c-1"], 
								[1, 2, 4]);
			add_opcode_rabbit_altd($cpu, "sla %c, jkhl", [0xFD, 0x88."+%c-1"], 
								[1, 2, 4]);
		},
		"sll B, bcde/jkhl [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "sll %c, bcde", [0xDD, 0xA8."+%c-1"], 
								[1, 2, 4]);
			add_opcode_rabbit_altd($cpu, "sll %c, jkhl", [0xFD, 0xA8."+%c-1"], 
								[1, 2, 4]);
		},
		"sra B, bcde/jkhl [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "sra %c, bcde", [0xDD, 0x98."+%c-1"], 
								[1, 2, 4]);
			add_opcode_rabbit_altd($cpu, "sra %c, jkhl", [0xFD, 0x98."+%c-1"], 
								[1, 2, 4]);
		},
		"srl B, bcde/jkhl [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "srl %c, bcde", [0xDD, 0xB8."+%c-1"], 
								[1, 2, 4]);
			add_opcode_rabbit_altd($cpu, "srl %c, jkhl", [0xFD, 0xB8."+%c-1"], 
								[1, 2, 4]);
		},
		"sub hl, de [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "sub hl, de", [0x55]);
		},
		"sub hl, jk [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "sub hl, jk", [0x45]);
		},
		"sub jkhl, bcde [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "sub jkhl, bcde", [0xED, 0xD6]);
		},
		"sures [r3k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "sures", [0xED, 0x7D]);
		},
		"syscall [r3k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "syscall", [0xED, 0x75]);
		},
		"sysret [r4k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "sysret", [0xED, 0x83]);
			add_opcode($cpu, "sret", [0xED, 0x83]);
		},
		"test <> [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "test hl", [0x4C]);
			add_opcode_rabbit_altd($cpu, "test bc", [0xED, 0x4C]);
			add_opcode_rabbit_altd($cpu, "test bcde", [0xDD, 0x5C]);
			add_opcode_rabbit_altd($cpu, "test jkhl", [0xFD, 0x5C]);
			add_opcode_rabbit_altd($cpu, "test ix", [0xDD, 0x4C]);
			add_opcode_rabbit_altd($cpu, "test iy", [0xFD, 0x4C]);
		},
		"uma [r3k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "uma", [0xED, 0xC0]);
		},
		"ums [r3k]" => sub {
			my($cpu) = @_;
			add_opcode($cpu, "ums", [0xED, 0xC8]);
		},
		"xor hl, de [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "xor hl, de", [0x54]);
		},
		"xor jkhl, bcde [r4k]" => sub {
			my($cpu) = @_;
			add_opcode_rabbit_altd($cpu, "xor jkhl, bcde", [0xED, 0xEE]);
		},
	};
	
	$actions->{$key}->($cpu);
}
	
#------------------------------------------------------------------------------
# make opcodes
#------------------------------------------------------------------------------
require "opcodes_8080.pl";
require "opcodes_8085.pl";
require "opcodes_gbz80.pl";
require "opcodes_z80.pl";
require "opcodes_z80n.pl";
require "opcodes_z180.pl";
require "opcodes_ez80.pl";
require "opcodes_r800.pl";
require "opcodes_kc160.pl";
require "opcodes_rabbit.pl";

#------------------------------------------------------------------------------
# syntetic opcodes
#------------------------------------------------------------------------------
do "opcodes_synth.pl";
$@ and die $@;

#------------------------------------------------------------------------------
# write file
#------------------------------------------------------------------------------
$opcodes->to_file($output_file);
