/*
Z88DK Z80 Macro Assembler

Hash of strings to void* including doubly-linked list of all strings to be
able to retrieve in the order added.
Keys are kept in strpool, no need to release memory.
Memory pointed by value of each hash entry must be managed by caller.

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#include "alloc.h"
#include "strhash.h"
#include "strpool.h"
#include "str.h"

/*-----------------------------------------------------------------------------
*   Define the class
*----------------------------------------------------------------------------*/
DEF_CLASS( StrHash );

void StrHash_init( StrHash *self )
{
    self->hash = NULL;
    self->count = 0;
    self->ignore_case = FALSE;
}

void StrHash_copy( StrHash *self, StrHash *other )
{
    StrHashElem *elem, *tmp;

    /* create new hash and copy element by element from other */
    self->hash = NULL;
    self->count = 0;

    HASH_ITER( hh, other->hash, elem, tmp )
    {
        StrHash_set( &self, elem->key, elem->value );
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

    if ( self == NULL )
        return;

    HASH_ITER( hh, self->hash, elem, tmp )
    {
        StrHash_remove_elem( self, elem );
    }
}

/*-----------------------------------------------------------------------------
*	Upper-case a key if hash has ignore_case on, return address of key
*	keeps input unmodified.
*	NOTE: not reentrant
*----------------------------------------------------------------------------*/
static char *StrHash_norm_key( StrHash *self, char *key )
{
	static STR_DEFINE(KEY, STR_SIZE);		/* static object to keep upper case key */
	
	if ( self->ignore_case )
	{
		str_set(KEY, key);
		str_toupper(KEY);
		return str_data(KEY);
	}
	else
		return key;
}

/*-----------------------------------------------------------------------------
*	Find a hash entry
*----------------------------------------------------------------------------*/
StrHashElem *StrHash_find( StrHash *self, char *key )
{
    StrHashElem *elem;
    size_t  	 num_chars;

    if ( self == NULL || key == NULL )
        return NULL;

	key = StrHash_norm_key( self, key );
    num_chars = strlen( key );
    HASH_FIND( hh, self->hash, key, num_chars, elem );
    return elem;
}

/*-----------------------------------------------------------------------------
*	Delete a hash entry if not NULL
*----------------------------------------------------------------------------*/
void StrHash_remove_elem( StrHash *self, StrHashElem *elem )
{
    if ( self == NULL || elem == NULL )
        return;

    HASH_DEL( self->hash, elem );

    self->count--;

    if ( self->free_data != NULL )
        self->free_data( elem->value );

    m_free( elem );
}

/*-----------------------------------------------------------------------------
*	Create the element if the key is not found, update the value if found
*----------------------------------------------------------------------------*/
void StrHash_set( StrHash **pself, char *key, void *value )
{
    StrHashElem *elem;
    size_t num_chars;

    INIT_OBJ( StrHash, pself );

    elem = StrHash_find( *pself, key );

    /* create new element if not found, value is updated at the end */
    if ( elem == NULL )
    {
		key = StrHash_norm_key( *pself, key );
        
		elem = m_new( StrHashElem );
        elem->key = strpool_add( key );

        /* add to hash, need to store elem->key instead of key, as it is invariant */
        num_chars = strlen( key );
        HASH_ADD_KEYPTR( hh, ( *pself )->hash, elem->key, num_chars, elem );

        ( *pself )->count++;
    }
    else 					/* element exists, free data of old value */
    {
        if ( ( *pself )->free_data != NULL )
            ( *pself )->free_data( elem->value );
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

    if ( elem != NULL )
        return elem->value;
    else
        return NULL;
}

/*-----------------------------------------------------------------------------
*	Check if a key exists in the hash
*----------------------------------------------------------------------------*/
Bool StrHash_exists( StrHash *self, char *key )
{
    StrHashElem *elem;

    elem = StrHash_find( self, key );
    if ( elem != NULL )
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
    return self == NULL ? NULL : ( StrHashElem * )self->hash;
}

/*-----------------------------------------------------------------------------
*   itereate through list
*----------------------------------------------------------------------------*/
StrHashElem *StrHash_next( StrHashElem *iter )
{
    return iter == NULL ? NULL : ( StrHashElem * )( iter )->hh.next;
}

/*-----------------------------------------------------------------------------
*	check if hash is empty
*----------------------------------------------------------------------------*/
Bool StrHash_empty( StrHash *self )
{
    return StrHash_first( self ) == NULL ? TRUE : FALSE;
}

/*-----------------------------------------------------------------------------
*	sort the items in the hash
*----------------------------------------------------------------------------*/
void StrHash_sort( StrHash *self, StrHash_compare_func compare )
{
    if ( self == NULL )
        return;

    HASH_SORT( self->hash, compare );
}
