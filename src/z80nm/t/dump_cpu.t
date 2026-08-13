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

    for my $cpu_id ( CPU::min_id .. CPU::max_id ) {
        my $cpu_name = CPU::lookup_name($cpu_id);

        my $obj = ObjModule->new;
        $obj->name("module1");
        $obj->version($version);
        $obj->cpu($cpu_name);

        check_obj(
            $obj,
            "$dir/expected/${self}_v${version_str}_cpu_${cpu_name}.def",
            "$dir/expected/${self}_v${version_str}_cpu_${cpu_name}.txt"
        );
    }
}

unlink_testfiles;
done_testing;
