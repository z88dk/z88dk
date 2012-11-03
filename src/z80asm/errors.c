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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/errors.c,v 1.18 2012-11-03 17:39:35 pauloscustodio Exp $ */
/* $Log: errors.c,v $
/* Revision 1.18  2012-11-03 17:39:35  pauloscustodio
/* astyle, comments
/*
/* Revision 1.17  2012/06/14 15:01:27  pauloscustodio
/* Split safe strings from strutil.c to safestr.c
/*
/* Revision 1.16  2012/05/26 18:51:10  pauloscustodio
/* CH_0012 : wrappers on OS calls to raise fatal error
/* CH_0013 : new errors interface to decouple calling code from errors.c
/*
/* Revision 1.15  2012/05/24 17:09:27  pauloscustodio
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
/* - Created new functions fputc_err, fgetc_err, ... to raise the exception on error.
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

#include "memalloc.h"   /* before any other include */

#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <assert.h>
#include "errors.h"
#include "strutil.h"
#include "safestr.h"
#include "class.h"
#include "strpool.h"
#include "types.h"

/*-----------------------------------------------------------------------------
*   Error strings
*----------------------------------------------------------------------------*/
#define DEF_MSG(name,msg)   msg,
static char *error_msg[] =
{
#include "errors_def.h"
};
#undef DEF_MSG

/*-----------------------------------------------------------------------------
*   Class to keep current output file and close it on program exit
*----------------------------------------------------------------------------*/
CLASS( ErrFile )
FILE    *fp;            /* file handle */
char    *filename;      /* file name kept in strpool.h */
int     num_errors;     /* number of errors in file, do delete file if empty */
END_CLASS;

DEF_CLASS( ErrFile );

void ErrFile_open( ErrFile *self, char *filename );
void ErrFile_close( ErrFile *self );

void ErrFile_init( ErrFile *self )
{
    /* force init strpool to make sure ErrFile is destroyed before StrPool */
    strpool_init();
}

void ErrFile_copy( ErrFile *self )
{
    self->fp = NULL;
}

void ErrFile_fini( ErrFile *self )
{
    ErrFile_close( self );
}

void ErrFile_open( ErrFile *self, char *filename )
{
    /* close current file if any */
    ErrFile_close( self );

    /* open new file */
    self->fp = fopen_err( filename, "w" );           /* CH_0012 */
    self->filename = strpool_add( filename );
}

void ErrFile_close( ErrFile *self )
{
    /* close current file if any */
    if ( self->fp != NULL )
    {
        fclose( self->fp );
    }

    /* delete file if num_errors is zero */
    if ( self->filename != NULL && self->num_errors == 0 )
    {
        remove( self->filename );
    }

    /* reset */
    self->fp         = NULL;
    self->filename   = NULL;        /* file kept in strpool, no leak */
    self->num_errors = 0;
}

void ErrFile_puts( ErrFile *self, char *str )
{
    if ( self->fp != NULL )
    {
        fputs( str, self->fp );
        self->num_errors++;
    }
}

/*-----------------------------------------------------------------------------
*   Singletons
*----------------------------------------------------------------------------*/
static ErrFile *error_file = NULL;
static int num_errors      = 0;
static int num_warnings    = 0;
static char *error_filename = NULL;
static char *error_module = NULL;
static int  error_line     = 0;

/*-----------------------------------------------------------------------------
*   init - create error_file on first call
*----------------------------------------------------------------------------*/
static void init( void )
{
    if ( error_file == NULL )
    {
        error_file = OBJ_NEW( ErrFile );
    }
}

/*-----------------------------------------------------------------------------
*   define the next FILE, LINENO, MODULE to use in error messages
*   error(), fatal_error(), warning()
*----------------------------------------------------------------------------*/
void set_error_null( void )
{
    error_filename = error_module = NULL;
    error_line = 0;
}

void set_error_file( char *filename )
{
    error_filename = filename ? strpool_add( filename ) : NULL;
}

void set_error_module( char *modulename )
{
    error_module = modulename ? strpool_add( modulename ) : NULL;
}

void set_error_line( int lineno )
{
    error_line = lineno;
}

/*-----------------------------------------------------------------------------
*   Error count handling
*----------------------------------------------------------------------------*/
void reset_error_count( void )
{
    num_errors = num_warnings = 0;
}

int  get_num_errors( void )
{
    return num_errors;
}

int  get_num_warnings( void )
{
    return num_warnings;
}

/*-----------------------------------------------------------------------------
*   Handle output file for errors
*----------------------------------------------------------------------------*/
void open_error_file( char *filename )
{
    init();
    ErrFile_open( error_file, filename );
}

void close_error_file( void )
{
    init();
    ErrFile_close( error_file );
}

/*-----------------------------------------------------------------------------
*   Send out an error message
*----------------------------------------------------------------------------*/
static void out_error_msg( int *countp, char *prefix,
                           char *filename, int lineno,
                           bool is_fatal,
                           ErrorCode err, va_list argptr )
{
    SSTR_DEFINE( str, MAXLINE );
    SSTR_DEFINE( location, MAXLINE );

    init();

    /* CH_0003 : output prefix */
    sstr_set( str, err ? prefix : "Exit" );

    /* output filename */
    if ( filename && *filename )
    {
        sstr_fcat( location, " file '%s'", filename );
    }

    /* output module */
    if ( error_module != NULL && *error_module )
    {
        sstr_fcat( location, " module '%s'", error_module );
    }

    /* output line number */
    if ( lineno > 0 )
    {
        sstr_fcat( location, " line %d", lineno );
    }

    /* add location to str */
    if ( sstr_len( location ) )
    {
        sstr_fcat( str, " at%s", sstr_data( location ) );
    }

    sstr_cat( str, ": " );

    /* output error message */
    if ( err >= 0 && err < NUM_ELEMS( error_msg ) )
    {
        switch ( err )
        {
            case ERR_TOTALERRORS:
                /* ignore all the info collected in str */
                sstr_clear( str );
                /* fall through to default */

            default:
                sstr_vfcat( str, error_msg[err], argptr );     /* pass variable args */
        }
    }
    else
    {
        sstr_fcat( str, "Error %d", err );
    }

    /* output newline */
    sstr_cat( str, "\n" );

    /* CH_0001 : Assembly error messages should appear on stderr */
    fputs( sstr_data( str ), stderr );

    /* send to error file */
    ErrFile_puts( error_file, sstr_data( str ) );

    /* count number of errors */
    ( *countp )++;

    if ( is_fatal )
    {
        throw( FatalErrorException, sstr_data( str ) );
    }
}

/*-----------------------------------------------------------------------------
*   error / warning
*----------------------------------------------------------------------------*/
void fatal_error( ErrorCode err, ... )
{
    va_list argptr;
    va_start( argptr, err );
    out_error_msg( &num_errors, "Error", error_filename, error_line, TRUE, err, argptr );
}

void error( ErrorCode err, ... )
{
    va_list argptr;
    va_start( argptr, err );
    out_error_msg( &num_errors, "Error", error_filename, error_line, FALSE, err, argptr );
}

void warning( ErrorCode err, ... )
{
    va_list argptr;
    va_start( argptr, err );
    out_error_msg( &num_warnings, "Warning", error_filename, error_line, FALSE, err, argptr );
}

void fatal_error_at( char *filename, int lineno, ErrorCode err, ... )
{
    va_list argptr;
    va_start( argptr, err );
    out_error_msg( &num_errors, "Error", filename, lineno, TRUE, err, argptr );
}

void error_at( char *filename, int lineno, ErrorCode err, ... )
{
    va_list argptr;
    va_start( argptr, err );
    out_error_msg( &num_errors, "Error", filename, lineno, FALSE, err, argptr );
}

void warning_at( char *filename, int lineno, ErrorCode err, ... )
{
    va_list argptr;
    va_start( argptr, err );
    out_error_msg( &num_warnings, "Warning", filename, lineno, FALSE, err, argptr );
}


/*-----------------------------------------------------------------------------
*   OS interface with fatal errors on failure
*----------------------------------------------------------------------------*/
FILE *fopen_err( char *filename, char *mode )
{
    FILE *fp = fopen( filename, mode );

    if ( fp == NULL )
    {
        fatal_error_at( error_filename, error_line,
                        mode[0] == 'r' ? ERR_FOPEN_READ  : ERR_FOPEN_WRITE,
                        filename );
    }

    return fp;
}

void fputc_err( int c, FILE *stream )
{
    int ret = fputc( c, stream );

    if ( ret == EOF )
    {
        fatal_error_at( error_filename, error_line, ERR_FILE_WRITE );
    }
}

int fgetc_err( FILE *stream )
{
    int ret = fgetc( stream );

    if ( ret == EOF )
    {
        fatal_error_at( error_filename, error_line, ERR_FILE_READ );
    }

    return ret;
}

void fwrite_err( const void *buffer, size_t size, size_t count, FILE *stream )
{
    size_t written = fwrite( buffer, size, count, stream );

    if ( written != count )
    {
        fatal_error_at( error_filename, error_line, ERR_FILE_WRITE );
    }
}

void fread_err( void *buffer, size_t size, size_t count, FILE *stream )
{
    size_t read = fread( buffer, size, count, stream );

    if ( read != count )
    {
        fatal_error_at( error_filename, error_line, ERR_FILE_READ );
    }
}
