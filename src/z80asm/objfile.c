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

Handle object file contruction, reading and writing
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/objfile.c,v 1.1 2011-08-19 15:53:58 pauloscustodio Exp $ */
/* $Log: objfile.c,v $
/* Revision 1.1  2011-08-19 15:53:58  pauloscustodio
/* BUG_0010 : heap corruption when reaching MAXCODESIZE
/* - test for overflow of MAXCODESIZE is done before each instruction at parseline(); if only one byte is available in codearea, and a 2 byte instruction is assembled, the heap is corrupted before the exception is raised.
/* - Factored all the codearea-accessing code into a new module, checking for MAXCODESIZE on every write.
/*
/* */

#include <memory.h>
#include "objfile.h"
