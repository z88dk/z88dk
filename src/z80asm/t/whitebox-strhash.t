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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-strhash.t,v 1.1 2013-01-18 22:59:18 pauloscustodio Exp $
# $Log: whitebox-strhash.t,v $
# Revision 1.1  2013-01-18 22:59:18  pauloscustodio
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
	StrHash *hash;
	
	warn("init\n");
	hash = OBJ_NEW(StrHash);
	check_list(hash, "");
	
	if (StrHash_get(hash, "abc") != NULL)		ERROR;
	if (StrHash_get(hash, "def") != NULL)		ERROR;
	if (StrHash_get(hash, "ghi") != NULL)		ERROR;
	
	if ( StrHash_exists(hash, "abc"))			ERROR;
	if ( StrHash_exists(hash, "def"))			ERROR;
	if ( StrHash_exists(hash, "ghi"))			ERROR;
	
	StrHash_set(hash, "abc", (void*)1);
	check_list(hash, "abc 1");

	if (StrHash_get(hash, "abc") != (void*)1)	ERROR;
	if (StrHash_get(hash, "def") != NULL)		ERROR;
	if (StrHash_get(hash, "ghi") != NULL)		ERROR;
	
	if (!StrHash_exists(hash, "abc"))			ERROR;
	if ( StrHash_exists(hash, "def"))			ERROR;
	if ( StrHash_exists(hash, "ghi"))			ERROR;
	
	StrHash_set(hash, "def", (void*)2);
	check_list(hash, "abc 1 def 2");

	if (StrHash_get(hash, "abc") != (void*)1)	ERROR;
	if (StrHash_get(hash, "def") != (void*)2)	ERROR;
	if (StrHash_get(hash, "ghi") != NULL)		ERROR;
	
	if (!StrHash_exists(hash, "abc"))			ERROR;
	if (!StrHash_exists(hash, "def"))			ERROR;
	if ( StrHash_exists(hash, "ghi"))			ERROR;
	
	StrHash_set(hash, "ghi", (void*)3);
	check_list(hash, "abc 1 def 2 ghi 3");

	if (StrHash_get(hash, "abc") != (void*)1)	ERROR;
	if (StrHash_get(hash, "def") != (void*)2)	ERROR;
	if (StrHash_get(hash, "ghi") != (void*)3)	ERROR;
	
	if (!StrHash_exists(hash, "abc"))			ERROR;
	if (!StrHash_exists(hash, "def"))			ERROR;
	if (!StrHash_exists(hash, "ghi"))			ERROR;
	
	StrHash_remove(hash, "def");
	check_list(hash, "abc 1 ghi 3");

	if (StrHash_get(hash, "abc") != (void*)1)	ERROR;
	if (StrHash_get(hash, "def") != NULL)		ERROR;
	if (StrHash_get(hash, "ghi") != (void*)3)	ERROR;
	
	if (!StrHash_exists(hash, "abc"))			ERROR;
	if ( StrHash_exists(hash, "def"))			ERROR;
	if (!StrHash_exists(hash, "ghi"))			ERROR;
	
	StrHash_remove(hash, "def");
	check_list(hash, "abc 1 ghi 3");

	if (StrHash_get(hash, "abc") != (void*)1)	ERROR;
	if (StrHash_get(hash, "def") != NULL)		ERROR;
	if (StrHash_get(hash, "ghi") != (void*)3)	ERROR;
	
	if (!StrHash_exists(hash, "abc"))			ERROR;
	if ( StrHash_exists(hash, "def"))			ERROR;
	if (!StrHash_exists(hash, "ghi"))			ERROR;
	
	StrHash_remove(hash, "ghi");
	check_list(hash, "abc 1");

	if (StrHash_get(hash, "abc") != (void*)1)	ERROR;
	if (StrHash_get(hash, "def") != NULL)		ERROR;
	if (StrHash_get(hash, "ghi") != NULL)		ERROR;
	
	if (!StrHash_exists(hash, "abc"))			ERROR;
	if ( StrHash_exists(hash, "def"))			ERROR;
	if ( StrHash_exists(hash, "ghi"))			ERROR;
	
	StrHash_remove(hash, "abc");
	check_list(hash, "");

	if (StrHash_get(hash, "abc") != NULL)		ERROR;
	if (StrHash_get(hash, "def") != NULL)		ERROR;
	if (StrHash_get(hash, "ghi") != NULL)		ERROR;
	
	if ( StrHash_exists(hash, "abc"))			ERROR;
	if ( StrHash_exists(hash, "def"))			ERROR;
	if ( StrHash_exists(hash, "ghi"))			ERROR;
	
	return 0;
END

t_run_module([], "", <<ERR, 0);
init
memalloc: init
memalloc strhash.c(1): alloc 40 bytes at ADDR_1
memalloc strpool.c(1): alloc 28 bytes at ADDR_2
memalloc strhash.c(2): alloc 48 bytes at ADDR_3
memalloc strpool.c(2): alloc 36 bytes at ADDR_4
memalloc strpool.c(3): alloc 4 bytes at ADDR_5
memalloc strpool.c(4): alloc 44 bytes at ADDR_6
memalloc strpool.c(4): alloc 384 bytes at ADDR_7
memalloc strhash.c(3): alloc 44 bytes at ADDR_8
memalloc strhash.c(3): alloc 384 bytes at ADDR_9
memalloc strhash.c(2): alloc 48 bytes at ADDR_10
memalloc strpool.c(2): alloc 36 bytes at ADDR_11
memalloc strpool.c(3): alloc 4 bytes at ADDR_12
memalloc strhash.c(2): alloc 48 bytes at ADDR_13
memalloc strpool.c(2): alloc 36 bytes at ADDR_14
memalloc strpool.c(3): alloc 4 bytes at ADDR_15
memalloc strhash.c(5): free 48 bytes at ADDR_10 allocated at strhash.c(2)
memalloc strhash.c(5): free 48 bytes at ADDR_13 allocated at strhash.c(2)
memalloc strhash.c(4): free 384 bytes at ADDR_9 allocated at strhash.c(3)
memalloc strhash.c(4): free 44 bytes at ADDR_8 allocated at strhash.c(3)
memalloc strhash.c(5): free 48 bytes at ADDR_3 allocated at strhash.c(2)
memalloc strhash.c(1): free 40 bytes at ADDR_1 allocated at strhash.c(1)
memalloc strpool.c(6): free 4 bytes at ADDR_5 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_4 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_12 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_11 allocated at strpool.c(2)
memalloc strpool.c(5): free 384 bytes at ADDR_7 allocated at strpool.c(4)
memalloc strpool.c(5): free 44 bytes at ADDR_6 allocated at strpool.c(4)
memalloc strpool.c(6): free 4 bytes at ADDR_15 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_14 allocated at strpool.c(2)
memalloc strpool.c(1): free 28 bytes at ADDR_2 allocated at strpool.c(1)
memalloc: cleanup
ERR


unlink_testfiles();
done_testing;
