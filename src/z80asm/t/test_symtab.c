/*
Z88DK Z80 Macro Assembler

Unit test for codearea.c

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#include "listfile.h"
#include "model.h"
#include "module.h"
#include "options.h"
#include "sym.h"
#include "symtab.h"

#include <assert.h>
#include <stdarg.h>
#include <stdio.h>

int sizeof_relocroutine = 0;
int sizeof_reloctable = 0;

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

static void dump_Symbol ( Symbol *sym )
{
	warn("Symbol %s (%s) = %ld, [", 
		 sym->name, Symbol_fullname(sym), sym->value );
	if (sym->is_defined)	warn("DEFINED ");
	if (sym->is_touched)	warn("TOUCHED ");
	if (sym->is_computed)	warn("COMPUTED ");

	switch (sym->type)
	{
	case TYPE_UNKNOWN:	warn("TYPE_UNKNOWN "); break;
	case TYPE_CONSTANT:	warn("TYPE_CONSTANT "); break;
	case TYPE_ADDRESS:	warn("TYPE_ADDRESS "); break;
	case TYPE_COMPUTED:	warn("TYPE_COMPUTED "); break;
	default: 			warn("invalid-type"); break;
	}

	switch (sym->scope)
	{
	case SCOPE_LOCAL:	warn("LOCAL ");  break;
	case SCOPE_PUBLIC:	warn("PUBLIC "); break;
	case SCOPE_EXTERN:	warn("EXTERN "); break;
	case SCOPE_GLOBAL:	warn("GLOBAL "); break;
	default: 			warn("invalid-scope"); break;
	}
	
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

static void test_symtab( void )
{
	Symbol *sym;
	SymbolHash *symtab, *symtab2;
	
	list_open("test.lis");
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
	_define_sym(S("Var1"), 1, TYPE_CONSTANT, 0, NULL, NULL, &symtab);
	_define_sym(S("var1"), 2, TYPE_CONSTANT, 0, NULL, NULL, &symtab);
	_define_sym(S("VAR1"), 3, TYPE_CONSTANT, 0, NULL, NULL, &symtab);
	dump_SymbolHash(symtab, "tab1");
	
	assert( find_symbol(S("Var1"), symtab)->value == 1 );
	assert( find_symbol(S("var1"), symtab)->value == 2 );
	assert( find_symbol(S("VAR1"), symtab)->value == 3 );

	dump_SymbolHash(symtab, "tab1");
	
	warn("Concat symbol tables\n");	
	symtab = OBJ_NEW(SymbolHash);
	assert( symtab );
	_define_sym(S("Var1"),  1, TYPE_CONSTANT, 0, NULL, NULL, &symtab);
	_define_sym(S("Var2"),  2, TYPE_CONSTANT, 0, NULL, NULL, &symtab);
	_define_sym(S("Var3"), -3, TYPE_CONSTANT, 0, NULL, NULL, &symtab);
	dump_SymbolHash(symtab, "tab1");
	
	symtab2 = OBJ_NEW(SymbolHash);
	assert( symtab2 );
	_define_sym(S("Var3"), 3, TYPE_CONSTANT, 0, NULL, NULL, &symtab2);
	_define_sym(S("Var4"), 4, TYPE_CONSTANT, 0, NULL, NULL, &symtab2);
	_define_sym(S("Var5"), 5, TYPE_CONSTANT, 0, NULL, NULL, &symtab2);
	dump_SymbolHash(symtab2, "tab2");
	
	SymbolHash_cat( &symtab, symtab2 );
	dump_SymbolHash(symtab, "merged_tab");
	
	OBJ_DELETE( symtab );
	OBJ_DELETE( symtab2 );
	
	warn("Sort\n");	
	symtab = OBJ_NEW(SymbolHash);
	assert( symtab );
	_define_sym(S("One"), 	1, TYPE_CONSTANT, 0, NULL, NULL, &symtab);
	_define_sym(S("Two"),	2, TYPE_CONSTANT, 0, NULL, NULL, &symtab); 
	_define_sym(S("Three"),	3, TYPE_CONSTANT, 0, NULL, NULL, &symtab);
	_define_sym(S("Four"),	4, TYPE_CONSTANT, 0, NULL, NULL, &symtab);
	dump_SymbolHash(symtab, "tab");
	
	SymbolHash_sort(symtab, SymbolHash_by_name);
	dump_SymbolHash(symtab, "tab by name");

	SymbolHash_sort(symtab, SymbolHash_by_value);
	dump_SymbolHash(symtab, "tab by value");

	OBJ_DELETE( symtab );

	warn("Use local symbol before definition\n");
	_define_sym(S("WIN32"), 1, TYPE_CONSTANT, 0, NULL, NULL, &static_symtab);
	SymbolHash_cat( & CURRENTMODULE->local_symtab, static_symtab );
	_define_sym(S("PC"), 0, TYPE_CONSTANT, 0, NULL, NULL, &global_symtab);
	find_symbol( S("PC"), global_symtab )->value += 3;
	find_symbol( S("PC"), global_symtab )->value += 3;
	sym = get_used_symbol(S("NN"));
	assert( sym != NULL );
	assert( ! sym->is_defined );
	find_symbol( S("PC"), global_symtab )->value += 3;
	sym = get_used_symbol(S("NN"));
	assert( sym != NULL );
	assert( ! sym->is_defined );
	find_symbol( S("PC"), global_symtab )->value += 3;
	sym = define_symbol(S("NN"), find_symbol( "PC", global_symtab )->value, TYPE_ADDRESS); 
	sym->is_touched = TRUE;
	sym = get_used_symbol(S("NN"));
	assert( sym != NULL );
	dump_Symbol(sym);
	assert( sym->is_defined );
	
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
	
	list_close(FALSE);

	warn("End\n");	

}

int main( int argc, char *argv[] )
{
	test_symtab();
	return 0;
}
