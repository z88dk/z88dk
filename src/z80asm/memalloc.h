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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/memalloc.h,v 1.1 2011-07-18 00:43:35 pauloscustodio Exp $ */
/* $Log: memalloc.h,v $
/* Revision 1.1  2011-07-18 00:43:35  pauloscustodio
/* Initialize MS Visual Studio DEBUG build to show memory leaks on exit
/*
/*
/* */

#ifndef MEMALLOC_H
#define MEMALLOC_H

extern void init_memalloc (void);

#ifdef _CRTDBG_MAP_ALLOC	/* MS Visual Studio malloc debug */
#include <stdlib.h>
#include <crtdbg.h>
#endif

#endif /* ndef MEMALLOC_H */
