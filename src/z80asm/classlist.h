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

Lists of objects defined by class.h
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/classlist.h,v 1.1 2013-01-30 00:39:25 pauloscustodio Exp $ */
/* $Log: classlist.h,v $
/* Revision 1.1  2013-01-30 00:39:25  pauloscustodio
/* New CLASS_LIST() to create lists of objects defined with CLASS()
/*
/*
/* */

#ifndef CLASSLIST_H
#define CLASSLIST_H

#include "memalloc.h"   /* before any other include */
#include "queue.h"
#include "types.h"
#include "class.h"

/*-----------------------------------------------------------------------------
*   PUBLIC INTERFACE

// declare the list class
CLASS_LIST(T);			// T is declared by CLASS(T); defines TList

// define the list class
DEF_CLASS_LIST(T);

// methods
TList *list = OBJ_NEW(TList);
T *obj1 = OBJ_NEW(T);
void TList_append(list, obj1);			// append to end

TListElem *iter;
TList_first(list, &iter);
while (obj = TList_next(list, &iter)) {...}

*----------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------
*   Class declaration
*----------------------------------------------------------------------------*/
#define CLASS_LIST(T) _CLASS_LIST(T)
#define _CLASS_LIST(T)														\
	/* list element, contains obj pointer to T of element */				\
	typedef struct T##ListElem												\
	{																		\
		T *obj;		                			/* contained object */		\
		TAILQ_ENTRY( T##ListElem ) entries;   	/* Tail queue. */			\
	} T##ListElem;															\
																			\
	/* list class */														\
	CLASS( T##List )														\
		TAILQ_HEAD( T##ListHead, T##ListElem ) head; 	/* head of queue */	\
	END_CLASS;																\
																			\
	/* methods */															\
	extern void T##List_append( T##List *self, T *obj );					\
	extern void T##List_first(  T##List *self, T##ListElem **iter );		\
	extern T   *T##List_next(   T##List *self, T##ListElem **iter );		

/*-----------------------------------------------------------------------------
*   Class definition
*----------------------------------------------------------------------------*/
#define DEF_CLASS_LIST(T) _DEF_CLASS_LIST(T)
#define _DEF_CLASS_LIST(T)													\
	/* define the class */													\
	DEF_CLASS(T##List)														\
																			\
	void T##List_init ( T##List *self )										\
	{																		\
		TAILQ_INIT( &self->head );											\
	}																		\
																			\
	void T##List_copy ( T##List *self, T##List *other )						\
	{																		\
		T##ListElem *elem;													\
																			\
		/* create new list and copy element by element from other */		\
		TAILQ_INIT( &self->head );											\
																			\
		TAILQ_FOREACH( elem, &other->head, entries )						\
		{																	\
			ObjList_append( self, T##_clone( elem->obj ) );					\
		}																	\
	}																		\
																			\
	void T##List_fini ( T##List *self )										\
	{																		\
		T##ListElem *elem;													\
																			\
		while ( elem = TAILQ_FIRST( &self->head ) )							\
		{																	\
			TAILQ_REMOVE( &self->head, elem, entries );						\
																			\
			OBJ_DELETE( elem->obj );										\
			xfree( elem );													\
		}																	\
	}																		\
																			\
	/* append to list */													\
	void T##List_append( T##List *self, T *obj )							\
	{																		\
		T##ListElem *elem = xcalloc_struct( T##ListElem );					\
		elem->obj = obj;													\
		OBJ_AUTODELETE(obj) = FALSE;		/* deleted by list */			\
		TAILQ_INSERT_TAIL( &self->head, elem, entries );					\
	}																		\
																			\
	/* init iterator */														\
	void T##List_first( T##List *self, T##ListElem **iter )					\
	{																		\
		*iter = NULL;														\
	}																		\
																			\
	/* get next object */													\
	T *T##List_next( T##List *self, T##ListElem **iter )					\
	{																		\
		if ( *iter == NULL )												\
		{																	\
			*iter = TAILQ_FIRST( &self->head );		/* first time */		\
		}																	\
		else																\
		{																	\
			*iter = TAILQ_NEXT( *iter, entries );	/* 2nd & following */	\
		}																	\
																			\
		return *iter == NULL ? NULL : ( *iter )->obj;						\
	}																		

#endif /* ndef CLASSLIST_H */
