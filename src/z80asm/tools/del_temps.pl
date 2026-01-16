#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

use strict;
use warnings;
use File::Find;

my @patterns = (
    qr/\.core$/,
    qr/\.o$/,
    qr/\.d$/,
    qr/\.out$/,
    qr/\.orig$/,
    qr/\.exe$/,
    qr/\.tmp$/,
    qr/\.bak$/,
    qr/\.log$/,
    qr/~$/,
);

find(
    sub {
        return unless -f $_;   # only files
        for my $re (@patterns) {
            if ($_ =~ $re) {
                unlink $_ or warn "Could not remove $_: $!";
                last;
            }
        }
    },
    '.'
);