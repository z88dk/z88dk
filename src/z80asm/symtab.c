/*
Z88-DK Z80ASM - Z80 Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

Symbol table
Replaced avltree from original assembler by hash table because:
a) code simplicity
b) performance - avltree 50% slower when loading the symbols from the ZX 48 ROM assembly,
   see t\developer\benchmark_symtab.t
*/

#include "errors.h"
#include "listfile.h"
#include "fileutil.h"
#include "model.h"
#include "options.h"
#include "symbol.h"
#include "symtab.h"
#include "z80asm.h"

#include <assert.h>

/*-----------------------------------------------------------------------------
*   Global Symbol Tables
*----------------------------------------------------------------------------*/
SymbolHash *global_symtab = NULL;
SymbolHash *static_symtab = NULL;

/*-----------------------------------------------------------------------------
*   Symbol Table
*----------------------------------------------------------------------------*/
DEF_CLASS_HASH( Symbol, FALSE );			/* defines SymbolHash */

/*-----------------------------------------------------------------------------
*   join two symbol tables, adding all symbols from source to the target
*   symbol table; if symbols with the same name exist, the one from source
*   overwrites the one at target
*----------------------------------------------------------------------------*/
void SymbolHash_cat( SymbolHash **ptarget, SymbolHash *source )
{
    SymbolHashElem *iter;
    Symbol         *sym;

    for ( iter = SymbolHash_first( source ); iter; iter = SymbolHash_next( iter ) )
    {
        sym = ( Symbol * )iter->value;
        SymbolHash_set( ptarget, sym->name, Symbol_clone( sym ) );
    }
}

/*-----------------------------------------------------------------------------
*   return pointer to found symbol in a symbol tree, otherwise NULL if not found
*	marks looked-up symbol as is_touched
*----------------------------------------------------------------------------*/
Symbol *find_symbol( char *name, SymbolHash *symtab )
{
    Symbol *sym;

    sym = SymbolHash_get( symtab, name );
	if ( sym != NULL )
	{
		sym->is_touched = TRUE;
		if ( strcmp( sym->name, name ) != 0 )
			warn_symbol_different( sym->name, name );
	}

    return sym;
}

Symbol *find_local_symbol( char *name )
{
    return find_symbol( name, CURRENTMODULE->local_symtab );
}

Symbol *find_global_symbol( char *name )
{
    return find_symbol( name, global_symtab );
}

/*-----------------------------------------------------------------------------
*   create a symbol in the given table, error if already defined
*----------------------------------------------------------------------------*/
Symbol *_define_sym(char *name, long value, sym_type_t type, sym_scope_t scope,
                     Module *module, Section *section,
					 SymbolHash **psymtab )
{
    Symbol *sym;

    sym = find_symbol( name, *psymtab );

    if ( sym == NULL )								/* new symbol */
    {
		sym = Symbol_create(name, value, type, scope, module, section);
		sym->is_defined = TRUE;
        SymbolHash_set( psymtab, name, sym );
    }
    else if ( ! sym->is_defined )	/* already declared but not defined */
    {
        sym->value = value;
		sym->type = MAX( sym->type, type );
        sym->scope = scope;
		sym->is_defined = TRUE;
        sym->module = module;
		sym->section = section;
    }
    else											/* already defined */
    {
        if ( sym->module && sym->module != module && sym->module->modname )
            error_symbol_redefined_module( name, sym->module->modname );
        else
            error_symbol_redefined( name );
    }

    return sym;
}

/*-----------------------------------------------------------------------------
*   refer to a symbol in an expression
*   search for symbol in either local tree or global table,
*   create undefined symbol if not found, return symbol
*----------------------------------------------------------------------------*/
Symbol *get_used_symbol( char *name )
{
    Symbol     *sym;

    sym = find_symbol( name, CURRENTMODULE->local_symtab );	/* search in local tab */

    if ( sym == NULL )
    {
        /* not local */
        sym = find_symbol( name, global_symtab );			/* search in global tab */

        if ( sym == NULL )
        {
            sym = Symbol_create( name, 0, TYPE_UNKNOWN, SCOPE_LOCAL, 
								 CURRENTMODULE, CURRENTSECTION );
            SymbolHash_set( & CURRENTMODULE->local_symtab, name, sym );
        }
    }

    return sym;
}

/*-----------------------------------------------------------------------------
*   define a static symbol (from -D command line)
*----------------------------------------------------------------------------*/
Symbol *define_static_def_sym( char *name, long value )
{
    return _define_sym( name, value, TYPE_CONSTANT, SCOPE_LOCAL, 
						NULL, get_first_section(NULL), 
						& static_symtab );
}

/*-----------------------------------------------------------------------------
*   define a global static symbol (e.g. ASMSIZE, ASMTAIL)
*----------------------------------------------------------------------------*/
Symbol *define_global_def_sym( char *name, long value )
{
	Symbol* sym = _define_sym(name, value, TYPE_CONSTANT, SCOPE_PUBLIC,
						NULL, get_first_section(NULL), 
						& global_symtab );
	sym->is_global_def = TRUE;
	return sym;
}

/*-----------------------------------------------------------------------------
*   define a local DEF symbol (e.g. DEFINE)
*----------------------------------------------------------------------------*/
Symbol *define_local_def_sym( char *name, long value )
{
	return _define_sym(name, value, TYPE_CONSTANT, SCOPE_LOCAL,
						CURRENTMODULE, CURRENTSECTION, 
						& CURRENTMODULE->local_symtab );
}

/*-----------------------------------------------------------------------------
*   define a new symbol in the local or global tabs
*----------------------------------------------------------------------------*/
Symbol *define_local_sym(char *name, long value, sym_type_t type)
{
	return _define_sym(name, value, type, SCOPE_LOCAL,
						CURRENTMODULE, CURRENTSECTION, 
						& CURRENTMODULE->local_symtab );
}

Symbol *define_global_sym(char *name, long value, sym_type_t type)
{
	return _define_sym(name, value, type, SCOPE_PUBLIC,
						CURRENTMODULE, CURRENTSECTION, 
						& global_symtab );
}

/*-----------------------------------------------------------------------------
*   copy all SYM_ADDR symbols to target, replacing NAME by NAME@MODULE
*----------------------------------------------------------------------------*/
static void copy_full_sym_names( SymbolHash **ptarget, SymbolHash *source, 
								 Bool (*cond)(Symbol *sym) )
{
    SymbolHashElem *iter;
    Symbol         *sym;

    for ( iter = SymbolHash_first( source ); iter; iter = SymbolHash_next( iter ) )
    {
        sym = ( Symbol * )iter->value;

		if (sym->is_defined && cond(sym))
			SymbolHash_set(ptarget, Symbol_fullname(sym), Symbol_clone(sym));
    }
}

/*-----------------------------------------------------------------------------
*   get the symbols for which the passed function returns TRUE,
*   mapped NAME@MODULE -> Symbol, needs to be deleted by OBJ_DELETE()
*----------------------------------------------------------------------------*/
static SymbolHash *_select_module_symbols(Module *module, Bool(*cond)(Symbol *sym))
{
	ModuleListElem *iter;
	SymbolHash *all_syms = OBJ_NEW(SymbolHash);

	if (module == NULL) {
		for (module = get_first_module(&iter); module != NULL; module = get_next_module(&iter))
			copy_full_sym_names(&all_syms, module->local_symtab, cond);
	}
	else {
		copy_full_sym_names(&all_syms, module->local_symtab, cond);
	}
	copy_full_sym_names(&all_syms, global_symtab, cond);

	return all_syms;
}

SymbolHash *select_symbols( Bool (*cond)(Symbol *sym) )
{
	return _select_module_symbols(NULL, cond);
}

SymbolHash *select_module_symbols(Module *module, Bool(*cond)(Symbol *sym))
{
	return _select_module_symbols(module, cond);
}

/*-----------------------------------------------------------------------------
*   copy the static symbols to CURRENTMODULE->local_symtab
*----------------------------------------------------------------------------*/
void copy_static_syms( void )
{
    SymbolHashElem *iter;
    Symbol         *sym;

    for ( iter = SymbolHash_first( static_symtab ); iter; iter = SymbolHash_next( iter ) )
    {
        sym = ( Symbol * )iter->value;
        _define_sym( sym->name, sym->value, sym->type, sym->scope, 
					 CURRENTMODULE, CURRENTSECTION, 
					 & CURRENTMODULE->local_symtab );
    }
}

/*-----------------------------------------------------------------------------
*   delete the static and global symbols
*----------------------------------------------------------------------------*/
void remove_all_local_syms( void )
{
    SymbolHash_remove_all( CURRENTMODULE->local_symtab );
}
void remove_all_static_syms( void )
{
    SymbolHash_remove_all( static_symtab );
}
void remove_all_global_syms( void )
{
    SymbolHash_remove_all( global_symtab );
}

/*-----------------------------------------------------------------------------
*   create a local symbol:
*   a) if not yet in the local table (CURRENTMODULE), create it
*   b) if in the local table but not yet defined, create now (was a reference)
*   c) else error REDEFINED
*----------------------------------------------------------------------------*/
static Symbol *define_local_symbol(char *name, long value, sym_type_t type)
{
    Symbol *sym;

    sym = find_symbol( name, CURRENTMODULE->local_symtab );

    if ( sym == NULL )					/* Symbol not declared as local */
    {
        /* create symbol */
		sym = Symbol_create(name, value, type, SCOPE_LOCAL, CURRENTMODULE, CURRENTSECTION);
		sym->is_defined = TRUE;
		SymbolHash_set(&CURRENTMODULE->local_symtab, name, sym);
    }
    else if ( sym->is_defined )			/* local symbol already defined */
    {
        error_symbol_redefined( name );
    }
    else								/* symbol declared local, but not yet defined */
    {
        sym->value = value;
		sym->type = MAX( sym->type, type );
		sym->scope = SCOPE_LOCAL;
		sym->is_defined = TRUE;
        sym->module  = CURRENTMODULE;						/* owner of symbol is always creator */
		sym->section = CURRENTSECTION;
    }

	return sym;
}

/*-----------------------------------------------------------------------------
*   create a symbol in the local or global tree:
*   a) if not already global/extern, create in the local (CURRENTMODULE) symbol table
*   b) if declared global/extern and not defined, define now
*   c) if declared global/extern and defined -> error REDEFINED
*   d) if in global table and not global/extern -> define a new local symbol
*----------------------------------------------------------------------------*/
Symbol *define_symbol(char *name, long value, sym_type_t type)
{
    Symbol     *sym;

    sym = find_symbol( name, global_symtab );

	if (sym == NULL)						/* Symbol not declared as global/extern */
	{
		sym = define_local_symbol(name, value, type);
	}
	else if (sym->is_defined)				/* global symbol already defined */
	{
		error_symbol_redefined(name);
	}
	else
	{
		sym->value = value;
		sym->type = MAX(sym->type, type);
		sym->scope = SCOPE_PUBLIC;			/* already in global, must be public */
		sym->is_defined = TRUE;
		sym->module = CURRENTMODULE;		/* owner of symbol is always creator */
		sym->section = CURRENTSECTION;
	}

	return sym;
}

/*-----------------------------------------------------------------------------
*   update a symbol value, used to compute EQU symbols
*----------------------------------------------------------------------------*/
void update_symbol( char *name, long value, sym_type_t type )
{
    Symbol *sym;

    sym = find_symbol( name, CURRENTMODULE->local_symtab );

	if ( sym == NULL )
		sym = find_symbol( name, global_symtab );

    if ( sym == NULL )
		error_not_defined(name);
	else
	{
		sym->value = value;
		sym->type = type;
		sym->is_computed = TRUE;
	}
}

/*-----------------------------------------------------------------------------
*   declare a GLOBAL symbol
*----------------------------------------------------------------------------*/
void declare_global_symbol(char *name)
{
	Symbol     *sym, *global_sym;

	sym = find_symbol(name, CURRENTMODULE->local_symtab);	/* search in local tab */

	if (sym == NULL)
	{
		/* not local */
		sym = find_symbol(name, global_symtab);			/* search in global tab */

		if (sym == NULL)
		{
			/* not local, not global -> declare symbol as global */
			sym = Symbol_create(name, 0, TYPE_UNKNOWN, SCOPE_GLOBAL, CURRENTMODULE, CURRENTSECTION);
			SymbolHash_set(&global_symtab, name, sym);
		}
		else if (sym->module == CURRENTMODULE && (sym->scope == SCOPE_PUBLIC || sym->scope == SCOPE_EXTERN))
		{
			/* Aready declared PUBLIC or EXTERN, ignore GLOBAL declaration */
		}
		else if (sym->module != CURRENTMODULE || sym->scope != SCOPE_GLOBAL)
		{
			error_symbol_redecl(name);
		}
		else
		{
			sym->scope = SCOPE_GLOBAL;
		}
	}
	else
	{
		/* local */
		global_sym = find_symbol(name, global_symtab);

		if (global_sym == NULL)
		{
			/* local, not global */
			/* If no global symbol of identical name has been created,
			then re-declare local symbol as global symbol */
			sym->scope = SCOPE_GLOBAL;

			global_sym = SymbolHash_extract(CURRENTMODULE->local_symtab, name);
			assert(global_sym == sym);

			SymbolHash_set(&global_symtab, name, sym);
		}
		else
		{
			/* local, global - no possible path, as if local & not global,
			symbol is moved local -> global */
			assert(0);
		}
	}
}

/*-----------------------------------------------------------------------------
*   declare a PUBLIC symbol
*----------------------------------------------------------------------------*/
void declare_public_symbol(char *name)
{
	Symbol     *sym, *global_sym;

	sym = find_symbol(name, CURRENTMODULE->local_symtab);	/* search in local tab */

	if (sym == NULL)
	{
		/* not local */
		sym = find_symbol(name, global_symtab);			/* search in global tab */

		if (sym == NULL)
		{
			/* not local, not global -> declare symbol as global */
			sym = Symbol_create(name, 0, TYPE_UNKNOWN, SCOPE_PUBLIC, CURRENTMODULE, CURRENTSECTION);
			SymbolHash_set(&global_symtab, name, sym);
		}
		else if (sym->module == CURRENTMODULE && sym->scope == SCOPE_EXTERN)
		{
			/* Declared already EXTERN in the same module, change to PUBLIC */
			sym->scope = SCOPE_PUBLIC;
		}
		else if (sym->module == CURRENTMODULE && sym->scope == SCOPE_GLOBAL)
		{
			/* Declared already GLOBAL in the same module, ignore */
		}
		else if (sym->module != CURRENTMODULE || sym->scope != SCOPE_PUBLIC)
		{
			error_symbol_redecl(name);
		}
		else
		{
			sym->scope = SCOPE_PUBLIC;
		}
	}
	else
	{
		/* local */
		global_sym = find_symbol(name, global_symtab);

		if (global_sym == NULL)
		{
			/* local, not global */
			/* If no global symbol of identical name has been created,
			   then re-declare local symbol as global symbol */
			sym->scope = SCOPE_PUBLIC;

			global_sym = SymbolHash_extract(CURRENTMODULE->local_symtab, name);
			assert(global_sym == sym);

			SymbolHash_set(&global_symtab, name, sym);
		}
		else
		{
			/* local, global - no possible path, as if local & not global,
			   symbol is moved local -> global */
			assert(0);
		}
	}
}

/*-----------------------------------------------------------------------------
*   declare an EXTERN symbol
*----------------------------------------------------------------------------*/
void declare_extern_symbol(char *name)
{
	Symbol     *sym, *ext_sym;

	sym = find_symbol(name, CURRENTMODULE->local_symtab);	/* search in local tab */

	if (sym == NULL)
	{
		/* not local */
		sym = find_symbol(name, global_symtab);			/* search in global tab */

		if (sym == NULL)
		{
			/* not local, not global -> declare symbol as extern */
			sym = Symbol_create(name, 0, TYPE_CONSTANT, SCOPE_EXTERN, CURRENTMODULE, CURRENTSECTION);
			SymbolHash_set(&global_symtab, name, sym);
		}
		else if (sym->module == CURRENTMODULE && (sym->scope == SCOPE_PUBLIC || sym->scope == SCOPE_GLOBAL))
		{
			/* Declared already PUBLIC or GLOBAL in the same module, ignore EXTERN */
		}
		else if (sym->module != CURRENTMODULE || sym->scope != SCOPE_EXTERN)
		{
			error_symbol_redecl(name);
		}
		else
		{
			sym->scope = SCOPE_EXTERN;
		}
    }
    else
    {
        /* local */
        ext_sym = find_symbol( name, global_symtab );

        if ( ext_sym == NULL )
        {
            /* If no external symbol of identical name has been declared, then re-declare local
               symbol as external symbol, but only if local symbol is not defined yet */
            if ( ! sym->is_defined )
            {
				sym->type = TYPE_CONSTANT;
				sym->scope = SCOPE_EXTERN;
				
				ext_sym = SymbolHash_extract( CURRENTMODULE->local_symtab, name );
				assert(ext_sym == sym);

                SymbolHash_set( &global_symtab, name, sym );
            }
            else
            {
                /* already declared local */
                error_symbol_decl_local( name );
            }
        }
        else 
        {
			/* re-declaration not allowed */
			error_symbol_redecl(name);
		}
    }
}

/*-----------------------------------------------------------------------------
*   sort functions for SymbolHash_sort
*----------------------------------------------------------------------------*/
int SymbolHash_by_name( SymbolHashElem *a, SymbolHashElem *b )
{
    return strcmp( a->key, b->key );
}

int SymbolHash_by_value( SymbolHashElem *a, SymbolHashElem *b )
{
    return ( ( Symbol * )( a->value ) )->value - ( ( Symbol * )( b->value ) )->value;
}

/*-----------------------------------------------------------------------------
*   generate output files with lists of symbols
*----------------------------------------------------------------------------*/
static void _write_symbol_file(char *filename, Module *module, Bool(*cond)(Symbol *sym),
							   char *prefix, Bool type_flag) 
{
	FILE *file;
	SymbolHash *symbols;
	SymbolHashElem *iter;
	Symbol         *sym;
	long			reloc_offset;

	if (opts.relocatable && module == NULL)		// module is NULL in link phase
		reloc_offset = sizeof_relocroutine + sizeof_reloctable + 4;
	else
		reloc_offset = 0;

	file = myfopen(filename, "w");
	if (file)
	{
		symbols = select_module_symbols(module, cond);

		/* write symbols numerically, then alphabetical */
		SymbolHash_sort(symbols, SymbolHash_by_name);
		SymbolHash_sort(symbols, SymbolHash_by_value);

		for (iter = SymbolHash_first(symbols); iter; iter = SymbolHash_next(iter))
		{
			sym = (Symbol *)iter->value;
			fprintf(file, "%s%-*s = $%04lX ; %c %s\n",
				prefix,
				COLUMN_WIDTH - 1, sym->name,
				sym->value + reloc_offset,
				(!type_flag) ? ' ' : (sym->scope == SCOPE_LOCAL) ? 'L' : 'G',
				(module == NULL && sym->module != NULL) ? sym->module->modname : "");
		}

		OBJ_DELETE(symbols);

		myfclose(file);
	}
}

/*-----------------------------------------------------------------------------
*   Write symbols to files
*----------------------------------------------------------------------------*/
static Bool cond_all_symbols(Symbol *sym) { return TRUE; }

void write_map_file(void)
{
	_write_symbol_file(
		get_map_filename(get_first_module(NULL)->filename),
		NULL, cond_all_symbols, "", TRUE);
}

static Bool cond_global_symbols(Symbol *sym)
{
	return !(sym->is_global_def) && (sym->scope == SCOPE_PUBLIC || sym->scope == SCOPE_GLOBAL);
}

void write_def_file(void)
{
	_write_symbol_file(
		get_def_filename(get_first_module(NULL)->filename),
		NULL, cond_global_symbols, "DEFC ", FALSE);
}

static Bool cond_module_symbols(Symbol *sym) 
{
	if (sym->is_touched 
		&& (sym->scope == SCOPE_LOCAL || sym->scope == SCOPE_PUBLIC 
			|| (sym->scope == SCOPE_GLOBAL && sym->is_defined)))
		return TRUE;
	else
		return FALSE;
}

void write_sym_file(Module *module)
{
	_write_symbol_file(
		get_sym_filename(module->filename),
		module, cond_module_symbols, "", TRUE);
}
