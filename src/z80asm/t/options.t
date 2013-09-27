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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/options.t,v 1.1 2013-09-27 01:14:33 pauloscustodio Exp $
#
# Test options

use strict;
use warnings;
use File::Slurp;
use Test::More;
require 't/test_utils.pl';

my $copyrightmsg = get_copyright()."\n";

#------------------------------------------------------------------------------
# --help, -h
#------------------------------------------------------------------------------
my $help_text = $copyrightmsg . <<'END';

Usage:
  z80asm [options] { @<modulefile> | <filename> }

  [] = optional, {} = may be repeated, | = OR clause.

  To assemble 'fred.asm' use 'fred' or 'fred.asm'

  <modulefile> contains list of file names of all modules to be linked,
  one module per line.

  File types recognized or created by z80asm:
    .asm = source file (default), or alternative -e<ext>
    .obj = object file (default), or alternative -M<ext>
    .lst = list file
    .bin = Z80 binary file
    .sym = symbols file
    .map = map file
    .def = global address definition file
    .err = error file

Help Options:
  -h, --help             Show help options
  -v, --verbose          Be verbose
  -nv, --not-verbose     Be silent

Application Options:

Options: -n defines option to be turned OFF (except -r -R -i -x -D -t -o)
-l listing file, -s symbol table, -m map listing file
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
t_z80asm_capture("", 		$copyrightmsg, 	"", 0);
t_z80asm_capture("-h", 		$help_text, 	"", 0);
t_z80asm_capture("--help", 	$help_text, 	"", 0);

#------------------------------------------------------------------------------
# --verbose, -v
#------------------------------------------------------------------------------
my $verbose_text = <<'END';
Assemble all files.
Create symbol table file.
Link/relocate assembled modules.
Create address map file.

Assembling 'test.asm'...
Pass1...
Pass2...
Size of module is 3 bytes

Total of 3 lines assembled.
linking module(s)...
Pass1...
ORG address for code is 0000
Code size of linked modules is 3 bytes
Pass2...
Creating map...
Code generation completed.
END

unlink_testfiles();
write_file(asm_file(), " nop \n nop \n nop");
t_z80asm_capture("-r0 -b -v ".asm_file(), $verbose_text, "", 0);
ok -f obj_file();
ok -f bin_file();
is read_file(bin_file(), binmode => ':raw'), "\0\0\0";

unlink_testfiles();
write_file(asm_file(), " nop \n nop \n nop");
t_z80asm_capture("-r0 -b --verbose ".asm_file(), $verbose_text, "", 0);
ok -f obj_file();
ok -f bin_file();
is read_file(bin_file(), binmode => ':raw'), "\0\0\0";


#------------------------------------------------------------------------------
# --not-verbose, -nv
#------------------------------------------------------------------------------
unlink_testfiles();
write_file(asm_file(), "nop");

t_z80asm_capture("-r0 -b -nv ".asm_file(), "", "", 0);
ok -f obj_file();
ok -f bin_file();
is read_file(bin_file(), binmode => ':raw'), "\0";

t_z80asm_capture("-r0 -b --not-verbose ".asm_file(), "", "", 0);
ok -f obj_file();
ok -f bin_file();
is read_file(bin_file(), binmode => ':raw'), "\0";



unlink_testfiles();
done_testing();

__END__
# $Log: options.t,v $
# Revision 1.1  2013-09-27 01:14:33  pauloscustodio
# Parse command line options via look-up tables:
# --help, --verbose
#
# Revision 1.3  2013/04/07 22:30:48  pauloscustodio
# Test output with 3 input lines
#
# Revision 1.2  2013/01/20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.1  2011/07/11 15:46:33  pauloscustodio
# Added test scripts for all z80asm options
