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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/memalloc.c,v 1.1 2011-07-18 00:43:35 pauloscustodio Exp $ */
/* $Log: memalloc.c,v $
/* Revision 1.1  2011-07-18 00:43:35  pauloscustodio
/* Initialize MS Visual Studio DEBUG build to show memory leaks on exit
/*
/*
/* */

#include "memalloc.h"	/* before any other include to enable memory leak detection */

#include <stdlib.h>

/*-----------------------------------------------------------------------------
*   init_memalloc
*	Initialize MS Visual Studio DEBUG build to show memory leaks on exit
*----------------------------------------------------------------------------*/
#define REPORT_STDERR(reportType)   _CrtSetReportMode(reportType, _CRTDBG_MODE_FILE ); \
				    _CrtSetReportFile(reportType, _CRTDBG_FILE_STDERR )
void init_memalloc (void) 
{
#ifdef _CRTDBG_MAP_ALLOC	/* MS Visual Studio malloc debug */
    _CrtSetDbgFlag(_CRTDBG_ALLOC_MEM_DF | _CRTDBG_LEAK_CHECK_DF);
    REPORT_STDERR(_CRT_WARN);
    REPORT_STDERR(_CRT_ERROR);
    REPORT_STDERR(_CRT_ASSERT);
#endif
}
#undef REPORT_STDERR
