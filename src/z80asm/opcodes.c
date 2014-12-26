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

Copyright (C) Paulo Custodio, 2011-2014

Define CPU opcodes

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/opcodes.c,v 1.6 2014-12-26 16:46:58 pauloscustodio Exp $ 
*/

#include "xmalloc.h"   /* before any other include */

#include "expr.h"
#include "codearea.h"
#include "opcodes.h"
#include "z80asm.h"

/* add 1 or 2 bytes opcode opcode to object code 
*  bytes in big-endian format, e.g. 0xCB00 */
void add_opcode(int opcode)
{
	if ( opcode & 0xFF00)
		append_byte( (opcode >> 8) & 0xFF );
	append_byte( opcode & 0xFF );
}

/* add opcode followed by jump relative offset expression */
void add_opcode_jr(int opcode, Expr *expr)
{
	add_opcode(opcode);
	Pass2infoExpr(RANGE_JR_OFFSET, expr);
}

/* add opcode followed by 16-bit expression */
void add_opcode_nn(int opcode, struct Expr *expr)
{
	add_opcode(opcode);
	Pass2infoExpr(RANGE_WORD, expr);
}
