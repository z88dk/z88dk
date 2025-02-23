package Opcode;

#------------------------------------------------------------------------------
# Build CPU tables
# asm placeholders:
#	%s	signed byte
#	%n	unsigned byte
#   %h  high page offset
#	%m	unsigned word - 16, 24 or 32 bits
#	%m1	%m+1
#	%M	unsigned word, big-endian
#	%j	jr offset
#	%J	jre offset
#	%c	constant (im, bit, rst, ...)
#	%d	signed register indirect offset
#	%D	%d+1						TODO: should be %d1 for consistency
#	%u	unsigned register indirect offset
#	%t	temp jump label to end of statement; %t3 to end of statement - 3
#------------------------------------------------------------------------------

use Modern::Perl;

my @fields = 	 qw( asm cpu synth const ops );
use Object::Tiny qw( asm cpu synth const ops );
use Clone;

# all CPUs
my @CPUS = (qw(
	z80
	z80_strict
	z80n
	z180
	ez80
	ez80_z80
	r800
	r2ka
	r3k
	r4k
	r5k
	8080 
	8080_strict
	8085
	8085_strict
	gbz80
	kc160
	kc160_z80
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

sub add1 {
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
}

sub _is_post_increment {
	my($asm) = @_;
	if ($asm =~ /\((bc|de|hl)\)/) {		# (bc), (de), (hl)
		my $rp = $1;
		if ($asm =~ /altd|ioe|ioi|
				 	 call|jp|jmp|ldi|ldd|
				 	 ld\s\w\w+'?,\s\(\w\w+\)|
				 	 ld\s\(\w\w+\),\s\w\w+/x) {	# exceptions
			return 0;
		}
		else {
			return $rp;
		}
	}
	else {
		return 0;
	}
}

sub add {
	my($self, $opcode) = @_;
	my $asm = $opcode->asm;
	my $cpu = $opcode->cpu;

	$self->add1($opcode);

	# add post-increment/decrement sythetic opcodes
	if (my $rp = _is_post_increment($asm)) {
		for (['inc', '+', 'i'], ['dec', '-', 'd']) {
			my($action, $operator, $suffix) = @$_;
			my $action_opcode = $self->opcodes->{"$action $rp"}{$cpu};
			if (!$action_opcode) {
				warn "opcode not found: $cpu; $asm; $action $rp" if $ENV{DEBUG};
			}
			else {
				# (bc+)
				(my $new_asm = $asm) =~ s/\($rp\)/($rp$operator)/;
				my @subops = @{$opcode->ops};
				my @action_ops = @{$action_opcode->ops};

				my $new_opcode = Opcode->new(asm=>$new_asm, cpu=>$cpu, 
											 const=>clone($opcode->const),
											 ops=>[@subops, @action_ops],
											 synth=>1);
				$self->add1($new_opcode);

				# (hli)
				if ($rp eq 'hl') {
					($new_asm = $asm) =~ s/\($rp\)/($rp$suffix)/;

					my $new_opcode = Opcode->new(asm=>$new_asm, cpu=>$cpu, 
												const=>clone($opcode->const),
												ops=>[@subops, @action_ops],
												synth=>1);
					$self->add1($new_opcode);
				}

				# ldi
				if (($new_asm = $asm) =~ s/^ld\s/ld$suffix /) {
					$new_opcode = Opcode->new(asm=>$new_asm, cpu=>$cpu, 
											  const=>clone($opcode->const),
											  ops=>[@subops, @action_ops],
											  synth=>1);
					$self->add1($new_opcode);
				}
			}
		}
	}
}

sub copy_cpu {
	my($self, $ori_cpu, $new_cpu, $filter) = @_;

	for my $asm (sort keys %{$self->opcodes}) {
		if ($self->exists($asm, $ori_cpu)) {
			my $opcode = clone($self->opcodes->{$asm}{$ori_cpu});
			$opcode->{cpu} = $new_cpu;

			if ($filter->($opcode)) {
				$self->add1($opcode);
			}
		}
	}
}

sub add_synth1 {
	my($self, $cpu, $asm, @subasm) = @_;
	
	if ($self->exists($asm, $cpu)) {
		return;
	}

	if ($cpu =~ /_strict/) {
		return;
	}

	my @subops;
	for my $subasm (@subasm) {
		# replace 0:%s/0:$u by %m
		my $extend;
		if ($subasm =~ s/0:(%[nsu])/%m/) {
			$extend = $1;
		}
		
		# replace %t by %m
		my $temp_label;
		if ($subasm =~ s/^((jr|djnz)\b.*)(%t\d*)/$1%j/) {
			$temp_label = $3;
		}
		elsif ($subasm =~ s/(%t\d*)/%m/) {
			$temp_label = $1;
		}
		
		# replace %D by %d
		my $dis_plus_1;
		if ($subasm =~ s/(%D)/%d/) {
			$dis_plus_1 = $1;
		}
		
		# replace 00/0000 by %n/%m
		my $zero;
		if ($subasm =~ s/\b0000\b/%m/) {
			$zero = '%m';
		}
		elsif ($subasm =~ s/\b00\b/%n/) {
			$zero = '%n';
		}
		
		# replace 01/0001 by %n/%m
		my $one;
		if ($subasm =~ s/\b0001\b/%m/) {
			$one = '%m';
		}
		elsif ($subasm =~ s/\b01\b/%n/) {
			$one = '%n';
		}
		
		# replace 02/0002 by %n/%m
		my $two;
		if ($subasm =~ s/\b0002\b/%m/) {
			$two = '%m';
		}
		elsif ($subasm =~ s/\b02\b/%n/) {
			$two = '%n';
		}
		
		# get opcode
		my $subopcode = $self->opcodes->{$subasm}{$cpu};
		if (!$subopcode) {
			warn "opcode not found: $cpu; $asm; $subasm" if $ENV{DEBUG};
			return;
		}
		
		# remap bytes
		for my $op (@{$subopcode->ops}) {
			my @bytes = @$op;

			# replace %m by %s/$u,0[,0]
			if ($extend) {
				my $i = 0;
				while ($i < @bytes && $bytes[$i] ne '%m') {
					$i++;
				}
				$i < @bytes or die;
				$bytes[$i++] = $extend;
				while ($i < @bytes) {
					$bytes[$i++] = 0;
				}
			}

			# replace %m/%j by %t
			if ($temp_label) {
				my $i = 0;
				while ($i < @bytes && $bytes[$i] !~ /%[jm]/) {
					$i++;
				}
				$i < @bytes or die;
				while ($i < @bytes) {
					$bytes[$i++] = $temp_label;
				}
			}
			
			# replace %d by %D
			if ($dis_plus_1) {
				for (@bytes) {
					s/%d/$dis_plus_1/;
				}
			}

			# replace %n/%m by zero
			if ($zero) {
				my $i = 0;
				while ($i < @bytes && $bytes[$i] !~ /%[mn]/) {
					$i++;
				}
				$i < @bytes or die;
				while ($i < @bytes) {
					$bytes[$i++] = 0;
				}
			}
			
			# replace %n/%m by one
			if ($one) {
				my $i = 0;
				while ($i < @bytes && $bytes[$i] !~ /%[mn]/) {
					$i++;
				}
				$i < @bytes or die;
				$bytes[$i++] = 1;
				while ($i < @bytes) {
					$bytes[$i++] = 0;
				}
			}

			# replace %n/%m by two
			if ($two) {
				my $i = 0;
				while ($i < @bytes && $bytes[$i] !~ /%[mn]/) {
					$i++;
				}
				$i < @bytes or die;
				$bytes[$i++] = 2;
				while ($i < @bytes) {
					$bytes[$i++] = 0;
				}
			}
			#say "$asm - $subasm - @bytes";
			
			push @subops, \@bytes;
		}
	}

	my $opcode = Opcode->new(asm=>$asm, cpu=>$cpu, synth=>1, ops=>\@subops);
	$self->add($opcode);
}

sub add_synth {
	my($self, $cpu, $asm, @subasm) = @_;
	
	if ($self->exists($asm, $cpu)) {
		return;
	}

	if ($cpu =~ /_strict/) {
		return;
	}

	$self->add_synth1($cpu, $asm, @subasm);

	# add post-increment/decrement sythetic opcodes
	if (my $rp = _is_post_increment($asm)) {
		for (['inc', '+'], ['dec', '-']) {
			my($action, $operator) = @$_;
			(my $post_asm = $asm) =~ s/\($rp\)/($rp$operator)/;
			$self->add_synth1($cpu, $post_asm, [@subasm, "$action $rp"]);
		}
	}
}

sub add_emul {
	my($self, $cpu, $asm, $func, @args) = @_;

	if ($cpu =~ /_strict/) {
		return;
	}

	if (!$self->exists($asm, $cpu)) {
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
	my($self, $asm, $cpu) = @_;
	if ($self->opcodes->{$asm} &&
		$self->opcodes->{$asm}{$cpu}) {
		return 1;
	}
	else {
		return 0;
	}
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
		$self->add1($opcode);
	}
	return $self;
}

1;
