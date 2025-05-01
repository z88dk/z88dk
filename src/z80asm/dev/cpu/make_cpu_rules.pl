#!/usr/bin/env perl

#------------------------------------------------------------------------------
# Build ragel source code to parse opcodes
#------------------------------------------------------------------------------

use Modern::Perl;
BEGIN { 
	use Path::Tiny;
	use lib path($0)->dirname;
	use Opcodes;
}
use Carp (); 
use Data::Dump 'dump'; 
$SIG{__DIE__} = \&Carp::confess;
use warnings FATAL => 'all';

@ARGV==2 or die "Usage: $0 input_file.dat output_file.h\n";
my($input_file, $output_file) = @ARGV;

my $aux_func_name = $output_file =~ s/\..*/_action_/r;
my $output_aux_file_header = $output_file =~ s/\.\w+$/_action.h/r;
my $output_aux_file_source = $output_file =~ s/\.\w+$/_action.c/r;


my $opcodes = Opcodes->from_file($input_file);

my %parser;

for my $asm (sort keys %{$opcodes->opcodes}) {
	my $tokens = parser_tokens($asm);
	
	# check for parens
	my $parens;
	if    ($asm =~ /\(%[nmh]\)/) {		$parens = 'expr_in_parens'; }
	elsif ($asm =~ /\(\w+\+%[dsu]/) {	$parens = 'no_expr'; }
	elsif ($asm =~ /\w+\+%[dsu]/) {		$parens = 'no_expr'; }
	elsif ($asm =~ /%[snmMjJkc]/) {		$parens = 'expr_no_parens'; }
	elsif ($asm !~ /%/) {				$parens = 'no_expr';   }
	else { die $asm; }
		
	for my $cpu (sort keys %{$opcodes->opcodes->{$asm}}) {
		my $opcode = $opcodes->opcodes->{$asm}{$cpu};
		
		$parser{$tokens}{$cpu}{$parens} = $opcode;
	}
}

open(my $rules, ">", $output_file) or die "$output_file: $!";
open(my $aux_h, ">", $output_aux_file_header) or die "$output_aux_file_header: $!";
open(my $aux_c, ">", $output_aux_file_source) or die "$output_aux_file_source: $!";

say $aux_h <<END;
#pragma once
#include "codearea.h"
#include "directives.h"
#include "errors.h"
#include "expr1.h"
#include "if.h"
#include "opcodes.h"
#include "options.h"
#include "parse1.h"
#include "str.h"

/*-----------------------------------------------------------------------------
*   Helper macros
*----------------------------------------------------------------------------*/

/* macros for actions - labels */
#define DO_STMT_LABEL() asm_cond_LABEL(stmt_label)

/* macros for actions - statements */
#define DO_stmt(opcode) \\
			do { \\
				DO_STMT_LABEL(); \\
				add_opcode(opcode); \\
			} while(0)

#define _DO_stmt_(suffix, opcode) \\
			do { \\
			 	Expr1 *expr = pop_expr(ctx); \\
				DO_STMT_LABEL(); \\
				add_opcode_##suffix((opcode), expr); \\
			} while(0)

#define DO_stmt_jr( opcode)		_DO_stmt_(jr,		opcode)
#define DO_stmt_jre( opcode)	_DO_stmt_(jre,		opcode)
#define DO_stmt_n(  opcode)		_DO_stmt_(n,		opcode)
#define DO_stmt_h(  opcode)		_DO_stmt_(h,		opcode)
#define DO_stmt_n_0(opcode)		_DO_stmt_(n_0,		opcode)
#define DO_stmt_n_0_0(	opcode)	_DO_stmt_(n_0_0,	opcode)
#define DO_stmt_s_0(opcode)		_DO_stmt_(s_0,		opcode)
#define DO_stmt_s_0_0(opcode)	_DO_stmt_(s_0_0,	opcode)
#define DO_stmt_d(  opcode)		_DO_stmt_(d,		opcode)

#define DO_stmt_nn( opcode) \\
			do { \\
			 	Expr1 *expr = pop_expr(ctx); \\
				DO_STMT_LABEL(); \\
				add_opcode_nn((opcode), expr, 0); \\
			} while(0)

#define DO_stmt_nnn( opcode) \\
			do { \\
			 	Expr1 *expr = pop_expr(ctx); \\
				DO_STMT_LABEL(); \\
				add_opcode_nnn((opcode), expr, 0); \\
			} while(0)


#define DO_stmt_nnnn( opcode)	_DO_stmt_(nnnn,		opcode)
#define DO_stmt_NN( opcode)		_DO_stmt_(NN,		opcode)
#define DO_stmt_idx(opcode)		_DO_stmt_(idx,		opcode)

#define DO_stmt_idx_n(opcode) \\
			do { \\
			 	Expr1 *n_expr   = pop_expr(ctx); \\
				Expr1 *idx_expr = pop_expr(ctx); \\
				DO_STMT_LABEL(); \\
				add_opcode_idx_n((opcode), idx_expr, n_expr); \\
			} while(0)

#define DO_stmt_n_n(opcode) \\
			do { \\
			 	Expr1 *n2_expr = pop_expr(ctx); \\
				Expr1 *n1_expr = pop_expr(ctx); \\
				DO_STMT_LABEL(); \\
				add_opcode_n_n((opcode), n1_expr, n2_expr); \\
			} while(0)

#define DO_stmt_idx_idx1(opcode0, opcode1) \\
			do { \\
			 	Expr1 *idx_expr = pop_expr(ctx); \\
				DO_STMT_LABEL(); \\
				add_opcode_idx_idx1((opcode0), (opcode1), idx_expr); \\
			} while(0)

#define DO_stmt_nn_nn(opcode0, opcode1) \\
			do { \\
			 	Expr1 *expr = pop_expr(ctx); \\
				DO_STMT_LABEL(); \\
				add_opcode_nn_nn((opcode0), (opcode1), expr); \\
			} while(0)

#define DO_stmt_jr_jr(opcode0, opcode1) \\
			do { \\
			 	Expr1 *expr = pop_expr(ctx); \\
				DO_STMT_LABEL(); \\
				add_opcode_jr_jr((opcode0), (opcode1), expr); \\
			} while(0)

#define DO_stmt_defb() \\
			do { \\
			 	Expr1 *expr = pop_expr(ctx); \\
				DO_STMT_LABEL(); \\
				add_opcode_defb(expr); \\
			} while(0)

#define DO_stmt_x_nn(opcode) \\
			do { \\
			 	Expr1 *nn_expr = pop_expr(ctx); \\
				Expr1 *x_expr = pop_expr(ctx); \\
				DO_STMT_LABEL(); \\
				add_opcode_x_nn((opcode), x_expr, nn_expr); \\
			} while(0)

#define DO_stmt_xx_nn(opcode) \\
			do { \\
			 	Expr1 *nn_expr = pop_expr(ctx); \\
				Expr1 *xx_expr = pop_expr(ctx); \\
				DO_STMT_LABEL(); \\
				add_opcode_xx_nn((opcode), xx_expr, nn_expr); \\
			} while(0)


END

say $aux_c <<END;
#include "$output_aux_file_header"
END

my $action_nr = 0;
for my $tokens (sort keys %parser) {
	$action_nr++;
	#say $tokens;
	
	say $rules $tokens, ' @{ ',
				"if (!${aux_func_name}${action_nr}(ctx, name, stmt_label)) return false; }";
	
	say $aux_h "bool ${aux_func_name}${action_nr}",
						"(ParseCtx *ctx, Str *name, Str *stmt_label);";
	
	say $aux_c "bool ${aux_func_name}${action_nr}",
						"(ParseCtx *ctx, Str *name, Str *stmt_label) {";
	say $aux_c merge_cpu($parser{$tokens});
	say $aux_c "return true;";
	say $aux_c "}\n";
}

exit 0;

sub parser_tokens {
	local($_) = @_;
	my $instr_flag = qr/\b(?:call|call3|jp|jmp|jr|jre|jp3|lljp|ret|ret3|rst|flag)\b/i;
	my $am = qr/\b(?:l|il|is|lil|lis|sil|sis)\b/i;
	my $flag = qr/\b(?:nz|z|nc|c|po|pe|p|m|lz|lo|nv|v|x5|nx5|k|nk|ne|eq|ltu|leu|gtu|geu|lt|le|gt|ge)\b/i;
	my $instr_x = qr/\b(cpd|cpdr|cpi|cpir|ind|indr|ini|inir|otdr|otir|outd|outi)\s+(x)\b/i;
	my $instr_xy = qr/\b(ldd|lddr|ldi|ldir)\s+(xy)\b/i;
	
	my @tokens = ();
	
	while (!/\G \z 				/gcx) {
		if (/\G \s+ 			/gcx) {}
		elsif (/\G \( (\w+)		/gcx) { push @tokens, "_TK_IND_".uc($1); }
		elsif (/\G ($instr_flag) \s+ ($flag) \b
								/gcx) { push @tokens, "_TK_".uc($1)."_".uc($2); }
		elsif (/\G ($instr_flag) \s* \. \s* ($am) \s+ ($flag) \b
								/gcx) { push @tokens, "_TK_".uc($1)."_".uc($2)."_".uc($3); }
		elsif (/\G $instr_x		/gcx) { push @tokens, "_TK_".uc($1)."_".uc($2); }
		elsif (/\G $instr_xy	/gcx) { push @tokens, "_TK_".uc($1)."_".uc($2); }
		elsif (/\G , 			/gcx) { push @tokens, "_TK_COMMA"; }
		elsif (/\G \) 			/gcx) { push @tokens, "_TK_RPAREN"; }
		elsif (/\G \( %[nmh] \)	/gcx) { push @tokens, "expr"; }
		elsif (/\G    %[snmMjJx]/gcx) { push @tokens, "expr"; }
		elsif (/\G \+ %[dsu]	/gcx) { push @tokens, "expr"; }
		elsif (/\G    %[c]		/gcx) { push @tokens, "const_expr"; }
		elsif (/\G    (\w+)	'	/gcx) { push @tokens, "_TK_".uc($1)."1"; }
		elsif (/\G    (\w+)		/gcx) { push @tokens, "_TK_".uc($1); }
		elsif (/\G \+   		/gcx) { push @tokens, "_TK_PLUS"; }
		elsif (/\G \-   		/gcx) { push @tokens, "_TK_MINUS"; }
		elsif (/\G \.   		/gcx) { push @tokens, "_TK_DOT"; }
		elsif (/\G \:   		/gcx) { push @tokens, "_TK_COLON"; }
		else { die "$_ ; ", substr($_, pos($_)||0) }
	}
	return join(' ', ('| label?', @tokens, "_TK_NEWLINE"));
}

sub multiple_uses_of_expr {
	my($opcode) = @_;
	my @ops = @{$opcode->ops};
	my %found;
	for my $i (0..$#ops) {
		for (@{$ops[$i]}) {
			if (/%m/) {
				$found{$i}++;
			}
		}
	}
	return scalar keys %found > 1;
}

sub parse_code {
	my($cpu, $opcode) = @_;
	my $asm = $opcode->asm;
	my @ops = @{$opcode->ops};
	my @bytes = $opcode->bytes;
	my $bytes = "@bytes";
	my @code;

	#say "$cpu\t$asm\t$bytes";

	# handle option -no_synth
	if ($opcode->synth) {
		push @code,
			"if (option_no_synth())",
			"\terror(ErrIllegalIdent, NULL);";
	}

	# handle special case of jump to %t
	if ($bytes =~ /%t/) {
		push @code,
			"{",
			"DO_STMT_LABEL();",
			"const char *end_label = autolabel();";
		for my $op (@ops) {
			my $count_t = scalar(grep {/%t/} @$op);
			if ($count_t) {
				my $bin = 0;
				my $target_offset = 0;
				for my $i (0 .. $#$op) {
					if ($op->[$i] =~ /%t(\d*)/) {
						if ($1) {
							$target_offset = $1;
						}
						last;
					}
					else {
						$bin = ($bin << 8) | ($op->[$i] & 0xFF);
					}
				}
				
				if ($count_t==1) {
					push @code,
						"add_opcode_jr_end(0x".fmthex($bin).", end_label, $target_offset);";
				}
				elsif ($count_t==2) {
					push @code,
						"add_opcode_jp_nn_end(0x".fmthex($bin).", end_label, $target_offset);";
				}
				elsif ($count_t==3) {	
					push @code,
						"add_opcode_jp_nnn_end(0x".fmthex($bin).", end_label, $target_offset);";
				}
				else {	
					die $count_t;
				}				
			}
			else {
				push @code, parse_code_opcode($cpu, $opcode, @$op);
			}
		}
		push @code, 
			"asm_LABEL_offset(end_label, get_cur_opcode_size());",
			"}";
	}
	# handle multiple uses of the same expression
	elsif (multiple_uses_of_expr($opcode)) {
		push @code,
			"{",
			"DO_STMT_LABEL();",
			"Expr1 *expr = pop_expr(ctx);";
		for my $op (@ops) {
			my $count_m = scalar(grep {/%m/} @$op);
			if ($count_m) {
				my $bin = 0;
				my $target_offset = 0;
				for my $i (0 .. $#$op) {
					if ($op->[$i] =~ /%m(\d*)/) {
						if ($1) {
							$target_offset = $1;
						}
						last;
					}
					else {
						$bin = ($bin << 8) | ($op->[$i] & 0xFF);
					}
				}
				
				if ($count_m==2) {
					push @code,
						"add_opcode_nn(0x".fmthex($bin).", Expr1_clone(expr), $target_offset);";
				}
				elsif ($count_m==3) {	
					push @code,
						"add_opcode_nnn(0x".fmthex($bin).", Expr1_clone(expr), $target_offset);";
				}
				elsif ($count_m==4) {	
					push @code,
						"add_opcode_nnnn(0x".fmthex($bin).", Expr1_clone(expr));";
				}
				else {	
					die $count_m;
				}				
			}
			else {
				push @code, parse_code_opcode($cpu, $opcode, @$op);
			}
		}
		push @code, 
			"OBJ_DELETE(expr);",
			"}";
	}
	# handle two jump relatives to same address
	elsif ($bytes =~ /%j \d+ %j/) {
		push @code,
			"{",
			"DO_STMT_LABEL();",
			"Expr1 *expr = pop_expr(ctx);";
		for my $op (@ops) {
			my $count_j = scalar(grep {/%j/} @$op);
			if ($count_j) {
				my $bin = 0;
				for my $i (0 .. $#$op) {
					last if $op->[$i] =~ /%j/;
					$bin = ($bin << 8) | ($op->[$i] & 0xFF);
				}
				
				if ($count_j==1) {
					push @code,
						"add_opcode_jr(0x".fmthex($bin).", Expr1_clone(expr));";
				}
				else {	
					die $count_j;
				}				
			}
			else {
				push @code, parse_code_opcode($cpu, $opcode, @$op);
			}
		}
		push @code, 
			"OBJ_DELETE(expr);",
			"}";
	}
	# handle ld dd,(ix+d) -> ld ddl,(ix+d) : ld ddh, (ix+d+1)
	elsif ($bytes =~ /%D/) {
		for my $i (0 .. $#ops) {
			if (($ops[$i][2]//'') eq '%d' && ($ops[$i+1][2]//'') eq '%D') {
				my $opcode0 = ($ops[$i+0][0] << 8) + $ops[$i+0][1];
				my $opcode1 = ($ops[$i+1][0] << 8) + $ops[$i+1][1];
				push @code, 
					"DO_stmt_idx_idx1(".sprintf("0x%04XLL, 0x%04XLL", $opcode0, $opcode1).");";
			}
			elsif ($ops[$i][2]//'' eq '%D') {
				# handled above
			}
			else {
				push @code, parse_code_opcode($cpu, $opcode, @{$ops[$i]});
			}
		}
	}
	else {
		for my $op (@ops) {
			push @code, parse_code_opcode($cpu, $opcode, @$op);
		}
	}
	
	return join("\n", @code);
}

sub parse_code_opcode {
	my($cpu, $opcode, @bytes) = @_;
	my $asm = $opcode->asm;
	my @const = sort {$a <=> $b} @{$opcode->const};
	my @code;

	# check for argument type
	my $stmt = "";
	my $bytes = join(' ', @bytes);
	
	#say "$cpu\t$asm\t@bytes" if $asm =~ /lcall/;
	
	if ($bytes =~ s/ \@(\w+)//) {
		my $func = $1;
		push @code, 
			"DO_STMT_LABEL();",
			"add_call_emul_func(\"$func\");";
	}
	elsif ($asm =~ /^mmu %c, %n/) {
		push @code, 
			"if (ctx->expr_error) { error(ErrConstExprExpected, NULL); } else {",
			"if (ctx->expr_value < 0 || ctx->expr_value > 7) error_hex2(ErrIntRange, ctx->expr_value);",
			"DO_stmt_n(0xED9150LL + ctx->expr_value);}";
	}
	elsif ($asm =~ /^mmu %c, a/) {
		push @code, 
			"if (ctx->expr_error) { error(ErrConstExprExpected, NULL); } else {",
			"if (ctx->expr_value < 0 || ctx->expr_value > 7) error_hex2(ErrIntRange, ctx->expr_value);",
			"DO_stmt(0xED9250LL + ctx->expr_value);}";
	}
	elsif ($bytes =~ s/ %d %n$//) {
		$stmt = "DO_stmt_idx_n";
	}
	elsif ($bytes =~ s/ %n %n$//) {
		$stmt = "DO_stmt_n_n";
	}
	elsif ($bytes =~ s/ %n$//) {
		$stmt = "DO_stmt_n";
	}
	elsif ($bytes =~ s/ %u$//) {
		$stmt = "DO_stmt_n";
	}
	elsif ($bytes =~ s/ %s$//) {
		$stmt = "DO_stmt_d";
	}
	elsif ($bytes =~ s/ %h$//) {
		$stmt = "DO_stmt_h";
	}
	elsif ($bytes =~ s/ %m %m %x %x$//) {
		$stmt = "DO_stmt_xx_nn";
	}
	elsif ($bytes =~ s/ %m %m %x$//) {
		$stmt = "DO_stmt_x_nn";
	}
	elsif ($bytes =~ s/ %m %m %m %m$//) {
		$stmt = "DO_stmt_nnnn";
	}
	elsif ($bytes =~ s/ %m %m %m$//) {
		$stmt = "DO_stmt_nnn";
	}
	elsif ($bytes =~ s/ %m %m$//) {
		$stmt = "DO_stmt_nn";
	}
	elsif ($bytes =~ s/ %u 0 0$//) {
		$stmt = "DO_stmt_n_0_0";
	}
	elsif ($bytes =~ s/ %u 0$//) {
		$stmt = "DO_stmt_n_0";
	}
	elsif ($bytes =~ s/ %n 0 0$//) {
		$stmt = "DO_stmt_n_0_0";
	}
	elsif ($bytes =~ s/ %n 0$//) {
		$stmt = "DO_stmt_n_0";
	}
	elsif ($bytes =~ s/ %s 0$//) {
		$stmt = "DO_stmt_s_0";
	}
	elsif ($bytes =~ s/ %s 0 0$//) {
		$stmt = "DO_stmt_s_0_0";
	}
	elsif ($bytes =~ s/ %M %M$//) {
		$stmt = "DO_stmt_NN";
	}
	elsif ($bytes =~ s/ %j$//) {
		$stmt = "DO_stmt_jr";
	}
	elsif ($bytes =~ s/ %J %J$//) {
		$stmt = "DO_stmt_jre";
	}
	elsif ($asm =~ /%c/) {
		$bytes =~ s/%c/ctx->expr_value/g;
		push @code,
			"if (ctx->expr_error) { error(ErrConstExprExpected, NULL); } else {",
			"switch (ctx->expr_value) {",
			join(" ", map {"case $_:"} @const)." break;",
			"default: error_hex2(ErrIntRange, ctx->expr_value);",
			"}}";
			
		if ($bytes =~ s/ %d// || $bytes =~ s/%d //) {
			$stmt = "DO_stmt_idx";
		} 
		else {
			$stmt = "DO_stmt";
		}
	}
	elsif ($bytes =~ s/ %d//) {
		$stmt = "DO_stmt_idx";
	}
	elsif ($bytes =~ s/^%s//) {
		push @code, "DO_stmt_defb();";		# call __z80asm__add_sp_s : defb %s
	}
	else {
		$stmt = "DO_stmt";
	}

	# build statement - need to leave expressions for C compiler
	if ($stmt) {
		@bytes = split(' ', $bytes);	# $bytes has %x removed

		#say "@bytes";

		my @expr;
		for (@bytes) {
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
				$_ = eval($_); die "$cpu, $asm, @bytes, $_" if $@;
				$_ = fmthex($_);
			}
		}
		
		my $opc = "0x".join('', @bytes)."LL";
		for (0..$#expr) {
			next unless defined $expr[$_];
			my $bytes_shift = scalar(@bytes) - $_ - 1;
			$opc .= '+(('.($expr[$_]).')';
			$opc .= ' << '.($bytes_shift * 8) if $bytes_shift;
			$opc .= ')';
		}
		push @code, $stmt."(".$opc.");";
	}

	my $code = join("\n", @code);
	return $code;
}

sub merge_cpu {
	my($t) = @_;
	my $ret = '';
	my @cpus = Opcode->cpus();
	my %code;
	
	my $last_code;
	for my $cpu (@cpus) {
		if (exists $t->{$cpu}) {
			my $code = merge_parens($cpu, $t->{$cpu});
			$code{$code}{$cpu}++;
			$last_code = $code;
		}
	}
	
	if (scalar(keys %code) == 1 && 
	    scalar(keys %{$code{$last_code}}) == scalar(@cpus)) {
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
		$ret .= "default: ".
				"error(ErrIllegalIdent, NULL); ".
				"}\n";
	}
	
	return $ret;
}

sub merge_parens {
	my($cpu, $t) = @_;
	my $ret = '';
	
	if ($t->{no_expr}) {
		die if $t->{expr_no_parens} || $t->{expr_in_parens};
		return parse_code($cpu, $t->{no_expr});
	}
	elsif (!$t->{expr_no_parens} && !$t->{expr_in_parens}) {
		die;
	}
	elsif (!$t->{expr_no_parens} && $t->{expr_in_parens}) {
		return "if (!ctx->expr_in_parens) return false;\n".
				parse_code($cpu, $t->{expr_in_parens});			
	}
	elsif ($t->{expr_no_parens} && !$t->{expr_in_parens}) {
		return "if (ctx->expr_in_parens) warning(ErrExprInParens, NULL);\n".
				parse_code($cpu, $t->{expr_no_parens});
	}
	elsif ($t->{expr_no_parens} && $t->{expr_in_parens}) {
		my $in_parens = parse_code($cpu, $t->{expr_in_parens});
		my $no_parens = parse_code($cpu, $t->{expr_no_parens});
		return "if (ctx->expr_in_parens) { $in_parens } else { $no_parens }";
	}
	else {
		die;
	}
}

sub fmthex {
	return join(' ', map {/^\d+$/ ? sprintf('%02X', $_) : $_} @_);
}
