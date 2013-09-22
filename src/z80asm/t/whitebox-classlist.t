#!/usr/bin/perl

#     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
#   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
#                ZZZZZ      888           888  0000         0000
#              ZZZZZ        88888888888888888  0000         0000
#            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
#          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
#        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
#      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
#    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
#  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM
#
# Copyright (C) Paulo Custodio, 2011-2013

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

# test memalloc
my $objs = "class.o"; 

t_compile_module(<<'END_INIT', <<'END', $objs);

#define ERROR return __LINE__

#include "classlist.h"

CLASS(Obj)
	char *string;
END_CLASS;

void Obj_init (Obj *self) 	{ self->string = g_strdup("Hello World"); }
void Obj_copy (Obj *self, Obj *other)
							{ self->string = g_strdup(other->string); }
void Obj_fini (Obj *self)	{ g_free0(self->string); }

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

	
END_INIT
	/* main */
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
END

t_run_module([], <<'OUT', <<'ERR', 0);
GLib Memory statistics (successful operations):
 blocks of | allocated  | freed      | allocated  | freed      | n_bytes   
  n_bytes  | n_times by | n_times by | n_times by | n_times by | remaining 
           | malloc()   | free()     | realloc()  | realloc()  |           
===========|============|============|============|============|===========
         4 |         12 |         12 |          0 |          0 |         +0
        12 |         36 |         36 |          0 |          0 |         +0
        20 |          1 |          1 |          0 |          0 |         +0
        32 |         24 |         24 |          0 |          0 |         +0
        40 |          7 |          7 |          0 |          0 |         +0
GLib Memory statistics (failing operations):
 --- none ---
Total bytes: allocated=1548, zero-initialized=1336 (86.30%), freed=1548 (100.00%), remaining=0
OUT
ERR


unlink_testfiles();
done_testing;


__END__
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-classlist.t,v 1.10 2013-09-22 21:06:00 pauloscustodio Exp $
# $Log: whitebox-classlist.t,v $
# Revision 1.10  2013-09-22 21:06:00  pauloscustodio
# replace g_free by g_free0
#
# Revision 1.9  2013/09/09 00:20:45  pauloscustodio
# Add default set of modules to t_compile_module:
# -DMEMALLOC_DEBUG memalloc.c die.o except.o strpool.o
#
# Revision 1.8  2013/09/08 08:29:21  pauloscustodio
# Replaced xmalloc et al with g_malloc0 et al.
#
# Revision 1.7  2013/09/08 00:43:59  pauloscustodio
# New error module with one error function per error, no need for the error
# constants. Allows compiler to type-check error message arguments.
# Included the errors module in the init() mechanism, no need to call
# error initialization from main(). Moved all error-testing scripts to
# one file errors.t.
#
# Revision 1.6  2013/09/01 18:11:52  pauloscustodio
# Change in test output due to memalloc change.
#
# Revision 1.5  2013/09/01 11:52:55  pauloscustodio
# Setup memalloc on init.c.
# Setup GLib memory allocation functions to use memalloc functions.
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
