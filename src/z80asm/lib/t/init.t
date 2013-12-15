#!/usr/bin/perl

# Copyright (C) Paulo Custodio, 2011-2013
#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/t/Attic/init.t,v 1.1 2013-12-15 23:31:04 pauloscustodio Exp $
#
# Test init.h

use Modern::Perl;
use Test::More;
use File::Slurp;
use Capture::Tiny 'capture';

my $compile = "cc -Wall -otest test.c die.c";

# init / fini
write_file("test.c", <<'END');
#include "init.h"

DEFINE_init()
{
	init();			/* mistake, caught by setting initialized before running code */
	warn("init called\n");
}

DEFINE_fini()
{
	init();			/* mistake, caught by setting initialized before running code */
	warn("fini called\n");
}

void func1(void)
{
	init();
	warn("func1 called\n");
}
	
void func2(void)
{
	init();
	warn("func2 called\n");
}
	
int main()
{
	warn("main started\n");
	func1();
	func2();
	func1();
	func2();
	warn("main finished\n");
	return 0;
}
END
ok !system $compile;
is_deeply [capture {system "test"}], ["", <<'ERR', 0];
main started
init called
func1 called
func2 called
func1 called
func2 called
main finished
fini called
ERR


unlink <test.*>;
done_testing;


# $Log: init.t,v $
# Revision 1.1  2013-12-15 23:31:04  pauloscustodio
# Replace code-generation for init() functions by macros in init.h
# to help define init() and fini() functions per module.
# Code generation complicates maintenance, as all the modules with init()
# functions are coupled together, and it may not be clear how the init()
# module appears.
#
# Revision 1.2  2013/12/15 13:18:35  pauloscustodio
# Move memory allocation routines to lib/xmalloc, instead of glib,
# introduce memory leak report on exit and memory fence check.
#
# Revision 1.1  2013/12/15 04:02:26  pauloscustodio
# Move the die and queue modules to the z80asm/lib directory
#
# Revision 1.9  2013/09/09 00:20:45  pauloscustodio
# Add default set of modules to t_compile_module:
# -DMEMALLOC_DEBUG xmalloc.c die.o except.o strpool.o
#
# Revision 1.8  2013/09/01 00:18:30  pauloscustodio
# - Replaced e4c exception mechanism by a much simpler one based on a few
#   macros. The former did not allow an exit(1) to be called within a
#   try-catch block.
#
# Revision 1.7  2013/01/20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.6  2012/06/14 15:01:27  pauloscustodio
# Split safe strings from strutil.c to safestr.c
#
# Revision 1.5  2012/05/26 18:50:26  pauloscustodio
# Use .o instead of .c to build test program, faster compilation.
# Use gcc to compile instead of cc.
#
# Revision 1.4  2012/05/22 20:33:34  pauloscustodio
# Added tests
#
# Revision 1.3  2012/05/20 06:32:50  pauloscustodio
# Added tests
#
# Revision 1.2  2012/05/20 05:52:10  pauloscustodio
# Test raising exception in die
#
# Revision 1.1  2012/05/17 15:04:47  pauloscustodio
# white box test of new modules
