#!/usr/bin/env perl

#------------------------------------------------------------------------------
# Build parser rules for parsing the opcodes
#------------------------------------------------------------------------------

use Modern::Perl;
use YAML::Tiny;

@ARGV==2 or die "Usage: $0 input_file.yaml output_file.yaml\n";
my($input_file, $output_file) = @ARGV;

my $yaml = YAML::Tiny->read($input_file);
my %opcodes = %{$yaml->[0]};

my %parser;

my @CPUS = sort keys %{$opcodes{"nop"}};

for my $asm (sort keys %opcodes) {
	my @tokens = parser_tokens($asm);
	
	# check for parens
	my $parens;
	if    ($asm =~ /\(%[nmh]\)/) {		$parens = 'expr_in_parens'; }
	elsif ($asm =~ /%[snmjc]/) {		$parens = 'expr_no_parens'; }
	else {								$parens = 'no_expr';   }
		
	for my $cpu (sort keys %{$opcodes{$asm}}) {
		my @ops = @{$opcodes{$asm}{$cpu}};
		
		$parser{"@tokens"}{$cpu}{$parens} = [$asm, @ops];
	}
}

my %parser_yaml;

for my $tokens (sort keys %parser) {
	$parser_yaml{$tokens} = merge_cpu($parser{$tokens});
}

$yaml = YAML::Tiny->new(\%parser_yaml);
$yaml->write($output_file);

exit 0;

sub parser_tokens {
	local($_) = @_;
	my @tokens = ();
	
	while (!/\G \z 				/gcx) {
		if (/\G \s+ 			/gcx) {}
		elsif (/\G \( %[nmh] \)	/gcx) { push @tokens, "expr"; }
		elsif (/\G    %[snmMj]	/gcx) { push @tokens, "expr"; }
		elsif (/\G \+ %[dsu]	/gcx) { push @tokens, "expr"; }
		elsif (/\G    %[c]		/gcx) { push @tokens, "const_expr"; }
		elsif (/\G    (\w+)	'	/gcx) { push @tokens, "Keyword::".uc($1)."1"; }
		elsif (/\G    (\w+)		/gcx) { push @tokens, "Keyword::".uc($1); }
		elsif (/\G \(    		/gcx) { push @tokens, "TType::LParen"; }
		elsif (/\G , 			/gcx) { push @tokens, "TType::Comma"; }
		elsif (/\G \) 			/gcx) { push @tokens, "TType::RParen"; }
		elsif (/\G \+   		/gcx) { push @tokens, "TType::Plus"; }
		elsif (/\G \-   		/gcx) { push @tokens, "TType::Minus"; }
		elsif (/\G \.   		/gcx) { push @tokens, "TType::Dot"; }
		else { die "$_ ; ", substr($_, pos($_)||0) }
	}
	push @tokens, "TType::End";
	return @tokens;
}

sub parse_code {
	my($cpu, $asm, @ops) = @_;
	my @code;

	my @bin;
	for my $op (@ops) {
		push @bin, @$op;
	}
	my $bin = "@bin";
	
	#say "$cpu\t$asm\t$bin";

	# handle special case of jump to %t
	if (grep {/%t/} @{$ops[0]}) {
		my $op1 = $ops[0][0];
		my $op2 = $ops[1][0];
		push @code, "add_emul_call_flag(0x".fmthex($op1).", 0x".fmthex($op2).");";
	}
	# handle rst[.l] %c
	elsif ($asm =~ /^rst((\.(s|sil|l|lis))?) %c/) {
		if ($1) {
			push @code, "\n#if 0\n";
			push @code, 
				"DO_STMT_LABEL();",
				"DO_stmt(".sprintf("0x%02X", $ops[0][0]).");";
			push @code, "\n#endif\n";
			shift @ops;
		}
		for my $op (@ops) {
			push @code, parse_code_opcode($cpu, $asm, @$op);
		}
	}
	# handle ld dd,(ix+d) -> ld ddl,(ix+d) : ld ddh, (ix+d+1)
	elsif ($bin =~ /%D/) {
		push @code, "\n#if 0\n";
		push @code, "DO_STMT_LABEL();";
		for my $i (0 .. $#ops) {
			if (($ops[$i][2]//'') eq '%d' && ($ops[$i+1][2]//'') eq '%D') {
				my $opcode0 = ($ops[$i+0][0] << 8) + $ops[$i+0][1];
				my $opcode1 = ($ops[$i+1][0] << 8) + $ops[$i+1][1];
				push @code, 
					"DO_stmt_idx_idx1(".sprintf("0x%04X, 0x%04X", $opcode0, $opcode1).");";
			}
			elsif ($ops[$i][2]//'' eq '%D') {
				# already handled
			}
			else {
				push @code, parse_code_opcode($cpu, $asm, @{$ops[$i]});
			}
		}
		push @code, "\n#endif\n";
	}
	else {
		for my $op (@ops) {
			push @code, parse_code_opcode($cpu, $asm, @$op);
		}
	}
	
	return join("\n", @code);
}

sub parse_code_opcode {
	my($cpu, $asm, @bin) = @_;
	my $bin = join(' ', @bin);
	
	if ($bin =~ s/ \@(\w+)//) {
		return "add_call_function(\"$1\");";
	}
	elsif ($asm =~ /^rst /) {
		return "add_restart();";
	}
	elsif ($asm =~ /^mmu %c, %n/) {
		return "add_z80n_mmu_n();";
	}
	elsif ($asm =~ /^mmu %c, a/) {
		return "add_z80n_mmu_a();";
	}
	
	my @bin0 = @bin;
	my @code;

	#say "$cpu\t$asm\t@bin";
	
	# check for argument type
	my($stmt, $extra_arg) = ("", "");
	$bin = join(' ', @bin);
	
	if ($bin =~ s/ \@(\w+)//) {
		my $func = $1;
		push @code, "\n#if 0\n";
		push @code, 
			"DO_STMT_LABEL();",
			"add_call_emul_func(\"$func\");";
		push @code, "\n#endif\n";
		my $code = join("\n", @code);
		return $code;
	}
	elsif ($asm =~ /^rst((\.(s|sil|l|lis))?) %c/) {
		push @code, "\n#if 0\n";
		push @code, 
			"DO_STMT_LABEL();",
			"if (expr_error) { error_expected_const_expr(); }".
			"else { add_rst_opcode(expr_value); }";
		push @code, "\n#endif\n";
		my $code = join("\n", @code);
		return $code;
	}
	elsif ($asm =~ /^mmu %c, %n/) {
		push @code, "\n#if 0\n";
		push @code, 
			"DO_STMT_LABEL();",
			"if (expr_error) { error_expected_const_expr(); } else {",
			"if (expr_value < 0 || expr_value > 7) error_int_range(expr_value);",
			"DO_stmt_n(0xED9150 + expr_value);}";
		push @code, "\n#endif\n";
		my $code = join("\n", @code);
		return $code;
	}
	elsif ($asm =~ /^mmu %c, a/) {
		push @code, "\n#if 0\n";
		push @code, 
			"DO_STMT_LABEL();",
			"if (expr_error) { error_expected_const_expr(); } else {",
			"if (expr_value < 0 || expr_value > 7) error_int_range(expr_value);",
			"DO_stmt(0xED9250 + expr_value);}";
		push @code, "\n#endif\n";
		my $code = join("\n", @code);
		return $code;
	}
	elsif ($bin =~ s/ %d %n$//) {
		return "add_opcode_idx_n(".build_bytes($bin).");";
	}
	elsif ($bin =~ s/ %n %n$//) {
		return "add_opcode_n_n(".build_bytes($bin).");";
	}
	elsif ($bin =~ s/ %n$//) {
		return "add_opcode_n(".build_bytes($bin).");";
	}
	elsif ($bin =~ s/ %u$//) {
		return "add_opcode_n(".build_bytes($bin).");";
	}
	elsif ($bin =~ s/ %s$//) {
		return "add_opcode_s(".build_bytes($bin).");";
	}
	elsif ($bin =~ s/ %h$//) {
		return "add_opcode_h(".build_bytes($bin).");";
	}
	elsif ($bin =~ s/ %m %m %m$//) {
		return "add_opcode_nnn(".build_bytes($bin).");";
	}
	elsif ($bin =~ s/ %m %m$//) {
		return "add_opcode_nn(".build_bytes($bin).");";
	}
	elsif ($bin =~ s/ %u 0$//) {
		return "add_opcode_n_0(".build_bytes($bin).");";
	}
	elsif ($bin =~ s/ %s 0$//) {
		return "add_opcode_s_0(".build_bytes($bin).");";
	}
	elsif ($bin =~ s/ %M %M$//) {
		return "add_opcode_NN(".build_bytes($bin).");";
	}
	elsif ($bin =~ s/ %j$//) {
		return "add_jump_relative(".build_bytes($bin).");";
	}
	elsif ($bin =~ s/%c\((.*?)\)/c/) {
		my @values = eval($1); die "$cpu, $asm, @bin, $1" if $@;
		$bin =~ s/%c/c/g;		# replace all other %c in bin
		my $code =  "{\n".
					"Assert(m_exprs.size() >= 1);\n".
					"Assert(m_exprs[0]->is_const());\n".
					"int c = m_exprs[0]->value();\n".
					"m_exprs.pop_front();\n".
					"switch (c) {\n".
					join(" ", map {"case $_:"} @values)." break;\n".
					"default: ".
					"g_errors.error(ErrCode::IntRange, int_to_hex(c, 2));\n".
					"}\n";
		if ($bin =~ s/ %d// || $bin =~ s/%d //) {
			$code .= "add_opcode_idx(".build_bytes($bin).");\n";
		} 
		else {
			$code .= "add_opcode(".build_bytes($bin).");\n";
		}
		$code .= "}";
		return $code;
	}
	elsif ($bin =~ s/ %d//) {
		return "add_opcode_idx(".build_bytes($bin).");";
	}
	else {
		return "add_opcode(".build_bytes($bin).");";
	}
}

# build opcode bytes - need to leave expressions for C compiler
sub build_bytes {
	my($bin) = @_;
	my @bin = split(' ', $bin);
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
			$_ = eval($_); die "$bin, $_" if $@;
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
	
	return $opc;
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
		$ret .= "switch (g_args.cpu()) {\n";
		for my $code (sort keys %code) {
			for my $cpu (sort keys %{$code{$code}}) {
				$ret .= "case CPU_".uc($cpu).": ";
			}
			$ret .= "\n$code\nbreak;\n"
		}
		$ret .= "default: ".
				"g_errors.error(ErrCode::IllegalIdent, m_line.peek_text()); ".
                "}\n";
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
		return "if (!expr_in_parens()) { ".
				"g_errors.error(ErrCode::ExprNotInParens); ".
				"return; }\n".
				parse_code($cpu, @{$t->{expr_in_parens}});			
	}
	elsif ($t->{expr_no_parens} && !$t->{expr_in_parens}) {
		return "if (expr_in_parens()) ".
				"g_errors.warning(ErrCode::ExprInParens);\n".
				parse_code($cpu, @{$t->{expr_no_parens}});
	}
	elsif ($t->{expr_no_parens} && $t->{expr_in_parens}) {
		return 	"if (expr_in_parens()) { ".
				parse_code($cpu, @{$t->{expr_in_parens}}).
				" } else { ".
				parse_code($cpu, @{$t->{expr_no_parens}}).
				" }";
	}
	else {
		die;
	}
}

sub fmthex {
	return join(' ', map {/^\d+$/ ? sprintf('%02X', $_) : $_} @_);
}
