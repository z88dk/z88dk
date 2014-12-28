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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/ldinstr.c,v 1.52 2014-12-28 07:28:09 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "codearea.h"
#include "errors.h"
#include "options.h"
#include "scan.h"
#include "symbol.h"
#include "z80asm.h"
#include <stdio.h>

static void LD_IND_HL(void)
{
	int dest_idx = sym.cpu_idx_reg;
	UInt opcodeptr;

	if (dest_idx)
		append_byte(dest_idx);			/* 0xDD or 0xFD */

	opcodeptr = get_cur_module_size();	/* pointer to instruction opcode - BUG_0015 */
	append_byte(0x36);					/* preset 2. opcode to LD (IX|IY+d),n  */

	if (dest_idx)
	{
		GetSym();
		if (!Pass2info(RANGE_BYTE_SIGNED))
			return;						/* syntax error in +d expression */
	}

	GetSymExpect(TK_COMMA);
	GetSym();

	if (sym.cpu_idx_reg)
	{
		error_illegal_ident();
		return;
	}

	switch (sym.cpu_reg8)
	{
	case REG_NONE:
		Pass2info(RANGE_BYTE_UNSIGNED);	/* Execute, store & patch 8bit expression for <n> */
		break;

	default:
		patch_byte(opcodeptr, (Byte)(0x70 + sym.cpu_reg8));     /* LD  (IX|IY+d),r  */
		break;
	}

}

static void LD_IND_BC_DE(void)
{
	int dest_reg = sym.cpu_ind_reg16;

	GetSymExpect(TK_COMMA);
	GetSym();

	if (sym.cpu_reg8 == REG_A)
		append_byte(0x02 + (dest_reg << 4));			/* ld (BC)/(DE), A */
	else
	{
		error_illegal_ident();
	}
}

static void LD_IND_NN(void)
{
	Expr *expr;

	if (!(expr = expr_parse()))
		return;					/* syntax error in expression */

	CurSymExpect(TK_RPAREN);
	GetSym();

	CurSymExpect(TK_COMMA);
	GetSym();

	switch (sym.cpu_reg16_sp)
	{
	case REG_HL:			/* LD  (nn),dd  => dd: HL, IX, IY */
		if (sym.cpu_idx_reg)
		{
			append_2bytes(sym.cpu_idx_reg, 0x22);
			Pass2infoExpr(RANGE_WORD, expr);
		}
		else
		{
			append_byte(0x22);
			Pass2infoExpr(RANGE_WORD, expr);
		}
		return;

	case REG_NONE:
		break;

	default:					/* LD  (nn),dd   => dd: BC,DE,SP  */
		append_2bytes(0xED, (Byte)(0x43 + (sym.cpu_reg16_sp << 4)));
		Pass2infoExpr(RANGE_WORD, expr);
		return;
	}

	switch (sym.cpu_reg8)
	{
	case REG_A:
		append_byte(0x32);      /* LD  (nn),A  */
		Pass2infoExpr(RANGE_WORD, expr);
		return;

	default:
		error_illegal_ident();
	}
}

static void LD_REG8(void)
{
	int dest_reg = sym.cpu_reg8;
	int dest_idx = sym.cpu_idx_reg;

	if (dest_reg != REG_NONE && dest_idx && (opts.cpu & CPU_RABBIT)) 
	{
		error_illegal_ident();
		return;
	}

	GetSymExpect(TK_COMMA);
	GetSym();

	switch (sym.tok)
	{
	case TK_LPAREN:					/* LD  A,(nn)  */
		if (dest_reg == REG_A)
		{
			append_byte(0x3A);
			Pass2info(RANGE_WORD);
		}
		else
		{
			error_illegal_ident();
		}
		return;

	case TK_I:						/* LD  A,I */
		if (!(opts.cpu & CPU_RABBIT) && dest_reg == REG_A)
			append_2bytes(0xED, 0x57);
		else 
			error_illegal_ident();
		return;

	case TK_IIR:					/* LD  A,IIR */
		if ((opts.cpu & CPU_RABBIT) && dest_reg == REG_A)
			append_2bytes(0xED, 0x57);
		else
			error_illegal_ident();
		return;

	case TK_R:						/* LD  A,R */
		if (!(opts.cpu & CPU_RABBIT) && dest_reg == REG_A)
			append_2bytes(0xED, 0x5F);
		else
			error_illegal_ident();
		return;

	case TK_EIR:					/* LD  A,EIR */
		if ((opts.cpu & CPU_RABBIT) && dest_reg == REG_A)
			append_2bytes(0xED, 0x5F);
		else
			error_illegal_ident();
		return;

	default:
		break;
	}

	switch (sym.cpu_ind_reg16)
	{
	case IND_REG16_BC:				/* LD   A,(BC)  */
	case IND_REG16_DE:				/* LD   A,(DE)  */
		if (dest_reg == REG_A)
		{
			append_byte(0x0A + (sym.cpu_ind_reg16 << 4));
		}
		else
		{
			error_illegal_ident();
		}
		return;

	case IND_REG16_HL:
		if (dest_idx)
		{
			error_illegal_ident();
		}
		else if (sym.cpu_idx_reg)			/* LD   r,(IX/IY+d)  */
		{
			append_2bytes(sym.cpu_idx_reg, (Byte)(0x40 + (dest_reg << 3) + 0x06));
			GetSym();
			Pass2info(RANGE_BYTE_SIGNED);
		}
		else							/* LD   r,(HL)  */
		{
			append_byte((Byte)(0x40 + (dest_reg << 3) + 0x06));
		}
		return;

	default:
		break;
	}

	if (sym.cpu_reg8 != REG_NONE)			/* LD  r,r  */
	{
		if (sym.cpu_idx_reg && (opts.cpu & CPU_RABBIT))
		{
			error_illegal_ident();
			return;
		}

		if (dest_idx || sym.cpu_idx_reg)
		{
			if (dest_idx && sym.cpu_idx_reg && dest_idx != sym.cpu_idx_reg)
			{
				error_illegal_ident();
				return;
			}
			else 
				append_byte(dest_idx ? dest_idx : sym.cpu_idx_reg);
				
		}
		append_byte((Byte)(0x40 + (dest_reg << 3) + sym.cpu_reg8));
	}
	else								/* LD  r,n */
	{
		if (dest_idx)
		{
			append_2bytes(dest_idx, (Byte)((dest_reg << 3) + 0x06));
			Pass2info(RANGE_BYTE_UNSIGNED);
		}
		else
		{
			append_byte((Byte)((dest_reg << 3) + 0x06));
			Pass2info(RANGE_BYTE_UNSIGNED);
		}
	}
}

static void LD_REG16(void)
{
	int dest_reg = sym.cpu_reg16_sp;
	int dest_idx = sym.cpu_idx_reg;

	GetSymExpect(TK_COMMA);
	GetSym();

	if (sym.tok == TK_LPAREN)
	{
		GetSym();
		switch (dest_reg)
		{
		case REG_HL:					/* LD   HL/IX/IY,(nn)  */
			if (dest_idx)
			{
				append_2bytes(dest_idx, 0x2A);
				Pass2info(RANGE_WORD);
			}
			else
			{
				append_byte(0x2A);
				Pass2info(RANGE_WORD);
			}
			CurSymExpect(TK_RPAREN);
			return;

		case REG_NONE:
			error_illegal_ident();
			return;

		default:						/* LD   dd,(nn)  */
			append_2bytes(0xED, (Byte)(0x4B + (dest_reg << 4)));
			Pass2info(RANGE_WORD);
			CurSymExpect(TK_RPAREN);
			return;
		}
	}

	switch (sym.cpu_reg16_sp)
	{
	case REG_NONE:					/* LD dd,nn */
		if (dest_idx)
		{
			append_2bytes(dest_idx, 0x21);
			Pass2info(RANGE_WORD);
		}
		else
		{
			append_byte((Byte)((dest_reg << 4) + 0x01));
			Pass2info(RANGE_WORD);
		}
		return;

	case REG_HL:						/* LD SP,HL/IX/IY */
		if (dest_reg == REG_SP)
		{
			if (sym.cpu_idx_reg)
				append_byte(sym.cpu_idx_reg);
			append_byte(0xF9);
		}
		else
		{
			error_illegal_ident();
		}
		return;

	default:
		break;
	}

	error_illegal_ident();
}

void LD(void)
{
	GetSym();
	switch (sym.tok)
	{
	case TK_LPAREN:					/* LD (nn),... */
		GetSym();
		LD_IND_NN();
		return;

	case TK_I:						/* LD  I,A */
		GetSymExpect(TK_COMMA);
		GetSym();
		if (!(opts.cpu & CPU_RABBIT) && sym.cpu_reg8 == REG_A)
			append_2bytes(0xED, 0x47);
		else
			error_illegal_ident();
		return;

	case TK_IIR:					/* LD  IIR,A */
		GetSymExpect(TK_COMMA);
		GetSym();
		if ((opts.cpu & CPU_RABBIT) && sym.cpu_reg8 == REG_A)
			append_2bytes(0xED, 0x47);
		else
			error_illegal_ident();
		return;

	case TK_R:						/* LD  R,A */
		GetSymExpect(TK_COMMA);
		GetSym();
		if (!(opts.cpu & CPU_RABBIT) && sym.cpu_reg8 == REG_A)
			append_2bytes(0xED, 0x4F);
		else
			error_illegal_ident();
		return;

	case TK_EIR:					/* LD  EIR,A */
		GetSymExpect(TK_COMMA);
		GetSym();
		if ((opts.cpu & CPU_RABBIT) && sym.cpu_reg8 == REG_A)
			append_2bytes(0xED, 0x4F);
		else
			error_illegal_ident();
		return;

	default:
		break;
	}
	
	switch (sym.cpu_ind_reg16)
	{
	case IND_REG16_BC:
	case IND_REG16_DE:
		LD_IND_BC_DE();
		return;

	case IND_REG16_HL:				/* ld (HL),xxx / ld (ix+d),xxx / ld (iy+d),xxx */
		LD_IND_HL();
		return;

	case IND_REG16_NONE:
		break;

	default:
		assert(0);
	}

	if (sym.cpu_reg8 != REG_NONE)		/* ld r,... */
	{
		LD_REG8();
		return;
	}

	if (sym.cpu_reg16_sp != REG_NONE)	/* ld dd, ... */
	{
		LD_REG16();
		return;
	}

	error_syntax();
}
