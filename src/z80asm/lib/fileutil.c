/*
Utilities working files.

Copyright (C) Paulo Custodio, 2011-2013

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/fileutil.c,v 1.4 2014-01-11 00:10:39 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */
#include "fileutil.h"
#include "strutil.h"
#include "strpool.h"

/*-----------------------------------------------------------------------------
*   Pathname manipulation
*   All filenames are returned in fixed length Str defined by
*	DEFINE_STR( dest, FILENAME_MAX ) or DEFINE_FILE_STR( dest )
*	Input string is unchanged.
*	Basename is file name removing all directories.
*	Extension is the final "." followed by sequence of letters or digits
*----------------------------------------------------------------------------*/

/* remove the extension of the filename, returns in passed Str */
void path_remove_ext( Str *dest, char *filename )
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

/* make a copy of the file name in strpool, replacing the extension */
void path_replace_ext( Str *dest, char *filename, char *new_ext )
{
    path_remove_ext( dest, filename );

    if ( new_ext != NULL )
        Str_append( dest, new_ext );
}

/* make a copy of the file basename, skipping the directory part */
void path_basename( Str *dest, char *filename )
{
    char *dir_pos_1, *dir_pos_2, *basename;

    dir_pos_1 = strrchr( filename, '/' );

    if ( dir_pos_1 == NULL ) dir_pos_1 = filename - 1;

    dir_pos_2 = strrchr( filename, '\\' );

    if ( dir_pos_2 == NULL ) dir_pos_2 = filename - 1;

    basename = MAX( dir_pos_1, dir_pos_2 ) + 1;
    Str_set( dest, basename );
}

/* search for a file on the given directory list, return full path name */
extern void path_search( Str *dest, char *filename, List *dir_list )
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
* Revision 1.4  2014-01-11 00:10:39  pauloscustodio
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


