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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-srcfile.t,v 1.4 2013-05-11 00:29:26 pauloscustodio Exp $
# $Log: whitebox-srcfile.t,v $
# Revision 1.4  2013-05-11 00:29:26  pauloscustodio
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
#
# Test srcfile

use Modern::Perl;
use Test::More;
use File::Path qw(make_path remove_tree);
require 't/test_utils.pl';

# test memalloc
my $objs = "srcfile.o file.o errors.o strlist.o strhash.o dynstr.o strpool.o class.o ".
		   "die.o strutil.o safestr.o except.o";
ok ! system "make $objs";
my $compile   = "                 memalloc.c $objs";
my $compile_d = "-DMEMALLOC_DEBUG memalloc.c $objs";

my $init_code = <<'END';
#define ERROR return __LINE__
struct module *CURRENTMODULE;
FILE *errfile;
int clinemode;
int clineno;
int listing;
size_t get_PC( void ) { return 0; }
void list_start_line( size_t address, char *source_file, int source_line_nr, char *line ) {}
END

# check source path
t_compile_module($init_code, <<'END', $compile);
	/* main */
	int i;
	
	/* add args 2..N as directories in path */
	for ( i = 2 ; i < argc ; i++ )
		add_source_file_path(argv[i]);
	
	/* search file in arg 1 */
	puts( search_source_file(argv[1]) );
	
	return 0;
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

t_run_module(['f0'], "f0\n", "", 0);
t_run_module(['f1'], "f1\n", "", 0);
t_run_module(['f2'], "f2\n", "", 0);
t_run_module(['f3'], "f3\n", "", 0);
t_run_module(['f4'], "f4\n", "", 0);

t_run_module(['f0', 'x1', 'x2', 'x3'], "f0\n", "", 0);
t_run_module(['f1', 'x1', 'x2', 'x3'], "x1/f1\n", "", 0);
t_run_module(['f2', 'x1', 'x2', 'x3'], "x2/f2\n", "", 0);
t_run_module(['f3', 'x1', 'x2', 'x3'], "x3/f3\n", "", 0);
t_run_module(['f4', 'x1', 'x2', 'x3'], "f4\n", "", 0);


# test module
t_compile_module($init_code, <<'END', $compile_d);

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
	
	add_source_file_path("x1");
	add_source_file_path("x2");
	add_source_file_path("x3");
	
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

t_run_module([], '', <<'END', 0);
memalloc: init
memalloc strlist.c(1): alloc 36 bytes at ADDR_1
memalloc strpool.c(1): alloc 32 bytes at ADDR_2
memalloc strlist.c(3): alloc 12 bytes at ADDR_3
memalloc strpool.c(2): alloc 36 bytes at ADDR_4
memalloc strpool.c(3): alloc 3 bytes at ADDR_5
memalloc strpool.c(4): alloc 44 bytes at ADDR_6
memalloc strpool.c(4): alloc 384 bytes at ADDR_7
memalloc strlist.c(3): alloc 12 bytes at ADDR_8
memalloc strpool.c(2): alloc 36 bytes at ADDR_9
memalloc strpool.c(3): alloc 3 bytes at ADDR_10
memalloc strlist.c(3): alloc 12 bytes at ADDR_11
memalloc strpool.c(2): alloc 36 bytes at ADDR_12
memalloc strpool.c(3): alloc 3 bytes at ADDR_13
memalloc srcfile.c(2): alloc 48 bytes at ADDR_14
memalloc dynstr.c(1): alloc 40 bytes at ADDR_15
memalloc dynstr.c(3): alloc 256 bytes at ADDR_16
memalloc srcfile.c(1): alloc 40 bytes at ADDR_17
memalloc strpool.c(2): alloc 36 bytes at ADDR_18
memalloc strpool.c(3): alloc 3 bytes at ADDR_19
memalloc file.c(1): alloc 32 bytes at ADDR_20
memalloc file.c(4): alloc 40 bytes at ADDR_21
memalloc file.c(5): alloc 44 bytes at ADDR_22
memalloc file.c(5): alloc 384 bytes at ADDR_23
memalloc strpool.c(2): alloc 36 bytes at ADDR_24
memalloc strpool.c(3): alloc 6 bytes at ADDR_25
memalloc dynstr.c(1): alloc 40 bytes at ADDR_26
memalloc dynstr.c(3): alloc 256 bytes at ADDR_27
memalloc dynstr.c(4): free 256 bytes at ADDR_27 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 8 bytes at ADDR_28
memalloc srcfile.c(1): alloc 12 bytes at ADDR_29
memalloc dynstr.c(1): alloc 40 bytes at ADDR_30
memalloc dynstr.c(3): alloc 256 bytes at ADDR_31
memalloc dynstr.c(4): free 256 bytes at ADDR_31 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 7 bytes at ADDR_32
memalloc srcfile.c(1): alloc 12 bytes at ADDR_33
memalloc srcfile.c(3): alloc 28 bytes at ADDR_34
memalloc dynstr.c(1): alloc 40 bytes at ADDR_35
memalloc dynstr.c(3): alloc 256 bytes at ADDR_36
memalloc dynstr.c(4): free 256 bytes at ADDR_36 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 7 bytes at ADDR_37
memalloc srcfile.c(1): alloc 12 bytes at ADDR_38
memalloc dynstr.c(1): alloc 40 bytes at ADDR_39
memalloc dynstr.c(3): alloc 256 bytes at ADDR_40
memalloc dynstr.c(4): free 256 bytes at ADDR_40 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 8 bytes at ADDR_41
memalloc srcfile.c(1): alloc 12 bytes at ADDR_42
memalloc dynstr.c(1): alloc 40 bytes at ADDR_43
memalloc dynstr.c(3): alloc 256 bytes at ADDR_44
memalloc dynstr.c(4): free 256 bytes at ADDR_44 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 8 bytes at ADDR_45
memalloc srcfile.c(1): alloc 12 bytes at ADDR_46
memalloc dynstr.c(1): alloc 40 bytes at ADDR_47
memalloc dynstr.c(3): alloc 256 bytes at ADDR_48
memalloc dynstr.c(4): free 256 bytes at ADDR_48 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 8 bytes at ADDR_49
memalloc srcfile.c(1): alloc 12 bytes at ADDR_50
memalloc srcfile.c(4): free 28 bytes at ADDR_34 allocated at srcfile.c(3)
memalloc srcfile.c(1): free 12 bytes at ADDR_50 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 8 bytes at ADDR_49 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_47 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 12 bytes at ADDR_46 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 8 bytes at ADDR_45 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_43 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 12 bytes at ADDR_42 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 8 bytes at ADDR_41 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_39 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 12 bytes at ADDR_38 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 7 bytes at ADDR_37 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_35 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 12 bytes at ADDR_33 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 7 bytes at ADDR_32 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_30 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 12 bytes at ADDR_29 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 8 bytes at ADDR_28 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_26 allocated at dynstr.c(1)
memalloc srcfile.c(3): alloc 28 bytes at ADDR_51
memalloc dynstr.c(1): alloc 40 bytes at ADDR_52
memalloc dynstr.c(3): alloc 256 bytes at ADDR_53
memalloc dynstr.c(4): free 256 bytes at ADDR_53 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 7 bytes at ADDR_54
memalloc srcfile.c(1): alloc 12 bytes at ADDR_55
memalloc dynstr.c(1): alloc 40 bytes at ADDR_56
memalloc dynstr.c(3): alloc 256 bytes at ADDR_57
memalloc dynstr.c(4): free 256 bytes at ADDR_57 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 8 bytes at ADDR_58
memalloc srcfile.c(1): alloc 12 bytes at ADDR_59
memalloc dynstr.c(1): alloc 40 bytes at ADDR_60
memalloc dynstr.c(3): alloc 256 bytes at ADDR_61
memalloc dynstr.c(4): free 256 bytes at ADDR_61 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 8 bytes at ADDR_62
memalloc srcfile.c(1): alloc 12 bytes at ADDR_63
memalloc dynstr.c(1): alloc 40 bytes at ADDR_64
memalloc dynstr.c(3): alloc 256 bytes at ADDR_65
memalloc dynstr.c(4): free 256 bytes at ADDR_65 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 8 bytes at ADDR_66
memalloc srcfile.c(1): alloc 12 bytes at ADDR_67
memalloc srcfile.c(4): free 28 bytes at ADDR_51 allocated at srcfile.c(3)
memalloc srcfile.c(1): free 12 bytes at ADDR_67 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 8 bytes at ADDR_66 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_64 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 12 bytes at ADDR_63 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 8 bytes at ADDR_62 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_60 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 12 bytes at ADDR_59 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 8 bytes at ADDR_58 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_56 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 12 bytes at ADDR_55 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 7 bytes at ADDR_54 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_52 allocated at dynstr.c(1)
memalloc srcfile.c(5): alloc 40 bytes at ADDR_68
memalloc srcfile.c(2): alloc 48 bytes at ADDR_69
memalloc dynstr.c(1): alloc 40 bytes at ADDR_70
memalloc dynstr.c(3): alloc 256 bytes at ADDR_71
memalloc srcfile.c(1): alloc 40 bytes at ADDR_72
memalloc srcfile.c(5): alloc 12 bytes at ADDR_73
memalloc dynstr.c(1): alloc 40 bytes at ADDR_74
memalloc dynstr.c(3): alloc 256 bytes at ADDR_75
memalloc dynstr.c(4): free 256 bytes at ADDR_75 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 8 bytes at ADDR_76
memalloc srcfile.c(1): alloc 12 bytes at ADDR_77
memalloc dynstr.c(1): alloc 40 bytes at ADDR_78
memalloc dynstr.c(3): alloc 256 bytes at ADDR_79
memalloc dynstr.c(4): free 256 bytes at ADDR_79 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 7 bytes at ADDR_80
memalloc srcfile.c(1): alloc 12 bytes at ADDR_81
memalloc srcfile.c(3): alloc 28 bytes at ADDR_82
memalloc dynstr.c(1): alloc 40 bytes at ADDR_83
memalloc dynstr.c(3): alloc 256 bytes at ADDR_84
memalloc dynstr.c(4): free 256 bytes at ADDR_84 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 7 bytes at ADDR_85
memalloc srcfile.c(1): alloc 12 bytes at ADDR_86
memalloc dynstr.c(1): alloc 40 bytes at ADDR_87
memalloc dynstr.c(3): alloc 256 bytes at ADDR_88
memalloc dynstr.c(4): free 256 bytes at ADDR_88 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 8 bytes at ADDR_89
memalloc srcfile.c(1): alloc 12 bytes at ADDR_90
memalloc dynstr.c(1): alloc 40 bytes at ADDR_91
memalloc dynstr.c(3): alloc 256 bytes at ADDR_92
memalloc dynstr.c(4): free 256 bytes at ADDR_92 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 8 bytes at ADDR_93
memalloc srcfile.c(1): alloc 12 bytes at ADDR_94
memalloc dynstr.c(1): alloc 40 bytes at ADDR_95
memalloc dynstr.c(3): alloc 256 bytes at ADDR_96
memalloc dynstr.c(4): free 256 bytes at ADDR_96 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 8 bytes at ADDR_97
memalloc srcfile.c(1): alloc 12 bytes at ADDR_98
memalloc srcfile.c(4): free 28 bytes at ADDR_82 allocated at srcfile.c(3)
memalloc srcfile.c(1): free 12 bytes at ADDR_98 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 8 bytes at ADDR_97 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_95 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 12 bytes at ADDR_94 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 8 bytes at ADDR_93 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_91 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 12 bytes at ADDR_90 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 8 bytes at ADDR_89 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_87 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 12 bytes at ADDR_86 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 7 bytes at ADDR_85 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_83 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 12 bytes at ADDR_81 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 7 bytes at ADDR_80 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_78 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 12 bytes at ADDR_77 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 8 bytes at ADDR_76 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_74 allocated at dynstr.c(1)
memalloc srcfile.c(5): free 12 bytes at ADDR_73 allocated at srcfile.c(5)
memalloc dynstr.c(2): free 256 bytes at ADDR_71 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_70 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 40 bytes at ADDR_72 allocated at srcfile.c(1)
memalloc srcfile.c(2): free 48 bytes at ADDR_69 allocated at srcfile.c(2)
memalloc srcfile.c(2): alloc 48 bytes at ADDR_99
memalloc dynstr.c(1): alloc 40 bytes at ADDR_100
memalloc dynstr.c(3): alloc 256 bytes at ADDR_101
memalloc srcfile.c(1): alloc 40 bytes at ADDR_102
memalloc srcfile.c(5): alloc 12 bytes at ADDR_103
memalloc dynstr.c(1): alloc 40 bytes at ADDR_104
memalloc dynstr.c(3): alloc 256 bytes at ADDR_105
memalloc dynstr.c(4): free 256 bytes at ADDR_105 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 8 bytes at ADDR_106
memalloc srcfile.c(1): alloc 12 bytes at ADDR_107
memalloc dynstr.c(1): alloc 40 bytes at ADDR_108
memalloc dynstr.c(3): alloc 256 bytes at ADDR_109
memalloc dynstr.c(4): free 256 bytes at ADDR_109 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 7 bytes at ADDR_110
memalloc srcfile.c(1): alloc 12 bytes at ADDR_111
memalloc srcfile.c(3): alloc 28 bytes at ADDR_112
memalloc dynstr.c(1): alloc 40 bytes at ADDR_113
memalloc dynstr.c(3): alloc 256 bytes at ADDR_114
memalloc dynstr.c(4): free 256 bytes at ADDR_114 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 7 bytes at ADDR_115
memalloc srcfile.c(1): alloc 12 bytes at ADDR_116
memalloc dynstr.c(1): alloc 40 bytes at ADDR_117
memalloc dynstr.c(3): alloc 256 bytes at ADDR_118
memalloc dynstr.c(4): free 256 bytes at ADDR_118 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 8 bytes at ADDR_119
memalloc srcfile.c(1): alloc 12 bytes at ADDR_120
memalloc dynstr.c(1): alloc 40 bytes at ADDR_121
memalloc dynstr.c(3): alloc 256 bytes at ADDR_122
memalloc dynstr.c(4): free 256 bytes at ADDR_122 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 8 bytes at ADDR_123
memalloc srcfile.c(1): alloc 12 bytes at ADDR_124
memalloc dynstr.c(1): alloc 40 bytes at ADDR_125
memalloc dynstr.c(3): alloc 256 bytes at ADDR_126
memalloc dynstr.c(4): free 256 bytes at ADDR_126 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 8 bytes at ADDR_127
memalloc srcfile.c(1): alloc 12 bytes at ADDR_128
memalloc srcfile.c(4): free 28 bytes at ADDR_112 allocated at srcfile.c(3)
memalloc srcfile.c(1): free 12 bytes at ADDR_128 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 8 bytes at ADDR_127 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_125 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 12 bytes at ADDR_124 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 8 bytes at ADDR_123 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_121 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 12 bytes at ADDR_120 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 8 bytes at ADDR_119 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_117 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 12 bytes at ADDR_116 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 7 bytes at ADDR_115 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_113 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 12 bytes at ADDR_111 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 7 bytes at ADDR_110 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_108 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 12 bytes at ADDR_107 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 8 bytes at ADDR_106 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_104 allocated at dynstr.c(1)
memalloc srcfile.c(2): alloc 48 bytes at ADDR_129
memalloc dynstr.c(1): alloc 40 bytes at ADDR_130
memalloc dynstr.c(3): alloc 256 bytes at ADDR_131
memalloc srcfile.c(1): alloc 40 bytes at ADDR_132
memalloc file.c(4): alloc 40 bytes at ADDR_133
memalloc srcfile.c(5): alloc 12 bytes at ADDR_134
memalloc srcfile.c(5): free 12 bytes at ADDR_134 allocated at srcfile.c(5)
memalloc dynstr.c(2): free 256 bytes at ADDR_131 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_130 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 40 bytes at ADDR_132 allocated at srcfile.c(1)
memalloc srcfile.c(2): free 48 bytes at ADDR_129 allocated at srcfile.c(2)
memalloc srcfile.c(5): free 12 bytes at ADDR_103 allocated at srcfile.c(5)
memalloc dynstr.c(2): free 256 bytes at ADDR_101 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_100 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 40 bytes at ADDR_102 allocated at srcfile.c(1)
memalloc srcfile.c(2): free 48 bytes at ADDR_99 allocated at srcfile.c(2)
memalloc srcfile.c(5): alloc 40 bytes at ADDR_135
memalloc srcfile.c(2): alloc 48 bytes at ADDR_136
memalloc dynstr.c(1): alloc 40 bytes at ADDR_137
memalloc dynstr.c(3): alloc 256 bytes at ADDR_138
memalloc srcfile.c(1): alloc 40 bytes at ADDR_139
memalloc srcfile.c(5): alloc 12 bytes at ADDR_140
memalloc dynstr.c(1): alloc 40 bytes at ADDR_141
memalloc dynstr.c(3): alloc 256 bytes at ADDR_142
memalloc dynstr.c(4): free 256 bytes at ADDR_142 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 8 bytes at ADDR_143
memalloc srcfile.c(1): alloc 12 bytes at ADDR_144
memalloc dynstr.c(1): alloc 40 bytes at ADDR_145
memalloc dynstr.c(3): alloc 256 bytes at ADDR_146
memalloc dynstr.c(4): free 256 bytes at ADDR_146 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 7 bytes at ADDR_147
memalloc srcfile.c(1): alloc 12 bytes at ADDR_148
memalloc srcfile.c(3): alloc 28 bytes at ADDR_149
memalloc dynstr.c(1): alloc 40 bytes at ADDR_150
memalloc dynstr.c(3): alloc 256 bytes at ADDR_151
memalloc dynstr.c(4): free 256 bytes at ADDR_151 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 7 bytes at ADDR_152
memalloc srcfile.c(1): alloc 12 bytes at ADDR_153
memalloc dynstr.c(1): alloc 40 bytes at ADDR_154
memalloc dynstr.c(3): alloc 256 bytes at ADDR_155
memalloc dynstr.c(4): free 256 bytes at ADDR_155 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 8 bytes at ADDR_156
memalloc srcfile.c(1): alloc 12 bytes at ADDR_157
memalloc dynstr.c(1): alloc 40 bytes at ADDR_158
memalloc dynstr.c(3): alloc 256 bytes at ADDR_159
memalloc dynstr.c(4): free 256 bytes at ADDR_159 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 8 bytes at ADDR_160
memalloc srcfile.c(1): alloc 12 bytes at ADDR_161
memalloc dynstr.c(1): alloc 40 bytes at ADDR_162
memalloc dynstr.c(3): alloc 256 bytes at ADDR_163
memalloc dynstr.c(4): free 256 bytes at ADDR_163 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 8 bytes at ADDR_164
memalloc srcfile.c(1): alloc 12 bytes at ADDR_165
memalloc srcfile.c(4): free 28 bytes at ADDR_149 allocated at srcfile.c(3)
memalloc srcfile.c(1): free 12 bytes at ADDR_165 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 8 bytes at ADDR_164 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_162 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 12 bytes at ADDR_161 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 8 bytes at ADDR_160 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_158 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 12 bytes at ADDR_157 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 8 bytes at ADDR_156 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_154 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 12 bytes at ADDR_153 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 7 bytes at ADDR_152 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_150 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 12 bytes at ADDR_148 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 7 bytes at ADDR_147 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_145 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 12 bytes at ADDR_144 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 8 bytes at ADDR_143 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_141 allocated at dynstr.c(1)
memalloc srcfile.c(5): free 12 bytes at ADDR_140 allocated at srcfile.c(5)
memalloc dynstr.c(2): free 256 bytes at ADDR_138 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_137 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 40 bytes at ADDR_139 allocated at srcfile.c(1)
memalloc srcfile.c(2): free 48 bytes at ADDR_136 allocated at srcfile.c(2)
memalloc srcfile.c(2): alloc 48 bytes at ADDR_166
memalloc dynstr.c(1): alloc 40 bytes at ADDR_167
memalloc dynstr.c(3): alloc 256 bytes at ADDR_168
memalloc srcfile.c(1): alloc 40 bytes at ADDR_169
memalloc srcfile.c(5): alloc 12 bytes at ADDR_170
memalloc dynstr.c(1): alloc 40 bytes at ADDR_171
memalloc dynstr.c(3): alloc 256 bytes at ADDR_172
memalloc dynstr.c(4): free 256 bytes at ADDR_172 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 8 bytes at ADDR_173
memalloc srcfile.c(1): alloc 12 bytes at ADDR_174
memalloc dynstr.c(1): alloc 40 bytes at ADDR_175
memalloc dynstr.c(3): alloc 256 bytes at ADDR_176
memalloc dynstr.c(4): free 256 bytes at ADDR_176 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 7 bytes at ADDR_177
memalloc srcfile.c(1): alloc 12 bytes at ADDR_178
memalloc srcfile.c(3): alloc 28 bytes at ADDR_179
memalloc dynstr.c(1): alloc 40 bytes at ADDR_180
memalloc dynstr.c(3): alloc 256 bytes at ADDR_181
memalloc dynstr.c(4): free 256 bytes at ADDR_181 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 7 bytes at ADDR_182
memalloc srcfile.c(1): alloc 12 bytes at ADDR_183
memalloc dynstr.c(1): alloc 40 bytes at ADDR_184
memalloc dynstr.c(3): alloc 256 bytes at ADDR_185
memalloc dynstr.c(4): free 256 bytes at ADDR_185 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 8 bytes at ADDR_186
memalloc srcfile.c(1): alloc 12 bytes at ADDR_187
memalloc dynstr.c(1): alloc 40 bytes at ADDR_188
memalloc dynstr.c(3): alloc 256 bytes at ADDR_189
memalloc dynstr.c(4): free 256 bytes at ADDR_189 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 8 bytes at ADDR_190
memalloc srcfile.c(1): alloc 12 bytes at ADDR_191
memalloc dynstr.c(1): alloc 40 bytes at ADDR_192
memalloc dynstr.c(3): alloc 256 bytes at ADDR_193
memalloc dynstr.c(4): free 256 bytes at ADDR_193 allocated at dynstr.c(3)
memalloc dynstr.c(4): alloc 8 bytes at ADDR_194
memalloc srcfile.c(1): alloc 12 bytes at ADDR_195
memalloc srcfile.c(4): free 28 bytes at ADDR_179 allocated at srcfile.c(3)
memalloc srcfile.c(1): free 12 bytes at ADDR_195 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 8 bytes at ADDR_194 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_192 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 12 bytes at ADDR_191 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 8 bytes at ADDR_190 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_188 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 12 bytes at ADDR_187 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 8 bytes at ADDR_186 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_184 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 12 bytes at ADDR_183 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 7 bytes at ADDR_182 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_180 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 12 bytes at ADDR_178 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 7 bytes at ADDR_177 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_175 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 12 bytes at ADDR_174 allocated at srcfile.c(1)
memalloc dynstr.c(2): free 8 bytes at ADDR_173 allocated at dynstr.c(4)
memalloc dynstr.c(1): free 40 bytes at ADDR_171 allocated at dynstr.c(1)
memalloc srcfile.c(2): alloc 48 bytes at ADDR_196
memalloc dynstr.c(1): alloc 40 bytes at ADDR_197
memalloc dynstr.c(3): alloc 256 bytes at ADDR_198
memalloc srcfile.c(1): alloc 40 bytes at ADDR_199
memalloc srcfile.c(5): alloc 12 bytes at ADDR_200
memalloc srcfile.c(5): free 12 bytes at ADDR_200 allocated at srcfile.c(5)
memalloc dynstr.c(2): free 256 bytes at ADDR_198 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_197 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 40 bytes at ADDR_199 allocated at srcfile.c(1)
memalloc srcfile.c(2): free 48 bytes at ADDR_196 allocated at srcfile.c(2)
memalloc srcfile.c(5): free 12 bytes at ADDR_170 allocated at srcfile.c(5)
memalloc dynstr.c(2): free 256 bytes at ADDR_168 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_167 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 40 bytes at ADDR_169 allocated at srcfile.c(1)
memalloc srcfile.c(2): free 48 bytes at ADDR_166 allocated at srcfile.c(2)
memalloc dynstr.c(2): free 256 bytes at ADDR_16 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_15 allocated at dynstr.c(1)
memalloc srcfile.c(1): free 40 bytes at ADDR_17 allocated at srcfile.c(1)
memalloc srcfile.c(2): free 48 bytes at ADDR_14 allocated at srcfile.c(2)
memalloc srcfile.c(5): free 40 bytes at ADDR_68 allocated at srcfile.c(5)
last object deleted
memalloc srcfile.c(5): free 40 bytes at ADDR_135 allocated at srcfile.c(5)
memalloc file.c(3): free 40 bytes at ADDR_21 allocated at file.c(4)
memalloc file.c(2): free 384 bytes at ADDR_23 allocated at file.c(5)
memalloc file.c(2): free 44 bytes at ADDR_22 allocated at file.c(5)
memalloc file.c(3): free 40 bytes at ADDR_133 allocated at file.c(4)
memalloc file.c(1): free 32 bytes at ADDR_20 allocated at file.c(1)
memalloc strlist.c(2): free 12 bytes at ADDR_3 allocated at strlist.c(3)
memalloc strlist.c(2): free 12 bytes at ADDR_8 allocated at strlist.c(3)
memalloc strlist.c(2): free 12 bytes at ADDR_11 allocated at strlist.c(3)
memalloc strlist.c(1): free 36 bytes at ADDR_1 allocated at strlist.c(1)
memalloc strpool.c(6): free 3 bytes at ADDR_5 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_4 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_10 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_9 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_13 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_12 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_19 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_18 allocated at strpool.c(2)
memalloc strpool.c(5): free 384 bytes at ADDR_7 allocated at strpool.c(4)
memalloc strpool.c(5): free 44 bytes at ADDR_6 allocated at strpool.c(4)
memalloc strpool.c(6): free 6 bytes at ADDR_25 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_24 allocated at strpool.c(2)
memalloc strpool.c(1): free 32 bytes at ADDR_2 allocated at strpool.c(1)
memalloc: cleanup
END


# check recursive includes
t_compile_module($init_code, <<'END', $compile);
	/* main */
	SourceFileList *lst;
	int ret = 1;
	
    init_except();                      /* init exception mechanism */

    /* start try..catch with finally to cleanup any allocated memory */
    try
    {
		add_source_file_path("x1");
		add_source_file_path("x2");
		add_source_file_path("x3");
		
		lst = OBJ_NEW( SourceFileList );
		if (lst->count != 0) ERROR;
		
		SourceFileList_open( lst, "f0" );
		if (lst->count != 1) ERROR;
		
		SourceFileList_open( lst, "f1" );
		if (lst->count != 2) ERROR;

		SourceFileList_open( lst, "f0" );
		
		warn("not reached\n");
	}
    catch ( FatalErrorException )
    {
        ret = 0;		/* ok */
    }
	
	return ret;
END

t_run_module([], '', <<'END', 0);
Error: Cannot include file 'f0' recursively
END
diag "Should show error message location";


# Check file open error at top level
t_compile_module($init_code, <<'END', $compile);
	/* main */
	SourceFileList *lst;
	int ret = 1;
	
    init_except();                      /* init exception mechanism */

    /* start try..catch with finally to cleanup any allocated memory */
    try
    {
		lst = OBJ_NEW( SourceFileList );
		if (lst->count != 0) ERROR;
		
		SourceFileList_open( lst, "fxxx" );
		warn("not reached\n");
	}
    catch ( FatalErrorException )
    {
        ret = 0;		/* ok */
    }
	
	return ret;
END

t_run_module([], '', <<'END', 0);
Error: Cannot open file 'fxxx' for reading
END


# Check file open error at include level
t_compile_module($init_code, <<'END', $compile);
	/* main */
	SourceFileList *lst;
	int ret = 1;
	
    init_except();                      /* init exception mechanism */

    /* start try..catch with finally to cleanup any allocated memory */
    try
    {
		lst = OBJ_NEW( SourceFileList );
		if (lst->count != 0) ERROR;
		
		SourceFileList_open( lst, "f0" );
		if (lst->count != 1) ERROR;
		
		SourceFileList_open( lst, "fxxx" );
		
		warn("not reached\n");
	}
    catch ( FatalErrorException )
    {
        ret = 0;		/* ok */
    }
	
	return ret;
END

t_run_module([], '', <<'END', 0);
Error: Cannot open file 'fxxx' for reading
END
diag "Should show error message location";


# delete directories and files
remove_tree(qw( x1 x2 x3 ));
unlink_testfiles('f0');
done_testing;
