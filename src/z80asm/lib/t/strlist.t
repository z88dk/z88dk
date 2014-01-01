#!/usr/bin/perl

# Copyright (C) Paulo Custodio, 2011-2013
#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/t/Attic/strlist.t,v 1.2 2014-01-01 21:19:51 pauloscustodio Exp $
#
# Test strlist.c

use Modern::Perl;
use Test::More;
use File::Slurp;
use Capture::Tiny 'capture';
use Test::Differences; 

my $compile = "cc -Wall -otest test.c strlist.c strpool.c class.c xmalloc.c die.c";

write_file("test.c", <<'END');
#include "strlist.h"
#include "die.h"

#define ERROR die("Test failed at line %d\n", __LINE__)

#define T_START(list)							\
	iter = StrList_first(list);

#define T_NEXT(list, text)						\
	if (! iter) 						ERROR;	\
	str = iter->string;							\
	if (! str) 							ERROR;	\
	if (strcmp(str, text)) 				ERROR;	\
	if (str != iter->string)			ERROR;	\
	iter = StrList_next(iter);					

#define T_END(list)								\
	iter = StrList_next(iter);					\
	if (iter) 							ERROR;

int main()
{
	StrList *l1, *l2;
	char *str;
	StrListElem *iter;
	
	warn("start main\n");
	
	l1 = OBJ_NEW(StrList);
	
	T_START(l1);
	T_END(l1);
	
	StrList_push(&l1, "abc");

	T_START(l1);
	T_NEXT(l1, "abc");
	T_END(l1);
	
	StrList_push(&l1, "def");

	T_START(l1);
	T_NEXT(l1, "abc");
	T_NEXT(l1, "def");
	T_END(l1);
	
	l2 = StrList_clone(l1);

	T_START(l1);
	T_NEXT(l1, "abc");
	T_NEXT(l1, "def");
	T_END(l1);
	
	T_START(l2);
	T_NEXT(l2, "abc");
	T_NEXT(l2, "def");
	T_END(l2);
	
	StrList_push(&l1, "ghi");

	T_START(l1);
	T_NEXT(l1, "abc");
	T_NEXT(l1, "def");
	T_NEXT(l1, "ghi");
	T_END(l1);
	
	T_START(l2);
	T_NEXT(l2, "abc");
	T_NEXT(l2, "def");
	T_END(l2);
	
	StrList_push(&l2, "jkl");

	T_START(l1);
	T_NEXT(l1, "abc");
	T_NEXT(l1, "def");
	T_NEXT(l1, "ghi");
	T_END(l1);
	
	T_START(l2);
	T_NEXT(l2, "abc");
	T_NEXT(l2, "def");
	T_NEXT(l2, "jkl");
	T_END(l2);
	
	/* empty */
	OBJ_DELETE(l1);
	l1 = OBJ_NEW(StrList);
	
	if (! StrList_empty(l1)) ERROR;
	
	StrList_push(&l1, "abc");
	
	if (StrList_empty(l1)) ERROR;
	
	OBJ_DELETE(l1);
	OBJ_DELETE(l2);
	
	/* uninitialized list */
	l1 = NULL;
	T_START(l1);
	T_END(l1);

	StrList_push(&l1, "abc");

	T_START(l1);
	T_NEXT(l1, "abc");
	T_END(l1);
	
	StrList_push(&l1, "def");

	T_START(l1);
	T_NEXT(l1, "abc");
	T_NEXT(l1, "def");
	T_END(l1);
	
	warn("end main\n");

	return 0;
}
END

system($compile) and die "compile failed: $compile\n";
t_capture("test", "", <<'ERR', 0);
start main
end main
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


# $Log: strlist.t,v $
# Revision 1.2  2014-01-01 21:19:51  pauloscustodio
# Show error line in case of test failure
#
# Revision 1.1  2013/12/26 23:42:27  pauloscustodio
# Replace StringList from strutil by StrList in new strlis.c, to keep lists of strings (e.g. directory search paths)
#
# Revision 1.8  2013/02/25 21:36:17  pauloscustodio
# Uniform the APIs of classhash, classlist, strhash, strlist
#
# Revision 1.7  2013/01/30 20:40:07  pauloscustodio
# Test cases
#
# Revision 1.6  2013/01/20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.5  2013/01/19 01:33:16  pauloscustodio
# Clean-up strpool code
#
# Revision 1.4  2013/01/19 00:04:53  pauloscustodio
# Implement StrHash_clone, required change in API of class.h and all classes that used it.
#
# Revision 1.3  2012/06/14 15:01:27  pauloscustodio
# Split safe strings from strutil.c to safestr.c
#
# Revision 1.2  2012/05/26 18:50:26  pauloscustodio
# Use .o instead of .c to build test program, faster compilation.
# Use gcc to compile instead of cc.
#
# Revision 1.1  2012/05/24 21:42:42  pauloscustodio
# CH_0011 : new string list class to hold lists of strings
#
