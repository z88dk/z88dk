#!/usr/bin/perl

# Copyright (C) Paulo Custodio, 2011-2013
#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/t/classhash.t,v 1.1 2013-12-25 17:37:13 pauloscustodio Exp $
#
# Test classhash.c

use Modern::Perl;
use Test::More;
use File::Slurp;
use Capture::Tiny 'capture';
use Test::Differences; 

my $compile = "cc -Wall -otest test.c strhash.c strpool.c class.c xmalloc.c die.c";

write_file("test.c", <<'END');
#include "classhash.h"
#include "die.h"

#define ERROR return __LINE__

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

int main()
{
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


# $Log: classhash.t,v $
# Revision 1.1  2013-12-25 17:37:13  pauloscustodio
# Move classlist and classhash to the z80asm/lib directory
#
# Revision 1.12  2013/12/25 17:02:10  pauloscustodio
# Move strhash.c to the z80asm/lib directory
#
# Revision 1.11  2013/12/18 23:05:52  pauloscustodio
# Move class.c to the z80asm/lib directory
#
# Revision 1.10  2013/12/15 13:18:35  pauloscustodio
# Move memory allocation routines to lib/xmalloc, instead of glib,
# introduce memory leak report on exit and memory fence check.
#
# Revision 1.9  2013/09/22 21:06:00  pauloscustodio
# replace g_free by g_free0
#
# Revision 1.8  2013/09/09 00:20:45  pauloscustodio
# Add default set of modules to t_compile_module:
# -DMEMALLOC_DEBUG xmalloc.c die.o except.o strpool.o
#
# Revision 1.7  2013/09/08 08:29:21  pauloscustodio
# Replaced xmalloc et al with glib functions
#
# Revision 1.6  2013/09/08 00:43:59  pauloscustodio
# New error module with one error function per error, no need for the error
# constants. Allows compiler to type-check error message arguments.
# Included the errors module in the init() mechanism, no need to call
# error initialization from main(). Moved all error-testing scripts to
# one file errors.t.
#
# Revision 1.5  2013/09/01 18:14:44  pauloscustodio
# Change in test output due to xmalloc change.
#
# Revision 1.4  2013/09/01 11:52:55  pauloscustodio
# Setup xmalloc on init.c.
# Setup GLib memory allocation functions to use xmalloc functions.
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
