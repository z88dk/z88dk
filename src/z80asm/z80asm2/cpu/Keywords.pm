#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2025
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

package Keywords;
use Modern::Perl;

sub new {
    my ($class) = @_;
    my $self = bless {
        list    => [],  # e.g. { idx => 1, flags => "IS_REGISTER", id => "Keyword::A_", name => "a'" }
        by_name => {},
        by_id   => {},
    }, $class;
    return $self;
}

sub read_from_file {
    my ($self, $file) = @_;

    $self->{list} = [];
    $self->{by_name} = {};
    $self->{by_id}   = {};

    # add None entry
    my $none_entry = { idx => 0,
                        name => "none", id => "Keyword::None",
                        flags => "" };
    $self->{list}[0] = $none_entry;
    $self->{by_name}{"none"} = $none_entry;
    $self->{by_id}{"Keyword::None"} = $none_entry;
    my $idx = 1;

    open(my $fh, "<", $file) or die "open $file: $!";
    while (<$fh>) {
        next unless s/^\s*X\(\s*//;
        s/\s*\)\s*//;
        my ($id, $name, $flags) = split(/\s*,\s*/, $_);

        $id = "Keyword::$id";
        $name = lc($name);
        $name =~ s/^\"(.*)\"$/$1/;

        my $entry = { idx => $idx, name => $name, id => $id, flags => $flags };
        $self->{list}[$idx] = $entry;
        $self->{by_name}{$name} = $entry;
        $self->{by_id}{$id} = $entry;
            
        $idx++;
    }
    close($fh);
}

sub list {
    my ($self) = @_;
    return $self->{list};
}

sub by_name {
    my ($self) = @_;
    return $self->{by_name};
}

sub by_id {
    my ($self) = @_;
    return $self->{by_id};
}

1;
