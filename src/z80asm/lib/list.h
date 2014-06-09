/*
Generic doubly linked list, data allocation is handled by the caller.
Uses queue.h for implementation.

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/list.h,v 1.14 2014-06-09 13:15:27 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"		/* before any other include */

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


/*
* $Log: list.h,v $
* Revision 1.14  2014-06-09 13:15:27  pauloscustodio
* Int and UInt types
*
* Revision 1.13  2014/05/25 01:02:30  pauloscustodio
* Byte, Int, UInt added
*
* Revision 1.12  2014/05/17 14:27:13  pauloscustodio
* Use C99 integer types
*
* Revision 1.11  2014/05/06 22:17:38  pauloscustodio
* Made types all-caps to avoid conflicts with /usr/include/i386-linux-gnu/sys/types.h
*
* Revision 1.10  2014/05/02 21:34:58  pauloscustodio
* byte_t and uint_t renamed to Byte, UInt
*
* Revision 1.9  2014/04/15 20:06:44  pauloscustodio
* Solve warning: no newline at end of file
*
* Revision 1.8  2014/03/05 23:44:55  pauloscustodio
* Renamed 64-bit portability to BUG_0042
*
* Revision 1.7  2014/02/19 23:59:27  pauloscustodio
* BUG_0042: 64-bit portability issues
* size_t changes to unsigned long in 64-bit. Usage of size_t * to
* retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
* breaks on a 64-bit architecture. Make the functions return the value instead
* of being passed the pointer to the return value, so that the compiler
* takes care of size convertions.
* Create UInt, use UInt instead of size_t.
*
* Revision 1.6  2014/01/21 22:42:40  pauloscustodio
* ws
*
* Revision 1.5  2014/01/21 21:33:02  pauloscustodio
* ws
*
* Revision 1.4  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.3  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.2  2014/01/02 16:02:28  pauloscustodio
* Register free() function to be used by remove_all() to delete each element
*
* Revision 1.1  2014/01/02 12:48:39  pauloscustodio
* Generic doubly-linked lists lists
*
*
*/
