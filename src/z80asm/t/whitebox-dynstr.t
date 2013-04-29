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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-dynstr.t,v 1.5 2013-04-29 22:24:33 pauloscustodio Exp $
# $Log: whitebox-dynstr.t,v $
# Revision 1.5  2013-04-29 22:24:33  pauloscustodio
# Add utility functions to convert end-of-line sequences CR, CRLF, LFCR, LF all to LF
#
# Revision 1.4  2013/02/28 00:32:35  pauloscustodio
# New interface to Str to copy characters to string
#
# Revision 1.3  2013/02/22 17:21:29  pauloscustodio
# Added chomp()
#
# Revision 1.2  2013/01/20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.1  2012/06/14 15:03:45  pauloscustodio
# CH_0014 : New Dynamic Strings that grow automatically on creation / concatenation
#
#
# Test dynstr

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

my $objs = "dynstr.o class.o die.o safestr.o strutil.o except.o";
ok ! system "make $objs";

my $compile = "-DMEMALLOC_DEBUG memalloc.c $objs";

t_compile_module(<<'END_INIT', <<'END', $compile);
#include "die.h"

#define ERROR return __LINE__

void _check_str (Str *str, size_t size, size_t len, char *text, 
				char *file, int lineno)
{
	if (str == NULL) 
		fprintf(stderr, "%s(%d) str == NULL\n", file, lineno);
	if (str->data == NULL) 
		fprintf(stderr, "%s(%d) str->data == NULL\n", file, lineno);
	if (str->size != size)
		fprintf(stderr, "%s(%d) str->size %u != %u\n", file, lineno, str->size, size);
	if (str->len != len)
		fprintf(stderr, "%s(%d) str->len %u != %u\n", file, lineno, str->len, len);
	if (memcmp(str->data - 4, "\xAA\xAA\xAA\xAA", 4))
		fprintf(stderr, "%s(%d) fence at start not found\n", file, lineno);
	if (memcmp(str->data + str->size, "\xAA\xAA\xAA\xAA", 4))
		fprintf(stderr, "%s(%d) fence at end not found\n", file, lineno);
	if (str->data[str->len] != 0)
		fprintf(stderr, "%s(%d) null terminator not found\n", file, lineno);
	if (memcmp(str->data, text, str->len))
		fprintf(stderr, "%s(%d) different text found\n", file, lineno);
}	

#define check_str(str,size,len,text) _check_str(str,size,len,text,__FILE__,__LINE__)

void call_set_vf (Str *str, char *format, ...)
{
	va_list argptr;
	va_start(argptr, format);
	Str_vfset(str, format, argptr);
}

void call_cat_vf (Str *str, char *format, ...)
{
	va_list argptr;
	va_start(argptr, format);
	Str_vfcat(str, format, argptr);
}

END_INIT
	/* main */
	Str *s1, *s2;
	
	warn("init\n");
	s1 = OBJ_NEW(Str);
	check_str(s1, 256, 0, "");
	
	warn("Str_unreserve\n");
	Str_unreserve(s1);
	check_str(s1, 1, 0, "");

	warn("Str_szcat\n");
	Str_szcat(s1, "h");
	check_str(s1, 256, 1, "h");

	Str_szcat(s1, "ello");
	check_str(s1, 256, 5, "hello");
	
	warn("Str_szset\n");
	Str_szset(s1, "world");
	check_str(s1, 256, 5, "world");


	Str_chset(s1, 'X');
	check_str(s1, 256, 1, "X");

	Str_chset(s1, 'H');
	check_str(s1, 256, 1, "H");

	Str_chcat(s1, 'E');
	check_str(s1, 256, 2, "HE");

	
	warn("Str_clear\n");
	Str_clear(s1);
	check_str(s1, 256, 0, "");

	warn("Str_reserve in 256 blocks\n");
	Str_reserve(s1, 254);
	check_str(s1, 256, 0, "");

	Str_reserve(s1, 255);
	check_str(s1, 256, 0, "");

	Str_reserve(s1, 256);
	check_str(s1, 512, 0, "");

	Str_unreserve(s1);
	Str_reserve(s1, 511);
	check_str(s1, 512, 0, "");

	warn("Str_unreserve\n");
	Str_clear(s1); 
	Str_unreserve(s1);
	check_str(s1, 1, 0, "");
	Str_szset(s1, "hello world");
	check_str(s1, 256, 11, "hello world");

	warn("Str_clone\n");
	s2 = Str_clone(s1);
	check_str(s1, 256, 11, "hello world");
	if (s1 == s2) 			ERROR;
	if (s1->data == s2->data) ERROR;
	
	warn("Str_fset\n");
	Str_fset(s1, "%s %d", "hello", 123);
	check_str(s1, 256, 9, "hello 123");
	
	warn("Str_fcat\n");
	Str_fcat(s1, "%s", "");		/* empty */
	check_str(s1, 256, 9, "hello 123");

	Str_fcat(s1, "%s", " and world");
	check_str(s1, 256, 19, "hello 123 and world");
	
	warn("Str_vfset\n");
	call_set_vf(s1, "%s %d", "hello", 123);
	check_str(s1, 256, 9, "hello 123");
	
	warn("Str_vfcat\n");
	call_cat_vf(s1, "%s", "");		/* empty */
	check_str(s1, 256, 9, "hello 123");

	call_cat_vf(s1, "%s", " and world");
	check_str(s1, 256, 19, "hello 123 and world");
		
	warn("Str_unreserve and Str_fset\n");
	Str_clear(s1); 
	Str_unreserve(s1);
	check_str(s1, 1, 0, "");
	
	warn("expand\n");
	Str_fset(s1, "%s", "1");
	check_str(s1, 256, 1, "1");
	
	warn("Str_bset\n");
	Str_bset(s1, "\0\1\2\3", 4);
	check_str(s1, 256, 4, "\0\1\2\3");
	
	warn("Str_bcat\n");
	Str_bcat(s1, "\4\5\6\7", 4);
	check_str(s1, 256, 8, "\0\1\2\3\4\5\6\7");
	
	warn("Str_set, Str_cat\n");
	Str_szset(s1, "hello ");
	check_str(s1, 256, 6, "hello ");
	Str_szset(s2, "world");
	check_str(s2, 256, 5, "world");
	
	Str_cat(s1, s2);
	check_str(s1, 256, 11, "hello world");
	check_str(s2, 256, 5, "world");
	
	Str_set(s2, s1);
	check_str(s1, 256, 11, "hello world");
	check_str(s2, 256, 11, "hello world");
		
	warn("Str_compare\n");
	Str_clear(s1); Str_clear(s2);
	if (Str_compare(s1,s2)) 	ERROR;
	
	Str_clear(s1); Str_szset(s2, "a");
	if (Str_compare(s1,s2) >= 0) 	ERROR;
	
	Str_szset(s1, "a"); Str_clear(s2); 
	if (Str_compare(s1,s2) <= 0) 	ERROR;
	
	Str_szset(s1, "a"); Str_szset(s2, "a");
	if (Str_compare(s1,s2) != 0) 	ERROR;
	
	Str_szset(s1, "a"); Str_szset(s2, "b");
	if (Str_compare(s1,s2) >= 0) 	ERROR;
	
	Str_szset(s1, "b"); Str_szset(s2, "a");
	if (Str_compare(s1,s2) <= 0) 	ERROR;
	
	Str_szset(s1, "a"); Str_szset(s2, "aa");
	if (Str_compare(s1,s2) >= 0) 	ERROR;
	
	Str_szset(s1, "aa"); Str_szset(s2, "a");
	if (Str_compare(s1,s2) <= 0) 	ERROR;
	
	// chomp
	Str_szset(s1, "\r\n \t\fx\r\n \t\f");
	Str_chomp(s1);
	check_str(s1, 256, 6, "\r\n \t\fx");
	
	Str_szset(s1, "\r\n \t\f \r\n \t\f");
	Str_chomp(s1);
	check_str(s1, 256, 0, "");

	// normalize_eol
	Str_szset(s1, "A" "\r\n" "B" "\n\r" "C" "\n" "D" "\r" "E");
	Str_normalize_eol(s1);
	check_str(s1, 256, 9, "A\nB\nC\nD\nE");
	
	Str_szset(s1, "A" "\r");
	Str_normalize_eol(s1);
	check_str(s1, 256, 2, "A\n");
	
	Str_szset(s1, "A" "\n");
	Str_normalize_eol(s1);
	check_str(s1, 256, 2, "A\n");
	
	
	warn("delete s1\n");
	OBJ_DELETE(s1);
	if (s1 != NULL) 		ERROR;

	warn("delete s2\n");
	OBJ_DELETE(s2);
	if (s2 != NULL) 		ERROR;

	warn("end\n");
	return 0;
END

t_run_module([], "", <<ERR, 0);
init
memalloc: init
memalloc dynstr.c(1): alloc 40 bytes at ADDR_1
memalloc dynstr.c(4): alloc 256 bytes at ADDR_2
Str_unreserve
memalloc dynstr.c(5): free 256 bytes at ADDR_2 allocated at dynstr.c(4)
memalloc dynstr.c(5): alloc 1 bytes at ADDR_3
Str_szcat
memalloc dynstr.c(4): free 1 bytes at ADDR_3 allocated at dynstr.c(5)
memalloc dynstr.c(4): alloc 256 bytes at ADDR_4
Str_szset
Str_clear
Str_reserve in 256 blocks
memalloc dynstr.c(4): free 256 bytes at ADDR_4 allocated at dynstr.c(4)
memalloc dynstr.c(4): alloc 512 bytes at ADDR_5
memalloc dynstr.c(5): free 512 bytes at ADDR_5 allocated at dynstr.c(4)
memalloc dynstr.c(5): alloc 1 bytes at ADDR_6
memalloc dynstr.c(4): free 1 bytes at ADDR_6 allocated at dynstr.c(5)
memalloc dynstr.c(4): alloc 512 bytes at ADDR_7
Str_unreserve
memalloc dynstr.c(5): free 512 bytes at ADDR_7 allocated at dynstr.c(4)
memalloc dynstr.c(5): alloc 1 bytes at ADDR_8
memalloc dynstr.c(4): free 1 bytes at ADDR_8 allocated at dynstr.c(5)
memalloc dynstr.c(4): alloc 256 bytes at ADDR_9
Str_clone
memalloc dynstr.c(1): alloc 40 bytes at ADDR_10
memalloc dynstr.c(2): alloc 256 bytes at ADDR_11
Str_fset
Str_fcat
Str_vfset
Str_vfcat
Str_unreserve and Str_fset
memalloc dynstr.c(5): free 256 bytes at ADDR_9 allocated at dynstr.c(4)
memalloc dynstr.c(5): alloc 1 bytes at ADDR_12
expand
memalloc dynstr.c(4): free 1 bytes at ADDR_12 allocated at dynstr.c(5)
memalloc dynstr.c(4): alloc 256 bytes at ADDR_13
Str_bset
Str_bcat
Str_set, Str_cat
Str_compare
delete s1
memalloc dynstr.c(3): free 256 bytes at ADDR_13 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_1 allocated at dynstr.c(1)
delete s2
memalloc dynstr.c(3): free 256 bytes at ADDR_11 allocated at dynstr.c(2)
memalloc dynstr.c(1): free 40 bytes at ADDR_10 allocated at dynstr.c(1)
end
memalloc: cleanup
ERR

unlink_testfiles();
done_testing;

