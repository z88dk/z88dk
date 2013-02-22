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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-strutil.t,v 1.9 2013-02-22 17:21:29 pauloscustodio Exp $
# $Log: whitebox-strutil.t,v $
# Revision 1.9  2013-02-22 17:21:29  pauloscustodio
# Added chomp()
#
# Revision 1.8  2013/01/20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.7  2012/06/14 15:01:27  pauloscustodio
# Split safe strings from strutil.c to safestr.c
#
# Revision 1.6  2012/06/07 11:49:59  pauloscustodio
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

my $objs = "strutil.o";
ok ! system "make $objs";

t_compile_module('', <<'END', $objs);
#define ERROR return __LINE__

	char s[255];
	char * p;

	// strtoupper, strtolower
	strcpy(s, "Abc1");
	p = strtolower(s);
	if (p != s)							ERROR;
	if(strcmp(s, "abc1"))				ERROR;
	
	strcpy(s, "Abc1");
	p = strtoupper(s);
	if (p != s)							ERROR;
	if(strcmp(s, "ABC1"))				ERROR;
	
	// stricompare
	if (stricompare("","") != 0)		ERROR;
	if (stricompare("a","") != 1)		ERROR;
	if (stricompare("","a") != -1)		ERROR;
	if (stricompare("a","a") != 0)		ERROR;
	if (stricompare("a","A") != 0)		ERROR;
	if (stricompare("A","a") != 0)		ERROR;
	if (stricompare("ab","a") != 1)		ERROR;
	if (stricompare("a","ab") != -1)	ERROR;
	if (stricompare("ab","ab") != 0)	ERROR;
	
	// chomp
	strcpy(s, "\r\n \t\fx\r\n \t\f");
	p = chomp(s);
	if (p != s)							ERROR;
	if(strcmp(s, "\r\n \t\fx"))			ERROR;
	
	strcpy(s, "\r\n \t\f \r\n \t\f");
	p = chomp(s);
	if (p != s)							ERROR;
	if(strcmp(s, ""))					ERROR;
	
	return 0;
END

t_run_module([], "", "", 0);

unlink_testfiles();
done_testing;
