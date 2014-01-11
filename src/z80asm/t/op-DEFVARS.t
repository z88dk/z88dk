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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/op-DEFVARS.t,v 1.3 2014-01-11 01:29:46 pauloscustodio Exp $
# $Log: op-DEFVARS.t,v $
# Revision 1.3  2014-01-11 01:29:46  pauloscustodio
# Extend copyright to 2014.
# Move CVS log to bottom of file.
#
# Revision 1.2  2013/04/01 22:03:20  pauloscustodio
# Add conditional assembly tests
#
# Revision 1.1  2013/03/06 00:03:05  pauloscustodio
# Test DEFVARS
#
#
# Test DEFVARS

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

t_z80asm(
	asm		=> "
				defc base = 0x1000
				defvars base 
				{
					f1		ds.b 100
					f2		ds.w 1
					f3		ds.p 1
					f4		ds.l 1
					f5
				}
				
				defw f1, f2, f3, f4, f5
				
				defvars 0 {
					f6		ds.b 1
					f7		ds.b 1
					f8
				}
				
				defw f6, f7, f8
				
				defvars -1		; continue after f5
				{
					f9		ds.l 1
					f10		ds.l 1
					f11
				}
				
				defw f9, f10, f11
				
				",
	bin 	=>	pack("v*", 
						0x1000, 				# f1
						0x1000+100, 			# f2
						0x1000+100+2, 			# f3
						0x1000+100+2+3,			# f4
						0x1000+100+2+3+4,		# f5
						0,						# f6
						0+1,					# f7
						0+1+1,					# f8
						0x1000+100+2+3+4,		# f9
						0x1000+100+2+3+4+4,		# f10
						0x1000+100+2+3+4+4+4,	# f11
				),
);

# check with conditional assembly
t_z80asm(
	asm		=> "
				if 0
					defc base = 0x1000
					defvars base 
					{
						f1		ds.b 100
						f2
					}
				else
					defc base = 0x1000
					defvars base 
					{
						f1		ds.b 200
						f2
					}
				endif

				defw f1, f2
				
				",
	bin 	=>	pack("v*", 
						0x1000, 				# f1
						0x1000+200, 			# f2
				),
);

unlink_testfiles();
done_testing();
