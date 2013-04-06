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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/z80pass.c,v 1.46 2013-04-06 13:15:04 pauloscustodio Exp $
$Log: z80pass.c,v $
Revision 1.46  2013-04-06 13:15:04  pauloscustodio
Move default asm and obj extension handling to file.c.
srcfilename and objfilename are now pointers to static variables in file.c

Revision 1.45  2013/03/31 18:33:55  pauloscustodio
Comments

Revision 1.44  2013/03/04 23:23:37  pauloscustodio
Removed writeline, that was used to cancel listing of multi-line
constructs, as only the first line was shown on the list file. Fixed
the problem in DEFVARS and DEFGROUP. Side-effect: LSTOFF line is listed.

Revision 1.43  2013/02/27 20:47:53  pauloscustodio
comments

Revision 1.42  2013/02/26 02:36:54  pauloscustodio
Simplified symbol output to listfile by using SymbolRefList argument

Revision 1.41  2013/02/26 02:11:32  pauloscustodio
New model_symref.c with all symbol cross-reference list handling

Revision 1.40  2013/02/22 17:26:34  pauloscustodio
Decouple assembler from listfile handling

Revision 1.39  2013/02/19 22:52:40  pauloscustodio
BUG_0030 : List bytes patching overwrites header
BUG_0031 : List file garbled with input lines with 255 chars
New listfile.c with all the listing related code

Revision 1.38  2013/02/16 09:46:55  pauloscustodio
BUG_0029 : Incorrect alignment in list file with more than 4 bytes opcode

Revision 1.37  2013/02/12 00:58:13  pauloscustodio
BUG_0027 : Incorrect tabulation in symbol list
BUG_0028 : Not aligned page list in symbol list with more that 18 references
CH_0017 : Align with spaces, deprecate -t option

Revision 1.36  2013/02/11 21:54:38  pauloscustodio
BUG_0026 : Incorrect paging in symbol list

Revision 1.35  2013/01/24 23:03:03  pauloscustodio
Replaced (unsigned char) by (byte_t)
Replaced (unisigned int) by (size_t)
Replaced (short) by (int)

Revision 1.34  2013/01/20 13:18:10  pauloscustodio
BUG_0024 : (ix+128) should show warning message
Signed integer range was wrongly checked to -128..255 instead
of -128..127

Revision 1.33  2013/01/14 00:29:37  pauloscustodio
CH_0015 : integer out of range error replaced by warning

Revision 1.32  2012/11/03 17:39:36  pauloscustodio
astyle, comments

Revision 1.31  2012/11/01 23:20:56  pauloscustodio
Warinings due to missing include

Revision 1.30  2012/06/07 11:49:59  pauloscustodio
stricompare() instead of Flncmp()

Revision 1.29  2012/05/26 18:51:10  pauloscustodio
CH_0012 : wrappers on OS calls to raise fatal error
CH_0013 : new errors interface to decouple calling code from errors.c

Revision 1.28  2012/05/24 17:09:27  pauloscustodio
Unify copyright header

Revision 1.27  2012/05/20 06:39:27  pauloscustodio
astyle

Revision 1.26  2012/05/20 06:02:09  pauloscustodio
Garbage collector
Added automatic garbage collection on exit and simple fence mechanism
to detect buffer underflow and overflow, to memalloc functions.
No longer needed to call init_malloc().
No longer need to try/catch during creation of memory structures to
free partially created data - all not freed data is freed atexit().
Renamed xfree0() to xfree().

Revision 1.25  2012/05/17 17:42:14  pauloscustodio
DefineSymbol() and DefineDefSym() defined as void, a fatal error is
always raised on error.

Revision 1.24  2012/05/12 16:57:33  pauloscustodio
    BUG_0016 : RCMX000 emulation routines not assembled when LIST is ON (-l)
        The code "cpi" is assembled as "call rcmx_cpi" when option -RCMX000 is ON.
        This is implemented by calling SetTemporaryLine() to insert new code
        at the current input position.
        When LIST is ON, getasmline() remembers the input file position, reads
        the next line and restores the file position. It ignores the buffer
        set by SetTemporaryLine(), causing the assembler to skip
        the "call rcmx_cpi" line.
        Also added registry of rcmx_cpi as external library routine.

Revision 1.23  2012/05/11 19:29:49  pauloscustodio
Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, 
indenting style, space padding in parentheses and operators. Options written in the makefile, 
target astyle.
        --mode=c
        --lineend=linux
        --indent=spaces=4
        --style=ansi --add-brackets
        --indent-switches --indent-classes
        --indent-preprocessor --convert-tabs
        --break-blocks
        --pad-oper --pad-paren-in --pad-header --unpad-paren
        --align-pointer=name

Revision 1.22  2011/10/14 14:46:03  pauloscustodio
-  BUG_0013 : defm check for MAX_CODESIZE incorrect
 - Remove un-necessary tests for MAX_CODESIZE; all tests are concentrated in check_space() 
 from codearea.c.

Revision 1.21  2011/10/07 17:53:04  pauloscustodio
BUG_0015 : Relocation issue - dubious addresses come out of linking
(reported on Tue, Sep 27, 2011 at 8:09 PM by dom)
- Introduced in version 1.1.8, when the CODESIZE and the codeptr were merged into the same entity.
- This caused the problem because CODESIZE keeps track of the start offset of each module in the 
  sequence they will appear in the object file, and codeptr is reset to the start of the codearea 
  for each module.
  The effect was that all address calculations at link phase were considering a start offset of zero 
  for all modules.
- Moreover, when linking modules from a libary, the modules are pulled in to the code area as they 
  are needed, and not in the sequence they will be in the object file. The start offset was being 
  ignored and the modules were being loaded in the incorrect order
- Consequence of these two issues were all linked addresses wrong.

Revision 1.20  2011/08/21 20:37:20  pauloscustodio
CH_0005 : handle files as char[FILENAME_MAX] instead of strdup for every operation
- Factor all pathname manipulation into module file.c.
- Make default extensions constants.
- Move asm_ext[] and obj_ext[] to the options.c module.

Revision 1.19  2011/08/19 15:53:58  pauloscustodio
BUG_0010 : heap corruption when reaching MAXCODESIZE
- test for overflow of MAXCODESIZE is done before each instruction at parseline(); if only one byte 
  is available in codearea, and a 2 byte instruction is assembled, the heap is corrupted before the 
  exception is raised.
- Factored all the codearea-accessing code into a new module, checking for MAXCODESIZE on 
  every write.

Revision 1.18  2011/08/19 10:20:32  pauloscustodio
- Factored code to read/write word from file into fgetw_err/fputw_err.
- Renamed ReadLong/WriteLong to fgetl_err/fputl_err for symetry.

Revision 1.17  2011/08/18 23:27:54  pauloscustodio
BUG_0009 : file read/write not tested for errors
- In case of disk full file write fails, but assembler does not detect the error
  and leaves back corruped object/binary files
- Created new exception FileIOException and ERR_FILE_IO error.
- Created new functions fputc_err, fgetc_err, ... to raise the exception on error.

Revision 1.16  2011/08/14 19:37:43  pauloscustodio
Z80pass1(): no need to check for fatal error and return; bypassed by exception mechanism

Revision 1.15  2011/08/05 20:20:45  pauloscustodio
CH_0004 : Exception mechanism to handle fatal errors
Replaced all ERR_NO_MEMORY/return sequences by an exception, captured at main().
Replaced all the memory allocation functions malloc, calloc, ... by corresponding
macros xmalloc, xcalloc, ... that raise an exception if the memory cannot be allocated,
removing all the test code after each memory allocation.
Replaced all functions that allocated memory structures by the new xcalloc_struct().
Replaced all free() by xfree0() macro which only frees if the pointer in non-null, and
sets the poiter to NULL afterwards, to avoid any used of the freed memory.
Created try/catch sequences to clean-up partially created memory structures and rethrow the
exception, to cleanup memory leaks.
Replaced 'l' (lower case letter L) by 'len' - too easy to confuse with numeral '1'.

Revision 1.14  2011/07/18 00:48:25  pauloscustodio
Initialize MS Visual Studio DEBUG build to show memory leaks on exit

Revision 1.13  2011/07/14 01:32:08  pauloscustodio
    - Unified "Integer out of range" and "Out of range" errors; they are the same error.
    - Unified ReportIOError as ReportError(ERR_FILE_OPEN)
    CH_0003 : Error messages should be more informative
        - Added printf-args to error messages, added "Error:" prefix.
    BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
        - Raise ERR_UNBALANCED_PAREN instead

Revision 1.12  2011/07/12 22:47:59  pauloscustodio
- Moved all error variables and error reporting code to a separate module errors.c,
  replaced all extern declarations of these variables by include errors.h,
  created symbolic constants for error codes.
- Added test scripts for error messages.

Revision 1.11  2011/07/11 16:19:37  pauloscustodio
Moved all option variables and option handling code to a separate module options.c,
replaced all extern declarations of these variables by include options.h.
Created declarations in z80asm.h of objects defined in z80asm.c.

Revision 1.10  2011/07/09 18:25:35  pauloscustodio
Log keyword in checkin comment was expanded inside Log expansion... recursive
Added Z80asm banner to all source files

Revision 1.9  2011/07/09 17:36:09  pauloscustodio
Copied cvs log into Log history

Revision 1.8  2011/07/09 01:46:00  pauloscustodio
Added Log keyword

Revision 1.7  2011/07/09 01:34:12  pauloscustodio
added casts to clean up warnings
BUG_0004 : 8bit unsigned constants are not checked for out-of-range
     Added the check to ExprUnsigned8() and Z80pass2().

Revision 1.6  2010/04/16 17:34:37  dom
Make line number an int - 32768 lines isn't big enough...

Revision 1.5  2009/09/03 17:54:55  dom
Fix name conflict with the getline function in POSIX 2008

Nabbed via Fedora/Kevin Kofler

Revision 1.4  2009/08/14 22:23:12  dom
clean up some compiler warnings

Revision 1.3  2002/05/11 20:09:38  dom
A patch around the appalling IF ELSE ENDIF handling of z80asm where it
tries to evaluate FALSE clauses and gets completely in a twist.

These patches turn off the output to the two errors that I've seen pop
up in this state: Syntax error and unknown identifier. Please test this
one quite hard if you get a change... - it was done to allow even more
complicated logic in the z88 app startup to actually work - as soon as I'm
happy with that I'll commit it as well

Revision 1.2  2001/03/21 16:34:01  dom
Added changes to allow labels to end in ':' and the prefix '.' isn't
necessarily needed..this isn't guaranteed to be perfect so let me know
of any problems and drop back to 1.0.18

Revision 1.1  2000/07/04 15:33:29  dom
branches:  1.1.1;
Initial revision

Revision 1.1.1.1  2000/07/04 15:33:29  dom
First import of z88dk into the sourceforge system <gulp>

*/

/* $History: Z80PASS.C $ */
/*  */
/* *****************  Version 14  ***************** */
/* User: Gbs          Date: 26-01-00   Time: 22:10 */
/* Updated in $/Z80asm */
/* Expression range validation removed from 8bit unsigned (redundant). */
/*  */
/* *****************  Version 12  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 20:07 */
/* Updated in $/Z80asm */
/* "PC" program counter changed to long (from unsigned short). */
/*  */
/* *****************  Version 10  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 12:13 */
/* Updated in $/Z80asm */
/* Added Ascii Art "Z80asm" at top of source file. */
/*  */
/* *****************  Version 8  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 11:39 */
/* Updated in $/Z80asm */
/* parseline() bug fix: code size may reach <= MAXCODESIZE. */
/*  */
/* *****************  Version 7  ***************** */
/* User: Gbs          Date: 30-05-99   Time: 1:06 */
/* Updated in $/Z80asm */
/* New function, Flncmp() to compare two filenames after internal lower */
/* case conversion (used by Include file mutual recursion validation). */
/*  */
/* *****************  Version 6  ***************** */
/* User: Gbs          Date: 2-05-99    Time: 18:16 */
/* Updated in $/Z80asm */
/* New function, FindFile(), to validate whether an include file already */
/* has been included in a previous include level. */
/* Z80pass2() bug fix: Expressions that are saved to object file */
/* (typically containing external symbols) shouldn't get evaluated - this */
/* can create unnecessary error messages. */
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

#include "memalloc.h"   /* before any other include */

#include "codearea.h"
#include "config.h"
#include "errors.h"
#include "file.h"
#include "hist.h"
#include "listfile.h"
#include "model.h"
#include "options.h"
#include "scan.h"
#include "strutil.h"
#include "symbol.h"
#include "symbols.h"
#include "z80asm.h"
#include <ctype.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

/* external functions */
void Skipline( FILE *fptr );
void LinkModules( void );
void DefineOrigin( void );
void ParseIdent( enum flag interpret );
void RemovePfixlist( struct expr *pfixexpr );
void StoreExpr( struct expr *pfixexpr, char range );
int GetChar( FILE *fptr );
long EvalPfixExpr( struct expr *pass2expr );
struct expr *ParseNumExpr( void );
enum symbols GetSym( void );
symbol *FindSymbol( char *identifier, avltree *treeptr );

/* local functions */
void ifstatement( enum flag interpret );
void parseline( enum flag interpret );
void getasmline( void );
void Pass2info( struct expr *expression, char constrange, long lfileptr );
void Z80pass1( void );
void Z80pass2( void );
void WriteSymbolTable( char *msg, avltree *root );
void WriteMapFile( void );
void StoreName( symbol *node, byte_t symscope );
void StoreLibReference( symbol *node );
void StoreGlobalName( symbol *node );
void StoreLocalName( symbol *node );
long Evallogexpr( void );
struct sourcefile *Prevfile( void );
struct sourcefile *Newfile( struct sourcefile *curfile, char *fname );
struct sourcefile *Setfile( struct sourcefile *curfile, struct sourcefile *newfile, char *fname );
struct sourcefile *FindFile( struct sourcefile *srcfile, char *fname );


/* global variables */
extern FILE *z80asmfile, *objfile;
extern char line[], ident[], separators[];
extern enum symbols sym;
extern enum flag EOL;
extern long TOTALLINES;
extern struct modules *modulehdr;       /* pointer to module header */
extern struct module *CURRENTMODULE;
extern avltree *globalroot;
extern char *temporary_ptr;

void
Z80pass1( void )
{
    line[0] = '\0';                   /* reset contents of list buffer */

    while ( !feof( z80asmfile ) )
    {
        parseline( ON );              /* before parsing it */
    }
}



void
getasmline( void )
{
    long fptr;
    char *save_temporary_ptr;
    int len, c;

    fptr = ftell( z80asmfile );           /* remember file and temp buffer position */
    save_temporary_ptr = temporary_ptr;

    c = 0;

    for ( len = 0; ( len < 254 ) && ( c != '\n' ); len++ )
    {
        c = GetChar( z80asmfile );

        if ( c != EOF )
        {
            line[len] = c;    /* line feed inclusive */
        }
        else
        {
            break;
        }
    }

    line[len] = '\0';

    fseek( z80asmfile, fptr, SEEK_SET );  /* resume file and temp buffer position */
    temporary_ptr = save_temporary_ptr;
}



void
parseline( enum flag interpret )
{
    FindSymbol( ASSEMBLERPC, globalroot )->symvalue = get_PC();   /* update assembler program counter */

    ++CURRENTFILE->line;

    if ( !clinemode )
    {
        set_error_line( CURRENTFILE->line );    /* error location */
    }

    ++TOTALLINES;

    if ( listing )
    {
        getasmline();    /* get a copy of current source line */
		list_start_line( get_PC(), CURRENTFILE->fname, CURRENTFILE->line, line );
    }

    EOL = OFF;                /* reset END OF LINE flag */
    GetSym();

    if ( sym == fullstop || sym == label )
    {
        if ( interpret == ON )
        {
            /* Generate only possible label declaration if line parsing is allowed */
            if ( sym == label || GetSym() == name )
            {
				/* labels must always be touched due to forward referencing problems in expressions */
                DefineSymbol( ident, get_PC(), SYMADDR | SYMTOUCHED ); 
                                                                         
                GetSym();      /* check for another identifier */				
            }
            else
            {
                error( ERR_ILLEGAL_IDENT );       /* a name must follow a label declaration */
                return;       /* read in a new source line */
            }
        }
        else
        {
            Skipline( z80asmfile );
            sym = newline;    /* ignore label and rest of line */
        }
    }

    switch ( sym )
    {
        case name:
            ParseIdent( interpret );
            break;

        case newline:
            break;                /* empty line, get next... */

        default:
            if ( interpret == ON )
            {
                error( ERR_SYNTAX );    /* Syntax error */
            }
    }

    list_end_line();				/* Write current source line to list file */
}



/* multilevel contitional assembly logic */

void
ifstatement( enum flag interpret )
{
    if ( interpret == ON )
    {
        /* evaluate #if expression */
        if ( Evallogexpr() != 0 )
        {

            do
            {
                /* expression is TRUE, interpret lines until #else or #endif */
                if ( !feof( z80asmfile ) )
                {
                    parseline( ON );
                }
                else
                {
                    return;    /* end of file - exit from this #if level */
                }
            }
            while ( ( sym != elsestatm ) && ( sym != endifstatm ) );

            if ( sym == elsestatm )
            {
                do
                {
                    /* then ignore lines until #endif ... */
                    if ( !feof( z80asmfile ) )
                    {
                        parseline( OFF );
                    }
                    else
                    {
                        return;
                    }
                }
                while ( sym != endifstatm );
            }
        }
        else
        {
            do
            {
                /* expression is FALSE, ignore until #else or #endif */
                if ( !feof( z80asmfile ) )
                {
                    parseline( OFF );
                }
                else
                {
                    return;
                }
            }
            while ( ( sym != elsestatm ) && ( sym != endifstatm ) );

            if ( sym == elsestatm )
            {
                do
                {
                    if ( !feof( z80asmfile ) )
                    {
                        parseline( ON );
                    }
                    else
                    {
                        return;
                    }
                }
                while ( sym != endifstatm );
            }
        }
    }
    else
    {
        do
        {
            /* don't evaluate #if expression and ignore all lines until #endif */
            if ( !feof( z80asmfile ) )
            {
                parseline( OFF );
            }
            else
            {
                return;    /* end of file - exit from this IF level */
            }
        }
        while ( sym != endifstatm );
    }

    sym = nil;
}



long
Evallogexpr( void )
{
    struct expr *postfixexpr;
    long constant = 0;

    GetSym();                     /* get logical expression */

    if ( ( postfixexpr = ParseNumExpr() ) != NULL )
    {
        constant = EvalPfixExpr( postfixexpr );
        RemovePfixlist( postfixexpr );    /* remove linked list, expression evaluated */
    }

    return constant;
}




void
Z80pass2( void )
{
    struct expr *pass2expr, *prevexpr;
    struct JRPC *curJR, *prevJR;
    long constant;
    long fptr_exprdecl, fptr_namedecl, fptr_modname, fptr_modcode, fptr_libnmdecl;
    size_t patchptr;


    if ( ( pass2expr = CURRENTMODULE->mexpr->firstexpr ) != NULL )
    {
        curJR = CURRENTMODULE->JRaddr->firstref;  /* point at first JR PC address in this module */

        do
        {
            constant = EvalPfixExpr( pass2expr );

            if ( pass2expr->stored == OFF )
            {
                if ( ( pass2expr->rangetype & EXPREXTERN ) || ( pass2expr->rangetype & EXPRADDR ) )
                {
                    /*
                     * Expression contains symbol declared as external or defined as a relocatable
                     * address,
                     */
                    /* store expression in relocatable file */
                    switch ( pass2expr->rangetype & RANGE )
                    {
                        case RANGE_32SIGN:
                            StoreExpr( pass2expr, 'L' );
                            break;

                        case RANGE_16CONST:
                            StoreExpr( pass2expr, 'C' );
                            break;

                        case RANGE_8UNSIGN:
                            StoreExpr( pass2expr, 'U' );
                            break;

                        case RANGE_8SIGN:
                            StoreExpr( pass2expr, 'S' );
                            break;
                    }
                }
            }

            if ( ( pass2expr->rangetype & NOTEVALUABLE ) && ( pass2expr->stored == OFF ) )
            {
                if ( ( pass2expr->rangetype & RANGE ) == RANGE_JROFFSET )
                {
                    if ( pass2expr->rangetype & EXPREXTERN )
                    {
						/* JR, DJNZ used an external label - */
                        error_at( pass2expr->srcfile, pass2expr->curline, ERR_JR_NOT_LOCAL );	
                    }     
                    else
                    {
                        error_at( pass2expr->srcfile, pass2expr->curline, ERR_NOT_DEFINED );
                    }

                    prevJR = curJR;
                    curJR = curJR->nextref;       /* get ready for next JR instruction */
                    xfree( prevJR );
                }
                else
                {
                    error_at( pass2expr->srcfile, pass2expr->curline, ERR_NOT_DEFINED );
                }
            }
            else
            {
                patchptr = pass2expr->codepos;            /* index in memory buffer */

                switch ( pass2expr->rangetype & RANGE )
                {
                    case RANGE_JROFFSET:
                        constant -= curJR->PCaddr;    /* get module PC at JR instruction */

                        if ( constant >= -128 && constant <= 127 )
                        {
                            patch_byte( &patchptr, (byte_t) constant );
                            /* opcode is stored, now store relative jump */
                        }
                        else
                        {
                            error_at( pass2expr->srcfile, pass2expr->curline, ERR_INT_RANGE, constant );
                        }

                        prevJR = curJR;
                        curJR = curJR->nextref;       /* get ready for JR instruction */
                        xfree( prevJR );
                        break;

                    case RANGE_8UNSIGN:
                        if ( constant < -128 || constant > 255 )
                            warning_at( pass2expr->srcfile, pass2expr->curline, ERR_INT_RANGE, constant );

						patch_byte( &patchptr, (byte_t) constant );
                        break;

                    case RANGE_8SIGN:
                        if ( constant < -128 || constant > 127 )
                            warning_at( pass2expr->srcfile, pass2expr->curline, ERR_INT_RANGE, constant );

						patch_byte( &patchptr, (byte_t) constant );
                        break;

                    case RANGE_16CONST:
                        if ( constant < -32768 || constant > 65535 )
                            warning_at( pass2expr->srcfile, pass2expr->curline, ERR_INT_RANGE, constant );

						patch_word( &patchptr, ( int ) constant );
                        break;

                    case RANGE_32SIGN:
                        if ( constant < LONG_MIN || constant > LONG_MAX )
                            warning_at( pass2expr->srcfile, pass2expr->curline, ERR_INT_RANGE, constant );

						patch_long( &patchptr, constant );
                        break;
                }
            }

            if ( option_list )
            {
				list_patch_data( pass2expr->listpos, constant, RANGE_SIZE(pass2expr->rangetype) );
            }

            prevexpr = pass2expr;
            pass2expr = pass2expr->nextexpr;      /* get next pass2 expression */
            RemovePfixlist( prevexpr );   /* release current expression */
        }
        while ( pass2expr != NULL );      /* re-evaluate expressions and patch in code */

        xfree( CURRENTMODULE->mexpr );   /* Release header of expressions list */
        xfree( CURRENTMODULE->JRaddr );  /* Release header of relative jump address list */
        CURRENTMODULE->mexpr = NULL;
        CURRENTMODULE->JRaddr = NULL;
    }

    if ( ! get_num_errors() && option_symtable )
    {
        WriteSymbolTable( "Local Module Symbols:", CURRENTMODULE->localroot );
        WriteSymbolTable( "Global Module Symbols:", globalroot );
    }

    fptr_namedecl = ftell( objfile );
    inorder( CURRENTMODULE->localroot, ( void ( * )( void * ) ) StoreLocalName ); /* Store Local Name declarations to relocatable file */
    inorder( globalroot, ( void ( * )( void * ) ) StoreGlobalName ); /* Store Global name declarations to relocatable file */

    fptr_libnmdecl = ftell( objfile );    /* Store library reference names */
    inorder( globalroot, ( void ( * )( void * ) ) StoreLibReference ); /* Store library reference name declarations to relocatable file */

    fptr_modname = ftell( objfile );
    constant = strlen( CURRENTMODULE->mname );
    fputc_err( constant, objfile );  /* write length of module name to relocatable file */
    fwritec_err( CURRENTMODULE->mname, ( size_t ) constant, objfile );   /* write module name to relocatable file */

    if ( ( constant = get_codeindex() ) == 0 )    /* BUG_0015 */
    {
        fptr_modcode = -1;    /* no code generated!  */
    }
    else
    {
        fptr_modcode = ftell( objfile );
        fputw_err( constant, objfile );  /* two bytes of module code size */
        fwrite_codearea( objfile );
    }

    inc_codesize( constant );             /* BUG_0015 */

    if ( verbose )
    {
        printf( "Size of module is %ld bytes\n", constant );
    }

    fseek( objfile, 8, SEEK_SET ); /* set file pointer to point at ORG */

    if ( ( modulehdr->first == CURRENTMODULE ) )
    {
        if ( deforigin )
        {
            CURRENTMODULE->origin = EXPLICIT_ORIGIN;    /* use origin from command line */
        }
    }

    fputw_err( CURRENTMODULE->origin, objfile );         /* two bytes of origin */

    fptr_exprdecl = 30;           /* expressions always begins at file position 24 */

    if ( fptr_namedecl == fptr_exprdecl )
    {
        fptr_exprdecl = -1;    /* no expressions */
    }

    if ( fptr_libnmdecl == fptr_namedecl )
    {
        fptr_namedecl = -1;    /* no name declarations */
    }

    if ( fptr_modname == fptr_libnmdecl )
    {
        fptr_libnmdecl = -1;    /* no library reference declarations */
    }

    fputl_err( fptr_modname, objfile );  /* write fptr. to module name */
    fputl_err( fptr_exprdecl, objfile ); /* write fptr. to name declarations */
    fputl_err( fptr_namedecl, objfile ); /* write fptr. to name declarations */
    fputl_err( fptr_libnmdecl, objfile ); /* write fptr. to library name declarations */
    fputl_err( fptr_modcode, objfile );  /* write fptr. to module code */
}


void
StoreGlobalName( symbol *node )
{
    if ( ( node->type & SYMXDEF ) && ( node->type & SYMTOUCHED ) )
    {
        StoreName( node, SYMXDEF );
    }
}


void
StoreLocalName( symbol *node )
{
    if ( ( node->type & SYMLOCAL ) && ( node->type & SYMTOUCHED ) )
    {
        StoreName( node, SYMLOCAL );
    }
}


void
StoreName( symbol *node, byte_t scope )
{
    int b;

    switch ( scope )
    {
        case SYMLOCAL:
            fputc_err( 'L', objfile );
            break;

        case SYMXDEF:
            if ( node->type & SYMDEF )
            {
                fputc_err( 'X', objfile );
            }
            else
            {
                fputc_err( 'G', objfile );
            }

            break;
    }

    if ( node->type & SYMADDR )   /* then write type of symbol */
    {
        fputc_err( 'A', objfile );    /* either a relocatable address */
    }
    else
    {
        fputc_err( 'C', objfile );    /* or a constant */
    }

    fputl_err( node->symvalue, objfile );

    b = strlen( node->symname );
    fputc_err( b, objfile );         /* write length of symbol name to relocatable file */
    fwritec_err( node->symname, ( size_t ) b, objfile ); /* write symbol name to relocatable file */
}


void
StoreLibReference( symbol *node )
{
    size_t b;

    if ( ( node->type & SYMXREF ) && ( node->type & SYMDEF ) && ( node->type & SYMTOUCHED ) )
    {
        b = strlen( node->symname );
        fputc_err( ( int ) b, objfile ); /* write length of symbol name to relocatable file */
        fwritec_err( node->symname, b, objfile );    /* write symbol name to relocatable file */
    }
}


void
Pass2info( struct expr *pfixexpr,       /* pointer to header of postfix expression linked list */
           char constrange,				/* allowed size of value to be parsed */
           long byteoffset )			/* position in listing file to patch */
{
    pfixexpr->nextexpr = NULL;
    pfixexpr->rangetype = constrange;
    pfixexpr->srcfile = CURRENTFILE->fname;       /* pointer to record containing current source file name */
    pfixexpr->curline = CURRENTFILE->line;        /* pointer to record containing current line number */
    pfixexpr->listpos = list_patch_pos(byteoffset);
												  /* now calculated as absolute file pointer */

    if ( CURRENTMODULE->mexpr->firstexpr == NULL )
    {
        CURRENTMODULE->mexpr->firstexpr = pfixexpr;
        CURRENTMODULE->mexpr->currexpr = pfixexpr;        /* Expression header points at first expression */
    }
    else
    {
        CURRENTMODULE->mexpr->currexpr->nextexpr = pfixexpr;      /* Current expr. node points to new expression
                                                                   * node */
        CURRENTMODULE->mexpr->currexpr = pfixexpr;				  /* Pointer to current expr. node updated */
    }
}



struct sourcefile *
Prevfile( void )
{
    struct usedfile *newusedfile;
    struct sourcefile *ownedfile;

    newusedfile = xcalloc_struct( struct usedfile );
    ownedfile = CURRENTFILE;
    CURRENTFILE = CURRENTFILE->prevsourcefile;    /* get back to owner file - now the current */
    CURRENTFILE->newsourcefile = NULL;    /* current file is now the last in the list */
    ownedfile->prevsourcefile = NULL;     /* pointer to owner now obsolete... */

    newusedfile->nextusedfile = CURRENTFILE->usedsourcefile;      /* set ptr to next record to current ptr to
                                                                 * another used file */
    CURRENTFILE->usedsourcefile = newusedfile;    /* new used file now inserted into list */
    newusedfile->ownedsourcefile = ownedfile;     /* the inserted record now points to previously owned file */
    return ( CURRENTFILE );
}


/* CH_0004 : always returns non-NULL, ERR_NO_MEMORY is signalled by exception */
struct sourcefile *
Newfile( struct sourcefile *curfile, char *fname )
{
    struct sourcefile *nfile;
    struct sourcefile *ret;

    nfile = xcalloc_struct( struct sourcefile );
    ret = Setfile( curfile, nfile, fname );

    return ret;
}


struct sourcefile *
Setfile( struct sourcefile *curfile,    /* pointer to record of current source file */
         struct sourcefile *nfile,      /* pointer to record of new
                                         * source file */
         char *filename )
{
    nfile->fname = xstrdup( filename );   /* pointer to filename string */
    nfile->prevsourcefile = curfile;
    nfile->newsourcefile = NULL;
    nfile->usedsourcefile = NULL;
    nfile->filepointer = 0;
    nfile->line = 0;                      /* Reset to 0 as line counter during parsing */
    return ( nfile );
}


struct sourcefile *
FindFile( struct sourcefile *srcfile, char *flnm )
{
    struct sourcefile *foundfile;

    if ( srcfile != NULL )
    {
        if ( ( foundfile = FindFile( srcfile->prevsourcefile, flnm ) ) != NULL )
        {
            return foundfile;    /* trying to include an already included file recursively! */
        }

        if ( stricompare( srcfile->fname, flnm ) == 0 )
        {
            return srcfile;    /* this include file already used! */
        }
        else
        {
            return NULL;    /* this include file didn't match filename searched */
        }
    }
    else
    {
        return NULL;
    }
}


void
WriteSymbol( symbol *n )
{
    if ( n->owner == CURRENTMODULE )
    {
        /* Write only symbols related to current module */
        if ( ( n->type & SYMLOCAL ) || ( n->type & SYMXDEF ) )
        {
            if ( ( n->type & SYMTOUCHED ) )
            {
				list_symbol( n->symname, n->symvalue, n->references );
            }
        }
    }
}


void
WriteSymbolTable( char *msg, avltree *root )
{
	list_start_table( msg );
    inorder( root, ( void ( * )( void * ) ) WriteSymbol ); /* write symbol table */
}
