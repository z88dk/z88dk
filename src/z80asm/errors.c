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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/errors.c,v 1.15 2012-05-24 17:09:27 pauloscustodio Exp $ */
/* $Log: errors.c,v $
/* Revision 1.15  2012-05-24 17:09:27  pauloscustodio
/* Unify copyright header
/*
/* Revision 1.14  2012/05/24 15:07:03  pauloscustodio
/* Rename safestr_t to sstr_t, keep length to speed-up appending chars
/*
/* Revision 1.13  2012/05/24 13:43:52  pauloscustodio
/* Remove ERRORS, redundant with TOTALERRORS
/*
/* Revision 1.12  2012/05/22 20:35:26  pauloscustodio
/* astyle
/*
/* Revision 1.11  2012/05/22 20:29:17  pauloscustodio
/* Use new sstr_t to simplify avoiding buffer overruns
/*
/* Revision 1.10  2012/05/17 21:36:06  pauloscustodio
/* Remove global ASMERROR, redundant with TOTALERRORS.
/* Remove IllegalArgumentException, replace by FatalErrorException.
/*
/* Revision 1.9  2012/05/17 20:31:45  pauloscustodio
/* New errors_def.h with error name and string together, for easier maintenance
/*
/* Revision 1.8  2012/05/17 17:14:59  pauloscustodio
/* Remove global ASSEMBLE_ERROR, not used
/*
/* Revision 1.7  2012/05/11 19:29:49  pauloscustodio
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
/* Revision 1.6  2011/10/14 14:46:03  pauloscustodio
/* -  BUG_0013 : defm check for MAX_CODESIZE incorrect
/*  - Remove un-necessary tests for MAX_CODESIZE; all tests are concentrated in check_space() from codearea.c.
/*
/* Revision 1.5  2011/08/18 23:27:54  pauloscustodio
/* BUG_0009 : file read/write not tested for errors
/* - In case of disk full file write fails, but assembler does not detect the error
/*   and leaves back corruped object/binary files
/* - Created new exception FileIOException and ERR_FILE_IO error.
/* - Created new functions xfputc, xfgetc, ... to raise the exception on error.
/*
/* Revision 1.4  2011/08/14 19:27:52  pauloscustodio
/* - ReportError() raises the new exception FatalErrorException for fatal error ERR_MAX_CODESIZE
/*
/* Revision 1.3  2011/07/18 00:48:25  pauloscustodio
/* Initialize MS Visual Studio DEBUG build to show memory leaks on exit
/*
/* Revision 1.2  2011/07/14 01:32:08  pauloscustodio
/*     - Unified "Integer out of range" and "Out of range" errors; they are the same error.
/*     - Unified ReportIOError as ReportError(ERR_FILE_OPEN)
/*     CH_0003 : Error messages should be more informative
/*         - Added printf-args to error messages, added "Error:" prefix.
/*     BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
/*         - Raise ERR_UNBALANCED_PAREN instead
/*
/* Revision 1.1  2011/07/12 22:47:59  pauloscustodio
/* - Moved all error variables and error reporting code to a separate module errors.c,
/*   replaced all extern declarations of these variables by include errors.h,
/*   created symbolic constants for error codes.
/* - Added test scripts for error messages.
/*
/* */

#include "memalloc.h"   /* before any other include to enable memory leak detection */

#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <assert.h>
#include "errors.h"
#include "options.h"
#include "z80asm.h"
#include "config.h"
#include "strutil.h"

/* global variables */
int         TOTALERRORS     = 0;            /* total num errors */

/*-----------------------------------------------------------------------------
*   Error strings
*----------------------------------------------------------------------------*/
#define DEF_MSG(name,msg)   msg,

static char *errmsg[] =
{
#include "errors_def.h"
};

#undef DEF_MSG

/*-----------------------------------------------------------------------------
*   ResetErrors
*       Reset global error variables to no-error
*----------------------------------------------------------------------------*/
void ResetErrors( void )
{
    TOTALERRORS     = 0;
}

/*-----------------------------------------------------------------------------
*   ReportError
*       Report error errnum at given file and line number
*----------------------------------------------------------------------------*/
void ReportError( char *filename, int lineno, int errnum, ... )
{
    va_list argptr;
    SSTR_DEFINE( errstr, MAXLINE );

    va_start( argptr, errnum ); /* init variable args */

    if ( clinemode && clineno )
    {
        lineno = clineno;
    }

    /* CH_0003 : output prefix */
    sstr_set( errstr, "Error: " );

    /* output filename */
    if ( filename != NULL )
    {
        sstr_fcat( errstr, "File '%s', ", filename );
    }

    /* output module */
    if ( CURRENTMODULE != NULL && CURRENTMODULE->mname != NULL )
    {
        sstr_fcat( errstr, "Module '%s', ", CURRENTMODULE->mname );
    }

    /* output line number */
    if ( lineno != 0 )
    {
        sstr_fcat( errstr, "at line %d, ", lineno );
    }

    /* handle special errors */
    if ( errnum >= 0 && errnum < NUM_ELEMS( errmsg ) )
    {
        switch ( errnum )
        {
            case ERR_MAX_CODESIZE:
                sstr_fcat( errstr, errmsg[errnum], ( long )MAXCODESIZE );
                break;

            case ERR_TOTALERRORS:
                /* ignore all the info collected in errstr */
                sstr_fset( errstr, errmsg[errnum], TOTALERRORS );
                break;

            default:
                sstr_vfcat( errstr, errmsg[errnum], argptr );     /* pass variable args */
        }
    }
    else
    {
        sstr_fcat( errstr, "Error %d", errnum );
    }

    /* add newline */
    sstr_cat( errstr, "\n" );

    /* CH_0001 : Assembly error messages should appear on stderr */
    fputs( sstr_data( errstr ), stderr );

    if ( errfile != NULL )
    {
        fputs( sstr_data( errstr ), errfile );
    }

    /* increment error counter */
    ++TOTALERRORS;
}


