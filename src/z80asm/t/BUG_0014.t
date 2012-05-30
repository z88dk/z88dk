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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/BUG_0014.t,v 1.2 2012-05-30 22:06:48 pauloscustodio Exp $
# $Log: BUG_0014.t,v $
# Revision 1.2  2012-05-30 22:06:48  pauloscustodio
# BUG_0019 : z80asm closes a closed file handle, crash in Linux
#
# Revision 1.1  2011/09/30 10:30:06  pauloscustodio
# BUG_0014 : -x./zx_clib should create ./zx_clib.lib but actually creates .lib
# (reported on Tue, Sep 27, 2011 at 8:09 PM by dom)
# path_remove_ext() removed everything after last ".", ignoring directory
#  separators. Fixed.
#
#
# -x./zx_clib should create ./zx_clib.lib but actually creates .lib

use strict;
use warnings;
use File::Slurp;
use Test::More;
use Config;
require 't/test_utils.pl';

for my $lib (   'zx_clib',    'zx_clib.lib',
	      './zx_clib',  './zx_clib.lib',
	     '.\\zx_clib', '.\\zx_clib.lib' ) {
	next if $lib =~ /\\/ && $Config{osname} !~ /Win32/i;
	
    unlink_testfiles('zx_clib.lib');
    ok ! -f 'zx_clib.lib', "zx_clib.lib deleted, building $lib";
    write_file(asm_file(), "xlib main \n main: ret");
    t_z80asm_capture("-x".$lib." ".asm_file(), "", "", 0);
    ok -f 'zx_clib.lib', "zx_clib.lib exists, built $lib";
}

unlink_testfiles('zx_clib.lib');
done_testing();
