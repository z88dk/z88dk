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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/codearea.c,v 1.38 2014-06-13 19:18:07 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "codearea.h"
#include "errors.h"
#include "fileutil.h"
#include "init.h"
#include "listfile.h"
#include "strpool.h"
#include "symbol.h"
#include "z80asm.h"
#include <assert.h>
#include <memory.h>

/*-----------------------------------------------------------------------------
*   global data
*----------------------------------------------------------------------------*/
static SectionHash 	*g_sections;
static Section 		*g_cur_section;
static Section 		*g_default_section;

static UInt  codesize;			/* size of all modules before current,
								   i.e. base address of current module
								   BUG_0015 */

/*-----------------------------------------------------------------------------
*   Initialize and Terminate module
*----------------------------------------------------------------------------*/
DEFINE_init()
{
    reset_codearea();	/* init default section */
    codesize  = 0;		/* marks start of each new module, always incremented, BUG_0015 */
}

DEFINE_fini()
{
	OBJ_DELETE( g_sections );
	g_cur_section = g_default_section = NULL;
}

/*-----------------------------------------------------------------------------
*   init the code area
*----------------------------------------------------------------------------*/
void reset_codearea( void )
{
    init();
	SectionHash_remove_all( g_sections );
	g_default_section = get_section("");
	set_cur_section( g_default_section );
}

/*-----------------------------------------------------------------------------
*   Named Section of code, introduced by "SECTION" keyword
*----------------------------------------------------------------------------*/
DEF_CLASS( Section );
DEF_CLASS_HASH( Section, TRUE );

void Section_init (Section *self)   
{
	self->name = "";		/* default: empty section */
	self->addr	= 0;
	self->asmpc	= 0;
	self->opcode_size = 0;
	
	self->bytes	= OBJ_NEW( ByteArray );
	OBJ_AUTODELETE( self->bytes ) = FALSE;
	
	self->module_start = OBJ_NEW( UIntArray );
	OBJ_AUTODELETE( self->module_start ) = FALSE;
}

void Section_copy (Section *self, Section *other)	
{ 
	self->bytes		   = ByteArray_clone( other->bytes );
	self->module_start = UIntArray_clone( other->module_start );
}

void Section_fini (Section *self)
{
	OBJ_DELETE( self->bytes );
	OBJ_DELETE( self->module_start );
}

/* allocate a new module, setup module_start[] of all sections, return new unique ID */
int section_new_module( void )
{
	Section *section;
	SectionHashElem *iter;
	int module_id;

	init();
	module_id = UIntArray_size( g_default_section->module_start );

	/* expand all sections this new ID */
	for ( section = sections_first( &iter ) ; section != NULL ; 
		  section = sections_next(  &iter ) )
	{
		(void) section_module_start( section, module_id );
	}
	return module_id;
}

/* return start offset for given section and module ID */
UInt section_module_start( Section *section, int module_id )
{
	UInt addr, *item;
	int i;
	int cur_size;
	
    init();
	cur_size = UIntArray_size( section->module_start );
	if ( cur_size > module_id )
		return *( UIntArray_item( section->module_start, module_id ) );

	addr = 0;
	for ( i = cur_size < 1 ? 0 : cur_size - 1; 
	      i < module_id; i++ )
	{
		item = UIntArray_item( section->module_start, i );
		if ( *item < addr )
			*item = addr;
		else
			addr = *item;
	}

	/* update address with current code index */
	item = UIntArray_item( section->module_start, module_id );
	assert( get_section_size( section ) >= addr );

	addr = *item = get_section_size( section );
	return addr;
}

/* allocate the addr of each of the sections, concatenating the sections in
   consecutive addresses. Start at the given org, or at 0 if negative */
void sections_alloc_addr( Int origin )
{
	Section *section;
	SectionHashElem *iter;
	int end_id;
	UInt addr;

	init();
	end_id = section_new_module();		/* dummy module to have end addr of each section */

	addr = origin >= 0 ? origin : 0;	/* start address */

	/* allocate addr in sequence */
	for ( section = sections_first( &iter ) ; section != NULL ; 
		  section = sections_next(  &iter ) )
	{
		section->addr = addr;
		addr += section_module_start( section, end_id );
	}
}

/* get section by name, creates a new section if new name */
Section *get_section( char *name )
{
	Section *section;
	int last_id;

	init();
	section = SectionHash_get( g_sections, name );
	if ( section == NULL )
	{
		section = OBJ_NEW( Section );
		section->name = strpool_add( name );
		SectionHash_set( & g_sections, name, section );

		/* define start address of all existing modules = 0, except for default section */
		if ( g_default_section != NULL && *name != '\0' )
		{
			last_id = UIntArray_size( g_default_section->module_start ) - 1;
			if ( last_id >= 0 )
				UIntArray_item( section->module_start, last_id );		/* init [0..module_id] to zero */
		}
	}
	return section;
}

/* iterate through sections */
Section *sections_first( SectionHashElem **piter )
{
	init();
	*piter = SectionHash_first( g_sections );
	return (*piter == NULL) ? NULL : (Section *) (*piter)->value;
}

Section *sections_next(  SectionHashElem **piter )
{
	init();
	*piter = SectionHash_next( *piter );
	return (*piter == NULL) ? NULL : (Section *) (*piter)->value;
}

/* get/set current section */
Section *get_cur_section( void )
{
	init();
	return g_cur_section;
}

void set_cur_section( Section *section )
{
	init();
	g_cur_section = section;
}

Section *get_default_section( void )
{
	init();
	return g_default_section;
}

/* return number of bytes and base address of current section code */
Byte *get_section_code( Section *section )
{
    init();
    return ByteArray_item( section->bytes, 0 );
}

UInt get_section_size( Section *section )
{
    init();
    return ByteArray_size( section->bytes );
}

/* Handle ASMPC */
void set_PC( UInt n )
{
    init();
	g_cur_section->asmpc = n;
	g_cur_section->opcode_size = 0;
}

UInt next_PC( void )
{
    init();
	g_cur_section->asmpc += g_cur_section->opcode_size;
	g_cur_section->opcode_size = 0;
	return g_cur_section->asmpc;
}

UInt get_PC( void )
{
    init();
	return g_cur_section->asmpc;
}

static void inc_PC( UInt n )
{
    init();
    g_cur_section->opcode_size += n;
}


/*-----------------------------------------------------------------------------
*   code size - address allocation
*----------------------------------------------------------------------------*/
UInt get_codesize( void ) /* BUG_0015 */
{
    init();
    return codesize;
}

UInt inc_codesize( UInt n ) /* BUG_0015 */
{
    init();
    return codesize += n;
}

static void check_space( UInt addr, UInt n )
{
	init();
    if ( addr + n > MAXCODESIZE )
        fatal_max_codesize( ( long )MAXCODESIZE );
}

/*-----------------------------------------------------------------------------
*   read/write code area to an open file
*----------------------------------------------------------------------------*/
void fwrite_codearea( FILE *file )
{
	init();
    xfput_chars( file, (char *) get_section_code( g_cur_section ), 
						        get_section_size( g_cur_section ) );
}

void fwrite_codearea_chunk( FILE *file, UInt addr, UInt write_size )
{
	UInt code_size;

	init();
	code_size = get_section_size( g_cur_section );
    if ( addr < code_size )
    {
        if ( addr + write_size > code_size )
            write_size = code_size - addr;

        xfput_chars( file, (char *) ByteArray_item( g_cur_section->bytes, addr ), write_size );
    }
}

/* append data read from file to the current code area */
void fread_codearea( FILE *file, UInt read_size )
{
	UInt code_size;

	init();
	code_size = get_section_size( g_cur_section );
	if ( read_size > 0 )
	{
		check_space( code_size, read_size );
		ByteArray_item( g_cur_section->bytes, code_size + read_size - 1 );		/* reserve space */
		xfget_chars( file, (char *) ByteArray_item( g_cur_section->bytes, code_size ), read_size );
		inc_PC( read_size );
	}
}

/* read to codearea at offset - BUG_0015 */
void fread_codearea_offset( FILE *file, UInt offset, UInt read_size )
{
	init();
	if ( read_size > 0 )
	{
		check_space( offset, read_size );
		ByteArray_item( g_cur_section->bytes, offset + read_size - 1 );		/* reserve space */
		xfget_chars( file, (char *) ByteArray_item( g_cur_section->bytes, offset ), read_size );
	}
}

/*-----------------------------------------------------------------------------
*   load data into code area
*----------------------------------------------------------------------------*/
void patch_value( UInt *paddr, UInt value, int num_bytes )
{
	UInt old_codeindex;

    init();
	old_codeindex = get_section_size( g_cur_section );
	check_space( *paddr, num_bytes );
	while ( num_bytes-- > 0 )
	{
		*( ByteArray_item( g_cur_section->bytes, (*paddr)++ ) ) = value & 0xFF;
		value >>= 8;
	}

	/* advance PC if past end of previous buffer */
	if ( *paddr > old_codeindex )
		inc_PC( *paddr - old_codeindex );
}

void append_value( UInt value, int num_bytes )
{
	UInt addr;

    init();
	addr = get_section_size( g_cur_section );
	patch_value( &addr, value, num_bytes );
    list_append( value, num_bytes );
}

void patch_byte( UInt *paddr, Byte byte1 ) { patch_value( paddr, byte1, 1 ); }
void patch_word( UInt *paddr, int  word  ) { patch_value( paddr, word,  2 ); }
void patch_long( UInt *paddr, long dword ) { patch_value( paddr, dword, 4 ); }

void append_byte( Byte byte1 ) { append_value( byte1, 1 ); }
void append_word( int  word )  { append_value( word,  2 ); }
void append_long( long dword ) { append_value( dword, 4 ); }

void append_2bytes( Byte byte1, Byte byte2 ) 
{
	append_value( byte1, 1 );
	append_value( byte2, 1 );
}
