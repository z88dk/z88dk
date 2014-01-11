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
# Copyright (C) Paulo Custodio, 2011-2014

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/BUG_0016.t,v 1.4 2014-01-11 01:29:46 pauloscustodio Exp $
# $Log: BUG_0016.t,v $
# Revision 1.4  2014-01-11 01:29:46  pauloscustodio
# Extend copyright to 2014.
# Move CVS log to bottom of file.
#
# Revision 1.3  2013/01/20 21:24:28  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.2  2013/01/20 20:43:12  pauloscustodio
# Delete *.lst files that are generated during the test in the libsrc/z80_crt0s/z80_emu
# directory
#
# Revision 1.1  2012/05/12 17:03:29  pauloscustodio
# BUG_0016 : RCMX000 emulation routines not assembled when LIST is ON (-l)
#
# Revision 1.1  2011/07/11 15:46:33  pauloscustodio
# Added test scripts for all z80asm options
#
# BUG_0016 : RCMX000 emulation routines not assembled when LIST is ON (-l)

use strict;
use warnings;
use Test::More;
use Iterator::Array::Jagged;
require 't/test_utils.pl';

my $z80emu_lib = 'z80emu.lib';
my $z80emu_srcdir = '../../libsrc/z80_crt0s/z80_emu';
my @z80emu_routines = qw(
		rcmx_cpi
);
my @z80emu_src = map {$z80emu_srcdir.'/'.$_.'.asm'} @z80emu_routines;
my @z80emu_lst = map {$z80emu_srcdir.'/'.$_.'.lst'} @z80emu_routines;
my $cpi_emu = "\x38\x12\xBE\x23\x0B\xF5\xE3\xCB\x85\xCB\xD5\x78".
			  "\xB1\x20\x02\xCB\x95\xE3\xF1\xC9\xBE\x23\x0B\xF5".
			  "\xE3\xCB\xC5\x18\xEC";

# test file
write_file(asm_file(), "cpi\n");

# build z80emu.lib
t_z80asm_capture("-l -x$z80emu_lib @z80emu_src", "", "", 0);

# compile for Z80 with and without -l
for my $list ("", "-l") {
	unlink(bin_file());
	t_z80asm_capture("$list -i$z80emu_lib -b -r0 ".asm_file(), "", "", 0);
	t_binary(read_binfile(bin_file()), "\xED\xA1");
}

# compile for RCMX000 with and without -l
for my $list ("", "-l") {
	unlink(bin_file());
	t_z80asm_capture("$list -RCMX000 -i$z80emu_lib -b -r0 ".asm_file(), "", "", 0);
	t_binary(read_binfile(bin_file()), "\xCD\x03\x00".$cpi_emu);
}

unlink_testfiles($z80emu_lib, @z80emu_lst);
done_testing();
