package Trie;

#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

use Modern::Perl;
use Object::Tiny qw( trie value_id values token_id nodes transitions bytecode );
use warnings FATAL => 'uninitialized';
use Data::Dump 'dump';

sub new {
    my ($class) = @_;
    return bless {
        trie        => {},
        value_id    => {},
        values      => [],
        token_id    => {},
        nodes       => [],
        transitions => [],
        bytecode    => [],
    }, $class;
}

sub add {
    my ( $self, $asm, $cpu, $value ) = @_;

    # create the trie
    my @tokens = $self->lex( $asm, $cpu );
    my $node   = $self->trie;
    for (@tokens) {
        my ( $token, $token_value ) = @$_;
        $node->{$token} //= {};
        $node = $node->{$token};
    }

    # create the value ID
    if ( !exists $self->value_id->{$value} ) {
        my $id = @{ $self->values };
        $self->value_id->{$value} = $id;
        push @{ $self->values },
            { id => $id, value => $value, _asm => $asm, _cpu => $cpu };
    }
    my $id = $self->value_id->{$value};
    $node->{_value} = $id;
}

sub lex {
    my ( $class, $asm, $cpu ) = @_;
    my @tokens;

    # first token is the CPU
    push @tokens, [ "TrieToken::cpu_" . lc($cpu), $cpu ] if defined $cpu;

    # split asm in lexemes
    while ( $asm ne "" ) {
        if ( $asm =~ s/^\s+// ) {
            next;    # skip whitespace
        }
        if ( $asm =~ s/^(\d+)// ) {
            push @tokens, [ "TrieToken::TK_Integer", $1 ];
            next;
        }
        if ( $asm =~ s/^(\w+)// ) {
            push @tokens, [ "TrieToken::KW_" . uc($1), $1 ];
            next;
        }
        if ( $asm =~ s/^(%t\d*)// ) {
            push @tokens, [ "TrieToken::Label", $1 ];
            next;
        }
        if ( $asm =~ s/^(%\w+)// ) {
            push @tokens, [ "TrieToken::Expr", $1 ];
            next;
        }
        if ( $asm =~ s/^\+(%\w+)// ) {
            push @tokens, [ "TrieToken::DispExpr", $1 ];
            next;
        }
        if ( $asm =~ s/^\(// ) {
            push @tokens, [ "TrieToken::TK_LeftParen", "(" ];
            next;
        }
        if ( $asm =~ s/^\)// ) {
            push @tokens, [ "TrieToken::TK_RightParen", ")" ];
            next;
        }
        if ( $asm =~ s/^\+// ) {
            push @tokens, [ "TrieToken::TK_Plus", "+" ];
            next;
        }
        if ( $asm =~ s/^-// ) {
            push @tokens, [ "TrieToken::TK_Minus", "-" ];
            next;
        }
        if ( $asm =~ s/^'// ) {
            push @tokens, [ "TrieToken::TK_Tick", "'" ];
            next;
        }
        if ( $asm =~ s/^\.// ) {
            push @tokens, [ "TrieToken::TK_Dot", "." ];
            next;
        }
        if ( $asm =~ s/^,// ) {
            push @tokens, [ "TrieToken::TK_Comma", "," ];
            next;
        }
        if ( $asm =~ s/^:// ) {
            push @tokens, [ "TrieToken::TK_Colon", ":" ];
            next;
        }
        if ( $asm =~ s/^;// ) {
            push @tokens, [ "TrieToken::TK_EndOfLine", ";" ];
            next;
        }
        die "unexpected lexing error: '$asm'\n";
    }
    return @tokens;
}

sub read_token_id {
    my ( $self, $opcodes_trie_token_h ) = @_;
    open( my $fh, "<", $opcodes_trie_token_h )
        or die "open $opcodes_trie_token_h: $!";
    my $in = 0;
    while (<$fh>) {
        if (/enum class TrieToken/) {
            $in = 1;
            next;
        }
        if (/\}/) {
            $in = 0;
            next;
        }
        next if !$in;
        if (/^\s*(\w+)\s*=\s*(\d+),/) {
            my ( $token, $id ) = ( $1, $2 );
            $self->token_id->{"TrieToken::$token"} = $id;
        }
    }
}

sub make_table {
    my ($self)        = @_;
    my $node_id       = 0;
    my $transition_id = 0;

    # depth-first traversal of the trie to assign node IDs and paths
    my @stack = ( [ $self->trie, 0, "" ] );
    while (@stack) {
        my ( $node, $id, $path ) = @{ pop @stack };
        $node->{_id}                  = $id;
        $node->{_path}                = $path;
        $node->{_first_transition_id} = $transition_id;
        my $first_transition_id = $transition_id;
        $self->nodes->[$id] = $node;
        for my $key (
            sort { $self->token_id->{$a} <=> $self->token_id->{$b} }
            grep { !/^_/ } keys %$node
            )
        {
            my $child      = $node->{$key};
            my $child_path = "$path $key" =~ s/TrieToken:://r =~ s/^\s+//r;
            my $child_id   = ++$node_id;
            $self->transitions->[$transition_id] = {
                id    => $transition_id,
                from  => $id,
                to    => $child_id,
                token => $key
            };
            if ( $transition_id == $first_transition_id ) {
                $self->transitions->[$transition_id]{first} =
                    1;    # mark first transition for this node
            }
            $transition_id++;

            push @stack, [ $child, $child_id, $child_path ];
        }

        $node->{_num_transitions} =
            $transition_id - $node->{_first_transition_id};
    }
}

sub output_h {
    my ( $self, $basename ) = @_;
    my $h = "extern const TrieNode ${basename}_nodes[];\n";
    $h .= "extern const TrieTransition ${basename}_transitions[];\n";
    return $h;
}

sub output_cpp {
    my ( $self, $basename ) = @_;

    # TrieNode table
    my $num_nodes = @{ $self->nodes };
    my $cpp       = "const TrieNode ${basename}_nodes[$num_nodes] = {\n";
    for my $node ( @{ $self->nodes } ) {
        my $first_transition_id = $node->{_first_transition_id};
        my $num_transitions     = $node->{_num_transitions};
        my $value_id     = exists $node->{_value} ? $node->{_value}     : -1;
        my $value_id_str = $value_id >= 0         ? " action $value_id" : "";

        if ( $num_transitions == 0 ) {    # accepting node, no transitions
            defined $node->{_value}
                or die "accepting node $node->{_id} has no value\n"
                . dump($node);
            $first_transition_id =
                0;    # not used, but set to a valid value for consistency
        }
        $cpp .=
"    /* node $node->{_id} */ { $first_transition_id, $num_transitions, $value_id }, "
            . "// $node->{_path},$value_id_str\n";
    }
    $cpp .= "};\n\n";

    # TrieTransition table
    my $num_transitions = @{ $self->transitions };
    $cpp .=
        "const TrieTransition ${basename}_transitions[$num_transitions] = {\n";
    for my $trans ( @{ $self->transitions } ) {
        my $node_from = $self->nodes->[ $trans->{from} ];
        my $node_to   = $self->nodes->[ $trans->{to} ];

        if ( $trans->{first} ) {
            $cpp .= "\n    // from node $trans->{from} ($node_from->{_path})\n";
        }
        $cpp .=
            "    /* trans $trans->{id} */ { $trans->{token}, $trans->{to} },\n";
    }
    $cpp .= "};\n\n";

    return $cpp;
}

1;
