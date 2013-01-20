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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/option-d.t,v 1.2 2013-01-20 21:24:29 pauloscustodio Exp $
# $Log: option-d.t,v $
# Revision 1.2  2013-01-20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.1  2011/07/11 15:46:33  pauloscustodio
# Added test scripts for all z80asm options
#
#
# Test option -d, -nd

use strict;
use warnings;
use File::Slurp;
use Test::More;
require 't/test_utils.pl';

# first compiles; second skips
unlink_testfiles();
write_file(asm_file(), "nop");

t_z80asm_capture("-d ".asm_file(), "", "", 0);
is substr(read_file(obj_file(), binmode => ':raw'), -1, 1), "\0";

my $date_obj = -M obj_file();

# now skips compile
sleep 2;		# make sure our obj is older
t_z80asm_capture("-d ".asm_file(), "", "", 0);
is substr(read_file(obj_file(), binmode => ':raw'), -1, 1), "\0";

is -M obj_file(), $date_obj;	# same object

# touch source
sleep 2;		# make sure our obj is older
write_file(asm_file(), "nop");
t_z80asm_capture("-d ".asm_file(), "", "", 0);
is substr(read_file(obj_file(), binmode => ':raw'), -1, 1), "\0";

isnt -M obj_file(), $date_obj;	# new object

$date_obj = -M obj_file();

# compile again
sleep 2;		# make sure our obj is older
t_z80asm_capture("-d -nd ".asm_file(), "", "", 0);
is substr(read_file(obj_file(), binmode => ':raw'), -1, 1), "\0";

isnt -M obj_file(), $date_obj;	# new object

unlink_testfiles();
done_testing();
