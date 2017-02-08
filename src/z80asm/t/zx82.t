#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Build ZX Spectrum 48K ROM, compare result

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

my $src = 	  "t/data/zx48.asm";
my $bmk_bin = "t/data/zx48.rom";
my $patched_src = "zx48.asm";
my $err = 	  "zx48.err";
my $obj = 	  "zx48.o";
my $bin = 	  "zx48.bin";
my $reloc =	  "zx48.reloc";
my $map = 	  "zx48.map";
my $sym = 	  "zx48.sym";
my $project =	  "t/data/zx48_01.prj";

# get project files
my @prj_src = split(' ', scalar(read_file($project)));
my @prj_err = @prj_src; for (@prj_err) { s/\.asm$/.err/i }
my @prj_obj = @prj_src; for (@prj_obj) { s/\.asm$/.o/i }
my @prj_sym = @prj_src; for (@prj_sym) { s/\.asm$/.sym/i }
my $prj_bin = $prj_src[0]; $prj_bin =~ s/\.asm$/.bin/i;
my $prj_reloc = $prj_src[0]; $prj_reloc =~ s/\.asm$/.reloc/i;
my $prj_map = $prj_src[0]; $prj_map =~ s/\.asm$/.map/i;

my @testfiles = ($patched_src, $err, $obj, $bin, $reloc, $map, $sym,
		 @prj_err, @prj_obj, @prj_sym, $prj_bin, $prj_reloc, $prj_map);
unlink_testfiles(@testfiles);

# patch original source to comply with z80asm syntax
# Note: this step should not be required
ok open(my $in_src, "<", $src), "open $src";
ok open(my $out_src, ">", $patched_src), "open $patched_src";
while (<$in_src>) {
    s/^(\#(define|end))/;$1/;
    s/ORG\s+\$3D00//;
	s/^(ORG)/\t$1/i;
    s/^([a-z]\w*) /$1:/i;
    s/(?<![\w\'])\$(?![\w\'])/ASMPC/;
    s/%([01]+)/\@$1/;

    print $out_src $_;
}
ok close($in_src), "close $src";
ok close($out_src), "close $patched_src";

# assemble as one source file
t_z80asm_capture("-b $patched_src", "", "", 0);
ok ! -f $err, "no $err";
ok -f $obj, "$obj exists";
ok -f $bin, "$bin exists";
t_binary(read_binfile($bin),
	 read_binfile($bmk_bin));

# assemble with separate modules
t_z80asm_capture("-b \@$project", "", "", 0);
for (@prj_err) { ok ! -f $_, "no $_"; }
for (@prj_obj) { ok -f $_, "$_ exists"; }
ok -f $prj_bin, "$prj_bin exists";
t_binary(read_binfile($prj_bin),
	 read_binfile($bmk_bin));

unlink_testfiles(@testfiles);
done_testing();
