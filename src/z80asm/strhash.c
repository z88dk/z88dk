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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/strhash.c,v 1.8 2013-02-25 21:36:17 pauloscustodio Exp $ */
/* $Log: strhash.c,v $
/* Revision 1.8  2013-02-25 21:36:17  pauloscustodio
/* Uniform the APIs of classhash, classlist, strhash, strlist
/*
/* Revision 1.7  2013/02/02 00:07:35  pauloscustodio
/* StrHash_next() returns value instead of BOOL
/*
/* Revision 1.6  2013/01/22 22:24:49  pauloscustodio
/* Removed StrHash_set_delptr() - not intuitive and error prone
/* Added StrHash_remove_all() to remove all elements
/* Added StrHash_remove_elem() to remove one item giving its address
/*
/* Revision 1.5  2013/01/22 01:02:54  pauloscustodio
/* Removed CIRCLEQ from StrHash - redundant, UT_hash_handle contains a double-linked list
/* Added StrHash_set_delptr() to define at create-key time the function to free the value when
/* the item is deleted later.
/* Added StrHash_head() to get head of list - usefull in a delete-all loop.
/*
/* Revision 1.4  2013/01/20 21:10:32  pauloscustodio
/* Rename bool to BOOL, to be consistent with TRUE and FALSE and
/* distinguish from C++ bool, true, false
/*
/* Revision 1.3  2013/01/19 23:52:40  pauloscustodio
/* strhash hanged on cleanup - delete by HASH_ITER / HASH_DEL
/* instead of traversing CIRCLEQ
/*
/* Revision 1.2  2013/01/19 00:04:53  pauloscustodio
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

	self->hash = NULL;
}

void StrHash_copy( StrHash *self, StrHash *other )
{
    StrHashElem *elem, *tmp;

    /* create new hash and copy element by element from other */
	self->hash = NULL;

    HASH_ITER( hh, other->hash, elem, tmp )
    {
		StrHash_set( self, elem->key, elem->value );
    }
}

void StrHash_fini( StrHash *self )
{
	StrHash_remove_all( self );
}

/*-----------------------------------------------------------------------------
*	Remove all entries
*----------------------------------------------------------------------------*/
void StrHash_remove_all( StrHash *self )
{
    StrHashElem *elem, *tmp;

    HASH_ITER( hh, self->hash, elem, tmp )
    {
        StrHash_remove_elem( self, elem );
    }
}

/*-----------------------------------------------------------------------------
*	Find a hash entry
*----------------------------------------------------------------------------*/
StrHashElem *StrHash_find( StrHash *self, char *key )
{
    StrHashElem *elem;
    size_t  	num_chars = strlen( key );

    HASH_FIND( hh, self->hash, key, num_chars, elem );
	return elem;
}

/*-----------------------------------------------------------------------------
*	Delete a hash entry if not NULL
*----------------------------------------------------------------------------*/
void StrHash_remove_elem( StrHash *self, StrHashElem *elem )
{
	if ( elem )
	{
		HASH_DEL( self->hash, elem );
		xfree( elem );
	}
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
		
		/* add to hash */
		num_chars = strlen( key );
		HASH_ADD_KEYPTR( hh, self->hash, key, num_chars, elem );
	}
	
	/* update value */
	elem->value	     = value;
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
BOOL StrHash_exists( StrHash *self, char *key )
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
	StrHash_remove_elem( self, elem );
}

/*-----------------------------------------------------------------------------
*	Get first hash entry, maybe NULL
*----------------------------------------------------------------------------*/
StrHashElem *StrHash_first( StrHash *self )
{
    return (StrHashElem *)self->hash;
}

/*-----------------------------------------------------------------------------
*   itereate through list
*----------------------------------------------------------------------------*/
StrHashElem *StrHash_next( StrHashElem *iter )
{
	return iter == NULL ? NULL : (StrHashElem *)(iter)->hh.next;
}

/*-----------------------------------------------------------------------------
*	check if hash is empty
*----------------------------------------------------------------------------*/
BOOL StrHash_empty( StrHash *self )
{
	return StrHash_first(self) == NULL ? TRUE : FALSE;
}

/*-----------------------------------------------------------------------------
*	sort the items in the hash
*----------------------------------------------------------------------------*/
void StrHash_sort( StrHash *self, StrHash_compare_func compare )
{
	HASH_SORT( self->hash, compare );
}

