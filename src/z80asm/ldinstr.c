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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/ldinstr.c,v 1.36 2014-04-22 23:52:55 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "codearea.h"
#include "config.h"
#include "errors.h"
#include "options.h"
#include "scan.h"
#include "symbol.h"
#include "z80asm.h"
#include <stdio.h>

/* external functions */
int ExprUnsigned8( int listoffset );
int ExprSigned8( int listoffset );
int ExprAddress( int listoffset );
int CheckRegister16( void );
int CheckRegister8( void );
int IndirectRegisters( void );

/* local functions */
void LD_HL8bit_indrct( void );
void LD_16bit_reg( void );
void LD_index8bit_indrct( int reg );
void LD_address_indrct( char *exprptr );
void LD_r_8bit_indrct( int reg );


/* global variables */
extern struct module *CURRENTMODULE;



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
                        append_byte( ( byte_t )( destreg * 0x08 + 0x06 ) );
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

                    append_byte( ( byte_t )( 0x40 + destreg * 0x08 + sourcereg ) ); /* LD  r,r  */
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
            append_byte( ( byte_t )( 0x70 + sourcereg ) );       /* LD  (HL),r  */
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
    int sourcereg;
    uint_t opcodeptr;

    if ( destreg == 5 )
    {
        append_byte( 0xDD );
    }
    else
    {
        append_byte( 0xFD );
    }

    opcodeptr = get_codeindex();  /* pointer to instruction opcode - BUG_0015 */
    append_byte( 0x36 );          /* preset 2. opcode to LD (IX|IY+d),n  */


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
            patch_byte( &opcodeptr, ( byte_t )( 112 + sourcereg ) );     /* LD  (IX|IY+d),r  */
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
        append_byte( ( byte_t )( 0x40 + destreg * 0x08 + 0x06 ) ); /* LD   r,(HL)  */
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

        append_byte( ( byte_t )( 0x40 + destreg * 0x08 + 0x06 ) );
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
            append_byte( ( byte_t )( 0x43 + sourcereg * 0x10 ) );
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
                    append_byte( ( byte_t )( 0x4B + destreg * 0x10 ) );
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
                        append_byte( ( byte_t )( destreg * 0x10 + 0x01 ) );
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

/*
* $Log: ldinstr.c,v $
* Revision 1.36  2014-04-22 23:52:55  pauloscustodio
* As inc_PC() is no longer needed, append_opcode() no longer makes sense.
* Removed append_opcode() and created a new helper append_2bytes().
*
* Revision 1.35  2014/04/22 23:32:42  pauloscustodio
* Release 2.2.0 with major fixes:
*
* - Object file format changed to version 03, to include address of start
* of the opcode of each expression stored in the object file, to allow
* ASMPC to refer to the start of the opcode instead of the patch pointer.
* This solves long standing BUG_0011 and BUG_0048.
*
* - ASMPC no longer stored in the symbol table and evaluated as a separate
* token, to allow expressions including ASMPC to be relocated. This solves
* long standing and never detected BUG_0047.
*
* - Handling ASMPC during assembly simplified - no need to call inc_PC() on
* every assembled instruction, no need to store list of JRPC addresses as
* ASMPC is now stored in the expression.
*
* BUG_0047: Expressions including ASMPC not relocated - impacts call po|pe|p|m emulation in RCMX000
* ASMPC is computed on zero-base address of the code section and expressions
* including ASMPC are not relocated at link time.
* "call po, xx" is emulated in --RCMX000 as "jp pe, ASMPC+3; call xx".
* The expression ASMPC+3 is not marked as relocateable, and the resulting
* code only works when linked at address 0.
*
* BUG_0048: ASMPC used in JP/CALL argument does not refer to start of statement
* In "JP ASMPC", ASMPC is coded as instruction-address + 1 instead
* of instruction-address.
*
* BUG_0011 : ASMPC should refer to start of statememnt, not current element in DEFB/DEFW
* Bug only happens with forward references to relative addresses in expressions.
* See example from zx48.asm ROM image in t/BUG_0011.t test file.
* Need to change object file format to correct - need patchptr and address of instruction start.
*
* Revision 1.34  2014/04/18 17:46:18  pauloscustodio
* - Change struct expr to Expr class, use CLASS_LIST instead of linked list
*   manipulating.
* - Factor parsing and evaluating contants.
* - Factor symbol-not-defined error during expression evaluation.
* - Store module name in strpool instead of xstrdup/xfree.
*
* Revision 1.33  2014/04/06 23:29:26  pauloscustodio
* Removed lookup functions in token.c, no longer needed with the ragel based scanner.
* Moved the token definitions from token_def.h to scan_def.h.
*
* Revision 1.32  2014/03/16 19:19:49  pauloscustodio
* Integrate use of srcfile in scanner, removing global variable z80asmfile
* and attributes CURRENTMODULE->cfile->line and CURRENTMODULE->cfile->fname.
*
* Revision 1.31  2014/03/15 02:12:07  pauloscustodio
* Rename last token to tok*
* GetSym() declared in scan.h
*
* Revision 1.30  2014/03/11 00:15:13  pauloscustodio
* Scanner reads input line-by-line instead of character-by-character.
* Factor house-keeping at each new line read in the scanner getasmline().
* Add interface to allow back-tacking of the recursive descent parser by
* getting the current input buffer position and comming back to the same later.
* SetTemporaryLine() keeps a stack of previous input lines.
* Scanner handles single-quoted strings and returns a number.
* New error for single-quoted string with length != 1.
* Scanner handles double-quoted strings and returns the quoted string.
*
* Revision 1.29  2014/03/05 23:44:55  pauloscustodio
* Renamed 64-bit portability to BUG_0042
*
* Revision 1.28  2014/03/01 15:45:31  pauloscustodio
* CH_0021: New operators ==, !=, &&, ||, <<, >>, ?:
* Handle C-like operators, make exponentiation (**) right-associative.
* Simplify expression parser by handling composed tokens in lexer.
* Change token ids to TK_...
*
* Revision 1.27  2014/02/25 22:39:34  pauloscustodio
* ws
*
* Revision 1.26  2014/02/24 23:08:55  pauloscustodio
* Rename "enum symbols" to "tokid_t", define in token.h
*
* Revision 1.25  2014/02/19 23:59:26  pauloscustodio
* BUG_0042: 64-bit portability issues
* size_t changes to unsigned long in 64-bit. Usage of size_t * to
* retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
* breaks on a 64-bit architecture. Make the functions return the value instead
* of being passed the pointer to the return value, so that the compiler
* takes care of size convertions.
* Create uint_t and ulong_t, use uint_t instead of size_t.
*
* Revision 1.24  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.23  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.22  2013/12/15 13:18:33  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.21  2013/10/04 23:09:24  pauloscustodio
* Parse command line options via look-up tables:
* -R, --relocatable
* --RCMX000
*
* Revision 1.20  2013/09/08 00:43:59  pauloscustodio
* New error module with one error function per error, no need for the error
* constants. Allows compiler to type-check error message arguments.
* Included the errors module in the init() mechanism, no need to call
* error initialization from main(). Moved all error-testing scripts to
* one file errors.t.
*
* Revision 1.19  2013/01/24 23:03:03  pauloscustodio
* Replaced (unsigned char) by (byte_t)
* Replaced (unisigned int) by (uint_t)
* Replaced (short) by (int)
*
* Revision 1.18  2013/01/20 21:24:28  pauloscustodio
* Updated copyright year to 2013
*
* Revision 1.17  2012/11/03 17:39:36  pauloscustodio
* astyle, comments
*
* Revision 1.16  2012/05/26 18:51:10  pauloscustodio
* CH_0012 : wrappers on OS calls to raise fatal error
* CH_0013 : new errors interface to decouple calling code from errors.c
*
* Revision 1.15  2012/05/24 17:09:27  pauloscustodio
* Unify copyright header
*
* Revision 1.14  2012/05/11 19:29:49  pauloscustodio
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
* Revision 1.13  2011/10/14 14:51:15  pauloscustodio
* - Silence warnings with casts.
*
* Revision 1.12  2011/10/07 17:53:04  pauloscustodio
* BUG_0015 : Relocation issue - dubious addresses come out of linking
* (reported on Tue, Sep 27, 2011 at 8:09 PM by dom)
* - Introduced in version 1.1.8, when the CODESIZE and the codeptr were merged into the same entity.
* - This caused the problem because CODESIZE keeps track of the start offset of each module in the sequence they will appear in the object file, and codeptr is reset to the start of the codearea for each module.
* The effect was that all address calculations at link phase were considering
*  a start offset of zero for all modules.
* - Moreover, when linking modules from a libary, the modules are pulled in to the code area as they are needed, and not in the sequence they will be in the object file. The start offset was being ignored and the modules were being loaded in the incorrect order
* - Consequence of these two issues were all linked addresses wrong.
*
* Revision 1.11  2011/08/19 15:53:58  pauloscustodio
* BUG_0010 : heap corruption when reaching MAXCODESIZE
* - test for overflow of MAXCODESIZE is done before each instruction at parseline(); if only one byte is available in codearea, and a 2 byte instruction is assembled, the heap is corrupted before the exception is raised.
* - Factored all the codearea-accessing code into a new module, checking for MAXCODESIZE on every write.
*
* Revision 1.10  2011/07/18 00:48:25  pauloscustodio
* Initialize MS Visual Studio DEBUG build to show memory leaks on exit
*
* Revision 1.9  2011/07/12 22:47:59  pauloscustodio
* - Moved all error variables and error reporting code to a separate module errors.c,
*   replaced all extern declarations of these variables by include errors.h,
*   created symbolic constants for error codes.
* - Added test scripts for error messages.
*
* Revision 1.8  2011/07/11 16:21:12  pauloscustodio
* Removed references to dead variable 'relocfile'.
*
* Revision 1.7  2011/07/09 18:25:35  pauloscustodio
* Log keyword in checkin comment was expanded inside Log expansion... recursive
* Added Z80asm banner to all source files
*
* Revision 1.6  2011/07/09 17:36:09  pauloscustodio
* Copied cvs log into Log history
*
* Revision 1.5  2011/07/09 01:46:00  pauloscustodio
* Added Log keyword
*
* Revision 1.4  2010/04/16 17:34:37  dom
* Make line number an int - 32768 lines isn't big enough...
*
* Revision 1.3  2009/07/18 23:23:15  dom
* clean up the code a bit more (Formatting and a fewer magic numbers)
*
* Revision 1.2  2009/05/28 19:20:16  dom
* For the RCM SLL isn't a valid opcode, neither is anything using ixh,ixl,iyh
* or iyl.
*
* Revision 1.1  2000/07/04 15:33:30  dom
* branches:  1.1.1;
* Initial revision
*
* Revision 1.1.1.1  2000/07/04 15:33:30  dom
* First import of z88dk into the sourceforge system <gulp>
*
*/

/* $History: LDINSTR.C $ */
/*  */
/* *****************  Version 10  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 20:05 */
/* Updated in $/Z80asm */
/* "PC" program counter changed to long (from unsigned short). */
/*  */
/* *****************  Version 8  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 12:12 */
/* Updated in $/Z80asm */
/* Added Ascii Art "Z80asm" at top of source file. */
/*  */
/* *****************  Version 6  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 11:29 */
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
/* User: Gbs          Date: 20-06-98   Time: 15:10 */
/* Updated in $/Z80asm */
/* SourceSafe Version History Comment Block added. */
