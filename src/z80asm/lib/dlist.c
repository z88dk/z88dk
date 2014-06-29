/*
Generic doubly linked ring, data allocation is handled by the caller.
Works on void*, caller needs to pass pointers to structs 
with same next/first and prev/last pointers as first elements.
Ring head always exists and has next pointing to first element and 
prev to last element, or to itself if list is empty.

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/Attic/dlist.c,v 1.2 2014-06-29 23:41:57 pauloscustodio Exp $
*/

#include "xmalloc.h"		/* before any other include */

#include "dlist.h"
#include <assert.h>

/*-----------------------------------------------------------------------------
*   Init head in case it was zeroed (e.g. statically initialized)
*----------------------------------------------------------------------------*/
static void dl_init( DList *list )
{
	assert( list );
	if ( list->next == NULL || list->prev == NULL )
		list->next = list->prev = list;
}

/*-----------------------------------------------------------------------------
*   Get first and last elements from the list, NULL if empty
*----------------------------------------------------------------------------*/
void *dl_first( DList *list )
{
	dl_init( list );
	if ( list->next == list )
		return NULL;
	else
		return list->next;
}

void *dl_last( DList *list )
{
	dl_init( list );
	if ( list->prev == list )
		return NULL;
	else
		return list->prev;
}

/*-----------------------------------------------------------------------------
*   Get next and previous elements from a given node, NULL if empty
*----------------------------------------------------------------------------*/
void *dl_next( DList *list, void *node_ )
{
	DList *node = node_; 

	dl_init( list );
	assert( node && node->next && node->prev );

	if ( node->next == list )
		return NULL;
	else
		return node->next;
}

void *dl_prev( DList *list, void *node_ )
{
	DList *node = node_; 
	
	dl_init( list );
	assert( node && node->next && node->prev );

	if ( node->prev == list )
		return NULL;
	else
		return node->prev;
}

/*-----------------------------------------------------------------------------
*   Insert after or before given element, which may be the list head, 
*	return new node
*----------------------------------------------------------------------------*/
void *dl_insert_after( void *old_node_, void *new_node_ )
{
	DList *old_node = old_node_;
	DList *new_node = new_node_;

	dl_init( old_node );
	assert( new_node );

	new_node->next = old_node->next;
	new_node->prev = old_node;
	old_node->next = new_node;
	new_node->next->prev = new_node;

	return new_node;
}

void *dl_insert_before( void *old_node_, void *new_node_ )
{
	DList *old_node = old_node_;

	dl_init( old_node );
	return dl_insert_after( old_node->prev, new_node_ );
}

/*-----------------------------------------------------------------------------
*   Remove and return the given element
*----------------------------------------------------------------------------*/
void *dl_remove( DList *list, void *node_ )
{
	DList *node = node_; 

	dl_init( list );
	assert( node != list && node && node->next && node->prev );

	node->next->prev = node->prev;
	node->prev->next = node->next;
	node->next = node->prev = NULL;

	return node;
}

/*-----------------------------------------------------------------------------
*   Add and retrieve at the end, return node
*   dl_pop() returns NULL if empty
*----------------------------------------------------------------------------*/
void *dl_push( DList *list, void *node_ )
{
	return dl_insert_before( list, node_ );
}

void *dl_pop( DList *list )
{
	DList *node = dl_last( list );
	if ( node )
		return dl_remove( list, node );
	else
		return NULL;
}

/*-----------------------------------------------------------------------------
*   Add and retrieve at the start, return node
*   dl_shift() returns NULL if empty
*----------------------------------------------------------------------------*/
void *dl_unshift( DList *list, void *node_ )
{
	return dl_insert_after( list, node_ );
}

void *dl_shift( DList *list )
{
	DList *node = dl_first( list );
	if ( node )
		return dl_remove( list, node );
	else
		return NULL;
}

/*-----------------------------------------------------------------------------
*   Merge-sort the list
*----------------------------------------------------------------------------*/
void dl_msort( DList *list, int (*compare)( void *node_a_, void *node_b_ ) )
{
	DList left = DL_INIT, right = DL_INIT;
	DList *node_a, *node_b;

	/* empty lists or with one element are sorted */
	node_a = dl_first(list);
	node_b = dl_last(list);
	if ( ! node_a || node_a == node_b )
		return;

	/* move elements from start to the left list, and from end to the right list */
	dl_init(&left);
	dl_init(&right);
	while (1)
	{
		/* left element */
		node_a = dl_shift(list);
		if ( ! node_a )
			break;
		dl_push(&left, node_a);

		/* right element */
		node_b = dl_pop(list);
		if ( ! node_b )
			break;
		dl_unshift(&right, node_b);
	}

	/* sort sublists */
	dl_msort(&left,  compare);
	dl_msort(&right, compare);

	/* merge two sublists */
	while (1)
	{
		node_a = dl_first(&left);
		node_b = dl_first(&right);
		
		if ( ! node_a && ! node_b )
			break;						/* finished */

		if ( node_a && node_b )			/* both have items */
		{
			if ( compare(node_a, node_b) <= 0 )
			{
				node_a = dl_shift(&left);
				dl_push(list, node_a);
			}
			else
			{
				node_b = dl_shift(&right);
				dl_push(list, node_b);
			}
		}
		else if ( node_a )
		{
			node_a = dl_shift(&left);
			dl_push(list, node_a);
		}
		else
		{
			assert(node_b);
			node_b = dl_shift(&right);
			dl_push(list, node_b);
		}
	}
}
