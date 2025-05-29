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
make_state_machine();
patch_file($template_file, path($grammar_file)->basename(".y"));

dump $grammar;

#-------------------------------------------------------------------------------
# parse the grammar file
#-------------------------------------------------------------------------------
sub parse_grammar {
	my($filename) = @_;
	open(my $fh, "<", $filename) or die "open file $filename: $!\n";
	
	my @rules;
	my @actions;
	my $rule_nr = -1;
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
			if ($rule_nr < 0) {
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
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*actions_decl\b/) {
			my $prefix = $1;
			push @out, $_;
			for my $action_id (0 .. @{$grammar->{rules}} - 1) {
				push @out, $prefix."void ".action_funcname($action_id)."();\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*actions_impl\b/) {
			my $prefix = $1;
			push @out, $_;
			for my $action_id (0 .. @{$grammar->{rules}} - 1) {
				push @out, $prefix."void LineParser::".action_funcname($action_id)."() {\n";
				my $action = action_function($grammar->{actions}[$action_id]);
				push @out, "$prefix$action\n";
				push @out, "}\n\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*states\b/) {
			my $prefix = $1;
			push @out, $_;
			for my $state (@{$grammar->{states}}) {
				my $line = $prefix."{ /* ".$state->{state}.": ".
						   join(" ", @{$state->{path}})." */\n"; 
				
				# unordered_map<Token::Keyword, int>	keyword_next;
				$line .= "$prefix  { "; 
				for my $token (sort keys %{$state->{tokens}}) {
					next unless $token =~ /^KW_/;
					$line .= "{Token::$token,".$state->{tokens}{$token}."}, ";
				}
				$line .= "},\n";
				
				# unordered_map<Token::Token, int>	token_next;
				$line .= "$prefix  { "; 
				for my $token (sort keys %{$state->{tokens}}) {
					next if $token =~ /^KW_/;
					$line .= "{Token::$token,".$state->{tokens}{$token}."}, ";
				}
				$line .= "},\n";
				
				# int action{-1};
				$line .= "$prefix  ";
				if (exists $state->{action}) {
					$line .= "&LineParser::".action_funcname($state->{action});
				}
				else {
					$line .= "nullptr";
				}
				$line .= ",\n";
				
				$line .= "$prefix},\n";
				
				push @out, $line;
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

sub action_funcname {
	my($action_id) = @_;
	my @tokens = @{$grammar->{rules}[$action_id]};
	my $funcname = "exec_action_".lc(join("_", @tokens));
	return $funcname;
}

sub action_function {
    my($text) = @_;
    for ($text) {
        s/\$(\d+)/m_line[$1]/g; # replace $1, $2, ... with m_line[1], m_line[2], ...
    }
    return $text;
}

#-------------------------------------------------------------------------------
# make state machine to parse the grammar
#-------------------------------------------------------------------------------
sub make_state_machine {
	my @rules = @{$grammar->{rules}};
	my @actions = @{$grammar->{actions}};
	
	# build a trie for the rules
	my $trie = {};
	for my $rule_nr (0 .. $#rules) {
		my @tokens = @{$rules[$rule_nr]};
		push @tokens, 'END'; # add END token to the end of the rule
		my $action = $actions[$rule_nr];
		
		my $node = $trie;
		for my $token (@tokens) {
			if (!exists $node->{$token}) {
				$node->{$token} = {};
			}
			$node = $node->{$token};
		}
		$node->{action} = $rule_nr; # store the action at the end of the path
	}

	# create states
	my @states;

	my $traverse;
	$traverse = sub {	# so that we can use it recursively
		my($node, $state, @path) = @_;

		if (!defined $states[$state]) {
			# create a new state
			$states[$state] = {state => $state, tokens => {}, path => [@path]};
		}

		if (exists $node->{action}) {
			# this is a valid state
			$states[$state]{action} = $node->{action};
		}
		else {
			for my $token (sort keys %$node) {
				next if $token eq 'action'; # skip the action key
				if (exists $states[$state]{tokens}{$token}) {
					$state = $states[$state]{tokens}{$token}; # reuse existing state
				}
				else {
					my $new_state = $#states + 1; # create a new state
					$states[$state]{tokens}{$token} = $new_state;
					$traverse->($node->{$token}, $new_state, @path, $token);
				}
			}
		}
	};
	$traverse->($trie, 0);

	$grammar->{trie} = $trie;
	$grammar->{states} = \@states;
}
