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
# Copyright (C) Paulo Custodio, 2011

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-die.t,v 1.1 2012-05-17 15:04:47 pauloscustodio Exp $
# $Log: whitebox-die.t,v $
# Revision 1.1  2012-05-17 15:04:47  pauloscustodio
# white box test of new modules
#
# Revision 1.1  2012/04/22 20:32:20  pauloscustodio
# Test new ASMTAIL and ASMSIZE keywords
#
# Test die.c

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

# test die
t_compile_module("", <<'END', "die.c");
	die("Hello %s\n", "John");
	return 0;
END
t_run_module([], "", <<'END', 1);
Hello John
END

# test warn
t_compile_module("", <<'END', "die.c");
	warn("Hello %s\n", "John");
	return 0;
END
t_run_module([], "", <<'END', 0);
Hello John
END

unlink_testfiles();
done_testing;
