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
Copyright (C) Paulo Custodio, 2011-2012
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/asmdrctv.c,v 1.29 2012-05-24 17:09:27 pauloscustodio Exp $ */
/* $Log: asmdrctv.c,v $
/* Revision 1.29  2012-05-24 17:09:27  pauloscustodio
/* Unify copyright header
/*
/* Revision 1.28  2012/05/23 20:45:42  pauloscustodio
/* Replace ERR_FILE_OPEN by ERR_FOPEN_READ and ERR_FOPEN_WRITE.
/* Add tests.
/*
/* Revision 1.27  2012/05/18 00:20:32  pauloscustodio
/* ParseIndent(): remove hard coded IDs of IF, ELSE, ENDIF
/* Z80ident[]: make always handling function the same name as assembler ident.
/*
/* Revision 1.26  2012/05/17 17:42:14  pauloscustodio
/* DefineSymbol() and DefineDefSym() defined as void, a fatal error is
/* always raised on error.
/*
/* Revision 1.25  2012/05/11 19:29:49  pauloscustodio
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
/* Revision 1.24  2011/10/14 14:46:03  pauloscustodio
/* -  BUG_0013 : defm check for MAX_CODESIZE incorrect
/*  - Remove un-necessary tests for MAX_CODESIZE; all tests are concentrated in check_space() from codearea.c.
/*
/* Revision 1.23  2011/10/07 17:53:04  pauloscustodio
/* BUG_0015 : Relocation issue - dubious addresses come out of linking
/* (reported on Tue, Sep 27, 2011 at 8:09 PM by dom)
/* - Introduced in version 1.1.8, when the CODESIZE and the codeptr were merged into the same entity.
/* - This caused the problem because CODESIZE keeps track of the start offset of each module in the sequence they will appear in the object file, and codeptr is reset to the start of the codearea for each module.
/* The effect was that all address calculations at link phase were considering
/*  a start offset of zero for all modules.
/* - Moreover, when linking modules from a libary, the modules are pulled in to the code area as they are needed, and not in the sequence they will be in the object file. The start offset was being ignored and the modules were being loaded in the incorrect order
/* - Consequence of these two issues were all linked addresses wrong.
/*
/* Revision 1.22  2011/08/19 15:53:58  pauloscustodio
/* BUG_0010 : heap corruption when reaching MAXCODESIZE
/* - test for overflow of MAXCODESIZE is done before each instruction at parseline(); if only one byte is available in codearea, and a 2 byte instruction is assembled, the heap is corrupted before the exception is raised.
/* - Factored all the codearea-accessing code into a new module, checking for MAXCODESIZE on every write.
/*
/* Revision 1.21  2011/08/18 23:27:54  pauloscustodio
/* BUG_0009 : file read/write not tested for errors
/* - In case of disk full file write fails, but assembler does not detect the error
/*   and leaves back corruped object/binary files
/* - Created new exception FileIOException and ERR_FILE_IO error.
/* - Created new functions xfputc, xfgetc, ... to raise the exception on error.
/*
/* Revision 1.20  2011/08/14 19:46:46  pauloscustodio
/* - INCLUDE(), BINARY(): throw the new exception FatalErrorException for fatal error ERR_FILE_OPEN, no need to re-open the original source file after the error
/* - INCLUDE(): no need to check for fatal error and return; bypassed by exception mechanism
/* - source_file_open flag removed; z80asmfile is used for the same purpose
/*
/* Revision 1.19  2011/08/05 19:37:38  pauloscustodio
/* CH_0004 : Exception mechanism to handle fatal errors
/* Replaced all ERR_NO_MEMORY/return sequences by an exception, captured at main().
/* Replaced all functions that allocated memory structures by the new xcalloc_struct().
/* Replaced 'l' (lower case letter L) by 'len' - too easy to confuse with numeral '1'.
/*
/* Revision 1.18  2011/07/18 00:52:01  pauloscustodio
/* Initialize MS Visual Studio DEBUG build to show memory leaks on exit
/* BUG_0007 : memory leaks - Cleaned memory leaks in DEFS()
/*
/* Revision 1.17  2011/07/14 01:32:08  pauloscustodio
/*     - Unified "Integer out of range" and "Out of range" errors; they are the same error.
/*     - Unified ReportIOError as ReportError(ERR_FILE_OPEN)
/*     CH_0003 : Error messages should be more informative
/*         - Added printf-args to error messages, added "Error:" prefix.
/*     BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
/*         - Raise ERR_UNBALANCED_PAREN instead
/*
/* Revision 1.16  2011/07/12 22:47:59  pauloscustodio
/* - Moved all error variables and error reporting code to a separate module errors.c,
/*   replaced all extern declarations of these variables by include errors.h,
/*   created symbolic constants for error codes.
/* - Added test scripts for error messages.
/*
/* Revision 1.15  2011/07/11 15:56:46  pauloscustodio
/* Moved all option variables and option handling code to a separate module options.c,
/* replaced all extern declarations of these variables by include options.h.
/*
/* Revision 1.14  2011/07/09 18:25:35  pauloscustodio
/* Log keyword in checkin comment was expanded inside Log expansion... recursive
/* Added Z80asm banner to all source files
/*
/* Revision 1.13  2011/07/09 17:36:09  pauloscustodio
/* Copied cvs log into Log history
/*
/* Revision 1.12  2011/07/09 01:46:00  pauloscustodio
/* Added Log keyword
/*
/* Revision 1.11  2011/07/09 01:14:13  pauloscustodio
/* added casts to clean up warnings
/*
/* Revision 1.10  2010/04/16 17:34:37  dom
/* Make line number an int - 32768 lines isn't big enough...
/*
/* Revision 1.9  2009/08/14 22:23:12  dom
/* clean up some compiler warnings
/*
/* Revision 1.8  2009/06/22 21:26:28  dom
/* don't expand a zero length file
/*
/* Revision 1.7  2009/06/13 17:36:24  dom
/* Add -I and -L to specify search paths for libraries and includes
/*
/* Revision 1.6  2003/10/11 15:41:04  dom
/* changes from garry
/*
/* - support for defp -> defp addr,bank
/* - square brackets can be used in expressions
/* - comma can be used in defm
/*
/* Revision 1.5  2002/02/20 21:37:57  dom
/* merged in changes from rc1.4 branch to handle empty lines in list files
/*
/* Revision 1.4  2001/06/27 08:53:28  dom
/* branches:  1.4.2;
/* Added a second parameter to defs to indicate what the filler byte should be
/*
/* Revision 1.3  2001/02/28 17:59:22  dom
/* Added UNDEFINE for undefining symbols, bumped version to 1.0.18
/*
/* Revision 1.2  2001/01/23 10:00:08  dom
/* Changes by x1cygnus:
/*
/* just added a harcoded macro Invoke, similar to callpkg except that the
/* instruction 'Invoke' resolves to a call by default (ti83) and to a RST if
/* the parameter -plus is specified on the command line.
/*
/* Changes by dom:
/* Added in a rudimentary default directory set up (Defined at compile time)
/* a bit kludgy and not very nice!
/*
/* Revision 1.1  2000/07/04 15:33:30  dom
/* branches:  1.1.1;
/* Initial revision
/*
/* Revision 1.1.1.1  2000/07/04 15:33:30  dom
/* First import of z88dk into the sourceforge system <gulp>
/*
/* Revision 1.4.2.1  2002/02/20 21:35:19  dom
/* changes from dennis to handle blank lines in file list files
/*
/* */

/* $History: Asmdrctv.c $ */
/*  */
/* *****************  Version 13  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 20:04 */
/* Updated in $/Z80asm */
/* MAXCODESIZE checking implemented for DEFB, DEFW, DEFL & DEFM. */
/*  */
/* *****************  Version 11  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 12:12 */
/* Updated in $/Z80asm */
/* Added Ascii Art "Z80asm" at top of source file. */
/*  */
/* *****************  Version 9  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 11:27 */
/* Updated in $/Z80asm */
/* "config.h" included before "symbol.h" */
/*  */
/* *****************  Version 8  ***************** */
/* User: Gbs          Date: 30-05-99   Time: 0:57 */
/* Updated in $/Z80asm */
/* Redundant system include files removed. */
/* Binary() rewritten to replace low I/O open() with fopen(), fread(). */
/* Fetchfilename() now doesn't changed parsed filename due to UNIX OS. */
/*  */
/* *****************  Version 7  ***************** */
/* User: Gbs          Date: 2-05-99    Time: 18:01 */
/* Updated in $/Z80asm */
/* INCLUDE() now validates for recursive including of identical files. */
/*  */
/* *****************  Version 5  ***************** */
/* User: Gbs          Date: 17-04-99   Time: 0:30 */
/* Updated in $/Z80asm */
/* New GNU programming style C format. Improved ANSI C coding style */
/* eliminating previous compiler warnings. New -o option. Asm sources file */
/* now parsed even though any line feed standards (CR,LF or CRLF) are */
/* used. */
/*  */
/* *****************  Version 3  ***************** */
/* User: Gbs          Date: 4-09-98    Time: 0:08 */
/* Updated in $/Z80asm */
/* DEFVARS functionality extended with -1 argument. */
/*  */
/* *****************  Version 2  ***************** */
/* User: Gbs          Date: 20-06-98   Time: 15:21 */
/* Updated in $/Z80asm */
/* Version History Comment block syntax layout corrected. */

/*  */
/* *****************  Version 1  ***************** */
/* User: Gbs          Date: 20-06-98   Time: 14:52 */
/* Created in $/Z80asm */
/* Improvements on defm() and Fetchfilename(): */
/* fgetc() logic now handled better according to EOF events. */

#include "memalloc.h"   /* before any other include to enable memory leak detection */

#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>
#include "config.h"
#include "options.h"
#include "symbol.h"
#include "symbols.h"
#include "z80asm.h"
#include "errors.h"
#include "file.h"
#include "codearea.h"

/* external functions */
enum symbols GetSym( void );
int ExprSigned8( int listoffset );
int ExprUnsigned8( int listoffset );
int ExprAddress( int listoffset );
int ExprLong( int listoffset );
int DEFSP( void );
int GetChar( FILE *fptr );
long EvalPfixExpr( struct expr *pfixexpr );
long GetConstant( char *evalerr );
void Pass2info( struct expr *expression, char constrange, long lfileptr );
void RemovePfixlist( struct expr *pfixexpr );
void Z80pass1( void );
void Skipline( FILE *fptr );
struct expr *ParseNumExpr( void );
struct sourcefile *Newfile( struct sourcefile *curfile, char *fname );
struct sourcefile *Prevfile( void );
struct sourcefile *FindFile( struct sourcefile *srcfile, char *fname );
int cmpidstr( symbol *kptr, symbol *p );
void FreeSym( symbol *node );
symbol *FindSymbol( char *identifier, avltree *treeptr );


/* local functions */
void DeclModuleName( void );
void DEFINE( void );
void UNDEFINE( void );


/* global variables */
extern FILE *z80asmfile, *listfile;
extern char ident[], stringconst[];
extern unsigned short DEFVPC;
extern enum symbols sym;
extern enum flag writeline, EOL;
extern struct modules *modulehdr;
extern struct module *CURRENTMODULE;


int
DEFSP( void )
{
    if ( GetSym() == fullstop )
        if ( GetSym() == name )
            switch ( ident[0] )
            {
                case 'B':
                    return 1;

                case 'W':
                    return 2;

                case 'P':
                    return 3;

                case 'L':
                    return 4;

                default:
                    return -1;
            }
        else
        {
            ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX );
            return -1;
        }
    else
    {
        ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX );
        return -1;
    }
}



long
Parsevarsize( void )
{

    struct expr *postfixexpr;

    long offset = 0, varsize, size_multiplier;

    if ( strcmp( ident, "DS" ) != 0 )
    {
        ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT );
    }
    else
    {
        if ( ( varsize = DEFSP() ) == -1 )
        {
            ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_UNKNOWN_IDENT );
        }
        else
        {
            GetSym();

            if ( ( postfixexpr = ParseNumExpr() ) != NULL )
            {
                if ( postfixexpr->rangetype & NOTEVALUABLE )
                {
                    ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_NOT_DEFINED );
                    RemovePfixlist( postfixexpr );
                }
                else
                {
                    size_multiplier = EvalPfixExpr( postfixexpr );
                    RemovePfixlist( postfixexpr );

                    if ( size_multiplier > 0 && size_multiplier <= MAXCODESIZE )
                    {
                        offset = varsize * size_multiplier;
                    }
                    else
                    {
                        ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_INT_RANGE, size_multiplier );
                    }
                }
            }
        }
    }

    return offset;
}



long
Parsedefvarsize( long offset )
{
    long varoffset = 0;

    switch ( sym )
    {
        case name:
            if ( strcmp( ident, "DS" ) != 0 )
            {
                DefineSymbol( ident, offset, 0 );
                GetSym();
            }

            if ( sym == name )
            {
                varoffset = Parsevarsize();
            }

            break;

        default:
            ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX );
    }

    return varoffset;
}



void
DEFVARS( void )
{
    struct expr *postfixexpr;

    long offset;
    enum flag globaldefv;

    writeline = OFF;              /* DEFVARS definitions are not output'ed to listing file */
    GetSym();

    if ( ( postfixexpr = ParseNumExpr() ) != NULL )
    {
        /* expr. must not be stored in relocatable file */
        if ( postfixexpr->rangetype & NOTEVALUABLE )
        {
            ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_NOT_DEFINED );
            RemovePfixlist( postfixexpr );
            return;
        }
        else
        {
            offset = EvalPfixExpr( postfixexpr ); /* offset expression must not contain undefined symbols */
            RemovePfixlist( postfixexpr );
        }

        if ( ( offset != -1 ) && ( offset != 0 ) )
        {
            DEFVPC = ( unsigned short )offset;
            globaldefv = ON;
        }
        else
        {
            if ( offset == -1 )
            {
                globaldefv = ON;
                offset = DEFVPC;
            }
            else
            {
                /* offset = 0, use temporarily without smashing DEFVPC */
                globaldefv = OFF;
            }
        }
    }
    else
    {
        return;    /* syntax error raised in ParseNumExpr() - get next line from file... */
    }

    while ( !feof( z80asmfile ) && sym != lcurly )
    {
        Skipline( z80asmfile );

        EOL = OFF;
        ++CURRENTFILE->line;
        GetSym();
    }

    if ( sym == lcurly )
    {
        while ( !feof( z80asmfile ) && GetSym() != rcurly )
        {
            if ( EOL == ON )
            {
                ++CURRENTFILE->line;
                EOL = OFF;
            }
            else
            {
                offset += Parsedefvarsize( offset );
            }
        }

        if ( globaldefv == ON )
        {
            DEFVPC = ( unsigned short )offset;
        }
    }
}



void
DEFGROUP( void )
{
    struct expr *postfixexpr;
    long constant, enumconst = 0;

    writeline = OFF;              /* DEFGROUP definitions are not output'ed to listing file */

    while ( !feof( z80asmfile ) && GetSym() != lcurly )
    {
        Skipline( z80asmfile );
        EOL = OFF;
        ++CURRENTFILE->line;
    }

    if ( sym == lcurly )
    {
        while ( !feof( z80asmfile ) && sym != rcurly )
        {
            if ( EOL == ON )
            {
                ++CURRENTFILE->line;
                EOL = OFF;
            }
            else
            {
                do
                {
                    GetSym();

                    switch ( sym )
                    {
                        case rcurly:
                        case semicolon:
                        case newline:
                            break;

                        case name:
                            strcpy( stringconst, ident );     /* remember name */

                            if ( GetSym() == assign )
                            {
                                GetSym();

                                if ( ( postfixexpr = ParseNumExpr() ) != NULL )
                                {
                                    if ( postfixexpr->rangetype & NOTEVALUABLE )
                                    {
                                        ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_NOT_DEFINED );
                                    }
                                    else
                                    {
                                        constant = EvalPfixExpr( postfixexpr );
                                        enumconst = constant;
                                        DefineSymbol( stringconst, enumconst++, 0 );
                                    }

                                    RemovePfixlist( postfixexpr );
                                }

                                GetSym();     /* prepare for next identifier */
                            }
                            else
                            {
                                DefineSymbol( stringconst, enumconst++, 0 );
                            }

                            break;

                        default:
                            ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX );
                            break;
                    }
                }
                while ( sym == comma );   /* get enum definitions separated by comma in current line */

                Skipline( z80asmfile );   /* ignore rest of line */
            }
        }
    }
}


void
DEFS()
{
    struct expr *postfixexpr;
    struct expr *constexpr;

    long constant, val;

    GetSym();                     /* get numerical expression */

    if ( ( postfixexpr = ParseNumExpr() ) != NULL )
    {
        /* expr. must not be stored in relocatable file */
        if ( postfixexpr->rangetype & NOTEVALUABLE )
        {
            ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_NOT_DEFINED );
        }
        else
        {
            constant = EvalPfixExpr( postfixexpr );
            /* BUG_0007 : memory leaks - was not being released in case of error */
            RemovePfixlist( postfixexpr ); /* remove linked list, expression evaluated */

            if ( sym != comma )
            {
                val = 0;
            }
            else
            {
                GetSym();

                if ( ( constexpr = ParseNumExpr() ) != NULL )
                {
                    if ( constexpr->rangetype & NOTEVALUABLE )
                    {
                        ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_NOT_DEFINED );
                    }
                    else
                    {
                        val = EvalPfixExpr( constexpr );
                    }

                    RemovePfixlist( constexpr );
                }
            }

            if ( constant >= 0 )
            {
                inc_PC( constant );

                while ( constant-- )
                {
                    append_byte( ( unsigned char ) val );
                }
            }
            else
            {
                ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_INT_RANGE, constant );
                return;
            }
        }
    }
}

void
UNDEFINE( void )
{
    symbol *sym;

    do
    {
        if ( GetSym() == name )
        {
            sym = FindSymbol( ident, CURRENTMODULE->localroot );
        }

        if ( sym != NULL )
        {
            delete( &CURRENTMODULE->localroot, sym, ( int ( * )( void *, void * ) ) cmpidstr, ( void ( * )( void * ) ) FreeSym );
        }
        else
        {
            ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX );
            break;
        }
    }
    while ( GetSym() == comma );
}

void
DEFINE( void )
{
    do
    {
        if ( GetSym() == name )
        {
            DefineDefSym( ident, 1, 0, &CURRENTMODULE->localroot );
        }
        else
        {
            ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX );
            break;
        }
    }
    while ( GetSym() == comma );
}


void
DEFC( void )
{
    struct expr *postfixexpr;
    long constant;

    do
    {
        if ( GetSym() == name )
        {
            strcpy( stringconst, ident ); /* remember name */

            if ( GetSym() == assign )
            {
                GetSym();         /* get numerical expression */

                if ( ( postfixexpr = ParseNumExpr() ) != NULL )
                {
                    /* expr. must not be stored in
                       * relocatable file */
                    if ( postfixexpr->rangetype & NOTEVALUABLE )
                    {
                        ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_NOT_DEFINED );
                        break;
                    }
                    else
                    {
                        constant = EvalPfixExpr( postfixexpr );    /* DEFC expression must not
                                                                 * contain undefined symbols */
                        DefineSymbol( stringconst, constant, 0 );
                    }

                    RemovePfixlist( postfixexpr );
                }
                else
                {
                    break;    /* syntax error - get next line from file... */
                }
            }
            else
            {
                ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX );
                break;
            }
        }
        else
        {
            ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX );
            break;
        }
    }
    while ( sym == comma );       /* get all DEFC definition separated by comma */
}



void
ORG( void )
{

    struct expr *postfixexpr;
    long constant;

    GetSym();                     /* get numerical expression */

    if ( ( postfixexpr = ParseNumExpr() ) != NULL )
    {
        if ( postfixexpr->rangetype & NOTEVALUABLE )
        {
            ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_NOT_DEFINED );
        }
        else
        {
            constant = EvalPfixExpr( postfixexpr );       /* ORG expression must not contain undefined symbols */

            if ( constant >= 0 && constant <= 65535U )
            {
                CURRENTMODULE->origin = constant;
            }
            else
            {
                ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_INT_RANGE, constant );
            }
        }

        RemovePfixlist( postfixexpr );
    }
}


void
DEFB( void )
{
    long bytepos = 0;

    do
    {
        GetSym();

        if ( !ExprUnsigned8( bytepos ) )
        {
            break;    /* syntax error - get next line from file... */
        }

        inc_PC( 1 );                      /* DEFB allocated, update assembler PC */
        ++bytepos;

        if ( sym == newline )
        {
            break;
        }
        else if ( sym != comma )
        {
            ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX );
            break;
        }
    }
    while ( sym == comma );       /* get all DEFB definitions separated by comma */
}



void
DEFW( void )
{
    long bytepos = 0;

    do
    {
        GetSym();

        if ( !ExprAddress( bytepos ) )
        {
            break;    /* syntax error - get next line from file... */
        }

        inc_PC( 2 );                      /* DEFW allocated, update assembler PC */
        bytepos += 2;

        if ( sym == newline )
        {
            break;
        }
        else if ( sym != comma )
        {
            ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX );
            break;
        }
    }
    while ( sym == comma );       /* get all DEFB definitions separated by comma */
}



void
DEFP( void )
{
    long bytepos = 0;

    do
    {
        GetSym();

        if ( !ExprAddress( bytepos ) )
        {
            break;    /* syntax error - get next line from file... */
        }

        inc_PC( 2 );                      /* DEFW allocated, update assembler PC */
        bytepos += 2;

        /* Pointers must be specified as WORD,BYTE pairs separated by commas */
        if ( sym != comma )
        {
            ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX );
        }

        GetSym();

        if ( !ExprUnsigned8( bytepos ) )
        {
            break;    /* syntax error - get next line from file... */
        }

        inc_PC( 1 );                      /* DEFB allocated, update assembler PC */
        bytepos += 1;

        if ( sym == newline )
        {
            break;
        }
        else if ( sym != comma )
        {
            ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX );
            break;
        }
    }
    while ( sym == comma );       /* get all DEFB definitions separated by comma */
}



void
DEFL( void )
{
    long bytepos = 0;

    do
    {
        GetSym();

        if ( !ExprLong( bytepos ) )
        {
            break;    /* syntax error - get next line from file... */
        }

        inc_PC( 4 );                      /* DEFL allocated, update assembler PC */
        bytepos += 4;

        if ( sym == newline )
        {
            break;
        }
        else if ( sym != comma )
        {
            ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX );
            break;
        }
    }
    while ( sym == comma );       /* get all DEFB definitions separated by comma */
}




void
DEFM( void )
{
    long constant, bytepos = 0;

    do
    {
        if ( GetSym() == dquote )
        {
            while ( !feof( z80asmfile ) )
            {
                constant = GetChar( z80asmfile );

                if ( constant == EOF )
                {
                    sym = newline;
                    EOL = ON;
                    ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX );
                    return;
                }
                else
                {
                    if ( constant != '\"' )
                    {
                        append_byte( ( unsigned char ) constant );
                        ++bytepos;
                        inc_PC( 1 );
                    }
                    else
                    {
                        GetSym();

                        if ( sym != strconq && sym != comma && sym != newline && sym != semicolon )
                        {
                            ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX );
                            return;
                        }

                        break;    /* get out of loop */
                    }
                }
            }
        }
        else
        {
            if ( !ExprUnsigned8( bytepos ) )
            {
                break;    /* syntax error - get next line from file... */
            }

            if ( sym != strconq && sym != comma && sym != newline && sym != semicolon )
            {
                ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX ); /* expression separator not found */
                break;
            }

            ++bytepos;
            inc_PC( 1 );
        }
    }
    while ( sym != newline && sym != semicolon );
}




void
INCLUDE( void )
{
    char    *filename;

    if ( GetSym() == dquote )
    {
        /* fetch filename of include file */
        filename = Fetchfilename( z80asmfile );

        if ( FindFile( CURRENTFILE, filename ) != NULL )
        {
            ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_INCLUDE_RECURSION, filename );
            return;
        }

        CURRENTFILE->filepointer = ftell( z80asmfile );   /* get file position of current source file */
        fclose( z80asmfile );     /* close current source file */

        if ( ( z80asmfile = fopen( filename, "rb" ) ) == NULL )
        {
            /* Open include file */
            ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_FOPEN_READ, filename );
            throw( FatalErrorException, "INCLUDE failed open include file" );
        }
        else
        {
            CURRENTFILE = Newfile( CURRENTFILE, filename );       /* Allocate new file into file information list */

            if ( verbose )
            {
                puts( CURRENTFILE->fname );    /* display name of INCLUDE file */
            }

            Z80pass1();           /* parse include file */

            CURRENTFILE = Prevfile();     /* Now get back to current file... */

            fclose( z80asmfile );
            z80asmfile = NULL;

            if ( ( z80asmfile = fopen( CURRENTFILE->fname, "rb" ) ) == NULL )
            {
                /* re-open current source file */
                ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_FOPEN_READ, CURRENTFILE->fname );
                throw( FatalErrorException, "INCLUDE failed open original file" );
            }
            else
            {
                fseek( z80asmfile, CURRENTFILE->filepointer, 0 ); /* file position to beginning of */
            }
        }                       /* line following INCLUDE line */
    }
    else
    {
        ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX );
    }

    sym = newline;
    writeline = OFF;              /* don't write current source line to listing file (empty line of INCLUDE file) */
}


void
BINARY( void )
{
    char      *filename;
    FILE          *binfile;
    long          Codesize;

    if ( GetSym() == dquote )
    {
        filename = Fetchfilename( z80asmfile );

        if ( ( binfile = fopen( filename, "rb" ) ) == NULL )
        {
            ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_FOPEN_READ, filename );
            throw( FatalErrorException, "BINARY failed open file" );
        }

        fseek( binfile, 0L, SEEK_END ); /* file pointer to end of file */
        Codesize = ftell( binfile );
        fseek( binfile, 0L, SEEK_SET ); /* file pointer to start of file */

        fread_codearea( binfile, Codesize );  /* read binary code */
        inc_PC( Codesize );

        fclose( binfile );
    }
    else
    {
        ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX );
    }
}



char *
Fetchfilename( FILE *fptr )
{
    char  *ptr;
    int    len, c = 0;

    do
    {
        for ( len = 0; len < 255; len++ )
        {
            if ( !feof( fptr ) )
            {
                c = GetChar( fptr );

                if ( ( c == '\n' ) || ( c == EOF ) )
                {
                    break;
                }

                if ( c != '"' )
                {
                    ident[len] = ( char ) c;
                }
                else
                {
                    break;       /* fatal - end of file reached! */
                }
            }
            else
            {
                break;
            }
        }

        ident[len] = '\0';          /* null-terminate file name */
    }
    while ( strlen( ident ) == 0 && !feof( fptr ) );

    if ( c != '\n' )
    {
        Skipline( fptr );    /* prepare for next line */
    }

    ptr = ident;

    if ( *ptr == '#' )
    {
        ptr++;
    }

    return strlen( ptr ) ? SearchFile( ptr, 1 ) : "";
}



void
DeclModuleName( void )
{
    if ( CURRENTMODULE->mname == NULL )
    {
        if ( sym == name )
        {
            CURRENTMODULE->mname = xstrdup( ident );
        }
        else
        {
            ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT );
        }
    }
    else
    {
        ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_MODULE_REDEFINED );
    }
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


