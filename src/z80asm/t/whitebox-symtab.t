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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-symtab.t,v 1.7 2013-06-16 17:51:57 pauloscustodio Exp $
# $Log: whitebox-symtab.t,v $
# Revision 1.7  2013-06-16 17:51:57  pauloscustodio
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
#
#

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

my $objs = "-DMEMALLOC_DEBUG memalloc.c ".
		   "sym.o symtab.o symref.o ".
		   "class.o strpool.o strutil.o safestr.o strlist.o strhash.o ".
		   "file.o errors.o die.o except.o";

my $init = <<'END';
#include "symbol.h"

int listing				= 0;
int option_symtable		= 1;
int option_list			= 1;
int page_nr 			= 1;
int sdcc_hacks			= 0;
int list_get_page_nr() { return page_nr; }

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
	
	TITLE("End");	
END

# write test object file
t_run_module([], "", <<'END', 0);

---- TEST: Create current module ----

memalloc: init
memalloc symtab.c(1): alloc 32 bytes at ADDR_1
memalloc strhash.c(1): alloc 32 bytes at ADDR_2
memalloc strpool.c(1): alloc 32 bytes at ADDR_3

---- TEST: Create symbol ----

memalloc sym.c(1): alloc 48 bytes at ADDR_4
memalloc symref.c(2): alloc 40 bytes at ADDR_5
memalloc strpool.c(2): alloc 36 bytes at ADDR_6
memalloc strpool.c(3): alloc 5 bytes at ADDR_7
memalloc strpool.c(4): alloc 44 bytes at ADDR_8
memalloc strpool.c(4): alloc 384 bytes at ADDR_9
memalloc symref.c(1): alloc 32 bytes at ADDR_10
memalloc symref.c(2): alloc 12 bytes at ADDR_11
Symbol VAR1 (VAR1) = 123, type = 0x00 [], ref = [1 ], owner = NULL
memalloc symref.c(1): free 32 bytes at ADDR_10 allocated at symref.c(1)
memalloc symref.c(2): free 12 bytes at ADDR_11 allocated at symref.c(2)
memalloc symref.c(2): free 40 bytes at ADDR_5 allocated at symref.c(2)
memalloc sym.c(1): free 48 bytes at ADDR_4 allocated at sym.c(1)
memalloc sym.c(1): alloc 48 bytes at ADDR_12
memalloc symref.c(2): alloc 40 bytes at ADDR_13
memalloc symref.c(1): alloc 32 bytes at ADDR_14
memalloc symref.c(2): alloc 12 bytes at ADDR_15
Symbol VAR1 (VAR1) = 123, type = 0x00 [], ref = [1 ], owner = CURRENTMODULE
memalloc strpool.c(2): alloc 36 bytes at ADDR_16
memalloc strpool.c(3): alloc 12 bytes at ADDR_17
Symbol VAR1 (VAR1@MODULE) = 123, type = 0x00 [], ref = [1 ], owner = CURRENTMODULE

---- TEST: Delete symbol ----

memalloc symref.c(1): free 32 bytes at ADDR_14 allocated at symref.c(1)
memalloc symref.c(2): free 12 bytes at ADDR_15 allocated at symref.c(2)
memalloc symref.c(2): free 40 bytes at ADDR_13 allocated at symref.c(2)
memalloc sym.c(1): free 48 bytes at ADDR_12 allocated at sym.c(1)

---- TEST: Global symtab ----

memalloc symtab.c(1): alloc 32 bytes at ADDR_18
memalloc strhash.c(1): alloc 32 bytes at ADDR_19
Symtab "global": EMPTY
memalloc symtab.c(1): alloc 32 bytes at ADDR_20
memalloc strhash.c(1): alloc 32 bytes at ADDR_21
Symtab "static": EMPTY

---- TEST: Concat symbol tables ----

memalloc symtab.c(1): alloc 32 bytes at ADDR_22
memalloc strhash.c(1): alloc 32 bytes at ADDR_23
memalloc sym.c(1): alloc 48 bytes at ADDR_24
memalloc symref.c(2): alloc 40 bytes at ADDR_25
memalloc symref.c(1): alloc 32 bytes at ADDR_26
memalloc symref.c(2): alloc 12 bytes at ADDR_27
memalloc strhash.c(4): alloc 40 bytes at ADDR_28
memalloc strhash.c(5): alloc 44 bytes at ADDR_29
memalloc strhash.c(5): alloc 384 bytes at ADDR_30
memalloc symref.c(2): free 12 bytes at ADDR_27 allocated at symref.c(2)
memalloc symref.c(2): alloc 12 bytes at ADDR_31
memalloc sym.c(1): alloc 48 bytes at ADDR_32
memalloc symref.c(2): alloc 40 bytes at ADDR_33
memalloc strpool.c(2): alloc 36 bytes at ADDR_34
memalloc strpool.c(3): alloc 5 bytes at ADDR_35
memalloc symref.c(1): alloc 32 bytes at ADDR_36
memalloc symref.c(2): alloc 12 bytes at ADDR_37
memalloc strhash.c(4): alloc 40 bytes at ADDR_38
memalloc symref.c(2): free 12 bytes at ADDR_37 allocated at symref.c(2)
memalloc symref.c(2): alloc 12 bytes at ADDR_39
memalloc sym.c(1): alloc 48 bytes at ADDR_40
memalloc symref.c(2): alloc 40 bytes at ADDR_41
memalloc strpool.c(2): alloc 36 bytes at ADDR_42
memalloc strpool.c(3): alloc 5 bytes at ADDR_43
memalloc symref.c(1): alloc 32 bytes at ADDR_44
memalloc symref.c(2): alloc 12 bytes at ADDR_45
memalloc strhash.c(4): alloc 40 bytes at ADDR_46
memalloc symref.c(2): free 12 bytes at ADDR_45 allocated at symref.c(2)
memalloc symref.c(2): alloc 12 bytes at ADDR_47
Symtab "tab1": 
  Symbol VAR1 (VAR1) = 1, type = 0x01 [DEFINED ], ref = [1 ], owner = NULL
  Symbol VAR2 (VAR2) = 2, type = 0x01 [DEFINED ], ref = [2 ], owner = NULL
  Symbol VAR3 (VAR3) = -3, type = 0x01 [DEFINED ], ref = [3 ], owner = NULL
memalloc symtab.c(1): alloc 32 bytes at ADDR_48
memalloc strhash.c(1): alloc 32 bytes at ADDR_49
memalloc sym.c(1): alloc 48 bytes at ADDR_50
memalloc symref.c(2): alloc 40 bytes at ADDR_51
memalloc symref.c(1): alloc 32 bytes at ADDR_52
memalloc symref.c(2): alloc 12 bytes at ADDR_53
memalloc strhash.c(4): alloc 40 bytes at ADDR_54
memalloc strhash.c(5): alloc 44 bytes at ADDR_55
memalloc strhash.c(5): alloc 384 bytes at ADDR_56
memalloc symref.c(2): free 12 bytes at ADDR_53 allocated at symref.c(2)
memalloc symref.c(2): alloc 12 bytes at ADDR_57
memalloc sym.c(1): alloc 48 bytes at ADDR_58
memalloc symref.c(2): alloc 40 bytes at ADDR_59
memalloc strpool.c(2): alloc 36 bytes at ADDR_60
memalloc strpool.c(3): alloc 5 bytes at ADDR_61
memalloc symref.c(1): alloc 32 bytes at ADDR_62
memalloc symref.c(2): alloc 12 bytes at ADDR_63
memalloc strhash.c(4): alloc 40 bytes at ADDR_64
memalloc symref.c(2): free 12 bytes at ADDR_63 allocated at symref.c(2)
memalloc symref.c(2): alloc 12 bytes at ADDR_65
memalloc sym.c(1): alloc 48 bytes at ADDR_66
memalloc symref.c(2): alloc 40 bytes at ADDR_67
memalloc strpool.c(2): alloc 36 bytes at ADDR_68
memalloc strpool.c(3): alloc 5 bytes at ADDR_69
memalloc symref.c(1): alloc 32 bytes at ADDR_70
memalloc symref.c(2): alloc 12 bytes at ADDR_71
memalloc strhash.c(4): alloc 40 bytes at ADDR_72
memalloc symref.c(2): free 12 bytes at ADDR_71 allocated at symref.c(2)
memalloc symref.c(2): alloc 12 bytes at ADDR_73
Symtab "tab2": 
  Symbol VAR3 (VAR3) = 3, type = 0x01 [DEFINED ], ref = [4 ], owner = NULL
  Symbol VAR4 (VAR4) = 4, type = 0x01 [DEFINED ], ref = [5 ], owner = NULL
  Symbol VAR5 (VAR5) = 5, type = 0x01 [DEFINED ], ref = [6 ], owner = NULL
memalloc sym.c(1): alloc 48 bytes at ADDR_74
memalloc symref.c(2): alloc 40 bytes at ADDR_75
memalloc symref.c(1): alloc 32 bytes at ADDR_76
memalloc symref.c(2): alloc 12 bytes at ADDR_77
memalloc symref.c(1): free 32 bytes at ADDR_44 allocated at symref.c(1)
memalloc symref.c(2): free 12 bytes at ADDR_47 allocated at symref.c(2)
memalloc symref.c(2): free 40 bytes at ADDR_41 allocated at symref.c(2)
memalloc sym.c(1): free 48 bytes at ADDR_40 allocated at sym.c(1)
memalloc sym.c(1): alloc 48 bytes at ADDR_78
memalloc symref.c(2): alloc 40 bytes at ADDR_79
memalloc symref.c(1): alloc 32 bytes at ADDR_80
memalloc symref.c(2): alloc 12 bytes at ADDR_81
memalloc strhash.c(4): alloc 40 bytes at ADDR_82
memalloc sym.c(1): alloc 48 bytes at ADDR_83
memalloc symref.c(2): alloc 40 bytes at ADDR_84
memalloc symref.c(1): alloc 32 bytes at ADDR_85
memalloc symref.c(2): alloc 12 bytes at ADDR_86
memalloc strhash.c(4): alloc 40 bytes at ADDR_87
Symtab "merged_tab": 
  Symbol VAR1 (VAR1) = 1, type = 0x01 [DEFINED ], ref = [1 ], owner = NULL
  Symbol VAR2 (VAR2) = 2, type = 0x01 [DEFINED ], ref = [2 ], owner = NULL
  Symbol VAR3 (VAR3) = 3, type = 0x01 [DEFINED ], ref = [4 ], owner = NULL
  Symbol VAR4 (VAR4) = 4, type = 0x01 [DEFINED ], ref = [5 ], owner = NULL
  Symbol VAR5 (VAR5) = 5, type = 0x01 [DEFINED ], ref = [6 ], owner = NULL
memalloc symref.c(1): free 32 bytes at ADDR_26 allocated at symref.c(1)
memalloc symref.c(2): free 12 bytes at ADDR_31 allocated at symref.c(2)
memalloc symref.c(2): free 40 bytes at ADDR_25 allocated at symref.c(2)
memalloc sym.c(1): free 48 bytes at ADDR_24 allocated at sym.c(1)
memalloc strhash.c(3): free 40 bytes at ADDR_28 allocated at strhash.c(4)
memalloc symref.c(1): free 32 bytes at ADDR_36 allocated at symref.c(1)
memalloc symref.c(2): free 12 bytes at ADDR_39 allocated at symref.c(2)
memalloc symref.c(2): free 40 bytes at ADDR_33 allocated at symref.c(2)
memalloc sym.c(1): free 48 bytes at ADDR_32 allocated at sym.c(1)
memalloc strhash.c(3): free 40 bytes at ADDR_38 allocated at strhash.c(4)
memalloc symref.c(1): free 32 bytes at ADDR_76 allocated at symref.c(1)
memalloc symref.c(2): free 12 bytes at ADDR_77 allocated at symref.c(2)
memalloc symref.c(2): free 40 bytes at ADDR_75 allocated at symref.c(2)
memalloc sym.c(1): free 48 bytes at ADDR_74 allocated at sym.c(1)
memalloc strhash.c(3): free 40 bytes at ADDR_46 allocated at strhash.c(4)
memalloc symref.c(1): free 32 bytes at ADDR_80 allocated at symref.c(1)
memalloc symref.c(2): free 12 bytes at ADDR_81 allocated at symref.c(2)
memalloc symref.c(2): free 40 bytes at ADDR_79 allocated at symref.c(2)
memalloc sym.c(1): free 48 bytes at ADDR_78 allocated at sym.c(1)
memalloc strhash.c(3): free 40 bytes at ADDR_82 allocated at strhash.c(4)
memalloc symref.c(1): free 32 bytes at ADDR_85 allocated at symref.c(1)
memalloc symref.c(2): free 12 bytes at ADDR_86 allocated at symref.c(2)
memalloc symref.c(2): free 40 bytes at ADDR_84 allocated at symref.c(2)
memalloc sym.c(1): free 48 bytes at ADDR_83 allocated at sym.c(1)
memalloc strhash.c(2): free 384 bytes at ADDR_30 allocated at strhash.c(5)
memalloc strhash.c(2): free 44 bytes at ADDR_29 allocated at strhash.c(5)
memalloc strhash.c(3): free 40 bytes at ADDR_87 allocated at strhash.c(4)
memalloc symtab.c(1): free 32 bytes at ADDR_22 allocated at symtab.c(1)
memalloc symref.c(1): free 32 bytes at ADDR_52 allocated at symref.c(1)
memalloc symref.c(2): free 12 bytes at ADDR_57 allocated at symref.c(2)
memalloc symref.c(2): free 40 bytes at ADDR_51 allocated at symref.c(2)
memalloc sym.c(1): free 48 bytes at ADDR_50 allocated at sym.c(1)
memalloc strhash.c(3): free 40 bytes at ADDR_54 allocated at strhash.c(4)
memalloc symref.c(1): free 32 bytes at ADDR_62 allocated at symref.c(1)
memalloc symref.c(2): free 12 bytes at ADDR_65 allocated at symref.c(2)
memalloc symref.c(2): free 40 bytes at ADDR_59 allocated at symref.c(2)
memalloc sym.c(1): free 48 bytes at ADDR_58 allocated at sym.c(1)
memalloc strhash.c(3): free 40 bytes at ADDR_64 allocated at strhash.c(4)
memalloc symref.c(1): free 32 bytes at ADDR_70 allocated at symref.c(1)
memalloc symref.c(2): free 12 bytes at ADDR_73 allocated at symref.c(2)
memalloc symref.c(2): free 40 bytes at ADDR_67 allocated at symref.c(2)
memalloc sym.c(1): free 48 bytes at ADDR_66 allocated at sym.c(1)
memalloc strhash.c(2): free 384 bytes at ADDR_56 allocated at strhash.c(5)
memalloc strhash.c(2): free 44 bytes at ADDR_55 allocated at strhash.c(5)
memalloc strhash.c(3): free 40 bytes at ADDR_72 allocated at strhash.c(4)
memalloc symtab.c(1): free 32 bytes at ADDR_48 allocated at symtab.c(1)

---- TEST: Sort ----

memalloc symtab.c(1): alloc 32 bytes at ADDR_88
memalloc strhash.c(1): alloc 32 bytes at ADDR_89
memalloc sym.c(1): alloc 48 bytes at ADDR_90
memalloc symref.c(2): alloc 40 bytes at ADDR_91
memalloc strpool.c(2): alloc 36 bytes at ADDR_92
memalloc strpool.c(3): alloc 4 bytes at ADDR_93
memalloc symref.c(1): alloc 32 bytes at ADDR_94
memalloc symref.c(2): alloc 12 bytes at ADDR_95
memalloc strhash.c(4): alloc 40 bytes at ADDR_96
memalloc strhash.c(5): alloc 44 bytes at ADDR_97
memalloc strhash.c(5): alloc 384 bytes at ADDR_98
memalloc symref.c(2): free 12 bytes at ADDR_95 allocated at symref.c(2)
memalloc symref.c(2): alloc 12 bytes at ADDR_99
memalloc sym.c(1): alloc 48 bytes at ADDR_100
memalloc symref.c(2): alloc 40 bytes at ADDR_101
memalloc strpool.c(2): alloc 36 bytes at ADDR_102
memalloc strpool.c(3): alloc 4 bytes at ADDR_103
memalloc symref.c(1): alloc 32 bytes at ADDR_104
memalloc symref.c(2): alloc 12 bytes at ADDR_105
memalloc strhash.c(4): alloc 40 bytes at ADDR_106
memalloc symref.c(2): free 12 bytes at ADDR_105 allocated at symref.c(2)
memalloc symref.c(2): alloc 12 bytes at ADDR_107
memalloc sym.c(1): alloc 48 bytes at ADDR_108
memalloc symref.c(2): alloc 40 bytes at ADDR_109
memalloc strpool.c(2): alloc 36 bytes at ADDR_110
memalloc strpool.c(3): alloc 6 bytes at ADDR_111
memalloc symref.c(1): alloc 32 bytes at ADDR_112
memalloc symref.c(2): alloc 12 bytes at ADDR_113
memalloc strhash.c(4): alloc 40 bytes at ADDR_114
memalloc symref.c(2): free 12 bytes at ADDR_113 allocated at symref.c(2)
memalloc symref.c(2): alloc 12 bytes at ADDR_115
memalloc sym.c(1): alloc 48 bytes at ADDR_116
memalloc symref.c(2): alloc 40 bytes at ADDR_117
memalloc strpool.c(2): alloc 36 bytes at ADDR_118
memalloc strpool.c(3): alloc 5 bytes at ADDR_119
memalloc symref.c(1): alloc 32 bytes at ADDR_120
memalloc symref.c(2): alloc 12 bytes at ADDR_121
memalloc strhash.c(4): alloc 40 bytes at ADDR_122
memalloc symref.c(2): free 12 bytes at ADDR_121 allocated at symref.c(2)
memalloc symref.c(2): alloc 12 bytes at ADDR_123
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
memalloc symref.c(1): free 32 bytes at ADDR_94 allocated at symref.c(1)
memalloc symref.c(2): free 12 bytes at ADDR_99 allocated at symref.c(2)
memalloc symref.c(2): free 40 bytes at ADDR_91 allocated at symref.c(2)
memalloc sym.c(1): free 48 bytes at ADDR_90 allocated at sym.c(1)
memalloc strhash.c(3): free 40 bytes at ADDR_96 allocated at strhash.c(4)
memalloc symref.c(1): free 32 bytes at ADDR_104 allocated at symref.c(1)
memalloc symref.c(2): free 12 bytes at ADDR_107 allocated at symref.c(2)
memalloc symref.c(2): free 40 bytes at ADDR_101 allocated at symref.c(2)
memalloc sym.c(1): free 48 bytes at ADDR_100 allocated at sym.c(1)
memalloc strhash.c(3): free 40 bytes at ADDR_106 allocated at strhash.c(4)
memalloc symref.c(1): free 32 bytes at ADDR_112 allocated at symref.c(1)
memalloc symref.c(2): free 12 bytes at ADDR_115 allocated at symref.c(2)
memalloc symref.c(2): free 40 bytes at ADDR_109 allocated at symref.c(2)
memalloc sym.c(1): free 48 bytes at ADDR_108 allocated at sym.c(1)
memalloc strhash.c(3): free 40 bytes at ADDR_114 allocated at strhash.c(4)
memalloc symref.c(1): free 32 bytes at ADDR_120 allocated at symref.c(1)
memalloc symref.c(2): free 12 bytes at ADDR_123 allocated at symref.c(2)
memalloc symref.c(2): free 40 bytes at ADDR_117 allocated at symref.c(2)
memalloc sym.c(1): free 48 bytes at ADDR_116 allocated at sym.c(1)
memalloc strhash.c(2): free 384 bytes at ADDR_98 allocated at strhash.c(5)
memalloc strhash.c(2): free 44 bytes at ADDR_97 allocated at strhash.c(5)
memalloc strhash.c(3): free 40 bytes at ADDR_122 allocated at strhash.c(4)
memalloc symtab.c(1): free 32 bytes at ADDR_88 allocated at symtab.c(1)

---- TEST: Use local symbol before definition ----

memalloc sym.c(1): alloc 48 bytes at ADDR_124
memalloc symref.c(2): alloc 40 bytes at ADDR_125
memalloc strpool.c(2): alloc 36 bytes at ADDR_126
memalloc strpool.c(3): alloc 6 bytes at ADDR_127
memalloc symref.c(1): alloc 32 bytes at ADDR_128
memalloc symref.c(2): alloc 12 bytes at ADDR_129
memalloc strhash.c(4): alloc 40 bytes at ADDR_130
memalloc strhash.c(5): alloc 44 bytes at ADDR_131
memalloc strhash.c(5): alloc 384 bytes at ADDR_132
memalloc symref.c(2): free 12 bytes at ADDR_129 allocated at symref.c(2)
memalloc symref.c(2): alloc 12 bytes at ADDR_133
memalloc sym.c(1): alloc 48 bytes at ADDR_134
memalloc symref.c(2): alloc 40 bytes at ADDR_135
memalloc symref.c(1): alloc 32 bytes at ADDR_136
memalloc symref.c(2): alloc 12 bytes at ADDR_137
memalloc strhash.c(4): alloc 40 bytes at ADDR_138
memalloc strhash.c(5): alloc 44 bytes at ADDR_139
memalloc strhash.c(5): alloc 384 bytes at ADDR_140
memalloc sym.c(1): alloc 48 bytes at ADDR_141
memalloc symref.c(2): alloc 40 bytes at ADDR_142
memalloc strpool.c(2): alloc 36 bytes at ADDR_143
memalloc strpool.c(3): alloc 6 bytes at ADDR_144
memalloc symref.c(1): alloc 32 bytes at ADDR_145
memalloc symref.c(2): alloc 12 bytes at ADDR_146
memalloc strhash.c(4): alloc 40 bytes at ADDR_147
memalloc strhash.c(5): alloc 44 bytes at ADDR_148
memalloc strhash.c(5): alloc 384 bytes at ADDR_149
memalloc symref.c(2): free 12 bytes at ADDR_146 allocated at symref.c(2)
memalloc symref.c(2): alloc 12 bytes at ADDR_150
memalloc sym.c(1): alloc 48 bytes at ADDR_151
memalloc symref.c(2): alloc 40 bytes at ADDR_152
memalloc strpool.c(2): alloc 36 bytes at ADDR_153
memalloc strpool.c(3): alloc 3 bytes at ADDR_154
memalloc symref.c(1): alloc 32 bytes at ADDR_155
memalloc symref.c(2): alloc 12 bytes at ADDR_156
memalloc strhash.c(4): alloc 40 bytes at ADDR_157
memalloc symref.c(1): alloc 32 bytes at ADDR_158
memalloc symref.c(2): alloc 12 bytes at ADDR_159
memalloc symref.c(1): alloc 32 bytes at ADDR_160
memalloc symref.c(2): alloc 12 bytes at ADDR_161
memalloc strpool.c(2): alloc 36 bytes at ADDR_162
memalloc strpool.c(3): alloc 10 bytes at ADDR_163
Symbol NN (NN@MODULE) = 12, type = 0x1B [DEFINED TOUCHED ADDR LOCAL ], ref = [10 6 8 ], owner = CURRENTMODULE
Symtab "global tab": 
  Symbol ASMPC (ASMPC) = 12, type = 0x03 [DEFINED TOUCHED ], ref = [3 ], owner = NULL
Symtab "static tab": 
  Symbol WIN32 (WIN32) = 1, type = 0x01 [DEFINED ], ref = [1 ], owner = NULL
Symtab "local tab": 
  Symbol WIN32 (WIN32) = 1, type = 0x01 [DEFINED ], ref = [1 ], owner = NULL
  Symbol NN (NN@MODULE) = 12, type = 0x1B [DEFINED TOUCHED ADDR LOCAL ], ref = [10 6 8 ], owner = CURRENTMODULE

---- TEST: End ----

memalloc strhash.c(1): free 32 bytes at ADDR_89 allocated at strhash.c(1)
memalloc strhash.c(1): free 32 bytes at ADDR_49 allocated at strhash.c(1)
memalloc strhash.c(1): free 32 bytes at ADDR_23 allocated at strhash.c(1)
memalloc symref.c(1): free 32 bytes at ADDR_128 allocated at symref.c(1)
memalloc symref.c(2): free 12 bytes at ADDR_133 allocated at symref.c(2)
memalloc symref.c(2): free 40 bytes at ADDR_125 allocated at symref.c(2)
memalloc sym.c(1): free 48 bytes at ADDR_124 allocated at sym.c(1)
memalloc strhash.c(2): free 384 bytes at ADDR_132 allocated at strhash.c(5)
memalloc strhash.c(2): free 44 bytes at ADDR_131 allocated at strhash.c(5)
memalloc strhash.c(3): free 40 bytes at ADDR_130 allocated at strhash.c(4)
memalloc symtab.c(1): free 32 bytes at ADDR_20 allocated at symtab.c(1)
memalloc strhash.c(1): free 32 bytes at ADDR_21 allocated at strhash.c(1)
memalloc symref.c(1): free 32 bytes at ADDR_145 allocated at symref.c(1)
memalloc symref.c(2): free 12 bytes at ADDR_150 allocated at symref.c(2)
memalloc symref.c(2): free 40 bytes at ADDR_142 allocated at symref.c(2)
memalloc sym.c(1): free 48 bytes at ADDR_141 allocated at sym.c(1)
memalloc strhash.c(2): free 384 bytes at ADDR_149 allocated at strhash.c(5)
memalloc strhash.c(2): free 44 bytes at ADDR_148 allocated at strhash.c(5)
memalloc strhash.c(3): free 40 bytes at ADDR_147 allocated at strhash.c(4)
memalloc symtab.c(1): free 32 bytes at ADDR_18 allocated at symtab.c(1)
memalloc strhash.c(1): free 32 bytes at ADDR_19 allocated at strhash.c(1)
memalloc symref.c(1): free 32 bytes at ADDR_136 allocated at symref.c(1)
memalloc symref.c(2): free 12 bytes at ADDR_137 allocated at symref.c(2)
memalloc symref.c(2): free 40 bytes at ADDR_135 allocated at symref.c(2)
memalloc sym.c(1): free 48 bytes at ADDR_134 allocated at sym.c(1)
memalloc strhash.c(3): free 40 bytes at ADDR_138 allocated at strhash.c(4)
memalloc symref.c(1): free 32 bytes at ADDR_160 allocated at symref.c(1)
memalloc symref.c(2): free 12 bytes at ADDR_161 allocated at symref.c(2)
memalloc symref.c(1): free 32 bytes at ADDR_155 allocated at symref.c(1)
memalloc symref.c(2): free 12 bytes at ADDR_156 allocated at symref.c(2)
memalloc symref.c(1): free 32 bytes at ADDR_158 allocated at symref.c(1)
memalloc symref.c(2): free 12 bytes at ADDR_159 allocated at symref.c(2)
memalloc symref.c(2): free 40 bytes at ADDR_152 allocated at symref.c(2)
memalloc sym.c(1): free 48 bytes at ADDR_151 allocated at sym.c(1)
memalloc strhash.c(2): free 384 bytes at ADDR_140 allocated at strhash.c(5)
memalloc strhash.c(2): free 44 bytes at ADDR_139 allocated at strhash.c(5)
memalloc strhash.c(3): free 40 bytes at ADDR_157 allocated at strhash.c(4)
memalloc symtab.c(1): free 32 bytes at ADDR_1 allocated at symtab.c(1)
memalloc strhash.c(1): free 32 bytes at ADDR_2 allocated at strhash.c(1)
memalloc strpool.c(6): free 5 bytes at ADDR_7 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_6 allocated at strpool.c(2)
memalloc strpool.c(6): free 12 bytes at ADDR_17 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_16 allocated at strpool.c(2)
memalloc strpool.c(6): free 5 bytes at ADDR_35 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_34 allocated at strpool.c(2)
memalloc strpool.c(6): free 5 bytes at ADDR_43 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_42 allocated at strpool.c(2)
memalloc strpool.c(6): free 5 bytes at ADDR_61 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_60 allocated at strpool.c(2)
memalloc strpool.c(6): free 5 bytes at ADDR_69 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_68 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_93 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_92 allocated at strpool.c(2)
memalloc strpool.c(6): free 4 bytes at ADDR_103 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_102 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_111 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_110 allocated at strpool.c(2)
memalloc strpool.c(6): free 5 bytes at ADDR_119 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_118 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_127 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_126 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_144 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_143 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_154 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_153 allocated at strpool.c(2)
memalloc strpool.c(5): free 384 bytes at ADDR_9 allocated at strpool.c(4)
memalloc strpool.c(5): free 44 bytes at ADDR_8 allocated at strpool.c(4)
memalloc strpool.c(6): free 10 bytes at ADDR_163 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_162 allocated at strpool.c(2)
memalloc strpool.c(1): free 32 bytes at ADDR_3 allocated at strpool.c(1)
memalloc: cleanup
END

# delete directories and files
unlink_testfiles();
done_testing;
