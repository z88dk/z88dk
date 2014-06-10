/*
Hash of strings to void* including doubly-linked list of all strings to be
able to retrieve in the order added.
Keys are kept in strpool, no need to release memory.
Memory pointed by value of each hash entry must be managed by caller.

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/strhash.c,v 1.13 2014-06-10 19:07:50 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */
#include "strhash.h"
#include "strpool.h"
#include "strutil.h"

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
*----------------------------------------------------------------------------*/
static char *StrHash_norm_key( StrHash *self, char *key )
{
	DEFINE_STR( KEY, MAXLINE );
	
	if ( self->ignore_case )
	{
		Str_set( KEY, key );
		return strtoupper( KEY->str );
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

    xfree( elem );
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
        
		elem = xnew( StrHashElem );
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


/*
* $Log: strhash.c,v $
* Revision 1.13  2014-06-10 19:07:50  pauloscustodio
* Make StrHash_norm_key reentrant
*
* Revision 1.12  2014/06/09 13:15:27  pauloscustodio
* Int and UInt types
*
* Revision 1.11  2014/05/25 01:02:30  pauloscustodio
* Byte, Int, UInt added
*
* Revision 1.10  2014/05/17 14:27:13  pauloscustodio
* Use C99 integer types
*
* Revision 1.9  2014/05/06 22:17:38  pauloscustodio
* Made types all-caps to avoid conflicts with /usr/include/i386-linux-gnu/sys/types.h
*
* Revision 1.8  2014/05/02 21:34:58  pauloscustodio
* byte_t and uint_t renamed to Byte, UInt
*
* Revision 1.7  2014/04/05 14:37:54  pauloscustodio
* Added ignore_case attribute to allow case-insensitive string hashes
*
* Revision 1.6  2014/03/05 23:44:55  pauloscustodio
* Renamed 64-bit portability to BUG_0042
*
* Revision 1.5  2014/02/19 23:59:27  pauloscustodio
* BUG_0042: 64-bit portability issues
* size_t changes to unsigned long in 64-bit. Usage of size_t * to
* retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
* breaks on a 64-bit architecture. Make the functions return the value instead
* of being passed the pointer to the return value, so that the compiler
* takes care of size convertions.
* Create UInt, use UInt instead of size_t.
*
* Revision 1.4  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.3  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.2  2014/01/05 23:20:39  pauloscustodio
* List, StrHash classlist and classhash receive the address of the container
* object in all functions that add items to the container, and create the
* container on first use. This allows a container to be staticaly
* initialized with NULL and instantiated on first push/unshift/set.
* Add count attribute to StrHash, classhash to count elements in container.
* Add free_data attribute in StrHash to register a free fucntion to delete
* the data container when the hash is removed or a key is overwritten.
*
* Revision 1.1  2013/12/25 17:02:10  pauloscustodio
* Move strhash.c to the z80asm/lib directory
*
* Revision 1.13  2013/12/15 13:18:34  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.12  2013/09/12 00:10:02  pauloscustodio
* Create xfree() macro that NULLs the pointer after free, required
* by z80asm to find out if a pointer was already freed.
*
* Revision 1.11  2013/09/08 08:29:21  pauloscustodio
* Replaced xmalloc et al with glib functions
*
* Revision 1.10  2013/09/01 18:46:01  pauloscustodio
* Remove call to strpool_init(). String pool is initialized in init.c before main() starts.
*
* Revision 1.9  2013/05/27 22:43:34  pauloscustodio
* StrHash_set failed when the key string buffer was reused later in the code.
* StrHash_get failed to retrieve object after the key used by StrHash_set was reused.
*
* Revision 1.8  2013/02/25 21:36:17  pauloscustodio
* Uniform the APIs of classhash, classlist, strhash, strlist
*
* Revision 1.7  2013/02/02 00:07:35  pauloscustodio
* StrHash_next() returns value instead of Bool
*
* Revision 1.6  2013/01/22 22:24:49  pauloscustodio
* Removed StrHash_set_delptr() - not intuitive and error prone
* Added StrHash_remove_all() to remove all elements
* Added StrHash_remove_elem() to remove one item giving its address
*
* Revision 1.5  2013/01/22 01:02:54  pauloscustodio
* Removed CIRCLEQ from StrHash - redundant, UT_hash_handle contains a double-linked list
* Added StrHash_set_delptr() to define at create-key time the function to free the value when
* the item is deleted later.
* Added StrHash_head() to get head of list - usefull in a delete-all loop.
*
* Revision 1.4  2013/01/20 21:10:32  pauloscustodio
* Rename bool to Bool, to be consistent with TRUE and FALSE and
* distinguish from C++ bool, true, false
*
* Revision 1.3  2013/01/19 23:52:40  pauloscustodio
* strhash hanged on cleanup - delete by HASH_ITER / HASH_DEL
* instead of traversing CIRCLEQ
*
* Revision 1.2  2013/01/19 00:04:53  pauloscustodio
* Implement StrHash_clone, required change in API of class.h and all classes that used it.
*
* Revision 1.1  2013/01/18 22:59:17  pauloscustodio
* CH_0016 : StrHash class to create maps from string to void*
* Created the StrHash to create hash tables mapping string keys kept in
* strpool to void* user pointer.
*
*/
