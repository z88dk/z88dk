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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-strhash.t,v 1.10 2013-09-01 00:18:30 pauloscustodio Exp $
# $Log: whitebox-strhash.t,v $
# Revision 1.10  2013-09-01 00:18:30  pauloscustodio
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
#
# Test strlist

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

# test memalloc
my $objs = "strhash.o strpool.o class.o die.o strutil.o safestr.o except.o";
ok ! system "make $objs";
my $compile = "-DMEMALLOC_DEBUG memalloc.c $objs";

t_compile_module(<<'END_INIT', <<'END', $compile);
#include "die.h"

#define ERROR return __LINE__

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

END_INIT
	/* main */
	StrHash *hash1, *hash2;
	StrHashElem *elem;
	
	warn("init\n");
	hash1 = OBJ_NEW(StrHash);
	if (StrHash_first(hash1) != NULL)			ERROR;
	check_list(hash1, "");
	
	StrHash_set(hash1, S("abc"), "123");
	check_list(hash1, "abc 123");
	
	StrHash_set(hash1, S("def"), "456");
	check_list(hash1, "abc 123 def 456");
	
	StrHash_set(hash1, S("ghi"), "789");
	check_list(hash1, "abc 123 def 456 ghi 789");
	
	StrHash_set(hash1, S("def"), "456");
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
	StrHash_set(hash1, S("abc"), "123");
	StrHash_set(hash1, S("def"), "456");
	StrHash_set(hash1, S("ghi"), "789");
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

	StrHash_set(hash1, S("abc"), "123");
	StrHash_set(hash1, S("def"), "456");
	StrHash_set(hash1, S("ghi"), "789");
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
	
	StrHash_set(hash1, S("abc"), "123");
	
	if (StrHash_empty(hash1)) ERROR;
	
	/* sort */
	OBJ_DELETE(hash1);
	hash1 = OBJ_NEW(StrHash);
	
	StrHash_set(hash1, S("def"), "456");
	check_list(hash1, "def 456");
	
	StrHash_set(hash1, S("abc"), "123");
	check_list(hash1, "def 456 abc 123");
	
	StrHash_set(hash1, S("ghi"), "789");
	check_list(hash1, "def 456 abc 123 ghi 789");
	
	StrHash_set(hash1, S("def"), "457");
	check_list(hash1, "def 457 abc 123 ghi 789");
	
	StrHash_sort(hash1, ascending);
	check_list(hash1, "abc 123 def 457 ghi 789");
	
	StrHash_sort(hash1, descending);
	check_list(hash1, "ghi 789 def 457 abc 123");
	
	return 0;
END

t_run_module([], "", <<ERR, 0);
init
memalloc: init
memalloc strhash.c(1): alloc 32 bytes at ADDR_1
memalloc strpool.c(1): alloc 32 bytes at ADDR_2
memalloc strhash.c(4): alloc 40 bytes at ADDR_3
memalloc strpool.c(2): alloc 36 bytes at ADDR_4
memalloc strpool.c(3): alloc 4 bytes at ADDR_5
memalloc strpool.c(4): alloc 44 bytes at ADDR_6
memalloc strpool.c(4): alloc 384 bytes at ADDR_7
memalloc strhash.c(5): alloc 44 bytes at ADDR_8
memalloc strhash.c(5): alloc 384 bytes at ADDR_9
memalloc strhash.c(4): alloc 40 bytes at ADDR_10
memalloc strpool.c(2): alloc 36 bytes at ADDR_11
memalloc strpool.c(3): alloc 4 bytes at ADDR_12
memalloc strhash.c(4): alloc 40 bytes at ADDR_13
memalloc strpool.c(2): alloc 36 bytes at ADDR_14
memalloc strpool.c(3): alloc 4 bytes at ADDR_15
memalloc strhash.c(1): alloc 32 bytes at ADDR_16
memalloc strhash.c(4): alloc 40 bytes at ADDR_17
memalloc strhash.c(5): alloc 44 bytes at ADDR_18
memalloc strhash.c(5): alloc 384 bytes at ADDR_19
memalloc strhash.c(4): alloc 40 bytes at ADDR_20
memalloc strhash.c(4): alloc 40 bytes at ADDR_21
memalloc strhash.c(3): free 40 bytes at ADDR_10 allocated at strhash.c(4)
memalloc strhash.c(3): free 40 bytes at ADDR_13 allocated at strhash.c(4)
memalloc strhash.c(2): free 384 bytes at ADDR_9 allocated at strhash.c(5)
memalloc strhash.c(2): free 44 bytes at ADDR_8 allocated at strhash.c(5)
memalloc strhash.c(3): free 40 bytes at ADDR_3 allocated at strhash.c(4)
memalloc strhash.c(3): free 40 bytes at ADDR_17 allocated at strhash.c(4)
memalloc strhash.c(3): free 40 bytes at ADDR_20 allocated at strhash.c(4)
memalloc strhash.c(2): free 384 bytes at ADDR_19 allocated at strhash.c(5)
memalloc strhash.c(2): free 44 bytes at ADDR_18 allocated at strhash.c(5)
memalloc strhash.c(3): free 40 bytes at ADDR_21 allocated at strhash.c(4)
memalloc strhash.c(4): alloc 40 bytes at ADDR_22
memalloc strhash.c(5): alloc 44 bytes at ADDR_23
memalloc strhash.c(5): alloc 384 bytes at ADDR_24
memalloc strhash.c(4): alloc 40 bytes at ADDR_25
memalloc strhash.c(4): alloc 40 bytes at ADDR_26
memalloc strhash.c(3): free 40 bytes at ADDR_22 allocated at strhash.c(4)
memalloc strhash.c(3): free 40 bytes at ADDR_25 allocated at strhash.c(4)
memalloc strhash.c(2): free 384 bytes at ADDR_24 allocated at strhash.c(5)
memalloc strhash.c(2): free 44 bytes at ADDR_23 allocated at strhash.c(5)
memalloc strhash.c(3): free 40 bytes at ADDR_26 allocated at strhash.c(4)
memalloc strhash.c(4): alloc 40 bytes at ADDR_27
memalloc strhash.c(5): alloc 44 bytes at ADDR_28
memalloc strhash.c(5): alloc 384 bytes at ADDR_29
memalloc strhash.c(4): alloc 40 bytes at ADDR_30
memalloc strhash.c(4): alloc 40 bytes at ADDR_31
memalloc strhash.c(3): free 40 bytes at ADDR_30 allocated at strhash.c(4)
memalloc strhash.c(3): free 40 bytes at ADDR_31 allocated at strhash.c(4)
memalloc strhash.c(2): free 384 bytes at ADDR_29 allocated at strhash.c(5)
memalloc strhash.c(2): free 44 bytes at ADDR_28 allocated at strhash.c(5)
memalloc strhash.c(3): free 40 bytes at ADDR_27 allocated at strhash.c(4)
memalloc strhash.c(1): free 32 bytes at ADDR_1 allocated at strhash.c(1)
memalloc strhash.c(1): alloc 32 bytes at ADDR_32
memalloc strhash.c(4): alloc 40 bytes at ADDR_33
memalloc strhash.c(5): alloc 44 bytes at ADDR_34
memalloc strhash.c(5): alloc 384 bytes at ADDR_35
memalloc strhash.c(2): free 384 bytes at ADDR_35 allocated at strhash.c(5)
memalloc strhash.c(2): free 44 bytes at ADDR_34 allocated at strhash.c(5)
memalloc strhash.c(3): free 40 bytes at ADDR_33 allocated at strhash.c(4)
memalloc strhash.c(1): free 32 bytes at ADDR_32 allocated at strhash.c(1)
memalloc strhash.c(1): alloc 32 bytes at ADDR_36
memalloc strhash.c(4): alloc 40 bytes at ADDR_37
memalloc strhash.c(5): alloc 44 bytes at ADDR_38
memalloc strhash.c(5): alloc 384 bytes at ADDR_39
memalloc strhash.c(4): alloc 40 bytes at ADDR_40
memalloc strhash.c(4): alloc 40 bytes at ADDR_41
memalloc strhash.c(3): free 40 bytes at ADDR_41 allocated at strhash.c(4)
memalloc strhash.c(3): free 40 bytes at ADDR_37 allocated at strhash.c(4)
memalloc strhash.c(2): free 384 bytes at ADDR_39 allocated at strhash.c(5)
memalloc strhash.c(2): free 44 bytes at ADDR_38 allocated at strhash.c(5)
memalloc strhash.c(3): free 40 bytes at ADDR_40 allocated at strhash.c(4)
memalloc strhash.c(1): free 32 bytes at ADDR_36 allocated at strhash.c(1)
memalloc strhash.c(1): free 32 bytes at ADDR_16 allocated at strhash.c(1)
memalloc strpool.c(6): free 4 bytes at ADDR_5 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_4 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_12 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_11 allocated at strpool.c(2)
memalloc strpool.c(5): free 384 bytes at ADDR_7 allocated at strpool.c(4)
memalloc strpool.c(5): free 44 bytes at ADDR_6 allocated at strpool.c(4)
memalloc strpool.c(6): free 4 bytes at ADDR_15 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_14 allocated at strpool.c(2)
memalloc strpool.c(1): free 32 bytes at ADDR_2 allocated at strpool.c(1)
memalloc: cleanup
ERR


unlink_testfiles();
done_testing;
