/*
Z88-DK Z80ASM - Z80 Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2022
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

Symbol table
Replaced avltree from original assembler by hash table because:
a) code simplicity
b) performance - avltree 50% slower when loading the symbols from the ZX 48 ROM assembly,
   see t\developer\benchmark_symtab.t
*/

#include "die.h"
#include "fileutil.h"
#include "if.h"
#include "options.h"
#include "reloc_code.h"
#include "str.h"
#include "symbol.h"
#include "symtab.h"
#include "z80asm.h"
#include "zutils.h"

#define COLUMN_WIDTH	32

/*-----------------------------------------------------------------------------
*   Global Symbol Tables
*----------------------------------------------------------------------------*/
SymbolHash *global_symtab = NULL;
SymbolHash *static_symtab = NULL;

/*-----------------------------------------------------------------------------
*   Symbol Table
*----------------------------------------------------------------------------*/
DEF_CLASS_HASH( Symbol, false );			/* defines SymbolHash */

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
Symbol* find_symbol(const char* name, SymbolHash* symtab) {
	Symbol* sym = SymbolHash_get(symtab, name);
	if (sym != NULL)
		sym->is_touched = true;
	return sym;
}

Symbol *find_local_symbol(const char *name )
{
    return find_symbol( name, CURRENTMODULE->local_symtab );
}

Symbol *find_global_symbol(const char *name )
{
    return find_symbol( name, global_symtab );
}

/*-----------------------------------------------------------------------------
*   create a symbol in the given table, error if already defined
*----------------------------------------------------------------------------*/
Symbol *_define_sym(const char *name, long value, sym_type_t type, sym_scope_t scope,
                     Module *module, Section *section,
					 SymbolHash **psymtab )
{
    Symbol *sym;

    sym = find_symbol( name, *psymtab );

    if ( sym == NULL )								/* new symbol */
    {
		sym = Symbol_create(name, value, type, scope, module, section);
		sym->is_defined = true;
        SymbolHash_set( psymtab, name, sym );
    }
    else if ( ! sym->is_defined )	/* already declared but not defined */
    {
        sym->value = value;
		sym->type = MAX( sym->type, type );
        sym->scope = scope;
		sym->is_defined = true;
        sym->module = module;
		sym->section = section;
		sym->filename = get_error_filename();
		sym->line_num = get_error_line_num();
    }
    else											/* already defined */
    {
        if (strncmp(name, "__CDBINFO__",11) == 0)
        {
            /* ignore duplicates of those */
            return sym;
        }

		if (sym->module && sym->module != module && sym->module->modname)
			error_duplicate_definition_module(sym->module->modname, name);
		else
			error_duplicate_definition(name);
    }

    return sym;
}

/*-----------------------------------------------------------------------------
*   refer to a symbol in an expression
*   search for symbol in either local tree or global table,
*   create undefined symbol if not found, return symbol
*----------------------------------------------------------------------------*/
Symbol *get_used_symbol(const char *name )
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
Symbol *define_static_def_sym(const char *name, long value )
{
    Symbol *sym = _define_sym( name, value, TYPE_CONSTANT, SCOPE_LOCAL, 
						NULL, get_first_section(NULL), 
						& static_symtab );
	if (opts.verbose) 
		printf("Predefined constant: %s = $%04X\n", name, (int)value);
	return sym;
}

/*-----------------------------------------------------------------------------
*   define a global static symbol (e.g. ASMSIZE, ASMTAIL)
*----------------------------------------------------------------------------*/
Symbol *define_global_def_sym(const char *name, long value )
{
	Symbol* sym = _define_sym(name, value, TYPE_CONSTANT, SCOPE_PUBLIC,
						NULL, get_first_section(NULL), 
						& global_symtab );
	sym->is_global_def = true;
	return sym;
}

/*-----------------------------------------------------------------------------
*   define a local DEF symbol (e.g. DEFINE)
*----------------------------------------------------------------------------*/
Symbol *define_local_def_sym(const char *name, long value )
{
	return _define_sym(name, value, TYPE_CONSTANT, SCOPE_LOCAL,
						CURRENTMODULE, CURRENTSECTION, 
						& CURRENTMODULE->local_symtab );
}

/*-----------------------------------------------------------------------------
*   define a new symbol in the local or global tabs
*----------------------------------------------------------------------------*/
Symbol *define_local_sym(const char *name, long value, sym_type_t type)
{
	return _define_sym(name, value, type, SCOPE_LOCAL,
						CURRENTMODULE, CURRENTSECTION, 
						& CURRENTMODULE->local_symtab );
}

Symbol *define_global_sym(const char *name, long value, sym_type_t type)
{
	return _define_sym(name, value, type, SCOPE_PUBLIC,
						CURRENTMODULE, CURRENTSECTION, 
						& global_symtab );
}

/*-----------------------------------------------------------------------------
*   copy all SYM_ADDR symbols to target, replacing NAME by NAME@MODULE
*----------------------------------------------------------------------------*/
static void copy_full_sym_names( SymbolHash **ptarget, SymbolHash *source, 
								 bool (*cond)(Symbol *sym) )
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
*   get the symbols for which the passed function returns true,
*   mapped NAME@MODULE -> Symbol, needs to be deleted by OBJ_DELETE()
*----------------------------------------------------------------------------*/
static SymbolHash *_select_module_symbols(Module *module, bool(*cond)(Symbol *sym))
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

SymbolHash *select_symbols( bool (*cond)(Symbol *sym) )
{
	return _select_module_symbols(NULL, cond);
}

SymbolHash *select_module_symbols(Module *module, bool(*cond)(Symbol *sym))
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
static Symbol* define_local_symbol(const char* name, long value, sym_type_t type)
{
	Symbol* sym;

	sym = find_symbol(name, CURRENTMODULE->local_symtab);

	if (sym == NULL)					/* Symbol not declared as local */
	{
		/* create symbol */
		sym = Symbol_create(name, value, type, SCOPE_LOCAL, CURRENTMODULE, CURRENTSECTION);
		sym->is_defined = true;
		SymbolHash_set(&CURRENTMODULE->local_symtab, name, sym);
	}
	else if (sym->is_defined)			/* local symbol already defined */
		error_duplicate_definition(name);
	else								/* symbol declared local, but not yet defined */
	{
		sym->value = value;
		sym->type = MAX(sym->type, type);
		sym->scope = SCOPE_LOCAL;
		sym->is_defined = true;
		sym->module = CURRENTMODULE;						/* owner of symbol is always creator */
		sym->section = CURRENTSECTION;
		sym->filename = get_error_filename();
		sym->line_num = get_error_line_num();
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
Symbol* define_symbol(const char* name, long value, sym_type_t type)
{
	Symbol* sym;

	sym = find_symbol(name, global_symtab);

	if (sym == NULL)						/* Symbol not declared as global/extern */
	{
		sym = define_local_symbol(name, value, type);
	}
	else if (sym->is_defined)				/* global symbol already defined */
	{
		if (strncmp(name, "__CDBINFO__", 11))
			error_duplicate_definition(name);
	}
	else
	{
		sym->value = value;
		sym->type = MAX(sym->type, type);
		sym->scope = SCOPE_PUBLIC;			/* already in global, must be public */
		sym->is_defined = true;
		sym->module = CURRENTMODULE;		/* owner of symbol is always creator */
		sym->section = CURRENTSECTION;
		sym->filename = get_error_filename();
		sym->line_num = get_error_line_num();
	}

	return sym;
}

/*-----------------------------------------------------------------------------
*   update a symbol value, used to compute EQU symbols
*----------------------------------------------------------------------------*/
void update_symbol(const char *name, long value, sym_type_t type )
{
    Symbol *sym;

    sym = find_symbol( name, CURRENTMODULE->local_symtab );

	if ( sym == NULL )
		sym = find_symbol( name, global_symtab );

    if ( sym == NULL )
		error_undefined_symbol(name);
	else
	{
		sym->value = value;
		sym->type = type;
		sym->is_computed = true;
	}
}

/*-----------------------------------------------------------------------------
*   declare a GLOBAL symbol
*----------------------------------------------------------------------------*/
void declare_global_symbol(const char *name)
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
			xassert(global_sym == sym);

			SymbolHash_set(&global_symtab, name, sym);
		}
		else
		{
			/* local, global - no possible path, as if local & not global,
			symbol is moved local -> global */
			xassert(0);
		}
	}
}

/*-----------------------------------------------------------------------------
*   declare a PUBLIC symbol
*----------------------------------------------------------------------------*/
void declare_public_symbol(const char *name)
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
			xassert(global_sym == sym);

			SymbolHash_set(&global_symtab, name, sym);
		}
		else
		{
			/* local, global - no possible path, as if local & not global,
			   symbol is moved local -> global */
			xassert(0);
		}
	}
}

/*-----------------------------------------------------------------------------
*   declare an EXTERN symbol
*----------------------------------------------------------------------------*/
void declare_extern_symbol(const char *name)
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
				xassert(ext_sym == sym);

                SymbolHash_set( &global_symtab, name, sym );
            }
            else
            {
                /* already declared local */
                error_symbol_redecl( name );
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
*   generate output files with lists of symbols
*----------------------------------------------------------------------------*/
static void _write_symbol_file(const char *filename, Module *module, bool(*cond)(Symbol *sym),
							   char *prefix, bool type_flag) 
{
	FILE *file;
	SymbolHash *symbols;
	SymbolHashElem *iter;
	Symbol         *sym;
	long			reloc_offset;
	STR_DEFINE(line, STR_SIZE);

	if (opts.relocatable && module == NULL)		// module is NULL in link phase
		reloc_offset = sizeof_relocroutine + sizeof_reloctable + 4;
	else
		reloc_offset = 0;

	if (opts.verbose)
		printf("Creating file '%s'\n", path_canon(filename));

	file = xfopen(filename, "w");

	symbols = select_module_symbols(module, cond);

	// show symbols in the order they appear in the source
	for (iter = SymbolHash_first(symbols); iter; iter = SymbolHash_next(iter))
	{
		sym = (Symbol *)iter->value;

		Str_set(line, prefix);
		Str_append_sprintf(line, "%-*s", COLUMN_WIDTH - 1, sym->name);
		Str_append_sprintf(line, " = $%04lX ", sym->value + reloc_offset);

		if (type_flag) {
			Str_append_sprintf(line, "; %s", sym_type_str[sym->type]);
			Str_append_sprintf(line, ", %s", sym_scope_str[sym->scope]);
			Str_append_sprintf(line, ", %s", sym->is_global_def ? "def" : "");
			Str_append_sprintf(line, ", %s", (module == NULL && sym->module != NULL) ? sym->module->modname : "");
			Str_append_sprintf(line, ", %s", sym->section->name);
			Str_append_sprintf(line, ", ");
			if (sym->filename && sym->filename[0]) {
				Str_append_sprintf(line, "%s:%d", sym->filename, sym->line_num);
			}
		}
		strstrip(Str_data(line));
		Str_sync_len(line);
		fprintf(file, "%s\n", Str_data(line));
	}

	OBJ_DELETE(symbols);

	xfclose(file);
}

/*-----------------------------------------------------------------------------
*   Write symbols to files
*----------------------------------------------------------------------------*/
static bool cond_all_symbols(Symbol *sym) { return true; }

void write_map_file(void) {
	const char* filename;
	if (opts.bin_file)
		filename = get_map_filename(opts.bin_file);
	else
		filename = get_map_filename(get_first_module(NULL)->filename);

	_write_symbol_file(filename, NULL, cond_all_symbols, "", true);
}

static bool cond_global_symbols(Symbol *sym)
{
	return !(sym->is_global_def) && (sym->scope == SCOPE_PUBLIC || sym->scope == SCOPE_GLOBAL);
}

void write_def_file(void) {
	const char* filename;
	if (opts.bin_file)
		filename = get_def_filename(opts.bin_file);
	else
		filename = get_def_filename(get_first_module(NULL)->filename);

	_write_symbol_file(filename, NULL, cond_global_symbols, "DEFC ", false);
}

static bool cond_module_symbols(Symbol *sym) 
{
	if (sym->is_touched 
		&& (sym->scope == SCOPE_LOCAL || sym->scope == SCOPE_PUBLIC 
			|| (sym->scope == SCOPE_GLOBAL && sym->is_defined)))
		return true;
	else
		return false;
}

void write_sym_file(Module *module)
{
	_write_symbol_file(
		get_sym_filename(module->filename),
		module, cond_module_symbols, "", true);
}

void check_undefined_symbols(SymbolHash *symtab)
{
	SymbolHashElem *iter;
	Symbol         *sym;

	for (iter = SymbolHash_first(symtab); iter; iter = SymbolHash_next(iter))
	{
		sym = (Symbol *)iter->value;

		if (sym->scope == SCOPE_PUBLIC && !sym->is_defined) {
			set_error_location(sym->filename, sym->line_num);
			error_undefined_symbol(sym->name);
		}
	}
	clear_error_location();
}
