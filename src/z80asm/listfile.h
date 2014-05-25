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

Copyright (C) Paulo Custodio, 2011-2014

Handle assembly listing and symbol table listing.

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/listfile.h,v 1.19 2014-05-25 01:02:29 pauloscustodio Exp $

*/

#pragma once

#include "xmalloc.h"   /* before any other include */

#include "class.h"
#include "strutil.h"
#include "symref.h"
#include "types.h"

/* Page metrics for list file (CH_0017) */
#define PAGE_LEN		64
#define PAGE_WIDTH		122
#define COLUMN_WIDTH	32
#define HEX_DUMP_WIDTH	32
#define REF_PER_LINE	15

/*-----------------------------------------------------------------------------
*   Class to hold current list file
*----------------------------------------------------------------------------*/
CLASS( ListFile )
	char		*filename;				/* list file name, held in strpool */
	FILE		*file;					/* open file */

	int			 page_nr;				/* current page number */
	int			 line_nr;				/* current line number in page */

	Bool		 source_list_ended;		/* end of source listing, from now on no source lines */

	/* current line being output */
	Bool		 line_started;			/* true if a line was started but not ended */
	long		 start_line_pos;		/* ftell() position at start of next list line */
	uint32_t	 address;				/* address of start of line */
	Str			*bytes;					/* list of bytes output for this line */

	char		*source_file;			/* source file, kept in strpool */
	int			 source_line_nr;		/* line number of source */
	Str			*line;					/* input line being output */

END_CLASS;

/*-----------------------------------------------------------------------------
*	Object API
*----------------------------------------------------------------------------*/

/* open the list file for writing, given the list file name */
extern void ListFile_open( ListFile *self, char *list_file );

/* close the list file, and remove the file if the passed flag is FALSE */
extern void ListFile_close( ListFile *self, Bool keep_file );

/* output a list line in three steps:
   1. start a new list, provide address, file name, line number and input assembly line
   2.1. append bytes, words, longs
   2.2. collect patch position in list file for expressions
   3. output the full line */
extern void ListFile_start_line( ListFile *self, uint32_t address,
                                 char *source_file, int source_line_nr, char *line );
extern void ListFile_append( ListFile *self, long value, int num_bytes );
extern void ListFile_append_byte( ListFile *self, Byte byte1 );
extern void ListFile_append_word( ListFile *self, int word );
extern void ListFile_append_long( ListFile *self, long dword );
extern long ListFile_patch_pos( ListFile *self, int byte_offset );
extern void ListFile_end_line( ListFile *self );

/* end the source listing - get_page_nr() returns -1 from here onwards */
extern void ListFile_end( ListFile *self );

/* patch the bytes at the given patch_pos returned by ListFile_patch_pos() */
extern void ListFile_patch_data( ListFile *self, long patch_pos, long value, int num_bytes );

/* write the symbol table in two steps:
   1. start a new table, provide title
   2. output symbol name, reference, output reference, ...
*/
extern void ListFile_start_table( ListFile *self, char *title );
extern void ListFile_symbol( ListFile *self, char *symbol_name, long symbol_value,
                             SymbolRefList *references );

/* return current page number */
extern int ListFile_get_page_nr( ListFile *self );

/*-----------------------------------------------------------------------------
*	Singleton API - all methods work on one global list object
*	See description for corresponding method above
*----------------------------------------------------------------------------*/
extern void list_open( char *list_file );
extern void list_close( Bool keep_file );
extern void list_start_line( uint32_t address,
                             char *source_file, int source_line_nr, char *line );
extern void list_append( long value, int num_bytes );
extern void list_append_byte( Byte byte1 );
extern void list_append_word( int word );
extern void list_append_long( long dword );
extern long list_patch_pos( int byte_offset );
extern void list_end_line( void );
extern void list_end( void );
extern void list_patch_data( long patch_pos, long value, int num_bytes );
extern void list_start_table( char *title );
extern void list_symbol( char *symbol_name, long symbol_value,
                         SymbolRefList *references );
extern int  list_get_page_nr( void );

/*
* $Log: listfile.h,v $
* Revision 1.19  2014-05-25 01:02:29  pauloscustodio
* Byte, Int, UInt added
*
* Revision 1.18  2014/05/17 14:27:12  pauloscustodio
* Use C99 integer types
*
* Revision 1.17  2014/05/06 22:17:38  pauloscustodio
* Made types all-caps to avoid conflicts with /usr/include/i386-linux-gnu/sys/types.h
*
* Revision 1.16  2014/05/02 21:34:58  pauloscustodio
* byte_t and uint_t renamed to Byte, uint32_t
*
* Revision 1.15  2014/04/15 20:06:43  pauloscustodio
* Solve warning: no newline at end of file
*
* Revision 1.14  2014/03/05 23:44:55  pauloscustodio
* Renamed 64-bit portability to BUG_0042
*
* Revision 1.13  2014/02/19 23:59:26  pauloscustodio
* BUG_0042: 64-bit portability issues
* size_t changes to unsigned long in 64-bit. Usage of size_t * to
* retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
* breaks on a 64-bit architecture. Make the functions return the value instead
* of being passed the pointer to the return value, so that the compiler
* takes care of size convertions.
* Create uint32_t, use uint32_t instead of size_t.
*
* Revision 1.12  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.11  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.10  2014/01/02 18:59:04  pauloscustodio
* warning: "/","*" within comment [-Wcomment]
*
* Revision 1.9  2014/01/02 18:54:56  pauloscustodio
* warning: "/","*" within comment [-Wcomment]
*
* Revision 1.8  2013/12/30 02:05:32  pauloscustodio
* Merge dynstr.c and safestr.c into lib/strutil.c; the new Str type
* handles both dynamically allocated strings and fixed-size strings.
* Replaced g_strchomp by chomp by; g_ascii_tolower by tolower;
* g_ascii_toupper by toupper; g_ascii_strcasecmp by stricompare.
*
* Revision 1.7  2013/12/15 13:18:34  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.6  2013/09/30 00:24:25  pauloscustodio
* Parse command line options via look-up tables:
* -e, --asm-ext
* -M, --obj-ext
* Move filename extension functions to options.c
*
* Revision 1.5  2013/05/16 23:39:48  pauloscustodio
* Move struct node to sym.c, rename to Symbol
* Move SymbolRef to symref.c
*
* Revision 1.4  2013/03/04 23:37:09  pauloscustodio
* Removed pass1 that was used to skip creating page references of created
* symbols in pass2. Modified add_symbol_ref() to ignore pages < 1,
* modified list_get_page_nr() to return -1 after the whole source is
* processed.
*
* Revision 1.3  2013/02/26 02:36:54  pauloscustodio
* Simplified symbol output to listfile by using SymbolRefList argument
*
* Revision 1.2  2013/02/22 17:26:33  pauloscustodio
* Decouple assembler from listfile handling
*
* Revision 1.1  2013/02/19 22:52:40  pauloscustodio
* BUG_0030 : List bytes patching overwrites header
* BUG_0031 : List file garbled with input lines with 255 chars
* New listfile.c with all the listing related code
*
*/
