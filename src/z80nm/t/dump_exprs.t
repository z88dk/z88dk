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

    if ( $version >= 5 ) {
        my $section = ObjSection->new;
        $section->name("section1");
        $obj->sections->add($section);
    }

    for my $expr_type_id ( ObjRangeType::min_id .. ObjRangeType::max_id ) {
        my $expr_type_name = ObjRangeType::lookup_name($expr_type_id);
        next if $expr_type_name eq "Undefined";    # end marker, not a real type
        next if $expr_type_name eq "Assignment" && $version < 7;

        my $expr = ObjExpr->new;
        $expr->type($expr_type_name);

        if ( $version >= 4 ) {
            $expr->file("file1.asm");
            $expr->line(123);
        }

        if ( $version >= 5 ) {
            $expr->section("section1");
        }

        if ( $version >= 3 ) {
            $expr->asmpc(0x1234);
        }

        $expr->patch_ptr( 0x1234 + 1 );

        if ( $version >= 17 ) {
            $expr->opcode_size(3);
        }

        if ( $expr_type_name eq "Assignment" ) {
            $expr->target_name("x");
            $expr->patch_ptr(0);
            $expr->opcode_size(0);
        }

        $expr->text("label1+123");

        $obj->exprs->add($expr);
    }

    check_obj(
        $obj,
        "$dir/expected/${self}_v${version_str}.def",
        "$dir/expected/${self}_v${version_str}.txt"
    );
}

unlink_testfiles;
done_testing;
