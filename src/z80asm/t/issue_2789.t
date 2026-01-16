#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

chdir "t/2789/build";
my $cmd = path("build.sh")->slurp;
chomp($cmd);
ok 0==system($cmd);
chdir "../../..";

unlink "t/2789/arch/file2.asm";
unlink_testfiles;
done_testing;
