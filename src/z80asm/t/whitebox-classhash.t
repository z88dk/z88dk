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
my $objs = "strhash.o class.o die.o strutil.o safestr.o except.o init.o strpool.o";
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

t_run_module([], <<'OUT', <<'ERR', 0);
GLib Memory statistics (successful operations):
 blocks of | allocated  | freed      | allocated  | freed      | n_bytes   
  n_bytes  | n_times by | n_times by | n_times by | n_times by | remaining 
           | malloc()   | free()     | realloc()  | realloc()  |           
===========|============|============|============|============|===========
         4 |          3 |          3 |          0 |          0 |         +0
        12 |         14 |         14 |          0 |          0 |         +0
        20 |          1 |          1 |          0 |          0 |         +0
        32 |         25 |         25 |          0 |          0 |         +0
        40 |         16 |         16 |          0 |          0 |         +0
        44 |          6 |          6 |          0 |          0 |         +0
        96 |          1 |          1 |          0 |          0 |         +0
       252 |          3 |          0 |          0 |          0 |       +756
       384 |          6 |          6 |          0 |          0 |         +0
      1016 |          1 |          0 |          0 |          0 |      +1016
      1024 |          1 |          1 |          0 |          0 |         +0
GLib Memory statistics (failing operations):
 --- none ---
Total bytes: allocated=7100, zero-initialized=5876 (82.76%), freed=5328 (75.04%), remaining=1772
OUT
ERR


unlink_testfiles();
done_testing;


__END__
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-classhash.t,v 1.5 2013-09-01 18:14:44 pauloscustodio Exp $
# $Log: whitebox-classhash.t,v $
# Revision 1.5  2013-09-01 18:14:44  pauloscustodio
# Change in test output due to memalloc change.
#
# Revision 1.4  2013/09/01 11:52:55  pauloscustodio
# Setup memalloc on init.c.
# Setup GLib memory allocation functions to use memalloc functions.
#
# Revision 1.3  2013/05/27 22:43:34  pauloscustodio
# StrHash_set failed when the key string buffer was reused later in the code.
# StrHash_get failed to retrieve object after the key used by StrHash_set was reused.
#
# Revision 1.2  2013/02/25 21:36:17  pauloscustodio
# Uniform the APIs of classhash, classlist, strhash, strlist
#
# Revision 1.1  2013/02/02 00:08:26  pauloscustodio
# New CLASS_HASH() to create hash tables of objects defined by CLASS()
