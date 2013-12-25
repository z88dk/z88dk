/*
Hash of strings to objects defined by CLASS(), including doubly-linked list of all strings to be
able to retrieve in the order added.
Keys are kept in strpool, no need to release memory.
Uses StrHash to keep the keys, takes care of memory allocation of values.

Copyright (C) Paulo Custodio, 2011-2013

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/classhash.h,v 1.1 2013-12-25 17:37:13 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */
#include "queue.h"
#include "types.h"
#include "class.h"
#include "strhash.h"

/*-----------------------------------------------------------------------------
*   PUBLIC INTERFACE

// declare the hash class
CLASS_HASH(T);			// T is declared by CLASS(T); defines THash

// define the hash class
DEF_CLASS_HASH(T);

*----------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------
*   Class declaration
*----------------------------------------------------------------------------*/
#define CLASS_HASH(T)														\
	/* hash class */														\
	CLASS( T##Hash )														\
		StrHash *hash;		/* map keys to T* */							\
	END_CLASS;																\
																			\
	/* iterator class */													\
	typedef StrHashElem T##HashElem;										\
																			\
	/* compare function used by sort */										\
	typedef int (*T##Hash_compare_func)(T##HashElem *a, T##HashElem *b);	\
																			\
	/* add new key/value to the list, create new entry if new key, */		\
	/* overwrite if key exists */											\
	extern void T##Hash_set( T##Hash *self, char *key, T *obj );			\
																			\
	/* retrive value for a given key, return NULL if not found */			\
	extern T *T##Hash_get( T##Hash *self, char *key );						\
																			\
	/* Check if a key exists in the hash */									\
	extern BOOL T##Hash_exists( T##Hash *self, char *key );					\
																			\
	/* Remove element from hash if found */									\
	extern void T##Hash_remove( T##Hash *self, char *key );					\
																			\
	/* Remove all entries */												\
	extern void T##Hash_remove_all( T##Hash *self );						\
																			\
	/* Find a hash entry */													\
	extern T##HashElem *T##Hash_find( T##Hash *self, char *key );			\
																			\
	/* Delete a hash entry if not NULL */									\
	extern void T##Hash_remove_elem( T##Hash *self, T##HashElem *elem );	\
																			\
	/* get the iterator of the first element in the list, NULL if empty */	\
	extern T##HashElem *T##Hash_first( T##Hash *self );						\
																			\
	/* get the iterator of the next element in the list, NULL at end */		\
	extern T##HashElem *T##Hash_next( T##HashElem *iter );					\
																			\
	/* check if hash is empty */											\
	extern BOOL T##Hash_empty( T##Hash *self );								\
																			\
	/* sort the items in the hash */										\
	extern void T##Hash_sort( T##Hash *self, T##Hash_compare_func compare );\

/*-----------------------------------------------------------------------------
*   Class definition
*----------------------------------------------------------------------------*/
#define DEF_CLASS_HASH(T)													\
	/* define the class */													\
	DEF_CLASS(T##Hash);														\
																			\
	void T##Hash_init ( T##Hash *self )										\
	{																		\
		self->hash = OBJ_NEW(StrHash);										\
	}																		\
																			\
	void T##Hash_copy ( T##Hash *self, T##Hash *other )						\
	{																		\
		StrHashElem *iter;													\
																			\
		/* create new hash and copy element by element from other */		\
		self->hash = OBJ_NEW(StrHash);										\
																			\
		for ( iter = StrHash_first(other->hash) ; iter != NULL ;			\
		      iter = StrHash_next(iter) )		 							\
		{																	\
			T##Hash_set( self,		 										\
						 iter->key, T##_clone( (T *) iter->value ) );		\
		}																	\
	}																		\
																			\
	void T##Hash_fini ( T##Hash *self )										\
	{																		\
		T##Hash_remove_all( self );											\
	}																		\
																			\
	/* set key/value, delete old value if any */							\
	void T##Hash_set( T##Hash *self, char *key, T *obj )					\
	{																		\
		T *old;																\
																			\
		/* delete old, if any */											\
		old = (T *) StrHash_get( self->hash, key );							\
		if ( old ) 															\
		{																	\
			OBJ_DELETE( old );												\
		}																	\
																			\
		/* set new value */													\
		StrHash_set( self->hash, key, (void *) obj );						\
		OBJ_AUTODELETE(obj) = FALSE;		/* deleted by hash */			\
	}																		\
																			\
	/* get value, NULL if not defined */									\
	T *T##Hash_get( T##Hash *self, char *key )								\
	{																		\
		return (T *) StrHash_get( self->hash, key );						\
	}																		\
																			\
	/* check if element exists */											\
	BOOL T##Hash_exists( T##Hash *self, char *key )							\
	{																		\
		return StrHash_exists( self->hash, key );							\
	}																		\
																			\
	/* remove element if it exists */										\
	void T##Hash_remove( T##Hash *self, char *key )							\
	{																		\
		T##HashElem *elem;													\
																			\
		elem = T##Hash_find( self, key );									\
		T##Hash_remove_elem( self, elem );									\
	}																		\
																			\
	/* remove all elements */												\
	void T##Hash_remove_all( T##Hash *self )								\
	{																		\
		T##HashElem *elem;													\
																			\
		while ( ( elem = T##Hash_first( self ) ) != NULL )					\
		{																	\
			T##Hash_remove_elem( self, elem );								\
		}																	\
	}																		\
																			\
	/* find a hash entry */													\
	T##HashElem *T##Hash_find( T##Hash *self, char *key )					\
	{																		\
		return StrHash_find( self->hash, key );								\
	}																		\
																			\
	/* delete a hash entry if not NULL */									\
	void T##Hash_remove_elem( T##Hash *self, T##HashElem *elem )			\
	{																		\
		T *obj;																\
																			\
		if ( elem )															\
		{																	\
			obj = (T *)elem->value;											\
			OBJ_DELETE( obj );												\
			StrHash_remove_elem( self->hash, elem );						\
		}																	\
	}																		\
																			\
	/* get first hash entry, maybe NULL */									\
	T##HashElem *T##Hash_first( T##Hash *self )								\
	{																		\
		return StrHash_first( self->hash );									\
	}																		\
																			\
	/* get the iterator of the next element in the list, NULL at end */		\
	T##HashElem *T##Hash_next( T##HashElem *iter )							\
	{																		\
		return StrHash_next( iter );										\
	}																		\
																			\
	/* check if hash is empty */											\
	BOOL T##Hash_empty( T##Hash *self )										\
	{																		\
		return T##Hash_first(self) == NULL ? TRUE : FALSE;					\
	}																		\
																			\
	/* sort the items in the hash */										\
	void T##Hash_sort( T##Hash *self, T##Hash_compare_func compare )		\
	{																		\
		StrHash_sort( self->hash, compare );								\
	}																		\


/* 
* $Log: classhash.h,v $
* Revision 1.1  2013-12-25 17:37:13  pauloscustodio
* Move classlist and classhash to the z80asm/lib directory
*
* Revision 1.3  2013/12/15 13:18:33  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.2  2013/02/25 21:36:17  pauloscustodio
* Uniform the APIs of classhash, classlist, strhash, strlist
*
* Revision 1.1  2013/02/02 00:08:26  pauloscustodio
* New CLASS_HASH() to create hash tables of objects defined by CLASS()
*
*/
