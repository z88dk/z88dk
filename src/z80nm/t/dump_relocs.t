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

    next unless $version >= 19;

    my $obj = ObjModule->new;
    $obj->name("module1");
    $obj->version($version);

    for my $range_type_id ( ObjRangeType::min_id .. ObjRangeType::max_id ) {
        my $range_type_name = ObjRangeType::lookup_name($range_type_id);
        next if $range_type_name eq "Undefined";   # end marker, not a real type
        next if $range_type_name eq "Assignment";  # nonsense for relocation
        next if $range_type_name eq "JrOffset";    # nonsense for relocation
        next if $range_type_name eq "JreOffset";   # nonsense for relocation

        my $reloc = ObjReloc->new;
        $reloc->type($range_type_name);
        $reloc->symbol("x");
        $reloc->addend(0x1234);
        $reloc->section("section1");
        $reloc->patch_ptr(0x1234);
        $reloc->file("file1.asm");
        $reloc->line(123);

        $obj->relocs->add($reloc);
    }

    check_obj(
        $obj,
        "$dir/expected/${self}_v${version_str}.def",
        "$dir/expected/${self}_v${version_str}.txt"
    );
}

unlink_testfiles;
done_testing;
