/*
Z88-DK Z80ASM - Z80 Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2015
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

Cross reference list of symbol usage
*/

#include "options.h"
#include "symref.h"

/*-----------------------------------------------------------------------------
*    Cross reference list of symbol usage
*----------------------------------------------------------------------------*/
DEF_CLASS( SymbolRef );
DEF_CLASS_LIST( SymbolRef );

void SymbolRef_init( SymbolRef *self ) { }
void SymbolRef_copy( SymbolRef *self, SymbolRef *other ) { }
void SymbolRef_fini( SymbolRef *self ) { }

/* check if reference is repeated and should not be inserted */
static Bool ref_repeated( SymbolRefList *list, int page_nr )
{
    if ( SymbolRefList_empty( list ) )
        return FALSE;					/* list is empty */

    if ( SymbolRefList_first( list )->obj->page_nr == page_nr )
        return TRUE;					/* used in first */

    if ( SymbolRefList_last( list )->obj->page_nr == page_nr )
        return TRUE;					/* used in last */

    return FALSE;						/* not used */
}


/* add a symbol reference, create the list if NULL */
void add_symbol_ref( SymbolRefList *list, int page_nr, Bool defined )
{
    SymbolRef *obj;

    if ( opts.symtable && opts.list &&
            page_nr > 0 )							/* = -1 in link phase */
    {
        /* check if page_nr was already referenced at start (definition) or end (usage) */
        if ( ! ref_repeated( list, page_nr ) )
        {
            /* add the reference */
            obj = OBJ_NEW( SymbolRef );
            obj->page_nr = page_nr;

            if ( defined )
            {
                SymbolRefList_unshift( &list, obj );		/* add at start */
            }
            else
            {
                SymbolRefList_push( &list, obj );			/* add at end */
            }
        }
        else if ( ! SymbolRefList_empty( list ) &&
                  defined &&
                  SymbolRefList_last( list )->obj->page_nr == page_nr )
        {
            /* move the reference from end of list to start of list, set defined flag */
            obj = SymbolRefList_pop( list );
            SymbolRefList_unshift( &list, obj );
        }
    }
}
