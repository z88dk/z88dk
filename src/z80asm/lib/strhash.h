/*
Hash of strings to void* including doubly-linked list of all strings to be
able to retrieve in the order added.
Keys are kept in strpool, no need to release memory.
Memory pointed by value of each hash entry must be managed by caller.

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/strhash.h,v 1.9 2014-05-02 21:34:58 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */
#include "types.h"
#include "class.h"
#include "queue.h"
#include "uthash.h"

/*-----------------------------------------------------------------------------
*   Class
*----------------------------------------------------------------------------*/
typedef struct StrHashElem
{
    char    *key; 					/* string kept in strpool.h */
    void	*value;					/* value managed by caller */

    UT_hash_handle hh;      		/* hash table */

} StrHashElem;

CLASS( StrHash )
	uint 	count;					/* number of objects */
	BOOL 	ignore_case;			/* TRUE to ignore case of keys */
	void  (*free_data)(void *);		/* function to free an element
									   called by StrHash_remove_all() */
	StrHashElem		*hash;			/* hash table of all keys */
END_CLASS;

/* compare function used by sort */
typedef int ( *StrHash_compare_func )( StrHashElem *a, StrHashElem *b );

/* add new key/value to the list, create new entry if new key,
   overwrite if key exists */
extern void StrHash_set( StrHash **pself, char *key, void *value );

/* retrive value for a given key, return NULL if not found */
extern void *StrHash_get( StrHash *self, char *key );

/* Check if a key exists in the hash */
extern BOOL StrHash_exists( StrHash *self, char *key );

/* Remove element from hash if found */
extern void StrHash_remove( StrHash *self, char *key );

/* Remove all entries */
extern void StrHash_remove_all( StrHash *self );

/* Find a hash entry */
extern StrHashElem *StrHash_find( StrHash *self, char *key );

/* Delete a hash entry if not NULL */
extern void StrHash_remove_elem( StrHash *self, StrHashElem *elem );

/* get the iterator of the first element in the list, NULL if list empty */
extern StrHashElem *StrHash_first( StrHash *self );

/* get the iterator of the next element in the list, NULL at end of list */
extern StrHashElem *StrHash_next( StrHashElem *iter );

/* check if hash is empty */
extern BOOL StrHash_empty( StrHash *self );

/* sort the items in the hash */
extern void StrHash_sort( StrHash *self, StrHash_compare_func compare );


/*
* $Log: strhash.h,v $
* Revision 1.9  2014-05-02 21:34:58  pauloscustodio
* byte_t, uint_t and ulong_t renamed to byte, uint and ulong
*
* Revision 1.8  2014/04/05 14:37:54  pauloscustodio
* Added ignore_case attribute to allow case-insensitive string hashes
*
* Revision 1.7  2014/03/05 23:44:55  pauloscustodio
* Renamed 64-bit portability to BUG_0042
*
* Revision 1.6  2014/03/04 11:51:08  pauloscustodio
* ws
*
* Revision 1.5  2014/02/19 23:59:27  pauloscustodio
* BUG_0042: 64-bit portability issues
* size_t changes to unsigned long in 64-bit. Usage of size_t * to
* retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
* breaks on a 64-bit architecture. Make the functions return the value instead
* of being passed the pointer to the return value, so that the compiler
* takes care of size convertions.
* Create uint and ulong, use uint instead of size_t.
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
* Revision 1.8  2013/12/15 13:18:34  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.7  2013/02/25 21:36:17  pauloscustodio
* Uniform the APIs of classhash, classlist, strhash, strlist
*
* Revision 1.6  2013/02/02 00:07:35  pauloscustodio
* StrHash_next() returns value instead of BOOL
*
* Revision 1.5  2013/01/22 22:24:49  pauloscustodio
* Removed StrHash_set_delptr() - not intuitive and error prone
* Added StrHash_remove_all() to remove all elements
* Added StrHash_remove_elem() to remove one item giving its address
*
* Revision 1.4  2013/01/22 01:02:54  pauloscustodio
* Removed CIRCLEQ from StrHash - redundant, UT_hash_handle contains a double-linked list
* Added StrHash_set_delptr() to define at create-key time the function to free the value when
* the item is deleted later.
* Added StrHash_head() to get head of list - usefull in a delete-all loop.
*
* Revision 1.3  2013/01/20 21:10:32  pauloscustodio
* Rename bool to BOOL, to be consistent with TRUE and FALSE and
* distinguish from C++ bool, true, false
*
* Revision 1.2  2013/01/19 23:52:40  pauloscustodio
* strhash hanged on cleanup - delete by HASH_ITER / HASH_DEL
* instead of traversing CIRCLEQ
*
* Revision 1.1  2013/01/18 22:59:17  pauloscustodio
* CH_0016 : StrHash class to create maps from string to void*
* Created the StrHash to create hash tables mapping string keys kept in
* strpool to void* user pointer.
*
*/
