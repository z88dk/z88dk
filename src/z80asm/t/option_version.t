#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# no arguments
unlink_testfiles;
capture_ok("z88dk-z80asm", get_copyright()."\n");

unlink_testfiles;
done_testing;

# get version and date from hist.c
sub get_copyright {
	my $hist = slurp("src/c/hist.c");
	my($copyright) = $hist =~ /\#define \s+ COPYRIGHT \s+ \" (.*?) \"/x or die;

	my $config = slurp("../config.h");
	my($version) = $config =~ /\#define \s+ Z88DK_VERSION \s+ \" (.*?) \" /x or die;

	my $copyrightmsg = "Z80 Macro Assembler ".$version."\n(c) ".$copyright;

	return $copyrightmsg;
}

