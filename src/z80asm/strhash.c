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

Copyright (C) Paulo Custodio, 2011-2013

Hash of strings to void* including doubly-linked list of all strings to be
able to retrieve in the order added.
Keys are kept in strpool, no need to release memory.
Memory pointed by value of each hash entry must be managed by caller.
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/strhash.c,v 1.2 2013-01-19 00:04:53 pauloscustodio Exp $ */
/* $Log: strhash.c,v $
/* Revision 1.2  2013-01-19 00:04:53  pauloscustodio
/* Implement StrHash_clone, required change in API of class.h and all classes that used it.
/*
/* Revision 1.1  2013/01/18 22:59:17  pauloscustodio
/* CH_0016 : StrHash class to create maps from string to void*
/* Created the StrHash to create hash tables mapping string keys kept in
/* strpool to void* user pointer.
/*
/*
/* */

#include "memalloc.h"   /* before any other include */
#include "strhash.h"
#include "strpool.h"

/*-----------------------------------------------------------------------------
*   Define the class
*----------------------------------------------------------------------------*/
DEF_CLASS( StrHash );

void StrHash_init( StrHash *self )
{
    /* force init strpool to make sure StrHash is destroyed before StrPool */
    strpool_init();

	self->hash_table = NULL;
    CIRCLEQ_INIT( &self->head );
}

void StrHash_copy( StrHash *self, StrHash *other )
{
    StrHashElem *elem;

    /* create new hash and copy element by element from other */
	self->hash_table = NULL;
    CIRCLEQ_INIT( &self->head );

	CIRCLEQ_FOREACH( elem, &other->head, entries )
    {
		StrHash_set( self, elem->key, elem->value );
    }
}

void StrHash_fini( StrHash *self )
{
    StrHashElem *elem;

	while ( ! CIRCLEQ_EMPTY( &self->head ) )
    {
		elem = CIRCLEQ_FIRST( &self->head );
		StrHash_remove( self, elem->key );
    }
}

/*-----------------------------------------------------------------------------
*	Find a hash entry
*----------------------------------------------------------------------------*/
static StrHashElem *StrHash_find( StrHash *self, char *key )
{
    StrHashElem *elem;
    size_t  	num_chars = strlen( key );

    HASH_FIND( hh, self->hash_table, key, num_chars, elem );
	return elem;
}

/*-----------------------------------------------------------------------------
*	Create the element if the key is not found, update the value if found
*----------------------------------------------------------------------------*/
void StrHash_set( StrHash *self, char *key, void *value )
{
    StrHashElem *elem;
	size_t num_chars;

	elem = StrHash_find( self, key );
	
	/* create new element if not found, value is updated at the end */
	if (elem == NULL) 
	{						
		elem = xcalloc_struct( StrHashElem );
		elem->key = strpool_add( key );
		
		/* add to tail of CIRCLEQ */
		CIRCLEQ_INSERT_TAIL( &self->head, elem, entries);
		
		/* add to hash */
		num_chars = strlen( key );
		HASH_ADD_KEYPTR( hh, self->hash_table, key, num_chars, elem );
	}
	
	/* update value */
	elem->value	= value;
}

/*-----------------------------------------------------------------------------
*	Retrive value for a given key, return NULL if not found
*----------------------------------------------------------------------------*/
void *StrHash_get( StrHash *self, char *key )
{
    StrHashElem *elem;
	
	elem = StrHash_find( self, key );
	if (elem) 
		return elem->value;
	else
		return NULL;
}

/*-----------------------------------------------------------------------------
*	Check if a key exists in the hash
*----------------------------------------------------------------------------*/
bool StrHash_exists( StrHash *self, char *key )
{
    StrHashElem *elem;
	
	elem = StrHash_find( self, key );
	if (elem) 
		return TRUE;
	else
		return FALSE;
}

/*-----------------------------------------------------------------------------
*	Remove element from hash if found
*----------------------------------------------------------------------------*/
void StrHash_remove( StrHash *self, char *key )
{
    StrHashElem *elem;
	
	elem = StrHash_find( self, key );
	if (elem) 
	{
		/* remove from CIRCLEQ */
		CIRCLEQ_REMOVE( &self->head, elem, entries );
		
		/* remove from hash table */
        HASH_DEL( self->hash_table, elem );
		
		/* release memory */
        xfree( elem );
	}
}

/*-----------------------------------------------------------------------------
*   itereate through list
*----------------------------------------------------------------------------*/
void StrHash_first( StrHash *self, StrHashElem **iter )
{
    *iter = NULL;
}

bool StrHash_next( StrHash *self, StrHashElem **iter )
{
	if ( *iter == NULL )
	{	
		*iter = CIRCLEQ_FIRST( &self->head );			/* first element */
	}
	else if ( *iter == CIRCLEQ_END( &self->head ) )
	{
		return FALSE;									/* end of list */
	}
	else
	{
		*iter = CIRCLEQ_NEXT( *iter, entries );			/* 2nd and following */
	}
	return ( *iter == CIRCLEQ_END( &self->head ) ) ? FALSE : TRUE;
}
