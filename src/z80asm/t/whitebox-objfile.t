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
# Test file

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

my $objs = "objfile.o lib/class.o file.o errors.o lib/strutil.o lib/strlist.o lib/fileutil.o scan.o options.o hist.o";

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
char *CreateLibfile( char *filename ) {}
char *GetLibfile( char *filename ) {}
Symbol *define_static_def_sym( char *name, long value ) {return NULL;}
char ident[MAXLINE];
char separators[MAXLINE];

END


t_compile_module($init, <<'END', $objs);

#define SEL3(i,a,b,c)	((i)<=0?(a):(i)<=1?(b):(c))

	ObjFile *obj;
	FILE	*file;
	int 	code_size;
	
	code_size = atoi(argv[1]);
	
	TITLE("File not found, test mode");	
	unlink("test.obj");
	TRY_OK( obj = ObjFile_open_read("test.obj", TRUE) );
	ASSERT( obj == NULL );

	TITLE("File not found, read mode");	
	unlink("test.obj");
	obj = NULL;
	TRY_NOK( obj = ObjFile_open_read("test.obj", FALSE) );
	ASSERT( obj == NULL );

	TITLE("Invalid short file, test mode");	
	TRY_OK( file = xfopen("test.obj", "wb") );
	TRY_OK( xfclose(file) );
	TRY_OK( obj = ObjFile_open_read("test.obj", TRUE) );
	ASSERT( obj == NULL );
	
	TITLE("Invalid short file, read mode");	
	TRY_OK( file = xfopen("test.obj", "wb") );
	TRY_OK( xfclose(file) );
	obj = NULL;
	TRY_OK( obj = ObjFile_open_read("test.obj", FALSE) );
	ASSERT( obj == NULL );
	
	TITLE("Invalid long file, test mode");	
	TRY_OK( file = xfopen("test.obj", "wb") );
	fprintf( file, "%100s", "" );		/* 100 spaces */
	TRY_OK( xfclose(file) );
	TRY_OK( obj = ObjFile_open_read("test.obj", TRUE) );
	ASSERT( obj == NULL );
	
	TITLE("Invalid long file, read mode");	
	TRY_OK( file = xfopen("test.obj", "wb") );
	fprintf( file, "%100s", "" );		/* 100 spaces */
	TRY_OK( xfclose(file) );
	obj = NULL;
	TRY_OK( obj = ObjFile_open_read("test.obj", FALSE) );
	ASSERT( obj == NULL );
	
	TITLE("TEST1 Object file, read mode");
	TRY_OK( obj = ObjFile_open_read("test1.obj", FALSE) );
	ASSERT( obj != NULL );
	ASSERT( obj->start_ptr == 0 );
	ASSERT( strcmp(obj->filename, "test1.obj") == 0 );
	ASSERT( strcmp(obj->modname,  "TEST1") == 0 );
	ASSERT( obj->in_library == FALSE );
	ASSERT( obj->writing == FALSE );
	ASSERT( obj->org_addr == -1 );
	ASSERT( obj->modname_ptr != -1 );
	ASSERT( obj->expr_ptr == -1 );
	ASSERT( obj->symbols_ptr == -1 );
	ASSERT( obj->externsym_ptr == -1 );
	ASSERT( code_size ? (obj->code_ptr != -1) : (obj->code_ptr == -1));
	ASSERT( obj->code_size == code_size );
	OBJ_DELETE(obj);
	ASSERT( obj == NULL );
	
	TITLE("TEST1 Object file, test mode");
	TRY_OK( obj = ObjFile_open_read("test1.obj", TRUE) );
	ASSERT( obj != NULL );
	ASSERT( obj->start_ptr == 0 );
	ASSERT( strcmp(obj->filename, "test1.obj") == 0 );
	ASSERT( strcmp(obj->modname,  "TEST1") == 0 );
	ASSERT( obj->in_library == FALSE );
	ASSERT( obj->writing == FALSE );
	ASSERT( obj->org_addr == -1 );
	ASSERT( obj->modname_ptr != -1 );
	ASSERT( obj->expr_ptr == -1 );
	ASSERT( obj->symbols_ptr == -1 );
	ASSERT( obj->externsym_ptr == -1 );
	ASSERT( code_size ? (obj->code_ptr != -1) : (obj->code_ptr == -1));
	ASSERT( obj->code_size == code_size );
	OBJ_DELETE(obj);
	ASSERT( obj == NULL );
	
	TITLE("TEST1 Library file");
	TRY_OK( file = xfopen("test1.lib", "rb") );
	ASSERT( file != NULL );
	fseek( file, 16, SEEK_SET );
	TRY_OK( obj = ObjFile_read("test1.lib", file) );	
	ASSERT( obj != NULL );
	ASSERT( obj->start_ptr == 16 );
	ASSERT( strcmp(obj->filename, "test1.lib") == 0 );
	ASSERT( strcmp(obj->modname,  "TEST1") == 0 );
	ASSERT( obj->in_library == TRUE );
	ASSERT( obj->writing == FALSE );
	ASSERT( obj->org_addr == -1 );
	ASSERT( obj->modname_ptr != -1 );
	ASSERT( obj->expr_ptr == -1 );
	ASSERT( obj->symbols_ptr == -1 );
	ASSERT( obj->externsym_ptr == -1 );
	ASSERT( code_size ? (obj->code_ptr != -1) : (obj->code_ptr == -1));
	ASSERT( obj->code_size == code_size );
	OBJ_DELETE(obj);
	ASSERT( obj == NULL );
	
	TITLE("End");	
END

# write test object file
for my $code_size (0, 1, 65536) {
	my $obj1 = objfile(NAME => "TEST1", CODE => "\x00" x $code_size);
	write_binfile(obj1_file(), $obj1); 
	write_binfile(lib1_file(), libfile($obj1));

	t_run_module([$code_size], '', <<'END', 0);

---- TEST: File not found, test mode ----


---- TEST: File not found, read mode ----

Error: cannot read file 'test.obj'

---- TEST: Invalid short file, test mode ----


---- TEST: Invalid short file, read mode ----

Error: file 'test.obj' not an object file

---- TEST: Invalid long file, test mode ----


---- TEST: Invalid long file, read mode ----

Error: file 'test.obj' not an object file

---- TEST: TEST1 Object file, read mode ----


---- TEST: TEST1 Object file, test mode ----


---- TEST: TEST1 Library file ----


---- TEST: End ----

END
}

# delete directories and files
unlink_testfiles();
done_testing;


__END__
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-objfile.t,v 1.17 2014-01-01 21:23:48 pauloscustodio Exp $
# $Log: whitebox-objfile.t,v $
# Revision 1.17  2014-01-01 21:23:48  pauloscustodio
# Move generic file utility functions to lib/fileutil.c
#
# Revision 1.16  2013/12/30 02:05:34  pauloscustodio
# Merge dynstr.c and safestr.c into lib/strutil.c; the new Str type
# handles both dynamically allocated strings and fixed-size strings.
# Replaced g_strchomp by chomp by; g_ascii_tolower by tolower;
# g_ascii_toupper by toupper; g_ascii_strcasecmp by stricompare.
#
# Revision 1.15  2013/12/26 23:42:28  pauloscustodio
# Replace StringList from strutil by StrList in new strlis.c, to keep lists of strings (e.g. directory search paths)
#
# Revision 1.14  2013/12/25 14:39:50  pauloscustodio
# Move strutil.c to the z80asm/lib directory
#
# Revision 1.13  2013/12/18 23:05:52  pauloscustodio
# Move class.c to the z80asm/lib directory
#
# Revision 1.12  2013/12/15 13:18:35  pauloscustodio
# Move memory allocation routines to lib/xmalloc, instead of glib,
# introduce memory leak report on exit and memory fence check.
#
# Revision 1.11  2013/11/11 23:47:04  pauloscustodio
# Move source code generation tools to dev/Makefile, only called on request,
# and keep the generated files in z80asm directory, so that build does
# not require tools used for the code generation (ragel, perl).
# Remove code generation for structs - use CLASS macro instead.
#
# Revision 1.10  2013/10/15 23:24:33  pauloscustodio
# Move reading by lines or tokens and file reading interface to scan.rl
# to decouple file.c from scan.c.
# Add singleton interface to scan to be used by parser.
#
# Revision 1.9  2013/10/08 21:53:07  pauloscustodio
# Replace Flex-based lexer by a Ragel-based one.
# Add interface to file.c to read files by tokens, calling the lexer.
#
# Revision 1.8  2013/09/23 23:14:10  pauloscustodio
# Renamed SzList to StringList, simplified interface by assuming that
# list lives in memory util program ends; it is used for directory searches
# only. Moved interface to strutil.c, removed strlist.c.
#
# Revision 1.7  2013/09/22 21:04:22  pauloscustodio
# New File and FileStack objects
#
# Revision 1.6  2013/09/09 00:20:45  pauloscustodio
# Add default set of modules to t_compile_module:
# -DMEMALLOC_DEBUG xmalloc.c die.o except.o strpool.o
#
# Revision 1.5  2013/09/08 00:43:59  pauloscustodio
# New error module with one error function per error, no need for the error
# constants. Allows compiler to type-check error message arguments.
# Included the errors module in the init() mechanism, no need to call
# error initialization from main(). Moved all error-testing scripts to
# one file errors.t.
#
# Revision 1.4  2013/09/01 17:34:50  pauloscustodio
# Change in test output due to xmalloc change.
#
# Revision 1.3  2013/09/01 11:52:55  pauloscustodio
# Setup xmalloc on init.c.
# Setup GLib memory allocation functions to use xmalloc functions.
#
# Revision 1.2  2013/05/16 22:45:21  pauloscustodio
# Add ObjFile to struct module
# Use ObjFile to check for valid object file
#
# Revision 1.1  2013/05/12 19:46:35  pauloscustodio
# New module for object file handling
#
