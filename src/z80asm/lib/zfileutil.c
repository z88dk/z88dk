/*
Z88DK Z80 Macro Assembler

Utilities working files.

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#include "alloc.h"
#include "class.h"
#include "fileutil.h"
#include "zfileutil.h"
#include "init.h"
#include "strpool.h"
#include "str.h"
#include "uthash.h"

#include <assert.h>
#include <stdarg.h>
#include <sys/stat.h>
#ifdef _WIN32
#include <direct.h>
#endif

static void file_error_filename( char *filename, Bool is_writing );

/*-----------------------------------------------------------------------------
*	List to keep temporary file names that need to be deleted atexit
*	Relies on class.c destruction of all created objects
*----------------------------------------------------------------------------*/
static UT_array *temp_files;		/* keep list of temp files generated */

/*-----------------------------------------------------------------------------
*	Initialize and delete temp_files
*----------------------------------------------------------------------------*/
DEFINE_init_module()
{
	utarray_new(temp_files, &ut_str_icd);
}

DEFINE_dtor_module()
{
	char **p;

	/* delete all temp files */
	for (p = NULL; (p = (char**)utarray_prev(temp_files, p)) != NULL; ) 
		remove(*p);

	utarray_free(temp_files);
}

/* add temp file name to list of files to delete at exit */
static char *add_temp_file( char *filename )
{
	char **p;

	init_module();
	utarray_push_back(temp_files, &filename);		/* save string in heap */
	p = (char **)utarray_back(temp_files);
	return *p;										/* return address of saved string */
}

/* return temporary file name, schedules file to be removed atexit */
char *temp_filename( char *filename )
{
	STR_DEFINE(temp, FILENAME_MAX);
	static int count;
	char *ret;

	Str_sprintf( temp, "%s/~$%d$%s", 
				 path_dirname(filename), ++count, path_basename(filename) );
	ret = add_temp_file(Str_data(temp));

	STR_DELETE(temp);
	return ret;
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
									   renamed to filename at fclose() */
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
	
	elem = m_new( OpenFileElem );
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
			m_free( elem );
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

/* show error for a file */
static void file_error_filename( char *filename, Bool is_writing )
{
	/* call call-back, if any */
	if (ferr_callback != NULL)
		ferr_callback( filename, is_writing );
	else
		warn("Error: cannot %s file '%s'\n", is_writing ? "write" : "read", filename );
}

static void fatal_ferr_read( FILE *file )
{
    OpenFile *open_file = get_open_file( file );
	file_error_filename( open_file ? open_file->filename : "???", FALSE );
}

static void fatal_ferr_write( FILE *file )
{
    OpenFile *open_file = get_open_file( file );
	file_error_filename( open_file ? open_file->filename : "???", TRUE );
}

/*-----------------------------------------------------------------------------
*   File open and close
*----------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------
*   read/write Str
*----------------------------------------------------------------------------*/
void xfput_strz( FILE *file, char *str )
{
	xfwrite_bytes(str, strlen(str), file);
}

void xfput_Str( FILE *file, Str *str )
{
	xfwrite_bytes(Str_data(str), Str_len(str), file);
}

void xfget_Str( FILE *file, Str *str, size_t len )
{
	/* reserve space */
	Str_clear( str );
	Str_reserve( str, len );

	/* may fail if static string */
    if ( (int)len + 1 > str->size )
        fatal_ferr_read( file ); 			/* too long */

	xfread_bytes(Str_data(str), len, file);		/* characters */
    Str_data(str)[len] = '\0';					/* terminate string */
	Str_len(str) = len;							/* set lenght; Str_sync_len() only for
											   strings not including nulls */
}

/*-----------------------------------------------------------------------------
*   read/write counted string - string with size byte at start
*----------------------------------------------------------------------------*/
static void _xfput_count_byte_str( FILE *file, char *str, size_t len )
{
    if ( len > 0xFF )
        fatal_ferr_write( file );			/* too long */

    xfput_uint8( file, len & 0xFF );		/* byte count */
	xfwrite_bytes(str, len, file);			/* characters */
}

void xfput_count_byte_strz( FILE *file, char *str )
{
	_xfput_count_byte_str( file, str, strlen(str) );
}

void xfput_count_byte_Str( FILE *file, Str *str )
{
	_xfput_count_byte_str( file, Str_data(str), Str_len(str) );
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
	xfwrite_bytes(str, len, file);			/* characters */
}

void xfput_count_word_strz( FILE *file, char *str )
{
	_xfput_count_word_str( file, str, strlen(str) );
}

void xfput_count_word_Str( FILE *file, Str *str )
{
	_xfput_count_word_str( file, Str_data(str), Str_len(str) );
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
void xfput_int8( FILE *file, int value )
{
	xfput_uint8( file, (Byte) value );
}

void xfput_uint8( FILE *file, Byte value )
{
    if ( fputc( value, file ) < 0 )
        fatal_ferr_write( file );
}

int xfget_int8(  FILE *file )
{
	int value = (int)xfget_uint8( file );
    if ( value & 0x80 )
        value |= ~ 0xFF;				/* sign-extend above bit 7 */
	return value;
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
void xfput_int16( FILE *file, int value )
{
	xfput_uint16( file, (int) value );
}

void xfput_uint16( FILE *file, int value )
{
    Byte buffer[2];

	buffer[0] = value & 0xFF; value >>= 8;
	buffer[1] = value & 0xFF; value >>= 8;
	xfwrite_bytes((char *)buffer, sizeof(buffer), file);
}

int xfget_int16( FILE *file )
{
	int value = (int) xfget_uint16( file );
    if ( value & 0x8000 )
        value |= ~ 0xFFFF;			/* sign-extend above bit 15 */
	return value;
}

int xfget_uint16( FILE *file )
{
    Byte buffer[2];

	xfread_bytes(buffer, sizeof(buffer), file);
	return
        ( ( buffer[0] << 0 ) & 0x00FF ) |
        ( ( buffer[1] << 8 ) & 0xFF00 );
}

/*-----------------------------------------------------------------------------
*   read/write numbers - 32 bit
*----------------------------------------------------------------------------*/
void xfput_int32( FILE *file, int value )
{
	xfput_uint32(file, (unsigned int)value);
}

void xfput_uint32(FILE *file, unsigned int value)
{
    Byte buffer[4];

	buffer[0] = value & 0xFF; value >>= 8;
	buffer[1] = value & 0xFF; value >>= 8;
	buffer[2] = value & 0xFF; value >>= 8;
	buffer[3] = value & 0xFF; value >>= 8;
	xfwrite_bytes((char *)buffer, sizeof(buffer), file);
}

int xfget_int32( FILE *file )
{
	int value = (int) xfget_uint32( file );
    if ( value & 0x80000000L )
        value |= ~ 0xFFFFFFFFL;	/* sign-extend above bit 31; solve BUG_0021 */
	return value;
}

unsigned int xfget_uint32( FILE *file )
{
    Byte buffer[4];

	xfread_bytes(buffer, sizeof(buffer), file);
	return
        ( ( buffer[0] << 0 ) & 0x000000FF ) |
        ( ( buffer[1] << 8 ) & 0x0000FF00 ) |
        ( ( buffer[2] << 16 ) & 0x00FF0000 ) |
        ( ( buffer[3] << 24 ) & 0xFF000000 );
}

/*-----------------------------------------------------------------------------
*   Pathname manipulation
*   All filenames are returned in fixed length Str defined by
*	STR_DEFINE( dest, FILENAME_MAX )
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
    dot_pos   = strrchr( Str_data(dest), '.' );
    dir_pos_1 = strrchr( Str_data(dest), '/' );

    if ( dir_pos_1 == NULL ) dir_pos_1 = Str_data(dest);

    dir_pos_2 = strrchr( Str_data(dest), '\\' );

    if ( dir_pos_2 == NULL ) dir_pos_2 = Str_data(dest);

    if ( dot_pos != NULL && dot_pos > dir_pos_1 && dot_pos > dir_pos_2 )
    {
        *dot_pos = '\0';                /* terminate the string */
        Str_sync_len( dest );
    }
}

char *path_remove_ext( char *filename )
{
	STR_DEFINE(dest, FILENAME_MAX);
	char *ret;

	_path_remove_ext( dest, filename );
	ret = strpool_add(Str_data(dest));

	STR_DELETE(dest);
	return ret;
}

/* make a copy of the file name in strpool, replacing the extension */
char *path_replace_ext( char *filename, char *new_ext )
{
	STR_DEFINE(dest, FILENAME_MAX);
	char *ret;

    _path_remove_ext( dest, filename );

    if ( new_ext != NULL )
        Str_append( dest, new_ext );
	ret = strpool_add(Str_data(dest));

	STR_DELETE(dest);
	return ret;
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
	char path[FILENAME_MAX];
	snprintf(path, sizeof(path), "%s", filename);

	// remove last file component
	char *p = path + strlen(path);
	while (p > path && !(p[-1] == '/' || p[-1] == '\\')) p--;
	while (p > path && (p[-1] == '/' || p[-1] == '\\')) p--;
	*p = '\0';

	if (*path == '\0')		/* dir is now empty */
		snprintf(path, sizeof(path), ".");

	return strpool_add(path);
}

char *path_remove_slashes(char *filename)
{
	char path[FILENAME_MAX];
	snprintf(path, sizeof(path), "%s", filename);
	char *p = path + strlen(path);
	while (p > path && (p[-1] == '/' || p[-1] == '\\')) p--;
	*p = '\0';
	return strpool_add(path);
}

/* search for a file on the given directory list, return full path name */
static void path_search_1(Str *dest, char *filename, UT_array *dir_list, Str *pathname)
{
	char **pdir;
	
    Str_set( dest, filename );		/* default return: input file name */

    /* if no dir_list, return file */
    if ( dir_list == NULL )
        return;

    /* check if file exists in current directory */
	if (file_exists(filename))
		return;

    /* search in dir_list */
	for (pdir = NULL; (pdir = (char **)utarray_next(dir_list, pdir)) != NULL; )
    {
		Str_sprintf(pathname, "%s/%s", *pdir, filename);

		if (file_exists(Str_data(pathname))) {
            Str_set( dest, Str_data(pathname) );
            return;
        }
    }

    /* return unchanged pathname if not found */
    return;
}

void path_search(Str *dest, char *filename, UT_array *dir_list)
{
	STR_DEFINE(pathname, FILENAME_MAX);
	path_search_1(dest, filename, dir_list, pathname);
	STR_DELETE(pathname);
}

char *search_file( char *filename, UT_array *dir_list )
{
	STR_DEFINE(dest, FILENAME_MAX);
	char *ret;

    path_search( dest, filename, dir_list );
	ret = strpool_add(Str_data(dest));

	STR_DELETE(dest);
	return ret;
}

Bool file_exists(char *filename)
{
	struct stat  sb;
	if ((stat(filename, &sb) == 0)  && (sb.st_mode & S_IFREG))
		return TRUE;
	else
		return FALSE;
}

Bool dir_exists(char *dirname)
{
	struct stat  sb;
	if ((stat(dirname, &sb) == 0) && (sb.st_mode & S_IFDIR))
		return TRUE;
	else
		return FALSE;
}

int file_size(char *filename)	// file size, -1 if not regular file
{
	struct stat  sb;
	if ((stat(filename, &sb) == 0) && (sb.st_mode & S_IFREG))
		return sb.st_size;
	else
		return -1;
}

void mkdir_p(char *path)
{
	path = path_remove_slashes(path);
	if (!dir_exists(path)) {
		char *parent = path_dirname(path);
		mkdir_p(parent);

#ifdef _WIN32
		int rv = _mkdir(path);
#else
		int rv = mkdir(path, 0777);
#endif
		if (rv != 0) {
			perror(path);
			exit(1);
		}
	}
}
