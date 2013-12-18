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
# Test srcfile

use Modern::Perl;
use Test::More;
use File::Path qw(make_path remove_tree);
require 't/test_utils.pl';

my $objs = "srcfile.o lib/class.o file.o errors.o dynstr.o safestr.o strutil.o scan.o options.o hist.o";

my $init_code = <<'END';
#include "symbol.h"
#define ERROR return __LINE__
struct module *CURRENTMODULE;
FILE *errfile;
size_t get_PC( void ) { return 0; }
void list_start_line( size_t address, char *source_file, int source_line_nr, char *line ) {}
char *CreateLibfile( char *filename ) {}
char *GetLibfile( char *filename ) {}
Symbol *define_static_def_sym( char *name, long value ) {return NULL;}
char ident[MAXLINE];
char separators[MAXLINE];
END

# create directories and files
make_path(qw( x1 x2 x3 ));
write_file('f0',    {binmode => ':raw'}, "F0 1\r\rF0 3\n\nF0 5\r\n\nF0 7\r\n\rF0 9\n\r\rF0 11\n\r\nF0 13");
write_file('x1/f0', {binmode => ':raw'}, "");
write_file('x1/f1', {binmode => ':raw'}, "F1 1\r\nF1 2\r\nF1 3\r");
write_file('x2/f1', {binmode => ':raw'}, "");
write_file('x2/f2', {binmode => ':raw'}, "");
write_file('x3/f2', {binmode => ':raw'}, "");
write_file('x3/f3', {binmode => ':raw'}, "");


# test module
t_compile_module($init_code, <<'END', $objs);

#define T_GETLINE(nr,text)										\
	line = SourceFile_getline( src );							\
	if (line == NULL)							ERROR;			\
	if (strcmp(line, text))	{ puts(line); puts(text); ERROR; } 	\
	if (src->line_nr != nr)						ERROR;			\

#define T_END()													\
	line = SourceFile_getline( src );							\
	if (line != NULL)							ERROR;			\
	if (strcmp(Str_data(src->line), ""))		ERROR; 		 	\
	if (src->line_nr != 0)						ERROR;			\

#define T_LST_GETLINE(filename,nr,text)							\
	line = SourceFileList_getline( lst );						\
	if (line == NULL)							ERROR;			\
	if (SourceFileList_line( lst ) != line) 	ERROR;			\
	if (strcmp(line, text))	{ puts(line); puts(text); ERROR; } 	\
	if (SourceFileList_line_nr( lst ) != nr)	ERROR;			\
	if (strcmp(SourceFileList_filename( lst ), filename))	ERROR;			\

#define T_LST_END()												\
	line = SourceFileList_getline( lst );						\
	if (line != NULL)							ERROR;			\
	if (strcmp(SourceFileList_line( lst ), ""))	ERROR; 		 	\
	if (SourceFileList_line_nr( lst ) != 0)		ERROR;			\

#define T_SINGLETON_GETLINE(filename,nr,text)					\
	line = source_getline();									\
	if (line == NULL)							ERROR;			\
	if (source_line() != line)				 	ERROR;			\
	if (strcmp(line, text))	{ puts(line); puts(text); ERROR; } 	\
	if (source_line_nr() != nr)					ERROR;			\
	if (strcmp(source_filename(), filename))	ERROR;			\

#define T_SINGLETON_END()										\
	line = source_getline();									\
	if (line != NULL)							ERROR;			\
	if (strcmp(source_line(), ""))				ERROR; 		 	\
	if (source_line_nr() != 0)					ERROR;			\

	/* main */
	SourceFile *src;
	SourceFileList *lst;
	char *line;
	
	add_StringList(&opts.inc_path, "x1");
	add_StringList(&opts.inc_path, "x2");
	add_StringList(&opts.inc_path, "x3");
	
	src = OBJ_NEW( SourceFile );
	if (strcmp(src->filename, "")) 			ERROR;
	if (src->file       	!= NULL) 		ERROR;
	if (src->line       	== NULL) 		ERROR;
	if (Str_len(src->line) 	!= 0)			ERROR;
	if (src->line_nr    	!= 0   ) 		ERROR;
	if (src->line_stack 	== NULL) 		ERROR;
	if (src->line_stack->count != 0) 		ERROR;
	
	T_END();
	T_END();
	T_END();
	
	SourceFile_open( src, "f0" );
	if (strcmp(src->filename, "f0")) 		ERROR;
	if (src->file       	== NULL) 		ERROR;
	if (src->line       	== NULL) 		ERROR;
	if (Str_len(src->line) 	!= 0)			ERROR;
	if (src->line_nr    	!= 0   ) 		ERROR;
	if (src->line_stack 	== NULL) 		ERROR;
	if (src->line_stack->count != 0) 		ERROR;

	T_GETLINE(1, "F0 1\n");
	T_GETLINE(2, "\n");
	T_GETLINE(3, "F0 3\n");
	T_GETLINE(4, "\n");
	

	/* open file again */
	SourceFile_open( src, "f0" );
	if (strcmp(src->filename, "f0")) 		ERROR;
	if (src->file       	== NULL) 		ERROR;
	if (src->line       	== NULL) 		ERROR;
	if (Str_len(src->line) 	!= 0)			ERROR;
	if (src->line_nr    	!= 0   ) 		ERROR;
	if (src->line_stack 	== NULL) 		ERROR;
	if (src->line_stack->count != 0) 		ERROR;

	T_GETLINE( 1, "F0 1\n");
	T_GETLINE( 2, "\n");
	T_GETLINE( 3, "F0 3\n");
	T_GETLINE( 4, "\n");
	T_GETLINE( 5, "F0 5\n");
	T_GETLINE( 6, "\n");
	T_GETLINE( 7, "F0 7\n");
	T_GETLINE( 8, "\n");
	T_GETLINE( 9, "F0 9\n");
	T_GETLINE(10, "\n");
	T_GETLINE(11, "F0 11\n");
	T_GETLINE(12, "\n");
	T_GETLINE(13, "F0 13\n");
	T_END();
	T_END();
	T_END();
	
	
	/* open new file */
	SourceFile_open( src, "f1" );
	if (strcmp(src->filename, "x1/f1"))		ERROR;
	if (src->file       	== NULL) 		ERROR;
	if (src->line       	== NULL) 		ERROR;
	if (Str_len(src->line) 	!= 0)			ERROR;
	if (src->line_nr    	!= 0   ) 		ERROR;
	if (src->line_stack 	== NULL) 		ERROR;
	if (src->line_stack->count != 0) 		ERROR;

	T_GETLINE( 1, "F1 1\n");
	T_GETLINE( 2, "F1 2\n");
	T_GETLINE( 3, "F1 3\n");
	T_END();
	T_END();
	T_END();
	
	/* ungetline */
	SourceFile_ungetline( src, "line 6\n" );
	SourceFile_ungetline( src, "line 5" );
	SourceFile_ungetline( src, "line 1\nline 2\nline 3\nline 4" );
	
	T_GETLINE( 0, "line 1\n" );
	T_GETLINE( 0, "line 2\n" );
	T_GETLINE( 0, "line 3\n" );
	T_GETLINE( 0, "line 4" );
	T_GETLINE( 0, "line 5" );
	T_GETLINE( 0, "line 6\n" );
	T_END();
	T_END();
	T_END();
	
	/* open new file */
	SourceFile_open( src, "f1" );
	if (strcmp(src->filename, "x1/f1"))		ERROR;
	if (src->file       	== NULL) 		ERROR;
	if (src->line       	== NULL) 		ERROR;
	if (Str_len(src->line) 	!= 0)			ERROR;
	if (src->line_nr    	!= 0   ) 		ERROR;
	if (src->line_stack 	== NULL) 		ERROR;
	if (src->line_stack->count != 0) 		ERROR;

	T_GETLINE( 1, "F1 1\n");

	/* ungetline in the middle of file */
	SourceFile_ungetline( src, "line 1\nline 2\nline 3\nline 4" );
	
	T_GETLINE( 1, "line 1\n" );
	T_GETLINE( 1, "line 2\n" );
	T_GETLINE( 1, "line 3\n" );
	T_GETLINE( 1, "line 4" );

	/* continue from file */
	T_GETLINE( 2, "F1 2\n");
	T_GETLINE( 3, "F1 3\n");
	T_END();
	T_END();
	T_END();
	
	
	/* SourceFileList_getline / ungetline before open */
	lst = OBJ_NEW( SourceFileList );
	
	T_LST_END();
	T_LST_END();
	T_LST_END();
	
	SourceFileList_ungetline( lst, "line 6\n" );
	SourceFileList_ungetline( lst, "line 5" );
	SourceFileList_ungetline( lst, "line 1\nline 2\nline 3\nline 4" );
	
	T_LST_GETLINE("", 0, "line 1\n" );
	T_LST_GETLINE("", 0, "line 2\n" );
	T_LST_GETLINE("", 0, "line 3\n" );
	T_LST_GETLINE("", 0, "line 4" );
	T_LST_GETLINE("", 0, "line 5" );
	T_LST_GETLINE("", 0, "line 6\n" );
	T_LST_END();
	T_LST_END();
	T_LST_END();

	/* open file */
	SourceFileList_open( lst, "f0" );
	if (strcmp(SourceFileList_filename(lst),"f0"))	ERROR;
	if (strcmp(SourceFileList_line( lst ), ""))	ERROR;
	if (SourceFileList_line_nr( lst ) != 0)		ERROR;

	T_LST_GETLINE("f0",1, "F0 1\n");
	T_LST_GETLINE("f0",2, "\n");
	T_LST_GETLINE("f0",3, "F0 3\n");
	T_LST_GETLINE("f0",4, "\n");
	
	SourceFileList_ungetline( lst, "line 6\n" );
	SourceFileList_ungetline( lst, "line 5" );
	SourceFileList_ungetline( lst, "line 1\nline 2\nline 3\nline 4" );
	
	T_LST_GETLINE("f0", 4, "line 1\n" );
	T_LST_GETLINE("f0", 4, "line 2\n" );
	T_LST_GETLINE("f0", 4, "line 3\n" );
	T_LST_GETLINE("f0", 4, "line 4" );
	T_LST_GETLINE("f0", 4, "line 5" );
	T_LST_GETLINE("f0", 4, "line 6\n" );

	T_LST_GETLINE("f0", 5, "F0 5\n");
	T_LST_GETLINE("f0", 6, "\n");
	T_LST_GETLINE("f0", 7, "F0 7\n");
	T_LST_GETLINE("f0", 8, "\n");
	
	/* open new file */
	SourceFileList_open( lst, "f1" );
	if (strcmp(SourceFileList_filename(lst),"x1/f1"))	ERROR;
	if (strcmp(SourceFileList_line( lst ), ""))	ERROR;
	if (SourceFileList_line_nr( lst ) != 0)		ERROR;
	
	T_LST_GETLINE("x1/f1", 1, "F1 1\n");
	T_LST_GETLINE("x1/f1", 2, "F1 2\n");
	T_LST_GETLINE("x1/f1", 3, "F1 3\n");
	
	T_LST_GETLINE("f0", 9, "F0 9\n");
	T_LST_GETLINE("f0",10, "\n");
	T_LST_GETLINE("f0",11, "F0 11\n");
	T_LST_GETLINE("f0",12, "\n");
	T_LST_GETLINE("f0",13, "F0 13\n");
	T_LST_END();
	T_LST_END();
	T_LST_END();
	

	/* singleton API */
	T_SINGLETON_END();
	T_SINGLETON_END();
	T_SINGLETON_END();
	
	source_ungetline("line 6\n" );
	source_ungetline("line 5" );
	source_ungetline("line 1\nline 2\nline 3\nline 4" );
	
	T_SINGLETON_GETLINE("", 0, "line 1\n" );
	T_SINGLETON_GETLINE("", 0, "line 2\n" );
	T_SINGLETON_GETLINE("", 0, "line 3\n" );
	T_SINGLETON_GETLINE("", 0, "line 4" );
	T_SINGLETON_GETLINE("", 0, "line 5" );
	T_SINGLETON_GETLINE("", 0, "line 6\n" );
	T_SINGLETON_END();
	T_SINGLETON_END();
	T_SINGLETON_END();
	
	/* open file */
	source_open("f0");
	if (strcmp(source_filename(),"f0"))	ERROR;
	if (strcmp(source_line(), ""))	ERROR;
	if (source_line_nr() != 0)		ERROR;

	T_SINGLETON_GETLINE("f0",1, "F0 1\n");
	T_SINGLETON_GETLINE("f0",2, "\n");
	T_SINGLETON_GETLINE("f0",3, "F0 3\n");
	T_SINGLETON_GETLINE("f0",4, "\n");
	
	source_ungetline("line 6\n" );
	source_ungetline("line 5" );
	source_ungetline("line 1\nline 2\nline 3\nline 4" );
	
	T_SINGLETON_GETLINE("f0", 4, "line 1\n" );
	T_SINGLETON_GETLINE("f0", 4, "line 2\n" );
	T_SINGLETON_GETLINE("f0", 4, "line 3\n" );
	T_SINGLETON_GETLINE("f0", 4, "line 4" );
	T_SINGLETON_GETLINE("f0", 4, "line 5" );
	T_SINGLETON_GETLINE("f0", 4, "line 6\n" );

	T_SINGLETON_GETLINE("f0", 5, "F0 5\n");
	T_SINGLETON_GETLINE("f0", 6, "\n");
	T_SINGLETON_GETLINE("f0", 7, "F0 7\n");
	T_SINGLETON_GETLINE("f0", 8, "\n");
	
	/* open new file */
	source_open("f1");
	if (strcmp(source_filename(),"x1/f1"))	ERROR;
	if (strcmp(source_line(), ""))	ERROR;
	if (source_line_nr() != 0)		ERROR;
	
	T_SINGLETON_GETLINE("x1/f1", 1, "F1 1\n");
	T_SINGLETON_GETLINE("x1/f1", 2, "F1 2\n");
	T_SINGLETON_GETLINE("x1/f1", 3, "F1 3\n");
	
	T_SINGLETON_GETLINE("f0", 9, "F0 9\n");
	T_SINGLETON_GETLINE("f0",10, "\n");
	T_SINGLETON_GETLINE("f0",11, "F0 11\n");
	T_SINGLETON_GETLINE("f0",12, "\n");
	T_SINGLETON_GETLINE("f0",13, "F0 13\n");
	T_SINGLETON_END();
	T_SINGLETON_END();
	T_SINGLETON_END();


	OBJ_DELETE( src );
	OBJ_DELETE( lst );
	warn("last object deleted\n");
	
	return 0;
END

t_run_module([], '', <<'ERR', 0);
last object deleted
ERR


# check recursive includes
t_compile_module($init_code, <<'END', $objs);
	/* main */
	SourceFileList *lst;
	int ret = 1;
	
    /* start try..catch with finally to cleanup any allocated memory */
    TRY
    {
		add_StringList(&opts.inc_path, "x1");
		add_StringList(&opts.inc_path, "x2");
		add_StringList(&opts.inc_path, "x3");
		
		lst = OBJ_NEW( SourceFileList );
		if (lst->count != 0) ERROR;
		
		SourceFileList_open( lst, "f0" );
		if (lst->count != 1) ERROR;
		
		SourceFileList_open( lst, "f1" );
		if (lst->count != 2) ERROR;

		SourceFileList_open( lst, "f0" );
		
		warn("not reached\n");
	}
    CATCH ( FatalErrorException )
    {
        ret = 0;		/* ok */
    }
	FINALLY {}
	ETRY;
	
	return ret;
END

t_run_module([], '', <<'END', 0);
Error: cannot include file 'f0' recursively
END
diag "Should show error message location";


# Check file open error at top level
t_compile_module($init_code, <<'END', $objs);
	/* main */
	SourceFileList *lst;
	int ret = 1;
	
    /* start try..catch with finally to cleanup any allocated memory */
    TRY
    {
		lst = OBJ_NEW( SourceFileList );
		if (lst->count != 0) ERROR;
		
		SourceFileList_open( lst, "fxxx" );
		warn("not reached\n");
	}
    CATCH ( FatalErrorException )
    {
        ret = 0;		/* ok */
    }
	FINALLY {}
	ETRY;
	
	return ret;
END

t_run_module([], '', <<'END', 0);
Error: cannot read file 'fxxx'
END


# Check file open error at include level
t_compile_module($init_code, <<'END', $objs);
	/* main */
	SourceFileList *lst;
	int ret = 1;
	
    /* start try..catch with finally to cleanup any allocated memory */
    TRY
    {
		lst = OBJ_NEW( SourceFileList );
		if (lst->count != 0) ERROR;
		
		SourceFileList_open( lst, "f0" );
		if (lst->count != 1) ERROR;
		
		SourceFileList_open( lst, "fxxx" );
		
		warn("not reached\n");
	}
    CATCH ( FatalErrorException )
    {
        ret = 0;		/* ok */
    }
	FINALLY {}
	ETRY;
	
	return ret;
END

t_run_module([], '', <<'END', 0);
Error: cannot read file 'fxxx'
END
diag "Should show error message location";


# delete directories and files
remove_tree(qw( x1 x2 x3 ));
unlink_testfiles('f0');
done_testing;


__END__
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-srcfile.t,v 1.21 2013-12-18 23:05:52 pauloscustodio Exp $
# $Log: whitebox-srcfile.t,v $
# Revision 1.21  2013-12-18 23:05:52  pauloscustodio
# Move class.c to the z80asm/lib directory
#
# Revision 1.20  2013/12/15 13:18:35  pauloscustodio
# Move memory allocation routines to lib/xmalloc, instead of glib,
# introduce memory leak report on exit and memory fence check.
#
# Revision 1.19  2013/11/11 23:47:04  pauloscustodio
# Move source code generation tools to dev/Makefile, only called on request,
# and keep the generated files in z80asm directory, so that build does
# not require tools used for the code generation (ragel, perl).
# Remove code generation for structs - use CLASS macro instead.
#
# Revision 1.18  2013/10/15 23:24:33  pauloscustodio
# Move reading by lines or tokens and file reading interface to scan.rl
# to decouple file.c from scan.c.
# Add singleton interface to scan to be used by parser.
#
# Revision 1.17  2013/10/08 21:53:07  pauloscustodio
# Replace Flex-based lexer by a Ragel-based one.
# Add interface to file.c to read files by tokens, calling the lexer.
#
# Revision 1.16  2013/10/05 13:43:05  pauloscustodio
# Parse command line options via look-up tables:
# -i, --use-lib
# -x, --make-lib
#
# Revision 1.15  2013/10/05 10:54:36  pauloscustodio
# Parse command line options via look-up tables:
# -I, --inc-path
# -L, --lib-path
#
# Revision 1.14  2013/10/05 08:14:43  pauloscustodio
# Parse command line options via look-up tables:
# -C, --line-mode
#
# Revision 1.13  2013/10/01 23:23:53  pauloscustodio
# Parse command line options via look-up tables:
# -l, --list
# -nl, --no-list
#
# Revision 1.12  2013/09/30 00:26:57  pauloscustodio
# Parse command line options via look-up tables:
# -e, --asm-ext
# -M, --obj-ext
# Move filename extension functions to options.c
#
# Revision 1.11  2013/09/23 23:14:10  pauloscustodio
# Renamed SzList to StringList, simplified interface by assuming that
# list lives in memory util program ends; it is used for directory searches
# only. Moved interface to strutil.c, removed strlist.c.
#
# Revision 1.10  2013/09/22 21:04:22  pauloscustodio
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
# Revision 1.7  2013/09/01 17:14:02  pauloscustodio
# Change in test output due to xmalloc change.
#
# Revision 1.6  2013/09/01 11:52:56  pauloscustodio
# Setup xmalloc on init.c.
# Setup GLib memory allocation functions to use xmalloc functions.
#
# Revision 1.5  2013/09/01 00:18:30  pauloscustodio
# - Replaced e4c exception mechanism by a much simpler one based on a few
#   macros. The former did not allow an exit(1) to be called within a
#   try-catch block.
#
# Revision 1.4  2013/05/11 00:29:26  pauloscustodio
# CH_0021 : Exceptions on file IO show file name
# Keep a hash table of all opened file names, so that the file name
# is shown on a fatal error.
# Rename file IO funtions: f..._err to xf...
#
# Revision 1.3  2013/03/10 18:00:24  pauloscustodio
# Interface with errors (set input position for errors) and  listfile (start list of each input line)
#
# Revision 1.2  2013/03/02 23:52:49  pauloscustodio
# Add API to handle a stack of open sorce files and singleton API
#
# Revision 1.1  2013/02/27 22:31:43  pauloscustodio
# New srcfile.c to handle reading lines from source files
#
