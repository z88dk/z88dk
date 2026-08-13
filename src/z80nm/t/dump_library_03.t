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

    # library modules for all cpu/ixiy combinations
    my $lib = ObjLibrary->new;
    $lib->version($version);

    for my $cpu ( CPU::min_id .. CPU::max_id ) {
        for my $swap_ixiy ( 0 .. 1 ) {
            my $cpu_str  = CPU::lookup_name($cpu);
            my $ixiy_str = $swap_ixiy ? "ixiy" : "no_ixiy";

            my $obj = ObjModule->new;
            $obj->version($version);
            $obj->name("module_${cpu_str}_${ixiy_str}");
            $obj->cpu($cpu_str);
            $obj->swap_ixiy($swap_ixiy);

            # create local and global symbols
            for my $scope ( "Local", "Public" ) {
                for my $n ( 1 .. 2 ) {
                    my $sym = ObjSymbol->new;
                    $sym->name( lc("$scope$n") );
                    $sym->scope($scope);
                    $obj->symbols->add($sym);
                }
            }

            $lib->add($obj);
        }
    }

    check_obj(
        $lib,
        "$dir/expected/${self}_v${version_str}.def",
        "$dir/expected/${self}_v${version_str}.txt"
    );
}

unlink_testfiles;
done_testing;
