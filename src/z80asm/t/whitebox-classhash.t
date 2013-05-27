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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-classhash.t,v 1.3 2013-05-27 22:43:34 pauloscustodio Exp $
# $Log: whitebox-classhash.t,v $
# Revision 1.3  2013-05-27 22:43:34  pauloscustodio
# StrHash_set failed when the key string buffer was reused later in the code.
# StrHash_get failed to retrieve object after the key used by StrHash_set was reused.
#
# Revision 1.2  2013/02/25 21:36:17  pauloscustodio
# Uniform the APIs of classhash, classlist, strhash, strlist
#
# Revision 1.1  2013/02/02 00:08:26  pauloscustodio
# New CLASS_HASH() to create hash tables of objects defined by CLASS()
#
#

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

# test memalloc
my $objs = "strhash.o strpool.o class.o die.o strutil.o safestr.o except.o";
ok ! system "make $objs";
my $compile = "-DMEMALLOC_DEBUG memalloc.c $objs";

t_compile_module(<<'END_INIT', <<'END', $compile);

#define ERROR return __LINE__

#include "classhash.h"

CLASS(Obj)
	char *string;
END_CLASS;

void Obj_init (Obj *self) 	{ self->string = xstrdup("Hello World"); }
void Obj_copy (Obj *self, Obj *other)
							{ self->string = xstrdup(other->string); }
void Obj_fini (Obj *self)	{ xfree(self->string); }

DEF_CLASS(Obj);

Obj *new_obj(char *text)
{
	Obj *obj = OBJ_NEW(Obj);
	strcpy(obj->string, text);
	return obj;
}

CLASS_HASH(Obj);
DEF_CLASS_HASH(Obj);


#include "die.h"
void _check_list (StrHash *hash, char *expected, char *file, int lineno)
{
}

#define check_list(hash,expected) _check_list(hash,expected,__FILE__,__LINE__)


#define T_START(hash)							\
	iter = ObjHash_first(hash);

#define T_NEXT(hash, akey, atext)				\
	if (! iter)							ERROR;	\
	obj = iter->value;							\
	if (! obj) 							ERROR;	\
	if (strcmp(iter->key, akey)) 		ERROR;	\
	if (strcmp(obj->string, atext))		ERROR;	\
	if (obj != iter->value)				ERROR;	\
	obj = ObjHash_get(hash, akey);				\
	if (! obj) 							ERROR;	\
	if (strcmp(obj->string, atext))		ERROR;	\
	obj = ObjHash_get(hash, "nokey");			\
	if (obj) 							ERROR;	\
	if (! ObjHash_exists(hash, akey))	ERROR;	\
	if (ObjHash_exists(hash, "nokey"))	ERROR;	\
	iter = ObjHash_next(iter);

#define T_END(hash)								\
	if (iter != NULL)					ERROR;


int ascending (ObjHashElem *a, ObjHashElem *b)
{
	return strcmp(((Obj *)(a->value))->string, ((Obj *)(b->value))->string);
}

int descending (ObjHashElem *a, ObjHashElem *b)
{
	return strcmp(((Obj *)(b->value))->string, ((Obj *)(a->value))->string);
}

/* reuse string - test saving of keys by hash */
char *S(char *str)
{
	static char buffer[MAXLINE];
	
	strcpy(buffer, str);		/* overwrite last string */
	return buffer;
}

END_INIT
	/* main */
	Obj *obj;
	ObjHash *hash, *hash2;
	ObjHashElem *iter, *elem;
	
	hash = OBJ_NEW(ObjHash);
	
	T_START(hash);
	T_END(hash);

	ObjHash_set(hash, S("abc"), new_obj("321"));
	
	T_START(hash);
	T_NEXT(hash, "abc", "321");
	T_END(hash);

	T_START(hash);
	T_NEXT(hash, "abc", "321");
	T_END(hash);

	ObjHash_set(hash, S("def"), new_obj("456"));

	T_START(hash);
	T_NEXT(hash, "abc", "321");
	T_NEXT(hash, "def", "456");
	T_END(hash);

	ObjHash_set(hash, S("ghi"), new_obj("789"));

	T_START(hash);
	T_NEXT(hash, "abc", "321");
	T_NEXT(hash, "def", "456");
	T_NEXT(hash, "ghi", "789");
	T_END(hash);

	/* set new object, old is deleted */
	ObjHash_set(hash, S("abc"), new_obj("123"));
	
	T_START(hash);
	T_NEXT(hash, "abc", "123");
	T_NEXT(hash, "def", "456");
	T_NEXT(hash, "ghi", "789");
	T_END(hash);

	/* clone */
	hash2 = ObjHash_clone(hash);
	
	T_START(hash);
	T_NEXT(hash, "abc", "123");
	T_NEXT(hash, "def", "456");
	T_NEXT(hash, "ghi", "789");
	T_END(hash);

	T_START(hash2);
	T_NEXT(hash2, "abc", "123");
	T_NEXT(hash2, "def", "456");
	T_NEXT(hash2, "ghi", "789");
	T_END(hash2);

	ObjHash_remove(hash, S("def"));
	
	T_START(hash);
	T_NEXT(hash, "abc", "123");
	T_NEXT(hash, "ghi", "789");
	T_END(hash);

	T_START(hash2);
	T_NEXT(hash2, "abc", "123");
	T_NEXT(hash2, "def", "456");
	T_NEXT(hash2, "ghi", "789");
	T_END(hash2);

	ObjHash_remove(hash, S("def"));
	
	T_START(hash);
	T_NEXT(hash, "abc", "123");
	T_NEXT(hash, "ghi", "789");
	T_END(hash);

	T_START(hash2);
	T_NEXT(hash2, "abc", "123");
	T_NEXT(hash2, "def", "456");
	T_NEXT(hash2, "ghi", "789");
	T_END(hash2);

	ObjHash_remove(hash, S("ghi"));
	
	T_START(hash);
	T_NEXT(hash, "abc", "123");
	T_END(hash);

	T_START(hash2);
	T_NEXT(hash2, "abc", "123");
	T_NEXT(hash2, "def", "456");
	T_NEXT(hash2, "ghi", "789");
	T_END(hash2);

	ObjHash_remove(hash, S("abc"));
	
	T_START(hash);
	T_END(hash);

	T_START(hash2);
	T_NEXT(hash2, "abc", "123");
	T_NEXT(hash2, "def", "456");
	T_NEXT(hash2, "ghi", "789");
	T_END(hash2);

	ObjHash_remove_all(hash);
	
	T_START(hash);
	T_END(hash);

	T_START(hash2);
	T_NEXT(hash2, "abc", "123");
	T_NEXT(hash2, "def", "456");
	T_NEXT(hash2, "ghi", "789");
	T_END(hash2);

	ObjHash_remove_all(hash2);
	
	T_START(hash);
	T_END(hash);

	T_START(hash2);
	T_END(hash2);

	/* first / remove_elem */
	ObjHash_set(hash, S("abc"), new_obj("123"));
	ObjHash_set(hash, S("def"), new_obj("456"));
	ObjHash_set(hash, S("ghi"), new_obj("789"));

	T_START(hash);
	T_NEXT(hash, "abc", "123");
	T_NEXT(hash, "def", "456");
	T_NEXT(hash, "ghi", "789");
	T_END(hash);

	elem = ObjHash_first(hash); 
	if (elem == NULL) ERROR;
	if (strcmp(elem->key, "abc")) ERROR;
	ObjHash_remove_elem(hash, elem);
	
	T_START(hash);
	T_NEXT(hash, "def", "456");
	T_NEXT(hash, "ghi", "789");
	T_END(hash);

	elem = ObjHash_first(hash); 
	if (elem == NULL) ERROR;
	if (strcmp(elem->key, "def")) ERROR;
	ObjHash_remove_elem(hash, elem);
	
	T_START(hash);
	T_NEXT(hash, "ghi", "789");
	T_END(hash);

	elem = ObjHash_first(hash); 
	if (elem == NULL) ERROR;
	if (strcmp(elem->key, "ghi")) ERROR;
	ObjHash_remove_elem(hash, elem);
	
	T_START(hash);
	T_END(hash);

	elem = ObjHash_first(hash); 
	if (elem != NULL) ERROR;

	T_START(hash);
	T_END(hash);

	/* find / remove_elem */
	ObjHash_set(hash, S("abc"), new_obj("123"));
	ObjHash_set(hash, S("def"), new_obj("456"));
	ObjHash_set(hash, S("ghi"), new_obj("789"));

	T_START(hash);
	T_NEXT(hash, "abc", "123");
	T_NEXT(hash, "def", "456");
	T_NEXT(hash, "ghi", "789");
	T_END(hash);

	elem = ObjHash_find(hash, "def"); 
	if (elem == NULL) ERROR;
	if (strcmp(elem->key, "def")) ERROR;
	ObjHash_remove_elem(hash, elem);
	
	T_START(hash);
	T_NEXT(hash, "abc", "123");
	T_NEXT(hash, "ghi", "789");
	T_END(hash);

	elem = ObjHash_find(hash, "ghi"); 
	if (elem == NULL) ERROR;
	if (strcmp(elem->key, "ghi")) ERROR;
	ObjHash_remove_elem(hash, elem);
	
	T_START(hash);
	T_NEXT(hash, "abc", "123");
	T_END(hash);

	elem = ObjHash_find(hash, "abc"); 
	if (elem == NULL) ERROR;
	if (strcmp(elem->key, "abc")) ERROR;
	ObjHash_remove_elem(hash, elem);
	
	T_START(hash);
	T_END(hash);

	elem = ObjHash_find(hash, "abc"); 
	if (elem != NULL) ERROR;
	
	T_START(hash);
	T_END(hash);

	/* empty */
	OBJ_DELETE(hash);
	hash = OBJ_NEW(ObjHash);

	if (! ObjHash_empty(hash)) ERROR;
	
	ObjHash_set(hash, S("abc"), new_obj("123"));
	
	if (ObjHash_empty(hash)) ERROR;

	/* sort */
	OBJ_DELETE(hash);
	hash = OBJ_NEW(ObjHash);
	
	ObjHash_set(hash, S("def"), new_obj("456"));
	ObjHash_set(hash, S("abc"), new_obj("321"));
	ObjHash_set(hash, S("ghi"), new_obj("789"));

	T_START(hash);
	T_NEXT(hash, "def", "456");
	T_NEXT(hash, "abc", "321");
	T_NEXT(hash, "ghi", "789");
	T_END(hash);

	ObjHash_sort(hash, ascending);
	
	T_START(hash);
	T_NEXT(hash, "abc", "321");
	T_NEXT(hash, "def", "456");
	T_NEXT(hash, "ghi", "789");
	T_END(hash);

	ObjHash_sort(hash, descending);
	
	T_START(hash);
	T_NEXT(hash, "ghi", "789");
	T_NEXT(hash, "def", "456");
	T_NEXT(hash, "abc", "321");
	T_END(hash);
	
	return 0;
END

t_run_module([], "", <<ERR, 0);
memalloc: init
memalloc test.c(5): alloc 32 bytes at ADDR_1
memalloc strhash.c(1): alloc 32 bytes at ADDR_2
memalloc strpool.c(1): alloc 32 bytes at ADDR_3
memalloc test.c(4): alloc 32 bytes at ADDR_4
memalloc test.c(1): alloc 12 bytes at ADDR_5
memalloc strhash.c(4): alloc 40 bytes at ADDR_6
memalloc strpool.c(2): alloc 36 bytes at ADDR_7
memalloc strpool.c(3): alloc 4 bytes at ADDR_8
memalloc strpool.c(4): alloc 44 bytes at ADDR_9
memalloc strpool.c(4): alloc 384 bytes at ADDR_10
memalloc strhash.c(5): alloc 44 bytes at ADDR_11
memalloc strhash.c(5): alloc 384 bytes at ADDR_12
memalloc test.c(4): alloc 32 bytes at ADDR_13
memalloc test.c(1): alloc 12 bytes at ADDR_14
memalloc strhash.c(4): alloc 40 bytes at ADDR_15
memalloc strpool.c(2): alloc 36 bytes at ADDR_16
memalloc strpool.c(3): alloc 4 bytes at ADDR_17
memalloc test.c(4): alloc 32 bytes at ADDR_18
memalloc test.c(1): alloc 12 bytes at ADDR_19
memalloc strhash.c(4): alloc 40 bytes at ADDR_20
memalloc strpool.c(2): alloc 36 bytes at ADDR_21
memalloc strpool.c(3): alloc 4 bytes at ADDR_22
memalloc test.c(4): alloc 32 bytes at ADDR_23
memalloc test.c(1): alloc 12 bytes at ADDR_24
memalloc test.c(3): free 12 bytes at ADDR_5 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_4 allocated at test.c(4)
memalloc test.c(5): alloc 32 bytes at ADDR_25
memalloc strhash.c(1): alloc 32 bytes at ADDR_26
memalloc test.c(4): alloc 32 bytes at ADDR_27
memalloc test.c(2): alloc 4 bytes at ADDR_28
memalloc strhash.c(4): alloc 40 bytes at ADDR_29
memalloc strhash.c(5): alloc 44 bytes at ADDR_30
memalloc strhash.c(5): alloc 384 bytes at ADDR_31
memalloc test.c(4): alloc 32 bytes at ADDR_32
memalloc test.c(2): alloc 4 bytes at ADDR_33
memalloc strhash.c(4): alloc 40 bytes at ADDR_34
memalloc test.c(4): alloc 32 bytes at ADDR_35
memalloc test.c(2): alloc 4 bytes at ADDR_36
memalloc strhash.c(4): alloc 40 bytes at ADDR_37
memalloc test.c(3): free 12 bytes at ADDR_14 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_13 allocated at test.c(4)
memalloc strhash.c(3): free 40 bytes at ADDR_15 allocated at strhash.c(4)
memalloc test.c(3): free 12 bytes at ADDR_19 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_18 allocated at test.c(4)
memalloc strhash.c(3): free 40 bytes at ADDR_20 allocated at strhash.c(4)
memalloc test.c(3): free 12 bytes at ADDR_24 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_23 allocated at test.c(4)
memalloc strhash.c(2): free 384 bytes at ADDR_12 allocated at strhash.c(5)
memalloc strhash.c(2): free 44 bytes at ADDR_11 allocated at strhash.c(5)
memalloc strhash.c(3): free 40 bytes at ADDR_6 allocated at strhash.c(4)
memalloc test.c(3): free 4 bytes at ADDR_28 allocated at test.c(2)
memalloc test.c(4): free 32 bytes at ADDR_27 allocated at test.c(4)
memalloc strhash.c(3): free 40 bytes at ADDR_29 allocated at strhash.c(4)
memalloc test.c(3): free 4 bytes at ADDR_33 allocated at test.c(2)
memalloc test.c(4): free 32 bytes at ADDR_32 allocated at test.c(4)
memalloc strhash.c(3): free 40 bytes at ADDR_34 allocated at strhash.c(4)
memalloc test.c(3): free 4 bytes at ADDR_36 allocated at test.c(2)
memalloc test.c(4): free 32 bytes at ADDR_35 allocated at test.c(4)
memalloc strhash.c(2): free 384 bytes at ADDR_31 allocated at strhash.c(5)
memalloc strhash.c(2): free 44 bytes at ADDR_30 allocated at strhash.c(5)
memalloc strhash.c(3): free 40 bytes at ADDR_37 allocated at strhash.c(4)
memalloc test.c(4): alloc 32 bytes at ADDR_38
memalloc test.c(1): alloc 12 bytes at ADDR_39
memalloc strhash.c(4): alloc 40 bytes at ADDR_40
memalloc strhash.c(5): alloc 44 bytes at ADDR_41
memalloc strhash.c(5): alloc 384 bytes at ADDR_42
memalloc test.c(4): alloc 32 bytes at ADDR_43
memalloc test.c(1): alloc 12 bytes at ADDR_44
memalloc strhash.c(4): alloc 40 bytes at ADDR_45
memalloc test.c(4): alloc 32 bytes at ADDR_46
memalloc test.c(1): alloc 12 bytes at ADDR_47
memalloc strhash.c(4): alloc 40 bytes at ADDR_48
memalloc test.c(3): free 12 bytes at ADDR_39 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_38 allocated at test.c(4)
memalloc strhash.c(3): free 40 bytes at ADDR_40 allocated at strhash.c(4)
memalloc test.c(3): free 12 bytes at ADDR_44 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_43 allocated at test.c(4)
memalloc strhash.c(3): free 40 bytes at ADDR_45 allocated at strhash.c(4)
memalloc test.c(3): free 12 bytes at ADDR_47 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_46 allocated at test.c(4)
memalloc strhash.c(2): free 384 bytes at ADDR_42 allocated at strhash.c(5)
memalloc strhash.c(2): free 44 bytes at ADDR_41 allocated at strhash.c(5)
memalloc strhash.c(3): free 40 bytes at ADDR_48 allocated at strhash.c(4)
memalloc test.c(4): alloc 32 bytes at ADDR_49
memalloc test.c(1): alloc 12 bytes at ADDR_50
memalloc strhash.c(4): alloc 40 bytes at ADDR_51
memalloc strhash.c(5): alloc 44 bytes at ADDR_52
memalloc strhash.c(5): alloc 384 bytes at ADDR_53
memalloc test.c(4): alloc 32 bytes at ADDR_54
memalloc test.c(1): alloc 12 bytes at ADDR_55
memalloc strhash.c(4): alloc 40 bytes at ADDR_56
memalloc test.c(4): alloc 32 bytes at ADDR_57
memalloc test.c(1): alloc 12 bytes at ADDR_58
memalloc strhash.c(4): alloc 40 bytes at ADDR_59
memalloc test.c(3): free 12 bytes at ADDR_55 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_54 allocated at test.c(4)
memalloc strhash.c(3): free 40 bytes at ADDR_56 allocated at strhash.c(4)
memalloc test.c(3): free 12 bytes at ADDR_58 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_57 allocated at test.c(4)
memalloc strhash.c(3): free 40 bytes at ADDR_59 allocated at strhash.c(4)
memalloc test.c(3): free 12 bytes at ADDR_50 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_49 allocated at test.c(4)
memalloc strhash.c(2): free 384 bytes at ADDR_53 allocated at strhash.c(5)
memalloc strhash.c(2): free 44 bytes at ADDR_52 allocated at strhash.c(5)
memalloc strhash.c(3): free 40 bytes at ADDR_51 allocated at strhash.c(4)
memalloc test.c(5): free 32 bytes at ADDR_1 allocated at test.c(5)
memalloc test.c(5): alloc 32 bytes at ADDR_60
memalloc strhash.c(1): alloc 32 bytes at ADDR_61
memalloc test.c(4): alloc 32 bytes at ADDR_62
memalloc test.c(1): alloc 12 bytes at ADDR_63
memalloc strhash.c(4): alloc 40 bytes at ADDR_64
memalloc strhash.c(5): alloc 44 bytes at ADDR_65
memalloc strhash.c(5): alloc 384 bytes at ADDR_66
memalloc test.c(3): free 12 bytes at ADDR_63 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_62 allocated at test.c(4)
memalloc strhash.c(2): free 384 bytes at ADDR_66 allocated at strhash.c(5)
memalloc strhash.c(2): free 44 bytes at ADDR_65 allocated at strhash.c(5)
memalloc strhash.c(3): free 40 bytes at ADDR_64 allocated at strhash.c(4)
memalloc test.c(5): free 32 bytes at ADDR_60 allocated at test.c(5)
memalloc test.c(5): alloc 32 bytes at ADDR_67
memalloc strhash.c(1): alloc 32 bytes at ADDR_68
memalloc test.c(4): alloc 32 bytes at ADDR_69
memalloc test.c(1): alloc 12 bytes at ADDR_70
memalloc strhash.c(4): alloc 40 bytes at ADDR_71
memalloc strhash.c(5): alloc 44 bytes at ADDR_72
memalloc strhash.c(5): alloc 384 bytes at ADDR_73
memalloc test.c(4): alloc 32 bytes at ADDR_74
memalloc test.c(1): alloc 12 bytes at ADDR_75
memalloc strhash.c(4): alloc 40 bytes at ADDR_76
memalloc test.c(4): alloc 32 bytes at ADDR_77
memalloc test.c(1): alloc 12 bytes at ADDR_78
memalloc strhash.c(4): alloc 40 bytes at ADDR_79
memalloc test.c(3): free 12 bytes at ADDR_78 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_77 allocated at test.c(4)
memalloc strhash.c(3): free 40 bytes at ADDR_79 allocated at strhash.c(4)
memalloc test.c(3): free 12 bytes at ADDR_70 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_69 allocated at test.c(4)
memalloc strhash.c(3): free 40 bytes at ADDR_71 allocated at strhash.c(4)
memalloc test.c(3): free 12 bytes at ADDR_75 allocated at test.c(1)
memalloc test.c(4): free 32 bytes at ADDR_74 allocated at test.c(4)
memalloc strhash.c(2): free 384 bytes at ADDR_73 allocated at strhash.c(5)
memalloc strhash.c(2): free 44 bytes at ADDR_72 allocated at strhash.c(5)
memalloc strhash.c(3): free 40 bytes at ADDR_76 allocated at strhash.c(4)
memalloc test.c(5): free 32 bytes at ADDR_67 allocated at test.c(5)
memalloc strhash.c(1): free 32 bytes at ADDR_68 allocated at strhash.c(1)
memalloc strhash.c(1): free 32 bytes at ADDR_61 allocated at strhash.c(1)
memalloc test.c(5): free 32 bytes at ADDR_25 allocated at test.c(5)
memalloc strhash.c(1): free 32 bytes at ADDR_26 allocated at strhash.c(1)
memalloc strhash.c(1): free 32 bytes at ADDR_2 allocated at strhash.c(1)
memalloc strpool.c(6): free 4 bytes at ADDR_8 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_7 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_17 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_16 allocated at strpool.c(2)
memalloc strpool.c(5): free 384 bytes at ADDR_10 allocated at strpool.c(4)
memalloc strpool.c(5): free 44 bytes at ADDR_9 allocated at strpool.c(4)
memalloc strpool.c(6): free 4 bytes at ADDR_22 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_21 allocated at strpool.c(2)
memalloc strpool.c(1): free 32 bytes at ADDR_3 allocated at strpool.c(1)
memalloc: cleanup
ERR


unlink_testfiles();
done_testing;
