/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

Manage the code area in memory
*/

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
DEFINE_init_module()
{
    reset_codearea();	/* init default section */
}

DEFINE_dtor_module()
{
	OBJ_DELETE( g_sections );
	g_cur_section = g_default_section = g_last_section = NULL;
}

/*-----------------------------------------------------------------------------
*   Named Section of code, introduced by "SECTION" keyword
*----------------------------------------------------------------------------*/
DEF_CLASS( Section );
DEF_CLASS_HASH( Section, FALSE );

void Section_init (Section *self)   
{
	self->name = "";		/* default: empty section */
	self->addr	= 0;
	self->origin = -1;
	self->origin_found = FALSE;
	self->origin_opts = FALSE;
	self->section_split = FALSE;
	self->asmpc	= 0;
	self->opcode_size = 0;
	
	self->bytes = OBJ_NEW(ByteArray);
	OBJ_AUTODELETE(self->bytes) = FALSE;

	self->reloc = OBJ_NEW(intArray);
	OBJ_AUTODELETE(self->reloc) = FALSE;

	self->module_start = OBJ_NEW(intArray);
	OBJ_AUTODELETE( self->module_start ) = FALSE;
}

void Section_copy (Section *self, Section *other)	
{ 
	self->bytes = ByteArray_clone(other->bytes);
	self->reloc = intArray_clone(other->reloc);
	self->module_start = intArray_clone(other->module_start);
}

void Section_fini (Section *self)
{
	OBJ_DELETE(self->bytes);
	OBJ_DELETE(self->reloc);
	OBJ_DELETE(self->module_start);
}

/*-----------------------------------------------------------------------------
*   Handle list of current sections
*----------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------
*   init to default section ""; only called at startup
*----------------------------------------------------------------------------*/
void reset_codearea( void )
{
    init_module();
	SectionHash_remove_all( g_sections );
	g_cur_section = g_default_section = g_last_section = NULL;
	new_section("");
}

/*-----------------------------------------------------------------------------
*   return size of current section
*----------------------------------------------------------------------------*/
int get_section_size( Section *section )
{
    init_module();
    return ByteArray_size( section->bytes );
}

/*-----------------------------------------------------------------------------
*   compute total size of all sections
*----------------------------------------------------------------------------*/
int get_sections_size( void )
{
	Section *section;
	SectionHashElem *iter;
	int size;

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

	init_module();
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
			last_id = intArray_size( g_default_section->module_start ) - 1;
			if ( last_id >= 0 )
				intArray_item( g_cur_section->module_start, last_id );		/* init [0..module_id] to zero */
		}
	}
	return g_cur_section;
}

/*-----------------------------------------------------------------------------
*   get/set current section
*----------------------------------------------------------------------------*/
Section *get_cur_section( void )
{
	init_module();
	return g_cur_section;
}

Section *set_cur_section( Section *section )
{
	init_module();
	return (g_cur_section = section);		/* assign and return */
}

/*-----------------------------------------------------------------------------
*   iterate through sections
*	pointer to iterator may be NULL if no need to iterate
*----------------------------------------------------------------------------*/
Section *get_first_section( SectionHashElem **piter )
{
	SectionHashElem *iter;

	init_module();
	if ( piter == NULL )
		piter = &iter;		/* user does not need to iterate */

	*piter = SectionHash_first( g_sections );
	return (*piter == NULL) ? NULL : (Section *) (*piter)->value;
}

Section *get_last_section( void )
{
	init_module();
	return g_last_section;
}

Section *get_next_section(  SectionHashElem **piter )
{
	init_module();
	*piter = SectionHash_next( *piter );
	return (*piter == NULL) ? NULL : (Section *) (*piter)->value;
}

/*-----------------------------------------------------------------------------
*   Handle current module
*----------------------------------------------------------------------------*/
static int get_last_module_id( void )
{
	init_module();
	return intArray_size( g_default_section->module_start ) - 1;
}

int get_cur_module_id( void )
{
	init_module();
	return g_cur_module;
}

void set_cur_module_id( int module_id )
{
	init_module();
	assert( module_id >= 0 );
	assert( module_id <= get_last_module_id() );
	g_cur_module = module_id;
}

/*-----------------------------------------------------------------------------
*   return start and end offset for given section and module ID
*----------------------------------------------------------------------------*/
static int section_module_start( Section *section, int module_id )
{
	int addr, *item;
	int i;
	int cur_size;
	
    init_module();
	cur_size = intArray_size( section->module_start );
	if ( cur_size > module_id )
		addr = *( intArray_item( section->module_start, module_id ) );
	else
	{
		addr = 0;
		for ( i = cur_size < 1 ? 0 : cur_size - 1; 
			  i < module_id; i++ )
		{
			item = intArray_item( section->module_start, i );
			if ( *item < addr )
				*item = addr;
			else
				addr = *item;
		}

		/* update address with current code index */
		item = intArray_item( section->module_start, module_id );
		assert( get_section_size( section ) >= addr );

		addr = *item = get_section_size( section );
	}
	return addr;
}

static int section_module_size(  Section *section, int module_id )
{
	int  last_module_id = get_last_module_id();
	int addr, size;

	addr = section_module_start( section, module_id );
	if ( module_id < last_module_id )
		size = section_module_start( section, module_id + 1 ) - addr;
	else
		size = get_section_size( section ) - addr;

	return size;
}

int get_cur_module_start( void ) { return section_module_start( g_cur_section, g_cur_module ); }
int get_cur_module_size(  void ) { return section_module_size(  g_cur_section, g_cur_module ); }

/*-----------------------------------------------------------------------------
*   allocate the addr of each of the sections, concatenating the sections in
*   consecutive addresses, or starting from a new address if a section
*	has a defined origin. Start at the command line origin, or at 0 if negative
*----------------------------------------------------------------------------*/
void sections_alloc_addr(void)
{
	Section *section;
	SectionHashElem *iter;
	int addr;

	init_module();

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

	init_module();
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
void set_PC( int addr )
{
    init_module();
	g_cur_section->asmpc = addr;
	g_cur_section->opcode_size = 0;
}

int next_PC( void )
{
    init_module();
	g_cur_section->asmpc += g_cur_section->opcode_size;
	g_cur_section->opcode_size = 0;
	return g_cur_section->asmpc;
}

int get_PC( void )
{
    init_module();
	return g_cur_section->asmpc;
}

static void inc_PC( int num_bytes )
{
    init_module();
    g_cur_section->opcode_size += num_bytes;
}

/*-----------------------------------------------------------------------------
*   Check space before allocating bytes in section
*----------------------------------------------------------------------------*/
static void check_space( int addr, int num_bytes )
{
	init_module();
	if (addr + num_bytes > MAXCODESIZE && !g_cur_section->max_codesize_issued)
	{
		error_max_codesize((long)MAXCODESIZE);
		g_cur_section->max_codesize_issued = TRUE;
	}
}

/* reserve space in bytes, increment PC if buffer expanded
   assert only the last module can be expanded */
static Byte *alloc_space( int addr, int num_bytes )
{
	int base_addr;
	int old_size, new_size;
	Byte *buffer;

    init_module();
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
void patch_value( int addr, int value, int num_bytes )
{
	Byte *buffer;

    init_module();
	buffer = alloc_space( addr, num_bytes );
	while ( num_bytes-- > 0 )
	{
		*buffer++ = value & 0xFF;
		value >>= 8;
	}
}

void append_value( int value, int num_bytes )
{
    init_module();
	patch_value(get_cur_module_size(), value, num_bytes);

	if ( opts.list )
		list_append( value, num_bytes );
}

void patch_byte( int addr, Byte byte1 ) { patch_value( addr, byte1, 1 ); }
void patch_word( int addr, int  word  ) { patch_value( addr, word,  2 ); }
void patch_long( int addr, long dword ) { patch_value( addr, dword, 4 ); }

void append_byte( Byte byte1 ) { append_value( byte1, 1 ); }
void append_word( int  word )  { append_value( word,  2 ); }
void append_long( long dword ) { append_value( dword, 4 ); }

void append_2bytes( Byte byte1, Byte byte2 ) 
{
	append_value( byte1, 1 );
	append_value( byte2, 1 );
}

void append_defs(int num_bytes, Byte fill)
{
	while (num_bytes-- > 0)
		append_byte(fill);
}

/* advance code pointer reserving space, return address of start of buffer */
Byte *append_reserve( int num_bytes )
{
    init_module();
	return alloc_space( get_cur_module_size(), num_bytes );
}

/* append binary contents of file, whole file if num_bytes < 0 */
void patch_file_contents( FILE *file, int addr, long num_bytes )
{
	long start_ptr;
	Byte *buffer;

	init_module();

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
		buffer = alloc_space( addr, num_bytes );
		xfget_chars( file, (char *) buffer, num_bytes );
	}
}

void append_file_contents(FILE *file, long num_bytes)
{
	init_module();
	patch_file_contents(file, get_cur_module_size(), num_bytes);
}

/*-----------------------------------------------------------------------------
*   read/write current module to an open file
*----------------------------------------------------------------------------*/
int fwrite_module_code(FILE *file)
{
	Section *section;
	SectionHashElem *iter;
	int code_size = 0;
	int addr, size;

	init_module();
	for (section = get_first_section(&iter); section != NULL;
		section = get_next_section(&iter))
	{
		addr = section_module_start(section, g_cur_module);
		size = section_module_size(section, g_cur_module);

		/* write all sections, even empty ones, to allow user to define sections list by
		   a sequence of SECTION statements
		   exception: empty section, as it is the first one anyway, if no ORG is defined */
		if (size > 0 || section != get_first_section(NULL) || section->origin >= 0)
		{
			xfput_int32(file, size);
			xfput_count_byte_strz(file, section->name);
			write_origin(file, section);

			if (size > 0)		/* ByteArray_item(bytes,0) creates item[0]!! */
				xfput_chars(file, (char *)ByteArray_item(section->bytes, addr), size);

			code_size += size;
		}
	}

	if (code_size > 0)
		xfput_int32(file, -1);		/* end marker */

	return code_size;
}

/*-----------------------------------------------------------------------------
*   read/write whole code area to an open file
*----------------------------------------------------------------------------*/
void fwrite_codearea(char *filename, FILE **pbinfile, FILE **prelocfile)
{
	STR_DEFINE(new_name, FILENAME_MAX);
	Section *section;
	SectionHashElem *iter;
	int section_size;
	int cur_section_block_size;
	int cur_addr;

	init_module();

	cur_addr = -1;
	cur_section_block_size = 0;
	for (section = get_first_section(&iter); section != NULL;
		section = get_next_section(&iter))
	{
		section_size = get_section_size(section);

		if (cur_addr < 0)
			cur_addr = section->addr;

		/* bytes from this section */
		if (section_size > 0)
		{
			if (section->name && *section->name)					/* only if section name not empty */
			{
				/* change current file if address changed, or option --split-bin, or section_split */
				if ((!opts.relocatable && opts.split_bin) ||
					section->section_split ||
					cur_addr != section->addr ||
					(section != get_first_section(NULL) && section->origin >= 0))
				{
					str_set(new_name, path_remove_ext(filename));	/* "test" */
					str_append_char(new_name, '_');
					str_append(new_name, section->name);

					myfclose(*pbinfile);
					*pbinfile = myfopen(get_bin_filename(str_data(new_name)), "wb");
					if (!*pbinfile)
						break;

					if (*prelocfile) {
						myfclose(*prelocfile);
						*prelocfile = myfopen(get_reloc_filename(str_data(new_name)), "wb");
						cur_section_block_size = 0;
					}

					cur_addr = section->addr;
				}
			}

			xfput_chars(*pbinfile, (char *)ByteArray_item(section->bytes, 0), section_size);

			if (*prelocfile) {
				unsigned i;
				for (i = 0; i < intArray_size(section->reloc); i++) {
					xfput_uint16(*prelocfile, *(intArray_item(section->reloc, i)) + cur_section_block_size);
				}
			}

			cur_section_block_size += section_size;
		}

		cur_addr += section_size;
	}

	STR_DELETE(new_name);
}

/*-----------------------------------------------------------------------------
*   Assembly directives
*----------------------------------------------------------------------------*/

/* define a new origin, called by the ORG directive
*  if origin is -1, the section is split creating a new binary file */
void set_origin_directive(int origin)
{
	if (CURRENTSECTION->origin_found)
		error_org_redefined();
	else
	{
		CURRENTSECTION->origin_found = TRUE;
		if (origin == -1)					/* signal split section binary file */
			CURRENTSECTION->section_split = TRUE;
		else if (origin >= 0 && origin <= 0xFFFF)
		{
			if (CURRENTSECTION->origin_opts && CURRENTSECTION->origin >= 0)
				; /* ignore ORG, as --origin from command line overrides */
			else
				CURRENTSECTION->origin = origin;
		}
		else
			error_int_range(origin);
	}
}

/* define a new origin, called by the --orgin command line option */
void set_origin_option(int origin)
{
	Section *default_section;

	if (origin < 0 || origin > 0xFFFF)
		error_int_range((long)origin);
	else
	{
		default_section = get_first_section(NULL);
		default_section->origin = origin;
		default_section->origin_opts = TRUE;
	}
}


void read_origin(FILE* file, Section *section) {
	int origin = xfget_int32(file);
	if (origin >= 0) {
		section->origin = origin;
		section->section_split = FALSE;
	}
	else if (origin == -2) {
		section->section_split = TRUE;
	}
	else {
		section->section_split = FALSE;
	}
}

void write_origin(FILE* file, Section *section) {
	int origin = section->origin;
	if (origin < 0) {
		if (section->section_split)
			origin = -2;			/* write -2 for section split */
		else
			origin = -1;			/* write -1 for not defined */
	}

	xfput_int32(file, origin);
}
