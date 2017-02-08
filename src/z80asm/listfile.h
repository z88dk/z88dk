/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

Handle assembly listing and symbol table listing.
*/

#pragma once

#include "class.h"
#include "str.h"
#include "types.h"

/* Page metrics for list file (CH_0017) */
#define COLUMN_WIDTH	32
#define HEX_DUMP_WIDTH	32
#define REF_PER_LINE	15

/*-----------------------------------------------------------------------------
*   Class to hold current list file
*----------------------------------------------------------------------------*/
CLASS( ListFile )
	char		*filename;				/* list file name, held in strpool */
	FILE		*file;					/* open file */

	Bool		 source_list_ended;		/* end of source listing, from now on no source lines */

	/* current line being output */
	Bool		 line_started;			/* true if a line was started but not ended */
	long		 start_line_pos;		/* ftell() position at start of next list line */
	int	 address;				/* address of start of line */
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
extern void ListFile_start_line( ListFile *self, int address,
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

/*-----------------------------------------------------------------------------
*	Singleton API - all methods work on one global list object
*	See description for corresponding method above
*----------------------------------------------------------------------------*/
extern void list_open( char *list_file );
extern void list_close( Bool keep_file );
extern void list_start_line( int address,
                             char *source_file, int source_line_nr, char *line );
extern void list_append( long value, int num_bytes );
extern void list_append_byte( Byte byte1 );
extern void list_append_word( int word );
extern void list_append_long( long dword );
extern long list_patch_pos( int byte_offset );
extern void list_end_line( void );
extern void list_end( void );
extern void list_patch_data( long patch_pos, long value, int num_bytes );
