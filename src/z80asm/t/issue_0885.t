#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/885
# z80asm: bug in application of all operators in defined constants in some circumstances

my $got_zsdcc = -f "../../bin/z88dk-zsdcc$Config{_exe}";

for my $clib ('sdcc_iy',		# zsdcc compile
	          'new',			# sccz80 compile
) {
	SKIP: {
		skip "z88dk-zsdcc not found, test skipped", 1 
			if ($clib eq 'sdcc_iy' && !$got_zsdcc);
        skip "only run with DEVELOPER=1", 1
            unless $ENV{DEVELOPER};			# fails in snapcraft tests
            
        unlink_testfiles;
        spew("${test}.c", <<END);
			void main(void)
			{
			__asm
			ici:
				DEFC toto = ici %8
			__endasm;
			}
END
		run_ok("zcc +zx -vn -clib=$clib -m --list ${test}.c -o ${test}");
        test_map("${test}.map");
    }
}


# core of the problem
unlink_testfiles;
my $org = 100;
spew("${test}.asm", <<'END');
._main
ici:
    DEFC toto = ici %8
    defw _main, ici, toto
END
capture_ok("z88dk-z80asm -m -b -r$org ${test}.asm", "");
check_bin_file("${test}.bin", words($org, $org, $org % 8));
test_map("${test}.map");


unlink_testfiles;
done_testing;

#------------------------------------------------------------------------------

sub read_map {
    my($map_file) = @_;
	local $Test::Builder::Level = $Test::Builder::Level + 1;

    ok -f $map_file, "$map_file exists";
    my %map;
    for (path($map_file)->lines) {
		/^(ici|toto|_main)\s*=\s*\$([0-9A-F]{4,})\b/ and $map{$1} = hex($2);
    }
    return %map;
}

sub test_map {
    my($map_file) = @_;
	local $Test::Builder::Level = $Test::Builder::Level + 1;

    my %map = read_map($map_file);
    ok $map{ici}==$map{_main}, "$map{ici}==$map{_main}";
    ok $map{toto}==$map{ici} % 8, "$map{toto}==$map{ici} % 8";
}
