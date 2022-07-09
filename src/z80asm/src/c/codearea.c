/*
Z88DK Z80 Macro Assembler

Copyright (C) Paulo Custodio, 2011-2022
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

Manage the code area in memory
*/

#include "codearea.h"
#include "die.h"
#include "fileutil.h"
#include "if.h"
#include "init.h"
#include "options.h"
#include "strutil.h"
#include "utstring.h"
#include "z80asm.h"
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
DEF_CLASS_HASH( Section, false );

void Section_init (Section *self)   
{
	self->name = "";		/* default: empty section */
	self->addr	= 0;
	self->origin = -1;
	self->align = 1;
	self->origin_found = false;
	self->origin_opts = false;
	self->section_split = false;
	self->asmpc = 0;
	self->asmpc_phase = -1;
	self->opcode_size = 0;
	
	self->bytes = OBJ_NEW(ByteArray);
	OBJ_AUTODELETE(self->bytes) = false;

	self->reloc = OBJ_NEW(intArray);
	OBJ_AUTODELETE(self->reloc) = false;

	self->module_start = OBJ_NEW(intArray);
	OBJ_AUTODELETE( self->module_start ) = false;
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
Section *new_section( const char *name )
{
	int last_id;

	init_module();
	g_cur_section = SectionHash_get( g_sections, name );
	if ( g_cur_section == NULL )
	{
		g_cur_section = OBJ_NEW( Section );
		g_cur_section->name = spool_add( name );
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
	xassert( module_id >= 0 );
	xassert( module_id <= get_last_module_id() );
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
		xassert( get_section_size( section ) >= addr );

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
	Section *section, *next_section;
	SectionHashElem *iter;
	int addr;

	init_module();

	/* allocate addr in sequence */
	addr = 0;
	for (section = get_first_section(&iter); section != NULL; section = next_section) {
		if (section->origin >= 0) {		/* break in address space */
			if (option_single_binary_block() && section != get_first_section(&iter)) {
				/* merge sections together if appmake or relocatable */
			}
			else {
				addr = section->origin;
			}
		}

		section->addr = addr;
		addr += get_section_size(section);

		// check ALIGN of next section, extend this section if needed
		next_section = get_next_section(&iter);
		if (next_section != NULL && !(next_section->origin >= 0) && next_section->align > 1
			&& get_section_size(next_section) > 0) {
			int above = addr % next_section->align;
			if (above > 0) {
				for (int i = next_section->align - above; i > 0; i--) {
					*(ByteArray_push(section->bytes)) = opts.filler;
					addr++;
				}
			}
		}
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
		section->asmpc_phase = -1;
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
	if (g_cur_section->asmpc_phase >= 0)
		g_cur_section->asmpc_phase += g_cur_section->opcode_size;

	g_cur_section->opcode_size = 0;
	return g_cur_section->asmpc;
}

int get_PC(void)
{
	init_module();
	return g_cur_section->asmpc;
}

int get_phased_PC(void)
{
	init_module();
	return g_cur_section->asmpc_phase;
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
	if (addr + num_bytes > MAXCODESIZE && !g_cur_section->max_codesize_issued) {
		error_segment_overflow();
		g_cur_section->max_codesize_issued = true;
	}
}

/* reserve space in bytes, increment PC if buffer expanded
   assert only the last module can be expanded */
static byte_t *alloc_space( int addr, int num_bytes )
{
	int base_addr;
	int old_size, new_size;
	byte_t *buffer;

    init_module();
	base_addr = get_cur_module_start();
	old_size  = get_cur_module_size();

	/* cannot expand unless last module */
	if ( get_cur_module_id() != get_last_module_id() )
		xassert( addr + num_bytes <= old_size );

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
	byte_t *buffer;

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

	if (opts.cur_list)
		list_append_bytes(value, num_bytes);
}

void patch_byte( int addr, byte_t byte1 ) { patch_value( addr, byte1, 1 ); }
void patch_word( int addr, int  word  ) { patch_value( addr, word,  2 ); }
void patch_long( int addr, long dword ) { patch_value( addr, dword, 4 ); }

void patch_word_be(int addr, int  word) { patch_value(addr, ((word & 0xFF00) >> 8) | ((word & 0x00FF) << 8), 2); }

void append_byte( byte_t byte1 ) { append_value( byte1, 1 ); }
void append_word( int  word )  { append_value( word,  2 ); }
void append_long( long dword ) { append_value( dword, 4 ); }

void append_word_be(int  word) { append_value(((word & 0xFF00) >> 8) | ((word & 0x00FF) << 8), 2); }

void append_2bytes( byte_t byte1, byte_t byte2 ) 
{
	append_value( byte1, 1 );
	append_value( byte2, 1 );
}

void append_defs(int num_bytes, byte_t fill)
{
	while (num_bytes-- > 0)
		append_byte(fill);
}

/* advance code pointer reserving space, return address of start of buffer */
byte_t *append_reserve( int num_bytes )
{
    init_module();
	return alloc_space( get_cur_module_size(), num_bytes );
}

void patch_from_memory(byte_t* data, int addr, long num_bytes) {
	init_module();

	if (num_bytes > 0) {
		byte_t *buffer = alloc_space(addr, num_bytes);
		memcpy(buffer, data, num_bytes);
	}
}

/*-----------------------------------------------------------------------------
*   read/write current module to an open file
*----------------------------------------------------------------------------*/
bool fwrite_module_code(FILE *file, int* p_code_size)
{
	Section *section;
	SectionHashElem *iter;
	bool wrote_data = false;
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
		if (size > 0 || section != get_first_section(NULL) || 
		    section->origin >= 0 || section->align > 1)
		{
			xfwrite_dword(size, file);
			xfwrite_wcount_cstr(section->name, file);
			write_origin(file, section);
			xfwrite_dword(section->align, file);

			if (size > 0)		/* ByteArray_item(bytes,0) creates item[0]!! */
				xfwrite_bytes((char *)ByteArray_item(section->bytes, addr), size, file);

			code_size += size;
			wrote_data = true;
		}
	}

	if (wrote_data)
		xfwrite_dword(-1, file);		/* end marker */

	if (p_code_size)
		*p_code_size = code_size;

	return wrote_data;
}

/*-----------------------------------------------------------------------------
*   read/write whole code area to an open file
*----------------------------------------------------------------------------*/
void fwrite_codearea(const char *filename,
	CodeareaFile* binfile, CodeareaFile* relocfile)
{
	UT_string* new_basename;
	utstring_new(new_basename);

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
		if (section_size > 0 || section->origin >= 0 || section->section_split)
		{
			if (section->name && *section->name)	/* only if section name not empty */
			{
				/* change current file if address changed, or option -split-bin, or section_split */
				if ((!option_single_binary_block() && opts.split_bin) ||
					section->section_split ||
					cur_addr != section->addr ||
					(section != get_first_section(NULL) && section->origin >= 0))
				{
					utstring_clear(new_basename);
					utstring_printf(new_basename, "%s_%s",
						path_remove_ext(filename),		/* e.g. "test" */
						section->name);					/* e.g. "_code" */

					// close old files, remove if empty and not initial files
					codearea_close_remove(binfile, relocfile);

					// open next bin file
					binfile->filename = path_canon(
						get_bin_filename(
							utstring_body(new_basename)));
					binfile->fp = xfopen(binfile->filename, "wb");

					if (opts.verbose)
						printf("Creating binary '%s'\n", binfile->filename);

					// open next reloc file
					if (relocfile->fp) {
						relocfile->filename = path_canon(
							get_reloc_filename(
								utstring_body(new_basename)));
						relocfile->fp = xfopen(relocfile->filename, "wb");

						cur_section_block_size = 0;
					}

					cur_addr = section->addr;
				}
			}

			xfwrite_bytes((char*)ByteArray_item(section->bytes, 0),
				section_size, binfile->fp);

			if (relocfile->fp) {
				unsigned i;
				for (i = 0; i < intArray_size(section->reloc); i++) {
					xfwrite_word(*(intArray_item(section->reloc, i)) + cur_section_block_size,
						relocfile->fp);
				}
			}

			cur_section_block_size += section_size;
		}

		cur_addr += section_size;
	}

	utstring_free(new_basename);
}

// close old files, remove if empty and not initial files
void codearea_close_remove(CodeareaFile* binfile, CodeareaFile* relocfile) {
	// get size of bin file
	xfseek(binfile->fp, 0, SEEK_END);
	long bin_size = ftell(binfile->fp);

	// close both files
	xfclose(binfile->fp);
	if (relocfile->fp)
		xfclose(relocfile->fp);

	// delete both if bin is not empty and not the first file
	if (bin_size == 0 &&
		0 != strcmp(binfile->filename, binfile->initial_filename)) {
		remove(binfile->filename);
		if (relocfile->fp)
			remove(relocfile->filename);
	}
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
		CURRENTSECTION->origin_found = true;
		if (origin == -1)					/* signal split section binary file */
			CURRENTSECTION->section_split = true;
		else if (origin >= 0)
		{
			if (CURRENTSECTION->origin_opts && CURRENTSECTION->origin >= 0)
				; /* ignore ORG, as -r from command line overrides */
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

	if (origin < 0)		// value can be >0xffff for banked address
		error_int_range((long)origin);
	else
	{
		default_section = get_first_section(NULL);
		default_section->origin = origin;
		default_section->origin_opts = true;
	}
}


void read_origin(FILE* file, Section *section) {
	int origin = xfread_dword(file);
	set_origin(origin, section);
}

extern void set_origin(int origin, Section *section) {
	if (origin >= 0) {
		section->origin = origin;
		section->section_split = false;
	}
	else if (origin == -2) {
		section->section_split = true;
	}
	else {
		// ignore all other values
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

	xfwrite_dword(origin, file);
}

void set_phase_directive(int address)
{
	if (address >= 0 && address <= 0xFFFF)
		CURRENTSECTION->asmpc_phase = address;
	else
		error_int_range(address);
}

void clear_phase_directive()
{
	CURRENTSECTION->asmpc_phase = -1;
}
