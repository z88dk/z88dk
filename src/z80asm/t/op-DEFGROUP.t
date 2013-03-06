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
# Copyright (C) Paulo Custodio, 2011-2013

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/op-DEFGROUP.t,v 1.1 2013-03-06 00:02:17 pauloscustodio Exp $
# $Log: op-DEFGROUP.t,v $
# Revision 1.1  2013-03-06 00:02:17  pauloscustodio
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

unlink_testfiles();
done_testing();
