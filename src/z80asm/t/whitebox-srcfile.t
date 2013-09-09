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

my $objs = "srcfile.o class.o file.o errors.o strlist.o dynstr.o safestr.o strutil.o";

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
t_compile_module($init_code, <<'END', $objs);
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

t_run_module(['f0'], <<'OUT', "", 0);
f0
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

t_run_module(['f1'], <<'OUT', "", 0);
f1
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

t_run_module(['f2'], <<'OUT', "", 0);
f2
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

t_run_module(['f3'], <<'OUT', "", 0);
f3
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

t_run_module(['f4'], <<'OUT', "", 0);
f4
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


t_run_module(['f0', 'x1', 'x2', 'x3'], <<'OUT', "", 0);
f0
GLib Memory statistics (successful operations):
 blocks of | allocated  | freed      | allocated  | freed      | n_bytes   
  n_bytes  | n_times by | n_times by | n_times by | n_times by | remaining 
           | malloc()   | free()     | realloc()  | realloc()  |           
===========|============|============|============|============|===========
        12 |          3 |          3 |          0 |          0 |         +0
        20 |          1 |          1 |          0 |          0 |         +0
        36 |          1 |          1 |          0 |          0 |         +0
        96 |          1 |          1 |          0 |          0 |         +0
       252 |          3 |          0 |          0 |          0 |       +756
      1016 |          1 |          0 |          0 |          0 |      +1016
      1024 |          1 |          1 |          0 |          0 |         +0
GLib Memory statistics (failing operations):
 --- none ---
Total bytes: allocated=2984, zero-initialized=1940 (65.01%), freed=1212 (40.62%), remaining=1772
OUT

t_run_module(['f1', 'x1', 'x2', 'x3'], <<'OUT', "", 0);
x1/f1
GLib Memory statistics (successful operations):
 blocks of | allocated  | freed      | allocated  | freed      | n_bytes   
  n_bytes  | n_times by | n_times by | n_times by | n_times by | remaining 
           | malloc()   | free()     | realloc()  | realloc()  |           
===========|============|============|============|============|===========
        12 |          3 |          3 |          0 |          0 |         +0
        20 |          1 |          1 |          0 |          0 |         +0
        36 |          1 |          1 |          0 |          0 |         +0
        96 |          1 |          1 |          0 |          0 |         +0
       252 |          3 |          0 |          0 |          0 |       +756
      1016 |          1 |          0 |          0 |          0 |      +1016
      1024 |          1 |          1 |          0 |          0 |         +0
GLib Memory statistics (failing operations):
 --- none ---
Total bytes: allocated=2984, zero-initialized=1940 (65.01%), freed=1212 (40.62%), remaining=1772
OUT

t_run_module(['f2', 'x1', 'x2', 'x3'], <<'OUT', "", 0);
x2/f2
GLib Memory statistics (successful operations):
 blocks of | allocated  | freed      | allocated  | freed      | n_bytes   
  n_bytes  | n_times by | n_times by | n_times by | n_times by | remaining 
           | malloc()   | free()     | realloc()  | realloc()  |           
===========|============|============|============|============|===========
        12 |          3 |          3 |          0 |          0 |         +0
        20 |          1 |          1 |          0 |          0 |         +0
        36 |          1 |          1 |          0 |          0 |         +0
        96 |          1 |          1 |          0 |          0 |         +0
       252 |          3 |          0 |          0 |          0 |       +756
      1016 |          1 |          0 |          0 |          0 |      +1016
      1024 |          1 |          1 |          0 |          0 |         +0
GLib Memory statistics (failing operations):
 --- none ---
Total bytes: allocated=2984, zero-initialized=1940 (65.01%), freed=1212 (40.62%), remaining=1772
OUT

t_run_module(['f3', 'x1', 'x2', 'x3'], <<'OUT', "", 0);
x3/f3
GLib Memory statistics (successful operations):
 blocks of | allocated  | freed      | allocated  | freed      | n_bytes   
  n_bytes  | n_times by | n_times by | n_times by | n_times by | remaining 
           | malloc()   | free()     | realloc()  | realloc()  |           
===========|============|============|============|============|===========
        12 |          3 |          3 |          0 |          0 |         +0
        20 |          1 |          1 |          0 |          0 |         +0
        36 |          1 |          1 |          0 |          0 |         +0
        96 |          1 |          1 |          0 |          0 |         +0
       252 |          3 |          0 |          0 |          0 |       +756
      1016 |          1 |          0 |          0 |          0 |      +1016
      1024 |          1 |          1 |          0 |          0 |         +0
GLib Memory statistics (failing operations):
 --- none ---
Total bytes: allocated=2984, zero-initialized=1940 (65.01%), freed=1212 (40.62%), remaining=1772
OUT

t_run_module(['f4', 'x1', 'x2', 'x3'], <<'OUT', "", 0);
f4
GLib Memory statistics (successful operations):
 blocks of | allocated  | freed      | allocated  | freed      | n_bytes   
  n_bytes  | n_times by | n_times by | n_times by | n_times by | remaining 
           | malloc()   | free()     | realloc()  | realloc()  |           
===========|============|============|============|============|===========
        12 |          3 |          3 |          0 |          0 |         +0
        20 |          1 |          1 |          0 |          0 |         +0
        36 |          1 |          1 |          0 |          0 |         +0
        96 |          1 |          1 |          0 |          0 |         +0
       252 |          3 |          0 |          0 |          0 |       +756
      1016 |          1 |          0 |          0 |          0 |      +1016
      1024 |          1 |          1 |          0 |          0 |         +0
GLib Memory statistics (failing operations):
 --- none ---
Total bytes: allocated=2984, zero-initialized=1940 (65.01%), freed=1212 (40.62%), remaining=1772
OUT



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

t_run_module([], <<'OUT', <<'ERR', 0);
GLib Memory statistics (successful operations):
 blocks of | allocated  | freed      | allocated  | freed      | n_bytes   
  n_bytes  | n_times by | n_times by | n_times by | n_times by | remaining 
           | malloc()   | free()     | realloc()  | realloc()  |           
===========|============|============|============|============|===========
         7 |          0 |         11 |         11 |          0 |         +0
         8 |          0 |         23 |         23 |          0 |         +0
        12 |         43 |         43 |          0 |          0 |         +0
        20 |          1 |          1 |          0 |          0 |         +0
        28 |          6 |          6 |          0 |          0 |         +0
        32 |          1 |          1 |          0 |          0 |         +0
        36 |          1 |          1 |          0 |          0 |         +0
        40 |         52 |         52 |          0 |          0 |         +0
        44 |          1 |          1 |          0 |          0 |         +0
        48 |          7 |          7 |          0 |          0 |         +0
        96 |          1 |          1 |          0 |          0 |         +0
       252 |          3 |          0 |          0 |          0 |       +756
       256 |          0 |          7 |         41 |         34 |         +0
       384 |          1 |          1 |          0 |          0 |         +0
      1016 |          1 |          0 |          0 |          0 |      +1016
      1024 |          1 |          1 |          0 |          0 |         +0
GLib Memory statistics (failing operations):
 --- none ---
Total bytes: allocated=17265, zero-initialized=5296 (30.67%), freed=15493 (89.74%), remaining=1772
OUT
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
    CATCH ( FatalErrorException )
    {
        ret = 0;		/* ok */
    }
	FINALLY {}
	ETRY;
	
	return ret;
END

t_run_module([], <<'OUT', <<'END', 0);
GLib Memory statistics (successful operations):
 blocks of | allocated  | freed      | allocated  | freed      | n_bytes   
  n_bytes  | n_times by | n_times by | n_times by | n_times by | remaining 
           | malloc()   | free()     | realloc()  | realloc()  |           
===========|============|============|============|============|===========
        12 |          5 |          5 |          0 |          0 |         +0
        20 |          1 |          1 |          0 |          0 |         +0
        21 |          1 |          0 |          0 |          1 |         +0
        24 |          1 |          1 |          0 |          0 |         +0
        32 |          1 |          1 |          0 |          0 |         +0
        36 |          1 |          1 |          0 |          0 |         +0
        37 |          0 |          1 |          1 |          0 |         +0
        40 |          7 |          7 |          0 |          0 |         +0
        42 |          0 |          0 |          1 |          1 |         +0
        44 |          2 |          1 |          0 |          1 |         +0
        48 |          2 |          2 |          0 |          0 |         +0
        88 |          0 |          1 |          1 |          0 |         +0
        96 |          1 |          1 |          0 |          0 |         +0
       252 |          3 |          0 |          0 |          0 |       +756
       256 |          0 |          2 |          2 |          0 |         +0
       384 |          1 |          1 |          0 |          0 |         +0
      1016 |          1 |          0 |          0 |          0 |      +1016
      1024 |          1 |          1 |          0 |          0 |         +0
GLib Memory statistics (failing operations):
 --- none ---
Total bytes: allocated=4612, zero-initialized=2800 (60.71%), freed=2840 (61.58%), remaining=1772
OUT
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

t_run_module([], <<'OUT', <<'END', 0);
GLib Memory statistics (successful operations):
 blocks of | allocated  | freed      | allocated  | freed      | n_bytes   
  n_bytes  | n_times by | n_times by | n_times by | n_times by | remaining 
           | malloc()   | free()     | realloc()  | realloc()  |           
===========|============|============|============|============|===========
        18 |          1 |          0 |          0 |          1 |         +0
        20 |          1 |          1 |          0 |          0 |         +0
        24 |          1 |          2 |          1 |          0 |         +0
        36 |          0 |          0 |          1 |          1 |         +0
        40 |          3 |          3 |          0 |          0 |         +0
        44 |          1 |          0 |          0 |          1 |         +0
        48 |          1 |          1 |          0 |          0 |         +0
        88 |          0 |          1 |          1 |          0 |         +0
        96 |          1 |          1 |          0 |          0 |         +0
       252 |          3 |          0 |          0 |          0 |       +756
       256 |          0 |          1 |          1 |          0 |         +0
      1016 |          1 |          0 |          0 |          0 |      +1016
      1024 |          1 |          1 |          0 |          0 |         +0
GLib Memory statistics (failing operations):
 --- none ---
Total bytes: allocated=3570, zero-initialized=2036 (57.03%), freed=1798 (50.36%), remaining=1772
OUT
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

t_run_module([], <<'OUT', <<'END', 0);
GLib Memory statistics (successful operations):
 blocks of | allocated  | freed      | allocated  | freed      | n_bytes   
  n_bytes  | n_times by | n_times by | n_times by | n_times by | remaining 
           | malloc()   | free()     | realloc()  | realloc()  |           
===========|============|============|============|============|===========
        12 |          1 |          1 |          0 |          0 |         +0
        18 |          1 |          0 |          0 |          1 |         +0
        20 |          1 |          1 |          0 |          0 |         +0
        24 |          1 |          2 |          1 |          0 |         +0
        32 |          1 |          1 |          0 |          0 |         +0
        36 |          0 |          0 |          1 |          1 |         +0
        40 |          6 |          6 |          0 |          0 |         +0
        44 |          2 |          1 |          0 |          1 |         +0
        48 |          2 |          2 |          0 |          0 |         +0
        88 |          0 |          1 |          1 |          0 |         +0
        96 |          1 |          1 |          0 |          0 |         +0
       252 |          3 |          0 |          0 |          0 |       +756
       256 |          0 |          2 |          2 |          0 |         +0
       384 |          1 |          1 |          0 |          0 |         +0
      1016 |          1 |          0 |          0 |          0 |      +1016
      1024 |          1 |          1 |          0 |          0 |         +0
GLib Memory statistics (failing operations):
 --- none ---
Total bytes: allocated=4466, zero-initialized=2676 (59.92%), freed=2694 (60.32%), remaining=1772
OUT
Error: cannot read file 'fxxx'
END
diag "Should show error message location";


# delete directories and files
remove_tree(qw( x1 x2 x3 ));
unlink_testfiles('f0');
done_testing;


__END__
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-srcfile.t,v 1.9 2013-09-09 00:20:45 pauloscustodio Exp $
# $Log: whitebox-srcfile.t,v $
# Revision 1.9  2013-09-09 00:20:45  pauloscustodio
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
# Revision 1.7  2013/09/01 17:14:02  pauloscustodio
# Change in test output due to memalloc change.
#
# Revision 1.6  2013/09/01 11:52:56  pauloscustodio
# Setup memalloc on init.c.
# Setup GLib memory allocation functions to use memalloc functions.
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
