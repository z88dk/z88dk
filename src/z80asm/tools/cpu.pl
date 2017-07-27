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
	if ($asm =~ / \b [hl] \b /x && $asm !~ /hl|ix|iy/) {
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
	if ($asm =~ / ^ (ld) \s+ (b|c|d|e|h|l|a|f|bc|de|hl|af)(,.*) /x && $asm !~ /i[xy][hl]/) {
		my($asm1, $asm2, $asm3) = ($1, $2, $3);
		add_3('rabbit', "$asm1 $asm2'$asm3",     "76 $bin");
		add_3('rabbit', "altd $asm1 $asm2$asm3", "76 $bin");
	}

	add_3($cpu_tag, $asm, $bin);
}

sub add_3 {
	my($cpu_tag, $asm, $bin) = @_;
	
	# expand (hl) to (ix), (ix+d) and iy
	if ($asm =~ / (.*) ( \( hl \) ) (.*) /x) {
		my($asm1, $asm2, $asm3) = ($1, $2, $3);
		add_4($cpu_tag, "$asm1(ix)$asm3",		encode_ixiy_bin($bin, "DD", "00"));
		add_4($cpu_tag, "$asm1(ix+DIS)$asm3", 	encode_ixiy_bin($bin, "DD", "DIS"));
		add_4($cpu_tag, "$asm1(iy)$asm3", 		encode_ixiy_bin($bin, "FD", "00"));
		add_4($cpu_tag, "$asm1(iy+DIS)$asm3", 	encode_ixiy_bin($bin, "FD", "DIS"));
	}
	
	add_4($cpu_tag, $asm, $bin);
}

sub add_4 {
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

# add a test, replace N, NN, ... by numbers
sub add_test {
	my($cpu, $asm, $bin) = @_;

	if ($asm =~ /NN/) {
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
					$bin = 'Error' if $ok eq 'err';
					print $fh sprintf(" %-23s; %s\n", $asm, $bin)
				}
			}
		}
	}
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
		
		# check that all sub-values have the same cpu_tag
		my $cpu_tag;
		for (values %$v) {
			if (!defined($cpu_tag)) {
				$cpu_tag = $_->{cpu_tag};
			}
			else {
				die $tokens unless $cpu_tag eq $_->{cpu_tag};
			}
			delete $_->{cpu_tag};
		}
		die $tokens unless defined($cpu_tag);
		
		# add comments to rule
		for (sort {$a->{asm} cmp $b->{asm}} values %$v) {
			push @{$Parser{$tokens}{comments}}, 
				"/* ".($_->{asm})." */\n";
		}
		
		# add cpu_tag checking code
		if ($cpu_tag ne 'all') {
			push @{$Parser{$tokens}{code}}, 
				"  if ((opts.cpu & (CPU_".uc($cpu_tag).")) == 0) { error_illegal_ident(); return FALSE; }\n";
		}
		
		# check for (NN), (N), NN, N, ""
		my $v_nkeys = scalar(keys %$v);
		if ($v_nkeys == 2 && $v->{'(NN)'} && $v->{'N'}) {
			push @{$Parser{$tokens}{code}}, 
				"  if (expr_in_parens) {\n".
				"    ".c_code($v->{'(NN)'}, 1)."\n".
				"  }\n".
				"  else {\n".
				"    ".c_code($v->{'N'}, 1)."\n".
				"  }\n";
		}
		else {
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

	my $ixiy_bin = ixiy_bin($asm);
	if ($ixiy_bin) {
		return "if (!opts.swap_ix_iy) {\n".
			   "    ".c_code1($bin, $level+1)."\n".
			   "  }\n".
			   "  else {\n".
			   "    ".c_code1($ixiy_bin, $level+1)."\n".
			   "  }";
	}
	else {
		return c_code1($bin, $level);
	}
}

sub c_code1 {
	my($bin, $level) = @_;
	my $indent = "  " x (++$level);
	my $ret = '';
	
	if ($bin =~ s/^76 //) { 
		$ret .= "DO_stmt(0x76);\n".$indent;
	}

	my $stmt = "";
	if ($bin =~ s/ N$//) {
		$stmt = "DO_stmt_n";
	}
	elsif ($bin =~ s/ NNl NNh$//) {
		$stmt = "DO_stmt_nn";
	}
	elsif ($bin =~ s/ DIS//) {
		$stmt = "DO_stmt_idx";
	}
	else {
		$stmt = "DO_stmt";
	}
	$stmt or die $bin;
	
	my @hex = map {$_ = sprintf("%02X", hex($_))} split(' ', $bin);
	@hex > 0 && @hex <= 3 or die $bin;
	
	$ret .= $stmt."(0x".join("", @hex)."); ";
	
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

		s/      DIS     / expr /x;

		s/,/ COMMA /g;
		s/'/1/g;
		s/ \( (hl|ix|iy) \+? / IND_$1 /x;
		s/ \)                / RPAREN /x;
	}
	my @tokens = split(' ', $asm);
	for (@tokens) {
		if (/expr/) {
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
