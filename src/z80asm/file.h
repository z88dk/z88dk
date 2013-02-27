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

Utilities for file handling
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/file.h,v 1.10 2013-02-27 20:44:32 pauloscustodio Exp $ */
/* $Log: file.h,v $
/* Revision 1.10  2013-02-27 20:44:32  pauloscustodio
/* Renamed StrList to SzList to solve conflict with CLASS_LIST( Str ) also generating a class StrList
/* search_file() now accepts a NULL dir_list.
/*
/* Revision 1.9  2013/01/20 21:24:28  pauloscustodio
/* Updated copyright year to 2013
/*
/* Revision 1.8  2012/05/26 18:36:36  pauloscustodio
/* Replaced xfputc and friends with fputc_err, raising a fatal_error() instead of an
/* exception, moved to errors.c
/*
/* Revision 1.7  2012/05/24 21:44:00  pauloscustodio
/* New search_file() to search file in a StrList
/*
/* Revision 1.6  2012/05/24 17:09:27  pauloscustodio
/* Unify copyright header
/*
/* Revision 1.5  2012/05/11 19:29:49  pauloscustodio
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
/* Revision 1.4  2011/10/14 14:54:54  pauloscustodio
/* - New path_basename() in file.c, change functions to return result string
/*  pointer.
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

#ifndef FILE_H
#define FILE_H

#include "memalloc.h"   /* before any other include */
#include "strlist.h"

#include <stdio.h>

/* read/write words and longs */
extern void   fputw_err( size_t word, FILE *stream );
extern size_t fgetw_err( FILE *stream );

extern void   fputl_err( long dword,  FILE *stream );
extern long   fgetl_err( FILE *stream );

/* pathname manipulation
 * All filenames are passed as char file[FILENAME_MAX] elements, instead of always strdup'ing
 */
extern char *path_remove_ext( char *filename );
extern char *path_replace_ext( char *dest, const char *source, const char *new_ext );
extern char *path_basename( char *dest, const char *source );

/* search for a file on the given directory list, return full path name
 * pathname is stored in strpool, no need to remove */
extern char *search_file( char *filename, SzList *dir_list );

#endif /* ndef FILE_H */

