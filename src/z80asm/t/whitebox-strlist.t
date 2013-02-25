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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-strlist.t,v 1.8 2013-02-25 21:36:17 pauloscustodio Exp $
# $Log: whitebox-strlist.t,v $
# Revision 1.8  2013-02-25 21:36:17  pauloscustodio
# Uniform the APIs of classhash, classlist, strhash, strlist
#
# Revision 1.7  2013/01/30 20:40:07  pauloscustodio
# Test cases
#
# Revision 1.6  2013/01/20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.5  2013/01/19 01:33:16  pauloscustodio
# Clean-up strpool code
#
# Revision 1.4  2013/01/19 00:04:53  pauloscustodio
# Implement StrHash_clone, required change in API of class.h and all classes that used it.
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
my $objs = "strlist.o strpool.o class.o die.o strutil.o safestr.o except.o";
ok ! system "make $objs";
my $compile = "-DMEMALLOC_DEBUG memalloc.c $objs";

t_compile_module(<<'END_INIT', <<'END', $compile);
#include "die.h"

#define ERROR return __LINE__

#define T_START(list)							\
	iter = StrList_first(list);

#define T_NEXT(list, text)						\
	if (! iter) 						ERROR;	\
	str = iter->string;							\
	if (! str) 							ERROR;	\
	if (strcmp(str, text)) 				ERROR;	\
	if (str != iter->string)			ERROR;	\
	iter = StrList_next(iter);					

#define T_END(list)								\
	iter = StrList_next(iter);					\
	if (iter) 							ERROR;

END_INIT
	/* main */
	StrList *l1, *l2;
	char *str;
	StrListElem *iter;
	
	l1 = OBJ_NEW(StrList);
	
	T_START(l1);
	T_END(l1);
	
	StrList_push(l1, "abc");

	T_START(l1);
	T_NEXT(l1, "abc");
	T_END(l1);
	
	StrList_push(l1, "def");

	T_START(l1);
	T_NEXT(l1, "abc");
	T_NEXT(l1, "def");
	T_END(l1);
	
	l2 = StrList_clone(l1);

	T_START(l1);
	T_NEXT(l1, "abc");
	T_NEXT(l1, "def");
	T_END(l1);
	
	T_START(l2);
	T_NEXT(l2, "abc");
	T_NEXT(l2, "def");
	T_END(l2);
	
	StrList_push(l1, "ghi");

	T_START(l1);
	T_NEXT(l1, "abc");
	T_NEXT(l1, "def");
	T_NEXT(l1, "ghi");
	T_END(l1);
	
	T_START(l2);
	T_NEXT(l2, "abc");
	T_NEXT(l2, "def");
	T_END(l2);
	
	StrList_push(l2, "jkl");

	T_START(l1);
	T_NEXT(l1, "abc");
	T_NEXT(l1, "def");
	T_NEXT(l1, "ghi");
	T_END(l1);
	
	T_START(l2);
	T_NEXT(l2, "abc");
	T_NEXT(l2, "def");
	T_NEXT(l2, "jkl");
	T_END(l2);
	
	/* empty */
	OBJ_DELETE(l1);
	l1 = OBJ_NEW(StrList);
	
	if (! StrList_empty(l1)) ERROR;
	
	StrList_push(l1, "abc");
	
	if (StrList_empty(l1)) ERROR;
	
	OBJ_DELETE(l1);
	OBJ_DELETE(l2);
	
	return 0;
END

t_run_module([], "", <<ERR, 0);
memalloc: init
memalloc strlist.c(1): alloc 36 bytes at ADDR_1
memalloc strpool.c(1): alloc 32 bytes at ADDR_2
memalloc strlist.c(3): alloc 12 bytes at ADDR_3
memalloc strpool.c(2): alloc 36 bytes at ADDR_4
memalloc strpool.c(3): alloc 4 bytes at ADDR_5
memalloc strpool.c(4): alloc 44 bytes at ADDR_6
memalloc strpool.c(4): alloc 384 bytes at ADDR_7
memalloc strlist.c(3): alloc 12 bytes at ADDR_8
memalloc strpool.c(2): alloc 36 bytes at ADDR_9
memalloc strpool.c(3): alloc 4 bytes at ADDR_10
memalloc strlist.c(1): alloc 36 bytes at ADDR_11
memalloc strlist.c(3): alloc 12 bytes at ADDR_12
memalloc strlist.c(3): alloc 12 bytes at ADDR_13
memalloc strlist.c(3): alloc 12 bytes at ADDR_14
memalloc strpool.c(2): alloc 36 bytes at ADDR_15
memalloc strpool.c(3): alloc 4 bytes at ADDR_16
memalloc strlist.c(3): alloc 12 bytes at ADDR_17
memalloc strpool.c(2): alloc 36 bytes at ADDR_18
memalloc strpool.c(3): alloc 4 bytes at ADDR_19
memalloc strlist.c(2): free 12 bytes at ADDR_3 allocated at strlist.c(3)
memalloc strlist.c(2): free 12 bytes at ADDR_8 allocated at strlist.c(3)
memalloc strlist.c(2): free 12 bytes at ADDR_14 allocated at strlist.c(3)
memalloc strlist.c(1): free 36 bytes at ADDR_1 allocated at strlist.c(1)
memalloc strlist.c(1): alloc 36 bytes at ADDR_20
memalloc strlist.c(3): alloc 12 bytes at ADDR_21
memalloc strlist.c(2): free 12 bytes at ADDR_21 allocated at strlist.c(3)
memalloc strlist.c(1): free 36 bytes at ADDR_20 allocated at strlist.c(1)
memalloc strlist.c(2): free 12 bytes at ADDR_12 allocated at strlist.c(3)
memalloc strlist.c(2): free 12 bytes at ADDR_13 allocated at strlist.c(3)
memalloc strlist.c(2): free 12 bytes at ADDR_17 allocated at strlist.c(3)
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
memalloc strpool.c(1): free 32 bytes at ADDR_2 allocated at strpool.c(1)
memalloc: cleanup
ERR


unlink_testfiles();
done_testing;
