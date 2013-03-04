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

Handle assembly listing and symbol table listing.
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/listfile.h,v 1.4 2013-03-04 23:37:09 pauloscustodio Exp $ */
/* $Log: listfile.h,v $
/* Revision 1.4  2013-03-04 23:37:09  pauloscustodio
/* Removed pass1 that was used to skip creating page references of created
/* symbols in pass2. Modified add_symbol_ref() to ignore pages < 1,
/* modified list_get_page_nr() to return -1 after the whole source is
/* processed.
/*
/* Revision 1.3  2013/02/26 02:36:54  pauloscustodio
/* Simplified symbol output to listfile by using SymbolRefList argument
/*
/* Revision 1.2  2013/02/22 17:26:33  pauloscustodio
/* Decouple assembler from listfile handling
/*
/* Revision 1.1  2013/02/19 22:52:40  pauloscustodio
/* BUG_0030 : List bytes patching overwrites header
/* BUG_0031 : List file garbled with input lines with 255 chars
/* New listfile.c with all the listing related code
/*
/*
/* */

#ifndef LISTFILE_H
#define LISTFILE_H

#include "memalloc.h"   /* before any other include */

#include "class.h"
#include "dynstr.h"
#include "model.h"
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
	char	*filename;				/* list file name, held in strpool */
	FILE	*file;					/* open file */

	int		page_nr;				/* current page number */
	int		line_nr;				/* current line number in page */

	BOOL	source_list_ended;		/* end of source listing, from now on no source lines */

	/* current line being output */
	BOOL	line_started;			/* true if a line was started but not ended */
	long	start_line_pos;			/* ftell() position at start of next list line */
	size_t	address;				/* address of start of line */
	Str		*bytes;					/* list of bytes output for this line */

	char	*source_file;			/* source file, kept in strpool */
	int		source_line_nr;			/* line number of source */
	Str		*line;					/* input line being output */

END_CLASS;

/*-----------------------------------------------------------------------------
*	Object API  
*----------------------------------------------------------------------------*/

/* open the list file for writing, given the assembly source file name and
   the extension of the list file */
extern void ListFile_open( ListFile *self, char *source_file, char *extension );

/* close the list file, and remove the file if the passed flag is FALSE */
extern void ListFile_close( ListFile *self, BOOL keep_file );

/* output a list line in three steps:
   1. start a new list, provide address, file name, line number and input assembly line
   2.1. append bytes, words, longs
   2.2. collect patch position in list file for expressions
   3. output the full line */
extern void ListFile_start_line( ListFile *self, size_t address, 
								 char *source_file, int source_line_nr, char *line );
extern void ListFile_append( ListFile *self, long value, int num_bytes );
extern void ListFile_append_byte( ListFile *self, byte_t byte );
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
extern void list_open( char *source_file, char *extension );
extern void list_close( BOOL keep_file );
extern void list_start_line( size_t address, 
							 char *source_file, int source_line_nr, char *line );
extern void list_append( long value, int num_bytes );
extern void list_append_byte( byte_t byte );
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

#endif /* ndef LISTFILE_H */

