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

Fixed-size circular ring of objects defined by class.h
Objects are pre-allocated and cleared before being returned to caller as new elements.


$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/classring.h,v 1.5 2013-12-15 19:01:07 pauloscustodio Exp $
$Log: classring.h,v $
Revision 1.5  2013-12-15 19:01:07  pauloscustodio
Move platform specific defines from types.h to config.h.
Remove dependency of types.h from glib.h.
Use NUM_ELEMS() instead of glib G_N_ELEMENTS().

Revision 1.4  2013/12/15 13:18:33  pauloscustodio
Move memory allocation routines to lib/xmalloc, instead of glib,
introduce memory leak report on exit and memory fence check.

Revision 1.3  2013/09/01 18:45:35  pauloscustodio
Remove NUM_ELEMS, use G_N_ELEMENTS instead (from glib.h)
Remove FALSE, TRUE, MIN, MAX; defined in glib.h

Revision 1.2  2013/04/14 18:18:40  pauloscustodio
Was missing setting autodelete of children to false, caused multiple frees on some occasions.
Warnings.

Revision 1.1  2013/04/13 15:55:10  pauloscustodio
New CLASS_RING for circular queue of tokens pre-allocated to spare the
alloc/free for each token received from the lexer, and to allow quick
look-ahead for the parser without the need to push back tokens.


*/

#ifndef CLASSRING_H
#define CLASSRING_H

#include "xmalloc.h"   /* before any other include */
#include "types.h"
#include "class.h"

/*-----------------------------------------------------------------------------
*   PUBLIC INTERFACE

// declare the ring class
CLASS_RING(T, SIZE);	// T is declared by CLASS(T); defines TRing
						// needs a T_clear(T *self) method

// define the ring class
DEF_CLASS_RING(T);

*----------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------
*   Class declaration
*----------------------------------------------------------------------------*/
#define CLASS_RING(T,SIZE) 													\
	/* circular ring class */												\
	CLASS( T##Ring )														\
		int first, last;					/* point to first and last */	\
		T *queue[SIZE+1]; 					/* circular ring */				\
	END_CLASS;																\
																			\
	/* add object to end of ring - clear the element and return pointer */	\
	/* return NULL if ring is full */										\
	extern T *T##Ring_push( T##Ring *self );								\
																			\
	/* remove object from end of ring */									\
	/* return a pointer to the removed object, only valid until */			\
	/* overwritten by new data added to the ring */							\
	extern T *T##Ring_pop( T##Ring *self );									\
																			\
	/* add object to start of ring - clear the element and return pointer */\
	/* return NULL if ring is full */										\
	extern T *T##Ring_unshift( T##Ring *self );								\
																			\
	/* remove object from start of ring */									\
	/* return a pointer to the removed object, only valid until */			\
	/* overwritten by new data added to the ring */							\
	extern T *T##Ring_shift( T##Ring *self );								\
																			\
	/* check if ring is empty */											\
	extern BOOL T##Ring_empty( T##Ring *self );								\
																			\
	/* check if ring is full */												\
	extern BOOL T##Ring_full( T##Ring *self );								\
																			\
	/* get pointer to ring element number N for N=0,1,2,..,-2,-1 */			\
	/* return NULL if element N does not exist */							\
	extern T *T##Ring_get( T##Ring *self, int n );							\

/*-----------------------------------------------------------------------------
*   Class definition
*----------------------------------------------------------------------------*/
#define DEF_CLASS_RING(T)													\
	/* define the class */													\
	DEF_CLASS(T##Ring)														\
																			\
	void T##Ring_init ( T##Ring *self )										\
	{																		\
		int i;																\
		for ( i = 0; i < NUM_ELEMS(self->queue); i++ ) 						\
		{																	\
			self->queue[i] = OBJ_NEW(T);									\
			OBJ_AUTODELETE( self->queue[i] ) = FALSE;						\
		}																	\
		self->first = self->last = 0;										\
	}																		\
																			\
	void T##Ring_copy ( T##Ring *self, T##Ring *other )						\
	{																		\
		int i;																\
		for ( i = 0; i < NUM_ELEMS(self->queue); i++ )						\
		{																	\
			self->queue[i] = T##_clone( other->queue[i] );					\
		}																	\
	}																		\
																			\
	void T##Ring_fini ( T##Ring *self )										\
	{																		\
		int i;																\
		for ( i = 0; i < NUM_ELEMS(self->queue); i++ ) 						\
		{																	\
			OBJ_DELETE( self->queue[i] );									\
		}																	\
	}																		\
																			\
	/* check if ring is empty */											\
	BOOL T##Ring_empty( T##Ring *self )										\
	{																		\
		return self->first == self->last;									\
	}																		\
																			\
	/* check if ring is full */												\
	BOOL T##Ring_full( T##Ring *self )										\
	{																		\
		return ((self->last + 1) % NUM_ELEMS(self->queue)) == self->first;	\
	}																		\
																			\
	/* get pointer to ring element number N for N=0,1,2,..,-2,-1 */			\
	/* return NULL if element N does not exist */							\
	T *T##Ring_get( T##Ring *self, int n )									\
	{																		\
		int first, last;													\
																			\
		/* normalize first <= last */										\
		first = self->first;												\
		last  = self->last;													\
		if ( first > last )													\
			last += NUM_ELEMS(self->queue);									\
																			\
		/* convert n to index */											\
		if ( n >= 0 ) 			/* positive n */							\
			n += first;														\
		else		 			/* negative n */							\
			n += last;														\
																			\
		/* get object pointer */											\
		if ( n < first || n >= last )										\
			return NULL;													\
		else																\
			return self->queue[ n % NUM_ELEMS(self->queue) ];				\
	}																		\
																			\
	/* add object to end of ring - clear the element and return pointer */	\
	/* return NULL if ring is full */										\
	T *T##Ring_push( T##Ring *self )										\
	{																		\
		T *obj;																\
		if ( T##Ring_full( self ) )											\
			return NULL;													\
		else 																\
		{																	\
			obj = self->queue[ self->last++ ];								\
			self->last %= NUM_ELEMS(self->queue);							\
			T##_clear( obj );												\
			return obj;														\
		}																	\
	}																		\
																			\
	/* add object to start of ring - clear the element and return pointer */\
	/* return NULL if ring is full */										\
	T *T##Ring_unshift( T##Ring *self )										\
	{																		\
		T *obj;																\
		if ( T##Ring_full( self ) )											\
			return NULL;													\
		else 																\
		{																	\
			self->first--;													\
			if ( self->first < 0 )											\
				self->first += NUM_ELEMS(self->queue);						\
			obj = self->queue[ self->first ];								\
			T##_clear( obj );												\
			return obj;														\
		}																	\
	}																		\
																			\
	/* remove object from start of ring */									\
	/* return a pointer to the removed object, only valid until */			\
	/* overwritten by new data added to the ring */							\
	T *T##Ring_shift( T##Ring *self )										\
	{																		\
		T *obj;																\
		if ( T##Ring_empty( self ) )										\
			return NULL;													\
		else 																\
		{																	\
			obj = self->queue[ self->first++ ];								\
			self->first %= NUM_ELEMS(self->queue);							\
			return obj;														\
		}																	\
	}																		\
																			\
	/* remove object from end of ring */									\
	/* return a pointer to the removed object, only valid until */			\
	/* overwritten by new data added to the ring */							\
	T *T##Ring_pop( T##Ring *self )											\
	{																		\
		T *obj;																\
		if ( T##Ring_empty( self ) )										\
			return NULL;													\
		else 																\
		{																	\
			self->last--;													\
			if ( self->last < 0 )											\
				self->last += NUM_ELEMS(self->queue);						\
			obj = self->queue[ self->last ];								\
			return obj;														\
		}																	\
	}																		\


#endif /* ndef CLASSRING_H */
