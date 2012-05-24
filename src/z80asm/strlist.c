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

Copyright (C) Paulo Custodio, 2011-2012

List of strings (e.g. include path); strings kept in strpool.h
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/strlist.c,v 1.1 2012-05-24 21:42:42 pauloscustodio Exp $ */
/* $Log: strlist.c,v $
/* Revision 1.1  2012-05-24 21:42:42  pauloscustodio
/* CH_0011 : new string list class to hold lists of strings
/*
/*
/* */

#include "memalloc.h"   /* before any other include */
#include "strlist.h"
#include "strpool.h"

/*-----------------------------------------------------------------------------
*   Define the class
*----------------------------------------------------------------------------*/
DEF_CLASS( StrList );

void StrList_init( StrList *self )
{
    /* force init strpool to make sure StrList is destroyed before StrPool */
    strpool_init();

    TAILQ_INIT( &self->head );
}

void StrList_copy( StrList *self )
{
    StrListElem *elem, *new_elem;
    TAILQ_HEAD( , StrListElem ) old_head;

    /* save old head from original object */
    memcpy( &old_head, &self->head, sizeof( old_head ) );

    /* create new list and copy element by element from old_head */
    TAILQ_INIT( &self->head );
    TAILQ_FOREACH( elem, &old_head, entries )
    {
        new_elem = xcalloc_struct( StrListElem );
        new_elem->string = elem->string; /* point to same string at strpool */
        TAILQ_INSERT_TAIL( &self->head, new_elem, entries );
    }
}

void StrList_fini( StrList *self )
{
    StrListElem *elem;

    while ( elem = TAILQ_FIRST( &self->head ) )
    {
        TAILQ_REMOVE( &self->head, elem, entries );
        xfree( elem );
    }
}

/*-----------------------------------------------------------------------------
*   append a string to the list
*----------------------------------------------------------------------------*/
void StrList_append( StrList *self, char *string )
{
    StrListElem *elem;

    elem = xcalloc_struct( StrListElem );
    elem->string = strpool_add( string );
    TAILQ_INSERT_TAIL( &self->head, elem, entries );
}

/*-----------------------------------------------------------------------------
*   itereate through list
*----------------------------------------------------------------------------*/
void StrList_first( StrList *self, StrListElem **iter )
{
    *iter = NULL;
}

char *StrList_next( StrList *self, StrListElem **iter )
{
    if ( *iter == NULL )
    {
        *iter = TAILQ_FIRST( &self->head );    /* first time */
    }
    else
    {
        *iter = TAILQ_NEXT( *iter, entries );    /* 2nd and following */
    }

    return *iter == NULL ? NULL : ( *iter )->string;
}
