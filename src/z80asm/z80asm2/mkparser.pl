#!/usr/bin/env perl

#-------------------------------------------------------------------------------
# Create a parser from the given descritption and template
#-------------------------------------------------------------------------------

use Modern::Perl;
use Array::Compare;
use Path::Tiny;
use File::Copy;
use Data::Dump 'dump';

#-------------------------------------------------------------------------------
# data
#-------------------------------------------------------------------------------

my %tokens = (
	END => "",
	IDENT => "",
	INT => "",
	FLOAT => "",
	EXPR => "",
	CONST_EXPR => "",
	STR => "",
	RAW_STR => "",
	NEWLINE => "\n",
	
	ASMPC => '$',
	BACKSLASH => "\\",
	BIN_AND => "&",
	BIN_NOT => "~",
	BIN_OR => "|",
	BIN_XOR => "^",
	COLON => ":",
	COMMA => ",",
	DHASH => "##",
	DIV => "/",
	DOT => ".",
	EQ => "=",
	GE => ">=",
	GT => ">",
	HASH => "#",
	LBRACE => "{",
	LE => "<=",
	LOG_AND => "&&",
	LOG_NOT => "!",
	LOG_OR => "||",
	LOG_XOR => "^^",
	LPAREN => "(",
	LSHIFT => "<<",
	LSQUARE => "[",
	LT => "<",
	MINUS => "-",
	MOD => '%',
	MULT => "*",
	NE => "<>",
	PLUS => "+",
	POWER => "**",
	QUEST => "?",
	RBRACE => "}",
	RPAREN => ")",
	RSHIFT => ">>",
	RSQUARE => "]",
);

my %keywords = (
	NONE => "",
	KW_ASMPC => "asmpc",
	KW_ASSUME => "assume",
	KW_BINARY => "binary",
	KW_C_LINE => "c_line",
	KW_EQU => "equ",
	KW_INCBIN => "incbin",
	KW_INCLUDE => "include",
	KW_LINE => "line",
);

#-------------------------------------------------------------------------------
# main
#-------------------------------------------------------------------------------
@ARGV==2 or die "Usage: ",path($0)->basename," template.cpp grammar.y\n";
my($template_file, $grammar_file) = @ARGV;

my $grammar;

parse_grammar($grammar_file);
patch_file($template_file, path($grammar_file)->basename(".y"));

#dump $grammar;

#-------------------------------------------------------------------------------
# parse the grammar file
#-------------------------------------------------------------------------------
sub parse_grammar {
	my($filename) = @_;
	open(my $fh, "<", $filename) or die "open file $filename: $!\n";
	
	my @rules = ([]);
	my @actions = ("");
	my $rule_nr = 0;
	while (<$fh>) {
		if (/^\s*\/\//) {
			next;
		}
		elsif (/^\S/) {
			$rule_nr++;
			my @tokens = parse_grammar_rule($_);
			$rules[$rule_nr] = \@tokens;
			$actions[$rule_nr] = "";
		}
		else {
			if ($rule_nr < 1) {
				die "action code before rules: $_" if /\S/;
			}
			else {
				$actions[$rule_nr] .= $_;
			}
		}
	}
	
	$grammar = {tokens => \%tokens, keywords => \%keywords,
				rules => \@rules, actions => \@actions};


}

sub parse_grammar_rule {
	my($text) = @_;
	my %reverse_tokens;
	while (my($key, $value) = each %tokens) {
		if ($value ne "") {
			$reverse_tokens{$value} = $key;
		}
	}
	
	my @tokens;
	for (split(' ', $text)) {
		if (exists $tokens{$_}) {
			push @tokens, $_;
		}
		elsif (/"(.+)"/ && exists $reverse_tokens{$1}) {
			push @tokens, $reverse_tokens{$1};
		}
		elsif (/"(.+)"/) {
			push @tokens, "KW_".uc($1);
			$keywords{"KW_".uc($1)} = $1;
		}
		else {
			die "Undefined token: $_\n";
		}
	}
	
	return @tokens;
}

#-------------------------------------------------------------------------------
# patch the file with grammar
#-------------------------------------------------------------------------------
sub patch_file {
	my($template, $base_output) = @_;
	my @in = path($template)->lines;
	my @in0 = @in;
	my @out;
	
	while (@in) {
		$_ = shift(@in);
		if (/^(\s*)\/\/\@\@BEGIN:\s*type\b/) {
			my $prefix = $1;
			push @out, $_;
			push @out, "${prefix}END,\n";		# END must be id 0
			for (sort keys %{$grammar->{tokens}}) {
				next if $_ eq 'END';
				push @out, "$prefix$_,\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*type_map\b/) {
			my $prefix = $1;
			push @out, $_;
			for my $kw (sort keys %{$grammar->{tokens}}) {
				my $string = $grammar->{tokens}{$kw};
				push @out, "${prefix}{ $kw, ".c_string($string)." },\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*keyword\b/) {
			my $prefix = $1;
			push @out, $_;
			push @out, "${prefix}NONE,\n";		# NONE must be id 0
			for (sort keys %{$grammar->{keywords}}) {
				next if $_ eq 'NONE';
				push @out, "$prefix$_,\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*keyword_map\b/) {
			my $prefix = $1;
			push @out, $_;
			for my $kw (sort keys %{$grammar->{keywords}}) {
				my $string = $grammar->{keywords}{$kw};
				push @out, "${prefix}{ ".c_string($string).", $kw },\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		else {
			push @out, $_;
		}
	}
	
	# change template if needed
	my $ac = Array::Compare->new;
	if (!$ac->compare(\@in0, \@out)) {
		copy($template, "$template.bak") or die "copy to $template.bak failed\n";
		path($template)->spew(@out);
	}
}

sub c_string {
	my($text) = @_;
	$text =~ s/([\\"])/\\$1/g;
	$text =~ s/\n/\\n/g;
	return '"'.$text.'"';
}
