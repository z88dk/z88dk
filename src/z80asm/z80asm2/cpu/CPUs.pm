#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

package CPUs;
use Modern::Perl;
use Object::Tiny qw( list by_id by_name );

sub new {
    my ($class) = @_;
    my $self = bless {
        list    => [],   # e.g. { idx => 10, id => "CPU::i8080", name => 8080 }
        by_id   => {},   
        by_name => {},   
    }, $class;
    return $self;
}

sub read_from_file {
    my ($self, $file) = @_;

    $self->{list}    = [];
    $self->{by_id}   = {};
    $self->{by_name} = {};

    open(my $fh, "<", $file) or die "open $file: $!";
    while (<$fh>) {
        next unless s/^\s*X\(\s*//;
        s/\s*\)\s*//;

        my ($idx, $id, $name) = split(/\s*,\s*/, $_);
        $id = "CPU::$id";
        $name =~ s/^\"(.*)\"$/$1/;

        my $entry = { idx => $idx, id => $id, name => $name };
        $self->{list}[$idx] = $entry;
        $self->{by_id}{$id} = $entry;
        $self->{by_name}{$name} = $entry;
    }
    close($fh);
}

1;
