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

my $objs = "objfile.o class.o file.o init_obj.o init_obj_file.o safestr.o errors.o strlist.o strutil.o";

t_compile_module('', <<'END', $objs);

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

	t_run_module([$code_size], <<'OUT', <<'END', 0);
GLib Memory statistics (successful operations):
 blocks of | allocated  | freed      | allocated  | freed      | n_bytes   
  n_bytes  | n_times by | n_times by | n_times by | n_times by | remaining 
           | malloc()   | free()     | realloc()  | realloc()  |           
===========|============|============|============|============|===========
        12 |          2 |          0 |          0 |          2 |         +0
        18 |          1 |          0 |          0 |          1 |         +0
        20 |          1 |          1 |          0 |          0 |         +0
        24 |          3 |          3 |          2 |          2 |         +0
        28 |          0 |          1 |          1 |          0 |         +0
        32 |          1 |          1 |          0 |          0 |         +0
        35 |          0 |          2 |          2 |          0 |         +0
        36 |          0 |          0 |          1 |          1 |         +0
        40 |          1 |          1 |          0 |          0 |         +0
        44 |          4 |          1 |          0 |          3 |         +0
        48 |          0 |          0 |          2 |          2 |         +0
        80 |          3 |          3 |          0 |          0 |         +0
        88 |          0 |          3 |          3 |          0 |         +0
        96 |          1 |          1 |          0 |          0 |         +0
       252 |          3 |          0 |          0 |          0 |       +756
       384 |          1 |          1 |          0 |          0 |         +0
      1016 |          1 |          0 |          0 |          0 |      +1016
      1024 |          1 |          1 |          0 |          0 |         +0
GLib Memory statistics (failing operations):
 --- none ---
Total bytes: allocated=4440, zero-initialized=2608 (58.74%), freed=2668 (60.09%), remaining=1772
OUT

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
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-objfile.t,v 1.7 2013-09-22 21:04:22 pauloscustodio Exp $
# $Log: whitebox-objfile.t,v $
# Revision 1.7  2013-09-22 21:04:22  pauloscustodio
# New File and FileStack objects
#
# Revision 1.6  2013/09/09 00:20:45  pauloscustodio
# Add default set of modules to t_compile_module:
# -DMEMALLOC_DEBUG memalloc.c die.o except.o strpool.o
#
# Revision 1.5  2013/09/08 00:43:59  pauloscustodio
# New error module with one error function per error, no need for the error
# constants. Allows compiler to type-check error message arguments.
# Included the errors module in the init() mechanism, no need to call
# error initialization from main(). Moved all error-testing scripts to
# one file errors.t.
#
# Revision 1.4  2013/09/01 17:34:50  pauloscustodio
# Change in test output due to memalloc change.
#
# Revision 1.3  2013/09/01 11:52:55  pauloscustodio
# Setup memalloc on init.c.
# Setup GLib memory allocation functions to use memalloc functions.
#
# Revision 1.2  2013/05/16 22:45:21  pauloscustodio
# Add ObjFile to struct module
# Use ObjFile to check for valid object file
#
# Revision 1.1  2013/05/12 19:46:35  pauloscustodio
# New module for object file handling
#
