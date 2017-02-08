/*
Z88DK Z80 Macro Assembler

Generic doubly linked list, data allocation is handled by the caller.
Uses queue.h for implementation.

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#include "alloc.h"
#include "list.h"

/*-----------------------------------------------------------------------------
*   Define List class
*----------------------------------------------------------------------------*/

DEF_CLASS( List );

void List_init( List *self )
{
    self->count = 0;
    TAILQ_INIT( &self->head );
}

void List_copy( List *self, List *other )
{
    ListElem *elem;

    /* create new list and copy element by element from other */
    self->count = 0;
    TAILQ_INIT( &self->head );

    TAILQ_FOREACH( elem, &other->head, entries )
    {
        List_push( &self, elem->data );
    }
}

void List_fini( List *self )
{
    List_remove_all( self );
}

/*-----------------------------------------------------------------------------
*   create a new element
*----------------------------------------------------------------------------*/
static ListElem *List_new_elem( List **pself, void *data )
{
    ListElem *elem;

    INIT_OBJ( List, pself );			/* init object */

    elem = m_new( ListElem );
    elem->data = data;

    ( *pself )->count++;
    return elem;
}

/*-----------------------------------------------------------------------------
*   remove element and return object
*----------------------------------------------------------------------------*/
static void *List_remove_elem( List *self, ListElem *elem )
{
    void *data;

    if ( self == NULL || elem == NULL )
        return NULL;

    data = elem->data;

    TAILQ_REMOVE( &self->head, elem, entries );
    m_free( elem );

    self->count--;
    return data;
}

/*-----------------------------------------------------------------------------
*   add and retrieve at the end
*----------------------------------------------------------------------------*/
void List_push( List **pself, void *data )
{
    ListElem *elem = List_new_elem( pself, data );
    TAILQ_INSERT_TAIL( &( *pself )->head, elem, entries );
}

void *List_pop( List *self )
{
    ListElem *elem = List_last( self );
    return List_remove_elem( self, elem );
}

/*-----------------------------------------------------------------------------
*   add and retrieve at the start
*----------------------------------------------------------------------------*/
void List_unshift( List **pself, void *data )
{
    ListElem *elem = List_new_elem( pself, data );
    TAILQ_INSERT_HEAD( &( *pself )->head, elem, entries );
}

void *List_shift( List *self )
{
    ListElem *elem = List_first( self );
    return List_remove_elem( self, elem );
}

/*-----------------------------------------------------------------------------
*   set iterator to start and end of list, data is iter->data
*----------------------------------------------------------------------------*/
ListElem *List_first( List *self )
{
    return self == NULL ? NULL : TAILQ_FIRST( &self->head );
}

ListElem *List_last( List *self )
{
    return self == NULL ? NULL : TAILQ_LAST( &self->head, ListHead );
}

/*-----------------------------------------------------------------------------
*   advance iterator to next/previous element
*----------------------------------------------------------------------------*/
ListElem *List_next( ListElem *iter )
{
    return iter == NULL ? NULL : TAILQ_NEXT( iter, entries );
}

ListElem *List_prev( ListElem *iter )
{
    return iter == NULL ? NULL : TAILQ_PREV( iter, ListHead, entries );
}

/*-----------------------------------------------------------------------------
*   insert data before/after a given iterator
*----------------------------------------------------------------------------*/
void List_insert_after( List **pself, ListElem *iter, void *data )
{
    ListElem *elem;

    if ( iter == NULL )
        List_push( pself, data );
    else
    {
        elem = List_new_elem( pself, data );
        TAILQ_INSERT_AFTER( &( *pself )->head, iter, elem, entries );
    }
}

void List_insert_before( List **pself, ListElem *iter, void *data )
{
    ListElem *elem;

    if ( iter == NULL )
        List_unshift( pself, data );
    else
    {
        elem = List_new_elem( pself, data );
        TAILQ_INSERT_BEFORE( iter, elem, entries );
    }
}

/*-----------------------------------------------------------------------------
*   remove and return data pointed by iterator,
*	advance iterator to next element
*----------------------------------------------------------------------------*/
void *List_remove( List *self, ListElem **piter )
{
    ListElem *old_iter;

    if ( self == NULL )
        return NULL;

    old_iter = *piter;
    *piter = List_next( *piter );
    return List_remove_elem( self, old_iter );
}

/*-----------------------------------------------------------------------------
*   remove all list; free if not NULL is called to free each element
*----------------------------------------------------------------------------*/
void List_remove_all( List *self )
{
    ListElem *elem;

    if ( self == NULL )
        return;

    while ( ( elem = List_first( self ) ) != NULL )
    {
        if ( self->free_data != NULL && elem->data != NULL )
            self->free_data( elem->data );

        List_remove( self, &elem );
    }
}

/* check if list is empty */
Bool List_empty( List *self )
{
    return List_first( self ) == NULL ? TRUE : FALSE;
}
