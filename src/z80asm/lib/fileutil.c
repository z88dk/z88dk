/*
Utilities working files.

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/fileutil.c,v 1.13 2014-02-20 22:55:27 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "fileutil.h"

#include "strpool.h"
#include "strutil.h"
#include "uthash.h"

#include <assert.h>
#include <stdarg.h>
#include <sys/stat.h>

static void fatal_ferr_filename( char *filename, BOOL is_writing );

/*-----------------------------------------------------------------------------
*	List to keep temporary file names that need to be deleted atexit
*	Relies on class.c destruction of all created objects
*----------------------------------------------------------------------------*/
static List *temp_files = NULL;		/* keep list of temp files generated */

/* add temp file name to list of files to delete at exit */
static char *add_temp_file( char *filename )
{
	char *temp;
	
	strpool_init();
	temp = strpool_add(filename);
	
	List_push( &temp_files, temp );
	temp_files->free_data = (void(*)(void*))remove;	/* call remove(file) atexit */
	
	return temp;
}

/* return temporary file name, schedules file to be removed atexit */
char *temp_filename( char *filename )
{
	DEFINE_FILE_STR( temp );
	static int count;
	
	Str_sprintf( temp, "%s~$%d$%s", 
				 path_dirname(filename), ++count, path_basename(filename) );

	return add_temp_file( temp->str );
}

/*-----------------------------------------------------------------------------
*	Class to keep one open file, and hash FILE* -> OpenFile
*----------------------------------------------------------------------------*/
CLASS( OpenFile )
    FILE    *file; 					/* file pointer returned by fopen */
    char    *filename;				/* file name kept in strpool.h */
	char 	*atomic_tempname;		/* tempname used in atomic mode */
	BOOL	 is_open;				/* TRUE if fopen succeeded */
	BOOL	 is_writing;			/* TRUE if writing, FALSE if reading */
	BOOL	 is_atomic;				/* TRUE if writing a temp file to be
									   renamed to filename at xfclose() */
END_CLASS;

typedef struct OpenFileElem
{
    FILE     *file; 				/* file pointer returned by fopen */
    OpenFile *open_file;			/* OpenFile object */

    UT_hash_handle hh;      		/* hash table */

} OpenFileElem;

static OpenFileElem *open_files = NULL;	/* singleton */

/*-----------------------------------------------------------------------------
*	Keep map FILE* --> OpenFile
*	allocated / released by OpenFile_xxx()
*----------------------------------------------------------------------------*/

/* add open file to hash */
static void add_open_file( FILE *file, OpenFile *open_file )
{
    OpenFileElem *elem;
	
	assert(file);

	HASH_FIND_PTR( open_files, &file, elem );
	assert( elem == NULL );			/* make sure FILE* is unique */
	
	elem = xnew( OpenFileElem );
	elem->file 		= file;
	elem->open_file	= open_file;

	HASH_ADD_PTR( open_files, file, elem );
}

/* get open file from hash, NULL if file already closed */
static OpenFile *get_open_file( FILE *file )
{
    OpenFileElem *elem;

	if ( file == NULL )
		return NULL;

    /* check if file exists already */
    HASH_FIND_PTR( open_files, &file, elem );

    return elem != NULL ? elem->open_file : NULL;
}

/* remove open file from hash */
static void remove_open_file( FILE *file )
{
    OpenFileElem *elem;

	if ( file != NULL )
	{
		HASH_FIND_PTR( open_files, &file, elem );
		
		if ( elem != NULL )
		{
			HASH_DEL( open_files, elem );
			xfree( elem );
		}
	}
}

/*-----------------------------------------------------------------------------
*	Class to keep information on open files
*	Needed to assure correct order of destruction of objects
*	Relies on class.c destruction of all created objects
*----------------------------------------------------------------------------*/
DEF_CLASS( OpenFile );

void OpenFile_init( OpenFile *self )
{
	strpool_init();
}

void OpenFile_copy( OpenFile *self, OpenFile *other )
{
	assert(0);
}

void OpenFile_fini( OpenFile *self )
{
	if ( self->file != NULL && self->is_open )
		fclose( self->file );		/* no xfclose for atomic to work */
		
	remove_open_file( self->file );
}

/* open a file, add to hash table */
static FILE *OpenFile_open( char *filename, char *mode, BOOL is_atomic )
{
	OpenFile   *self;
	char 	   *temp_name;

	/* init temp_files before OpenFile, to assure temp files are removed last */
	strpool_init();
	temp_name = is_atomic ? temp_filename( filename ) : NULL;

	/* init object */
	self = OBJ_NEW( OpenFile );
	self->filename   = strpool_add( filename );
	self->is_writing = strchr( mode, 'r' ) ? FALSE : TRUE;
	
	/* handle atomic writes */
	if ( self->is_writing && is_atomic )
	{
		self->is_atomic			= TRUE;
		self->file 				= fopen( temp_name, mode );
		self->atomic_tempname 	= temp_name;
	}
	else 
	{
		self->is_atomic			= FALSE;
		self->file 				= fopen( filename, mode );
		self->atomic_tempname 	= NULL;
	}

	if ( self->file == NULL )
	{
		/* error, remove object */
		BOOL is_writing = self->is_writing;
		OBJ_DELETE( self );
		fatal_ferr_filename( filename, is_writing );
	}
	else 
	{
		/* add object to open_files map */
		self->is_open = TRUE;
		add_open_file( self->file, self );
	}

	return self->file;
}

/* close a file, rename temp name if atomic, remove from hash table */
static void OpenFile_close( FILE *file )
{
    OpenFile *self;
	char     *filename;
	BOOL	  is_writing;
	int 	  fclose_ret 	= 0;
	int 	  rename_ret 	= 0;

	/* try to get open_file, may fail if file was already closed */
	self = get_open_file( file );
	if ( self == NULL )
	{
		fclose( file );				/* not-managed file, ignore errors */
	}
	else 
	{												/* managed file */
		filename   	= self->filename;
		is_writing 	= self->is_writing;
		
		/* close file */
		if ( self->is_open )
			fclose_ret = fclose( file );
		self->is_open = FALSE;			/* so that OBJ_DELETE() skips fclose() */
		
		/* handle atomic writes, if fclose OK */
		if ( self->is_atomic )
		{
			if ( fclose_ret >= 0 )
			{
				/* remove target file, if it exists; needed for rename 
				   ignore errors from remove */
				remove( self->filename );
				rename_ret = rename( self->atomic_tempname, self->filename );
			}
		}

		OBJ_DELETE( self );			/* object no longer needed */
		
		/* error if fclose or rename failed */
		if ( fclose_ret < 0 || rename_ret < 0 )
			fatal_ferr_filename( filename, is_writing );
	}
}

/*-----------------------------------------------------------------------------
*	Fatal error handling
*----------------------------------------------------------------------------*/
static ferr_callback_t ferr_callback = NULL;		/* default handler */

/* set call-back for input/output error; return old call-back */
ferr_callback_t set_ferr_callback( ferr_callback_t func )
{
	ferr_callback_t old = ferr_callback;
	ferr_callback = func;
	return old;
}

/* call fatal error for a file */
static void fatal_ferr_filename( char *filename, BOOL is_writing )
{
	/* call call-back, if any */
	if (ferr_callback != NULL)
		ferr_callback( filename, is_writing );
	
	/* safety net - abort if no call-back registered */
	die("Error: cannot %s file '%s'\n", is_writing ? "write" : "read", filename );
}

static void fatal_ferr_read( FILE *file )
{
    OpenFile *open_file = get_open_file( file );
	fatal_ferr_filename( open_file ? open_file->filename : "???", FALSE );
}

static void fatal_ferr_write( FILE *file )
{
    OpenFile *open_file = get_open_file( file );
	fatal_ferr_filename( open_file ? open_file->filename : "???", TRUE );
}

/*-----------------------------------------------------------------------------
*   File open and close
*----------------------------------------------------------------------------*/
FILE *xfopen( char *filename, char *mode )
{
	return OpenFile_open( filename, mode, FALSE );
}

FILE *xfopen_atomic( char *filename, char *mode )
{
	return OpenFile_open( filename, mode, TRUE );
}

void xfclose( FILE *file )
{
    OpenFile_close( file );
}

void xfclose_remove( FILE *file )
{
    OpenFile *self;
	char     *filename;

	/* try to get open_file, may fail if file was already closed */
	self = get_open_file( file );
	filename = self ? self->filename : NULL;	/* filename in strpool */
	
	/* close the file */
    xfclose( file );
	
	/* delete file, if one was found */
	if ( filename != NULL )
		remove( filename );
}

/*-----------------------------------------------------------------------------
*   Buffers
*----------------------------------------------------------------------------*/
void xfwrite( void *buffer, uint_t size, uint_t count, FILE *file )
{
    if ( fwrite( buffer, size, count, file ) != count )
        fatal_ferr_write( file );
}

void xfread( void *buffer, uint_t size, uint_t count, FILE *file )
{
    if ( fread( buffer, size, count, file ) != count )
        fatal_ferr_read( file );
}

/*-----------------------------------------------------------------------------
*   read/write strings of characters
*----------------------------------------------------------------------------*/
void xfput_chars( FILE *file, char *buffer, uint_t len )
{
    xfwrite( buffer, sizeof(char), len, file );
}

void xfget_chars( FILE *file, char *buffer, uint_t len )
{
    xfread( buffer, sizeof(char), len, file );
}

/*-----------------------------------------------------------------------------
*   read/write Str
*----------------------------------------------------------------------------*/
void xfput_strz( FILE *file, char *str )
{
    xfput_chars( file, str, strlen(str) );
}

void xfput_Str( FILE *file, Str *str )
{
    xfput_chars( file, str->str, str->len );
}

void xfget_Str( FILE *file, Str *str, uint_t len )
{
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
static void _xfput_count_byte_str( FILE *file, char *str, uint_t len )
{
    if ( len > 0xFF )
        fatal_ferr_write( file );			/* too long */

    xfput_uint8( file, len );				/* byte count */
	xfput_chars( file, str, len );			/* characters */
}

void xfput_count_byte_strz( FILE *file, char *str )
{
	_xfput_count_byte_str( file, str, strlen(str) );
}

void xfput_count_byte_Str( FILE *file, Str *str )
{
	_xfput_count_byte_str( file, str->str, str->len );
}

void xfget_count_byte_Str( FILE *file, Str *str )
{
	uint_t len;
	
	len = xfget_uint8( file );				/* byte count */
    xfget_Str(   file, str, len );			/* characters */
}

/*-----------------------------------------------------------------------------
*   read/write counted string - string with size word at start
*----------------------------------------------------------------------------*/
static void _xfput_count_word_str( FILE *file, char *str, uint_t len )
{
    if ( len > 0xFFFF )
        fatal_ferr_write( file );			/* too long */

    xfput_uint16( file, len );				/* word count */
	xfput_chars(  file, str, len );			/* characters */
}

void xfput_count_word_strz( FILE *file, char *str )
{
	_xfput_count_word_str( file, str, strlen(str) );
}

void xfput_count_word_Str( FILE *file, Str *str )
{
	_xfput_count_word_str( file, str->str, str->len );
}

void xfget_count_word_Str( FILE *file, Str *str )
{
	uint_t len;
	
	len = xfget_uint16( file );				/* byte count */
    xfget_Str(    file, str, len );			/* characters */
}

/*-----------------------------------------------------------------------------
*   read/write numbers - 8 bit
*----------------------------------------------------------------------------*/
void xfput_int8( FILE *file, int value )
{
	xfput_uint8( file, (uint_t) value );
}

void xfput_uint8( FILE *file, uint_t value )
{
    if ( fputc( value, file ) < 0 )
        fatal_ferr_write( file );
}

int xfget_int8(  FILE *file )
{
	uint_t value = xfget_uint8( file );
    if ( value & 0x80 )
        value |= ~ 0xFF;				/* sign-extend above bit 7 */
	return (int) value;
}

uint_t xfget_uint8( FILE *file )
{
	int value;
	if ( (value = getc( file )) < 0 )
        fatal_ferr_read( file );
	return (uint_t) value;
}

/*-----------------------------------------------------------------------------
*   read/write numbers - 16 bit
*----------------------------------------------------------------------------*/
void xfput_int16( FILE *file, int value )
{
	xfput_uint16( file, (uint_t) value );
}

void xfput_uint16( FILE *file, uint_t value )
{
    char buffer[2];

	buffer[0] = value & 0xFF; value >>= 8;
	buffer[1] = value & 0xFF; value >>= 8;
    xfput_chars( file, buffer, sizeof(buffer) );
}

int xfget_int16( FILE *file )
{
	int value = (int) xfget_uint16( file );
    if ( value & 0x8000 )
        value |= ~ 0xFFFF;			/* sign-extend above bit 15 */
	return value;
}

uint_t xfget_uint16( FILE *file )
{
    char buffer[2];

    xfget_chars( file, buffer, sizeof(buffer) );
	return
        ( ( buffer[0] << 0 ) & 0x00FF ) |
        ( ( buffer[1] << 8 ) & 0xFF00 );
}

/*-----------------------------------------------------------------------------
*   read/write numbers - 32 bit
*----------------------------------------------------------------------------*/
void xfput_int32( FILE *file, long value )
{
	xfput_uint32( file, (ulong_t) value );
}

void xfput_uint32( FILE *file, ulong_t value )
{
    char buffer[4];

	buffer[0] = value & 0xFF; value >>= 8;
	buffer[1] = value & 0xFF; value >>= 8;
	buffer[2] = value & 0xFF; value >>= 8;
	buffer[3] = value & 0xFF; value >>= 8;
    xfput_chars( file, buffer, sizeof(buffer) );
}

long xfget_int32( FILE *file )
{
	long value = (long) xfget_uint32( file );
    if ( value & 0x80000000L )
        value |= ~ 0xFFFFFFFFL;	/* sign-extend above bit 31; solve BUG_0021 */
	return value;
}

ulong_t xfget_uint32( FILE *file )
{
    char buffer[4];

    xfget_chars( file, buffer, sizeof(buffer) );
	return
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

	_path_remove_ext( dest, filename );
	return strpool_add( dest->str );
}

/* make a copy of the file name in strpool, replacing the extension */
char *path_replace_ext( char *filename, char *new_ext )
{
	DEFINE_FILE_STR( dest );
	
    _path_remove_ext( dest, filename );

    if ( new_ext != NULL )
        Str_append( dest, new_ext );
	return strpool_add( dest->str );
}

/* return address of start of file basename after final slash, or start of string in none */
static char *_start_basename( char *filename )
{
    char *dir_pos_1, *dir_pos_2;
	
    dir_pos_1 = strrchr( filename, '/' );
    if ( dir_pos_1 == NULL ) dir_pos_1 = filename - 1;

    dir_pos_2 = strrchr( filename, '\\' );
    if ( dir_pos_2 == NULL ) dir_pos_2 = filename - 1;

	return MAX( dir_pos_1, dir_pos_2 ) + 1;
}

/* make a copy of the file basename, skipping the directory part */
char *path_basename( char *filename )
{
    return strpool_add( _start_basename(filename) );
}

/* make a copy of the file dirname */
char *path_dirname( char *filename )
{
	DEFINE_FILE_STR( dest );
	char *basename;
	
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
	
    path_search( dest, filename, dir_list );
    return strpool_add( dest->str );
}

/*
* $Log: fileutil.c,v $
* Revision 1.13  2014-02-20 22:55:27  pauloscustodio
* xfget_int16() and xfget_int32() were not sign-extending correctly
* causing link to fail on a 64-bit architecture.
*
* Revision 1.12  2014/02/19 23:59:27  pauloscustodio
* BUG_0041: 64-bit portability issues
* size_t changes to unsigned long in 64-bit. Usage of size_t * to
* retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
* breaks on a 64-bit architecture. Make the functions return the value instead
* of being passed the pointer to the return value, so that the compiler
* takes care of size convertions.
* Create uint_t and ulong_t, use uint_t instead of size_t.
*
* Revision 1.11  2014/02/02 23:00:54  pauloscustodio
* New xfclose_remove() to remove file after closing.
*
* Revision 1.10  2014/01/29 22:40:52  pauloscustodio
* Mechanism for atomic file write - open a temp file for writing on
* xfopen_atomic(), close and rename to final name on xfclose().
* temp_filename() to generate a temporary file name that is
* deleted atexit.
*
* Revision 1.9  2014/01/21 23:12:30  pauloscustodio
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
