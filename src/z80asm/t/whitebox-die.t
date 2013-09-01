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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-die.t,v 1.8 2013-09-01 00:18:30 pauloscustodio Exp $
# $Log: whitebox-die.t,v $
# Revision 1.8  2013-09-01 00:18:30  pauloscustodio
# - Replaced e4c exception mechanism by a much simpler one based on a few
#   macros. The former did not allow an exit(1) to be called within a
#   try-catch block.
#
# Revision 1.7  2013/01/20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.6  2012/06/14 15:01:27  pauloscustodio
# Split safe strings from strutil.c to safestr.c
#
# Revision 1.5  2012/05/26 18:50:26  pauloscustodio
# Use .o instead of .c to build test program, faster compilation.
# Use gcc to compile instead of cc.
#
# Revision 1.4  2012/05/22 20:33:34  pauloscustodio
# Added tests
#
# Revision 1.3  2012/05/20 06:32:50  pauloscustodio
# Added tests
#
# Revision 1.2  2012/05/20 05:52:10  pauloscustodio
# Test raising exception in die
#
# Revision 1.1  2012/05/17 15:04:47  pauloscustodio
# white box test of new modules
#
# Test die.c

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

my $objs = "die.o strutil.o safestr.o";
ok ! system "make $objs";

# test die
t_compile_module("", <<'END', $objs);
	warn("1\n");	
	die("Hello %s\n", "John");
	warn("2\n");	
	
	return 0;
END
t_run_module([], "", <<'END', 1);
1
Hello John
END


# test warn
t_compile_module("", <<'END', $objs);
	warn("Hello %s\n", "John");
	return 0;
END
t_run_module([], "", <<'END', 0);
Hello John
END

unlink_testfiles();
done_testing;
