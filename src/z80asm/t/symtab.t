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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/symtab.t,v 1.5 2014-01-11 01:29:46 pauloscustodio Exp $
# $Log: symtab.t,v $
# Revision 1.5  2014-01-11 01:29:46  pauloscustodio
# Extend copyright to 2014.
# Move CVS log to bottom of file.
#
# Revision 1.4  2013/09/08 00:43:59  pauloscustodio
# New error module with one error function per error, no need for the error
# constants. Allows compiler to type-check error message arguments.
# Included the errors module in the init() mechanism, no need to call
# error initialization from main(). Moved all error-testing scripts to
# one file errors.t.
#
# Revision 1.3  2013/06/11 23:16:06  pauloscustodio
# Move symbol creation logic fromReadNames() in  modlink.c to symtab.c.
# Add error message for invalid symbol and scope chars in object file.
#
# Revision 1.2  2013/06/01 01:24:23  pauloscustodio
# CH_0022 : Replace avltree by hash table for symbol table
#
# Revision 1.1  2013/05/28 23:39:04  pauloscustodio
# test definition of symbols in all possible combinations
#
#

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

# -DVAR
t_z80asm(
	asm		=> "define VAR",
	err		=> "Error at file 'test.asm' line 1: symbol 'VAR' already defined",
	options	=> "-DVAR"
);

t_z80asm(
	asm		=> "defb VAR",
	bin		=> "\1",
	options	=> "-DVAR"
);

t_z80asm(
	asm		=> "defc VAR=2",
	err		=> "Error at file 'test.asm' line 1: symbol 'VAR' already defined",
	options	=> "-DVAR"
);

t_z80asm(
	asm		=> "VAR: nop",
	err		=> "Error at file 'test.asm' line 1: symbol 'VAR' already defined",
	options	=> "-DVAR"
);

t_z80asm(
	asm		=> "xdef VAR : defb VAR",
	bin		=> "\1",
	options	=> "-DVAR"
);

t_z80asm(
	asm		=> "xref VAR",
	err		=> "Error at file 'test.asm' line 1: symbol 'VAR' already declared local",
	options	=> "-DVAR"
);

t_z80asm(
	asm		=> "xlib VAR : defb VAR",
	bin		=> "\1",
	options	=> "-DVAR"
);

t_z80asm(
	asm		=> "lib VAR",
	err		=> "Error at file 'test.asm' line 1: symbol 'VAR' already declared local",
	options	=> "-DVAR"
);

# define VAR
t_z80asm(
	asm		=> "define VAR : defb VAR",
	bin		=> "\1",
);

t_z80asm(
	asm		=> "undefine VAR",
	err		=> "Error at file 'test.asm' line 1: syntax error",
);

t_z80asm(
	asm		=> "define VAR : undefine VAR : define VAR : defb VAR",
	bin		=> "\1",
);

t_z80asm(
	asm		=> "define VAR : defc VAR=2",
	err		=> "Error at file 'test.asm' line 2: symbol 'VAR' already defined",
);

t_z80asm(
	asm		=> "define VAR : VAR: nop",
	err		=> "Error at file 'test.asm' line 2: symbol 'VAR' already defined",
);

t_z80asm(
	asm		=> "define VAR : xdef VAR : defb VAR",
	bin		=> "\1",
);

t_z80asm(
	asm		=> "define VAR : xref VAR",
	err		=> "Error at file 'test.asm' line 2: symbol 'VAR' already declared local",
);

t_z80asm(
	asm		=> "define VAR : xlib VAR : defb VAR",
	bin		=> "\1",
);

t_z80asm(
	asm		=> "define VAR : lib VAR",
	err		=> "Error at file 'test.asm' line 2: symbol 'VAR' already declared local",
);

# defc VAR
t_z80asm(
	asm		=> "defc VAR=1 : defb VAR",
	bin		=> "\1",
);

t_z80asm(
	asm		=> "defc VAR=1 : define VAR",
	err		=> "Error at file 'test.asm' line 2: symbol 'VAR' already defined",
);

t_z80asm(
	asm		=> "defc VAR=1 : defc VAR=1",
	err		=> "Error at file 'test.asm' line 2: symbol 'VAR' already defined",
);

t_z80asm(
	asm		=> "defc VAR=1 : VAR: nop",
	err		=> "Error at file 'test.asm' line 2: symbol 'VAR' already defined",
);

t_z80asm(
	asm		=> "defc VAR=1 : xdef VAR : defb VAR",
	bin		=> "\1",
);

t_z80asm(
	asm		=> "defc VAR=1 : xref VAR",
	err		=> "Error at file 'test.asm' line 2: symbol 'VAR' already declared local",
);

t_z80asm(
	asm		=> "defc VAR=1 : xlib VAR : defb VAR",
	bin		=> "\1",
);

t_z80asm(
	asm		=> "defc VAR=1 : lib VAR",
	err		=> "Error at file 'test.asm' line 2: symbol 'VAR' already declared local",
);

# VAR:
t_z80asm(
	asm		=> "VAR: : defb VAR",
	bin		=> "\0",
);

t_z80asm(
	asm		=> "defb VAR : VAR:",
	bin		=> "\1",
);

t_z80asm(
	asm		=> "VAR: : define VAR",
	err		=> "Error at file 'test.asm' line 2: symbol 'VAR' already defined",
);

t_z80asm(
	asm		=> "VAR: : defc VAR=1",
	err		=> "Error at file 'test.asm' line 2: symbol 'VAR' already defined",
);

t_z80asm(
	asm		=> "VAR: : VAR: nop",
	err		=> "Error at file 'test.asm' line 2: symbol 'VAR' already defined",
);

t_z80asm(
	asm		=> "VAR: : xdef VAR : defb VAR",
	bin		=> "\0",
);

t_z80asm(
	asm		=> "xdef VAR : VAR: : defb VAR",
	bin		=> "\0",
);

t_z80asm(
	asm		=> "VAR: : xref VAR",
	err		=> "Error at file 'test.asm' line 2: symbol 'VAR' already declared local",
);

t_z80asm(
	asm		=> "VAR: : xlib VAR : defb VAR",
	bin		=> "\0",
);

t_z80asm(
	asm		=> "VAR: : lib VAR",
	err		=> "Error at file 'test.asm' line 2: symbol 'VAR' already declared local",
);

# XDEF
t_z80asm(
	asm		=> "xdef VAR : xdef VAR : VAR: defb VAR",
	bin		=> "\0",
);

t_z80asm(
	asm		=> "xdef VAR : xref VAR",
	err		=> "Error at file 'test.asm' line 2: re-declaration of 'VAR' not allowed",
);

t_z80asm(
	asm		=> "xdef VAR : lib VAR",
	err		=> "Error at file 'test.asm' line 2: re-declaration of 'VAR' not allowed",
);

t_z80asm(
	asm		=> "xdef VAR : xlib VAR",
	err		=> "Error at file 'test.asm' line 2: re-declaration of 'VAR' not allowed",
);

t_z80asm(
	asm		=> "xdef VAR",
	asm1	=> "xdef VAR : defc VAR=3 : defb VAR",
	bin		=> "\3",
);

# XREF
t_z80asm(
	asm		=> "xref VAR : xdef VAR",
	err		=> "Error at file 'test.asm' line 2: re-declaration of 'VAR' not allowed",
);

t_z80asm(
	asm		=> "xref VAR : xref VAR : VAR: defb VAR",	# local hides global
	bin		=> "\0",
);

t_z80asm(
	asm		=> "xref VAR : lib VAR",
	err		=> "Error at file 'test.asm' line 2: re-declaration of 'VAR' not allowed",
);

t_z80asm(
	asm		=> "xref VAR : xlib VAR",
	err		=> "Error at file 'test.asm' line 2: re-declaration of 'VAR' not allowed",
);

# LIB
t_z80asm(
	asm		=> "lib VAR : xdef VAR",
	err		=> "Error at file 'test.asm' line 2: re-declaration of 'VAR' not allowed",
);

t_z80asm(
	asm		=> "lib VAR : xref VAR : VAR: defb VAR",	# local hides global
	bin		=> "\0",
);

t_z80asm(
	asm		=> "lib VAR : lib VAR : VAR: defb VAR",	# local hides global
	bin		=> "\0",
);

t_z80asm(
	asm		=> "lib VAR : xlib VAR",
	err		=> "Error at file 'test.asm' line 2: re-declaration of 'VAR' not allowed",
);

# XLIB
t_z80asm(
	asm		=> "xlib VAR : xdef VAR : VAR: defb VAR",
	bin		=> "\0",
);

t_z80asm(
	asm		=> "xlib VAR : xref VAR",
	err		=> "Error at file 'test.asm' line 2: re-declaration of 'VAR' not allowed",
);

t_z80asm(
	asm		=> "xlib VAR : lib VAR",
	err		=> "Error at file 'test.asm' line 2: re-declaration of 'VAR' not allowed",
);

t_z80asm(
	asm		=> "xlib VAR : xlib VAR",
	err		=> "Error at file 'test.asm' line 2: module name already defined",
);

# Symbol redefined
t_z80asm(
	asm		=> "xdef VAR : defc VAR=3 : defb VAR",
	asm1	=> "xdef VAR : defc VAR=3 : defb VAR",
	linkerr	=> "Error at module 'TEST1': symbol 'VAR' already defined in module 'TEST'",
);


# Symbol declared global in another module
t_z80asm(
	asm		=> "xdef VAR : defc VAR=2",
	asm1	=> "xdef VAR : defc VAR=3",
	linkerr	=> "Error at module 'TEST1': symbol 'VAR' already defined in module 'TEST'",
);


# delete directories and files
unlink_testfiles();
done_testing;
