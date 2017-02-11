#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Test classlist.c

use Modern::Perl;
use Test::More;
use File::Slurp;
use Capture::Tiny 'capture';
use Test::Differences; 

my $compile = "gcc -Wall -otest test.c class.c strpool.c alloc.c dbg.c";

write_file("test.c", <<'END');
#include "classlist.h"
#include "dbg.h"

#define ERROR die("Test failed at line %d\n", __LINE__)

CLASS(Obj)
	char *string;
END_CLASS;

void Obj_init (Obj *self) 	{ self->string = m_strdup("Hello World"); }
void Obj_copy (Obj *self, Obj *other)
							{ self->string = m_strdup(other->string); }
void Obj_fini (Obj *self)	{ m_free(self->string); }

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
	ObjList_unshift( &list, new_obj("abc") );
	
	T_START(list);
	T_NEXT(list, "abc");
	T_END(list);
	
	ObjList_unshift( &list, new_obj("def") );
	
	T_START(list);
	T_NEXT(list, "def");
	T_NEXT(list, "abc");
	T_END(list);
	
	
	/* push */
	ObjList_push( &list, new_obj("ghi") );
	
	T_START(list);
	T_NEXT(list, "def");
	T_NEXT(list, "abc");
	T_NEXT(list, "ghi");
	T_END(list);

	ObjList_push( &list, new_obj("jkl") );
	
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
	ObjList_insert_after( &list, iter, new_obj("AAA") );
	
	T_START(list);
	T_NEXT(list, "def");
	T_NEXT(list, "AAA");
	T_NEXT(list, "abc");
	T_NEXT(list, "ghi");
	T_NEXT(list, "jkl");
	T_END(list);
	
	iter = ObjList_last(list);
	ObjList_insert_after( &list, iter, new_obj("ZZZ") );
	
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
	ObjList_insert_before( &list, iter, new_obj("BBB") );
	
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
	ObjList_insert_before( &list, iter, new_obj("XXX") );
	
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
	
	ObjList_push( &list, new_obj("abc") );
	ObjList_push( &list, new_obj("def") );
	ObjList_push( &list, new_obj("ghi") );
	
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
	
	ObjList_push( &list, new_obj("abc") );
	
	if (ObjList_empty(list)) ERROR;
	
	return 0;
}
END

system($compile) and die "compile failed: $compile\n";
t_capture("./test", "", "", 0);


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
