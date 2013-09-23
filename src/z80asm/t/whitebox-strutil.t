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
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-strutil.t,v 1.12 2013-09-23 23:14:10 pauloscustodio Exp $
#
# Test strutil

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

my $objs = "strutil.o";

t_compile_module('', <<'END', $objs);
#define ERROR return __LINE__

	char s[255];
	char * p;
	StringList *list1 = NULL;
	StringList *list2 = NULL;

	// StringList
	add_StringList(&list1, "one");
	add_StringList(&list1, "two");
	add_StringList(&list1, "three");
	add_StringList(&list1, "four");
	
	printf("List1\n");
	FOR_StringList(list1, p)
		printf("->%s\n", p);
	ENDFOR_StringList;
	
	printf("List1, break at two\n");
	FOR_StringList(list1, p)
	{
		printf("->%s\n", p);
		if (strcmp(p, "two") == 0) break;
	}
	ENDFOR_StringList;
	
	printf("List2\n");
	FOR_StringList(list2, p)
		printf("->%s\n", p);
	ENDFOR_StringList;
	
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
	
	// normalize_eol
	strcpy(s, "A" "\r\n" "B" "\n\r" "C" "\n" "D" "\r" "E");
	p = normalize_eol(s);
	if (p != s)							ERROR;
	if(strcmp(s, "A\nB\nC\nD\nE"))		ERROR;
	
	strcpy(s, "A" "\r");
	p = normalize_eol(s);
	if (p != s)							ERROR;
	if(strcmp(s, "A\n"))				ERROR;
	
	strcpy(s, "A" "\n");
	p = normalize_eol(s);
	if (p != s)							ERROR;
	if(strcmp(s, "A\n"))				ERROR;

	return 0;
END

t_run_module([], <<'OUT', "", 0);
List1
->one
->two
->three
->four
List1, break at two
->one
->two
List2
GLib Memory statistics (successful operations):
 blocks of | allocated  | freed      | allocated  | freed      | n_bytes   
  n_bytes  | n_times by | n_times by | n_times by | n_times by | remaining 
           | malloc()   | free()     | realloc()  | realloc()  |           
===========|============|============|============|============|===========
        20 |          1 |          1 |          0 |          0 |         +0
        96 |          1 |          1 |          0 |          0 |         +0
       252 |          3 |          0 |          0 |          0 |       +756
      1016 |          1 |          0 |          0 |          0 |      +1016
      1024 |          1 |          1 |          0 |          0 |         +0
GLib Memory statistics (failing operations):
 --- none ---
Total bytes: allocated=2912, zero-initialized=1868 (64.15%), freed=1140 (39.15%), remaining=1772
OUT

unlink_testfiles();
done_testing;


__END__
# $Log: whitebox-strutil.t,v $
# Revision 1.12  2013-09-23 23:14:10  pauloscustodio
# Renamed SzList to StringList, simplified interface by assuming that
# list lives in memory util program ends; it is used for directory searches
# only. Moved interface to strutil.c, removed strlist.c.
#
# Revision 1.11  2013/09/09 00:20:45  pauloscustodio
# Add default set of modules to t_compile_module:
# -DMEMALLOC_DEBUG memalloc.c die.o except.o strpool.o
#
# Revision 1.10  2013/04/29 22:24:33  pauloscustodio
# Add utility functions to convert end-of-line sequences CR, CRLF, LFCR, LF all to LF
#
# Revision 1.9  2013/02/22 17:21:29  pauloscustodio
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
