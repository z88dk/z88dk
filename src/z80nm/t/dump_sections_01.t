#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;
use FindBin;
use lib "$FindBin::Bin/../../z80asm/z80asm2/tools";
use ObjModule;
use Data::Dump 'dump';

my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");

my @test_versions = (Obj::min_version .. Obj::max_version);
if ($ENV{TEST_VERSION}) {
	@test_versions = ( 0+$ENV{TEST_VERSION} );
}

for my $version ( @test_versions ) {
    my $version_str = sprintf "%02d", $version;

    my $obj = ObjModule->new;
    $obj->name("module1");
    $obj->version($version);

    # empty section
    if ( $version >= 5 ) {
        my $section = ObjSection->new;
        $obj->sections->add($section);
    }

    check_obj(
        $obj,
        "$dir/expected/${self}_v${version_str}.def",
        "$dir/expected/${self}_v${version_str}.txt"
    );
}

unlink_testfiles;
done_testing;
