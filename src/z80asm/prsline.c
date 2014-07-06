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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/prsline.c,v 1.63 2014-07-06 23:11:25 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "codearea.h"
#include "errors.h"
#include "listfile.h"
#include "options.h"
#include "scan.h"
#include "strutil.h"
#include "symbol.h"
#include "types.h"
#include "z80asm.h"
#include <assert.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* local functions */
int IndirectRegisters( void );
int CheckRegister16( void );
int CheckRegister8( void );
int CheckCondition( void );

struct
{
    char          *name;
    int            flags;
    int            cpu;
}
flags[] =
{
    { "Z",    FLAGS_Z,  CPU_ALL },
    { "NZ",   FLAGS_NZ, CPU_ALL },
    { "C",    FLAGS_C,  CPU_ALL },
    { "NC",   FLAGS_NC, CPU_ALL },
    { "PE",   FLAGS_PE, CPU_ALL },   /* Not for jr, emu for RCM */
    { "PO",   FLAGS_PO, CPU_ALL },   /* Not for jr, emu for RCM */
    { "P",    FLAGS_P,  CPU_ALL },   /* Not for jr, emu for RCM */
    { "M",    FLAGS_M,  CPU_ALL },   /* Not for jr, emu for RCM */
#if 0
    { "LZ",   FLAGS_PO, CPU_RABBIT },  /* RCM alias */
    { "LO",   FLAGS_PE, CPU_RABBIT },  /* RCM alias */
    { "GTU",  FLAGS_GTU, CPU_RCM4000 }, /* RCM4000 */
    { "GT",   FLAGS_GT,  CPU_RCM4000 },  /* RCM4000 */
    { "LT",   FLAGS_LT,  CPU_RCM4000 },  /* RCM4000 */
    { "V",    FLAGS_V,   CPU_RCM4000 },   /* RCM4000 */
#endif
};



int
CheckCondition( void )
{
    size_t  i;
    char   *text = tok_name;
    size_t  len = strlen( text );

    for ( i = 0; i < NUM_ELEMS( flags ); i++ )
    {
        if ( len != strlen( flags[i].name ) )
        {
            continue;
        }

        if ( stricompare( text, flags[i].name ) == 0 )
        {
            if ( ( opts.cpu & flags[i].cpu ) == 0 )
            {
                continue;
            }

            return flags[i].flags;
        }
    }

    return -1;
}


int
CheckRegister8( void )
{
    if ( tok == TK_NAME )
    {
        if ( *( tok_name + 1 ) == '\0' )
        {
            switch ( toupper(*tok_name) )
            {
            case 'A':
                return 7;

            case 'H':
                return 4;

            case 'B':
                return 0;

            case 'L':
                return 5;

            case 'C':
                return 1;

            case 'D':
                return 2;

            case 'E':
                return 3;

            case 'I':
            {
                if ( ( opts.cpu & CPU_RABBIT ) )
                {
                    error_illegal_ident();
                    return -1;
                }

                return 8;
            }

            case 'R':
            {
                if ( ( opts.cpu & CPU_RABBIT ) )
                {
                    error_illegal_ident();
                    return -1;
                }

                return 9;
            }

            case 'F':
                return 6;
            }
        }
        else
        {
            if ( stricompare( tok_name, "IXL" ) == 0 )
            {
                if ( opts.swap_ix_iy )
                {
                    return ( 16 + 5 );
                }
                else
                {
                    return ( 8 + 5 );
                }
            }

            else if ( stricompare( tok_name, "IXH" ) == 0 )
            {
                if ( opts.swap_ix_iy )
                {
                    return ( 16 + 4 );
                }
                else
                {
                    return ( 8 + 4 );
                }
            }

            else if ( stricompare( tok_name, "IYL" ) == 0 )
            {
                if ( opts.swap_ix_iy )
                {
                    return ( 8 + 5 );
                }
                else
                {
                    return ( 16 + 5 );
                }
            }

            else if ( stricompare( tok_name, "IYH" ) == 0 )
            {
                if ( opts.swap_ix_iy )
                {
                    return ( 8 + 4 );
                }
                else
                {
                    return ( 16 + 4 );
                }
            }

            else if ( stricompare( tok_name, "IIR" ) == 0 ) /** Was 'I' register */
            {
                if ( ( opts.cpu & CPU_RABBIT ) )
                {
                    return 8;
                }
            }
            else if ( stricompare( tok_name, "EIR" ) == 0 ) /** Was 'R' register */
            {
                if ( ( opts.cpu & CPU_RABBIT ) )
                {
                    return 9;
                }
            }

        }
    }

    return -1;
}


int
CheckRegister16( void )
{
    if ( tok == TK_NAME )
    {
        if ( stricompare( tok_name, "HL" ) == 0 )
        {
            return REG16_HL;
        }
        else if ( stricompare( tok_name, "BC" ) == 0 )
        {
            return REG16_BC;
        }
        else if ( stricompare( tok_name, "DE" ) == 0 )
        {
            return REG16_DE;
        }
        else if ( stricompare( tok_name, "SP" ) == 0 )
        {
            return REG16_SP;
        }
        else if ( stricompare( tok_name, "AF" ) == 0 )
        {
            return REG16_AF;
        }
        else if ( stricompare( tok_name, "AF'" ) == 0 )
        {
            return REG16_AF1;
        }
        else if ( stricompare( tok_name, "IX" ) == 0 )
        {
            return opts.swap_ix_iy ? REG16_IY : REG16_IX;
        }
        else if ( stricompare( tok_name, "IY" ) == 0 )
        {
            return opts.swap_ix_iy ? REG16_IX : REG16_IY;
        }
    }

    return -1;
}


/*
 * This function will parse the current line for an indirect addressing mode. The return code can be:
 *
 * 0 - 2   :   (BC); (DE); (HL) 5,6     :   (IX <+|- expr.> ); (IY <+|- expr.> ) 7       :   (nn), nn = 16bit address
 * expression
 *
 * The function also returns a pointer to the parsed expression, now converted to postfix.
 */
int
IndirectRegisters( void )
{
    int reg16;

    GetSym();
    reg16 = CheckRegister16();

    switch ( reg16 )
    {
    case REG16_BC:
    case REG16_DE:
    case REG16_HL:
        if ( GetSym() == TK_RPAREN )
        {
            /* (BC) | (DE) | (HL) | ? */
            GetSym();
            return ( reg16 );     /* indicate (BC), (DE), (HL) */
        }
        else
        {
            error_syntax();     /* Right bracket missing! */
            return -1;
        }

    case REG16_IX:
    case REG16_IY:
        GetSym();                 /* prepare expression evaluation */
        return ( reg16 );

    case -1:                    /* tok could be a '+', '-' or a symbol... */
        return 7;

    default:
        error_illegal_ident();
        return -1;
    }
}
