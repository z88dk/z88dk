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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-objfile.t,v 1.3 2013-09-01 11:52:55 pauloscustodio Exp $
# $Log: whitebox-objfile.t,v $
# Revision 1.3  2013-09-01 11:52:55  pauloscustodio
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
#
# Test file

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

my $objs = "-DMEMALLOC_DEBUG memalloc.c ".
		   "objfile.o class.o strpool.o file.o ".
		   "strutil.o safestr.o strlist.o strhash.o errors.o die.o except.o init.o";

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

	t_run_module([$code_size], "", <<'END', 0);
memalloc: init

---- TEST: File not found, test mode ----


---- TEST: File not found, read mode ----

memalloc errors.c(1): alloc 40 bytes at ADDR_1
memalloc strpool.c(1): alloc 32 bytes at ADDR_2
memalloc strhash.c(1): alloc 32 bytes at ADDR_3
Error: Cannot open file 'test.obj' for reading

---- TEST: Invalid short file, test mode ----

memalloc file.c(1): alloc 32 bytes at ADDR_4
memalloc file.c(4): alloc 40 bytes at ADDR_5
memalloc strpool.c(2): alloc 36 bytes at ADDR_6
memalloc strpool.c(3): alloc 9 bytes at ADDR_7
memalloc strpool.c(4): alloc 44 bytes at ADDR_8
memalloc strpool.c(4): alloc 384 bytes at ADDR_9
memalloc file.c(5): alloc 44 bytes at ADDR_10
memalloc file.c(5): alloc 384 bytes at ADDR_11

---- TEST: Invalid short file, read mode ----

Error: File 'test.obj' not an object file

---- TEST: Invalid long file, test mode ----


---- TEST: Invalid long file, read mode ----

Error: File 'test.obj' not an object file

---- TEST: TEST1 Object file, read mode ----

memalloc strpool.c(2): alloc 36 bytes at ADDR_12
memalloc strpool.c(3): alloc 10 bytes at ADDR_13
memalloc objfile.c(1): alloc 80 bytes at ADDR_14
memalloc strpool.c(2): alloc 36 bytes at ADDR_15
memalloc strpool.c(3): alloc 6 bytes at ADDR_16
memalloc objfile.c(1): free 80 bytes at ADDR_14 allocated at objfile.c(1)

---- TEST: TEST1 Object file, test mode ----

memalloc objfile.c(1): alloc 80 bytes at ADDR_17
memalloc objfile.c(1): free 80 bytes at ADDR_17 allocated at objfile.c(1)

---- TEST: TEST1 Library file ----

memalloc strpool.c(2): alloc 36 bytes at ADDR_18
memalloc strpool.c(3): alloc 10 bytes at ADDR_19
memalloc objfile.c(1): alloc 80 bytes at ADDR_20
memalloc objfile.c(1): free 80 bytes at ADDR_20 allocated at objfile.c(1)

---- TEST: End ----

memalloc file.c(2): free 384 bytes at ADDR_11 allocated at file.c(5)
memalloc file.c(2): free 44 bytes at ADDR_10 allocated at file.c(5)
memalloc file.c(3): free 40 bytes at ADDR_5 allocated at file.c(4)
memalloc file.c(1): free 32 bytes at ADDR_4 allocated at file.c(1)
memalloc strhash.c(1): free 32 bytes at ADDR_3 allocated at strhash.c(1)
memalloc errors.c(1): free 40 bytes at ADDR_1 allocated at errors.c(1)
memalloc strpool.c(6): free 9 bytes at ADDR_7 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_6 allocated at strpool.c(2)
memalloc strpool.c(6): free 10 bytes at ADDR_13 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_12 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_16 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_15 allocated at strpool.c(2)
memalloc strpool.c(5): free 384 bytes at ADDR_9 allocated at strpool.c(4)
memalloc strpool.c(5): free 44 bytes at ADDR_8 allocated at strpool.c(4)
memalloc strpool.c(6): free 10 bytes at ADDR_19 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_18 allocated at strpool.c(2)
memalloc strpool.c(1): free 32 bytes at ADDR_2 allocated at strpool.c(1)
memalloc: cleanup
END
}

# delete directories and files
unlink_testfiles();
done_testing;
