#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;
use lib '.';
use ObjModule;
use Data::Dump 'dump';

my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");

for my $version ( Obj::min_version .. Obj::cur_version ) {
    my $version_str = sprintf "%02d", $version;

    for my $swap_ixiy ( 0 .. 1 ) {

        my $obj = ObjModule->new;
        $obj->name("module1");
        $obj->version($version);
        $obj->swap_ixiy($swap_ixiy);

        check_obj(
            $obj,
            "$dir/expected/${self}_v${version_str}_swap_ixiy_${swap_ixiy}.def",
            "$dir/expected/${self}_v${version_str}_swap_ixiy_${swap_ixiy}.txt"
        );
    }
}

unlink_testfiles;
done_testing;
