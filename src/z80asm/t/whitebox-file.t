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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-file.t,v 1.7 2013-02-27 20:47:30 pauloscustodio Exp $
# $Log: whitebox-file.t,v $
# Revision 1.7  2013-02-27 20:47:30  pauloscustodio
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

t_compile_module(<<'INIT', <<'END', $objs);
#define ERROR return __LINE__
struct module *CURRENTMODULE;
FILE *errfile;
int clinemode;
int clineno;
INIT
	/* main */
	SzList *list = OBJ_NEW(SzList);
	
	SzList_push(list, "x1");
	SzList_push(list, "x2");
	SzList_push(list, "x3");
	
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
