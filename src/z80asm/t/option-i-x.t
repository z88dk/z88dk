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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/option-i-x.t,v 1.4 2013-06-04 21:40:21 pauloscustodio Exp $
# $Log: option-i-x.t,v $
# Revision 1.4  2013-06-04 21:40:21  pauloscustodio
# added test cases
#
# Revision 1.3  2013/01/20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.2  2011/08/05 20:23:53  pauloscustodio
# test case where .lib is not passed in -i, -x, e.g "-itest"
#
# Revision 1.1  2011/07/11 15:46:33  pauloscustodio
# Added test scripts for all z80asm options
#
#
# Test option -i, -x

use strict;
use warnings;
use File::Slurp;
use Test::More;
use File::Basename;
require 't/test_utils.pl';

my $lib = lib2_file(); 
my $lib2 = basename($lib, ".lib");

# -x with .lib
unlink_testfiles();
write_file(asm_file(), "xlib main \n main: ret");
t_z80asm_capture("-x".$lib." ".asm_file(), "", "", 0);
ok -f $lib;

# -i with .lib
t_z80asm_ok(0, "lib main \n call main", 
		"\xCD\x03\x00\xC9",
		"-i".$lib);

unlink_testfiles($lib, $lib2);

# -x without .lib
unlink_testfiles();
write_file(asm_file(), "xlib main \n main: ret");
t_z80asm_capture("-x".$lib2." ".asm_file(), "", "", 0);
ok -f $lib;

# -i without .lib
t_z80asm_ok(0, "lib main \n call main", 
		"\xCD\x03\x00\xC9",
		"-i".$lib2);

# link objects and libs
# library modules are loaded in alpha-sequence of labels, starting at 10
unlink_testfiles();
write_file(asm1_file(), "xlib A1 \n A1: defb 1");
write_file(asm2_file(), "xlib A2 \n A2: defb 2");
write_file(asm3_file(), "xlib A3 \n A3: defb 3");
t_z80asm_capture("-x".lib1_file()." ".asm1_file()." ".asm2_file()." ".asm3_file(), "", "", 0);
ok -f lib1_file();

write_file(asm4_file(), "xlib A4 \n A4: defb 4");
write_file(asm5_file(), "xlib A5 \n A5: defb 5");
write_file(asm6_file(), "xlib A6 \n A6: defb 6");
t_z80asm_capture("-x".lib2_file()." ".asm4_file()." ".asm5_file()." ".asm6_file(), "", "", 0);
ok -f lib2_file();

write_file(asm_file(),  "A0: \n ".
						"lib  A1,A2,A3,A4,A5,A6 \n xref A7,A8,A9 \n ".
						"defb A1,A2,A3,A4,A5,A6,        A7,A8,A9 \n ".
						"defb 0 \n");
write_file(asm7_file(), "xdef A7 \n A7: defb 7");
write_file(asm8_file(), "xdef A8 \n A8: defb 8");
write_file(asm9_file(), "xdef A9 \n A9: defb 9");
t_z80asm_capture("-l -b -r0 -i".lib1_file()." -i".lib2_file()." ".
				 asm_file()." ".asm7_file()." ".asm8_file()." ".asm9_file(), "", "", 0);
ok -f bin_file();
my $binary = read_file(bin_file(), binmode => ':raw', err_mode => 'quiet');
t_binary($binary, pack("C*", 
						13, 14, 15, 16, 17, 18, 10, 11, 12,
						0,
						7, 8, 9, 1, 2, 3, 4, 5, 6,
						));

unlink_testfiles($lib, $lib2);
done_testing();
