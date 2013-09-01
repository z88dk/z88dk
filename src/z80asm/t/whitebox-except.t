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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-except.t,v 1.8 2013-09-01 11:52:55 pauloscustodio Exp $
# $Log: whitebox-except.t,v $
# Revision 1.8  2013-09-01 11:52:55  pauloscustodio
# Setup memalloc on init.c.
# Setup GLib memory allocation functions to use memalloc functions.
#
# Revision 1.7  2013/09/01 00:18:30  pauloscustodio
# - Replaced e4c exception mechanism by a much simpler one based on a few
#   macros. The former did not allow an exit(1) to be called within a
#   try-catch block.
#
# Revision 1.6  2013/01/20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.5  2012/06/14 15:01:27  pauloscustodio
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

my $objs = "die.o strutil.o safestr.o except.o";
ok ! system "make $objs";

# compile
t_compile_module('', <<'END', $objs);
	int test;
	
	if (argc != 2) 				return 1;
	test = atoi(argv[1]);
	
	if (test == 0)
	{
		warn("Throw without try\n");
		THROW(RuntimeException);
	}
	else 
	{
		warn("Before try\n");	
		TRY	{
			warn("In try\n");	
			if (test == 1) {
				warn("Throw FatalErrorException\n");
				THROW(FatalErrorException);
			}
			else if (test == 2) {
				warn("Throw AssertionException\n");
				THROW(AssertionException);
			}
			else {
				warn("In test 3, new try\n");
				TRY
				{
					warn("in internal try, throw FatalErrorException\n");
					THROW(FatalErrorException);
					warn("not reached\n");
				}
				CATCH(FatalErrorException)
				{
					warn("Caught FatalErrorException\n");	
					RETHROW(AssertionException);
					warn("Has re-thrown\n");
				}
				FINALLY
				{
					warn("Inner Finally, THROWN() = %d\n", THROWN() );
				}
				ETRY;
				warn("not reached\n");
			}				
			warn("End of try\n");	
		}
		CATCH (RuntimeException)
		{
			warn("Caught RuntimeException\n");	
		}
		CATCH (AssertionException)
		{
			warn("Caught AssertionException\n");	
		}
		FINALLY 
		{
			warn("Finally, THROWN() = %d\n", THROWN() );
		}
		ETRY;
	}
	warn("End of main\n");	
	return 0;
END


# THROW outside of TRY
t_run_module([0], "", <<END, 1);
Throw without try
Uncaught runtime exception at file test.c line 66
END


# run FatalErrorException
t_run_module([1], "", <<END, 0);
Before try
In try
Throw FatalErrorException
Finally, THROWN() = 3
End of main
END

# run AssertionException
t_run_module([2], "", <<END, 0);
Before try
In try
Throw AssertionException
Caught AssertionException
Finally, THROWN() = 2
End of main
END

# run second-level try and rethrow
t_run_module([3], "", <<END, 0);
Before try
In try
In test 3, new try
in internal try, throw FatalErrorException
Caught FatalErrorException
Inner Finally, THROWN() = 3
Caught AssertionException
Finally, THROWN() = 2
End of main
END

unlink_testfiles();
done_testing;
