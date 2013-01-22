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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/strhash.h,v 1.5 2013-01-22 22:24:49 pauloscustodio Exp $ */
/* $Log: strhash.h,v $
/* Revision 1.5  2013-01-22 22:24:49  pauloscustodio
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
*   PUBLIC INTERFACE
*
*   StrHash *self = OBJ_NEW(StrHash);
*   StrHash_set(self, "KEY", (void*)value);	// adds to tail of list
*	value = StrHash_get(self, "KEY"); 		// NULL if not exists
*	if ( StrHash_exists(self, "KEY") ) ...
*   StrHash_remove(self, "KEY");
*
*   StrHashElem *iter; 
*   StrHash_first(self, &iter);
*   while (StrHash_next(self, &iter)) {
*		// use iter->key, iter->value
*	}
*	
*	head = StrHash_head(self);				// element at head of list or NULL
*
*   OBJ_DELETE(StrHash);
*----------------------------------------------------------------------------*/
typedef struct StrHashElem
{
    char    *key; 					/* string kept in strpool.h */
	void	*value;					/* value managed by caller */

    UT_hash_handle hh;      		/* hash table */

} StrHashElem;

CLASS( StrHash )
StrHashElem		*hash_table;		/* hash table of all keys */
END_CLASS;

/* manipulate key, value */
extern void			StrHash_set( StrHash *self, char *key, void *value );
extern void		   *StrHash_get( StrHash *self, char *key );
extern BOOL			StrHash_exists( StrHash *self, char *key );
extern void			StrHash_remove( StrHash *self, char *key );
extern void			StrHash_remove_all( StrHash *self );

/* manipulate StrHashElem */
extern StrHashElem *StrHash_find( StrHash *self, char *key );
extern StrHashElem *StrHash_head( StrHash *self );
extern void 		StrHash_remove_elem( StrHash *self, StrHashElem *elem );

/* traverse the list */
extern void			StrHash_first( StrHash *self, StrHashElem **iter );
extern BOOL			StrHash_next( StrHash *self, StrHashElem **iter );

#endif /* ndef STRHASH_H */
