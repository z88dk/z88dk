#!/usr/bin/env perl

use Modern::Perl;
use YAML::Tiny;

my $yaml = YAML::Tiny->read("opcodes.yaml");
my %opcodes = %{$yaml->[0]};

my %parser;

my @CPUS = sort keys %{$opcodes{"nop"}};

for my $asm (sort keys %opcodes) {
	my $tokens = parser_tokens($asm);
	
	# asm for swap_ix_iy
	(my $asm_swap = $asm) =~ s/\b(ix|iy)/ $1 eq 'ix' ? 'iy' : 'ix' /ge;
	
	# check for parens
	my $parens;
	if    ($asm =~ /\(%[nmh]\)/) {		$parens = 'expr_in_parens'; }
	elsif ($asm =~ /%[snmjc]/) {		$parens = 'expr_no_parens'; }
	else {								$parens = 'no_expr';   }
		
	for my $cpu (sort keys %{$opcodes{$asm}}) {
		my @ops = @{$opcodes{$asm}{$cpu}};
		my @ops_swap = @{$opcodes{$asm_swap}{$cpu}};
		
		$parser{$tokens}{$cpu}{$parens}{ixiy} = [$asm, @ops];
		$parser{$tokens}{$cpu}{$parens}{iyix} = [$asm_swap, @ops_swap];
	}
}

open(my $rules, ">", "cpu_rules.h") or die $!;

for my $tokens (sort keys %parser) {
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
			"Expr *target_expr = pop_expr(ctx);",
			"const char *end_label = autolabel();",
			"Expr *end_label_expr = parse_expr(end_label);",
			"add_opcode_nn(0x".fmthex($op1).", end_label_expr);",	# jump over
			"add_opcode_nn(0x".fmthex($op2).", target_expr);",		# call
			"asm_LABEL_offset(end_label, 6);";
	}
	# handle special case of dec b;jr nz, %j
	elsif (@ops==2 && $ops[0][0] == 0x05 && $ops[1][1] eq '%j') {
		my $opc = "0x".fmthex($ops[1][0]);
		push @code, 
			"DO_stmt(0x05);",
			# compensate for extra byte
			"add_opcode_jr_n($opc, pop_expr(ctx), 1);";	
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
	
	# check for argument type
	my($stmt, $extra_arg) = ("", "");
	my $bin = join(' ', @bin);
	
	if ($bin =~ s/ \@(\w+)//) {
		my $func = $1;
		push @code, 
			"DO_STMT_LABEL();",
			"add_call_emul_func(\"$func\");";
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
		$ret .= "switch (opts.cpu) {\n";
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
		return merge_ixiy($cpu, $t->{no_expr});
	}
	elsif (!$t->{expr_no_parens} && !$t->{expr_in_parens}) {
		die;
	}
	elsif (!$t->{expr_no_parens} && $t->{expr_in_parens}) {
		return "if (!expr_in_parens) return false;\n".
				merge_ixiy($cpu, $t->{expr_in_parens});			
	}
	elsif ($t->{expr_no_parens} && !$t->{expr_in_parens}) {
		return "if (expr_in_parens) warn_expr_in_parens();\n".
				merge_ixiy($cpu, $t->{expr_no_parens});
	}
	elsif ($t->{expr_no_parens} && $t->{expr_in_parens}) {
		my($common, $in_parens, $no_parens) = 
			extract_common(merge_ixiy($cpu, $t->{expr_in_parens}),
						   merge_ixiy($cpu, $t->{expr_no_parens}));
		return $common.
				"if (expr_in_parens) { $in_parens } else { $no_parens }";
	}
	else {
		die;
	}
}

sub merge_ixiy {
	my($cpu, $t) = @_;
	
	my $ixiy = parse_code($cpu, @{$t->{ixiy}});
	my $iyix = parse_code($cpu, @{$t->{iyix}});
	
	if ($ixiy eq $iyix) {
		return $ixiy;
	}
	else {
		(my $common, $ixiy, $iyix) = extract_common($ixiy, $iyix);
		return $common.
				"if (!opts.swap_ix_iy) { $ixiy } else { $iyix }";
	}
}

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

sub fmthex {
	return join(' ', map {/^\d+$/ ? sprintf('%02X', $_) : $_} @_);
}
