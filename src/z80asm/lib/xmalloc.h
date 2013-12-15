/*
Memory allocation routines with automatic garbage collection on exit,
Simple fence mechanism and exception thrown on out of memory.
Only works for memory allocated by xmalloc and freed by xfree.
Use MS Visual Studio malloc debug for any allocation not using xmalloc/xfree

Copyright (C) Paulo Custodio, 2011-2013

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/Attic/xmalloc.h,v 1.1 2013-12-15 13:18:43 pauloscustodio Exp $
*/

#pragma once

/* include stdlib.h before crtdbg.h */
#include <stdlib.h>

/* MS Visual Studio malloc debug */
#ifdef _CRTDBG_MAP_ALLOC        
#include <crtdbg.h>
#endif
#include <string.h>
#include <stdio.h>

/*-----------------------------------------------------------------------------
*   PUBLIC INTERFACE
*   alloc memory
*   dies on allocation failure or buffer overruns
*----------------------------------------------------------------------------*/

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


/*
* $Log: xmalloc.h,v $
* Revision 1.1  2013-12-15 13:18:43  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.9  2013/09/01 11:52:55  pauloscustodio
* Setup xmalloc on init.c.
* Setup GLib memory allocation functions to use xmalloc functions.
*
* Revision 1.8  2013/09/01 00:18:28  pauloscustodio
* - Replaced e4c exception mechanism by a much simpler one based on a few
*   macros. The former did not allow an exit(1) to be called within a
*   try-catch block.
*
* Revision 1.7  2013/01/20 21:24:28  pauloscustodio
* Updated copyright year to 2013
*
* Revision 1.6  2012/05/24 17:09:27  pauloscustodio
* Unify copyright header
*
* Revision 1.5  2012/05/20 06:39:27  pauloscustodio
* astyle
*
* Revision 1.4  2012/05/20 06:02:09  pauloscustodio
* Garbage collector
* Added automatic garbage collection on exit and simple fence mechanism
* to detect buffer underflow and overflow, to xmalloc functions.
* No longer needed to call init_malloc().
* No longer need to try/catch during creation of memory structures to
* free partially created data - all not freed data is freed atexit().
* Renamed xfree0() to xfree().
*
* Revision 1.3  2012/05/11 19:29:49  pauloscustodio
* Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, 
* indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
*         --mode=c
*         --lineend=linux
*         --indent=spaces=4
*         --style=ansi --add-brackets
*         --indent-switches --indent-classes
*         --indent-preprocessor --convert-tabs
*         --break-blocks
*         --pad-oper --pad-paren-in --pad-header --unpad-paren
*         --align-pointer=name
*
* Revision 1.2  2011/08/05 19:49:13  pauloscustodio
* CH_0004 : Exception mechanism to handle fatal errors
* New memory allocation functions xmalloc, xcalloc, ... that raise an exception if the memory cannot be allocated.
* New xfree0() macro which only frees if the pointer in non-null, and
* sets the poiter to NULL afterwards, to avoid any used of the freed memory.
*
* Revision 1.1  2011/07/18 00:43:35  pauloscustodio
* Initialize MS Visual Studio DEBUG build to show memory leaks on exit
*
*/
