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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/opcodes.c,v 1.9 2014-12-29 20:08:59 pauloscustodio Exp $ 
*/

#include "xmalloc.h"   /* before any other include */

#include "expr.h"
#include "codearea.h"
#include "model.h"
#include "opcodes.h"
#include "parse.h"
#include "z80asm.h"

/* add 1 to 4 bytes opcode opcode to object code 
*  bytes in big-endian format, e.g. 0xCB00 */
void add_opcode(int opcode)
{
	if ( opcode & 0xFF000000 )
		append_byte( (opcode >> 24) & 0xFF );
	if ( opcode & 0xFF0000 )
		append_byte( (opcode >> 16) & 0xFF );
	if ( opcode & 0xFF00 )
		append_byte( (opcode >> 8) & 0xFF );
	append_byte( opcode & 0xFF );
}

/* add opcode followed by jump relative offset expression */
void add_opcode_jr(int opcode, Expr *expr)
{
	add_opcode(opcode);
	Pass2infoExpr(RANGE_JR_OFFSET, expr);
}

/* add opcode followed by 8-bit expression */
void add_opcode_n(int opcode, Expr *expr)
{
	add_opcode(opcode);
	Pass2infoExpr(RANGE_BYTE_UNSIGNED, expr);
}

/* add opcode followed by 16-bit expression */
void add_opcode_nn(int opcode, Expr *expr)
{
	add_opcode(opcode);
	Pass2infoExpr(RANGE_WORD, expr);
}

/* add opcode followed by IX/IY offset expression */
void add_opcode_idx(int opcode, Expr *expr)
{
	if (opcode & 0xFF0000) 
	{				/* 3 bytes, insert idx offset as 2nd byte */
		add_opcode( (opcode >> 8) & 0xFFFF );
		Pass2infoExpr(RANGE_BYTE_SIGNED, expr);
		add_opcode( opcode & 0xFF );
	}
	else
	{
		add_opcode(opcode);
		Pass2infoExpr(RANGE_BYTE_SIGNED, expr);
	}
}


/* add "call flag", or emulation on a Rabbit */
void add_call_flag(int flag, Expr *target)
{
	char *end_label;
	Expr *end_label_expr;
	int jump_size;

	if (!(opts.cpu & CPU_RABBIT))
		add_opcode_nn(Z80_CALL_FLAG(flag), target);
	else
	{
		end_label = autolabel();
		end_label_expr = parse_expr(end_label);

		if (flag <= FLAG_C)
		{
			add_opcode_jr(Z80_JR_FLAG(NOT_FLAG(flag)), end_label_expr);
			jump_size = 2;
		}
		else
		{
			add_opcode_nn(Z80_JP_FLAG(NOT_FLAG(flag)), end_label_expr);
			jump_size = 3;
		}

		add_opcode_nn(Z80_CALL, target);

		define_symbol(end_label, get_PC() + jump_size + 3, TYPE_ADDRESS, SYM_TOUCHED);
	}
}

/* add opcode, or call emulation function on a Rabbit */
void add_opcode_emul(int opcode, char *emul_func)
{
	Expr *emul_func_expr;

	if (!(opts.cpu & CPU_RABBIT))
		add_opcode(opcode);
	else
	{
		declare_extern_symbol(emul_func);
		emul_func_expr = parse_expr(emul_func);
		add_opcode_nn(Z80_CALL, emul_func_expr);
	}
}
