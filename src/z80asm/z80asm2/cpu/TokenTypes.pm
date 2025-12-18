#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2025
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

package TokenTypes;
use Modern::Perl;
use Object::Tiny qw( list by_id );

sub new {
    my ($class) = @_;
    my $self = bless {
        list    => [],  # e.g. { idx => 0, id => "TokenType::EndOfLine" }
        by_id   => {},
    }, $class;
    return $self;
}

sub read_from_file {
    my ($self, $file) = @_;

    $self->{list} = [];
    $self->{by_id}   = {};

    open(my $fh, "<", $file) or die "open $file: $!";
    my $idx = 0;
    while (<$fh>) {
        last if /^\s*enum\s+class\s+TokenType\s*\{/;
    }
    while (<$fh>) {
        last if /^\}/;
        next unless /^\s*(\w+)\s*,/;

        my $token_type = "TokenType::$1";
        my $entry = { id => $token_type, idx => $idx };

        $self->{by_id}{$token_type} = $entry;
        $self->{list}[$idx] = $entry;
        $idx++;
    }
    close($fh);
}

1;
