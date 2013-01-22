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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-strhash.t,v 1.5 2013-01-22 01:02:54 pauloscustodio Exp $
# $Log: whitebox-strhash.t,v $
# Revision 1.5  2013-01-22 01:02:54  pauloscustodio
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

void *alloc_data(char *data) 
{
	void *p = xstrdup(data);
	warn("alloc_data(\"%s\")\n", p);
	return p;
}

void free_data(void *data) 
{
	warn("free_data(\"%s\")\n", data);
	xfree(data);
}

void _check_list (StrHash *hash, char *expected, char *file, int lineno)
{
	StrHashElem *iter;
	char *exp_key, *got_string;
	int exp_value; 
	char tokens[256], *tokensp;
	
	/* strtok cannot modify constant strings */
	strcpy(tokens, expected);
	tokensp = tokens;
	
	StrHash_first(hash, &iter);
	while (1) {
		exp_key   = strtok(tokensp, " "); tokensp = NULL;
		exp_value = atoi(strtok(tokensp, " ")); tokensp = NULL;
		
		got_string = StrHash_next(hash, &iter) ? iter->key : NULL;
		
		if (exp_key == NULL && got_string != NULL)
			die(AssertionException, "%s(%d): got %s, expected end of hash\n", 
			    file, lineno, got_string);
		else if (exp_key != NULL && got_string == NULL)
			die(AssertionException, "%s(%d): got end of hash, expected %s\n", 
			    file, lineno, exp_key);
		else if (exp_key == NULL && got_string == NULL)
			break;		/* OK */
		else if (strcmp(exp_key, got_string) != 0)
			die(AssertionException, "%s(%d): got %s, expected %s\n", 
			    file, lineno, got_string, exp_key);
		else if (exp_value != (int)iter->value)
			die(AssertionException, "%s(%d): got %d, expected %d\n", 
			    file, lineno, (int)iter->value, exp_value);
	}
}	

#define check_list(hash,expected) _check_list(hash,expected,__FILE__,__LINE__)

END_INIT
	/* main */
	StrHash *hash1, *hash2;
	
	warn("init\n");
	hash1 = OBJ_NEW(StrHash);
	check_list(hash1, "");
	
	if (StrHash_head(hash1) != NULL)			ERROR;
	
	if (StrHash_get(hash1, "abc") != NULL)		ERROR;
	if (StrHash_get(hash1, "def") != NULL)		ERROR;
	if (StrHash_get(hash1, "ghi") != NULL)		ERROR;
	
	if ( StrHash_exists(hash1, "abc"))			ERROR;
	if ( StrHash_exists(hash1, "def"))			ERROR;
	if ( StrHash_exists(hash1, "ghi"))			ERROR;
	
	StrHash_set(hash1, "abc", (void*)1);
	check_list(hash1, "abc 1");

	if (StrHash_head(hash1) != StrHash_find(hash1, "abc"))	ERROR;
	
	if (StrHash_get(hash1, "abc") != (void*)1)	ERROR;
	if (StrHash_get(hash1, "def") != NULL)		ERROR;
	if (StrHash_get(hash1, "ghi") != NULL)		ERROR;
	
	if (!StrHash_exists(hash1, "abc"))			ERROR;
	if ( StrHash_exists(hash1, "def"))			ERROR;
	if ( StrHash_exists(hash1, "ghi"))			ERROR;
	
	StrHash_set(hash1, "def", (void*)2);
	check_list(hash1, "abc 1 def 2");

	if (StrHash_head(hash1) != StrHash_find(hash1, "abc"))	ERROR;

	if (StrHash_get(hash1, "abc") != (void*)1)	ERROR;
	if (StrHash_get(hash1, "def") != (void*)2)	ERROR;
	if (StrHash_get(hash1, "ghi") != NULL)		ERROR;
	
	if (!StrHash_exists(hash1, "abc"))			ERROR;
	if (!StrHash_exists(hash1, "def"))			ERROR;
	if ( StrHash_exists(hash1, "ghi"))			ERROR;
	
	StrHash_set(hash1, "ghi", (void*)3);
	check_list(hash1, "abc 1 def 2 ghi 3");

	if (StrHash_head(hash1) != StrHash_find(hash1, "abc"))	ERROR;

	if (StrHash_get(hash1, "abc") != (void*)1)	ERROR;
	if (StrHash_get(hash1, "def") != (void*)2)	ERROR;
	if (StrHash_get(hash1, "ghi") != (void*)3)	ERROR;
	
	if (!StrHash_exists(hash1, "abc"))			ERROR;
	if (!StrHash_exists(hash1, "def"))			ERROR;
	if (!StrHash_exists(hash1, "ghi"))			ERROR;
	
	
	/* clone */
	hash2 = StrHash_clone(hash1);
	check_list(hash2, "abc 1 def 2 ghi 3");
	
	if (StrHash_get(hash2, "abc") != (void*)1)	ERROR;
	if (StrHash_get(hash2, "def") != (void*)2)	ERROR;
	if (StrHash_get(hash2, "ghi") != (void*)3)	ERROR;
	
	if (!StrHash_exists(hash2, "abc"))			ERROR;
	if (!StrHash_exists(hash2, "def"))			ERROR;
	if (!StrHash_exists(hash2, "ghi"))			ERROR;
	
	
	StrHash_remove(hash1, "def");
	check_list(hash1, "abc 1 ghi 3");

	if (StrHash_get(hash1, "abc") != (void*)1)	ERROR;
	if (StrHash_get(hash1, "def") != NULL)		ERROR;
	if (StrHash_get(hash1, "ghi") != (void*)3)	ERROR;
	
	if (!StrHash_exists(hash1, "abc"))			ERROR;
	if ( StrHash_exists(hash1, "def"))			ERROR;
	if (!StrHash_exists(hash1, "ghi"))			ERROR;
	
	StrHash_remove(hash1, "def");
	check_list(hash1, "abc 1 ghi 3");

	if (StrHash_get(hash1, "abc") != (void*)1)	ERROR;
	if (StrHash_get(hash1, "def") != NULL)		ERROR;
	if (StrHash_get(hash1, "ghi") != (void*)3)	ERROR;
	
	if (!StrHash_exists(hash1, "abc"))			ERROR;
	if ( StrHash_exists(hash1, "def"))			ERROR;
	if (!StrHash_exists(hash1, "ghi"))			ERROR;
	
	StrHash_remove(hash1, "ghi");
	check_list(hash1, "abc 1");

	if (StrHash_get(hash1, "abc") != (void*)1)	ERROR;
	if (StrHash_get(hash1, "def") != NULL)		ERROR;
	if (StrHash_get(hash1, "ghi") != NULL)		ERROR;
	
	if (!StrHash_exists(hash1, "abc"))			ERROR;
	if ( StrHash_exists(hash1, "def"))			ERROR;
	if ( StrHash_exists(hash1, "ghi"))			ERROR;
	
	StrHash_remove(hash1, "abc");
	check_list(hash1, "");

	if (StrHash_get(hash1, "abc") != NULL)		ERROR;
	if (StrHash_get(hash1, "def") != NULL)		ERROR;
	if (StrHash_get(hash1, "ghi") != NULL)		ERROR;
	
	if ( StrHash_exists(hash1, "abc"))			ERROR;
	if ( StrHash_exists(hash1, "def"))			ERROR;
	if ( StrHash_exists(hash1, "ghi"))			ERROR;

	
	check_list(hash2, "abc 1 def 2 ghi 3");

	if (StrHash_get(hash2, "abc") != (void*)1)	ERROR;
	if (StrHash_get(hash2, "def") != (void*)2)	ERROR;
	if (StrHash_get(hash2, "ghi") != (void*)3)	ERROR;
	
	if (!StrHash_exists(hash2, "abc"))			ERROR;
	if (!StrHash_exists(hash2, "def"))			ERROR;
	if (!StrHash_exists(hash2, "ghi"))			ERROR;
	
	StrHash_remove(hash2, "abc");
	check_list(hash2, "def 2 ghi 3");
	
	if (StrHash_get(hash2, "abc") != NULL)		ERROR;
	if (StrHash_get(hash2, "def") != (void*)2)	ERROR;
	if (StrHash_get(hash2, "ghi") != (void*)3)	ERROR;
	
	if ( StrHash_exists(hash2, "abc"))			ERROR;
	if (!StrHash_exists(hash2, "def"))			ERROR;
	if (!StrHash_exists(hash2, "ghi"))			ERROR;

	StrHash_remove(hash2, "def");
	check_list(hash2, "ghi 3");
	
	StrHash_remove(hash2, "ghi");
	check_list(hash2, "");

	/* test auto-delete of values */
	StrHash_set_delptr(hash1, "abc", alloc_data("abc"), free_data);
	StrHash_set_delptr(hash1, "def", alloc_data("def"), free_data);
	StrHash_set_delptr(hash1, "ghi", alloc_data("ghi"), free_data);
	
	if (strcmp(StrHash_get(hash1, "abc"), "abc"))	ERROR;
	if (strcmp(StrHash_get(hash1, "def"), "def"))	ERROR;
	if (strcmp(StrHash_get(hash1, "ghi"), "ghi"))	ERROR;
	
	/* Automagically deletes data */
	StrHash_remove(hash1, "def");

	return 0;
END

t_run_module([], "", <<ERR, 0);
init
memalloc: init
memalloc strhash.c(1): alloc 32 bytes at ADDR_1
memalloc strpool.c(1): alloc 32 bytes at ADDR_2
memalloc strhash.c(4): alloc 44 bytes at ADDR_3
memalloc strpool.c(2): alloc 36 bytes at ADDR_4
memalloc strpool.c(3): alloc 4 bytes at ADDR_5
memalloc strpool.c(4): alloc 44 bytes at ADDR_6
memalloc strpool.c(4): alloc 384 bytes at ADDR_7
memalloc strhash.c(5): alloc 44 bytes at ADDR_8
memalloc strhash.c(5): alloc 384 bytes at ADDR_9
memalloc strhash.c(4): alloc 44 bytes at ADDR_10
memalloc strpool.c(2): alloc 36 bytes at ADDR_11
memalloc strpool.c(3): alloc 4 bytes at ADDR_12
memalloc strhash.c(4): alloc 44 bytes at ADDR_13
memalloc strpool.c(2): alloc 36 bytes at ADDR_14
memalloc strpool.c(3): alloc 4 bytes at ADDR_15
memalloc strhash.c(1): alloc 32 bytes at ADDR_16
memalloc strhash.c(4): alloc 44 bytes at ADDR_17
memalloc strhash.c(5): alloc 44 bytes at ADDR_18
memalloc strhash.c(5): alloc 384 bytes at ADDR_19
memalloc strhash.c(4): alloc 44 bytes at ADDR_20
memalloc strhash.c(4): alloc 44 bytes at ADDR_21
memalloc strhash.c(3): free 44 bytes at ADDR_10 allocated at strhash.c(4)
memalloc strhash.c(3): free 44 bytes at ADDR_13 allocated at strhash.c(4)
memalloc strhash.c(2): free 384 bytes at ADDR_9 allocated at strhash.c(5)
memalloc strhash.c(2): free 44 bytes at ADDR_8 allocated at strhash.c(5)
memalloc strhash.c(3): free 44 bytes at ADDR_3 allocated at strhash.c(4)
memalloc strhash.c(3): free 44 bytes at ADDR_17 allocated at strhash.c(4)
memalloc strhash.c(3): free 44 bytes at ADDR_20 allocated at strhash.c(4)
memalloc strhash.c(2): free 384 bytes at ADDR_19 allocated at strhash.c(5)
memalloc strhash.c(2): free 44 bytes at ADDR_18 allocated at strhash.c(5)
memalloc strhash.c(3): free 44 bytes at ADDR_21 allocated at strhash.c(4)
memalloc test.c(1): alloc 4 bytes at ADDR_22
alloc_data("abc")
memalloc strhash.c(4): alloc 44 bytes at ADDR_23
memalloc strhash.c(5): alloc 44 bytes at ADDR_24
memalloc strhash.c(5): alloc 384 bytes at ADDR_25
memalloc test.c(1): alloc 4 bytes at ADDR_26
alloc_data("def")
memalloc strhash.c(4): alloc 44 bytes at ADDR_27
memalloc test.c(1): alloc 4 bytes at ADDR_28
alloc_data("ghi")
memalloc strhash.c(4): alloc 44 bytes at ADDR_29
free_data("def")
memalloc test.c(2): free 4 bytes at ADDR_26 allocated at test.c(1)
memalloc strhash.c(3): free 44 bytes at ADDR_27 allocated at strhash.c(4)
memalloc strhash.c(1): free 32 bytes at ADDR_16 allocated at strhash.c(1)
free_data("abc")
memalloc test.c(2): free 4 bytes at ADDR_22 allocated at test.c(1)
memalloc strhash.c(3): free 44 bytes at ADDR_23 allocated at strhash.c(4)
memalloc strhash.c(2): free 384 bytes at ADDR_25 allocated at strhash.c(5)
memalloc strhash.c(2): free 44 bytes at ADDR_24 allocated at strhash.c(5)
free_data("ghi")
memalloc test.c(2): free 4 bytes at ADDR_28 allocated at test.c(1)
memalloc strhash.c(3): free 44 bytes at ADDR_29 allocated at strhash.c(4)
memalloc strhash.c(1): free 32 bytes at ADDR_1 allocated at strhash.c(1)
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
