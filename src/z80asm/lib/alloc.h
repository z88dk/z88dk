/*
Z88DK Z80 Macro Assembler

Alloc library.

Simple fence mechanism and shows memory leaks on exit.
Descructor function can be declared at allocation time to orderly destroy objects.
Functions die on allocation failure.

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#pragma once

#include "dbg.h"
#include "types.h"
#include <stdlib.h>

/*-----------------------------------------------------------------------------
*   initialize module; called automatically, but may be needed to force
*   initialization before user module is initialized
*----------------------------------------------------------------------------*/

extern void m_alloc_init( void );

/*-----------------------------------------------------------------------------
*   wrappers to stdlib allocation functions that register the allocated 
*	memory block and check for leaks at exit; 
*   use _compat function when a function pointer compatible with stdlib 
*	is required
*----------------------------------------------------------------------------*/

extern void *m_malloc_compat( size_t size );
extern void *m_malloc_( size_t size, char *file, int lineno );
#define      m_malloc( size )	\
						check_mem_die( m_malloc_((size), __FILE__, __LINE__) )

extern void *m_calloc_compat( size_t num, size_t size );
extern void *m_calloc_( size_t num, size_t size, char *file, int lineno );
#define      m_calloc( num, size )	\
						check_mem_die( m_calloc_((num), (size), __FILE__, __LINE__) )

extern char *m_strdup_compat( char *source );
extern char *m_strdup_( char *source, char *file, int lineno );
#define      m_strdup( source )	\
						((char *) check_mem_die( m_strdup_((source), __FILE__, __LINE__) ) )

extern void *m_realloc_compat( void *memptr, size_t size );
extern void *m_realloc_( void *memptr, size_t size, char *file, int lineno );
#define      m_realloc( memptr, size )	\
						check_mem_die( m_realloc_((memptr), (size), __FILE__, __LINE__) )

/* allocate memory for a type / array of types */
#define		 m_new_n( type, num )	\
						((type *)m_calloc((num), sizeof(type)))
#define		 m_new( type )	\
						m_new_n( type, 1 )

/* free sets memptr to NULL to avoid reuse of freed memory block */
extern void  m_free_compat( void *memptr );
extern void  m_free_( void *memptr, char *file, int lineno );
#define      m_free( memptr )	\
						( m_free_((memptr), __FILE__, __LINE__), \
						  (memptr) = NULL )

/*-----------------------------------------------------------------------------
*   Declaration of a destructor function to orderly destroy the objects.
*   Depends on the allocation sequence: first allocate memory for the 
*	children and then allocate memory for the parent. 
*	As destruction is in reverse order, the parent destructor will 
*	free the children.
*	memptr is any memory returned by the allocation functions above.
*   These functions croak if the memory block was not allocated by 
*	m_malloc et.al.
*----------------------------------------------------------------------------*/

/* destroy children - the parent is destoyed by m_free */
typedef void (*destructor_t)(void *memptr);

/* declare a memory object destructor, to be called by m_free() to destroy
   any children - the parent is destoyed by m_free
   Returns pointer to be able to be chained. */
extern void *m_set_destructor_( void *memptr, destructor_t destructor, char *file, int lineno );
#define      m_set_destructor( memptr, destructor )	\
						m_set_destructor_((memptr), (destructor), __FILE__, __LINE__)

/* declare a memory object as part of a collection, so that it is skipped 
   by the garbage collector on the first pass - the parent will destroy 
   it when it is itself destroyed.
   The garbage collector collects memory in the reverse allocation order.
   This flag avoids a list element to be destroyed without removing from the
   list, leaving dangling pointers in the parent.
   Returns pointer to be able to be chained. */
extern void *m_set_in_collection_( void *memptr, Bool in_collection, char *file, int lineno );
#define      m_set_in_collection( memptr )	\
						m_set_in_collection_((memptr), TRUE,  __FILE__, __LINE__)
#define      m_clear_in_collection( memptr )	\
						m_set_in_collection_((memptr), FALSE, __FILE__, __LINE__)

/* declare a memory block as to be destroyed by the garbage collector atexit,
   so that no memory leak warning is given
   Returns pointer to be able to be chained. */
extern void *m_destroy_atexit_( void *memptr, char *file, int lineno );
#define      m_destroy_atexit( memptr )	\
						m_destroy_atexit_((memptr), __FILE__, __LINE__)

/* check if memptr points to a block allocated by m_... */
extern Bool m_is_managed( void *memptr );
