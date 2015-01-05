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

Assembly directives.

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/directives.h,v 1.4 2015-01-05 23:34:02 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include to enable memory leak detection */

enum {
	DEFVARS_SIZE_B = 1,
	DEFVARS_SIZE_W = 2,
	DEFVARS_SIZE_P = 3,
	DEFVARS_SIZE_L = 4,
};

/* start a new DEFVARS context, closing any previously open one */
extern void defvars_start(int start_addr);

/* define one constant in the current context */
extern void defvars_define_const(char *name, int elem_size, int count);

/* start a new DEFGROUP context, give the value of the next defined constant */
extern void defgroup_start(int next_value);

/* define one constant with the next value, increment the value */
extern void defgroup_define_const(char *name);

/* create a block of empty bytes, called by the DEFS directive */
extern void defs(int count, int fill);
