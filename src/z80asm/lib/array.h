/*
Template array that grows on request. Items may move in memory on reallocation.
Uses strutil.h for implementation.

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/array.h,v 1.2 2014-02-19 23:59:27 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"		/* before any other include */

#include "class.h"
#include "types.h"
#include "strutil.h"
#include <stdlib.h>

/*-----------------------------------------------------------------------------
*   ARRAY( T )					// declare class TArray
*	DEF_ARRAY( T )				// define the class
*	arr = OBJ_NEW( TArray )		// create object
*	arr->free_data = elem_free;	// function to free each element
*	T *TArray_item(n)			// expand array if needed and return address of item
*	uint_t TArray_size()		// return number of elements
*	TArray_remove_all()			// free each element and colapse array
*	TArray_unreserve()			// free all unused space of array
*----------------------------------------------------------------------------*/

/* declare */
#define ARRAY( T )															\
	CLASS( T##Array )														\
		Str *items;															\
		void ( *free_data )( void * );	/* function to free an element */	\
										/* called by TArray_remove_all() */	\
	END_CLASS																\
																			\
	extern uint_t	T##Array_size(T##Array *self);							\
	extern T 	   *T##Array_item(T##Array *self, uint_t n);				\
	extern void		T##Array_remove_all(T##Array *self);					\
	extern void		T##Array_unreserve(T##Array *self);						\

/* define */
#define DEF_ARRAY( T )														\
	DEF_CLASS( T##Array )													\
																			\
	void T##Array_init (T##Array *self)										\
	{ 																		\
		self->items = OBJ_NEW( Str );										\
		OBJ_AUTODELETE( self->items ) = FALSE;								\
	}																		\
																			\
	void T##Array_copy (T##Array *self, T##Array *other) 					\
	{ 																		\
		self->items = Str_clone( other->items );							\
	}																		\
																			\
	void T##Array_fini (T##Array *self) 									\
	{ 																		\
		T##Array_remove_all(self);											\
		OBJ_DELETE(self->items);											\
	}																		\
																			\
	uint_t T##Array_size(T##Array *self)									\
	{																		\
		return self->items->len / sizeof(T);								\
	}																		\
																			\
	T *T##Array_item(T##Array *self, uint_t n)								\
	{																		\
		uint_t old_size, new_size, new_bytes;								\
																			\
		old_size = T##Array_size(self);										\
		new_size = MAX( old_size, n + 1 );									\
																			\
		/* create new empty elements */										\
		if ( new_size > old_size )											\
		{																	\
			new_bytes = (new_size - old_size) * sizeof(T);					\
			Str_reserve(self->items, new_bytes );							\
			self->items->len += new_bytes;									\
			memset( (T *)self->items->str + old_size, 0, new_bytes );		\
		}																	\
																			\
		/* return address of n-item */										\
		return (T *)self->items->str + n;									\
	}																		\
																			\
	void T##Array_remove_all(T##Array *self)								\
	{																		\
		uint_t size, i;														\
																			\
		if ( self->free_data != NULL )										\
		{																	\
			size = T##Array_size(self);										\
			for ( i = 0; i < size; i++ )									\
				self->free_data( T##Array_item(self, i) );					\
		}																	\
		Str_clear(self->items);												\
	}																		\
																			\
	void T##Array_unreserve(T##Array *self)									\
	{																		\
		Str_unreserve(self->items);											\
	}																		\


/*
* $Log: array.h,v $
* Revision 1.2  2014-02-19 23:59:27  pauloscustodio
* BUG_0041: 64-bit portability issues
* size_t changes to unsigned long in 64-bit. Usage of size_t * to
* retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
* breaks on a 64-bit architecture. Make the functions return the value instead
* of being passed the pointer to the return value, so that the compiler
* takes care of size convertions.
* Create uint_t and ulong_t, use uint_t instead of size_t.
*
* Revision 1.1  2014/02/17 22:05:20  pauloscustodio
* Template array that grows on request. Items may move in memory on reallocation.
* Uses strutil.h for implementation.
*
*
*/