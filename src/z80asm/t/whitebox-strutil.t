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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-strutil.t,v 1.1 2012-05-22 20:26:17 pauloscustodio Exp $
# $Log: whitebox-strutil.t,v $
# Revision 1.1  2012-05-22 20:26:17  pauloscustodio
# Safe strings
# New type safestr_t to hold strings with size to prevent buffer overruns.
# Remove strtoupper, use POSIX strupr instead
#
#
# Test strutil

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

# test xmalloc
my $compile = "strutil.c";

t_compile_module(<<'INIT', <<'END', $compile);
#define SZ 5
#define ERROR return __LINE__
#define TEST(s,is) \
	if (s->size != SZ)					ERROR;	\
	if (strcmp(s->data, is))			ERROR;	\
	if (safestr_len(s) != strlen(is))	ERROR

char * test_vfset(safestr_t *self, char *format, ...)
{
	va_list argptr;
	va_start(argptr, format);	/* init variable args */

	return safestr_vfset(self, format, argptr);
}

char * test_vfcat(safestr_t *self, char *format, ...)
{
	va_list argptr;
	va_start(argptr, format);	/* init variable args */

	return safestr_vfcat(self, format, argptr);
}

INIT
	char buffer[5];
	SAFESTR_DEFINE( s, SZ );
	SAFESTR_DEFINE_REF( s2, buffer, sizeof(buffer) );
	char * p;

	TEST(s, "");
	p = safestr_set(s, "");
	if (p != safestr_data(s))			ERROR;
	TEST(s, "");
	
	safestr_set(s, "1234");
	TEST(s, "1234");
	safestr_set(s, "123");
	TEST(s, "123");
	safestr_set(s, "");
	TEST(s, "");
	
	p = safestr_cat(s, "");
	if (p != safestr_data(s))			ERROR;
	TEST(s, "");

	safestr_cat(s, "1");
	TEST(s, "1");
	safestr_cat(s, "2");
	TEST(s, "12");
	safestr_cat(s, "3");
	TEST(s, "123");
	safestr_cat(s, "4");
	TEST(s, "1234");
	safestr_cat(s, "5");
	TEST(s, "1234");
	
	safestr_clear(s);
	TEST(s, "");

	p = safestr_fset(s, "");
	if (p != safestr_data(s))			ERROR;
	TEST(s, "");

	safestr_fset(s, "%d", 1);
	TEST(s, "1");
	safestr_fset(s, "%d", 12);
	TEST(s, "12");
	safestr_fset(s, "%d", 123);
	TEST(s, "123");
	safestr_fset(s, "%d", 1234);
	TEST(s, "1234");
	safestr_fset(s, "%d", 12345);
	TEST(s, "1234");
	
	p = safestr_fcat(s, "");
	if (p != safestr_data(s))			ERROR;
	TEST(s, "1234");

	safestr_clear(s);
	TEST(s, "");

	safestr_fcat(s, "%d", 1);
	TEST(s, "1");
	safestr_fcat(s, "%d", 2);
	TEST(s, "12");
	safestr_fcat(s, "%d", 3);
	TEST(s, "123");
	safestr_fcat(s, "%d", 4);
	TEST(s, "1234");
	safestr_fcat(s, "%d", 5);
	TEST(s, "1234");
	
	safestr_clear(s);
	TEST(s, "");

	p = test_vfset(s, "");
	if (p != safestr_data(s))			ERROR;
	TEST(s, "");

	test_vfset(s, "%d", 1);
	TEST(s, "1");
	test_vfset(s, "%d", 12);
	TEST(s, "12");
	test_vfset(s, "%d", 123);
	TEST(s, "123");
	test_vfset(s, "%d", 1234);
	TEST(s, "1234");
	test_vfset(s, "%d", 12345);
	TEST(s, "1234");
	
	p = test_vfcat(s, "");
	if (p != safestr_data(s))			ERROR;
	TEST(s, "1234");

	safestr_clear(s);
	TEST(s, "");

	test_vfcat(s, "%d", 1);
	TEST(s, "1");
	test_vfcat(s, "%d", 2);
	TEST(s, "12");
	test_vfcat(s, "%d", 3);
	TEST(s, "123");
	test_vfcat(s, "%d", 4);
	TEST(s, "1234");
	test_vfcat(s, "%d", 5);
	TEST(s, "1234");

	// test SAFESTR_DEFINE_REF()
	if (s2->data != buffer)				ERROR;
	if (s2->size != 5)					ERROR;
	
	return 0;
END

t_run_module([], "", "", 0);

unlink_testfiles();
done_testing;
