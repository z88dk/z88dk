#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

package DFA_Tokens;
use Modern::Perl;
use Object::Tiny qw( by_key list );

sub new {
    my ($class) = @_;
    my $self = bless {
        by_key => {},  # e.g. { idx => 16, dfa_token => "K_A_", token => "Keyword::A_" }
        list   => [],
    }, $class;
    return $self;
}

sub clear {
    my ($self) = @_;
    $self->{by_key} = {};
    $self->{list}   = [];
}

sub add_token {
    my ($self, $token) = @_;
    return if exists $self->{by_key}{$token};

    my $token_key = $token;
    for ($token_key) {
        s/^Keyword::/KW_/;
        s/^TokenType::/TK_/;
        s/^CPU::/CPU_/;
    }

    $self->{by_key}{$token_key} = { dfa_token => $token_key, token => $token, idx => 0 };
}

sub create_token_codes {
    my ($self) = @_;
    my $idx = 0;

    $self->add_token("None");
    $self->{by_key}{"None"}{idx} = $idx++;

    $self->{list} = [ $self->{by_key}{"None"} ];
    for my $token_key (sort keys %{ $self->{by_key} }) {
        next if $token_key eq "None";
        $self->{by_key}{$token_key}{idx} = $idx;
        $self->{list}[$idx] = $self->{by_key}{$token_key};
        $idx++;
    }
}

1;
