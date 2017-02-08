/*
Z88DK Z80 Macro Assembler

Lists of objects defined by class.h

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#pragma once

#include "alloc.h"
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
		size_t count;							/* number of objects */		\
		TAILQ_HEAD( T##ListHead, T##ListElem ) head; 	/* head of queue */	\
	END_CLASS;																\
																			\
	/* add object to end of list - list becomes owner of obj */				\
	extern void T##List_push( T##List **pself, T *obj );					\
																			\
	/* extract object from end of list - caller becomes owner of obj */		\
	extern T *T##List_pop( T##List *self );									\
																			\
	/* add object to start of list - list becomes owner of obj */			\
	extern void T##List_unshift( T##List **pself, T *obj );					\
																			\
	/* extract object from start of list - caller becomes owner of obj */	\
	extern T *T##List_shift( T##List *self );								\
																			\
	/* set iterator to start and end of list, object is iter->obj */		\
	extern T##ListElem *T##List_first( T##List *self );						\
	extern T##ListElem *T##List_last ( T##List *self );						\
																			\
	/* advance iterator to next/previous element */							\
	extern T##ListElem *T##List_next( T##ListElem *iter );					\
	extern T##ListElem *T##List_prev( T##ListElem *iter );					\
																			\
	/* insert object before/after a given iterator, list becomes owner */	\
	extern void T##List_insert_after ( T##List **pself, 					\
									   T##ListElem *iter, T *obj );			\
	extern void T##List_insert_before( T##List **pself, 					\
									   T##ListElem *iter, T *obj );			\
																			\
	/* remove and return object pointed by iterator, caller becomes owner */\
	/* advance iterator to next element */									\
	extern T *T##List_remove( T##List *self, T##ListElem **iter );			\
																			\
	/* remove all objects from the list */									\
	extern void T##List_remove_all( T##List *self );						\
																			\
	/* check if list is empty */											\
	extern Bool T##List_empty( T##List *self );								\
 
/*-----------------------------------------------------------------------------
*   Class definition
*----------------------------------------------------------------------------*/
#define DEF_CLASS_LIST(T)													\
	/* define the class */													\
	DEF_CLASS(T##List)														\
																			\
	void T##List_init ( T##List *self )										\
	{																		\
		self->count = 0;													\
		TAILQ_INIT( &self->head );											\
	}																		\
																			\
	void T##List_copy ( T##List *self, T##List *other )						\
	{																		\
		T##ListElem *elem;													\
																			\
		/* create new list and copy element by element from other */		\
		self->count = 0;													\
		TAILQ_INIT( &self->head );											\
																			\
		TAILQ_FOREACH( elem, &other->head, entries )						\
		{																	\
			T##List_push( &self, T##_clone( elem->obj ) );					\
		}																	\
	}																		\
																			\
	void T##List_fini ( T##List *self )										\
	{																		\
		T##List_remove_all( self );											\
	}																		\
																			\
	/* create a new element */												\
	T##ListElem *T##List_new_elem( T##List **pself, T *obj )				\
	{																		\
		T##ListElem *elem;													\
																			\
		INIT_OBJ( T##List, pself );											\
																			\
		elem = m_new(T##ListElem);											\
		elem->obj = obj;													\
		OBJ_AUTODELETE(obj) = FALSE;		/* deleted by list */			\
																			\
		(*pself)->count++;													\
		return elem;														\
	}																		\
																			\
	/* remove element and return object */									\
	T *T##List_remove_elem( T##List *self, T##ListElem *elem )				\
	{																		\
		T *obj;																\
																			\
		if ( self == NULL || elem == NULL )									\
			return NULL;													\
																			\
		obj = elem->obj;													\
		OBJ_AUTODELETE(obj) = TRUE;		/* deleted by caller */				\
																			\
		TAILQ_REMOVE( &self->head, elem, entries);							\
		m_free( elem );														\
																			\
		self->count--;														\
		return obj;															\
	}																		\
																			\
	/* add object to end of list - list becomes owner of the obj */			\
	void T##List_push( T##List **pself, T *obj )							\
	{																		\
		T##ListElem *elem = T##List_new_elem( pself, obj );					\
		TAILQ_INSERT_TAIL( &(*pself)->head, elem, entries );				\
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
	void T##List_unshift( T##List **pself, T *obj )							\
	{																		\
		T##ListElem *elem = T##List_new_elem( pself, obj );					\
		TAILQ_INSERT_HEAD( &(*pself)->head, elem, entries );				\
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
		return self == NULL ? NULL : TAILQ_FIRST( &self->head );			\
	}																		\
																			\
	/* set iterator to end of list, object is iter->obj */					\
	T##ListElem *T##List_last( T##List *self )								\
	{																		\
		return self == NULL ? NULL : TAILQ_LAST( &self->head, T##ListHead );\
	}																		\
																			\
	/* advance iterator to next element */									\
	T##ListElem *T##List_next( T##ListElem *iter )							\
	{																		\
		return iter == NULL ? NULL : TAILQ_NEXT( iter, entries );			\
	}																		\
																			\
	/* advance iterator to previous element */								\
	T##ListElem *T##List_prev( T##ListElem *iter )							\
	{																		\
		return iter == NULL ? NULL : TAILQ_PREV( iter, T##ListHead, entries );\
	}																		\
																			\
	/* insert an object before/after a given iterator, list becomes owner */\
	void T##List_insert_after( T##List **pself, T##ListElem *iter, T *obj )	\
	{																		\
		T##ListElem *elem;													\
																			\
		if ( iter == NULL )													\
			T##List_push( pself, obj );										\
		else																\
		{																	\
			elem = T##List_new_elem( pself, obj );							\
			TAILQ_INSERT_AFTER( &(*pself)->head, iter, elem, entries );		\
		}																	\
	}																		\
																			\
	/* insert an object before/after a given iterator, list becomes owner */\
	void T##List_insert_before( T##List **pself, T##ListElem *iter, T *obj )\
	{																		\
		T##ListElem *elem;													\
																			\
		if ( iter == NULL )													\
			T##List_unshift( pself, obj );									\
		else																\
		{																	\
			elem = T##List_new_elem( pself, obj );							\
			TAILQ_INSERT_BEFORE( iter, elem, entries );						\
		}																	\
	}																		\
																			\
	/* remove and return object pointed by iterator, caller becomes owner */\
	/* advance iterator to next element */									\
	T *T##List_remove( T##List *self, T##ListElem **piter )					\
	{																		\
		T##ListElem *old_iter;												\
																			\
		if ( self == NULL )													\
			return NULL;													\
																			\
		old_iter = *piter;													\
		*piter = T##List_next(*piter);										\
		return T##List_remove_elem( self, old_iter );						\
	}																		\
																			\
	/* remove all objects from the list */									\
	void T##List_remove_all( T##List *self )								\
	{																		\
		T##ListElem *elem;													\
		T *obj;																\
																			\
		if ( self == NULL )													\
			return;															\
																			\
		while ( ( elem = T##List_first(self) ) != NULL )					\
		{																	\
			obj = T##List_remove( self, &elem );							\
			OBJ_DELETE( obj );												\
		}																	\
	}																		\
																			\
	/* check if list is empty */											\
	Bool T##List_empty( T##List *self )										\
	{																		\
		return T##List_first(self) == NULL ? TRUE : FALSE;					\
	}
