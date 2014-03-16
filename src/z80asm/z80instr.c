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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/z80instr.c,v 1.53 2014-03-16 23:57:06 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "codearea.h"
#include "config.h"
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
struct expr *ParseNumExpr( void );
void RemovePfixlist( struct expr *pfixexpr );
void Pass2info( struct expr *expression, char constrange, long lfileptr );
long EvalPfixExpr( struct expr *pfixexpr );
int ExprSigned8( int listpatchoffset );
int CheckRegister8( void );
int IndirectRegisters( void );
int CheckCondition( void );
int CheckRegister16( void );
int ExprUnsigned8( int listoffset );
int ExprAddress( int listoffset );
void ExtAccumulator( int opcode );

/* local functions */
void ADD_8bit_instr( void );
void ADC_8bit_instr( void );
void SBC_8bit_instr( void );
void IncDec_8bit_instr( int opcode );
void ArithLog8_instr( int opcode );
void NewJRaddr( void );
void JP_instr( int opc0, int opc );
void Subroutine_addr( int opc0, int opc );


/* global variables */
extern struct module *CURRENTMODULE;


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
            append_byte( ( byte_t )( opcode + qq * 0x10 ) );
            inc_PC( 1 );
            break;

        case REG16_AF:
            append_byte( ( byte_t )( opcode + 0x30 ) );
            inc_PC( 1 );
            break;

        case REG16_IX:
            append_byte( 0xDD );
            append_byte( ( byte_t )( opcode + 0x20 ) );
            inc_PC( 2 );
            break;

        case REG16_IY:
            append_byte( 0xFD );
            append_byte( ( byte_t )( opcode + 0x20 ) );
            inc_PC( 2 );
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
            append_byte( ( byte_t )( 0xC0 + constant * 0x08 ) );  /* RET cc  instruction opcode */
        }
        else
        {
            error_illegal_ident();
        }

        break;

	case TK_EOF:
    case TK_NEWLINE:
        append_byte( 0xC9 );
        break;

    default:
        error_syntax();
        return;
    }

    inc_PC( 1 );
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
                                    append_byte( 0xED );
                                    append_byte( 0x54 );
                                    inc_PC( 2 );
                                }
                                else
                                {
                                    append_byte( 0xE3 );      /* EX  (SP),HL  */
                                    inc_PC( 1 );
                                }

                                break;

                            case REG16_IX:
                                append_byte( 0xDD );
                                append_byte( 0xE3 );  /* EX  (SP),IX  */
                                inc_PC( 2 );
                                break;

                            case REG16_IY:
                                append_byte( 0xFD );
                                append_byte( 0xE3 );  /* EX  (SP),IY  */
                                inc_PC( 2 );
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
                        inc_PC( 1 );
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

        case 4:
            if ( GetSym() == TK_COMMA )      /* EX  AF,AF'   */
                if ( GetSym() == TK_NAME )
                    if ( CheckRegister16() == 4 )
                    {
                        append_byte( 0x08 );
                        inc_PC( 1 );
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
                            append_byte( ( byte_t )( 0x41 + reg * 0x08 ) ); /* OUT (C),r  */
                            inc_PC( 2 );
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

            inc_PC( 2 );

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
                append_byte( ( byte_t )( 0x40 + inreg * 0x08 ) ); /* IN r,(C) */
                inc_PC( 2 );
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

                    inc_PC( 2 );
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
    struct expr *postfixexpr;

    if ( ( opts.cpu & CPU_RABBIT ) )
    {
        error_illegal_ident();
        return;
    }

    GetSym();

    if ( ( postfixexpr = ParseNumExpr() ) != NULL )
    {
        if ( postfixexpr->expr_type & NOT_EVALUABLE )
        {
            error_not_defined();
        }
        else
        {
            constant = EvalPfixExpr( postfixexpr );

            switch ( constant )
            {
            case 0:
                append_byte( 0xED );
                append_byte( 0x46 );      /* IM 0   */
                break;

            case 1:
                append_byte( 0xED );
                append_byte( 0x56 );      /* IM 1  */
                break;

            case 2:
                append_byte( 0xED );
                append_byte( 0x5E );      /* IM 2  */
                break;
            }

            inc_PC( 2 );
        }

        RemovePfixlist( postfixexpr );    /* remove linked list, because expr. was evaluated */
    }
}


void
RST( void )
{
    long constant;
    struct expr *postfixexpr;

    GetSym();

    if ( ( postfixexpr = ParseNumExpr() ) != NULL )
    {
        if ( postfixexpr->expr_type & NOT_EVALUABLE )
        {
            error_not_defined();
        }
        else
        {
            constant = EvalPfixExpr( postfixexpr );

            if ( ( constant >= 0 && constant <= 56 ) && ( constant % 8 == 0 ) )
            {
                if ( ( opts.cpu & CPU_RABBIT ) &&
                        ( ( constant == 0 ) || ( constant == 8 ) || ( constant == 0x30 ) ) )
                {
                    error_illegal_ident();
                }
                else
                {
                    append_byte( ( byte_t )( 0xC7 + constant ) ); /* RST  00H, ... 38H */
                    inc_PC( 1 );
                }
            }
            else
            {
                error_int_range( constant );
            }
        }

        RemovePfixlist( postfixexpr );
    }
}


void CALL_OZ( void )
{
    long constant;
    struct expr *postfixexpr;

    append_byte( 0xE7 );          /* RST 20H instruction */
    inc_PC( 1 );

    if ( GetSym() == TK_LPAREN )
    {
        GetSym();    /* Optional parenthesis around expression */
    }

    if ( ( postfixexpr = ParseNumExpr() ) != NULL )
    {
        if ( postfixexpr->expr_type & NOT_EVALUABLE )
        {
            error_not_defined();    /* CALL_OZ expression must be evaluable */
        }
        else
        {
            constant = EvalPfixExpr( postfixexpr );

            if ( ( constant > 0 ) && ( constant <= 255 ) )
            {
                append_byte( ( byte_t )constant ); /* 1 byte OZ parameter */
                inc_PC( 1 );
            }
            else if ( ( constant > 255 ) && ( constant <= 65535 ) )
            {
                append_word( constant );  /* 2 byte OZ parameter */
                inc_PC( 2 );
            }
            else
            {
                error_int_range( constant );
            }
        }

        RemovePfixlist( postfixexpr );    /* remove linked list, because expr. was evaluated */
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
    struct expr *postfixexpr;

    append_byte( 0xCF );          /* RST 08H instruction */
    inc_PC( 1 );

    if ( GetSym() == TK_LPAREN )
    {
        GetSym();    /* Optional parenthesis around expression */
    }

    if ( ( postfixexpr = ParseNumExpr() ) != NULL )
    {
        if ( postfixexpr->expr_type & NOT_EVALUABLE )
        {
            error_not_defined();    /* CALL_OZ expression must be evaluable */
        }
        else
        {
            constant = EvalPfixExpr( postfixexpr );

            if ( ( constant >= 0 ) && ( constant <= 65535 ) )
            {
                append_word( constant );    /* 2 byte parameter always */
                inc_PC( 2 );
            }
            else
            {
                error_int_range( constant );
            }
        }

        RemovePfixlist( postfixexpr );    /* remove linked list, because expr. was evaluated */
    }
}

void
INVOKE( void )
{
    long constant;
    struct expr *postfixexpr;

    if ( opts.ti83plus )
    {
        append_byte( 0xEF );    /* Ti83Plus: RST 28H instruction */
    }
    else
    {
        append_byte( 0xCD );    /* Ti83: CALL */
    }

    inc_PC( 1 );

    if ( GetSym() == TK_LPAREN )
    {
        GetSym();    /* Optional parenthesis around expression */
    }

    if ( ( postfixexpr = ParseNumExpr() ) != NULL )
    {
        if ( postfixexpr->expr_type & NOT_EVALUABLE )
        {
            error_not_defined();    /* INVOKE expression must be evaluable */
        }
        else
        {
            constant = EvalPfixExpr( postfixexpr );

            if ( ( constant >= 0 ) && ( constant <= 65535 ) )
            {
                append_word( constant );    /* 2 byte parameter always */
                inc_PC( 2 );
            }
            else
            {
                error_int_range( constant );
            }
        }

        RemovePfixlist( postfixexpr );    /* remove linked list, because expr. was evaluated */
    }
}

void
FPP( void )
{
    long constant;
    struct expr *postfixexpr;

    append_byte( 0xDF );          /* RST 18H instruction */
    inc_PC( 1 );

    if ( GetSym() == TK_LPAREN )
    {
        GetSym();    /* Optional parenthesis around expression */
    }

    if ( ( postfixexpr = ParseNumExpr() ) != NULL )
    {
        if ( postfixexpr->expr_type & NOT_EVALUABLE )
        {
            error_not_defined();    /* FPP expression must be evaluable */
        }
        else
        {
            constant = EvalPfixExpr( postfixexpr );

            if ( ( constant > 0 ) && ( constant < 255 ) )
            {
                append_byte( ( byte_t )constant ); /* 1 byte OZ parameter */
                inc_PC( 1 );
            }
            else
            {
                error_int_range( constant );
            }
        }

        RemovePfixlist( postfixexpr );    /* remove linked list, because expr. was evaluated */
    }
}


void
Subroutine_addr( int opcode0, int opcode )
{
    long constant;

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
            static char buffer[200];

            switch ( constant )
            {
            case FLAGS_NZ:  /* nz */
                append_byte( 0x28 ); /* jr z */
                append_byte( 0x03 );
                append_byte( ( byte_t )opcode0 );
                inc_PC( 2 );
                break;

            case FLAGS_Z:  /* z */
                append_byte( 0x20 ); /* jr nz */
                append_byte( 0x03 );
                append_byte( ( byte_t )opcode0 );
                inc_PC( 2 );
                break;

            case FLAGS_NC:  /* nc */
                append_byte( 0x38 ); /* jr c */
                append_byte( 0x03 );
                append_byte( ( byte_t )opcode0 );
                inc_PC( 2 );
                break;

            case FLAGS_C:  /* c */
                append_byte( 0x30 ); /* jr nc */
                append_byte( 0x03 );
                append_byte( ( byte_t )opcode0 );
                inc_PC( 2 );
                break;

            case FLAGS_PO:  /* po */
                append_byte( 0xea ); /* jp pe */
                sprintf( buffer, "ASMPC+6\n" );
                SetTemporaryLine( buffer );
                GetSym();
                ExprAddress( 1 );
                EOL = FALSE;
                append_byte( 0xCD );
                inc_PC( 3 );
                break;

            case FLAGS_PE:  /* pe */
                append_byte( 0xe2 ); /* jp po */
                sprintf( buffer, "ASMPC+6\n" );
                SetTemporaryLine( buffer );
                GetSym();
                ExprAddress( 1 );
                EOL = FALSE;
                append_byte( 0xCD );
                inc_PC( 3 );
                break;

            case FLAGS_P:  /* p */
                append_byte( 0xfa ); /* jp m */
                sprintf( buffer, "ASMPC+6\n" );
                SetTemporaryLine( buffer );
                GetSym();
                ExprAddress( 1 );
                EOL = FALSE;
                append_byte( 0xCD );
                inc_PC( 3 );
                break;

            case FLAGS_M:  /* m */
                append_byte( 0xf2 ); /* jp p */
                sprintf( buffer, "ASMPC+6\n" );
                SetTemporaryLine( buffer );
                GetSym();
                ExprAddress( 1 );
                EOL = FALSE;
                append_byte( 0xCD );
                inc_PC( 3 );
                break;
            }
        }
        else
        {
            append_byte( ( byte_t )( opcode + constant * 0x08 ) ); /* get instruction opcode */
        }

        GetSym();
    }
    else
    {
        append_byte( ( byte_t )opcode0 );  /* JP nn, CALL nn */
    }

    ExprAddress( 1 );
    inc_PC( 3 );
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
            inc_PC( 1 );
            break;

        case 5:         /* JP (IX) */
            append_byte( 0xDD );
            append_byte( 0xE9 );
            inc_PC( 2 );
            break;

        case 6:         /* JP (IY) */
            append_byte( 0xFD );
            append_byte( 0xE9 );
            inc_PC( 2 );
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


void
JR( void )
{
    struct expr *postfixexpr;
    long constant;

    if ( GetSym() == TK_NAME )
    {
        switch ( constant = CheckCondition() )
        {
            /* check for a condition */
        case FLAGS_NZ:
        case FLAGS_Z:
        case FLAGS_NC:
        case FLAGS_C:
            append_byte( ( byte_t )( 0x20 + constant * 0x08 ) );

            if ( GetSym() == TK_COMMA )
            {
                GetSym();         /* point at start of address expression */
                break;
            }
            else
            {
                error_syntax(); /* comma missing */
                return;
            }

        case -1:
            append_byte( 0x18 );  /* opcode for JR  e */
            break;                /* identifier not a condition id - check for legal expression */

        default:
            error_syntax();      /* illegal condition, syntax
                                                                     * error  */
            return;
        }
    }

    inc_PC( 2 );                  /* assembler PC points at next instruction */

    if ( ( postfixexpr = ParseNumExpr() ) != NULL )
    {
        /* get numerical expression */
        if ( postfixexpr->expr_type & NOT_EVALUABLE )
        {
            NewJRaddr();          /* Amend another JR PC address to the list */
            Pass2info( postfixexpr, RANGE_JROFFSET, 1 );
            append_byte( 0 );     /* update code pointer */
        }
        else
        {
            constant = EvalPfixExpr( postfixexpr );
            constant -= get_PC();
            RemovePfixlist( postfixexpr );        /* remove linked list - expression evaluated. */

            if ( ( constant >= -128 ) && ( constant <= 127 ) )
            {
                append_byte( ( byte_t )( constant ) );  /* opcode is stored, now store relative jump */
            }
            else
            {
                append_byte( 0 );								/* BUG_0025 - store dummy offset */
                error_int_range( constant );
            }
        }
    }
}


void
DJNZ( void )
{
    struct expr *postfixexpr;
    long constant;

    append_byte( 0x10 );          /* DJNZ opcode */

    if ( GetSym() == TK_COMMA )
    {
        GetSym();                         /* optional comma */
    }

    inc_PC( 2 );

    if ( ( postfixexpr = ParseNumExpr() ) != NULL )
    {
        /* get numerical expression */
        if ( postfixexpr->expr_type & NOT_EVALUABLE )
        {
            NewJRaddr();          /* Amend another JR PC address to the list */
            Pass2info( postfixexpr, RANGE_JROFFSET, 1 );
            append_byte( 0 );     /* update code pointer */
        }
        else
        {
            constant = EvalPfixExpr( postfixexpr );
            constant -= get_PC();
            RemovePfixlist( postfixexpr );        /* remove linked list - expression evaluated. */

            if ( ( constant >= -128 ) && ( constant <= 127 ) )
            {
                append_byte( ( byte_t )( constant ) );  /* opcode is stored, now store relative jump */
            }
            else
            {
                append_byte( 0 );								/* BUG_0025 - store dummy offset */
                error_int_range( constant );
            }
        }
    }
}


void
NewJRaddr( void )
{
    struct JRPC *newJRPC;

    newJRPC = xnew( struct JRPC );
    newJRPC->nextref = NULL;
    newJRPC->PCaddr = ( uint_t )get_PC();

    if ( CURRENTMODULE->JRaddr->firstref == NULL )
    {
        /* no list yet */
        CURRENTMODULE->JRaddr->firstref = newJRPC;      /* initialise first reference */
        CURRENTMODULE->JRaddr->lastref = newJRPC;
    }
    else
    {
        CURRENTMODULE->JRaddr->lastref->nextref = newJRPC;      /* update last entry with new entry */
        CURRENTMODULE->JRaddr->lastref = newJRPC;               /* point to new entry */
    }
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
                append_byte( ( byte_t )( 0x09 + 0x10 * reg16 ) ); /* ADD HL,rr */
                inc_PC( 1 );
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

            append_byte( ( byte_t )( 0x09 + 0x10 * reg16 ) );
            inc_PC( 2 );
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
                append_byte( ( byte_t )( 0x42 + 0x10 * reg16 ) );
                inc_PC( 2 );
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
                append_byte( ( byte_t )( 0x4A + 0x10 * reg16 ) );
                inc_PC( 2 );
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
            append_byte( ( byte_t )( 0x80 + opcode * 0x08 + 0x06 ) ); /* xxx  A,(HL) */
            inc_PC( 1 );
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

            append_byte( ( byte_t )( 0x80 + opcode * 0x08 + 0x06 ) );
            ExprSigned8( 2 );
            inc_PC( 3 );
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
            append_byte( ( byte_t )( 0xC0 + opcode * 0x08 + 0x06 ) ); /* xxx  A,n */
            ExprUnsigned8( 1 );
            inc_PC( 2 );
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
                inc_PC( 1 );
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
                inc_PC( 1 );
            }

            reg &= 7;

            append_byte( ( byte_t )( 0x80 + opcode * 0x08 + reg ) ); /* xxx  A,r */
            inc_PC( 1 );
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
        append_byte( 0xDD );
        append_byte( 0x23 );
        inc_PC( 2 );
        break;

    case 6:
        append_byte( 0xFD );
        append_byte( 0x23 );
        inc_PC( 2 );
        break;

    default:
        append_byte( ( byte_t )( 0x03 + reg16 * 0x10 ) );
        inc_PC( 1 );
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
        append_byte( 0xDD );
        append_byte( 0x2B );
        inc_PC( 2 );
        break;

    case 6:
        append_byte( 0xFD );
        append_byte( 0x2B );
        inc_PC( 2 );
        break;

    default:
        append_byte( ( byte_t )( 0x0B + reg16 * 0x10 ) );
        inc_PC( 1 );
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
            append_byte( ( byte_t )( 0x30 + opcode ) ); /* INC/DEC (HL) */
            inc_PC( 1 );
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

            append_byte( ( byte_t )( 0x30 + opcode ) );
            ExprSigned8( 2 );
            inc_PC( 3 );
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
            append_byte( ( byte_t )( ( reg & 0x07 ) * 0x08 + opcode ) ); /* INC/DEC  ixh,ixl */
            inc_PC( 2 );
            break;

        case 20:
        case 21:
            if ( ( opts.cpu & CPU_RABBIT ) )
            {
                error_illegal_ident();
                return;
            }

            append_byte( 0xFD );
            append_byte( ( byte_t )( ( reg & 0x07 ) * 0x08 + opcode ) ); /* INC/DEC  iyh,iyl */
            inc_PC( 2 );
            break;

        default:
            append_byte( ( byte_t )( reg * 0x08 + opcode ) ); /* INC/DEC  r */
            inc_PC( 1 );
            break;
        }
    }
}



void
BitTest_instr( int opcode )
{
    long bitnumber, reg;
    struct expr *postfixexpr;

    GetSym();

    if ( ( postfixexpr = ParseNumExpr() ) != NULL )
    {
        /* Expression must not be stored in object file */
        if ( postfixexpr->expr_type & NOT_EVALUABLE )
        {
            error_not_defined();
        }
        else
        {
            bitnumber = EvalPfixExpr( postfixexpr );

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
                            append_byte( ( byte_t )( opcode + bitnumber * 0x08 + 0x06 ) );
                            inc_PC( 2 );
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
                            append_byte( ( byte_t )( opcode + bitnumber * 0x08 + 0x06 ) );
                            inc_PC( 4 );
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
                            append_byte( ( byte_t )( opcode + bitnumber * 0x08 + reg ) );
                            inc_PC( 2 );
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

        RemovePfixlist( postfixexpr );
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
            append_byte( ( byte_t )( opcode * 0x08 + 0x06 ) );
            inc_PC( 2 );
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
            append_byte( ( byte_t )( opcode * 0x08 + 0x06 ) );
            inc_PC( 4 );
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
            append_byte( ( byte_t )( opcode * 0x08 + reg ) );
            inc_PC( 2 );
        }
    }
}

/*
* $Log: z80instr.c,v $
* Revision 1.53  2014-03-16 23:57:06  pauloscustodio
* Removed global line[]
*
* Revision 1.52  2014/03/15 02:12:07  pauloscustodio
* Rename last token to tok*
* GetSym() declared in scan.h
*
* Revision 1.51  2014/03/11 23:34:00  pauloscustodio
* Remove check for feof(z80asmfile), add token TK_EOF to return on EOF.
* Allows decoupling of input file used in scanner from callers.
* Removed TOTALLINES.
* GetChar() made static to scanner, not called by other modules.
*
* Revision 1.50  2014/03/11 22:59:20  pauloscustodio
* Move EOL flag to scanner
*
* Revision 1.49  2014/03/11 00:15:13  pauloscustodio
* Scanner reads input line-by-line instead of character-by-character.
* Factor house-keeping at each new line read in the scanner getasmline().
* Add interface to allow back-tacking of the recursive descent parser by
* getting the current input buffer position and comming back to the same later.
* SetTemporaryLine() keeps a stack of previous input lines.
* Scanner handles single-quoted strings and returns a number.
* New error for single-quoted string with length != 1.
* Scanner handles double-quoted strings and returns the quoted string.
*
* Revision 1.48  2014/03/05 23:44:55  pauloscustodio
* Renamed 64-bit portability to BUG_0042
*
* Revision 1.47  2014/03/04 11:49:47  pauloscustodio
* Expression parser and expression evaluator use a look-up table of all
* supported unary, binary and ternary oprators, instead of a big switch
* statement to select the operation.
* Expression operations are stored in a contiguous array instead of
* a liked list to reduce administrative overhead of adding / iterating.
*
* Revision 1.46  2014/03/03 13:43:50  pauloscustodio
* Renamed symbol and expression type attributes
*
* Revision 1.45  2014/03/03 13:27:07  pauloscustodio
* Rename symbol type constants
*
* Revision 1.44  2014/03/01 15:45:31  pauloscustodio
* CH_0021: New operators ==, !=, &&, ||, <<, >>, ?:
* Handle C-like operators, make exponentiation (**) right-associative.
* Simplify expression parser by handling composed tokens in lexer.
* Change token ids to TK_...
*
* Revision 1.43  2014/02/25 22:39:34  pauloscustodio
* ws
*
* Revision 1.42  2014/02/24 23:08:55  pauloscustodio
* Rename "enum symbols" to "tokid_t", define in token.h
*
* Revision 1.41  2014/02/19 23:59:26  pauloscustodio
* BUG_0042: 64-bit portability issues
* size_t changes to unsigned long in 64-bit. Usage of size_t * to
* retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
* breaks on a 64-bit architecture. Make the functions return the value instead
* of being passed the pointer to the return value, so that the compiler
* takes care of size convertions.
* Create uint_t and ulong_t, use uint_t instead of size_t.
*
* Revision 1.40  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.39  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.38  2013/12/15 13:18:34  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.37  2013/10/04 23:20:21  pauloscustodio
* Parse command line options via look-up tables:
* -plus, --ti83plus
*
* Revision 1.36  2013/10/04 23:09:25  pauloscustodio
* Parse command line options via look-up tables:
* -R, --relocatable
* --RCMX000
*
* Revision 1.35  2013/09/08 08:29:21  pauloscustodio
* Replaced xmalloc et al with glib functions
*
* Revision 1.34  2013/09/08 00:43:59  pauloscustodio
* New error module with one error function per error, no need for the error
* constants. Allows compiler to type-check error message arguments.
* Included the errors module in the init() mechanism, no need to call
* error initialization from main(). Moved all error-testing scripts to
* one file errors.t.
*
* Revision 1.33  2013/01/24 23:03:03  pauloscustodio
* Replaced (unsigned char) by (byte_t)
* Replaced (unisigned int) by (uint_t)
* Replaced (short) by (int)
*
* Revision 1.32  2013/01/20 12:50:05  pauloscustodio
* BUG_0025 : JR at org 0 with out-of-range jump crashes WriteListFile()
* jr instruction on address 0, with out of range argument ->
* jr calls error and writes incomplete opcode (only one byte);
* WriteListFile tries to list bytes from -1 to 1 -> crash
*
* Revision 1.31  2012/11/03 17:39:36  pauloscustodio
* astyle, comments
*
* Revision 1.30  2012/05/26 18:51:10  pauloscustodio
* CH_0012 : wrappers on OS calls to raise fatal error
* CH_0013 : new errors interface to decouple calling code from errors.c
*
* Revision 1.29  2012/05/24 17:09:27  pauloscustodio
* Unify copyright header
*
* Revision 1.28  2012/05/18 00:28:45  pauloscustodio
* astyle
*
* Revision 1.27  2012/05/18 00:20:32  pauloscustodio
* ParseIndent(): remove hard coded IDs of IF, ELSE, ENDIF
* Z80ident[]: make always handling function the same name as assembler ident.
*
* Revision 1.26  2012/05/11 19:29:49  pauloscustodio
* Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, 
* indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
*         --mode=c
*         --lineend=linux
*         --indent=spaces=4
*         --style=ansi --add-brackets
*         --indent-switches --indent-classes
*         --indent-preprocessor --convert-tabs
*         --break-blocks
*         --pad-oper --pad-paren-in --pad-header --unpad-paren
*         --align-pointer=name
*
* Revision 1.25  2011/10/14 14:51:15  pauloscustodio
* - Silence warnings with casts.
*
* Revision 1.24  2011/08/19 15:53:58  pauloscustodio
* BUG_0010 : heap corruption when reaching MAXCODESIZE
* - test for overflow of MAXCODESIZE is done before each instruction at parseline(); if only one byte is available in codearea, and a 2 byte instruction is assembled, the heap is corrupted before the exception is raised.
* - Factored all the codearea-accessing code into a new module, checking for MAXCODESIZE on every write.
*
* Revision 1.23  2011/08/05 20:11:02  pauloscustodio
* CH_0004 : Exception mechanism to handle fatal errors
* Replaced all ERR_NO_MEMORY/return sequences by an exception, captured at main().
* Replaced all the memory allocation functions malloc, calloc, ... by corresponding
* macros xmalloc, xcalloc, ... that raise an exception if the memory cannot be allocated,
* removing all the test code after each memory allocation.
* Replaced all functions that allocated memory structures by the new xcalloc_struct().
*
* Revision 1.22  2011/07/18 00:48:25  pauloscustodio
* Initialize MS Visual Studio DEBUG build to show memory leaks on exit
*
* Revision 1.21  2011/07/14 01:32:08  pauloscustodio
*     - Unified "Integer out of range" and "Out of range" errors; they are the same error.
*     - Unified ReportIOError as ReportError(ERR_FILE_OPEN)
*     CH_0003 : Error messages should be more informative
*         - Added printf-args to error messages, added "Error:" prefix.
*     BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
*         - Raise ERR_UNBALANCED_PAREN instead
*
* Revision 1.20  2011/07/12 22:47:59  pauloscustodio
* - Moved all error variables and error reporting code to a separate module errors.c,
*   replaced all extern declarations of these variables by include errors.h,
*   created symbolic constants for error codes.
* - Added test scripts for error messages.
*
* Revision 1.19  2011/07/11 16:21:12  pauloscustodio
* Removed references to dead variable 'relocfile'.
*
* Revision 1.18  2011/07/11 16:19:37  pauloscustodio
* Moved all option variables and option handling code to a separate module options.c,
* replaced all extern declarations of these variables by include options.h.
* Created declarations in z80asm.h of objects defined in z80asm.c.
*
* Revision 1.17  2011/07/09 18:25:35  pauloscustodio
* Log keyword in checkin comment was expanded inside Log expansion... recursive
* Added Z80asm banner to all source files
*
* Revision 1.16  2011/07/09 17:36:09  pauloscustodio
* Copied cvs log into Log history
*
* Revision 1.15  2011/07/09 01:46:00  pauloscustodio
* Added Log keyword
*
* Revision 1.14  2011/07/09 01:32:27  pauloscustodio
* added casts to clean up warnings
*
* Revision 1.13  2011/02/27 11:58:46  stefano
* Rolled back z80asm changes (I must have messed up something!!)
* Slightly updated console output for Enterprise..
*
* Revision 1.12  2011/02/25 17:14:43  stefano
* EXOS directive fixed on z80asm
*
* Revision 1.11  2011/02/23 16:27:39  stefano
* *** empty log message ***
*
* Revision 1.10  2010/04/16 17:34:37  dom
* Make line number an int - 32768 lines isn't big enough...
*
* Revision 1.9  2009/08/14 22:23:12  dom
* clean up some compiler warnings
*
* Revision 1.8  2009/07/18 23:23:15  dom
* clean up the code a bit more (Formatting and a fewer magic numbers)
*
* Revision 1.7  2009/05/28 19:20:16  dom
* For the RCM SLL isn't a valid opcode, neither is anything using ixh,ixl,iyh
* or iyl.
*
* Revision 1.6  2007/06/24 14:46:24  dom
* remove the erroneous debug line
*
* Revision 1.5  2007/06/17 12:07:43  dom
* Commit the rabbit emulation code including rrd, rld
*
* Add a .vcproj for visual studio
*
* Revision 1.4  2007/02/28 11:23:24  stefano
* New platform !
* Rabbit Control Module 2000/3000.
*
* Revision 1.3  2002/01/18 16:22:11  dom
* for add,adc,sbc the a, for 8 bit operations is optional
*
* Revision 1.2  2001/01/23 10:00:09  dom
* Changes by x1cygnus:
*
* just added a harcoded macro Invoke, similar to callpkg except that the
* instruction 'Invoke' resolves to a call by default (ti83) and to a RST if
* the parameter -plus is specified on the command line.
*
* Changes by dom:
* Added in a rudimentary default directory set up (Defined at compile time)
* a bit kludgy and not very nice!
*
* Revision 1.1  2000/07/04 15:33:29  dom
* branches:  1.1.1;
* Initial revision
*
* Revision 1.1.1.1  2000/07/04 15:33:29  dom
* First import of z88dk into the sourceforge system <gulp>
*
*/

/* $History: Z80INSTR.C $ */
/*  */
/* *****************  Version 13  ***************** */
/* User: Gbs          Date: 3-10-99    Time: 12:59 */
/* Updated in $/Z80asm */
/* Change in CALL_PKG():  */
/* 0 is allowed as parameter. 16 bit address 8bi split using % 256 and  / */
/* 256. */
/*  */
/* *****************  Version 12  ***************** */
/* User: Gbs          Date: 30-09-99   Time: 22:39 */
/* Updated in $/Z80asm */
/* CALL_PKG hard coded macro implemented for Garry Lancaster's Package */
/* System. */
/*  */
/* *****************  Version 10  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 20:07 */
/* Updated in $/Z80asm */
/* "PC" program counter changed to long (from unsigned short). */
/*  */
/* *****************  Version 8  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 12:13 */
/* Updated in $/Z80asm */
/* Added Ascii Art "Z80asm" at top of source file. */
/*  */
/* *****************  Version 6  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 11:31 */
/* Updated in $/Z80asm */
/* "config.h" included before "symbol.h" */
/*  */
/* *****************  Version 4  ***************** */
/* User: Gbs          Date: 17-04-99   Time: 0:30 */
/* Updated in $/Z80asm */
/* New GNU programming style C format. Improved ANSI C coding style */
/* eliminating previous compiler warnings. New -o option. Asm sources file */
/* now parsed even though any line feed standards (CR,LF or CRLF) are */
/* used. */
/*  */
/* *****************  Version 2  ***************** */
/* User: Gbs          Date: 20-06-98   Time: 14:59 */
/* Updated in $/Z80asm */
/* SourceSafe version history comment block added. */
