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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-safestr.t,v 1.3 2013-04-06 10:55:15 pauloscustodio Exp $
# $Log: whitebox-safestr.t,v $
# Revision 1.3  2013-04-06 10:55:15  pauloscustodio
# SSTR_DEFINE() caused compilation error "C2099: initializer is not a constant" when used to define global variables
#
# Revision 1.2  2013/01/20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.1  2012/06/14 15:01:27  pauloscustodio
# Split safe strings from strutil.c to safestr.c
#
#
# Test safestr

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

my $objs = "safestr.o";
ok ! system "make $objs";

t_compile_module(<<'INIT', <<'END', $objs);
#define SZ (5)
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

SSTR_DEFINE(global, SZ);

INIT
	char buffer[5];
	SSTR_DEFINE( s, SZ );
	SSTR_DEFINE_REF( s2, buffer, sizeof(buffer) );
	char * p;

	TEST(s, "");
	p = sstr_set(s, "");
	if (p != sstr_data(s))			ERROR;
	TEST(s, "");
	
	TEST(global, "");
	p = sstr_set(global, "");
	if (p != sstr_data(global))		ERROR;
	TEST(global, "");

	
	sstr_set(s, "1234");
	TEST(s, "1234");
	sstr_set(s, "123");
	TEST(s, "123");
	sstr_set(s, "");
	TEST(s, "");
	
	sstr_set(global, "1234");
	TEST(global, "1234");
	sstr_set(global, "123");
	TEST(global, "123");
	sstr_set(global, "");
	TEST(global, "");
	

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

	return 0;
END

t_run_module([], "", "", 0);

unlink_testfiles();
done_testing;
