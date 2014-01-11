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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/op-DEFGROUP.t,v 1.3 2014-01-11 01:29:46 pauloscustodio Exp $
# $Log: op-DEFGROUP.t,v $
# Revision 1.3  2014-01-11 01:29:46  pauloscustodio
# Extend copyright to 2014.
# Move CVS log to bottom of file.
#
# Revision 1.2  2013/04/01 22:03:20  pauloscustodio
# Add conditional assembly tests
#
# Revision 1.1  2013/03/06 00:02:17  pauloscustodio
# 	BUG_0032 : DEFGROUP ignores name after assignment
# 		The code
# DEFGROUP {
#   f10 = 10, f11
# }
# did not define f11 - all text after the expression was discarded.
#
#
# Test DEFVARS

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

t_z80asm(
	asm		=> "
				defgroup 
				{ 
					f0, f1, 
					f2, f3, 
					f10 = 10, 
					f11, 
					f20 = 20, 
					f21 
				}
				
				defw f0, f1, f2, f3, f10, f11, f20, f21
				
				",
	bin 	=>	pack("v*", 
						0, 1,
						2, 3,
						10, 11,
						20, 21
				),
);

# BUG_0032
t_z80asm(
	asm		=> "
				defgroup { 
					f10 = 10, f11
				}
				
				defw f10, f11
				
				",
	bin 	=>	pack("v*", 
						10, 11,
				),
);

# check with conditional assembly
t_z80asm(
	asm		=> "
				if 1
					defgroup 
					{ 
						ff = 1
					}
				else
					defgroup 
					{
						ff = 2
					}
				endif
				
				if 0
					defgroup 
					{ 
						fg = 1
					}
				else
					defgroup 
					{
						fg = 2
					}
				endif
				
				defw ff, fg
				
				",
	bin 	=>	pack("v*", 
						1, 2
				),
);


unlink_testfiles();
done_testing();
