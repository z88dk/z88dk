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

Copyright (C) Paulo Custodio, 2011-2014

Handle object file contruction, reading and writing

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/objfile.c,v 1.33 2014-06-09 13:15:26 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "class.h"
#include "codearea.h"
#include "errors.h"
#include "fileutil.h"
#include "options.h"
#include "model.h"
#include "objfile.h"
#include "strpool.h"
#include "strutil.h"
#include "legacy.h"

#include <assert.h>

/*-----------------------------------------------------------------------------
*   Object header
*----------------------------------------------------------------------------*/
#ifdef __LEGACY_Z80ASM_SYNTAX
char Z80objhdr[] 	= "Z80RMF01";
#else
char Z80objhdr[] 	= "Z80RMF" OBJ_VERSION;
#endif

#define Z80objhdr_size (sizeof(Z80objhdr)-1)

/*-----------------------------------------------------------------------------
*   Write module to object file
*----------------------------------------------------------------------------*/
static long write_expr( FILE *fp, Module *module )
{
	static Str *last_sourcefile = NULL;		/* keep last source file referred to in object */
	ExprListElem *iter;
    Expr *expr;
	char range;
	long expr_ptr;

	INIT_OBJ( Str, &last_sourcefile );

	if ( ExprList_empty( module->exprs ) )	/* no expressions */
		return -1;

	expr_ptr = ftell( fp );
	for ( iter = ExprList_first( module->exprs ); iter != NULL; iter = ExprList_next( iter ) )
	{
		expr = iter->obj;

		/* store range */
		switch ( expr->expr_type & RANGE )
		{
		case RANGE_32SIGN:	range = 'L'; break;
		case RANGE_16CONST:	range = 'C'; break;
		case RANGE_8UNSIGN:	range = 'U'; break;
		case RANGE_8SIGN:	range = 'S'; break;
		case RANGE_JROFFSET:
		default:
			assert(0);
		}
		xfput_uint8( fp, range );				/* range of expression */

		/* store file name if different from last, folowed by source line number */
		if ( expr->filename != NULL &&
			 strcmp( last_sourcefile->str, expr->filename ) != 0 )
		{
			xfput_count_word_strz( fp, expr->filename );
			Str_set( last_sourcefile, expr->filename );
		}
		else
			xfput_count_word_strz( fp, "" );

		xfput_int32(  fp, expr->line_nr );				/* source line number */
		xfput_uint16( fp, expr->asmpc );				/* ASMPC */
		xfput_uint16( fp, expr->code_pos );				/* patchptr */
		xfput_count_word_strz( fp, expr->text->str );	/* expression */
	}

	xfput_uint8( fp, 0 );								/* terminator */

	return expr_ptr;
}

static int write_symbols_symtab( FILE *fp, SymbolHash *symtab )
{
    SymbolHashElem *iter;
    Symbol         *sym;
	int written = 0;
	char scope, type;

    for ( iter = SymbolHash_first( symtab ); iter; iter = SymbolHash_next( iter ) )
    {
        sym = ( Symbol * )iter->value;

		/* scope */
		scope = ( sym->sym_type & SYM_PUBLIC ) ? 'G' :
			    ( sym->sym_type & SYM_LOCAL  ) ? 'L' : 0;

		/* type */
		type = ( sym->sym_type & SYM_ADDR ) ? 'A' : 'C';

        if ( scope != 0 && ( sym->sym_type & SYM_TOUCHED ) )
        {
			xfput_uint8( fp, scope );
			xfput_uint8( fp, type );
			xfput_uint32(fp, sym->value );
			xfput_count_byte_strz( fp, sym->name );

			written++;
        }
    }
	return written;
}

static long write_symbols( FILE *fp, Module *module )
{
	long symbols_ptr;
	int written = 0;

	symbols_ptr = ftell( fp );

	written += write_symbols_symtab( fp, module->local_symtab );
	written += write_symbols_symtab( fp, global_symtab );

	if ( written )
		return symbols_ptr;
	else
		return -1;
}

static long write_externsym( FILE *fp, Module *module )
{
    SymbolHashElem *iter;
    Symbol         *sym;
	long externsym_ptr;
	int written = 0;

	externsym_ptr = ftell( fp );

    for ( iter = SymbolHash_first( global_symtab ); iter; iter = SymbolHash_next( iter ) )
    {
        sym = ( Symbol * )iter->value;

        if ( ( sym->sym_type & SYM_EXTERN ) && 
			 ( sym->sym_type & SYM_TOUCHED ) )
		{
			xfput_count_byte_strz( fp, sym->name );
			written++;
		}
    }

	if ( written )
		return externsym_ptr;
	else
		return -1;
}

static long write_modname( FILE *fp, Module *module )
{
	long modname_ptr = ftell( fp );
	xfput_count_byte_strz( fp, module->modname );		/* write module name */
	return modname_ptr;
}

static long write_code( FILE *fp, Module *module )
{
	long code_ptr, code_size;
	
	code_size = get_codeindex();
	if ( code_size == 0 )
		return -1;

	code_ptr = ftell( fp );
    xfput_uint16( fp, code_size & 0xFFFF );				/* two bytes of module code size */
    fwrite_codearea( fp );

    if ( opts.verbose )
        printf( "Size of module '%s' is %ld bytes\n", module->modname, code_size );

    inc_codesize( code_size);							/* BUG_0015 */

	return code_ptr;
}

void write_obj_file( char *source_filename, Module *module )
{
	char *obj_filename;
	FILE *fp;
	long header_ptr, modname_ptr, expr_ptr, symbols_ptr, externsym_ptr, code_ptr;
	int i;

	/* open file */
	obj_filename = get_obj_filename( source_filename );
	fp = xfopen_atomic( obj_filename, "w+b" );

	/* write header */
    xfput_strz( fp, Z80objhdr );
	xfput_uint16( fp, module->origin );		/* two bytes of origin */

	/* write placeholders for 5 pointers pointers */
	header_ptr = ftell( fp );
	for ( i = 0; i < 5; i++ )
	    xfput_uint32( fp, -1 );

	/* write sections, return pointers */
	expr_ptr		= write_expr(		fp, module );
	symbols_ptr		= write_symbols(	fp, module );
	externsym_ptr	= write_externsym(	fp, module );
	modname_ptr		= write_modname(	fp, module );
	code_ptr		= write_code(		fp, module );

	/* write pointers to areas */
	fseek( fp, header_ptr, SEEK_SET );
    xfput_uint32( fp, modname_ptr );
    xfput_uint32( fp, expr_ptr );
    xfput_uint32( fp, symbols_ptr );
    xfput_uint32( fp, externsym_ptr );
    xfput_uint32( fp, code_ptr );

	/* close temp file and rename to object file */
	xfclose( fp );
}



/*-----------------------------------------------------------------------------
*   Check the object file header
*----------------------------------------------------------------------------*/
static Bool test_header( FILE *file )
{
    char buffer[Z80objhdr_size];

    if ( fread(  buffer, sizeof(char), Z80objhdr_size, file ) == Z80objhdr_size &&
         memcmp( buffer, Z80objhdr,    Z80objhdr_size ) == 0
       )
        return TRUE;
    else
        return FALSE;
}

/*-----------------------------------------------------------------------------
*   Object file class
*----------------------------------------------------------------------------*/
DEF_CLASS( OFile );

void OFile_init( OFile *self )
{
	self->origin = -1;
	self->modname_ptr = 
	self->expr_ptr = 
	self->symbols_ptr =
	self->externsym_ptr = 
	self->code_ptr = -1;
}

void OFile_copy( OFile *self, OFile *other ) { assert(0); }

void OFile_fini( OFile *self )
{
	/* if not from library, close file */
    if ( self->file		 != NULL && 
		 self->start_ptr == 0
	   )
        xfclose( self->file );

	/* if writing but not closed, delete partialy created file */
    if ( self->writing && 
		 self->start_ptr == 0 &&
         self->file      != NULL && 
		 self->filename  != NULL
	   )
        remove( self->filename );
}

/*-----------------------------------------------------------------------------
*	read object file header from within an open library file.
*   Return NULL if invalid object file or not the correct version.
*   Object needs to be deleted by caller by OBJ_DELETE()
*   Keeps the library file open
*----------------------------------------------------------------------------*/
OFile *OFile_read_header( FILE *file, size_t start_ptr )
{
	OFile *self;
    DEFINE_STR( buffer, MAXLINE );

	/* check file version */
    fseek( file, start_ptr, SEEK_SET );
	if ( ! test_header( file ) )
		return NULL;

	/* create OFile object */
	self = OBJ_NEW( OFile );

	self->file			= file;
	self->start_ptr		= start_ptr;
	self->writing		= FALSE;

    /* read object file header */
    self->origin = xfget_uint16( file );
	if ( self->origin == 0xFFFF)
		self->origin = -1;

    self->modname_ptr	= xfget_int32( file );
    self->expr_ptr		= xfget_int32( file );
    self->symbols_ptr	= xfget_int32( file );
    self->externsym_ptr	= xfget_int32( file );
    self->code_ptr		= xfget_int32( file );

    /* read module name */
    fseek( file, start_ptr + self->modname_ptr, SEEK_SET );
    xfget_count_byte_Str( file, buffer );
    self->modname		= strpool_add( buffer->str );

    /* read code size */
    if ( self->code_ptr < 0 )
        self->code_size = 0;
    else
    {
        fseek( file, self->start_ptr + self->code_ptr, SEEK_SET );
        self->code_size = xfget_uint16( file );

        if ( self->code_size == 0 )		/* BUG_0008 */
            self->code_size = 0x10000;
    }

	return self;
}

/*-----------------------------------------------------------------------------
*	open object file for reading, read header.
*   Return NULL if invalid object file or not the correct version.
*   Object needs to be deleted by caller by OBJ_DELETE()
*   Keeps the object file open
*----------------------------------------------------------------------------*/
static OFile *_OFile_open_read( char *filename, Bool test_mode )
{
	OFile *self;
	FILE *file;

	/* file exists? */
	file = test_mode ? 
			fopen(  filename, "rb" ) :	/* no exceptions if testing */
			xfopen( filename, "rb" );
	if ( file == NULL )
		return NULL;

	/* read header */
	self = OFile_read_header( file, 0 );
	if ( self == NULL )
	{
		xfclose( file );
		
		if ( ! test_mode )
			error_not_obj_file( filename );

		return NULL;
	}
	self->filename = strpool_add( filename );

	/* return object */
	return self;
}

OFile *OFile_open_read( char *filename )
{
	return _OFile_open_read( filename, FALSE );
}

/*-----------------------------------------------------------------------------
*	close object file
*----------------------------------------------------------------------------*/
void OFile_close( OFile *self )
{
	if ( self != NULL && self->file != NULL )
	{
		xfclose( self->file );
		self->file = NULL;
	}
}

/*-----------------------------------------------------------------------------
*	test if a object file exists and is the correct version, return object if yes
*   return NULL if not. 
*   Object needs to be deleted by caller by OBJ_DELETE()
*   Opens and closes the object file
*----------------------------------------------------------------------------*/
OFile *OFile_test_file( char *filename )
{
	OFile *self = _OFile_open_read( filename, TRUE );

	/* close the file */
	if ( self != NULL && self->file != NULL )
	{
		xfclose( self->file );
		self->file = NULL;
	}

	return self;
}

/*-----------------------------------------------------------------------------
*	return static ByteArray with binary contents of given file
*	return NULL if input file is not an object, or does not exist
*	NOTE: not reentrant, reuses array on each call
*----------------------------------------------------------------------------*/
ByteArray *read_obj_file_data( char *filename )
{
	static ByteArray *buffer = NULL;
	size_t	 size;
	OFile	*ofile;

	/* static object to read each file, not reentrant */
	INIT_OBJ( ByteArray, &buffer );

	/* open object file, check header */
	ofile = OFile_open_read( filename );
	if ( ofile == NULL )
		return NULL;					/* error */

    fseek( ofile->file, 0, SEEK_END );	/* file pointer to end of file */
    size = ftell( ofile->file );
    fseek( ofile->file, 0, SEEK_SET );	/* file pointer to start of file */

	/* set array size, read file */
	ByteArray_set_size( buffer, size );
	xfget_chars( ofile->file, (char *) ByteArray_item( buffer, 0 ), size );
    
	OBJ_DELETE( ofile );

	return buffer;
}

/*-----------------------------------------------------------------------------
*	Updates current module name and size, if given object file is valid
*	Load module name and size, when assembling with -d and up-to-date
*----------------------------------------------------------------------------*/
Bool objmodule_loaded( char *src_filename, Module *module )
{
	OFile *ofile = OFile_test_file( get_obj_filename( src_filename ) );
    if ( ofile != NULL )
    {
        inc_codesize( ofile->code_size );		/* BUG_0015, BUG_0050 */
        module->modname = ofile->modname;        
		OBJ_DELETE( ofile );					/* BUG_0049 */

        return TRUE;
    }
    else
        return FALSE;
}



/*
* $Log: objfile.c,v $
* Revision 1.33  2014-06-09 13:15:26  pauloscustodio
* Int and UInt types
*
* Revision 1.32  2014/06/03 22:53:14  pauloscustodio
* Do not sort symbols before writing to object file. Not needed and
* wastes time.
*
* Revision 1.31  2014/06/02 22:29:14  pauloscustodio
* Write object file in one go at the end of pass 2, instead of writing
* parts during pass 1 assembly. This allows the object file format to be
* changed more easily, to allow sections in a near future.
* Remove global variable objfile and CloseFiles().
*
* Revision 1.30  2014/05/25 01:02:29  pauloscustodio
* Byte, Int, UInt added
*
* Revision 1.29  2014/05/21 20:57:27  pauloscustodio
* Embryo of write module
*
* Revision 1.28  2014/05/19 22:15:54  pauloscustodio
* Move read_obj_file_data() to objfile.c
* Move CreateLibfile() to libfile.c, rename to search_libfile()
*
* Revision 1.27  2014/05/19 00:21:10  pauloscustodio
* logic error in test for library
*
* Revision 1.26  2014/05/17 23:08:03  pauloscustodio
* Change origin to Int, use -1 to signal as not defined
*
* Revision 1.25  2014/05/17 22:42:25  pauloscustodio
* Move load_module_object() that loads object file size when assembling
* with -d option to objfile.c. Change objfile API.
*
* Revision 1.24  2014/05/17 14:27:12  pauloscustodio
* Use C99 integer types
*
* Revision 1.23  2014/05/06 22:17:38  pauloscustodio
* Made types all-caps to avoid conflicts with /usr/include/i386-linux-gnu/sys/types.h
*
* Revision 1.22  2014/05/02 21:34:58  pauloscustodio
* byte_t and uint_t renamed to Byte, UInt
*
* Revision 1.21  2014/04/22 23:32:42  pauloscustodio
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
* Revision 1.20  2014/03/05 23:44:55  pauloscustodio
* Renamed 64-bit portability to BUG_0042
*
* Revision 1.19  2014/02/25 22:39:34  pauloscustodio
* ws
*
* Revision 1.18  2014/02/19 23:59:26  pauloscustodio
* BUG_0042: 64-bit portability issues
* size_t changes to unsigned long in 64-bit. Usage of size_t * to
* retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
* breaks on a 64-bit architecture. Make the functions return the value instead
* of being passed the pointer to the return value, so that the compiler
* takes care of size convertions.
* Create UInt, use UInt instead of size_t.
*
* Revision 1.17  2014/01/23 22:30:55  pauloscustodio
* Use xfclose() instead of fclose() to detect file write errors during buffer flush called
* at fclose()
*
* Revision 1.16  2014/01/20 23:29:18  pauloscustodio
* Moved file.c to lib/fileutil.c
*
* Revision 1.15  2014/01/14 23:53:53  pauloscustodio
* Missing include
*
* Revision 1.14  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.13  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
* 
* Revision 1.12  2013/12/30 02:05:32  pauloscustodio
* Merge dynstr.c and safestr.c into lib/strutil.c; the new Str type
* handles both dynamically allocated strings and fixed-size strings.
* Replaced g_strchomp by chomp by; g_ascii_tolower by tolower;
* g_ascii_toupper by toupper; g_ascii_strcasecmp by stricompare.
* 
* Revision 1.11  2013/12/15 13:18:34  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
* 
* Revision 1.10  2013/09/08 00:43:59  pauloscustodio
* New error module with one error function per error, no need for the error
* constants. Allows compiler to type-check error message arguments.
* Included the errors module in the init() mechanism, no need to call
* error initialization from main(). Moved all error-testing scripts to
* one file errors.t.
* 
* Revision 1.9  2013/09/01 18:46:01  pauloscustodio
* Remove call to strpool_init(). String pool is initialized in init.c before main() starts.
* 
* Revision 1.8  2013/08/30 21:50:43  pauloscustodio
* By suggestion of Philipp Klaus Krause: rename LEGACY to __LEGACY_Z80ASM_SYNTAX,
* as an identifier reserved by the C standard for implementation-defined behaviour
* starting with two underscores.
* 
* Revision 1.7  2013/08/30 01:06:08  pauloscustodio
* New C-like expressions, defined when __LEGACY_Z80ASM_SYNTAX is not defined. Keeps old
* behaviour under -D__LEGACY_Z80ASM_SYNTAX (defined in legacy.h)
* 
* BACKWARDS INCOMPATIBLE CHANGE, turned OFF by default (-D__LEGACY_Z80ASM_SYNTAX)
* - Expressions now use more standard C-like operators
* - Object and library files changed signature to
*   "Z80RMF02", "Z80LMF02", to avoid usage of old
*   object files with expressions inside in the old format
* 
* Detail:
* - String concatenation in DEFM: changed from '&' to ',';  '&' will be AND
* - Power:                        changed from '^' to '**'; '^' will be XOR
* - XOR:                          changed from ':' to '^';
* - AND:                          changed from '~' to '&';  '~' will be NOT
* - NOT:                          '~' added as binary not
* 
* Revision 1.6  2013/05/12 19:46:35  pauloscustodio
* New module for object file handling
* 
* Revision 1.5  2013/03/30 00:02:22  pauloscustodio
* include xmalloc.h before any other include
* 
* Revision 1.4  2013/01/20 21:24:28  pauloscustodio
* Updated copyright year to 2013
* 
* Revision 1.3  2012/05/24 17:09:27  pauloscustodio
* Unify copyright header
* 
* Revision 1.2  2012/05/11 19:29:49  pauloscustodio
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
* Revision 1.1  2011/08/19 15:53:58  pauloscustodio
* BUG_0010 : heap corruption when reaching MAXCODESIZE
* - test for overflow of MAXCODESIZE is done before each instruction at parseline(); 
*	if only one byte is available in codearea, and a 2 byte instruction is assembled, 
*	the heap is corrupted before the exception is raised.
* - Factored all the codearea-accessing code into a new module, checking for MAXCODESIZE on every write.
* 
*/
