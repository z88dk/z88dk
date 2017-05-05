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
	
	# expand $var: {b c d} -> expands into 3 lines for each element and $1 = (0..3)
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
	
	# expand (X) -> expands 5 lines (hl), (ix), (ix+d), (iy), (iy+d)
	# must be replaced before [']
	if ($opcode =~ /\(X\)/) {
		my($opcode_1, $opcode_2) = ($`, $');
		@$cpus == 0 or die;
	
		# hl
		add_opcode($opcodes, $opcode_1."(hl)".$opcode_2, $bytes, [], $var);
		
		# ix
		add_opcode($opcodes, $opcode_1."(ix)".$opcode_2, "DD, ".$bytes.", 0", [], $var);
		
		# ix+D
		add_opcode($opcodes, $opcode_1."(ix SN)".$opcode_2, "DD, ".$bytes.", SN", [], $var);
		
		# iy
		add_opcode($opcodes, $opcode_1."(iy)".$opcode_2, "FD, ".$bytes.", 0", [], $var);
		
		# iy+D
		add_opcode($opcodes, $opcode_1."(iy SN)".$opcode_2, "FD, ".$bytes.", SN", [], $var);
		
		return;
	}
	
	# expand ['] -> expands 3 lines: no tick for all cpus, with tick / with ALTD for [rabbit]
	if ($opcode =~ /\[\'\]/) {
		my($opcode_1, $opcode_2) = ($`, $');
		@$cpus == 0 or die;
		
		# without '
		add_opcode($opcodes, $opcode_1.$opcode_2, $bytes, [], $var);
		
		# with '
		add_opcode($opcodes, $opcode_1."'".$opcode_2, "76, ".$bytes, ['rabbit'], $var);
		
		# without ' and with ALTD
		add_opcode($opcodes, "altd ".$opcode_1.$opcode_2, "76, ".$bytes, ['rabbit'], $var);
		
		return;
	}

	# expand XH, XL -> expands to 2 lines with (ixh,ixl) and (iyh,iyl), only for [z80]
	if ($opcode =~ /X[HL]/) {
		@$cpus == 0 or die;

		# IXH, IXL
		(my $opcode_copy = $opcode) =~ s/X([HL])/ix\L$1/g;
		add_opcode($opcodes, $opcode_copy, "DD, ".$bytes, ['z80'], $var);
		
		# IYH, IYL
		($opcode_copy = $opcode) =~ s/X([HL])/iy\L$1/g;
		add_opcode($opcodes, $opcode_copy, "FD, ".$bytes, ['z80'], $var);
		
		return;
	}

	# scan tokens
	my @tokens = scan_opcode($opcode);
	
	# compute bytes
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
			elsif (/ \G ( [a-z] [a-z0-9]* \'?
			            | [A-Z_]+
						| . 
						) /gcx) { 
				push @tokens, $1; 
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
	
	for ($bytes) {
		# all numbers in hex
		s/ \b( [0-9A-F]+ )\b /0x$1/gx;

		# compute sub-expressions
		s/ ( (?: 0x [0-9A-F]+ | \d+ ) (?: \s* [-+*] \s* (?: 0x [0-9A-F]+ | \d+ ) )* ) / eval($1) /egx;
		$@ and die $@;
		
		# prefix name ? (a) : (b) --> name ? (prefix, a) : (prefix, b)
		s/ (.*?) \s* , \s* (\w+) \s* \? \s* \( (.*?) \) \s* : \s* \( (.*?) \) /$2 ? ($1, $3) : ($1, $4)/gx;
	}
	
	return split_exprs($bytes);
}

sub split_exprs {
	local($_) = @_;
	my @exprs = ('');
	my $paren = 0;
	while (! /\G\Z/gc) {
		if (/\G\s+/gc) {
		}
		elsif (/\G\(/gc) {
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
		elsif (/\G[^(),\s]+/gc) {
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
			my @bytes = @{$p->{$token}{bytes}};
			my $exists = check_cpus($cpu, @{$p->{$token}{cpus}});
			add_asm_line($opcode, \@bytes, $exists, $ok_fh, $bin_fh, $err_fh, $addr);
		}
		else { 					# branch - recurse
			add_asm_lines([@$tokens, $token], $p->{$token}, $cpu, $ok_fh, $bin_fh, $err_fh, $addr);
		}
	}
}

sub add_asm_line {
	my($opcode, $bytes, $exists, $ok_fh, $bin_fh, $err_fh, $addr) = @_;

	# handle N_IMN: ld a,N | ld a,(MN)
	if ($opcode =~ /\bN_IMN\b/) {
		my($opcode_1, $opcode_2) = ($`, $');
		
		for my $expr_in_parens (0 .. 1) {
			my @values = ($expr_in_parens ? (0, 0x7FFF, 0xFFFF) : (0, 0x7F, 0xFF));
			for my $value (@values) {
				my $opcode_copy = $opcode_1 . ($expr_in_parens ? "($value)" : $value) . $opcode_2;
				my @bytes_copy = fill_value($value, choose_expr('expr_in_parens', $expr_in_parens, @$bytes));
				add_asm_line($opcode_copy, \@bytes_copy, $exists, $ok_fh, $bin_fh, $err_fh, $addr);
			}
		}
		return;		
	}

	# handle N: ld b,N
	if ($opcode =~ /\bN\b/) {
		my($opcode_1, $opcode_2) = ($`, $');
		
		my @values = (0, 0x7F, 0xFF);
		for my $value (@values) {
			my @bytes_copy = fill_value($value, @$bytes);
			add_asm_line($opcode_1 . $value . $opcode_2, \@bytes_copy, 
						 $exists, $ok_fh, $bin_fh, $err_fh, $addr);
			add_asm_line($opcode_1 . "(" . $value . ")" . $opcode_2, \@bytes_copy, 
						 0, $ok_fh, $bin_fh, $err_fh, $addr);
		}
		return;		
	}

	# handle N: ld b,(ix SN)
	if ($opcode =~ /\bSN\b/) {
		my($opcode_1, $opcode_2) = ($`, $');
		
		my @values = (0, -128, 127);
		for my $value (@values) {
			my @bytes_copy = fill_value($value & 0xFF, @$bytes);
			add_asm_line($opcode_1.($value >= 0 ? "+" : "").$value.$opcode_2, \@bytes_copy, 
						 $exists, $ok_fh, $bin_fh, $err_fh, $addr);
		}
		return;		
	}
	
	my $asm_line = sprintf(" %-23s;; %04X: ", $opcode, $$addr).
				   join(" ", map {sprintf("%02X", $_)} @$bytes);
	if ($exists) {
		say $ok_fh $asm_line;
		print $bin_fh map {chr($_)} @$bytes;
		$$addr += @$bytes;
	}
	else {
		say $err_fh $asm_line;
	}
}

sub choose_expr {
	my($name, $value, @bytes) = @_;
	
	# choose based on value and flatten list
	my @ret;
	for (@bytes) {
		# name ? (a) : (b) --> value ? (a) : (b)
		s/ $name \s* \? \s* \( (.*?) \) \s* : \s* \( (.*?) \) /$value ? $1 : $2/egx;
		
		push @ret, split_exprs($_);
	}
	
	return @ret;
}

sub fill_value {
	my($value, @bytes) = @_;
	
	for (@bytes) {
		if    ($_ eq 'N')  { $_ = $value & 0xFF; }
		elsif ($_ eq 'M')  { $_ = $value >> 8; }
		elsif ($_ eq 'SN') { $_ = $value; }
		else {
			$_ = eval($_); $@ and die $@;
		}
	}

	return @bytes;
}

sub join_tokens {
	my(@tokens) = @_;
	my $opcode = join(" ", @tokens);
	for ($opcode) {
		s/ ([,\)])/$1/g;
		s/([\(]) /$1/g;
	}
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
	my $rule = '| label? '.join(' ', rule_tokens(@$tokens)).' ';

	# build CPU condition
	my $cpu_cond = '';
	if (@$cpus) {
		my @cond = map {'CPU_'.uc($_)} @$cpus;
		$cpu_cond = 'if ( (opts.cpu & ('.join('|', @cond).')) == 0 ) { '.
					'error_illegal_ident(); return FALSE; } ';
	}
	
	# add expr_in_parens condition
	my $parens_cond = '';
	if (grep {/\b(N|MN)\b/} @$tokens) {
		$parens_cond .= 'if (expr_in_parens) return FALSE; ';
	}
	if (grep {/\b(IN|IMN)\b/} @$tokens) {
		$parens_cond .= 'if (!expr_in_parens) return FALSE; ';
	}
	
	# add rule action
	$rule .= '@{ '.$cpu_cond.$parens_cond.rule_opcode(@$bytes).' }';

	return $rule;
}

sub rule_tokens {
	my(@tokens) = @_;
	for (@tokens) {
		if    ($_ eq ',') 		{ $_ = '_TK_COMMA'; }
		elsif ($_ eq '(') 		{ $_ = '_TK_LPAREN'; }
		elsif ($_ eq ')') 		{ $_ = '_TK_RPAREN'; }
		elsif (/^([a-z]+)\'$/) 	{ $_ = '_TK_'.uc($1).'1'; }
		elsif (/^([A-Z_]+)$/)	{ $_ = 'expr'; }
		else 					{ $_ = '_TK_'.uc($_); }
	}
	push @tokens, '_TK_NEWLINE ';

	# join (hl, (ix, (iy
	my $tokens = join(' ', @tokens);
	$tokens =~ s/_TK_LPAREN _TK_(HL|IX|IY)/_TK_IND_$1/g;
	@tokens = split(' ', $tokens);
	
	return @tokens;
}

sub rule_opcode {
	my(@bytes) = @_;
say "@bytes";

	# check for selection on type of expression
	if (@bytes && $bytes[0] =~ /^ \s* expr_in_parens \s* \? \s* \( (.*?) \) \s* : \s* \( (.*?) \) \s*$/x) {
		my($paren, $no_paren) = ($1, $2);
		$paren = rule_opcode(split_exprs($paren));
		$no_paren = rule_opcode(split_exprs($no_paren));
		return 'if (expr_in_parens) { '.$paren.' } else { '.$no_paren.' } ';
	}
	
	# check for prefixes
	my $code = '';
	while (@bytes && $bytes[0] == 0x76) {
		$code .= 'DO_stmt(0x76); ';
		shift @bytes;
	}
	
	# check for MN
	if (@bytes > 2 && $bytes[-2] eq 'N' && $bytes[-1] eq 'M') {
		pop @bytes; pop @bytes;
		return $code.'DO_stmt_nn('.rule_compute_opcode(@bytes).');';
	}
	
	# check for N
	if (@bytes > 1 && $bytes[-1] eq 'N') {
		pop @bytes; 
		return $code.'DO_stmt_n('.rule_compute_opcode(@bytes).');';
	}
	
	# check for SN
	if (@bytes > 1 && $bytes[-1] eq 'SN') {
		pop @bytes; 
		return $code.'DO_stmt_idx('.rule_compute_opcode(@bytes).');';
	}
	
	return $code.'DO_stmt('.rule_compute_opcode(@bytes).');'
}

sub rule_compute_opcode {
	my(@bytes) = @_;
	my $opcode = 0;
	for my $byte (@bytes) {
		$byte = eval($byte); $@ and die $@;
		$opcode <<= 8;
		$opcode |= $byte;
	}
	return sprintf('0x%02X', $opcode);
}

#------------------------------------------------------------------------------
sub replace_ext {
	my($file, $new_ext) = @_;
	$file =~ s/\.\w+$/$new_ext/;
	return path($file);
}
