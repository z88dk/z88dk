#!perl

#------------------------------------------------------------------------------
# Build all the CPU opcodes from cpu_opcodes.def
#------------------------------------------------------------------------------
use Modern::Perl;
use Path::Tiny;
use Data::Dump 'dump';

# global data
my @CPUS = (qw( z80 z180 r2k r3k ));
my $TEST_FILE = "t/data/cpu_opcodes_";
my %TEST_ASM;			# %TEST_ASM{cpu}{ok|err} contais test assembly
my @RAGEL_INC;			# $RAGEL_INC 			 contains Ragel rules

# init data
for my $cpu (@CPUS) {
	$TEST_ASM{$cpu} = {ok => [], err => []};
} 

my $datafile = replace_ext($0, ".def");
parse_file($datafile);

# write test files
for my $cpu (@CPUS) {
	for my $data (qw( ok err )) {
		my @lines = sort @{$TEST_ASM{$cpu}{$data}};
		my $file = $TEST_FILE.$cpu."_".$data.".asm";
		path($file)->spew_raw(map {"$_\n"} @lines);
	}
}

# write parser include
path("cpu_opcodes.h")->spew_raw(map {"$_\n"} sort @RAGEL_INC);

#------------------------------------------------------------------------------
sub replace_ext {
	my($file, $new_ext) = @_;
	$file =~ s/\.\w+$/$new_ext/;
	return path($file);
}

#------------------------------------------------------------------------------
sub trim {
	local($_) = @_;
	s/^\s*\#.*//;
	s/^\s*\;.*//;
	s/^\s+//;
	s/\s+$//;
	s/\s+/ /g;
	return $_;
}

#------------------------------------------------------------------------------
# Parse input file
#------------------------------------------------------------------------------
sub parse_file {
	my($file) = @_;
	for (path($file)->lines) {
		$_ = trim($_);
		last if /^__END__/;
		next unless /\S/;
		parse_line($_);
	}
}

#------------------------------------------------------------------------------
sub parse_line {
	local($_) = @_;
	
	# check if this opcode has a cpu filter
	my $arch = '';
	if (/^\[\s*([\w_]+)\s*\]\s*/) {
		$arch = $1;
		$_ = $';
	}
	
	# get opcode and bytes and insert in opcodes
	my($opcode, $bytes) = split(/\s*=>\s*/, $_);
	add_opcode($opcode, $bytes, $arch);
}

#------------------------------------------------------------------------------
sub add_opcode {
	my($opcode, $bytes, $arch, $var) = @_;
	$var ||= 1;		# start with $1
	
	# expand $var: {b c d} -> expands into 3 lines for each element and $1 = (0..3)
	if ($opcode =~ /\{(.*?)\}/) {
		my($before, $list, $after) = ($`, $1, $');
		my @list = split(' ', $list);
		for (0 .. $#list) {
			my($id, $text) = ($_, $list[$_]);
			next if $text eq '.';				# use a DOT to skip items
			(my $bytes_copy = $bytes) =~ s/\$$var/ sprintf("%X", $id) /ge;
			
			add_opcode($before.$text.$after, $bytes_copy, $arch, $var+1);
		}
		return;
	}

	# expand (X) -> expands 5 lines (hl), (ix), (ix+d), (iy), (iy+d)
	if ($opcode =~ /\(X\)/) {
		my($opcode_1, $opcode_2) = ($`, $');
	
		# hl
		add_opcode($opcode_1."(hl)".$opcode_2, $bytes, $arch, $var);
		
		# ix
		add_opcode($opcode_1."(ix)".$opcode_2, "DD, ".$bytes.", SN0", $arch, $var);
		
		# ix+D
		add_opcode($opcode_1."(ix+SN)".$opcode_2, "DD, ".$bytes.", SN", $arch, $var);
		
		# iy
		add_opcode($opcode_1."(iy)".$opcode_2, "FD, ".$bytes.", SN0", $arch, $var);
		
		# iy+D
		add_opcode($opcode_1."(iy+SN)".$opcode_2, "FD, ".$bytes.", SN", $arch, $var);
		
		return;
	}

	# expand XH, XL -> expands to 3 lines with (h,l), and (ixh,ixl) and (iyh,iyl) only for [z80]
	if ($opcode =~ /X[HL]/) {

		# H, L
		(my $opcode_copy = $opcode) =~ s/X([HL])/\L$1/g;
		add_opcode($opcode_copy, $bytes, $arch, $var);
		
		# IXH, IXL
		($opcode_copy = $opcode) =~ s/X([HL])/ix\L$1/g;
		add_opcode($opcode_copy, "DD, ".$bytes, 'z80', $var);
		
		# IYH, IYL
		($opcode_copy = $opcode) =~ s/X([HL])/iy\L$1/g;
		add_opcode($opcode_copy, "FD, ".$bytes, 'z80', $var);
		
		return;
	}

	# expand ['] -> expands 3 lines: no tick for all arch, with tick / with ALTD for [rabbit]
	if ($opcode =~ /\[\'\]/) {
		my($opcode_1, $opcode_2) = ($`, $');
		
		# without '
		add_opcode($opcode_1.$opcode_2, $bytes, $arch, $var);
		
		# with '
		add_opcode($opcode_1."'".$opcode_2, "76, ".$bytes, 'rabbit', $var);
		
		# without ' and with ALTD
		add_opcode("altd ".$opcode_1.$opcode_2, "76, ".$bytes, 'rabbit', $var);
		
		return;
	}

	# expand [a',] -> expands 4 lines: sub b | sub a,b | sub a',b | altd sub b
	if ($opcode =~ /\[a\',\]/) {
		my($opcode_1, $opcode_2) = ($`, $');
		
		add_opcode(        $opcode_1."     ".$opcode_2,        $bytes, $arch,    $var);
		add_opcode(        $opcode_1." a,  ".$opcode_2,        $bytes, $arch,    $var);
		add_opcode(        $opcode_1." a', ".$opcode_2, "76, ".$bytes, "rabbit", $var);
		add_opcode("altd ".$opcode_1." a,  ".$opcode_2, "76, ".$bytes, "rabbit", $var);
		
		return;
	}

	# expand [a,] -> expands 2 lines: sub b | sub a,b
	if ($opcode =~ /\[a,\]/) {
		my($opcode_1, $opcode_2) = ($`, $');
		
		add_opcode($opcode_1."    ".$opcode_2, $bytes, $arch, $var);
		add_opcode($opcode_1." a, ".$opcode_2, $bytes, $arch, $var);
		
		return;
	}

	# remove extra blanks
	for ($opcode) {
		s/\s+/ /g; s/^\s+//; s/\s+$//;
	}
	
	# reorder bytes DD|FD, xx, N, SN -> DD|FD, xx, SN, N
	$bytes =~ s/\b (N) \s* , \s* (SN 0?) \b/ $2, $1 /x;
	
	# build test code
	my $valid_code = check_valid($opcode);
	for my $cpu (@CPUS) {
		my $exists = check_arch($cpu, $arch);
		build_test_code($opcode, $bytes, $cpu, $exists && $valid_code);
	}
	
	# build Ragel rules
	if ($valid_code) {
		build_ragel_rule($opcode, $bytes, $arch);
	}
}

#------------------------------------------------------------------------------
sub build_test_code {
	my($opcode, $bytes, $cpu, $exists_and_valid) = @_;
	
	# check for /N_IMN/
	if ($opcode =~ /\b N_IMN \b/x) {
		my($opcode_1, $opcode_2) = ($`, $');
		
		$bytes =~ /\b expr_in_parens \s* \? \s* (.*?) \s* : \s* (.*) $/x 
			or die "expected expr_in_parens at ", $bytes;
		my($bytes_1, $true, $false) = ($`, $1, $2);
		
		# N
		(my $bytes_copy = $bytes_1.$false) =~ s/\b N \b/ 2A /x or die;
		build_test_code($opcode_1.(0x2A).$opcode_2, $bytes_copy, $cpu, $exists_and_valid);
		
		# (MN)
		($bytes_copy = $bytes_1.$true) =~ s/\b N \s* , \s* M \b/ 34, 12 /x or die;
		build_test_code($opcode_1.'('.(0x1234).')'.$opcode_2, $bytes_copy, $cpu, $exists_and_valid);
		
		return;
	}
	
	# check for /N/
	if ($opcode =~ /\b N \b/x) {
		my($opcode_1, $opcode_2) = ($`, $');
		
		# N
		(my $bytes_copy = $bytes) =~ s/\b N \b/ 2A /x or die;
		build_test_code($opcode_1.(0x2A).$opcode_2, $bytes_copy, $cpu, $exists_and_valid);
		
		# (N)
		build_test_code($opcode_1.'('.(0x2A).')'.$opcode_2, $bytes_copy, $cpu, 0);
		
		return;
	}
	
	# check for /IMN/
	if ($opcode =~ /\b IMN \b/x) {
		my($opcode_1, $opcode_2) = ($`, $');
		
		# MN
		(my $bytes_copy = $bytes) =~ s/\b N \s* , \s* M \b/ 34, 12 /x or die;
		build_test_code($opcode_1.(0x1234).$opcode_2, $bytes_copy, $cpu, 0);
		
		# (N)
		build_test_code($opcode_1.'('.(0x1234).')'.$opcode_2, $bytes_copy, $cpu, $exists_and_valid);
		
		return;
	}
	
	# check for /SN/
	if ($opcode =~ /\b SN \b/x) {
		my($opcode_1, $opcode_2) = ($`, $');
		
		(my $bytes_copy = $bytes) =~ s/\b SN \b/ 7F /x or die;
		build_test_code($opcode_1.(0x7F).$opcode_2, $bytes_copy, $cpu, $exists_and_valid);
		
		return;
	}
	
	# check for /SN0/
	$bytes =~ s/\b SN0 \b/0/x;
	
	my @bytes = compute_bytes(split(/\s*,\s*/, $bytes));
	my $asm_line = sprintf(" %-23s;; ", $opcode).
				   join(" ", map {sprintf("%02X", $_)} @bytes);
	if ($exists_and_valid) {
		push @{$TEST_ASM{$cpu}{ok}}, $asm_line;
	}
	else {
		push @{$TEST_ASM{$cpu}{err}}, " ".$opcode;
	}
}

#------------------------------------------------------------------------------
sub compute_bytes {
	my(@bytes) = @_;
	
	@bytes = grep {/\S/} @bytes;
	for (@bytes) {
		# all numbers in hex
		s/ \b( [0-9A-F]+ )\b /0x$1/gx;
		$_ = eval($_); $@ and die "$_: $@";
	}

	return @bytes;
}

#------------------------------------------------------------------------------
sub check_arch {
	my($cpu, $arch) = @_;
	return 1 unless $arch;
	for ($arch) {
		/^not_(.*)/ and return ! check_arch($cpu, $1);
		return 1 if /$cpu/;
		return 1 if /zilog/ && $cpu =~ /^z/;
		return 1 if /rabbit/ && $cpu =~ /^r/;
	}
	return 0;
}

#------------------------------------------------------------------------------
sub build_ragel_rule {
	my($opcode, $bytes, $arch) = @_;
	
	my $rule = '| label? ';
	$rule .= join(' ', opcode_tokens_rule($opcode)).' ';
	$rule .= '@{ ';
	
	if ($arch) {
		my $cond = ($arch =~ /not_(.*)/) ? '(opts.cpu & (CPU_'.uc($1).   ')) != 0'
										 : '(opts.cpu & (CPU_'.uc($arch).')) == 0';
		$rule .= "if ($cond) { error_illegal_ident(); return FALSE; } ";
	}
	
	if ($opcode =~ /\b N \b/x) {
		$rule .= 'if (expr_in_parens) return FALSE; ';
	}
	
	if ($opcode =~ /\b IMN \b/x) {
		$rule .= 'if (!expr_in_parens) return FALSE; ';
	}
	
	$rule .= join(' ', opcode_bytes_rule($bytes)).' ';
	$rule .= '}';
	
	push @RAGEL_INC, $rule;
}

#------------------------------------------------------------------------------
# check for invalid code constructs
sub check_valid {
	local($_) = @_;

	return 0 if /\b i[xy][hl] \b/x && /\b altd \b | \' /x;
	return 1;
}

#------------------------------------------------------------------------------
# scan opcode, return list of tokens
sub opcode_tokens_rule {
	local($_) = @_;
	
	my @tokens;
	while (!/ \G \z /gcx) {
		if    (/ \G \s+ 		/gcx)	{	; }		# ignore blanks
		elsif (/ \G ,   		/gcx)	{ push @tokens, '_TK_COMMA'; }
		elsif (/ \G \)   		/gcx)	{ push @tokens, '_TK_RPAREN'; }
		elsif (/ \G \( \s* (hl|ix|iy) \s* \+? /gcx)	
										{ push @tokens, '_TK_IND_'.uc($1); }
		elsif (/ \G \( \s* (bc|de) \s* \) \+? /gcx)	
										{ push @tokens, '_TK_IND_'.uc($1); }
		elsif (/ \G [A-Z_]+ 	/gcx)	{ push @tokens, 'expr'; }
		elsif (/ \G ([a-z0]+)\' /gcx)	{ push @tokens, '_TK_'.uc($1).'1'; }
		elsif (/ \G ([a-z0]+)   /gcx)	{ push @tokens, '_TK_'.uc($1); }
		else { die "cannot parse ".substr($_,pos($_)||0)." in $_"; }
	}
	push @tokens, '_TK_NEWLINE';
	return @tokens;
}

#------------------------------------------------------------------------------
# return rules to load opcode
sub opcode_bytes_rule {
	my($bytes) = @_;
	my @rules;
	
	# ALTD prefix
	if ($bytes =~ s/^\s*76\s*,\s*//) {
		push @rules, 'DO_stmt(0x76);';
	}

	# expr_in_parens
	if ($bytes =~ /\b expr_in_parens \s* \? \s* (.*?) \s* : \s* (.*) $/x) {
		my($bytes_1, $true, $false) = ($`, $1, $2);
		
		push @rules, 'if (expr_in_parens) {';
		push @rules, opcode_bytes_rule($bytes_1.$true);
		push @rules, '} else {';
		push @rules, opcode_bytes_rule($bytes_1.$false);
		push @rules, '}';
		return @rules;
	}

	# Handle data bytes
	my $func = 'DO_stmt';
	my $post_arg = '';
	if ($bytes =~ s/\b N \s* , \s* M \b/ /x) {
		$func = 'DO_stmt_nn';
	}
	elsif ($bytes =~ s/\b SN \s* , \s* N \b/ /x) {
		$func = 'DO_stmt_idx_n';
	}
	elsif ($bytes =~ s/\b SN \b/ /x) {
		$func = 'DO_stmt_idx';
	}
	elsif ($bytes =~ s/\b SN0 \s* , \s* N \b/ /x) {
		$func = 'DO_stmt_n';
		$post_arg = ' << 8';
	}
	elsif ($bytes =~ s/\b SN0 \b/ /x) {
		$func = 'DO_stmt';
		$post_arg = ' << 8';
	}
	elsif ($bytes =~ s/\b N \b/ /x) {
		$func = 'DO_stmt_n';
	}
	
	# opcode
	my @bytes = compute_bytes(split(/\s*,\s*/, $bytes));
	my $opcode = 0;
	while (@bytes) {
		die unless $bytes[0] =~ /^\d+$/;
		$opcode <<= 8;
		$opcode |= shift @bytes;
	}
	
	push @rules, $func.'(0x'.sprintf('%02X', $opcode).$post_arg.');';
	
	return @rules;
}




__END__

for my $cpu (@CPU) {
	make_test_files(, $cpu,
		$TEST_FILE.$cpu."_ok.asm",
		$TEST_FILE.$cpu."_ok.bmk",
		$TEST_FILE.$cpu."_err.asm");
}

my $parser_file = replace_ext($0, ".h");
make_parser_file(, $parser_file);

sub add_opcode {
	my(, $opcode, $bytes, $arch, $var) = @_;
	$var ||= 1;		# start with $1
	
	# scan tokens
	my @tokens = scan_opcode($opcode);
	
	# compute bytes
	my @bytes = compute_bytes($bytes);
	
	# build trie of tokens in 
	my $p = ;
	for my $token (@tokens, "") {
		$p->{$token} ||= {};
		$p = $p->{$token};
	}
	
	$p->{arch} = $arch;
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
	my(, $cpu, $ok_file, $bin_file, $err_file) = @_;
	
	# write asm files in binary mode to have only LF
	open(my $ok_fh,  ">:raw", $ok_file)  or die $!;
	open(my $bin_fh, ">:raw", $bin_file) or die $!;
	open(my $err_fh, ">:raw", $err_file) or die $!;
	my $addr = 0;
	
	add_asm_lines([], , $cpu, $ok_fh, $bin_fh, $err_fh, \$addr);
}

sub add_asm_lines {
	my($tokens, $p, $cpu, $ok_fh, $bin_fh, $err_fh, $addr) = @_;
	
	for my $token (sort keys %$p) {
		if ($token eq "") {		# leaf - output
			my $opcode = join_tokens(@$tokens);
			my @bytes = @{$p->{$token}{bytes}};
			my $exists = check_arch($cpu, @{$p->{$token}{arch}});
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

#------------------------------------------------------------------------------
# Build parser include file
#------------------------------------------------------------------------------
sub make_parser_file {
	my(, $parser_file) = @_;
	
	# write files in binary mode to have only LF
	open(my $fh, ">:raw", $parser_file)  or die $!;
	add_rules([], , $fh);
}

sub add_rules {
	my($tokens, $p, $fh) = @_;
	
	for my $token (sort keys %$p) {
		if ($token eq "") {		# leaf - output
			my $bytes = $p->{$token}{bytes};
			my $arch  = $p->{$token}{arch};
			my $rule = rule($tokens, $bytes, $arch);
			say $fh $rule;
		}
		else { 					# branch - recurse
			add_rules([@$tokens, $token], $p->{$token}, $fh);
		}
	}
}

sub rule {
	my($tokens, $bytes, $arch) = @_;

	# build rule based on tokens
	my $rule = '| label? '.join(' ', rule_tokens(@$tokens)).' ';

	# build CPU condition
	my $cpu_cond = '';
	if (@$arch) {
		my @cond = map {'CPU_'.uc($_)} @$arch;
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

