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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/strhash.h,v 1.7 2013-02-25 21:36:17 pauloscustodio Exp $ */
/* $Log: strhash.h,v $
/* Revision 1.7  2013-02-25 21:36:17  pauloscustodio
/* Uniform the APIs of classhash, classlist, strhash, strlist
/*
/* Revision 1.6  2013/02/02 00:07:35  pauloscustodio
/* StrHash_next() returns value instead of BOOL
/*
/* Revision 1.5  2013/01/22 22:24:49  pauloscustodio
/* Removed StrHash_set_delptr() - not intuitive and error prone
/* Added StrHash_remove_all() to remove all elements
/* Added StrHash_remove_elem() to remove one item giving its address
/*
/* Revision 1.4  2013/01/22 01:02:54  pauloscustodio
/* Removed CIRCLEQ from StrHash - redundant, UT_hash_handle contains a double-linked list
/* Added StrHash_set_delptr() to define at create-key time the function to free the value when
/* the item is deleted later.
/* Added StrHash_head() to get head of list - usefull in a delete-all loop.
/*
/* Revision 1.3  2013/01/20 21:10:32  pauloscustodio
/* Rename bool to BOOL, to be consistent with TRUE and FALSE and
/* distinguish from C++ bool, true, false
/*
/* Revision 1.2  2013/01/19 23:52:40  pauloscustodio
/* strhash hanged on cleanup - delete by HASH_ITER / HASH_DEL
/* instead of traversing CIRCLEQ
/*
/* Revision 1.1  2013/01/18 22:59:17  pauloscustodio
/* CH_0016 : StrHash class to create maps from string to void*
/* Created the StrHash to create hash tables mapping string keys kept in
/* strpool to void* user pointer.
/*
/*
/* */

#ifndef STRHASH_H
#define STRHASH_H

#include "memalloc.h"   /* before any other include */
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
	StrHashElem		*hash;			/* hash table of all keys */
END_CLASS;

/* compare function used by sort */
typedef int (*StrHash_compare_func)(StrHashElem *a, StrHashElem *b);

/* add new key/value to the list, create new entry if new key, 
   overwrite if key exists */
extern void StrHash_set( StrHash *self, char *key, void *value );

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

#endif /* ndef STRHASH_H */
