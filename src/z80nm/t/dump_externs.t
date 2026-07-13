#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;
use lib '.';
use ObjModule;
use Data::Dump 'dump';

my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");

for my $version ( Obj::min_version .. Obj::max_version ) {
    my $version_str = sprintf "%02d", $version;

    my $obj = ObjModule->new;
    $obj->name("module1");
    $obj->version($version);

    $obj->externs->add("x1");
    $obj->externs->add("x2");
    $obj->externs->add("x3");

    check_obj(
        $obj,
        "$dir/expected/${self}_v${version_str}.def",
        "$dir/expected/${self}_v${version_str}.txt"
    );
}

unlink_testfiles;
done_testing;
