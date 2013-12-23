#!/usr/bin/perl

# Copyright (C) Paulo Custodio, 2011-2013
#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/t/Attic/die.t,v 1.3 2013-12-23 19:19:52 pauloscustodio Exp $
#
# Test die.c

use Modern::Perl;
use Test::More;
use File::Slurp;
use Capture::Tiny 'capture';
use Test::Differences; 

my $compile = "cc -Wall -otest test.c die.c";

# warn / die
write_file("test.c", <<'END');
#include "die.h"
int main()
{
	warn("Hello %s\n", "John");
	die("Bye %s\n", "John");
	warn("Hello %s\n", "Doe");
	return 0;
}
END
system($compile) and die "compile failed: $compile\n";
t_capture("test", "", <<'ERR', 1);
Hello John
Bye John
ERR


# xatexit
write_file("test.c", <<'END');
#include "die.h"
void fini1(void)
{
	warn("fini1\n");
}
void fini2(void)
{
	warn("fini2\n");
}
int main()
{
	xatexit(fini1);
	xatexit(fini2);
	warn("end\n");
	return 0;
}
END
system($compile) and die "compile failed: $compile\n";
t_capture("test", "", <<'ERR', 0);
end
fini2
fini1
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

# $Log: die.t,v $
# Revision 1.3  2013-12-23 19:19:52  pauloscustodio
# Show difference in command output in case of test failure
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
