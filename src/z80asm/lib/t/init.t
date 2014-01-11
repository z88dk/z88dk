#!/usr/bin/perl

# Copyright (C) Paulo Custodio, 2011-2014
#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/t/Attic/init.t,v 1.4 2014-01-11 01:29:41 pauloscustodio Exp $
#
# Test init.h

use Modern::Perl;
use Test::More;
use File::Slurp;
use Capture::Tiny 'capture';
use Test::Differences; 

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
system($compile) and die "compile failed: $compile\n";
t_capture("test", "", <<'ERR', 0);
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

sub t_capture {
	my($cmd, $exp_out, $exp_err, $exp_exit) = @_;
	my $line = "[line ".((caller)[2])."]";
	ok 1, "$line command: $cmd";
	
	my($out, $err, $exit) = capture { system $cmd; };
	eq_or_diff_text $out, $exp_out, "$line out";
	eq_or_diff_text $err, $exp_err, "$line err";
	ok !!$exit == !!$exp_exit, "$line exit";
}

# $Log: init.t,v $
# Revision 1.4  2014-01-11 01:29:41  pauloscustodio
# Extend copyright to 2014.
# Move CVS log to bottom of file.
#
# Revision 1.3  2013/12/24 17:43:19  pauloscustodio
# comment
#
# Revision 1.2  2013/12/23 19:19:52  pauloscustodio
# Show difference in command output in case of test failure
#
# Revision 1.1  2013/12/15 23:31:04  pauloscustodio
# Replace code-generation for init() functions by macros in init.h
# to help define init() and fini() functions per module.
# Code generation complicates maintenance, as all the modules with init()
# functions are coupled together, and it may not be clear how the init()
# module appears.
