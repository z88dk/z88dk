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

Memory allocation routines
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/memalloc.c,v 1.2 2011-08-05 19:49:13 pauloscustodio Exp $ */
/* $Log: memalloc.c,v $
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

#include "memalloc.h"	/* before any other include to enable memory leak detection */

#include <stdlib.h>
#include <string.h>

/*-----------------------------------------------------------------------------
*   init_memalloc
*	Initialize MS Visual Studio DEBUG build to show memory leaks on exit
*----------------------------------------------------------------------------*/
#define REPORT_STDERR(reportType)   _CrtSetReportMode(reportType, _CRTDBG_MODE_FILE | _CRTDBG_MODE_DEBUG); \
				    _CrtSetReportFile(reportType, _CRTDBG_FILE_STDERR )
void init_memalloc (void) 
{
#ifdef _CRTDBG_MAP_ALLOC	/* MS Visual Studio malloc debug */
    _CrtSetDbgFlag(_CRTDBG_ALLOC_MEM_DF | _CRTDBG_LEAK_CHECK_DF);
    REPORT_STDERR(_CRT_WARN);
    REPORT_STDERR(_CRT_ERROR);
    REPORT_STDERR(_CRT_ASSERT);

    /* _CrtSetBreakAlloc(86);	    /* break on allocation Nr. XX */
#endif
}
#undef REPORT_STDERR

/*-----------------------------------------------------------------------------
*   _check_memalloc
*	Check return of allocation function, throw exception if NULL
*----------------------------------------------------------------------------*/
void * _check_memalloc (void *ptr)
{
    if (ptr == NULL)
	throw(NotEnoughMemoryException, "Not enough memory");
    return ptr;
}

/*-----------------------------------------------------------------------------
*   _check_stralloc
*	Check return of string allocation function, throw exception if NULL
*	Init string with copy from given string, or initial '\0' char if NULL
*----------------------------------------------------------------------------*/
char * _check_stralloc (void *ptr, char *source)
{
    _check_memalloc(ptr);
    if (source) {
	strcpy((char *) ptr, source);
    }
    else {
	*((char *) ptr) = '\0';
    }
    return (char *) ptr;
}

/*-----------------------------------------------------------------------------
*   xstrdup_add
*	like xstrdup, reserve additional chars for string to grow
*----------------------------------------------------------------------------*/
char * xstrdup_add (char * source, int additional_chars) 
{
    char * str = xstralloc( strlen(source) + additional_chars );
    strcpy(str, source);

    return str;
}

