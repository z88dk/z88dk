/*
Hash of strings to objects defined by CLASS(), including doubly-linked list of all strings to be
able to retrieve in the order added.
Keys are kept in strpool, no need to release memory.
Uses StrHash to keep the keys, takes care of memory allocation of values.

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/classhash.h,v 1.8 2014-05-02 21:34:58 pauloscustodio Exp $
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
DEF_CLASS_HASH(T, BOOL ignore_case);	// ignore_case = TRUE for case-insensitive
										// keys

*----------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------
*   Class declaration
*----------------------------------------------------------------------------*/
#define CLASS_HASH(T)														\
	/* hash class */														\
	CLASS( T##Hash )														\
		uint   count;		/* number of objects */							\
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
	extern void T##Hash_set( T##Hash **pself, char *key, T *obj );			\
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
#define DEF_CLASS_HASH(T, _ignore_case)										\
	/* define the class */													\
	DEF_CLASS(T##Hash);														\
																			\
	void T##Hash_init ( T##Hash *self )										\
	{																		\
		self->hash = OBJ_NEW(StrHash);										\
		self->hash->ignore_case = _ignore_case;								\
		self->count = 0;													\
	}																		\
																			\
	void T##Hash_copy ( T##Hash *self, T##Hash *other )						\
	{																		\
		StrHashElem *iter;													\
																			\
		/* create new hash and copy element by element from other */		\
		self->hash = OBJ_NEW(StrHash);										\
		self->count = 0;													\
																			\
		for ( iter = StrHash_first(other->hash) ; iter != NULL ;			\
		      iter = StrHash_next(iter) )		 							\
		{																	\
			T##Hash_set( &self,		 										\
						 iter->key, T##_clone( (T *) iter->value ) );		\
		}																	\
	}																		\
																			\
	void T##Hash_fini ( T##Hash *self )										\
	{																		\
		T##Hash_remove_all( self );											\
	}																		\
																			\
	/* remove all elements */												\
	void T##Hash_remove_all( T##Hash *self )								\
	{																		\
		T##HashElem *elem;													\
																			\
		if ( self == NULL )													\
			return;															\
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
		if ( self == NULL || key == NULL )									\
			return NULL;													\
																			\
		return StrHash_find( self->hash, key );								\
	}																		\
																			\
	/* delete a hash entry if not NULL */									\
	void T##Hash_remove_elem( T##Hash *self, T##HashElem *elem )			\
	{																		\
		T *obj;																\
																			\
		if ( self == NULL || elem == NULL )									\
			return;															\
																			\
		obj = (T *)elem->value;												\
		OBJ_DELETE( obj );													\
		StrHash_remove_elem( self->hash, elem );							\
																			\
		self->count = self->hash->count;									\
	}																		\
																			\
	/* set key/value, delete old value if any */							\
	void T##Hash_set( T##Hash **pself, char *key, T *obj )					\
	{																		\
		T *old;																\
																			\
		INIT_OBJ( T##Hash, pself );											\
																			\
		/* delete old, if any */											\
		old = (T *) StrHash_get( (*pself)->hash, key );						\
		if ( old ) 															\
		{																	\
			OBJ_DELETE( old );												\
		}																	\
																			\
		/* set new value */													\
		StrHash_set( & ((*pself)->hash), key, (void *) obj );				\
		OBJ_AUTODELETE(obj) = FALSE;		/* deleted by hash */			\
		(*pself)->count = (*pself)->hash->count;							\
	}																		\
																			\
	/* get value, NULL if not defined */									\
	T *T##Hash_get( T##Hash *self, char *key )								\
	{																		\
		return self == NULL ? NULL : (T *) StrHash_get( self->hash, key );	\
	}																		\
																			\
	/* check if element exists */											\
	BOOL T##Hash_exists( T##Hash *self, char *key )							\
	{																		\
		return self == NULL ? FALSE : StrHash_exists( self->hash, key );	\
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
	/* get first hash entry, maybe NULL */									\
	T##HashElem *T##Hash_first( T##Hash *self )								\
	{																		\
		return self == NULL ? NULL : StrHash_first( self->hash );			\
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
		if ( self == NULL )													\
			return;															\
																			\
		StrHash_sort( self->hash, compare );								\
	}																		\
 

/*
* $Log: classhash.h,v $
* Revision 1.8  2014-05-02 21:34:58  pauloscustodio
* byte_t, uint_t and ulong_t renamed to byte, uint and ulong
*
* Revision 1.7  2014/04/05 22:02:06  pauloscustodio
* Added ignore_case attribute to allow case-insensitive class hashes
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
* Revision 1.1  2013/12/25 17:37:13  pauloscustodio
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
