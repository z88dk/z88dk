/*
Unit test for codearea.c

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/test_symtab.c,v 1.1 2014-06-14 11:54:29 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "listfile.h"
#include "model.h"
#include "module.h"
#include "options.h"
#include "sym.h"
#include "symref.h"
#include "symtab.h"

#include <glib.h>
#include <stdarg.h>
#include <stdio.h>

char *GetLibfile( char *filename ) { return ""; }
extern Symbol *_define_sym( char *name, long value, Byte type, Module *owner, SymbolHash **psymtab );

/* reuse string - test saving of keys by hash */
static char *S(char *str)
{
	static char buffer[MAXLINE];
	
	strcpy(buffer, str);		/* overwrite last string */
	return buffer;
}

static void dump_SymbolRefList ( SymbolRefList *references )
{
	SymbolRefListElem *iter;
	for ( iter = SymbolRefList_first(references); iter != NULL ; 
	      iter = SymbolRefList_next(iter) )
	{
		g_printerr("%d ", iter->obj->page_nr );
	}
}

static void dump_Symbol ( Symbol *sym )
{
	g_printerr("Symbol %s (%s) = %ld, type = 0x%02X [", 
		 sym->name, Symbol_fullname(sym), sym->value, sym->sym_type );
	if (sym->sym_type & SYM_DEFINED)	g_printerr("DEFINED ");
	if (sym->sym_type & SYM_TOUCHED)	g_printerr("TOUCHED ");
	if (sym->sym_type & SYM_DEFINE)		g_printerr("DEF ");
	if (sym->sym_type & SYM_ADDR)		g_printerr("ADDR ");
	if (sym->sym_type & SYM_LOCAL)		g_printerr("LOCAL ");
	if (sym->sym_type & SYM_PUBLIC)		g_printerr("GLOBAL ");
	if (sym->sym_type & SYM_EXTERN)		g_printerr("EXTERN ");
	g_printerr("], ref = [");
	dump_SymbolRefList(sym->references);
	g_printerr("], owner = %s\n", 
			sym->owner == NULL ? 
				"NULL" : 
				sym->owner == CURRENTMODULE ? 
					"CURRENTMODULE" : "?");
}

static void dump_SymbolHash ( SymbolHash *symtab, char *name )
{
	SymbolHashElem *iter;
	Symbol         *sym;

	g_printerr("Symtab \"%s\": %s\n", name, SymbolHash_empty(symtab) ? "EMPTY" : "" );
	for ( iter = SymbolHash_first( symtab ); iter; iter = SymbolHash_next( iter ) )
	{
		sym = (Symbol *)iter->value;
		if ( sym != SymbolHash_get( symtab, sym->name ) )
			g_printerr("ERROR: symbol %s not found in hash\n", sym->name);

		g_printerr("  ");
		dump_Symbol( sym );
	}	
}

static void dump_symtab ( void ) 
{
	dump_SymbolHash(global_symtab, "global tab");
	dump_SymbolHash(static_symtab, "static tab");
	dump_SymbolHash(CURRENTMODULE->local_symtab, "local tab");
}	

static void inc_page_nr( void )
{
	int cur_page_nr = list_get_page_nr();
	
	while ( list_get_page_nr() == cur_page_nr )
	{
		list_start_line(0, "", 0, "\n");
		list_end_line();
	}
}

static void test_symtab( void )
{
	Symbol *sym;
	SymbolHash *symtab, *symtab2;
	
	list_open("test.lst");
	opts.symtable = TRUE;
	opts.list     = TRUE;
	
	g_printerr("Create current module\n");	
	set_cur_module( new_module() );

	g_printerr("Create symbol\n");	
	sym = Symbol_create(S("Var1"), 123, 0, NULL);
	dump_Symbol(sym);
	OBJ_DELETE(sym);

	sym = Symbol_create(S("Var1"), 123, 0, CURRENTMODULE);
	dump_Symbol(sym);
	CURRENTMODULE->modname = "MODULE";
	dump_Symbol(sym);
	
	g_printerr("Delete symbol\n");	
	OBJ_DELETE(sym);
	
	g_printerr("Global symtab\n");	
	dump_SymbolHash(global_symtab, "global");
	dump_SymbolHash(static_symtab, "static");
	
	g_printerr("check case insensitive - CH_0024\n");
	symtab = OBJ_NEW(SymbolHash);
	g_assert( symtab );
	_define_sym(S("Var1"),  1, 0, NULL, &symtab); inc_page_nr();
	_define_sym(S("Var2"),  2, 0, NULL, &symtab); inc_page_nr(); 
	_define_sym(S("Var3"), -3, 0, NULL, &symtab); inc_page_nr();
	dump_SymbolHash(symtab, "tab1");
	
	g_assert( find_symbol(S("Var1"), symtab)->value ==  1 );
	g_assert( find_symbol(S("VAR1"), symtab)->value ==  1 );
	g_assert( find_symbol(S("var1"), symtab)->value ==  1 );

	g_assert( find_symbol(S("Var2"), symtab)->value ==  2 );
	g_assert( find_symbol(S("VAR2"), symtab)->value ==  2 );
	g_assert( find_symbol(S("var2"), symtab)->value ==  2 );

	g_assert( find_symbol(S("Var3"), symtab)->value == -3 );
	g_assert( find_symbol(S("VAR3"), symtab)->value == -3 );
	g_assert( find_symbol(S("var3"), symtab)->value == -3 );

	dump_SymbolHash(symtab, "tab1");
	
	g_printerr("Concat symbol tables\n");	
	symtab = OBJ_NEW(SymbolHash);
	g_assert( symtab );
	_define_sym(S("Var1"),  1, 0, NULL, &symtab); inc_page_nr();
	_define_sym(S("Var2"),  2, 0, NULL, &symtab); inc_page_nr(); 
	_define_sym(S("Var3"), -3, 0, NULL, &symtab); inc_page_nr();
	dump_SymbolHash(symtab, "tab1");
	
	symtab2 = OBJ_NEW(SymbolHash);
	g_assert( symtab2 );
	_define_sym(S("Var3"), 3, 0, NULL, &symtab2); inc_page_nr();
	_define_sym(S("Var4"), 4, 0, NULL, &symtab2); inc_page_nr();
	_define_sym(S("Var5"), 5, 0, NULL, &symtab2); inc_page_nr();
	dump_SymbolHash(symtab2, "tab2");
	
	SymbolHash_cat( &symtab, symtab2 );
	dump_SymbolHash(symtab, "merged_tab");
	
	OBJ_DELETE( symtab );
	OBJ_DELETE( symtab2 );
	
	g_printerr("Sort\n");	
	symtab = OBJ_NEW(SymbolHash);
	g_assert( symtab );
	_define_sym(S("One"), 	1, 0, NULL, &symtab); inc_page_nr();
	_define_sym(S("Two"),	2, 0, NULL, &symtab); inc_page_nr(); 
	_define_sym(S("Three"),	3, 0, NULL, &symtab); inc_page_nr();
	_define_sym(S("Four"),	4, 0, NULL, &symtab); inc_page_nr();
	dump_SymbolHash(symtab, "tab");
	
	SymbolHash_sort(symtab, SymbolHash_by_name);
	dump_SymbolHash(symtab, "tab by name");

	SymbolHash_sort(symtab, SymbolHash_by_value);
	dump_SymbolHash(symtab, "tab by value");

	OBJ_DELETE( symtab );

	g_printerr("Use local symbol before definition\n");
	_define_sym(S("WIN32"), 1, 0, NULL, &static_symtab); inc_page_nr();
	SymbolHash_cat( & CURRENTMODULE->local_symtab, static_symtab ); inc_page_nr();
	_define_sym(S("PC"), 0, 0, NULL, &global_symtab); inc_page_nr();
	find_symbol( S("PC"), global_symtab )->value += 3; inc_page_nr();
	find_symbol( S("PC"), global_symtab )->value += 3; inc_page_nr();
	sym = get_used_symbol(S("NN")); inc_page_nr();
	g_assert( sym != NULL );
	g_assert( ! (sym->sym_type & SYM_DEFINED) );
	find_symbol( S("PC"), global_symtab )->value += 3; inc_page_nr();
	sym = get_used_symbol(S("NN")); inc_page_nr();
	g_assert( sym != NULL );
	g_assert( ! (sym->sym_type & SYM_DEFINED) );
	find_symbol( S("PC"), global_symtab )->value += 3; inc_page_nr();
	define_symbol(S("NN"), find_symbol( "PC", global_symtab )->value, SYM_ADDR | SYM_TOUCHED ); 
	sym = get_used_symbol(S("NN")); inc_page_nr();
	g_assert( sym != NULL );
	dump_Symbol(sym);
	g_assert( sym->sym_type & SYM_DEFINED );
	
	dump_symtab();

	g_printerr("Delete Local\n");	
	remove_all_local_syms();
	dump_symtab();
	
	g_printerr("Delete Static\n");	
	remove_all_static_syms();
	dump_symtab();
	
	g_printerr("Delete Global\n");	
	remove_all_global_syms();
	dump_symtab();
	
	g_printerr("End\n");	

}

int main( int argc, char *argv[] )
{
	g_test_init( &argc, &argv, NULL );
	g_test_add_func( "/Symtab", test_symtab );

	return g_test_run();
}
