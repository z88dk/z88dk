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
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/z80asm.c,v 1.50 2012-05-20 06:39:27 pauloscustodio Exp $ */
/* $Log: z80asm.c,v $
/* Revision 1.50  2012-05-20 06:39:27  pauloscustodio
/* astyle
/*
/* Revision 1.49  2012/05/20 06:02:09  pauloscustodio
/* Garbage collector
/* Added automatic garbage collection on exit and simple fence mechanism
/* to detect buffer underflow and overflow, to memalloc functions.
/* No longer needed to call init_malloc().
/* No longer need to try/catch during creation of memory structures to
/* free partially created data - all not freed data is freed atexit().
/* Renamed xfree0() to xfree().
/*
/* Revision 1.48  2012/05/18 00:23:14  pauloscustodio
/* DefineSymbol() and DefineDefSym() defined as void, a fatal error is always raised on error.
/*
/* Revision 1.47  2012/05/17 21:36:06  pauloscustodio
/* Remove global ASMERROR, redundant with TOTALERRORS.
/* Remove IllegalArgumentException, replace by FatalErrorException.
/*
/* Revision 1.46  2012/05/17 17:49:20  pauloscustodio
/* astyle
/*
/* Revision 1.45  2012/05/17 17:42:14  pauloscustodio
/* DefineSymbol() and DefineDefSym() defined as void, a fatal error is
/* always raised on error.
/*
/* Revision 1.44  2012/05/17 14:56:23  pauloscustodio
/* New init_except() to be called at start of main(), auto cleanup atexit(), no need to call e4c_context_end()
/*
/* Revision 1.43  2012/05/11 19:29:49  pauloscustodio
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
/* Revision 1.42  2011/10/14 15:00:22  pauloscustodio
/* - Move cpu_type to options.c.
/* - Replace strncpy by strncat, when used to make a safe copy without buffer overruns. The former pads the string with nulls.
/* - Factor strtoupper() to new module strutil.c.
/*
/* Revision 1.41  2011/10/07 17:53:04  pauloscustodio
/* BUG_0015 : Relocation issue - dubious addresses come out of linking
/* (reported on Tue, Sep 27, 2011 at 8:09 PM by dom)
/* - Introduced in version 1.1.8, when the CODESIZE and the codeptr were merged into the same entity.
/* - This caused the problem because CODESIZE keeps track of the start offset of each module in the sequence they will appear in the object file, and codeptr is reset to the start of the codearea for each module.
/* The effect was that all address calculations at link phase were considering
/*  a start offset of zero for all modules.
/* - Moreover, when linking modules from a libary, the modules are pulled in to the code area as they are needed, and not in the sequence they will be in the object file. The start offset was being ignored and the modules were being loaded in the incorrect order
/* - Consequence of these two issues were all linked addresses wrong.
/*
/* Revision 1.40  2011/08/21 20:37:20  pauloscustodio
/* CH_0005 : handle files as char[FILENAME_MAX] instead of strdup for every operation
/* - Factor all pathname manipulation into module file.c.
/* - Make default extensions constants.
/* - Move srcext[] and objext[] to the options.c module.
/*
/* Revision 1.39  2011/08/19 15:53:58  pauloscustodio
/* BUG_0010 : heap corruption when reaching MAXCODESIZE
/* - test for overflow of MAXCODESIZE is done before each instruction at parseline(); if only one byte is available in codearea, and a 2 byte instruction is assembled, the heap is corrupted before the exception is raised.
/* - Factored all the codearea-accessing code into a new module, checking for MAXCODESIZE on every write.
/*
/* Revision 1.38  2011/08/19 10:20:32  pauloscustodio
/* - Factored code to read/write word from file into xfget_word/xfput_word.
/* - Renamed ReadLong/WriteLong to xfget_long/xfput_long for symetry.
/*
/* Revision 1.37  2011/08/18 23:27:54  pauloscustodio
/* BUG_0009 : file read/write not tested for errors
/* - In case of disk full file write fails, but assembler does not detect the error
/*   and leaves back corruped object/binary files
/* - Created new exception FileIOException and ERR_FILE_IO error.
/* - Created new functions xfputc, xfgetc, ... to raise the exception on error.
/*
/* Revision 1.36  2011/08/18 21:47:48  pauloscustodio
/* BUG_0008 : code block of 64K is read as zero
/*
/* Revision 1.35  2011/08/15 17:12:31  pauloscustodio
/* Upgrade to Exceptions4c 2.8.9 to solve memory leak.
/*
/* Revision 1.34  2011/08/14 19:36:02  pauloscustodio
/* - AssembleSourceFile(): error return is never used; changed to void
/* - AssembleSourceFile(): added try-catch to delete incomplete files in case of fatal error, throw FatalErrorException instead of early return
/* - main(): added try-catch to delete incomplete library file in case of fatal error
/* - source_file_open not needed; z80asmfile can be used for the same purpose
/*
/* Revision 1.33  2011/08/05 20:07:49  pauloscustodio
/* CH_0004 : Exception mechanism to handle fatal errors
/* Included exceptions4c 2.4, Copyright (c) 2011 Guillermo Calvo
/* Replaced all ERR_NO_MEMORY/return sequences by an exception, captured at main().
/* Replaced all the memory allocation functions malloc, calloc, ... by corresponding
/* macros xmalloc, xcalloc, ... that raise an exception if the memory cannot be allocated,
/* removing all the test code after each memory allocation.
/* Replaced all functions that allocated memory structures by the new xcalloc_struct().
/* Replaced all free() by xfree0() macro which only frees if the pointer in non-null, and
/* sets the poiter to NULL afterwards, to avoid any used of the freed memory.
/* Created try/catch sequences to clean-up partially created memory structures and rethrow the
/* exception, to cleanup memory leaks.
/* Replaced all exit(1) by an exception.
/* Replaced 'l' (lower case letter L) by 'len' - too easy to confuse with numeral '1'.
/*
/* Revision 1.32  2011/07/18 00:53:26  pauloscustodio
/* Initialize MS Visual Studio DEBUG build to show memory leaks on exit
/* BUG_0007 : memory leaks - Cleaned memory leaks in main(), ReleaseModules()
/*
/* Revision 1.31  2011/07/14 01:32:08  pauloscustodio
/*     - Unified "Integer out of range" and "Out of range" errors; they are the same error.
/*     - Unified ReportIOError as ReportError(ERR_FILE_OPEN)
/*     CH_0003 : Error messages should be more informative
/*         - Added printf-args to error messages, added "Error:" prefix.
/*     BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
/*         - Raise ERR_UNBALANCED_PAREN instead
/*
/* Revision 1.30  2011/07/12 22:47:59  pauloscustodio
/* - Moved all error variables and error reporting code to a separate module errors.c,
/*   replaced all extern declarations of these variables by include errors.h,
/*   created symbolic constants for error codes.
/* - Added test scripts for error messages.
/*
/* Revision 1.29  2011/07/11 16:16:44  pauloscustodio
/* Moved all option variables and option handling code to a separate module options.c,
/* replaced all extern declarations of these variables by include options.h.
/* Created declarations in z80asm.h of objects defined in z80asm.c.
/*
/* Revision 1.28  2011/07/09 18:25:35  pauloscustodio
/* Log keyword in checkin comment was expanded inside Log expansion... recursive
/* Added Z80asm banner to all source files
/*
/* Revision 1.27  2011/07/09 17:36:09  pauloscustodio
/* Copied cvs log into Log history
/*
/* Revision 1.26  2011/07/09 01:46:00  pauloscustodio
/* Added Log keyword
/*
/* Revision 1.25  2011/07/09 01:27:34  pauloscustodio
/* Moved snprintf macro to z80asm.h
/* Moved copyright info to hist.c
/* Added casts to remove warnings
/* BUG_0001 : Error in expression during link, expression garbled - memory corruption?
/*      Simple asm program: "org 0 \n jp NN \n jp NN \n NN: \n",
/*      compile with "z80asm -t4 -b test.asm"
/*      fails with: "File 'test.asm', Module 'TEST', Syntax error in expression \n
/*                   Error in expression +¦+²+-;¾?.¹Ò¦Ò²Ù+vÝFÝVÝ^Ýx¦ Ý@ÝHÝPÝ".
/*      Problem cause: lexer GetSym() is not prepared to read '\0' bytes.
/*      When the expression is read from the OBJ file at the link phase, the '\0'
/*      at the end of the expression field is interpreted as a random separator
/*      because ssym[] contains fewer elements (27) than the separators string (28);
/*      hence in some cases the expression is parsed correctly, e.g. without -t4
/*      the program assembles correctly.
/*      If the random separator is a semicolon, GetSym() calls Skipline() to go past
/*      the comment, and reads past the end of the expression in the OBJ file,
/*      causing the parse of the next expression to fail.
/* BUG_0002 : CreateLibFile and GetLibFile: buffer overrun
/*      When the Z80_STDLIB variable is defined, libfilename is allocated with one byte
/*      too short (strlen(filename) instead of strlen(filename)+1).
/* BUG_0003 : Illegal options are ignored, although ReportError 9 (Illegal Option) exists
/*      SetAsmFlag(): Some options were missing the 'return' statement, following through
/*      to the next tests; inserted 'return' in options 'M', 'I', 'L' and 'D'.
/*      Added ReportError 9 (Illegal Option) if the option is not recognized.
/* CH_0001 : Assembly error messages should appear on stderr
/*      It's cumbersome to have to open .err files to see assembly errors.
/*      Changed ReportError() to Write error messages to stderr in addition to the .err file.
/*
/* Revision 1.24  2010/09/19 00:06:20  dom
/* Tweaks for compiling code generated by sdcc - it generates XREF rather than
/* LIB so treat XREF as a LIB (this possibly should be the default)
/*
/* Do some _ mapping magic when in sdcc so standard z88dk libs can be used
/* (wrong _ convention chosen a long time ago...)
/*
/* Have -forcexlib flag which treats MODULE as XLIB.
/*
/* Revision 1.23  2010/04/16 17:34:37  dom
/* Make line number an int - 32768 lines isn't big enough...
/*
/* Revision 1.22  2009/07/18 23:23:15  dom
/* clean up the code a bit more (Formatting and a fewer magic numbers)
/*
/* Revision 1.21  2009/06/22 22:12:53  dom
/* Fix some win32 compiler issues
/*
/* Revision 1.20  2009/06/13 17:36:24  dom
/* Add -I and -L to specify search paths for libraries and includes
/*
/* Revision 1.19  2007/07/21 22:43:35  dom
/* bump the version to a random made up version, bump the date
/*
/* Revision 1.18  2007/07/21 22:41:00  dom
/* some emacs foo to make my life easier.
/*
/* Support the concept of including from @lst files, simply list the include
/* file will an @ at the start and it will be parsed for files. This should
/* make library management a bit easier in that we don't have to add a new
/* routine to about 25 .lst files!
/*
/* Revision 1.17  2007/02/28 11:23:24  stefano
/* New platform !
/* Rabbit Control Module 2000/3000.
/*
/* Revision 1.16  2003/12/01 22:04:25  denniz
/* Fix for DOS/Win32 directory names with dots.
/*
/* Revision 1.15  2003/10/11 15:41:04  dom
/* changes from garry
/*
/* - support for defp -> defp addr,bank
/* - square brackets can be used in expressions
/* - comma can be used in defm
/*
/* Revision 1.14  2002/12/09 19:55:24  dom
/* version bump
/*
/* Revision 1.13  2002/12/01 15:47:17  dom
/* local install on unix resolved
/*
/* Revision 1.12  2002/05/11 20:35:47  dom
/* ahem
/*
/* Revision 1.11  2002/05/11 20:09:38  dom
/* A patch around the appalling IF ELSE ENDIF handling of z80asm where it
/* tries to evaluate FALSE clauses and gets completely in a twist.
/*
/* These patches turn off the output to the two errors that I've seen pop
/* up in this state: Syntax error and unknown identifier. Please test this
/* one quite hard if you get a change... - it was done to allow even more
/* complicated logic in the z88 app startup to actually work - as soon as I'm
/* happy with that I'll commit it as well
/*
/* Revision 1.10  2002/04/22 14:45:51  stefano
/* Removed the SLL L undocumented instructions from the Graph library.
/* NEW startup=2 mode for the ZX81 (SLOW mode... hoping we'll make it work in the future).
/* MS Visual C compiler related fixes
/* -IXIY option on Z80ASM to swap the IX and IY registers
/*
/* Revision 1.9  2002/02/20 21:37:57  dom
/* merged in changes from rc1.4 branch to handle empty lines in list files
/*
/* Revision 1.8  2002/01/20 23:21:14  dom
/* branches:  1.8.2;
/* bumped version number and added prototype (from Dennis)
/*
/* Revision 1.7  2002/01/16 22:46:15  dom
/* removing my debugging printfs..
/*
/* Revision 1.6  2002/01/16 22:45:34  dom
/* if no module name is defined it now takes it from the filename after
/* stripping off the path and any extensions
/*
/* Revision 1.5  2001/04/24 08:54:34  dom
/* Added -h flag to print up usage, z80asm by itself just prints the
/* copyright message
/*
/* Revision 1.4  2001/03/21 16:34:01  dom
/* Added changes to allow labels to end in ':' and the prefix '.' isn't
/* necessarily needed..this isn't guaranteed to be perfect so let me know
/* of any problems and drop back to 1.0.18
/*
/* Revision 1.3  2001/02/28 17:59:22  dom
/* Added UNDEFINE for undefining symbols, bumped version to 1.0.18
/*
/* Revision 1.2  2001/01/23 10:00:09  dom
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
/* Revision 1.1  2000/07/04 15:33:29  dom
/* branches:  1.1.1;
/* Initial revision
/*
/* Revision 1.1.1.1  2000/07/04 15:33:29  dom
/* First import of z88dk into the sourceforge system <gulp>
/*
/* Revision 1.8.2.1  2002/02/20 21:35:19  dom
/* changes from dennis to handle blank lines in file list files
/*
/* */

/* $History: Z80ASM.C $ */
/*  */
/* *****************  Version 22  ***************** */
/* User: Gbs          Date: 30-01-00   Time: 12:49 */
/* Updated in $/Z80asm */
/* New option -M implemented, which defines arbitrary object file name */
/* extension. */
/*  */
/* *****************  Version 21  ***************** */
/* User: Gbs          Date: 26-01-00   Time: 22:12 */
/* Updated in $/Z80asm */
/* "V1.0.14" version text changes. */
/*  */
/* *****************  Version 20  ***************** */
/* User: Gbs          Date: 30-09-99   Time: 22:39 */
/* Updated in $/Z80asm */
/* CALL_PKG hard coded macro implemented for Garry Lancaster's Package */
/* System. */
/*  */
/* *****************  Version 18  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 20:07 */
/* Updated in $/Z80asm */
/* "PC" program counter changed to long (from unsigned short). */
/*  */
/* *****************  Version 16  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 12:13 */
/* Updated in $/Z80asm */
/* Added Ascii Art "Z80asm" at top of source file. */
/* '#' changed to '@' in default help page. */
/* ReportError() changed to display the platform specific MAXCODESIZE */
/* value when the maximum code generation size has been reached. */
/*  */
/* *****************  Version 11  ***************** */
/* User: Gbs          Date: 30-05-99   Time: 1:04 */
/* Updated in $/Z80asm */
/* Redundant system include files removed. */
/* Explicitly specified file source file extension automaticlly removed. */
/* Slight changes to default help page. */
/*  */
/* *****************  Version 10  ***************** */
/* User: Gbs          Date: 2-05-99    Time: 18:12 */
/* Updated in $/Z80asm */
/* New function, ReportIOError().  */
/* ReportError() improved to display to <stderr> when no error filename is */
/* available and to display the name of the module in which the error */
/* occurred (this is especially useful during linking errors). */
/*  */
/* *****************  Version 8  ***************** */
/* User: Gbs          Date: 17-04-99   Time: 0:30 */
/* Updated in $/Z80asm */
/* New GNU programming style C format. Improved ANSI C coding style */
/* eliminating previous compiler warnings. New -o option. Asm sources file */
/* now parsed even though any line feed standards (CR,LF or CRLF) are */
/* used. */
/*  */
/* *****************  Version 7  ***************** */
/* User: Gbs          Date: 7-03-99    Time: 13:14 */
/* Updated in $/Z80asm */
/* Program terminates with 1 if error occurs, otherwise 0 if all went OK. */
/* (Dominic Morris - djm@jb.man.ac.uk) */
/*  */
/* *****************  Version 5  ***************** */
/* User: Gbs          Date: 6-09-98    Time: 12:53 */
/* Updated in $/Z80asm */
/* -o logic replaced with -e<ext> option. This makes Z80asm completely */
/* configurable on which filename extension to use for source files. */
/*  */
/* *****************  Version 3  ***************** */
/* User: Gbs          Date: 4-09-98    Time: 0:11 */
/* Updated in $/Z80asm */
/* ".opt" source files now parsed in stead of ".asm" files using new -o */
/* option. */
/*  */
/* *****************  Version 2  ***************** */
/* User: Gbs          Date: 20-06-98   Time: 15:00 */
/* Updated in $/Z80asm */
/* SourceSafe Version  History comment block added. */
/* program version strings updated, "V1.0.3". */

/* All exit(-1) changed to exit(0) - djm 26/6/98 */
/* Cleaned up info so doesn't linewrap on Amiga */

/* Oops, screw up! exit(0) (was exit(-1))  should be exit(1) - djm 29/2/99 */

#include "memalloc.h"   /* before any other include to enable memory leak detection */

#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <ctype.h>
#include "config.h"
#include "symbol.h"
#include "symbols.h"
#include "z80asm.h"
#include "hist.h"
#include "options.h"
#include "errors.h"
#include "file.h"
#include "codearea.h"
#include "strutil.h"

/* external functions */
void RemovePfixlist( struct expr *pfixexpr );
void Z80pass1( void );
void Z80pass2( void );
void CreateLib( void );
void LinkModules( void );
void DeclModuleName( void );
void FreeSym( symbol *node );
void CreateDeffile( void );
void WriteGlobal( symbol *node );
void WriteMapFile( void );
void CreateBinFile( void );
struct sourcefile *Newfile( struct sourcefile *curfile, char *fname );
enum symbols GetSym( void );
long GetConstant( char *evalerr );
int cmpidstr( symbol *kptr, symbol *p );


/* local functions */
void prompt( void );
void WriteHeader( void );
void ReleaseFile( struct sourcefile *srcfile );
void ReleaseLibraries( void );
void ReleaseOwnedFile( struct usedfile *ownedfile );
void ReleaseModules( void );
void ReleaseExprns( struct expression *express );
void CloseFiles( void );
void AssembleSourceFile( void );
int TestAsmFile( void );
int GetModuleSize( void );
symbol *createsym( symbol *symptr );
struct module *NewModule( void );
struct libfile *NewLibrary( void );


FILE *z80asmfile, *listfile, *errfile, *objfile, *mapfile, *modsrcfile, *deffile, *libfile;

int      include_dir_num = 0;
char   **include_dir = NULL;
int      lib_dir_num = 0;
char   **lib_dir = NULL;

/* BUG_0001 array ssym[] needs to have one element per character in
 * separators, plus one newline to match the final '\0' just in case it is
 * not caught before */
enum symbols sym, ssym[] =
    {
        space, strconq, dquote, squote, semicolon, comma, fullstop,
        lparen, lcurly, lsquare, rsquare, rcurly, rparen, plus, minus, multiply, divi, mod, power,
        assign, bin_and, bin_or, bin_xor, less, greater, log_not, constexpr, colon, newline
    };
char separators[] = " &\"\';,.({[]})+-*/%^=~|:<>!#:";

enum flag pass1, writeline;
enum flag EOL, library, createlibrary;

int PAGENR, LINENR;
long TOTALLINES;
unsigned char PAGELEN;
int TAB_DIST = 8, COLUMN_WIDTH;
char line[255], stringconst[255], ident[FILENAME_MAX + 1];

/* CH_0005 : handle files as char[FILENAME_MAX] instead of strdup for every operation */
char srcfilename[FILENAME_MAX];
char lstfilename[FILENAME_MAX];
char objfilename[FILENAME_MAX];
char errfilename[FILENAME_MAX];
char libfilename[FILENAME_MAX];


char Z80objhdr[] = "Z80RMF01";
char objhdrprefix[] = "oomodnexprnamelibnmodc";
char Z80libhdr[] = "Z80LMF01";

unsigned char reloc_routine[] =
    "\x08\xD9\xFD\xE5\xE1\x01\x49\x00\x09\x5E\x23\x56\xD5\x23\x4E\x23"
    "\x46\x23\xE5\x09\x44\x4D\xE3\x7E\x23\xB7\x20\x06\x5E\x23\x56\x23"
    "\x18\x03\x16\x00\x5F\xE3\x19\x5E\x23\x56\xEB\x09\xEB\x72\x2B\x73"
    "\xD1\xE3\x2B\x7C\xB5\xE3\xD5\x20\xDD\xF1\xF1\xFD\x36\x00\xC3\xFD"
    "\x71\x01\xFD\x70\x02\xD9\x08\xFD\xE9";

size_t sizeof_relocroutine = 73;

char *reloctable = NULL, *relocptr = NULL;

long listfileptr;
unsigned short DEFVPC;          /* DEFVARS address counter */
size_t EXPLICIT_ORIGIN;         /* origin defined from command line */
time_t asmtime;                 /* time   of assembly in seconds */
char *date;                     /* pointer to datestring calculated from asmtime */

struct modules *modulehdr;
struct module *CURRENTMODULE;
struct liblist *libraryhdr;
avltree *globalroot, *staticroot;


void
AssembleSourceFile( void )
{
    /* try-catch to delete incomplete files in case of fatal error */
    try
    {
        if ( ( errfile = fopen( errfilename, "w" ) ) == NULL )
        {
            /* Create error file */
            ReportError( NULL, 0, ERR_FILE_OPEN, errfilename );
            throw( FatalErrorException, "cannot open errfile" );
        }

        if ( listing_CPY || symfile )
        {
            if ( ( listfile = fopen( lstfilename, "w+" ) ) != NULL )
            {
                /* Create LIST or SYMBOL file */
                PAGENR = 0;
                LINENR = 6;
                WriteHeader();                  /* Begin list file with a header */
                listfileptr = ftell( listfile ); /* Get file pos. of next line in list file */
            }
            else
            {
                ReportError( NULL, 0, ERR_FILE_OPEN, lstfilename );
                throw( FatalErrorException, "cannot open lstfile" );
            }
        }

        if ( ( objfile = fopen( objfilename, "w+b" ) ) != NULL )
        {
            /* Create relocatable object file */
            xfwritec( Z80objhdr,    strlen( Z80objhdr ),    objfile );
            xfwritec( objhdrprefix, strlen( objhdrprefix ), objfile );
        }
        else
        {
            ReportError( NULL, 0, ERR_FILE_OPEN, objfilename );
            throw( FatalErrorException, "cannot open objfile" );
        }

        set_PC( 0 );
        set_oldPC();
        copy( staticroot, &CURRENTMODULE->localroot, ( int ( * )( void *, void * ) ) cmpidstr, ( void * ( * )( void * ) ) createsym );

        /* Create standard 'ASMPC' identifier */
        DefineDefSym( ASSEMBLERPC, get_PC(), 0, &globalroot );

        if ( verbose )
        {
            printf( "Assembling '%s'...\nPass1...\n", srcfilename );
        }

        pass1 = ON;
        Z80pass1();
        pass1 = OFF;                    /* GetSymPtr will only generate page references in Pass1 (if listing is ON) */

        if ( CURRENTMODULE->mname == NULL )     /* Module name must be defined */
        {
            path_basename( ident, srcfilename );
            path_remove_ext( ident );
            strtoupper( ident );
            sym = name;
            DeclModuleName();
            /* ReportError (CURRENTFILE->fname, 0, ERR_MODULE_NOT_DEFINED); */
        }

        if ( ERRORS == 0 )
        {
            if ( verbose )
            {
                puts( "Pass2..." );
            }

            Z80pass2();
        }
    }

    finally
    {
        /*
         * Source file no longer needed (file could already have been closed, if fatal error occurred during INCLUDE
         * processing).
         */
        if ( z80asmfile != NULL )
        {
            fclose( z80asmfile );
            z80asmfile = NULL;
        }

        if ( listing_CPY || symfile )
        {
            fseek( listfile, 0, SEEK_END );
            xfputc( 12, listfile );     /* end listing with a FF */
            fclose( listfile );
            listfile = NULL;

            if ( ERRORS )
            {
                remove( lstfilename );    /* remove incomplete list file */
            }
        }

        fclose( objfile );
        objfile = NULL;

        if ( ERRORS )
        {
            remove( objfilename );    /* remove incomplete object file */
        }

        if ( errfile != NULL )
        {
            fclose( errfile );
            errfile = NULL;

            if ( ERRORS == 0 )
            {
                remove( errfilename );    /* remove empty error file */
            }
        }

        if ( globaldef )
        {
            xfputc( '\n', deffile );    /* separate DEFC lines for each module */
            inorder( globalroot, ( void ( * )( void * ) ) WriteGlobal );
        }

        deleteall( &CURRENTMODULE->localroot, ( void ( * )( void * ) ) FreeSym );
        deleteall( &CURRENTMODULE->notdeclroot, ( void ( * )( void * ) ) FreeSym );
        deleteall( &globalroot, ( void ( * )( void * ) ) FreeSym );
    }
}


void
CloseFiles( void )
{
    if ( z80asmfile != NULL )
    {
        fclose( z80asmfile );
    }

    if ( listfile != NULL )
    {
        fclose( listfile );
    }

    if ( objfile != NULL )
    {
        fclose( objfile );
    }

    if ( errfile != NULL )
    {
        fclose( errfile );
    }

    z80asmfile = listfile = objfile = errfile = NULL;
}


int
TestAsmFile( void )
{
    struct stat afile, ofile;

    if ( datestamp )
    {
        /* assemble only updated files */
        if ( stat( srcfilename, &afile ) == -1 )
        {
            return GetModuleSize();    /* source file not available... */
        }
        else if ( stat( objfilename, &ofile ) != -1 )
            if ( afile.st_mtime <= ofile.st_mtime )
            {
                return GetModuleSize();    /* source is older than object module */
            }
    }

    if ( ( z80asmfile = fopen( srcfilename, "rb" ) ) == NULL )
    {
        /* Open source file */
        ReportError( NULL, 0, ERR_FILE_OPEN, srcfilename );             /* Object module is not found or */
        return -1;              /* source is has recently been updated */
    }

    return 1;                   /* assemble if no datestamp check */
}



int
GetModuleSize( void )
{
    char fheader[9];
    long fptr_modcode, fptr_modname;
    size_t size;

    if ( ( objfile = fopen( objfilename, "rb" ) ) != NULL )
    {
        /* open relocatable object file */
        xfreadc( fheader, 8U, objfile );        /* read first 8 chars from file into array */
        fheader[8] = '\0';

        if ( strcmp( fheader, Z80objhdr ) != 0 )
        {
            /* compare header of file */
            ReportError( NULL, 0, ERR_NOT_OBJ_FILE, objfilename );      /* not an object file */
            fclose( objfile );
            objfile = NULL;
            return -1;
        }

        fseek( objfile, 8 + 2, SEEK_SET );              /* set file pointer to point at module name */
        fptr_modname = xfget_long( objfile );   /* get file pointer to module name */
        fseek( objfile, fptr_modname, SEEK_SET );       /* set file pointer to module name */

        size = xfgetc( objfile );
        xfreadc( line, size, objfile ); /* read module name */
        line[size] = '\0';
        CURRENTMODULE->mname = xstrdup( line );

        fseek( objfile, 26, SEEK_SET ); /* set file pointer to point at module code pointer */
        fptr_modcode = xfget_long( objfile );   /* get file pointer to module code */

        if ( fptr_modcode != -1 )
        {
            fseek( objfile, fptr_modcode, SEEK_SET );   /* set file pointer to module code */
            size = xfget_word( objfile );

            /* BUG_0008 : fix size, if a zero was written, the moudule is actually 64K */
            if ( size == 0 )
            {
                size = 0x10000;
            }

            if ( CURRENTMODULE->startoffset + size > MAXCODESIZE )
            {
                ReportError( objfilename, 0, ERR_MAX_CODESIZE );
            }
            else
            {
                inc_codesize( size );           /* BUG_0015 : was not updating codesize */
            }
        }

        fclose( objfile );
        return 0;
    }
    else
    {
        ReportError( NULL, 0, ERR_FILE_OPEN, objfilename );
        return -1;
    }
}


void
CreateLibfile( char *filename )
{
    size_t len;

    len = strlen( filename );

    if ( len )
    {
        path_replace_ext( libfilename, filename, FILEEXT_LIB );     /* add '.lib' extension */
    }
    else
    {
        if ( ( filename = getenv( "Z80_STDLIB" ) ) != NULL )
        {
            /* BUG_0002 - off by one alloc */
            libfilename[0] = '\0';              /* prepare for strncat */
            strncat( libfilename, filename, FILENAME_MAX - 1 );
        }
        else
        {
            ReportError( NULL, 0, ERR_ENV_NOT_DEFINED, "Z80_STDLIB" );
            return;
        }
    }

    if ( ( libfile = fopen( libfilename, "w+b" ) ) == NULL )
    {
        /* create library as BINARY file */
        ReportError( NULL, 0, ERR_OPEN_LIB, libfilename );
    }
    else
    {
        createlibrary = ON;
        xfwritec( Z80libhdr, 8U, libfile );     /* write library header */
    }
}


void
GetLibfile( char *filename )
{
    char            tempbuf[FILENAME_MAX + 1];
    struct libfile *newlib;
    char           *ptr;
    char           *ext = "";
    char *f, fheader[9];
    int len;

    newlib = NewLibrary();
    E4C_ASSERT( newlib != NULL );

    len = strlen( filename );

    if ( len )
    {
        if ( strcmp( filename + ( len - 4 ), FILEEXT_LIB ) != 0 )
        {
            ext = FILEEXT_LIB;
        }

        snprintf( tempbuf, sizeof( tempbuf ), "%s%s", filename, ext );

        ptr = SearchFile( tempbuf, 0 );

        f = xstrdup( ptr );
    }
    else
    {
        filename = getenv( "Z80_STDLIB" );

        if ( filename != NULL )
        {
            /* BUG_0002 - off by one alloc */
            f = xstrdup( filename );
        }
        else
        {
            ReportError( NULL, 0, ERR_ENV_NOT_DEFINED, "Z80_STDLIB" );
            return;
        }
    }

    newlib->libfilename = f;

    if ( ( z80asmfile = fopen( f, "rb" ) ) == NULL )
    {
        /* Does file exist? */
        ReportError( NULL, 0, ERR_OPEN_LIB, f );
        return;
    }
    else
    {
        xfreadc( fheader, 8U, z80asmfile );     /* read first 8 chars from file into array */
        fheader[8] = '\0';
    }

    if ( strcmp( fheader, Z80libhdr ) != 0 )            /* compare header of file */
    {
        ReportError( NULL, 0, ERR_NOT_LIB_FILE, f );    /* not a library file */
    }
    else
    {
        library = ON;
    }

    fclose( z80asmfile );
    z80asmfile = NULL;
}


/* CH_0004 : always returns non-NULL, ERR_NO_MEMORY is signalled by exception */
struct module *
NewModule( void )
{
    struct module *newm;

    if ( modulehdr == NULL )
    {
        modulehdr = xcalloc_struct( struct modules );
        modulehdr->first = NULL;
        modulehdr->last = NULL; /* Module header initialised */
    }

    newm = xcalloc_struct( struct module );

    newm->nextmodule = NULL;
    newm->mname = NULL;
    newm->startoffset = get_codesize();
    newm->origin = 65535;
    newm->cfile = NULL;
    newm->localroot = NULL;
    newm->notdeclroot = NULL;

    newm->mexpr = xcalloc_struct( struct expression );

    /* Allocate room for expression header */
    newm->mexpr->firstexpr = NULL;
    newm->mexpr->currexpr = NULL;
    /* Module expression header initialised */

    newm->JRaddr = xcalloc_struct( struct JRPC_Hdr );

    newm->JRaddr->firstref = NULL;
    newm->JRaddr->lastref = NULL;
    /* Module JRaddr list header initialised */

    if ( modulehdr->first == NULL )
    {
        modulehdr->first = newm;
        modulehdr->last = newm;         /* First module     in list   */
    }
    else
    {
        modulehdr->last->nextmodule = newm;     /* current/last module points now at new current */
        modulehdr->last = newm;                 /* pointer to current module updated */
    }

    return newm;
}


/* CH_0004 : always returns non-NULL, ERR_NO_MEMORY is signalled by exception */
struct libfile *
NewLibrary( void )
{
    struct libfile *newl;

    if ( libraryhdr == NULL )
    {
        libraryhdr = xcalloc_struct( struct liblist );
        libraryhdr->firstlib = NULL;
        libraryhdr->currlib = NULL;     /* Library header initialised */
    }

    newl = xcalloc_struct( struct libfile );
    newl->nextlib = NULL;
    newl->libfilename = NULL;
    newl->nextobjfile = -1;

    if ( libraryhdr->firstlib == NULL )
    {
        libraryhdr->firstlib = newl;
        libraryhdr->currlib = newl;     /* First library in list */
    }
    else
    {
        libraryhdr->currlib->nextlib = newl;    /* current/last library points now at new current */
        libraryhdr->currlib = newl;     /* pointer to current module updated */
    }

    return newl;
}



void
ReleaseModules( void )
{
    struct module *tmpptr, *curptr;
    struct JRPC *curJR, *prevJR;

    if ( modulehdr == NULL )
    {
        return;
    }

    /* if exception happened at first module creation, we may have a header an no modules
     * move while check to top of loop */
    curptr = modulehdr->first;

    while ( curptr != NULL )    /* until all modules are released */
    {
        if ( curptr->cfile != NULL )
        {
            ReleaseFile( curptr->cfile );
        }

        deleteall( &curptr->localroot, ( void ( * )( void * ) ) FreeSym );
        deleteall( &curptr->notdeclroot, ( void ( * )( void * ) ) FreeSym );

        if ( curptr->mexpr != NULL )
        {
            ReleaseExprns( curptr->mexpr );
        }

        /* BUG_0007 : memory leaks */
        if ( curptr->JRaddr != NULL )
        {
            curJR = curptr->JRaddr->firstref;

            while ( curJR )
            {
                prevJR = curJR;
                curJR = curJR->nextref; /* get ready for next JR instruction */
                xfree( prevJR );
            }

            xfree( curptr->JRaddr );
            curptr->JRaddr = NULL;
        }

        if ( curptr->mname != NULL )
        {
            xfree( curptr->mname );
        }

        tmpptr = curptr;
        curptr = curptr->nextmodule;
        xfree( tmpptr );       /* Release module */
    }

    xfree( modulehdr );
    modulehdr = NULL;
    CURRENTMODULE = NULL;
}



void
ReleaseLibraries( void )
{
    struct libfile *curptr, *tmpptr;

    curptr = libraryhdr->firstlib;

    while ( curptr != NULL )    /* while there are libraries */
    {
        if ( curptr->libfilename != NULL )
        {
            xfree( curptr->libfilename );
        }

        tmpptr = curptr;
        curptr = curptr->nextlib;
        xfree( tmpptr );       /* release library */
    }

    xfree( libraryhdr );       /* Release library header */
    libraryhdr = NULL;
}



void
ReleaseExprns( struct expression *express )
{
    struct expr *tmpexpr, *curexpr;

    curexpr = express->firstexpr;

    while ( curexpr != NULL )
    {
        tmpexpr = curexpr->nextexpr;
        RemovePfixlist( curexpr );
        curexpr = tmpexpr;
    }

    xfree( express );
}


void
ReleaseFile( struct sourcefile *srcfile )
{
    if ( srcfile->usedsourcefile != NULL )
    {
        ReleaseOwnedFile( srcfile->usedsourcefile );
    }

    xfree( srcfile->fname );   /* Release allocated area for filename */
    xfree( srcfile );          /* Release file information record for this file */
}


void
ReleaseOwnedFile( struct usedfile *ownedfile )
{
    /* Release first other files called by this file */
    if ( ownedfile->nextusedfile != NULL )
    {
        ReleaseOwnedFile( ownedfile->nextusedfile );
    }

    /* Release first file owned by this file */
    if ( ownedfile->ownedsourcefile != NULL )
    {
        ReleaseFile( ownedfile->ownedsourcefile );
    }

    xfree( ownedfile );        /* Then release this owned file */
}


void
display_options( void )
{
    if ( datestamp == ON )
    {
        puts( "Assemble only updated files." );
    }
    else
    {
        puts( "Assemble all files" );
    }

    if ( symfile == ON )
    {
        puts( "Create symbol table file." );
    }

    if ( listing == ON )
    {
        puts( "Create listing file." );
    }

    if ( globaldef == ON )
    {
        puts( "Create global definition file." );
    }

    if ( createlibrary == ON )
    {
        puts( "Create library from specified modules." );
    }

    if ( z80bin == ON )
    {
        puts( "Link/relocate assembled modules." );
    }

    if ( library == ON )
    {
        puts( "Link library modules with code." );
    }

    if ( z80bin == ON && mapref == ON )
    {
        puts( "Create address map file." );
    }

    if ( codesegment == ON && autorelocate == OFF )
    {
        puts( "Split code into 16K banks." );
    }

    if ( autorelocate == ON )
    {
        puts( "Create relocatable code." );
    }

    putchar( '\n' );
}


/***************************************************************************************************
 * Main entry of Z80asm
 ***************************************************************************************************/
int
main( int argc, char *argv[] )
{
    int asmflag;
    int    i;
    char  *ptr;
    int    include_level = 0;
    FILE  *includes[10];   /* 10 levels of inclusion should be enough */

    init_except();                      /* init exception mechanism */

    /* start try..catch with finally to cleanup any allocated memory */
    try
    {
        init_codearea_module();         /* init data for object file creation */


        writeline = ON;
        library = createlibrary = OFF;

        ResetOptions();
        ResetErrors();

        modsrcfile = NULL;
        CURRENTMODULE = NULL;
        modulehdr = NULL;               /* initialise to no modules */
        libraryhdr = NULL;              /* initialise to no library files */

        globalroot = NULL;              /* global identifier tree initialized */
        staticroot = NULL;              /* static identifier tree initialized */

        /* define OS_ID */
        DefineDefSym( OS_ID, 1, 0, &staticroot );

        /* Get command line arguments, if any... */
        if ( argc == 1 )
        {
            prompt();
            throw( FatalErrorException, "No arguments" );
        }

        time( &asmtime );
        date = asctime( localtime( &asmtime ) ); /* get current system time for date in list file */




        PAGELEN = 66;
        TOTALERRORS = 0;
        TOTALLINES = 0;

        CURRENTMODULE = NewModule();            /* then create a dummy module */
        /* this is needed during command line parsing */
        E4C_ASSERT( CURRENTMODULE != NULL );

        /* Setup some default search paths */
        i = include_dir_num++;
        include_dir = xrealloc( include_dir, include_dir_num * sizeof( include_dir[0] ) );
        include_dir[i] = xstrdup( "." );

        if ( ( ptr = getenv( "Z80_OZFILES" ) ) != NULL )
        {
            i = include_dir_num++;
            include_dir = xrealloc( include_dir, include_dir_num * sizeof( include_dir[0] ) );
            include_dir[i] = xstrdup( ptr );
        }

        i = lib_dir_num++;
        lib_dir = xrealloc( lib_dir, lib_dir_num * sizeof( lib_dir[0] ) );
        lib_dir[i] = xstrdup( "." );


        while ( --argc > 0 )
        {
            /* Get options first */
            ++argv;

            if ( ( *argv )[0] == '-' )
            {
                SetAsmFlag( ( ( *argv ) + 1 ) );
            }
            else
            {
                if ( ( *argv )[0] == '@' )
                    if ( ( modsrcfile = fopen( ( *argv + 1 ), "rb" ) ) == NULL )
                    {
                        ReportError( NULL, 0, ERR_FILE_OPEN, ( *argv + 1 ) );
                    }

                break;
            }
        }

        ReleaseModules();               /* Now remove dummy module again, not needed */

        if ( !argc && modsrcfile == NULL )
        {
            ReportError( NULL, 0, ERR_NO_SRC_FILE );
            throw( FatalErrorException, "no source file" );
        }

        COLUMN_WIDTH = 4 * TAB_DIST;    /* define column width   for output files */

        if ( verbose == ON )
        {
            display_options();    /* display status messages of select assembler options */
        }

        for ( ;; )
        {
            /* Module loop */
            z80asmfile = listfile = objfile = errfile = NULL;

            init_codearea();            /* Pointer (PC)     to store z80 instruction */
            ERRORS = 0;

            if ( modsrcfile == NULL )
            {
                if ( argc > 0 )
                {
                    if ( ( *argv )[0] != '-' )
                    {
                        ident[0] = '\0';                /* prepare for strncat */
                        strncat( ident, *argv, 254 );
                        --argc;
                        ++argv; /* get ready for next filename */
                    }
                    else
                    {
                        ReportError( NULL, 0, ERR_ILLEGAL_SRC_FILENAME, *argv ); /* Illegal source file name */
                        break;
                    }
                }
                else
                {
                    break;
                }
            }
            else
            {
again:
                ptr = Fetchfilename( modsrcfile );
                strcpy( ident, ptr );

                if ( strlen( ident ) == 0 )
                {
                    fclose( modsrcfile );

                    if ( include_level )
                    {
                        include_level--;
                        modsrcfile = includes[include_level];
                        goto again;
                    }

                    break;
                }
                else if ( ident[0] == '@' && include_level < sizeof( includes ) - 1 )
                {
                    includes[include_level++] = modsrcfile;

                    if ( ( modsrcfile = fopen( ident + 1, "rb" ) ) == NULL )
                    {
                        ReportError( NULL, 0, ERR_FILE_OPEN, ident + 1 );
                    }
                    else
                    {
                        goto again;
                    }
                }
            }

            path_replace_ext( srcfilename, ident, srcext );         /* set '.asm' extension */
            path_replace_ext( objfilename, ident, objext );         /* set '.obj' extension */
            path_replace_ext( errfilename, ident, FILEEXT_ERR );  /* set '.err' extension */
            path_replace_ext( lstfilename, ident,
                              listing ? FILEEXT_LST                  /* set '.lst' extension */
                              : FILEEXT_SYM );               /* set '.sym' extension */

            CURRENTMODULE = NewModule();                    /* Create module data structures for new file */
            E4C_ASSERT( CURRENTMODULE != NULL );

            CURRENTFILE = Newfile( NULL, srcfilename );   /* Create first file record */
            E4C_ASSERT( CURRENTFILE != NULL );

            if ( globaldef && CURRENTMODULE == modulehdr->first )
            {
                CreateDeffile();
            }

            if ( ( asmflag = TestAsmFile() ) == 1 )
            {
                AssembleSourceFile();   /* begin assembly... */

                if ( verbose )
                {
                    putchar( '\n' );    /* separate module texts */
                }
            }
            else if ( asmflag == -1 )
            {
                break;    /* file open error - stop assembler */
            }

        }                               /* for */

        CloseFiles();

        if ( globaldef )
        {
            fclose( deffile );
        }

        /* try-catch to delete lib file in case of error */
        try
        {
            if ( createlibrary && TOTALERRORS == 0 )
            {
                CreateLib();
            }
        }

        finally
        {
            if ( createlibrary )
            {
                fclose( libfile );

                if ( TOTALERRORS > 0 )
                {
                    remove( libfilename );
                }
            }
        }


        if ( ( TOTALERRORS == 0 ) && verbose )
        {
            printf( "Total of %ld lines assembled.\n", TOTALLINES );
        }

        if ( ( TOTALERRORS == 0 ) && z80bin )
        {
            LinkModules();
        }

        if ( ( TOTALERRORS == 0 ) && z80bin )
        {
            if ( mapref )
            {
                WriteMapFile();
            }

            CreateBinFile();
        }


    }

    /* catch and report fatal errors */
    catch ( NotEnoughMemoryException )
    {
        ReportError( NULL, 0, ERR_NO_MEMORY );
    }
    catch ( FileIOException )
    {
        ReportError( NULL, 0, ERR_FILE_IO );
    }
    catch ( FatalErrorException )
    {
        /* TOTALERRORS is already incremented */
    }
    catch ( RuntimeException )  /* catch all */
    {
        TOTALERRORS++;
    }

    /* cleanup all allocated memory */
    finally
    {
        CloseFiles();

#ifndef QDOS
        deleteall( &globalroot, ( void ( * )( void * ) ) FreeSym );
        deleteall( &staticroot, ( void ( * )( void * ) ) FreeSym );

        if ( modulehdr != NULL )
        {
            ReleaseModules();    /* Release module information (symbols, etc.) */
        }

        if ( libraryhdr != NULL )
        {
            ReleaseLibraries();    /* Release library information */
        }

        if ( autorelocate )
            if ( reloctable != NULL )
            {
                xfree( reloctable );
            }

        /* BUG_0007 : memory leaks */
        if ( include_dir )
        {
            int i;

            for ( i = 0; i < include_dir_num; i++ )
            {
                xfree( include_dir[i] );
            }

            xfree( include_dir );
        }

        include_dir = NULL;

        /* BUG_0007 : memory leaks */
        if ( lib_dir )
        {
            int i;

            for ( i = 0; i < lib_dir_num; i++ )
            {
                xfree( lib_dir[i] );
            }

            xfree( lib_dir );
        }

        lib_dir = NULL;
#endif
    }

    if ( TOTALERRORS > 0 )
    {
        ReportError( NULL, 0, ERR_TOTALERRORS );
        /* <djm>, if errors, then we really want to return an error number
         * surely?
         */
        return 1;
    }
    else
    {
        return 0;    /* assembler successfully ended */
    }
}

void
prompt( void )
{
    printf( "%s\n", copyrightmsg );
}

void
usage( void )
{
    printf( "%s\n", copyrightmsg );
    puts( "z80asm [options] [ @<modulefile> | {<filename>} ]" );
    puts( "[] = may be ignored. {} = may be repeated. | = OR clause." );
    printf( "To assemble 'fred%s' use 'fred' or 'fred%s'\n", FILEEXT_ASM, FILEEXT_ASM );
    puts( "<modulefile> contains file names of all modules to be linked:" );
    puts( "File names are put on separate lines ended with \\n. File types recognized or" );
    puts( "created by z80asm (defined by the following extension):" );
    printf( "%s = source file (default), or alternative -e<ext>\n", FILEEXT_ASM );
    printf( "%s = object file (default), or alternative -M<ext>\n", objext );
    printf( "%s = list file, %s = Z80 code file\n", FILEEXT_LST, FILEEXT_BIN );
    printf( "%s = symbols file, %s = map file, %s = XDEF file, %s = error file\n", FILEEXT_SYM, FILEEXT_MAP, FILEEXT_DEF, FILEEXT_ERR );
    puts( "Options: -n defines option to be turned OFF (except -r -R -i -x -D -t -o)" );
    printf( "-v verbose, -l listing file, -s symbol table, -m map listing file\n" );
    puts( "-r<ORG> Explicit relocation <ORG> defined in hex (ignore ORG in first module)" );
    puts( "-plus Interpret 'Invoke' as RST 28h" );
    puts( "-R Generate relocatable code (Automatical relocation before execution)" );
    puts( "-D<symbol> define symbol as logically TRUE (used for conditional assembly)" );
    puts( "-b assemble files & link to ORG address. -c split code in 16K banks" );
    puts( "-d date stamp control, assemble only if source file > object file" );
    puts( "-a: -b & -d (assemble only updated source files, then link & relocate)" );
    puts( "-o<bin filename> expl. output filename, -g XDEF reloc. addr. from all modules" );
    printf( "-i<library> include <library> LIB modules with %s modules during linking\n", objext );
    puts( "-x<library> create library from specified modules ( e.g. with @<modules> )" );
    printf( "-t<n> tabulator width for %s, %s, %s files. Column width is 4 times -t\n", FILEEXT_MAP, FILEEXT_DEF, FILEEXT_SYM );
    printf( "-I<path> additional path to search for includes\n" );
    printf( "-L<path> path to search for libraries\n" );
    puts( "Default options: -nv -nd -nb -nl -s -m -ng -nc -nR -t8" );
}


symbol *
createsym( symbol *symptr )
{
    return CreateSymbol( symptr->symname, symptr->symvalue, symptr->type, symptr->owner );
}


/** \brief Search for a filename in the include path
 *
 *  \param base - The filename to search for
 *
 *  \return Filename (static buffer)
 */
char *SearchFile( char *base, int is_include )
{
    static char  filename[FILENAME_MAX + 1];
    char       **paths = lib_dir;
    int          paths_num = lib_dir_num;
    struct stat  sb;
    int          i;

    if ( is_include )
    {
        paths = include_dir;
        paths_num = include_dir_num;
    }

    if ( stat( base, &sb ) == 0 )
    {
        snprintf( filename, sizeof( filename ), "%s", base );
        return filename;
    }

    for ( i = 0; i < paths_num; i++ )
    {
        snprintf( filename, sizeof( filename ), "%s/%s", paths[i], base );

        if ( stat( filename, &sb ) == 0 )
        {
            return filename;
        }
    }

    snprintf( filename, sizeof( filename ), "%s", base );
    return filename;
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

