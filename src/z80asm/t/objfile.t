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
# Test object file output from z80asm

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/objfile.t,v 1.10 2014-04-19 14:57:58 pauloscustodio Exp $
#

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

#------------------------------------------------------------------------------
# Black box tests
#------------------------------------------------------------------------------

my $obj;

# simplest object file
unlink_testfiles();
write_file(asm_file(), "");
t_z80asm_capture(asm_file(), "", "", 0);
$obj = read_binfile(obj_file());
t_binary($obj, objfile(NAME => 'test', CODE => ""));

# add 1 byte of code
unlink_testfiles();
write_file(asm_file(), "nop");
t_z80asm_capture(asm_file(), "", "", 0);
$obj = read_binfile(obj_file());
t_binary($obj, objfile(NAME => 'test', CODE => "\x00"));

# add 65536 byte of code
unlink_testfiles();
write_file(asm_file(), "nop\n" x 0x10000);
t_z80asm_capture(asm_file(), "", "", 0);
$obj = read_binfile(obj_file());
t_binary($obj, objfile(NAME => 'test', CODE => "\x00" x 0x10000));

# define org
unlink_testfiles();
write_file(asm_file(), "org 0 \n nop");
t_z80asm_capture(asm_file(), "", "", 0);
$obj = read_binfile(obj_file());
t_binary($obj, objfile(NAME => 'test', ORG => 0, CODE => "\x00"));

unlink_testfiles();
write_file(asm_file(), "org 0xFFFE \n nop");
t_z80asm_capture(asm_file(), "", "", 0);
$obj = read_binfile(obj_file());
t_binary($obj, objfile(NAME => 'test', ORG => 0xFFFE, CODE => "\x00"));

# add expressions, one of each type
unlink_testfiles();
write_file(asm_file(), "
	ld a,  3*4
	ld b,  (ix + 3*4)
	ld de, 3*4
	defl   3*4
");
t_z80asm_capture(asm_file(), "", "", 0);
$obj = read_binfile(obj_file());
t_binary($obj, objfile(NAME => 'test',
		       CODE => "\x3E\x0C".
			       "\xDD\x46\x0C".
			       "\x11\x0C\x00".
			       "\x0C\x00\x00\x00"));

unlink_testfiles();
write_file(asm_file(), "
	defc   value8  = 3
	defc   value16 = 3

	ld a,  value8 * 4
	ld b,  (ix + value8 * 4)
	ld de, value16 * 4
	defl   value16 * 4
");
t_z80asm_capture(asm_file(), "", "", 0);
$obj = read_binfile(obj_file());
t_binary($obj, objfile(NAME => 'test',
		       SYMBOLS => [["L", "C", 3, "value16"],
				   ["L", "C", 3, "value8"]],
		       CODE => "\x3E\x0C".
			       "\xDD\x46\x0C".
			       "\x11\x0C\x00".
			       "\x0C\x00\x00\x00"));

unlink_testfiles();
write_file(asm_file(), "
	ld a,  value8 *4
	ld b,  (ix + value8 * 4)
	ld de, value16 * 4
	defl   value16 * 4

	defc   value8  = 3
	defc   value16 = 3
");
t_z80asm_capture(asm_file(), "", "", 0);
$obj = read_binfile(obj_file());
t_binary($obj, objfile(NAME => 'test',
		       SYMBOLS => [["L", "C", 3, "value16"],
				   ["L", "C", 3, "value8"]],
		       CODE => "\x3E\x0C".
			       "\xDD\x46\x0C".
			       "\x11\x0C\x00".
			       "\x0C\x00\x00\x00"));

unlink_testfiles();
write_file(asm_file(), "
	org 3
label:	ld a,  label * 4
	ld b,  (ix + label * 5)
label2:	ld de, label2 * 4
	defl   label2 * 6
");
t_z80asm_capture(asm_file(), "", "", 0);
$obj = read_binfile(obj_file());
t_binary($obj, objfile(NAME => 'test',
		       ORG => 3,
		       EXPR => [["U", 1, "label*4"],
				["S", 4, "label*5"],
				["C", 6, "label2*4"],
				["L", 8, "label2*6"]],
		       SYMBOLS => [["L", "A", 0, "label"],
				   ["L", "A", 5, "label2"]],
		       CODE => "\x3E\x00".
			       "\xDD\x46\x00".
			       "\x11\x00\x00".
			       "\x00\x00\x00\x00"));

# local and global symbols
unlink_testfiles();
write_file(asm_file(), "
	PUBLIC global
	EXTERN extobj
	EXTERN extlib

local:	nop
global:	call extobj
	call extlib
");
t_z80asm_capture(asm_file(), "", "", 0);
$obj = read_binfile(obj_file());
t_binary($obj, objfile(NAME => 'test',
		       EXPR => [["C", 2, "extobj"],
				["C", 5, "extlib"]],
		       SYMBOLS => [["L", "A", 0, "local"],
				   ["G", "A", 1, "global"]],
		       LIBS => ["extlib","extobj"],
		       CODE => "\x00".
		               "\xCD\x00\x00".
		               "\xCD\x00\x00"));

# library
unlink_testfiles();
write_file(asm_file(), "
	PUBLIC mult

mult:	ret
");
t_z80asm_capture(asm_file(), "", "", 0);
$obj = read_binfile(obj_file());
t_binary($obj, objfile(NAME => 'test',
		       SYMBOLS => [["G", "A", 0, "mult"]],
		       CODE => "\xC9"));


# link modules
unlink_testfiles();

write_file(asm_file(), "");
t_z80asm_capture(asm_file(), "", "", 0);
$obj = read_binfile(obj_file());
t_binary($obj, objfile(NAME => 'test', CODE => ""));

write_file(asm1_file(), "PUBLIC main \n main:");
t_z80asm_capture(asm1_file(), "", "", 0);
$obj = read_binfile(obj1_file());
t_binary($obj, objfile(NAME => 'test1',
				SYMBOLS => [["G", "A", 0, "main"]],
				CODE => ""));

write_file(asm2_file(), "EXTERN main \n jp main");
t_z80asm_capture(asm2_file(), "", "", 0);
$obj = read_binfile(obj2_file());
t_binary($obj, objfile(NAME => 'test2',
				EXPR => [["C", 1, "main"]],
				LIBS => ["main"],
				CODE => "\xC3\0\0"));
write_binfile(obj3_file(), $obj);

t_z80asm_capture(join(" ", "-r0", "-a", asm_file(), asm1_file(), asm2_file()), "", "", 0);
t_binary(read_binfile(bin_file()), "\xC3\x00\x00");

#------------------------------------------------------------------------------
# White box tests
#------------------------------------------------------------------------------
unlink_testfiles();

my $objs = "objfile.o lib/class.o errors.o lib/strutil.o lib/strhash.o lib/list.o lib/fileutil.o scan.o options.o model.o lib/srcfile.o hist.o";

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

#define SEL3(i,a,b,c)	((i)<=0?(a):(i)<=1?(b):(c))

	ObjFile *obj;
	FILE	*file;
	int 	code_size;
	
	errors_init();

	code_size = atoi(argv[1]);
	
	TITLE("File not found, test mode");	
	remove("test.obj");
	TRY_OK( obj = ObjFile_open_read("test.obj", TRUE) );
	ASSERT( obj == NULL );

	TITLE("File not found, read mode");	
	remove("test.obj");
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
	
	TITLE("test1 Object file, read mode");
	TRY_OK( obj = ObjFile_open_read("test1.obj", FALSE) );
	ASSERT( obj != NULL );
	ASSERT( obj->start_ptr == 0 );
	ASSERT( strcmp(obj->filename, "test1.obj") == 0 );
	ASSERT( strcmp(obj->modname,  "test1") == 0 );
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
	
	TITLE("test1 Object file, test mode");
	TRY_OK( obj = ObjFile_open_read("test1.obj", TRUE) );
	ASSERT( obj != NULL );
	ASSERT( obj->start_ptr == 0 );
	ASSERT( strcmp(obj->filename, "test1.obj") == 0 );
	ASSERT( strcmp(obj->modname,  "test1") == 0 );
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
	
	TITLE("test1 Library file");
	TRY_OK( file = xfopen("test1.lib", "rb") );
	ASSERT( file != NULL );
	fseek( file, 16, SEEK_SET );
	TRY_OK( obj = ObjFile_read("test1.lib", file) );	
	ASSERT( obj != NULL );
	ASSERT( obj->start_ptr == 16 );
	ASSERT( strcmp(obj->filename, "test1.lib") == 0 );
	ASSERT( strcmp(obj->modname,  "test1") == 0 );
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
	my $obj1 = objfile(NAME => "test1", CODE => "\x00" x $code_size);
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

---- TEST: test1 Object file, read mode ----


---- TEST: test1 Object file, test mode ----


---- TEST: test1 Library file ----


---- TEST: End ----

END
}


unlink_testfiles();
done_testing();

# $Log: objfile.t,v $
# Revision 1.10  2014-04-19 14:57:58  pauloscustodio
# Fix test scripts to run in UNIX
#
# Revision 1.9  2014/04/13 20:32:10  pauloscustodio
# PUBLIC and EXTERN instead of LIB, XREF, XDEF, XLIB
#
# Revision 1.8  2014/04/13 11:54:01  pauloscustodio
# CH_0025: PUBLIC and EXTERN instead of LIB, XREF, XDEF, XLIB
# Use new keywords PUBLIC and EXTERN, make the old ones synonyms.
# Remove 'X' scope for symbols in object files used before for XLIB -
# all PUBLIC symbols have scope 'G'.
# Remove SDCC hack on object files trating XLIB and XDEF the same.
# Created a warning to say XDEF et.al. are deprecated, but for the
# momment keep it commented.
#
# Revision 1.7  2014/04/06 23:04:19  pauloscustodio
# Merged objfile.t and whitebox-objfile.t
#
# Revision 1.6  2014/04/05 23:36:11  pauloscustodio
# CH_0024: Case-preserving, case-insensitive symbols
# Symbols no longer converted to upper-case, but still case-insensitive
# searched. Warning when a symbol is used with different case than
# defined. Intermidiate stage before making z80asm case-sensitive, to
# be more C-code friendly.
#
# Revision 1.24  2014/02/08 18:30:49  pauloscustodio (whitebox-objfile.t)
# lib/srcfile.c to read source files and handle recursive includes,
# used to read @lists, removed opts.files;
# model.c to hold global data model
#
# Revision 1.23  2014/01/20 23:29:18  pauloscustodio (whitebox-objfile.t)
# Moved file.c to lib/fileutil.c
#
# Revision 1.22  2014/01/15 00:01:40  pauloscustodio (whitebox-objfile.t)
# Decouple file.c from errors.c by adding a call-back mechanism in file for
# fatal errors, setup by errors_init()
#
# Revision 1.5  2014/01/11 01:29:46  pauloscustodio
# Extend copyright to 2014.
# Move CVS log to bottom of file.
#
# Revision 1.20  2014/01/11 00:10:40  pauloscustodio (whitebox-objfile.t)
# Astyle - format C code
# Add -Wall option to CFLAGS, remove all warnings
#
# Revision 1.19  2014/01/06 00:33:36  pauloscustodio (whitebox-objfile.t)
# Use init.h mechanism, no need for main() calling init_errors
# and atexit(fini_errors); use Str and StrHash instead of glib.
#
# Revision 1.18  2014/01/02 17:18:17  pauloscustodio (whitebox-objfile.t)
# StrList removed, replaced by List
#
# Revision 1.17  2014/01/01 21:23:48  pauloscustodio (whitebox-objfile.t)
# Move generic file utility functions to lib/fileutil.c
#
# Revision 1.16  2013/12/30 02:05:34  pauloscustodio (whitebox-objfile.t)
# Merge dynstr.c and safestr.c into lib/strutil.c; the new Str type
# handles both dynamically allocated strings and fixed-size strings.
# Replaced g_strchomp by chomp by; g_ascii_tolower by tolower;
# g_ascii_toupper by toupper; g_ascii_strcasecmp by stricompare.
#
# Revision 1.15  2013/12/26 23:42:28  pauloscustodio (whitebox-objfile.t)
# Replace StringList from strutil by StrList in new strlis.c, to keep lists of strings (e.g. directory search paths)
#
# Revision 1.14  2013/12/25 14:39:50  pauloscustodio (whitebox-objfile.t)
# Move strutil.c to the z80asm/lib directory
#
# Revision 1.13  2013/12/18 23:05:52  pauloscustodio (whitebox-objfile.t)
# Move class.c to the z80asm/lib directory
#
# Revision 1.12  2013/12/15 13:18:35  pauloscustodio (whitebox-objfile.t)
# Move memory allocation routines to lib/xmalloc, instead of glib,
# introduce memory leak report on exit and memory fence check.
#
# Revision 1.11  2013/11/11 23:47:04  pauloscustodio (whitebox-objfile.t)
# Move source code generation tools to dev/Makefile, only called on request,
# and keep the generated files in z80asm directory, so that build does
# not require tools used for the code generation (ragel, perl).
# Remove code generation for structs - use CLASS macro instead.
#
# Revision 1.4  2013/12/11 23:33:55  pauloscustodio
# BUG_0039: library not pulled in if XLIB symbol not referenced in expression
#
# Revision 1.10  2013/10/15 23:24:33  pauloscustodio (whitebox-objfile.t)
# Move reading by lines or tokens and file reading interface to scan.rl
# to decouple file.c from scan.c.
# Add singleton interface to scan to be used by parser.
#
# Revision 1.9  2013/10/08 21:53:07  pauloscustodio (whitebox-objfile.t)
# Replace Flex-based lexer by a Ragel-based one.
# Add interface to file.c to read files by tokens, calling the lexer.
#
# Revision 1.8  2013/09/23 23:14:10  pauloscustodio (whitebox-objfile.t)
# Renamed SzList to StringList, simplified interface by assuming that
# list lives in memory util program ends; it is used for directory searches
# only. Moved interface to strutil.c, removed strlist.c.
#
# Revision 1.7  2013/09/22 21:04:22  pauloscustodio (whitebox-objfile.t)
# New File and FileStack objects
#
# Revision 1.6  2013/09/09 00:20:45  pauloscustodio (whitebox-objfile.t)
# Add default set of modules to t_compile_module:
# -DMEMALLOC_DEBUG xmalloc.c die.o except.o strpool.o
#
# Revision 1.5  2013/09/08 00:43:59  pauloscustodio (whitebox-objfile.t)
# New error module with one error function per error, no need for the error
# constants. Allows compiler to type-check error message arguments.
# Included the errors module in the init() mechanism, no need to call
# error initialization from main(). Moved all error-testing scripts to
# one file errors.t.
#
# Revision 1.4  2013/09/01 17:34:50  pauloscustodio (whitebox-objfile.t)
# Change in test output due to xmalloc change.
#
# Revision 1.3  2013/09/01 11:52:55  pauloscustodio (whitebox-objfile.t)
# Setup xmalloc on init.c.
# Setup GLib memory allocation functions to use xmalloc functions.
#
# Revision 1.3  2013/06/04 21:40:21  pauloscustodio
# added test cases
#
# Revision 1.2  2013/05/16 22:45:21  pauloscustodio (whitebox-objfile.t)
# Add ObjFile to struct module
# Use ObjFile to check for valid object file
#
# Revision 1.1  2013/05/12 19:46:35  pauloscustodio (whitebox-objfile.t)
# New module for object file handling
#
# Revision 1.2  2013/01/20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.1  2011/08/19 15:53:59  pauloscustodio
# BUG_0010 : heap corruption when reaching MAXCODESIZE
# - test for overflow of MAXCODESIZE is done before each instruction at parseline(); if only one byte is available in codearea, and a 2 byte instruction is assembled, the heap is corrupted before the exception is raised.
# - Factored all the codearea-accessing code into a new module, checking for MAXCODESIZE on every write.
#
