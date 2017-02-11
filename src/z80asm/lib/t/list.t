#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Test list.c

use Modern::Perl;
use Test::More;
use File::Slurp;
use Capture::Tiny 'capture';
use Test::Differences; 

my $compile = "gcc -Wall -otest test.c list.c class.c strpool.c alloc.c dbg.c";

write_file("test.c", <<'END');
#include "list.h"
#include "dbg.h"
#include <stdarg.h>

#define ERROR die("Test failed at line %d\n", __LINE__)

void check_list( List *list, ... )
{
	ListElem *iter;
	int count;
	va_list args;
	char *text;
	
	iter = List_first( list );
	va_start( args, list );
	count = 0;
	while ( (text = va_arg( args, char *)) != NULL )
	{
		if (iter == NULL)						ERROR;
		if (iter->data == NULL)					ERROR;
		if (strcmp(iter->data, text))			ERROR;
	
		iter = List_next(iter);
		count++;
	}
	if (iter != NULL)							ERROR;
	if (count && list == NULL)					ERROR;
	if (list != NULL && count != list->count)	ERROR;
	if (count && List_empty(list))				ERROR;
	if (! count && ! List_empty(list))			ERROR;
}

int main()
{
	List *list = NULL, *list2 = NULL;
	ListElem *iter;
	char *text;

	/* check empty list */
	check_list(NULL, NULL);
	

	/* push */
	OBJ_DELETE(list);
	check_list(list, NULL);

	if (list != NULL)							ERROR;
	List_push(&list, "a");
	if (list == NULL)							ERROR;
	check_list(list, "a", NULL);

	List_push(&list, "b");
	check_list(list, "a", "b", NULL);
	
	List_push(&list, "c");
	check_list(list, "a", "b", "c", NULL);
	
	List_remove_all(list);
	if (list == NULL)							ERROR;
	check_list(list, NULL);

	
	/* pop */
	OBJ_DELETE(list);
	check_list(list, NULL);

	List_push(&list, "a");
	List_push(&list, "b");
	List_push(&list, "c");
	check_list(list, "a", "b", "c", NULL);

	text = List_pop(list);
	if (strcmp(text, "c"))						ERROR;
	check_list(list, "a", "b", NULL);

	text = List_pop(list);
	if (strcmp(text, "b"))						ERROR;
	check_list(list, "a", NULL);

	text = List_pop(list);
	if (strcmp(text, "a"))						ERROR;
	check_list(list, NULL);
	
	text = List_pop(list);
	if (text != NULL)							ERROR;
	check_list(list, NULL);

	
	/* unshift */
	OBJ_DELETE(list);
	check_list(list, NULL);

	if (list != NULL)							ERROR;
	List_unshift(&list, "a");
	if (list == NULL)							ERROR;
	check_list(list, "a", NULL);

	List_unshift(&list, "b");
	check_list(list, "b", "a", NULL);
	
	List_unshift(&list, "c");
	check_list(list, "c", "b", "a", NULL);
	
	List_remove_all(list);
	if (list == NULL)							ERROR;
	check_list(list, NULL);

	
	/* shift */
	OBJ_DELETE(list);
	check_list(list, NULL);

	List_push(&list, "a");
	List_push(&list, "b");
	List_push(&list, "c");
	check_list(list, "a", "b", "c", NULL);

	text = List_shift(list);
	if (strcmp(text, "a"))						ERROR;
	check_list(list, "b", "c", NULL);

	text = List_shift(list);
	if (strcmp(text, "b"))						ERROR;
	check_list(list, "c", NULL);

	text = List_shift(list);
	if (strcmp(text, "c"))						ERROR;
	check_list(list, NULL);
	
	text = List_shift(list);
	if (text != NULL)							ERROR;
	check_list(list, NULL);

	
	/* first */
	OBJ_DELETE(list);
	check_list(list, NULL);

	if (List_first(NULL) != NULL)				ERROR;

	list = OBJ_NEW(List);
	if (List_first(list) != NULL)				ERROR;
	
	check_list(list, NULL);
	List_push(&list, "a");
	List_push(&list, "b");
	List_push(&list, "c");
	check_list(list, "a", "b", "c", NULL);

	if (List_first(list) == NULL)				ERROR;
	if (strcmp(List_first(list)->data, "a"))	ERROR;
	
	List_remove_all(list);
	if (list == NULL)							ERROR;
	check_list(list, NULL);

	
	/* last */
	OBJ_DELETE(list);
	check_list(list, NULL);

	if (List_last(NULL) != NULL)				ERROR;

	list = OBJ_NEW(List);
	if (List_last(list) != NULL)				ERROR;
	
	check_list(list, NULL);
	List_push(&list, "a");
	List_push(&list, "b");
	List_push(&list, "c");
	check_list(list, "a", "b", "c", NULL);

	if (List_last(list) == NULL)				ERROR;
	if (strcmp(List_last(list)->data, "c"))		ERROR;
	
	List_remove_all(list);
	if (list == NULL)							ERROR;
	check_list(list, NULL);

	
	/* next */
	OBJ_DELETE(list);
	check_list(list, NULL);

	if (List_next(NULL) != NULL)				ERROR;

	list = OBJ_NEW(List);
	iter = List_first(list);
	if (List_next(iter) != NULL)				ERROR;

	check_list(list, NULL);
	List_push(&list, "a");
	List_push(&list, "b");
	List_push(&list, "c");
	check_list(list, "a", "b", "c", NULL);

	iter = List_first(list);
	if (strcmp(iter->data, "a"))				ERROR;
	iter = List_next(iter);
	if (strcmp(iter->data, "b"))				ERROR;
	iter = List_next(iter);
	if (strcmp(iter->data, "c"))				ERROR;
	iter = List_next(iter);
	if (iter != NULL)							ERROR;
	
	
	/* prev */
	OBJ_DELETE(list);
	check_list(list, NULL);

	if (List_prev(NULL) != NULL)				ERROR;

	list = OBJ_NEW(List);
	iter = List_last(list);
	if (List_prev(iter) != NULL)				ERROR;

	check_list(list, NULL);
	List_push(&list, "a");
	List_push(&list, "b");
	List_push(&list, "c");
	check_list(list, "a", "b", "c", NULL);

	iter = List_last(list);
	if (strcmp(iter->data, "c"))				ERROR;
	iter = List_prev(iter);
	if (strcmp(iter->data, "b"))				ERROR;
	iter = List_prev(iter);
	if (strcmp(iter->data, "a"))				ERROR;
	iter = List_prev(iter);
	if (iter != NULL)							ERROR;
	
	
	/* insert after */
	OBJ_DELETE(list);
	check_list(list, NULL);

	List_insert_after(&list, NULL, "a");
	check_list(list, "a", NULL);
	
	List_insert_after(&list, NULL, "b");
	check_list(list, "a", "b", NULL);
	
	iter = List_first(list);
	List_insert_after(&list, iter, "A");
	check_list(list, "a", "A", "b", NULL);
	
	iter = List_last(list);
	List_insert_after(&list, iter, "B");
	check_list(list, "a", "A", "b", "B", NULL);
	
	
	/* insert before */
	OBJ_DELETE(list);
	check_list(list, NULL);

	List_insert_before(&list, NULL, "a");
	check_list(list, "a", NULL);
	
	List_insert_before(&list, NULL, "b");
	check_list(list, "b", "a", NULL);
	
	iter = List_first(list);
	List_insert_before(&list, iter, "A");
	check_list(list, "A", "b", "a", NULL);
	
	iter = List_last(list);
	List_insert_before(&list, iter, "B");
	check_list(list, "A", "b", "B", "a", NULL);
	
	
	/* remove */
	OBJ_DELETE(list);
	check_list(list, NULL);

	List_push(&list, "a");
	List_push(&list, "b");
	List_push(&list, "c");
	check_list(list, "a", "b", "c", NULL);

	iter = List_next(List_first(list));
	if (strcmp(iter->data, "b"))				ERROR;
	
	text = List_remove(list, &iter);
	if (strcmp(text, "b"))						ERROR;
	if (strcmp(iter->data, "c"))				ERROR;
	check_list(list, "a", "c", NULL);

	text = List_remove(list, &iter);
	if (strcmp(text, "c"))						ERROR;
	if (iter != NULL)							ERROR;
	check_list(list, "a", NULL);

	iter = List_first(list);
	if (strcmp(iter->data, "a"))				ERROR;

	text = List_remove(list, &iter);
	if (strcmp(text, "a"))						ERROR;
	if (iter != NULL)							ERROR;
	check_list(list, NULL);
	
	
	/* remove_all */
	OBJ_DELETE(list);
	check_list(list, NULL);

	List_push(&list, "a");
	List_push(&list, "b");
	List_push(&list, "c");
	check_list(list, "a", "b", "c", NULL);

	List_remove_all(list);
	check_list(list, NULL);
	

	OBJ_DELETE(list);
	check_list(list, NULL);

	List_push(&list, m_strdup("a"));
	List_push(&list, m_strdup("b"));
	List_push(&list, m_strdup("c"));
	check_list(list, "a", "b", "c", NULL);
	list->free_data = m_free_compat;
	
	List_remove_all(list);
	check_list(list, NULL);
	

	/* clone */
	OBJ_DELETE(list);
	check_list(list, NULL);

	List_push(&list, "a");
	List_push(&list, "b");
	List_push(&list, "c");
	check_list(list, "a", "b", "c", NULL);

	list2 = List_clone(list);
	check_list(list2, "a", "b", "c", NULL);
	
	text = List_shift(list); if (strcmp(text, "a")) ERROR;
	text = List_shift(list); if (strcmp(text, "b")) ERROR;
	text = List_shift(list); if (strcmp(text, "c")) ERROR;
	text = List_shift(list); if (text != NULL) 		ERROR;
	
	text = List_shift(list2); if (strcmp(text, "a")) ERROR;
	text = List_shift(list2); if (strcmp(text, "b")) ERROR;
	text = List_shift(list2); if (strcmp(text, "c")) ERROR;
	text = List_shift(list2); if (text != NULL)		 ERROR;
	
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
