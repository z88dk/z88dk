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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/exprprsr.c,v 1.87 2014-07-06 23:11:25 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "class.h"
#include "codearea.h"
#include "errors.h"
#include "expr.h"
#include "fileutil.h"
#include "legacy.h"
#include "options.h"
#include "scan.h"
#include "symbol.h"
#include "except.h"
#include "expr.h"
#include "expr_def.h"
#include "z80asm.h"
#include <assert.h>
#include <ctype.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

Bool ExprLong( int listoffset )
{
	return Pass2info( RANGE_DWORD, listoffset );
}

Bool ExprAddress( int listoffset )
{
	return Pass2info( RANGE_WORD, listoffset );
}

Bool ExprUnsigned8( int listoffset )
{
	return Pass2info( RANGE_BYTE_UNSIGNED, listoffset );
}

Bool ExprSigned8( int listoffset )
{
    /* BUG_0005 : Offset of (ix+d) should be optional; '+' or '-' are necessary */
    switch ( tok )
    {
    case TK_RPAREN:
        append_byte( 0 );   /* offset zero */
        return TRUE;		/* OK, zero already stored */

    case TK_PLUS:
    case TK_MINUS:          /* + or - expected */
        return Pass2info( RANGE_BYTE_SIGNED, listoffset );

    default:                /* Syntax error, e.g. (ix 4) */
        error_syntax();
        return FALSE;		/* FAIL */
    }
}
