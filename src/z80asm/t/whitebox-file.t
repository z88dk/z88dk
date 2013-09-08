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
use File::Path qw(make_path remove_tree);
require 't/test_utils.pl';

my $objs = "file.o errors.o strlist.o strhash.o class.o ".
		   "die.o strutil.o safestr.o except.o init.o strpool.o";
my $objs_r = "$objs                  memalloc.o";
my $objs_d = "$objs -DMEMALLOC_DEBUG memalloc.c";

t_compile_module('', <<'END', $objs_r);
	SzList *list;
	
	if (argv[2][0] == '0')
	{
		list = NULL;
	}
	else
	{
		list = OBJ_NEW(SzList);
	
		SzList_push(list, "x1");
		SzList_push(list, "x2");
		SzList_push(list, "x3");
	}
	
	puts( search_file(argv[1], list) );
END

# create directories and files
make_path(qw( x1 x2 x3 ));
write_file('f0', "");
write_file('x1/f0', "");
write_file('x1/f1', "");
write_file('x2/f1', "");
write_file('x2/f2', "");
write_file('x3/f2', "");
write_file('x3/f3', "");

t_run_module(['f0', '0'], "f0\n", "", 0);
t_run_module(['f1', '0'], "f1\n", "", 0);
t_run_module(['f2', '0'], "f2\n", "", 0);
t_run_module(['f3', '0'], "f3\n", "", 0);
t_run_module(['f4', '0'], "f4\n", "", 0);

t_run_module(['f0', '1'], "f0\n", "", 0);
t_run_module(['f1', '1'], "x1/f1\n", "", 0);
t_run_module(['f2', '1'], "x2/f2\n", "", 0);
t_run_module(['f3', '1'], "x3/f3\n", "", 0);
t_run_module(['f4', '1'], "f4\n", "", 0);

# test file manipulation
t_compile_module('', <<'END', $objs_r);
#define T1(init, func, result) \
		strcpy( file, init); \
		p = func; \
		ASSERT( p == file ); \
		ASSERT( strcmp(file, result) == 0 )

#define T2(func, result) \
		p = func; \
		ASSERT( strcmp(p, result) == 0 )
	
	char file[FILENAME_MAX];
	char *p;
	
	T1("abc", 			(path_remove_ext(file)), "abc");
	T1("abc.", 			(path_remove_ext(file)), "abc");
	T1("abc.xpt", 		(path_remove_ext(file)), "abc");
	T1("abc.xpt.obj", 	(path_remove_ext(file)), "abc.xpt");
	T1("./abc", 		(path_remove_ext(file)), "./abc");
	T1(".\\abc",		(path_remove_ext(file)), ".\\abc");
	T1("./abc.", 		(path_remove_ext(file)), "./abc");
	T1(".\\abc.",		(path_remove_ext(file)), ".\\abc");
	T1("./abc.xpt", 	(path_remove_ext(file)), "./abc");
	T1(".\\abc.xpt",	(path_remove_ext(file)), ".\\abc");

	T1("", (path_replace_ext(file, "abc", 			".obj")),	"abc.obj");
	T1("", (path_replace_ext(file, "abc.", 			".obj")),	"abc.obj");
	T1("", (path_replace_ext(file, "abc.xpt.zz",	".obj")),	"abc.xpt.obj");
	T1("", (path_replace_ext(file, "./abc", 		".obj")),	"./abc.obj");
	T1("", (path_replace_ext(file, ".\\abc", 		".obj")),	".\\abc.obj");
	T1("", (path_replace_ext(file, "./abc.", 		".obj")),	"./abc.obj");
	T1("", (path_replace_ext(file, ".\\abc.", 		".obj")),	".\\abc.obj");
	T1("", (path_replace_ext(file, "./abc.xpt", 	".obj")),	"./abc.obj");
	T1("", (path_replace_ext(file, ".\\abc.xpt", 	".obj")),	".\\abc.obj");
	
	T1("", (path_basename(file, "abc")),			"abc");
	T1("", (path_basename(file, "abc.zz")),			"abc.zz");
	T1("", (path_basename(file, "./abc")),			"abc");
	T1("", (path_basename(file, ".\\abc")),			"abc");
	T1("", (path_basename(file, "/a/b/c/abc")),		"abc");
	T1("", (path_basename(file, "\\a\\b\\c\\abc")),	"abc");
	
	T2((asm_filename_ext("./abc.xpt")),		"./abc.asm");
	T2((lst_filename_ext("./abc.xpt")),		"./abc.lst");
	T2((obj_filename_ext("./abc.xpt")),		"./abc.obj");
	T2((def_filename_ext("./abc.xpt")),		"./abc.def");
	T2((err_filename_ext("./abc.xpt")),		"./abc.err");
	T2((bin_filename_ext("./abc.xpt")),		"./abc.bin");
	T2((segbin_filename_ext("./abc.xpt")),	"./abc.bn0");
	T2((lib_filename_ext("./abc.xpt")),		"./abc.lib");
	T2((sym_filename_ext("./abc.xpt")),		"./abc.sym");
	T2((map_filename_ext("./abc.xpt")),		"./abc.map");
END

t_run_module([], "", "", 0);

# test file IO
t_compile_module('', <<'END', $objs_d);
/* 256 characters */
#define BIG_STR "1234567890" "1234567890" "1234567890" "1234567890" "1234567890" \
				"1234567890" "1234567890" "1234567890" "1234567890" "1234567890" \
				"1234567890" "1234567890" "1234567890" "1234567890" "1234567890" \
				"1234567890" "1234567890" "1234567890" "1234567890" "1234567890" \
				"1234567890" "1234567890" "1234567890" "1234567890" "1234567890" \
				"123456" 
	SSTR_DEFINE( small, 5 );
	SSTR_DEFINE( large, 1024 );
	char buffer[1024];
	FILE *file;
	long fpos;
	struct stat filestat;
	
	TITLE("xfopen");
	TRY_NOK( file = xfopen("test1xxxx.bin", "rb") );
	TRY_NOK( file = xfopen("x/x/x/x/test1.bin", "wb") );
	
	TITLE("xfclose");
	TRY_OK( file = xfopen("test1.bin", "wb") );
	TRY_OK( xfclose(file) );
	TRY_NOK( xfclose(file) );
	
	TITLE("xstat");
	TRY_NOK( xstat("test1xxxx.bin", &filestat) );
	memset( &filestat, 0, sizeof(filestat) );
	TRY_OK(  xstat("test1.bin",     &filestat) );
	ASSERT( filestat.st_size == 0 );

	TITLE("xfwrite");
	sstr_set( small, BIG_STR );
	TRY_OK( file = xfopen("test1.bin", "wb") );
	TRY_OK( xfwrite( sstr_data(small), sizeof(char), sstr_len(small), file ) );
	TRY_OK( xfclose(file) );
	dump_file("test1.bin");

	TRY_OK( file = xfopen("test1.bin", "rb") );
	TRY_NOK( xfwrite( sstr_data(small), sizeof(char), sstr_len(small), file ) );
	TRY_OK( xfclose(file) );

	TITLE("xfread");
	memset(buffer, 0, sizeof(buffer));
	TRY_OK( file = xfopen("test1.bin", "rb") );
	TRY_OK( xfread( buffer, sizeof(char), sstr_len(small), file ) );
	ASSERT( 0 == memcmp(buffer, sstr_data(small), sstr_len(small)) );
	fseek(file, 1, SEEK_SET);
	TRY_NOK( xfread( buffer, sizeof(char), sstr_len(small), file ) );
	TRY_OK( xfclose(file) );

	TITLE("xfput_char");
	sstr_set( small, BIG_STR );
	TRY_OK( file = xfopen("test1.bin", "wb") );
	TRY_OK( xfput_char( sstr_data(small), sstr_len(small), file ) );
	TRY_OK( xfclose(file) );
	dump_file("test1.bin");

	TRY_OK( file = xfopen("test1.bin", "rb") );
	TRY_NOK( xfput_char( sstr_data(small), sstr_len(small), file ) );
	TRY_OK( xfclose(file) );

	TITLE("xfget_char");
	memset(buffer, 0, sizeof(buffer));
	TRY_OK( file = xfopen("test1.bin", "rb") );
	TRY_OK( xfget_char( buffer, sstr_len(small), file ) );
	ASSERT( 0 == memcmp(buffer, sstr_data(small), sstr_len(small)) );
	fseek(file, 1, SEEK_SET);
	TRY_NOK( xfget_char( buffer, sstr_len(small), file ) );
	TRY_OK( xfclose(file) );

	TITLE("xfput_u8");
	TRY_OK( file = xfopen("test1.bin", "wb") );
	TRY_OK( xfput_u8( -128, file ) );
	TRY_OK( xfput_u8( -127, file ) );
	TRY_OK( xfput_u8(    0, file ) );
	TRY_OK( xfput_u8(  127, file ) );
	TRY_OK( xfput_u8(  128, file ) );
	TRY_OK( xfput_u8(  255, file ) );
	TRY_OK( xfclose(file) );
	dump_file("test1.bin");

	TRY_OK( file = xfopen("test1.bin", "rb") );
	TRY_NOK( xfput_u8( 0, file ) );
	TRY_OK( xfclose(file) );
	
	TITLE("xfget_u8");
	TRY_OK( file = xfopen("test1.bin", "rb") );
	ASSERT( xfget_u8(file) ==  128 );
	ASSERT( xfget_u8(file) ==  129 );
	ASSERT( xfget_u8(file) ==    0 );
	ASSERT( xfget_u8(file) ==  127 );
	ASSERT( xfget_u8(file) ==  128 );
	ASSERT( xfget_u8(file) ==  255 );
	TRY_NOK( xfget_u8( file ) );
	TRY_OK( xfclose(file) );
	
	TITLE("xfget_i8");
	TRY_OK( file = xfopen("test1.bin", "rb") );
	ASSERT( xfget_i8(file) == -128 );
	ASSERT( xfget_i8(file) == -127 );
	ASSERT( xfget_i8(file) ==    0 );
	ASSERT( xfget_i8(file) ==  127 );
	ASSERT( xfget_i8(file) == -128 );
	ASSERT( xfget_i8(file) ==   -1 );
	TRY_NOK( xfget_i8( file ) );
	TRY_OK( xfclose(file) );
	
	TITLE("xfput_u16");
	TRY_OK( file = xfopen("test1.bin", "wb") );
	TRY_OK( xfput_u16( -32768, file ) );
	TRY_OK( xfput_u16( -32767, file ) );
	TRY_OK( xfput_u16(      0, file ) );
	TRY_OK( xfput_u16(  32767, file ) );
	TRY_OK( xfput_u16(  32768, file ) );
	TRY_OK( xfput_u16(  65535, file ) );
	TRY_OK( xfclose(file) );
	dump_file("test1.bin");

	TRY_OK( file = xfopen("test1.bin", "rb") );
	TRY_NOK( xfput_u16( 0, file ) );
	TRY_OK( xfclose(file) );
	
	TITLE("xfget_u16");
	TRY_OK( file = xfopen("test1.bin", "rb") );
	ASSERT( xfget_u16(file) ==  32768 );
	ASSERT( xfget_u16(file) ==  32769 );
	ASSERT( xfget_u16(file) ==      0 );
	ASSERT( xfget_u16(file) ==  32767 );
	ASSERT( xfget_u16(file) ==  32768 );
	ASSERT( xfget_u16(file) ==  65535 );
	fseek(file, -1, SEEK_END);
	TRY_NOK( xfget_u16( file ) );
	TRY_OK( xfclose(file) );
	
	TITLE("xfget_i16");
	TRY_OK( file = xfopen("test1.bin", "rb") );
	ASSERT( xfget_i16(file) == -32768 );
	ASSERT( xfget_i16(file) == -32767 );
	ASSERT( xfget_i16(file) ==      0 );
	ASSERT( xfget_i16(file) ==  32767 );
	ASSERT( xfget_i16(file) == -32768 );
	ASSERT( xfget_i16(file) ==     -1 );
	fseek(file, -1, SEEK_END);
	TRY_NOK( xfget_i16( file ) );
	TRY_OK( xfclose(file) );

	TITLE("xfput_u32");
	TRY_OK( file = xfopen("test1.bin", "wb") );
	TRY_OK( xfput_u32( -2147483648, file ) );
	TRY_OK( xfput_u32( -2147483647, file ) );
	TRY_OK( xfput_u32(           0, file ) );
	TRY_OK( xfput_u32(           1, file ) );
	TRY_OK( xfput_u32(         256, file ) );
	TRY_OK( xfput_u32(       65536, file ) );
	TRY_OK( xfput_u32(    16777216, file ) );
	TRY_OK( xfput_u32(  2147483647, file ) );
	TRY_OK( xfput_u32(  2147483648, file ) );
	TRY_OK( xfput_u32(  4294967295, file ) );
	TRY_OK( xfclose(file) );
	dump_file("test1.bin");

	TRY_OK( file = xfopen("test1.bin", "rb") );
	TRY_NOK( xfput_u32( 0, file ) );
	TRY_OK( xfclose(file) );
	
	TITLE("xfget_u32");
	TRY_OK( file = xfopen("test1.bin", "rb") );
	ASSERT( xfget_u32(file) ==  2147483648 );
	ASSERT( xfget_u32(file) ==  2147483649 );
	ASSERT( xfget_u32(file) ==           0 );
	ASSERT( xfget_u32(file) ==           1 );
	ASSERT( xfget_u32(file) ==         256 );
	ASSERT( xfget_u32(file) ==       65536 );
	ASSERT( xfget_u32(file) ==    16777216 );
	ASSERT( xfget_u32(file) ==  2147483647 );
	ASSERT( xfget_u32(file) ==  2147483648 );
	ASSERT( xfget_u32(file) ==  4294967295 );
	fseek(file, -3, SEEK_END);
	TRY_NOK( xfget_u32( file ) );
	TRY_OK( xfclose(file) );
	
	TITLE("xfget_i32");
	TRY_OK( file = xfopen("test1.bin", "rb") );
	ASSERT( xfget_i32(file) == -2147483648 );
	ASSERT( xfget_i32(file) == -2147483647 );
	ASSERT( xfget_i32(file) ==           0 );
	ASSERT( xfget_i32(file) ==           1 );
	ASSERT( xfget_i32(file) ==         256 );
	ASSERT( xfget_i32(file) ==       65536 );
	ASSERT( xfget_i32(file) ==    16777216 );
	ASSERT( xfget_i32(file) ==  2147483647 );
	ASSERT( xfget_i32(file) ==  2147483648 );
	ASSERT( xfget_i32(file) ==  4294967295 );
	fseek(file, -3, SEEK_END);
	TRY_NOK( xfget_i32( file ) );
	TRY_OK( xfclose(file) );
	
	TITLE("xfput_sstr");
	sstr_set( small, BIG_STR );
	TRY_OK( file = xfopen("test1.bin", "wb") );
	TRY_OK( xfput_sstr( small, file ) );
	TRY_OK( xfclose(file) );
	dump_file("test1.bin");

	TRY_OK( file = xfopen("test1.bin", "rb") );
	TRY_NOK( xfput_sstr( small, file ) );
	TRY_OK( xfclose(file) );

	TITLE("xfget_sstr");
	TRY_OK( file = xfopen("test1.bin", "rb") );
	TRY_OK( xfget_sstr( small, small->size-1, file ) );
	ASSERT( 0 == memcmp(sstr_data(small), BIG_STR, sstr_len(small)) );
	TRY_NOK( xfget_u8( file ) );
	fseek(file, 1, SEEK_SET);
	TRY_NOK( xfget_sstr( small, small->size-1, file ) );
	fseek(file, 0, SEEK_SET);
	TRY_NOK( xfget_sstr( small, small->size, file ) );
	TRY_OK( xfclose(file) );

	TITLE("xfput_c1sstr");
	TRY_OK( file = xfopen("test1.bin", "wb") );
	sstr_set(large, BIG_STR); sstr_data(large)[0] = '\0'; sstr_sync_len(large);
	TRY_OK( xfput_c1sstr(large, file) );
	sstr_set(large, BIG_STR); sstr_data(large)[1] = '\0'; sstr_sync_len(large);
	TRY_OK( xfput_c1sstr(large, file) );
	sstr_set(large, BIG_STR); sstr_data(large)[255] = '\0'; sstr_sync_len(large);
	TRY_OK( xfput_c1sstr(large, file) );
	sstr_set(large, BIG_STR); sstr_data(large)[256] = '\0'; sstr_sync_len(large);
	TRY_NOK( xfput_c1sstr(large, file) );
	TRY_OK( xfclose(file) );
	dump_file("test1.bin");

	TRY_OK( file = xfopen("test1.bin", "rb") );
	sstr_set(large, BIG_STR); sstr_data(large)[0] = '\0'; sstr_sync_len(large);
	TRY_NOK( xfput_c1sstr(large, file) );
	TRY_OK( xfclose(file) );

	TITLE("xfget_c1sstr");
	TRY_OK( file = xfopen("test1.bin", "rb") );
	TRY_OK( xfget_c1sstr( large, file ) );
	ASSERT( 0 == sstr_len(large) );
	ASSERT( 0 == memcmp(sstr_data(large), BIG_STR, sstr_len(large)) );
	TRY_OK( xfget_c1sstr( large, file ) );
	ASSERT( 1 == sstr_len(large) );
	ASSERT( 0 == memcmp(sstr_data(large), BIG_STR, sstr_len(large)) );
	TRY_OK( xfget_c1sstr( large, file ) );
	ASSERT( 255 == sstr_len(large) );
	ASSERT( 0 == memcmp(sstr_data(large), BIG_STR, sstr_len(large)) );
	TRY_NOK( xfget_u8( file ) );
	fseek(file, 0, SEEK_SET);
	TRY_OK( xfget_c1sstr( small, file ) );
	ASSERT( 0 == sstr_len(small) );
	ASSERT( 0 == memcmp(sstr_data(small), BIG_STR, sstr_len(small)) );
	TRY_OK( xfget_c1sstr( small, file ) );
	ASSERT( 1 == sstr_len(small) );
	ASSERT( 0 == memcmp(sstr_data(small), BIG_STR, sstr_len(small)) );
	TRY_NOK( xfget_c1sstr(small, file) );
	TRY_OK( xfclose(file) );

	TITLE("xfput_c2sstr");
	TRY_OK( file = xfopen("test1.bin", "wb") );
	sstr_set(large, BIG_STR); sstr_data(large)[0] = '\0'; sstr_sync_len(large);
	TRY_OK( xfput_c2sstr(large, file) );
	sstr_set(large, BIG_STR); sstr_data(large)[1] = '\0'; sstr_sync_len(large);
	TRY_OK( xfput_c2sstr(large, file) );
	sstr_set(large, BIG_STR); sstr_data(large)[255] = '\0'; sstr_sync_len(large);
	TRY_OK( xfput_c2sstr(large, file) );
	sstr_set(large, BIG_STR); sstr_data(large)[256] = '\0'; sstr_sync_len(large);
	TRY_OK( xfput_c2sstr(large, file) );
	TRY_OK( xfclose(file) );
	dump_file("test1.bin");

	TRY_OK( file = xfopen("test1.bin", "rb") );
	sstr_set(large, BIG_STR); sstr_data(large)[0] = '\0'; sstr_sync_len(large);
	TRY_NOK( xfput_c2sstr(large, file) );
	TRY_OK( xfclose(file) );

	TITLE("xfget_c2sstr");
	TRY_OK( file = xfopen("test1.bin", "rb") );
	TRY_OK( xfget_c2sstr( large, file ) );
	ASSERT( 0 == sstr_len(large) );
	ASSERT( 0 == memcmp(sstr_data(large), BIG_STR, sstr_len(large)) );
	TRY_OK( xfget_c2sstr( large, file ) );
	ASSERT( 1 == sstr_len(large) );
	ASSERT( 0 == memcmp(sstr_data(large), BIG_STR, sstr_len(large)) );
	TRY_OK( xfget_c2sstr( large, file ) );
	ASSERT( 255 == sstr_len(large) );
	ASSERT( 0 == memcmp(sstr_data(large), BIG_STR, sstr_len(large)) );
	TRY_OK( xfget_c2sstr( large, file ) );
	ASSERT( 256 == sstr_len(large) );
	ASSERT( 0 == memcmp(sstr_data(large), BIG_STR, sstr_len(large)) );
	TRY_NOK( xfget_u8( file ) );
	fseek(file, 0, SEEK_SET);
	TRY_OK( xfget_c2sstr( small, file ) );
	ASSERT( 0 == sstr_len(small) );
	ASSERT( 0 == memcmp(sstr_data(small), BIG_STR, sstr_len(small)) );
	TRY_OK( xfget_c2sstr( small, file ) );
	ASSERT( 1 == sstr_len(small) );
	ASSERT( 0 == memcmp(sstr_data(small), BIG_STR, sstr_len(small)) );
	TRY_NOK( xfget_c2sstr(small, file) );
	TRY_OK( xfclose(file) );

END

t_run_module([], <<'OUT', <<'END', 0);
GLib Memory statistics (successful operations):
 blocks of | allocated  | freed      | allocated  | freed      | n_bytes   
  n_bytes  | n_times by | n_times by | n_times by | n_times by | remaining 
           | malloc()   | free()     | realloc()  | realloc()  |           
===========|============|============|============|============|===========
        18 |         17 |          0 |          0 |         17 |         +0
        19 |         11 |          0 |          0 |         11 |         +0
        20 |          1 |          1 |          0 |          0 |         +0
        24 |         28 |         28 |          0 |          0 |         +0
        29 |          0 |         15 |         15 |          0 |         +0
        30 |          0 |         10 |         10 |          0 |         +0
        32 |          1 |          1 |          0 |          0 |         +0
        33 |          0 |          2 |          2 |          0 |         +0
        36 |          0 |          0 |         17 |         17 |         +0
        38 |          0 |          1 |         11 |         10 |         +0
        40 |          1 |          1 |          0 |          0 |         +0
        44 |         29 |          1 |          0 |         28 |         +0
        88 |          0 |         28 |         28 |          0 |         +0
        96 |          2 |          2 |          0 |          0 |         +0
       252 |          3 |          0 |          0 |          0 |       +756
       384 |          1 |          1 |          0 |          0 |         +0
      1016 |          1 |          0 |          0 |          0 |      +1016
      1024 |          1 |          1 |          0 |          0 |         +0
GLib Memory statistics (failing operations):
 --- none ---
Total bytes: allocated=10222, zero-initialized=2464 (24.10%), freed=8450 (82.66%), remaining=1772
OUT

---- TEST: xfopen ----

Error: cannot read file 'test1xxxx.bin'
Error: cannot write file 'x/x/x/x/test1.bin'

---- TEST: xfclose ----

Error: cannot close file 'test1.bin'

---- TEST: xstat ----

Error: cannot read file 'test1xxxx.bin'

---- TEST: xfwrite ----

File: test1.bin:
   0   1    2    3    4   
Error: cannot write file 'test1.bin'

---- TEST: xfread ----

Error: cannot read file 'test1.bin'

---- TEST: xfput_char ----

File: test1.bin:
   0   1    2    3    4   
Error: cannot write file 'test1.bin'

---- TEST: xfget_char ----

Error: cannot read file 'test1.bin'

---- TEST: xfput_u8 ----

File: test1.bin:
   0  <80> <81> <00> <7F> <80> <FF> 
Error: cannot write file 'test1.bin'

---- TEST: xfget_u8 ----

Error: cannot read file 'test1.bin'

---- TEST: xfget_i8 ----

Error: cannot read file 'test1.bin'

---- TEST: xfput_u16 ----

File: test1.bin:
   0  <00> <80> <01> <80> <00> <00> <FF> <7F> <00> <80> <FF> <FF> 
Error: cannot write file 'test1.bin'

---- TEST: xfget_u16 ----

Error: cannot read file 'test1.bin'

---- TEST: xfget_i16 ----

Error: cannot read file 'test1.bin'

---- TEST: xfput_u32 ----

File: test1.bin:
   0  <00> <00> <00> <80> <01> <00> <00> <80> <00> <00> <00> <00> <01> <00> <00> <00> 
  10  <00> <01> <00> <00> <00> <00> <01> <00> <00> <00> <00> <01> <FF> <FF> <FF> <7F> 
  20  <00> <00> <00> <80> <FF> <FF> <FF> <FF> 
Error: cannot write file 'test1.bin'

---- TEST: xfget_u32 ----

Error: cannot read file 'test1.bin'

---- TEST: xfget_i32 ----

Error: cannot read file 'test1.bin'

---- TEST: xfput_sstr ----

File: test1.bin:
   0   1    2    3    4   
Error: cannot write file 'test1.bin'

---- TEST: xfget_sstr ----

Error: cannot read file 'test1.bin'
Error: cannot read file 'test1.bin'
Error: cannot read file 'test1.bin'

---- TEST: xfput_c1sstr ----

Error: cannot write file 'test1.bin'
File: test1.bin:
   0  <00> <01>  1   <FF>  1    2    3    4    5    6    7    8    9    0    1    2   
  10   3    4    5    6    7    8    9    0    1    2    3    4    5    6    7    8   
  20   9    0    1    2    3    4    5    6    7    8    9    0    1    2    3    4   
  30   5    6    7    8    9    0    1    2    3    4    5    6    7    8    9    0   
  40   1    2    3    4    5    6    7    8    9    0    1    2    3    4    5    6   
  50   7    8    9    0    1    2    3    4    5    6    7    8    9    0    1    2   
  60   3    4    5    6    7    8    9    0    1    2    3    4    5    6    7    8   
  70   9    0    1    2    3    4    5    6    7    8    9    0    1    2    3    4   
  80   5    6    7    8    9    0    1    2    3    4    5    6    7    8    9    0   
  90   1    2    3    4    5    6    7    8    9    0    1    2    3    4    5    6   
  A0   7    8    9    0    1    2    3    4    5    6    7    8    9    0    1    2   
  B0   3    4    5    6    7    8    9    0    1    2    3    4    5    6    7    8   
  C0   9    0    1    2    3    4    5    6    7    8    9    0    1    2    3    4   
  D0   5    6    7    8    9    0    1    2    3    4    5    6    7    8    9    0   
  E0   1    2    3    4    5    6    7    8    9    0    1    2    3    4    5    6   
  F0   7    8    9    0    1    2    3    4    5    6    7    8    9    0    1    2   
 100   3    4    5   
Error: cannot write file 'test1.bin'

---- TEST: xfget_c1sstr ----

Error: cannot read file 'test1.bin'
Error: cannot read file 'test1.bin'

---- TEST: xfput_c2sstr ----

File: test1.bin:
   0  <00> <00> <01> <00>  1   <FF> <00>  1    2    3    4    5    6    7    8    9   
  10   0    1    2    3    4    5    6    7    8    9    0    1    2    3    4    5   
  20   6    7    8    9    0    1    2    3    4    5    6    7    8    9    0    1   
  30   2    3    4    5    6    7    8    9    0    1    2    3    4    5    6    7   
  40   8    9    0    1    2    3    4    5    6    7    8    9    0    1    2    3   
  50   4    5    6    7    8    9    0    1    2    3    4    5    6    7    8    9   
  60   0    1    2    3    4    5    6    7    8    9    0    1    2    3    4    5   
  70   6    7    8    9    0    1    2    3    4    5    6    7    8    9    0    1   
  80   2    3    4    5    6    7    8    9    0    1    2    3    4    5    6    7   
  90   8    9    0    1    2    3    4    5    6    7    8    9    0    1    2    3   
  A0   4    5    6    7    8    9    0    1    2    3    4    5    6    7    8    9   
  B0   0    1    2    3    4    5    6    7    8    9    0    1    2    3    4    5   
  C0   6    7    8    9    0    1    2    3    4    5    6    7    8    9    0    1   
  D0   2    3    4    5    6    7    8    9    0    1    2    3    4    5    6    7   
  E0   8    9    0    1    2    3    4    5    6    7    8    9    0    1    2    3   
  F0   4    5    6    7    8    9    0    1    2    3    4    5    6    7    8    9   
 100   0    1    2    3    4    5   <00> <01>  1    2    3    4    5    6    7    8   
 110   9    0    1    2    3    4    5    6    7    8    9    0    1    2    3    4   
 120   5    6    7    8    9    0    1    2    3    4    5    6    7    8    9    0   
 130   1    2    3    4    5    6    7    8    9    0    1    2    3    4    5    6   
 140   7    8    9    0    1    2    3    4    5    6    7    8    9    0    1    2   
 150   3    4    5    6    7    8    9    0    1    2    3    4    5    6    7    8   
 160   9    0    1    2    3    4    5    6    7    8    9    0    1    2    3    4   
 170   5    6    7    8    9    0    1    2    3    4    5    6    7    8    9    0   
 180   1    2    3    4    5    6    7    8    9    0    1    2    3    4    5    6   
 190   7    8    9    0    1    2    3    4    5    6    7    8    9    0    1    2   
 1A0   3    4    5    6    7    8    9    0    1    2    3    4    5    6    7    8   
 1B0   9    0    1    2    3    4    5    6    7    8    9    0    1    2    3    4   
 1C0   5    6    7    8    9    0    1    2    3    4    5    6    7    8    9    0   
 1D0   1    2    3    4    5    6    7    8    9    0    1    2    3    4    5    6   
 1E0   7    8    9    0    1    2    3    4    5    6    7    8    9    0    1    2   
 1F0   3    4    5    6    7    8    9    0    1    2    3    4    5    6    7    8   
 200   9    0    1    2    3    4    5    6   
Error: cannot write file 'test1.bin'

---- TEST: xfget_c2sstr ----

Error: cannot read file 'test1.bin'
Error: cannot read file 'test1.bin'
END

# delete directories and files
remove_tree(qw( x1 x2 x3 ));
unlink_testfiles('f0');
done_testing;


__END__
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-file.t,v 1.14 2013-09-08 00:43:59 pauloscustodio Exp $
# $Log: whitebox-file.t,v $
# Revision 1.14  2013-09-08 00:43:59  pauloscustodio
# New error module with one error function per error, no need for the error
# constants. Allows compiler to type-check error message arguments.
# Included the errors module in the init() mechanism, no need to call
# error initialization from main(). Moved all error-testing scripts to
# one file errors.t.
#
# Revision 1.13  2013/09/01 17:39:26  pauloscustodio
# Change in test output due to memalloc change.
#
# Revision 1.12  2013/09/01 11:52:55  pauloscustodio
# Setup memalloc on init.c.
# Setup GLib memory allocation functions to use memalloc functions.
#
# Revision 1.11  2013/05/12 19:20:34  pauloscustodio
# warnings
#
# Revision 1.10  2013/05/11 00:29:26  pauloscustodio
# CH_0021 : Exceptions on file IO show file name
# Keep a hash table of all opened file names, so that the file name
# is shown on a fatal error.
# Rename file IO funtions: f..._err to xf...
#
# Revision 1.9  2013/04/04 23:08:18  pauloscustodio
# Helper functions to create file names of each of the extensions used in z80asm
#
# Revision 1.8  2013/02/27 20:56:52  pauloscustodio
# search_file() now accepts a NULL dir_list.
#
# Revision 1.7  2013/02/27 20:47:30  pauloscustodio
# Renamed StrList to SzList to solve conflict with CLASS_LIST( Str ) also generating a class StrList
#
# Revision 1.6  2013/02/25 21:36:17  pauloscustodio
# Uniform the APIs of classhash, classlist, strhash, strlist
#
# Revision 1.5  2013/01/20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.4  2013/01/19 23:54:04  pauloscustodio
# BUG_0023 : Error file with warning is removed in link phase
# z80asm -b f1.asm
# If assembling f1.asm produces a warning, the link phase removes the f1.err
# file hidding the warning.
#
# Revision 1.3  2012/06/14 15:01:27  pauloscustodio
# Split safe strings from strutil.c to safestr.c
#
# Revision 1.2  2012/05/26 18:50:26  pauloscustodio
# Use .o instead of .c to build test program, faster compilation.
# Use gcc to compile instead of cc.
#
# Revision 1.1  2012/05/24 21:44:00  pauloscustodio
# New search_file() to search file in a StrList
#
