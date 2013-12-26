#!/usr/bin/perl

# Copyright (C) Paulo Custodio, 2011-2013
#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/t/Attic/strutil.t,v 1.2 2013-12-26 23:42:27 pauloscustodio Exp $
#
# Test strutil.c

use Modern::Perl;
use Test::More;
use File::Slurp;
use Capture::Tiny 'capture';
use Test::Differences; 

my $compile = "cc -Wall -mms-bitfields -IC:/MinGW/msys/1.0/include/glib-2.0 -IC:/MinGW/msys/1.0/lib/glib-2.0/include -otest test.c strutil.c strpool.c die.c xmalloc.c -LC:/MinGW/msys/1.0/lib -lglib-2.0 -lintl";

warn "-mms-bitfields -IC:/MinGW/msys/1.0/include/glib-2.0 -IC:/MinGW/msys/1.0/lib/glib-2.0/include -LC:/MinGW/msys/1.0/lib -lglib-2.0 -lintl";

write_file("test.c", <<'END');
#include "die.h"
#include "strutil.h"

#define ERROR return __LINE__

int main()
{
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
	
	// g_ascii_strcasecmp
	if (g_ascii_strcasecmp("","") != 0)			ERROR;
	if (g_ascii_strcasecmp("a","") < 1)			ERROR;
	if (g_ascii_strcasecmp("","a") > -1)		ERROR;
	if (g_ascii_strcasecmp("a","a") != 0)		ERROR;
	if (g_ascii_strcasecmp("a","A") != 0)		ERROR;
	if (g_ascii_strcasecmp("A","a") != 0)		ERROR;
	if (g_ascii_strcasecmp("ab","a") < 1)		ERROR;
	if (g_ascii_strcasecmp("a","ab") > -1)		ERROR;
	if (g_ascii_strcasecmp("ab","ab") != 0)		ERROR;
	
	// g_strchomp
	strcpy(s, "\r\n \t\fx\r\n \t\f");
	p = g_strchomp(s);
	if (p != s)							ERROR;
	if(strcmp(s, "\r\n \t\fx"))			ERROR;
	
	strcpy(s, "\r\n \t\f \r\n \t\f");
	p = g_strchomp(s);
	if (p != s)							ERROR;
	if(strcmp(s, ""))					ERROR;
	
	return 0;
}
END
system($compile) and die "compile failed: $compile\n";

t_capture("test", "", "", 0);


unlink <test.*>;
done_testing;

sub t_capture {
	my($cmd, $exp_out, $exp_err, $exp_exit) = @_;
	my $line = "[line ".((caller)[2])."]";
	ok 1, "$line command: $cmd";
	
	my($out, $err, $exit) = capture { system $cmd; };
	eq_or_diff_text $out, $exp_out, "$line out";
	eq_or_diff_text $err, $exp_err, "$line err";
	ok !!$exit == !!$exp_exit, "$line exit";
}


# $Log: strutil.t,v $
# Revision 1.2  2013-12-26 23:42:27  pauloscustodio
# Replace StringList from strutil by StrList in new strlis.c, to keep lists of strings (e.g. directory search paths)
#
# Revision 1.1  2013/12/25 14:39:51  pauloscustodio
# Move strutil.c to the z80asm/lib directory
#
# Revision 1.14  2013/12/15 13:18:35  pauloscustodio
# Move memory allocation routines to lib/xmalloc, instead of glib,
# introduce memory leak report on exit and memory fence check.
#
# Revision 1.13  2013/09/24 00:05:36  pauloscustodio
# Replaced chomp by g_strchomp; tolower by g_ascii_tolower;
# toupper by g_ascii_toupper; stricompare by g_ascii_strcasecmp.
# Removed normalize_eol.
#
# Revision 1.12  2013/09/23 23:14:10  pauloscustodio
# Renamed SzList to StringList, simplified interface by assuming that
# list lives in memory util program ends; it is used for directory searches
# only. Moved interface to strutil.c, removed strlist.c.
#
# Revision 1.11  2013/09/09 00:20:45  pauloscustodio
# Add default set of modules to t_compile_module:
# -DMEMALLOC_DEBUG xmalloc.c die.o except.o strpool.o
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
