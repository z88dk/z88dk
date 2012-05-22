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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-die.t,v 1.4 2012-05-22 20:33:34 pauloscustodio Exp $
# $Log: whitebox-die.t,v $
# Revision 1.4  2012-05-22 20:33:34  pauloscustodio
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

my $compile = "-DEXCEPT_DEBUG die.c strutil.c except.c";

# test die
t_compile_module("", <<'END', $compile);
	init_except();
	warn("1\n");	
	die(NotEnoughMemoryException, "Hello %s\n", "John");
	warn("2\n");	
	
	return 0;
END
t_run_module([], "", <<'END', 1);
except: init
1
Hello John


Uncaught NotEnoughMemoryException: Hello John


    thrown at die (die.c:0)

The value of errno was 0.

Exception hierarchy
________________________________________________________________

    RuntimeException
     |
     +--NotEnoughMemoryException
________________________________________________________________
except: cleanup
END


# test warn
t_compile_module("", <<'END', $compile);
	init_except();
	warn("Hello %s\n", "John");
	return 0;
END
t_run_module([], "", <<'END', 0);
except: init
Hello John
except: cleanup
END

unlink_testfiles();
done_testing;
