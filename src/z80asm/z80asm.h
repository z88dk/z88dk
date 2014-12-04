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
Copyright (C) Paulo Custodio, 2011-2014


$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/z80asm.h,v 1.66 2014-12-04 23:30:20 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */

#include "types.h"
#include "sym.h"
#include "strutil.h"
#include "expr.h"
#include <stdio.h>
#include <stdlib.h>

#ifdef MSDOS
#define MAXCODESIZE 65532       /* MSDOS 64K heap boundary */
#else
#define MAXCODESIZE 65536
#endif

extern size_t sizeof_relocroutine, sizeof_reloctable;

extern char *GetLibfile( char *filename );

extern void assemble_file( char *filename );
extern void Z80pass1( char *filename );
extern Bool Pass2info(range_t range, int byteoffset);
extern Bool Pass2infoExpr(range_t range, int byteoffset, Expr *expr);
