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

Copyright (C) Paulo Custodio, 2011-2013

Utilities for file handling, raise fatal errors on failure

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/file.c,v 1.35 2013-11-11 23:47:03 pauloscustodio Exp $
*/

#include "memalloc.h"   /* before any other include */

#include "file.h"
#include "listfile.h"
#include "options.h"
#include "strpool.h"
#include "errors.h"

/*-----------------------------------------------------------------------------
*   Initialize and Terminate functions called by init()
*----------------------------------------------------------------------------*/
void struct_File_init(struct File *self, char *filename, char *mode)
{
    FILE *fp     = xfopen( filename, mode );
	BOOL writing = strchr(mode, 'w') ? TRUE : FALSE;

	/* init structure */
	self->fp		= fp;
	self->filename	= strpool_add(filename);
	self->text		= g_string_new("");
	self->writing	= writing;
}

void struct_File_fini(struct File *self)
{
	if ( self->fp )
	{
		close_File( self );
	
		/* delete file if writing */
		if ( self->writing )
			unlink( self->filename );
	}

	/* free string and data */
	if ( self->text )
	{
		g_string_free( self->text, TRUE );		
		self->text = NULL;
	}

}

/*-----------------------------------------------------------------------------
*   close an open file
*   if not called, delete_File() will delete a file open for writing
*----------------------------------------------------------------------------*/
void close_File(struct File *self)
{
	if ( self->fp )
	{
		xfclose( self->fp );
		self->fp = NULL;
	}
}

/*-----------------------------------------------------------------------------
*   Pathname manipulation
*   All filenames are passed as char file[FILENAME_MAX] elements
*   return string is written to passed buffer and returned by the function
*----------------------------------------------------------------------------*/

/* remove the extension of the passed filename, modifies the string in place */
char *path_remove_ext( char *filename )
{
    char *dot_pos = strrchr( filename, FILEEXT_SEPARATOR[0] );
    char *dir_pos;

    if ( dot_pos != NULL )
    {
        /* BUG_0014 : need to ignore dot if before a directory separator */
        dir_pos = strrchr( filename, '/' );

        if ( dir_pos != NULL && dot_pos < dir_pos )
        {
            return filename;    /* dot before slash */
        }

        dir_pos = strrchr( filename, '\\' );

        if ( dir_pos != NULL && dot_pos < dir_pos )
        {
            return filename;    /* dot before backslash */
        }

        *dot_pos = '\0';                /* terminate the string */
    }

    return filename;
}

/* make a copy of the file name, replacing the extension */
char *path_replace_ext( char *dest, const char *source, const char *new_ext )
{
	g_strlcpy( dest, source, FILENAME_MAX );
    path_remove_ext( dest );						/* file without extension */
	g_strlcat( dest, new_ext, FILENAME_MAX );		/* copy new extension */

    return dest;
}

/* make a copy of the file basename, skipping the directory part */
char *path_basename( char *dest, const char *source )
{
    const char *path_sep1, *path_sep2, *basename;

    path_sep1 = strrchr( source, '/' );

    if ( path_sep1 == NULL )
    {
        path_sep1 = source - 1;
    }

    path_sep2 = strrchr( source, '\\' );

    if ( path_sep2 == NULL )
    {
        path_sep2 = source - 1;
    }

    if ( path_sep1 > path_sep2 )
    {
        basename = path_sep1 + 1;
    }
    else
    {
        basename = path_sep2 + 1;
    }

	g_strlcpy( dest, basename, FILENAME_MAX );

    return dest;
}

/*-----------------------------------------------------------------------------
*  Search for a file on the given directory list, return full path name
*  pathname is stored in strpool, no need to remove
*----------------------------------------------------------------------------*/
char *search_file( char *filename, StringList *dir_list )
{
    char        *dir;
    struct stat sb;
    char		pathname[ FILENAME_MAX ];

	/* if no dir_list, return file */
	if ( dir_list == NULL )
        return strpool_add( filename );

    /* check if file exists in current directory */
    if ( stat( filename, &sb ) == 0 )
        return strpool_add( filename );

    /* search in dir_list */
	FOR_StringList( dir_list, dir )
	{
		g_snprintf( pathname, sizeof(pathname), "%s/%s", dir, filename );
        if ( stat( pathname, &sb ) == 0 )
            return strpool_add( pathname );
	}
	ENDFOR_StringList;

    /* return unchanged pathname if not found */
    return strpool_add( filename );
}







/*-----------------------------------------------------------------------------
*   TODO: remove old interface down this line
*----------------------------------------------------------------------------*/






#include "class.h"
#include "config.h"
#include "file.h"
#include "safestr.h"
#include "strpool.h"
#include "strutil.h"
#include "uthash.h"
#include <sys/stat.h>
#include <sys/types.h>

/*-----------------------------------------------------------------------------
*	Keep hash table of FILE* to file names for error messages
*----------------------------------------------------------------------------*/
typedef struct OpenFileElem
{
    FILE    *file; 					/* file pointer returned by fopen */
	char    *filename;				/* file name kept in strpool.h */
	
    UT_hash_handle hh;      		/* hash table */

} OpenFileElem;

CLASS( OpenFile )
	OpenFileElem *hash;				/* keep hash of all open files */
END_CLASS;

DEF_CLASS( OpenFile );

void OpenFile_init( OpenFile *self ) { }

void OpenFile_copy( OpenFile *self, OpenFile *other ) { }

void OpenFile_fini( OpenFile *self )
{
    OpenFileElem *elem, *tmp;

    HASH_ITER( hh, self->hash, elem, tmp )
    {
        HASH_DEL( self->hash, elem );
        g_free0( elem );
    }
}

static OpenFile *open_files = NULL;	/* sigleton */

#define init_open_files()	( open_files == NULL ? (open_files = OBJ_NEW( OpenFile )) : open_files )

/* file names are only deleted on end of program, to be able to show error message on 2nd fclose */
static void add_filename( FILE *file, char *filename )
{
	OpenFileElem *elem;

	init_open_files();

    /* check if file exists already */
    HASH_FIND_PTR( open_files->hash, &file, elem );
    if ( elem )
    {
		/* found, replace name */
		elem->filename 	= strpool_add(filename);		
    }
	else
	{
		/* new, create hash entry */
		elem = g_new0(OpenFileElem, 1);
		elem->file 		= file;
		elem->filename 	= strpool_add(filename);		
		
		HASH_ADD_PTR( open_files->hash, file, elem );
	}	
}

static char *get_filename( FILE *file )
{
	OpenFileElem *elem;

	init_open_files();

    /* check if file exists already */
    HASH_FIND_PTR( open_files->hash, &file, elem );
    
	return elem ? elem->filename : "???";	
}

/*-----------------------------------------------------------------------------
*   File open and close
*----------------------------------------------------------------------------*/
void xstat( char *filename, struct stat *filestat )
{
    int result = stat( filename, filestat );

    if ( result < 0 )
        fatal_read_file( filename );
}

FILE *xfopen( char *filename, char *mode )
{
    FILE *file = fopen( filename, mode );
    if ( file == NULL )
	{
		if ( strchr(mode, 'r') )
			fatal_read_file( filename );
		else
			fatal_write_file( filename );
	}

	add_filename( file, filename );		/* never deleted from hash */
    return file;
}

void xfclose( FILE *file )
{
	int result = fclose( file );
	if ( result < 0 )
		fatal_close_file( get_filename(file) );
}

/*-----------------------------------------------------------------------------
*   Buffers
*----------------------------------------------------------------------------*/
void xfwrite( const void *buffer, size_t size, size_t count, FILE *file )
{
    size_t written = fwrite( buffer, size, count, file );
    if ( written != count )
        fatal_write_file( get_filename(file) );
}

void xfread( void *buffer, size_t size, size_t count, FILE *file )
{
    size_t read = fread( buffer, size, count, file );
    if ( read != count )
        fatal_read_file( get_filename(file) );
}

void xfput_char( const char *buffer, size_t len, FILE *file )
{
	xfwrite( buffer, sizeof(char), len, file );
}

void xfget_char( char *buffer, size_t len, FILE *file )
{
	xfread( buffer, sizeof(char), len, file );
}

/*-----------------------------------------------------------------------------
*   Read / write 8 bits
*----------------------------------------------------------------------------*/
void xfput_u8( int value, FILE *file )
{
    int result = fputc( value, file );
    if ( result < 0 )
        fatal_write_file( get_filename(file) );
}

int xfget_u8( FILE *file )
{
    int result = getc( file );
    if ( result < 0 )
        fatal_read_file( get_filename(file) );
    return result;
}

int xfget_i8( FILE *file )
{
	int result = xfget_u8( file );
    if ( result & 0x80 )
        result |= ~ 0xFF;
	return result;
}

/*-----------------------------------------------------------------------------
*   Read / write 16 bits
*----------------------------------------------------------------------------*/
void xfput_u16( int value, FILE *file )
{
    char buffer[2] =
    {
        (value & 0x00FF) >> 0,
        (value & 0xFF00) >> 8
    };
    xfput_char( buffer, sizeof(buffer), file );
}

int xfget_u16( FILE *file )
{
    char buffer[2];
    xfget_char( buffer, sizeof(buffer), file );
    return
        ( ( buffer[0] << 0 ) & 0x00FF ) |
        ( ( buffer[1] << 8 ) & 0xFF00 );
}

int xfget_i16( FILE *file )
{
	int result = xfget_u16( file );
    if ( result & 0x8000 )
        result |= ~ 0xFFFF;
	return result;
}

/*-----------------------------------------------------------------------------
*   Read / write 32 bits
*----------------------------------------------------------------------------*/
void xfput_u32( long value, FILE *file )
{
    char buffer[4] =
    {
        (char)((value & 0x000000FF) >> 0),
        (char)((value & 0x0000FF00) >> 8),
        (char)((value & 0x00FF0000) >> 16),
        (char)((value & 0xFF000000) >> 24)
    };
    xfput_char( buffer, sizeof(buffer), file );
}

long xfget_u32( FILE *file )
{
    char buffer[4];

    xfget_char( buffer, sizeof( buffer ), file );
    return
        ( ( buffer[0] << 0  ) & 0x000000FF ) |
        ( ( buffer[1] << 8  ) & 0x0000FF00 ) |
        ( ( buffer[2] << 16 ) & 0x00FF0000 ) |
        ( ( buffer[3] << 24 ) & 0xFF000000 );
}

long xfget_i32( FILE *file )
{
	long result = xfget_u32( file );
    if ( result & 0x80000000L )		/* BUG_0021: sign extend if bit 31 is on */
        result |= ~ 0xFFFFFFFFL;
    return result;
}

/*-----------------------------------------------------------------------------
*   Read / write sstr_t
*----------------------------------------------------------------------------*/
void xfput_sstr( sstr_t *str, FILE *file )
{
	xfput_char( sstr_data(str), sstr_len(str), file );
}

void xfget_sstr( sstr_t *str, size_t len, FILE *file )
{
	if ( len + 1 > str->size )
		fatal_read_file( get_filename(file) );/* too long */
	
	xfget_char( sstr_data(str), len, file );				/* characters */
	sstr_data(str)[len] = '\0';								/* terminate string */
	sstr_sync_len(str);
}

/*-----------------------------------------------------------------------------
*   Read / write Counted strings
*----------------------------------------------------------------------------*/

/* read/write sstr_t byte-counted strings (1 byte size + string chars) with error check */
void xfput_c1sstr( sstr_t *str, FILE *file )
{
	if ( sstr_len(str) > 0xFF )
		fatal_write_file( get_filename(file) );					/* too long */
	xfput_u8( sstr_len(str), file );							/* byte count */
	xfput_sstr( str, file );									/* characters */
}

void xfget_c1sstr( sstr_t *str, FILE *file )
{
	size_t len = xfget_u8( file );								/* byte count */
	xfget_sstr( str, len, file );
}

/* read/write sstr_t word-counted strings (2 bytes size + string chars) with error check */
void xfput_c2sstr( sstr_t *str, FILE *file )
{
	if ( sstr_len(str) > 0xFFFF )
		fatal_write_file( get_filename(file) );					/* too long */
	xfput_u16( sstr_len(str), file );							/* word count */
	xfput_sstr( str, file );									/* characters */
}

void xfget_c2sstr( sstr_t *str, FILE *file )
{
	size_t len = xfget_u16( file );								/* word count */
	xfget_sstr( str, len, file );
}


/*
$Log: file.c,v $
Revision 1.35  2013-11-11 23:47:03  pauloscustodio
Move source code generation tools to dev/Makefile, only called on request,
and keep the generated files in z80asm directory, so that build does
not require tools used for the code generation (ragel, perl).
Remove code generation for structs - use CLASS macro instead.

Revision 1.34  2013/10/16 21:42:06  pauloscustodio
Allocate minimum-sized string, grow as needed.
Allocate a GString text inside of File, to be used by file reading methods.

Revision 1.33  2013/10/16 00:14:37  pauloscustodio
Move FileStack implementation to scan.c, remove FileStack.
Move getline_File() to scan.c.

Revision 1.32  2013/10/15 23:24:31  pauloscustodio
Move reading by lines or tokens and file reading interface to scan.rl
to decouple file.c from scan.c.
Add singleton interface to scan to be used by parser.

Revision 1.31  2013/10/08 21:53:06  pauloscustodio
Replace Flex-based lexer by a Ragel-based one.
Add interface to file.c to read files by tokens, calling the lexer.

Revision 1.30  2013/10/01 21:27:44  pauloscustodio
warnings

Revision 1.29  2013/09/30 00:24:25  pauloscustodio
Parse command line options via look-up tables:
-e, --asm-ext
-M, --obj-ext
Move filename extension functions to options.c

Revision 1.28  2013/09/26 21:38:08  pauloscustodio
Set error location while reading files.
Delete File object when popping from FileStack.

Revision 1.27  2013/09/23 23:14:10  pauloscustodio
Renamed SzList to StringList, simplified interface by assuming that
list lives in memory util program ends; it is used for directory searches
only. Moved interface to strutil.c, removed strlist.c.

Revision 1.26  2013/09/22 21:34:48  pauloscustodio
Remove legacy xxx_err() interface

Revision 1.25  2013/09/22 21:04:21  pauloscustodio
New File and FileStack objects

Revision 1.23  2013/09/08 08:29:21  pauloscustodio
Replaced xmalloc et al with g_malloc0 et al.

Revision 1.22  2013/09/08 00:43:59  pauloscustodio
New error module with one error function per error, no need for the error
constants. Allows compiler to type-check error message arguments.
Included the errors module in the init() mechanism, no need to call
error initialization from main(). Moved all error-testing scripts to
one file errors.t.

Revision 1.21  2013/09/01 18:46:01  pauloscustodio
Remove call to strpool_init(). String pool is initialized in init.c before main() starts.

Revision 1.20  2013/05/12 19:20:34  pauloscustodio
warnings

Revision 1.19  2013/05/11 00:29:26  pauloscustodio
CH_0021 : Exceptions on file IO show file name
Keep a hash table of all opened file names, so that the file name
is shown on a fatal error.
Rename file IO funtions: f..._err to xf...

Revision 1.18  2013/04/06 13:15:04  pauloscustodio
Move default asm and obj extension handling to file.c.
srcfilename and objfilename are now pointers to static variables in file.c

Revision 1.17  2013/04/04 23:08:18  pauloscustodio
Helper functions to create file names of each of the extensions used in z80asm

Revision 1.16  2013/03/30 00:02:22  pauloscustodio
include memalloc.h before any other include

Revision 1.15  2013/02/27 20:44:32  pauloscustodio
Renamed StrList to SzList to solve conflict with CLASS_LIST( Str ) also generating a class StrList
search_file() now accepts a NULL dir_list.

Revision 1.14  2013/02/25 21:36:17  pauloscustodio
Uniform the APIs of classhash, classlist, strhash, strlist

Revision 1.13  2013/01/20 21:24:28  pauloscustodio
Updated copyright year to 2013

Revision 1.12  2012/11/03 17:39:36  pauloscustodio
astyle, comments

Revision 1.11  2012/10/28 17:22:56  pauloscustodio
BUG_0021: need sign extension in 64-bit architectures

Revision 1.10  2012/06/14 15:01:27  pauloscustodio
Split safe strings from strutil.c to safestr.c

Revision 1.9  2012/05/26 18:36:36  pauloscustodio
Replaced xfputc and friends with xfput_u8, raising a fatal_error() instead of an
exception, moved to errors.c

Revision 1.8  2012/05/24 21:44:00  pauloscustodio
New search_file() to search file in a StrList

Revision 1.7  2012/05/24 17:09:27  pauloscustodio
Unify copyright header

Revision 1.6  2012/05/11 19:29:49  pauloscustodio
Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
        --mode=c
        --lineend=linux
        --indent=spaces=4
        --style=ansi --add-brackets
        --indent-switches --indent-classes
        --indent-preprocessor --convert-tabs
        --break-blocks
        --pad-oper --pad-paren-in --pad-header --unpad-paren
        --align-pointer=name

Revision 1.5  2011/10/14 14:54:54  pauloscustodio
- New path_basename() in file.c, change functions to return result string
 pointer.

Revision 1.4  2011/09/30 10:30:06  pauloscustodio
BUG_0014 : -x./zx_clib should create ./zx_clib.lib but actually creates .lib
(reported on Tue, Sep 27, 2011 at 8:09 PM by dom)
path_remove_ext() removed everything after last ".", ignoring directory
 separators. Fixed.

Revision 1.3  2011/08/21 20:21:21  pauloscustodio
CH_0005 : handle files as char[FILENAME_MAX] instead of strdup for every operation
- Factor all pathname manipulation into module file.c.

Revision 1.2  2011/08/18 23:27:54  pauloscustodio
BUG_0009 : file read/write not tested for errors
- In case of disk full file write fails, but assembler does not detect the error
  and leaves back corruped object/binary files
- Created new exception FileIOException and ERR_FILE_IO error.
- Created new functions xfput_u8, xfget_u8, ... to raise the exception on error.

Revision 1.1  2011/08/18 21:42:05  pauloscustodio
Utilities for file handling

*/
