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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/codearea.h,v 1.29 2014-06-13 19:18:07 pauloscustodio Exp $
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

extern void reset_codearea( void );			/* init to default section "" */

/*-----------------------------------------------------------------------------
*   Named Section of code, introduced by "SECTION" keyword
*----------------------------------------------------------------------------*/
CLASS( Section )
	char		*name;			/* name of section, kept in strpool */
	UInt		 addr;			/* start address of this section,
								   computed by sections_alloc_addr() */
	UInt		 asmpc;			/* address of current opcode */
	UInt		 opcode_size;	/* Number of bytes added after last 
								   set_PC() or next_PC() */
	ByteArray	*bytes;			/* binary code of section, used to compute 
								   current size */
	UIntArray	*module_start;	/* at module_addr[ID] is the start offset from
								   addr of module ID */
END_CLASS;

CLASS_HASH( Section );

/* allocate a new module, setup module_start[] of all sections, return new unique ID */
extern int section_new_module( void );

/* return start offset for given section and module ID */
extern UInt section_module_start( Section *section, int module_id );

/* allocate the addr of each of the sections, concatenating the sections in
   consecutive addresses. Start at the given org, or at 0 if negative */
extern void sections_alloc_addr( Int origin );

/* get section by name, creates a new section if new name */
extern Section *get_section( char *name );

/* iterate through sections */
extern Section *sections_first( SectionHashElem **piter );
extern Section *sections_next(  SectionHashElem **piter );

/* get/set current and default section */
extern Section *get_default_section( void );
extern Section *get_cur_section( void );
extern void     set_cur_section( Section *section );

#define CURRENTSECTION	(get_cur_section())

/* return number of bytes and base address of current section code */
extern Byte *get_section_code( Section *section );
extern UInt  get_section_size( Section *section );

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
*   reset the code area, return current size
*----------------------------------------------------------------------------*/

extern UInt get_codesize( void );			/* size of all modules before current,
                                               i.e. base address of current module */
extern UInt inc_codesize( UInt n );			/* increment loaded codesize */

/*-----------------------------------------------------------------------------
*   write code area to an open file
*----------------------------------------------------------------------------*/
extern void fwrite_codearea( FILE *file );
extern void fwrite_codearea_chunk( FILE *file, UInt addr, UInt write_size );
extern void fread_codearea( FILE *file, UInt read_size );		/* append to codearea */
extern void fread_codearea_offset( FILE *file, UInt offset, UInt read_size );  /* read to codearea at offset */

/*-----------------------------------------------------------------------------
*   patch a value at a position, or append to the end of the code area
*	the patch address is incremented after store
*----------------------------------------------------------------------------*/
extern void  patch_value( UInt *paddr, UInt value, int num_bytes );
extern void append_value(              UInt value, int num_bytes );

extern void  patch_byte( UInt *paddr, Byte byte1 );		/* one byte */
extern void append_byte( Byte byte1 );
extern void append_2bytes( Byte byte1, Byte byte2 );

extern void  patch_word( UInt *paddr, int word );		/* 2-byte word */
extern void append_word( int word );

extern void  patch_long( UInt *paddr, long dword );		/* 4-byte long */
extern void append_long( long dword );
