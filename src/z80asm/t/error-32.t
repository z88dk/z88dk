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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/error-32.t,v 1.1 2011-08-18 23:27:54 pauloscustodio Exp $
# $Log: error-32.t,v $
# Revision 1.1  2011-08-18 23:27:54  pauloscustodio
# BUG_0009 : file read/write not tested for errors
# - In case of disk full file write fails, but assembler does not detect the error
#   and leaves back corruped object/binary files
# - Created new exception FileIOException and ERR_FILE_IO error.
# - Created new functions xfputc, xfgetc, ... to raise the exception on error.
#
#
# Test error 32

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

diag "File IO --> not testeable";

unlink_testfiles();
done_testing();
