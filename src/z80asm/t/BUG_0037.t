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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/BUG_0037.t,v 1.2 2014-01-11 01:29:46 pauloscustodio Exp $
# $Log: BUG_0037.t,v $
# Revision 1.2  2014-01-11 01:29:46  pauloscustodio
# Extend copyright to 2014.
# Move CVS log to bottom of file.
#
# Revision 1.1  2013/06/15 22:10:01  pauloscustodio
# BUG_0037 : Symbol already defined error when symbol used in IF expression
#
# Revision 1.1  2013/06/10 23:11:33  pauloscustodio
# CH_0023 : Remove notdecl_tab
#
#

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

my $asm = "
			IF !NEED_floatpack
				DEFINE	NEED_floatpack
			ENDIF
			defb NEED_floatpack
";
my $bin = "\x01";

t_z80asm(
	asm		=> $asm,
	bin		=> $bin,
);

t_z80asm(
	asm		=> $asm,
	bin		=> $bin,
	options	=> "-DNEED_floatpack",
);

unlink_testfiles();
done_testing();
