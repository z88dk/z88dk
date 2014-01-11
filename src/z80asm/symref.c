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
Copyright (C) Paulo Custodio, 2011-2013

Cross reference list of symbol usage

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/symref.c,v 1.7 2014-01-11 00:10:39 pauloscustodio Exp $
$Log: symref.c,v $
Revision 1.7  2014-01-11 00:10:39  pauloscustodio
Astyle - format C code
Add -Wall option to CFLAGS, remove all warnings

Revision 1.6  2014/01/02 23:33:11  pauloscustodio
Unify interface of classlist and list.

Revision 1.5  2013/12/15 13:18:34  pauloscustodio
Move memory allocation routines to lib/xmalloc, instead of glib,
introduce memory leak report on exit and memory fence check.

Revision 1.4  2013/10/01 23:23:53  pauloscustodio
Parse command line options via look-up tables:
-l, --list
-nl, --no-list

Revision 1.3  2013/10/01 22:50:27  pauloscustodio
Parse command line options via look-up tables:
-s, --symtable
-ns, --no-symtable

Revision 1.2  2013/06/01 01:24:22  pauloscustodio
CH_0022 : Replace avltree by hash table for symbol table

Revision 1.1  2013/05/16 23:39:48  pauloscustodio
Move struct node to sym.c, rename to Symbol
Move SymbolRef to symref.c

Revision 1.2  2013/03/04 23:37:09  pauloscustodio
Removed pass1 that was used to skip creating page references of created
symbols in pass2. Modified add_symbol_ref() to ignore pages < 1,
modified list_get_page_nr() to return -1 after the whole source is
processed.

Revision 1.1  2013/02/26 02:11:32  pauloscustodio
New model_symref.c with all symbol cross-reference list handling

Revision 1.1  2013/02/19 22:52:40  pauloscustodio

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
static BOOL ref_repeated( SymbolRefList *list, int page_nr )
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
void add_symbol_ref( SymbolRefList *list, int page_nr, BOOL defined )
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

