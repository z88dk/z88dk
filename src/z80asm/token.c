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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/token.c,v 1.2 2014-03-01 15:45:31 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "token.h"
#include "init.h"
#include "types.h"

#include <assert.h>

/*-----------------------------------------------------------------------------
*	Init token lookup tables
*----------------------------------------------------------------------------*/
static tokid_t char_token_lu[256];
static char *token_string_lu[] =
{
#define TOKEN(name, string)	string,
#include "token_def.h"
};

DEFINE_init()
{
	int i;

	for (i = 0; i < NUM_ELEMS(char_token_lu); i++)
		char_token_lu[i] = TK_NIL;

#define TOKEN(name, string)	\
		if (string[0] != '\0' && string[1] == '\0') {	/* 1-char token */	\
			int c = string[0]; \
			assert( char_token_lu[ c ] == TK_NIL ); \
			char_token_lu[ c ] = name; \
		}
#include "token_def.h"
}

DEFINE_fini()
{
}

/*-----------------------------------------------------------------------------
*	Lookup char in token tables; char may be -1 (EOF)
*----------------------------------------------------------------------------*/

/* return tokid_t of the given character, for single-char tokens */
tokid_t char_token( int c )
{
	init();
	if ( c < 0 || c >= NUM_ELEMS(char_token_lu) )
		return TK_NIL;
	else
		return char_token_lu[c];
}

/* return the string representation of the given token */
char *token_string( tokid_t tok )
{
	if ( tok >= 0 && tok < NUM_ELEMS(token_string_lu) )
		return token_string_lu[ tok ];
	else
		return "";
}


/*
* $Log: token.c,v $
* Revision 1.2  2014-03-01 15:45:31  pauloscustodio
* CH_0021: New operators ==, !=, &&, ||, <<, >>, ?:
* Handle C-like operators, make exponentiation (**) right-associative.
* Simplify expression parser by handling composed tokens in lexer.
* Change token ids to TK_...
*
* Revision 1.1  2014/02/24 23:08:55  pauloscustodio
* Rename "enum symbols" to "tokid_t", define in token.h
*
*
*/
