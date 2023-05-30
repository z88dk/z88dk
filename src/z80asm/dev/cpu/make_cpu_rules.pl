#!/usr/bin/env perl

use Modern::Perl;
use YAML::Tiny;

my $yaml = YAML::Tiny->read("opcodes.yaml");
my %opcodes = %{$yaml->[0]};

my %parser;

my @CPUS = sort keys %{$opcodes{"nop"}};

for my $asm (sort keys %opcodes) {
	my $tokens = parser_tokens($asm);
	
	# check for parens
	my $parens;
	if    ($asm =~ /\(%[nmh]\)/) {		$parens = 'expr_in_parens'; }
	elsif ($asm =~ /%[snmjc]/) {		$parens = 'expr_no_parens'; }
	else {								$parens = 'no_expr';   }
		
	for my $cpu (sort keys %{$opcodes{$asm}}) {
		my @ops = @{$opcodes{$asm}{$cpu}};
		
		$parser{$tokens}{$cpu}{$parens} = [$asm, @ops];
	}
}

open(my $rules, ">", "cpu_rules.h") or die $!;

for my $tokens (sort keys %parser) {
	#say $tokens;
	
	print $rules $tokens, ' @{', "\n";
	print $rules merge_cpu($parser{$tokens});
	print $rules '}', "\n\n";
}

exit 0;

sub parser_tokens {
	local($_) = @_;
	my @tokens = ();
	
	while (!/\G \z 				/gcx) {
		if (/\G \s+ 			/gcx) {}
		elsif (/\G \( (\w+)		/gcx) { push @tokens, "_TK_IND_".uc($1); }
		elsif (/\G , 			/gcx) { push @tokens, "_TK_COMMA"; }
		elsif (/\G \) 			/gcx) { push @tokens, "_TK_RPAREN"; }
		elsif (/\G \( %[nmh] \)	/gcx) { push @tokens, "expr"; }
		elsif (/\G    %[snmMj]	/gcx) { push @tokens, "expr"; }
		elsif (/\G \+ %[dsu]	/gcx) { push @tokens, "expr"; }
		elsif (/\G    %[c]		/gcx) { push @tokens, "const_expr"; }
		elsif (/\G    (\w+)	'	/gcx) { push @tokens, "_TK_".uc($1)."1"; }
		elsif (/\G    (\w+)		/gcx) { push @tokens, "_TK_".uc($1); }
		elsif (/\G \+   		/gcx) { push @tokens, "_TK_PLUS"; }
		elsif (/\G \-   		/gcx) { push @tokens, "_TK_MINUS"; }
		elsif (/\G \.   		/gcx) { push @tokens, "_TK_DOT"; }
		else { die "$_ ; ", substr($_, pos($_)||0) }
	}
	return join(' ', ('| label?', @tokens, "_TK_NEWLINE"));
}

sub parse_code {
	my($cpu, $asm, @ops) = @_;
	my @code;

	# handle special case of jump to %t
	if (grep {/%t/} @{$ops[0]}) {
		my $op1 = $ops[0][0];
		my $op2 = $ops[1][0];
		push @code,
			"DO_STMT_LABEL();",
			"Expr1 *target_expr = pop_expr(ctx);",
			"const char *end_label = autolabel();",
			"Expr1 *end_label_expr = parse_expr(end_label);",
			"add_opcode_nn(0x".fmthex($op1).", end_label_expr);",	# jump over
			"add_opcode_nn(0x".fmthex($op2).", target_expr);",		# call
			"asm_LABEL_offset(end_label, 6);";
	}
	# handle special case of dec b;jr nz, %j
	elsif (@ops==2 && $ops[0][0] =~ /^\d+$/ && 
	       $ops[0][0] == 0x05 && $ops[1][1] eq '%j') {
		my $opc = "0x".fmthex($ops[1][0]);
		push @code, 
			"DO_stmt(0x05);",
			# compensate for extra byte
			"add_opcode_jr_n($opc, pop_expr(ctx), 1);";	
	}
	# handle {ADL0}? xxx : xxx
	elsif ($ops[0][0] eq '{ADL0}?') {
		my(@adl0, @adl1);
		shift @ops;
		while (@ops && $ops[0][0] ne ':') {
			push @adl0, shift @ops;
		}
		shift @ops;
		@adl1 = @ops;
		
		push @code, 
			"if (option_ez80_adl() == false) {",
			parse_code($cpu, $asm, @adl0),
			"}",
			"else {",
			parse_code($cpu, $asm, @adl1),
			"}";
	}
	# handle {ADLn}
	elsif ($ops[0][0] =~ /\{ADL(\d)\}/) {
		my $value = $1 ? "true" : "false";
		shift @ops;
		push @code,
			"if (option_ez80_adl() != $value) {",
			"    error_illegal_ident(); ",
			"}",
			"else {",
			parse_code($cpu, $asm, @ops),
			"}";
	}
	# handle rst[.l] %c
	elsif ($asm =~ /^rst((\.[ls])?) %c/) {
		if ($1) {
			push @code, 
				"DO_STMT_LABEL();",
				"DO_stmt(".sprintf("0x%02X", $ops[0][0]).");";
			shift @ops;
		}
		for my $bin (@ops) {
			push @code, parse_code_opcode($cpu, $asm, @$bin);
		}
	}		
	else {
		for my $bin (@ops) {
			push @code, parse_code_opcode($cpu, $asm, @$bin);
		}
	}
	
	return join("\n", @code);
}

sub parse_code_opcode {
	my($cpu, $asm, @bin) = @_;
	my @bin0 = @bin;
	my @code;

	#say "$cpu\t$asm\t@bin";
	
	# check for argument type
	my($stmt, $extra_arg) = ("", "");
	my $bin = join(' ', @bin);
	
	if ($bin =~ s/ \@(\w+)//) {
		my $func = $1;
		push @code, 
			"DO_STMT_LABEL();",
			"add_call_emul_func(\"$func\");";
	}
	elsif ($asm =~ /^rst((\.[ls])?) %c/) {
		push @code, 
			"DO_STMT_LABEL();",
			"if (expr_error) { error_expected_const_expr(); } else {",
			"if (expr_value > 0 && expr_value < 8) expr_value *= 8;",
			"switch (expr_value) {",
			"case 0x00: case 0x08: case 0x30:",
			"  if (option_cpu() & CPU_RABBIT)",
			"    DO_stmt(0xCD0000 + (expr_value << 8));",
			"  else",
			"    DO_stmt(0xC7 + expr_value);",
			"  break;",
			"case 0x10: case 0x18: case 0x20: case 0x28: case 0x38:",
			"  DO_stmt(0xC7 + expr_value); break;",
			"default: error_int_range(expr_value);",
			"}}";
	}
	elsif ($asm =~ /^mmu %c, %n/) {
		push @code, 
			"DO_STMT_LABEL();",
			"if (expr_error) { error_expected_const_expr(); } else {",
			"if (expr_value < 0 || expr_value > 7) error_int_range(expr_value);",
			"DO_stmt_n(0xED9150 + expr_value);}";
	}
	elsif ($asm =~ /^mmu %c, a/) {
		push @code, 
			"DO_STMT_LABEL();",
			"if (expr_error) { error_expected_const_expr(); } else {",
			"if (expr_value < 0 || expr_value > 7) error_int_range(expr_value);",
			"DO_stmt(0xED9250 + expr_value);}";
		my $code = join("\n", @code);
		return $code;
	}
	elsif ($bin =~ s/ %d %n$//) {
		$stmt = "DO_stmt_idx_n";
	}
	elsif ($bin =~ s/ %n %n$//) {
		$stmt = "DO_stmt_n_n";
	}
	elsif ($bin =~ s/ %n$//) {
		$stmt = "DO_stmt_n";
	}
	elsif ($bin =~ s/ %u$//) {
		$stmt = "DO_stmt_n";
	}
	elsif ($bin =~ s/ %s$//) {
		$stmt = "DO_stmt_d";
	}
	elsif ($bin =~ s/ %h$//) {
		$stmt = "DO_stmt_h";
	}
	elsif ($bin =~ s/ %m %m %m$//) {
		$stmt = "DO_stmt_nnn";
	}
	elsif ($bin =~ s/ %m %m$//) {
		$stmt = "DO_stmt_nn";
	}
	elsif ($bin =~ s/ %u 0$//) {
		$stmt = "DO_stmt_n_0";
	}
	elsif ($bin =~ s/ %s 0$//) {
		$stmt = "DO_stmt_s_0";
	}
	elsif ($bin =~ s/ %M %M$//) {
		$stmt = "DO_stmt_NN";
	}
	elsif ($bin =~ s/ %j$//) {
		$stmt = "DO_stmt_jr";
	}
	elsif ($bin =~ s/%c\((.*?)\)/expr_value/) {
		my @values = eval($1); die "$cpu, $asm, @bin, $1" if $@;
		$bin =~ s/%c/expr_value/g;		# replace all other %c in bin
		push @code,
			"if (expr_error) { error_expected_const_expr(); } else {",
			"switch (expr_value) {",
			join(" ", map {"case $_:"} @values)." break;",
			"default: error_int_range(expr_value);",
			"}}";
			
		if ($bin =~ s/ %d// || $bin =~ s/%d //) {
			$stmt = "DO_stmt_idx";
		} 
		else {
			$stmt = "DO_stmt";
		}
	}
	elsif ($bin =~ s/ %d//) {
		$stmt = "DO_stmt_idx";
	}
	else {
		$stmt = "DO_stmt";
	}

	# build statement - need to leave expressions for C compiler
	if ($stmt) {
		@bin = split(' ', $bin);	# $bin has %x removed
		my @expr;
		for (@bin) {
			if (/[+*?<>]/) {
				my $offset = 0;
				if (s/^(\d+)\+//) {
					$offset = $1;
				}
				$_ =~ s/\b(\d+)\b/ $1 < 10 ? $1 : "0x".fmthex($1) /ge;
				push @expr, $_;
				$_ = fmthex($offset);
			}
			else {
				push @expr, undef;
				$_ = eval($_); die "$cpu, $asm, @bin, $_" if $@;
				$_ = fmthex($_);
			}
		}
		
		my $opc = "0x".join('', @bin);
		for (0..$#expr) {
			next unless defined $expr[$_];
			my $bytes_shift = scalar(@bin) - $_ - 1;
			$opc .= '+(('.($expr[$_]).')';
			$opc .= ' << '.($bytes_shift * 8) if $bytes_shift;
			$opc .= ')';
		}
		push @code, $stmt."(".$opc.$extra_arg.");";
	}

	my $code = join("\n", @code);
	return $code;
}

sub merge_cpu {
	my($t) = @_;
	my $ret = '';
	my %code;
	
	my $last_code;
	for my $cpu (@CPUS) {
		if (exists $t->{$cpu}) {
			my $code = merge_parens($cpu, $t->{$cpu});
			$code{$code}{$cpu}++;
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
		$ret .= "switch (option_cpu()) {\n";
		for my $code (sort keys %code) {
			for my $cpu (sort keys %{$code{$code}}) {
				$ret .= "case CPU_".uc($cpu).": ";
			}
			$ret .= "\n$code\nbreak;\n"
		}
		$ret .= "default: error_illegal_ident(); }\n";
	}
	
	return $ret;
}

sub merge_parens {
	my($cpu, $t) = @_;
	my $ret = '';
	
	if ($t->{no_expr}) {
		die if $t->{expr_no_parens} || $t->{expr_in_parens};
		return parse_code($cpu, @{$t->{no_expr}});
	}
	elsif (!$t->{expr_no_parens} && !$t->{expr_in_parens}) {
		die;
	}
	elsif (!$t->{expr_no_parens} && $t->{expr_in_parens}) {
		return "if (!expr_in_parens) return false;\n".
				parse_code($cpu, @{$t->{expr_in_parens}});			
	}
	elsif ($t->{expr_no_parens} && !$t->{expr_in_parens}) {
		return "if (expr_in_parens) warn_expr_in_parens();\n".
				parse_code($cpu, @{$t->{expr_no_parens}});
	}
	elsif ($t->{expr_no_parens} && $t->{expr_in_parens}) {
		my $in_parens = parse_code($cpu, @{$t->{expr_in_parens}});
		my $no_parens = parse_code($cpu, @{$t->{expr_no_parens}});
		return "if (expr_in_parens) { $in_parens } else { $no_parens }";
	}
	else {
		die;
	}
}

sub fmthex {
	return join(' ', map {/^\d+$/ ? sprintf('%02X', $_) : $_} @_);
}
