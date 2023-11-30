#!/usr/bin/env perl

#------------------------------------------------------------------------------
# Build parser rules for parsing the opcodes
#------------------------------------------------------------------------------

use Modern::Perl;
use YAML::Tiny;

@ARGV==2 or die "Usage: $0 input_file.y output_file.yaml\n";
my($input_file, $output_file) = @ARGV;

my %parser;

open(my $in, "<", $input_file) or die "open file $input_file: $!\n";
my($tokens, $code) = ('', '');
while (<$in>) {
	next if /^\s*#/;
	next if /^\s*$/;
	if (/^\S/) {
		add_rule($tokens, $code);
		$tokens = $_;
		$code = '';
	}
	else {
		die "unexpected code at $_" unless $tokens;
		s/^\s//;
		$code .= $_;
	}
}

add_rule($tokens, $code);

my $yaml = YAML::Tiny->new(\%parser);
$yaml->write($output_file);

sub parser_tokens {
	local($_) = @_;
	#my @tokens = ("TType::MainParser");
	my @tokens = ();
	
	while (!/\G \z 				/gcx) {
		if (/\G \s+ 			/gcx) {}
		elsif (/\G EXPR  \b		/gcx) { push @tokens, "expr"; }
		elsif (/\G CONST_EXPR \b/gcx) { push @tokens, "const_expr"; }
		elsif (/\G IDENT \b		/gcx) { push @tokens, "TType::Ident"; }
		elsif (/\G STR \b		/gcx) { push @tokens, "TType::String"; }
		elsif (/\G    (\w+)	'	/gcx) { push @tokens, "Keyword::".uc($1)."1"; }
		elsif (/\G    (\w+)		/gcx) { push @tokens, "Keyword::".uc($1); }
		elsif (/\G \(    		/gcx) { push @tokens, "TType::LParen"; }
		elsif (/\G , 			/gcx) { push @tokens, "TType::Comma"; }
		elsif (/\G \) 			/gcx) { push @tokens, "TType::RParen"; }
		elsif (/\G \+   		/gcx) { push @tokens, "TType::Plus"; }
		elsif (/\G \-   		/gcx) { push @tokens, "TType::Minus"; }
		elsif (/\G \.   		/gcx) { push @tokens, "TType::Dot"; }
		elsif (/\G \:   		/gcx) { push @tokens, "TType::Colon"; }
		elsif (/\G \=   		/gcx) { push @tokens, "TType::Eq"; }
		elsif (/\G \$   		/gcx) { push @tokens, "TType::End"; }
		else { die "Failed to parse: $_ ; ", substr($_, pos($_)||0) }
	}
	return @tokens;
}

sub add_rule {
	my($tokens, $code) = @_;
	return if $tokens eq '';
	
	if ($tokens =~ /\[(.*?)\]/) {
		my($before, $options, $after) = ($`, $1, $');
		my @options = split(/\|/, $options);
		for my $option (@options) {
			add_rule($before.$option.$after, $code);
		}
	}
	else {
		my @tokens = parser_tokens($tokens);
		my $rule = "@tokens";
		$parser{$rule} ||= "";
		$parser{$rule} .= $code;
	}
}
