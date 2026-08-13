#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Issue #2978
# z80asm -m8085 requires invalid code RST n*8 for RST n

# every restart instruction can be encoded as RST n*8 (Zilog) or RST n (Intel)
my $bytes = bytes( 0xC7, 0xC7, 
                   0xCF, 0xCF, 
                   0xD7, 0xD7, 
                   0xDF, 0xDF, 
                   0xE7, 0xE7, 
                   0xEF, 0xEF,
                   0xF7, 0xF7, 
                   0xFF, 0xFF );

z80asm_ok( "", "", "", <<END, $bytes );
	rst 0
    rst 0

    rst 1
    rst 8

    rst 2
    rst 0x10

    rst 3
    rst 0x18

    rst 4
    rst 0x20

    rst 5
    rst 0x28

    rst 6
    rst 0x30

    rst 7
    rst 0x38
END

unlink_testfiles;
done_testing;
