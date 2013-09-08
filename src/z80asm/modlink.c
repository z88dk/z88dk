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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/modlink.c,v 1.70 2013-09-08 08:29:21 pauloscustodio Exp $ */
/* $Log: modlink.c,v $
/* Revision 1.70  2013-09-08 08:29:21  pauloscustodio
/* Replaced xmalloc et al with g_malloc0 et al.
/*
/* Revision 1.69  2013/09/08 00:43:59  pauloscustodio
/* New error module with one error function per error, no need for the error
/* constants. Allows compiler to type-check error message arguments.
/* Included the errors module in the init() mechanism, no need to call
/* error initialization from main(). Moved all error-testing scripts to
/* one file errors.t.
/*
/* Revision 1.68  2013/09/01 12:00:07  pauloscustodio
/* Cleanup compilation warnings
/*
/* Revision 1.67  2013/09/01 00:18:28  pauloscustodio
/* - Replaced e4c exception mechanism by a much simpler one based on a few
/*   macros. The former did not allow an exit(1) to be called within a
/*   try-catch block.
/*
/* Revision 1.66  2013/06/16 20:14:39  pauloscustodio
/* Move deffile writing to deffile.c, remove global variable deffile
/*
/* Revision 1.65  2013/06/15 00:26:23  pauloscustodio
/* Move mapfile writing to mapfile.c.
/*
/* Revision 1.64  2013/06/14 23:47:13  pauloscustodio
/* BUG_0036 : Map file does not show local symbols with the same name in different modules
/* If the same local symbol is defined in multiple modules, only one of
/* them appears in the map file.
/* "None." is written in map file if no symbols are defined.
/*
/* Revision 1.63  2013/06/14 22:14:36  pauloscustodio
/* find_local_symbol() and find_global_symbol() to encapsulate usage of get_global_tab()
/*
/* Revision 1.62  2013/06/11 23:16:06  pauloscustodio
/* Move symbol creation logic fromReadNames() in  modlink.c to symtab.c.
/* Add error message for invalid symbol and scope chars in object file.
/*
/* Revision 1.61  2013/06/08 23:37:32  pauloscustodio
/* Replace define_def_symbol() by one function for each symbol table type: define_static_def_sym(),
/*  define_global_def_sym(), define_local_def_sym(), encapsulating the symbol table used.
/* Define keywords for special symbols ASMPC, ASMSIZE, ASMTAIL
/*
/* Revision 1.60  2013/06/08 23:07:53  pauloscustodio
/* Add global ASMPC Symbol pointer, to avoid "ASMPC" symbol table lookup on every instruction.
/* Encapsulate get_global_tab() and get_static_tab() by using new functions define_static_def_sym()
/*  and define_global_def_sym().
/*
/* Revision 1.59  2013/06/01 01:24:22  pauloscustodio
/* CH_0022 : Replace avltree by hash table for symbol table
/*
/* Revision 1.58  2013/05/23 22:22:23  pauloscustodio
/* Move symbol to sym.c, rename to Symbol
/*
/* Revision 1.57  2013/05/06 23:02:12  pauloscustodio
/* BUG_0034 : If assembly process fails with fatal error, invalid library is kept
/* Option -x creates an empty library file (just the header). If the
/* assembly process fails with a fatal errror afterwards, the library file
/* is not deleted.
/*
/* Revision 1.56  2013/05/02 21:24:50  pauloscustodio
/* Cleanup assemble login
/* Removed global vars srcfilename, objfilename
/*
/* Revision 1.55  2013/04/07 23:34:19  pauloscustodio
/* CH_0020 : ERR_ORG_NOT_DEFINED if no ORG given
/* z80asm no longer asks for an ORG address from the standard input
/* if one is not given either by an ORG statement or a -r option;
/* it exists with an error message instead.
/* The old behaviour was causing wrong build scripts to hang waiting
/* for input.
/*
/* Revision 1.54  2013/04/06 13:15:04  pauloscustodio
/* Move default asm and obj extension handling to file.c.
/* srcfilename and objfilename are now pointers to static variables in file.c
/*
/* Revision 1.53  2013/04/04 23:24:18  pauloscustodio
/* Remove global variable errfilename
/*
/* Revision 1.52  2013/04/03 21:53:47  pauloscustodio
/* CreateDeffile() : no need to allocate file name dynamically, use a stack variable
/*
/* Revision 1.51  2013/03/31 13:49:41  pauloscustodio
/* ReadName(), ReadNames(), CheckIfModuleWanted(), LinkLibModules(), SearchLibFile()
/* were using global z80asmfile instead of a local FILE* variable - fixed
/*
/* Revision 1.50  2013/03/04 23:23:37  pauloscustodio
/* Removed writeline, that was used to cancel listing of multi-line
/* constructs, as only the first line was shown on the list file. Fixed
/* the problem in DEFVARS and DEFGROUP. Side-effect: LSTOFF line is listed.
/*
/* Revision 1.49  2013/02/19 22:52:40  pauloscustodio
/* BUG_0030 : List bytes patching overwrites header
/* BUG_0031 : List file garbled with input lines with 255 chars
/* New listfile.c with all the listing related code
/*
/* Revision 1.48  2013/02/12 00:55:00  pauloscustodio
/* CH_0017 : Align with spaces, deprecate -t option
/*
/* Revision 1.47  2013/01/24 23:03:03  pauloscustodio
/* Replaced (unsigned char) by (byte_t)
/* Replaced (unisigned int) by (size_t)
/* Replaced (short) by (int)
/*
/* Revision 1.46  2013/01/20 13:18:10  pauloscustodio
/* BUG_0024 : (ix+128) should show warning message
/* Signed integer range was wrongly checked to -128..255 instead
/* of -128..127
/*
/* Revision 1.45  2013/01/14 00:29:37  pauloscustodio
/* CH_0015 : integer out of range error replaced by warning
/*
/* Revision 1.44  2012/11/03 17:39:36  pauloscustodio
/* astyle, comments
/*
/* Revision 1.43  2012/06/14 15:01:27  pauloscustodio
/* Split safe strings from strutil.c to safestr.c
/*
/* Revision 1.42  2012/06/07 11:54:13  pauloscustodio
/* - Make mapfile static to module modlink.
/* - Remove modsrcfile, not used.
/* - GetModuleSize(): use local variable for file handle instead of objfile
/*
/* Revision 1.41  2012/05/29 21:00:35  pauloscustodio
/* BUG_0019 : z80asm closes a closed file handle, crash in Linux
/*
/* Revision 1.40  2012/05/26 18:51:10  pauloscustodio
/* CH_0012 : wrappers on OS calls to raise fatal error
/* CH_0013 : new errors interface to decouple calling code from errors.c
/*
/* Revision 1.39  2012/05/24 17:09:27  pauloscustodio
/* Unify copyright header
/*
/* Revision 1.38  2012/05/23 20:00:38  pauloscustodio
/* BUG_0017 : no error message if fails to create binary file chunk (option -c).
/* Replace ERR_FILE_OPEN by ERR_FOPEN_READ and ERR_FOPEN_WRITE.
/*
/* Revision 1.37  2012/05/20 06:39:27  pauloscustodio
/* astyle
/*
/* Revision 1.36  2012/05/20 06:02:09  pauloscustodio
/* Garbage collector
/* Added automatic garbage collection on exit and simple fence mechanism
/* to detect buffer underflow and overflow, to memalloc functions.
/* No longer needed to call init_malloc().
/* No longer need to try/catch during creation of memory structures to
/* free partially created data - all not freed data is freed atexit().
/* Renamed xfree0() to xfree().
/*
/* Revision 1.35  2012/05/20 05:31:18  pauloscustodio
/* Solve signed/unsigned mismatch warnings in symboltype, libtype: changed to char.
/*
/* Revision 1.34  2012/05/17 21:36:06  pauloscustodio
/* Remove global ASMERROR, redundant with TOTALERRORS.
/* Remove IllegalArgumentException, replace by FatalErrorException.
/*
/* Revision 1.33  2012/05/17 17:42:14  pauloscustodio
/* define_symbol() defined as void, a fatal error is
/* always raised on error.
/*
/* Revision 1.32  2012/05/11 19:29:49  pauloscustodio
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
/* Revision 1.31  2012/04/05 08:39:19  stefano
/* New reserved words, ASMTAIL and ASMSIZE, referring to the finally linked program block.
/* ASMTAIL could be a good starting point to determine automatically the heap position for malloc() or to insert a stack overflow protection in programs.
/* Note the in some case, after the program packaging, there are extra critical bytes to be preserved as well.
/*
/* Revision 1.30  2011/10/14 14:46:03  pauloscustodio
/* -  BUG_0013 : defm check for MAX_CODESIZE incorrect
/*  - Remove un-necessary tests for MAX_CODESIZE; all tests are concentrated in check_space() from codearea.c.
/*
/* Revision 1.29  2011/10/07 17:53:04  pauloscustodio
/* BUG_0015 : Relocation issue - dubious addresses come out of linking
/* (reported on Tue, Sep 27, 2011 at 8:09 PM by dom)
/* - Introduced in version 1.1.8, when the CODESIZE and the codeptr were merged into the same entity.
/* - This caused the problem because CODESIZE keeps track of the start offset of each module in the sequence they will appear in the object file, and codeptr is reset to the start of the codearea for each module.
/* The effect was that all address calculations at link phase were considering
/*  a start offset of zero for all modules.
/* - Moreover, when linking modules from a libary, the modules are pulled in to the code area as they are needed, and not in the sequence they will be in the object file. The start offset was being ignored and the modules were being loaded in the incorrect order
/* - Consequence of these two issues were all linked addresses wrong.
/*
/* Revision 1.28  2011/08/21 20:37:20  pauloscustodio
/* CH_0005 : handle files as char[FILENAME_MAX] instead of strdup for every operation
/* - Factor all pathname manipulation into module file.c.
/* - Make default extensions constants.
/* - Move asm_ext[] and obj_ext[] to the options.c module.
/*
/* Revision 1.27  2011/08/19 15:53:58  pauloscustodio
/* BUG_0010 : heap corruption when reaching MAXCODESIZE
/* - test for overflow of MAXCODESIZE is done before each instruction at parseline(); if only one byte is available in codearea, and a 2 byte instruction is assembled, the heap is corrupted before the exception is raised.
/* - Factored all the codearea-accessing code into a new module, checking for MAXCODESIZE on every write.
/*
/* Revision 1.26  2011/08/19 10:20:32  pauloscustodio
/* - Factored code to read/write word from file into fgetw_err/fputw_err.
/* - Renamed ReadLong/WriteLong to fgetl_err/fputl_err for symetry.
/*
/* Revision 1.25  2011/08/18 23:27:54  pauloscustodio
/* BUG_0009 : file read/write not tested for errors
/* - In case of disk full file write fails, but assembler does not detect the error
/*   and leaves back corruped object/binary files
/* - Created new exception FileIOException and ERR_FILE_IO error.
/* - Created new functions fputc_err, fgetc_err, ... to raise the exception on error.
/*
/* Revision 1.24  2011/08/18 21:46:54  pauloscustodio
/* BUG_0008 : code block of 64K is read as zero
/*
/* Revision 1.23  2011/08/15 17:12:31  pauloscustodio
/* Upgrade to Exceptions4c 2.8.9 to solve memory leak.
/*
/* Revision 1.22  2011/08/14 19:42:07  pauloscustodio
/* - LinkModules(), ModuleExpr(), CreateBinFile(), CreateLib(): throw the new exception FatalErrorException for fatal error ERR_FILE_OPEN
/*
/* Revision 1.21  2011/08/05 19:56:37  pauloscustodio
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
/* Replaced 'l' (lower case letter L) by 'len' - too easy to confuse with numeral '1'.
/*
/* Revision 1.20  2011/07/18 00:48:25  pauloscustodio
/* Initialize MS Visual Studio DEBUG build to show memory leaks on exit
/*
/* Revision 1.19  2011/07/14 01:32:08  pauloscustodio
/*     - Unified "Integer out of range" and "Out of range" errors; they are the same error.
/*     - Unified ReportIOError as ReportError(ERR_FILE_OPEN)
/*     CH_0003 : Error messages should be more informative
/*         - Added printf-args to error messages, added "Error:" prefix.
/*     BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
/*         - Raise ERR_UNBALANCED_PAREN instead
/*
/* Revision 1.18  2011/07/12 22:47:59  pauloscustodio
/* - Moved all error variables and error reporting code to a separate module errors.c,
/*   replaced all extern declarations of these variables by include errors.h,
/*   created symbolic constants for error codes.
/* - Added test scripts for error messages.
/*
/* Revision 1.17  2011/07/11 16:00:34  pauloscustodio
/* Moved all option variables and option handling code to a separate module options.c,
/* replaced all extern declarations of these variables by include options.h.
/* Created declarations in z80asm.h of objects defined in z80asm.c.
/*
/* Revision 1.16  2011/07/09 18:25:35  pauloscustodio
/* Log keyword in checkin comment was expanded inside Log expansion... recursive
/* Added Z80asm banner to all source files
/*
/* Revision 1.15  2011/07/09 17:36:09  pauloscustodio
/* Copied cvs log into Log history
/*
/* Revision 1.14  2011/07/09 01:46:00  pauloscustodio
/* Added Log keyword
/*
/* Revision 1.13  2011/07/09 01:20:55  pauloscustodio
/* added casts to clean up warnings
/*
/* Revision 1.12  2010/09/19 02:37:57  dom
/* 64bit issue
/*
/* Revision 1.11  2010/09/19 00:06:20  dom
/* Tweaks for compiling code generated by sdcc - it generates XREF rather than
/* LIB so treat XREF as a LIB (this possibly should be the default)
/*
/* Do some _ mapping magic when in sdcc so standard z88dk libs can be used
/* (wrong _ convention chosen a long time ago...)
/*
/* Have -forcexlib flag which treats MODULE as XLIB.
/*
/* Revision 1.10  2010/04/16 17:34:37  dom
/* Make line number an int - 32768 lines isn't big enough...
/*
/* Revision 1.9  2009/09/28 23:14:13  dom
/* Get the length of the right name.
/*
/* Revision 1.8  2009/09/03 17:42:12  dom
/* Remove endian reading kludge and make work on 64 bit
/*
/* Revision 1.7  2009/08/14 22:23:12  dom
/* clean up some compiler warnings
/*
/* Revision 1.6  2009/07/23 20:35:14  dom
/* Get the end position right here as well
/*
/* Revision 1.5  2009/07/17 22:06:48  dom
/* Experimental code to allow a LIB directive to refer to a globally exported
/* symbol from a module.
/*
/* Should provide a better way of doing the ASMDISP stuff.
/*
/* Revision 1.4  2002/11/05 11:45:56  dom
/* powerpc endian detection
/*
/* fix for 64 bit machines, sizeof(long) != 4
/*
/* Revision 1.3  2002/10/22 19:21:10  dom
/* that shouldn't have been committed (oops)
/*
/* Revision 1.2  2002/10/22 19:15:28  dom
/* Makefile changes to use $(RM) instead of rm
/*
/* Revision 1.1  2000/07/04 15:33:30  dom
/* branches:  1.1.1;
/* Initial revision
/*
/* Revision 1.1.1.1  2000/07/04 15:33:30  dom
/* First import of z88dk into the sourceforge system <gulp>
/*
/* */

/* $History: MODLINK.C $ */
/*  */
/* *****************  Version 16  ***************** */
/* User: Gbs          Date: 26-01-00   Time: 22:10 */
/* Updated in $/Z80asm */
/* Expression range validation removed from 8bit unsigned (redundant). */
/*  */
/* *****************  Version 14  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 20:06 */
/* Updated in $/Z80asm */
/* "PC" program counter changed to long (from unsigned short). */
/*  */
/* *****************  Version 12  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 12:12 */
/* Updated in $/Z80asm */
/* Added Ascii Art "Z80asm" at top of source file. */
/*  */
/* *****************  Version 10  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 11:30 */
/* Updated in $/Z80asm */
/* "config.h" included before "symbol.h" */
/*  */
/* *****************  Version 9  ***************** */
/* User: Gbs          Date: 30-05-99   Time: 1:00 */
/* Updated in $/Z80asm */
/* Redundant system include files removed. */
/* Createlib() rewritten to replace low I/O open() with fopen() and */
/* fread(). */
/*  */
/* *****************  Version 8  ***************** */
/* User: Gbs          Date: 2-05-99    Time: 18:06 */
/* Updated in $/Z80asm */
/* File IO errors now handled through new ReportIOError() function. */
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
/* User: Gbs          Date: 7-03-99    Time: 13:13 */
/* Updated in $/Z80asm */
/* Minor changes to keep C compiler happy. */
/*  */
/* *****************  Version 3  ***************** */
/* User: Gbs          Date: 4-09-98    Time: 0:10 */
/* Updated in $/Z80asm */
/* Various changes by Dominic Morris (ENDIAN #if). */
/*  */
/* *****************  Version 2  ***************** */
/* User: Gbs          Date: 20-06-98   Time: 15:10 */
/* Updated in $/Z80asm */
/* SourceSafe Version History Comment Block added. */

/* ifdef QDOS changed to ifdef ENDIAN to sort ENDIAN djm 26/6/98 */

#include "memalloc.h"   /* before any other include */

#include "codearea.h"
#include "config.h"
#include "errors.h"
#include "file.h"
#include "listfile.h"
#include "options.h"
#include "safestr.h"
#include "strpool.h"
#include "strutil.h"
#include "sym.h"
#include "symbol.h"
#include "except.h"
#include "z80asm.h"
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* external functions */
void RemovePfixlist( struct expr *pfixexpr );
struct module *NewModule( void );
struct libfile *NewLibrary( void );
struct sourcefile *Newfile( struct sourcefile *curfile, char *fname );
long EvalPfixExpr( struct expr *pass2expr );
int GetChar( FILE *fptr );
struct expr *ParseNumExpr( void );

/* local functions */
int LinkModule( char *filename, long fptr_base );
int LinkTracedModule( char *filename, long baseptr );
int LinkLibModules( char *objfilename, long fptr_base, long startnames, long endnames );
int LinkLibModule( struct libfile *library, long curmodule, char *modname );
int SearchLibfile( struct libfile *curlib, char *modname );
char *ReadName( FILE *file );
void redefinedmsg( void );
void CreateLib( char *lib_filename );
void SearchLibraries( char *modname );
void LinkModules( void );
void ModuleExpr( void );
void CreateBinFile( void );
void ReadNames( char *filename, FILE *file, long nextname, long endnames );
void ReadExpr( long nextexpr, long endexpr );
void ReleaseLinkInfo( void );
static char *CheckIfModuleWanted( FILE *file, long currentlibmodule, char *modname );

/* global variables */
extern FILE *z80asmfile;
extern char line[], ident[];
extern char Z80objhdr[];
extern char Z80libhdr[];
extern enum symbols sym, GetSym( void );
extern enum flag EOL, library;
extern byte_t reloc_routine[];
extern struct liblist *libraryhdr;
extern struct module *CURRENTMODULE;
extern char *reloctable, *relocptr;

struct linklist *linkhdr;
struct libfile *CURRENTLIB;
size_t totaladdr, curroffset;

void
ReadNames( char *filename, FILE *file, long nextname, long endnames )
{
    char scope, symbol_char;
	byte_t symboltype = 0;
    long value;

    do
    {
        scope = fgetc_err( file );
        symbol_char = fgetc_err( file ); /* type of name   */
        value = fgetl_err( file );		/* read symbol (long) integer */
        ReadName( file );				/* read symbol name */

        nextname += 1 + 1 + 4 + 1 + strlen( line );

        switch ( symbol_char )
        {
            case 'A':
                symboltype = SYMADDR;
                value += modulehdr->first->origin + CURRENTMODULE->startoffset;       /* Absolute address */
                break;

            case 'C':
                symboltype = 0;
                break;

			default:
				error_not_obj_file( filename );
        }

        switch ( scope )
        {
            case 'L':
				define_local_sym( line, value, symboltype );
				break;

            case 'G':
				define_global_sym( line, value, symboltype );
				break;

            case 'X':
				define_library_sym( line, value, symboltype );
				break;

			default:
				error_not_obj_file( filename );
		}
    }
    while ( nextname < endnames );
}



void
ReadExpr( long nextexpr, long endexpr )
{
    char type;
    long constant, i, fptr;
    struct expr *postfixexpr;
    size_t patchptr, offsetptr;

    do
    {
        type = fgetc_err( z80asmfile );
        offsetptr = fgetw_err( z80asmfile );

        /* assembler PC     as absolute address */
        set_PC( modulehdr->first->origin + CURRENTMODULE->startoffset + offsetptr );

        ASMPC->value = get_PC();

        i = fgetc_err( z80asmfile ); /* get length of infix expression */
        fptr = ftell( z80asmfile );       /* file pointer is at start of expression */
        fgets( line, i + 1, z80asmfile ); /* read string for error reference */
        fseek( z80asmfile, fptr, SEEK_SET );      /* reset file pointer to start of expression */
        nextexpr += 1 + 1 + 1 + 1 + i + 1;


        EOL = OFF;                /* reset end of line parsing flag - a line is to be parsed... */

        GetSym();

        if ( ( postfixexpr = ParseNumExpr() ) != NULL )
        {
            /* parse numerical expression */
            if ( postfixexpr->rangetype & NOTEVALUABLE )
            {
                error_not_defined_expr( line );
            }
            else
            {
                constant = EvalPfixExpr( postfixexpr );
                patchptr = CURRENTMODULE->startoffset + offsetptr;        /* index to memory buffer */

                switch ( type )
                {
                    case 'U':
                        if ( constant < -128 || constant > 255 )
							warn_int_range_expr( constant, line );

                        patch_byte( &patchptr, (byte_t) constant );
                        break;

                    case 'S':
                        if ( constant < -128 || constant > 127 )
							warn_int_range_expr( constant, line );

						patch_byte( &patchptr, (byte_t) constant );    /* opcode is stored, now store signed 8bit value */
                        break;

                    case 'C':
                        if ( constant < -32768 || constant > 65535 )
                            warn_int_range_expr( constant, line );

						patch_word( &patchptr, constant );

                        if ( autorelocate )
                            if ( postfixexpr->rangetype & SYMADDR )
                            {
                                /* Expression contains relocatable address */
                                constant = get_PC() - curroffset;

                                if ( ( constant >= 0 ) && ( constant <= 255 ) )
                                {
                                    *relocptr++ = (byte_t) constant;
                                    sizeof_reloctable++;
                                }
                                else
                                {
                                    *relocptr++ = 0;
                                    *relocptr++ = (size_t)( get_PC() - curroffset ) % 256U;
                                    *relocptr++ = (size_t)( get_PC() - curroffset ) / 256U;
                                    sizeof_reloctable += 3;
                                }

                                totaladdr++;
                                curroffset = (size_t)get_PC();
                            }

                        break;

                    case 'L':
                        if ( constant < LONG_MIN || constant > LONG_MAX )
                            warn_int_range_expr( constant, line );

						patch_long( &patchptr, constant );
                        break;
                }
            }

            RemovePfixlist( postfixexpr );
        }
        else
        {
            error_expr( line );
        }
    }
    while ( nextexpr < endexpr );
}



void
LinkModules( void )
{
    char fheader[9];
    size_t origin;
    struct module *lastobjmodule;
	char *obj_filename;

    option_symtable = listing = OFF;
    linkhdr = NULL;

    if ( verbose )
    {
        puts( "linking module(s)...\nPass1..." );
    }

    if ( autorelocate == ON )
    {
        reloctable = ( char * ) g_malloc0( 32768U );
        relocptr = reloctable;
        relocptr += 4;  /* point at first offset to store */
        totaladdr = 0;
        sizeof_reloctable = 0;  /* relocation table, still 0 elements .. */
        curroffset = 0;
    }
    else
    {
        reloctable = NULL;
    }

    TRY
    {
        CURRENTMODULE = modulehdr->first;       /* begin with first module */
        lastobjmodule = modulehdr->last;        /* remember this last module, further modules are libraries */

        /* open error file */
        open_error_file( err_filename_ext( CURRENTFILE->fname ) );

        set_PC( 0 );
        ASMPC = define_global_def_sym( ASMPC_KW, get_PC() );  /* Create standard 'ASMPC' identifier */

        do                                      /* link machine code & read symbols in all modules */
        {
            set_error_null();
            set_error_module( CURRENTMODULE->mname );

            if ( library )
            {
                CURRENTLIB = libraryhdr->firstlib;      /* begin library search  from first library for each
                                                        * module */
                CURRENTLIB->nextobjfile = 8;            /* point at first library module (past header) */
            }

            CURRENTFILE->line = 0;              /* no line references on errors during link processing */

            if ( !clinemode )
            {
                set_error_line( CURRENTFILE->line );    /* error location */
            }

            /* overwrite '.asm' extension with * '.obj' */
            obj_filename = obj_filename_ext( CURRENTFILE->fname );

            /* open relocatable file for reading */
            z80asmfile = fopen_err( obj_filename, "rb" );           /* CH_0012 */
            freadc_err( fheader, 8U, z80asmfile );             /* read first 6 chars from file into array */
            fheader[8] = '\0';

            /* compare header of file */
            if ( strcmp( fheader, Z80objhdr ) != 0 )
            {
                error_not_obj_file( obj_filename );  /* not a object     file */
                fclose( z80asmfile );
                z80asmfile = NULL;
                break;
            }

            origin = fgetw_err( z80asmfile );

            if ( modulehdr->first == CURRENTMODULE )            /* origin of first module */
            {
                if ( autorelocate )
                {
                    CURRENTMODULE->origin = 0;    /* ORG 0 on auto relocation */
                }
                else
                {
                    if ( deforigin )
                    {
                        CURRENTMODULE->origin = EXPLICIT_ORIGIN;    /* use origin from command line    */
                    }
                    else
                    {
                        CURRENTMODULE->origin = origin;

                        if ( CURRENTMODULE->origin == 65535U )
                        {
							error_org_not_defined();  /* no ORG */
							fclose( z80asmfile );
							z80asmfile = NULL;
							break;
                        }
                    }
                }

                if ( verbose == ON )
                {
                    printf( "ORG address for code is %04lX\n", CURRENTMODULE->origin );
                }
            }

            fclose( z80asmfile );
            z80asmfile = NULL;

            LinkModule( obj_filename, 0 );       /* link code & read name definitions */

            CURRENTMODULE = CURRENTMODULE->nextmodule;  /* get next module, if any */

        }
        while ( CURRENTMODULE != lastobjmodule->nextmodule );

        /* parse only object modules, not added library modules */

        set_error_null();

        define_global_def_sym( ASMSIZE_KW, get_codesize() );
        define_global_def_sym( ASMTAIL_KW, modulehdr->first->origin + get_codesize() );

        if ( verbose == ON )
        {
            printf( "Code size of linked modules is %d bytes\n", ( int )get_codesize() );
        }

        if ( ! get_num_errors() )
        {
            ModuleExpr();               /*  Evaluate expressions in  all modules */
        }

    }
    FINALLY
    {
        set_error_null();

        ReleaseLinkInfo();              /* Release module link information */

        close_error_file();
    }
	ETRY;
}




int
LinkModule( char *filename, long fptr_base )
{
    long fptr_namedecl, fptr_modname, fptr_modcode, fptr_libnmdecl;
    size_t size;
    int flag = 0;

    /* open object file for reading */
    z80asmfile = fopen_err( filename, "rb" );           /* CH_0012 */
    fseek( z80asmfile, fptr_base + 10U, SEEK_SET );

    fptr_modname = fgetl_err( z80asmfile );              /* get file pointer to module name */
    fgetl_err( z80asmfile );                     /* get file pointer to expression declarations */
    fptr_namedecl = fgetl_err( z80asmfile );     /* get file pointer to name declarations */
    fptr_libnmdecl = fgetl_err( z80asmfile );    /* get file pointer to library name declarations */
    fptr_modcode = fgetl_err( z80asmfile );              /* get file pointer to module code */

    if ( fptr_modcode != -1 )
    {
        fseek( z80asmfile, fptr_base + fptr_modcode, SEEK_SET );  /* set file pointer to module code */

        size = fgetw_err( z80asmfile );

        /* BUG_0008 : fix size, if a zero was written, the moudule is actually 64K */
        if ( size == 0 )
        {
            size = 0x10000;
        }

        /* read module code at startoffset of the module */
        /* BUG_0015: was reading at current position in code area, swaping order of modules */
        fread_codearea_offset( z80asmfile, CURRENTMODULE->startoffset, size );

        /* BUG_0015 : was no updating codesize */
        if ( CURRENTMODULE->startoffset == get_codesize() )
        {
            inc_codesize( size );    /* a new module has been added */
        }

    }

    if ( fptr_namedecl != -1 )
    {
        fseek( z80asmfile, fptr_base + fptr_namedecl, SEEK_SET );  /* set file pointer to point at name
                                                                 * declarations */

        if ( fptr_libnmdecl != -1 )
        {
            ReadNames( filename, z80asmfile, fptr_namedecl, fptr_libnmdecl );    /* Read symbols until library declarations */
        }
        else
        {
            ReadNames( filename, z80asmfile, fptr_namedecl, fptr_modname );    /* Read symbol suntil module name */
        }
    }

    fclose( z80asmfile );
    z80asmfile = NULL;

    if ( fptr_libnmdecl != -1 )
    {
        if ( library )
        {
            /* search in libraries, if present */
            flag = LinkLibModules( filename, fptr_base, fptr_libnmdecl, fptr_modname );   /* link library modules */

            if ( !flag )
            {
                return 0;
            }
        }
    }

    return LinkTracedModule( filename, fptr_base );       /* Remember module for pass2 */
}




int
LinkLibModules( char *filename, long fptr_base, long nextname, long endnames )
{
    long len;
    char *modname;
	FILE *file;

    do
    {
        /* open object file for reading */
        file = fopen_err( filename, "rb" );           /* CH_0012 */
        fseek( file, fptr_base + nextname, SEEK_SET );       /* set file pointer to point at library name
                                                             * declarations */
        ReadName( file );					/* read library reference name */
        fclose( file );

        len = strlen( line );
        nextname += 1 + len;      /* remember module pointer to next name in this   object module */

        if ( find_global_symbol( line ) == NULL )
        {
            modname = g_strdup( line );

            TRY
            {
                SearchLibraries( modname );       /* search name in libraries */
            }
            FINALLY
            {
                g_free( modname ); /* remove copy of module name */
            }
			ETRY;
        }
    }
    while ( nextname < endnames );

    return 1;
}




void
SearchLibraries( char *modname )
{

    int i;


    for ( i = 0; i < 2; i++ )
    {
        /* Libraries searched in max. 2 passes */
        while ( CURRENTLIB != NULL )
        {
            if ( SearchLibfile( CURRENTLIB, modname ) )
            {
                return;
            }

            CURRENTLIB = CURRENTLIB->nextlib;

            if ( CURRENTLIB != NULL )
                if ( CURRENTLIB->nextobjfile != 8 )
                {
                    CURRENTLIB->nextobjfile = 8;    /* search at start of next lib */
                }
        }

        /* last library read ... */
        CURRENTLIB = libraryhdr->firstlib;        /* start at the beginning of the first module */
        CURRENTLIB->nextobjfile = 8;              /* in the first library */
    }
}



int
SearchLibfile( struct libfile *curlib, char *modname )
{
    long currentlibmodule, modulesize;
    int ret = 0;
    char *mname;
	FILE *file;

    file = fopen_err( curlib->libfilename, "rb" );           /* CH_0012 */

    while ( curlib->nextobjfile != -1 )
    {
        /* search name in all available library modules */
        do
        {
            /* point at first available module in library */
            fseek( file, curlib->nextobjfile, SEEK_SET );   /* point at beginning of a module */
            currentlibmodule = curlib->nextobjfile;
            curlib->nextobjfile = fgetl_err( file ); /* get file pointer to next module in library */
            modulesize = fgetl_err( file ); /* get size of current module */
        }
        while ( modulesize == 0 && curlib->nextobjfile != -1 );

        if ( modulesize != 0 )
        {
            if ( ( mname = CheckIfModuleWanted( file, currentlibmodule, modname ) ) != NULL )
            {
                TRY
                {
                    fclose( file );
                    ret =  LinkLibModule( curlib, currentlibmodule + 4 + 4, mname );
                }
                FINALLY
                {
                    g_free( mname );
                }
				ETRY;

                return ret;
            }
            else if ( sdcc_hacks == ON && modname[0] == '_' && ( mname = CheckIfModuleWanted( file, currentlibmodule, modname + 1 ) ) != NULL )
            {
                TRY
                {
                    fclose( file );
                    ret =  LinkLibModule( curlib, currentlibmodule + 4 + 4, mname );
                }
                FINALLY
                {
                    g_free( mname );
                }
				ETRY;

                return ret;
            }
        }
    }

    fclose( file );
    return 0;
}


/** \brief Check to see if a library module is required
 *
 *  \param z80asmfile - File to read from
 *  \param currentlibmodule - Current offset in file
 *  \param modname - Module/symbol to search for

 */
static char *
CheckIfModuleWanted( FILE *file, long currentlibmodule, char *modname )
{
    long fptr_mname, fptr_expr, fptr_name, fptr_libname;
    char *mname;
    char *name;
    enum flag found = OFF;


    /* found module name? */
    fseek( file, currentlibmodule + 4 + 4 + 8 + 2, SEEK_SET );     /* point at module name  file
                                                                        * pointer */
    fptr_mname = fgetl_err( file );      /* get module name file  pointer   */
    fptr_expr = fgetl_err( file );
    fptr_name = fgetl_err( file );
    fptr_libname = fgetl_err( file );
    fseek( file, currentlibmodule + 4 + 4 + fptr_mname, SEEK_SET );       /* point at module name  */
    mname = g_strdup( ReadName( file ) );                      /* read module name */

    if ( strcmp( mname, modname ) == 0 )
    {
        found = ON;
    }
    else
    {
        /* We didn't find the module name, lets have a look through the exported symbol list */
        if ( fptr_name != 0 )
        {
            long end = fptr_libname;
            long red = 0;

            if ( fptr_libname == -1 )
            {
                end = fptr_mname;
            }

            /* Move to the name section */
            fseek( file, currentlibmodule + 4 + 4 + fptr_name, SEEK_SET );
            red = fptr_name;

            while ( ! found && red < end )
            {
                char scope, type;
                long temp;

                scope = fgetc_err( file );
                red++;
                type = fgetc_err( file );
                red++;
                temp = fgetl_err( file );
                red += 4;
                name = ReadName( file );
                red += strlen( name );
                red++; /* Length byte */

                if ( ( scope == 'X' || scope == 'G' ) && strcmp( name, modname ) == 0 )
                {
                    found = ON;
                }
            }
        }
    }

    if ( !found )
    {
        g_free( mname );
        mname = NULL;
    }

    return mname;
}

int
LinkLibModule( struct libfile *library, long curmodule, char *modname )
{
    struct module *tmpmodule;
    int flag;

    tmpmodule = CURRENTMODULE;  /* remember current module */

    CURRENTMODULE = NewModule();
    CURRENTMODULE->mname = g_strdup( modname );  /* get a copy of module name */
    /* create new module for library */
    CURRENTFILE = Newfile( NULL, library->libfilename ); /* filename for 'module' */

    if ( verbose )
    {
        printf( "Linking library module <%s>\n", modname );
    }

    flag = LinkModule( library->libfilename, curmodule );       /* link   module & read names */

    CURRENTMODULE = tmpmodule;  /* restore previous current module */
    return flag;
}



char *
ReadName( FILE *file )
{
    size_t strlength;

    strlength = fgetc_err( file );
    freadc_err( line, strlength, file ); /* read   name */
    line[strlength] = '\0';

    return line;
}



void
ModuleExpr( void )
{
    long fptr_namedecl, fptr_modname, fptr_exprdecl, fptr_libnmdecl;
    long fptr_base;
    struct linkedmod *curlink;

    if ( verbose )
    {
        puts( "Pass2..." );
    }

    curlink = linkhdr->firstlink;

    do
    {
        CURRENTMODULE = curlink->moduleinfo;
        fptr_base = curlink->modulestart;

        set_error_null();
        set_error_module( CURRENTMODULE->mname );
        set_error_file( CURRENTFILE->fname );

        /* open relocatable file for reading */
        z80asmfile = fopen_err( curlink->objfilename, "rb" );           /* CH_0012 */
        fseek( z80asmfile, fptr_base + 10, SEEK_SET );        /* point at module name  pointer   */
        fptr_modname = fgetl_err( z80asmfile );              /* get file pointer to module name */
        fptr_exprdecl = fgetl_err( z80asmfile );     /* get file pointer to expression declarations */
        fptr_namedecl = fgetl_err( z80asmfile );     /* get file pointer to name declarations */
        fptr_libnmdecl = fgetl_err( z80asmfile );    /* get file pointer to library name declarations */

        if ( fptr_exprdecl != -1 )
        {
            fseek( z80asmfile, fptr_base + fptr_exprdecl, SEEK_SET );

            if ( fptr_namedecl != -1 )
            {
                ReadExpr( fptr_exprdecl, fptr_namedecl );	/* Evaluate until beginning of name declarations */
            }    
            else if ( fptr_libnmdecl != -1 )
            {
                ReadExpr( fptr_exprdecl, fptr_libnmdecl );	/* Evaluate until beginning of library reference declarations */
            }   
            else
            {
                ReadExpr( fptr_exprdecl, fptr_modname );    /* Evaluate until beginning of module name */
            }
        }

        fclose( z80asmfile );
        z80asmfile = NULL;

        curlink = curlink->nextlink;
    }
    while ( curlink != NULL );

    set_error_null();
}



void
CreateBinFile( void )
{
    FILE *binaryfile;
    size_t codesize, codeblock, offset;
    SSTR_DEFINE( filename, FILENAME_MAX );

    if ( expl_binflnm == ON )
        /* use predined output filename from command line */
    {
        sstr_set( filename, binfilename );
    }
    else
    {
        /* create output filename, based on project filename */
        /* get source filename from first module */
        sstr_set( filename, modulehdr->first->cfile->fname );
        path_remove_ext( sstr_data( filename ) );
        sstr_sync_len( filename );

        if ( codesegment == ON && get_codesize() > 16384 )
        {
            sstr_cat( filename, FILEEXT_SEGBIN );   /* add '.bn0' extension */
        }
        else
        {
            sstr_cat( filename, FILEEXT_BIN );      /* add '.bin' extension */
        }
    }

    /* binary output to filename.bin */
    binaryfile = fopen_err( sstr_data( filename ), "wb" );         /* CH_0012 */

    if ( autorelocate == ON && totaladdr != 0 )
    {
        fwritec_err( reloc_routine, sizeof_relocroutine, binaryfile );   /* relocate routine */
        *( reloctable + 0 ) = (size_t) totaladdr % 256U;
        *( reloctable + 1 ) = (size_t) totaladdr / 256U;    /* total of relocation elements */
        *( reloctable + 2 ) = (size_t) sizeof_reloctable % 256U;
        *( reloctable + 3 ) = (size_t) sizeof_reloctable / 256U; /* total size of relocation table elements */

        fwritec_err( reloctable, sizeof_reloctable + 4, binaryfile );    /* write relocation table, inclusive 4 byte header */
        printf( "Relocation header is %d bytes.\n", ( int )( sizeof_relocroutine + sizeof_reloctable + 4 ) );
        fwrite_codearea( binaryfile );                                /* write code as one big chunk */
        fclose( binaryfile );
        binaryfile = NULL;
    }
    else if ( codesegment == ON && get_codesize() > 16384 )
    {
        fclose( binaryfile );
        binaryfile = NULL;
        offset = 0;
        codesize = get_codesize();

        do
        {
            codeblock = ( codesize > 16384U ) ? 16384U : codesize;
            codesize -= codeblock;
            binaryfile = fopen_err( sstr_data( filename ), "wb" );         /* CH_0012 */
            fwrite_codearea_chunk( binaryfile, offset, codeblock ); /* code in 16K chunks */
            fclose( binaryfile );
            binaryfile = NULL;

            offset += codeblock;
            ++(sstr_data( filename )[sstr_len( filename ) - 1]); /* path code file with number */
        }
        while ( codesize );
    }
    else
    {
        fwrite_codearea( binaryfile );                                /* write code as one big chunk */
        fclose( binaryfile );
        binaryfile = NULL;
    }

    if ( verbose )
    {
        puts( "Code generation completed." );
    }
}



void
CreateLib( char *lib_filename )
{
    long Codesize;
    FILE *lib_file = NULL;
    FILE *obj_file = NULL;
    char *filebuffer = NULL;
    long fptr;
	char obj_filename[FILENAME_MAX];

    if ( verbose )
    {
        puts( "Creating library..." );
    }

	CURRENTMODULE = modulehdr->first;

    TRY
    {
		/* create library as BINARY file */
		lib_file = fopen_err( lib_filename, "w+b" );          /* CH_0012 */
		fwritec_err( Z80libhdr, 8U, lib_file );				/* write library header */

        open_error_file( err_filename_ext( lib_filename ) );

        do
        {
            set_error_null();
            set_error_module( CURRENTMODULE->mname );

			/* replace fname with the .obj extension */
			path_replace_ext( obj_filename, CURRENTFILE->fname, get_obj_ext() );
			g_free( CURRENTFILE->fname );
			CURRENTFILE->fname = g_strdup( obj_filename );

            obj_file = fopen_err( CURRENTFILE->fname, "rb" );           /* CH_0012 */
            fseek( obj_file, 0L, SEEK_END );  /* file pointer to end of file */
            Codesize = ftell( obj_file );
            fseek( obj_file, 0L, SEEK_SET );  /* file pointer to start of file */

            filebuffer = ( char * ) g_malloc0( ( size_t ) Codesize );
            freadc_err( filebuffer, Codesize, obj_file ); /* load object file */
            fclose( obj_file );
            obj_file = NULL;

            if ( memcmp( filebuffer, Z80objhdr, 8U ) != 0 )
            {
                error_not_obj_file( CURRENTFILE->fname );
                break;
            }

            if ( verbose )
            {
                printf( "<%s> module at %04lX.\n", CURRENTFILE->fname, ftell( lib_file ) );
            }

            if ( CURRENTMODULE->nextmodule == NULL )
            {
                fputl_err( -1, lib_file );    /* this is the last module */
            }
            else
            {
                fptr = ftell( lib_file ) + 4 + 4;
                fputl_err( fptr + Codesize, lib_file ); /* file pointer to next module */
            }

            fputl_err( Codesize, lib_file );    /* size of this module */
            fwritec_err( filebuffer, ( size_t ) Codesize, lib_file ); /* write module to library */
            g_free( filebuffer );

            CURRENTMODULE = CURRENTMODULE->nextmodule;
        }
        while ( CURRENTMODULE != NULL );
    }
    FINALLY
    {
        if ( obj_file )
            fclose( obj_file );

        if ( lib_file )
			fclose( lib_file );

        if ( get_num_errors() )
            remove( lib_filename );

		set_error_null();
        close_error_file();

        if ( filebuffer )
            g_free( filebuffer );
    }
	ETRY;
}



int
LinkTracedModule( char *filename, long baseptr )
{
    struct linkedmod *newm;
    char *fname;

    if ( linkhdr == NULL )
    {
        linkhdr = g_new0( struct linklist, 1 );
        linkhdr->firstlink = NULL;
        linkhdr->lastlink = NULL;       /* Library header initialised */
    }

    fname = g_strdup( filename );        /* get a copy module file name */

    newm = g_new0( struct linkedmod, 1 );
    newm->nextlink = NULL;
    newm->objfilename = fname;
    newm->modulestart = baseptr;
    newm->moduleinfo = CURRENTMODULE;   /* pointer to current (active) module structure   */

    if ( linkhdr->firstlink == NULL )
    {
        linkhdr->firstlink = newm;
        linkhdr->lastlink = newm;       /* First module trace information */
    }
    else
    {
        linkhdr->lastlink->nextlink = newm;     /* current/last linked module points now at new current */
        linkhdr->lastlink = newm;               /* pointer to current linked module updated */
    }

    return 1;
}


void
ReleaseLinkInfo( void )
{
    struct linkedmod *m, *n;

    if ( linkhdr == NULL )
    {
        return;
    }

    m = linkhdr->firstlink;

    while ( m != NULL )               /* move test to start in case list is empty */
    {
        if ( m->objfilename != NULL )
        {
            g_free( m->objfilename );
        }

        n = m->nextlink;
        g_free( m );
        m = n;
    }

    g_free( linkhdr );

    linkhdr = NULL;
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

