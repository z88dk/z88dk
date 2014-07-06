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

Error handling.

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/errors.c,v 1.48 2014-07-06 23:11:25 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "errors.h"
#include "except.h"
#include "fileutil.h"
#include "options.h"
#include "srcfile.h"
#include "strpool.h"
#include "strutil.h"
#include "strhash.h"
#include "types.h"
#include "init.h"
#include <stdio.h>

static void fatal_file_error( char *filename, Bool writing );

/*-----------------------------------------------------------------------------
*   Singleton data
*----------------------------------------------------------------------------*/
typedef struct Errors
{
    int			 count;				/* total errors */
    char		*filename;			/* location of error: name of source file */
    char		*module;			/* location of error: name of module */
    int			 line;				/* location of error: line number */
} Errors;

static Errors errors;				/* count errors and locations */


typedef struct ErrorFile
{
    FILE		*file;				/* currently open error file */
    char		*filename;			/* name of error file */
    StrHash		*errors;			/* set if errors per file, do delete file if empty */
} ErrorFile;

static ErrorFile error_file;		/* currently open error file */

/*-----------------------------------------------------------------------------
*   Initialize and Terminate module
*----------------------------------------------------------------------------*/
DEFINE_init()
{
	strpool_init();					/* make sure strpool is removed last */

    /* init Errors */
    reset_error_count();			/* clear error count */
    set_error_null();               /* clear location of error messages */

    /* init ErrorFile
	   initialize, force StrHash to init before */
    error_file.errors = OBJ_NEW( StrHash );	
	
	/* init file error handling */
	set_ferr_callback( fatal_file_error );
	set_incl_recursion_err_cb( fatal_include_recursion );
}

DEFINE_fini()
{
    /* close error file, delete it if no errors */
    close_error_file();

    /* delete hash table */
    OBJ_DELETE( error_file.errors );
}

void errors_init( void ) 
{
	init();
}

/*-----------------------------------------------------------------------------
*	define the next FILE, LINENO, MODULE to use in error messages
*	error_xxx(), fatal_xxx(), warn_xxx()
*----------------------------------------------------------------------------*/
void set_error_null( void )
{
    init();
    errors.filename = errors.module = NULL;
    errors.line = 0;
}

void set_error_file( char *filename )
{
    init();
    errors.filename = strpool_add( filename );	/* may be NULL */
}

void set_error_module( char *modulename )
{
    init();
    errors.module = strpool_add( modulename );	/* may be NULL */
}

void set_error_line( int lineno )
{
    init();
    errors.line = lineno;
}

/*-----------------------------------------------------------------------------
*	reset count of errors and return current count
*----------------------------------------------------------------------------*/
void reset_error_count( void )
{
    init();
    errors.count = 0;
}

int get_num_errors( void )
{
    init();
    return errors.count;
}

/*-----------------------------------------------------------------------------
*	Open file to receive all errors / warnings from now on
*	File is created on first call and appended on second, to allow assemble
*	and link errors to be joined in the same file.
*----------------------------------------------------------------------------*/
void open_error_file( char *src_filename )
{
    char *mode;
	char *filename = get_err_filename( src_filename );

    init();

    /* close current file if any */
    close_error_file();

    error_file.filename = strpool_add( filename );

    /* open new file for write or append depending on previous errors
       written to file (BUG_0023, CH_0012) */
    if ( StrHash_get( error_file.errors, error_file.filename ) )
        mode = "a";
    else
        mode = "w";

    error_file.file = xfopen( error_file.filename, mode );
}

void close_error_file( void )
{
    init();

    /* close current file if any */
    if ( error_file.file != NULL )
        xfclose( error_file.file );

    /* delete file if no errors found */
    if ( error_file.filename != NULL )
    {
        if ( ! StrHash_get( error_file.errors, error_file.filename ) )
            remove( error_file.filename );
    }

    /* reset */
    error_file.file		= NULL;
    error_file.filename	= NULL;        /* filename kept in strpool, no leak */
}

static void puts_error_file( char *string )
{
    init();

    if ( error_file.file != NULL )
    {
        fputs( string, error_file.file );

        /* signal errors in file */
        if ( error_file.filename != NULL )
            StrHash_set( & error_file.errors,
                         error_file.filename,	/* key */
                         error_file.filename );	/* value */
    }
}

/*-----------------------------------------------------------------------------
*   Output error message
*----------------------------------------------------------------------------*/
static void do_error( enum ErrType err_type, char *message )
{
    DEFINE_STR( msg, MAXLINE );
    size_t len_at, len_prefix;

    init();

    /* init empty message */
    Str_clear( msg );

    /* Information messages have no prefix */
    if ( err_type != ErrInfo )
    {
        Str_append( msg, err_type == ErrWarn ? "Warning" : "Error" );

        /* prepare to remove " at" if no prefix */
        len_at = msg->len;
        Str_append( msg, " at" );
        len_prefix = msg->len;

        /* output filename */
        if ( errors.filename && *errors.filename )
            Str_append_sprintf( msg, " file '%s'", errors.filename );

        /* output module */
        if ( errors.module != NULL && *errors.module )
            Str_append_sprintf( msg, " module '%s'", errors.module );

        /* output line number */
        if ( errors.line > 0 )
            Str_append_sprintf( msg, " line %d", errors.line );

        /* remove at if no prefix */
        if ( len_prefix == msg->len )	/* no prefix loaded to string */
        {
            msg->str[ len_at ] = '\0';	/* go back 3 chars to before at */
            Str_sync_len( msg );
        }

        Str_append( msg, ": " );
    }

    /* output error message */
    Str_append( msg, message );
    Str_append_char( msg, '\n' );

    /* CH_0001 : Assembly error messages should appear on stderr */
    fputs( msg->str, stderr );

    /* send to error file */
    puts_error_file( msg->str );

    if ( err_type == ErrError || err_type == ErrFatal )
    {
        /* count number of errors */
        errors.count++;

        /* exception if fatal */
        if ( err_type == ErrFatal )
            THROW( FatalErrorException );
    }
}

/*-----------------------------------------------------------------------------
*   define error functions
*----------------------------------------------------------------------------*/
#define ERR(err_type,func,args)	\
	void func \
	{ \
		DEFINE_STR( msg, MAXLINE ); \
		\
		init(); \
		Str_append_sprintf( msg, args ); \
		do_error( err_type, msg->str ); \
	}
#include "errors_def.h"
#undef ERR

/*-----------------------------------------------------------------------------
*   fatal file error handling
*----------------------------------------------------------------------------*/
static void fatal_file_error( char *filename, Bool writing )
{
	init();
	
	if ( writing )
		fatal_write_file( filename );
	else
		fatal_read_file( filename );
}
