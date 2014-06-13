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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/symtab.t,v 1.20 2014-06-13 19:16:48 pauloscustodio Exp $
#

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

#------------------------------------------------------------------------------
# Black box tests
#------------------------------------------------------------------------------

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
	asm		=> "PUBLIC VAR : PUBLIC VAR : VAR: defb VAR",
	bin		=> "\0",
);

t_z80asm(
	asm		=> "PUBLIC VAR : EXTERN VAR",
	err		=> "Error at file 'test.asm' line 2: re-declaration of 'VAR' not allowed",
);

t_z80asm(
	asm		=> "EXTERN VAR : defb VAR",
	asm1	=> "PUBLIC VAR : defc VAR=3",
	bin		=> "\3",
);

# EXTERN
t_z80asm(
	asm		=> "EXTERN VAR : PUBLIC VAR",
	err		=> "Error at file 'test.asm' line 2: re-declaration of 'VAR' not allowed",
);

t_z80asm(
	asm		=> "EXTERN VAR : EXTERN VAR : VAR: defb VAR",	# local hides global
	bin		=> "\0",
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

# CH_0024: Case-preserving, case-insensitive symbols
unlink_testfiles();
write_file(asm_file(), "Defc Loc = 1 \n ld a, LOC \n PUBLIC Var \n defc VAR = 2");
write_file(asm1_file(), "EXTERN var \n ld a, VAR");
t_z80asm_capture("-l -b -r0 ".asm_file()." ".asm1_file(), "", <<'ERR', 0);
Warning at file 'test.asm' line 2: symbol 'Loc' used as 'LOC'
Warning at file 'test.asm' line 4: symbol 'Var' used as 'VAR'
Warning at file 'test1.asm' line 2: symbol 'var' used as 'VAR'
Warning at file 'test1.asm' line 2: symbol 'var' used as 'VAR'
Warning at file 'test1.asm' line 2: symbol 'Var' used as 'VAR'
ERR
t_binary(read_binfile(bin_file()), "\x3E\x01\x3E\x02");

# CH_0025: PUBLIC and EXTERN instead of LIB, XREF, XDEF, XLIB
write_file(asm_file(), "
	PUBLIC 	var1
	DEFC 	var1 = 1
	
	XDEF	var2
	DEFC 	var2 = 2
	
	XLIB	var3
	DEFC 	var3 = 3
");
write_file(asm1_file(), "
	EXTERN 	var1
	DEFB 	var1
	
	XREF	var2
	DEFB 	var2
	
	LIB		var3
	DEFB 	var3
");
t_z80asm_capture("-l -b -r0 ".asm_file()." ".asm1_file(), "", "", 0);
#Warning at file 'test.asm' line 5: 'XDEF' is deprecated, use 'PUBLIC' instead
#Warning at file 'test.asm' line 8: 'XLIB' is deprecated, use 'PUBLIC' instead
#Warning at file 'test1.asm' line 5: 'XREF' is deprecated, use 'EXTERN' instead
#Warning at file 'test1.asm' line 8: 'LIB' is deprecated, use 'EXTERN' instead
#ERR
t_binary(read_binfile(bin_file()), "\x01\x02\x03");

#------------------------------------------------------------------------------
# White box tests
#------------------------------------------------------------------------------

my $objs = "sym.o symtab.o symref.o codearea.o errors.o options.o model.o ".
		   "hist.o scan.o module.o expr.o ".
		   "lib/array.o lib/class.o lib/strhash.o lib/strutil.o lib/list.o ".
		   "lib/fileutil.o lib/srcfile.o";

my $init = <<'END';
void list_start_line( size_t address, char *source_file, int source_line_nr, char *line ) 
{	
	warn("%04X %-16s %5d %s", address, source_file, source_line_nr, line);
}
void list_append( long value, int num_bytes ) {}

int page_nr 			= 1;
int list_get_page_nr() { return page_nr; }


char *GetLibfile( char *filename ) {return NULL;}

extern SymbolHash *get_static_tab(void);

extern Symbol *_define_sym( char *name, long value, Byte type, Module *owner, SymbolHash **psymtab );

void dump_SymbolRefList ( SymbolRefList *references )
{
	SymbolRefListElem *iter;
	for ( iter = SymbolRefList_first(references); iter; iter = SymbolRefList_next(iter) )
	{
		warn("%d ", iter->obj->page_nr );
	}
}

void dump_Symbols () {}

void dump_Symbol ( Symbol *sym )
{
	warn("Symbol %s (%s) = %ld, type = 0x%02X [", 
		 sym->name, Symbol_fullname(sym), sym->value, sym->sym_type );
	if (sym->sym_type & SYM_DEFINED)	warn("DEFINED ");
	if (sym->sym_type & SYM_TOUCHED)	warn("TOUCHED ");
	if (sym->sym_type & SYM_DEFINE)		warn("DEF ");
	if (sym->sym_type & SYM_ADDR)		warn("ADDR ");
	if (sym->sym_type & SYM_LOCAL)		warn("LOCAL ");
	if (sym->sym_type & SYM_PUBLIC)		warn("GLOBAL ");
	if (sym->sym_type & SYM_EXTERN)		warn("EXTERN ");
	warn("], ref = [");
	dump_SymbolRefList(sym->references);
	warn("], owner = %s\n", 
			sym->owner == NULL ? 
				"NULL" : 
				sym->owner == CURRENTMODULE ? 
					"CURRENTMODULE" : "?");
}

void dump_SymbolHash ( SymbolHash *symtab, char *name )
{
	SymbolHashElem *iter;
	Symbol         *sym;

	warn("Symtab \"%s\": %s\n", name, SymbolHash_empty(symtab) ? "EMPTY" : "" );
	for ( iter = SymbolHash_first( symtab ); iter; iter = SymbolHash_next( iter ) )
	{
		sym = (Symbol *)iter->value;
		if ( sym != SymbolHash_get( symtab, sym->name ) )
			warn("ERROR: symbol %s not found in hash\n", sym->name);

		warn("  ");
		dump_Symbol( sym );
	}	
}

void dump_symtab ( void ) 
{
	dump_SymbolHash(global_symtab, "global tab");
	dump_SymbolHash(static_symtab, "static tab");
	dump_SymbolHash(CURRENTMODULE->local_symtab, "local tab");
}	

/* reuse string - test saving of keys by hash */
char *S(char *str)
{
	static char buffer[MAXLINE];
	
	strcpy(buffer, str);		/* overwrite last string */
	return buffer;
}

END

t_compile_module($init, <<'END', $objs);

	Symbol *sym;
	SymbolHash *symtab, *symtab2;
	
	opts.symtable = TRUE;
	opts.list     = TRUE;
	
	TITLE("Create current module");	
	set_cur_module( new_module() );

	TITLE("Create symbol");	
	sym = Symbol_create(S("Var1"), 123, 0, NULL);
	dump_Symbol(sym);
	OBJ_DELETE(sym);

	sym = Symbol_create(S("Var1"), 123, 0, CURRENTMODULE);
	dump_Symbol(sym);
	CURRENTMODULE->modname = "MODULE";
	dump_Symbol(sym);
	
	TITLE("Delete symbol");	
	OBJ_DELETE(sym);
	
	TITLE("Global symtab");	
	dump_SymbolHash(global_symtab, "global");
	dump_SymbolHash(static_symtab, "static");
	
	TITLE("Concat symbol tables");	
	ASSERT( symtab  = OBJ_NEW(SymbolHash) );
	_define_sym(S("Var1"),  1, 0, NULL, &symtab); page_nr++;
	_define_sym(S("Var2"),  2, 0, NULL, &symtab); page_nr++; 
	_define_sym(S("Var3"), -3, 0, NULL, &symtab); page_nr++;
	dump_SymbolHash(symtab, "tab1");
	
	/* check case insensitive - CH_0024 */
	ASSERT( find_symbol(S("Var1"), symtab)->value ==  1 );
	ASSERT( find_symbol(S("VAR1"), symtab)->value ==  1 );
	ASSERT( find_symbol(S("var1"), symtab)->value ==  1 );

	ASSERT( find_symbol(S("Var2"), symtab)->value ==  2 );
	ASSERT( find_symbol(S("VAR2"), symtab)->value ==  2 );
	ASSERT( find_symbol(S("var2"), symtab)->value ==  2 );

	ASSERT( find_symbol(S("Var3"), symtab)->value == -3 );
	ASSERT( find_symbol(S("VAR3"), symtab)->value == -3 );
	ASSERT( find_symbol(S("var3"), symtab)->value == -3 );
	
	dump_SymbolHash(symtab, "tab1");
	
	ASSERT( symtab2 = OBJ_NEW(SymbolHash) );
	_define_sym(S("Var3"), 3, 0, NULL, &symtab2); page_nr++;
	_define_sym(S("Var4"), 4, 0, NULL, &symtab2); page_nr++;
	_define_sym(S("Var5"), 5, 0, NULL, &symtab2); page_nr++;
	dump_SymbolHash(symtab2, "tab2");
	
	SymbolHash_cat( &symtab, symtab2 );
	dump_SymbolHash(symtab, "merged_tab");
	
	OBJ_DELETE( symtab );
	OBJ_DELETE( symtab2 );
	
	TITLE("Sort");	
	ASSERT( symtab  = OBJ_NEW(SymbolHash) );
	_define_sym(S("One"), 	1, 0, NULL, &symtab); page_nr++;
	_define_sym(S("Two"),	2, 0, NULL, &symtab); page_nr++; 
	_define_sym(S("Three"),	3, 0, NULL, &symtab); page_nr++;
	_define_sym(S("Four"),	4, 0, NULL, &symtab); page_nr++;

	dump_SymbolHash(symtab, "tab");
	
	SymbolHash_sort(symtab, SymbolHash_by_name);
	dump_SymbolHash(symtab, "tab by name");

	SymbolHash_sort(symtab, SymbolHash_by_value);
	dump_SymbolHash(symtab, "tab by value");

	OBJ_DELETE( symtab );

	TITLE("Use local symbol before definition");
	page_nr = 1;
	_define_sym(S("WIN32"), 1, 0, NULL, &static_symtab); page_nr++;
	SymbolHash_cat( & CURRENTMODULE->local_symtab, static_symtab ); page_nr++;
	_define_sym(S("PC"), 0, 0, NULL, &global_symtab); page_nr++;
	find_symbol( S("PC"), global_symtab )->value += 3; page_nr++;
	find_symbol( S("PC"), global_symtab )->value += 3; page_nr++;
	sym = get_used_symbol(S("NN")); page_nr++;
	ASSERT( sym != NULL );
	ASSERT( ! (sym->sym_type & SYM_DEFINED) );
	find_symbol( S("PC"), global_symtab )->value += 3; page_nr++;
	sym = get_used_symbol(S("NN")); page_nr++;
	ASSERT( sym != NULL );
	ASSERT( ! (sym->sym_type & SYM_DEFINED) );
	find_symbol( S("PC"), global_symtab )->value += 3; page_nr++;
	define_symbol(S("NN"), find_symbol( "PC", global_symtab )->value, SYM_ADDR | SYM_TOUCHED ); 
	sym = get_used_symbol(S("NN")); page_nr++;
	ASSERT( sym != NULL );
	dump_Symbol(sym);
	ASSERT( sym->sym_type & SYM_DEFINED );
	
	dump_symtab();
	
	TITLE("Delete Local");	
	remove_all_local_syms();
	dump_symtab();
	
	TITLE("Delete Static");	
	remove_all_static_syms();
	dump_symtab();
	
	TITLE("Delete Global");	
	remove_all_global_syms();
	dump_symtab();
	
	TITLE("End");	
END

# write test object file
t_run_module([], '', <<'ERR', 0);

---- TEST: Create current module ----


---- TEST: Create symbol ----

Symbol Var1 (Var1) = 123, type = 0x00 [], ref = [1 ], owner = NULL
Symbol Var1 (Var1) = 123, type = 0x00 [], ref = [1 ], owner = CURRENTMODULE
Symbol Var1 (Var1@MODULE) = 123, type = 0x00 [], ref = [1 ], owner = CURRENTMODULE

---- TEST: Delete symbol ----


---- TEST: Global symtab ----

Symtab "global": EMPTY
Symtab "static": EMPTY

---- TEST: Concat symbol tables ----

Symtab "tab1": 
  Symbol Var1 (Var1) = 1, type = 0x01 [DEFINED ], ref = [1 ], owner = NULL
  Symbol Var2 (Var2) = 2, type = 0x01 [DEFINED ], ref = [2 ], owner = NULL
  Symbol Var3 (Var3) = -3, type = 0x01 [DEFINED ], ref = [3 ], owner = NULL
Warning: symbol 'Var1' used as 'VAR1'
Warning: symbol 'Var1' used as 'var1'
Warning: symbol 'Var2' used as 'VAR2'
Warning: symbol 'Var2' used as 'var2'
Warning: symbol 'Var3' used as 'VAR3'
Warning: symbol 'Var3' used as 'var3'
Symtab "tab1": 
  Symbol Var1 (Var1) = 1, type = 0x03 [DEFINED TOUCHED ], ref = [1 ], owner = NULL
  Symbol Var2 (Var2) = 2, type = 0x03 [DEFINED TOUCHED ], ref = [2 ], owner = NULL
  Symbol Var3 (Var3) = -3, type = 0x03 [DEFINED TOUCHED ], ref = [3 ], owner = NULL
Symtab "tab2": 
  Symbol Var3 (Var3) = 3, type = 0x01 [DEFINED ], ref = [4 ], owner = NULL
  Symbol Var4 (Var4) = 4, type = 0x01 [DEFINED ], ref = [5 ], owner = NULL
  Symbol Var5 (Var5) = 5, type = 0x01 [DEFINED ], ref = [6 ], owner = NULL
Symtab "merged_tab": 
  Symbol Var1 (Var1) = 1, type = 0x03 [DEFINED TOUCHED ], ref = [1 ], owner = NULL
  Symbol Var2 (Var2) = 2, type = 0x03 [DEFINED TOUCHED ], ref = [2 ], owner = NULL
  Symbol Var3 (Var3) = 3, type = 0x01 [DEFINED ], ref = [4 ], owner = NULL
  Symbol Var4 (Var4) = 4, type = 0x01 [DEFINED ], ref = [5 ], owner = NULL
  Symbol Var5 (Var5) = 5, type = 0x01 [DEFINED ], ref = [6 ], owner = NULL

---- TEST: Sort ----

Symtab "tab": 
  Symbol One (One) = 1, type = 0x01 [DEFINED ], ref = [7 ], owner = NULL
  Symbol Two (Two) = 2, type = 0x01 [DEFINED ], ref = [8 ], owner = NULL
  Symbol Three (Three) = 3, type = 0x01 [DEFINED ], ref = [9 ], owner = NULL
  Symbol Four (Four) = 4, type = 0x01 [DEFINED ], ref = [10 ], owner = NULL
Symtab "tab by name": 
  Symbol Four (Four) = 4, type = 0x01 [DEFINED ], ref = [10 ], owner = NULL
  Symbol One (One) = 1, type = 0x01 [DEFINED ], ref = [7 ], owner = NULL
  Symbol Three (Three) = 3, type = 0x01 [DEFINED ], ref = [9 ], owner = NULL
  Symbol Two (Two) = 2, type = 0x01 [DEFINED ], ref = [8 ], owner = NULL
Symtab "tab by value": 
  Symbol One (One) = 1, type = 0x01 [DEFINED ], ref = [7 ], owner = NULL
  Symbol Two (Two) = 2, type = 0x01 [DEFINED ], ref = [8 ], owner = NULL
  Symbol Three (Three) = 3, type = 0x01 [DEFINED ], ref = [9 ], owner = NULL
  Symbol Four (Four) = 4, type = 0x01 [DEFINED ], ref = [10 ], owner = NULL

---- TEST: Use local symbol before definition ----

Symbol NN (NN@MODULE) = 12, type = 0x1B [DEFINED TOUCHED ADDR LOCAL ], ref = [10 6 8 ], owner = CURRENTMODULE
Symtab "global tab": 
  Symbol PC (PC) = 12, type = 0x03 [DEFINED TOUCHED ], ref = [3 ], owner = NULL
Symtab "static tab": 
  Symbol WIN32 (WIN32) = 1, type = 0x01 [DEFINED ], ref = [1 ], owner = NULL
Symtab "local tab": 
  Symbol WIN32 (WIN32) = 1, type = 0x01 [DEFINED ], ref = [1 ], owner = NULL
  Symbol NN (NN@MODULE) = 12, type = 0x1B [DEFINED TOUCHED ADDR LOCAL ], ref = [10 6 8 ], owner = CURRENTMODULE

---- TEST: Delete Local ----

Symtab "global tab": 
  Symbol PC (PC) = 12, type = 0x03 [DEFINED TOUCHED ], ref = [3 ], owner = NULL
Symtab "static tab": 
  Symbol WIN32 (WIN32) = 1, type = 0x01 [DEFINED ], ref = [1 ], owner = NULL
Symtab "local tab": EMPTY

---- TEST: Delete Static ----

Symtab "global tab": 
  Symbol PC (PC) = 12, type = 0x03 [DEFINED TOUCHED ], ref = [3 ], owner = NULL
Symtab "static tab": EMPTY
Symtab "local tab": EMPTY

---- TEST: Delete Global ----

Symtab "global tab": EMPTY
Symtab "static tab": EMPTY
Symtab "local tab": EMPTY

---- TEST: End ----

ERR


# delete directories and files
unlink_testfiles();
done_testing;

# $Log: symtab.t,v $
# Revision 1.20  2014-06-13 19:16:48  pauloscustodio
# Remove CreateLibfile() - no longer used
#
# Revision 1.19  2014/06/13 16:00:46  pauloscustodio
# Extended codearea.c to support different sections of code.
#
# Revision 1.18  2014/06/09 13:30:28  pauloscustodio
# Rename current module abrev
#
# Revision 1.17  2014/06/01 22:16:50  pauloscustodio
# Write expressions to object file only in pass 2, to remove dupplicate code
# and allow simplification of object file writing code. All expression
# error messages are now output only during pass 2.
#
# Revision 1.16  2014/05/29 00:19:37  pauloscustodio
# CH_0025: Link-time expression evaluation errors show source filename and line number
# Object file format changed to version 04, to include the source file
# location of expressions in order to give meaningful link-time error messages.
#
# Revision 1.15  2014/05/25 01:02:30  pauloscustodio
# Byte, Int, UInt added
#
# Revision 1.14  2014/05/17 14:27:13  pauloscustodio
# Use C99 integer types int8_t, Byte, int16_t, uint16_t, int32_t, uint32_t
#
# Revision 1.13  2014/05/06 22:17:38  pauloscustodio
# Made types Byte, UINT and ULONG all-caps to avoid conflicts with /usr/include/i386-linux-gnu/sys/types.h
#
# Revision 1.12  2014/05/02 21:34:58  pauloscustodio
# byte_t, uint_t and ulong_t renamed to Byte, UINT and ULONG
#
# Revision 1.11  2014/05/02 20:24:39  pauloscustodio
# New class Module to replace struct module and struct modules
#
# Revision 1.10  2014/04/22 23:32:42  pauloscustodio
# Release 2.2.0 with major fixes:
#
# - Object file format changed to version 03, to include address of start
# of the opcode of each expression stored in the object file, to allow
# ASMPC to refer to the start of the opcode instead of the patch pointer.
# This solves long standing BUG_0011 and BUG_0048.
#
# - ASMPC no longer stored in the symbol table and evaluated as a separate
# token, to allow expressions including ASMPC to be relocated. This solves
# long standing and never detected BUG_0047.
#
# - Handling ASMPC during assembly simplified - no need to call inc_PC() on
# every assembled instruction, no need to store list of JRPC addresses as
# ASMPC is now stored in the expression.
#
# BUG_0047: Expressions including ASMPC not relocated - impacts call po|pe|p|m emulation in RCMX000
# ASMPC is computed on zero-base address of the code section and expressions
# including ASMPC are not relocated at link time.
# "call po, xx" is emulated in --RCMX000 as "jp pe, ASMPC+3; call xx".
# The expression ASMPC+3 is not marked as relocateable, and the resulting
# code only works when linked at address 0.
#
# BUG_0048: ASMPC used in JP/CALL argument does not refer to start of statement
# In "JP ASMPC", ASMPC is coded as instruction-address + 1 instead
# of instruction-address.
#
# BUG_0011 : ASMPC should refer to start of statememnt, not current element in DEFB/DEFW
# Bug only happens with forward references to relative addresses in expressions.
# See example from zx48.asm ROM image in t/BUG_0011.t test file.
# Need to change object file format to correct - need patchptr and address of instruction start.
#
# Revision 1.9  2014/04/18 17:46:18  pauloscustodio
# - Change struct expr to Expr class, use CLASS_LIST instead of linked list
#   manipulating.
# - Factor parsing and evaluating contants.
# - Factor symbol-not-defined error during expression evaluation.
# - Store module name in strpool instead of xstrdup/xfree.
#
# Revision 1.8  2014/04/13 11:54:01  pauloscustodio
# CH_0025: PUBLIC and EXTERN instead of LIB, XREF, XDEF, XLIB
# Use new keywords PUBLIC and EXTERN, make the old ones synonyms.
# Remove 'X' scope for symbols in object files used before for XLIB -
# all PUBLIC symbols have scope 'G'.
# Remove SDCC hack on object files trating XLIB and XDEF the same.
# Created a warning to say XDEF et.al. are deprecated, but for the
# momment keep it commented.
#
# Revision 1.7  2014/04/06 11:07:11  pauloscustodio
# Merged symtab.t and whitebox-symtab.t
#
# Revision 1.6  2014/04/05 23:36:11  pauloscustodio
# CH_0024: Case-preserving, case-insensitive symbols
# Symbols no longer converted to upper-case, but still case-insensitive
# searched. Warning when a symbol is used with different case than
# defined. Intermidiate stage before making z80asm case-sensitive, to
# be more C-code friendly.
#
# Revision 1.37  2014/03/03 14:09:20  pauloscustodio (whitebox-symtab.t)
# Renamed symbol type attribute
#
# Revision 1.36  2014/03/03 13:27:07  pauloscustodio (whitebox-symtab.t)
# Rename symbol type constants
#
# Revision 1.35  2014/02/08 18:30:49  pauloscustodio (whitebox-symtab.t)
# lib/srcfile.c to read source files and handle recursive includes,
# used to read @lists, removed opts.files;
# model.c to hold global data model
#
# Revision 1.34  2014/01/20 23:29:19  pauloscustodio (whitebox-symtab.t)
# Moved file.c to lib/fileutil.c
#
# Revision 1.5  2014/01/11 01:29:46  pauloscustodio
# Extend copyright to 2014.
# Move CVS log to bottom of file.
#
# Revision 1.32  2014/01/11 00:10:40  pauloscustodio (whitebox-symtab.t)
# Astyle - format C code
# Add -Wall option to CFLAGS, remove all warnings
#
# Revision 1.31  2014/01/05 23:20:39  pauloscustodio (whitebox-symtab.t)
# List, StrHash classlist and classhash receive the address of the container
# object in all functions that add items to the container, and create the
# container on first use. This allows a container to be staticaly
# initialized with NULL and instantiated on first push/unshift/set.
# Add count attribute to StrHash, classhash to count elements in container.
# Add free_data attribute in StrHash to register a free fucntion to delete
# the data container when the hash is removed or a key is overwritten.
#
# Revision 1.30  2014/01/02 17:18:17  pauloscustodio (whitebox-symtab.t)
# StrList removed, replaced by List
#
# Revision 1.29  2014/01/01 21:23:48  pauloscustodio (whitebox-symtab.t)
# Move generic file utility functions to lib/fileutil.c
#
# Revision 1.28  2013/12/30 02:05:34  pauloscustodio (whitebox-symtab.t)
# Merge dynstr.c and safestr.c into lib/strutil.c; the new Str type
# handles both dynamically allocated strings and fixed-size strings.
# Replaced g_strchomp by chomp by; g_ascii_tolower by tolower;
# g_ascii_toupper by toupper; g_ascii_strcasecmp by stricompare.
#
# Revision 1.27  2013/12/26 23:42:28  pauloscustodio (whitebox-symtab.t)
# Replace StringList from strutil by StrList in new strlis.c, to keep lists of strings (e.g. directory search paths)
#
# Revision 1.26  2013/12/25 17:02:10  pauloscustodio (whitebox-symtab.t)
# Move strhash.c to the z80asm/lib directory
#
# Revision 1.25  2013/12/25 14:39:50  pauloscustodio (whitebox-symtab.t)
# Move strutil.c to the z80asm/lib directory
#
# Revision 1.24  2013/12/18 23:05:52  pauloscustodio (whitebox-symtab.t)
# Move class.c to the z80asm/lib directory
#
# Revision 1.23  2013/12/15 13:18:35  pauloscustodio (whitebox-symtab.t)
# Move memory allocation routines to lib/xmalloc, instead of glib,
# introduce memory leak report on exit and memory fence check.
#
# Revision 1.22  2013/11/11 23:47:04  pauloscustodio (whitebox-symtab.t)
# Move source code generation tools to dev/Makefile, only called on request,
# and keep the generated files in z80asm directory, so that build does
# not require tools used for the code generation (ragel, perl).
# Remove code generation for structs - use CLASS macro instead.
#
# Revision 1.21  2013/10/15 23:24:33  pauloscustodio (whitebox-symtab.t)
# Move reading by lines or tokens and file reading interface to scan.rl
# to decouple file.c from scan.c.
# Add singleton interface to scan to be used by parser.
#
# Revision 1.20  2013/10/08 21:53:07  pauloscustodio (whitebox-symtab.t)
# Replace Flex-based lexer by a Ragel-based one.
# Add interface to file.c to read files by tokens, calling the lexer.
#
# Revision 1.19  2013/10/05 10:54:36  pauloscustodio (whitebox-symtab.t)
# Parse command line options via look-up tables:
# -I, --inc-path
# -L, --lib-path
#
# Revision 1.18  2013/10/01 23:23:53  pauloscustodio (whitebox-symtab.t)
# Parse command line options via look-up tables:
# -l, --list
# -nl, --no-list
#
# Revision 1.17  2013/10/01 22:50:27  pauloscustodio (whitebox-symtab.t)
# Parse command line options via look-up tables:
# -s, --symtable
# -ns, --no-symtable
#
# Revision 1.16  2013/10/01 22:09:33  pauloscustodio (whitebox-symtab.t)
# Parse command line options via look-up tables:
# -sdcc
#
# Revision 1.15  2013/09/24 00:05:36  pauloscustodio (whitebox-symtab.t)
#
# Revision 1.14  2013/09/23 23:14:10  pauloscustodio (whitebox-symtab.t)
# Renamed SzList to StringList, simplified interface by assuming that
# list lives in memory util program ends; it is used for directory searches
# only. Moved interface to strutil.c, removed strlist.c.
#
# Revision 1.13  2013/09/22 21:04:22  pauloscustodio (whitebox-symtab.t)
# New File and FileStack objects
#
# Revision 1.12  2013/09/09 00:20:45  pauloscustodio (whitebox-symtab.t)
# Add default set of modules to t_compile_module:
# -DMEMALLOC_DEBUG xmalloc.c die.o except.o strpool.o
#
# Revision 1.4  2013/09/08 00:43:59  pauloscustodio
# New error module with one error function per error, no need for the error
# constants. Allows compiler to type-check error message arguments.
# Included the errors module in the init() mechanism, no need to call
# error initialization from main(). Moved all error-testing scripts to
# one file errors.t.
#
# Revision 1.10  2013/09/01 17:04:44  pauloscustodio (whitebox-symtab.t)
# Change in test output due to xmalloc change.
#
# Revision 1.9  2013/09/01 11:52:56  pauloscustodio (whitebox-symtab.t)
# Setup xmalloc on init.c.
# Setup GLib memory allocation functions to use xmalloc functions.
#
# Revision 1.8  2013/06/16 22:25:39  pauloscustodio (whitebox-symtab.t)
# New remove_all_{local,static,global}_syms( void ) functions
# to encapsulate calls to get_global_tab().
#
# Revision 1.7  2013/06/16 17:51:57  pauloscustodio (whitebox-symtab.t)
# get_all_syms() to get list of symbols matching a type mask, use in mapfile to decouple
# it from get_global_tab()
#
# Revision 1.6  2013/06/16 16:49:20  pauloscustodio (whitebox-symtab.t)
# Symbol_fullname() to return full symbol name NAME@MODULE
#
# Revision 1.3  2013/06/11 23:16:06  pauloscustodio
# Move symbol creation logic fromReadNames() in  modlink.c to symtab.c.
# Add error message for invalid symbol and scope chars in object file.
#
# Revision 1.4  2013/06/10 23:11:33  pauloscustodio (whitebox-symtab.t)
# CH_0023 : Remove notdecl_tab
#
#
# Revision 1.3  2013/06/08 23:37:32  pauloscustodio (whitebox-symtab.t)
# Replace define_def_symbol() by one function for each symbol table type: define_static_def_sym(),
#  define_global_def_sym(), define_local_def_sym(), encapsulating the symbol table used.
# Define keywords for special symbols ASMSIZE, ASMTAIL
#
# Revision 1.2  2013/06/08 23:07:53  pauloscustodio (whitebox-symtab.t)
# Add global ASMPC Symbol pointer, to avoid "ASMPC" symbol table lookup on every instruction.
# Encapsulate get_global_tab() and get_static_tab() by using new functions define_static_sym()
#  and define_global_sym().
#
# Revision 1.2  2013/06/01 01:24:23  pauloscustodio
# CH_0022 : Replace avltree by hash table for symbol table
#
# Revision 1.1  2013/05/28 23:39:04  pauloscustodio
# test definition of symbols in all possible combinations
#
