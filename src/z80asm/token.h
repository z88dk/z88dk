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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/token.h,v 1.2 2014-03-01 15:45:31 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */

#include "types.h"

/*-----------------------------------------------------------------------------
*	Token IDs
*----------------------------------------------------------------------------*/
#define TOKEN(name, string) name,
typedef enum tokid_t
{
#include "token_def.h"
} tokid_t;

/*-----------------------------------------------------------------------------
*	Lookup char in token tables; char may be -1 (EOF)
*----------------------------------------------------------------------------*/

/* return tokid_t of the given character, for single-char tokens */
extern tokid_t char_token( int c );

/* return the string representation of the given token */
extern char *token_string( tokid_t tok );

/*
* $Log: token.h,v $
* Revision 1.2  2014-03-01 15:45:31  pauloscustodio
* CH_0021: New operators ==, !=, &&, ||, <<, >>, ?:
* Handle C-like operators, make exponentiation (**) right-associative.
* Simplify expression parser by handling composed tokens in lexer.
* Change token ids to TK_...
*
* Revision 1.1  2014/02/24 23:08:57  pauloscustodio
* Rename "enum symbols" to "tokid_t", define in token.h
*
*
*/
