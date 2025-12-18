package Opcode;

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
#	%m1	%m+1
# 	%x	segment, 8 or 16 bits
#	%M	unsigned word, big-endian
#	%j	jr offset
#	%J	jre offset
#	%c	constant (im, bit, rst, ...)
#	%d	signed byte
#	%d1	%d+1
#	%t	temp jump label to end of statement; %t3 to end of statement - 3
#------------------------------------------------------------------------------

use Modern::Perl;
use warnings FATAL => 'all';

my @fields = 	 qw( asm cpu synth const ops );
use Object::Tiny qw( asm cpu synth const ops );
use Clone;

# all CPUs
my @CPUS = (qw(
	z80			z80_strict
	z80n		    z80n_strict
	z180		    z180_strict
	ez80		    ez80_strict
	ez80_z80	    ez80_z80_strict
	r800		    r800_strict
	r2ka		    r2ka_strict
	r3k			r3k_strict
	r4k			r4k_strict
	r5k			r5k_strict
	r6k			r6k_strict
	8080 		8080_strict
	8085		    8085_strict
	gbz80		gbz80_strict
	kc160		kc160_strict
	kc160_z80	kc160_z80_strict
));

# create constants for each cpu
my %CPUS;
for my $cpu (@CPUS) {
	$CPUS{$cpu} = 1;
	eval "sub cpu_$cpu() { return '$cpu'; }"; $@ and die $@;
}

sub cpus {
	my($class) = @_;
	return sort @CPUS;
}

sub new {
	my($class, %args) = @_;
	my $self = bless {}, $class;
	
	$self->{asm} = delete $args{asm} || '';
	$self->asm or die "assembly not defined";
	
	$self->{cpu} = delete $args{cpu} || "z80";
	$CPUS{$self->cpu} or die "cpu not found: ", $self->cpu;
	
	$self->{synth} = delete $args{synth} || 0;
	
	# list of constants for %c
	$self->{const} = delete $args{const} || [];

	# list of opcodes, each list of bytes or %X
	$self->{ops} = delete $args{ops} || [[]];

	%args and die "extra arguments: ", join(" ", keys %args);
	
	return $self;
}

sub clone {
	my($self, $replace_asm_f, $replace_bytes_f) = @_;
	
	my $new = Clone::clone($self);

	for ($new->{asm}) {
		$replace_asm_f->();
	}
	
	for my $op (@{$new->ops}) {
		for (@$op) {
			$replace_bytes_f->();
		}
	}
	
	return $new;
}

sub bytes {
	my($self) = @_;
	
	my @bytes;
	for my $op (@{$self->ops}) {
		for my $byte (@$op) {
			push @bytes, $byte;
		}
	}
	
	return @bytes;
}

# input/output to data file
sub titles {
	my($class) = @_;
	return join("|", @fields);
}

sub to_string {
	my($self) = @_;
	my @output = ($self->asm, 
				  $self->cpu, 
				  $self->synth ? "X" : "_",
				  join(",", @{$self->const}));
	my @ops;
	for my $op (@{$self->ops}) {
		my @bytes;
		for my $byte (@$op) {
			if ($byte =~ /^\d+$/) {
				push @bytes, sprintf("%02X", $byte);
			}
			else {
				push @bytes, $byte;
			}
		}
		push @ops, join(" ", @bytes);
	}
	push @output, join(";", @ops);
	my $output = join("|", @output);
	return $output;
}

sub from_string {
	my($class, $str) = @_;
	chomp($str);
	my @fields = split(/\|/, $str);
	@fields == 5 or die "insufficient data: $str";
	my @ops = split(/;/, $fields[4]);
	for (@ops) {
		my @bytes = split(' ', $_);
		for (@bytes) {
			if (/^[0-9a-f]+$/i) {
				$_ = hex($_);
			}
		}
		$_ = \@bytes;
	}
	my $self = $class->new(
						asm		=>	$fields[0], 
						cpu		=>	$fields[1], 
						synth	=>	$fields[2] =~ /x/i ? 1 : 0,
						const	=>  [split(/,/, $fields[3])],
						ops		=>	\@ops);
	return $self;
}

#------------------------------------------------------------------------------

package Opcodes;

use Modern::Perl;
use Clone 'clone';
use Object::Tiny qw( opcodes );

sub new {
	my($class) = @_;
	my $self = bless { opcodes => {} }, $class;
	return $self;
}

sub add {
	my($self, $opcode) = @_;
	my $asm = $opcode->asm;
	my $cpu = $opcode->cpu;
	if ($self->opcodes->{$asm} &&
		$self->opcodes->{$asm}{$cpu}) {
		die "opcode already exists: ", 
			$self->opcodes->{$asm}{$cpu}->to_string, " ",
			$opcode->to_string;
	}
	
	$self->opcodes->{$asm}{$cpu} = $opcode;
	
	#say STDERR "add ", $opcode->cpu, " ", $opcode->asm if $ENV{DEBUG};
	#use Carp 'longmess';
	#warn "$cpu\t$asm\n".longmess() if $asm eq "ld (ix), bc";
}

sub copy_cpu {
	my($self, $ori_cpu, $new_cpu, $filter) = @_;

	for my $asm (sort keys %{$self->opcodes}) {
		if ($self->exists($ori_cpu, $asm)) {
			my $opcode = clone($self->opcodes->{$asm}{$ori_cpu});
			$opcode->{cpu} = $new_cpu;

			if ($filter->($opcode)) {
				$self->add($opcode);
			}
		}
	}
}

sub add_synth {
	my($self, $cpu, $asm, @asm_statements) = @_;
	
	if ($self->exists($cpu, $asm)) {	# opcode already exists
		return;
	}
	
	if ($cpu =~ /_strict/) {			# no sythetic opcodes in strict mode
		return;
	}

	#say STDERR "try add ", $cpu, " ", $asm if $ENV{DEBUG};

	my @subops;
	my @subasm = split(/\n| : /, join("\n", @asm_statements));
	for my $subasm (@subasm) {
		$subasm =~ s/^\s+//; $subasm =~ s/\s+$//;
		
		# get opcode
		my $subopcode = $self->search_opcode($cpu, $subasm);
		if (!$subopcode) {
			#say STDERR "opcode not found: $cpu, $asm" if $ENV{DEBUG};
			return;
		}
		
		# remap bytes
		for my $op (@{$subopcode->ops}) {
			push @subops, clone($op);
		}
	}

	my $opcode = Opcode->new(asm=>$asm, cpu=>$cpu, synth=>1, ops=>\@subops);
	$self->add($opcode);
}

sub add_emul {
	my($self, $cpu, $asm, $func, @args) = @_;

	if ($cpu =~ /_strict/) {			# no sythetic opcodes in strict mode
		return;
	}

	if (!$self->exists($cpu, $asm)) {
		if (@args) {
			$self->add(Opcode->new(asm=>$asm, cpu=>$cpu, 
								   ops=>[[0xCD, '@'.$func, ''], \@args],
								   synth=>1));
		}
		else {
			$self->add(Opcode->new(asm=>$asm, cpu=>$cpu, 
								   ops=>[[0xCD, '@'.$func, '']],
								   synth=>1));
		}
	}
}

sub exists {
	my($self, $cpu, $asm) = @_;
	if ($self->opcodes->{$asm} &&
		$self->opcodes->{$asm}{$cpu}) {
		return 1;
	}
	else {
		return 0;
	}
}	

sub search_opcode {
	my($self, $cpu, $asm) = @_;
	
	my $asm1;
	
	# replace %m/%n/%d
	for my $wildcard ('%m', '%n', '%d') {
		if (($asm1 = $asm) =~ s/0x([0-9a-fA-F]+)/$wildcard/) {
			my $value = hex($1);
			my $opcode = $self->opcodes->{$asm1}{$cpu};
			if ($opcode) {
				return $self->_replace_opcode_nn($opcode, $wildcard, $value);
			}
		}
	}

	# replace 0:%d/0:%n
	if (($asm1 = $asm) =~ s/0:(%[dn])/%m/) {
		my $wildcard = $1;
		my $opcode = $self->opcodes->{$asm1}{$cpu};
		if ($opcode) {
			return $self->_replace_opcode_sign_extend($opcode, $wildcard);
		}
	}
	
	# replace %mN my %m
	if (($asm1 = $asm) =~ s/(%m\d)/%m/) {
		my $temp = $1;
		my $opcode = $self->opcodes->{$asm1}{$cpu};
		if ($opcode) {
			return $self->_replace_opcode_text($opcode, '%m', $temp);
		}
	}
	
	# replace %tN by %m
	# Note: jr %j can have %j in bytes, or %m in case of 8080
	for my $wildcard ('%m', '%j') {
		if (($asm1 = $asm) =~ s/(%t\d?)/$wildcard/) {
			my $temp = $1;
			my $opcode = $self->opcodes->{$asm1}{$cpu};
			if ($opcode) {
				my @bytes = $opcode->bytes;
				my $bytes = "@bytes";
				if ($bytes =~ /%m/) {
					return $self->_replace_opcode_text($opcode, '%m', $temp);
				}
				elsif ($bytes =~ /%j/) {
					return $self->_replace_opcode_text($opcode, '%j', $temp);
				}
				else {
					die $opcode->asm," $bytes";
				}
			}
		}
	}
	
	# replace %d1 by %d
	if (($asm1 = $asm) =~ s/%d1/%d/) {
		my $opcode = $self->opcodes->{$asm1}{$cpu};
		if ($opcode) {
			return $self->_replace_opcode_text($opcode, '%d', '%d1');
		}
	}
	
	my $opcode = $self->opcodes->{$asm}{$cpu};
	if (!$opcode) {
		#warn "opcode not found: $cpu, $asm" if $ENV{DEBUG};
	}
	return $opcode;
}

sub _replace_opcode_nn {
	my($self, $opcode, $wildcard, $value) = @_;
	$opcode = clone($opcode); 	# make deep copy
	for my $op ($opcode->ops) {
		for my $bytes (@$op) {
			if ($wildcard) {
				my $i = 0;
				while ($i < @$bytes && $bytes->[$i] ne $wildcard) {
					$i++;
				}
				if ($i < @$bytes) {
					while ($i < @$bytes && $bytes->[$i] eq $wildcard) {
						$bytes->[$i++] = $value & 0xff;
						$value >>= 8;
					}
					$wildcard = undef;
				}
			}
		}
	}
	return $opcode;
}

sub _replace_opcode_sign_extend {
	my($self, $opcode, $wildcard) = @_;
	$opcode = clone($opcode); 	# make deep copy
	for my $op ($opcode->ops) {
		for my $bytes (@$op) {
			if ($wildcard) {
				my $i = 0;
				while ($i < @$bytes && $bytes->[$i] ne '%m') {
					$i++;
				}
				while ($i < @$bytes) {
					if ($wildcard) {
						$bytes->[$i++] = $wildcard;
						$wildcard = undef;
					}
					else {
						$bytes->[$i++] = '%s'
					}
				}
			}
		}
	}
	return $opcode;
}

sub _replace_opcode_text {
	my($self, $opcode, $find, $replace) = @_;
	$opcode = clone($opcode); 	# make deep copy
	my $found;
	for my $op ($opcode->ops) {
		for my $bytes (@$op) {
			if (!$found) {
				my $i = 0;
				while ($i < @$bytes) {
					if ($bytes->[$i] eq $find) {
						$bytes->[$i] = $replace;
						$found = 1;
					}
					$i++;
				}
			}
		}
	}
	return $opcode;
}

# input/output to data file
sub to_file {
	my($self, $file) = @_;
	open(my $fh, ">", $file) or die "write $file: $!";
	say $fh Opcode->titles;
	for my $asm (sort keys %{$self->opcodes}) {
		for my $cpu (sort keys %{$self->opcodes->{$asm}}) {
			my $opcode = $self->opcodes->{$asm}{$cpu};
			say $fh $opcode->to_string;
		}
	}
}

sub from_file {
	my($class, $file) = @_;
	my $self = $class->new;
	open(my $fh, "<", $file) or die "read $file: $!";
	
	my $titles = <$fh>;
	chomp $titles;
	$titles eq Opcode->titles or die "invalid data file $file";
	
	while (<$fh>) {
		my $opcode = Opcode->from_string($_);
		$self->add($opcode);
	}
	return $self;
}

1;
