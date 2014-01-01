#!/usr/bin/perl

# Copyright (C) Paulo Custodio, 2011-2013
#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/t/classlist.t,v 1.2 2014-01-01 21:18:37 pauloscustodio Exp $
#
# Test classlist.c

use Modern::Perl;
use Test::More;
use File::Slurp;
use Capture::Tiny 'capture';
use Test::Differences; 

my $compile = "cc -Wall -otest test.c class.c xmalloc.c die.c";

write_file("test.c", <<'END');
#include "classlist.h"
#include "die.h"

#define ERROR die("Test failed at line %d\n", __LINE__)

CLASS(Obj)
	char *string;
END_CLASS;

void Obj_init (Obj *self) 	{ self->string = xstrdup("Hello World"); }
void Obj_copy (Obj *self, Obj *other)
							{ self->string = xstrdup(other->string); }
void Obj_fini (Obj *self)	{ xfree(self->string); }

DEF_CLASS(Obj);

CLASS_LIST(Obj);
DEF_CLASS_LIST(Obj);

#define T_START(list)							\
	_iter = ObjList_first(list);				\
	_count = 0;

#define T_NEXT(list, text)						\
	if (_iter == NULL) ERROR;					\
	if (strcmp(_iter->obj->string, text)) ERROR;\
	_iter = ObjList_next(_iter);				\
	_count++;

#define T_END(list)								\
	if (_iter != NULL) ERROR;					\
	if (_count != list->count) ERROR;

Obj *new_obj( char *text )
{
	Obj *obj = OBJ_NEW(Obj);
	strcpy(obj->string, text);
	return obj;
}

int main()
{
	Obj *obj;
	ObjList *list, *list2;
	ObjListElem *iter, *_iter;
	int _count;
	
	list = OBJ_NEW(ObjList);
	
	
	/* unshift */
	ObjList_unshift( list, new_obj("abc") );
	
	T_START(list);
	T_NEXT(list, "abc");
	T_END(list);
	
	ObjList_unshift( list, new_obj("def") );
	
	T_START(list);
	T_NEXT(list, "def");
	T_NEXT(list, "abc");
	T_END(list);
	
	
	/* push */
	ObjList_push( list, new_obj("ghi") );
	
	T_START(list);
	T_NEXT(list, "def");
	T_NEXT(list, "abc");
	T_NEXT(list, "ghi");
	T_END(list);

	ObjList_push( list, new_obj("jkl") );
	
	T_START(list);
	T_NEXT(list, "def");
	T_NEXT(list, "abc");
	T_NEXT(list, "ghi");
	T_NEXT(list, "jkl");
	T_END(list);

	
	/* clone */
	list2 = ObjList_clone(list);
	
	T_START(list);
	T_NEXT(list, "def");
	T_NEXT(list, "abc");
	T_NEXT(list, "ghi");
	T_NEXT(list, "jkl");
	T_END(list);
	
	T_START(list2);
	T_NEXT(list2, "def");
	T_NEXT(list2, "abc");
	T_NEXT(list2, "ghi");
	T_NEXT(list2, "jkl");
	T_END(list2);


	/* pop */
	obj = ObjList_pop(list);
	if (strcmp(obj->string, "jkl")) ERROR;
	OBJ_DELETE(obj);
	
	T_START(list);
	T_NEXT(list, "def");
	T_NEXT(list, "abc");
	T_NEXT(list, "ghi");
	T_END(list);
	
	obj = ObjList_pop(list);
	if (strcmp(obj->string, "ghi")) ERROR;
	OBJ_DELETE(obj);
	
	T_START(list);
	T_NEXT(list, "def");
	T_NEXT(list, "abc");
	T_END(list);
	
	obj = ObjList_pop(list);
	if (strcmp(obj->string, "abc")) ERROR;
	OBJ_DELETE(obj);
	
	T_START(list);
	T_NEXT(list, "def");
	T_END(list);
	
	obj = ObjList_pop(list);
	if (strcmp(obj->string, "def")) ERROR;
	OBJ_DELETE(obj);
	
	T_START(list);
	T_END(list);
	
	obj = ObjList_pop(list);
	if (obj != NULL) ERROR;
	
	
	/* clone */
	list = ObjList_clone(list2);
	
	T_START(list);
	T_NEXT(list, "def");
	T_NEXT(list, "abc");
	T_NEXT(list, "ghi");
	T_NEXT(list, "jkl");
	T_END(list);
	
	T_START(list2);
	T_NEXT(list2, "def");
	T_NEXT(list2, "abc");
	T_NEXT(list2, "ghi");
	T_NEXT(list2, "jkl");
	T_END(list2);


	/* shift */
	obj = ObjList_shift(list);
	if (strcmp(obj->string, "def")) ERROR;
	OBJ_DELETE(obj);
	
	T_START(list);
	T_NEXT(list, "abc");
	T_NEXT(list, "ghi");
	T_NEXT(list, "jkl");
	T_END(list);
	
	obj = ObjList_shift(list);
	if (strcmp(obj->string, "abc")) ERROR;
	OBJ_DELETE(obj);
	
	T_START(list);
	T_NEXT(list, "ghi");
	T_NEXT(list, "jkl");
	T_END(list);
	
	obj = ObjList_shift(list);
	if (strcmp(obj->string, "ghi")) ERROR;
	OBJ_DELETE(obj);
	
	T_START(list);
	T_NEXT(list, "jkl");
	T_END(list);
	
	obj = ObjList_shift(list);
	if (strcmp(obj->string, "jkl")) ERROR;
	OBJ_DELETE(obj);
	
	T_START(list);
	T_END(list);
	
	obj = ObjList_shift(list);
	if (obj != NULL) ERROR;

	
	/* clone */
	list = ObjList_clone(list2);
	
	OBJ_DELETE(list2);
	list2 = OBJ_NEW(ObjList);
	
	T_START(list);
	T_NEXT(list, "def");
	T_NEXT(list, "abc");
	T_NEXT(list, "ghi");
	T_NEXT(list, "jkl");
	T_END(list);
	
	T_START(list2);
	T_END(list2);


	/* first */
	iter = ObjList_first(list);
	if (strcmp(iter->obj->string, "def")) ERROR;
	
	iter = ObjList_first(list2);
	if (iter != NULL) ERROR;
	
	/* next */
	iter = ObjList_first(list);
	if (strcmp(iter->obj->string, "def")) ERROR;
	
	iter = ObjList_next(iter);
	if (strcmp(iter->obj->string, "abc")) ERROR;
	
	iter = ObjList_next(iter);
	if (strcmp(iter->obj->string, "ghi")) ERROR;
	
	iter = ObjList_next(iter);
	if (strcmp(iter->obj->string, "jkl")) ERROR;
	
	iter = ObjList_next(iter);
	if (iter != NULL) ERROR;
	
	
	/* last */
	iter = ObjList_last(list);
	if (strcmp(iter->obj->string, "jkl")) ERROR;
	
	iter = ObjList_last(list2);
	if (iter != NULL) ERROR;

	
	/* prev */
	iter = ObjList_last(list);
	if (strcmp(iter->obj->string, "jkl")) ERROR;
	
	iter = ObjList_prev(iter);
	if (strcmp(iter->obj->string, "ghi")) ERROR;
	
	iter = ObjList_prev(iter);
	if (strcmp(iter->obj->string, "abc")) ERROR;
	
	iter = ObjList_prev(iter);
	if (strcmp(iter->obj->string, "def")) ERROR;
	
	iter = ObjList_prev(iter);
	if (iter != NULL) ERROR;


	/* insert after */
	iter = ObjList_first(list);
	iter = ObjList_insert_after(list, iter, new_obj("AAA") );
	if (strcmp(iter->obj->string, "AAA")) ERROR;
	
	T_START(list);
	T_NEXT(list, "def");
	T_NEXT(list, "AAA");
	T_NEXT(list, "abc");
	T_NEXT(list, "ghi");
	T_NEXT(list, "jkl");
	T_END(list);
	
	iter = ObjList_last(list);
	iter = ObjList_insert_after(list, iter, new_obj("ZZZ") );
	if (strcmp(iter->obj->string, "ZZZ")) ERROR;
	
	T_START(list);
	T_NEXT(list, "def");
	T_NEXT(list, "AAA");
	T_NEXT(list, "abc");
	T_NEXT(list, "ghi");
	T_NEXT(list, "jkl");
	T_NEXT(list, "ZZZ");
	T_END(list);


	/* insert before */
	iter = ObjList_first(list);
	iter = ObjList_insert_before(list, iter, new_obj("BBB") );
	if (strcmp(iter->obj->string, "BBB")) ERROR;
	
	T_START(list);
	T_NEXT(list, "BBB");
	T_NEXT(list, "def");
	T_NEXT(list, "AAA");
	T_NEXT(list, "abc");
	T_NEXT(list, "ghi");
	T_NEXT(list, "jkl");
	T_NEXT(list, "ZZZ");
	T_END(list);

	iter = ObjList_last(list);
	iter = ObjList_insert_before(list, iter, new_obj("XXX") );
	if (strcmp(iter->obj->string, "XXX")) ERROR;
	
	T_START(list);
	T_NEXT(list, "BBB");
	T_NEXT(list, "def");
	T_NEXT(list, "AAA");
	T_NEXT(list, "abc");
	T_NEXT(list, "ghi");
	T_NEXT(list, "jkl");
	T_NEXT(list, "XXX");
	T_NEXT(list, "ZZZ");
	T_END(list);


	/* remove */
	iter = ObjList_first(list);
	iter = ObjList_next(iter);
	iter = ObjList_next(iter);
	if (strcmp(iter->obj->string, "AAA")) ERROR;

	obj = ObjList_remove(list, &iter);
	if (strcmp(obj->string, "AAA")) ERROR;
	OBJ_DELETE(obj);

	T_START(list);
	T_NEXT(list, "BBB");
	T_NEXT(list, "def");
	T_NEXT(list, "abc");
	T_NEXT(list, "ghi");
	T_NEXT(list, "jkl");
	T_NEXT(list, "XXX");
	T_NEXT(list, "ZZZ");
	T_END(list);

	obj = ObjList_remove(list, &iter);
	if (strcmp(obj->string, "abc")) ERROR;
	OBJ_DELETE(obj);

	T_START(list);
	T_NEXT(list, "BBB");
	T_NEXT(list, "def");
	T_NEXT(list, "ghi");
	T_NEXT(list, "jkl");
	T_NEXT(list, "XXX");
	T_NEXT(list, "ZZZ");
	T_END(list);

	obj = ObjList_remove(list, &iter);
	if (strcmp(obj->string, "ghi")) ERROR;
	OBJ_DELETE(obj);

	T_START(list);
	T_NEXT(list, "BBB");
	T_NEXT(list, "def");
	T_NEXT(list, "jkl");
	T_NEXT(list, "XXX");
	T_NEXT(list, "ZZZ");
	T_END(list);

	obj = ObjList_remove(list, &iter);
	if (strcmp(obj->string, "jkl")) ERROR;
	OBJ_DELETE(obj);

	T_START(list);
	T_NEXT(list, "BBB");
	T_NEXT(list, "def");
	T_NEXT(list, "XXX");
	T_NEXT(list, "ZZZ");
	T_END(list);

	obj = ObjList_remove(list, &iter);
	if (strcmp(obj->string, "XXX")) ERROR;
	OBJ_DELETE(obj);

	T_START(list);
	T_NEXT(list, "BBB");
	T_NEXT(list, "def");
	T_NEXT(list, "ZZZ");
	T_END(list);

	obj = ObjList_remove(list, &iter);
	if (strcmp(obj->string, "ZZZ")) ERROR;
	OBJ_DELETE(obj);
	if (iter != NULL) ERROR;

	T_START(list);
	T_NEXT(list, "BBB");
	T_NEXT(list, "def");
	T_END(list);

	obj = ObjList_remove(list, &iter);
	if (obj != NULL) ERROR;
	if (iter != NULL) ERROR;
	
	/* remove_all */
	OBJ_DELETE(list);
	list = OBJ_NEW(ObjList);
	
	T_START(list);
	T_END(list);
	
	ObjList_push( list, new_obj("abc") );
	ObjList_push( list, new_obj("def") );
	ObjList_push( list, new_obj("ghi") );
	
	T_START(list);
	T_NEXT(list, "abc");
	T_NEXT(list, "def");
	T_NEXT(list, "ghi");
	T_END(list);

	ObjList_remove_all(list);
	
	T_START(list);
	T_END(list);
	
	/* empty */
	OBJ_DELETE(list);
	list = OBJ_NEW(ObjList);

	if (! ObjList_empty(list)) ERROR;
	
	ObjList_push( list, new_obj("abc") );
	
	if (ObjList_empty(list)) ERROR;
	
	return 0;
}
END

system($compile) and die "compile failed: $compile\n";
t_capture("test", "", "", 0);


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


# $Log: classlist.t,v $
# Revision 1.2  2014-01-01 21:18:37  pauloscustodio
# Show error line in case of test failure
#
# Revision 1.1  2013/12/25 17:37:13  pauloscustodio
# Move classlist and classhash to the z80asm/lib directory
#
# Revision 1.12  2013/12/18 23:05:52  pauloscustodio
# Move class.c to the z80asm/lib directory
#
# Revision 1.11  2013/12/15 13:18:35  pauloscustodio
# Move memory allocation routines to lib/xmalloc, instead of glib,
# introduce memory leak report on exit and memory fence check.
#
# Revision 1.10  2013/09/22 21:06:00  pauloscustodio
# replace g_free by g_free0
#
# Revision 1.9  2013/09/09 00:20:45  pauloscustodio
# Add default set of modules to t_compile_module:
# -DMEMALLOC_DEBUG xmalloc.c die.o except.o strpool.o
#
# Revision 1.8  2013/09/08 08:29:21  pauloscustodio
# Replaced xmalloc et al with glib functions
#
# Revision 1.7  2013/09/08 00:43:59  pauloscustodio
# New error module with one error function per error, no need for the error
# constants. Allows compiler to type-check error message arguments.
# Included the errors module in the init() mechanism, no need to call
# error initialization from main(). Moved all error-testing scripts to
# one file errors.t.
#
# Revision 1.6  2013/09/01 18:11:52  pauloscustodio
# Change in test output due to xmalloc change.
#
# Revision 1.5  2013/09/01 11:52:55  pauloscustodio
# Setup xmalloc on init.c.
# Setup GLib memory allocation functions to use xmalloc functions.
#
# Revision 1.4  2013/02/25 21:36:17  pauloscustodio
# Uniform the APIs of classhash, classlist, strhash, strlist
#
# Revision 1.3  2013/01/30 20:40:07  pauloscustodio
# Test cases
#
# Revision 1.2  2013/01/30 00:48:29  pauloscustodio
# Test OBJ_DELETE()
#
# Revision 1.1  2013/01/30 00:39:26  pauloscustodio
# New CLASS_LIST() to create lists of objects defined with CLASS()
#
