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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/op-ASMSIZE-ASMTAIL.t,v 1.5 2014-04-13 20:32:10 pauloscustodio Exp $
# $Log: op-ASMSIZE-ASMTAIL.t,v $
# Revision 1.5  2014-04-13 20:32:10  pauloscustodio
# PUBLIC and EXTERN instead of LIB, XREF, XDEF, XLIB
#
# Revision 1.4  2014/01/11 01:29:46  pauloscustodio
# Extend copyright to 2014.
# Move CVS log to bottom of file.
#
# Revision 1.3  2013/01/20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.2  2012/05/22 20:33:34  pauloscustodio
# Added tests
#
# Revision 1.1  2012/04/22 20:32:20  pauloscustodio
# Test new ASMTAIL and ASMSIZE keywords
#

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

my @testfiles = qw( testa.asm testa.lst testa.sym testa.obj testa.map testa.bin
					testb.asm testb.lst testb.sym testb.obj
				);

my $asm = "
	EXTERN ASMSIZE, ASMTAIL
	
	DEFB 0,1,2,3
	DEFW ASMSIZE
	DEFW ASMTAIL
";

#------------------------------------------------------------------------------
t_z80asm_ok(0, $asm, "\x00\x01\x02\x03\x08\x00\x08\x00", "-r0000 -b");
t_z80asm_ok(0, $asm, "\x00\x01\x02\x03\x08\x00\x08\xF0", "-rF000 -b");

#------------------------------------------------------------------------------
unlink_testfiles(@testfiles);

write_file('testa.asm', $asm);
write_file('testb.asm', $asm);
t_z80asm_capture("-b -r0000 testa.asm testb.asm", "", "", 0);
t_binary(read_binfile('testa.bin'), 
		"\x00\x01\x02\x03\x10\x00\x10\x00".
		"\x00\x01\x02\x03\x10\x00\x10\x00");

t_z80asm_capture("-b -rF000 testa.asm testb.asm", "", "", 0);
t_binary(read_binfile('testa.bin'), 
		"\x00\x01\x02\x03\x10\x00\x10\xF0".
		"\x00\x01\x02\x03\x10\x00\x10\xF0");

unlink_testfiles(@testfiles);
done_testing();
