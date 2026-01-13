#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

my $config = slurp("../config.h");
my($version) = $config =~ /Z88DK_VERSION\s*"(.*)"/;
ok $version, "version $version";

capture_ok("z88dk-z80asm -h", <<END . slurp("t/help.txt"));
Z80 Macro Assembler $version
(c) InterLogic 1993-2009, Paulo Custodio 2011-2026

END

capture_nok("z88dk-z80asm -h=x", <<END);
error: illegal option: -h=x
END

# make sure help fist in 80 columns
ok open(my $fh, "<", __FILE__), "open ".__FILE__;
while (<$fh>) {
    next if /^\s*\#/;
    chomp;
    if (length($_) > 80) {
        ok 0, "line $. longer than 80 chars";
    }
}

unlink_testfiles;
done_testing;
