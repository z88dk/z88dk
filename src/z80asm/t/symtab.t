#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm

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
	asm		=> "PUBLIC VAR : defb VAR",
	bin		=> "\1",
	options	=> "-DVAR"
);

t_z80asm(
	asm		=> "EXTERN VAR",
	err		=> "Error at file 'test.asm' line 1: symbol 'VAR' already declared local",
	options	=> "-DVAR"
);

# define VAR
t_z80asm(
	asm		=> "define VAR : defb VAR",
	bin		=> "\1",
);

t_z80asm(
	asm		=> "undefine VAR : defb VAR",
	err		=> "Error at file 'test.asm' line 2: symbol 'VAR' not defined",
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
	asm		=> "define VAR : PUBLIC VAR : defb VAR",
	bin		=> "\1",
);

t_z80asm(
	asm		=> "define VAR : EXTERN VAR",
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
	asm		=> "defc VAR=1 : PUBLIC VAR : defb VAR",
	bin		=> "\1",
);

t_z80asm(
	asm		=> "defc VAR=1 : EXTERN VAR",
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
	asm		=> "VAR: : PUBLIC VAR : defb VAR",
	bin		=> "\0",
);

t_z80asm(
	asm		=> "PUBLIC VAR : VAR: : defb VAR",
	bin		=> "\0",
);

t_z80asm(
	asm		=> "VAR: : EXTERN VAR",
	err		=> "Error at file 'test.asm' line 2: symbol 'VAR' already declared local",
);

# PUBLIC
t_z80asm(
	asm		=> "PUBLIC VAR : PUBLIC VAR : DEFC VAR = 3 : defb VAR",
	asm1	=> "EXTERN VAR : defb VAR",
	bin		=> "\3\3",
);

t_z80asm(
	asm		=> "PUBLIC VAR : EXTERN VAR : DEFC VAR = 3 : defb VAR",
	asm1	=> "EXTERN VAR : defb VAR",
	bin		=> "\3\3",
);

t_z80asm(
	asm		=> "PUBLIC VAR : GLOBAL VAR : DEFC VAR = 3 : defb VAR",
	asm1	=> "EXTERN VAR : defb VAR",
	bin		=> "\3\3",
);

# EXTERN
t_z80asm(
	asm		=> "EXTERN VAR : PUBLIC VAR : DEFC VAR = 3 : defb VAR",
	asm1	=> "EXTERN VAR : defb VAR",
	bin		=> "\3\3",
);

t_z80asm(
	asm		=> "EXTERN VAR : EXTERN VAR : VAR: defb VAR",	# local hides global
	bin		=> "\0",
);

t_z80asm(
	asm		=> "EXTERN VAR : GLOBAL VAR : DEFC VAR = 3 : defb VAR",
	asm1	=> "EXTERN VAR : defb VAR",
	bin		=> "\3\3",
);

# GLOBAL
t_z80asm(
	asm		=> "GLOBAL VAR : PUBLIC VAR : DEFC VAR = 3 : defb VAR",
	asm1	=> "EXTERN VAR : defb VAR",
	bin		=> "\3\3",
);

t_z80asm(
	asm		=> "GLOBAL VAR : EXTERN VAR : DEFC VAR = 3 : defb VAR",
	asm1	=> "EXTERN VAR : defb VAR",
	bin		=> "\3\3",
);

t_z80asm(
	asm		=> "GLOBAL VAR : GLOBAL VAR : DEFC VAR = 3 : defb VAR",
	asm1	=> "EXTERN VAR : defb VAR",
	bin		=> "\3\3",
);

# Symbol redefined
t_z80asm(
	asm		=> "PUBLIC VAR : defc VAR=3 : defb VAR",
	asm1	=> "PUBLIC VAR : defc VAR=3 : defb VAR",
	linkerr	=> "Error at module 'test1': symbol 'VAR' already defined in module 'test'",
);

# Symbol declared global in another module
t_z80asm(
	asm		=> "PUBLIC VAR : defc VAR=2",
	asm1	=> "PUBLIC VAR : defc VAR=3",
	linkerr	=> "Error at module 'test1': symbol 'VAR' already defined in module 'test'",
);

# Case-sensitive symbols
unlink_testfiles();
write_file(asm_file(), " Defc Loc = 1 \n DEFC LOC = 2 \n ".
					   " Public Loc, LOC \n".
					   " ld a, Loc \n ld a, LOC");
write_file(asm1_file(), "EXTERN Loc, LOC \n ld a, Loc \n ld a, LOC");
t_z80asm_capture("-l -b ".asm_file()." ".asm1_file(), "", "", 0);
t_binary(read_binfile(bin_file()), "\x3E\x01\x3E\x02\x3E\x01\x3E\x02");

# delete directories and files
unlink_testfiles();
done_testing;
