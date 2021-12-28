/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2021
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

Error handling.
*/

#include "errors.h"
#include "fileutil.h"
#include "init.h"
#include "options.h"
#include "str.h"
#include "strhash.h"
#include "strutil.h"
#include "types.h"
#include "utstring.h"
#include <stdio.h>

/*-----------------------------------------------------------------------------
*   Singleton data
*----------------------------------------------------------------------------*/
typedef struct Errors
{
    int			 count;				/* total errors */
	const char	*filename;			/* location of error: name of source file */
	const char	*module;			/* location of error: name of module */
    int			 line;				/* location of error: line number */
} Errors;

static Errors errors;				/* count errors and locations */


typedef struct ErrorFile
{
    FILE		*file;				/* currently open error file */
	const char	*filename;			/* name of error file */
} ErrorFile;

static ErrorFile error_file;		/* currently open error file */

/*-----------------------------------------------------------------------------
*   Initialize and Terminate module
*----------------------------------------------------------------------------*/
DEFINE_init_module()
{
    /* init Errors */
    reset_error_count();			/* clear error count */
    set_error_null();               /* clear location of error messages */
}

DEFINE_dtor_module()
{
    /* close error file, delete it if no errors */
    close_error_file();
}

void errors_init( void ) 
{
	init_module();
}

/*-----------------------------------------------------------------------------
*	define the next FILE, LINENO, MODULE to use in error messages
*	error_xxx(), fatal_xxx(), warn_xxx()
*----------------------------------------------------------------------------*/
void set_error_null( void )
{
    init_module();
    errors.filename = errors.module = NULL;
    errors.line = 0;
}

void set_error_file(const char *filename )
{
    init_module();
    errors.filename = spool_add( filename );	/* may be NULL */
}

void set_error_module(const char *modulename )
{
    init_module();
    errors.module = spool_add( modulename );	/* may be NULL */
}

void set_error_line( int lineno )
{
    init_module();
    errors.line = lineno;
}

const char *get_error_file(void)
{
	init_module();
	return errors.filename;
}

int get_error_line(void)
{
	init_module();
	return errors.line;
}

/*-----------------------------------------------------------------------------
*	reset count of errors and return current count
*----------------------------------------------------------------------------*/
void reset_error_count( void )
{
    init_module();
    errors.count = 0;
}

int get_num_errors( void )
{
    init_module();
    return errors.count;
}

/*-----------------------------------------------------------------------------
*	Open file to receive all errors / warnings from now on
*	File is appended, to allow assemble	and link errors to be joined in the same file.
*----------------------------------------------------------------------------*/
void open_error_file(const char *src_filename )
{
	const char *filename = get_err_filename( src_filename );

    init_module();

    /* close current file if any */
    close_error_file();

    error_file.filename = spool_add( filename );
	error_file.file = xfopen(error_file.filename, "a");		// TODO: remove error file at start of assembly
}

void close_error_file( void )
{
    init_module();

    /* close current file if any */
	if (error_file.file != NULL)
	{
		xfclose(error_file.file);

		/* delete file if no errors found */
		if (error_file.filename != NULL && file_size(error_file.filename) == 0)
			remove(error_file.filename);
	}

    /* reset */
    error_file.file		= NULL;
    error_file.filename	= NULL;        /* filename kept in strpool, no leak */
}

static void puts_error_file( char *string )
{
    init_module();

    if ( error_file.file != NULL )
        fputs( string, error_file.file );
}

/*-----------------------------------------------------------------------------
*   Output error message
*----------------------------------------------------------------------------*/
void do_error( enum ErrType err_type, char *message )
{
	STR_DEFINE(msg, STR_SIZE);
    size_t len_at, len_prefix;

    init_module();

    /* init empty message */
    Str_clear( msg );

    /* Information messages have no prefix */
    if ( err_type != ErrInfo )
    {
        Str_append( msg, err_type == ErrWarn ? "Warning" : "Error" );

        /* prepare to remove " at" if no prefix */
        len_at = Str_len(msg);
        Str_append( msg, " at" );
        len_prefix = Str_len(msg);

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
        if ( len_prefix == Str_len(msg) )	/* no prefix loaded to string */
        {
            Str_data(msg)[ len_at ] = '\0';	/* go back 3 chars to before at */
            Str_sync_len( msg );
        }

        Str_append( msg, ": " );
    }

    /* output error message */
    Str_append( msg, message );
    Str_append_char( msg, '\n' );

    /* CH_0001 : Assembly error messages should appear on stderr */
    fputs( Str_data(msg), stderr );

    /* send to error file */
    puts_error_file( Str_data(msg) );

    if ( err_type == ErrError )
        errors.count++;		/* count number of errors */

	STR_DELETE(msg);
}
