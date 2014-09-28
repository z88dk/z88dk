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

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2014

Manage the code area in memory

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/codearea.h,v 1.32 2014-09-28 17:37:14 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */
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
	char		*name;			/* name of section, kept in strpool */
	UInt		 addr;			/* start address of this section,
								   computed by sections_alloc_addr() */
    Int			 origin;		/* ORG address of section, -1 if not defined */
	Bool		 origin_found;	/* ORG already found in code */
	Bool		 origin_opts;	/* ORG was defined from command line options, 
								   override asm code */
	UInt		 asmpc;			/* address of current opcode relative to start
								   of the current module, reset to 0 at start
								   of each module */
	UInt		 opcode_size;	/* number of bytes added after last 
								   set_PC() or next_PC() */
	ByteArray	*bytes;			/* binary code of section, used to compute 
								   current size */
	UIntArray	*module_start;	/* at module_addr[ID] is the start offset from
								   addr of module ID */
END_CLASS;

CLASS_HASH( Section );

/*-----------------------------------------------------------------------------
*   Handle list of current sections
*----------------------------------------------------------------------------*/

/* init to default section ""; only called at startup */
extern void reset_codearea( void );

/* return size of current section */
extern UInt get_section_size( Section *section );

/* compute total size of all sections */
extern UInt get_sections_size( void );

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
extern UInt get_cur_module_start( void );
extern UInt get_cur_module_size( void );

/*-----------------------------------------------------------------------------
*   Handle ASMPC
*	set_PC() defines the instruction start address
*	every byte added increments an offset but keeps ASMPC with start of opcode
*	next_PC() moves to the next opcode
*----------------------------------------------------------------------------*/
extern void set_PC( UInt n );
extern UInt next_PC( void );
extern UInt get_PC( void );

/*-----------------------------------------------------------------------------
*   patch a value at a position, or append to the end of the code area
*	the patch address is relative to current module and current section
*	and is incremented after store
*----------------------------------------------------------------------------*/
extern void  patch_value( UInt *paddr, UInt value, UInt num_bytes );
extern void append_value(              UInt value, UInt num_bytes );

extern void  patch_byte( UInt *paddr, Byte byte1 );		/* one byte */
extern void append_byte( Byte byte1 );
extern void append_2bytes( Byte byte1, Byte byte2 );

extern void  patch_word( UInt *paddr, int word );		/* 2-byte word */
extern void append_word( int word );

extern void  patch_long( UInt *paddr, long dword );		/* 4-byte long */
extern void append_long( long dword );

/* advance code pointer reserving space, return address of start of buffer */
extern Byte *append_reserve( UInt num_bytes );	

/* patch/append binary contents of file, whole file if num_bytes < 0 */
extern void  patch_file_contents( FILE *file, UInt *paddr, long num_bytes );	
extern void append_file_contents( FILE *file,              long num_bytes );	

/*-----------------------------------------------------------------------------
*   read/write current module to an open file
*----------------------------------------------------------------------------*/

/* write object code of the current module, return total size written */
extern UInt fwrite_module_code( FILE *file );	

/*-----------------------------------------------------------------------------
*   write whole code area to an open file
*----------------------------------------------------------------------------*/
extern void fwrite_codearea( char *filename, FILE **pfile );
extern void fwrite_codearea_chunk( char *filename, FILE **pfile, 
								   UInt offset, UInt write_size );
