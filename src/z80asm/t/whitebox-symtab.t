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

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

my $objs = "sym.o symtab.o symref.o lib/class.o lib/strhash.o errors.o lib/strutil.o lib/strlist.o lib/fileutil.o file.o options.o hist.o scan.o";

my $init = <<'END';
#include "symbol.h"

size_t get_PC( void ) { return 0; }
void list_start_line( size_t address, char *source_file, int source_line_nr, char *line ) 
{	
	warn("%04X %-16s %5d %s", address, source_file, source_line_nr, line);
}

int page_nr 			= 1;
int list_get_page_nr() { return page_nr; }

char ident[MAXLINE];
char separators[MAXLINE];

char *CreateLibfile( char *filename ) {}
char *GetLibfile( char *filename ) {}

struct module the_module;
struct module *CURRENTMODULE = &the_module;
struct modules the_modules;
struct modules *modulehdr = &the_modules;

extern SymbolHash *get_static_tab(void);

extern Symbol *_define_sym( char *name, long value, byte_t type, struct module *owner, SymbolHash *symtab );

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
		 sym->name, Symbol_fullname(sym), sym->value, sym->type );
	if (sym->type & SYMDEFINED)	warn("DEFINED ");
	if (sym->type & SYMTOUCHED)	warn("TOUCHED ");
	if (sym->type & SYMDEF)		warn("DEF ");
	if (sym->type & SYMADDR)	warn("ADDR ");
	if (sym->type & SYMLOCAL)	warn("LOCAL ");
	if (sym->type & SYMXDEF)	warn("XDEF ");
	if (sym->type & SYMXREF)	warn("XREF ");
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
	dump_SymbolHash(get_global_tab(), "global tab");
	dump_SymbolHash(get_static_tab(), "static tab");
	dump_SymbolHash(CURRENTMODULE->local_tab, "local tab");
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
    CURRENTMODULE->local_tab   = OBJ_NEW(SymbolHash);
	modulehdr->first = CURRENTMODULE;
	CURRENTMODULE->nextmodule = NULL;

	TITLE("Create symbol");	
	sym = Symbol_create(S("VAR1"), 123, 0, NULL);
	dump_Symbol(sym);
	OBJ_DELETE(sym);

	sym = Symbol_create(S("VAR1"), 123, 0, CURRENTMODULE);
	dump_Symbol(sym);
	CURRENTMODULE->mname = "MODULE";
	dump_Symbol(sym);
	
	TITLE("Delete symbol");	
	OBJ_DELETE(sym);
	
	TITLE("Global symtab");	
	ASSERT( symtab  = get_global_tab() );
	ASSERT( symtab == get_global_tab() );
	ASSERT( symtab == get_global_tab() );
	dump_SymbolHash(symtab, "global");

	ASSERT( symtab  = get_static_tab() );
	ASSERT( symtab == get_static_tab() );
	ASSERT( symtab == get_static_tab() );
	dump_SymbolHash(symtab, "static");
	
	ASSERT( get_global_tab() != get_static_tab() );
	
	TITLE("Concat symbol tables");	
	ASSERT( symtab  = OBJ_NEW(SymbolHash) );
	_define_sym(S("VAR1"),  1, 0, NULL, symtab); page_nr++;
	_define_sym(S("VAR2"),  2, 0, NULL, symtab); page_nr++; 
	_define_sym(S("VAR3"), -3, 0, NULL, symtab); page_nr++;
	dump_SymbolHash(symtab, "tab1");
	
	ASSERT( symtab2 = OBJ_NEW(SymbolHash) );
	_define_sym(S("VAR3"), 3, 0, NULL, symtab2); page_nr++;
	_define_sym(S("VAR4"), 4, 0, NULL, symtab2); page_nr++;
	_define_sym(S("VAR5"), 5, 0, NULL, symtab2); page_nr++;
	dump_SymbolHash(symtab2, "tab2");
	
	SymbolHash_cat( symtab, symtab2 );
	dump_SymbolHash(symtab, "merged_tab");
	
	OBJ_DELETE( symtab );
	OBJ_DELETE( symtab2 );
	
	TITLE("Sort");	
	ASSERT( symtab  = OBJ_NEW(SymbolHash) );
	_define_sym(S("ONE"), 	1, 0, NULL, symtab); page_nr++;
	_define_sym(S("TWO"),	2, 0, NULL, symtab); page_nr++; 
	_define_sym(S("THREE"),	3, 0, NULL, symtab); page_nr++;
	_define_sym(S("FOUR"),	4, 0, NULL, symtab); page_nr++;

	dump_SymbolHash(symtab, "tab");
	
	SymbolHash_sort(symtab, SymbolHash_by_name);
	dump_SymbolHash(symtab, "tab by name");

	SymbolHash_sort(symtab, SymbolHash_by_value);
	dump_SymbolHash(symtab, "tab by value");

	OBJ_DELETE( symtab );

	TITLE("Use local symbol before definition");
	page_nr = 1;
	_define_sym(S("WIN32"), 1, 0, NULL, get_static_tab()); page_nr++;
	SymbolHash_cat( CURRENTMODULE->local_tab, get_static_tab() ); page_nr++;
	_define_sym(S(ASMPC_KW), 0, 0, NULL, get_global_tab()); page_nr++;
	find_symbol( S(ASMPC_KW), get_global_tab() )->value += 3; page_nr++;
	find_symbol( S(ASMPC_KW), get_global_tab() )->value += 3; page_nr++;
	sym = get_used_symbol(S("NN")); page_nr++;
	ASSERT( sym != NULL );
	ASSERT( ! (sym->type & SYMDEFINED) );
	find_symbol( S(ASMPC_KW), get_global_tab() )->value += 3; page_nr++;
	sym = get_used_symbol(S("NN")); page_nr++;
	ASSERT( sym != NULL );
	ASSERT( ! (sym->type & SYMDEFINED) );
	find_symbol( S(ASMPC_KW), get_global_tab() )->value += 3; page_nr++;
	define_symbol(S("NN"), find_symbol( S(ASMPC_KW), get_global_tab() )->value, SYMADDR | SYMTOUCHED ); 
	sym = get_used_symbol(S("NN")); page_nr++;
	ASSERT( sym != NULL );
	ASSERT( sym->type & SYMDEFINED );
	dump_Symbol(sym);
	
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

Symbol VAR1 (VAR1) = 123, type = 0x00 [], ref = [1 ], owner = NULL
Symbol VAR1 (VAR1) = 123, type = 0x00 [], ref = [1 ], owner = CURRENTMODULE
Symbol VAR1 (VAR1@MODULE) = 123, type = 0x00 [], ref = [1 ], owner = CURRENTMODULE

---- TEST: Delete symbol ----


---- TEST: Global symtab ----

Symtab "global": EMPTY
Symtab "static": EMPTY

---- TEST: Concat symbol tables ----

Symtab "tab1": 
  Symbol VAR1 (VAR1) = 1, type = 0x01 [DEFINED ], ref = [1 ], owner = NULL
  Symbol VAR2 (VAR2) = 2, type = 0x01 [DEFINED ], ref = [2 ], owner = NULL
  Symbol VAR3 (VAR3) = -3, type = 0x01 [DEFINED ], ref = [3 ], owner = NULL
Symtab "tab2": 
  Symbol VAR3 (VAR3) = 3, type = 0x01 [DEFINED ], ref = [4 ], owner = NULL
  Symbol VAR4 (VAR4) = 4, type = 0x01 [DEFINED ], ref = [5 ], owner = NULL
  Symbol VAR5 (VAR5) = 5, type = 0x01 [DEFINED ], ref = [6 ], owner = NULL
Symtab "merged_tab": 
  Symbol VAR1 (VAR1) = 1, type = 0x01 [DEFINED ], ref = [1 ], owner = NULL
  Symbol VAR2 (VAR2) = 2, type = 0x01 [DEFINED ], ref = [2 ], owner = NULL
  Symbol VAR3 (VAR3) = 3, type = 0x01 [DEFINED ], ref = [4 ], owner = NULL
  Symbol VAR4 (VAR4) = 4, type = 0x01 [DEFINED ], ref = [5 ], owner = NULL
  Symbol VAR5 (VAR5) = 5, type = 0x01 [DEFINED ], ref = [6 ], owner = NULL

---- TEST: Sort ----

Symtab "tab": 
  Symbol ONE (ONE) = 1, type = 0x01 [DEFINED ], ref = [7 ], owner = NULL
  Symbol TWO (TWO) = 2, type = 0x01 [DEFINED ], ref = [8 ], owner = NULL
  Symbol THREE (THREE) = 3, type = 0x01 [DEFINED ], ref = [9 ], owner = NULL
  Symbol FOUR (FOUR) = 4, type = 0x01 [DEFINED ], ref = [10 ], owner = NULL
Symtab "tab by name": 
  Symbol FOUR (FOUR) = 4, type = 0x01 [DEFINED ], ref = [10 ], owner = NULL
  Symbol ONE (ONE) = 1, type = 0x01 [DEFINED ], ref = [7 ], owner = NULL
  Symbol THREE (THREE) = 3, type = 0x01 [DEFINED ], ref = [9 ], owner = NULL
  Symbol TWO (TWO) = 2, type = 0x01 [DEFINED ], ref = [8 ], owner = NULL
Symtab "tab by value": 
  Symbol ONE (ONE) = 1, type = 0x01 [DEFINED ], ref = [7 ], owner = NULL
  Symbol TWO (TWO) = 2, type = 0x01 [DEFINED ], ref = [8 ], owner = NULL
  Symbol THREE (THREE) = 3, type = 0x01 [DEFINED ], ref = [9 ], owner = NULL
  Symbol FOUR (FOUR) = 4, type = 0x01 [DEFINED ], ref = [10 ], owner = NULL

---- TEST: Use local symbol before definition ----

Symbol NN (NN@MODULE) = 12, type = 0x1B [DEFINED TOUCHED ADDR LOCAL ], ref = [10 6 8 ], owner = CURRENTMODULE
Symtab "global tab": 
  Symbol ASMPC (ASMPC) = 12, type = 0x03 [DEFINED TOUCHED ], ref = [3 ], owner = NULL
Symtab "static tab": 
  Symbol WIN32 (WIN32) = 1, type = 0x01 [DEFINED ], ref = [1 ], owner = NULL
Symtab "local tab": 
  Symbol WIN32 (WIN32) = 1, type = 0x01 [DEFINED ], ref = [1 ], owner = NULL
  Symbol NN (NN@MODULE) = 12, type = 0x1B [DEFINED TOUCHED ADDR LOCAL ], ref = [10 6 8 ], owner = CURRENTMODULE

---- TEST: Delete Local ----

Symtab "global tab": 
  Symbol ASMPC (ASMPC) = 12, type = 0x03 [DEFINED TOUCHED ], ref = [3 ], owner = NULL
Symtab "static tab": 
  Symbol WIN32 (WIN32) = 1, type = 0x01 [DEFINED ], ref = [1 ], owner = NULL
Symtab "local tab": EMPTY

---- TEST: Delete Static ----

Symtab "global tab": 
  Symbol ASMPC (ASMPC) = 12, type = 0x03 [DEFINED TOUCHED ], ref = [3 ], owner = NULL
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


# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-symtab.t,v 1.29 2014-01-01 21:23:48 pauloscustodio Exp $
# $Log: whitebox-symtab.t,v $
# Revision 1.29  2014-01-01 21:23:48  pauloscustodio
# Move generic file utility functions to lib/fileutil.c
#
# Revision 1.28  2013/12/30 02:05:34  pauloscustodio
# Merge dynstr.c and safestr.c into lib/strutil.c; the new Str type
# handles both dynamically allocated strings and fixed-size strings.
# Replaced g_strchomp by chomp by; g_ascii_tolower by tolower;
# g_ascii_toupper by toupper; g_ascii_strcasecmp by stricompare.
#
# Revision 1.27  2013/12/26 23:42:28  pauloscustodio
# Replace StringList from strutil by StrList in new strlis.c, to keep lists of strings (e.g. directory search paths)
#
# Revision 1.26  2013/12/25 17:02:10  pauloscustodio
# Move strhash.c to the z80asm/lib directory
#
# Revision 1.25  2013/12/25 14:39:50  pauloscustodio
# Move strutil.c to the z80asm/lib directory
#
# Revision 1.24  2013/12/18 23:05:52  pauloscustodio
# Move class.c to the z80asm/lib directory
#
# Revision 1.23  2013/12/15 13:18:35  pauloscustodio
# Move memory allocation routines to lib/xmalloc, instead of glib,
# introduce memory leak report on exit and memory fence check.
#
# Revision 1.22  2013/11/11 23:47:04  pauloscustodio
# Move source code generation tools to dev/Makefile, only called on request,
# and keep the generated files in z80asm directory, so that build does
# not require tools used for the code generation (ragel, perl).
# Remove code generation for structs - use CLASS macro instead.
#
# Revision 1.21  2013/10/15 23:24:33  pauloscustodio
# Move reading by lines or tokens and file reading interface to scan.rl
# to decouple file.c from scan.c.
# Add singleton interface to scan to be used by parser.
#
# Revision 1.20  2013/10/08 21:53:07  pauloscustodio
# Replace Flex-based lexer by a Ragel-based one.
# Add interface to file.c to read files by tokens, calling the lexer.
#
# Revision 1.19  2013/10/05 10:54:36  pauloscustodio
# Parse command line options via look-up tables:
# -I, --inc-path
# -L, --lib-path
#
# Revision 1.18  2013/10/01 23:23:53  pauloscustodio
# Parse command line options via look-up tables:
# -l, --list
# -nl, --no-list
#
# Revision 1.17  2013/10/01 22:50:27  pauloscustodio
# Parse command line options via look-up tables:
# -s, --symtable
# -ns, --no-symtable
#
# Revision 1.16  2013/10/01 22:09:33  pauloscustodio
# Parse command line options via look-up tables:
# -sdcc
#
# Revision 1.15  2013/09/24 00:05:36  pauloscustodio
#
# Revision 1.14  2013/09/23 23:14:10  pauloscustodio
# Renamed SzList to StringList, simplified interface by assuming that
# list lives in memory util program ends; it is used for directory searches
# only. Moved interface to strutil.c, removed strlist.c.
#
# Revision 1.13  2013/09/22 21:04:22  pauloscustodio
# New File and FileStack objects
#
# Revision 1.12  2013/09/09 00:20:45  pauloscustodio
# Add default set of modules to t_compile_module:
# -DMEMALLOC_DEBUG xmalloc.c die.o except.o strpool.o
#
# Revision 1.11  2013/09/08 00:43:59  pauloscustodio
# New error module with one error function per error, no need for the error
# constants. Allows compiler to type-check error message arguments.
# Included the errors module in the init() mechanism, no need to call
# error initialization from main(). Moved all error-testing scripts to
# one file errors.t.
#
# Revision 1.10  2013/09/01 17:04:44  pauloscustodio
# Change in test output due to xmalloc change.
#
# Revision 1.9  2013/09/01 11:52:56  pauloscustodio
# Setup xmalloc on init.c.
# Setup GLib memory allocation functions to use xmalloc functions.
#
# Revision 1.8  2013/06/16 22:25:39  pauloscustodio
# New remove_all_{local,static,global}_syms( void ) functions
# to encapsulate calls to get_global_tab().
#
# Revision 1.7  2013/06/16 17:51:57  pauloscustodio
# get_all_syms() to get list of symbols matching a type mask, use in mapfile to decouple
# it from get_global_tab()
#
# Revision 1.6  2013/06/16 16:49:20  pauloscustodio
# Symbol_fullname() to return full symbol name NAME@MODULE
#
# Revision 1.5  2013/06/11 23:16:06  pauloscustodio
# Move symbol creation logic fromReadNames() in  modlink.c to symtab.c.
# Add error message for invalid symbol and scope chars in object file.
#
# Revision 1.4  2013/06/10 23:11:33  pauloscustodio
# CH_0023 : Remove notdecl_tab
#
# Revision 1.3  2013/06/08 23:37:32  pauloscustodio
# Replace define_def_symbol() by one function for each symbol table type: define_static_def_sym(),
#  define_global_def_sym(), define_local_def_sym(), encapsulating the symbol table used.
# Define keywords for special symbols ASMPC, ASMSIZE, ASMTAIL
#
# Revision 1.2  2013/06/08 23:07:53  pauloscustodio
# Add global ASMPC Symbol pointer, to avoid "ASMPC" symbol table lookup on every instruction.
# Encapsulate get_global_tab() and get_static_tab() by using new functions define_static_sym()
#  and define_global_sym().
#
# Revision 1.1  2013/06/01 01:24:23  pauloscustodio
# CH_0022 : Replace avltree by hash table for symbol table
