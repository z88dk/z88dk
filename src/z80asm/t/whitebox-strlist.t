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
#
# Test strlist

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

# test memalloc
my $objs = "strlist.o strpool.o class.o die.o strutil.o safestr.o except.o init.o";
ok ! system "make $objs";
my $compile = "-DMEMALLOC_DEBUG memalloc.c $objs";

t_compile_module(<<'END_INIT', <<'END', $compile);
#include "die.h"

#define ERROR return __LINE__

#define T_START(list)							\
	iter = SzList_first(list);

#define T_NEXT(list, text)						\
	if (! iter) 						ERROR;	\
	str = iter->string;							\
	if (! str) 							ERROR;	\
	if (strcmp(str, text)) 				ERROR;	\
	if (str != iter->string)			ERROR;	\
	iter = SzList_next(iter);					

#define T_END(list)								\
	iter = SzList_next(iter);					\
	if (iter) 							ERROR;

END_INIT
	/* main */
	SzList *l1, *l2;
	char *str;
	SzListElem *iter;
	
	l1 = OBJ_NEW(SzList);
	
	T_START(l1);
	T_END(l1);
	
	SzList_push(l1, "abc");

	T_START(l1);
	T_NEXT(l1, "abc");
	T_END(l1);
	
	SzList_push(l1, "def");

	T_START(l1);
	T_NEXT(l1, "abc");
	T_NEXT(l1, "def");
	T_END(l1);
	
	l2 = SzList_clone(l1);

	T_START(l1);
	T_NEXT(l1, "abc");
	T_NEXT(l1, "def");
	T_END(l1);
	
	T_START(l2);
	T_NEXT(l2, "abc");
	T_NEXT(l2, "def");
	T_END(l2);
	
	SzList_push(l1, "ghi");

	T_START(l1);
	T_NEXT(l1, "abc");
	T_NEXT(l1, "def");
	T_NEXT(l1, "ghi");
	T_END(l1);
	
	T_START(l2);
	T_NEXT(l2, "abc");
	T_NEXT(l2, "def");
	T_END(l2);
	
	SzList_push(l2, "jkl");

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
	l1 = OBJ_NEW(SzList);
	
	if (! SzList_empty(l1)) ERROR;
	
	SzList_push(l1, "abc");
	
	if (SzList_empty(l1)) ERROR;
	
	OBJ_DELETE(l1);
	OBJ_DELETE(l2);
	
	return 0;
END

t_run_module([], <<'OUT', <<'ERR', 0);
GLib Memory statistics (successful operations):
 blocks of | allocated  | freed      | allocated  | freed      | n_bytes   
  n_bytes  | n_times by | n_times by | n_times by | n_times by | remaining 
           | malloc()   | free()     | realloc()  | realloc()  |           
===========|============|============|============|============|===========
        12 |          7 |          7 |          0 |          0 |         +0
        20 |          1 |          1 |          0 |          0 |         +0
        36 |          3 |          3 |          0 |          0 |         +0
        96 |          1 |          1 |          0 |          0 |         +0
       252 |          3 |          0 |          0 |          0 |       +756
      1016 |          1 |          0 |          0 |          0 |      +1016
      1024 |          1 |          1 |          0 |          0 |         +0
GLib Memory statistics (failing operations):
 --- none ---
Total bytes: allocated=3104, zero-initialized=2060 (66.37%), freed=1332 (42.91%), remaining=1772
OUT
ERR


unlink_testfiles();
done_testing;


__END__
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-strlist.t,v 1.11 2013-09-01 17:08:17 pauloscustodio Exp $
# $Log: whitebox-strlist.t,v $
# Revision 1.11  2013-09-01 17:08:17  pauloscustodio
# Change in test output due to memalloc change.
#
# Revision 1.10  2013/09/01 11:52:56  pauloscustodio
# Setup memalloc on init.c.
# Setup GLib memory allocation functions to use memalloc functions.
#
# Revision 1.9  2013/02/27 20:47:30  pauloscustodio
# Renamed StrList to SzList to solve conflict with CLASS_LIST( Str ) also generating a class StrList
#
# Revision 1.8  2013/02/25 21:36:17  pauloscustodio
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
