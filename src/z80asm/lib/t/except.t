#!/usr/bin/perl

# Copyright (C) Paulo Custodio, 2011-2014
#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/t/Attic/except.t,v 1.5 2014-07-02 23:45:12 pauloscustodio Exp $
#
# Test except.c

use Modern::Perl;
use Test::More;
use File::Slurp;
use Capture::Tiny 'capture';
use Test::Differences; 

my $compile = "cc -Wall -otest test.c except.c";

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
system($compile) and die "compile failed: $compile\n";

# THROW outside of TRY
t_capture("./test 0", "", <<'ERR', 1);
Throw without try
Uncaught runtime exception at test.c(13)
ERR

# run FatalErrorException
t_capture("./test 1", "", <<'ERR', 0);
Before try
In try
Throw FatalErrorException
Finally, THROWN() = 3
End of main
ERR

# run AssertionException
t_capture("./test 2", "", <<'ERR', 0);
Before try
In try
Throw AssertionException
Caught AssertionException
Finally, THROWN() = 2
End of main
ERR

# run second-level try and rethrow
t_capture("./test 3", "", <<'ERR', 0);
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

sub t_capture {
	my($cmd, $exp_out, $exp_err, $exp_exit) = @_;
	my $line = "[line ".((caller)[2])."]";
	ok 1, "$line command: $cmd";
	
	my($out, $err, $exit) = capture { system $cmd; };
	eq_or_diff_text $out, $exp_out, "$line out";
	eq_or_diff_text $err, $exp_err, "$line err";
	ok !!$exit == !!$exp_exit, "$line exit";
}
