#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

package Trie;
use Modern::Perl;
use Object::Tiny qw( trie dfa_tokens dfa_leafs );

sub new {
    my ($class, $dfa_tokens, $dfa_leafs) = @_;
    my $self = bless {
        trie       => {},           # The main trie structure (was %Trie)
        dfa_tokens => $dfa_tokens,  # DFA_Tokens object
        dfa_leafs  => $dfa_leafs,   # DFA_Leafs object
    }, $class;
    return $self;
}

sub clear {
    my ($self) = @_;
    $self->{trie} = {};
    $self->{dfa_tokens}->clear();
    $self->{dfa_leafs}->clear();
}

sub read_opcodes {
    my ($self, $file, $keywords) = @_;

    $self->clear();

    open(my $fh, "<", $file) or die "open $file: $!";
    my $header = <$fh>;
    $header =~ /asm\|cpu\|synth\|const\|ops/ or die "$file: wrong file format";
    while (<$fh>) {
        chomp;
        my($asm, $cpu, $synth, $const, $ops) = split(/\|/, $_);
        my @tokens = $self->tokenize($asm, $keywords);
        next unless @tokens;

        # special case for Intel
        my $cpu_key = $cpu =~ /^80/ ? "CPU::i$cpu" : "CPU::$cpu";
        unshift @tokens, $cpu_key;      # start with the CPU token

        # build the trie with the tokens
        my $p = $self->{trie};
        for my $i (0 .. $#tokens) {
            my $token = $tokens[$i];

            $p->{$token} ||= {};
            $p = $p->{$token};

            $self->{dfa_tokens}->add_token($token);
        }

        # add leaf
        my $last = $tokens[-1];
        my $leaf = $self->{dfa_leafs}->add_leaf($cpu_key, $const, $ops,
                                                "@tokens");
        $p->{END} = $leaf;
    }

    $self->{dfa_tokens}->create_token_codes();
}

# tokenize the asm string, last token is the tail of the $asm string that 
# needs to be parsed, empty string if none
sub tokenize {
	my($self, $asm, $keywords) = @_;
	my $text = $asm;
	my @tokens;
	while ($text ne "") {
		$text =~ s/^\s+//;
		last if $text eq "";
        if ($text =~ s/^\+%\w//) {
            push @tokens, "PlusExpr";
        }
        elsif ($text =~ s/^\+(A|BC|DE|HL|IX|IY)//i) {
            push @tokens, "TokenType::Plus".uc($1);
        }
        elsif ($text =~ s/^%\w//) {
            push @tokens, "Expr";
        }
		elsif ($text =~ s/^(\w+\'?)//) {
			my $keyword = lc($1);
			if (!exists $keywords->by_name->{$keyword}) {
				die "Keyword $keyword missing\n";
			}
			elsif (@tokens == 0) {	# first token must be opcode
				if ($keywords->by_name->{$keyword}{flags} !~ /IS_OPCODE/) {
					die "Keyword $keyword missing IS_OPCODE flag\n";
				}
			}
			push @tokens, $keywords->by_name->{$keyword}{id};
		}
		elsif ($text =~ s/^\(//) {
			push @tokens, "TokenType::LeftParen";
		}
		elsif ($text =~ s/^\)//) {
			push @tokens, "TokenType::RightParen";
		}
		elsif ($text =~ s/^,//) {
			push @tokens, "TokenType::Comma";
		}
		elsif ($text =~ s/^\+//) {
			push @tokens, "TokenType::Plus";
		}
		elsif ($text =~ s/^\-//) {
			push @tokens, "TokenType::Minus";
		}
		elsif ($text =~ s/^\.//) {
			push @tokens, "TokenType::Dot";
		}
		elsif ($text =~ s/^://) {
			push @tokens, "TokenType::Colon";
		}
		else {
			die "cannot parse '$text'\n";
		}
	}
	push @tokens, "TokenType::EndOfLine";	# empty tail - complete parse
	return @tokens;
}

1;
