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
    OPERATOR => "",
	NEWLINE => "\n",
	
	ASMPC => '$',
	BACKSLASH => "\\",
	COLON => ":",
	COMMA => ",",
	DHASH => "##",
	DOT => ".",
	HASH => "#",
	LBRACE => "{",
	LPAREN => "(",
	LSQUARE => "[",
	QUEST => "?",
	RBRACE => "}",
	RPAREN => ")",
	RSQUARE => "]",
);

# Precedence levels based on standard C precedence
my %operators = (
    NONE        => { text => "",    precedence => 0,    associativity => 'Left',    arity => 'Unary' },

    # Power
    POWER       => { text => "**",  precedence => 14,   associativity => 'Right',   arity => 'Binary' },

    # Unary (prefix): + - ! ~
    UPLUS       => { text => "+",   precedence => 13,   associativity => 'Right',   arity => 'Unary' },
    UMINUS      => { text => "-",   precedence => 13,   associativity => 'Right',   arity => 'Unary' },
	LOG_NOT     => { text => "!",   precedence => 13,   associativity => 'Right',   arity => 'Unary' },
	BIN_NOT     => { text => "~",   precedence => 13,   associativity => 'Right',   arity => 'Unary' },

    # Multiplicative
    MULT        => { text => "*",   precedence => 12,   associativity => 'Left',    arity => 'Binary' },
    DIV         => { text => "/",   precedence => 12,   associativity => 'Left',    arity => 'Binary' },
    MOD         => { text => "%",   precedence => 12,   associativity => 'Left',    arity => 'Binary' },

    # Additive
    PLUS        => { text => "+",   precedence => 11,   associativity => 'Left',    arity => 'Binary' },
    MINUS       => { text => "-",   precedence => 11,   associativity => 'Left',    arity => 'Binary' },

    # Shift
	LSHIFT      => { text => "<<",  precedence => 10,   associativity => 'Left',    arity => 'Binary' },
	RSHIFT      => { text => ">>",  precedence => 10,   associativity => 'Left',    arity => 'Binary' },

    # Relational
    LT          => { text => "<",   precedence => 9,    associativity => 'Left',    arity => 'Binary' },
    LE          => { text => "<=",  precedence => 9,    associativity => 'Left',    arity => 'Binary' },
    GT          => { text => ">",   precedence => 9,    associativity => 'Left',    arity => 'Binary' },
    GE          => { text => ">=",  precedence => 9,    associativity => 'Left',    arity => 'Binary' },

    # Equality
    EQ          => { text => "=",   precedence => 8,    associativity => 'Left',    arity => 'Binary' },
    NE          => { text => "<>",  precedence => 8,    associativity => 'Left',    arity => 'Binary' },

    # Bitwise AND, XOR, OR
	BIN_AND     => { text => "&",   precedence => 7,    associativity => 'Left',    arity => 'Binary' },
	BIN_XOR     => { text => "^",   precedence => 6,    associativity => 'Left',    arity => 'Binary' },
	BIN_OR      => { text => "|",   precedence => 5,    associativity => 'Left',    arity => 'Binary' },

    # Logical AND, XOR, OR
	LOG_AND     => { text => "&&",  precedence => 4,    associativity => 'Left',    arity => 'Binary' },
	LOG_XOR     => { text => "^^",  precedence => 3,    associativity => 'Left',    arity => 'Binary' },
	LOG_OR      => { text => "||",  precedence => 2,    associativity => 'Left',    arity => 'Binary' },

    # Ternary
    TERNARY     => { text => "?:",  precedence => 1,    associativity => 'Right',   arity => 'Ternary' },
);

my %keywords = (
	NONE => "",
	ASMPC => "asmpc",
	ASSUME => "assume",
	BINARY => "binary",
	C_LINE => "c_line",
	EQU => "equ",
	INCBIN => "incbin",
	INCLUDE => "include",
	LINE => "line",
);

my %patches = (
    NONE    => { size => 0 },
    JR      => { size => 1 },
    N       => { size => 1 },
    NN      => { size => 2 },
);

#-------------------------------------------------------------------------------
# main
#-------------------------------------------------------------------------------
@ARGV>2 or die "Usage: ",path($0)->basename," grammar.y files.cpp...\n";
my($grammar_file, @source_files) = @ARGV;

my $grammar;

parse_grammar($grammar_file);
make_state_machine();
for my $file (@source_files) {
	patch_file($file);
}

#dump $grammar;

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
	
	$grammar = {tokens => \%tokens,
                keywords => \%keywords,
                operators => \%operators,
                patches => \%patches, 
				rules => \@rules,
                actions => \@actions};
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
			push @tokens, uc($1);
			$keywords{uc($1)} = lc($1);
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
	my($file) = @_;
	my @in = path($file)->lines;
	my @in0 = @in;
	my @out;
	
	while (@in) {
		$_ = shift(@in);
		if (/^(\s*)\/\/\@\@BEGIN:\s*ttype\b/) {
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
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*ttype_text\b/) {
			my $prefix = $1;
			push @out, $_;
			for my $kw (sort keys %{$grammar->{tokens}}) {
				my $string = $grammar->{tokens}{$kw};
				push @out, "${prefix}{ TType::$kw, ".c_string($string)." },\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*operator\b/) {
			my $prefix = $1;
			push @out, $_;
			push @out, "${prefix}NONE,\n";	# OP_NONE must be id 0
			for (sort keys %{$grammar->{operators}}) {
				next if $_ eq 'NONE';
				push @out, "$prefix$_,\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*operator_text\b/) {
			my $prefix = $1;
			push @out, $_;
			for my $kw (sort keys %{$grammar->{operators}}) {
				my $info = $grammar->{operators}{$kw};
				push @out, "${prefix}{ Operator::$kw, ".c_string($info->{text})." },\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*operator_info\b/) {
			my $prefix = $1;
			push @out, $_;
			for my $kw (sort keys %{$grammar->{operators}}) {
				my $info = $grammar->{operators}{$kw};
				push @out, "${prefix}{ Operator::$kw, { ".$info->{precedence}.", ".
                            "Associativity::".$info->{associativity}.", ".
                            "Arity::".$info->{arity}." } },\n";
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
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*keyword_text\b/) {
			my $prefix = $1;
			push @out, $_;
			for my $kw (sort keys %{$grammar->{keywords}}) {
				my $string = $grammar->{keywords}{$kw};
				push @out, "${prefix}{ Keyword::$kw, ".c_string($string)." },\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*keyword_lookup\b/) {
			my $prefix = $1;
			push @out, $_;
			for my $kw (sort keys %{$grammar->{keywords}}) {
				my $string = $grammar->{keywords}{$kw};
				push @out, "${prefix}{ ".c_string($string).", Keyword::$kw },\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*patch\b/) {
			my $prefix = $1;
			push @out, $_;
			push @out, "${prefix}NONE,\n";		# NONE must be id 0
			for (sort keys %{$grammar->{patches}}) {
				next if $_ eq 'NONE';
				push @out, "$prefix$_,\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
        }
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*patch_sizes\b/) {
			my $prefix = $1;
			push @out, $_;
			for (sort keys %{$grammar->{patches}}) {
				next if $_ eq 'NONE';
				push @out, $prefix."{ PatchType::".$_.", ".$grammar->{patches}{$_}{size}." },\n";
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
				
				# unordered_map<Keyword, int>	keyword_next;
				$line .= "$prefix  { "; 
				for my $token (sort keys %{$state->{tokens}}) {
					next unless exists $keywords{$token};
					$line .= "{Keyword::$token, ".$state->{tokens}{$token}."}, ";
				}
				$line .= "},\n";
				
				# unordered_map<TType::Token, int>	token_next;
				$line .= "$prefix  { "; 
				for my $token (sort keys %{$state->{tokens}}) {
					next if exists $keywords{$token};
					$line .= "{TType::$token, ".$state->{tokens}{$token}."}, ";
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
		copy($file, "$file.bak") or die "copy to $file.bak failed\n";
		path($file)->spew(@out);
		system("dos2unix", $file)==0 or die "dos2unix failed: $!";
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
	my $funcname = "action_".lc(join("_", @tokens));
	return $funcname;
}

sub action_function {
    my($text) = @_;
    for ($text) {
        s/\$(\d+)/m_elems.elems[$1-1]/g;
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
