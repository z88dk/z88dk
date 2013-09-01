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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-classlist.t,v 1.5 2013-09-01 11:52:55 pauloscustodio Exp $
# $Log: whitebox-classlist.t,v $
# Revision 1.5  2013-09-01 11:52:55  pauloscustodio
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

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

# test memalloc
my $objs = "class.o die.o strutil.o safestr.o except.o init.o";
ok ! system "make $objs";
my $compile = "-DMEMALLOC_DEBUG memalloc.c $objs";

t_compile_module(<<'END_INIT', <<'END', $compile);

#define ERROR return __LINE__

#include "classlist.h"

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

t_run_module([], "", <<ERR, 0);
memalloc: init
memalloc test.c(5): alloc 40 bytes at ADDR_1
memalloc test.c(4): alloc 32 bytes at ADDR_2
memalloc test.c(1): alloc 12 bytes at ADDR_3
memalloc test.c(5): alloc 12 bytes at ADDR_4
memalloc test.c(4): alloc 32 bytes at ADDR_5
memalloc test.c(1): alloc 12 bytes at ADDR_6
memalloc test.c(5): alloc 12 bytes at ADDR_7
memalloc test.c(4): alloc 32 bytes at ADDR_8
memalloc test.c(1): alloc 12 bytes at ADDR_9
memalloc test.c(5): alloc 12 bytes at ADDR_10
memalloc test.c(4): alloc 32 bytes at ADDR_11
memalloc test.c(1): alloc 12 bytes at ADDR_12
memalloc test.c(5): alloc 12 bytes at ADDR_13
memalloc test.c(5): alloc 40 bytes at ADDR_14
memalloc test.c(4): alloc 32 bytes at ADDR_15
memalloc test.c(2): alloc 4 bytes at ADDR_16
memalloc test.c(5): alloc 12 bytes at ADDR_17
memalloc test.c(4): alloc 32 bytes at ADDR_18
memalloc test.c(2): alloc 4 bytes at ADDR_19
memalloc test.c(5): alloc 12 bytes at ADDR_20
memalloc test.c(4): alloc 32 bytes at ADDR_21
memalloc test.c(2): alloc 4 bytes at ADDR_22
memalloc test.c(5): alloc 12 bytes at ADDR_23
memalloc test.c(4): alloc 32 bytes at ADDR_24
memalloc test.c(2): alloc 4 bytes at ADDR_25
memalloc test.c(5): alloc 12 bytes at ADDR_26
memalloc test.c(5): free 12 bytes at ADDR_13 allocated at test.c(5)
memalloc test.c(3): free 12 bytes at ADDR_12 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_11 allocated at test.c(4)
memalloc test.c(5): free 12 bytes at ADDR_10 allocated at test.c(5)
memalloc test.c(3): free 12 bytes at ADDR_9 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_8 allocated at test.c(4)
memalloc test.c(5): free 12 bytes at ADDR_4 allocated at test.c(5)
memalloc test.c(3): free 12 bytes at ADDR_3 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_2 allocated at test.c(4)
memalloc test.c(5): free 12 bytes at ADDR_7 allocated at test.c(5)
memalloc test.c(3): free 12 bytes at ADDR_6 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_5 allocated at test.c(4)
memalloc test.c(5): alloc 40 bytes at ADDR_27
memalloc test.c(4): alloc 32 bytes at ADDR_28
memalloc test.c(2): alloc 4 bytes at ADDR_29
memalloc test.c(5): alloc 12 bytes at ADDR_30
memalloc test.c(4): alloc 32 bytes at ADDR_31
memalloc test.c(2): alloc 4 bytes at ADDR_32
memalloc test.c(5): alloc 12 bytes at ADDR_33
memalloc test.c(4): alloc 32 bytes at ADDR_34
memalloc test.c(2): alloc 4 bytes at ADDR_35
memalloc test.c(5): alloc 12 bytes at ADDR_36
memalloc test.c(4): alloc 32 bytes at ADDR_37
memalloc test.c(2): alloc 4 bytes at ADDR_38
memalloc test.c(5): alloc 12 bytes at ADDR_39
memalloc test.c(5): free 12 bytes at ADDR_30 allocated at test.c(5)
memalloc test.c(3): free 4 bytes at ADDR_29 allocated at test.c(2)
memalloc test.c(4): free 32 bytes at ADDR_28 allocated at test.c(4)
memalloc test.c(5): free 12 bytes at ADDR_33 allocated at test.c(5)
memalloc test.c(3): free 4 bytes at ADDR_32 allocated at test.c(2)
memalloc test.c(4): free 32 bytes at ADDR_31 allocated at test.c(4)
memalloc test.c(5): free 12 bytes at ADDR_36 allocated at test.c(5)
memalloc test.c(3): free 4 bytes at ADDR_35 allocated at test.c(2)
memalloc test.c(4): free 32 bytes at ADDR_34 allocated at test.c(4)
memalloc test.c(5): free 12 bytes at ADDR_39 allocated at test.c(5)
memalloc test.c(3): free 4 bytes at ADDR_38 allocated at test.c(2)
memalloc test.c(4): free 32 bytes at ADDR_37 allocated at test.c(4)
memalloc test.c(5): alloc 40 bytes at ADDR_40
memalloc test.c(4): alloc 32 bytes at ADDR_41
memalloc test.c(2): alloc 4 bytes at ADDR_42
memalloc test.c(5): alloc 12 bytes at ADDR_43
memalloc test.c(4): alloc 32 bytes at ADDR_44
memalloc test.c(2): alloc 4 bytes at ADDR_45
memalloc test.c(5): alloc 12 bytes at ADDR_46
memalloc test.c(4): alloc 32 bytes at ADDR_47
memalloc test.c(2): alloc 4 bytes at ADDR_48
memalloc test.c(5): alloc 12 bytes at ADDR_49
memalloc test.c(4): alloc 32 bytes at ADDR_50
memalloc test.c(2): alloc 4 bytes at ADDR_51
memalloc test.c(5): alloc 12 bytes at ADDR_52
memalloc test.c(3): free 4 bytes at ADDR_16 allocated at test.c(2)
memalloc test.c(4): free 32 bytes at ADDR_15 allocated at test.c(4)
memalloc test.c(5): free 12 bytes at ADDR_17 allocated at test.c(5)
memalloc test.c(3): free 4 bytes at ADDR_19 allocated at test.c(2)
memalloc test.c(4): free 32 bytes at ADDR_18 allocated at test.c(4)
memalloc test.c(5): free 12 bytes at ADDR_20 allocated at test.c(5)
memalloc test.c(3): free 4 bytes at ADDR_22 allocated at test.c(2)
memalloc test.c(4): free 32 bytes at ADDR_21 allocated at test.c(4)
memalloc test.c(5): free 12 bytes at ADDR_23 allocated at test.c(5)
memalloc test.c(3): free 4 bytes at ADDR_25 allocated at test.c(2)
memalloc test.c(4): free 32 bytes at ADDR_24 allocated at test.c(4)
memalloc test.c(5): free 12 bytes at ADDR_26 allocated at test.c(5)
memalloc test.c(5): free 40 bytes at ADDR_14 allocated at test.c(5)
memalloc test.c(5): alloc 40 bytes at ADDR_53
memalloc test.c(4): alloc 32 bytes at ADDR_54
memalloc test.c(1): alloc 12 bytes at ADDR_55
memalloc test.c(5): alloc 12 bytes at ADDR_56
memalloc test.c(4): alloc 32 bytes at ADDR_57
memalloc test.c(1): alloc 12 bytes at ADDR_58
memalloc test.c(5): alloc 12 bytes at ADDR_59
memalloc test.c(4): alloc 32 bytes at ADDR_60
memalloc test.c(1): alloc 12 bytes at ADDR_61
memalloc test.c(5): alloc 12 bytes at ADDR_62
memalloc test.c(4): alloc 32 bytes at ADDR_63
memalloc test.c(1): alloc 12 bytes at ADDR_64
memalloc test.c(5): alloc 12 bytes at ADDR_65
memalloc test.c(5): free 12 bytes at ADDR_56 allocated at test.c(5)
memalloc test.c(3): free 12 bytes at ADDR_55 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_54 allocated at test.c(4)
memalloc test.c(5): free 12 bytes at ADDR_46 allocated at test.c(5)
memalloc test.c(3): free 4 bytes at ADDR_45 allocated at test.c(2)
memalloc test.c(4): free 32 bytes at ADDR_44 allocated at test.c(4)
memalloc test.c(5): free 12 bytes at ADDR_49 allocated at test.c(5)
memalloc test.c(3): free 4 bytes at ADDR_48 allocated at test.c(2)
memalloc test.c(4): free 32 bytes at ADDR_47 allocated at test.c(4)
memalloc test.c(5): free 12 bytes at ADDR_52 allocated at test.c(5)
memalloc test.c(3): free 4 bytes at ADDR_51 allocated at test.c(2)
memalloc test.c(4): free 32 bytes at ADDR_50 allocated at test.c(4)
memalloc test.c(5): free 12 bytes at ADDR_65 allocated at test.c(5)
memalloc test.c(3): free 12 bytes at ADDR_64 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_63 allocated at test.c(4)
memalloc test.c(5): free 12 bytes at ADDR_59 allocated at test.c(5)
memalloc test.c(3): free 12 bytes at ADDR_58 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_57 allocated at test.c(4)
memalloc test.c(3): free 12 bytes at ADDR_61 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_60 allocated at test.c(4)
memalloc test.c(5): free 12 bytes at ADDR_62 allocated at test.c(5)
memalloc test.c(3): free 4 bytes at ADDR_42 allocated at test.c(2)
memalloc test.c(4): free 32 bytes at ADDR_41 allocated at test.c(4)
memalloc test.c(5): free 12 bytes at ADDR_43 allocated at test.c(5)
memalloc test.c(5): free 40 bytes at ADDR_40 allocated at test.c(5)
memalloc test.c(5): alloc 40 bytes at ADDR_66
memalloc test.c(4): alloc 32 bytes at ADDR_67
memalloc test.c(1): alloc 12 bytes at ADDR_68
memalloc test.c(5): alloc 12 bytes at ADDR_69
memalloc test.c(4): alloc 32 bytes at ADDR_70
memalloc test.c(1): alloc 12 bytes at ADDR_71
memalloc test.c(5): alloc 12 bytes at ADDR_72
memalloc test.c(4): alloc 32 bytes at ADDR_73
memalloc test.c(1): alloc 12 bytes at ADDR_74
memalloc test.c(5): alloc 12 bytes at ADDR_75
memalloc test.c(3): free 12 bytes at ADDR_68 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_67 allocated at test.c(4)
memalloc test.c(5): free 12 bytes at ADDR_69 allocated at test.c(5)
memalloc test.c(3): free 12 bytes at ADDR_71 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_70 allocated at test.c(4)
memalloc test.c(5): free 12 bytes at ADDR_72 allocated at test.c(5)
memalloc test.c(3): free 12 bytes at ADDR_74 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_73 allocated at test.c(4)
memalloc test.c(5): free 12 bytes at ADDR_75 allocated at test.c(5)
memalloc test.c(5): free 40 bytes at ADDR_66 allocated at test.c(5)
memalloc test.c(5): alloc 40 bytes at ADDR_76
memalloc test.c(4): alloc 32 bytes at ADDR_77
memalloc test.c(1): alloc 12 bytes at ADDR_78
memalloc test.c(5): alloc 12 bytes at ADDR_79
memalloc test.c(3): free 12 bytes at ADDR_78 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_77 allocated at test.c(4)
memalloc test.c(5): free 12 bytes at ADDR_79 allocated at test.c(5)
memalloc test.c(5): free 40 bytes at ADDR_76 allocated at test.c(5)
memalloc test.c(5): free 40 bytes at ADDR_53 allocated at test.c(5)
memalloc test.c(5): free 40 bytes at ADDR_27 allocated at test.c(5)
memalloc test.c(5): free 40 bytes at ADDR_1 allocated at test.c(5)
memalloc: cleanup
ERR


unlink_testfiles();
done_testing;
