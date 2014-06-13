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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/codearea.c,v 1.36 2014-06-13 16:00:45 pauloscustodio Exp $
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
*   init the code area, return current size
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

/* return number of bytes appended to current section */
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
	UInt codeindex;
    
	init();
	codeindex = get_section_size( g_cur_section );
    xfput_chars( file, (char *) ByteArray_item( g_cur_section->bytes, 0 ), codeindex );
}

void fwrite_codearea_chunk( FILE *file, UInt addr, UInt size )
{
	UInt codeindex;

	init();
	codeindex = get_section_size( g_cur_section );
    if ( addr < codeindex )
    {
        if ( addr + size > codeindex )
            size = codeindex - addr;

        xfput_chars( file, (char *) ByteArray_item( g_cur_section->bytes, addr ), size );
    }
}

/* append data read from file to the current code area */
void fread_codearea( FILE *file, UInt size )
{
	UInt codeindex;

	init();
	codeindex = get_section_size( g_cur_section );
	if ( size > 0 )
	{
		check_space( codeindex, size );
		ByteArray_item( g_cur_section->bytes, codeindex + size - 1 );		/* reserve space */
		xfget_chars( file, (char *) ByteArray_item( g_cur_section->bytes, codeindex ), size );
		inc_PC( size );
	}
}

/* read to codearea at offset - BUG_0015 */
void fread_codearea_offset( FILE *file, UInt offset, UInt size )
{
	init();
	if ( size > 0 )
	{
		check_space( offset, size );
		ByteArray_item( g_cur_section->bytes, offset + size - 1 );		/* reserve space */
		xfget_chars( file, (char *) ByteArray_item( g_cur_section->bytes, offset ), size );
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


/*
* $Log: codearea.c,v $
* Revision 1.36  2014-06-13 16:00:45  pauloscustodio
* Extended codearea.c to support different sections of code.
*
* Revision 1.35  2014/06/09 13:15:25  pauloscustodio
* Int and UInt types
*
* Revision 1.34  2014/05/25 01:02:29  pauloscustodio
* Byte, Int, UInt added
*
* Revision 1.33  2014/05/17 14:27:12  pauloscustodio
* Use C99 integer types
*
* Revision 1.32  2014/05/06 22:52:01  pauloscustodio
* Remove OS-dependent defines and dependency on ../config.h.
* Remove OS_ID constant from predefined defines in assembly.
*
* Revision 1.31  2014/05/06 22:17:37  pauloscustodio
* Made types all-caps to avoid conflicts with /usr/include/i386-linux-gnu/sys/types.h
*
* Revision 1.30  2014/05/02 21:34:58  pauloscustodio
* byte_t and uint_t renamed to Byte, UInt
*
* Revision 1.29  2014/04/22 23:52:55  pauloscustodio
* As inc_PC() is no longer needed, append_opcode() no longer makes sense.
* Removed append_opcode() and created a new helper append_2bytes().
*
* Revision 1.28  2014/04/22 23:32:42  pauloscustodio
* Release 2.2.0 with major fixes:
*
* - Object file format changed to version 03, to include address of start
* of the opcode of each expression stored in the object file, to allow
* ASMPC to refer to the start of the opcode instead of the patch pointer.
* This solves long standing BUG_0011 and BUG_0048.
*
* - ASMPC no longer stored in the symbol table and evaluated as a separate
* token, to allow expressions including ASMPC to be relocated. This solves
* long standing and never detected BUG_0047.
*
* - Handling ASMPC during assembly simplified - no need to call inc_PC() on
* every assembled instruction, no need to store list of JRPC addresses as
* ASMPC is now stored in the expression.
*
* BUG_0047: Expressions including ASMPC not relocated - impacts call po|pe|p|m emulation in RCMX000
* ASMPC is computed on zero-base address of the code section and expressions
* including ASMPC are not relocated at link time.
* "call po, xx" is emulated in --RCMX000 as "jp pe, ASMPC+3; call xx".
* The expression ASMPC+3 is not marked as relocateable, and the resulting
* code only works when linked at address 0.
*
* BUG_0048: ASMPC used in JP/CALL argument does not refer to start of statement
* In "JP ASMPC", ASMPC is coded as instruction-address + 1 instead
* of instruction-address.
*
* BUG_0011 : ASMPC should refer to start of statememnt, not current element in DEFB/DEFW
* Bug only happens with forward references to relative addresses in expressions.
* See example from zx48.asm ROM image in t/BUG_0011.t test file.
* Need to change object file format to correct - need patchptr and address of instruction start.
*
* Revision 1.27  2014/04/15 21:07:18  pauloscustodio
* append_opcode() to append_byte() and inc_PC() in one go
*
* Revision 1.26  2014/03/05 23:44:55  pauloscustodio
* Renamed 64-bit portability to BUG_0042
*
* Revision 1.25  2014/02/25 22:39:34  pauloscustodio
* ws
*
* Revision 1.24  2014/02/19 23:59:26  pauloscustodio
* BUG_0042: 64-bit portability issues
* size_t changes to unsigned long in 64-bit. Usage of size_t * to
* retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
* breaks on a 64-bit architecture. Make the functions return the value instead
* of being passed the pointer to the return value, so that the compiler
* takes care of size convertions.
* Create UInt, use UInt instead of size_t.
*
* Revision 1.23  2014/01/20 23:29:17  pauloscustodio
* Moved file.c to lib/fileutil.c
*
* Revision 1.22  2014/01/11 01:29:39  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.21  2014/01/11 00:10:38  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.20  2014/01/09 23:26:24  pauloscustodio
* Use init.h mechanism, no need for main() calling init_codearea
*
* Revision 1.19  2013/12/15 13:18:33  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.18  2013/09/22 21:34:48  pauloscustodio
* Remove legacy xxx_err() interface
*
* Revision 1.17  2013/09/12 00:10:02  pauloscustodio
* Create xfree() macro that NULLs the pointer after free, required
* by z80asm to find out if a pointer was already freed.
*
* Revision 1.16  2013/09/09 00:15:11  pauloscustodio
* Integrate codearea in init() mechanism.
*
* Revision 1.15  2013/09/08 08:29:21  pauloscustodio
* Replaced xmalloc et al with glib functions
*
* Revision 1.14  2013/09/08 00:43:58  pauloscustodio
* New error module with one error function per error, no need for the error
* constants. Allows compiler to type-check error message arguments.
* Included the errors module in the init() mechanism, no need to call
* error initialization from main(). Moved all error-testing scripts to
* one file errors.t.
*
* Revision 1.13  2013/09/01 00:18:28  pauloscustodio
* - Replaced e4c exception mechanism by a much simpler one based on a few
*   macros. The former did not allow an exit(1) to be called within a
*   try-catch block.
*
* Revision 1.12  2013/05/12 19:39:32  pauloscustodio
* warnings
*
* Revision 1.11  2013/03/30 00:02:22  pauloscustodio
* include xmalloc.h before any other include
*
* Revision 1.10  2013/02/22 17:19:19  pauloscustodio
* Add listfile interface to append bytes to the listing
* Remove oldPC - no longer needed with new listfile
* Solve memory leak
*
* Revision 1.9  2013/01/24 23:03:03  pauloscustodio
* Replaced (unsigned char) by (Byte)
* Replaced (unisigned int) by (UInt)
* Replaced (short) by (int)
*
* Revision 1.8  2013/01/20 21:24:28  pauloscustodio
* Updated copyright year to 2013
*
* Revision 1.7  2012/05/26 18:51:10  pauloscustodio
* CH_0012 : wrappers on OS calls to raise fatal error
* CH_0013 : new errors interface to decouple calling code from errors.c
*
* Revision 1.6  2012/05/24 17:09:27  pauloscustodio
* Unify copyright header
*
* Revision 1.5  2012/05/24 16:18:53  pauloscustodio
* Let garbage collector do memory release atexit()
*
* Revision 1.4  2012/05/20 06:02:08  pauloscustodio
* Garbage collector
* Added automatic garbage collection on exit and simple fence mechanism
* to detect buffer underflow and overflow, to xmalloc functions.
* No longer needed to call init_malloc().
* No longer need to try/catch during creation of memory structures to
* free partially created data - all not freed data is freed atexit().
* Renamed xfree0() to xfree().
*
* Revision 1.3  2012/05/11 19:29:49  pauloscustodio
* Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, 
* indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
*         --mode=c
*         --lineend=linux
*         --indent=spaces=4
*         --style=ansi --add-brackets
*         --indent-switches --indent-classes
*         --indent-preprocessor --convert-tabs
*         --break-blocks
*         --pad-oper --pad-paren-in --pad-header --unpad-paren
*         --align-pointer=name
*
* Revision 1.2  2011/10/07 17:53:04  pauloscustodio
* BUG_0015 : Relocation issue - dubious addresses come out of linking
* (reported on Tue, Sep 27, 2011 at 8:09 PM by dom)
* - Introduced in version 1.1.8, when the CODESIZE and the codeptr were merged into the same entity.
* - This caused the problem because CODESIZE keeps track of the start offset of each module in the sequence they will appear in the object file, and codeptr is reset to the start of the codearea for each module.
* The effect was that all address calculations at link phase were considering
*  a start offset of zero for all modules.
* - Moreover, when linking modules from a libary, the modules are pulled in to the code area as they are needed, and not in the sequence they will be in the object file. The start offset was being ignored and the modules were being loaded in the incorrect order
* - Consequence of these two issues were all linked addresses wrong.
*
* Revision 1.1  2011/08/19 15:53:58  pauloscustodio
* BUG_0010 : heap corruption when reaching MAXCODESIZE
* - test for overflow of MAXCODESIZE is done before each instruction at parseline(); 
*	if only one byte is available in codearea, and a 2 byte instruction is assembled, 
*	the heap is corrupted before the exception is raised.
* - Factored all the codearea-accessing code into a new module, checking for MAXCODESIZE on every write.
*
*/
