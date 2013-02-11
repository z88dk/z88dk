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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/option-h.t,v 1.5 2013-02-11 21:56:11 pauloscustodio Exp $
# $Log: option-h.t,v $
# Revision 1.5  2013-02-11 21:56:11  pauloscustodio
# get_copyright() moved to test_utils.pl
#
# Revision 1.4  2013/01/20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.3  2012/05/17 21:36:06  pauloscustodio
# Remove global ASMERROR, redundant with TOTALERRORS.
# Remove IllegalArgumentException, replace by FatalErrorException.
#
# Revision 1.2  2011/07/11 16:49:31  pauloscustodio
# Get copyright information from hist.c
#
# Revision 1.1  2011/07/11 15:46:33  pauloscustodio
# Added test scripts for all z80asm options
#
#
# Test option -h

use strict;
use warnings;
use File::Slurp;
use Test::More;
require 't/test_utils.pl';

my $copyrightmsg = get_copyright()."\n";

t_z80asm_capture("", $copyrightmsg, "", 0);

t_z80asm_capture("-h", $copyrightmsg . <<'END', "", 0);
z80asm [options] [ @<modulefile> | {<filename>} ]
[] = may be ignored. {} = may be repeated. | = OR clause.
To assemble 'fred.asm' use 'fred' or 'fred.asm'
<modulefile> contains file names of all modules to be linked:
File names are put on separate lines ended with \n. File types recognized or
created by z80asm (defined by the following extension):
.asm = source file (default), or alternative -e<ext>
.obj = object file (default), or alternative -M<ext>
.lst = list file, .bin = Z80 code file
.sym = symbols file, .map = map file, .def = XDEF file, .err = error file
Options: -n defines option to be turned OFF (except -r -R -i -x -D -t -o)
-v verbose, -l listing file, -s symbol table, -m map listing file
-r<ORG> Explicit relocation <ORG> defined in hex (ignore ORG in first module)
-plus Interpret 'Invoke' as RST 28h
-R Generate relocatable code (Automatical relocation before execution)
-D<symbol> define symbol as logically TRUE (used for conditional assembly)
-b assemble files & link to ORG address. -c split code in 16K banks
-d date stamp control, assemble only if source file > object file
-a: -b & -d (assemble only updated source files, then link & relocate)
-o<bin filename> expl. output filename, -g XDEF reloc. addr. from all modules
-i<library> include <library> LIB modules with .obj modules during linking
-x<library> create library from specified modules ( e.g. with @<modules> )
-t<n> tabulator width for .map, .def, .sym files. Column width is 4 times -t
-I<path> additional path to search for includes
-L<path> path to search for libraries
Default options: -nv -nd -nb -nl -s -m -ng -nc -nR -t8
END

unlink_testfiles();
done_testing();
