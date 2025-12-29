#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2025
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

package CsrBuilder;
use Modern::Perl;
use Object::Tiny qw( state_count trans built
                     state_offsets trans_tokens trans_targets dense_rows );

# Simple CSR builder "class"
# Usage:
#   my $b = CsrBuilder->new($state_count, $token_count);
#   $b->add_transition($state, $token, $target);
#   $b->build;
#   $b->emit_cpp($fh, $cpp_namespace, $var_prefix);

# Threshold for using dense row (index lookup) instead of binary search
use constant DENSE_ROW_THRESHOLD => 8;

sub new {
    my ($class, $state_count, $token_count) = @_;
    die "state_count required" unless defined $state_count;
    die "token_count required" unless defined $token_count;
    my $self = {
        state_count => int($state_count),
        token_count => int($token_count),
        trans       => [ map { [] } (0 .. $state_count - 1) ], # arrayref of arrayrefs
        built       => 0,
        state_offsets => [],
        trans_tokens  => [],
        trans_targets => [],
        dense_rows    => [], # array of arrayrefs, one per dense row, undef for sparse
    };
    return bless $self, $class;
}

sub add_transition {
    my ($self, $state, $token, $target) = @_;
    die "already built" if $self->{built};
    push @{ $self->{trans}->[$state] }, [ int($token), int($target) ];
}

sub build {
    my ($self) = @_;
    return if $self->{built};

    my @state_offsets;
    my @tokens;
    my @targets;
    my @dense_rows;

    my $idx = 0;
    for my $s (0 .. $self->{state_count} - 1) {
        my $list = $self->{trans}->[$s];
        my $n = scalar(@$list);
        my $is_dense = ($n >= DENSE_ROW_THRESHOLD) ? 1 : 0;

        if ($is_dense) {
            # Build dense row: array of size token_count, -1 for missing
            my @dense = ( ( -1 ) x $self->{token_count} );
            for my $pair (@$list) {
                my ($tok, $tgt) = @$pair;
                $dense[$tok] = $tgt;
            }
            $dense_rows[$s] = \@dense;
            # For dense rows, do not add to sparse CSR arrays
            $state_offsets[$s] = $idx;
            next;
        } else {
            $dense_rows[$s] = undef;
        }

        $state_offsets[$s] = $idx;

        next unless @$list;

        # sort by token, stable
        my @sorted = sort { $a->[0] <=> $b->[0] } @$list;

        # Optional: deduplicate identical token entries (keep first)
        my $last_tok = undef;
        for my $pair (@sorted) {
            my ($tok, $tgt) = @$pair;
            if (defined $last_tok && $tok == $last_tok) {
                # skip duplicate token for this state (you can change policy)
                next;
            }
            push @tokens, 0 + $tok;
            push @targets, 0 + $tgt;
            $last_tok = $tok;
            $idx++;
        }
    }
    # final sentinel offset = total transitions
    $state_offsets[$self->{state_count}] = $idx;

    $self->{state_offsets} = \@state_offsets;
    $self->{trans_tokens}  = \@tokens;
    $self->{trans_targets} = \@targets;
    $self->{dense_rows}    = \@dense_rows;
    $self->{built} = 1;
}

sub emit_cpp {
    my ($self, $fh, $cpp_class, $var_prefix) = @_;
    $cpp_class  //= 'OpcodesParser';
    $var_prefix //= '';

    die "not built" unless $self->{built};

    # helpers
    my $emit_array = sub {
        my ($name, $type, $aref) = @_;
        my $count = scalar @$aref;
        print $fh "const $type ${cpp_class}::${var_prefix}${name}[$count] = {\n";
        $count = 0;
        for my $v (@$aref) {
            printf $fh "%6s, ", $v;
            $count++;
            if ($count % 8 == 0) { print $fh "\n"; }
        }
        print $fh "\n};\n\n";
    };

    # print sizes
    printf $fh "/* CSR built: %d states, %d transitions */\n\n",
        $self->{state_count}, scalar @{ $self->{trans_tokens} };

    $emit_array->('state_offsets', 'std::uint32_t', $self->{state_offsets});
    $emit_array->('trans_tokens',  'std::uint16_t', $self->{trans_tokens});
    $emit_array->('trans_targets', 'std::int32_t',  $self->{trans_targets});
    
    # Emit dense rows as a flat array and an index array
    my @dense_flat;
    my @dense_row_offsets;
    my $dense_idx = 0;
    for my $s (0 .. $self->{state_count} - 1) {
        if (defined $self->{dense_rows}[$s]) {
            $dense_row_offsets[$s] = $dense_idx;
            my $row = $self->{dense_rows}[$s];
            push @dense_flat, @$row;
            $dense_idx += $self->{token_count};
        } else {
            $dense_row_offsets[$s] = -1;
        }
    }
    $dense_row_offsets[$self->{state_count}] = $dense_idx;

    $emit_array->('dense_row_offsets', 'std::int32_t', \@dense_row_offsets);
    $emit_array->('dense_rows', 'int32_t', \@dense_flat);
}

1;
