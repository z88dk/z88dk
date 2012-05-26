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
# Copyright (C) Paulo Custodio, 2011-2012

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-file.t,v 1.2 2012-05-26 18:50:26 pauloscustodio Exp $
# $Log: whitebox-file.t,v $
# Revision 1.2  2012-05-26 18:50:26  pauloscustodio
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
my $objs = "file.o errors.o strlist.o strpool.o memalloc.o class.o ".
		   "die.o strutil.o except.o";
ok ! system "make $objs";

t_compile_module(<<'INIT', <<'END', $objs);
#define ERROR return __LINE__
struct module *CURRENTMODULE;
FILE *errfile;
int clinemode;
int clineno;
INIT
	/* main */
	StrList *list = OBJ_NEW(StrList);
	
	StrList_append(list, "x1");
	StrList_append(list, "x2");
	StrList_append(list, "x3");
	
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

t_run_module(['f0'], "f0\n", "", 0);
t_run_module(['f1'], "x1/f1\n", "", 0);
t_run_module(['f2'], "x2/f2\n", "", 0);
t_run_module(['f3'], "x3/f3\n", "", 0);
t_run_module(['f4'], "f4\n", "", 0);

# delete directories and files
remove_tree(qw( x1 x2 x3 ));
unlink_testfiles('f0');
done_testing;
