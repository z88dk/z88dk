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

Activate _CRTDBG_MAP_ALLOC, MS Visual Studio malloc debug - detects buffer overruns and
memory leaks.
Needs to be first include in any source, i.e. crtdbg.h needs to be included upfront.
On MEMALLOC_DEBUG, shows statistics of memory usage on exit.
*/

#pragma once

/* include stdlib.h before crtdbg.h */
#include <stdlib.h>

#ifdef _CRTDBG_MAP_ALLOC        /* MS Visual Studio malloc debug */
#include <crtdbg.h>
#endif

#include <string.h>
#include <stdio.h>
#include <glib.h>

/*-----------------------------------------------------------------------------
*   Initialize and Terminate functions called by init()
*----------------------------------------------------------------------------*/
extern void init_memalloc(void);
extern void fini_memalloc(void);

/*-----------------------------------------------------------------------------
*   PUBLIC INTERFACE
*   alloc memory
*   dies on allocation failure or buffer overruns
*----------------------------------------------------------------------------*/

#define xmalloc		g_malloc0
#define xcalloc		g_malloc0_n
#define xrealloc	g_realloc
#define xstrdup		g_strdup
#define xfree		g_free

/* macro to alloc struct
 * use xcalloc for structs to make sure any new pointers
 * in the struct are initialized to NULL */
#define xcalloc_n_struct(n, type_t)     g_new0(type_t, n)
#define xcalloc_struct(type_t)          g_new0(type_t, 1)


/* */
/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/memalloc.h,v 1.10 2013-09-01 16:21:55 pauloscustodio Exp $ */
/* $Log: memalloc.h,v $
/* Revision 1.10  2013-09-01 16:21:55  pauloscustodio
/* Removed memalloc allocation checking code, use MSVC _CRTDBG_MAP_ALLOC instead.
/* Dump memory usage statistics at the end if MEMALLOC_DEBUG defined.
/*
/* Revision 1.9  2013/09/01 11:52:55  pauloscustodio
/* Setup memalloc on init.c.
/* Setup GLib memory allocation functions to use memalloc functions.
/*
/* Revision 1.8  2013/09/01 00:18:28  pauloscustodio
/* - Replaced e4c exception mechanism by a much simpler one based on a few
/*   macros. The former did not allow an exit(1) to be called within a
/*   try-catch block.
/*
/* Revision 1.7  2013/01/20 21:24:28  pauloscustodio
/* Updated copyright year to 2013
/*
/* Revision 1.6  2012/05/24 17:09:27  pauloscustodio
/* Unify copyright header
/*
/* Revision 1.5  2012/05/20 06:39:27  pauloscustodio
/* astyle
/*
/* Revision 1.4  2012/05/20 06:02:09  pauloscustodio
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
/* */
