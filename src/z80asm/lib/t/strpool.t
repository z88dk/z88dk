#!/usr/bin/perl

# Copyright (C) Paulo Custodio, 2011-2013
#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/t/Attic/strpool.t,v 1.2 2013-12-23 19:19:52 pauloscustodio Exp $
#
# Test strpool.c

use Modern::Perl;
use Test::More;
use File::Slurp;
use Capture::Tiny 'capture';
use Test::Differences; 

my $compile = "cc -Wall -DSTRPOOL_DEBUG -otest test.c strpool.c die.c xmalloc.c";

write_file("test.c", <<'END');
#include "die.h"
#include "strpool.h"
#include <stdio.h>
#include <string.h>

struct strings {
	char *source, *pool;
}
strings[] = {
	{ "HELLO",	NULL },
	{ "WORLD",	NULL },
	{ NULL,		NULL },
};

#define ERROR return __LINE__

int main()
{
	char *pool;
	int i;
	
	warn("first run - create pool for all strings\n");
	for (i = 0; strings[i].source; i++) {
		pool = strpool_add(strings[i].source);
		if (pool == NULL) ERROR;
		if (pool == strings[i].source) ERROR;
		if (strcmp(strings[i].source, pool)) ERROR;
		strings[i].pool = pool;
	}
	
	warn("second run - check that pool did not move\n");
	for (i = 0; strings[i].source; i++) {
		pool = strpool_add(strings[i].source);
		if (pool == NULL) ERROR;
		if (pool == strings[i].source) ERROR;
		if (strcmp(strings[i].source, pool)) ERROR;
		if (pool != strings[i].pool) ERROR;
	}
	
	warn("check NULL case\n");
	pool = strpool_add(NULL);
	if (pool != NULL) ERROR;
	
	warn("end\n");
	return 0;
}
END
system($compile) and die "compile failed: $compile\n";

t_capture("test", "", <<'ERR', 0);
first run - create pool for all strings
strpool: add HELLO
strpool: add WORLD
second run - check that pool did not move
check NULL case
end
strpool: free HELLO
strpool: free WORLD
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

# $Log: strpool.t,v $
# Revision 1.2  2013-12-23 19:19:52  pauloscustodio
# Show difference in command output in case of test failure
#
# Revision 1.1  2013/12/18 01:46:22  pauloscustodio
# Move strpool.c to the z80asm/lib directory
#
# Revision 1.11  2013/12/15 13:18:35  pauloscustodio
# Move memory allocation routines to lib/xmalloc, instead of glib,
# introduce memory leak report on exit and memory fence check.
#
# Revision 1.10  2013/09/09 00:20:45  pauloscustodio
# Add default set of modules to t_compile_module:
# -DMEMALLOC_DEBUG xmalloc.c die.o except.o strpool.o
#
# Revision 1.9  2013/09/08 00:43:59  pauloscustodio
# New error module with one error function per error, no need for the error
# constants. Allows compiler to type-check error message arguments.
# Included the errors module in the init() mechanism, no need to call
# error initialization from main(). Moved all error-testing scripts to
# one file errors.t.
#
# Revision 1.8  2013/09/01 16:51:26  pauloscustodio
# Replaced strpool code by GLib String Chunks.
#
# Revision 1.7  2013/09/01 11:52:56  pauloscustodio
# Setup xmalloc on init.c.
# Setup GLib memory allocation functions to use xmalloc functions.
#
# Revision 1.6  2013/03/30 00:00:26  pauloscustodio
# Accept special case NULL in strpool_add, return NULL
#
# Revision 1.5  2013/01/20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.4  2013/01/19 01:33:16  pauloscustodio
# Clean-up strpool code
#
# Revision 1.3  2012/06/14 15:01:27  pauloscustodio
# Split safe strings from strutil.c to safestr.c
#
# Revision 1.2  2012/05/26 18:50:26  pauloscustodio
# Use .o instead of .c to build test program, faster compilation.
# Use gcc to compile instead of cc.
#
# Revision 1.1  2012/05/24 17:50:02  pauloscustodio
# CH_0010 : new string pool to hold strings for all program duration
#
# Revision 1.1  2012/05/24 17:16:28  pauloscustodio
# CH_0009 : new CLASS to define simple classes

