/*
Z88DK Z80 Macro Assembler

Hash of strings to objects defined by CLASS(), including doubly-linked list of all strings to be
able to retrieve in the order added.
Keys are kept in strpool, no need to release memory.
Uses StrHash to keep the keys, takes care of memory allocation of values.

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#pragma once

#include "queue.h"
#include "types.h"
#include "class.h"
#include "strhash.h"

/*-----------------------------------------------------------------------------
*   PUBLIC INTERFACE

// declare the hash class
CLASS_HASH(T);			// T is declared by CLASS(T); defines THash

// define the hash class
DEF_CLASS_HASH(T, Bool ignore_case);	// ignore_case = TRUE for case-insensitive
										// keys

*----------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------
*   Class declaration
*----------------------------------------------------------------------------*/
#define CLASS_HASH(T)														\
	/* hash class */														\
	CLASS( T##Hash )														\
		size_t   count;		/* number of objects */							\
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
	extern Bool T##Hash_exists( T##Hash *self, char *key );					\
																			\
	/* Remove element from hash if found */									\
	extern void T##Hash_remove( T##Hash *self, char *key );					\
																			\
	/* Extract element from hash if found, return element, undefine key in hash */	\
	extern T *T##Hash_extract( T##Hash *self, char *key );					\
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
	/* Extract element from hash if found, return element, undefine key in hash */	\
	extern T *T##Hash_extract_elem( T##Hash *self, T##HashElem *elem );		\
																			\
	/* get the iterator of the first element in the list, NULL if empty */	\
	extern T##HashElem *T##Hash_first( T##Hash *self );						\
																			\
	/* get the iterator of the next element in the list, NULL at end */		\
	extern T##HashElem *T##Hash_next( T##HashElem *iter );					\
																			\
	/* check if hash is empty */											\
	extern Bool T##Hash_empty( T##Hash *self );								\
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
	/* Extract element from hash if found, return element, undefine key in hash */	\
	T *T##Hash_extract_elem( T##Hash *self, T##HashElem *elem )				\
	{																		\
		T *obj;																\
																			\
		if ( self == NULL || elem == NULL )									\
			return NULL;													\
																			\
		obj = (T *)elem->value;												\
		StrHash_remove_elem( self->hash, elem );							\
																			\
		self->count = self->hash->count;									\
																			\
		return obj;															\
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
	Bool T##Hash_exists( T##Hash *self, char *key )							\
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
	/* Extract element from hash if found, return element, undefine key in hash */	\
	T *T##Hash_extract( T##Hash *self, char *key )							\
	{																		\
		T##HashElem *elem;													\
																			\
		elem = T##Hash_find( self, key );									\
		return T##Hash_extract_elem( self, elem );							\
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
	Bool T##Hash_empty( T##Hash *self )										\
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
	}
