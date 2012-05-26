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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-errors.t,v 1.1 2012-05-26 18:51:10 pauloscustodio Exp $
# $Log: whitebox-errors.t,v $
# Revision 1.1  2012-05-26 18:51:10  pauloscustodio
# CH_0012 : wrappers on OS calls to raise fatal error
# CH_0013 : new errors interface to decouple calling code from errors.c
#
#
#
# Test errors

use Modern::Perl;
use Test::More;
use File::Slurp;
use Test::Differences; 
require 't/test_utils.pl';

# test errors.c
unlink_testfiles();

my $objs = "errors.o memalloc.o class.o die.o strutil.o strpool.o except.o";
ok ! system "make $objs";

my $init = <<'END';
#define ERROR return __LINE__
#define check_count(e,w) \
	if (get_num_errors()   != e)	ERROR;	\
	if (get_num_warnings() != w)	ERROR
	
FILE*errfile = NULL;
END

t_compile_module($init, <<'END', $objs);
	int test;
	
	init_except();
	
	if (argc != 2) ERROR;
	test = atoi(argv[1]);
	
	switch (test) {
	case 1:
		check_count(0, 0);

		warn("test all error messages\n");
		error(ERR_OK);
		check_count(1, 0);
		
		error(ERR_FOPEN_READ,	"file1");
		check_count(2, 0);
		
		error(ERR_FOPEN_WRITE, "file2");
		check_count(3, 0);

		error(100);
		check_count(4, 0);

		warn("warning\n");
		warning(ERR_OK);
		check_count(4, 1);
		warning(ERR_FOPEN_READ, "file1");
		check_count(4, 2);
		
		warn("reset\n");
		reset_error_count();
		error(ERR_OK);
		warning(ERR_OK);
		check_count(1, 1);

		warn("error at\n");
		error_at(NULL, 0, ERR_OK);
		error_at(NULL, 0, ERR_FOPEN_READ, "file1");
		check_count(3, 1);
		
		error_at("f1.c", 0, ERR_OK);
		error_at("f1.c", 0, ERR_FOPEN_READ, "file1");
		check_count(5, 1);
		
		error_at(NULL, 5, ERR_OK);
		error_at(NULL, 5, ERR_FOPEN_READ, "file1");
		check_count(7, 1);
		
		error_at("f1.c", 5, ERR_OK);
		error_at("f1.c", 5, ERR_FOPEN_READ, "file1");
		check_count(9, 1);
		
		warn("warning at\n");
		warning_at(NULL, 0, ERR_OK);
		warning_at(NULL, 0, ERR_FOPEN_READ, "file1");
		check_count(9, 3);
		
		warning_at("f1.c", 0, ERR_OK);
		warning_at("f1.c", 0, ERR_FOPEN_READ, "file1");
		check_count(9, 5);
		
		warning_at(NULL, 5, ERR_OK);
		warning_at(NULL, 5, ERR_FOPEN_READ, "file1");
		check_count(9, 7);
		
		warning_at("f1.c", 5, ERR_OK);
		warning_at("f1.c", 5, ERR_FOPEN_READ, "file1");
		check_count(9, 9);
		
		warn("create and delete error file\n");
		open_error_file("test1.err");
		close_error_file();
		check_count(9, 9);
		
		warn("open and close error file\n");
		open_error_file("test2.err");
		error_at("f1.c", 5, ERR_FOPEN_READ, "file1");
		warning_at("f1.c", 5, ERR_FOPEN_READ, "file1");
		close_error_file();
		check_count(10, 10);

		reset_error_count();
		check_count(0, 0);
		
		// set_error_...
		set_error_null();
		error(ERR_FOPEN_READ, "file2");
		
		set_error_null();
		set_error_file("f2.c");
		error(ERR_FOPEN_READ, "file2");
		
		set_error_null();
		set_error_module("F2");
		error(ERR_FOPEN_READ, "file2");
		
		set_error_null();
		set_error_line(123);
		error(ERR_FOPEN_READ, "file2");
		
		set_error_file("f2.c");
		error(ERR_FOPEN_READ, "file2");
		
		set_error_module("F2");
		error(ERR_FOPEN_READ, "file2");

		set_error_null();
		
		check_count(6, 0);

		reset_error_count();
		check_count(0, 0);
	
		warn("open error file\n");
		open_error_file("test3.err");
		error_at("f1.c", 5, ERR_FOPEN_READ, "file1");
		warning_at("f1.c", 5, ERR_FOPEN_READ, "file1");
		check_count(1, 1);

		warn("open without close error file\n");
		open_error_file("test4.err");
		error_at("f1.c", 5, ERR_FOPEN_READ, "file1");
		warning_at("f1.c", 5, ERR_FOPEN_READ, "file1");
		check_count(2, 2);
		
		break;
		
	case 2:
		warn("open without close error file, unlink\n");
		open_error_file("test5.err");
		check_count(0, 0);
		break;
	
	case 3:
		try {
			warn("Fatal error\n");
			fatal_error(ERR_FOPEN_READ, "file1");
			warn("not reached\n");
		}
		catch (RuntimeException) {
			warn("caught fatal error\n");
		}
		ERROR;
		
	case 4:
		try {
			warn("Fatal error at\n");
			fatal_error_at("f1.c", 5, ERR_FOPEN_READ, "file1");
			warn("not reached\n");
		}
		catch (RuntimeException) {
			warn("caught fatal error\n");
		}
		ERROR;
		
	default:
		ERROR;
	}
		
	return 0;
END

t_run_module([1], "", <<'END', 0);
test all error messages
Exit: OK
Error: Cannot open file 'file1' for reading
Error: Cannot open file 'file2' for writing
Error: Error 100
warning
Exit: OK
Warning: Cannot open file 'file1' for reading
reset
Exit: OK
Exit: OK
error at
Exit: OK
Error: Cannot open file 'file1' for reading
Exit at file 'f1.c': OK
Error at file 'f1.c': Cannot open file 'file1' for reading
Exit at line 5: OK
Error at line 5: Cannot open file 'file1' for reading
Exit at file 'f1.c' line 5: OK
Error at file 'f1.c' line 5: Cannot open file 'file1' for reading
warning at
Exit: OK
Warning: Cannot open file 'file1' for reading
Exit at file 'f1.c': OK
Warning at file 'f1.c': Cannot open file 'file1' for reading
Exit at line 5: OK
Warning at line 5: Cannot open file 'file1' for reading
Exit at file 'f1.c' line 5: OK
Warning at file 'f1.c' line 5: Cannot open file 'file1' for reading
create and delete error file
open and close error file
Error at file 'f1.c' line 5: Cannot open file 'file1' for reading
Warning at file 'f1.c' line 5: Cannot open file 'file1' for reading
Error: Cannot open file 'file2' for reading
Error at file 'f2.c': Cannot open file 'file2' for reading
Error at module 'F2': Cannot open file 'file2' for reading
Error at line 123: Cannot open file 'file2' for reading
Error at file 'f2.c' line 123: Cannot open file 'file2' for reading
Error at file 'f2.c' module 'F2' line 123: Cannot open file 'file2' for reading
open error file
Error at file 'f1.c' line 5: Cannot open file 'file1' for reading
Warning at file 'f1.c' line 5: Cannot open file 'file1' for reading
open without close error file
Error at file 'f1.c' line 5: Cannot open file 'file1' for reading
Warning at file 'f1.c' line 5: Cannot open file 'file1' for reading
END

ok ! -f 'test1.err';

eq_or_diff_text scalar(read_file('test2.err')), <<'END';
Error at file 'f1.c' line 5: Cannot open file 'file1' for reading
Warning at file 'f1.c' line 5: Cannot open file 'file1' for reading
END

eq_or_diff_text scalar(read_file('test3.err')), <<'END';
Error at file 'f1.c' line 5: Cannot open file 'file1' for reading
Warning at file 'f1.c' line 5: Cannot open file 'file1' for reading
END

eq_or_diff_text scalar(read_file('test4.err')), <<'END';
Error at file 'f1.c' line 5: Cannot open file 'file1' for reading
Warning at file 'f1.c' line 5: Cannot open file 'file1' for reading
END


# bug : StrPool destroyed before ErrFile, unlink used unallocated memory
t_run_module([2], "", <<'END', 0);
open without close error file, unlink
END

ok ! -f 'test5.err';


# fatal error
t_run_module([3], "", <<'END', 1);
Fatal error
Error: Cannot open file 'file1' for reading
caught fatal error
END


t_run_module([4], "", <<'END', 1);
Fatal error at
Error at file 'f1.c' line 5: Cannot open file 'file1' for reading
caught fatal error
END


unlink_testfiles();
done_testing;




