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

Copyright (C) Paulo Custodio, 2011-2012

Utilities for file handling
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/file.c,v 1.12 2012-11-03 17:39:36 pauloscustodio Exp $ */
/* $Log: file.c,v $
/* Revision 1.12  2012-11-03 17:39:36  pauloscustodio
/* astyle, comments
/*
/* Revision 1.11  2012/10/28 17:22:56  pauloscustodio
/* BUG_0021: need sign extension in 64-bit architectures
/*
/* Revision 1.10  2012/06/14 15:01:27  pauloscustodio
/* Split safe strings from strutil.c to safestr.c
/*
/* Revision 1.9  2012/05/26 18:36:36  pauloscustodio
/* Replaced xfputc and friends with fputc_err, raising a fatal_error() instead of an
/* exception, moved to errors.c
/*
/* Revision 1.8  2012/05/24 21:44:00  pauloscustodio
/* New search_file() to search file in a StrList
/*
/* Revision 1.7  2012/05/24 17:09:27  pauloscustodio
/* Unify copyright header
/*
/* Revision 1.6  2012/05/11 19:29:49  pauloscustodio
/* Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
/*         --mode=c
/*         --lineend=linux
/*         --indent=spaces=4
/*         --style=ansi --add-brackets
/*         --indent-switches --indent-classes
/*         --indent-preprocessor --convert-tabs
/*         --break-blocks
/*         --pad-oper --pad-paren-in --pad-header --unpad-paren
/*         --align-pointer=name
/*
/* Revision 1.5  2011/10/14 14:54:54  pauloscustodio
/* - New path_basename() in file.c, change functions to return result string
/*  pointer.
/*
/* Revision 1.4  2011/09/30 10:30:06  pauloscustodio
/* BUG_0014 : -x./zx_clib should create ./zx_clib.lib but actually creates .lib
/* (reported on Tue, Sep 27, 2011 at 8:09 PM by dom)
/* path_remove_ext() removed everything after last ".", ignoring directory
/*  separators. Fixed.
/*
/* Revision 1.3  2011/08/21 20:21:21  pauloscustodio
/* CH_0005 : handle files as char[FILENAME_MAX] instead of strdup for every operation
/* - Factor all pathname manipulation into module file.c.
/*
/* Revision 1.2  2011/08/18 23:27:54  pauloscustodio
/* BUG_0009 : file read/write not tested for errors
/* - In case of disk full file write fails, but assembler does not detect the error
/*   and leaves back corruped object/binary files
/* - Created new exception FileIOException and ERR_FILE_IO error.
/* - Created new functions fputc_err, fgetc_err, ... to raise the exception on error.
/*
/* Revision 1.1  2011/08/18 21:42:05  pauloscustodio
/* Utilities for file handling
/*
/* */

#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>

#include "file.h"
#include "config.h"
#include "strutil.h"
#include "safestr.h"
#include "strpool.h"
#include "errors.h"

/*-----------------------------------------------------------------------------
*   File IO with exception
*----------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------
*   File IO words and longs
*----------------------------------------------------------------------------*/
void fputw_err( size_t word, FILE *stream )
{
    char buffer[2] =
    {
        ( word >> 0 ) & 0xFF,
        ( word >> 8 ) & 0xFF
    };
    fwritec_err( buffer, sizeof( buffer ), stream );
}

size_t fgetw_err( FILE *stream )
{
    char buffer[2];
    freadc_err( buffer, sizeof( buffer ), stream );
    return
        ( ( buffer[0] << 0 ) & 0x00FF ) |
        ( ( buffer[1] << 8 ) & 0xFF00 );
}

void fputl_err( long dword, FILE *stream )
{
    char buffer[4] =
    {
        ( dword >> 0 ) & 0xFF,
        ( dword >> 8 ) & 0xFF,
        ( dword >> 16 ) & 0xFF,
        ( dword >> 24 ) & 0xFF
    };
    fwritec_err( buffer, sizeof( buffer ), stream );
}

long fgetl_err( FILE *stream )
{
    char buffer[4];
    long retval;

    freadc_err( buffer, sizeof( buffer ), stream );
    retval =
        ( ( buffer[0] << 0 ) & 0x000000FF ) |
        ( ( buffer[1] << 8 ) & 0x0000FF00 ) |
        ( ( buffer[2] << 16 ) & 0x00FF0000 ) |
        ( ( buffer[3] << 24 ) & 0xFF000000 );

    /* BUG_0021: sign extend if bit 31 is on */
    if ( retval & 0x80000000L )
    {
        retval |= ~ 0xFFFFFFFFL;
    }

    return retval;
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
    int length;

    dest[0] = '\0';                     /* prepare for strncat */
    strncat( dest, source, FILENAME_MAX - 1 );

    path_remove_ext( dest );            /* file without extension */

    /* copy extension, make sure the final file fits in FILENAME_MAX-1 */
    length = strlen( dest );
    strncat( dest + length, new_ext, FILENAME_MAX - 1 - length );

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

    dest[0] = '\0';                     /* prepare for strncat */
    strncat( dest, basename, FILENAME_MAX - 1 );

    return dest;
}


/*-----------------------------------------------------------------------------
*  Search for a file on the given directory list, return full path name
*  pathname is stored in strpool, no need to remove
*----------------------------------------------------------------------------*/
char *search_file( char *filename, StrList *dir_list )
{
    StrListElem *iter;
    char        *dir;
    struct stat sb;
    SSTR_DEFINE( pathname, FILENAME_MAX );

    /* check if file exists in current directory */
    if ( stat( filename, &sb ) == 0 )
    {
        return strpool_add( filename );
    }

    /* search in dir_list */
    StrList_first( dir_list, &iter );

    while ( dir = StrList_next( dir_list, &iter ) )
    {
        sstr_fset( pathname, "%s/%s", dir, filename );

        if ( stat( sstr_data( pathname ), &sb ) == 0 )
        {
            return strpool_add( sstr_data( pathname ) );
        }
    }

    /* return unchanged pathname if not found */
    return strpool_add( filename );
}
