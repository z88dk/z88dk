#------------------------------------------------------------------------------
# Z88DK Z80 Macro Assembler
#
# Z80/Z180/RCM2000/RCM3000 assembly table
# Generate test code and parsing tables for the cpus defined in cpu.def
#
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------
use strict;
use warnings;
use v5.10;

my %Opcodes;
my %Parser;
my %Tests;
my @CPUS = qw( z80 z180 r2k r3k );

(my $data_file = $0) =~ s/\.pl$/.def/;
open(my $fh, "<", $data_file) or die "$data_file: $!";
while (<$fh>) {
	s/^\s+//; s/\s+$//; s/\s+/ /g;
	last if /^ __END__ /x;
	next if /^ \# /x;
	next unless /\S/;
	
	# check for cpu tag
	my $cpu_tag = 'all';
	if (/^ \s* \[ \s* (\w+) \s* \] \s* (.*)/x) {
		($cpu_tag, $_) = ($1, $2);
	}
	my($asm, $bin) = split(/\s*=>\s*/, $_, 2);
	
	add($cpu_tag, $asm, $bin);
}

build_parser();

(my $ragel_file = $0) =~ s/\.pl$/_rules.h/;
write_ragel($ragel_file);

(my $test_file_base = $0) =~ s/\.pl$/_test/;
write_tests($test_file_base);

# expand and recurse, call add_final at the end
sub add {
	my($cpu_tag, $asm, $bin, $level) = @_;
	$level ||= 1;

	# expand <b.c...>, <expr>
	if ($asm =~ / (.*?) < (.*?) > (.*) /x) {
		my($asm1, $asm2, $asm3) = ($1, $2, $3);
		my @l = split(/\./, $asm2);
		@l = map { [ $_, $l[$_] ] } (0..$#l);
		for (@l) {
			my($i, $v) = @$_;
			next if $v eq '';
			(my $bin1 = $bin) =~ s/<$level>/$i/;
			add($cpu_tag, "$asm1$v$asm3", $bin1, $level+1);
		}
		return;
	}
	else {
		add_1($cpu_tag, $asm, $bin);
	}
}

sub add_1 {
	my($cpu_tag, $asm, $bin) = @_;
	
	# expand ixh, ixl, iyh, iyl
	if ($asm =~ / \b [hl] \b /x && $asm !~ /hl|ix|iy/ &&
		check_cpu_tag('z80', $cpu_tag) && $bin !~ /^(?:ED|CB) /) {
		for ([ix => 'DD'], [iy => 'FD']) {
			my($r, $b) = @$_;
			(my $asm1 = $asm) =~ s/ \b ([hl]) \b /$r$1/gx;
			add_2('z80', $asm1, "$b $bin");
		}	
	}
	
	add_2($cpu_tag, $asm, $bin);
}

sub add_2 {
	my($cpu_tag, $asm, $bin) = @_;
	
	# expand altd op r, ; op r',
	my $for_rabbit = ($asm !~ / \b (?: i[xy][hl] | i | r ) \b /x);
		
	# ld r,*
	if ($asm =~ /^ (ld) \s+ (b|c|d|e|h|l|a|f|bc|de|hl|af)(,.*) /x && $for_rabbit) {
		my($asm1, $asm2, $asm3) = ($1, $2, $3);
		add_3('rabbit', "$asm1 $asm2'$asm3",     "76 $bin");
		add_3('rabbit', "altd $asm1 $asm2$asm3", "76 $bin");
	}
	# rl de
	elsif ($asm =~ /^ (rl) \s+ (de) $/x && $for_rabbit) {
		my($asm1, $asm2) = ($1, $2);
		add_3('rabbit', "$asm1 $asm2'",     "76 $bin");
		add_3('rabbit', "altd $asm1 $asm2", "76 $bin");
	}
	# rr de|hl
	elsif ($asm =~ /^ (rr) \s+ (de|hl) $/x && $for_rabbit) {
		my($asm1, $asm2) = ($1, $2);
		add_3('rabbit', "$asm1 $asm2'",     "76 $bin");
		add_3('rabbit', "altd $asm1 $asm2", "76 $bin");
	}
	# arithm a,*
	elsif ($asm =~ /^ (add|adc|sub|sbc|and|xor|or|cp) \s+ (a) \s* , \s* (.*) /x) {
		my($asm1, $asm2, $asm3) = ($1, $2, $3);
		
		add_3($cpu_tag, "$asm1 $asm3", 				$bin);			# add r
		
		if ($for_rabbit) {
			add_3('rabbit', "altd $asm1 $asm3", 		"76 $bin");		# altd add r
			add_3('rabbit', "$asm1 $asm2',$asm3",   	"76 $bin");		# add a',r
			add_3('rabbit', "altd $asm1 $asm2,$asm3",	"76 $bin");		# altd add a,r
		}
	}
	# arithm hl,*
	elsif ($asm =~ /^ (add|adc|sbc) \s+ (hl) \s* , \s* (.*) /x) {
		my($asm1, $asm2, $asm3) = ($1, $2, $3);
		
		if ($for_rabbit) {
			add_3('rabbit', "$asm1 $asm2',$asm3",   	"76 $bin");		# add hl',r
			add_3('rabbit', "altd $asm1 $asm2,$asm3",	"76 $bin");		# altd add hl,r
		}
	}
	# tst a,*
	elsif ($asm =~ /^ (tst) \s+ (a) \s* , \s* (.*) /x) {
		my($asm1, $asm2, $asm3) = ($1, $2, $3);
		
		add_3($cpu_tag, "$asm1 $asm3", 				$bin);				# tst r
	}
	# inc|dec r
	elsif ($asm =~ /^ (inc|dec|pop) \s+ (b|c|d|e|h|l|a|f|bc|de|hl|af) $ /x
			&& $for_rabbit) {
		my($asm1, $asm2) = ($1, $2);
		add_3('rabbit', "$asm1 $asm2'",     "76 $bin");
		add_3('rabbit', "altd $asm1 $asm2", "76 $bin");
	}
	# cpl|neg a
	elsif ($asm =~ /^ (cpl|neg|ccf|scf) \s+ (a|f) $ /x) {
		my($asm1, $asm2) = ($1, $2);
		add_3($cpu_tag, $asm1, $bin);	# cpl
		
		add_3('rabbit', "$asm1 $asm2'",     "76 $bin");
		add_3('rabbit', "altd $asm1", 		"76 $bin");
		add_3('rabbit', "altd $asm1 $asm2", "76 $bin");
	}

	add_3($cpu_tag, $asm, $bin);
}

sub add_3 {
	my($cpu_tag, $asm, $bin) = @_;
	
	# expand (hl) to (ix), (ix+d) and iy
	if ($asm =~ / (.*) ( \( hl \) ) (.*) /x && $bin !~ /^(?:76 )?ED /) {
		my($asm1, $asm2, $asm3) = ($1, $2, $3);
		if ($asm =~ /^jp/) {
			add_4($cpu_tag, "$asm1(ix)$asm3", 		"DD $bin");
			add_4($cpu_tag, "$asm1(iy)$asm3", 		"FD $bin");
		}
		else {
			add_4($cpu_tag, "$asm1(ix+DIS)$asm3", 	encode_ixiy_bin($bin, "DD", "DIS"));
			add_4($cpu_tag, "$asm1(iy+DIS)$asm3", 	encode_ixiy_bin($bin, "FD", "DIS"));
		}
	}
	
	add_4($cpu_tag, $asm, $bin);
}

sub add_4 {
	my($cpu_tag, $asm, $bin) = @_;
	
	# expand hl to ix, iy
	if ($asm =~ / ( .* [^\(] ) ( hl ) (.*) /x 
		&& $bin !~ /^(?:76 )?ED /
		&& $asm !~ /^ex/
		&& $cpu_tag eq 'all') {
		my($asm1, $asm2, $asm3) = ($1, $2, $3);
		add_5($cpu_tag, replace($asm, "hl", "ix"),	"DD $bin");
		add_5($cpu_tag, replace($asm, "hl", "iy"),	"FD $bin");
	}
	elsif ($asm =~ / ^ rr \s+ hl $ /x) {
		add_5($cpu_tag, "rr ix", "DD $bin");
		add_5($cpu_tag, "rr iy", "FD $bin");
	}
	
	add_5($cpu_tag, $asm, $bin);
}

sub add_5 {
	my($cpu_tag, $asm, $bin) = @_;
	
	# replace +DIS with 0
	if ($asm =~ / ( .* ) ( \+ \s* DIS ) (.*) /x) {
		my($asm1, $asm2, $asm3) = ($1, $2, $3);
		(my $bin1 = $bin) =~ s/DIS/00/;
		add_6($cpu_tag, $asm1.$asm3, $bin1);
	}
	add_6($cpu_tag, $asm, $bin);
}

sub add_6 {
	my($cpu_tag, $asm, $bin) = @_;

	# check for CONST
	if ($asm =~ /(.*) CONST (.*)/x) {
		my($asm1, $asm2) = ($1, $2);
		my %bin = expand_bin_choose($bin);
		my $min = 0; my $max = 0;
		for my $value (sort {$a <=> $b} keys %bin) {
			my $bin1 = $bin{$value};

			add_7($cpu_tag, $asm1.$value.$asm2, $bin1);
			
			$min = $value if $min > $value;
			$max = $value if $max < $value;
		}
		
		# add tests for for limit check
		for my $cpu (@CPUS) {
			$Tests{$cpu}{err}{$asm1.($min-1).$asm2} = 1;
			$Tests{$cpu}{err}{$asm1.($max+1).$asm2} = 1;
		}
	}
	else {
		add_7($cpu_tag, $asm, $bin);
	}
}

sub add_7 {
	my($cpu_tag, $asm, $bin) = @_;

	# add ioe and ioi prefixes
	if ($cpu_tag eq 'all' && 
		$asm =~ / ^ (?: (?: ldd | lddr | ldi | ldir ) 
					|   ld \s+ a \s* , \s* \( NN \) 
					) $ /x) {
		add_8('rabbit', "ioi $asm", "D3 $bin");
		add_8('rabbit', "ioe $asm", "DB $bin");
	}
	add_8($cpu_tag, $asm, $bin);
}
	
sub add_8 {
	my($cpu_tag, $asm, $bin) = @_;

	add_final($cpu_tag, $asm, $bin);
}

sub add_final {
	my($cpu_tag, $asm, $bin) = @_;
	
	# compute bin
	while ($bin =~ s/ ( [0-9a-f]+ ) \* ( [0-9a-f]+ ) / sprintf("%02X", hex($1) * hex($2)) /xie) {}
	while ($bin =~ s/ ( [0-9a-f]+ ) \+ ( [0-9a-f]+ ) / sprintf("%02X", hex($1) + hex($2)) /xie) {}
	
	say sprintf("%-16s%-24s%s", $cpu_tag, $asm, $bin) if $ENV{DEBUG};

	# add opcode
	die $asm if $Opcodes{$asm};
	$Opcodes{$asm} = [ $cpu_tag, $bin ];
	
	# add test
	for my $cpu (@CPUS) {
		if (check_cpu_tag($cpu, $cpu_tag)) {
			add_test($cpu, $asm, $bin);
		}
		else {
			$Tests{$cpu}{err}{$asm} = 1;
		}
	}
}

sub encode_ixiy_bin {
	my($bin, $pfx, $dis) = @_;
	my @bin = split ' ', $bin;
	my @out;
	
	# remove prefixes
	if ($bin[0] eq '76') { 
		push @out, shift @bin;
	}
	
	push @out, $pfx;			# 1st byte
	push @out, shift @bin;		# 2nd byte
	push @out, $dis;			# 3rd byte
	push @out, @bin;			# remainder
	
	$bin = join ' ', @out;
	return $bin;
}

sub check_cpu_tag {
	my($cpu, $cpu_tag) = @_;
	return 1 unless $cpu_tag;
	for ($cpu_tag) {
		/^not_(.*)/ and return ! check_cpu_tag($cpu, $1);
		return 1 if /$cpu/;
		return 1 if /zilog/ && $cpu =~ /^z/;
		return 1 if /rabbit/ && $cpu =~ /^r/;
		return 1 if /all/;
	}
	return 0;
}

sub is_emulated {
	my($asm) = @_;
	return ($asm =~ / ^ (?: rrd | rld | cpi | cpir | cpd | cpdr ) $ /x);
}

sub expand_bin_choose {
	my($bin) = @_;
	my %bin;
	
	$bin =~ / (.*?) \b choose \( ( .*? ) \) (.*) /x or die $bin;
	my($bin1, $choices, $bin2) = ($1, $2, $3);
	for my $choice (split(' ', $choices)) {
		my($value, $result) = split(/:/, $choice);
		$result =~ s/,/ /;
		
		$bin{$value} and die $bin{$value};
		$bin{$value} = join(' ', split(' ', $bin1.$result.$bin2));
	}

	return %bin;
}

# add a test, replace N, NN, ... by numbers
sub add_test {
	my($cpu, $asm, $bin) = @_;

	if ($asm =~ / ^ (?: altd \s+ )? (?: djnz|jr ) .* NN /x) {
		add_test($cpu, replace($asm, qr/NN/,  "ASMPC"), replace($bin, qr/NNe/, "FE"));
	}
	elsif ($asm =~ / ^ call \s+ (nz|z|nc|c|po|pe|p|m) .* NN /x) {
		add_test('zilog', replace($asm, qr/NN/,  65535), replace($bin, qr/NNl NNh/, "FF FF"));
		add_test('zilog', replace($asm, qr/NN/,  32767), replace($bin, qr/NNl NNh/, "FF 7F"));
		add_test('zilog', replace($asm, qr/NN/, -32768), replace($bin, qr/NNl NNh/, "00 80"));
	}
	elsif ($asm =~ /NN/) {
		add_test($cpu, replace($asm, qr/NN/,  65535), replace($bin, qr/NNl NNh/, "FF FF"));
		add_test($cpu, replace($asm, qr/NN/,  32767), replace($bin, qr/NNl NNh/, "FF 7F"));
		add_test($cpu, replace($asm, qr/NN/, -32768), replace($bin, qr/NNl NNh/, "00 80"));
	}
	elsif ($asm =~ /N/) {
		add_test($cpu, replace($asm, qr/N/,  255), replace($bin, qr/N/, "FF"));
		add_test($cpu, replace($asm, qr/N/,  127), replace($bin, qr/N/, "7F"));
		add_test($cpu, replace($asm, qr/N/, -128), replace($bin, qr/N/, "80"));
	}
	elsif ($asm =~ /DIS/) {
		add_test($cpu, replace($asm, qr/\+DIS/, "+127"), replace($bin, qr/DIS/, "7F"));
		add_test($cpu, replace($asm, qr/\+DIS/, "-128"), replace($bin, qr/DIS/, "80"));
	}
	else {
		$Tests{$cpu}{ok}{$asm} = $bin;
	}
}

sub replace {
	my($text, $find, $replace) = @_;
	$text =~ s/$find/$replace/g;
	return $text;
}

# write ragel rules
sub write_ragel {
	my($file) = @_;
	
	open(my $fh, ">", $file) or die "$file: $!";
	for my $tokens (sort keys %Parser) {
		my $v = $Parser{$tokens};
		
		print $fh @{$v->{comments}};
		print $fh "| label? ".$tokens." _TK_NEWLINE \@{\n";
		print $fh @{$v->{code}};
		print $fh "}\n\n";
	}
}

# write test files
sub write_tests {
	my($test_file_base) = @_;
	for my $cpu (@CPUS) {
		for my $ixiy ('', '_ixiy') {
			for my $ok ('ok', 'err') {
				next if $ixiy && $ok eq 'err';
				my $file = $test_file_base."_".$cpu.$ixiy."_".$ok.".asm";
				open(my $fh, ">", $file) or die "$file: $!";
				for my $asm (sort keys %{$Tests{$cpu}{$ok}}) {
					my $bin = $Tests{$cpu}{$ok}{$asm};
					if ($ixiy) {
						(my $asm1 = $asm) =~ s/(ix|iy)/ $1 eq 'ix' ? 'iy' : 'ix' /ge;
						$bin = $Tests{$cpu}{$ok}{$asm1};
					}
					$bin = expand_cpu_query($bin, $cpu);
					$bin = 'Error' if $ok eq 'err';
					print $fh sprintf(" %-23s; %s\n", $asm, $bin)
				}
			}
		}
	}
}

# expand bin containing cpu?op,op:op,op
sub expand_cpu_query {
	my($bin, $cpu) = @_;
	
	if ($bin =~ / (.*?) \b (\w+) \s* \? (.*?) : (.*) /x) {
		my($bin1, $cpu_tag, $bin_true, $bin_false) = ($1, $2, $3, $4);

		if (check_cpu_tag($cpu, $cpu_tag)) {
			$bin = join(' ', split(' ', "$bin1 $bin_true"));
		}
		else {
			$bin = join(' ', split(' ', "$bin1 $bin_false"));
		}
	}
	
	return $bin;
}

# build %Parser from %Opcodes
sub build_parser {
	# sort by tokens
	for my $asm (sort keys %Opcodes) {
		my($cpu_tag, $bin) = @{$Opcodes{$asm}};
		my($tokens, $expr) = build_tokens($asm);
		
		$Parser{$tokens}{expr}{$expr} and die "Parser{$tokens}{$expr} exists";
		$Parser{$tokens}{expr}{$expr} = {asm => $asm, cpu_tag => $cpu_tag, bin => $bin};
		$Parser{$tokens}{comments} = [];
		$Parser{$tokens}{code} = [];
	}
	
	# build code
	for my $tokens (keys %Parser) {
		my $v = $Parser{$tokens}{expr};
		die $tokens unless %$v;
		
		my $v_nkeys = scalar(keys %$v);
		my @v_keys = keys %$v;
		
		# check cpu_tags of all alternatives
		my %cpu_tags;
		for (values %$v) {
			$cpu_tags{$_->{cpu_tag}} = 1;
		}
		
		# check for single cpu_tag
		my $cpu_tag;
		if (scalar(keys %cpu_tags) == 1) {
			$cpu_tag = (%cpu_tags)[0];
		}
		
		# add comments to rule
		my $is_emulated;
		for (sort {$a->{asm} cmp $b->{asm}} values %$v) {
			push @{$Parser{$tokens}{comments}}, 
				"/* ".($_->{asm})." */\n";
			$is_emulated++ if is_emulated($_->{asm});
		}
		
		# add cpu_tag checking code
		if (defined($cpu_tag) && $cpu_tag ne 'all' && !$is_emulated) {
			push @{$Parser{$tokens}{code}}, 
				"  if ((opts.cpu & (CPU_".uc($cpu_tag).")) == 0) {".
				" error_illegal_ident(); return FALSE; }\n";
		}
		
		# check for const_expr
		if ($v_nkeys && (grep {$_ ne '' && /^\d+$/} @v_keys) == $v_nkeys) {
			push @{$Parser{$tokens}{code}}, 
				"  if (expr_error) return FALSE;\n";
			
			my $if = "if";
			for my $value (sort {$a <=> $b} @v_keys) {
				my $v1 = $v->{$value};
				push @{$Parser{$tokens}{code}}, 
					"  $if (expr_value == $value) {\n";
				if (!defined($cpu_tag) && $v1->{cpu_tag} ne 'all') {
					push @{$Parser{$tokens}{code}}, 
						"    if ((opts.cpu & CPU_".uc($v1->{cpu_tag}).") == 0) {".
						" error_illegal_ident(); return FALSE; }\n";
				}
				push @{$Parser{$tokens}{code}}, 
					"    ".c_code($v1, 1)."\n".
					"  }\n";
				$if = "else if";
			}
			push @{$Parser{$tokens}{code}}, 
				"  else\n".
				"    error_int_range(expr_value);\n".
				"\n";
		}
		# check for (NN), (N), NN, N, ""
		elsif ($v_nkeys == 2 && $v->{'(NN)'} && ($v->{'N'} || $v->{'NN'})) {
			defined $cpu_tag or die $tokens;
			push @{$Parser{$tokens}{code}}, 
				"  if (expr_in_parens) {\n".
				"    ".c_code($v->{'(NN)'}, 1)."\n".
				"  }\n".
				"  else {\n".
				"    ".c_code($v->{'N'} || $v->{'NN'}, 1)."\n".
				"  }\n";
		}
		else {
			defined $cpu_tag or die $tokens;
			$v_nkeys == 1 || die $tokens;
			if ($v->{'(NN)'} || $v->{'(N)'}) {
				push @{$Parser{$tokens}{code}}, 
					"  if (!expr_in_parens) return FALSE;\n";
			}
			elsif ($v->{'NN'} || $v->{'N'}) {
				push @{$Parser{$tokens}{code}}, 
					"  if (expr_in_parens) warn_expr_in_parens();\n";
			}
			else {
			}
			my @kv = %$v;
			push @{$Parser{$tokens}{code}}, 
				"  ".c_code($kv[1])."\n";
		}
		delete $Parser{$tokens}{expr};
	}
}

sub c_code {
	my($v, $level) = @_; # IN: $v->{asm}, $v->{bin}
	my($asm, $bin) = ($v->{asm}, $v->{bin});
	$level ||= 0;

	# expand bin containing cpu?op,op:op,op
	if ($bin =~ / (.*?) \b (\w+) \s* \? (.*?) : (.*) /x) {
		my($bin1, $cpu_tag, $bin_true, $bin_false) = ($1, $2, $3, $4);
		
		return "if ((opts.cpu & CPU_".uc($cpu_tag).") != 0) {\n".
			   "    ".c_code_1($asm, "$bin1 $bin_true", $level+1)."\n".
			   "  }\n".
			   "  else {\n".
			   "    ".c_code_1($asm, "$bin1 $bin_false", $level+1)."\n".
			   "  }";
	}
	else {
		return c_code_1($asm, $bin, $level);
	}
}

sub c_code_1 {
	my($asm, $bin, $level) = @_;
	my $indent = "  " x (++$level);

	my $ixiy_bin = ixiy_bin($asm);
	if ($ixiy_bin) {
		return "if (!opts.swap_ix_iy) {\n".
			   "    ".c_code_2($asm, $bin, $level+1)."\n".
			   "  }\n".
			   "  else {\n".
			   "    ".c_code_2($asm, $ixiy_bin, $level+1)."\n".
			   "  }";
	}
	else {
		return c_code_2($asm, $bin, $level);
	}
}

sub c_code_2 {
	my($asm, $bin, $level) = @_;
	my $indent = "  " x (++$level);
	my $ret = '';
	
	# check for altd prefix
	if ($bin =~ s/^76 //) { 
		$ret .= "DO_stmt(0x76);\n".$indent;
	}

	# which DO_stmt_xxx?
	my($stmt, $extra_arg) = ("", "");
	if (is_emulated($asm)) {
		$stmt = "DO_stmt_emul";
		$extra_arg = ", rcmx_".$asm;
	}
	elsif ($bin =~ s/ DIS N$//) {
		$stmt = "DO_stmt_idx_n";
	}
	elsif ($bin =~ s/ N$//) {
		$stmt = "DO_stmt_n";
	}
	elsif ($asm =~ / ^ call \s+ (nz|z|nc|c|po|pe|p|m) /x) {
		return "DO_stmt_call_flag(".uc($1)."); ";
	}
	elsif ($bin =~ s/ NNl NNh$//) {
		$stmt = "DO_stmt_nn";
	}
	elsif ($bin =~ s/ NNe$//) {
		$stmt = "DO_stmt_jr";
	}
	elsif ($bin =~ s/ DIS//) {
		$stmt = "DO_stmt_idx";
	}
	else {
		$stmt = "DO_stmt";
	}
	$stmt or die $bin;

	# build statement
	my @hex;
	for (split(' ', $bin)) {
		push @hex, sprintf("%02X", hex( eval { $_ } ));
		die $bin if $@;
	}
	@hex > 0 && @hex <= 4 or die $bin;
	
	$ret .= $stmt."(0x".join("", @hex).$extra_arg."); ";
	
	return $ret;
}

sub ixiy_bin {
	my($asm) = @_;
	if ($asm =~ /ix|iy/) {
		(my $asm1 = $asm) =~ s/(ix|iy)/ $1 eq 'ix' ? 'iy' : 'ix' /ge;
		my($cpu_tag1, $bin1) = @{$Opcodes{$asm1}};
		return $bin1;
	}
	else {
		return;
	}
}

sub build_tokens {
	my($asm) = @_;
	my $expr = '';
	for ($asm) {
		s/ ( \( NN \) ) / expr /x and $expr = $1;
		s/ ( \( N  \) ) / expr /x and $expr = $1;
		s/ (    NN    ) / expr /x and $expr = $1;
		s/ (    N     ) / expr /x and $expr = $1;
		s/ \b (\d+) \b  / const_expr /x and $expr = $1;

		s/      DIS     / expr       /x;

		s/,/ COMMA /g;
		s/'/1/g;
		s/ \( (hl|ix|iy|bc|de|sp|c) \+? / IND_$1 /x;
		s/ \)                           / RPAREN /x;
	}
	my @tokens = split(' ', $asm);
	for (@tokens) {
		if (/^ (?: expr | const_expr ) $/x) {
		}
		else {
			$_ = "_TK_".uc($_);
		}
	}
	my $tokens = join(' ', @tokens);
	return ($tokens, $expr);
}

if ($ENV{DEBUG}) {
	use Data::Dump 'dump';

	say "";
	say "Opcodes:";
	say dump \%Opcodes;
	
	say "";
	say "Parser:";
	say dump \%Parser;
	
	say "";
	say "Tests:";
	say dump \%Tests;
}
