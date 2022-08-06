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
my $rule;
while (<$in>) {
	next if /^\s*#/;
	next if /^\s*$/;
	if (/^\S/) {
		my @tokens = parser_tokens($_);
		$rule = "@tokens";
	}
	else {
		die "unexpected code at $_" unless $rule;
		$parser{$rule} ||= "";
		$parser{$rule} .= $_;
	}
}

my $yaml = YAML::Tiny->new(\%parser);
$yaml->write($output_file);

sub parser_tokens {
	local($_) = @_;
	my @tokens = ();
	
	while (!/\G \z 				/gcx) {
		if (/\G \s+ 			/gcx) {}
		elsif (/\G expr  \b		/gcx) { push @tokens, "expr"; }
		elsif (/\G ident \b		/gcx) { push @tokens, "TType::Ident"; }
		elsif (/\G    (\w+)	'	/gcx) { push @tokens, "Keyword::".uc($1)."1"; }
		elsif (/\G    (\w+)		/gcx) { push @tokens, "Keyword::".uc($1); }
		elsif (/\G \(    		/gcx) { push @tokens, "TType::LParen"; }
		elsif (/\G , 			/gcx) { push @tokens, "TType::Comma"; }
		elsif (/\G \) 			/gcx) { push @tokens, "TType::RParen"; }
		elsif (/\G \+   		/gcx) { push @tokens, "TType::Plus"; }
		elsif (/\G \-   		/gcx) { push @tokens, "TType::Minus"; }
		elsif (/\G \.   		/gcx) { push @tokens, "TType::Dot"; }
		elsif (/\G \:   		/gcx) { push @tokens, "TType::Colon"; }
		elsif (/\G \$   		/gcx) { push @tokens, "TType::End"; }
		else { die "$_ ; ", substr($_, pos($_)||0) }
	}
	return @tokens;
}

