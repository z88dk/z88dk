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

    # library with two modules
    my $lib = ObjLibrary->new;
    $lib->version($version);

    for my $m ( 1 .. 2 ) {
        my $obj = ObjModule->new;
        $obj->version($version);
        $obj->name("module$m");

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

    check_obj(
        $lib,
        "$dir/expected/${self}_v${version_str}.def",
        "$dir/expected/${self}_v${version_str}.txt"
    );
}

unlink_testfiles;
done_testing;
