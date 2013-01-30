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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-classlist.t,v 1.3 2013-01-30 20:40:07 pauloscustodio Exp $
# $Log: whitebox-classlist.t,v $
# Revision 1.3  2013-01-30 20:40:07  pauloscustodio
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
my $objs = "class.o die.o strutil.o safestr.o except.o";
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
	ObjList_first(list, &iter);

#define T_NEXT(list, text)						\
	obj = ObjList_next(list, &iter);			\
	if (! obj) 							ERROR;	\
	if (strcmp(obj->string, text)) 		ERROR;	\
	if (obj != iter->obj)				ERROR;

#define T_END(list)								\
	obj = ObjList_next(list, &iter);			\
	if (obj) 							ERROR;

	
END_INIT
	/* main */
	Obj *obj;
	ObjList *list, *list2;
	ObjListElem *iter;
	
	list = OBJ_NEW(ObjList);
	
	obj  = OBJ_NEW(Obj); strcpy(obj->string, "abc");
	ObjList_append(list, obj);
	
	T_START(list);
	T_NEXT(list, "abc");
	T_END(list);
	
	obj  = OBJ_NEW(Obj); strcpy(obj->string, "def");
	ObjList_append(list, obj);

	T_START(list);
	T_NEXT(list, "abc");
	T_NEXT(list, "def");
	T_END(list);
	
	list2 = ObjList_clone(list);
	
	T_START(list);
	T_NEXT(list, "abc");
	T_NEXT(list, "def");
	T_END(list);
	
	T_START(list2);
	T_NEXT(list2, "abc");
	T_NEXT(list2, "def");
	T_END(list2);
	
	strcpy( TAILQ_FIRST(&list2->head)->obj->string, "ABC" );
	strcpy( TAILQ_NEXT( TAILQ_FIRST(&list2->head), entries )
			->obj->string, "DEF" );
	
	T_START(list);
	T_NEXT(list, "abc");
	T_NEXT(list, "def");
	T_END(list);
	
	T_START(list2);
	T_NEXT(list2, "ABC");
	T_NEXT(list2, "DEF");
	T_END(list2);
	
	obj  = OBJ_NEW(Obj); strcpy(obj->string, "ghi");
	ObjList_append(list, obj);

	T_START(list);
	T_NEXT(list, "abc");
	T_NEXT(list, "def");
	T_NEXT(list, "ghi");
	T_END(list);
	
	T_START(list2);
	T_NEXT(list2, "ABC");
	T_NEXT(list2, "DEF");
	T_END(list2);
	
	obj  = OBJ_NEW(Obj); strcpy(obj->string, "JKL");
	ObjList_append(list2, obj);

	T_START(list);
	T_NEXT(list, "abc");
	T_NEXT(list, "def");
	T_NEXT(list, "ghi");
	T_END(list);
	
	T_START(list2);
	T_NEXT(list2, "ABC");
	T_NEXT(list2, "DEF");
	T_NEXT(list2, "JKL");
	T_END(list2);
	
	OBJ_DELETE(list2);
	OBJ_DELETE(list);
	
	return 0;
END

t_run_module([], "", <<ERR, 0);
memalloc: init
memalloc test.c(5): alloc 36 bytes at ADDR_1
memalloc test.c(4): alloc 32 bytes at ADDR_2
memalloc test.c(1): alloc 12 bytes at ADDR_3
memalloc test.c(5): alloc 12 bytes at ADDR_4
memalloc test.c(4): alloc 32 bytes at ADDR_5
memalloc test.c(1): alloc 12 bytes at ADDR_6
memalloc test.c(5): alloc 12 bytes at ADDR_7
memalloc test.c(5): alloc 36 bytes at ADDR_8
memalloc test.c(4): alloc 32 bytes at ADDR_9
memalloc test.c(2): alloc 4 bytes at ADDR_10
memalloc test.c(5): alloc 12 bytes at ADDR_11
memalloc test.c(4): alloc 32 bytes at ADDR_12
memalloc test.c(2): alloc 4 bytes at ADDR_13
memalloc test.c(5): alloc 12 bytes at ADDR_14
memalloc test.c(4): alloc 32 bytes at ADDR_15
memalloc test.c(1): alloc 12 bytes at ADDR_16
memalloc test.c(5): alloc 12 bytes at ADDR_17
memalloc test.c(4): alloc 32 bytes at ADDR_18
memalloc test.c(1): alloc 12 bytes at ADDR_19
memalloc test.c(5): alloc 12 bytes at ADDR_20
memalloc test.c(3): free 4 bytes at ADDR_10 allocated at test.c(2)
memalloc test.c(4): free 32 bytes at ADDR_9 allocated at test.c(4)
memalloc test.c(5): free 12 bytes at ADDR_11 allocated at test.c(5)
memalloc test.c(3): free 4 bytes at ADDR_13 allocated at test.c(2)
memalloc test.c(4): free 32 bytes at ADDR_12 allocated at test.c(4)
memalloc test.c(5): free 12 bytes at ADDR_14 allocated at test.c(5)
memalloc test.c(3): free 12 bytes at ADDR_19 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_18 allocated at test.c(4)
memalloc test.c(5): free 12 bytes at ADDR_20 allocated at test.c(5)
memalloc test.c(5): free 36 bytes at ADDR_8 allocated at test.c(5)
memalloc test.c(3): free 12 bytes at ADDR_3 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_2 allocated at test.c(4)
memalloc test.c(5): free 12 bytes at ADDR_4 allocated at test.c(5)
memalloc test.c(3): free 12 bytes at ADDR_6 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_5 allocated at test.c(4)
memalloc test.c(5): free 12 bytes at ADDR_7 allocated at test.c(5)
memalloc test.c(3): free 12 bytes at ADDR_16 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_15 allocated at test.c(4)
memalloc test.c(5): free 12 bytes at ADDR_17 allocated at test.c(5)
memalloc test.c(5): free 36 bytes at ADDR_1 allocated at test.c(5)
memalloc: cleanup
ERR


unlink_testfiles();
done_testing;
