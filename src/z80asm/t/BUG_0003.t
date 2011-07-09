#!/usr/bin/perl

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/BUG_0003.t,v 1.2 2011-07-09 17:36:09 pauloscustodio Exp $
# $Log: BUG_0003.t,v $
# Revision 1.2  2011-07-09 17:36:09  pauloscustodio
# Copied cvs log into $Log$ history
#
# Revision 1.1  2011/07/09 01:02:45  pauloscustodio
# Started to build test suite in t/ *.t unsing Perl prove. Included test for all standard
# Z80 opcodes; need to be extended with directives and opcodes for Z80 variants.
#
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
