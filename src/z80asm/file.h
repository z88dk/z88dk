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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/file.h,v 1.30 2014-01-11 00:10:39 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */

#include "types.h"

#if 0
/*-----------------------------------------------------------------------------
*   Object representing an open file
*	Files open for writing and not closed are removed on exit, to avoid
*	having half-created files left over on errors.
*----------------------------------------------------------------------------*/
typedef struct File
{
    FILE	*fp;			/* open file handle */
    char	*filename;		/* name of file, kept in strpool */
    GString	*text;			/* reading text buffer */
    BOOL	 writing;		/* TRUE if writing, FALSE if reading */
}
File;

extern void struct_File_init( File *self, char *filename, char *mode );
extern void struct_File_fini( File *self );

/* close an open file
   if not called, delete_File() will delete a file open for writing */
extern void close_File( File *self );
#endif




/*-----------------------------------------------------------------------------
*   TODO: remove old interface down this line
*----------------------------------------------------------------------------*/




#include "config.h"
#include "strutil.h"
#include "types.h"
#include <stdio.h>
#include <sys/stat.h>


/* OS interface with fatal errors on failure */
extern void  xstat( char *filename, struct stat *filestat );
extern FILE *xfopen( char *filename, char *mode );
extern void  xfclose( FILE *file );

/* read/write buffers */
extern void xfwrite( const void *buffer, size_t size, size_t count, FILE *file );
extern void xfread( void *buffer, size_t size, size_t count, FILE *file );          /* EOF is fatal */

extern void xfput_char( const char *buffer, size_t len, FILE *file );
extern void xfget_char( char *buffer, size_t len, FILE *file );         /* EOF is fatal */

/* read/write numbers */
extern void  xfput_u8( int value, FILE *file );
extern int   xfget_u8( FILE *file );   /* EOF is fatal */
extern int   xfget_i8( FILE *file );   /* EOF is fatal */

extern void  xfput_u16( int value, FILE *file );
extern int   xfget_u16( FILE *file );   /* EOF is fatal */
extern int   xfget_i16( FILE *file );   /* EOF is fatal */

extern void  xfput_u32( long value, FILE *file );
extern long  xfget_u32( FILE *file );   /* EOF is fatal */
extern long  xfget_i32( FILE *file );   /* EOF is fatal */

/* read/write Str */
extern void  xfput_sstr( Str *str, FILE *file );
extern void  xfget_sstr( Str *str, size_t len, FILE *file );

/* read/write Str byte-counted strings (1 byte size + string chars) */
extern void   xfput_c1sstr( Str *str, FILE *file );
extern void   xfget_c1sstr( Str *str, FILE *file );

/* read/write Str word-counted strings (2 bytes size + string chars) */
extern void   xfput_c2sstr( Str *str, FILE *file );
extern void   xfget_c2sstr( Str *str, FILE *file );

/*
$Log: file.h,v $
Revision 1.30  2014-01-11 00:10:39  pauloscustodio
Astyle - format C code
Add -Wall option to CFLAGS, remove all warnings

Revision 1.29  2014/01/10 00:15:25  pauloscustodio
Use Str instead of glib, List instead of GSList.
Use init.h mechanism, no need for main() calling init_scan.
glib dependency removed from code and Makefile

Revision 1.28  2014/01/02 17:18:16  pauloscustodio
StrList removed, replaced by List

Revision 1.27  2014/01/01 21:23:48  pauloscustodio
Move generic file utility functions to lib/fileutil.c

Revision 1.26  2013/12/30 02:05:32  pauloscustodio
Merge dynstr.c and safestr.c into lib/strutil.c; the new Str type
handles both dynamically allocated strings and fixed-size strings.
Replaced g_strchomp by chomp by; g_ascii_tolower by tolower;
g_ascii_toupper by toupper; g_ascii_strcasecmp by stricompare.

Revision 1.25  2013/12/26 23:42:27  pauloscustodio
Replace StringList from strutil by StrList in new strlis.c, to keep lists of strings (e.g. directory search paths)

Revision 1.24  2013/12/15 13:18:33  pauloscustodio
Move memory allocation routines to lib/xmalloc, instead of glib,
introduce memory leak report on exit and memory fence check.

Revision 1.23  2013/10/16 21:42:06  pauloscustodio
Allocate minimum-sized string, grow as needed.
Allocate a GString text inside of File, to be used by file reading methods.

Revision 1.22  2013/10/16 00:14:37  pauloscustodio
Move FileStack implementation to scan.c, remove FileStack.
Move getline_File() to scan.c.

Revision 1.21  2013/10/15 23:24:31  pauloscustodio
Move reading by lines or tokens and file reading interface to scan.rl
to decouple file.c from scan.c.
Add singleton interface to scan to be used by parser.

Revision 1.20  2013/10/08 21:53:06  pauloscustodio
Replace Flex-based lexer by a Ragel-based one.
Add interface to file.c to read files by tokens, calling the lexer.

Revision 1.19  2013/09/30 00:24:25  pauloscustodio
Parse command line options via look-up tables:
-e, --asm-ext
-M, --obj-ext
Move filename extension functions to options.c

Revision 1.18  2013/09/29 21:40:13  pauloscustodio
include

Revision 1.17  2013/09/27 01:14:33  pauloscustodio
Parse command line options via look-up tables:
--help, --verbose

Revision 1.16  2013/09/23 23:14:10  pauloscustodio
Renamed SzList to StringList, simplified interface by assuming that
list lives in memory util program ends; it is used for directory searches
only. Moved interface to strutil.c, removed strlist.c.

Revision 1.15  2013/09/22 21:34:48  pauloscustodio
Remove legacy xxx_err() interface

Revision 1.14  2013/09/22 21:04:21  pauloscustodio
New File and FileStack objects

Revision 1.13  2013/05/11 00:29:26  pauloscustodio
CH_0021 : Exceptions on file IO show file name
Keep a hash table of all opened file names, so that the file name
is shown on a fatal error.
Rename file IO funtions: f..._err to xf...

Revision 1.12  2013/04/06 13:15:04  pauloscustodio
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
Replaced xfputc and friends with xfput_u8, raising a fatal_error() instead of an
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
- Created new functions xfput_u8, xfget_u8, ... to raise the exception on error.

Revision 1.1  2011/08/18 21:42:05  pauloscustodio
Utilities for file handling

*/
