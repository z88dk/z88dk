/*
     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
                ZZZZZ      888           888  0000         0000
              ZZZZZ        88888888888888888  0000         0000
            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM

Copyright (C) Paulo Custodio, 2011-2014

Symbol table
Replaced avltree from original assembler by hash table because:
a) code simplicity
b) performance - avltree 50% slower when loading the symbols from the ZX 48 ROM assembly,
   see t\developer\benchmark_symtab.t

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/symtab.c,v 1.44 2014-07-06 22:48:54 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "errors.h"
#include "listfile.h"
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
DEF_CLASS_HASH( Symbol, TRUE );			/* defines SymbolHash */

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
*	marks looked-up symbol as SYM_TOUCHED
*----------------------------------------------------------------------------*/
Symbol *find_symbol( char *name, SymbolHash *symtab )
{
    Symbol *sym;

    sym = SymbolHash_get( symtab, name );

	/* Bodge for handling underscores (sdcc hack) */
    if ( sym == NULL && opts.sdcc && name[0] == '_' )
        sym = SymbolHash_get( symtab, name + 1 );

	if ( sym != NULL )
	{
		sym->sym_type_mask |= SYM_TOUCHED;
		if ( strcmp( sym->name, name ) != 0 )
			warn_symbol_diff_case( sym->name, name );
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
Symbol *_define_sym( char *name, long value, sym_type_t sym_type, Byte type_mask,
                     Module *module, Section *section,
					 SymbolHash **psymtab )
{
    Symbol *sym;

    sym = find_symbol( name, *psymtab );

    if ( sym == NULL )								/* new symbol */
    {
        sym = Symbol_create( name, value, sym_type, type_mask | SYM_DEFINED, 
							 module, section );
        SymbolHash_set( psymtab, name, sym );
    }
    else if ( !( sym->sym_type_mask & SYM_DEFINED ) )	/* already declared but not defined */
    {
        sym->value = value;
		sym->sym_type = MAX( sym->sym_type, sym_type );
        sym->sym_type_mask |= type_mask | SYM_DEFINED;
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

    /* add symbol references if listing */
    add_symbol_ref( sym->references, list_get_page_nr(), TRUE );

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
            sym = Symbol_create( name, 0, TYPE_UNKNOWN, SYM_NOTDEFINED, 
								 CURRENTMODULE, CURRENTSECTION );
            SymbolHash_set( & CURRENTMODULE->local_symtab, name, sym );
        }
    }

    /* add page references */
    add_symbol_ref( sym->references, list_get_page_nr(), FALSE );

    return sym;
}

/*-----------------------------------------------------------------------------
*   define a static symbol (from -D command line)
*----------------------------------------------------------------------------*/
Symbol *define_static_def_sym( char *name, long value )
{
    return _define_sym( name, value, TYPE_CONSTANT, SYM_DEFINE, 
						NULL, get_first_section(NULL), 
						& static_symtab );
}

/*-----------------------------------------------------------------------------
*   define a global static symbol (e.g. ASMSIZE, ASMTAIL)
*----------------------------------------------------------------------------*/
Symbol *define_global_def_sym( char *name, long value )
{
    return _define_sym( name, value, TYPE_CONSTANT, SYM_DEFINE, 
						NULL, get_first_section(NULL), 
						& global_symtab );
}

/*-----------------------------------------------------------------------------
*   define a local DEF symbol (e.g. DEFINE)
*----------------------------------------------------------------------------*/
Symbol *define_local_def_sym( char *name, long value )
{
    return _define_sym( name, value, TYPE_CONSTANT, SYM_DEFINE, 
						CURRENTMODULE, CURRENTSECTION, 
						& CURRENTMODULE->local_symtab );
}

/*-----------------------------------------------------------------------------
*   define a new symbol in the local or global tabs
*----------------------------------------------------------------------------*/
Symbol *define_local_sym( char *name, long value, sym_type_t sym_type, Byte type_mask )
{
    return _define_sym( name, value, sym_type, type_mask | SYM_LOCAL, 
						CURRENTMODULE, CURRENTSECTION, 
						& CURRENTMODULE->local_symtab );
}

Symbol *define_global_sym( char *name, long value, sym_type_t sym_type, Byte type_mask )
{
    return _define_sym( name, value, sym_type, type_mask | SYM_PUBLIC, 
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

		if ( cond( sym ) )
			SymbolHash_set( ptarget, Symbol_fullname( sym ), Symbol_clone( sym ) );
    }
}

/*-----------------------------------------------------------------------------
*   get the symbols for which the passed function returns TRUE,
*   mapped NAME@MODULE -> Symbol, needs to be deleted by OBJ_DELETE()
*----------------------------------------------------------------------------*/
SymbolHash *select_symbols( Bool (*cond)(Symbol *sym) )
{
    Module *module;
	ModuleListElem *iter;
    SymbolHash *all_syms = OBJ_NEW( SymbolHash );

	for ( module = get_first_module( &iter ) ; module != NULL ; 
		  module = get_next_module( &iter ) )
	{
		copy_full_sym_names( &all_syms, module->local_symtab, cond );
	}
    copy_full_sym_names( &all_syms, global_symtab, cond );

    return all_syms;
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
        _define_sym( sym->name, sym->value, sym->sym_type, sym->sym_type_mask, 
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
static void define_local_symbol( char *name, long value, sym_type_t sym_type, Byte type_mask )
{
    Symbol *sym;

    sym = find_symbol( name, CURRENTMODULE->local_symtab );

    if ( sym == NULL )					/* Symbol not declared as local */
    {
        /* create symbol */
        sym = Symbol_create( name, value, sym_type, type_mask | SYM_LOCAL | SYM_DEFINED, 
							 CURRENTMODULE, CURRENTSECTION );
        SymbolHash_set( & CURRENTMODULE->local_symtab, name, sym );

        /* First element in list is definition of symbol */
        add_symbol_ref( sym->references, list_get_page_nr(), TRUE );
    }
    else if ( sym->sym_type_mask & SYM_DEFINED )	/* local symbol already defined */
    {
        error_symbol_redefined( name );
    }
    else								/* symbol declared local, but not yet defined */
    {
        sym->value = value;
		sym->sym_type = MAX( sym->sym_type, sym_type );
        sym->sym_type_mask |= type_mask | SYM_LOCAL | SYM_DEFINED;	/* local symbol type set to address label or constant */
        sym->module  = CURRENTMODULE;						/* owner of symbol is always creator */
		sym->section = CURRENTSECTION;

        /* First element in list is definition of symbol */
        add_symbol_ref( sym->references, list_get_page_nr(), TRUE );
    }
}

/*-----------------------------------------------------------------------------
*   create a symbol in the local or global tree:
*   a) if not already global/extern, create in the local (CURRENTMODULE) symbol table
*   b) if declared global/extern and not defined, define now
*   c) if declared global/extern and defined -> error REDEFINED
*   d) if in global table and not global/extern -> define a new local symbol
*----------------------------------------------------------------------------*/
void define_symbol( char *name, long value, sym_type_t sym_type, Byte type_mask )
{
    Symbol     *sym;

    sym = find_symbol( name, global_symtab );

    if ( sym == NULL || 							/* Symbol not declared as global/extern */
		 ! (sym->sym_type_mask & SYM_PUBLIC) ) {	/* Symbol exixts in global but not public */

		/* the extern symbol is now no longer accessible */
        define_local_symbol( name, value, sym_type, type_mask );
    }
    else {											/* symbol declared global */
        if ( sym->sym_type_mask & SYM_DEFINED )	/* global symbol already defined */
        {
            error_symbol_redefined( name );
        }
        else							/* symbol declared global, but not yet defined */
        {
            sym->value = value;
			sym->sym_type = MAX( sym->sym_type, sym_type );
            sym->sym_type_mask |= type_mask | SYM_DEFINED;	/* defined, and typed as address label or constant */
            sym->module  = CURRENTMODULE;			/* owner of symbol is always creator */
			sym->section = CURRENTSECTION;

            /* First element in list is definition of symbol */
            add_symbol_ref( sym->references, list_get_page_nr(), TRUE );
        }
    }
}

/*-----------------------------------------------------------------------------
*   update a symbol value, used to compute EQU symbols
*----------------------------------------------------------------------------*/
void update_symbol( char *name, long value )
{
    Symbol *sym;

    sym = find_symbol( name, CURRENTMODULE->local_symtab );

	if ( sym == NULL )
		sym = find_symbol( name, global_symtab );

    if ( sym == NULL )
		error_org_not_defined();
	else
		sym->value = value;
}

/*-----------------------------------------------------------------------------
*   declare a PUBLIC symbol
*----------------------------------------------------------------------------*/
void declare_public_symbol( char *name )
{
    Symbol     *sym, *cloned_sym;

    sym = find_symbol( name, CURRENTMODULE->local_symtab );	/* search in local tab */

    if ( sym == NULL )
    {
        /* not local */
        sym = find_symbol( name, global_symtab );			/* search in global tab */

        if ( sym == NULL )
        {
            /* not local, not global -> declare symbol as global */
            sym = Symbol_create( name, 0, TYPE_UNKNOWN, SYM_PUBLIC, 
								 CURRENTMODULE, CURRENTSECTION );
            SymbolHash_set( &global_symtab, name, sym );
        }
        else
        {
            /* not local, global */
            if ( sym->module != CURRENTMODULE )
            {
                /* this symbol is declared in another module */
                if ( sym->sym_type_mask & SYM_EXTERN )
                {
                    sym->module  = CURRENTMODULE;	/* symbol now owned by this module */
					sym->section = CURRENTSECTION;
                    sym->sym_type_mask &= ~ SYM_EXTERN;	/* re-declare symbol as global if symbol was */
                    sym->sym_type_mask |= SYM_PUBLIC;	/* declared extern in another module */
                }
                else								/* cannot declare two identical global's */
                {
                    /* Already declared global - no possible path, as global tab is 
					   deleted between modules assembly */
                    assert(0);
                }
            }
            else if ( ( sym->sym_type_mask & SYM_PUBLIC ) != SYM_PUBLIC )
            {
                /* re-declaration not allowed */
                error_symbol_redecl( name );
            }
        }
    }
    else
    {
        /* local */
        cloned_sym = find_symbol( name, global_symtab );

        if ( cloned_sym == NULL )
        {
            /* local, not global */
            /* If no global symbol of identical name has been created, 
			   then re-declare local symbol as global symbol */
            sym->sym_type_mask &= ~ SYM_LOCAL;
            sym->sym_type_mask |= SYM_PUBLIC;
            cloned_sym = Symbol_create( sym->name, sym->value, sym->sym_type, sym->sym_type_mask, 
										sym->module, sym->section );
            SymbolHash_set( &global_symtab, name, cloned_sym );

            /* original local symbol cloned as global symbol, now delete old local ... */
            SymbolHash_remove( CURRENTMODULE->local_symtab, name );
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
void declare_extern_symbol( char *name )
{
    Symbol     *sym, *ext_sym;

    sym = find_symbol( name, CURRENTMODULE->local_symtab );	/* search in local tab */

    if ( sym == NULL )
    {
        /* not local */
        sym = find_symbol( name, global_symtab );			/* search in global tab */

        if ( sym == NULL )
        {
            /* not local, not global -> declare symbol as extern */
            sym = Symbol_create( name, 0, TYPE_UNKNOWN, SYM_EXTERN, 
								 CURRENTMODULE, CURRENTSECTION );
            SymbolHash_set( &global_symtab, name, sym );
        }
        else
        {
            /* not local, global */
            if ( sym->module == CURRENTMODULE )
            {
                if ( ( sym->sym_type_mask & SYM_EXTERN ) != SYM_EXTERN )
                {
                    /* Re-declaration not allowed */
                    error_symbol_redecl( name );
                }
            }
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
            if ( ( sym->sym_type_mask & SYM_DEFINED ) == 0 )
            {
                sym->sym_type_mask &= ~ SYM_LOCAL;
                sym->sym_type_mask |= SYM_EXTERN;
				ext_sym = Symbol_create( name, 0, sym->sym_type, sym->sym_type_mask, 
										 sym->module, sym->section );
                SymbolHash_set( &global_symtab, name, ext_sym );

                /* original local symbol cloned as external symbol, now delete old local ... */
                SymbolHash_remove( CURRENTMODULE->local_symtab, name );
            }
            else
            {
                /* already declared local */
                error_symbol_decl_local( name );
            }
        }
        else if ( ( sym->sym_type_mask & SYM_EXTERN ) != SYM_EXTERN )
        {
            /* re-declaration not allowed */
            error_symbol_redecl( name );
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
