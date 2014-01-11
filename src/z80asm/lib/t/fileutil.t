#!/usr/bin/perl

# Copyright (C) Paulo Custodio, 2011-2014
#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/t/fileutil.t,v 1.4 2014-01-11 01:29:41 pauloscustodio Exp $
#
# Test fileutil.c

use Modern::Perl;
use Test::More;
use File::Slurp;
use File::Path qw(make_path remove_tree);
use Capture::Tiny 'capture';
use Test::Differences; 

my $compile = "cc -Wall -otest test.c fileutil.c strutil.c xmalloc.c class.c list.c strpool.c die.c";

# create directories and files
make_path('test.x1', 'test.x2', 'test.x3');
write_file('test.f0', "");
write_file('test.x1/test.f0', "");
write_file('test.x1/test.f1', "");
write_file('test.x2/test.f1', "");
write_file('test.x2/test.f2', "");
write_file('test.x3/test.f2', "");
write_file('test.x3/test.f3', "");


write_file("test.c", <<'END');
#include "fileutil.h"
#include "strutil.h"
#include "strpool.h"
#include "die.h"

#define ERROR die("Test failed at line %d\n", __LINE__)

#define T_REMOVE_EXT(init, result) \
		path_remove_ext( s, init ); \
		if ( strcmp( s->str, result ) ) ERROR;

#define T_REPLACE_EXT(init, ext, result) \
		path_replace_ext( s, init, ext ); \
		if ( strcmp( s->str, result ) ) ERROR;

#define T_BASENAME(init, result) \
		path_basename( s, init ); \
		if ( strcmp( s->str, result ) ) ERROR;

#define T_SEARCH(file, path, result) \
		path_search( s, file, path ); \
		if ( strcmp( s->str, result ) ) ERROR; \
		p = search_file( file, path ); \
		if ( strcmp( p, result ) ) ERROR;

int main()
{
	DEFINE_FILE_STR( s );
	char *p;
	List *path = NULL;
	
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
	
	/* path_search */
	List_push(&path, strpool_add("test.x1"));
	List_push(&path, strpool_add("test.x2"));
	List_push(&path, strpool_add("test.x3"));
	
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
	
	return 0;
}
END

system($compile) and die "compile failed: $compile\n";
t_capture("test", "", "", 0);

remove_tree(<test.x*>);
unlink <test.*>;
done_testing;

sub t_capture {
	my($cmd, $exp_out, $exp_err, $exp_exit) = @_;
	my $line = "[line ".((caller)[2])."]";
	ok 1, "$line command: $cmd";
	
	my($out, $err, $exit) = capture { system $cmd; };
	eq_or_diff_text $out, $exp_out, "$line out";
	eq_or_diff_text $err, $exp_err, "$line err";
	ok !!$exit == !!$exp_exit, "$line exit";
}


# $Log: fileutil.t,v $
# Revision 1.4  2014-01-11 01:29:41  pauloscustodio
# Extend copyright to 2014.
# Move CVS log to bottom of file.
#
# Revision 1.3  2014/01/02 17:18:17  pauloscustodio
# StrList removed, replaced by List
#
# Revision 1.2  2014/01/01 21:36:38  pauloscustodio
# No dependency on glib
#
# Revision 1.1  2014/01/01 21:23:49  pauloscustodio
# Move generic file utility functions to lib/fileutil.c
#
