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
#include "strpool.h"
#include "str.h"
#include "uthash.h"

#include <assert.h>
#include <stdarg.h>
#include <sys/stat.h>
#ifdef _WIN32
#include <direct.h>
#endif

#ifdef _MSC_VER
#define snprintf _snprintf
#endif

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

bool file_exists(char *filename)
{
	struct stat  sb;
	if ((stat(filename, &sb) == 0)  && (sb.st_mode & S_IFREG))
		return true;
	else
		return false;
}

bool dir_exists(char *dirname)
{
	struct stat  sb;
	if ((stat(dirname, &sb) == 0) && (sb.st_mode & S_IFDIR))
		return true;
	else
		return false;
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
