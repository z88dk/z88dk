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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/file.h,v 1.12 2013-04-06 13:15:04 pauloscustodio Exp $
$Log: file.h,v $
Revision 1.12  2013-04-06 13:15:04  pauloscustodio
Move default asm and obj extension handling to file.c.
srcfilename and objfilename are now pointers to static variables in file.c

Revision 1.11  2013/04/04 23:08:18  pauloscustodio
Helper functions to create file names of each of the extensions used in z80asm

Revision 1.10  2013/02/27 20:44:32  pauloscustodio
Renamed StrList to SzList to solve conflict with CLASS_LIST( Str ) also generating a class StrList
search_file() now accepts a NULL dir_list.

Revision 1.9  2013/01/20 21:24:28  pauloscustodio
Updated copyright year to 2013

Revision 1.8  2012/05/26 18:36:36  pauloscustodio
Replaced xfputc and friends with fputc_err, raising a fatal_error() instead of an
exception, moved to errors.c

Revision 1.7  2012/05/24 21:44:00  pauloscustodio
New search_file() to search file in a StrList

Revision 1.6  2012/05/24 17:09:27  pauloscustodio
Unify copyright header

Revision 1.5  2012/05/11 19:29:49  pauloscustodio
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

Revision 1.4  2011/10/14 14:54:54  pauloscustodio
- New path_basename() in file.c, change functions to return result string
 pointer.

Revision 1.3  2011/08/21 20:21:21  pauloscustodio
CH_0005 : handle files as char[FILENAME_MAX] instead of strdup for every operation
- Factor all pathname manipulation into module file.c.

Revision 1.2  2011/08/18 23:27:54  pauloscustodio
BUG_0009 : file read/write not tested for errors
- In case of disk full file write fails, but assembler does not detect the error
  and leaves back corruped object/binary files
- Created new exception FileIOException and ERR_FILE_IO error.
- Created new functions fputc_err, fgetc_err, ... to raise the exception on error.

Revision 1.1  2011/08/18 21:42:05  pauloscustodio
Utilities for file handling

*/

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

/* default file name extensions */
#define FILEEXT_ASM     FILEEXT_SEPARATOR "asm"    /* ".asm" / "_asm" */
#define FILEEXT_LST     FILEEXT_SEPARATOR "lst"    /* ".lst" / "_lst" */
#define FILEEXT_OBJ     FILEEXT_SEPARATOR "obj"    /* ".obj" / "_obj" */
#define FILEEXT_DEF     FILEEXT_SEPARATOR "def"    /* ".def" / "_def" */
#define FILEEXT_ERR     FILEEXT_SEPARATOR "err"    /* ".err" / "_err" */
#define FILEEXT_BIN     FILEEXT_SEPARATOR "bin"    /* ".bin" / "_bin" */
#define FILEEXT_SEGBIN  FILEEXT_SEPARATOR "bn0"    /* ".bn0" / "_bn0" */
#define FILEEXT_LIB     FILEEXT_SEPARATOR "lib"    /* ".lib" / "_lib" */
#define FILEEXT_SYM     FILEEXT_SEPARATOR "sym"    /* ".sym" / "_sym" */
#define FILEEXT_MAP     FILEEXT_SEPARATOR "map"    /* ".map" / "_map" */

/* return address of static buffer with copy of filename converted to .XXX extension 
   NOT REENTRANT! */
extern char *asm_filename_ext( char *filename );
extern char *lst_filename_ext( char *filename );
extern char *obj_filename_ext( char *filename );
extern char *def_filename_ext( char *filename );
extern char *err_filename_ext( char *filename );
extern char *bin_filename_ext( char *filename );
extern char *segbin_filename_ext( char *filename );
extern char *lib_filename_ext( char *filename );
extern char *sym_filename_ext( char *filename );
extern char *map_filename_ext( char *filename );

/* define new extensions for asm and obj, instead of default */
extern void set_asm_ext( char *ext );
extern void set_obj_ext( char *ext );

extern char *get_asm_ext( void );
extern char *get_obj_ext( void );

/* search for a file on the given directory list, return full path name
 * pathname is stored in strpool, no need to remove */
extern char *search_file( char *filename, SzList *dir_list );

#endif /* ndef FILE_H */

