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

    my $obj = ObjModule->new;
    $obj->name("module1");
    $obj->version($version);

    # two sections, define ORG, ALIGN and split
    my $section1 = ObjSection->new;
    $section1->name("section1") if $version >= 5;
    $section1->org(0x1000) if $version >= 8;
    $section1->align(0x100) if $version >= 10;
    $section1->split(0);
    $section1->bytes( [ 0..15 ] );
    $obj->sections->add($section1);

    if ($version >= 5) {
        my $section2 = ObjSection->new;
        $section2->name("section2");
        $section2->split(1) if $version >= 8;
        $section2->bytes( [ 0..15 ] );
        $obj->sections->add($section2);
    }

    check_obj(
        $obj,
        "$dir/expected/${self}_v${version_str}.def",
        "$dir/expected/${self}_v${version_str}.txt"
    );
}

unlink_testfiles;
done_testing;
