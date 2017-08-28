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
	# continuation lines
	while (s/ \\ \s* $/ /x) {
		$_ .= <$fh>;
	}

	# delete blanks
	s/^\s+//; s/\s+$//; s/\s+/ /g;
	last if /^ __END__ /x;
	next if /^ ; /x;
	next unless /\S/;
	
	# check for cpu tag
	my $cpu_tag = 'all';
	if (/^ \s* \[ \s* (\w+) \s* \] \s* (.*)/x) {
		($cpu_tag, $_) = ($1, $2);
	}
	my($asm, $bin) = split(/\s*=>\s*/, $_, 2);
	$asm =~ s/\s*,\s*/,/g;
	
	add($cpu_tag, $asm, $bin);
}

build_parser();

(my $ragel_file = $0) =~ s/\.pl$/_rules_old.h/;
write_ragel($ragel_file);

# (my $test_file_base = $0) =~ s/\.pl$/_testold/;
# write_tests($test_file_base);

# expand and recurse, call add_final at the end
sub add {
	my($cpu_tag, $asm, $bin) = @_;

	# expand <b.c.<ix.iy>..>, <expr>
	my $count = 1;
	if ($asm =~ s/\{/ '{'.($count++).':' /ge) {
		# number sub-expressions and expand
		add_expand_list($cpu_tag, $asm, $bin);
	}
	else {
		add_ixh($cpu_tag, $asm, $bin);
	}
}

# expand <...> lists
sub add_expand_list {
	my($cpu_tag, $asm, $bin) = @_;
	
	if ($asm =~ / (.*?) \{ (\d+) : ([^{}]*) \} (.*) /x) {
		my($asm1, $level, $list, $asm2) = ($1, $2, $3, $4);
		my @list = split(/\s*\|\s*/, $list);
		@list = map { [ $_, $list[$_] ] } (0..$#list);
		for (@list) {
			my($i, $v) = @$_;
			next if $v eq '';
			add_expand_list($cpu_tag, "$asm1$v$asm2", replace($bin, qr/\$$level/, $i));
		}
	}
	else {
		add_ixh($cpu_tag, $asm, $bin);
	}
}

# expand ixh, ixl, iyh, iyl
sub add_ixh {
	my($cpu_tag, $asm, $bin) = @_;
	
	if ($asm =~ / \b [hl] \b /x && $asm !~ /hl|ix|iy/ && $bin !~ /^(?:ED|CB) /) {
		for ([ix => 'DD'], [iy => 'FD']) {
			my($r, $b) = @$_;
			(my $asm1 = $asm) =~ s/ \b ([hl]) \b /$r$1/gx;
			add_ix('z80', $asm1, "$b $bin");
		}	
	}
	add_ix($cpu_tag, $asm, $bin);
}

# expand hl to ix, iy
sub add_ix {
	my($cpu_tag, $asm, $bin) = @_;

	if ($asm =~ / ( .* [^\(] ) ( hl ) (.*) /x 
		&& $bin !~ /^ED /
		&& $asm !~ /^ex/
		&& $cpu_tag eq 'all'
		) {
		my($asm1, $asm2, $asm3) = ($1, $2, $3);
		add_ind_ix($cpu_tag, replace($asm, "hl", "ix"),	"DD $bin");
		add_ind_ix($cpu_tag, replace($asm, "hl", "iy"),	"FD $bin");
	}
	elsif ($asm =~ / ^ (?:ALTD \s+)? (rr|and|or|bool) \s+ hl \s* (,.*|) $/x) {
		my($op, $rest) = ($1, $2);
		add_ind_ix($cpu_tag, "$op ix$rest", "DD $bin");
		add_ind_ix($cpu_tag, "$op iy$rest", "FD $bin");
	}
	
	add_ind_ix($cpu_tag, $asm, $bin);
}

# expand (hl) to (ix), (ix+d) and iy
sub add_ind_ix {
	my($cpu_tag, $asm, $bin) = @_;

	if ($asm =~ / (.*) ( \( hl \) ) (.*) /x && $bin !~ /^ED /) {
		my($asm1, $asm2, $asm3) = ($1, $2, $3);
		if ($asm =~ /^jp/) {
			add_alu8($cpu_tag, "$asm1(ix)$asm3", 		"DD $bin");
			add_alu8($cpu_tag, "$asm1(iy)$asm3", 		"FD $bin");
		}
		else {
			add_alu8($cpu_tag, "$asm1(ix+DIS)$asm3", 	encode_ixiy_bin($bin, "DD", "DIS"));
			add_alu8($cpu_tag, "$asm1(iy+DIS)$asm3", 	encode_ixiy_bin($bin, "FD", "DIS"));
		}
	}
	
	add_alu8($cpu_tag, $asm, $bin);
}

# expand alu with without "a,"
sub add_alu8 {
	my($cpu_tag, $asm, $bin) = @_;

	if ($asm =~ /^ (add|adc|sub|sbc|and|xor|or|cp|tst|test) \s+ (a) \s* , \s* (.*) /x) {
		my($opcode, $a, $rest) = ($1, $2, $3);
		
		add_altd($cpu_tag, "$opcode $rest", 			    $bin);			# add r
		
		if ($opcode eq 'tst' || $opcode eq 'test' ) {		# only Z180
			add_altd($cpu_tag, "$opcode $a,$rest",	 	   $bin);			# add a,r
		}
		else {		
			if ($rest !~ /\bi[xy][hl]\b/) {
				add_altd('rabbit', "altd $opcode $rest","76 $bin");			# altd add r
			}
			add_altd($cpu_tag, "ALTD $opcode $a,$rest",	    $bin);			# add a,r : altd add a,r : add a',r
		}
	}
	elsif ($asm =~ /^ (cpl|neg|ccf|scf) \s+ (a|f) $ /x) {
		my($opcode, $reg) = ($1, $2);
		
		add_altd($cpu_tag, $opcode, $bin);						# cpl
		add_altd('rabbit', "altd $opcode", "76 $bin");			# altd cpl
		add_altd($cpu_tag, "ALTD $opcode $reg", $bin);			# cpl a : altd cpl a : cpl a'
	}
	else {
		add_altd($cpu_tag, $asm, $bin);
	}
}

# expand ALTD
sub add_altd {
	my($cpu_tag, $asm, $bin) = @_;

	if ($asm !~ / \b (?: i[xy][hl] | i | r ) \b /x) {
		if ($asm =~ /^ ALTD \s+ (\w+ \s+ (?: CONST \s* ,)? \s*)			# opcode with optional bit number
					   (b|c|d|e|h|l|a|f|bc|de|hl|af) \b (.*) $/x) {
			my($opcode, $reg, $rest) = ($1, $2, $3);
			add_io('rabbit', "$opcode$reg'$rest", "76 $bin");
			add_io('rabbit', "altd $opcode$reg$rest", "76 $bin");
		}
	}
	$asm =~ s/^ALTD\s+//;
	add_io($cpu_tag, $asm, $bin);
}

# expand IO
sub add_io {
	my($cpu_tag, $asm, $bin) = @_;

	if ($asm =~ /^ IO \s+ (.*) $/x) {
		my($opcode) = ($1);
		add_offset('rabbit', "ioi $opcode", "D3 $bin");
		add_offset('rabbit', "ioe $opcode", "DB $bin");
	}
	$asm =~ s/^IO\s+//;
	add_offset($cpu_tag, $asm, $bin);
}

# replace +DIS or +N with 0
sub add_offset {
	my($cpu_tag, $asm, $bin) = @_;
	
	if ($asm =~ / ( .* ) ( \+ \s* (DIS|N) ) (.*) /x) {
		my($asm1, $asm2, $offset, $asm3) = ($1, $2, $3, $4);
		(my $bin1 = $bin) =~ s/\b $offset \b/00/x;
		add_const($cpu_tag, $asm1.$asm3, $bin1);
	}
	add_const($cpu_tag, $asm, $bin);
}

# check for CONST
sub add_const {
	my($cpu_tag, $asm, $bin) = @_;

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

# add ioe and ioi prefixes
sub add_7 {
	my($cpu_tag, $asm, $bin) = @_;

	if ($cpu_tag eq 'all' && 
		$asm =~ / ^    ld \s+ a \s* , \s* \( NN \) 
					 $ /x) {
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

	# add opcode if not same already
	if ($Opcodes{$asm}) {
		die "($cpu_tag, $asm, $bin)" if $Opcodes{$asm}[0] ne $cpu_tag;
		die "($cpu_tag, $asm, $bin)" if $Opcodes{$asm}[1] ne $bin;
		return;
	}
	
	say sprintf("%-16s%-24s%s", $cpu_tag, $asm, $bin) if $ENV{DEBUG};
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
	elsif ($asm =~ /\b NN \b/x) {
		add_test($cpu, replace($asm, qr/NN/,  65535), replace($bin, qr/NNl NNh/, "FF FF"));
		add_test($cpu, replace($asm, qr/NN/,  32767), replace($bin, qr/NNl NNh/, "FF 7F"));
		add_test($cpu, replace($asm, qr/NN/, -32768), replace($bin, qr/NNl NNh/, "00 80"));
	}
	elsif ($asm =~ /\b N \b/x) {
		add_test($cpu, replace($asm, qr/N/,  255), replace($bin, qr/N/, "FF"));
		add_test($cpu, replace($asm, qr/N/,  127), replace($bin, qr/N/, "7F"));
		add_test($cpu, replace($asm, qr/N/, -128), replace($bin, qr/N/, "80"));
	}
	elsif ($asm =~ /\+DIS \b/x) {
		add_test($cpu, replace($asm, qr/\+DIS/, "+127"), replace($bin, qr/DIS/, "7F"));
		add_test($cpu, replace($asm, qr/\+DIS/, "-128"), replace($bin, qr/DIS/, "80"));
	}
	elsif ($asm =~ /\b SN \b/x) {
		add_test($cpu, replace($asm, qr/SN/,  "127"), replace($bin, qr/SN/, "7F"));
		add_test($cpu, replace($asm, qr/SN/, "-128"), replace($bin, qr/SN/, "80"));
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
	
	open(my $fh, ">:raw", $file) or die "$file: $!";
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
				open(my $fh, ">:raw", $file) or die "$file: $!";
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
	elsif ($bin =~ s/ SN$//) {
		$stmt = "DO_stmt_d";
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
		s/ (    SN    ) / expr /x and $expr = $1;
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


#------------------------------------------------------------------------------
# New programatic opcode generator
# asm placeholders:
#	%s	signed byte
#	%n	unsigned byte
#	%m	unsigned word
#	%j	jr offset
#	%c	constant (im, bit, rst, ...)
#	%d	signed register indirect offset
#	%u	unsigned register indirect offset
#	@label	unsigned word with given global label address
#------------------------------------------------------------------------------
@CPUS = qw( z80 z80_zxn z180 r2k r3k );

my @R8	= qw( b c d e h l (hl) a );
my @R16SP = qw( bc de hl sp );
my @R16AF = qw( bc de hl af );
my @ALU = qw( add adc sub sbc and xor or cp );
my @TEST= qw( tst test );
my @ROTA= qw( rlca rrca rla rra );
my @ROT = qw( rlc rrc rl rr sla sra sll sli srl );
my @BIT = qw( bit res set );

my @X	= qw( ix iy );
my @DIS	= ('0', '%d');
my @IO	= ('', qw( ioi ioe ));
my @ALTD= ('', qw( altd ));
my @A_  = ('a, ', '');

my %V = (
	'' => '',
	b => 0, c => 1, d => 2, e => 3, h => 4, l => 5, '(hl)' => 6, a => 7,
	bc => 0, de => 1, hl => 2, sp => 3, af => 3,
	add => 0, adc => 1, sub => 2, sbc => 3, and => 4, xor => 5, or => 6, cp => 7,
	rlca => 0, rrca => 1, rla => 2, rra => 3,
	rlc => 0, rrc => 1, rl => 2, rr => 3, sla => 4, sra => 5, sll => 6, sli => 6, srl => 7, 
	bit => 1, res => 2, set => 3,
	ix => 0xDD, iy => 0xFD, 
	altd => 0x76, ioi => 0xD3, ioe => 0xDB,
);

#------------------------------------------------------------------------------
# build %Opcodes
#------------------------------------------------------------------------------
%Opcodes = ();
for my $cpu (@CPUS) {
	my $rabbit	= ($cpu =~ /^r/);
	my $r3k		= ($cpu =~ /^r3k/);
	my $z80 	= ($cpu =~ /^z80/);
	my $z80_zxn	= ($cpu =~ /^z80_zxn/);
	my $z180 	= ($cpu =~ /^z180/);
	my $zilog	= ($cpu =~ /^z/);
	
	# 8-bit load group
	for my $r (@R8) { 
		for my $s (@R8) {
			my $op = 0x40 + $V{$r}*8 + $V{$s};
			add_opc($cpu, "ld $r, $s", $op);
		}
		add_opc($cpu, "ld $r, %n", 0x06 + $V{$r}*8, '%n');
	}
	add_opc($cpu, "ld a, (%m)", 0x3A, '%m', '%m');
	add_opc($cpu, "ld (%m), a", 0x32, '%m', '%m');
	add_opc($cpu, "ld (bc), a", 0x02);
	add_opc($cpu, "ld a, (bc)", 0x0A);
	add_opc($cpu, "ld (de), a", 0x12);
	add_opc($cpu, "ld a, (de)", 0x1A);

	# 8-bit ALU group
	for my $op (@ALU) {
		for my $r (@R8) {
			for my $a (@A_) {
				add_opc($cpu, "$op $a$r", 0x80 + $V{$op}*8 + $V{$r});
			}
		}
		for my $a (@A_) {
			add_opc($cpu, "$op $a%n", 0xC6 + $V{$op}*8, '%n');
		}
	}
	for my $r (@R8) { 
		add_opc($cpu, "inc $r", 0x04 + $V{$r}*8);
		add_opc($cpu, "dec $r", 0x05 + $V{$r}*8);
		
		for my $op (@TEST) {
			for my $a (@A_) {
				if ($z180) {
					add_opc($cpu, "$op $a$r",  0xED, 0x04 + $V{$r}*8);
					add_opc($cpu, "$op $a%n",  0xED, 0x64, '%n');
				}
				elsif ($z80_zxn) {
					add_opc($cpu, "$op $a%n",  0xED, 0x27, '%n');
				}
			}
		}
	}
	
	if ($zilog) {
		add_opc($cpu, "daa", 0x27);			# TODO: daa as library call
		add_opc($cpu, "rrd", 0xED, 0x67);
		add_opc($cpu, "rld", 0xED, 0x6F);
	}
	elsif ($rabbit) {
		add_opc($cpu, "rrd", 0xCD, '@__z80asm__rrd');
		add_opc($cpu, "rld", 0xCD, '@__z80asm__rld');
	}
	
	add_opc($cpu, "cpl", 		0x2F);
	add_opc($cpu, "cpl a", 		0x2F);
	add_opc($cpu, "cpl a'", 	$V{altd}, 0x2F) if $rabbit;
	add_opc($cpu, "altd cpl",	$V{altd}, 0x2F) if $rabbit;
	add_opc($cpu, "altd cpl a",	$V{altd}, 0x2F) if $rabbit;
	
	add_opc($cpu, "neg", 		0xED, 0x44);
	add_opc($cpu, "neg a", 		0xED, 0x44);
	add_opc($cpu, "neg a'", 	$V{altd}, 0xED, 0x44) if $rabbit;
	add_opc($cpu, "altd neg",	$V{altd}, 0xED, 0x44) if $rabbit;
	add_opc($cpu, "altd neg a",	$V{altd}, 0xED, 0x44) if $rabbit;
	
	add_opc($cpu, "ccf", 		0x3F);
	add_opc($cpu, "ccf f", 		0x3F);
	add_opc($cpu, "ccf f'", 	$V{altd}, 0x3F) if $rabbit;
	add_opc($cpu, "altd ccf",	$V{altd}, 0x3F) if $rabbit;
	add_opc($cpu, "altd ccf f",	$V{altd}, 0x3F) if $rabbit;
	
	add_opc($cpu, "scf", 		0x37);
	add_opc($cpu, "scf f", 		0x37);
	add_opc($cpu, "scf f'", 	$V{altd}, 0x37) if $rabbit;
	add_opc($cpu, "altd scf",	$V{altd}, 0x37) if $rabbit;
	add_opc($cpu, "altd scf f",	$V{altd}, 0x37) if $rabbit;
	
	# 16-bit load group
	for my $r (@R16SP) {
		add_opc($cpu, "ld $r, %m", 0x01 + $V{$r}*16, '%m', '%m');
		if ($r eq 'hl') {
			add_opc($cpu, "ld $r, (%m)", 0x2A, '%m', '%m');
			add_opc($cpu, "ld (%m), $r", 0x22, '%m', '%m');
			
			for my $x (@X) {
				add_opc($cpu, "ld $x, %m", $V{$x}, 0x01 + $V{$r}*16, '%m', '%m');
				add_opc($cpu, "ld $x, (%m)", $V{$x}, 0x2A, '%m', '%m');
				add_opc($cpu, "ld (%m), $x", $V{$x}, 0x22, '%m', '%m');
			}
		}
		else {
			add_opc($cpu, "ld $r, (%m)", 0xED, 0x4B + $V{$r}*16, '%m', '%m');
			add_opc($cpu, "ld (%m), $r", 0xED, 0x43 + $V{$r}*16, '%m', '%m');
		}
	}
	
	add_opc($cpu, "ld sp, hl", 0xF9);
	for my $x (@X) {
		add_opc($cpu, "ld sp, $x", $V{$x}, 0xF9);
	}
	
	for my $r (@R16AF) {
		add_opc($cpu, "push $r", 0xC5 + $V{$r}*16);
		add_opc($cpu, "pop $r", 0xC1 + $V{$r}*16);
		
		if ($r eq 'hl') {
			for my $x (@X) {
				add_opc($cpu, "push $x", $V{$x}, 0xC5 + $V{$r}*16);
				add_opc($cpu, "pop $x", $V{$x}, 0xC1 + $V{$r}*16);
			}
		}
	}
	
	if ($rabbit) {
		add_opc($cpu, "push ip", 0xED, 0x76);
		add_opc($cpu, "pop ip", 0xED, 0x7E);
	}
	
	if ($r3k) {
		add_opc($cpu, "push su", 0xED, 0x66) if $r3k;
		add_opc($cpu, "pop su", 0xED, 0x6E) if $r3k;
	}
	
	if ($rabbit) {
		for my $x (@X) {
			add_opc($cpu, "ld hl, $x", $V{$x}, 0x7C);
			add_opc($cpu, "ld $x, hl", $V{$x}, 0x7D);
		}
		
		for ([hl => 0xDD], [ix => ()], [iy => 0xFD]) {
			my($r, @pfx) = @$_;
		
			add_opc($cpu, "ld hl, ($r+%d)", @pfx, 0xE4, '%d');
			add_opc($cpu, "ld ($r+%d), hl", @pfx, 0xF4, '%d');
		}
			
		for ([hl => ()], [ix => 0xDD], [iy => 0xFD]) {
			my($r, @pfx) = @$_;
		
			add_opc($cpu, "ld (sp+%u), $r", @pfx, 0xD4, '%u');
			add_opc($cpu, "ld $r, (sp+%u)", @pfx, 0xC4, '%u');
		}
		
		for my $r (qw(bc de hl)) {
			for my $s (qw(bc de)) {
				add_opc($cpu, "ld $r', $s", 	0xED, 0x41 + $V{$r}*16 + (1-$V{$s})*8);
				add_opc($cpu, "altd ld $r, $s", 0xED, 0x41 + $V{$r}*16 + (1-$V{$s})*8);
			}
		}
		
		for ([hl => 0xED], [ix => 0xDD], [iy => 0xFD]) {
			my($r, $pfx) = @$_;
			
			add_opc($cpu, "ldp (%m), $r", $pfx, 0x65, '%m', '%m');
			add_opc($cpu, "ldp $r, (%m)", $pfx, 0x6D, '%m', '%m');
			add_opc($cpu, "ldp ($r), hl", $pfx, 0x64);
			add_opc($cpu, "ldp hl, ($r)", $pfx, 0x6C);
		}
	}
	
	# exchange group
	add_opc($cpu, "ex af, af'", 0x08);
	add_opc($cpu, "ex af, af",  0x08);
	
	add_opc($cpu, "exx",  0xD9);
	
	if ($zilog) {
		add_opc($cpu, "ex (sp), hl", 0xE3);
	}
	elsif ($rabbit) {
		add_opc($cpu, "ex (sp), hl", 0xED, 0x54);
		add_opc($cpu, "ex (sp), hl'", $V{altd}, 0xED, 0x54);
		add_opc($cpu, "altd ex (sp), hl", $V{altd}, 0xED, 0x54);
	}
	else {}
	
	for my $x (@X) {
		add_opc($cpu, "ex (sp), $x", $V{$x}, 0xE3);
	}
	
	add_opc($cpu, "ex de, hl", 0xEB);
	if ($rabbit) {
		add_opc($cpu, "ex de', hl", 0xE3);
		add_opc($cpu, "ex de, hl'", 0x76, 0xEB);
		add_opc($cpu, "ex de', hl'", 0x76, 0xE3);
		
		add_opc($cpu, "altd ex de, hl", 0x76, 0xEB);
		add_opc($cpu, "altd ex de', hl", 0x76, 0xE3);
	}
	
	# 16-bit ALU group
	for my $r (@R16SP) {
		add_opc($cpu, "add hl, $r", 0x09 + $V{$r}*16);
		add_opc($cpu, "sbc hl, $r", 0xED, 0x42 + $V{$r}*16);
		add_opc($cpu, "adc hl, $r", 0xED, 0x4A + $V{$r}*16);
		
		add_opc($cpu, "inc $r", 0x03 + $V{$r}*16);
		add_opc($cpu, "dec $r", 0x0B + $V{$r}*16);
	}
	
	for my $x (@X) {
		for my $r (@R16SP) {
			add_opc($cpu, "add $x, ".replace($r, qr/hl/, $x), $V{$x}, 0x09 + $V{$r}*16);
		}
		add_opc($cpu, "inc $x", $V{$x}, 0x03 + 2*16);
		add_opc($cpu, "dec $x", $V{$x}, 0x0B + 2*16);
	}
	
	if ($rabbit) {
		add_opc($cpu, "add sp, %s", 0x27, '%s');
		
		for ([hl => ()], [ix => 0xDD], [iy => 0xFD]) {
			my($r, @pfx) = @$_;
			
			add_opc($cpu, "and $r, de", @pfx, 0xDC);
			add_opc($cpu, "or $r, de", @pfx, 0xEC);
			add_opc($cpu, "bool $r", @pfx, 0xCC);
		}
	}
	
	for my $r (@R16SP) {
		if ($r eq 'sp') {
			add_opc($cpu, "mlt $r", 0xED, 0x4C + $V{$r}*16) if $z180;
		}
		else {
			add_opc($cpu, "mlt $r", 0xED, 0x4C + $V{$r}*16) if !$z80;
		}
	}
	
	if ($z80_zxn) {
		add_opc($cpu, "mul", 0xED, 0x30);
	}
	elsif ($rabbit) {
		add_opc($cpu, "mul", 0xF7);
	}
	else {}
	
	if ($r3k) {
		add_opc($cpu, "uma", 0xED, 0xC0);
		add_opc($cpu, "ums", 0xED, 0xC8);
	}
	
	# 8-bit rotate and shift group
	for my $op (@ROTA) {
		add_opc($cpu, $op, 0x07 + $V{$op}*8);
	}
	
	for my $op (@ROT) {
		next if $op =~ /sll|sli/ && !$zilog;
		for my $r (@R8) {
			add_opc($cpu, "$op $r", 0xCB, $V{$op}*8 + $V{$r});
		}
	}
	
	if ($z80) {
		for my $op (@ROT) {
			for my $x (@X) {
				for my $r (@R8) {
					next if $r eq '(hl)';
					add_opc($cpu, "$op ($x+%d), $r", $V{$x}, 0xCB, '%d', $V{$op}*8 + $V{$r});
				}
			}
		}			
	}
	
	# bit set, reset and test group
	for my $op (@BIT) {
		for my $r (@R8) {
			add_opc($cpu, "$op %c, $r", 0xCB, ($V{$op}*0x40 + $V{$r})."+8*%c(0..7)");
		}
	}
	
	# 16-bit rotate and shift group
	if ($rabbit) {
		add_opc($cpu, "rl de", 0xF3);
		add_opc($cpu, "rr de", 0xFB);
		for ([hl => ()], [ix => 0xDD], [iy => 0xFD]) {
			my($x, @pfx) = @$_;
			add_opc($cpu, "rr $x", @pfx, 0xFC);
		}
	}
	
	# CPU control group
	add_opc($cpu, "nop", 0x00);
	add_opc($cpu, "halt", 0x76) if $zilog;
	add_opc($cpu, "slp", 0xED, 0x76) if $z180;
	
	if ($r3k) {
		add_opc($cpu, "rdmode", 0xED, 0x7F);
		add_opc($cpu, "setusr", 0xED, 0x6F);
		add_opc($cpu, "sures", 0xED, 0x7D);
		add_opc($cpu, "syscall", 0xED, 0x75);
	}
	
	# Interrupt control group
	if ($zilog) {
		add_opc($cpu, "di", 0xF3);
		add_opc($cpu, "ei", 0xFB);

		add_opc($cpu, "im %c", 0xED, "%c(0..2)==0?0x46:%c==1?0x56:0x5E");

		add_opc($cpu, "ld i, a", 0xED, 0x47);
		add_opc($cpu, "ld a, i", 0xED, 0x57);
		add_opc($cpu, "ld r, a", 0xED, 0x4F);
		add_opc($cpu, "ld a, r", 0xED, 0x5F);
	}
	
	if ($rabbit) {
		add_opc($cpu, "ld eir, a", 0xED, 0x47);
		add_opc($cpu, "ld a, eir", 0xED, 0x57);
		add_opc($cpu, "ld iir, a", 0xED, 0x4F);
		add_opc($cpu, "ld a, iir", 0xED, 0x5F);
	
		add_opc($cpu, "ipset %c", 0xED, "%c(0..3)==0?0x46:%c==1?0x56:%c==2?0x4E:0x5E");
		add_opc($cpu, "ipres", 0xED, 0x5D);
	}

	add_opc($cpu, "reti", 0xED, 0x4D);
	add_opc($cpu, "retn", 0xED, 0x45) if $zilog;
	add_opc($cpu, "idet", 0x5B) if $r3k;
}

#------------------------------------------------------------------------------
# build %Parser
#------------------------------------------------------------------------------
%Parser = ();

for my $asm (sort keys %Opcodes) {
	my $tokens = parser_tokens($asm);
	
	# asm for swap_ix_iy
	(my $asm_swap = $asm) =~ s/(ix|iy)/ $1 eq 'ix' ? 'iy' : 'ix' /ge;
	
	# check for parens
	my $parens;
	if    ($asm =~ /\(%[nm]\)/) {		$parens = 'expr_in_parens'; }
	elsif ($asm =~ /%[snmjc]/) {		$parens = 'expr_no_parens'; }
	else {								$parens = 'no_expr';   }
		
	for my $cpu (sort keys %{$Opcodes{$asm}}) {
		my @bin = @{$Opcodes{$asm}{$cpu}};
		my @bin_swap = @{$Opcodes{$asm_swap}{$cpu}};
		
		$Parser{$tokens}{$cpu}{$parens}{ixiy} = [$asm, @bin];
		$Parser{$tokens}{$cpu}{$parens}{iyix} = [$asm_swap, @bin_swap];
	}
}

open(my $rules, ">:raw", "dev/cpu/cpu_rules.h") or die $!;
for my $tokens (sort keys %Parser) {
	print $rules $tokens, ' @{', "\n";
	print $rules merge_cpu($Parser{$tokens});
	print $rules '}', "\n\n";
}

#------------------------------------------------------------------------------
# build %Tests
#------------------------------------------------------------------------------
%Tests = ();

for my $asm (sort keys %Opcodes) {
	for my $cpu (sort keys %{$Opcodes{$asm}}) {
		my $bin = join(' ', @{$Opcodes{$asm}{$cpu}});
		
		add_tests($cpu, $asm, $bin);
	}
}

# open tests files
my %fh;
for my $cpu (@CPUS) {
	for my $ixiy ('', '_ixiy') {
		for my $ok ('ok', 'err') {
			next if $ixiy && $ok eq 'err';
			
			my $filename = "dev/cpu/cpu_test_${cpu}${ixiy}_${ok}.asm";
			open($fh{$cpu}{$ixiy}{$ok}, ">:raw", $filename ) or die "$filename: $!";
		}
	}
}

for my $asm (sort keys %Tests) {
	my $asmf = sprintf(" %-31s", $asm);
	for my $cpu (@CPUS) {
		if (exists $Tests{$asm}{$cpu}) {
			for my $ixiy ('', '_ixiy') {
				my $asm1 = $asm;
				if ($ixiy) {
					$asm1 =~ s/(ix|iy)/ $1 eq 'ix' ? 'iy' : 'ix' /ge;
				}
				my $bin1 = $Tests{$asm1}{$cpu};
				my @bin = split(' ', $bin1);
			
				$fh{$cpu}{$ixiy}{ok}->print($asmf."; ".fmthex(@bin)."\n");
			}
		}
		else {
			$fh{$cpu}{''}{err}->print($asmf."; Error\n");
		}
	}
	if (exists $Tests{$asm}{''}) {
		for my $cpu (@CPUS) {
			$fh{$cpu}{''}{err}->print($asmf."; Error\n");
		}
	}
}


#------------------------------------------------------------------------------
# Opcodes
#------------------------------------------------------------------------------
sub add_opc {
	my($cpu, $asm, @bin) = @_;

	# filter invalid opcodes
	return if $asm eq 'ld (hl), (hl)';
	
	add_opc_1($cpu, $asm, @bin);
	
	# expand ixh, ixl, ...
	if ($cpu =~ /^z80/ && $asm =~ /\b[hl]\b/ && $asm !~ /hl|ix|iy/) {
		(my $asm1 = $asm) =~ s/\b([hl])\b/ix$1/g;
		add_opc_1($cpu, $asm1, $V{ix}, @bin);
		(   $asm1 = $asm) =~ s/\b([hl])\b/iy$1/g;
		add_opc_1($cpu, $asm1, $V{iy}, @bin);
	}
}

sub add_opc_1 {
	my($cpu, $asm, @bin) = @_;

	add_opc_2($cpu, $asm, @bin);
	
	# expand (ix+%d)
	return if $asm =~ /^ldp/;
	
	if ($asm =~ /\(hl\)/) {
		(my $asm1 = $asm) =~ s/\(hl\)/(ix+%d)/g;
		add_opc_2($cpu, $asm1, $V{ix}, $bin[0], '%d', @bin[1..$#bin]);
		(   $asm1 = $asm) =~ s/\(hl\)/(iy+%d)/g;
		add_opc_2($cpu, $asm1, $V{iy}, $bin[0], '%d', @bin[1..$#bin]);
	}
}

sub add_opc_2 {
	my($cpu, $asm, @bin) = @_;

	# (ix+%d) -> (ix)
	if ($asm =~ /\+%[du]/) {
		(my $asm1 = $asm) =~ s/\+%[du]//;
		my @bin1 = map {/%[du]/ ? 0 : $_} @bin;
		add_opc_3($cpu, $asm1, @bin1);
	}

	add_opc_3($cpu, $asm, @bin);
}
	
sub add_opc_3 {
	my($cpu, $asm, @bin) = @_;

	add_opc_4($cpu, $asm, @bin);

	return unless $cpu =~ /^r/;
	
	# expand ioi ioe
	my $has_io;
	if ($asm =~ /\((ix|iy|hl|bc|de|%m)/ && $asm !~ /^ldp/) {
		add_opc_4($cpu, "ioi $asm", $V{ioi}, @bin);
		add_opc_4($cpu, "ioe $asm", $V{ioe}, @bin);
		$has_io++;
	}
	
	# expand altd
	if ($asm =~ /^ (?| ( (?:ld|inc|dec|pop|bool|rlc|rrc|rl|rr|sla|sra|sll|sli|srl) \s+ 
									(?:a|b|c|d|e|h|l|af|bc|de|hl)) ( $ | \b [^'] .*)
					 | ( (?:add|adc|sub|sbc|and|xor|or|cpl|neg) \s+ (?:a|hl) )(,.*)
					 | ( (?:ccf|scf) \s+ f)(,.*)
					 | ( (?:rlca|rrca|rla|rra)) (.*)
					 | ( (?:res|set) \s+ %c \s* , \s* (?:a|b|c|d|e|h|l)) ( $ | \b [^'] .*)
				   ) $/x) {
		if ($has_io) {
			add_opc_4($cpu, "$1'$2", $V{altd}, @bin);
			add_opc_4($cpu, "ioi $1'$2", $V{ioi}, $V{altd}, @bin);
			add_opc_4($cpu, "ioe $1'$2", $V{ioe}, $V{altd}, @bin);
			
			add_opc_4($cpu, "altd $1$2", $V{altd}, @bin);
			add_opc_4($cpu, "altd ioi $1$2", $V{altd}, $V{ioi}, @bin);
			add_opc_4($cpu, "altd ioe $1$2", $V{altd}, $V{ioe}, @bin);
			add_opc_4($cpu, "ioi altd $1$2", $V{ioi}, $V{altd}, @bin);
			add_opc_4($cpu, "ioe altd $1$2", $V{ioe}, $V{altd}, @bin);
		}
		else {
			add_opc_4($cpu, "$1'$2", $V{altd}, @bin);
			add_opc_4($cpu, "altd $1$2", $V{altd}, @bin);
		}
	}
	elsif ($asm =~ /^ (?| ( (?:add|adc|sub|sbc|and|xor|or) \s+ [^,]+ )
					    | ( (?:cp|bit) .*) 
						| ( (?:rlc|rrc|rl|rr|sla|sra|sll|sli|srl) \s+ \( .*)
					  ) $/x) {
		if ($has_io) {
			add_opc_4($cpu, "altd $1", $V{altd}, @bin);
			add_opc_4($cpu, "altd ioi $1", $V{altd}, $V{ioi}, @bin);
			add_opc_4($cpu, "altd ioe $1", $V{altd}, $V{ioe}, @bin);
			add_opc_4($cpu, "ioi altd $1", $V{ioi}, $V{altd}, @bin);
			add_opc_4($cpu, "ioe altd $1", $V{ioe}, $V{altd}, @bin);
		}
		else {
			add_opc_4($cpu, "altd $1", $V{altd}, @bin);
		}
	}
}

sub add_opc_4 {
	my($cpu, $asm, @bin) = @_;

	if ($Opcodes{$asm}{$cpu}) {
		my $old = fmthex(@{$Opcodes{$asm}{$cpu}});
		my $new = fmthex(@bin);
		if ($old ne $new) {
			die "$cpu: $asm: ($old) or ($new)?";
		}
	}
	else {
		say sprintf("%-8s%-24s%s", $cpu, $asm, fmthex(@bin));

		$Opcodes{$asm}{$cpu} = \@bin;
	}
}

#------------------------------------------------------------------------------
# Parser
#------------------------------------------------------------------------------
sub parser_tokens {
	local($_) = @_;
	my @tokens = ();
	
	while (!/\G \z 				/gcx) {
		if (/\G \s+ 			/gcx) {}
		elsif (/\G \( (\w+) 	/gcx) { push @tokens, "_TK_IND_".uc($1); }
		elsif (/\G , 			/gcx) { push @tokens, "_TK_COMMA"; }
		elsif (/\G \) 			/gcx) { push @tokens, "_TK_RPAREN"; }
		elsif (/\G \( %[nm] \)	/gcx) { push @tokens, "expr"; }
		elsif (/\G \+ %[du]		/gcx) { push @tokens, "expr"; }
		elsif (/\G    %[snmj]	/gcx) { push @tokens, "expr"; }
		elsif (/\G    %[c]		/gcx) { push @tokens, "const_expr"; }
		elsif (/\G    (\w+)	'	/gcx) { push @tokens, "_TK_".uc($1)."1"; }
		elsif (/\G    (\w+)		/gcx) { push @tokens, "_TK_".uc($1); }
		else { die "$_ ; ", substr($_, pos($_)||0) }
	}
	return join(' ', ('| label?', @tokens, "_TK_NEWLINE"));
}

sub parse_code {
	my($cpu, $asm, @bin) = @_;
	my @code;
	
	# store prefixes
	if ($cpu =~ /^r/) {
		while (@bin && 
				($bin[0] == $V{altd} ||
				 $bin[0] == $V{ioi} ||
				 $bin[0] == $V{ioe})) {
			push @code, "DO_stmt(0x".fmthex(shift @bin).");"
		}
	}
	
	# check for argument type
	my($stmt, $extra_arg) = ("", "");
	my $bin = join(' ', @bin);
	
	if ($bin =~ s/ \@(\w+)//) {
		my $func = $1;
		push @code, 
			"DO_STMT_LABEL();",
			"declare_extern_symbol(\"$func\");",
			"Expr *emul_func = parse_expr(\"$func\");",
			"add_opcode_nn(0xCD, emul_func);";
	}
	elsif ($bin =~ s/ %d %n$//) {
		$stmt = "DO_stmt_idx_n";
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
	elsif ($asm =~ / ^ call \s+ (nz|z|nc|c|po|pe|nv|v|lz|lo|p|m) /x) {
		return "DO_stmt_call_flag(".uc($1)."); ";
	}
	elsif ($bin =~ s/ %m %m$//) {
		$stmt = "DO_stmt_nn";
	}
	elsif ($bin =~ s/ %j$//) {
		$stmt = "DO_stmt_jr";
	}
	elsif ($bin =~ s/%c\((.*?)\)/expr_value/) {
		my @values = eval($1); die "$cpu, $asm, @bin, $1" if $@;
		$bin =~ s/%c/expr_value/g;		# replace all other %c in bin
		push @code,
			"if (expr_error) return FALSE;",
			"switch (expr_value) {",
			join(" ", map {"case $_:"} @values)." break;",
			"default: error_int_range(expr_value);",
			"}";
			
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
	@bin = split(' ', $bin);
	my @expr;
	for (@bin) {
		if (/[+*?]/) {
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
	$stmt and push @code, $stmt."(".$opc.$extra_arg.");";
	
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
		return "if (!expr_in_parens) return FALSE;\n".
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

#------------------------------------------------------------------------------
# Tests
#------------------------------------------------------------------------------
sub add_tests {
	my($cpu, $asm, $bin) = @_;

	if ($asm =~ /%s/) {
		add_tests($cpu, replace($asm, '%s', 127), replace($bin, '%s', 0x7F));
		add_tests($cpu, replace($asm, '%s', -128), replace($bin, '%s', 0x80));
	}
	elsif ($asm =~ /%n/) {
		add_tests($cpu, replace($asm, '%n', 255), replace($bin, '%n', 0xFF));
		add_tests($cpu, replace($asm, '%n', 127), replace($bin, '%n', 0x7F));
		add_tests($cpu, replace($asm, '%n', -128), replace($bin, '%n', 0x80));
	}
	elsif ($asm =~ /%m/) {
		add_tests($cpu, replace($asm, '%m', 65535), replace($bin, '%m %m', 0xFF." ".0xFF));
		add_tests($cpu, replace($asm, '%m', 32767), replace($bin, '%m %m', 0xFF." ".0x7F));
		add_tests($cpu, replace($asm, '%m',-32768), replace($bin, '%m %m', 0x00." ".0x80));
	}
	elsif ($asm =~ /%j/) {
		add_tests($cpu, replace($asm, '%j', "ASMPC"), replace($bin, '%j', 0xFE));
	}
	elsif ($asm =~ /%c/) {
		$bin =~ s/%c\((.*?)\)/%c/ or die $bin;
		my @values = eval($1); die "$cpu, $asm, $bin, $1" if $@;
		my($min, $max) = ($values[0], $values[-1]);
		for (@values) {
			my @bin = split(' ', replace($bin, '%c', $_));
			for (@bin) {
				$_ = eval($_) if /[+*?]/; die $@ if $@;
			}
			add_tests($cpu, replace($asm, '%c', $_), join(' ', @bin));
			$min = $_ if $_ < $min;
			$max = $_ if $_ > $max;
		}
		add_tests('', replace($asm, '%c', $min-1), replace($bin, '%c', $min-1));
		add_tests('', replace($asm, '%c', $max+1), replace($bin, '%c', $max+1));
	}
	elsif ($asm =~ /%d/) {
		add_tests($cpu, replace($asm, qr/\+%d/, "+127"), replace($bin, '%d', 0x7F));
		add_tests($cpu, replace($asm, qr/\+%d/, "-128"), replace($bin, '%d', 0x80));
	}
	elsif ($asm =~ /%u/) {
		add_tests($cpu, replace($asm, qr/\+%u/, "+255"), replace($bin, '%u', 0xFF));
		add_tests($cpu, replace($asm, qr/\+%u/, "+0"  ), replace($bin, '%u', 0x00));
	}
	else {
		$Tests{$asm}{$cpu} = $bin;
	}
}

sub fmthex {
	return join(' ', map {/\D/ ? $_ : sprintf('%02X', $_)} @_);
}

use Data::Dump 'dump';
say "\n%Opcodes:\n", dump \%Opcodes;
say "\n%Parser:\n", dump \%Parser;
say "\n%Tests:\n", dump \%Tests;

__END__
			
			if ($op != 0x76) {
				
				if ($r eq '(hl)') {
					for my $io (@IO) {
						add_opc($cpu, "$io ld $r, $s", $V{$io}, $op) if $rabbit;
						
						for my $x (@X) {
							for my $d (@DIS) {
								add_opc($cpu, "$io ld ($x+$d), $s", $V{$io}, $V{$x}, $op, $d) if $rabbit;
							}
						}
					}
				}
				else {
					add_opc($cpu, "ld $r', $s", $V{altd}, $op) if $rabbit;
					for my $altd (@ALTD) {
						add_opc($cpu, "$altd ld $r, $s", $V{$altd}, $op) if $rabbit;

						for my $x (@X) {
							for my $d (@DIS) {
								add_opc($cpu, "$io ld $r, ($x+$d)", $V{$io}, $V{$x}, $op, $d) if $rabbit;
							}
						}
					}
				}

				if ($s eq '(hl)') {
					for my $io (@IO) {
						add_opc($cpu, "$io ld $r, $s", $V{$io}, $op) if $rabbit;
						
						for my $x (@X) {
							for my $d (@DIS) {
								add_opc($cpu, "$io ld $r, ($x+$d)", $V{$io}, $V{$x}, $op, $d) if $rabbit;
							}
						}
					}
				}
				
				if ($z80 && 
					$r =~ /\b[hl]\b/ && $s ne '(hl)' || 
				    $s =~ /\b[hl]\b/ && $r ne '(hl)' ) {
					add_opc($cpu, "ld ".$R8X[$V{$r}].", ".$R8X[$V{$s}], $V{ix}, $op);
					add_opc($cpu, "ld ".$R8Y[$V{$r}].", ".$R8Y[$V{$s}], $V{iy}, $op);
				}
			}
		}
	}
}



__END__
	my $z80 = ($cpu =~ /z80/);
	my $z180 = ($cpu =~ /z180/);
	my $zilog = ($cpu =~ /^z/);
	
	# 8-bit load group
	for my $r (0..7) {
		for my $s (0..7) {
			my $op = 0x40 + $r*8 + $s;
			
			if ($op != 0x76) {
				my @ops = (["ld $R8[$r],$R8[$s]", $op]);
				@ops = expand_ix8(@ops) if $z80;
				@ops = expand_ind_ix(@ops);
				
				add_ops($cpu, @ops);
				add_ix8($cpu, "ld $R8[$r1],$R8[$r2]", $op);
				add_iix($cpu, "ld $R8[$r1],$R8[$r2]", $op);
				if ($cpu =~ /^r/) {
					if ($r1 != 6) {
						add_ops($cpu, "altd ld $R8[$r1],$R8[$r2]", $ALTD, $op);
						add_ops($cpu, "ld $R8[$r1]',$R8[$r2]", $ALTD, $op);
					}
					elsif ($r1 == 6 || $r2 == 6) {
						add_ops($cpu, "ioi ld $R8[$r1],$R8[$r2]", $IOI, $op);
						add_ops($cpu, "ioe ld $R8[$r1],$R8[$r2]", $IOE, $op);
					}
				}
			}
		}
	}
}

sub add_ops {
	my($cpu, @ops) = @_;

	for (@ops) {
		my($asm, @bin) = @$_;

		$Opcodes{$asm}{$cpu} and die "$cpu, $asm, @bin";
		$Opcodes{$asm}{$cpu} = \@bin;
	}
}


sub expand_ix8 {
	my(@ops) = @_;
	my @ret;
	
	for (@ops) {
		my($asm, @bin) = @$_;

		push @ret, [$asm, $bin];

		if ($asm !~ /hl|ix|iy/) {
			if ((my $asm1 = $asm) =~ s/\b([lh])\b/ix$1/g) {
				push @ret, [$asm1, $IX, @bin];
			}

			if ((my $asm1 = $asm) =~ s/\b([lh])\b/iy$1/g) {
				push @ret, [$asm1, $IX, @bin];
			}
		}
	}
	
	return @ret;
}

sub expand_ind_ix {
	my(@ops) = @_;
	my @ret;
	
	for (@ops) {
		my($asm, @bin) = @$_;

		push @ret, [$asm, @bin];

		if ((my $asm1 = $asm) =~ s/\(hl\)/ix+%d/g) {
			push @ret, [$asm1, $IX, @bin[0..1], '%d', @bin[2..$#bin]];
			$asm1 =~ s/+%d\b//; 
			push @ret, [$asm1, $IX, @bin[0..1], 0, @bin[2..$#bin]];
		}

		if ((my $asm1 = $asm) =~ s/\(hl\)/iy+%d/g) {
			push @ret, [$asm1, $IY, @bin[0..1], '%d', @bin[2..$#bin]];
			$asm1 =~ s/+%d\b//; 
			push @ret, [$asm1, $IY, @bin[0..1], 0, @bin[2..$#bin]];
		}
	}
	
	return @ret;
}

