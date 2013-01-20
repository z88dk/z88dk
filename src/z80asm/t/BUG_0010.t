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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/BUG_0010.t,v 1.4 2013-01-20 21:24:28 pauloscustodio Exp $
# $Log: BUG_0010.t,v $
# Revision 1.4  2013-01-20 21:24:28  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.3  2012/05/26 18:51:10  pauloscustodio
# CH_0012 : wrappers on OS calls to raise fatal error
# CH_0013 : new errors interface to decouple calling code from errors.c
#
# Revision 1.2  2011/08/19 19:21:25  pauloscustodio
# Additional test cases
#
# Revision 1.1  2011/08/19 15:53:59  pauloscustodio
# BUG_0010 : heap corruption when reaching MAXCODESIZE
# - test for overflow of MAXCODESIZE is done before each instruction at parseline(); if only one byte is available in codearea, and a 2 byte instruction is assembled, the heap is corrupted before the exception is raised.
# - Factored all the codearea-accessing code into a new module, checking for MAXCODESIZE on every write.
#
#
# BUG_0010 : heap corruption when reaching MAXCODESIZE - see hist.c for details

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

my $code;

$code = "defb 0xAA\n" x 65534 . "ld a, 0xAA";
t_z80asm_ok(0, $code, "\xAA" x 65534 . "\x3E\xAA");

# raise HEAP CORRUPTION DETECTED in MSVC
$code = "defb 0xAA\n" x 65535 . "ld a, 0xAA";
t_z80asm_error($code, "Error at file 'test.asm' line 65536: Max. code size of 65536 bytes reached");


$code = "defb 0xAA\n" x 65533 . "ld bc, 0xAAAA";
t_z80asm_ok(0, $code, "\xAA" x 65533 . "\x01\xAA\xAA");

# raise HEAP CORRUPTION DETECTED in MSVC
$code = "defb 0xAA\n" x 65534 . "ld bc, 0xAAAA";
t_z80asm_error($code, "Error at file 'test.asm' line 65535: Max. code size of 65536 bytes reached");


$code = "defb 0xAA\n" x 65532 . "defl 0xAAAAAAAA";
t_z80asm_ok(0, $code, "\xAA" x 65536);

# raise HEAP CORRUPTION DETECTED in MSVC
$code = "defb 0xAA\n" x 65533 . "defl 0xAAAAAAAA";
t_z80asm_error($code, "Error at file 'test.asm' line 65534: Max. code size of 65536 bytes reached");

unlink_testfiles();
done_testing();
