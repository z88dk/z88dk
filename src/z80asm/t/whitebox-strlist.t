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
# Copyright (C) Paulo Custodio, 2011-2012

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-strlist.t,v 1.1 2012-05-24 21:42:42 pauloscustodio Exp $
# $Log: whitebox-strlist.t,v $
# Revision 1.1  2012-05-24 21:42:42  pauloscustodio
# CH_0011 : new string list class to hold lists of strings
#
#
# Test strlist

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

# test memalloc
my $compile = "-DMEMALLOC_DEBUG strlist.c strpool.c memalloc.c class.c die.c strutil.c except.c";

t_compile_module(<<'END_INIT', <<'END', $compile);
#include "die.h"

#define ERROR return __LINE__

void _check_list (StrList *list, char *expected, char *file, int lineno)
{
	StrListElem *iter;
	char *exp_string, *got_string;
	char tokens[256], *tokensp;
	
	/* strtok cannot modify constant strings */
	strcpy(tokens, expected);
	tokensp = tokens;
	
	StrList_first(list, &iter);
	while (1) {
		exp_string = strtok(tokensp, " "); tokensp = NULL;
		got_string = StrList_next(list, &iter);
		
		if (exp_string == NULL && got_string != NULL)
			die(AssertionException, "%s(%d): got %s, expected end of list\n", 
			    file, lineno, got_string);
		else if (exp_string != NULL && got_string == NULL)
			die(AssertionException, "%s(%d): got end of list, expected %s\n", 
			    file, lineno, exp_string);
		else if (exp_string == NULL && got_string == NULL)
			break;		/* OK */
		else if (strcmp(exp_string, got_string) != 0)
			die(AssertionException, "%s(%d): got %s, expected %s\n", 
			    file, lineno, got_string, exp_string);
	}
}	

#define check_list(list,expected) _check_list(list,expected,__FILE__,__LINE__)

END_INIT
	/* main */
	StrList *l1, *l2;
	
	warn("init\n");
	l1 = OBJ_NEW(StrList);
	check_list(l1, "");
	
	StrList_append(l1, "abc");
	check_list(l1, "abc");

	StrList_append(l1, "def");
	check_list(l1, "abc def");

	l2 = StrList_clone(l1);
	check_list(l1, "abc def");
	check_list(l2, "abc def");
	
	StrList_append(l1, "ghi");
	check_list(l1, "abc def ghi");
	check_list(l2, "abc def");

	StrList_append(l2, "jkl");
	check_list(l1, "abc def ghi");
	check_list(l2, "abc def jkl");

	OBJ_DELETE(l1);
	OBJ_DELETE(l2);
	
	return 0;
END

t_run_module([], "", <<ERR, 0);
init
memalloc: init
memalloc strlist.c(1): alloc 36 bytes at ADDR_1
memalloc strpool.c(1): alloc 28 bytes at ADDR_2
memalloc strlist.c(4): alloc 12 bytes at ADDR_3
memalloc strpool.c(2): alloc 36 bytes at ADDR_4
memalloc strpool.c(3): alloc 4 bytes at ADDR_5
memalloc strpool.c(4): alloc 44 bytes at ADDR_6
memalloc strpool.c(4): alloc 384 bytes at ADDR_7
memalloc strlist.c(4): alloc 12 bytes at ADDR_8
memalloc strpool.c(2): alloc 36 bytes at ADDR_9
memalloc strpool.c(3): alloc 4 bytes at ADDR_10
memalloc strlist.c(1): alloc 36 bytes at ADDR_11
memalloc strlist.c(2): alloc 12 bytes at ADDR_12
memalloc strlist.c(2): alloc 12 bytes at ADDR_13
memalloc strlist.c(4): alloc 12 bytes at ADDR_14
memalloc strpool.c(2): alloc 36 bytes at ADDR_15
memalloc strpool.c(3): alloc 4 bytes at ADDR_16
memalloc strlist.c(4): alloc 12 bytes at ADDR_17
memalloc strpool.c(2): alloc 36 bytes at ADDR_18
memalloc strpool.c(3): alloc 4 bytes at ADDR_19
memalloc strlist.c(3): free 12 bytes at ADDR_3 allocated at strlist.c(4)
memalloc strlist.c(3): free 12 bytes at ADDR_8 allocated at strlist.c(4)
memalloc strlist.c(3): free 12 bytes at ADDR_14 allocated at strlist.c(4)
memalloc strlist.c(1): free 36 bytes at ADDR_1 allocated at strlist.c(1)
memalloc strlist.c(3): free 12 bytes at ADDR_12 allocated at strlist.c(2)
memalloc strlist.c(3): free 12 bytes at ADDR_13 allocated at strlist.c(2)
memalloc strlist.c(3): free 12 bytes at ADDR_17 allocated at strlist.c(4)
memalloc strlist.c(1): free 36 bytes at ADDR_11 allocated at strlist.c(1)
memalloc strpool.c(6): free 4 bytes at ADDR_5 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_4 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_10 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_9 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_16 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_15 allocated at strpool.c(2)
memalloc strpool.c(5): free 384 bytes at ADDR_7 allocated at strpool.c(4)
memalloc strpool.c(5): free 44 bytes at ADDR_6 allocated at strpool.c(4)
memalloc strpool.c(6): free 4 bytes at ADDR_19 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_18 allocated at strpool.c(2)
memalloc strpool.c(1): free 28 bytes at ADDR_2 allocated at strpool.c(1)
memalloc: cleanup
ERR


unlink_testfiles();
done_testing;
