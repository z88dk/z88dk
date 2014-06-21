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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/ldinstr.c,v 1.46 2014-06-21 02:15:43 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "codearea.h"
#include "errors.h"
#include "options.h"
#include "scan.h"
#include "symbol.h"
#include "z80asm.h"
#include <stdio.h>

/* external functions */
int CheckRegister16( void );
int CheckRegister8( void );
int IndirectRegisters( void );

/* local functions */
void LD_HL8bit_indrct( void );
void LD_16bit_reg( void );
void LD_index8bit_indrct( int reg );
void LD_address_indrct( char *exprptr );
void LD_r_8bit_indrct( int reg );





void
LD( void )
{
    char *exprptr;
    int sourcereg, destreg;

    if ( GetSym() == TK_LPAREN )
    {
        exprptr = ScanGetPos();    /* remember start of expression */

        switch ( destreg = IndirectRegisters() )
        {
        case 2:
            LD_HL8bit_indrct();   /* LD  (HL),  */
            break;

        case 5:
        case 6:
            LD_index8bit_indrct( destreg );       /* LD  (IX|IY+d),  */
            break;

        case 0:
            if ( tok == TK_COMMA )
            {
                /* LD  (BC),A  */
                GetSym();

                if ( CheckRegister8() == 7 )
                {
                    append_byte( 0x02 );
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

        case 1:
            if ( tok == TK_COMMA )
            {
                /* LD  (DE),A  */
                GetSym();

                if ( CheckRegister8() == 7 )
                {
                    append_byte( 0x12 );
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

        case 7:
            LD_address_indrct( exprptr ); /* LD  (nn),rr  ;  LD  (nn),A  */
            break;
        }
    }
    else
        switch ( destreg = CheckRegister8() )
        {
        case -1:
            LD_16bit_reg();         /* LD rr,(nn)   ;  LD  rr,nn   ;   LD  SP,HL|IX|IY   */
            break;

        case 6:
            error_illegal_ident(); /* LD F,? */
            break;

        case 8:
            if ( GetSym() == TK_COMMA )
            {
                GetSym();

                if ( CheckRegister8() == 7 )
                {
                    /* LD  I,A */
                    append_2bytes( 0xED, 0x47 );
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

        case 9:
            if ( GetSym() == TK_COMMA )
            {
                GetSym();

                if ( CheckRegister8() == 7 )
                {
                    /* LD  R,A */
                    append_2bytes( 0xED, 0x4F );
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
            if ( GetSym() == TK_COMMA )
            {
                if ( GetSym() == TK_LPAREN )
                {
                    LD_r_8bit_indrct( destreg );    /* LD  r,(HL)  ;   LD  r,(IX|IY+d)  */
                }
                else
                {
                    sourcereg = CheckRegister8();

                    if ( sourcereg == -1 )
                    {
                        /* LD  r,n */
                        if ( destreg & 8 )
                        {
                            if ( ( opts.cpu & CPU_RABBIT ) )

                            {
                                error_illegal_ident();
                                return;
                            }

                            append_byte( 0xDD );    /* LD IXl,n or LD IXh,n */
                        }
                        else if ( destreg & 16 )
                        {
                            if ( ( opts.cpu & CPU_RABBIT ) )
                            {
                                error_illegal_ident();
                                return;
                            }

                            append_byte( 0xFD );    /* LD  IYl,n or LD  IYh,n */
                        }

                        destreg &= 7;
                        append_byte( (Byte)( destreg * 0x08 + 0x06 ) );
                        ExprUnsigned8( 1 );
                        return;
                    }

                    if ( sourcereg == 6 )
                    {
                        /* LD x, F */
                        error_illegal_ident();
                        return;
                    }

                    if ( ( sourcereg == 8 ) && ( destreg == 7 ) )
                    {
                        /* LD A,I */
                        append_2bytes( 0xED, 0x57 );
                        return;
                    }

                    if ( ( sourcereg == 9 ) && ( destreg == 7 ) )
                    {
                        /* LD A,R */
                        append_2bytes( 0xED, 0x5F );
                        return;
                    }

                    if ( ( destreg & 8 ) || ( sourcereg & 8 ) )
                    {
                        /* IXl or IXh */
                        if ( ( opts.cpu & CPU_RABBIT ) )
                        {
                            error_illegal_ident();
                            return;
                        }

                        append_byte( 0xDD );
                    }
                    else if ( ( destreg & 16 ) || ( sourcereg & 16 ) )
                    {
                        /* IYl or IYh */
                        if ( ( opts.cpu & CPU_RABBIT ) )
                        {
                            error_illegal_ident();
                            return;
                        }

                        append_byte( 0xFD );
                    }

                    sourcereg &= 7;
                    destreg &= 7;

                    append_byte( (Byte)( 0x40 + destreg * 0x08 + sourcereg ) ); /* LD  r,r  */
                }
            }
            else
            {
                error_syntax();
            }

            break;
        }
}


/*
 * LD (HL),r LD   (HL),n
 */
void
LD_HL8bit_indrct( void )
{
    int sourcereg;

    if ( tok == TK_COMMA )
    {
        GetSym();

        switch ( sourcereg = CheckRegister8() )
        {
        case 6:
        case 8:
        case 9:
            error_illegal_ident();
            break;

        case -1:                /* LD  (HL),n  */
            append_byte( 0x36 );
            ExprUnsigned8( 1 );
            break;

        default:
            append_byte( (Byte)( 0x70 + sourcereg ) );       /* LD  (HL),r  */
            break;
        }
    }
    else
    {
        error_syntax();
    }
}


/*
 * LD (IX|IY+d),r LD   (IX|IY+d),n
 */
void
LD_index8bit_indrct( int destreg )
{
    int  sourcereg;
    UInt opcodeptr;

    if ( destreg == 5 )
    {
        append_byte( 0xDD );
    }
    else
    {
        append_byte( 0xFD );
    }

    opcodeptr = get_cur_module_size();		/* pointer to instruction opcode - BUG_0015 */
    append_byte( 0x36 );					/* preset 2. opcode to LD (IX|IY+d),n  */


    if ( !ExprSigned8( 2 ) )
    {
        return;    /* IX/IY offset expression */
    }

    if ( tok != TK_RPAREN )
    {
        error_syntax(); /* ')' wasn't found in line */
        return;
    }

    if ( GetSym() == TK_COMMA )
    {
        GetSym();

        switch ( sourcereg = CheckRegister8() )
        {
        case 6:
        case 8:
        case 9:
            error_illegal_ident();
            break;

        case -1:
            ExprUnsigned8( 3 );   /* Execute, store & patch 8bit expression for <n> */
            break;

        default:
            patch_byte( &opcodeptr, (Byte)( 112 + sourcereg ) );     /* LD  (IX|IY+d),r  */
            break;
        }                       /* end switch */
    }
    else
    {
        error_syntax();
    }
}


/*
 * LD  r,(HL) LD  r,(IX|IY+d) LD  A,(nn)
 */
void
LD_r_8bit_indrct( int destreg )
{
    int sourcereg;

    switch ( sourcereg = IndirectRegisters() )
    {
    case 2:
        append_byte( (Byte)( 0x40 + destreg * 0x08 + 0x06 ) ); /* LD   r,(HL)  */
        break;

    case 5:
    case 6:
        if ( sourcereg == 5 )
        {
            append_byte( 0xDD );
        }
        else
        {
            append_byte( 0xFD );
        }

        append_byte( (Byte)( 0x40 + destreg * 0x08 + 0x06 ) );
        ExprSigned8( 2 );
        break;

    case 7:                     /* LD  A,(nn)  */
        if ( destreg == 7 )
        {
            append_byte( 0x3A );
            ExprAddress( 1 );
        }
        else
        {
            error_illegal_ident();
        }

        break;

    case 0:
        if ( destreg == 7 )
        {
            /* LD   A,(BC)  */
            append_byte( 0x0A );
        }
        else
        {
            error_illegal_ident();
        }

        break;

    case 1:
        if ( destreg == 7 )
        {
            /* LD   A,(DE)  */
            append_byte( 0x1A );
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
}


void
LD_address_indrct( char *exprptr )
{
    int sourcereg;
    long bytepos;
    Expr *addrexpr;

    if ( ( addrexpr = expr_parse() ) == NULL )
    {
        return;    /* parse to right bracket */
    }
    else
    {
        OBJ_DELETE( addrexpr );    /* remove this expression again */
    }

    if ( tok != TK_RPAREN )
    {
        error_syntax(); /* Right bracket missing! */
        return;
    }

    if ( GetSym() == TK_COMMA )
    {
        GetSym();

        switch ( sourcereg = CheckRegister16() )
        {
        case 2:
            append_byte( 0x22 );  /* LD  (nn),HL  */
            bytepos = 1;
            break;

        case 0:
        case 1:         /* LD  (nn),dd   => dd: BC,DE,SP  */
        case 3:
            append_byte( 0xED );
            append_byte( (Byte)( 0x43 + sourcereg * 0x10 ) );
            bytepos = 2;
            break;

        case 5:         /* LD  (nn),IX    ;    LD  (nn),IY   */
        case 6:
            if ( sourcereg == 5 )
            {
                append_byte( 0xDD );
            }
            else
            {
                append_byte( 0xFD );
            }

            append_byte( 0x22 );
            bytepos = 2;
            break;

        case -1:
            if ( CheckRegister8() == 7 )
            {
                append_byte( 0x32 );      /* LD  (nn),A  */
                bytepos = 1;
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
    }
    else
    {
        error_syntax();
        return;
    }

    ScanSetPos( exprptr );			/* rewind fileptr to beginning of address expression */
    GetSym();
    ExprAddress( bytepos );			/* re-parse, evaluate, etc. */
}


void
LD_16bit_reg( void )
{
    int sourcereg, destreg;
    long bytepos;

    destreg = CheckRegister16();

    if ( destreg != -1 )
        if ( GetSym() == TK_COMMA )
            if ( GetSym() == TK_LPAREN )
            {
                switch ( destreg )
                {
                case 4:
                    error_illegal_ident();
                    return;

                case 2:
                    append_byte( 0x2A );      /* LD   HL,(nn)  */
                    bytepos = 1;
                    break;

                case 5:             /* LD  IX,(nn)    LD  IY,(nn)  */
                case 6:
                    if ( destreg == 5 )
                    {
                        append_byte( 0xDD );
                    }
                    else
                    {
                        append_byte( 0xFD );
                    }

                    append_byte( 0x2A );
                    bytepos = 2;
                    break;

                default:
                    append_byte( 0xED );
                    append_byte( (Byte)( 0x4B + destreg * 0x10 ) );
                    bytepos = 2;
                    break;
                }

                GetSym();
                ExprAddress( bytepos );
            }
            else
                switch ( sourcereg = CheckRegister16() )
                {
                case -1:              /* LD  rr,nn  */
                    switch ( destreg )
                    {
                    case 4:
                        error_illegal_ident();
                        return;

                    case 5:
                    case 6:
                        if ( destreg == 5 )
                        {
                            append_byte( 0xDD );
                        }
                        else
                        {
                            append_byte( 0xFD );
                        }

                        append_byte( 0x21 );
                        bytepos = 2;
                        break;

                    default:
                        append_byte( (Byte)( destreg * 0x10 + 0x01 ) );
                        bytepos = 1;
                        break;
                    }

                    ExprAddress( bytepos );
                    break;

                case 2:
                    if ( destreg == 3 )
                    {
                        /* LD  SP,HL  */
                        append_byte( 0xF9 );
                    }
                    else
                    {
                        error_illegal_ident();
                    }

                    break;

                case 5:               /* LD  SP,IX    LD  SP,IY  */
                case 6:
                    if ( destreg == 3 )
                    {
                        if ( sourcereg == 5 )
                        {
                            append_byte( 0xDD );
                        }
                        else
                        {
                            append_byte( 0xFD );
                        }

                        append_byte( 0xF9 );
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
        else
        {
            error_syntax();
        }
    else
    {
        error_syntax();
    }
}
