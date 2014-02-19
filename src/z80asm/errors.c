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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/errors.c,v 1.38 2014-02-19 23:59:26 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "errors.h"
#include "except.h"
#include "fileutil.h"
#include "srcfile.h"
#include "strpool.h"
#include "strutil.h"
#include "strhash.h"
#include "types.h"
#include "init.h"
#include <stdio.h>

static void fatal_file_error( char *filename, BOOL writing );

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
void open_error_file( char *filename )
{
    char *mode;

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
    uint_t len_at, len_prefix;

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
static void fatal_file_error( char *filename, BOOL writing )
{
	init();
	
	if ( writing )
		fatal_write_file( filename );
	else
		fatal_read_file( filename );
}


/*
* $Log: errors.c,v $
* Revision 1.38  2014-02-19 23:59:26  pauloscustodio
* BUG_0041: 64-bit portability issues
* size_t changes to unsigned long in 64-bit. Usage of size_t * to
* retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
* breaks on a 64-bit architecture. Make the functions return the value instead
* of being passed the pointer to the return value, so that the compiler
* takes care of size convertions.
* Create uint_t and ulong_t, use uint_t instead of size_t.
*
* Revision 1.37  2014/02/08 18:30:49  pauloscustodio
* lib/srcfile.c to read source files and handle recursive includes,
* used to read @lists, removed opts.files;
* model.c to hold global data model
*
* Revision 1.36  2014/01/20 23:29:18  pauloscustodio
* Moved file.c to lib/fileutil.c
*
* Revision 1.35  2014/01/15 00:01:39  pauloscustodio
* Decouple file.c from errors.c by adding a call-back mechanism in file for
* fatal errors, setup by errors_init()
*
* Revision 1.34  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.33  2014/01/11 00:10:38  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.32  2014/01/06 00:33:36  pauloscustodio
* Use init.h mechanism, no need for main() calling init_errors
* and atexit(fini_errors); use Str and StrHash instead of glib.
*
* Revision 1.31  2014/01/02 19:42:48  pauloscustodio
* warning: "/","*" within comment [-Wcomment]
* warning: type defaults to 'int' in declaration of '...' [-Wimplicit-int]
*
* Revision 1.30  2013/12/15 13:18:33  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.29  2013/09/22 21:34:48  pauloscustodio
* Remove legacy xxx_err() interface
*
* Revision 1.28  2013/09/08 00:43:58  pauloscustodio
* New error module with one error function per error, no need for the error
* constants. Allows compiler to type-check error message arguments.
* Included the errors module in the init() mechanism, no need to call
* error initialization from main(). Moved all error-testing scripts to
* one file errors.t.
*
* Revision 1.27  2013/09/01 18:46:01  pauloscustodio
* Remove call to strpool_init(). String pool is initialized in init.c before main() starts.
*
* Revision 1.26  2013/09/01 00:18:28  pauloscustodio
* - Replaced e4c exception mechanism by a much simpler one based on a few
*   macros. The former did not allow an exit(1) to be called within a
*   try-catch block.
*
* Revision 1.25  2013/05/12 19:39:32  pauloscustodio
* warnings
*
* Revision 1.24  2013/05/11 00:29:26  pauloscustodio
* CH_0021 : Exceptions on file IO show file name
* Keep a hash table of all opened file names, so that the file name
* is shown on a fatal error.
* Rename file IO funtions: f..._err to xf...
*
* Revision 1.23  2013/05/02 00:01:03  pauloscustodio
* New stat_err()
*
* Revision 1.22  2013/03/02 23:50:38  pauloscustodio
* use getc() instead of fgetc()
*
* Revision 1.21  2013/01/20 21:10:32  pauloscustodio
* Rename bool to BOOL, to be consistent with TRUE and FALSE and
* distinguish from C++ bool, true, false
*
* Revision 1.20  2013/01/19 23:54:04  pauloscustodio
* BUG_0023 : Error file with warning is removed in link phase
* z80asm -b f1.asm
* If assembling f1.asm produces a warning, the link phase removes the f1.err
* file hidding the warning.
*
* Revision 1.19  2013/01/19 00:04:53  pauloscustodio
* Implement StrHash_clone, required change in API of class.h and all classes that used it.
*
* Revision 1.18  2012/11/03 17:39:35  pauloscustodio
* astyle, comments
*
* Revision 1.17  2012/06/14 15:01:27  pauloscustodio
* Split safe strings from strutil.c to safestr.c
*
* Revision 1.16  2012/05/26 18:51:10  pauloscustodio
* CH_0012 : wrappers on OS calls to raise fatal error
* CH_0013 : new errors interface to decouple calling code from errors.c
*
* Revision 1.15  2012/05/24 17:09:27  pauloscustodio
* Unify copyright header
*
* Revision 1.14  2012/05/24 15:07:03  pauloscustodio
* Rename safestr_t to sstr_t, keep length to speed-up appending chars
*
* Revision 1.13  2012/05/24 13:43:52  pauloscustodio
* Remove ERRORS, redundant with TOTALERRORS
*
* Revision 1.12  2012/05/22 20:35:26  pauloscustodio
* astyle
*
* Revision 1.11  2012/05/22 20:29:17  pauloscustodio
* Use new sstr_t to simplify avoiding buffer overruns
*
* Revision 1.10  2012/05/17 21:36:06  pauloscustodio
* Remove global ASMERROR, redundant with TOTALERRORS.
* Remove IllegalArgumentException, replace by FatalErrorException.
*
* Revision 1.9  2012/05/17 20:31:45  pauloscustodio
* New errors_def.h with error name and string together, for easier maintenance
*
* Revision 1.8  2012/05/17 17:14:59  pauloscustodio
* Remove global ASSEMBLE_ERROR, not used
*
* Revision 1.7  2012/05/11 19:29:49  pauloscustodio
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
* Revision 1.6  2011/10/14 14:46:03  pauloscustodio
* -  BUG_0013 : defm check for MAX_CODESIZE incorrect
*  - Remove un-necessary tests for MAX_CODESIZE; all tests are concentrated in check_space() from codearea.c.
*
* Revision 1.5  2011/08/18 23:27:54  pauloscustodio
* BUG_0009 : file read/write not tested for errors
* - In case of disk full file write fails, but assembler does not detect the error
*   and leaves back corruped object/binary files
* - Created new exception FileIOException and ERR_FILE_IO error.
* - Created new functions xfput_u8, xfget_u8, ... to raise the exception on error.
*
* Revision 1.4  2011/08/14 19:27:52  pauloscustodio
* - ReportError() raises the new exception FatalErrorException for fatal error ERR_MAX_CODESIZE
*
* Revision 1.3  2011/07/18 00:48:25  pauloscustodio
* Initialize MS Visual Studio DEBUG build to show memory leaks on exit
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
