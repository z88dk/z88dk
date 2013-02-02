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

Hash of strings to objects defined by CLASS(), including doubly-linked list of all strings to be
able to retrieve in the order added.
Keys are kept in strpool, no need to release memory.
Uses StrHash to keep the keys, takes care of memory allocation of values.
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/classhash.h,v 1.1 2013-02-02 00:08:26 pauloscustodio Exp $ */
/* $Log: classhash.h,v $
/* Revision 1.1  2013-02-02 00:08:26  pauloscustodio
/* New CLASS_HASH() to create hash tables of objects defined by CLASS()
/*
/*
/* */

#ifndef CLASSHASH_H
#define CLASSHASH_H

#include "memalloc.h"   /* before any other include */
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

// methods
THash *hash = OBJ_NEW(THash);
T *obj1 = OBJ_NEW(T);
void THash_set(hash, "KEY", obj1);			// append to end

T *obj2 = THash_get(hash, "KEY"); 			// NULL if not exists

if ( THash_exists(hash, "KEY") ) ...

THash_remove(hash, "KEY");
StrHash_remove_all(hash);

THashElem *iter; 
THash_first(hash, &iter);
while (THash_next(hash, &iter)) {
	// use iter->key, iter->value
}

OBJ_DELETE(THash);

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
	/* methods */															\
	extern void T##Hash_set(    	T##Hash *self, char *key, T *obj );		\
	extern T   *T##Hash_get(    	T##Hash *self, char *key );				\
	extern BOOL T##Hash_exists( 	T##Hash *self, char *key );				\
	extern void T##Hash_remove( 	T##Hash *self, char *key );				\
	extern void T##Hash_remove_all( T##Hash *self );						\
																			\
	extern T##HashElem *T##Hash_find( T##Hash *self, char *key );			\
	extern T##HashElem *T##Hash_head( T##Hash *self );						\
	extern void 		T##Hash_remove_elem( 								\
									  T##Hash *self, T##HashElem *elem );	\
																			\
	extern void T##Hash_first( T##Hash *self, T##HashElem **iter );			\
	extern T   *T##Hash_next(  T##Hash *self, T##HashElem **iter );			\

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
		StrHash_first(other->hash, &iter);									\
		while (StrHash_next(other->hash, &iter)) 							\
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
		while ( elem = T##Hash_head( self ) )								\
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
	/* get first hash entry, maybe NULL */									\
	T##HashElem *T##Hash_head( T##Hash *self )								\
	{																		\
		return StrHash_head( self->hash );									\
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
																			\
	void T##Hash_first( T##Hash *self, T##HashElem **iter )					\
	{																		\
		StrHash_first( self->hash, iter );									\
	}																		\
																			\
	T *T##Hash_next(  T##Hash *self, T##HashElem **iter )					\
	{																		\
		return (T *) StrHash_next( self->hash, iter );						\
	}																		\

#endif /* ndef CLASSHASH_H */
