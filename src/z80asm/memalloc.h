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

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2012

Memory allocation routines with automatic garbage collection on exit,
Simple fence mechanism and exception thrown on out of memory.
Only works for memory allocated by xmalloc and freed by xfree.
Use MS Visual Studio malloc debug for any allocation not using xmalloc/xfree
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/memalloc.h,v 1.4 2012-05-20 06:02:09 pauloscustodio Exp $ */
/* $Log: memalloc.h,v $
/* Revision 1.4  2012-05-20 06:02:09  pauloscustodio
/* Garbage collector
/* Added automatic garbage collection on exit and simple fence mechanism
/* to detect buffer underflow and overflow, to memalloc functions.
/* No longer needed to call init_malloc().
/* No longer need to try/catch during creation of memory structures to
/* free partially created data - all not freed data is freed atexit().
/* Renamed xfree0() to xfree().
/*
/* Revision 1.3  2012/05/11 19:29:49  pauloscustodio
/* Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
/*         --mode=c
/*         --lineend=linux
/*         --indent=spaces=4
/*         --style=ansi --add-brackets
/*         --indent-switches --indent-classes
/*         --indent-preprocessor --convert-tabs
/*         --break-blocks
/*         --pad-oper --pad-paren-in --pad-header --unpad-paren
/*         --align-pointer=name
/*
/* Revision 1.2  2011/08/05 19:49:13  pauloscustodio
/* CH_0004 : Exception mechanism to handle fatal errors
/* New memory allocation functions xmalloc, xcalloc, ... that raise an exception if the memory cannot be allocated.
/* New xfree0() macro which only frees if the pointer in non-null, and
/* sets the poiter to NULL afterwards, to avoid any used of the freed memory.
/*
/* Revision 1.1  2011/07/18 00:43:35  pauloscustodio
/* Initialize MS Visual Studio DEBUG build to show memory leaks on exit
/*
/*
/* */

#ifndef MEMALLOC_H
#define MEMALLOC_H

/* include stdlib.h before crtdbg.h */
#include <stdlib.h>
#include "except.h"             /* CH_0004 : Exception mechanism to handle fatal errors */

#ifdef _CRTDBG_MAP_ALLOC        /* MS Visual Studio malloc debug */
#include <crtdbg.h>
#endif
#include <string.h>
#include <stdio.h>

/*-----------------------------------------------------------------------------
*   PUBLIC INTERFACE
*   alloc memory
*	throw NotEnoughMemoryException on failure
*	throw AssertionException on buffer overruns
*----------------------------------------------------------------------------*/

extern void * _xmalloc(size_t size, char *file, int lineno);
#define xmalloc(size)	_xmalloc((size), __FILE__, __LINE__)

extern void * _xcalloc(int num, size_t size, char *file, int lineno);
#define xcalloc(num, size)	_xcalloc((num), (size), __FILE__, __LINE__)

extern void * _xrealloc(void * memptr, size_t size, char *file, int lineno);
#define xrealloc(memptr, size)	_xrealloc((memptr), (size), __FILE__, __LINE__)

extern char * _xstrdup(char *source, char *file, int lineno);
#define xstrdup(source)	_xstrdup((source), __FILE__, __LINE__)

extern void _xfree(void * memptr, char *file, int lineno);
#define xfree(memptr)	( _xfree((memptr), __FILE__, __LINE__), (memptr) = NULL )

/* macro to alloc struct
 * use xcalloc for structs to make sure any new pointers
 * in the struct are initialized to NULL */
#define xcalloc_n_struct(n, type_t)     ((type_t *) xcalloc((n), sizeof(type_t)))
#define xcalloc_struct(type_t)          xcalloc_n_struct(1, type_t)

#endif /* ndef MEMALLOC_H */
