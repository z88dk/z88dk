/*
Utilities working files.

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/fileutil.c,v 1.21 2014-07-06 23:11:25 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "fileutil.h"

#include "strpool.h"
#include "strutil.h"
#include "uthash.h"

#include <assert.h>
#include <stdarg.h>
#include <sys/stat.h>

static void fatal_ferr_filename( char *filename, Bool is_writing );

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
	Bool	 is_open;				/* TRUE if fopen succeeded */
	Bool	 is_writing;			/* TRUE if writing, FALSE if reading */
	Bool	 is_atomic;				/* TRUE if writing a temp file to be
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
static FILE *OpenFile_open( char *filename, char *mode, Bool is_atomic )
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
		Bool is_writing = self->is_writing;
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
	Bool	  is_writing;
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
static void fatal_ferr_filename( char *filename, Bool is_writing )
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
void xfwrite( void *buffer, size_t size, size_t count, FILE *file )
{
    if ( fwrite( buffer, size, count, file ) != count )
        fatal_ferr_write( file );
}

void xfread( void *buffer, size_t size, size_t count, FILE *file )
{
    if ( fread( buffer, size, count, file ) != count )
        fatal_ferr_read( file );
}

/*-----------------------------------------------------------------------------
*   read/write strings of characters
*----------------------------------------------------------------------------*/
void xfput_chars( FILE *file, char *buffer, size_t len )
{
    xfwrite( buffer, sizeof(char), len, file );
}

void xfget_chars( FILE *file, char *buffer, size_t len )
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

void xfget_Str( FILE *file, Str *str, size_t len )
{
	/* reserve space */
	Str_clear( str );
	Str_reserve( str, len );

	/* may fail if static string */
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
	size_t len;
	
	len = xfget_uint8( file );				/* byte count */
    xfget_Str(   file, str, len );			/* characters */
}

/*-----------------------------------------------------------------------------
*   read/write counted string - string with size word at start
*----------------------------------------------------------------------------*/
static void _xfput_count_word_str( FILE *file, char *str, size_t len )
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
	size_t len;
	
	len = xfget_uint16( file );				/* byte count */
    xfget_Str(    file, str, len );			/* characters */
}

/*-----------------------------------------------------------------------------
*   read/write numbers - 8 bit
*----------------------------------------------------------------------------*/
void xfput_int8( FILE *file, int8_t value )
{
	xfput_uint8( file, (Byte) value );
}

void xfput_uint8( FILE *file, Byte value )
{
    if ( fputc( value, file ) < 0 )
        fatal_ferr_write( file );
}

int8_t xfget_int8(  FILE *file )
{
	Byte value = xfget_uint8( file );
    if ( value & 0x80 )
        value |= ~ 0xFF;				/* sign-extend above bit 7 */
	return (int8_t) value;
}

Byte xfget_uint8( FILE *file )
{
	int value;
	if ( (value = getc( file )) < 0 )
        fatal_ferr_read( file );
	return (Byte) value;
}

/*-----------------------------------------------------------------------------
*   read/write numbers - 16 bit
*----------------------------------------------------------------------------*/
void xfput_int16( FILE *file, int16_t value )
{
	xfput_uint16( file, (uint16_t) value );
}

void xfput_uint16( FILE *file, uint16_t value )
{
    Byte buffer[2];

	buffer[0] = value & 0xFF; value >>= 8;
	buffer[1] = value & 0xFF; value >>= 8;
    xfput_chars( file, (char *) buffer, sizeof(buffer) );
}

int16_t xfget_int16( FILE *file )
{
	int16_t value = (int16_t) xfget_uint16( file );
    if ( value & 0x8000 )
        value |= ~ 0xFFFF;			/* sign-extend above bit 15 */
	return value;
}

uint16_t xfget_uint16( FILE *file )
{
    Byte buffer[2];

    xfget_chars( file, (char *) buffer, sizeof(buffer) );
	return
        ( ( buffer[0] << 0 ) & 0x00FF ) |
        ( ( buffer[1] << 8 ) & 0xFF00 );
}

/*-----------------------------------------------------------------------------
*   read/write numbers - 32 bit
*----------------------------------------------------------------------------*/
void xfput_int32( FILE *file, int32_t value )
{
	xfput_uint32( file, (uint32_t) value );
}

void xfput_uint32( FILE *file, uint32_t value )
{
    Byte buffer[4];

	buffer[0] = value & 0xFF; value >>= 8;
	buffer[1] = value & 0xFF; value >>= 8;
	buffer[2] = value & 0xFF; value >>= 8;
	buffer[3] = value & 0xFF; value >>= 8;
    xfput_chars( file, (char *) buffer, sizeof(buffer) );
}

int32_t xfget_int32( FILE *file )
{
	int32_t value = (int32_t) xfget_uint32( file );
    if ( value & 0x80000000L )
        value |= ~ 0xFFFFFFFFL;	/* sign-extend above bit 31; solve BUG_0021 */
	return value;
}

uint32_t xfget_uint32( FILE *file )
{
    Byte buffer[4];

    xfget_chars( file, (char *) buffer, sizeof(buffer) );
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
