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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-strutil.t,v 1.6 2012-06-07 11:49:59 pauloscustodio Exp $
# $Log: whitebox-strutil.t,v $
# Revision 1.6  2012-06-07 11:49:59  pauloscustodio
# stricompare() instead of Flncmp()
#
# Revision 1.5  2012/06/06 22:42:57  pauloscustodio
# BUG_0021 : Different behaviour in string truncation in strutil in Linux and Win32
#
# Revision 1.4  2012/05/26 18:50:26  pauloscustodio
# Use .o instead of .c to build test program, faster compilation.
# Use gcc to compile instead of cc.
#
# Revision 1.3  2012/05/26 17:46:01  pauloscustodio
# Put back strtoupper, strupr does not exist in all systems, was causing nightly build to fail
#
# Revision 1.2  2012/05/24 15:07:03  pauloscustodio
# Rename safestr_t to sstr_t, keep length to speed-up appending chars
#
# Revision 1.1  2012/05/22 20:26:17  pauloscustodio
# Safe strings
# New type sstr_t to hold strings with size to prevent buffer overruns.
# Remove strtoupper, use POSIX strupr instead
#
#
# Test strutil

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

# test xmalloc
my $objs = "strutil.o";
ok ! system "make $objs";

t_compile_module(<<'INIT', <<'END', $objs);
#define SZ 5
#define ERROR return __LINE__
#define TEST(s,is) \
	if (s->size != SZ)					ERROR;	\
	if (strcmp(s->data, is))			ERROR;	\
	if (sstr_len(s) != strlen(is))	ERROR

char * test_vfset(sstr_t *self, char *format, ...)
{
	va_list argptr;
	va_start(argptr, format);	/* init variable args */

	return sstr_vfset(self, format, argptr);
}

char * test_vfcat(sstr_t *self, char *format, ...)
{
	va_list argptr;
	va_start(argptr, format);	/* init variable args */

	return sstr_vfcat(self, format, argptr);
}

INIT
	char buffer[5];
	SSTR_DEFINE( s, SZ );
	SSTR_DEFINE_REF( s2, buffer, sizeof(buffer) );
	char * p;

	TEST(s, "");
	p = sstr_set(s, "");
	if (p != sstr_data(s))			ERROR;
	TEST(s, "");
	
	sstr_set(s, "1234");
	TEST(s, "1234");
	sstr_set(s, "123");
	TEST(s, "123");
	sstr_set(s, "");
	TEST(s, "");
	
	p = sstr_cat(s, "");
	if (p != sstr_data(s))			ERROR;
	TEST(s, "");

	sstr_cat(s, "1");
	TEST(s, "1");
	sstr_cat(s, "2");
	TEST(s, "12");
	sstr_cat(s, "3");
	TEST(s, "123");
	sstr_cat(s, "4");
	TEST(s, "1234");
	sstr_cat(s, "5");
	TEST(s, "1234");
	
	sstr_clear(s);
	TEST(s, "");

	p = sstr_fset(s, "");
	if (p != sstr_data(s))			ERROR;
	TEST(s, "");

	sstr_fset(s, "%d", 1);
	TEST(s, "1");
	sstr_fset(s, "%d", 12);
	TEST(s, "12");
	sstr_fset(s, "%d", 123);
	TEST(s, "123");
	sstr_fset(s, "%d", 1234);
	TEST(s, "1234");
	sstr_fset(s, "%d", 12345);
	TEST(s, "1234");
	sstr_fset(s, "%d", 123456);
	TEST(s, "1234");
	
	p = sstr_fcat(s, "");
	if (p != sstr_data(s))			ERROR;
	TEST(s, "1234");

	sstr_clear(s);
	TEST(s, "");

	sstr_fcat(s, "%d", 1);
	TEST(s, "1");
	sstr_fcat(s, "%d", 2);
	TEST(s, "12");
	sstr_fcat(s, "%d", 3);
	TEST(s, "123");
	sstr_fcat(s, "%d", 4);
	TEST(s, "1234");
	sstr_fcat(s, "%d", 5);
	TEST(s, "1234");
	sstr_fcat(s, "%d", 56);
	TEST(s, "1234");
	sstr_fcat(s, "%d", 567);
	TEST(s, "1234");
	
	sstr_clear(s);
	TEST(s, "");

	p = test_vfset(s, "");
	if (p != sstr_data(s))			ERROR;
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
	if (p != sstr_data(s))			ERROR;
	TEST(s, "1234");

	sstr_clear(s);
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

	// test SSTR_DEFINE_REF()
	if (s2->data != buffer)				ERROR;
	if (s2->size != 5)					ERROR;

	// strtoupper, strtolower
	sstr_set(s, "Abc1");
	p = strtolower(sstr_data(s));
	if (p != sstr_data(s))				ERROR;
	TEST(s, "abc1");
	
	sstr_set(s, "Abc1");
	p = strtoupper(sstr_data(s));
	if (p != sstr_data(s))				ERROR;
	TEST(s, "ABC1");
	
	// stricompare
	if (stricompare("","") != 0)		ERROR;
	if (stricompare("a","") != 1)		ERROR;
	if (stricompare("","a") != -1)		ERROR;
	if (stricompare("a","a") != 0)		ERROR;
	if (stricompare("ab","a") != 1)		ERROR;
	if (stricompare("a","ab") != -1)	ERROR;
	if (stricompare("ab","ab") != 0)	ERROR;
	
	return 0;
END

t_run_module([], "", "", 0);

unlink_testfiles();
done_testing;
