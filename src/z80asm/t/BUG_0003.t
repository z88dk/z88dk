#!perl

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/BUG_0003.t,v 1.1 2011-07-09 01:02:45 pauloscustodio Exp $
# Test correction of BUG_0003, see hist.c for description

use strict;
use warnings;
use Capture::Tiny::Extended 'capture';
use Test::More;
require 't/test_utils.pl';

write_file(asm_file(), "");
my($stdout, $stderr, $return) = capture {
	system z80asm()." -Zillegaloption ".asm_file();
};
is $stdout, "", "stdout";
is $stderr, "Illegal option\n1 errors occurred during assembly\n", "stderr";
ok $return != 0, "retval";

unlink_testfiles();
done_testing();
