#!/usr/bin/perl

# Copyright (C) Paulo Custodio, 2011-2014
#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/t/Attic/xmalloc.t,v 1.8 2014-07-02 23:45:12 pauloscustodio Exp $
#
# Test xmalloc.c

use Modern::Perl;
use Test::More;
use File::Slurp;
use Capture::Tiny 'capture';
use Test::Differences; 

my $compile = "cc -Wall -DXMALLOC_DEBUG -otest test.c xmalloc.c";
my $nodebug = "cc -Wall -UXMALLOC_DEBUG -otest test.c xmalloc.c";


# no allocation
write_file("test.c", <<'END');
#include "xmalloc.h"
int main()
{
	return 0;
}
END
system($compile) and die "compile failed: $compile\n";
t_capture("./test", "", "", 0);


# allocate and no free no debug
write_file("test.c", <<'END');
#include "xmalloc.h"
int main()
{
	char * p1 = xmalloc(1);
	char * p2 = xmalloc(2);
	p1[0] = p2[0] = p2[1] = 0;
	if (memcmp(p1-4, "\xAA\xAA\xAA\xAA\0\xAA\xAA\xAA\xAA", 9) == 0 &&
	    memcmp(p2-4, "\xAA\xAA\xAA\xAA\0\0\xAA\xAA\xAA\xAA", 10) == 0)
		return 0;
	else 
		return 1;
}
END
system($nodebug) and die "compile failed: $nodebug\n";
t_capture("./test", "", <<'ERR', 0);
xmalloc xmalloc.c(108): leak (2) allocated at test.c(5)
xmalloc xmalloc.c(108): leak (1) allocated at test.c(4)
ERR


# alloc & no free, free in opposite order of alloc
write_file("test.c", <<'END');
#include "xmalloc.h"
int main()
{
	char *p1 = xmalloc(1);
	char *p2 = xmalloc(2);
	p1[0] = p2[0] = p2[1] = 0;
	if (memcmp(p1-4, "\xAA\xAA\xAA\xAA\0\xAA\xAA\xAA\xAA", 9)) return 1;
	if (memcmp(p2-4, "\xAA\xAA\xAA\xAA\0\0\xAA\xAA\xAA\xAA", 10)) return 2;
	return 0;
}
END
system($compile) and die "compile failed: $compile\n";
t_capture("./test", "", <<'ERR', 0);
xmalloc: init
xmalloc test.c(4): alloc (1)
xmalloc test.c(5): alloc (2)
xmalloc: cleanup
xmalloc xmalloc.c(108): leak (2) allocated at test.c(5)
xmalloc xmalloc.c(111): free (2) allocated at test.c(5)
xmalloc xmalloc.c(108): leak (1) allocated at test.c(4)
xmalloc xmalloc.c(111): free (1) allocated at test.c(4)
ERR


# alloc & free
write_file("test.c", <<'END');
#include "xmalloc.h"
int main()
{
	char *p1 = xmalloc(1);
	xfree(p1);
	if (p1) return 1;
	return 0;
}
END
system($compile) and die "compile failed: $compile\n";
t_capture("./test", "", <<'ERR', 0);
xmalloc: init
xmalloc test.c(4): alloc (1)
xmalloc test.c(5): free (1) allocated at test.c(4)
xmalloc: cleanup
ERR


# alloc failed - not portable to 64-bit
#write_file("test.c", <<'END');
##include "xmalloc.h"
#int main()
#{
#	xmalloc(0x80000000);
#	return 0;
#}
#END
#system($compile) and die "compile failed: $compile\n";
#t_capture("./test", "", <<'ERR', 1);
#xmalloc: init
#xmalloc test.c(4): alloc (2147483680) failed
#xmalloc: cleanup
#ERR


# unmatched block
write_file("test.c", <<'END');
#include "xmalloc.h"
int main()
{
	char p1[10], *p2 = p1;
	xfree(p2);
	return 0;
}
END
system($compile) and die "compile failed: $compile\n";
t_capture("./test", "", <<'ERR', 1);
xmalloc: init
xmalloc test.c(5): block not found
xmalloc: cleanup
ERR


# buffer underflow
write_file("test.c", <<'END');
#include "xmalloc.h"
int main()
{
	char *p1 = xmalloc(1);
	p1[-1] = 0;
	xfree(p1);
	return 0;
}
END
system($compile) and die "compile failed: $compile\n";
t_capture("./test", "", <<'ERR', 1);
xmalloc: init
xmalloc test.c(4): alloc (1)
xmalloc test.c(6): free (1) allocated at test.c(4)
xmalloc test.c(6): buffer underflow, allocated at test.c(4)
xmalloc: cleanup
ERR


# buffer overflow
write_file("test.c", <<'END');
#include "xmalloc.h"
int main()
{
	char *p1 = xmalloc(1);
	p1[1] = 0;
	xfree(p1);
	return 0;
}
END
system($compile) and die "compile failed: $compile\n";
t_capture("./test", "", <<'ERR', 1);
xmalloc: init
xmalloc test.c(4): alloc (1)
xmalloc test.c(6): free (1) allocated at test.c(4)
xmalloc test.c(6): buffer overflow, allocated at test.c(4)
xmalloc: cleanup
ERR


# xmalloc
write_file("test.c", <<'END');
#include "xmalloc.h"
int main()
{
	char *p1 = xmalloc(0);
	char *p2 = xmalloc(1);
	p2[0] = 0;
	if (memcmp(p1-4, "\xAA\xAA\xAA\xAA\xAA\xAA\xAA\xAA", 8)) return 1;
	if (memcmp(p2-4, "\xAA\xAA\xAA\xAA\0\xAA\xAA\xAA\xAA", 9)) return 2;
	return 0;
}
END
system($compile) and die "compile failed: $compile\n";
t_capture("./test", "", <<'ERR', 0);
xmalloc: init
xmalloc test.c(4): alloc (0)
xmalloc test.c(5): alloc (1)
xmalloc: cleanup
xmalloc xmalloc.c(108): leak (1) allocated at test.c(5)
xmalloc xmalloc.c(111): free (1) allocated at test.c(5)
xmalloc xmalloc.c(108): leak (0) allocated at test.c(4)
xmalloc xmalloc.c(111): free (0) allocated at test.c(4)
ERR


# xcalloc
write_file("test.c", <<'END');
#include "xmalloc.h"
int main()
{
	char *p1 = xcalloc(5, 1);
	if (memcmp(p1-4, "\xAA\xAA\xAA\xAA\0\0\0\0\0\xAA\xAA\xAA\xAA", 13))
		return 1;
	return 0;
}
END
system($compile) and die "compile failed: $compile\n";
t_capture("./test", "", <<'ERR', 0);
xmalloc: init
xmalloc test.c(4): alloc (5)
xmalloc: cleanup
xmalloc xmalloc.c(108): leak (5) allocated at test.c(4)
xmalloc xmalloc.c(111): free (5) allocated at test.c(4)
ERR


# xnew
write_file("test.c", <<'END');
#include "xmalloc.h"
int main()
{
	char *p1 = xnew(char);
	if (memcmp(p1-4, "\xAA\xAA\xAA\xAA\0\xAA\xAA\xAA\xAA", 9))
		return 1;
	return 0;
}
END
system($compile) and die "compile failed: $compile\n";
t_capture("./test", "", <<'ERR', 0);
xmalloc: init
xmalloc test.c(4): alloc (1)
xmalloc: cleanup
xmalloc xmalloc.c(108): leak (1) allocated at test.c(4)
xmalloc xmalloc.c(111): free (1) allocated at test.c(4)
ERR


# xnew_n
write_file("test.c", <<'END');
#include "xmalloc.h"
int main()
{
	char *p1 = xnew_n(char, 5);
	if (memcmp(p1-4, "\xAA\xAA\xAA\xAA\0\0\0\0\0\xAA\xAA\xAA\xAA", 13))
		return 1;
	return 0;
}
END
system($compile) and die "compile failed: $compile\n";
t_capture("./test", "", <<'ERR', 0);
xmalloc: init
xmalloc test.c(4): alloc (5)
xmalloc: cleanup
xmalloc xmalloc.c(108): leak (5) allocated at test.c(4)
xmalloc xmalloc.c(111): free (5) allocated at test.c(4)
ERR


# xrealloc - NULL input
write_file("test.c", <<'END');
#include "xmalloc.h"
int main()
{
	char *p1 = xrealloc(NULL, 2);
	p1[0] = p1[1] = 2;
	if (memcmp(p1-4, "\xAA\xAA\xAA\xAA\2\2\xAA\xAA\xAA\xAA", 10))
		return 1;
	return 0;
}
END
system($compile) and die "compile failed: $compile\n";
t_capture("./test", "", <<'ERR', 0);
xmalloc: init
xmalloc test.c(4): alloc (2)
xmalloc: cleanup
xmalloc xmalloc.c(108): leak (2) allocated at test.c(4)
xmalloc xmalloc.c(111): free (2) allocated at test.c(4)
ERR


# xrealloc - shrink
write_file("test.c", <<'END');
#include "xmalloc.h"
int main()
{
	char *p1 = xmalloc(2);
	p1[0] = p1[1] = 2;
	if (memcmp(p1-4, "\xAA\xAA\xAA\xAA\2\2\xAA\xAA\xAA\xAA", 10)) return 1;
	p1 = xrealloc(p1, 1);
	if (memcmp(p1-4, "\xAA\xAA\xAA\xAA\2\xAA\xAA\xAA\xAA", 9)) return 2;
	p1 = xrealloc(p1, 0);
	if (memcmp(p1-4, "\xAA\xAA\xAA\xAA\xAA\xAA\xAA\xAA", 8)) return 3;
	return 0;
}
END
system($compile) and die "compile failed: $compile\n";
t_capture("./test", "", <<'ERR', 0);
xmalloc: init
xmalloc test.c(4): alloc (2)
xmalloc test.c(7): free (2) allocated at test.c(4)
xmalloc test.c(7): alloc (1)
xmalloc test.c(9): free (1) allocated at test.c(7)
xmalloc test.c(9): alloc (0)
xmalloc: cleanup
xmalloc xmalloc.c(108): leak (0) allocated at test.c(9)
xmalloc xmalloc.c(111): free (0) allocated at test.c(9)
ERR


# xrealloc - grow
write_file("test.c", <<'END');
#include "xmalloc.h"
int main()
{
	char *p1 = xmalloc(1);
	p1[0] = 2;
	if (memcmp(p1-4, "\xAA\xAA\xAA\xAA\2\xAA\xAA\xAA\xAA", 9)) return 1;
	p1 = xrealloc(p1, 2);
	p1[1] = 3;
	if (memcmp(p1-4, "\xAA\xAA\xAA\xAA\2\3\xAA\xAA\xAA\xAA", 10)) return 2;
	return 0;
}
END
system($compile) and die "compile failed: $compile\n";
t_capture("./test", "", <<'ERR', 0);
xmalloc: init
xmalloc test.c(4): alloc (1)
xmalloc test.c(7): free (1) allocated at test.c(4)
xmalloc test.c(7): alloc (2)
xmalloc: cleanup
xmalloc xmalloc.c(108): leak (2) allocated at test.c(7)
xmalloc xmalloc.c(111): free (2) allocated at test.c(7)
ERR


# xstrdup
write_file("test.c", <<'END');
#include "xmalloc.h"
int main()
{
	char *p1 = xstrdup("hello");
	if (memcmp(p1-4, "\xAA\xAA\xAA\xAAhello\0\xAA\xAA\xAA\xAA", 14)) return 1;
	return 0;
}
END
system($compile) and die "compile failed: $compile\n";
t_capture("./test", "", <<'ERR', 0);
xmalloc: init
xmalloc test.c(4): alloc (6)
xmalloc: cleanup
xmalloc xmalloc.c(108): leak (6) allocated at test.c(4)
xmalloc xmalloc.c(111): free (6) allocated at test.c(4)
ERR


# xfree with NULL pointer
write_file("test.c", <<'END');
#include "xmalloc.h"
int main()
{
	char *p1 = NULL;
	xfree(p1);
	return 0;
}
END
system($compile) and die "compile failed: $compile\n";
t_capture("./test", "", <<'ERR', 0);
xmalloc: init
xmalloc: cleanup
ERR

unlink <test.*>;
done_testing;

sub t_capture {
	my($cmd, $exp_out, $exp_err, $exp_exit) = @_;
	my $line_nr = (caller)[2];
	my $line = "[line $line_nr]";
	ok 1, "$line command: $cmd";
	
	my($out, $err, $exit) = capture { system $cmd; };
	eq_or_diff_text $out, $exp_out, "$line out";
	eq_or_diff_text $err, $exp_err, "$line err";
	if ($ENV{DEBUG} && ($out ne $exp_out || $err ne $exp_err)) {
		write_file("$0.tmp", 
					(read_file($0))[0..$line_nr-1],
					$out, "OUT\n", 
					$err, "ERR\n");
		system "wdiff $0.tmp $0";
		die;
	}
	ok !!$exit == !!$exp_exit, "$line exit";
}
