#!/usr/bin/perl

# Copyright (C) Paulo Custodio, 2011-2014
#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/t/strhash.t,v 1.6 2014-04-19 14:57:58 pauloscustodio Exp $
#
# Test strhash.c

use Modern::Perl;
use Test::More;
use File::Slurp;
use Capture::Tiny 'capture';
use Test::Differences; 

my $compile = "cc -Wall -otest test.c strhash.c class.c xmalloc.c strpool.c strutil.c die.c";

write_file("test.c", <<'END');
#include "strhash.h"
#include "die.h"
#include <assert.h>

#define ERROR die("Test failed at line %d\n", __LINE__)

void _check_list (StrHash *hash, char *expected, char *file, int lineno)
{
	StrHashElem *iter, *elem;
	char tokens[256], wrong_key[256], *tokensp;
	char *exp_key, *exp_value, *value;
	int i;
	void *next_elem;
	
	/* strtok cannot modify constant strings */
	strcpy(tokens, expected);
	tokensp = tokens;
	
	for ( i = 0, iter = StrHash_first(hash); ; i++, iter = StrHash_next(iter) )
	{
		next_elem = iter ? iter->value : NULL;
		
		/* next expected key */
		exp_key = strtok(tokensp, " "); 
		tokensp = NULL;
		
		if (exp_key == NULL && next_elem)
		{
			die("%s %d : got %s, expected end of hash\n", 
			    file, lineno, iter->key);
		}
		else if (exp_key != NULL && ! next_elem)
		{
			die("%s %d : got end of hash, expected %s\n", 
			    file, lineno, exp_key);
		}
		else if (exp_key == NULL && ! next_elem)
		{
			break;		/* OK */
		}
		
		/* get expected value */
		exp_value = strtok(tokensp, " ");
		if (exp_value == NULL)
		{
			die("%s %d : exp_value should not be NULL\n", 
			    file, lineno);
		}
				
		/* check that key and value match */
		if (strcmp(iter->key, exp_key))
		{
			die("%s %d : key mismatch, got %s, expected %s\n", 
			    file, lineno, iter->key, exp_key);
		}
		
		if (strcmp(iter->value, exp_value))
		{
			die("%s %d : value mismatch, got %s, expected %s\n", 
			    file, lineno, iter->value, exp_value);
		}
		
		if (iter->value != next_elem)
		{
			die("%s %d : value pointer mismatch\n", 
			    file, lineno);
		}
		
		/* compute wrong key */
		strcpy(wrong_key, iter->key);
		(*wrong_key)++;

		/* check positive and negative StrHash_get() */
		value = StrHash_get(hash, iter->key);
		if (value == NULL || strcmp(value, iter->value))
		{
			die("%s %d : get(%s) = %s, expected %s\n", 
			    file, lineno, iter->key, value, iter->value);
		}

		value = StrHash_get(hash, wrong_key);
		if (value != NULL)
		{
			die("%s %d : get(%s) = %s, expected NULL\n", 
			    file, lineno, wrong_key, value);
		}
		
		/* check positive and negative StrHash_exists() */
		if ( ! StrHash_exists(hash, iter->key) )
		{
			die("%s %d : exists(%s) = FALSE, expected TRUE\n", 
			    file, lineno, iter->key);
		}

		if ( StrHash_exists(hash, wrong_key) )
		{
			die("%s %d : exists(%s) = TRUE, expected FALSE\n", 
			    file, lineno, wrong_key);
		}
		
		/* check positive and negative StrHash_find() */
		elem = StrHash_find(hash, iter->key);
		if ( elem == NULL || elem != iter )
		{
			die("%s %d : find(%s) failed\n", 
			    file, lineno, iter->key);
		}

		elem = StrHash_find(hash, wrong_key);
		if ( elem != NULL )
		{
			die("%s %d : find(%s) failed\n", 
			    file, lineno, wrong_key);
		}
	}
	
	/* check count */
	if ( hash != NULL && (size_t) i != hash->count )
		die("%s %d : count is %d, expected %d\n", file, lineno, hash->count, i);
}

#define check_list(hash,expected) _check_list(hash,expected,__FILE__,__LINE__)

int ascending (StrHashElem *a, StrHashElem *b)
{
	return strcmp((char*)(a->value), (char*)(b->value));
}

int descending (StrHashElem *a, StrHashElem *b)
{
	return strcmp((char*)(b->value), (char*)(a->value));
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
	StrHash *hash1, *hash2;
	StrHashElem *elem;
	
	/* no init */
	hash1 = NULL;

	if (StrHash_first(hash1) != NULL)			ERROR;
	check_list(hash1, "");
	
	StrHash_set(&hash1, S("abc"), "123");
	check_list(hash1, "abc 123");
	
	StrHash_set(&hash1, S("def"), "456");
	check_list(hash1, "abc 123 def 456");
	
	StrHash_set(&hash1, S("ghi"), "789");
	check_list(hash1, "abc 123 def 456 ghi 789");
	
	StrHash_set(&hash1, S("def"), "456");
	check_list(hash1, "abc 123 def 456 ghi 789");

	OBJ_DELETE( hash1 );
	
	
	/* init object */
	hash1 = OBJ_NEW(StrHash);
	if (StrHash_first(hash1) != NULL)			ERROR;
	check_list(hash1, "");
	
	StrHash_set(&hash1, S("abc"), "123");
	check_list(hash1, "abc 123");
	
	StrHash_set(&hash1, S("def"), "456");
	check_list(hash1, "abc 123 def 456");
	
	StrHash_set(&hash1, S("ghi"), "789");
	check_list(hash1, "abc 123 def 456 ghi 789");
	
	StrHash_set(&hash1, S("def"), "456");
	check_list(hash1, "abc 123 def 456 ghi 789");
	

	/* clone */
	hash2 = StrHash_clone(hash1);
	check_list(hash1, "abc 123 def 456 ghi 789");
	check_list(hash2, "abc 123 def 456 ghi 789");
	
	StrHash_remove(hash1, S("def"));
	check_list(hash1, "abc 123 ghi 789");
	check_list(hash2, "abc 123 def 456 ghi 789");
	
	StrHash_remove(hash1, S("def"));
	check_list(hash1, "abc 123 ghi 789");
	check_list(hash2, "abc 123 def 456 ghi 789");
	
	StrHash_remove(hash1, S("ghi"));
	check_list(hash1, "abc 123");
	check_list(hash2, "abc 123 def 456 ghi 789");

	StrHash_remove(hash1, S("abc"));
	check_list(hash1, "");
	check_list(hash2, "abc 123 def 456 ghi 789");

	StrHash_remove_all(hash1);
	check_list(hash1, "");
	check_list(hash2, "abc 123 def 456 ghi 789");
	
	StrHash_remove_all(hash2);
	check_list(hash1, "");
	check_list(hash2, "");
	
	
	/* head / remove_elem */
	StrHash_set(&hash1, S("abc"), "123");
	StrHash_set(&hash1, S("def"), "456");
	StrHash_set(&hash1, S("ghi"), "789");
	check_list(hash1, "abc 123 def 456 ghi 789");

	elem = StrHash_first(hash1); 
	if (elem == NULL) ERROR;
	if (strcmp(elem->key, "abc")) ERROR;
	StrHash_remove_elem(hash1, elem);
	check_list(hash1, "def 456 ghi 789");

	elem = StrHash_first(hash1); 
	if (elem == NULL) ERROR;
	if (strcmp(elem->key, "def")) ERROR;
	StrHash_remove_elem(hash1, elem);
	check_list(hash1, "ghi 789");

	elem = StrHash_first(hash1); 
	if (elem == NULL) ERROR;
	if (strcmp(elem->key, "ghi")) ERROR;
	StrHash_remove_elem(hash1, elem);
	check_list(hash1, "");

	elem = StrHash_first(hash1); 
	if (elem != NULL) ERROR;
	check_list(hash1, "");

	StrHash_set(&hash1, S("abc"), "123");
	StrHash_set(&hash1, S("def"), "456");
	StrHash_set(&hash1, S("ghi"), "789");
	check_list(hash1, "abc 123 def 456 ghi 789");

	elem = StrHash_find(hash1, S("def")); 
	if (elem == NULL) ERROR;
	if (strcmp(elem->key, "def")) ERROR;
	StrHash_remove_elem(hash1, elem);
	check_list(hash1, "abc 123 ghi 789");

	elem = StrHash_find(hash1, S("ghi")); 
	if (elem == NULL) ERROR;
	if (strcmp(elem->key, "ghi")) ERROR;
	StrHash_remove_elem(hash1, elem);
	check_list(hash1, "abc 123");

	elem = StrHash_find(hash1, S("abc")); 
	if (elem == NULL) ERROR;
	if (strcmp(elem->key, "abc")) ERROR;
	StrHash_remove_elem(hash1, elem);
	check_list(hash1, "");

	elem = StrHash_find(hash1, S("abc")); 
	if (elem != NULL) ERROR;
	check_list(hash1, "");
	
	/* empty */
	OBJ_DELETE(hash1);
	hash1 = OBJ_NEW(StrHash);
	
	if (! StrHash_empty(hash1)) ERROR;
	
	StrHash_set(&hash1, S("abc"), "123");
	
	if (StrHash_empty(hash1)) ERROR;
	
	
	/* sort */
	OBJ_DELETE(hash1);
	hash1 = OBJ_NEW(StrHash);
	
	StrHash_set(&hash1, S("def"), "456");
	check_list(hash1, "def 456");
	
	StrHash_set(&hash1, S("abc"), "123");
	check_list(hash1, "def 456 abc 123");
	
	StrHash_set(&hash1, S("ghi"), "789");
	check_list(hash1, "def 456 abc 123 ghi 789");
	
	StrHash_set(&hash1, S("def"), "457");
	check_list(hash1, "def 457 abc 123 ghi 789");
	
	StrHash_sort(hash1, ascending);
	check_list(hash1, "abc 123 def 457 ghi 789");
	
	StrHash_sort(hash1, descending);
	check_list(hash1, "ghi 789 def 457 abc 123");
	

	/* case-insensitive */
	hash1 = OBJ_NEW(StrHash);
	hash1->ignore_case = TRUE;
	if (StrHash_first(hash1) != NULL)			ERROR;
	check_list(hash1, "");
	
	StrHash_set(&hash1, S("abc"), "123");
	check_list(hash1, "ABC 123");
	
	StrHash_set(&hash1, S("Def"), "456");
	check_list(hash1, "ABC 123 DEF 456");
	
	StrHash_set(&hash1, S("GHI"), "789");
	check_list(hash1, "ABC 123 DEF 456 GHI 789");
	
	StrHash_set(&hash1, S("def"), "456");
	check_list(hash1, "ABC 123 DEF 456 GHI 789");
	
	
	/* free_data */
	OBJ_DELETE(hash1);
	hash1 = OBJ_NEW(StrHash);
	hash1->free_data = xfreef;
	
	StrHash_set(&hash1, "abc", xstrdup("123"));
	check_list(hash1, "abc 123");

	StrHash_set(&hash1, "def", xstrdup("456"));
	check_list(hash1, "abc 123 def 456");

	StrHash_set(&hash1, "abc", xstrdup("789"));
	check_list(hash1, "abc 789 def 456");
	
	StrHash_set(&hash1, "ghi", xstrdup("012"));
	check_list(hash1, "abc 789 def 456 ghi 012");
	
	StrHash_remove(hash1, "ghi");
	check_list(hash1, "abc 789 def 456");
	
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


# $Log: strhash.t,v $
# Revision 1.6  2014-04-19 14:57:58  pauloscustodio
# Fix test scripts to run in UNIX
#
# Revision 1.5  2014/04/05 14:37:54  pauloscustodio
# Added ignore_case attribute to allow case-insensitive string hashes
#
# Revision 1.4  2014/01/11 01:29:41  pauloscustodio
# Extend copyright to 2014.
# Move CVS log to bottom of file.
#
# Revision 1.3  2014/01/05 23:20:39  pauloscustodio
# List, StrHash classlist and classhash receive the address of the container
# object in all functions that add items to the container, and create the
# container on first use. This allows a container to be staticaly
# initialized with NULL and instantiated on first push/unshift/set.
# Add count attribute to StrHash, classhash to count elements in container.
# Add free_data attribute in StrHash to register a free fucntion to delete
# the data container when the hash is removed or a key is overwritten.
#
# Revision 1.2  2014/01/01 21:19:18  pauloscustodio
# Show error line in case of test failure
#
# Revision 1.1  2013/12/25 17:02:10  pauloscustodio
# Move strhash.c to the z80asm/lib directory
#
# Revision 1.16  2013/12/18 23:05:52  pauloscustodio
# Move class.c to the z80asm/lib directory
#
# Revision 1.15  2013/12/15 13:18:35  pauloscustodio
# Move memory allocation routines to lib/xmalloc, instead of glib,
# introduce memory leak report on exit and memory fence check.
#
# Revision 1.14  2013/09/09 00:20:45  pauloscustodio
# Add default set of modules to t_compile_module:
# -DMEMALLOC_DEBUG xmalloc.c die.o except.o strpool.o
#
# Revision 1.13  2013/09/08 00:43:59  pauloscustodio
# New error module with one error function per error, no need for the error
# constants. Allows compiler to type-check error message arguments.
# Included the errors module in the init() mechanism, no need to call
# error initialization from main(). Moved all error-testing scripts to
# one file errors.t.
#
# Revision 1.12  2013/09/01 17:10:49  pauloscustodio
# Change in test output due to xmalloc change.
#
# Revision 1.11  2013/09/01 11:52:56  pauloscustodio
# Setup xmalloc on init.c.
# Setup GLib memory allocation functions to use xmalloc functions.
#
# Revision 1.10  2013/09/01 00:18:30  pauloscustodio
# - Replaced e4c exception mechanism by a much simpler one based on a few
#   macros. The former did not allow an exit(1) to be called within a
#   try-catch block.
#
# Revision 1.9  2013/05/27 22:43:34  pauloscustodio
# StrHash_set failed when the key string buffer was reused later in the code.
# StrHash_get failed to retrieve object after the key used by StrHash_set was reused.
#
# Revision 1.8  2013/02/25 21:36:17  pauloscustodio
# Uniform the APIs of classhash, classlist, strhash, strlist
#
# Revision 1.7  2013/02/02 00:07:35  pauloscustodio
# StrHash_next() returns value instead of BOOL
#
# Revision 1.6  2013/01/22 22:24:49  pauloscustodio
# Removed StrHash_set_delptr() - not intuitive and error prone
# Added StrHash_remove_all() to remove all elements
# Added StrHash_remove_elem() to remove one item giving its address
#
# Revision 1.5  2013/01/22 01:02:54  pauloscustodio
# Removed CIRCLEQ from StrHash - redundant, UT_hash_handle contains a double-linked list
# Added StrHash_set_delptr() to define at create-key time the function to free the value when
# the item is deleted later.
# Added StrHash_head() to get head of list - usefull in a delete-all loop.
#
# Revision 1.4  2013/01/19 23:52:41  pauloscustodio
# strhash hanged on cleanup - delete by HASH_ITER / HASH_DEL
# instead of traversing CIRCLEQ
#
# Revision 1.3  2013/01/19 01:33:16  pauloscustodio
# Clean-up strpool code
#
# Revision 1.2  2013/01/19 00:04:53  pauloscustodio
# Implement StrHash_clone, required change in API of class.h and all classes that used it.
#
# Revision 1.1  2013/01/18 22:59:18  pauloscustodio
# CH_0016 : StrHash class to create maps from string to void*
# Created the StrHash to create hash tables mapping string keys kept in
# strpool to void* user pointer.
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
