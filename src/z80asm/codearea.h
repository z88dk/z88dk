/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

Manage the code area in memory
*/

#pragma once

#include "array.h"
#include "types.h"
#include "class.h"
#include "classhash.h"

#include <stdio.h>

/*-----------------------------------------------------------------------------
*   Handle Sections
*	Each section has a name (default = ""), a start address, an ASMPC, 
*	and a contiguous block of memory where opcodes are added.
*	Each module allocates a set of 0..N section blocks, each with it's 
*	start address in each section. Modules are identified with unique 
*	sequence IDs, and these IDs can be used to find out start of module
*	data in each section.
*	The alloc_addresses() call defines the start addresses of each section
*	by concatenating them together.
*	The reset_codearea() clears all section data.
*----------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------
*   Named Section of code, introduced by "SECTION" keyword
*----------------------------------------------------------------------------*/
CLASS( Section )
	char		*name;				/* name of section, kept in strpool */
	int			 addr;				/* start address of this section,
									*  computed by sections_alloc_addr() */
    int			 origin;			/* ORG address of section, -1 if not defined */
	Bool		 origin_found : 1;	/* ORG already found in code */
	Bool		 origin_opts : 1;	/* ORG was defined from command line options,
									*  override asm code */
	Bool		 section_split : 1;	/* ORG -1 was given, signal that this section
									*  should be output to a new binary file */
	Bool		 max_codesize_issued : 1;
									/* error_max_codesize issued, ignore next calls */
	int			 asmpc;				/* address of current opcode relative to start
									*  of the current module, reset to 0 at start
									*  of each module */
	int			 opcode_size;		/* number of bytes added after last 
									*  set_PC() or next_PC() */
	ByteArray	*bytes;				/* binary code of section, used to compute 
									*  current size */
	intArray	*reloc;				/* list of addresses in module containg relocable addreses */
	intArray	*module_start;		/* at module_addr[ID] is the start offset from
									*  addr of module ID */
END_CLASS;

CLASS_HASH( Section );

/*-----------------------------------------------------------------------------
*   Handle list of current sections
*----------------------------------------------------------------------------*/

/* init to default section ""; only called at startup */
extern void reset_codearea( void );

/* return size of current section */
extern int get_section_size( Section *section );

/* compute total size of all sections */
extern int get_sections_size( void );

/* get section by name, creates a new section if new name; make it the current section */
extern Section *new_section( char *name );

/* get/set current section */
extern Section *get_cur_section( void );
extern Section *set_cur_section( Section *section );

#define CURRENTSECTION	(get_cur_section())

/* iterate through sections, 
   pointer to iterator may be NULL if no need to iterate */
extern Section *get_first_section( SectionHashElem **piter );
extern Section *get_last_section( void );
extern Section *get_next_section( SectionHashElem **piter );

/*-----------------------------------------------------------------------------
*   allocate the addr of each of the sections, concatenating the sections in
*   consecutive addresses. Start at the given org, or at 0 if negative
*----------------------------------------------------------------------------*/
extern void sections_alloc_addr(void);

/*-----------------------------------------------------------------------------
*   Handle current module
*----------------------------------------------------------------------------*/

/* allocate a new module, setup module_start[] and reset ASMPC of all sections, 
   return new unique ID; make it the current module */
extern int new_module_id( void );

/* get/set current module, i.e. module where the next functions operate */
extern int  get_cur_module_id( void );
extern void set_cur_module_id( int module_id );

/* return start and end offset for the current section and module id */
extern int get_cur_module_start( void );
extern int get_cur_module_size( void );

/*-----------------------------------------------------------------------------
*   Handle ASMPC
*	set_PC() defines the instruction start address
*	every byte added increments an offset but keeps ASMPC with start of opcode
*	next_PC() moves to the next opcode
*----------------------------------------------------------------------------*/
extern void set_PC( int n );
extern int next_PC( void );
extern int get_PC( void );

/*-----------------------------------------------------------------------------
*   patch a value at a position, or append to the end of the code area
*	the patch address is relative to current module and current section
*----------------------------------------------------------------------------*/
extern void  patch_value( int addr, int value, int num_bytes );
extern void append_value(            int value, int num_bytes );

extern void  patch_byte( int addr, Byte byte1 );		/* one byte */
extern void append_byte( Byte byte1 );
extern void append_2bytes( Byte byte1, Byte byte2 );

extern void  patch_word( int addr, int word );			/* 2-byte word */
extern void append_word( int word );

extern void  patch_long( int addr, long dword );		/* 4-byte long */
extern void append_long( long dword );

extern void append_defs(int num_bytes, Byte fill);

/* advance code pointer reserving space, return address of start of buffer */
extern Byte *append_reserve( int num_bytes );	

/* patch/append binary contents of file, whole file if num_bytes < 0 */
extern void  patch_file_contents( FILE *file, int addr, long num_bytes );	
extern void append_file_contents( FILE *file,            long num_bytes );	

/*-----------------------------------------------------------------------------
*   read/write current module to an open file
*----------------------------------------------------------------------------*/

/* write object code of the current module, return total size written */
extern int fwrite_module_code( FILE *file );	

/*-----------------------------------------------------------------------------
*   write whole code area to an open file
*----------------------------------------------------------------------------*/
extern void fwrite_codearea( char *filename, FILE **pbinfile, FILE **prelocfile );

/*-----------------------------------------------------------------------------
*   Assembly directives
*----------------------------------------------------------------------------*/

/* define a new origin, called by the ORG directive
*  if origin is -1, the section is split creating a new binary file */
extern void set_origin_directive(int origin);

/* define a new origin, called by the --orgin command line option */
extern void set_origin_option(int origin);

/* read/write origin to/from input file, for these cases:
   origin = 0..0xFFFF - origin defined;
   origin = -1 - origin not defined 
   origin = -1 and section_split - origin not defined, but section split */
extern void read_origin(FILE* file, Section *section);
extern void write_origin(FILE* file, Section *section);
