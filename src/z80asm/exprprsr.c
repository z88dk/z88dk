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
Copyright (C) Paulo Custodio, 2011-2013
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/exprprsr.c,v 1.46 2013-09-22 21:34:48 pauloscustodio Exp $ */
/* $Log: exprprsr.c,v $
/* Revision 1.46  2013-09-22 21:34:48  pauloscustodio
/* Remove legacy xxx_err() interface
/*
/* Revision 1.45  2013/09/12 00:10:02  pauloscustodio
/* Create g_free0() macro that NULLs the pointer after free, required
/* by z80asm to find out if a pointer was already freed.
/*
/* Revision 1.44  2013/09/08 08:29:21  pauloscustodio
/* Replaced xmalloc et al with g_malloc0 et al.
/*
/* Revision 1.43  2013/09/08 00:43:59  pauloscustodio
/* New error module with one error function per error, no need for the error
/* constants. Allows compiler to type-check error message arguments.
/* Included the errors module in the init() mechanism, no need to call
/* error initialization from main(). Moved all error-testing scripts to
/* one file errors.t.
/*
/* Revision 1.42  2013/09/01 12:00:07  pauloscustodio
/* Cleanup compilation warnings
/*
/* Revision 1.41  2013/09/01 00:18:28  pauloscustodio
/* - Replaced e4c exception mechanism by a much simpler one based on a few
/*   macros. The former did not allow an exit(1) to be called within a
/*   try-catch block.
/*
/* Revision 1.40  2013/08/30 21:50:43  pauloscustodio
/* By suggestion of Philipp Klaus Krause: rename LEGACY to __LEGACY_Z80ASM_SYNTAX,
/* as an identifier reserved by the C standard for implementation-defined behaviour
/* starting with two underscores.
/*
/* Revision 1.39  2013/08/30 01:06:08  pauloscustodio
/* New C-like expressions, defined when __LEGACY_Z80ASM_SYNTAX is not defined. Keeps old
/* behaviour under -D__LEGACY_Z80ASM_SYNTAX (defined in legacy.h)
/*
/* BACKWARDS INCOMPATIBLE CHANGE, turned OFF by default (-D__LEGACY_Z80ASM_SYNTAX)
/* - Expressions now use more standard C-like operators
/* - Object and library files changed signature to
/*   "Z80RMF02", "Z80LMF02", to avoid usage of old
/*   object files with expressions inside in the old format
/*
/* Detail:
/* - String concatenation in DEFM: changed from '&' to ',';  '&' will be AND
/* - Power:                        changed from '^' to '**'; '^' will be XOR
/* - XOR:                          changed from ':' to '^';
/* - AND:                          changed from '~' to '&';  '~' will be NOT
/* - NOT:                          '~' added as binary not
/*
/* Revision 1.38  2013/06/14 22:14:36  pauloscustodio
/* find_local_symbol() and find_global_symbol() to encapsulate usage of get_global_tab()
/*
/* Revision 1.37  2013/06/10 23:11:33  pauloscustodio
/* CH_0023 : Remove notdecl_tab
/*
/* Revision 1.36  2013/06/08 23:37:32  pauloscustodio
/* Replace define_def_symbol() by one function for each symbol table type: define_static_def_sym(),
/*  define_global_def_sym(), define_local_def_sym(), encapsulating the symbol table used.
/* Define keywords for special symbols ASMPC, ASMSIZE, ASMTAIL
/*
/* Revision 1.35  2013/06/01 01:24:21  pauloscustodio
/* CH_0022 : Replace avltree by hash table for symbol table
/*
/* Revision 1.34  2013/05/23 22:22:23  pauloscustodio
/* Move symbol to sym.c, rename to Symbol
/*
/* Revision 1.33  2013/03/04 23:37:09  pauloscustodio
/* Removed pass1 that was used to skip creating page references of created
/* symbols in pass2. Modified add_symbol_ref() to ignore pages < 1,
/* modified list_get_page_nr() to return -1 after the whole source is
/* processed.
/*
/* Revision 1.32  2013/01/24 23:03:03  pauloscustodio
/* Replaced (unsigned char) by (byte_t)
/* Replaced (unisigned int) by (size_t)
/* Replaced (short) by (int)
/*
/* Revision 1.31  2013/01/20 13:18:10  pauloscustodio
/* BUG_0024 : (ix+128) should show warning message
/* Signed integer range was wrongly checked to -128..255 instead
/* of -128..127
/*
/* Revision 1.30  2013/01/14 00:29:37  pauloscustodio
/* CH_0015 : integer out of range error replaced by warning
/*
/* Revision 1.29  2012/11/03 17:39:35  pauloscustodio
/* astyle, comments
/*
/* Revision 1.28  2012/05/26 18:51:10  pauloscustodio
/* CH_0012 : wrappers on OS calls to raise fatal error
/* CH_0013 : new errors interface to decouple calling code from errors.c
/*
/* Revision 1.27  2012/05/24 17:09:27  pauloscustodio
/* Unify copyright header
/*
/* Revision 1.26  2012/05/24 16:20:52  pauloscustodio
/* ERR_EXPR_SYNTAX renamed ERR_SYNTAX_EXPR (consistency)
/*
/* Revision 1.25  2012/05/20 06:39:27  pauloscustodio
/* astyle
/*
/* Revision 1.24  2012/05/20 06:02:08  pauloscustodio
/* Garbage collector
/* Added automatic garbage collection on exit and simple fence mechanism
/* to detect buffer underflow and overflow, to memalloc functions.
/* No longer needed to call init_malloc().
/* No longer need to try/catch during creation of memory structures to
/* free partially created data - all not freed data is freed atexit().
/* Renamed xfree0() to xfree().
/*
/* Revision 1.23  2012/05/20 05:31:18  pauloscustodio
/* Solve signed/unsigned mismatch warnings in symboltype, libtype: changed to char.
/*
/* Revision 1.22  2012/05/17 17:42:14  pauloscustodio
/* define_symbol() defined as void, a fatal error is
/* always raised on error.
/*
/* Revision 1.21  2012/05/11 19:29:49  pauloscustodio
/* Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
/*         --mode=c
/*         --lineend=linux
/*         --indent=spaces=4
/*         --style=ansi --add-brackets
/*         --indent-switches --indent-classes
/*         --indent-preprocessor --convert-tabs
/*         --break-blocks
/*         --pad-oper --pad-paren-in --pad-header --unpad-paren
/*         --align-pointer=name
/*
/* Revision 1.20  2011/10/07 17:53:04  pauloscustodio
/* BUG_0015 : Relocation issue - dubious addresses come out of linking
/* (reported on Tue, Sep 27, 2011 at 8:09 PM by dom)
/* - Introduced in version 1.1.8, when the CODESIZE and the codeptr were merged into the same entity.
/* - This caused the problem because CODESIZE keeps track of the start offset of each module in the sequence they will appear in the object file, and codeptr is reset to the start of the codearea for each module.
/* The effect was that all address calculations at link phase were considering
/*  a start offset of zero for all modules.
/* - Moreover, when linking modules from a libary, the modules are pulled in to the code area as they are needed, and not in the sequence they will be in the object file. The start offset was being ignored and the modules were being loaded in the incorrect order
/* - Consequence of these two issues were all linked addresses wrong.
/*
/* Revision 1.19  2011/08/19 15:53:58  pauloscustodio
/* BUG_0010 : heap corruption when reaching MAXCODESIZE
/* - test for overflow of MAXCODESIZE is done before each instruction at parseline(); if only one byte is available in codearea, and a 2 byte instruction is assembled, the heap is corrupted before the exception is raised.
/* - Factored all the codearea-accessing code into a new module, checking for MAXCODESIZE on every write.
/*
/* Revision 1.18  2011/08/18 23:27:54  pauloscustodio
/* BUG_0009 : file read/write not tested for errors
/* - In case of disk full file write fails, but assembler does not detect the error
/*   and leaves back corruped object/binary files
/* - Created new exception FileIOException and ERR_FILE_IO error.
/* - Created new functions xfput_u8, xfget_u8, ... to raise the exception on error.
/*
/* Revision 1.17  2011/08/15 17:12:31  pauloscustodio
/* Upgrade to Exceptions4c 2.8.9 to solve memory leak.
/*
/* Revision 1.16  2011/08/05 19:46:16  pauloscustodio
/* CH_0004 : Exception mechanism to handle fatal errors
/* Replaced all ERR_NO_MEMORY/return sequences by an exception, captured at main().
/* Replaced all the memory allocation functions malloc, calloc, ... by corresponding
/* macros xmalloc, xcalloc, ... that raise an exception if the memory cannot be allocated,
/* removing all the test code after each memory allocation.
/* Replaced all functions that allocated memory structures by the new xcalloc_struct().
/* Replaced all free() by xfree0() macro which only frees if the pointer in non-null, and
/* sets the poiter to NULL afterwards, to avoid any used of the freed memory.
/* Created try/catch sequences to clean-up partially created memory structures and rethrow the
/* exception, to cleanup memory leaks.
/*
/* Revision 1.15  2011/07/18 00:48:25  pauloscustodio
/* Initialize MS Visual Studio DEBUG build to show memory leaks on exit
/*
/* Revision 1.14  2011/07/14 01:28:17  pauloscustodio
/*     BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
/*         - Raise ERR_UNBALANCED_PAREN instead
/*     CH_0003 : Error messages should be more informative
/*         - Added printf-args to error messages, added "Error:" prefix.
/*
/* Revision 1.13  2011/07/12 22:47:59  pauloscustodio
/* - Moved all error variables and error reporting code to a separate module errors.c,
/*   replaced all extern declarations of these variables by include errors.h,
/*   created symbolic constants for error codes.
/* - Added test scripts for error messages.
/*
/* Revision 1.12  2011/07/11 15:59:51  pauloscustodio
/* Moved all option variables and option handling code to a separate module options.c,
/* replaced all extern declarations of these variables by include options.h.
/*
/* Revision 1.11  2011/07/09 18:25:35  pauloscustodio
/* Log keyword in checkin comment was expanded inside Log expansion... recursive
/* Added Z80asm banner to all source files
/*
/* Revision 1.10  2011/07/09 17:36:09  pauloscustodio
/* Copied cvs log into Log history
/*
/* Revision 1.9  2011/07/09 01:46:00  pauloscustodio
/* Added Log keyword
/*
/* Revision 1.8  2011/07/09 01:19:18  pauloscustodio
/* added casts to clean up warnings
/* BUG_0004 : 8bit unsigned constants are not checked for out-of-range
/*      Added the check to ExprUnsigned8() and Z80pass2().
/* BUG_0005 : Offset of (ix+d) should be optional; '+' or '-' are necessary
/*      ExprSigned8(): Accept (ix) and (iy), use offset zero.
/*      Raise syntax error for (ix 4), was accepting as (ix+4).
/* CH_0002 : Unary plus and unary minus added to Factor()
/*      Accept unary minus and unary plus in factor to allow (ix+ -3) to be
/*      parsed as (ix-3).
/*
/* Revision 1.7  2010/09/19 00:06:20  dom
/* Tweaks for compiling code generated by sdcc - it generates XREF rather than
/* LIB so treat XREF as a LIB (this possibly should be the default)
/*
/* Do some _ mapping magic when in sdcc so standard z88dk libs can be used
/* (wrong _ convention chosen a long time ago...)
/*
/* Have -forcexlib flag which treats MODULE as XLIB.
/*
/* Revision 1.6  2010/04/16 17:34:37  dom
/* Make line number an int - 32768 lines isn't big enough...
/*
/* Revision 1.5  2009/07/18 23:23:15  dom
/* clean up the code a bit more (Formatting and a fewer magic numbers)
/*
/* Revision 1.4  2008/06/02 19:03:12  dom
/* Handle < and > operators.
/*
/* I have no idea where they got to!
/*
/* Revision 1.3  2007/06/17 12:07:43  dom
/* Commit the rabbit emulation code including rrd, rld
/*
/* Add a .vcproj for visual studio
/*
/* Revision 1.2  2003/10/11 15:41:04  dom
/* changes from garry
/*
/* - support for defp -> defp addr,bank
/* - square brackets can be used in expressions
/* - comma can be used in defm
/*
/* Revision 1.1  2000/07/04 15:33:30  dom
/* branches:  1.1.1;
/* Initial revision
/*
/* Revision 1.1.1.1  2000/07/04 15:33:30  dom
/* First import of z88dk into the sourceforge system <gulp>
/*
/* */

/* $History: EXPRPRSR.C $ */
/*  */
/* *****************  Version 15  ***************** */
/* User: Gbs          Date: 26-01-00   Time: 22:10 */
/* Updated in $/Z80asm */
/* Expression range validation removed from 8bit unsigned (redundant). */
/*  */
/* *****************  Version 13  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 20:05 */
/* Updated in $/Z80asm */
/* "PC" program counter changed to long (from unsigned short). */
/*  */
/* *****************  Version 11  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 12:12 */
/* Updated in $/Z80asm */
/* Added Ascii Art "Z80asm" at top of source file. */
/*  */
/* *****************  Version 9  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 11:29 */
/* Updated in $/Z80asm */
/* "config.h" included before "symbol.h" */
/*  */
/* *****************  Version 8  ***************** */
/* User: Gbs          Date: 2-05-99    Time: 18:04 */
/* Updated in $/Z80asm */
/* General improvements on EvalPfixExpr(), due to changes in declaration */
/* rules of XDEF, XREF and LIB. */
/*  */
/* *****************  Version 6  ***************** */
/* User: Gbs          Date: 17-04-99   Time: 0:30 */
/* Updated in $/Z80asm */
/* New GNU programming style C format. Improved ANSI C coding style */
/* eliminating previous compiler warnings. New -o option. Asm sources file */
/* now parsed even though any line feed standards (CR,LF or CRLF) are */
/* used. */
/*  */
/* *****************  Version 5  ***************** */
/* User: Gbs          Date: 7-03-99    Time: 14:24 */
/* Updated in $/Z80asm */
/* Minor changes to keep C compiler happy. */
/*  */
/* *****************  Version 4  ***************** */
/* User: Gbs          Date: 7-03-99    Time: 13:13 */
/* Updated in $/Z80asm */
/* Minor changes to keep C compiler happy. */
/*  */
/* *****************  Version 2  ***************** */
/* User: Gbs          Date: 20-06-98   Time: 15:06 */
/* Updated in $/Z80asm */
/* Improved handling of fgetc() character reading in relation to premature */
/* EOF handling (for character constants in expressions). */

#include "memalloc.h"   /* before any other include */

#include "codearea.h"
#include "config.h"
#include "errors.h"
#include "file.h"
#include "legacy.h"
#include "options.h"
#include "symbol.h"
#include "except.h"
#include "z80asm.h"
#include <assert.h>
#include <ctype.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* external functions */
enum symbols GetSym( void );
void Pass2info( struct expr *expression, char constrange, long lfileptr );
long GetConstant( char *evalerr );
int GetChar( FILE *fptr );

/* local functions */
void list_PfixExpr( struct expr *pfixlist );
void RemovePfixlist( struct expr *pfixexpr );
void PushItem( long oprconst, struct pfixstack **stackpointer );
void ClearEvalStack( struct pfixstack **stackptr );
void CalcExpression( enum symbols opr, struct pfixstack **stackptr );
void NewPfixSymbol( struct expr *pfixexpr, long oprconst, enum symbols oprtype, char *symident, char symboltype );
void StoreExpr( struct expr *pfixexpr, char range );
int ExprSigned8( int listoffset );
int ExprUnsigned8( int listoffset );
int ExprAddress( int listoffset );
int Condition( struct expr *pfixexpr );
int Expression( struct expr *pfixexpr );
int Term( struct expr *pfixexpr );
int Pterm( struct expr *pfixexpr );
int Factor( struct expr *pfixexpr );
long EvalPfixExpr( struct expr *pfixexpr );
long PopItem( struct pfixstack **stackpointer );
long Pw( long x, long y );
struct expr *ParseNumExpr( void );

/* global variables */
extern struct module *CURRENTMODULE;
extern enum symbols sym;
extern char ident[], separators[];
extern FILE *z80asmfile, *objfile;


int
Factor( struct expr *pfixexpr )
{
    long constant;
    Symbol *symptr;
    char eval_err;
    enum symbols open_paren;

    switch ( sym )
    {
        case name:
            symptr = get_used_symbol( ident );
            if ( symptr->type & SYMDEFINED )
            {
				/* copy appropriate type bits */
                pfixexpr->rangetype |= ( symptr->type & SYMTYPE );
                NewPfixSymbol( pfixexpr, symptr->value, number, NULL, symptr->type );
            }
            else
            {
                /* copy appropriate declaration bits */
                pfixexpr->rangetype |= ( symptr->type & SYMTYPE ) | NOTEVALUABLE;

				/* symbol only declared, store symbol name */
				NewPfixSymbol( pfixexpr, 0, number, ident, symptr->type );
            }

            strcpy( pfixexpr->infixptr, ident );    /* add identifier to infix expr */
            pfixexpr->infixptr += strlen( ident );  /* update pointer */

            GetSym();
            break;

        case hexconst:
        case binconst:
        case decmconst:
            strcpy( pfixexpr->infixptr, ident );    /* add constant to infix expr */
            pfixexpr->infixptr += strlen( ident );  /* update pointer */
            constant = GetConstant( &eval_err );

            if ( eval_err == 1 )
            {
                error_syntax_expr();
                return 0;           /* syntax error in expression */
            }
            else
            {
                NewPfixSymbol( pfixexpr, constant, number, NULL, 0 );
            }

            GetSym();
            break;

        case lparen:
        case lsquare:
            open_paren = sym;                           /* BUG_0006 : check correct balance */
            *pfixexpr->infixptr++ = separators[sym];    /* store '(' or '[' in infix expr */
            GetSym();

            if ( Condition( pfixexpr ) )
            {
                /* BUG_0006 : check correct balance */
                if ( open_paren == lparen  && sym == rparen ||
                        open_paren == lsquare && sym == rsquare )
                {
                    *pfixexpr->infixptr++ = separators[sym];        /* store ')' or ']' in infix expr */
                    GetSym();
                    break;
                }
                else
                {
                    error_unbanlanced_paren();
                    return 0;
                }
            }
            else
            {
                return 0;
            }

        case log_not:
            *pfixexpr->infixptr++ = '!';
            GetSym();

            if ( !Factor( pfixexpr ) )
            {
                return 0;
            }
            else
            {
                NewPfixSymbol( pfixexpr, 0, log_not, NULL, 0 );    /* logical NOT...  */
            }

            break;

        case bin_not:
            *pfixexpr->infixptr++ = '~';
            GetSym();

            if ( !Factor( pfixexpr ) )
            {
                return 0;
            }
            else
            {
                NewPfixSymbol( pfixexpr, 0, bin_not, NULL, 0 );    /* binary NOT...  */
            }

            break;

        case squote:
            *pfixexpr->infixptr++ = '\'';   /* store single quote in infix expr */

            if ( feof( z80asmfile ) )
            {
                error_syntax();
                return 0;
            }
            else
            {
                constant = GetChar( z80asmfile );

                if ( constant == EOF )
                {
                    error_syntax();
                    return 0;
                }
                else
                {
                    *pfixexpr->infixptr++ = (byte_t)constant;             /* store char in infix expr */

                    if ( GetSym() == squote )
                    {
                        *pfixexpr->infixptr++ = '\'';
                        NewPfixSymbol( pfixexpr, constant, number, NULL, 0 );
                    }
                    else
                    {
                        error_syntax_expr();
                        return 0;
                    }
                }
            }

            GetSym();
            break;

            /* CH_0002 accept and ignore unary plus */
        case plus:
            GetSym();
            return Factor( pfixexpr );

            /* CH_0002 accept and parse unary minus */
        case minus:
            GetSym();
            *pfixexpr->infixptr++ = '-';

            if ( Factor( pfixexpr ) )
            {
                NewPfixSymbol( pfixexpr, 0, negated, NULL, 0 );
            }
            else
            {
                return 0;
            }

            break;

        default:
            error_syntax_expr();  /* syntax error */
            return 0;
    }

    return 1;                   /* syntax OK */
}



int
Pterm( struct expr *pfixexpr )
{

    if ( !Factor( pfixexpr ) )
    {
        return ( 0 );
    }

    while ( sym == power )
    {
#ifdef __LEGACY_Z80ASM_SYNTAX
        *pfixexpr->infixptr++ = separators[power];        /* store '^' in infix expr */
#else
		/* store '**' in infix expr */
        *pfixexpr->infixptr++ = '*';
        *pfixexpr->infixptr++ = '*';
#endif

        GetSym();

        if ( Factor( pfixexpr ) )
        {
            NewPfixSymbol( pfixexpr, 0, power, NULL, 0 );
        }
        else
        {
            return 0;
        }
    }

    return ( 1 );
}



int
Term( struct expr *pfixexpr )
{
    enum symbols mulsym;

    if ( !Pterm( pfixexpr ) )
    {
        return ( 0 );
    }

    while ( ( sym == multiply ) || ( sym == divi ) || ( sym == mod ) )
    {
        *pfixexpr->infixptr++ = separators[sym];  /* store '/', '%', '*' in infix expr */
        mulsym = sym;
        GetSym();

        if ( Pterm( pfixexpr ) )
        {
            NewPfixSymbol( pfixexpr, 0, mulsym, NULL, 0 );
        }
        else
        {
            return 0;
        }
    }

    return ( 1 );
}



int
Expression( struct expr *pfixexpr )
{
    enum symbols addsym = nil;

    if ( ( sym == plus ) || ( sym == minus ) )
    {
        if ( sym == minus )
        {
            *pfixexpr->infixptr++ = '-';
        }

        addsym = sym;
        GetSym();

        if ( Term( pfixexpr ) )
        {
            if ( addsym == minus )
            {
                NewPfixSymbol( pfixexpr, 0, negated, NULL, 0 );
            }

            /* operand is signed, plus is redundant... */
        }
        else
        {
            return ( 0 );
        }
    }
    else if ( !Term( pfixexpr ) )
    {
        return ( 0 );
    }

    while ( ( sym == plus ) || ( sym == minus ) ||
            ( sym == bin_and ) || ( sym == bin_or ) || ( sym == bin_xor ) )
    {
        *pfixexpr->infixptr++ = separators[sym];
        addsym = sym;
        GetSym();

        if ( Term( pfixexpr ) )
        {
            NewPfixSymbol( pfixexpr, 0, addsym, NULL, 0 );
        }
        else
        {
            return ( 0 );
        }
    }

    return ( 1 );
}


int
Condition( struct expr *pfixexpr )
{
    enum symbols relsym = nil;

    if ( !Expression( pfixexpr ) )
    {
        return 0;
    }

    relsym = sym;

    switch ( sym )
    {
        case less:
            *pfixexpr->infixptr++ = '<';
            GetSym();

            switch ( sym )
            {
                case greater:
                    *pfixexpr->infixptr++ = '>';
                    relsym = notequal;  /* '<>' */
                    GetSym();
                    break;

                case assign:
                    *pfixexpr->infixptr++ = '=';
                    relsym = lessequal; /* '<=' */
                    GetSym();
                    break;

                default:
                    break;
            }

            break;

        case assign:
            *pfixexpr->infixptr++ = '=';
            GetSym();
            break;

        case greater:
            *pfixexpr->infixptr++ = '>';

            if ( GetSym() == assign )
            {
                *pfixexpr->infixptr++ = '=';
                relsym = greatequal;
                GetSym();
            }

            break;

        default:
            return 1;                       /* implicit (left side only) expression */
    }

    if ( !Expression( pfixexpr ) )
    {
        return 0;
    }
    else
    {
        NewPfixSymbol( pfixexpr, 0, relsym, NULL, 0 );    /* condition... */
    }

    return ( 1 );
}




struct expr *
ParseNumExpr( void )
{
    struct expr *pfixhdr;
    enum symbols constant_expression = nil;

    pfixhdr = g_new0( struct expr, 1 );

    pfixhdr->firstnode = NULL;
    pfixhdr->currentnode = NULL;
    pfixhdr->rangetype = 0;
    pfixhdr->stored = OFF;
    pfixhdr->codepos = get_codeindex(); /* BUG_0015 */
    pfixhdr->infixexpr = NULL;
    pfixhdr->infixptr = NULL;

    pfixhdr->infixexpr = g_new0( char, 128 );     /* TODO: make size a constant */

    pfixhdr->infixptr = pfixhdr->infixexpr;             /* initialise pointer to start of buffer */

    if ( sym == constexpr )
    {
        GetSym();               /* leading '#' : ignore relocatable address expression */
        constant_expression = constexpr;        /* convert to constant expression */
        *pfixhdr->infixptr++ = '#';
    }

    if ( Condition( pfixhdr ) )
    {
        /* parse expression... */
        if ( constant_expression == constexpr )
        {
            NewPfixSymbol( pfixhdr, 0, constexpr, NULL, 0 );    /* convert to constant expression */
        }

        *pfixhdr->infixptr = '\0';                      /* terminate infix expression */
    }
    else
    {
        RemovePfixlist( pfixhdr );
        pfixhdr = NULL;         /* syntax error in expression or no room */
    }                           /* for postfix expression */

    return pfixhdr;
}



void
StoreExpr( struct expr *pfixexpr, char range )
{
    byte_t b;

    xfput_u8( range, objfile );     /* range of expression */
    xfput_u16( pfixexpr->codepos, objfile );     /* patchptr */
    b = strlen( pfixexpr->infixexpr );
    xfput_u8( b, objfile );         /* length prefixed string */
    xfput_char( pfixexpr->infixexpr, ( size_t ) b, objfile );
    xfput_u8( 0, objfile );         /* nul-terminate expression */

    pfixexpr->stored = ON;
}



long
EvalPfixExpr( struct expr *pfixlist )
{
    struct pfixstack *stackptr = NULL;
    struct postfixlist *pfixexpr;
    Symbol *symptr;
    long ret = 0;

    TRY
    {
        pfixlist->rangetype &= EVALUATED; /* prefix expression as evaluated */
        pfixexpr = pfixlist->firstnode;   /* initiate to first node */

        do
        {
            switch ( pfixexpr->operatortype )
            {
                case number:
                    if ( pfixexpr->id == NULL ) /* Is operand an identifier? */
                    {
                        PushItem( pfixexpr->operandconst, &stackptr );
                    }
                    else
                    {
                        /* symbol was not defined and not declared */
                        if ( (pfixexpr->type & ~ SYMTOUCHED) != SYM_NOTDEFINED )
                        {
                            /* if all bits are set to zero */
                            if ( pfixexpr->type & SYMLOCAL )
                            {
                                symptr = find_local_symbol( pfixexpr->id );

								/* copy appropriate type bits */
                                pfixlist->rangetype |= ( symptr->type & SYMTYPE );

                                PushItem( symptr->value, &stackptr );
                            }
                            else
                            {
                                symptr = find_global_symbol( pfixexpr->id );

                                if ( symptr != NULL )
                                {
									/* copy appropriate type bits */
                                    pfixlist->rangetype |= ( symptr->type & SYMTYPE );

                                    if ( symptr->type & SYMDEFINED )
                                    {
                                        PushItem( symptr->value, &stackptr );
                                    }
                                    else
                                    {
                                        pfixlist->rangetype |= NOTEVALUABLE;
                                        PushItem( 0, &stackptr );
                                    }
                                }
                                else
                                {
                                    pfixlist->rangetype |= NOTEVALUABLE;
                                    PushItem( 0, &stackptr );
                                }
                            }
                        }
                        else
						{
                            /* try to find symbol now as either declared local or global */
                            symptr = get_used_symbol( pfixexpr->id );       

							/* copy appropriate type bits */
                            pfixlist->rangetype |= ( symptr->type & SYMTYPE );    

                            if ( symptr->type & SYMDEFINED )
                            {
                                PushItem( symptr->value, &stackptr );
                            }
                            else
                            {
                                pfixlist->rangetype |= NOTEVALUABLE;
                                PushItem( 0, &stackptr );
                            }
                        }
                    }

                    break;

                case negated:
                    stackptr->stackconstant = -stackptr->stackconstant;
                    break;

                case log_not:
                    stackptr->stackconstant = !( stackptr->stackconstant );
                    break;

                case bin_not:
                    stackptr->stackconstant = ~( stackptr->stackconstant );
                    break;

                case constexpr:
                    pfixlist->rangetype &= CLEAR_EXPRADDR;    /* convert to constant expression */
                    break;

                default:
                    CalcExpression( pfixexpr->operatortype, &stackptr );       /* plus minus, multiply, div,
                                                                     * mod */
                    break;
            }

            pfixexpr = pfixexpr->nextoperand;             /* get next operand in postfix expression */
        }
        while ( pfixexpr != NULL );

        if ( stackptr != NULL )
        {
            ret = PopItem( &stackptr );
        }
        else
        {
            ret = 0;    /* Unbalanced stack - probably during low memory... */
        }
    }
	FINALLY
    {
        ClearEvalStack( &stackptr );      /* in case stack is not balanced */
    }
	ETRY;

    return ret;
}



long
Pw( long x, long y )
{
    long i;

    for ( i = 1; y > 0; --y )
    {
        i *= x;
    }

    return i;
}



void
CalcExpression( enum symbols opr, struct pfixstack **stackptr )
{
    long leftoperand, rightoperand;

    rightoperand = PopItem( stackptr );   /* first get right operator */
    leftoperand = PopItem( stackptr );    /* then get left operator... */

    switch ( opr )
    {
        case bin_and:
            PushItem( ( leftoperand & rightoperand ), stackptr );
            break;

        case bin_or:
            PushItem( ( leftoperand | rightoperand ), stackptr );
            break;

        case bin_xor:
            PushItem( ( leftoperand ^ rightoperand ), stackptr );
            break;

        case plus:
            PushItem( ( leftoperand + rightoperand ), stackptr );
            break;

        case minus:
            PushItem( ( leftoperand - rightoperand ), stackptr );
            break;

        case multiply:
            PushItem( ( leftoperand * rightoperand ), stackptr );
            break;

        case divi:
            PushItem( ( leftoperand / rightoperand ), stackptr );
            break;

        case mod:
            PushItem( ( leftoperand % rightoperand ), stackptr );
            break;

        case power:
            PushItem( Pw( leftoperand, rightoperand ), stackptr );
            break;

        case assign:
            PushItem( ( leftoperand == rightoperand ), stackptr );
            break;

        case less:
            PushItem( ( leftoperand < rightoperand ), stackptr );
            break;

        case greater:
            PushItem( ( leftoperand > rightoperand ), stackptr );
            break;

        case lessequal:
            PushItem( ( leftoperand <= rightoperand ), stackptr );
            break;

        case greatequal:
            PushItem( ( leftoperand >= rightoperand ), stackptr );
            break;

        case notequal:
            PushItem( ( leftoperand != rightoperand ), stackptr );
            break;

        default:
            PushItem( 0, stackptr );
            break;
    }
}



void
RemovePfixlist( struct expr *pfixexpr )
{
    struct postfixlist *node, *tmpnode;

    if ( pfixexpr == NULL )
    {
        return;
    }

    node = pfixexpr->firstnode;

    while ( node != NULL )
    {
        tmpnode = node->nextoperand;

        if ( node->id != NULL )
        {
            g_free0( node->id );    /* Remove symbol id, if defined */
        }

        g_free0( node );
        node = tmpnode;
    }

    if ( pfixexpr->infixexpr != NULL )
    {
        g_free0( pfixexpr->infixexpr );    /* release infix expr. string */
    }

    g_free0( pfixexpr );           /* release header of postfix expression */
}




void
NewPfixSymbol( struct expr *pfixexpr,
               long oprconst,
               enum symbols oprtype,
               char *symident,
               char symboltype )
{
    struct postfixlist *newnode;

    newnode = g_new0( struct postfixlist, 1 );

    newnode->operandconst = oprconst;
    newnode->operatortype = oprtype;
    newnode->nextoperand = NULL;
    newnode->type = symboltype;

    if ( symident != NULL )
    {
        newnode->id = g_strdup( symident );    /* Allocate symbol */
    }
    else
    {
        newnode->id = NULL;
    }

    if ( pfixexpr->firstnode == NULL )
    {
        pfixexpr->firstnode = newnode;
        pfixexpr->currentnode = newnode;
    }
    else
    {
        pfixexpr->currentnode->nextoperand = newnode;
        pfixexpr->currentnode = newnode;
    }
}



void
PushItem( long oprconst, struct pfixstack **stackpointer )
{
    struct pfixstack *newitem;

    newitem = g_new0( struct pfixstack, 1 );
    newitem->stackconstant = oprconst;
    newitem->prevstackitem = *stackpointer;     /* link new node to current node */
    *stackpointer = newitem;                    /* update stackpointer to new item */
}



long
PopItem( struct pfixstack **stackpointer )
{
    struct pfixstack *stackitem;
    long constant;

    assert( *stackpointer );
    constant = ( *stackpointer )->stackconstant;
    stackitem = *stackpointer;
    *stackpointer = ( *stackpointer )->prevstackitem;   /* move stackpointer to previous item */
    g_free0( stackitem );                                /* return old item memory to OS */
    return ( constant );
}



void
ClearEvalStack( struct pfixstack **stackptr )
{
    while ( *stackptr != NULL )
    {
        PopItem( stackptr );    /* clear evaluation stack */
    }
}




int
ExprLong( int listoffset )
{

    struct expr *pfixexpr;
    long constant;
    int flag = 1;
    size_t exprptr = get_codeindex();     /* address of expression - BUG_0015 */

    if ( ( pfixexpr = ParseNumExpr() ) != NULL )
    {
        /* parse numerical expression */
        if ( ( pfixexpr->rangetype & EXPREXTERN ) || ( pfixexpr->rangetype & EXPRADDR ) )
            /* expression contains external reference or address label, must be recalculated during linking */
        {
            StoreExpr( pfixexpr, 'L' );
        }

        if ( pfixexpr->rangetype & EXPREXTERN )
        {
            RemovePfixlist( pfixexpr );
        }
        else
        {
            if ( ( pfixexpr->rangetype & EXPRADDR ) && ( listing == OFF ) )     /* expression contains address
                                                                           * label */
            {
                RemovePfixlist( pfixexpr );    /* no listing - evaluate during linking... */
            }
            else
            {
                if ( pfixexpr->rangetype & NOTEVALUABLE )
                {
                    Pass2info( pfixexpr, RANGE_32SIGN, listoffset );
                }
                else
                {
                    constant = EvalPfixExpr( pfixexpr );
                    RemovePfixlist( pfixexpr );

                    if ( constant < LONG_MIN || constant > LONG_MAX )
						warn_int_range( constant );

                    append_long( constant );
                }
            }
        }
    }
    else
    {
        flag = 0;
    }

    if ( get_codeindex() == exprptr )     /* BUG_0015 */
    {
        append_long( 0 );    /* reserve space if not yet reserved */
    }

    return flag;
}



int
ExprAddress( int listoffset )
{
    struct expr *pfixexpr;
    long constant;
    int flag = 1;
    size_t exprptr = get_codeindex();     /* address of expression - BUG_0015 */

    if ( ( pfixexpr = ParseNumExpr() ) != NULL )
    {
        /* parse numerical expression */
        if ( ( pfixexpr->rangetype & EXPREXTERN ) || ( pfixexpr->rangetype & EXPRADDR ) )
            /* expression contains external reference or address label, must be recalculated during linking */
        {
            StoreExpr( pfixexpr, 'C' );
        }

        if ( pfixexpr->rangetype & EXPREXTERN )
        {
            RemovePfixlist( pfixexpr );
        }
        else
        {
            if ( ( pfixexpr->rangetype & EXPRADDR ) && ( listing == OFF ) )     /* expression contains address
                                                                           * label */
            {
                RemovePfixlist( pfixexpr );    /* no listing - evaluate during linking... */
            }
            else
            {
                if ( pfixexpr->rangetype & NOTEVALUABLE )
                {
                    Pass2info( pfixexpr, RANGE_16CONST, listoffset );
                }
                else
                {
                    constant = EvalPfixExpr( pfixexpr );
                    RemovePfixlist( pfixexpr );

                    if ( constant < -32768 || constant > 65535 )
                        warn_int_range( constant );

					append_word( constant );
                }
            }
        }
    }
    else
    {
        flag = 0;
    }

    if ( get_codeindex() == exprptr )     /* BUG_0015 */
    {
        append_word( 0 );    /* reserve space if not yet reserved */
    }

    return flag;
}


int
ExprUnsigned8( int listoffset )
{
    struct expr *pfixexpr;
    long constant;
    int flag = 1;
    size_t exprptr = get_codeindex();     /* address of expression - BUG_0015 */

    if ( ( pfixexpr = ParseNumExpr() ) != NULL )
    {
        /* parse numerical expression */
        if ( ( pfixexpr->rangetype & EXPREXTERN ) || ( pfixexpr->rangetype & EXPRADDR ) )
            /* expression contains external reference or address label, must be recalculated during linking */
        {
            StoreExpr( pfixexpr, 'U' );
        }

        if ( pfixexpr->rangetype & EXPREXTERN )
        {
            RemovePfixlist( pfixexpr );
        }
        else
        {
            if ( ( pfixexpr->rangetype & EXPRADDR ) && ( listing == OFF ) )     /* expression contains address
                                                                           * label */
            {
                RemovePfixlist( pfixexpr );    /* no listing - evaluate during linking... */
            }
            else
            {
                if ( pfixexpr->rangetype & NOTEVALUABLE )
                {
                    Pass2info( pfixexpr, RANGE_8UNSIGN, listoffset );
                }
                else
                {
                    constant = EvalPfixExpr( pfixexpr );
                    RemovePfixlist( pfixexpr );

                    if ( constant < -128 || constant > 255 )
                        warn_int_range( constant );

					append_byte( (byte_t) constant );
                }
            }
        }
    }
    else
    {
        flag = 0;
    }

    if ( get_codeindex() == exprptr )     /* BUG_0015 */
    {
        append_byte( 0 );    /* reserve space if not yet reserved */
    }

    return flag;
}



int
ExprSigned8( int listoffset )
{
    struct expr *pfixexpr;
    long constant;
    int flag = 1;
    size_t exprptr = get_codeindex();     /* address of expression - BUG_0015 */

    /* BUG_0005 : Offset of (ix+d) should be optional; '+' or '-' are necessary */
    switch ( sym )
    {
        case rparen:
            append_byte( 0 );   /* offset zero */
            return 1;           /* OK, zero already stored */

        case plus:
        case minus:             /* + or - expected */
            break;              /* continue into parsing expression */

        default:                /* Syntax error, e.g. (ix 4) */
            error_syntax();
            return 0;           /* FAIL */
    }

    if ( ( pfixexpr = ParseNumExpr() ) != NULL )
    {
        /* parse numerical expression */
        if ( ( pfixexpr->rangetype & EXPREXTERN ) || ( pfixexpr->rangetype & EXPRADDR ) )
            /* expression contains external reference or address label, must be recalculated during linking */
        {
            StoreExpr( pfixexpr, 'S' );
        }

        if ( pfixexpr->rangetype & EXPREXTERN )
        {
            RemovePfixlist( pfixexpr );
        }
        else
        {
            if ( ( pfixexpr->rangetype & EXPRADDR ) && ( listing == OFF ) ) /* expression contains address label */
            {
                RemovePfixlist( pfixexpr );    /* no listing - evaluate during linking... */
            }
            else
            {
                if ( pfixexpr->rangetype & NOTEVALUABLE )
                {
                    Pass2info( pfixexpr, RANGE_8SIGN, listoffset );
                }
                else
                {
                    constant = EvalPfixExpr( pfixexpr );
                    RemovePfixlist( pfixexpr );

                    if ( constant < -128 || constant > 127 )
						warn_int_range( constant );

					append_byte( (byte_t) constant );
                }
            }
        }
    }
    else
    {
        flag = 0;
    }

    if ( get_codeindex() == exprptr )     /* BUG_0015 */
    {
        append_byte( 0 );    /* reserve space if not yet reserved */
    }

    return flag;
}


/*
 * Local Variables:
 *  indent-tabs-mode:nil
 *  require-final-newline:t
 *  c-basic-offset: 2
 *  eval: (c-set-offset 'case-label 0)
 *  eval: (c-set-offset 'substatement-open 2)
 *  eval: (c-set-offset 'access-label 0)
 *  eval: (c-set-offset 'class-open 2)
 *  eval: (c-set-offset 'class-close 2)
 * End:
 */

