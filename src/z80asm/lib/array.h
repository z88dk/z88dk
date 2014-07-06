/*
Template array that grows on request. Items may move in memory on reallocation.
Uses strutil.h for implementation.

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/array.h,v 1.14 2014-07-06 23:11:25 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"		/* before any other include */

#include "class.h"
#include "types.h"
#include "strutil.h"
#include <assert.h>
#include <stdlib.h>

/*-----------------------------------------------------------------------------
*   ARRAY( T )					// declare class TArray
*	DEF_ARRAY( T )				// define the class
*	arr = OBJ_NEW( TArray )		// create object
*	arr->free_data = elem_free;	// function to free each element
*	T *TArray_item(n)			// expand array if needed and return address of item
*	size_t TArray_size()		// return number of elements
*	TArray_set_size(n)			// set number of elements, call free_data on dropped ones
*	TArray_remove_all()			// free each element and colapse array
*	TArray_unreserve()			// free all unused space of array
*	T *TArray_push()			// add empty element to top, return address
*	T *TArray_top()				// return pointer to top item, NULL if empty
*	TArray_pop()				// drop top element
*----------------------------------------------------------------------------*/

/* declare */
#define ARRAY( T )															\
	CLASS( T##Array )														\
		Str *items;															\
		void ( *free_data )( void * );	/* function to free an element */	\
										/* called by TArray_remove_all() */	\
	END_CLASS																\
																			\
	extern size_t	T##Array_size(T##Array *self);							\
	extern void		T##Array_set_size(T##Array *self, size_t n);			\
	extern T 	   *T##Array_item(T##Array *self, size_t n);				\
	extern void		T##Array_remove_all(T##Array *self);					\
	extern void		T##Array_unreserve(T##Array *self);						\
	extern T	   *T##Array_push(T##Array *self);							\
	extern T	   *T##Array_top(T##Array *self);							\
	extern void		T##Array_pop(T##Array *self);							\


/* default types */
ARRAY( Byte );
ARRAY( UInt );
ARRAY( int );
ARRAY( long );

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
	size_t T##Array_size(T##Array *self)									\
	{																		\
		return self->items->len / sizeof(T);								\
	}																		\
																			\
	void T##Array_set_size(T##Array *self, size_t n)						\
	{																		\
		size_t size, i;														\
																			\
		/* delete old items */												\
		if ( self->free_data != NULL )										\
		{																	\
			size = T##Array_size(self);										\
			for ( i = n; i < size; i++ )									\
				self->free_data( T##Array_item(self, i) );					\
		}																	\
																			\
		/* create new items */												\
		if ( n > 0 )														\
			T##Array_item(self, n-1);										\
		else 																\
			Str_clear(self->items);											\
		self->items->len = n * sizeof(T);									\
	}																		\
																			\
	T *T##Array_item(T##Array *self, size_t n)								\
	{																		\
		size_t old_size, new_size, new_bytes;								\
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
		T##Array_set_size(self, 0);											\
	}																		\
																			\
	void T##Array_unreserve(T##Array *self)									\
	{																		\
		Str_unreserve(self->items);											\
	}																		\
																			\
	T *T##Array_push(T##Array *self)										\
	{																		\
		size_t size = T##Array_size(self);									\
		return T##Array_item(self, size);									\
	}																		\
																			\
	T *T##Array_top(T##Array *self)											\
	{																		\
		size_t size = T##Array_size(self);									\
		return size > 0 ? T##Array_item(self, size - 1) : NULL;				\
	}																		\
																			\
	void T##Array_pop(T##Array *self)										\
	{																		\
		size_t size = T##Array_size(self);									\
		assert( size > 0 );													\
		T##Array_set_size(self, size - 1);									\
	}
