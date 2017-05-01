#!perl

#------------------------------------------------------------------------------
# Build all the CPU opcodes from cpu_opcodes.def
#------------------------------------------------------------------------------
use Modern::Perl;
use Path::Tiny;
use Data::Dump 'dump';

my @CPU = (qw( z80 z180 r2k r3k ));
my $TEST = "t/data/opcodes_";

my $datafile = replace_ext($0, ".def");
my $opcodes = parse_file($datafile);

for my $cpu (@CPU) {
	make_test_files($opcodes, $cpu,
		$TEST.$cpu."_ok.asm",
		$TEST.$cpu."_ok.bmk",
		$TEST.$cpu."_err.asm");
}

my $parser_file = replace_ext($0, ".h");
make_parser_file($opcodes, $parser_file);

#------------------------------------------------------------------------------
# Parse input file, return data structure
#------------------------------------------------------------------------------
sub parse_file {
	my($file) = @_;
	my $opcodes = {};
	parse_lines($opcodes, path($file)->lines);
	return $opcodes;
}

sub parse_lines {
	my($opcodes, @lines) = @_;
	
	# read each line
LINES:
	for (@lines) {
		for (split(/\n/, $_)) {
			next if /^\s*\#/;
			next if /^\s*\;/;
			next if /^\s*$/;
			last LINES if /^__END__/;
			s/^\s+//;
			s/\s+$//;
			s/\s+/ /g;
			
			# check if this opcode has a cpu filter
			my @cpus;
			if (/^\[(.*?)\]\s*/) {
				my($cpus, $rest) = ($1, $');
				$_ = $rest;
				@cpus = split(' ', $cpus);
			}
			
			# get opcode and bytes and insert in opcodes
			my($opcode, $bytes) = split(/\s*=>\s*/, $_);
			add_opcode($opcodes, $opcode, $bytes, \@cpus);
		}
	}
}

sub add_opcode {
	my($opcodes, $opcode, $bytes, $cpus, $var) = @_;
	$var ||= 1;		# start with $1
	
	# expand $var
	if ($opcode =~ /\{(.*?)\}/) {
		my($before, $list, $after) = ($`, $1, $');
		my @list = split(' ', $list);
		for (0 .. $#list) {
			my($id, $text) = ($_, $list[$_]);
			next if $text eq '.';				# use a DOT to skip items
			
			my $opcode_copy = $before . $text . $after;
			my $bytes_copy = $bytes; $bytes_copy =~ s/\$$var/ sprintf("%X", $id) /ge;
			
			add_opcode($opcodes, $opcode_copy, $bytes_copy, $cpus, $var+1);
		}
		return;
	}
	
	# expand ['] - generate one line without ', one with ' and one without ' and with ALTD
	if ($opcode =~ /\[\'\]/) {
		my($opcode_1, $tick, $opcode_2) = ($`, $1, $');
		
		@$cpus == 0 or die;
		
		# without '
		add_opcode($opcodes, $opcode_1.$opcode_2, $bytes, [], $var);
		
		# with '
		add_opcode($opcodes, $opcode_1."'".$opcode_2, "76, ".$bytes, ['rabbit'], $var);
		
		# without ' and with ALTD
		add_opcode($opcodes, "altd ".$opcode_1.$opcode_2, "76, ".$bytes, ['rabbit'], $var);
		
		return;
	}

	# scan tokens
	my @tokens = scan_opcode($opcode);
	
	# compute bytes
	$bytes =~ s/([0-9A-F]+)/0x$1/g;		# all numbers in hex
	my @bytes = compute_bytes($bytes);
	
	# build trie of tokens in $opcodes
	my $p = $opcodes;
	for my $token (@tokens, "") {
		$p->{$token} ||= {};
		$p = $p->{$token};
	}
	
	$p->{cpus} = $cpus;
	$p->{bytes} = \@bytes;
}

sub scan_opcode {
	my($opcode) = @_;
	my @tokens;
	for ($opcode) {
		while (! /\G\Z/gc) {
			if (/\G\s+/gc) { 
				next; 
			}
			elsif (/\G[a-z][a-z0-9]*\'?|./gc) { 
				push @tokens, $&; 
			}
			else { 
				die; # not reached
			}
		}
	}
	return @tokens;
}

sub compute_bytes {
	my($bytes) = @_;
	my @ret;
	my @bytes = split_exprs($bytes);
	for (@bytes) {
		my @subbytes = eval($_); $@ and die $@;
		push @ret, @subbytes;
	}
	return @ret;
}

sub split_exprs {
	local($_) = @_;
	my @exprs = ('');
	my $paren = 0;
	while (! /\G\Z/gc) {
		if (/\G\(/gc) {
			$paren++;
			$exprs[-1] .= $&;
		}
		elsif (/\G\)/gc) {
			$paren--;
			die "syntax error: $_" if $paren < 0;
			$exprs[-1] .= $&;
		}
		elsif (/\G,/gc) {
			if ($paren == 0) {
				push @exprs, '';
			}
			else {
				$exprs[-1] .= $&;
			}
		}
		elsif (/\G[^(),]+/gc) {
			$exprs[-1] .= $&;
		}
		else {
			die "syntax error: $_";
		}
	}
	return @exprs;
}

#------------------------------------------------------------------------------
# Build asm test files for assembly ok and error
#------------------------------------------------------------------------------
sub make_test_files {
	my($opcodes, $cpu, $ok_file, $bin_file, $err_file) = @_;
	
	# write asm files in binary mode to have only LF
	open(my $ok_fh,  ">:raw", $ok_file)  or die $!;
	open(my $bin_fh, ">:raw", $bin_file) or die $!;
	open(my $err_fh, ">:raw", $err_file) or die $!;
	my $addr = 0;
	
	add_asm_lines([], $opcodes, $cpu, $ok_fh, $bin_fh, $err_fh, \$addr);
}

sub add_asm_lines {
	my($tokens, $p, $cpu, $ok_fh, $bin_fh, $err_fh, $addr) = @_;
	
	for my $token (sort keys %$p) {
		if ($token eq "") {		# leaf - output
			my $opcode = join_tokens(@$tokens);
			my $exists = check_cpus($cpu, @{$p->{$token}{cpus}});
			my @bytes = @{$p->{$token}{bytes}};
			my $asm_line = sprintf(" %-23s;; %04X: ", $opcode, $$addr).
						   join(" ", map {sprintf("%02X", $_)} @bytes);
			if ($exists) {
				say $ok_fh $asm_line;
				print $bin_fh map {chr($_)} @bytes;
				$$addr += @bytes;
			}
			else {
				say $err_fh $asm_line;
			}
		}
		else { 					# branch - recurse
			add_asm_lines([@$tokens, $token], $p->{$token}, $cpu, $ok_fh, $bin_fh, $err_fh, $addr);
		}
	}
}

sub join_tokens {
	my(@tokens) = @_;
	my $opcode = join(" ", @tokens);
	$opcode =~ s/ ([,])/$1/g;
	return $opcode;
}

sub check_cpus {
	my($cpu, @cpus) = @_;
	return 1 unless @cpus;
	for (@cpus) {
		/^not_(.*)/ and return ! check_cpus($cpu, $1);
		return 1 if /$cpu/;
		return 1 if /zilog/ && $cpu =~ /^z/;
		return 1 if /rabbit/ && $cpu =~ /^r/;
	}
	return 0;
}

#------------------------------------------------------------------------------
# Build parser include file
#------------------------------------------------------------------------------
sub make_parser_file {
	my($opcodes, $parser_file) = @_;
	
	# write files in binary mode to have only LF
	open(my $fh, ">:raw", $parser_file)  or die $!;
	add_rules([], $opcodes, $fh);
}

sub add_rules {
	my($tokens, $p, $fh) = @_;
	
	for my $token (sort keys %$p) {
		if ($token eq "") {		# leaf - output
			my $bytes = $p->{$token}{bytes};
			my $cpus  = $p->{$token}{cpus};
			my $rule = rule($tokens, $bytes, $cpus);
			say $fh $rule;
		}
		else { 					# branch - recurse
			add_rules([@$tokens, $token], $p->{$token}, $fh);
		}
	}
}

sub rule {
	my($tokens, $bytes, $cpus) = @_;

	# build rule based on tokens
	my $rule = '| label? ';
	for my $token (@$tokens) {
		if ($token eq ',') {
			$rule .= '_TK_COMMA ';
		}
		elsif ($token =~ /^([a-z]+)\'$/) {
			$rule .= '_TK_'.uc($1).'1 ';
		}
		else {
			$rule .= '_TK_'.uc($token).' ';
		}
	}
	$rule .= '_TK_NEWLINE ';

	# build opcode from bytes
	my $opcode = 0;
	for my $byte (@$bytes) {
		$opcode <<= 8;
		$opcode |= $byte;
	}

	# build CPU condition
	my $cpu_cond = '';
	if (@$cpus) {
		my @cond = map {'CPU_'.uc($_)} @$cpus;
		$cpu_cond = 'if ( (opts.cpu & ('.join('|', @cond).')) == 0 ) { '.
					'error_illegal_ident(); return FALSE; } ';
	}
	
	# add rule action
	$rule .= '@{ '.$cpu_cond.'DO_stmt('.sprintf('0x%02X', $opcode).'); }';

	return $rule;
}


#------------------------------------------------------------------------------
sub replace_ext {
	my($file, $new_ext) = @_;
	$file =~ s/\.\w+$/$new_ext/;
	return path($file);
}
