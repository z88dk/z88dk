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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-memalloc.t,v 1.2 2012-05-20 06:32:50 pauloscustodio Exp $
# $Log: whitebox-memalloc.t,v $
# Revision 1.2  2012-05-20 06:32:50  pauloscustodio
# Added tests
#
# Revision 1.1  2012/05/20 05:48:26  pauloscustodio
# Test garbage collector
#
# Revision 1.1  2012/05/17 15:04:47  pauloscustodio
# white box test of new modules
#
# Revision 1.1  2012/04/22 20:32:20  pauloscustodio
# Test new ASMTAIL and ASMSIZE keywords
#
# Test memory allocation

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

# test memalloc
my $compile = "-DMEMALLOC_DEBUG memalloc.c die.c except.c";

# allocate and no free no debug
t_compile_module("", <<'END', "memalloc.c die.c except.c");
	char * p1 = xmalloc(1);
	char * p2 = xmalloc(2);
	p1[0] = p2[0] = p2[1] = 0;
	if (memcmp(p1-4, "\xAA\xAA\xAA\xAA\0\xAA\xAA\xAA\xAA", 9) == 0 &&
	    memcmp(p2-4, "\xAA\xAA\xAA\xAA\0\0\xAA\xAA\xAA\xAA", 10) == 0)
		return 0;
	else 
		return 1;
END
t_run_module([], "", "", 0);


# debug
t_compile_module("", <<'END', $compile);
#define ERROR return __LINE__
	char *p1, *p2;
	int test;
	
	if (argc != 2) ERROR;
	test = atoi(argv[1]);
	
	switch (test) {
	case 1:							// no allocation
		break;
	
	case 2:							// alloc & no free, free in opposite order of alloc
		p1 = xmalloc(1);
		p2 = xmalloc(2);
		p1[0] = p2[0] = p2[1] = 0;
		if (memcmp(p1-4, "\xAA\xAA\xAA\xAA\0\xAA\xAA\xAA\xAA", 9)) ERROR;
		if (memcmp(p2-4, "\xAA\xAA\xAA\xAA\0\0\xAA\xAA\xAA\xAA", 10)) ERROR;
		break;

	case 3:							// alloc & free
		p1 = xmalloc(1);
		xfree(p1);
		if (p1) ERROR;
		break;
	
	case 4:							// alloc failed
		p1 = xmalloc(0x80000000);
		ERROR;
	
	case 5:							// unmatched block
		xfree(argv);
		break;
		
	case 6:							// buffer underflow
		p1 = xmalloc(1);
		p1[-1] = 0;
		xfree(p1);
		break;
	
	case 7:							// buffer overflow
		p1 = xmalloc(1);
		p1[1] = 0;
		xfree(p1);
		break;
		
	case 8:							// xmalloc
		p1 = xmalloc(0);
		p2 = xmalloc(1);
		p2[0] = 0;
		if (memcmp(p1-4, "\xAA\xAA\xAA\xAA\xAA\xAA\xAA\xAA", 8)) ERROR;
		if (memcmp(p2-4, "\xAA\xAA\xAA\xAA\0\xAA\xAA\xAA\xAA", 9)) ERROR;
		break;

	case 9:							// xcalloc
		p1 = xcalloc(5, 1);
		if (memcmp(p1-4, "\xAA\xAA\xAA\xAA\0\0\0\0\0\xAA\xAA\xAA\xAA", 13)) ERROR;
		break;

	case 10:						// realloc - NULL input
		p1 = xrealloc(NULL, 2);
		p1[0] = p1[1] = 2;
		if (memcmp(p1-4, "\xAA\xAA\xAA\xAA\2\2\xAA\xAA\xAA\xAA", 10)) ERROR;
		break;
	
	case 11:						// xrealloc - shrink
		p1 = xmalloc(2);
		p1[0] = p1[1] = 2;
		if (memcmp(p1-4, "\xAA\xAA\xAA\xAA\2\2\xAA\xAA\xAA\xAA", 10)) ERROR;
		p1 = xrealloc(p1, 1);
		if (memcmp(p1-4, "\xAA\xAA\xAA\xAA\2\xAA\xAA\xAA\xAA", 9)) ERROR;
		p1 = xrealloc(p1, 0);
		if (memcmp(p1-4, "\xAA\xAA\xAA\xAA\xAA\xAA\xAA\xAA", 8)) ERROR;
		break;

	case 12:						// xrealloc - grow
		p1 = xmalloc(1);
		p1[0] = 2;
		if (memcmp(p1-4, "\xAA\xAA\xAA\xAA\2\xAA\xAA\xAA\xAA", 9)) ERROR;
		p1 = xrealloc(p1, 2);
		p1[1] = 3;
		if (memcmp(p1-4, "\xAA\xAA\xAA\xAA\2\3\xAA\xAA\xAA\xAA", 10)) ERROR;
		break;

	case 13:						// xstrdup
		p1 = xstrdup("hello");
		if (memcmp(p1-4, "\xAA\xAA\xAA\xAAhello\0\xAA\xAA\xAA\xAA", 14)) ERROR;
		break;

	case 14:						// xcalloc_struct
		p1 = xcalloc_struct(char);
		if (memcmp(p1-4, "\xAA\xAA\xAA\xAA\0\xAA\xAA\xAA\xAA", 9)) ERROR;
		break;

	case 15:						// xcalloc_n_struct
		p1 = xcalloc_n_struct(2, char);
		if (memcmp(p1-4, "\xAA\xAA\xAA\xAA\0\0\xAA\xAA\xAA\xAA", 10)) ERROR;
		break;

	case 16:
		p1 = NULL;
		xfree(p1);
		break;
		
	default:
		ERROR;
	}
	
	return 0;
END

# no allocation
t_run_module([1], "", "", 0);

# alloc & no free, free in opposite order of alloc
t_run_module([2], "", <<ERR, 0);
memalloc: init
memalloc test.c(1): alloc 1 bytes at ADDR_1
memalloc test.c(2): alloc 2 bytes at ADDR_2
memalloc: cleanup
memalloc memalloc.c(1): free 2 bytes at ADDR_2 allocated at test.c(2)
memalloc memalloc.c(1): free 1 bytes at ADDR_1 allocated at test.c(1)
ERR

# alloc & free
t_run_module([3], "", <<ERR, 0);
memalloc: init
memalloc test.c(1): alloc 1 bytes at ADDR_1
memalloc test.c(2): free 1 bytes at ADDR_1 allocated at test.c(1)
memalloc: cleanup
ERR

# alloc failed
t_run_module([4], "", <<ERR, 1);
memalloc: init
memalloc test.c(1): alloc 2147483680 bytes failed


Uncaught NotEnoughMemoryException: memalloc test.c(1): alloc 2147483680 bytes failed


    thrown at die (die.c:50)

The value of errno was 0.

Exception hierarchy
________________________________________________________________

    RuntimeException
     |
     +--NotEnoughMemoryException
________________________________________________________________
memalloc: cleanup
ERR

# unmatched block
t_run_module([5], "", <<ERR, 1);
memalloc: init
memalloc test.c(1): block not found


Uncaught AssertionException: memalloc test.c(1): block not found


    thrown at die (die.c:50)

The value of errno was 0.

Exception hierarchy
________________________________________________________________

    AssertionException
     |
     +--AssertionException
________________________________________________________________
memalloc: cleanup
ERR

# buffer underflow
t_run_module([6], "", <<ERR, 1);
memalloc: init
memalloc test.c(1): alloc 1 bytes at ADDR_1
memalloc test.c(2): free 1 bytes at ADDR_1 allocated at test.c(1)
memalloc test.c(2): buffer underflow, memory allocated at test.c(1)


Uncaught AssertionException: memalloc test.c(2): buffer underflow, memory allocated at test.c(1)


    thrown at die (die.c:50)

The value of errno was 0.

Exception hierarchy
________________________________________________________________

    AssertionException
     |
     +--AssertionException
________________________________________________________________
memalloc: cleanup
ERR

# buffer overflow
t_run_module([7], "", <<ERR, 1);
memalloc: init
memalloc test.c(1): alloc 1 bytes at ADDR_1
memalloc test.c(2): free 1 bytes at ADDR_1 allocated at test.c(1)
memalloc test.c(2): buffer overflow, memory allocated at test.c(1)


Uncaught AssertionException: memalloc test.c(2): buffer overflow, memory allocated at test.c(1)


    thrown at die (die.c:50)

The value of errno was 0.

Exception hierarchy
________________________________________________________________

    AssertionException
     |
     +--AssertionException
________________________________________________________________
memalloc: cleanup
ERR

# memalloc
t_run_module([8], "", <<ERR, 0);
memalloc: init
memalloc test.c(1): alloc 0 bytes at ADDR_1
memalloc test.c(2): alloc 1 bytes at ADDR_2
memalloc: cleanup
memalloc memalloc.c(1): free 1 bytes at ADDR_2 allocated at test.c(2)
memalloc memalloc.c(1): free 0 bytes at ADDR_1 allocated at test.c(1)
ERR

# xcalloc
t_run_module([9], "", <<ERR, 0);
memalloc: init
memalloc test.c(1): alloc 5 bytes at ADDR_1
memalloc: cleanup
memalloc memalloc.c(1): free 5 bytes at ADDR_1 allocated at test.c(1)
ERR

# xrealloc - NULL input
t_run_module([10], "", <<ERR, 0);
memalloc: init
memalloc test.c(1): alloc 2 bytes at ADDR_1
memalloc: cleanup
memalloc memalloc.c(1): free 2 bytes at ADDR_1 allocated at test.c(1)
ERR

# xrealloc - shrink
t_run_module([11], "", <<ERR, 0);
memalloc: init
memalloc test.c(1): alloc 2 bytes at ADDR_1
memalloc test.c(2): free 2 bytes at ADDR_1 allocated at test.c(1)
memalloc test.c(2): alloc 1 bytes at ADDR_2
memalloc test.c(3): free 1 bytes at ADDR_2 allocated at test.c(2)
memalloc test.c(3): alloc 0 bytes at ADDR_3
memalloc: cleanup
memalloc memalloc.c(1): free 0 bytes at ADDR_3 allocated at test.c(3)
ERR

# xrealloc - grow
t_run_module([12], "", <<ERR, 0);
memalloc: init
memalloc test.c(1): alloc 1 bytes at ADDR_1
memalloc test.c(2): free 1 bytes at ADDR_1 allocated at test.c(1)
memalloc test.c(2): alloc 2 bytes at ADDR_2
memalloc: cleanup
memalloc memalloc.c(1): free 2 bytes at ADDR_2 allocated at test.c(2)
ERR

# xstrdup
t_run_module([13], "", <<ERR, 0);
memalloc: init
memalloc test.c(1): alloc 6 bytes at ADDR_1
memalloc: cleanup
memalloc memalloc.c(1): free 6 bytes at ADDR_1 allocated at test.c(1)
ERR

# xcalloc_struct
t_run_module([14], "", <<ERR, 0);
memalloc: init
memalloc test.c(1): alloc 1 bytes at ADDR_1
memalloc: cleanup
memalloc memalloc.c(1): free 1 bytes at ADDR_1 allocated at test.c(1)
ERR

# xcalloc_n_struct
t_run_module([15], "", <<ERR, 0);
memalloc: init
memalloc test.c(1): alloc 2 bytes at ADDR_1
memalloc: cleanup
memalloc memalloc.c(1): free 2 bytes at ADDR_1 allocated at test.c(1)
ERR

# xfree with NULL pointer
t_run_module([16], "", <<ERR, 0);
memalloc: init
memalloc: cleanup
ERR


unlink_testfiles();
done_testing;
