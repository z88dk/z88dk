#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

package DFA;
use Modern::Perl;
use Object::Tiny qw( states dfa_tokens dfa_leafs );

sub new {
    my ($class, $dfa_tokens, $dfa_leafs) = @_;
    my $self = bless {
        states     => [],  # array of state hashes
        dfa_tokens => $dfa_tokens,  # DFA_Tokens object
        dfa_leafs  => $dfa_leafs,   # DFA_Leafs object
    }, $class;
    return $self;
}

# Build DFA from a Trie object
sub read_from_trie {
    my ($self, $trie) = @_;
    $self->{states} = [];
    $self->{dfa_tokens} = $trie->dfa_tokens;
    $self->{dfa_leafs} = $trie->dfa_leafs;
    my $trie_hash = $trie->trie;

    # Recursively build states from trie
    $self->_make_states_recurse($trie_hash, []);
}

sub _make_states_recurse {
    my ($self, $trie, $path) = @_;

    # create the parent state
    my $state_nr = scalar(@{ $self->{states} });
    $trie->{state} = $state_nr;
    $trie->{path} = join(" ", @$path);
    my $state = { state => $state_nr, path => join(" ", @$path) };
    push @{ $self->{states} }, $state;

    # populate all children states recursively
    for my $k (sort keys %$trie) {
        my $v = $trie->{$k};
        if (ref($v) eq 'HASH' && $k ne 'END') {
            $self->_make_states_recurse($v, [ @$path, $k ]);
        }
    }

    # populate transitions of the parent state
    for my $k (sort keys %$trie) {
        my $v = $trie->{$k};
        if (ref($v) eq 'HASH') {
            if ($k eq 'END') {
                $state->{end} = $v;
            }
            elsif ($k =~ /^Keyword::/) {
                my $k_key = $k =~ s/^Keyword::/K_/r;
                $state->{transitions}{$k_key} = { state => $v->{state} };
            }
            elsif ($k =~ /^TokenType::/) {
                my $t_key = $k =~ s/^TokenType::/T_/r;
                $state->{transitions}{$t_key} = { state => $v->{state} };
            }
            elsif ($k =~ /^(Plus)?Expr$/) {
                $state->{transitions}{$k} = { state => $v->{state} };
            }
            else {
                die "unknown trie key: $k";
            }
        }
    }
}

# Read DFA from file (minimized DFA output)
sub read_from_file {
    my ($self, $file) = @_;
    $self->{states} = [];
    open(my $fh, "<", $file) or die "open $file: $!\n";
    my $line_nr = 0;
    my $num_states = -1;
    while (<$fh>) {
        ++$line_nr;
        chomp;
        s/\#.*//;  # remove comments
        next if /^\s*$/;
        my @words = split(' ', $_);
        if (@words == 2 && $words[0] eq 'num_states') {
            $num_states = $words[1];
        }
        elsif (@words == 2 && $words[0] eq 'num_tokens') {
            # skip
        }
        elsif (@words == 3 && $words[0] eq 'accept') {
            my $state_id = $words[1];
            my $accept_id = $words[2];
            $self->dfa_leafs->idx_exists($accept_id) or die "$file:$line_nr: error: invalid accept_id $accept_id\n";
            $self->{states}[$state_id] ||= { state => $state_id, transitions => {} };
            $self->{states}[$state_id]{end} = $self->dfa_leafs->list->[$accept_id];
        }
        elsif (@words == 4 && $words[0] eq 'trans') {
            my $state_id = $words[1];
            my $token_idx = $words[2];
            my $target_state = $words[3];
            $token_idx < scalar(@{ $self->dfa_tokens->list }) or die "$file:$line_nr: error: invalid dfa_token_id $token_idx\n";
            my $dfa_token = $self->dfa_tokens->list->[$token_idx]{dfa_token};
            $self->{states}[$state_id] ||= { state => $state_id, transitions => {} };
            $self->{states}[$state_id]{transitions}{$dfa_token} = $target_state;
        }
        else {
            die "$file:$line_nr: error: invalid line: $_\n";
        }
    }
    close($fh);

    # final checks
    $num_states == scalar(@{ $self->{states} }) or
        die "$file: error: num_states $num_states != actual ", scalar(@{ $self->{states} }), "\n";
}

# Write DFA to file
sub write_to_file {
    my ($self, $file) = @_;
    open(my $fh, ">", $file) or die "open $file: $!\n";
    my $states = $self->{states};
    say $fh "# DFA";
    say $fh "num_states ", scalar(@$states);
    say $fh "num_tokens ", scalar(@{ $self->dfa_tokens->list });

    # accepting states (deterministic order by state id)
    say $fh "";
    say $fh "# accept <state_id> <accept_class_id>";
    for my $state (sort { $a->{state} <=> $b->{state} } @$states) {
        if (exists $state->{end}) {
            my $leaf = $state->{end};
            say $fh "accept $state->{state} ", $leaf->{idx};
        }
    }

    # transitions (deterministic order by token numeric id)
    say $fh "";
    say $fh "# trans <from_state> <token_id> <to_state>";
    for my $state (sort { $a->{state} <=> $b->{state} } @$states) {
        my $from = $state->{state};
        my $trans = $state->{transitions} || {};
        # sort token keys by their numeric token index for stable output
        for my $token ( sort {
                $self->dfa_tokens->by_key->{$a}{idx} <=> $self->dfa_tokens->by_key->{$b}{idx}
            } keys %$trans )
        {
            my $token_idx = $self->dfa_tokens->by_key->{$token}{idx};
            my $to = $trans->{$token}{state};
            say $fh "trans $from $token_idx $to";
        }
    }
    close($fh);
}

1;

