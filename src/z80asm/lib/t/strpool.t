#!/usr/bin/perl

# Copyright (C) Paulo Custodio, 2011-2014
#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/t/Attic/strpool.t,v 1.8 2014-07-06 03:06:15 pauloscustodio Exp $
#
# Test strpool.c

use Modern::Perl;
use Test::More;
use File::Slurp;
use Capture::Tiny 'capture';
use Test::Differences; 

my $compile = "cc -Wall -DSTRPOOL_DEBUG -otest test.c strpool.c xmalloc.c dlist.c";

write_file("test.c", <<'END');
#include "xmalloc.h"
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

#define ERROR die("Test failed at line %d\n", __LINE__)

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

t_capture("./test", "", <<'ERR', 0);
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
