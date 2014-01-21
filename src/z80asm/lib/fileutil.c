/*
Utilities working files.

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/fileutil.c,v 1.9 2014-01-21 23:12:30 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "fileutil.h"

#include "init.h"
#include "strpool.h"
#include "strutil.h"
#include "uthash.h"

#include <assert.h>
#include <stdarg.h>
#include <sys/stat.h>

/*-----------------------------------------------------------------------------
*	Keep hash table of FILE* to opened files for error messages
*----------------------------------------------------------------------------*/
typedef struct OpenFileElem
{
    FILE    *file; 					/* file pointer returned by fopen */
    char    *filename;				/* file name kept in strpool.h */
	BOOL	 writing;				/* TRUE if writing, FALSE if reading */

    UT_hash_handle hh;      		/* hash table */

} OpenFileElem;

OpenFileElem *open_files = NULL;	/* singleton */

List *temp_files = NULL;			/* keep list of temp files generated */

/*-----------------------------------------------------------------------------
*	Initialize and terminate module
*----------------------------------------------------------------------------*/
DEFINE_init()
{
	strpool_init();
	
	open_files = NULL;
	temp_files = OBJ_NEW( List );	/* make sure we cleanup before class */
}

DEFINE_fini()
{
    OpenFileElem *open_elem, *tmp;
	char *filename;
	
	/* delete open files hash */
    HASH_ITER( hh, open_files, open_elem, tmp )
    {
        HASH_DEL( open_files, open_elem );
        xfree( open_elem );
    }
	
	/* unlink all temp files */
	while ( (filename = List_pop( temp_files )) != NULL )
		remove( filename );		/* ignore errors, file may not exist */
}

/*-----------------------------------------------------------------------------
*	Add open files to hash table
*	hash items are only deleted on end of program, to be able to show error
* 	messages after xfclose
*----------------------------------------------------------------------------*/
static void add_open_file( FILE *file, char *filename, BOOL writing )
{
    OpenFileElem *elem;

	init();

    /* check if file exists already */
    HASH_FIND_PTR( open_files, &file, elem );

    if ( elem )
    {
        /* found, replace entry */
        elem->filename 	= strpool_add( filename );
		elem->writing	= writing;
    }
    else
    {
        /* new, create hash entry */
        elem = xnew( OpenFileElem );
        elem->file 		= file;
        elem->filename 	= strpool_add( filename );
		elem->writing	= writing;

        HASH_ADD_PTR( open_files, file, elem );
    }
}

/*-----------------------------------------------------------------------------
*	Add temp file name to list of files to delete at exit
*----------------------------------------------------------------------------*/
static void add_temp_file( char *filename )
{
	init();
	List_push( &temp_files, strpool_add(filename) );
}

/*-----------------------------------------------------------------------------
*	Search open file by file handle
*----------------------------------------------------------------------------*/
static OpenFileElem *get_open_file( FILE *file )
{
    OpenFileElem *elem;

	init();

    /* check if file exists already */
    HASH_FIND_PTR( open_files, &file, elem );

    return elem;
}

/*-----------------------------------------------------------------------------
*	Fatal error handling
*----------------------------------------------------------------------------*/
static ferr_callback_t ferr_callback = NULL;		/* default handler */

/* set call-back for input/output error; return old call-back */
ferr_callback_t set_ferr_callback( ferr_callback_t func )
{
	ferr_callback_t old;

	init();
	
	old = ferr_callback;
	ferr_callback = func;

	return old;
}

/* call fatal error for a file */
static void fatal_ferr_filename( char *filename, BOOL writing )
{
	init();

	/* call call-back, if any */
	if (ferr_callback != NULL)
		ferr_callback( filename, writing );
	
	/* safety net - abort if no call-back registered */
	die("Error: cannot %s file '%s'\n", writing ? "write" : "read", filename );
}

static void fatal_ferr( FILE *file )
{
    OpenFileElem *elem;

	init();

	elem = get_open_file( file );
	fatal_ferr_filename( elem ? elem->filename : "???",
						 elem ? elem->writing  : FALSE );
}

static void fatal_ferr_read( FILE *file )
{
    OpenFileElem *elem;

	init();

	elem = get_open_file( file );
	fatal_ferr_filename( elem ? elem->filename : "???", FALSE );
}

static void fatal_ferr_write( FILE *file )
{
    OpenFileElem *elem;

	init();

	elem = get_open_file( file );
	fatal_ferr_filename( elem ? elem->filename : "???", TRUE );
}

/*-----------------------------------------------------------------------------
*   File open and close
*----------------------------------------------------------------------------*/
FILE *xfopen( char *filename, char *mode )
{
    FILE *file;
	BOOL writing;

	init();
	
	writing = strchr( mode, 'r' ) ? FALSE : TRUE;
	file = fopen( filename, mode );

    if ( file == NULL )
		fatal_ferr_filename( filename, writing );
	else 
		add_open_file( file, filename, writing );	/* never deleted from hash */

	return file;
}

void xfclose( FILE *file )
{
	init();

    if ( fclose( file ) < 0 )
        fatal_ferr( file );
}

/*-----------------------------------------------------------------------------
*   Buffers
*----------------------------------------------------------------------------*/
void xfwrite( void *buffer, size_t size, size_t count, FILE *file )
{
	init();
    if ( fwrite( buffer, size, count, file ) != count )
        fatal_ferr_write( file );
}

void xfread( void *buffer, size_t size, size_t count, FILE *file )
{
	init();
    if ( fread( buffer, size, count, file ) != count )
        fatal_ferr_read( file );
}

/*-----------------------------------------------------------------------------
*   read/write strings of characters
*----------------------------------------------------------------------------*/
void xfput_chars( FILE *file, char *buffer, size_t len )
{
	init();
    xfwrite( buffer, sizeof(char), len, file );
}

void xfget_chars( FILE *file, char *buffer, size_t len )
{
	init();
    xfread( buffer, sizeof(char), len, file );
}

/*-----------------------------------------------------------------------------
*   read/write Str
*----------------------------------------------------------------------------*/
void xfput_strz( FILE *file, char *str )
{
	init();
    xfput_chars( file, str, strlen(str) );
}

void xfput_Str( FILE *file, Str *str )
{
	init();
    xfput_chars( file, str->str, str->len );
}

void xfget_Str( FILE *file, Str *str, size_t len )
{
	init();
    if ( len + 1 > str->size )
        fatal_ferr_read( file ); 			/* too long */

    xfget_chars( file, str->str, len );		/* characters */
    str->str[len] = '\0';					/* terminate string */
	str->len = len;							/* set lenght; Str_sync_len() only for
											   strings not including nulls */
}

/*-----------------------------------------------------------------------------
*   read/write counted string - string with size byte at start
*----------------------------------------------------------------------------*/
static void _xfput_count_byte_str( FILE *file, char *str, size_t len )
{
	init();
    if ( len > 0xFF )
        fatal_ferr_write( file );			/* too long */

    xfput_uint8( file, len );				/* byte count */
	xfput_chars( file, str, len );			/* characters */
}

void xfput_count_byte_strz( FILE *file, char *str )
{
	init();
	_xfput_count_byte_str( file, str, strlen(str) );
}

void xfput_count_byte_Str( FILE *file, Str *str )
{
	init();
	_xfput_count_byte_str( file, str->str, str->len );
}

void xfget_count_byte_Str( FILE *file, Str *str )
{
	size_t len;
	
	init();
	xfget_uint8( file, &len );				/* byte count */
    xfget_Str(   file, str, len );			/* characters */
}

/*-----------------------------------------------------------------------------
*   read/write counted string - string with size word at start
*----------------------------------------------------------------------------*/
static void _xfput_count_word_str( FILE *file, char *str, size_t len )
{
	init();
    if ( len > 0xFFFF )
        fatal_ferr_write( file );			/* too long */

    xfput_uint16( file, len );				/* word count */
	xfput_chars(  file, str, len );			/* characters */
}

void xfput_count_word_strz( FILE *file, char *str )
{
	init();
	_xfput_count_word_str( file, str, strlen(str) );
}

void xfput_count_word_Str( FILE *file, Str *str )
{
	init();
	_xfput_count_word_str( file, str->str, str->len );
}

void xfget_count_word_Str( FILE *file, Str *str )
{
	size_t len;
	
	init();
	xfget_uint16( file, &len );				/* byte count */
    xfget_Str(    file, str, len );			/* characters */
}

/*-----------------------------------------------------------------------------
*   read/write numbers - 8 bit
*----------------------------------------------------------------------------*/
void xfput_int8( FILE *file, int value )
{
	init();
	xfput_uint8( file, (unsigned) value );
}

void xfput_uint8( FILE *file, unsigned value )
{
	init();
    if ( fputc( (unsigned) value, file ) < 0 )
        fatal_ferr_write( file );
}

void xfget_int8(  FILE *file, int *pvalue )
{
	init();
	xfget_uint8( file, (unsigned *) pvalue );
    if ( *pvalue & 0x80 )
        *pvalue |= ~ 0xFF;				/* sign-extend above bit 7 */
}

void xfget_uint8( FILE *file, unsigned *pvalue )
{
	int c;
	
	init();
	if ( (c = getc( file )) < 0 )
        fatal_ferr_read( file );
	*pvalue = (unsigned) c;
}

/*-----------------------------------------------------------------------------
*   read/write numbers - 16 bit
*----------------------------------------------------------------------------*/
void xfput_int16( FILE *file, int value )
{
	init();
	xfput_uint16( file, (unsigned) value );
}

void xfput_uint16( FILE *file, unsigned value )
{
    char buffer[2];

	init();
	buffer[0] = value & 0xFF; value >>= 8;
	buffer[1] = value & 0xFF; value >>= 8;
    xfput_chars( file, buffer, sizeof(buffer) );
}

void xfget_int16( FILE *file, int *pvalue )
{
	init();
	xfget_uint16( file, (unsigned *) pvalue );
    if ( *pvalue & 0x8000 )
        *pvalue |= ~ 0xFFFF;			/* sign-extend above bit 15 */
}

void xfget_uint16( FILE *file, unsigned *pvalue )
{
    char buffer[2];

	init();
    xfget_chars( file, buffer, sizeof(buffer) );
	*pvalue = 
        ( ( buffer[0] << 0 ) & 0x00FF ) |
        ( ( buffer[1] << 8 ) & 0xFF00 );
}

/*-----------------------------------------------------------------------------
*   read/write numbers - 32 bit
*----------------------------------------------------------------------------*/
void xfput_int32( FILE *file, long value )
{
	init();
	xfput_uint32( file, (unsigned long) value );
}

void xfput_uint32( FILE *file, unsigned long value )
{
    char buffer[4];

	init();
	buffer[0] = value & 0xFF; value >>= 8;
	buffer[1] = value & 0xFF; value >>= 8;
	buffer[2] = value & 0xFF; value >>= 8;
	buffer[3] = value & 0xFF; value >>= 8;
    xfput_chars( file, buffer, sizeof(buffer) );
}

void xfget_int32( FILE *file, long *pvalue )
{
	init();
	xfget_uint32( file, (unsigned long *) pvalue );
    if ( *pvalue & 0x80000000L )
        *pvalue |= ~ 0xFFFFFFFFL;	/* sign-extend above bit 31; solve BUG_0021 */
}

void xfget_uint32( FILE *file, unsigned long *pvalue )
{
    char buffer[4];

	init();
    xfget_chars( file, buffer, sizeof(buffer) );
	*pvalue = 
        ( ( buffer[0] << 0 ) & 0x000000FF ) |
        ( ( buffer[1] << 8 ) & 0x0000FF00 ) |
        ( ( buffer[2] << 16 ) & 0x00FF0000 ) |
        ( ( buffer[3] << 24 ) & 0xFF000000 );
}

/*-----------------------------------------------------------------------------
*   Pathname manipulation
*   All filenames are returned in fixed length Str defined by
*	DEFINE_STR( dest, FILENAME_MAX ) or DEFINE_FILE_STR( dest )
*	Input string is unchanged.
*	Basename is file name removing all directories.
*	Extension is the final "." followed by sequence of letters or digits
*----------------------------------------------------------------------------*/

/* remove the extension of the filename, returns in passed Str */
static void _path_remove_ext( Str *dest, char *filename )
{
    char *dot_pos, *dir_pos_1, *dir_pos_2;

	init();
	
    Str_set( dest, filename );		/* make a copy */

    /* BUG_0014 : need to ignore dot if before a directory separator */
    dot_pos   = strrchr( dest->str, FILEEXT_SEPARATOR[0] );
    dir_pos_1 = strrchr( dest->str, '/' );

    if ( dir_pos_1 == NULL ) dir_pos_1 = dest->str;

    dir_pos_2 = strrchr( dest->str, '\\' );

    if ( dir_pos_2 == NULL ) dir_pos_2 = dest->str;

    if ( dot_pos != NULL && dot_pos > dir_pos_1 && dot_pos > dir_pos_2 )
    {
        *dot_pos = '\0';                /* terminate the string */
        Str_sync_len( dest );
    }
}

char *path_remove_ext( char *filename )
{
	DEFINE_FILE_STR( dest );

	init();
	_path_remove_ext( dest, filename );
	return strpool_add( dest->str );
}

/* make a copy of the file name in strpool, replacing the extension */
char *path_replace_ext( char *filename, char *new_ext )
{
	DEFINE_FILE_STR( dest );

	init();
	
    _path_remove_ext( dest, filename );

    if ( new_ext != NULL )
        Str_append( dest, new_ext );
	return strpool_add( dest->str );
}

/* return address of start of file basename after final slash, or start of string in none */
static char *_start_basename( char *filename )
{
    char *dir_pos_1, *dir_pos_2;

	init();
	
    dir_pos_1 = strrchr( filename, '/' );
    if ( dir_pos_1 == NULL ) dir_pos_1 = filename - 1;

    dir_pos_2 = strrchr( filename, '\\' );
    if ( dir_pos_2 == NULL ) dir_pos_2 = filename - 1;

	return MAX( dir_pos_1, dir_pos_2 ) + 1;
}

/* make a copy of the file basename, skipping the directory part */
char *path_basename( char *filename )
{
	init();
    return strpool_add( _start_basename(filename) );
}

/* make a copy of the file dirname */
char *path_dirname( char *filename )
{
	DEFINE_FILE_STR( dest );
	char *basename;
	
	init();
	
    Str_set( dest, filename );
	basename = _start_basename( dest->str );
	*basename = '\0';		/* remove basename */
	return strpool_add( dest->str );
}

/* search for a file on the given directory list, return full path name */
void path_search( Str *dest, char *filename, List *dir_list )
{
    DEFINE_FILE_STR( pathname );
    struct stat  sb;
    ListElem	*iter;

	init();
	
    Str_set( dest, filename );		/* default return: input file name */

    /* if no dir_list, return file */
    if ( dir_list == NULL )
        return;

    /* check if file exists in current directory */
    if ( stat( filename, &sb ) == 0 )
        return;

    /* search in dir_list */
    for ( iter = List_first( dir_list ); iter != NULL; iter = List_next( iter ) )
    {
        Str_set( pathname, iter->data );
        Str_append_char( pathname, '/' );
        Str_append( pathname, filename );

        if ( stat( pathname->str, &sb ) == 0 )
        {
            Str_set( dest, pathname->str );
            return;
        }
    }

    /* return unchanged pathname if not found */
    return;
}

char *search_file( char *filename, List *dir_list )
{
    DEFINE_FILE_STR( dest );

	init();
	
    path_search( dest, filename, dir_list );
    return strpool_add( dest->str );
}

/*-----------------------------------------------------------------------------
*   Temp files
*----------------------------------------------------------------------------*/
char *temp_filename( char *filename )
{
	DEFINE_FILE_STR( temp );
	static int count;
	
	init();
	
	Str_sprintf( temp, "%s~$%d$%s", 
				 path_dirname(filename), ++count, path_basename(filename) );
	add_temp_file( temp->str );
	return strpool_add( temp->str );
}

/*
* $Log: fileutil.c,v $
* Revision 1.9  2014-01-21 23:12:30  pauloscustodio
* path_... functions return filename instrpool, no need to pass an array to store result.
*
* Revision 1.8  2014/01/21 22:42:18  pauloscustodio
* New dirname(), temp_filename()
*
* Revision 1.7  2014/01/20 23:29:18  pauloscustodio
* Moved file.c to lib/fileutil.c
*
* Revision 1.6  2014/01/15 00:01:40  pauloscustodio
* Decouple file.c from errors.c by adding a call-back mechanism in file for
* fatal errors, setup by errors_init()
*
* Revision 1.5  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.4  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.3  2014/01/09 23:13:04  pauloscustodio
* Use init.h mechanism, no need for main() calling init_options.
* Use Str instead of glib.
*
* Revision 1.2  2014/01/02 17:18:16  pauloscustodio
* StrList removed, replaced by List
*
* Revision 1.1  2014/01/01 21:23:48  pauloscustodio
* Move generic file utility functions to lib/fileutil.c
*
*
*/
