#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Test zfileutil.c

use Modern::Perl;
use Test::More;
use File::Slurp;
use File::Path qw(make_path remove_tree);
use Capture::Tiny 'capture';
use Test::Differences; 

my $compile = "gcc -I../../../ext/uthash/src -I../../common -Wno-overflow -otest test.c zfileutil.c str.c alloc.c class.c list.c strpool.c dbg.c ../../common/die.o ../../common/fileutil.o ../../common/strutil.o";

#------------------------------------------------------------------------------
# create directories and files
make_path('test.x1', 'test.x2', 'test.x3');
write_file('test.f0', "");
write_file('test.x1/test.f0', "");
write_file('test.x1/test.f1', "");
write_file('test.x2/test.f1', "");
write_file('test.x2/test.f2', "");
write_file('test.x3/test.f2', "");
write_file('test.x3/test.f3', "");


#------------------------------------------------------------------------------
write_file("test.c", <<'END');
#include "zfileutil.h"
#include "fileutil.h"
#include "strpool.h"

#define ERROR die("Test failed at line %d\n", __LINE__)

#define T_REMOVE_EXT(init, result) \
		p = path_remove_ext( init ); \
		if ( strcmp( p, result ) ) ERROR;

#define T_REPLACE_EXT(init, ext, result) \
		p = path_replace_ext( init, ext ); \
		if ( strcmp( p, result ) ) ERROR;

#define T_BASENAME(init, result) \
		p = path_basename( init ); \
		if ( strcmp( p, result ) ) ERROR;

#define T_DIRNAME(init, result) \
		p = path_dirname( init ); \
		if ( strcmp( p, result ) ) ERROR;

#define T_SEARCH(file, path, result) \
		path_search( s, file, path ); \
		if ( strcmp( Str_data(s), result ) ) ERROR; \
		p = search_file( file, path ); \
		if ( strcmp( p, result ) ) ERROR;

int main()
{
	STR_DEFINE(s, FILENAME_MAX);
	char *p;
	UT_array *path = NULL;
	
	/* path_remove_ext */
	T_REMOVE_EXT("abc", 			"abc");
	T_REMOVE_EXT("abc.", 			"abc");
	T_REMOVE_EXT("abc.xpt", 		"abc");
	T_REMOVE_EXT("abc.xpt.obj", 	"abc.xpt");
	T_REMOVE_EXT("./abc", 			"./abc");
	T_REMOVE_EXT(".\\abc",			".\\abc");
	T_REMOVE_EXT("./abc.", 			"./abc");
	T_REMOVE_EXT(".\\abc.",			".\\abc");
	T_REMOVE_EXT("./abc.xpt", 		"./abc");
	T_REMOVE_EXT(".\\abc.xpt",		".\\abc");
	T_REMOVE_EXT("./abc.xpt.obj", 	"./abc.xpt");
	T_REMOVE_EXT(".\\abc.xpt.obj",	".\\abc.xpt");

	/* path_replace_ext */
	T_REPLACE_EXT("abc", 		NULL,	"abc");
	T_REPLACE_EXT("abc.", 		NULL,	"abc");
	T_REPLACE_EXT("abc", 		"",		"abc");
	T_REPLACE_EXT("abc.", 		"",		"abc");
	T_REPLACE_EXT("abc", 		".obj",	"abc.obj");
	T_REPLACE_EXT("abc.", 		".obj",	"abc.obj");
	T_REPLACE_EXT("abc.xpt.zz",	".obj",	"abc.xpt.obj");
	T_REPLACE_EXT("./abc", 		".obj",	"./abc.obj");
	T_REPLACE_EXT(".\\abc", 	".obj",	".\\abc.obj");
	T_REPLACE_EXT("./abc.", 	".obj",	"./abc.obj");
	T_REPLACE_EXT(".\\abc.", 	".obj",	".\\abc.obj");
	T_REPLACE_EXT("./abc.xpt", 	".obj",	"./abc.obj");
	T_REPLACE_EXT(".\\abc.xpt", ".obj",	".\\abc.obj");

	/* path_basename */
	T_BASENAME("abc",			"abc");
	T_BASENAME("abc.zz",		"abc.zz");
	T_BASENAME("./abc",			"abc");
	T_BASENAME(".\\abc",		"abc");
	T_BASENAME("/a/b/c/abc",	"abc");
	T_BASENAME("\\a\\b\\c\\abc","abc");
	
	/* path_dirname */
	T_DIRNAME("abc",			".");
	T_DIRNAME("abc.zz",			".");
	T_DIRNAME("./abc",			".");
	T_DIRNAME(".\\abc",			".");
	T_DIRNAME("/a/b/c/abc",		"/a/b/c");
	T_DIRNAME("\\a\\b\\c\\abc",	"\\a\\b\\c");
	
	/* path_search */
	utarray_new(path,&ut_str_icd);
	p = "test.x1"; utarray_push_back(path, &p);
	p = "test.x2"; utarray_push_back(path, &p);
	p = "test.x3"; utarray_push_back(path, &p);
	
	T_SEARCH("test.f0", NULL, "test.f0");
	T_SEARCH("test.f1", NULL, "test.f1");
	T_SEARCH("test.f2", NULL, "test.f2");
	T_SEARCH("test.f3", NULL, "test.f3");
	T_SEARCH("test.f4", NULL, "test.f4");
	T_SEARCH("test.f0", path, "test.f0");
	T_SEARCH("test.f1", path, "test.x1/test.f1");
	T_SEARCH("test.f2", path, "test.x2/test.f2");
	T_SEARCH("test.f3", path, "test.x3/test.f3");
	T_SEARCH("test.f4", path, "test.f4");
	
	utarray_free(path);
	STR_DELETE(s);
	
	return 0;
}
END

system($compile) and die "compile failed: $compile\n";
t_capture("./test", "", "", 0);

#------------------------------------------------------------------------------
# file io
write_file("test.c", <<'END');
#include "zfileutil.h"
#include "fileutil.h"

#define ERROR die("Test failed at line %d\n", __LINE__)

/* 256 characters */
#define SMALL_STR "1234"
#define BIG_STR "1234567890" "1234567890" "1234567890" "1234567890" "1234567890" \
				"1234567890" "1234567890" "1234567890" "1234567890" "1234567890" \
				"1234567890" "1234567890" "1234567890" "1234567890" "1234567890" \
				"1234567890" "1234567890" "1234567890" "1234567890" "1234567890" \
				"1234567890" "1234567890" "1234567890" "1234567890" "1234567890" \
				"123456" 

int main(int argc, char *argv[])
{
	STR_DEFINE(small, 5);
	STR_DEFINE(large, 1024);
	Str *huge;
	char buffer[1024];
	FILE *file;
	int ivalue;
	unsigned uvalue;
	long ilvalue;
	unsigned long ulvalue;
	
	switch (*argv[1]) 
	{
		case '0':	xfopen("test.1xxxx.bin", "rb");
					break;

		case '1':	xfopen("x/x/x/x/test.1.bin", "wb"); 
					break;
		
		case '2':	file = xfopen("test.1.bin", "wb"); if ( ! file ) ERROR;
					xfclose(file);
					break;
					
		case '4':	Str_set( small, SMALL_STR );
					file = xfopen("test.1.bin", "wb"); if ( ! file ) ERROR;
					xfwrite( Str_data(small), sizeof(char), Str_len(small), file );
					xfclose(file);
					break;
					
		case '5':	Str_set( small, SMALL_STR );
					file = xfopen("test.1.bin", "rb"); if ( ! file ) ERROR;
					xfwrite( Str_data(small), sizeof(char), Str_len(small), file );
					break;

		case '6':	Str_set( small, SMALL_STR );
					memset(buffer, 0, sizeof(buffer));
					file = xfopen("test.1.bin", "rb"); if ( ! file ) ERROR;
					xfread( buffer, sizeof(char), Str_len(small), file );
					if (memcmp(buffer, Str_data(small), Str_len(small))) ERROR;
					
					fseek(file, 1, SEEK_SET);
					xfread( buffer, sizeof(char), Str_len(small), file );
					break;
		
		case '7':	Str_set( small, SMALL_STR );
					file = xfopen("test.1.bin", "wb"); if ( ! file ) ERROR;
					xfwrite_bytes( Str_data(small), Str_len(small), file );
					xfwrite_bytes( Str_data(small), Str_len(small) - 1, file );
					xfclose(file);
					
					memset(buffer, 0, sizeof(buffer));
					file = xfopen("test.1.bin", "rb"); if ( ! file ) ERROR;
					xfread_bytes( buffer, 4, file );
					xfread_bytes( buffer+4, 3, file );
					xfclose(file);
					if (memcmp(buffer, "1234123", 7)) ERROR;
					break;
					
		case '8':	Str_set( small, SMALL_STR );
					file = xfopen("test.1.bin", "wb"); if ( ! file ) ERROR;
					xfwrite_bytes( Str_data(small), Str_len(small), file );
					xfclose(file);
					
					memset(buffer, 0, sizeof(buffer));
					file = xfopen("test.1.bin", "rb"); if ( ! file ) ERROR;
					xfread_bytes( buffer, Str_len(small)+1, file );
					break;
					
	}

	return 0;
}
END

system($compile) and die "compile failed: $compile\n";

t_capture("./test 0", "", "test.1xxxx.bin: No such file or directory\n", 1);
t_capture("./test 1", "", "x/x/x/x/test.1.bin: No such file or directory\n", 1);
t_capture("./test 2", "", "", 0); is read_binfile("test.1.bin"), "";
t_capture("./test 4", "", "", 0); is read_binfile("test.1.bin"), "1234";
t_capture("./test 5", "", "failed to write 4 bytes to file 'test.1.bin'\n", 1);
t_capture("./test 6", "", "failed to read 4 bytes from file 'test.1.bin'\n", 1);
t_capture("./test 7", "", "", 0); is read_binfile("test.1.bin"), "1234123";
t_capture("./test 8", "", "failed to read 5 bytes from file 'test.1.bin'\n", 1);

#------------------------------------------------------------------------------
# order of execution of fini() actions
write_file("test.c", <<'END');
#include "zfileutil.h"
#include "fileutil.h"
#include "init.h"
#include <assert.h>

#define ERROR die("Test failed at line %d\n", __LINE__)

FILE *file;

DEFINE_init_module() { }
DEFINE_dtor_module() 
{
	assert(file);
	xfclose(file);	/* dummy, file is closed by class atexit() */
}

int main()
{
	/* call main fini() after zfileutil fini() */
	init_module();	
	file = xfopen("test.1.bin", "wb"); assert(file);
	
	xfwrite_cstr( "123", file );
	
	return 0;
}
END

system($compile) and die "compile failed: $compile\n";

t_capture("./test", "", "", 0); is read_binfile("test.1.bin"), "123";

#------------------------------------------------------------------------------
# cleanup and exit
remove_tree(<test.x*>);
unlink <test.*>;
done_testing;

#------------------------------------------------------------------------------
# util
sub t_capture {
	my($cmd, $exp_out, $exp_err, $exp_exit) = @_;
	my $line = "[line ".((caller)[2])."]";
	ok 1, "$line command: $cmd";
	
	my($out, $err, $exit) = capture { system $cmd; };
	eq_or_diff_text $out, $exp_out, "$line out";
	eq_or_diff_text $err, $exp_err, "$line err";
	ok !!$exit == !!$exp_exit, "$line exit";
}

sub read_binfile { scalar(read_file($_[0], { binmode => ':raw' })) }
