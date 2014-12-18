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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/z80instr.c,v 1.82 2014-12-18 14:23:21 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "codearea.h"
#include "errors.h"
#include "expr.h"
#include "options.h"
#include "scan.h"
#include "symbol.h"
#include "z80asm.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


/* local functions */
void ADD_8bit_instr( void );
void ADC_8bit_instr( void );
void SBC_8bit_instr( void );
void IncDec_8bit_instr( int opcode );
void ArithLog8_instr( int opcode );
void JP_instr( int opc0, int opc );
void Subroutine_addr( int opc0, int opc );
void ExtAccumulator(int opcode);

void
PushPop_instr( int opcode )
{
	GetSym();
	if (sym.cpu_reg16_af != REG16_NONE)
	{
		if (sym.cpu_idx_reg)
			append_byte(sym.cpu_idx_reg);
		append_byte((Byte)(opcode + (sym.cpu_reg16_af << 4)));
	}
	else
	{
		error_syntax();
	}
}


void
RET( void )
{
	GetSym();

	if (sym.cpu_flag != FLAG_NONE)
		append_byte((Byte)(0xC0 + (sym.cpu_flag << 3)));  /* RET cc  instruction opcode */
	else 
	{
		switch (sym.tok)
		{
		case TK_END:
		case TK_NEWLINE:
			append_byte(0xC9);
			break;

		default:
			error_syntax();
		}
	}
}



void
EX( void )
{
	GetSym();

	switch (sym.tok)
	{
	case TK_IND_SP:									/* EX (SP), HL/IX/IY */
		GetSymExpect(TK_COMMA);
		GetSym();
		if (sym.cpu_reg16_af == REG16_HL)
		{
			if ((opts.cpu & CPU_RABBIT) && ! sym.cpu_idx_reg)
				append_2bytes(0xED, 0x54);			/* Instruction code changed */
			else
			{
				if (sym.cpu_idx_reg)
					append_byte(sym.cpu_idx_reg);
				append_byte(0xE3);					/* EX (SP),HL/IX/DE */
			}
		}
		else
		{
			error_illegal_ident();
		}
		break;

	case TK_DE:										/* EX DE, HL */
		GetSymExpect(TK_COMMA);
		GetSym();
		if (sym.tok == TK_HL)
			append_byte(0xEB);
		else
		{
			error_illegal_ident();
		}
		break;

	case TK_AF:										/* EX AF, AF/AF' */
		GetSymExpect(TK_COMMA);
		GetSym();
		if (sym.tok == TK_AF || sym.tok == TK_AF1)
			append_byte(0x08);
		else
		{
			error_illegal_ident();
		}
		break;


	default:
		error_syntax();
	}
}



void
OUT( void )
{
	GetSym();
	
	if (opts.cpu & CPU_RABBIT)
	{
		error_illegal_ident();
	}
	else
	{
		switch (sym.tok)
		{
		case TK_IND_C:							/* OUT (C), r */
			GetSymExpect(TK_COMMA);
			GetSym();
			if (sym.cpu_reg8 != REG8_NONE && !sym.cpu_idx_reg)
				append_2bytes(0xED, (Byte)(0x41 + (sym.cpu_reg8 << 3)));
			else
			{
				error_illegal_ident();
			
			}
			break;

		case TK_LPAREN:							/* OUT (N), A */
			GetSym();
			append_byte(0xD3);
			if (!Pass2info(RANGE_BYTE_UNSIGNED, 1))
				return;							/* error in expression */

			if (sym.tok != TK_RPAREN)
			{
				error_syntax();
			}

			GetSymExpect(TK_COMMA);
			GetSym();
			if (sym.tok != TK_A)
			{
				error_illegal_ident();
			}

			break;

		default:
			break;
		}
	}
}


void
IN( void )
{
    int in_reg;

	GetSym();

	if (opts.cpu & CPU_RABBIT)
	{
		error_illegal_ident();
	}
	else
	{
		in_reg = sym.cpu_reg8;
		if (in_reg != REG8_NONE && !sym.cpu_idx_reg)
		{
			GetSymExpect(TK_COMMA);
			GetSym();
			switch (sym.tok)
			{
			case TK_IND_C:							/* IN r,(C) */
				append_2bytes(0xED, (Byte)(0x40 + (in_reg << 3)));	
				break;

			case TK_LPAREN:							/* IN A,(N) */
				if (in_reg != REG8_A)
				{
					error_illegal_ident();
				}

				GetSym();
				append_byte(0xDB);
				if (!Pass2info(RANGE_BYTE_UNSIGNED, 1))
					return;							/* error in expression */

				if (sym.tok != TK_RPAREN)
				{
					error_syntax();
				}

				break;

			default:
				error_syntax();
			}
		}
		else
		{
			error_illegal_ident();
		}
	}
}


void
RST( void )
{
    long constant;

    GetSym();

	if ( expr_parse_eval( &constant ) )
	{
        if ( ( constant >= 0 && constant <= 0x38 ) && ( constant % 8 == 0 ) )
        {
            if ( ( opts.cpu & CPU_RABBIT ) &&
                    ( ( constant == 0 ) || ( constant == 8 ) || ( constant == 0x30 ) ) )
			{
				error_illegal_ident();
			}
			else
            {
                append_byte( (Byte)( 0xC7 + constant ) );
            }
        }
        else
        {
            error_int_range( constant );
        }
    }
}


void CALL_OZ( void )
{
    long constant;

    append_byte( 0xE7 );          /* RST 20H instruction */

    GetSym();

	if ( expr_parse_eval( &constant ) )
	{
        if ( ( constant > 0 ) && ( constant <= 255 ) )
        {
            append_byte( (Byte)constant ); /* 1 byte OZ parameter */
        }
        else if ( ( constant > 255 ) && ( constant <= 65535 ) )
        {
            append_word( constant );  /* 2 byte OZ parameter */
        }
        else
        {
            error_int_range( constant );
        }
    }
}


void OZ( void )
{
    CALL_OZ();
}


void
CALL_PKG( void )
{
    long constant;

    append_byte( 0xCF );          /* RST 08H instruction */

	GetSym();

	if ( expr_parse_eval( &constant ) )
	{
        if ( ( constant >= 0 ) && ( constant <= 65535 ) )
        {
            append_word( constant );    /* 2 byte parameter always */
        }
        else
        {
            error_int_range( constant );
        }
    }
}

void
INVOKE( void )
{
    long constant;

    if ( opts.ti83plus )
        append_byte( 0xEF );    /* Ti83Plus: RST 28H instruction */
    else
        append_byte( 0xCD );    /* Ti83: CALL */

	GetSym();

	if ( expr_parse_eval( &constant ) )
	{
        if ( ( constant >= 0 ) && ( constant <= 65535 ) )
        {
            append_word( constant );    /* 2 byte parameter always */
        }
        else
        {
            error_int_range( constant );
        }
    }
}

void
FPP( void )
{
    long constant;

    append_byte( 0xDF );          /* RST 18H instruction */

	GetSym();

	if ( expr_parse_eval( &constant ) )
	{
        if ( ( constant > 0 ) && ( constant < 255 ) )
        {
            append_byte( (Byte)constant ); /* 1 byte OZ parameter */
        }
        else
        {
            error_int_range( constant );
        }
    }
}


void
Subroutine_addr( int opcode0, int opcode )
{
	int listoffset = 0;
	int flag;

	flag = sym.cpu_flag;
	if (flag != FLAG_NONE)			/* Check for condition */
    {
		GetSymExpect(TK_COMMA);

        if ( opcode0 == 205 && ( opts.cpu & CPU_RABBIT ) )
        {
            char buffer[200];

			switch (flag)
            {
            case FLAG_NZ:  /* nz */
                append_2bytes( 0x28, 0x03 ); /* jr z */
				listoffset = 2;
				next_PC();

				append_byte( (Byte)opcode0 );
                break;

            case FLAG_Z:  /* z */
                append_2bytes( 0x20, 0x03 ); /* jr nz */
				listoffset = 2;
				next_PC();

                append_byte( (Byte)opcode0 );
                break;

            case FLAG_NC:  /* nc */
                append_2bytes( 0x38, 0x03 ); /* jr c */
				listoffset = 2;
				next_PC();

                append_byte( (Byte)opcode0 );
                break;

            case FLAG_C:  /* c */
                append_2bytes( 0x30, 0x03 ); /* jr nc */
				listoffset = 2;
				next_PC();

                append_byte( (Byte)opcode0 );
                break;

            case FLAG_PO:  /* po */
                append_byte( 0xEA ); /* jp pe */
                sprintf( buffer, "ASMPC+6\n" );
                SetTemporaryLine( buffer );
                GetSym();
				Pass2info(RANGE_WORD, 1);
                EOL = FALSE;
				listoffset = 3;
				next_PC();

				append_byte( 0xCD );
                break;

            case FLAG_PE:  /* pe */
                append_byte( 0xE2 ); /* jp po */
                sprintf( buffer, "ASMPC+6\n" );
                SetTemporaryLine( buffer );
                GetSym();
				Pass2info(RANGE_WORD, 1);
                EOL = FALSE;
				listoffset = 3;
				next_PC();

                append_byte( 0xCD );
                break;

            case FLAG_P:  /* p */
                append_byte( 0xFA ); /* jp m */
                sprintf( buffer, "ASMPC+6\n" );
                SetTemporaryLine( buffer );
                GetSym();
				Pass2info(RANGE_WORD, 1);
                EOL = FALSE;
				listoffset = 3;
				next_PC();

				append_byte( 0xCD );
                break;

            case FLAG_M:  /* m */
                append_byte( 0xF2 ); /* jp p */
                sprintf( buffer, "ASMPC+6\n" );
                SetTemporaryLine( buffer );
                GetSym();
				Pass2info(RANGE_WORD, 1);
                EOL = FALSE;
				listoffset = 3;
				next_PC();

				append_byte( 0xCD );
                break;

			default:
				assert(0);
            }
        }
        else
        {
            append_byte( (Byte)( opcode + (flag << 3) ) ); /* get instruction opcode */
        }

        GetSym();
    }
    else
    {
        append_byte( (Byte)opcode0 );  /* JP nn, CALL nn */
    }

	Pass2info(RANGE_WORD, listoffset + 1);
}


void
JP_instr( int opc0, int opc )
{
	GetSym();
	if (sym.cpu_ind_reg16 == IND_REG16_HL)	/* JP (HL)/(IX)/(IY) */
	{
		if (sym.cpu_idx_reg)
		{
			append_byte(sym.cpu_idx_reg);
			GetSymExpect(TK_RPAREN);
		}
		append_byte(0xE9);
	}
	else 
	{
		Subroutine_addr( opc0, opc );		/* base opcode for <instr> nn; <instr> cc, nn */
    }
}


static void RelativeJump( Byte opcode )
{
	append_byte( opcode );
	Pass2info( RANGE_JR_OFFSET, 1 );
}

void
JR( void )
{
	int flag;

	GetSym();
	flag = sym.cpu_flag;

	if (flag == FLAG_NONE)
	{
		RelativeJump(0x18);
	}
	else if (flag < FLAG_PO)
    {
		GetSymExpect(TK_COMMA);
		GetSym();
		RelativeJump((Byte)(0x20 + (flag << 3)));
	}
	else
	{
		error_syntax();				/* illegal condition, syntax */
	}
}


void
DJNZ( void )
{
	GetSym();
	RelativeJump( 0x10 );
}


void
ADD( void )
{
	int dest_idx;

    GetSym();
	dest_idx = sym.cpu_idx_reg;

	switch (sym.cpu_reg16_sp)
    {
    case REG16_NONE:
        ExtAccumulator( 0 );	/* 16 bit register wasn't found - try to evaluate the 8 bit version */
        break;

	case REG16_HL:				/* HL, IX, IY */
		GetSymExpect(TK_COMMA);
		GetSym();
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
		append_byte((Byte)(0x09 + (sym.cpu_reg16_sp << 4)));	/* ADD HL,rr */
		return;

    default:
		error_illegal_ident();
		break;
    }
}


static void SBC_ADC(int opcode8bit, int opcode16bit)
{
	GetSym();

	switch (sym.cpu_reg16_sp)
	{
	case REG16_NONE:
		ExtAccumulator(opcode8bit);      /* 16 bit register wasn't found - try to evaluate the 8 bit version */
		break;

	case REG16_HL:
		if (sym.cpu_idx_reg)
		{
			error_illegal_ident();
		}
		else
		{
			GetSymExpect(TK_COMMA);
			GetSym();

			if (!sym.cpu_idx_reg && sym.cpu_reg16_sp != REG16_NONE)
				append_2bytes(0xED, (Byte)(opcode16bit + (sym.cpu_reg16_sp << 4)));
			else
			{
				error_illegal_ident();
			}
		}
		break;

	default:
		error_illegal_ident();
		break;
	}
}

void
SBC( void )
{
	SBC_ADC(3, 0x42);
}


void
ADC( void )
{
	SBC_ADC(1, 0x4A);
}


void
ArithLog8_instr( int opcode )
{
	if (sym.cpu_ind_reg16 == IND_REG16_HL)							/* (hl), (ix+d), (iy+d) */
	{
		if (sym.cpu_idx_reg)
			append_byte(sym.cpu_idx_reg);

		append_byte((Byte)(0x80 + (opcode << 3) + 0x06));		/* xxx  A,(HL) */

		if (sym.cpu_idx_reg)
		{
			GetSym();
			Pass2info(RANGE_BYTE_SIGNED, 2);
		}
	}
    else
    {
        /* no indirect addressing, try to get an 8bit register */
		switch (sym.cpu_reg8)
		{
		case REG8_NONE:		/* 8bit register wasn't found, try to evaluate an expression */
			append_byte((Byte)(0xC0 + (opcode << 3) + 0x06));	/* xxx  A,n */
			Pass2info(RANGE_BYTE_UNSIGNED, 1);
            break;

		default:
			if (sym.cpu_idx_reg)
			{
				if (opts.cpu & CPU_RABBIT)
				{
					error_illegal_ident();
					return;
				}
				append_byte(sym.cpu_idx_reg);
			}

			append_byte((Byte)(0x80 + (opcode << 3) + sym.cpu_reg8));	/* xxx  A,r */
        }
    }
}

static void INC_DEC(int opcode8bit, int opcode16bit)
{
	GetSym();

	switch (sym.cpu_reg16_sp)
	{
	case REG16_NONE:
		IncDec_8bit_instr(opcode8bit);   /* 16 bit register wasn't found - try to evaluate the 8bit version */
		break;

	default:
		if (sym.cpu_idx_reg)
			append_byte(sym.cpu_idx_reg);

		append_byte((Byte)(opcode16bit + (sym.cpu_reg16_sp << 4)));
	}

}

void
INC( void )
{
	INC_DEC(4, 0x03);
}

void
DEC( void )
{
	INC_DEC(5, 0x0B);
}

void
IncDec_8bit_instr(int opcode)
{
	if (sym.cpu_ind_reg16 == IND_REG16_HL)							/* (hl), (ix+d), (iy+d) */
	{
		if (sym.cpu_idx_reg)
			append_byte(sym.cpu_idx_reg);

		append_byte((Byte)(0x30 + opcode));		/* INC/DEC (HL) */

		if (sym.cpu_idx_reg)
		{
			GetSym();
			Pass2info(RANGE_BYTE_SIGNED, 2);
		}
	}
	else if (sym.cpu_reg8 != REG8_NONE)
	{
		/* no indirect addressing, must be an 8bit register */
		if (sym.cpu_idx_reg)
		{
			if (opts.cpu & CPU_RABBIT)
			{
				error_illegal_ident();
				return;
			}
			append_byte(sym.cpu_idx_reg);
		}

		append_byte((Byte)((sym.cpu_reg8 << 3) + opcode));			/* INC/DEC  r */
	}
	else
	{
		error_syntax();
	}
}

void
BitTest_instr( int opcode )
{
    long bitnumber;

    GetSym();

	if (!expr_parse_eval(&bitnumber))
		return;

	if (bitnumber < 0 || bitnumber > 7)
	{
		error_int_range(bitnumber);
		return;
	}

	CurSymExpect(TK_COMMA);
	GetSym();

	if (sym.cpu_ind_reg16 == IND_REG16_HL)							/* (hl), (ix+d), (iy+d) */
	{
		if (!sym.cpu_idx_reg)
			append_2bytes(0xCB, (Byte)(opcode + (bitnumber << 3) + 0x06));
		else
		{
			append_2bytes(sym.cpu_idx_reg, 0xCB);
			GetSym();
			Pass2info(RANGE_BYTE_SIGNED, 2);
			append_byte((Byte)(opcode + (bitnumber << 3) + 0x06));
		}
	}
	else if (sym.cpu_reg8 != REG8_NONE)
	{
		/* no indirect addressing, must be an 8bit register */
		if (sym.cpu_idx_reg)
		{
			error_illegal_ident();
		}
		else
			append_2bytes(0xCB, (Byte)(opcode + (bitnumber << 3) + sym.cpu_reg8));
	}
	else
	{
		error_illegal_ident();
	}
}


void
RotShift_instr( int opcode )
{
	GetSym();

	if (sym.cpu_ind_reg16 == IND_REG16_HL)							/* (hl), (ix+d), (iy+d) */
	{
		if (!sym.cpu_idx_reg)
			append_2bytes(0xCB, (Byte)((opcode << 3) + 0x06));
		else
		{
			append_2bytes(sym.cpu_idx_reg, 0xCB);
			GetSym();
			Pass2info(RANGE_BYTE_SIGNED, 2);
			append_byte((Byte)((opcode << 3) + 0x06));
		}
	}
	else if (sym.cpu_reg8 != REG8_NONE)
	{
		/* no indirect addressing, must be an 8bit register */
		if (sym.cpu_idx_reg)
		{
			error_illegal_ident();
		}
		else
			append_2bytes(0xCB, (Byte)((opcode << 3) + sym.cpu_reg8));
	}
	else
	{
		error_illegal_ident();
	}
}
