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
# Copyright (C) Paulo Custodio, 2011-2014
#
# Test errors

use Modern::Perl;
use Test::More;
use File::Slurp;
use Test::Differences; 
require 't/test_utils.pl';

# test errors.c
unlink_testfiles();

my $objs = "errors.o scan.o lib/class.o lib/strutil.o lib/strhash.o lib/list.o lib/fileutil.o options.o model.o lib/srcfile.o hist.o";

# get init code except init() and main()
my $init = <<'END';

#include "symbol.h"

struct module *CURRENTMODULE;
FILE *errfile;
size_t get_PC( void ) { return 0; }
void list_start_line( size_t address, char *source_file, int source_line_nr, char *line ) 
{	
	warn("%04X %-16s %5d %s", address, source_file, source_line_nr, line);
}
char *CreateLibfile( char *filename ) {return NULL;}
char *GetLibfile( char *filename ) {return NULL;}
Symbol *define_static_def_sym( char *name, long value ) {return NULL;}
char ident[MAXLINE];
char separators[MAXLINE];

END

t_compile_module($init, <<'END', $objs);
#define ERROR return __LINE__
#define check_count(e) if (get_num_errors() != e) ERROR;

	check_count(0);
	
	warn("Information\n");
	info_total_errors();
	check_count(0);

	warn("Warning\n");
	warn_option_deprecated("-t");
	check_count(0);

	warn("Error\n");
	error_syntax();
	check_count(1);

	warn("Fatal error not caught\n");
	fatal_read_file("file.asm");
	warn("NOT REACHED\n");	
END

t_run_module([], '', <<'ERR', 1);
Information
0 errors occurred during assembly
Warning
Warning: option '-t' is deprecated
Error
Error: syntax error
Fatal error not caught
Error: cannot read file 'file.asm'
Uncaught runtime exception at errors.c(1)
ERR


t_compile_module($init, <<'END', $objs);
#define ERROR return __LINE__
#define check_count(e) if (get_num_errors() != e) ERROR;
#define SYNTAX(file,module,line) \
	_count = get_num_errors(); \
	set_error_file(file); \
	set_error_module(module); \
	set_error_line(line); \
	error_syntax(); \
	check_count(_count + 1)
	
#define DOUBLE(x) #x #x
	int _count;

	check_count(0);
	
	warn("Fatal error\n");
	TRY
	{
		fatal_read_file("file.asm");
		warn("NOT REACHED\n");	
	}
	FINALLY
	{
		if (! THROWN()) ERROR;
	}
	ETRY;
	check_count(1);
	
	SYNTAX(	NULL,		NULL,	0 );
	SYNTAX(	NULL,		NULL,	1 );
	SYNTAX(	NULL,		"TEST",	0 );
	SYNTAX(	NULL,		"TEST",	1 );
	SYNTAX(	"test.asm",	NULL,	0 );
	SYNTAX(	"test.asm",	NULL,	1 );
	SYNTAX(	"test.asm",	"TEST",	0 );
	SYNTAX(	"test.asm",	"TEST",	1 );

	set_error_null();
	check_count(9);
	error_syntax();
	check_count(10);
	
	reset_error_count();
	check_count(0);

	open_error_file("test1.err");
	close_error_file();
	
	error_syntax();
	
	open_error_file("test2.err");
	error_syntax();
	close_error_file();
	
	open_error_file("test3.err");
	error_syntax();
	
	open_error_file("test2.err");
	error_syntax();
	
END

t_run_module([], '', <<'ERR', 0);
Fatal error
Error: cannot read file 'file.asm'
Error: syntax error
Error at line 1: syntax error
Error at module 'TEST': syntax error
Error at module 'TEST' line 1: syntax error
Error at file 'test.asm': syntax error
Error at file 'test.asm' line 1: syntax error
Error at file 'test.asm' module 'TEST': syntax error
Error at file 'test.asm' module 'TEST' line 1: syntax error
Error: syntax error
Error: syntax error
Error: syntax error
Error: syntax error
Error: syntax error
ERR

ok ! -f "test1.err", "no errors, file deleted";

eq_or_diff_text scalar(read_file('test2.err')), <<'END';
Error: syntax error
Error: syntax error
END

eq_or_diff_text scalar(read_file('test3.err')), <<'END';
Error: syntax error
END


unlink_testfiles();
done_testing;


__END__
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-errors.t,v 1.26 2014-02-08 18:30:49 pauloscustodio Exp $
# $Log: whitebox-errors.t,v $
# Revision 1.26  2014-02-08 18:30:49  pauloscustodio
# lib/srcfile.c to read source files and handle recursive includes,
# used to read @lists, removed opts.files;
# model.c to hold global data model
#
# Revision 1.25  2014/01/20 23:29:18  pauloscustodio
# Moved file.c to lib/fileutil.c
#
# Revision 1.24  2014/01/11 01:29:46  pauloscustodio
# Extend copyright to 2014.
# Move CVS log to bottom of file.
#
# Revision 1.23  2014/01/06 00:33:36  pauloscustodio
# Use init.h mechanism, no need for main() calling init_errors
# and atexit(fini_errors); use Str and StrHash instead of glib.
#
# Revision 1.22  2014/01/02 17:18:17  pauloscustodio
# StrList removed, replaced by List
#
# Revision 1.21  2014/01/01 21:23:48  pauloscustodio
# Move generic file utility functions to lib/fileutil.c
#
# Revision 1.20  2013/12/30 02:05:34  pauloscustodio
# Merge dynstr.c and safestr.c into lib/strutil.c; the new Str type
# handles both dynamically allocated strings and fixed-size strings.
# Replaced g_strchomp by chomp by; g_ascii_tolower by tolower;
# g_ascii_toupper by toupper; g_ascii_strcasecmp by stricompare.
#
# Revision 1.19  2013/12/26 23:42:28  pauloscustodio
# Replace StringList from strutil by StrList in new strlis.c, to keep lists of strings (e.g. directory search paths)
#
# Revision 1.18  2013/12/25 14:39:50  pauloscustodio
# Move strutil.c to the z80asm/lib directory
#
# Revision 1.17  2013/12/18 23:05:52  pauloscustodio
# Move class.c to the z80asm/lib directory
#
# Revision 1.16  2013/12/15 13:18:35  pauloscustodio
# Move memory allocation routines to lib/xmalloc, instead of glib,
# introduce memory leak report on exit and memory fence check.
#
# Revision 1.15  2013/11/11 23:47:04  pauloscustodio
# Move source code generation tools to dev/Makefile, only called on request,
# and keep the generated files in z80asm directory, so that build does
# not require tools used for the code generation (ragel, perl).
# Remove code generation for structs - use CLASS macro instead.
#
# Revision 1.14  2013/10/15 23:24:33  pauloscustodio
# Move reading by lines or tokens and file reading interface to scan.rl
# to decouple file.c from scan.c.
# Add singleton interface to scan to be used by parser.
#
# Revision 1.13  2013/10/08 21:53:07  pauloscustodio
# Replace Flex-based lexer by a Ragel-based one.
# Add interface to file.c to read files by tokens, calling the lexer.
#
# Revision 1.12  2013/10/05 09:24:13  pauloscustodio
# Parse command line options via look-up tables:
# -t (deprecated)
#
# Revision 1.11  2013/09/23 23:14:10  pauloscustodio
# Renamed SzList to StringList, simplified interface by assuming that
# list lives in memory util program ends; it is used for directory searches
# only. Moved interface to strutil.c, removed strlist.c.
#
# Revision 1.10  2013/09/22 21:04:21  pauloscustodio
# New File and FileStack objects
#
# Revision 1.9  2013/09/09 00:20:45  pauloscustodio
# Add default set of modules to t_compile_module:
# -DMEMALLOC_DEBUG xmalloc.c die.o except.o strpool.o
#
# Revision 1.8  2013/09/08 00:43:59  pauloscustodio
# New error module with one error function per error, no need for the error
# constants. Allows compiler to type-check error message arguments.
# Included the errors module in the init() mechanism, no need to call
# error initialization from main(). Moved all error-testing scripts to
# one file errors.t.
#
# Revision 1.7  2013/09/01 17:45:46  pauloscustodio
# Need to include init.o to have memory initialized
#
# Revision 1.6  2013/09/01 00:18:30  pauloscustodio
# - Replaced e4c exception mechanism by a much simpler one based on a few
#   macros. The former did not allow an exit(1) to be called within a
#   try-catch block.
#
# Revision 1.5  2013/05/11 00:29:26  pauloscustodio
# CH_0021 : Exceptions on file IO show file name
# Keep a hash table of all opened file names, so that the file name
# is shown on a fatal error.
# Rename file IO funtions: f..._err to xf...
#
# Revision 1.4  2013/01/20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.3  2013/01/19 23:54:04  pauloscustodio
# BUG_0023 : Error file with warning is removed in link phase
# z80asm -b f1.asm
# If assembling f1.asm produces a warning, the link phase removes the f1.err
# file hidding the warning.
#
# Revision 1.2  2012/06/14 15:01:27  pauloscustodio
# Split safe strings from strutil.c to safestr.c
#
# Revision 1.1  2012/05/26 18:51:10  pauloscustodio
# CH_0012 : wrappers on OS calls to raise fatal error
# CH_0013 : new errors interface to decouple calling code from errors.c
#
