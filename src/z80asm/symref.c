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

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2014

Cross reference list of symbol usage

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/symref.c,v 1.10 2014-06-21 02:18:29 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

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
