#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2025
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

package DFA_Leafs;
use Modern::Perl;
use Object::Tiny qw( list by_key );

sub new {
    my ($class) = @_;
    my $self = bless {
        list   => [],
        by_key => {},
    }, $class;
    return $self;
}

sub clear {
    my ($self) = @_;
    $self->{list}   = [];
    $self->{by_key} = {};
}

sub add_leaf {
    my ($self, $cpu_key, $const, $ops, $path) = @_;
    my $key = "$const|$ops";

    for ($path) {
        s/Keyword:://g;
        s/TokenType:://g;
    }

    my $leaf;
    if (!exists $self->{by_key}{$key}) {
        my $idx = scalar(@{ $self->{list} });
        $leaf = {
            idx       => $idx,
            const     => $const,
            ops       => $ops,
            paths     => { $path => 1 },
            cpus      => { $cpu_key => 1 },
        };
        $self->{by_key}{$key} = $leaf;
        $self->{list}[$idx] = $leaf;
    }
    else {
        $leaf = $self->{by_key}{$key};
        $leaf->{paths}{$path} = 1;
        $leaf->{cpus}{$cpu_key} = 1;
    }

    # make path list
    my @paths = sort keys %{ $leaf->{paths} };
    $leaf->{path} = join(" | ", @paths);

    return $leaf;
}

sub idx_exists {
    my ($self, $idx) = @_;
    return $idx >= 0 && exists $self->{list}[$idx];
}

1;

