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

#pragma once

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
	size_t 	count;					/* number of objects */
	Bool 	ignore_case;			/* TRUE to ignore case of keys */
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
extern Bool StrHash_exists( StrHash *self, char *key );

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
extern Bool StrHash_empty( StrHash *self );

/* sort the items in the hash */
extern void StrHash_sort( StrHash *self, StrHash_compare_func compare );
