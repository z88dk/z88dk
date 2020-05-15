#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/885
# z80asm: bug in application of all operators in defined constants in some circumstances

use Modern::Perl;
use Test::More;
use Path::Tiny;
require './t/testlib.pl';

my $c_code = <<'END';
void main(void)
{
__asm
ici:
    DEFC toto = ici %8
__endasm;
}
END

for my $clib ('sdcc_iy',		# zsdcc compile
	      'new',			# sccz80 compile
) {
    ok 1, "-clib=$clib";

    unlink_testfiles();
    spew("test.c", $c_code);
    run("zcc +zx -vn -clib=$clib -m --list test.c -o test");
    test_map("test.map");
}

# core of the problem
my $org = 100;
unlink_testfiles();
spew("test.asm", <<'END');
._main
ici:
    DEFC toto = ici %8
    defw _main, ici, toto
END
run("z80asm -m -b -r$org test.asm");
check_bin_file("test.bin", pack("v*", $org, $org, $org % 8));
test_map("test.map");

unlink_testfiles();
done_testing();

sub read_map {
    my($map_file) = @_;
    ok -f $map_file, $map_file;
    my %map;
    for (path($map_file)->lines) {
	/^(ici|toto|_main)\s*=\s*\$([0-9A-F]{4,})\b/ and $map{$1} = hex($2);
    }
    return %map;
}

sub test_map {
    my($map_file) = @_;
    my %map = read_map($map_file);
    ok $map{ici}==$map{_main}, "$map{ici}==$map{_main}";
    ok $map{toto}==$map{ici} % 8, "$map{toto}==$map{ici} % 8";
}
