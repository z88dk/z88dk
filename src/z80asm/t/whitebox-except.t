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
# Copyright (C) Paulo Custodio, 2011-2012

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-except.t,v 1.5 2012-06-14 15:01:27 pauloscustodio Exp $
# $Log: whitebox-except.t,v $
# Revision 1.5  2012-06-14 15:01:27  pauloscustodio
# Split safe strings from strutil.c to safestr.c
#
# Revision 1.4  2012/05/26 18:50:26  pauloscustodio
# Use .o instead of .c to build test program, faster compilation.
# Use gcc to compile instead of cc.
#
# Revision 1.3  2012/05/22 20:33:34  pauloscustodio
# Added tests
#
# Revision 1.2  2012/05/20 05:53:01  pauloscustodio
# Test raising RuntimeException and AssertionException
#
# Revision 1.1  2012/05/17 15:04:47  pauloscustodio
# white box test of new modules
#
# Test exceptions

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

my $objs = "die.o strutil.o safestr.o";
ok ! system "make $objs";
my $compile = "-DEXCEPT_DEBUG except.c $objs";

# compile
t_compile_module('', <<'END', $compile);
	int test;
	
	if (argc != 2) 				return 1;
	test = atoi(argv[1]);
	
	init_except();
	warn("1\n");	
	try	{
		warn("2\n");	
		if (test == 1) {
			throw(FatalErrorException, "Error");
		}
		else {
			throw(AssertionException, "Error");
		}
		warn("3\n");	
	}
	catch (RuntimeException)
	{
		warn("4\n");	
	}
	finally 
	{
		warn("5\n");	
	}
	warn("6\n");	
	return 0;
END


# run FatalErrorException
t_run_module([1], "", <<ERR, 0);
except: init
1
2
4
5
6
except: cleanup
ERR


# run AssertionException - cannot be caught
t_run_module([2], "", <<ERR, 1);
except: init
1
2
5


Uncaught AssertionException: Error

    thrown at main (test.c:0)

The value of errno was 0.

Exception hierarchy
________________________________________________________________

    AssertionException
________________________________________________________________
except: cleanup
ERR


unlink_testfiles();
done_testing;
