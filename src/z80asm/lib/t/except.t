#!/usr/bin/perl

# Copyright (C) Paulo Custodio, 2011-2013
#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/t/Attic/except.t,v 1.1 2013-12-15 20:30:39 pauloscustodio Exp $
#
# Test except.c

use Modern::Perl;
use Test::More;
use File::Slurp;
use Capture::Tiny 'capture';

my $compile = "cc -Wall -otest test.c except.c die.c";

# compile
write_file("test.c", <<'END');
#include "except.h"
#include <stdlib.h>
int main(int argc, char *argv[])
{
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
}
END
ok !system $compile;

# THROW outside of TRY
is_deeply [capture {system "test 0"}], ["", <<'ERR', 256];
Throw without try
Uncaught runtime exception at test.c(13)
ERR

# run FatalErrorException
is_deeply [capture {system "test 1"}], ["", <<'ERR', 0];
Before try
In try
Throw FatalErrorException
Finally, THROWN() = 3
End of main
ERR

# run AssertionException
is_deeply [capture {system "test 2"}], ["", <<'ERR', 0];
Before try
In try
Throw AssertionException
Caught AssertionException
Finally, THROWN() = 2
End of main
ERR

# run second-level try and rethrow
is_deeply [capture {system "test 3"}], ["", <<'ERR', 0];
Before try
In try
In test 3, new try
in internal try, throw FatalErrorException
Caught FatalErrorException
Inner Finally, THROWN() = 3
Caught AssertionException
Finally, THROWN() = 2
End of main
ERR

unlink <test.*>;
done_testing;


# $Log: except.t,v $
# Revision 1.1  2013-12-15 20:30:39  pauloscustodio
# Move except.c to the z80asm/lib directory
#
# Revision 1.11  2013/12/15 13:18:35  pauloscustodio
# Move memory allocation routines to lib/xmalloc, instead of glib,
# introduce memory leak report on exit and memory fence check.
#
# Revision 1.10  2013/09/09 00:20:45  pauloscustodio
# Add default set of modules to t_compile_module:
# -DMEMALLOC_DEBUG xmalloc.c die.o except.o strpool.o
#
# Revision 1.9  2013/09/08 00:40:10  pauloscustodio
# Changed format of output file name and line number in case of fatal error
#
# Revision 1.8  2013/09/01 11:52:55  pauloscustodio
# Setup xmalloc on init.c.
# Setup GLib memory allocation functions to use xmalloc functions.
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
