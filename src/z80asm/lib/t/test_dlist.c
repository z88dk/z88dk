/*
Unit test for dlist.c

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/t/Attic/test_dlist.c,v 1.3 2014-06-29 23:47:40 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "die.h"
#include "dlist.h"
#include <assert.h>
#include <stdio.h>

typedef struct Node
{
	DList	link;
	char 	c;
} Node;

#define MAXLINE		1024

Node  nodes[5];
DList head_, *head = &head_;

void dump_list(char *title, int line)
{
	Node *node;
	char text[MAXLINE];
	char *p;

	warn("%s (line %d)\n\n", title, line );

	/* check forward pointers */
	p = text;
	DL_FOREACH(head, node)
		*p++ = node->c;
	*p = 0;
	warn("list = %s.\n", text);

	/* check backward pointers */
	DL_FOREACH_R(head, node)
	{
		p--;
		assert( p >= text && *p == node->c );
	}

	warn("--------------------------------------------------------------------------------\n");
}

#define T(code) do { code; dump_list(#code ";", __LINE__); } while (0)

int compare_asc(Node *node_a, Node *node_b)
{
	return (int)node_a->c - (int)node_b->c;
}

int compare_des(Node *node_a, Node *node_b)
{
	return (int)node_b->c - (int)node_a->c;
}

int main( int argc, char *argv[] )
{
	int i;

	/* init elems */
	for ( i = 0; i < 5; i++ )
		nodes[i].c = 'A'+i;

	/* header is initialized automatically */
	assert( head->next == NULL && head->prev == NULL );
	assert( dl_first(head) == NULL );
	assert( dl_last(head)  == NULL );
	assert( head->next != NULL && head->prev != NULL );

	T(1);

	/* push / pop */
	assert( dl_pop( head ) == NULL );
	for ( i = 0; i < 5 ; i++ )
		T( assert( dl_push( head, &nodes[i] ) == &nodes[i] ) );
	for ( i = 4; i >= 0 ; i-- )
		T( assert( dl_pop( head ) == &nodes[i] ) );
	assert( dl_pop( head ) == NULL );

	/* shift / unshift */
	assert( dl_shift( head ) == NULL );
	for ( i = 0; i < 5 ; i++ )
		T( assert( dl_unshift( head, &nodes[i] ) == &nodes[i] ) );
	for ( i = 4; i >= 0 ; i-- )
		T( assert( dl_shift( head ) == &nodes[i] ) );
	assert( dl_shift( head ) == NULL );

	/* remove */
	for ( i = 0; i < 5 ; i++ )
		T( assert( dl_push( head, &nodes[i] ) == &nodes[i] ) );
	T( assert( dl_remove( head, &nodes[2] ) == &nodes[2] ) );
	T( assert( dl_remove( head, &nodes[0] ) == &nodes[0] ) );
	T( assert( dl_remove( head, &nodes[4] ) == &nodes[4] ) );
	T( assert( dl_remove( head, &nodes[1] ) == &nodes[1] ) );
	T( assert( dl_remove( head, &nodes[3] ) == &nodes[3] ) );

	/* insert */
	T( assert( dl_push( head, &nodes[0] ) == &nodes[0] ) );
	T( assert( dl_insert_before( &nodes[0], &nodes[1] ) == &nodes[1] ) );
	T( assert( dl_insert_before( &nodes[0], &nodes[2] ) == &nodes[2] ) );
	T( assert( dl_insert_after(  &nodes[0], &nodes[3] ) == &nodes[3] ) );
	T( assert( dl_insert_after(  &nodes[0], &nodes[4] ) == &nodes[4] ) );

	/* sort */
	T( dl_msort(head, (dl_compare_t) compare_asc) );
	T( dl_msort(head, (dl_compare_t) compare_des) );

	return 0;
}
