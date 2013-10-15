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
# Test errors

use Modern::Perl;
use Test::More;
use File::Slurp;
use Test::Differences; 
require 't/test_utils.pl';

# test errors.c
unlink_testfiles();

my $objs = "errors.o scan.o file.o init_obj.o init_obj_file.o init_obj_scan.o class.o safestr.o strutil.o options.o hist.o";

# get init code except init() and main()
my $init = <<'END' . read_file("init.c"); $init =~ s/static void init\(\)\s*\{.*//s;

#include "symbol.h"

struct module *CURRENTMODULE;
FILE *errfile;
size_t get_PC( void ) { return 0; }
void list_start_line( size_t address, char *source_file, int source_line_nr, char *line ) 
{	
	warn("%04X %-16s %5d %s", address, source_file, source_line_nr, line);
}
char *CreateLibfile( char *filename ) {}
char *GetLibfile( char *filename ) {}
Symbol *define_static_def_sym( char *name, long value ) {return NULL;}
char ident[MAXLINE];
char separators[MAXLINE];

END

t_compile_module($init, <<'END', $objs);
#define ERROR return __LINE__
#define check_count(e) if (get_num_errors() != e) ERROR;

	init_errors(); atexit( fini_errors );

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

t_run_module([], <<'OUT', <<'ERR', 1);
GLib Memory statistics (successful operations):
 blocks of | allocated  | freed      | allocated  | freed      | n_bytes   
  n_bytes  | n_times by | n_times by | n_times by | n_times by | remaining 
           | malloc()   | free()     | realloc()  | realloc()  |           
===========|============|============|============|============|===========
        12 |          3 |          0 |          0 |          3 |         +0
        13 |          0 |          1 |          1 |          0 |         +0
        18 |          1 |          0 |          0 |          1 |         +0
        20 |          1 |          1 |          0 |          0 |         +0
        24 |          3 |          3 |          1 |          1 |         +0
        25 |          0 |          0 |          1 |          1 |         +0
        26 |          0 |          1 |          1 |          0 |         +0
        28 |          0 |          1 |          1 |          0 |         +0
        33 |          0 |          0 |          1 |          1 |         +0
        34 |          0 |          1 |          1 |          0 |         +0
        36 |          0 |          0 |          1 |          1 |         +0
        44 |          4 |          1 |          0 |          3 |         +0
        50 |          0 |          0 |          1 |          1 |         +0
        66 |          0 |          0 |          1 |          1 |         +0
        88 |          0 |          3 |          3 |          0 |         +0
        96 |          1 |          1 |          0 |          0 |         +0
       252 |          3 |          0 |          0 |          0 |       +756
      1016 |          1 |          0 |          0 |          0 |      +1016
GLib Memory statistics (failing operations):
 --- none ---
Total bytes: allocated=2789, zero-initialized=1868 (66.98%), freed=1017 (36.46%), remaining=1772
OUT
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

	init_errors(); atexit( fini_errors );

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

t_run_module([], <<'OUT', <<'ERR', 0);
GLib Memory statistics (successful operations):
 blocks of | allocated  | freed      | allocated  | freed      | n_bytes   
  n_bytes  | n_times by | n_times by | n_times by | n_times by | remaining 
           | malloc()   | free()     | realloc()  | realloc()  |           
===========|============|============|============|============|===========
         8 |          0 |          4 |          4 |          0 |         +0
        12 |         25 |          0 |          0 |         25 |         +0
        13 |          0 |         13 |         13 |          0 |         +0
        15 |          0 |          4 |          4 |          0 |         +0
        17 |          0 |          4 |          4 |          0 |         +0
        18 |          1 |          0 |          0 |          1 |         +0
        20 |          1 |          1 |          0 |          0 |         +0
        24 |         13 |         13 |         21 |         21 |         +0
        28 |          0 |          1 |          1 |          0 |         +0
        32 |          1 |          1 |          0 |          0 |         +0
        36 |          0 |          0 |          1 |          1 |         +0
        40 |          1 |          1 |          0 |          0 |         +0
        44 |         27 |         14 |          0 |         13 |         +0
        88 |          0 |         13 |         13 |          0 |         +0
        96 |          2 |          2 |          0 |          0 |         +0
       252 |          3 |          0 |          0 |          0 |       +756
       384 |          1 |          1 |          0 |          0 |         +0
      1016 |          1 |          0 |          0 |          0 |      +1016
      1024 |          1 |          1 |          0 |          0 |         +0
GLib Memory statistics (failing operations):
 --- none ---
Total bytes: allocated=7323, zero-initialized=2464 (33.65%), freed=5551 (75.80%), remaining=1772
OUT
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
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-errors.t,v 1.14 2013-10-15 23:24:33 pauloscustodio Exp $
# $Log: whitebox-errors.t,v $
# Revision 1.14  2013-10-15 23:24:33  pauloscustodio
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
# -DMEMALLOC_DEBUG memalloc.c die.o except.o strpool.o
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
