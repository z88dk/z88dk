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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-memalloc.t,v 1.15 2013-09-09 00:20:45 pauloscustodio Exp $
#
# Test memory allocation

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

my $objs = "";

# show memory leaks
t_compile_module("", <<'END', $objs);
	char * p1 = g_malloc0(100);
	char * p2 = g_malloc0(100);
END
t_run_module([], <<END, "", 0);
GLib Memory statistics (successful operations):
 blocks of | allocated  | freed      | allocated  | freed      | n_bytes   
  n_bytes  | n_times by | n_times by | n_times by | n_times by | remaining 
           | malloc()   | free()     | realloc()  | realloc()  |           
===========|============|============|============|============|===========
        20 |          1 |          1 |          0 |          0 |         +0
       100 |          2 |          0 |          0 |          0 |       +200
GLib Memory statistics (failing operations):
 --- none ---
Total bytes: allocated=220, zero-initialized=200 (90.91%), freed=20 (9.09%), remaining=200
END

unlink_testfiles();
done_testing;


__END__
# $Log: whitebox-memalloc.t,v $
# Revision 1.15  2013-09-09 00:20:45  pauloscustodio
# Add default set of modules to t_compile_module:
# -DMEMALLOC_DEBUG memalloc.c die.o except.o strpool.o
#
# Revision 1.14  2013/09/08 08:29:21  pauloscustodio
# Replaced xmalloc et al with g_malloc0 et al.
#
# Revision 1.13  2013/09/08 00:43:59  pauloscustodio
# New error module with one error function per error, no need for the error
# constants. Allows compiler to type-check error message arguments.
# Included the errors module in the init() mechanism, no need to call
# error initialization from main(). Moved all error-testing scripts to
# one file errors.t.
#
# Revision 1.12  2013/09/01 17:36:22  pauloscustodio
# Change in test output due to memalloc change.
#
# Revision 1.11  2013/09/01 16:39:29  pauloscustodio
# Removed memalloc allocation checking code, use MSVC _CRTDBG_MAP_ALLOC instead.
# Dump memory usage statistics at the end if MEMALLOC_DEBUG defined.
#
# Revision 1.10  2013/09/01 16:21:55  pauloscustodio
# Removed memalloc allocation checking code, use MSVC _CRTDBG_MAP_ALLOC instead.
# Dump memory usage statistics at the end if MEMALLOC_DEBUG defined.
#
# Revision 1.9  2013/09/01 11:52:55  pauloscustodio
# Setup memalloc on init.c.
# Setup GLib memory allocation functions to use memalloc functions.
#
# Revision 1.8  2013/09/01 00:18:30  pauloscustodio
# - Replaced e4c exception mechanism by a much simpler one based on a few
#   macros. The former did not allow an exit(1) to be called within a
#   try-catch block.
#
# Revision 1.7  2013/02/22 17:16:40  pauloscustodio
# Output memory leaks on exit
#
# Revision 1.6  2013/01/20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.5  2012/06/14 15:01:27  pauloscustodio
# Split safe strings from strutil.c to safestr.c
#
# Revision 1.4  2012/05/26 18:50:26  pauloscustodio
# Use .o instead of .c to build test program, faster compilation.
# Use gcc to compile instead of cc.
#
# Revision 1.3  2012/05/22 20:33:34  pauloscustodio
# Added tests
#
# Revision 1.2  2012/05/20 06:32:50  pauloscustodio
# Added tests
#
# Revision 1.1  2012/05/20 05:48:26  pauloscustodio
# Test garbage collector
#
# Revision 1.1  2012/05/17 15:04:47  pauloscustodio
# white box test of new modules
