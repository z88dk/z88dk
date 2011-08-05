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
Copyright (C) Paulo Custodio, 2011

Memory allocation routines to enable memory leak detection in MS Visual Studio Debug build
Needs to be included in every source file before any other include.
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/memalloc.h,v 1.2 2011-08-05 19:49:13 pauloscustodio Exp $ */
/* $Log: memalloc.h,v $
/* Revision 1.2  2011-08-05 19:49:13  pauloscustodio
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

#include <stdlib.h>
#include "except.h"		/* CH_0004 : Exception mechanism to handle fatal errors */

#ifdef _CRTDBG_MAP_ALLOC	/* MS Visual Studio malloc debug */
#include <stdlib.h>
#include <crtdbg.h>
#endif

/* init MS Visual Studio malloc debug */
extern void init_memalloc (void);

extern void * _check_memalloc (void *ptr);
extern char * _check_stralloc (void *ptr, char *source);

/* alloc memory, throw NotEnoughMemoryException on failure 
 * implemented as macros to report location of allocation in memory leak report */
#define xcalloc(num, size)	_check_memalloc(calloc((num), (size)))

#define xmalloc(size)		_check_memalloc(malloc(size))

#define xrealloc(memblock, size) _check_memalloc(realloc((memblock), (size)))

/* alloc length+1 bytes, init to empty string */
#define xstralloc(length)	_check_stralloc(malloc((length)+1), NULL)

/* strdup, throw NotEnoughMemoryException on failure */
#define xstrdup(source)		((char *) _check_memalloc(strdup(source)))

/* like xstrdup, reserve additional chars for string to grow */
extern char * xstrdup_add (char * source, int additional_chars);

/* macro to alloc struct
 * use xcalloc for structs to make sure any new pointers
 * in the struct are initialized to NULL */
#define xcalloc_n_struct(n, type_t)	((type_t *) xcalloc((n), sizeof(type_t)))
#define xcalloc_struct(type_t)		xcalloc_n_struct(1, type_t)

/* macro to free if not NULL, and set pointer to NULL */
#define xfree0(p)		do { if ((p) != NULL) { free(p); } (p) = NULL; } while (0)

#endif /* ndef MEMALLOC_H */
