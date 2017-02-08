#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Test srcfile

use Modern::Perl;
use Test::More;
use File::Slurp;
use File::Path qw(make_path remove_tree);
use Capture::Tiny 'capture';
use Test::Differences; 

my $compile = "gcc -Wall -Ilib -otest test.c srcfile.c ".
			  "class.c alloc.c strpool.c str.c fileutil.c list.c dbg.c";

#------------------------------------------------------------------------------
# create directories and files
make_path('test.x1');
write_binfile('test.f0',    		"F0 1\r\rF0 3\n\nF0 5\r\n\nF0 7\r\n\r".
									"F0 9\n\r\rF0 11\n\r\nF0 13");
write_binfile('test.x1/test.f1', 	"F0 x1\r");
write_binfile('test.x1/test.f2', 	"F1 x1\n");
write_binfile('test.x1/test.f3', 	"F2 x1\r\n");


write_file("test.c", <<'END');
#include "srcfile.h"
#include "dbg.h"
#include <string.h>
#include <assert.h>

#define T_GETLINE(_filename, _line_nr, _expected)	\
			assert( str = SrcFile_getline( file ) ); \
			warn("(%s:%d)%s", _filename, _line_nr, _expected); \
			assert( strcmp( file->filename, _filename ) == 0 ); \
			assert( strcmp( SrcFile_filename(file), _filename ) == 0 ); \
			assert( file->line_nr == _line_nr ); \
			assert( SrcFile_line_nr(file) == _line_nr ); \
			assert( strcmp( str, _expected ) == 0 ); \
			assert( strcmp( str_data(file->line), _expected ) == 0 );
			
#define T_GETLINE_END()	\
			assert( SrcFile_getline( file ) == NULL ); \
			warn("(eof)\n");
			
static void new_line_cb( char *filename, int line_nr, char *text )
{
	warn("File %s line %d text %s\n", 
		 filename ? filename : "NULL", 
		 line_nr,
		 text ? text : "NULL");
}

UT_array *dirs = NULL;

static void incl_recursion_err_cb( char *filename )
{
	if (dirs)
		utarray_free(dirs);
	die("Recursive include %s\n", filename ? filename : "NULL");
}


int main(int argc, char *argv[])
{
	SrcFile *file;
	char *str;
	
	utarray_new(dirs,&ut_str_icd);
	str = "test.x1"; utarray_push_back(dirs, &str);
	
	switch (*argv[1]) 
	{
	case 'A':	
		warn("read first file, no new line callback\n");
		assert( file = OBJ_NEW( SrcFile ) );
		assert( SrcFile_filename( file ) == NULL );
		assert( SrcFile_line_nr( file ) == 0 );
		SrcFile_open( file, "test.f0", NULL );
		T_GETLINE("test.f0",  1, "F0 1\n");
		T_GETLINE("test.f0",  2, "\n");
		T_GETLINE("test.f0",  3, "F0 3\n");
		T_GETLINE("test.f0",  4, "\n");
		T_GETLINE("test.f0",  5, "F0 5\n");
		T_GETLINE("test.f0",  6, "\n");
		T_GETLINE("test.f0",  7, "F0 7\n");
		T_GETLINE("test.f0",  8, "\n");
		T_GETLINE("test.f0",  9, "F0 9\n");
		T_GETLINE("test.f0", 10, "\n");
		T_GETLINE("test.f0", 11, "F0 11\n");
		T_GETLINE("test.f0", 12, "\n");
		T_GETLINE("test.f0", 13, "F0 13\n");
		T_GETLINE_END();
		T_GETLINE_END();
		T_GETLINE_END();
		
		warn("read second file, no new line callback\n");
		SrcFile_open( file, "test.f1", dirs );
		T_GETLINE("test.x1/test.f1", 1, "F0 x1\n");
		T_GETLINE_END();
		T_GETLINE_END();
		T_GETLINE_END();
		
		warn("read third file, no new line callback\n");
		SrcFile_open( file, "test.f2", dirs );
		T_GETLINE("test.x1/test.f2", 1, "F1 x1\n");
		T_GETLINE_END();
		T_GETLINE_END();
		T_GETLINE_END();
		
		warn("read fourth file, no new line callback\n");
		SrcFile_open( file, "test.f3", dirs );
		T_GETLINE("test.x1/test.f3", 1, "F2 x1\n");
		T_GETLINE_END();
		T_GETLINE_END();
		T_GETLINE_END();
		
		warn("set new line callback\n");
		assert( set_new_line_cb( new_line_cb ) == NULL );
		assert( set_new_line_cb( new_line_cb ) == new_line_cb );

		warn("read first file with new line callback\n");
		SrcFile_open( file, "test.f0", NULL );
		T_GETLINE("test.f0",  1, "F0 1\n");
		T_GETLINE("test.f0",  2, "\n");
		T_GETLINE("test.f0",  3, "F0 3\n");
		T_GETLINE("test.f0",  4, "\n");
		T_GETLINE("test.f0",  5, "F0 5\n");
		T_GETLINE("test.f0",  6, "\n");
		T_GETLINE("test.f0",  7, "F0 7\n");
		T_GETLINE("test.f0",  8, "\n");
		T_GETLINE("test.f0",  9, "F0 9\n");
		T_GETLINE("test.f0", 10, "\n");
		T_GETLINE("test.f0", 11, "F0 11\n");
		T_GETLINE("test.f0", 12, "\n");
		T_GETLINE("test.f0", 13, "F0 13\n");
		
		warn("ungetline\n");
		SrcFile_ungetline( file, "line 6\n" );
		SrcFile_ungetline( file, "line 5" );
		SrcFile_ungetline( file, "line 1\n\nline 3\nline 4" );
		
		T_GETLINE("test.f0", 13, "line 1\n" );
		T_GETLINE("test.f0", 13, "\n" );
		T_GETLINE("test.f0", 13, "line 3\n" );
		T_GETLINE("test.f0", 13, "line 4\n" );
		T_GETLINE("test.f0", 13, "line 5\n" );
		T_GETLINE("test.f0", 13, "line 6\n" );
		
		T_GETLINE_END();
		T_GETLINE_END();
		T_GETLINE_END();

		warn("includes\n");
		SrcFile_open( file, "test.f1", dirs );
		SrcFile_push( file );
		SrcFile_open( file, "test.f2", dirs );
		SrcFile_push( file );
		SrcFile_open( file, "test.f3", dirs );

		T_GETLINE("test.x1/test.f3", 1, "F2 x1\n");
		T_GETLINE_END();	
		assert( SrcFile_pop( file ) );
		
		T_GETLINE("test.x1/test.f2", 1, "F1 x1\n");
		T_GETLINE_END();	
		assert( SrcFile_pop( file ) );
		
		T_GETLINE("test.x1/test.f1", 1, "F0 x1\n");
		T_GETLINE_END();	
		assert( ! SrcFile_pop( file ) );

		T_GETLINE_END();
		T_GETLINE_END();
		
		warn("recursive include, no callback\n");
		SrcFile_open( file, "test.f1", dirs );
		SrcFile_push( file );
		SrcFile_open( file, "test.f1", dirs );

		T_GETLINE("test.x1/test.f1", 1, "F0 x1\n");
		T_GETLINE_END();	
		assert( SrcFile_pop( file ) );

		T_GETLINE("test.x1/test.f1", 1, "F0 x1\n");
		T_GETLINE_END();	
		assert( ! SrcFile_pop( file ) );

		warn("set callback\n");
		assert( set_incl_recursion_err_cb( incl_recursion_err_cb ) == NULL );
		assert( set_incl_recursion_err_cb( incl_recursion_err_cb ) == incl_recursion_err_cb );

		warn("recursive include, with callback\n");
		SrcFile_open( file, "test.f1", dirs );
		SrcFile_push( file );
		SrcFile_open( file, "test.f1", dirs );

		assert(0); /* not reached */
		
		utarray_free(dirs);
		return 0;
	
	case 'B':	
		/* test garbage collection */
		assert( file = OBJ_NEW( SrcFile ) );
		SrcFile_open( file, "test.f0", NULL );
		SrcFile_ungetline( file, "line 1\n\nline 3\nline 4" );
		SrcFile_push( file );
		SrcFile_open( file, "test.f1", dirs );
		SrcFile_push( file );
		SrcFile_open( file, "test.f2", dirs );
		SrcFile_push( file );
		SrcFile_open( file, "test.f3", dirs );
		SrcFile_push( file );

		utarray_free(dirs);
		return 0;
	
	default:	
		assert(0);
	}
	
	return 0;
}
END

system($compile) and die "compile failed: $compile\n";
t_capture("./test A", "", <<END, 1);
read first file, no new line callback
(test.f0:1)F0 1
(test.f0:2)
(test.f0:3)F0 3
(test.f0:4)
(test.f0:5)F0 5
(test.f0:6)
(test.f0:7)F0 7
(test.f0:8)
(test.f0:9)F0 9
(test.f0:10)
(test.f0:11)F0 11
(test.f0:12)
(test.f0:13)F0 13
(eof)
(eof)
(eof)
read second file, no new line callback
(test.x1/test.f1:1)F0 x1
(eof)
(eof)
(eof)
read third file, no new line callback
(test.x1/test.f2:1)F1 x1
(eof)
(eof)
(eof)
read fourth file, no new line callback
(test.x1/test.f3:1)F2 x1
(eof)
(eof)
(eof)
set new line callback
read first file with new line callback
File test.f0 line 1 text F0 1

(test.f0:1)F0 1
File test.f0 line 2 text 

(test.f0:2)
File test.f0 line 3 text F0 3

(test.f0:3)F0 3
File test.f0 line 4 text 

(test.f0:4)
File test.f0 line 5 text F0 5

(test.f0:5)F0 5
File test.f0 line 6 text 

(test.f0:6)
File test.f0 line 7 text F0 7

(test.f0:7)F0 7
File test.f0 line 8 text 

(test.f0:8)
File test.f0 line 9 text F0 9

(test.f0:9)F0 9
File test.f0 line 10 text 

(test.f0:10)
File test.f0 line 11 text F0 11

(test.f0:11)F0 11
File test.f0 line 12 text 

(test.f0:12)
File test.f0 line 13 text F0 13

(test.f0:13)F0 13
ungetline
(test.f0:13)line 1
(test.f0:13)
(test.f0:13)line 3
(test.f0:13)line 4
(test.f0:13)line 5
(test.f0:13)line 6
File test.f0 line 14 text 
(eof)
(eof)
(eof)
includes
File test.x1/test.f3 line 1 text F2 x1

(test.x1/test.f3:1)F2 x1
File test.x1/test.f3 line 2 text 
(eof)
File test.x1/test.f2 line 1 text F1 x1

(test.x1/test.f2:1)F1 x1
File test.x1/test.f2 line 2 text 
(eof)
File test.x1/test.f1 line 1 text F0 x1

(test.x1/test.f1:1)F0 x1
File test.x1/test.f1 line 2 text 
(eof)
(eof)
(eof)
recursive include, no callback
File test.x1/test.f1 line 1 text F0 x1

(test.x1/test.f1:1)F0 x1
File test.x1/test.f1 line 2 text 
(eof)
File test.x1/test.f1 line 1 text F0 x1

(test.x1/test.f1:1)F0 x1
File test.x1/test.f1 line 2 text 
(eof)
set callback
recursive include, with callback
Recursive include test.x1/test.f1
END

t_capture("./test B", "", "", 0);

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

sub read_binfile  { scalar(read_file($_[0], { binmode => ':raw' })) }
sub write_binfile { my $file = shift; write_file($file, { binmode => ':raw' }, @_) }
