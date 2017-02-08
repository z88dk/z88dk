/*
Z88DK Z80 Macro Assembler

Generic doubly linked list, data allocation is handled by the caller.
Uses queue.h for implementation.

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#pragma once

#include "class.h"
#include "types.h"
#include "queue.h"

/*-----------------------------------------------------------------------------
*   List *list = NULL;			// init list
*	List_push( &list, data );	// add data
*	ListElem *iter;
*   for ( iter = List_first(list); iter != NULL; iter = List_next(iter) )
*	{ use iter->data }
*
*   OBJ_DELETE(List);			// is done automatically on exit
*----------------------------------------------------------------------------*/
typedef struct ListElem
{
    void *data;							/* user data */

    TAILQ_ENTRY( ListElem ) entries;	/* tail queue. */
} ListElem;

CLASS( List )
	size_t count;							/* number of objects */
	void ( *free_data )( void * );			/* function to free an element
											   called by List_remove_all() */
	TAILQ_HEAD( ListHead, ListElem ) head;	/* head of queue */
END_CLASS;

/* add and retrieve at the end */
extern void  List_push( List **pself, void *data );
extern void *List_pop( List *self );

/* add and retrieve at the start */
extern void  List_unshift( List **pself, void *data );
extern void *List_shift( List *self );

/* set iterator to start and end of list, data is iter->data */
extern ListElem *List_first( List *self );
extern ListElem *List_last( List *self );

/* advance iterator to next/previous element */
extern ListElem *List_next( ListElem *iter );
extern ListElem *List_prev( ListElem *iter );

/* insert data before/after a given iterator */
extern void List_insert_after( List **pself, ListElem *iter, void *data );
extern void List_insert_before( List **pself, ListElem *iter, void *data );

/* remove and return data pointed by iterator,
   advance iterator to next element */
extern void *List_remove( List *self, ListElem **piter );

/* remove all list; free_data if not NULL is called to free each element */
extern void List_remove_all( List *self );

/* check if list is empty */
extern Bool List_empty( List *self );
