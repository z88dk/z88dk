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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-file.t,v 1.9 2013-04-04 23:08:18 pauloscustodio Exp $
# $Log: whitebox-file.t,v $
# Revision 1.9  2013-04-04 23:08:18  pauloscustodio
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
#
# Test file

use Modern::Perl;
use Test::More;
use File::Path qw(make_path remove_tree);
require 't/test_utils.pl';

# test memalloc
my $objs = "file.o errors.o strlist.o strhash.o strpool.o memalloc.o class.o ".
		   "die.o strutil.o safestr.o except.o";
ok ! system "make $objs";

my $init = <<'INIT';
#define ERROR return __LINE__
struct module *CURRENTMODULE;
FILE *errfile;
int clinemode;
int clineno;
INIT

t_compile_module($init, <<'END', $objs);
	/* main */
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
	return 0;
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
t_compile_module($init, <<'END', $objs);
#define T1(init, func, result) \
		strcpy( file, init); \
		p = func; \
		if (p != file || strcmp(file, result)) { \
			warn("line %d: %s -> %s, %s\n", __LINE__, init, p, file); ERROR; \
		}
#define T2(func, result) \
		p = func; \
		if (strcmp(p, result)) { \
			warn("line %d: %s != %s\n", __LINE__, p, result); ERROR; \
		}
	
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
	
	return 0;
END

t_run_module([], "", "", 0);


# delete directories and files
remove_tree(qw( x1 x2 x3 ));
unlink_testfiles('f0');
done_testing;
