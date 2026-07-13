#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");

capture_nok( "perl z88dk-z80objcopy.pl -x", "$dir/expected/${self}.txt" );

unlink_testfiles;
done_testing;
