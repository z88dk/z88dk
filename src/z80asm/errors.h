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

Error handling.
Fatal errors THROW(FatalErrorException)

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/errors.h,v 1.23 2014-01-11 00:10:38 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */

#include <stdio.h>

enum ErrType { ErrInfo, ErrWarn, ErrError, ErrFatal };

/*-----------------------------------------------------------------------------
*	define the next FILE, LINENO, MODULE to use in error messages
*	error_xxx(), fatal_xxx(), warn_xxx()
*----------------------------------------------------------------------------*/
extern void set_error_null( void );             /* clear all locations */
extern void set_error_file( char *filename );
extern void set_error_module( char *modulename );
extern void set_error_line( int lineno );

/*-----------------------------------------------------------------------------
*	reset count of errors and return current count
*----------------------------------------------------------------------------*/
extern void reset_error_count( void );
extern int  get_num_errors( void );

/*-----------------------------------------------------------------------------
*	Open file to receive all errors / warnings from now on
*	File is created on first call and appended on second, to allow assemble
*	and link errors to be joined in the same file.
*----------------------------------------------------------------------------*/
extern void open_error_file( char *filename );
extern void close_error_file( void );   /* deletes the file if no errors */

/*-----------------------------------------------------------------------------
*   declare error functions
*----------------------------------------------------------------------------*/
#define ERR(err_type,func,args)	extern void func;
#include "errors_def.h"
#undef ERR


/*
* $Log: errors.h,v $
* Revision 1.23  2014-01-11 00:10:38  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.22  2014/01/06 00:33:36  pauloscustodio
* Use init.h mechanism, no need for main() calling init_errors
* and atexit(fini_errors); use Str and StrHash instead of glib.
*
* Revision 1.21  2014/01/02 19:42:48  pauloscustodio
* warning: "/","*" within comment [-Wcomment]
* warning: type defaults to 'int' in declaration of '...' [-Wimplicit-int]
*
* Revision 1.20  2014/01/02 18:59:04  pauloscustodio
* warning: "/","*" within comment [-Wcomment]
*
* Revision 1.19  2014/01/02 18:57:20  pauloscustodio
* warning: "/","*" within comment [-Wcomment]
*
* Revision 1.18  2013/12/15 13:18:33  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.17  2013/09/22 21:34:48  pauloscustodio
* Remove legacy xxx_err() interface
*
* Revision 1.16  2013/09/08 00:43:58  pauloscustodio
* New error module with one error function per error, no need for the error
* constants. Allows compiler to type-check error message arguments.
* Included the errors module in the init() mechanism, no need to call
* error initialization from main(). Moved all error-testing scripts to
* one file errors.t.
*
* Revision 1.15  2013/09/01 11:59:05  pauloscustodio
* Force xmalloc to be the first include, to be able to use MSVC memory debug tools
*
* Revision 1.14  2013/05/11 00:29:26  pauloscustodio
* CH_0021 : Exceptions on file IO show file name
* Keep a hash table of all opened file names, so that the file name
* is shown on a fatal error.
* Rename file IO funtions: f..._err to xf...
*
* Revision 1.13  2013/05/02 00:01:03  pauloscustodio
* New stat_err()
*
* Revision 1.12  2013/01/20 21:24:28  pauloscustodio
* Updated copyright year to 2013
*
* Revision 1.11  2012/05/26 18:51:10  pauloscustodio
* CH_0012 : wrappers on OS calls to raise fatal error
* CH_0013 : new errors interface to decouple calling code from errors.c
*
* Revision 1.10  2012/05/24 17:09:27  pauloscustodio
* Unify copyright header
*
* Revision 1.9  2012/05/24 13:43:52  pauloscustodio
* Remove ERRORS, redundant with TOTALERRORS
*
* Revision 1.8  2012/05/23 20:43:02  pauloscustodio
* Remove ERR_NO_ERR, not used
*
* Revision 1.7  2012/05/17 21:36:06  pauloscustodio
* Remove global ASMERROR, redundant with TOTALERRORS.
* Remove IllegalArgumentException, replace by FatalErrorException.
*
* Revision 1.6  2012/05/17 20:31:45  pauloscustodio
* New errors_def.h with error name and string together, for easier maintenance
*
* Revision 1.5  2012/05/17 17:14:59  pauloscustodio
* Remove global ASSEMBLE_ERROR, not used
*
* Revision 1.4  2012/05/11 19:29:49  pauloscustodio
* Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
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
* Revision 1.3  2011/08/18 23:27:54  pauloscustodio
* BUG_0009 : file read/write not tested for errors
* - In case of disk full file write fails, but assembler does not detect the error
*   and leaves back corruped object/binary files
* - Created new exception FileIOException and ERR_FILE_IO error.
* - Created new functions xfput_u8, xfget_u8, ... to raise the exception on error.
*
* Revision 1.2  2011/07/14 01:32:08  pauloscustodio
*     - Unified "Integer out of range" and "Out of range" errors; they are the same error.
*     - Unified ReportIOError as ReportError(ERR_FILE_OPEN)
*     CH_0003 : Error messages should be more informative
*         - Added printf-args to error messages, added "Error:" prefix.
*     BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
*         - Raise ERR_UNBALANCED_PAREN instead
*
* Revision 1.1  2011/07/12 22:47:59  pauloscustodio
* - Moved all error variables and error reporting code to a separate module errors.c,
*   replaced all extern declarations of these variables by include errors.h,
*   created symbolic constants for error codes.
* - Added test scripts for error messages.
*
*/
