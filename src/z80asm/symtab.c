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

Copyright (C) Paulo Custodio, 2011-2013

Symbol table
Replaced avltree from original assembler by hash table because:
a) code simplicity
b) performance - avltree 50% slower when loading the symbols from the ZX 48 ROM assembly,
   see t\developer\benchmark_symtab.t

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/symtab.c,v 1.2 2013-06-01 01:24:22 pauloscustodio Exp $
$Log: symtab.c,v $
Revision 1.2  2013-06-01 01:24:22  pauloscustodio
CH_0022 : Replace avltree by hash table for symbol table

Revision 1.1  2013/05/23 22:22:23  pauloscustodio
Move symbol to sym.c, rename to Symbol


*/

#include "memalloc.h"   /* before any other include */

#include "errors.h"
#include "listfile.h"
#include "options.h"
#include "symtab.h"
#include "z80asm.h"

/*-----------------------------------------------------------------------------
*   Symbol Table
*----------------------------------------------------------------------------*/
DEF_CLASS_HASH(Symbol);				/* defines SymbolHash */

/*-----------------------------------------------------------------------------
*   Global Symbol Tables
*----------------------------------------------------------------------------*/
#define DEF_GET_TAB(func)						\
	SymbolHash *func(void)						\
	{											\
		static SymbolHash *symtab = NULL;		\
												\
		if (symtab == NULL)						\
			symtab = OBJ_NEW(SymbolHash);		\
												\
		return symtab;							\
	}											\

DEF_GET_TAB(get_global_tab)
DEF_GET_TAB(get_static_tab)
#undef DEF_GET_TAB

/*-----------------------------------------------------------------------------
*   join two symbol tables, adding all symbols from source to the target 
*   symbol table; if symbols with the same name exist, the one from source 
*   overwrites the one at target
*----------------------------------------------------------------------------*/
void SymbolHash_cat( SymbolHash *target, SymbolHash *source )
{
	SymbolHashElem *iter;
	Symbol         *sym;

	for ( iter = SymbolHash_first( source ); iter; iter = SymbolHash_next( iter ) )
	{
		sym = (Symbol *)iter->value;
		SymbolHash_set( target, sym->name, Symbol_clone(sym) );
	}	
}


/*-----------------------------------------------------------------------------
*   return pointer to found symbol in a symbol tree, otherwise NULL if not found
*	marks looked-up symbol as SYMTOUCHED
*----------------------------------------------------------------------------*/
Symbol *find_symbol( char *name, SymbolHash *symtab )
{
    Symbol *sym;

	sym = SymbolHash_get( symtab, name );
	if ( sym != NULL )
		sym->type |= SYMTOUCHED;

	return sym;
}

/*-----------------------------------------------------------------------------
*   delete notdecl_tab symbol, if any with same name,
*	moving all page references to new defined symbol
*----------------------------------------------------------------------------*/
static void delete_notdecl_symbol ( Symbol *defined_symbol )
{
	Symbol *notdecl_sym;

	notdecl_sym = find_symbol( defined_symbol->name, CURRENTMODULE->notdecl_tab );
	if ( notdecl_sym != NULL )
	{
		/* move all references */
		cat_symbol_refs( defined_symbol->references, notdecl_sym->references );

		SymbolHash_remove( CURRENTMODULE->notdecl_tab, defined_symbol->name );
	}
}

/*-----------------------------------------------------------------------------
*   create a local symbol:
*   a) if not yet in the local table (CURRENTMODULE), create it
*   b) if in the local table but not yet defined, create now (was a reference)
*   c) else error REDEFINED
*----------------------------------------------------------------------------*/
static void define_local_symbol( char *name, long value, byte_t type )
{
    Symbol *sym;

	sym = find_symbol( name, CURRENTMODULE->local_tab );
	if ( sym == NULL )					/* Symbol not declared as local */
	{
		/* create symbol */
        sym = Symbol_create( name, value, type | SYMLOCAL | SYMDEFINED, CURRENTMODULE );
		SymbolHash_set( CURRENTMODULE->local_tab, name, sym );

        if ( option_symtable && option_list )
        {
            /* First element in list is definition of symbol */
			add_symbol_ref( sym->references, list_get_page_nr(), TRUE );
			
			/* Move page references from forward referenced symbol */
            delete_notdecl_symbol( sym );    
        }
	}
	else if ( sym->type & SYMDEFINED )	/* local symbol already defined */
    {
        error( ERR_SYMBOL_REDEFINED, name );
    }
	else								/* symbol declared local, but not yet defined */
	{
        sym->value = value;
        sym->type |= type | SYMLOCAL | SYMDEFINED;	/* local symbol type set to address label or constant */
        sym->owner = CURRENTMODULE;					/* owner of symbol is always creator */

        if ( option_symtable && option_list )
        {
            /* First element in list is definition of symbol */
			add_symbol_ref( sym->references, list_get_page_nr(), TRUE );
			
			/* Move page references from possible forward referenced symbol */
            delete_notdecl_symbol( sym );       
        }
	}
}

/*-----------------------------------------------------------------------------
*   create a symbol in the local or global tree:
*   a) if not already global/extern, create in the local (CURRENTMODULE) symbol table
*   b) if declared global/extern and not defined, define now
*   c) if declared global/extern and defined -> error REDEFINED
*   d) if in global table and not global/extern -> define a new local symbol
*----------------------------------------------------------------------------*/
void define_symbol( char *name, long value, byte_t type )
{
	SymbolHash *global_tab = get_global_tab();
	Symbol     *sym;

	sym = find_symbol( name, global_tab );
	if ( sym == NULL )					/* Symbol not declared as global/extern */
	{
        define_local_symbol( name, value, type );
	}
    else if ( sym->type & SYMXDEF )		/* symbol declared global */
    {
        if ( sym->type & SYMDEFINED )	/* global symbol already defined */
        {
			error( ERR_SYMBOL_REDEFINED, name );
		}
		else							/* symbol declared global, but not yet defined */
		{
            sym->value = value;
            sym->type |= type | SYMDEFINED;	/* defined, and typed as address label or constant */
            sym->owner = CURRENTMODULE;		/* owner of symbol is always creator */

            if ( option_symtable && option_list )
            {
				/* First element in list is definition of symbol */
                add_symbol_ref( sym->references, list_get_page_nr(), TRUE );     

				/* Move page references from possible forward referenced symbol  */
                delete_notdecl_symbol( sym );   
            }
		}
	}
	else								/* Extern declaration of symbol, now define local symbol. */
	{									/* the extern symbol is now no longer accessible */
        define_local_symbol( name, value, type );
    }
}

/*-----------------------------------------------------------------------------
*   create a SYMDEF symbol in the given table, error if already defined
*----------------------------------------------------------------------------*/
void define_def_symbol( char *name, long value, byte_t type, SymbolHash *symtab )
{
    Symbol *sym;

	sym = find_symbol( name, symtab );
	if ( sym != NULL )					/* Symbol already defined */
    {
        error( ERR_SYMBOL_REDEFINED, name );
    }
	else
	{
        sym = Symbol_create( name, value, type | SYMDEF | SYMDEFINED, NULL );
		SymbolHash_set( symtab, name, sym );
	}
}

/*-----------------------------------------------------------------------------
*   refer to a symbol in an expression
*   search for symbol in either local tree or global table, 
*   return found pointer if defined/declared, otherwise return NULL
*----------------------------------------------------------------------------*/
Symbol *get_used_symbol( char *name )
{
	SymbolHash *global_tab = get_global_tab();
    Symbol     *sym;

	sym = find_symbol( name, CURRENTMODULE->local_tab );	/* search in local tab */
    if ( sym == NULL )
    {
		/* not local */
		sym = find_symbol( name, global_tab );				/* search in global tab */
        if ( sym == NULL )
        {
			/* not local, not global -> add to not-declared list, only if listing */
            if ( option_symtable && option_list )
            {
				sym = find_symbol( name, CURRENTMODULE->notdecl_tab );
															/* search in not-declared tab */
                if ( sym == NULL )
                {
                    sym = Symbol_create( name, 0, SYM_NOTDEFINED, CURRENTMODULE );
					SymbolHash_set( CURRENTMODULE->notdecl_tab, name, sym );
                }
                else
                {
                    /* symbol found in forward referenced tree, note page reference */
					add_symbol_ref( sym->references, list_get_page_nr(), FALSE );
                }      
            }

            return NULL;
		}
	}

	/* add page references */
	if ( sym != NULL && option_symtable && option_list )
		add_symbol_ref( sym->references, list_get_page_nr(), FALSE );

	return sym;
}
			
/*-----------------------------------------------------------------------------
*   declare a global symbol; type = 0 for XDEF, SYMDEF for XLIB
*----------------------------------------------------------------------------*/
static void declare_global_symbol( char *name, byte_t type )
{
	SymbolHash *global_tab = get_global_tab();
    Symbol     *sym, *cloned_sym;

	sym = find_symbol( name, CURRENTMODULE->local_tab );	/* search in local tab */
    if ( sym == NULL )
    {
		/* not local */
		sym = find_symbol( name, global_tab );				/* search in global tab */
        if ( sym == NULL )
        {
			/* not local, not global -> declare symbol as global */
            sym = Symbol_create( name, 0, SYMXDEF | type, CURRENTMODULE );
			SymbolHash_set( global_tab, name, sym );
        }
        else
        {
			/* not local, global */
            if ( sym->owner != CURRENTMODULE )
            {
                /* this symbol is declared in another module */
                if ( sym->type & SYMXREF )
                {
                    sym->owner = CURRENTMODULE;		/* symbol now owned by this module */
                    sym->type &= XREF_OFF;			/* re-declare symbol as global if symbol was */
                    sym->type |= SYMXDEF | type;	/* declared extern in another module */
                }
                else								/* cannot declare two identical global's */
                {
					/* Already declared global - no possible path, as global tab is deleted between 
					   modules assembly */
					die( FatalErrorException, "not reached %s:%d", __FILE__, __LINE__ );
                }
            }
            else if ( ( sym->type & ( SYMXDEF | type ) ) != ( SYMXDEF | type ) )
            {
                /* re-declaration not allowed */
                error( ERR_SYMBOL_REDECL, name );
            }
        }
    }
    else
    {
        /* local */
		cloned_sym = find_symbol( name, global_tab );
        if ( cloned_sym == NULL )
        {
            /* local, not global */
            /* If no global symbol of identical name has been created, then re-declare local symbol as global symbol */
            sym->type &= SYMLOCAL_OFF;
            sym->type |= SYMXDEF;
            cloned_sym = Symbol_create( sym->name, sym->value, sym->type, CURRENTMODULE );
			SymbolHash_set( global_tab, name, cloned_sym );

            /* original local symbol cloned as global symbol, now delete old local ... */
			SymbolHash_remove( CURRENTMODULE->local_tab, name );
        }
        else
        {
            /* local, global - no possible path, as if local & not global, symbol is moved local -> global */
            die( FatalErrorException, "not reached %s:%d", __FILE__, __LINE__ );
        }
    }
}

/* declare a global symbol XDEF or XLIB */
void declare_global_obj_symbol( char *name ) { declare_global_symbol(name, 0); }
void declare_global_lib_symbol( char *name ) { declare_global_symbol(name, SYMDEF); }

/*-----------------------------------------------------------------------------
*   declare an external symbol; type = 0 for XREF, SYMDEF for LIB
*----------------------------------------------------------------------------*/
static void declare_extern_symbol( char *name, byte_t type )
{
	SymbolHash *global_tab = get_global_tab();
    Symbol     *sym, *ext_sym;

	sym = find_symbol( name, CURRENTMODULE->local_tab );	/* search in local tab */
    if ( sym == NULL )
    {
		/* not local */
		sym = find_symbol( name, global_tab );				/* search in global tab */
        if ( sym == NULL )
        {
			/* not local, not global -> declare symbol as extern */
            sym = Symbol_create( name, 0, SYMXREF | type, CURRENTMODULE );
			SymbolHash_set( global_tab, name, sym );
        }
        else
        {
			/* not local, global */
            if ( sym->owner == CURRENTMODULE )
            {
                if ( ( sym->type & ( SYMXREF | type ) ) != ( SYMXREF | type ) )
				{
                    if ( sdcc_hacks )
                    {
                        sym->type = SYMXREF | type ;
                    }
                    else
                    {
						/* Re-declaration not allowed */
                        error( ERR_SYMBOL_REDECL, name );
                    }
				}
            }
        }
    }
    else
    {
        /* local */
		ext_sym = find_symbol( name, global_tab );
        if ( ext_sym == NULL )
        {
            /* If no external symbol of identical name has been declared, then re-declare local
               symbol as external symbol, but only if local symbol is not defined yet */
            if ( ( sym->type & SYMDEFINED ) == 0 )
            {
                sym->type &= SYMLOCAL_OFF;
                sym->type |= ( SYMXREF | type );
                ext_sym = Symbol_create( name, 0, sym->type, CURRENTMODULE );
				SymbolHash_set( global_tab, name, ext_sym );

                /* original local symbol cloned as external symbol, now delete old local ... */
				SymbolHash_remove( CURRENTMODULE->local_tab, name );
            }
            else
            {
				/* already declared local */
                error( ERR_SYMBOL_DECL_LOCAL, name );
            }
        }
        else if ( ( sym->type & ( SYMXREF | type ) ) != ( SYMXREF | type ) )
        {
            /* re-declaration not allowed */
            error( ERR_SYMBOL_REDECL, name );
        }
    }
}

/* declare an external symbol XREF or LIB */
void declare_extern_obj_symbol( char *name ) { declare_extern_symbol(name, 0); }
void declare_extern_lib_symbol( char *name ) { declare_extern_symbol(name, SYMDEF); }


/*-----------------------------------------------------------------------------
*   sort functions for SymbolHash_sort
*----------------------------------------------------------------------------*/
int SymbolHash_by_name(  SymbolHashElem *a, SymbolHashElem *b)
{
	return strcmp( a->key, b->key );
}

int SymbolHash_by_value( SymbolHashElem *a, SymbolHashElem *b)
{
	return ((Symbol *)(a->value))->value - ((Symbol *)(b->value))->value;
}
