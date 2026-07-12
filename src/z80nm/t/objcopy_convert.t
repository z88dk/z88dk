#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;
use lib '.';
use ObjModule;

my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");

for my $version ( Obj::min_version .. Obj::max_version ) {
    my $version_str = sprintf "%02d", $version;

    run_ok("perl z88dk-z80objcopy.pl $dir/input/$self.def $test.1.o");
    run_ok("perl z88dk-z80objcopy.pl -v $version $test.1.o $test.2.o");
    capture_ok( "z88dk-z80nm -a $test.2.o",
        "$dir/expected/${self}_v$version_str.txt" );
}

unlink_testfiles;
done_testing;
