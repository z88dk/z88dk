/*
Generic doubly linked ring, data allocation is handled by the caller.
Works on void*, caller needs to pass pointers to structs 
with same next/first and prev/last pointers as first elements.
Ring head always exists and has next pointing to first element and 
prev to last element, or to itself if list is empty.

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/Attic/dlist.h,v 1.3 2014-06-29 23:47:40 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"		/* before any other include */

/*-----------------------------------------------------------------------------
*   List header and element
*	List head can be initialized with next = prev = NULL; next and prev will
*	be linked to list header on first use.
*	User code:
*		struct Node { DList link; ... }; 
*		DList head = DL_INIT;
*----------------------------------------------------------------------------*/
typedef struct DList
{
	struct DList *next, *prev;		/* point to next and previous element */
									/* point to first and last element from head */
	/* ... user data ... */
} DList;

#define DL_INIT {NULL,NULL}

/* get first and last elements from the list, NULL if empty */
extern void *dl_first( DList *list );
extern void *dl_last(  DList *list );

/* get next and previous elements from a given node, NULL if empty */
extern void *dl_next( DList *list, void *node_ );
extern void *dl_prev( DList *list, void *node_ );

/* convenience macros */
#define DL_FOREACH(head, node) \
	for ( node = dl_first(head); node != NULL; node = dl_next(head, node) )

#define DL_FOREACH_R(head, node) \
	for ( node = dl_last(head); node != NULL; node = dl_prev(head, node) )

/* add and retrieve at the end, return node
   dl_pop() returns NULL if empty */
extern void *dl_push( DList *list, void *node_ );
extern void *dl_pop(  DList *list );

/* add and retrieve at the start, return node
   dl_shift() returns NULL if empty */
extern void *dl_unshift( DList *list, void *node_ );
extern void *dl_shift(   DList *list );

/* insert after or before given element, which may be the list head, return new node */
extern void *dl_insert_after(  void *old_node_, void *new_node_ );
extern void *dl_insert_before( void *old_node_, void *new_node_ );

/* remove and return the given element */
extern void *dl_remove( DList *list, void *node_ );

/* merge-sort the list */
typedef int (*dl_compare_t)( void *node_a_, void *node_b_ );
extern void  dl_msort( DList *list, dl_compare_t compare );
