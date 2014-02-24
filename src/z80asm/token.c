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

Define lexer tokens

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/token.c,v 1.1 2014-02-24 23:08:55 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "token.h"
#include "init.h"

/*-----------------------------------------------------------------------------
*	Init token lookup tables
*----------------------------------------------------------------------------*/
static tokid_t char_token_lu[256];

DEFINE_init()
{
	int i;

	for (i = 0; i < NUM_ELEMS(char_token_lu); i++)
		char_token_lu[i] = nil;
}

DEFINE_fini()
{
}

extern tokid_t char_token( int c );

/*
* $Log: token.c,v $
* Revision 1.1  2014-02-24 23:08:55  pauloscustodio
* Rename "enum symbols" to "tokid_t", define in token.h
*
*
*/
