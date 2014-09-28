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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/codearea.c,v 1.43 2014-09-28 17:37:14 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "codearea.h"
#include "errors.h"
#include "fileutil.h"
#include "init.h"
#include "listfile.h"
#include "options.h"
#include "strpool.h"
#include "z80asm.h"
#include <assert.h>
#include <memory.h>

/*-----------------------------------------------------------------------------
*   global data
*----------------------------------------------------------------------------*/
static SectionHash 	*g_sections;
static Section 		*g_cur_section;
static Section 		*g_default_section;
static Section 		*g_last_section;
static int			 g_cur_module;

/*-----------------------------------------------------------------------------
*   Initialize and Terminate module
*----------------------------------------------------------------------------*/
DEFINE_init()
{
    reset_codearea();	/* init default section */
}

DEFINE_fini()
{
	OBJ_DELETE( g_sections );
	g_cur_section = g_default_section = g_last_section = NULL;
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
	self->origin = -1;
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

/*-----------------------------------------------------------------------------
*   Handle list of current sections
*----------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------
*   init to default section ""; only called at startup
*----------------------------------------------------------------------------*/
void reset_codearea( void )
{
    init();
	SectionHash_remove_all( g_sections );
	g_cur_section = g_default_section = g_last_section = NULL;
	new_section("");
}

/*-----------------------------------------------------------------------------
*   return size of current section
*----------------------------------------------------------------------------*/
UInt get_section_size( Section *section )
{
    init();
    return ByteArray_size( section->bytes );
}

/*-----------------------------------------------------------------------------
*   compute total size of all sections
*----------------------------------------------------------------------------*/
UInt get_sections_size( void )
{
	Section *section;
	SectionHashElem *iter;
	UInt size;

	size = 0;
	for ( section = get_first_section( &iter ) ; section != NULL ; 
		  section = get_next_section( &iter ) )
	{
		size += get_section_size( section );
	}
	return size;
}

/*-----------------------------------------------------------------------------
*   get section by name, creates a new section if new name; 
*	make it the current section
*----------------------------------------------------------------------------*/
Section *new_section( char *name )
{
	int last_id;

	init();
	g_cur_section = SectionHash_get( g_sections, name );
	if ( g_cur_section == NULL )
	{
		g_cur_section = OBJ_NEW( Section );
		g_cur_section->name = strpool_add( name );
		SectionHash_set( & g_sections, name, g_cur_section );
		
		/* set first and last sections */
		if ( g_default_section == NULL )
			g_default_section = g_cur_section;
		g_last_section = g_cur_section;

		/* define start address of all existing modules = 0, except for default section */
		if ( g_default_section != NULL && *name != '\0' )
		{
			last_id = UIntArray_size( g_default_section->module_start ) - 1;
			if ( last_id >= 0 )
				UIntArray_item( g_cur_section->module_start, last_id );		/* init [0..module_id] to zero */
		}
	}
	return g_cur_section;
}

/*-----------------------------------------------------------------------------
*   get/set current section
*----------------------------------------------------------------------------*/
Section *get_cur_section( void )
{
	init();
	return g_cur_section;
}

Section *set_cur_section( Section *section )
{
	init();
	return (g_cur_section = section);		/* assign and return */
}

/*-----------------------------------------------------------------------------
*   iterate through sections
*	pointer to iterator may be NULL if no need to iterate
*----------------------------------------------------------------------------*/
Section *get_first_section( SectionHashElem **piter )
{
	SectionHashElem *iter;

	init();
	if ( piter == NULL )
		piter = &iter;		/* user does not need to iterate */

	*piter = SectionHash_first( g_sections );
	return (*piter == NULL) ? NULL : (Section *) (*piter)->value;
}

Section *get_last_section( void )
{
	init();
	return g_last_section;
}

Section *get_next_section(  SectionHashElem **piter )
{
	init();
	*piter = SectionHash_next( *piter );
	return (*piter == NULL) ? NULL : (Section *) (*piter)->value;
}

/*-----------------------------------------------------------------------------
*   Handle current module
*----------------------------------------------------------------------------*/
static int get_last_module_id( void )
{
	init();
	return UIntArray_size( g_default_section->module_start ) - 1;
}

int get_cur_module_id( void )
{
	init();
	return g_cur_module;
}

void set_cur_module_id( int module_id )
{
	init();
	assert( module_id >= 0 );
	assert( module_id <= get_last_module_id() );
	g_cur_module = module_id;
}

/*-----------------------------------------------------------------------------
*   return start and end offset for given section and module ID
*----------------------------------------------------------------------------*/
static UInt section_module_start( Section *section, int module_id )
{
	UInt addr, *item;
	int i;
	int cur_size;
	
    init();
	cur_size = UIntArray_size( section->module_start );
	if ( cur_size > module_id )
		addr = *( UIntArray_item( section->module_start, module_id ) );
	else
	{
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
	}
	return addr;
}

static UInt section_module_size(  Section *section, int module_id )
{
	int  last_module_id = get_last_module_id();
	UInt addr, size;

	addr = section_module_start( section, module_id );
	if ( module_id < last_module_id )
		size = section_module_start( section, module_id + 1 ) - addr;
	else
		size = get_section_size( section ) - addr;

	return size;
}

UInt get_cur_module_start( void ) { return section_module_start( g_cur_section, g_cur_module ); }
UInt get_cur_module_size(  void ) { return section_module_size(  g_cur_section, g_cur_module ); }

/*-----------------------------------------------------------------------------
*   allocate the addr of each of the sections, concatenating the sections in
*   consecutive addresses, or starting from a new address if a section
*	has a defined origin. Start at the command line origin, or at 0 if negative
*----------------------------------------------------------------------------*/
void sections_alloc_addr(void)
{
	Section *section;
	SectionHashElem *iter;
	UInt addr;

	init();

	/* allocate addr in sequence */
	addr = 0;
	for ( section = get_first_section( &iter ) ; section != NULL ; 
		  section = get_next_section( &iter ) )
	{
		if ( section->origin >= 0 )		/* break in address space */
			addr = section->origin;

		section->addr = addr;
		addr += get_section_size( section );
	}
}

/*-----------------------------------------------------------------------------
*   allocate a new module, setup module_start[] and reset ASMPC of all sections, 
*   return new unique ID; make it the current module
*----------------------------------------------------------------------------*/
int new_module_id( void )
{
	Section *section;
	SectionHashElem *iter;
	int module_id;

	init();
	module_id = get_last_module_id() + 1;

	/* expand all sections this new ID */
	for ( section = get_first_section( &iter ) ; section != NULL ; 
		  section = get_next_section( &iter ) )
	{
		section->asmpc = 0;
		section->opcode_size = 0;
		(void) section_module_start( section, module_id );
	}
	
	/* init to default section */
	set_cur_section( g_default_section );
	
	return (g_cur_module = module_id);		/* assign and return */
}

/*-----------------------------------------------------------------------------
*   Handle ASMPC
*	set_PC() defines the instruction start address
*	every byte added increments an offset but keeps ASMPC with start of opcode
*	next_PC() moves to the next opcode
*----------------------------------------------------------------------------*/
void set_PC( UInt addr )
{
    init();
	g_cur_section->asmpc = addr;
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

static void inc_PC( UInt num_bytes )
{
    init();
    g_cur_section->opcode_size += num_bytes;
}

/*-----------------------------------------------------------------------------
*   Check space before allocating bytes in section
*----------------------------------------------------------------------------*/
static void check_space( UInt addr, UInt num_bytes )
{
	init();
    if ( addr + num_bytes > MAXCODESIZE )
        fatal_max_codesize( ( long )MAXCODESIZE );
}

/* reserve space in bytes, increment PC if buffer expanded
   assert only the last module can be expanded */
static Byte *alloc_space( UInt addr, UInt num_bytes )
{
	UInt base_addr;
	UInt old_size, new_size;
	Byte *buffer;

    init();
	base_addr = get_cur_module_start();
	old_size  = get_cur_module_size();

	/* cannot expand unless last module */
	if ( get_cur_module_id() != get_last_module_id() )
		assert( addr + num_bytes <= old_size );

	check_space( base_addr + addr, num_bytes );

	/* reserve space */
	if ( num_bytes > 0 )
	{
		(void)   ByteArray_item( g_cur_section->bytes, base_addr + addr + num_bytes - 1 );
		buffer = ByteArray_item( g_cur_section->bytes, base_addr + addr );
	}
	else 
		buffer = NULL;	/* no allocation */

	/* advance PC if past end of previous buffer */
	new_size = get_cur_module_size();
	if ( new_size > old_size )
		inc_PC( new_size - old_size );

	return buffer;
}

/*-----------------------------------------------------------------------------
*   patch a value at a position, or append to the end of the code area
*	the patch address is relative to current module and current section
*	and is incremented after store
*----------------------------------------------------------------------------*/
void patch_value( UInt *paddr, UInt value, UInt num_bytes )
{
	Byte *buffer;

    init();
	buffer = alloc_space( *paddr, num_bytes );
	(*paddr) += num_bytes;
	while ( num_bytes-- > 0 )
	{
		*buffer++ = value & 0xFF;
		value >>= 8;
	}
}

void append_value( UInt value, UInt num_bytes )
{
	UInt addr;

    init();
	addr = get_cur_module_size();
	patch_value( &addr, value, num_bytes );

	if ( opts.list )
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

/* advance code pointer reserving space, return address of start of buffer */
Byte *append_reserve( UInt num_bytes )
{
    init();
	return alloc_space( get_cur_module_size(), num_bytes );
}

/* append binary contents of file, whole file if num_bytes < 0 */
void patch_file_contents( FILE *file, UInt *paddr, long num_bytes )
{
	long start_ptr;
	Byte *buffer;

	init();

	/* get bin file size */
	if ( num_bytes < 0 )
	{
		start_ptr = ftell( file );
		
		fseek( file, 0, SEEK_END );				/* file pointer to end of file */
		num_bytes = ftell( file ) - start_ptr;
		
		fseek( file, start_ptr, SEEK_SET );		/* file pointer to original position */
	}

	if ( num_bytes > 0 )
	{
		buffer = alloc_space( *paddr, num_bytes );
		xfget_chars( file, (char *) buffer, num_bytes );
		*paddr += num_bytes;
	}
}

void append_file_contents( FILE *file, long num_bytes )
{
	UInt addr;

	init();
	addr = get_cur_module_size();
	patch_file_contents( file, &addr, num_bytes );
}

/*-----------------------------------------------------------------------------
*   read/write current module to an open file
*----------------------------------------------------------------------------*/
UInt fwrite_module_code( FILE *file )
{
	Section *section;
	SectionHashElem *iter;
	UInt code_size = 0;
	UInt addr, size;

	init();
	for ( section = get_first_section( &iter ) ; section != NULL ; 
		  section = get_next_section( &iter ) )
	{
		addr = section_module_start( section, g_cur_module );
		size = section_module_size(  section, g_cur_module );

		/* write all sections, even empty ones, to allow user to define sections list by 
		   a sequence of SECTION statements
		   exception: empty section, as it is the first one anyway, if no ORG is defined */
		if ( size > 0 || section != get_first_section(NULL) || section->origin >= 0 )
		{
			xfput_int32( file, size );
			xfput_count_byte_strz( file, section->name );
			xfput_int32( file, section->origin );

			if ( size > 0 )		/* ByteArray_item(bytes,0) creates item[0]!! */
				xfput_chars( file, (char *) ByteArray_item( section->bytes, addr ), size );

			code_size += size;
		}
	}

	if ( code_size > 0 )
		xfput_int32( file, -1 );		/* end marker */

	return code_size;
}

/*-----------------------------------------------------------------------------
*   read/write whole code area to an open file
*----------------------------------------------------------------------------*/
void fwrite_codearea( char *filename, FILE **pfile )
{
	init();
	fwrite_codearea_chunk( filename, pfile, 0, get_sections_size() );
}

/* write a chunk of data; addr is offset from first section */
void fwrite_codearea_chunk( char *filename, FILE **pfile, UInt offset, UInt write_size )
{
	DEFINE_FILE_STR( new_name );
	Section *section;
	SectionHashElem *iter;
	UInt cur_offset, section_size, block_size;
	Int  cur_addr;

	init();

	cur_offset = 0;
	cur_addr   = -1;
	for ( section = get_first_section( &iter ) ; section != NULL ; 
		  section = get_next_section( &iter ) )
	{
		section_size = get_section_size( section );

		if ( cur_addr < 0 )
			cur_addr = section->addr;

		/* bytes from this section */
		if ( section_size > 0 &&
			 offset >= cur_offset && offset < cur_offset + section_size )
		{
			/* change current file if address changed */
			if ( cur_addr != section->addr || 
				 ( section != get_first_section(NULL) && section->origin >= 0 ) )
			{
				Str_set( new_name, path_remove_ext( filename ) );	/* "test" */
				Str_append_char( new_name, '_' );
				Str_append( new_name, section->name );

				xfclose( *pfile );
				*pfile = xfopen( get_bin_filename( new_name->str ), "wb" );         /* CH_0012 */

				cur_addr = section->addr;
			}

			block_size = cur_offset + section_size - offset;
			block_size = MIN( block_size, write_size );

			xfput_chars( *pfile, (char *) ByteArray_item( section->bytes, offset - cur_offset ), block_size );

			write_size -= block_size;
			offset     += block_size;

			if ( write_size == 0 )
				break;
		}

		cur_offset += section_size;
		cur_addr += section_size;
	}
}
