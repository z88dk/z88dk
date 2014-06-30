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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/z80instr.c,v 1.79 2014-06-30 22:29:36 pauloscustodio Exp $
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

/* external functions */
int CheckRegister8( void );
int IndirectRegisters( void );
int CheckCondition( void );
int CheckRegister16( void );
void ExtAccumulator( int opcode );

/* local functions */
void ADD_8bit_instr( void );
void ADC_8bit_instr( void );
void SBC_8bit_instr( void );
void IncDec_8bit_instr( int opcode );
void ArithLog8_instr( int opcode );
void JP_instr( int opc0, int opc );
void Subroutine_addr( int opc0, int opc );

void
PushPop_instr( int opcode )
{
    int qq;

    if ( GetSym() == TK_NAME )
        switch ( qq = CheckRegister16() )
        {
        case REG16_BC:
        case REG16_DE:
        case REG16_HL:
            append_byte( (Byte)( opcode + qq * 0x10 ) );
            break;

        case REG16_AF:
            append_byte( (Byte)( opcode + 0x30 ) );
            break;

        case REG16_IX:
            append_byte( 0xDD );
            append_byte( (Byte)( opcode + 0x20 ) );
            break;

        case REG16_IY:
            append_byte( 0xFD );
            append_byte( (Byte)( opcode + 0x20 ) );
            break;

        default:
            error_illegal_ident();
        }
    else
    {
        error_syntax();
    }
}


void
RET( void )
{
    long constant;

    switch ( GetSym() )
    {
    case TK_NAME:
        if ( ( constant = CheckCondition() ) != -1 )
        {
            append_byte( (Byte)( 0xC0 + constant * 0x08 ) );  /* RET cc  instruction opcode */
        }
        else
        {
            error_illegal_ident();
        }

        break;

	case TK_END:
    case TK_NEWLINE:
        append_byte( 0xC9 );
        break;

    default:
        error_syntax();
        return;
    }
}



void
EX( void )
{
    if ( GetSym() == TK_LPAREN )
        if ( GetSym() == TK_NAME )
            if ( CheckRegister16() == REG16_SP )      /* EX  (SP) */
                if ( GetSym() == TK_RPAREN )
                    if ( GetSym() == TK_COMMA )
                        if ( GetSym() == TK_NAME )
                            switch ( CheckRegister16() )
                            {
                            case REG16_HL:
                                if ( ( opts.cpu & CPU_RABBIT ) )
                                {
                                    /* Instruction code changed */
                                    append_2bytes( 0xED, 0x54 );
                                }
                                else
                                {
                                    append_byte( 0xE3 );      /* EX  (SP),HL  */
                                }

                                break;

                            case REG16_IX:
                                append_2bytes( 0xDD, 0xE3 );  /* EX  (SP),IX  */
                                break;

                            case REG16_IY:
                                append_2bytes( 0xFD, 0xE3 );  /* EX  (SP),IY  */
                                break;

                            default:
                                error_illegal_ident();
                            }
                        else
                        {
                            error_syntax();
                        }
                    else
                    {
                        error_syntax();
                    }
                else
                {
                    error_syntax();
                }
            else
            {
                error_illegal_ident();
            }
        else
        {
            error_syntax();
        }
    else if ( tok == TK_NAME )
    {
        switch ( CheckRegister16() )
        {
        case REG16_DE:
            if ( GetSym() == TK_COMMA )      /* EX  DE,HL   */
                if ( GetSym() == TK_NAME )
                    if ( CheckRegister16() == 2 )
                    {
                        append_byte( 0xEB );
                    }
                    else
                    {
                        error_illegal_ident();
                    }
                else
                {
                    error_syntax();
                }
            else
            {
                error_syntax();
            }

            break;

        case REG16_AF:
            if ( GetSym() == TK_COMMA )      /* EX  AF,AF'   */
                if ( GetSym() == TK_NAME )
				{
					switch ( CheckRegister16() )
					{
					case REG16_AF:
					case REG16_AF1:
                        append_byte( 0x08 );
						break;
					default:
						error_illegal_ident();
                    }
				}
                else
                {
                    error_syntax();
                }
            else
            {
                error_syntax();
            }

            break;

        default:
            error_illegal_ident();
        }
    }
    else
    {
        error_syntax();
    }
}



void
OUT( void )
{
    long reg;

    if ( ( opts.cpu & CPU_RABBIT ) )
    {
        error_illegal_ident();
        return;
    }

    if ( GetSym() == TK_LPAREN )
    {
        GetSym();

        if ( CheckRegister8() == 1 )
        {
            /* OUT (C) */
            if ( GetSym() == TK_RPAREN )
                if ( GetSym() == TK_COMMA )
                    if ( GetSym() == TK_NAME )
                        switch ( reg = CheckRegister8() )
                        {
                        case 6:
                        case 8:
                        case 9:
                        case -1:
                            error_illegal_ident();
                            break;

                        default:
                            append_byte( 0xED );
                            append_byte( (Byte)( 0x41 + reg * 0x08 ) ); /* OUT (C),r  */
                            break;
                        }
                    else
                    {
                        error_syntax();
                    }
                else
                {
                    error_syntax();
                }
            else
            {
                error_syntax();
            }
        }
        else
        {
            append_byte( 0xD3 );

            if ( !ExprUnsigned8( 1 ) )
            {
                return;
            }

            if ( tok == TK_RPAREN )
                if ( GetSym() == TK_COMMA )
                    if ( GetSym() == TK_NAME )
                    {
                        if ( CheckRegister8() != 7 )
                        {
                            error_illegal_ident();
                        }
                    }
                    else
                    {
                        error_syntax();
                    }
                else
                {
                    error_syntax();
                }
            else
            {
                error_syntax();
            }
        }
    }
    else
    {
        error_syntax();
    }
}


void
IN( void )
{
    long inreg;

    if ( ( opts.cpu & CPU_RABBIT ) )
    {
        error_illegal_ident();
        return;
    }

    if ( GetSym() == TK_NAME )
    {
        switch ( inreg = CheckRegister8() )
        {
        case 8:
        case 9:
        case -1:
            error_illegal_ident();
            break;

        default:
            if ( GetSym() != TK_COMMA )
            {
                error_syntax();
                break;
            }

            if ( GetSym() != TK_LPAREN )
            {
                error_syntax();
                break;
            }

            GetSym();

            switch ( CheckRegister8() )
            {
            case 1:
                append_byte( 0xED );
                append_byte( (Byte)( 0x40 + inreg * 0x08 ) ); /* IN r,(C) */
                break;

            case -1:
                if ( inreg == 7 )
                {
                    append_byte( 0xDB );

                    if ( ExprUnsigned8( 1 ) )
                        if ( tok != TK_RPAREN )
                        {
                            error_syntax();
                        }
                }
                else
                {
                    error_illegal_ident();
                }

                break;

            default:
                error_illegal_ident();
                break;
            }

            break;
        }
    }
    else
    {
        error_syntax();
    }
}


void
IM( void )
{
    long constant;

    if ( opts.cpu & CPU_RABBIT )
    {
        error_illegal_ident();
        return;
    }

    GetSym();

	if ( expr_parse_eval( &constant ) )
	{
        switch ( constant )
        {
        case 0:	append_2bytes( 0xED, 0x46 ); break;
        case 1:	append_2bytes( 0xED, 0x56 ); break;
        case 2: append_2bytes( 0xED, 0x5E ); break;
		default: error_int_range( constant ); break;
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
    long constant;
	int listoffset = 0;

    GetSym();

    if ( ( constant = CheckCondition() ) != -1 ) /* Check for condition */
    {
        if ( GetSym() != TK_COMMA )
        {
            error_syntax();
            return;
        }

        if ( opcode0 == 205 && ( opts.cpu & CPU_RABBIT ) )
        {
            char buffer[200];

            switch ( constant )
            {
            case FLAGS_NZ:  /* nz */
                append_2bytes( 0x28, 0x03 ); /* jr z */
				listoffset = 2;
				next_PC();

				append_byte( (Byte)opcode0 );
                break;

            case FLAGS_Z:  /* z */
                append_2bytes( 0x20, 0x03 ); /* jr nz */
				listoffset = 2;
				next_PC();

                append_byte( (Byte)opcode0 );
                break;

            case FLAGS_NC:  /* nc */
                append_2bytes( 0x38, 0x03 ); /* jr c */
				listoffset = 2;
				next_PC();

                append_byte( (Byte)opcode0 );
                break;

            case FLAGS_C:  /* c */
                append_2bytes( 0x30, 0x03 ); /* jr nc */
				listoffset = 2;
				next_PC();

                append_byte( (Byte)opcode0 );
                break;

            case FLAGS_PO:  /* po */
                append_byte( 0xEA ); /* jp pe */
                sprintf( buffer, "ASMPC+6\n" );
                SetTemporaryLine( buffer );
                GetSym();
                ExprAddress( 1 );
                EOL = FALSE;
				listoffset = 3;
				next_PC();

				append_byte( 0xCD );
                break;

            case FLAGS_PE:  /* pe */
                append_byte( 0xE2 ); /* jp po */
                sprintf( buffer, "ASMPC+6\n" );
                SetTemporaryLine( buffer );
                GetSym();
                ExprAddress( 1 );
                EOL = FALSE;
				listoffset = 3;
				next_PC();

                append_byte( 0xCD );
                break;

            case FLAGS_P:  /* p */
                append_byte( 0xFA ); /* jp m */
                sprintf( buffer, "ASMPC+6\n" );
                SetTemporaryLine( buffer );
                GetSym();
                ExprAddress( 1 );
                EOL = FALSE;
				listoffset = 3;
				next_PC();

				append_byte( 0xCD );
                break;

            case FLAGS_M:  /* m */
                append_byte( 0xF2 ); /* jp p */
                sprintf( buffer, "ASMPC+6\n" );
                SetTemporaryLine( buffer );
                GetSym();
                ExprAddress( 1 );
                EOL = FALSE;
				listoffset = 3;
				next_PC();

				append_byte( 0xCD );
                break;
            }
        }
        else
        {
            append_byte( (Byte)( opcode + constant * 0x08 ) ); /* get instruction opcode */
        }

        GetSym();
    }
    else
    {
        append_byte( (Byte)opcode0 );  /* JP nn, CALL nn */
    }

    ExprAddress( listoffset + 1 );
}


void
JP_instr( int opc0, int opc )
{
    char *startexpr;				/* scan pointer to start of address expression */

	startexpr = ScanGetPos();		/* remember position of possible start of expression */

    if ( GetSym() == TK_LPAREN )
    {
        GetSym();

        switch ( CheckRegister16() )
        {
        case 2:         /* JP (HL) */
            append_byte( 0xE9 );
            break;

        case 5:         /* JP (IX) */
            append_2bytes( 0xDD, 0xE9 );
            break;

        case 6:         /* JP (IY) */
            append_2bytes( 0xFD, 0xE9 );
            break;

        case -1:
            error_syntax();
            break;

        default:
            error_illegal_ident();
            break;
        }
    }
    else
    {
		ScanSetPos( startexpr );		/* no indirect register were found, reparse line after 'JP' */
		Subroutine_addr( opc0, opc );	/* base opcode for <instr> nn; <instr> cc, nn */
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
    long constant;
	Byte opcode = 0x18;			/* opcode for JR  e */
    char *startexpr;				/* scan pointer to start of address expression */

	startexpr = ScanGetPos();		/* remember position of possible start of expression */

    if ( GetSym() == TK_NAME )
    {
        switch ( constant = CheckCondition() )
        {
            /* check for a condition */
        case FLAGS_NZ:
        case FLAGS_Z:
        case FLAGS_NC:
        case FLAGS_C:
            opcode = (Byte)( 0x20 + constant * 0x08 );

            if ( GetSym() == TK_COMMA )
            {
                GetSym();			/* point at start of address expression */
				break;
            }
            else
            {
                error_syntax(); /* comma missing */
				return;
            }
			break;

        case -1:
			ScanSetPos( startexpr );
			GetSym();
            break;              /* identifier not a condition id - check for legal expression */

        default:
            error_syntax();      /* illegal condition, syntax */
            return;
        }

    }

	RelativeJump( opcode );
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
    int acc16, reg16;
    char *fptr;

    fptr = ScanGetPos();

    GetSym();

    switch ( acc16 = CheckRegister16() )
    {
    case -1:
        ScanSetPos( fptr );
        ExtAccumulator( 0 );      /* 16 bit register wasn't found - try to evaluate the 8 bit version */
        break;

    case 2:
        if ( GetSym() == TK_COMMA )
        {
            GetSym();
            reg16 = CheckRegister16();

            if ( reg16 >= 0 && reg16 <= 3 )
            {
                append_byte( (Byte)( 0x09 + 0x10 * reg16 ) ); /* ADD HL,rr */
            }
            else
            {
                error_illegal_ident();
            }
        }
        else
        {
            error_syntax();
        }

        break;

    case 5:
    case 6:
        if ( GetSym() == TK_COMMA )
        {
            GetSym();
            reg16 = CheckRegister16();

            switch ( reg16 )
            {
            case 0:
            case 1:
            case 3:
                break;

            case 5:
            case 6:
                if ( acc16 == reg16 )
                {
                    reg16 = 2;
                }
                else
                {
                    error_illegal_ident();
                    return;
                }

                break;

            default:
                error_illegal_ident();
                return;
            }

            if ( acc16 == 5 )
            {
                append_byte( 0xDD );
            }
            else
            {
                append_byte( 0xFD );
            }

            append_byte( (Byte)( 0x09 + 0x10 * reg16 ) );
        }
        else
        {
            error_syntax();
        }

        break;

    default:
        error_unknown_ident();
        break;
    }
}


void
SBC( void )
{
    int reg16;
    char *fptr;

    fptr = ScanGetPos();
    GetSym();

    switch ( CheckRegister16() )
    {
    case -1:
        ScanSetPos( fptr );
        ExtAccumulator( 3 );      /* 16 bit register wasn't found - try to evaluate the 8 bit version */
        break;

    case 2:
        if ( GetSym() == TK_COMMA )
        {
            GetSym();
            reg16 = CheckRegister16();

            if ( reg16 >= 0 && reg16 <= 3 )
            {
                append_byte( 0xED );
                append_byte( (Byte)( 0x42 + 0x10 * reg16 ) );
            }
            else
            {
                error_illegal_ident();
            }
        }
        else
        {
            error_syntax();
        }

        break;

    default:
        error_illegal_ident();
        break;
    }
}


void
ADC( void )
{
    int reg16;
    char *fptr;

    fptr = ScanGetPos();

    GetSym();

    switch ( CheckRegister16() )
    {
    case -1:
        ScanSetPos( fptr );
        ExtAccumulator( 1 );      /* 16 bit register wasn't found - try to evaluate the 8 bit version */
        break;

    case 2:
        if ( GetSym() == TK_COMMA )
        {
            GetSym();
            reg16 = CheckRegister16();

            if ( reg16 >= 0 && reg16 <= 3 )
            {
                append_byte( 0xED );
                append_byte( (Byte)( 0x4A + 0x10 * reg16 ) );
            }
            else
            {
                error_illegal_ident();
            }
        }
        else
        {
            error_syntax();
        }

        break;

    default:
        error_illegal_ident();
        break;
    }
}






void
ArithLog8_instr( int opcode )
{
    long reg;

    if ( GetSym() == TK_LPAREN )
        switch ( reg = IndirectRegisters() )
        {
        case 2:
            append_byte( (Byte)( 0x80 + opcode * 0x08 + 0x06 ) ); /* xxx  A,(HL) */
            break;

        case 5:                   /* xxx A,(IX+d) */
        case 6:
            if ( reg == 5 )
            {
                append_byte( 0xDD );
            }
            else
            {
                append_byte( 0xFD );    /* xxx A,(IY+d) */
            }

            append_byte( (Byte)( 0x80 + opcode * 0x08 + 0x06 ) );
            ExprSigned8( 2 );
            break;

        default:
            error_syntax();
            break;
        }
    else
    {
        /* no indirect addressing, try to get an 8bit register */
        reg = CheckRegister8();

        switch ( reg )
        {
            /* 8bit register wasn't found, try to evaluate an expression */
        case -1:
            append_byte( (Byte)( 0xC0 + opcode * 0x08 + 0x06 ) ); /* xxx  A,n */
            ExprUnsigned8( 1 );
            break;

        case 6:         /* xxx A,F illegal */
        case 8:         /* xxx A,I illegal */
        case 9:         /* xxx A,R illegal */
            error_illegal_ident();
            break;

        default:
            if ( reg & 8 )
            {
                /* IXl or IXh */
                if ( ( opts.cpu & CPU_RABBIT ) )
                {
                    error_illegal_ident();
                    return;
                }

                append_byte( 0xDD );
            }
            else if ( reg & 16 )
            {
                /* IYl or IYh */
                if ( ( opts.cpu & CPU_RABBIT ) )
                {
                    error_illegal_ident();
                    return;
                }

                append_byte( 0xFD );
            }

            reg &= 7;

            append_byte( (Byte)( 0x80 + opcode * 0x08 + reg ) ); /* xxx  A,r */
            break;
        }
    }
}



void
INC( void )
{
    int reg16;

    GetSym();

    switch ( reg16 = CheckRegister16() )
    {
    case -1:
        IncDec_8bit_instr( 4 );   /* 16 bit register wasn't found - try to evaluate the 8bit version */
        break;

    case 4:
        error_illegal_ident();
        break;

    case 5:
        append_2bytes( 0xDD, 0x23 );
        break;

    case 6:
        append_2bytes( 0xFD, 0x23 );
        break;

    default:
        append_byte( (Byte)( 0x03 + reg16 * 0x10 ) );
        break;
    }
}


void
DEC( void )
{
    int reg16;

    GetSym();

    switch ( reg16 = CheckRegister16() )
    {
    case -1:
        IncDec_8bit_instr( 5 );   /* 16 bit register wasn't found - try to evaluate the 8bit version */
        break;

    case 4:
        error_illegal_ident();
        break;

    case 5:
        append_2bytes( 0xDD, 0x2B );
        break;

    case 6:
        append_2bytes( 0xFD, 0x2B );
        break;

    default:
        append_byte( (Byte)( 0x0B + reg16 * 0x10 ) );
        break;
    }
}


void
IncDec_8bit_instr( int opcode )
{
    long reg;

    if ( tok == TK_LPAREN )
    {
        switch ( reg = IndirectRegisters() )
        {
        case 2:
            append_byte( (Byte)( 0x30 + opcode ) ); /* INC/DEC (HL) */
            break;

        case 5:         /* INC/DEC (IX+d) */
        case 6:
            if ( reg == 5 )
            {
                append_byte( 0xDD );
            }
            else
            {
                append_byte( 0xFD );    /* INC/DEC (IY+d) */
            }

            append_byte( (Byte)( 0x30 + opcode ) );
            ExprSigned8( 2 );
            break;


        default:
            error_syntax();
            break;
        }
    }
    else
    {
        /* no indirect addressing, try to get an 8bit register */
        reg = CheckRegister8();

        switch ( reg )
        {
        case 6:
        case 8:
        case 9:
            error_illegal_ident();       /* INC/DEC I ;  INC/DEC R
                                                                     * illegal */
            break;

        case 12:
        case 13:
            if ( ( opts.cpu & CPU_RABBIT ) )
            {
                error_illegal_ident();
                return;
            }

            append_byte( 0xDD );
            append_byte( (Byte)( ( reg & 0x07 ) * 0x08 + opcode ) ); /* INC/DEC  ixh,ixl */
            break;

        case 20:
        case 21:
            if ( ( opts.cpu & CPU_RABBIT ) )
            {
                error_illegal_ident();
                return;
            }

            append_byte( 0xFD );
            append_byte( (Byte)( ( reg & 0x07 ) * 0x08 + opcode ) ); /* INC/DEC  iyh,iyl */
            break;

        default:
            append_byte( (Byte)( reg * 0x08 + opcode ) ); /* INC/DEC  r */
            break;
        }
    }
}



void
BitTest_instr( int opcode )
{
    long bitnumber, reg;

    GetSym();

	if ( expr_parse_eval( &bitnumber ) )
	{
        if ( bitnumber >= 0 && bitnumber <= 7 )
        {
            /* bit 0 - 7 */
            if ( tok == TK_COMMA )
            {
                if ( GetSym() == TK_LPAREN )
                {
                    switch ( ( reg = IndirectRegisters() ) )
                    {
                    case 2:
                        append_byte( 0xCB );  /* (HL)  */
                        append_byte( (Byte)( opcode + bitnumber * 0x08 + 0x06 ) );
                        break;

                    case 5:
                    case 6:
                        if ( reg == 5 )
                        {
                            append_byte( 0xDD );
                        }
                        else
                        {
                            append_byte( 0xFD );
                        }

                        append_byte( 0xCB );
                        ExprSigned8( 2 );
                        append_byte( (Byte)( opcode + bitnumber * 0x08 + 0x06 ) );
                        break;

                    default:
                        error_syntax();
                        break;
                    }
                }
                else
                {
                    /* no indirect addressing, try to get an 8bit register */
                    reg = CheckRegister8();

                    switch ( reg )
                    {
                    case 6:
                    case 8:
                    case 9:
                    case -1:
                        error_illegal_ident();
                        break;

                    default:
                        append_byte( 0xCB );
                        append_byte( (Byte)( opcode + bitnumber * 0x08 + reg ) );
                    }
                }
            }
            else
            {
                error_syntax();
            }
        }
        else
        {
            error_int_range( bitnumber );
        }
    }
}


void
RotShift_instr( int opcode )
{
    long reg;

    if ( GetSym() == TK_LPAREN )
        switch ( ( reg = IndirectRegisters() ) )
        {
        case 2:
            append_byte( 0xCB );
            append_byte( (Byte)( opcode * 0x08 + 0x06 ) );
            break;

        case 5:
        case 6:
            if ( reg == 5 )
            {
                append_byte( 0xDD );
            }
            else
            {
                append_byte( 0xFD );
            }

            append_byte( 0xCB );
            ExprSigned8( 2 );
            append_byte( (Byte)( opcode * 0x08 + 0x06 ) );
            break;

        default:
            error_syntax();
            break;
        }
    else
    {
        /* no indirect addressing, try to get an 8bit register */
        reg = CheckRegister8();

        switch ( reg )
        {
        case 6:
        case 8:
        case 9:
        case -1:
            error_illegal_ident();
            break;

        default:
            append_byte( 0xCB );
            append_byte( (Byte)( opcode * 0x08 + reg ) );
        }
    }
}
