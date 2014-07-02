/*
Memory allocation routines with automatic garbage collection on exit,
Simple fence mechanism and exception thrown on out of memory.
Only works for memory allocated by xmalloc and freed by xfree.
Use MS Visual Studio malloc debug for any allocation not using xmalloc/xfree

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/Attic/xmalloc.h,v 1.7 2014-07-02 23:45:12 pauloscustodio Exp $
*/

#pragma once

/* include stdlib.h before crtdbg.h */
#include <stdlib.h>

/* MS Visual Studio malloc debug */
#ifdef _CRTDBG_MAP_ALLOC
#include <crtdbg.h>
#endif
#include <assert.h>
#include <string.h>
#include <stdio.h>

/* initialize module; called automatically, but may be needed to force
   initialization before user module is initialized
*/
extern void xmalloc_init( void );

extern void *_xmalloc( size_t size, char *file, int lineno );
#define xmalloc(size)   _xmalloc((size), __FILE__, __LINE__)

extern void *_xcalloc( int num, size_t size, char *file, int lineno );
#define xcalloc(num, size)  _xcalloc((num), (size), __FILE__, __LINE__)
#define xnew(type)			((type *)_xcalloc(1, sizeof(type), __FILE__, __LINE__))
#define xnew_n(type, num)	((type *)_xcalloc((num), sizeof(type), __FILE__, __LINE__))

extern void *_xrealloc( void *memptr, size_t size, char *file, int lineno );
#define xrealloc(memptr, size)  _xrealloc((memptr), (size), __FILE__, __LINE__)

extern char *_xstrdup( char *source, char *file, int lineno );
#define xstrdup(source) _xstrdup((source), __FILE__, __LINE__)

extern void _xfree( void *memptr, char *file, int lineno );
#define xfree(memptr)   ( _xfree((memptr), __FILE__, __LINE__), (memptr) = NULL )

/* to use when a function pointer compatible with malloc() and free() is expected */
extern void *xmallocf( size_t size );
extern void  xfreef( void *memptr );

/* show errors on stderr, exit 1 */
#define warn(message,...)      fprintf(stderr, message, ##__VA_ARGS__)
#define die( message,...) do { fprintf(stderr, message, ##__VA_ARGS__); exit(1); } while (0)

/* OS-interface - assert no error */
#define xatexit(func) do { int atexit_ret = atexit(func); assert( atexit_ret == 0 ); } while (0)
