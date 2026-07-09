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

    my $count = 0;
    my $obj   = ObjModule->new;
    $obj->name("module1");
    $obj->version($version);

    if ( $version >= 5 ) {
        my $section = ObjSection->new;
        $section->name("section1");
        $obj->sections->add($section);
    }

    for my $scope_id ( ObjSymbolScope::min_id .. ObjSymbolScope::max_id ) {
        next if $scope_id == 0;
        my $scope = ObjSymbolScope::lookup_name($scope_id);

        for my $type_id ( ObjSymbolType::min_id .. ObjSymbolType::max_id ) {
            next if $type_id == 0;
            my $type = ObjSymbolType::lookup_name($type_id);

            my $symbol = ObjSymbol->new;
            $symbol->scope($scope);
            $symbol->type($type);

            if ( $version >= 5 ) {
                $symbol->section("section1");
            }

            $symbol->value(0x1234);

            my $name = "x" . ( ++$count );
            $symbol->name($name);

            if ( $version >= 9 ) {
                $symbol->file("file1.asm");
                $symbol->line(123);
            }

            $obj->symbols->add($symbol);
        }
    }

    check_obj(
        $obj,
        "$dir/expected/${self}_v${version_str}.def",
        "$dir/expected/${self}_v${version_str}.txt"
    );
}

unlink_testfiles;
done_testing;
