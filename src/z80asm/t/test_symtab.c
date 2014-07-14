/*
Unit test for codearea.c

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/test_symtab.c,v 1.6 2014-07-14 08:43:32 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "listfile.h"
#include "model.h"
#include "module.h"
#include "options.h"
#include "sym.h"
#include "symref.h"
#include "symtab.h"

#include <assert.h>
#include <stdarg.h>
#include <stdio.h>

char *GetLibfile( char *filename ) { return ""; }
extern Symbol *_define_sym( char *name, long value, sym_type_t sym_type, Byte type_mask,
                     Module *module, Section *section,
					 SymbolHash **psymtab );

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
		warn("%d ", iter->obj->page_nr );
	}
}

static void dump_Symbol ( Symbol *sym )
{
	warn("Symbol %s (%s) = %ld, type = 0x%02X [", 
		 sym->name, Symbol_fullname(sym), sym->value, sym->sym_type_mask );
	if (sym->sym_type_mask & SYM_DEFINED)	warn("DEFINED ");
	if (sym->sym_type_mask & SYM_TOUCHED)	warn("TOUCHED ");

	warn( sym->sym_type == TYPE_UNKNOWN		? "TYPE_UNKNOWN " :
		  sym->sym_type == TYPE_CONSTANT	? "TYPE_CONSTANT " :
		  sym->sym_type == TYPE_ADDRESS		? "TYPE_ADDRESS " :
		  sym->sym_type == TYPE_COMPUTED	? "TYPE_COMPUTED " :
											  "invalid-type " );

	if (sym->sym_type_mask & SYM_LOCAL)		warn("LOCAL ");
	if (sym->sym_type_mask & SYM_PUBLIC)	warn("GLOBAL ");
	if (sym->sym_type_mask & SYM_EXTERN)	warn("EXTERN ");
	warn("], ref = [");
	dump_SymbolRefList(sym->references);
	warn("], owner = %s\n", 
			sym->module == NULL ? 
				"NULL" : 
				sym->module == CURRENTMODULE ? 
					"CURRENTMODULE" : "?");
}

static void dump_SymbolHash ( SymbolHash *symtab, char *name )
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
	
	warn("Create current module\n");	
	set_cur_module( new_module() );

	warn("Create symbol\n");	
	sym = Symbol_create(S("Var1"), 123, TYPE_CONSTANT, 0, NULL, NULL);
	dump_Symbol(sym);
	OBJ_DELETE(sym);

	sym = Symbol_create(S("Var1"), 123, TYPE_CONSTANT, 0, CURRENTMODULE, NULL);
	dump_Symbol(sym);
	CURRENTMODULE->modname = "MODULE";
	dump_Symbol(sym);
	
	warn("Delete symbol\n");	
	OBJ_DELETE(sym);
	
	warn("Global symtab\n");	
	dump_SymbolHash(global_symtab, "global");
	dump_SymbolHash(static_symtab, "static");
	
	warn("check case insensitive - CH_0024\n");
	symtab = OBJ_NEW(SymbolHash);
	assert( symtab );
	_define_sym(S("Var1"),  1, TYPE_CONSTANT, 0, NULL, NULL, &symtab); inc_page_nr();
	_define_sym(S("Var2"),  2, TYPE_CONSTANT, 0, NULL, NULL, &symtab); inc_page_nr(); 
	_define_sym(S("Var3"), -3, TYPE_CONSTANT, 0, NULL, NULL, &symtab); inc_page_nr();
	dump_SymbolHash(symtab, "tab1");
	
	assert( find_symbol(S("Var1"), symtab)->value ==  1 );
	assert( find_symbol(S("VAR1"), symtab)->value ==  1 );
	assert( find_symbol(S("var1"), symtab)->value ==  1 );

	assert( find_symbol(S("Var2"), symtab)->value ==  2 );
	assert( find_symbol(S("VAR2"), symtab)->value ==  2 );
	assert( find_symbol(S("var2"), symtab)->value ==  2 );

	assert( find_symbol(S("Var3"), symtab)->value == -3 );
	assert( find_symbol(S("VAR3"), symtab)->value == -3 );
	assert( find_symbol(S("var3"), symtab)->value == -3 );

	dump_SymbolHash(symtab, "tab1");
	
	warn("Concat symbol tables\n");	
	symtab = OBJ_NEW(SymbolHash);
	assert( symtab );
	_define_sym(S("Var1"),  1, TYPE_CONSTANT, 0, NULL, NULL, &symtab); inc_page_nr();
	_define_sym(S("Var2"),  2, TYPE_CONSTANT, 0, NULL, NULL, &symtab); inc_page_nr(); 
	_define_sym(S("Var3"), -3, TYPE_CONSTANT, 0, NULL, NULL, &symtab); inc_page_nr();
	dump_SymbolHash(symtab, "tab1");
	
	symtab2 = OBJ_NEW(SymbolHash);
	assert( symtab2 );
	_define_sym(S("Var3"), 3, TYPE_CONSTANT, 0, NULL, NULL, &symtab2); inc_page_nr();
	_define_sym(S("Var4"), 4, TYPE_CONSTANT, 0, NULL, NULL, &symtab2); inc_page_nr();
	_define_sym(S("Var5"), 5, TYPE_CONSTANT, 0, NULL, NULL, &symtab2); inc_page_nr();
	dump_SymbolHash(symtab2, "tab2");
	
	SymbolHash_cat( &symtab, symtab2 );
	dump_SymbolHash(symtab, "merged_tab");
	
	OBJ_DELETE( symtab );
	OBJ_DELETE( symtab2 );
	
	warn("Sort\n");	
	symtab = OBJ_NEW(SymbolHash);
	assert( symtab );
	_define_sym(S("One"), 	1, TYPE_CONSTANT, 0, NULL, NULL, &symtab); inc_page_nr();
	_define_sym(S("Two"),	2, TYPE_CONSTANT, 0, NULL, NULL, &symtab); inc_page_nr(); 
	_define_sym(S("Three"),	3, TYPE_CONSTANT, 0, NULL, NULL, &symtab); inc_page_nr();
	_define_sym(S("Four"),	4, TYPE_CONSTANT, 0, NULL, NULL, &symtab); inc_page_nr();
	dump_SymbolHash(symtab, "tab");
	
	SymbolHash_sort(symtab, SymbolHash_by_name);
	dump_SymbolHash(symtab, "tab by name");

	SymbolHash_sort(symtab, SymbolHash_by_value);
	dump_SymbolHash(symtab, "tab by value");

	OBJ_DELETE( symtab );

	warn("Use local symbol before definition\n");
	_define_sym(S("WIN32"), 1, TYPE_CONSTANT, 0, NULL, NULL, &static_symtab); inc_page_nr();
	SymbolHash_cat( & CURRENTMODULE->local_symtab, static_symtab ); inc_page_nr();
	_define_sym(S("PC"), 0, TYPE_CONSTANT, 0, NULL, NULL, &global_symtab); inc_page_nr();
	find_symbol( S("PC"), global_symtab )->value += 3; inc_page_nr();
	find_symbol( S("PC"), global_symtab )->value += 3; inc_page_nr();
	sym = get_used_symbol(S("NN")); inc_page_nr();
	assert( sym != NULL );
	assert( ! (sym->sym_type_mask & SYM_DEFINED) );
	find_symbol( S("PC"), global_symtab )->value += 3; inc_page_nr();
	sym = get_used_symbol(S("NN")); inc_page_nr();
	assert( sym != NULL );
	assert( ! (sym->sym_type_mask & SYM_DEFINED) );
	find_symbol( S("PC"), global_symtab )->value += 3; inc_page_nr();
	define_symbol(S("NN"), find_symbol( "PC", global_symtab )->value, TYPE_ADDRESS, SYM_TOUCHED ); 
	sym = get_used_symbol(S("NN")); inc_page_nr();
	assert( sym != NULL );
	dump_Symbol(sym);
	assert( sym->sym_type_mask & SYM_DEFINED );
	
	dump_symtab();

	warn("Delete Local\n");	
	remove_all_local_syms();
	dump_symtab();
	
	warn("Delete Static\n");	
	remove_all_static_syms();
	dump_symtab();
	
	warn("Delete Global\n");	
	remove_all_global_syms();
	dump_symtab();
	
	warn("End\n");	

}

int main( int argc, char *argv[] )
{
	test_symtab();
	return 0;
}
