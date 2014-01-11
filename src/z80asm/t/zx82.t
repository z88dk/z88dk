#!/usr/bin/perl

#     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
#   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
#                ZZZZZ      888           888  0000         0000
#              ZZZZZ        88888888888888888  0000         0000
#            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
#          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
#        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
#      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
#    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
#  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM
#
# Copyright (C) Paulo Custodio, 2011-2014

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/zx82.t,v 1.5 2014-01-11 01:29:46 pauloscustodio Exp $
#
# Build ZX Spectrum 48K ROM, compare result

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

my $src = 	  "t/data/zx48.asm";
my $bmk_bin = 	  "t/data/zx48.rom";
my $patched_src = "zx48.asm";
my $err = 	  "zx48.err";
my $obj = 	  "zx48.obj";
my $bin = 	  "zx48.bin";
my $map = 	  "zx48.map";
my $sym = 	  "zx48.sym";
my $project =	  "t/data/zx48_01.prj";

# get project files
my @prj_src = split(' ', scalar(read_file($project)));
my @prj_err = @prj_src; for (@prj_err) { s/\.asm$/.err/i }
my @prj_obj = @prj_src; for (@prj_obj) { s/\.asm$/.obj/i }
my @prj_sym = @prj_src; for (@prj_sym) { s/\.asm$/.sym/i }
my $prj_bin = $prj_src[0]; $prj_bin =~ s/\.asm$/.bin/i;
my $prj_map = $prj_src[0]; $prj_map =~ s/\.asm$/.map/i;

my @testfiles = ($patched_src, $err, $obj, $bin, $map, $sym,
		 @prj_err, @prj_obj, @prj_sym, $prj_bin, $prj_map);
unlink_testfiles(@testfiles);

# patch original source to comply with z80asm syntax
# Note: this step should not be required
ok open(my $in_src, "<", $src), "open $src";
ok open(my $out_src, ">", $patched_src), "open $patched_src";
while (<$in_src>) {
    s/^(\#(define|end))/;$1/;
    s/^(ORG)/\t$1/i;
    s/^([a-z]\w*) /$1:/i;
    s/(?<![\w\'])\$(?![\w\'])/ASMPC/;
    s/%([01]+)/\@$1/;

    # ASMPC cannot be used in second expression of DEFB, see BUG_0011.t
    s/(L\w+-ASMPC)-1/$1/;

    print $out_src $_;
}
ok close($in_src), "close $src";
ok close($out_src), "close $patched_src";

# assemble as one source file
t_z80asm_capture("-r0 -b $patched_src", "", "", 0);
ok ! -f $err, "no $err";
ok -f $obj, "$obj exists";
ok -f $bin, "$bin exists";
t_binary(read_binfile($bin),
	 read_binfile($bmk_bin));

# assemble with separate modules
t_z80asm_capture("-r0 -b \@$project", "", "", 0);
for (@prj_err) { ok ! -f $_, "no $_"; }
for (@prj_obj) { ok -f $_, "$_ exists"; }
ok -f $prj_bin, "$prj_bin exists";
t_binary(read_binfile($prj_bin),
	 read_binfile($bmk_bin));

unlink_testfiles(@testfiles);
done_testing();
