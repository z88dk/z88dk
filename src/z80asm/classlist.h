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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/classlist.h,v 1.4 2013-09-08 08:29:21 pauloscustodio Exp $ */
/* $Log: classlist.h,v $
/* Revision 1.4  2013-09-08 08:29:21  pauloscustodio
/* Replaced xmalloc et al with g_malloc0 et al.
/*
/* Revision 1.3  2013/02/25 21:36:17  pauloscustodio
/* Uniform the APIs of classhash, classlist, strhash, strlist
/*
/* Revision 1.2  2013/01/30 20:38:59  pauloscustodio
/* Double macro call not necessary
/*
/* Revision 1.1  2013/01/30 00:39:25  pauloscustodio
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

*----------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------
*   Class declaration
*----------------------------------------------------------------------------*/
#define CLASS_LIST(T) 														\
	/* list element, contains obj pointer to T of element */				\
	typedef struct T##ListElem												\
	{																		\
		T *obj;		                			/* contained object */		\
		TAILQ_ENTRY( T##ListElem ) entries;   	/* Tail queue. */			\
	} T##ListElem;															\
																			\
	/* list class */														\
	CLASS( T##List )														\
		int count;								/* number of objects */		\
		TAILQ_HEAD( T##ListHead, T##ListElem ) head; 	/* head of queue */	\
	END_CLASS;																\
																			\
	/* add object to end of list - list becomes owner of obj */				\
	extern void T##List_push( T##List *self, T *obj );						\
																			\
	/* extract object from end of list - caller becomes owner of obj */		\
	extern T *T##List_pop( T##List *self );									\
																			\
	/* add object to start of list - list becomes owner of obj */			\
	extern void T##List_unshift( T##List *self, T *obj );					\
																			\
	/* extract object from start of list - caller becomes owner of obj */	\
	extern T *T##List_shift( T##List *self );								\
																			\
	/* set iterator to start and end of list, object is iter->obj */		\
	extern T##ListElem *T##List_first( T##List *self );						\
	extern T##ListElem *T##List_last( T##List *self );						\
																			\
	/* advance iterator to next/previous element */							\
	extern T##ListElem *T##List_next( T##ListElem *iter );					\
	extern T##ListElem *T##List_prev( T##ListElem *iter );					\
																			\
	/* insert object before/after a given iterator, list becomes owner */	\
	extern T##ListElem *T##List_insert_after( T##List *self, 				\
								T##ListElem *iter, T *obj );				\
	extern T##ListElem *T##List_insert_before( T##List *self, 				\
								T##ListElem *iter, T *obj );				\
																			\
	/* remove and return object pointed by iterator, caller becomes owner */\
	/* advance iterator to next element */									\
	extern T *T##List_remove( T##List *self, T##ListElem **iter );			\
																			\
	/* remove all objects from the list */									\
	extern void T##List_remove_all( T##List *self );						\
																			\
	/* check if list is empty */											\
	extern BOOL T##List_empty( T##List *self );								\

/*-----------------------------------------------------------------------------
*   Class definition
*----------------------------------------------------------------------------*/
#define DEF_CLASS_LIST(T)													\
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
		self->count = 0;													\
																			\
		TAILQ_FOREACH( elem, &other->head, entries )						\
		{																	\
			T##List_push( self, T##_clone( elem->obj ) );					\
		}																	\
	}																		\
																			\
	void T##List_fini ( T##List *self )										\
	{																		\
		T##List_remove_all( self );											\
	}																		\
																			\
	/* create a new element */												\
	T##ListElem *T##List_new_elem( T##List *self, T *obj )					\
	{																		\
		T##ListElem *elem = g_new0( T##ListElem, 1 );						\
		elem->obj = obj;													\
		OBJ_AUTODELETE(obj) = FALSE;		/* deleted by list */			\
		self->count++;														\
		return elem;														\
	}																		\
																			\
	/* remove element and return object */									\
	T *T##List_remove_elem( T##List *self, T##ListElem *elem )				\
	{																		\
		T *obj;																\
																			\
		if ( elem == NULL )													\
			return NULL;													\
																			\
		obj = elem->obj;													\
		OBJ_AUTODELETE(obj) = TRUE;		/* deleted by caller */				\
		TAILQ_REMOVE( &self->head, elem, entries);							\
		g_free( elem );														\
		self->count--;														\
		return obj;															\
	}																		\
																			\
	/* add object to end of list - list becomes owner of the obj */			\
	void T##List_push( T##List *self, T *obj )								\
	{																		\
		T##ListElem *elem = T##List_new_elem( self, obj );					\
		TAILQ_INSERT_TAIL( &self->head, elem, entries );					\
	}																		\
																			\
	/* extract object from end of list - caller becomes owner of the obj */	\
	T *T##List_pop( T##List *self )											\
	{																		\
		T##ListElem *elem = T##List_last( self );							\
		return T##List_remove_elem( self, elem );							\
	}																		\
																			\
	/* add object to start of list - list becomes owner of the object */	\
	void T##List_unshift(T##List *self, T *obj )							\
	{																		\
		T##ListElem *elem = T##List_new_elem( self, obj );					\
		TAILQ_INSERT_HEAD( &self->head, elem, entries );					\
	}																		\
																			\
	/* extract object from start of list - caller becomes owner of obj */	\
	T *T##List_shift( T##List *self )										\
	{																		\
		T##ListElem *elem = T##List_first( self );							\
		return T##List_remove_elem( self, elem );							\
	}																		\
																			\
	/* set iterator to start of list, object is iter->obj */				\
	T##ListElem *T##List_first( T##List *self )								\
	{																		\
		return TAILQ_FIRST( &self->head );									\
	}																		\
																			\
	/* set iterator to end of list, object is iter->obj */					\
	T##ListElem *T##List_last( T##List *self )								\
	{																		\
		return TAILQ_LAST( &self->head, T##ListHead );						\
	}																		\
																			\
	/* advance iterator to next element */									\
	T##ListElem *T##List_next( T##ListElem *iter )							\
	{																		\
		return iter == NULL ? NULL :										\
				TAILQ_NEXT( iter, entries );								\
	}																		\
																			\
	/* advance iterator to previous element */								\
	T##ListElem *T##List_prev( T##ListElem *iter )							\
	{																		\
		return iter == NULL ? NULL :										\
				TAILQ_PREV( iter, T##ListHead, entries );					\
	}																		\
																			\
	/* insert an object before/after a given iterator, list becomes owner */\
	T##ListElem *T##List_insert_after( T##List *self, 						\
								T##ListElem *iter, T *obj )					\
	{																		\
		T##ListElem *elem = T##List_new_elem( self, obj );					\
		TAILQ_INSERT_AFTER( &self->head, iter, elem, entries );				\
		return elem;														\
	}																		\
																			\
	/* insert an object before/after a given iterator, list becomes owner */\
	T##ListElem *T##List_insert_before( T##List *self, 						\
								T##ListElem *iter, T *obj )					\
	{																		\
		T##ListElem *elem = T##List_new_elem( self, obj );					\
		TAILQ_INSERT_BEFORE( iter, elem, entries );							\
		return elem;														\
	}																		\
																			\
	/* remove and return object pointed by iterator, caller becomes owner */\
	/* advance iterator to next element */									\
	T *T##List_remove( T##List *self, T##ListElem **iter )					\
	{																		\
		T##ListElem *old_iter = *iter;										\
		*iter = T##List_next(*iter);										\
		return T##List_remove_elem( self, old_iter );						\
	}																		\
																			\
	/* remove all objects from the list */									\
	void T##List_remove_all( T##List *self )								\
	{																		\
		T##ListElem *elem;													\
																			\
		while ( elem = TAILQ_FIRST( &self->head ) )							\
		{																	\
			TAILQ_REMOVE( &self->head, elem, entries );						\
																			\
			OBJ_DELETE( elem->obj );										\
			g_free( elem );													\
			self->count--;													\
		}																	\
	}																		\
																			\
	/* check if list is empty */											\
	BOOL T##List_empty( T##List *self )										\
	{																		\
		return T##List_first(self) == NULL ? TRUE : FALSE;					\
	}																		\


#endif /* ndef CLASSLIST_H */
