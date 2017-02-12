/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

Handle object file contruction, reading and writing
*/

#include "class.h"
#include "codearea.h"
#include "errors.h"
#include "fileutil.h"
#include "options.h"
#include "model.h"
#include "objfile.h"
#include "strpool.h"
#include "str.h"

#include <assert.h>

/*-----------------------------------------------------------------------------
*   Object header
*----------------------------------------------------------------------------*/
char Z80objhdr[] 	= "Z80RMF" OBJ_VERSION;

#define Z80objhdr_size (sizeof(Z80objhdr)-1)

/*-----------------------------------------------------------------------------
*   Write module to object file
*----------------------------------------------------------------------------*/
static long write_expr( FILE *fp )
{
	STR_DEFINE(last_sourcefile, STR_SIZE);		/* keep last source file referred to in object */
	ExprListElem *iter;
    Expr *expr;
	char range, *target_name;
	long expr_ptr;

	if ( ExprList_empty( CURRENTMODULE->exprs ) )	/* no expressions */
		return -1;

	expr_ptr = ftell( fp );
	for ( iter = ExprList_first( CURRENTMODULE->exprs ); iter != NULL; iter = ExprList_next( iter ) )
	{
		expr = iter->obj;

		/* store range */
		if ( expr->target_name )
		{
			target_name = expr->target_name;		/* EQU expression */
			range = '=';
		}
		else
		{
			target_name = "";						/* patch expression */
			switch ( expr->range )
			{
			case RANGE_DWORD:			range = 'L'; break;
			case RANGE_WORD:			range = 'C'; break;
			case RANGE_BYTE_UNSIGNED:	range = 'U'; break;
			case RANGE_BYTE_SIGNED:		range = 'S'; break;
			case RANGE_JR_OFFSET:		assert(0);
			default:					assert(0);
			}
		}
		xfput_uint8( fp, range );				/* range of expression */

		/* store file name if different from last, folowed by source line number */
		if ( expr->filename != NULL &&
			 strcmp( str_data(last_sourcefile), expr->filename ) != 0 )
		{
			xfput_count_word_strz( fp, expr->filename );
			str_set( last_sourcefile, expr->filename );
		}
		else
			xfput_count_word_strz( fp, "" );

		xfput_int32(  fp, expr->line_nr );				/* source line number */

		xfput_count_byte_strz( fp, expr->section->name );	/* section name */

		xfput_uint16( fp, expr->asmpc );				/* ASMPC */
		xfput_uint16( fp, expr->code_pos );				/* patchptr */
		xfput_count_byte_strz( fp, target_name );		/* target symbol for expression */
		xfput_count_word_strz( fp, str_data(expr->text) );	/* expression */
	}

	xfput_uint8( fp, 0 );								/* terminator */

	STR_DELETE(last_sourcefile);

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
		scope =
			(sym->scope == SCOPE_PUBLIC || (sym->is_defined && sym->scope == SCOPE_GLOBAL)) ? 'G' :
			(sym->scope == SCOPE_LOCAL) ? 'L' : 0;

		if (scope != 0 && sym->is_touched && sym->type != TYPE_UNKNOWN)
		{
			/* type */
			switch (sym->type)
			{
			case TYPE_CONSTANT:	type = 'C'; break;
			case TYPE_ADDRESS:	type = 'A'; break;
			case TYPE_COMPUTED:	type = '='; break;
			default: assert(0);
			}

			xfput_uint8(fp, scope);
			xfput_uint8(fp, type);

			xfput_count_byte_strz(fp, sym->section->name);
			xfput_uint32(fp, sym->value);
			xfput_count_byte_strz(fp, sym->name);

			written++;
		}
    }
	return written;
}

static long write_symbols( FILE *fp )
{
	long symbols_ptr;
	int written = 0;

	symbols_ptr = ftell( fp );

	written += write_symbols_symtab( fp, CURRENTMODULE->local_symtab );
	written += write_symbols_symtab( fp, global_symtab );

	if ( written )
	{
		xfput_uint8( fp, 0 );								/* terminator */
		return symbols_ptr;
	}
	else
		return -1;
}

static long write_externsym( FILE *fp )
{
    SymbolHashElem *iter;
    Symbol         *sym;
	long externsym_ptr;
	int written = 0;

	externsym_ptr = ftell( fp );

    for ( iter = SymbolHash_first( global_symtab ); iter; iter = SymbolHash_next( iter ) )
    {
        sym = ( Symbol * )iter->value;

		if (sym->is_touched &&
			(sym->scope == SCOPE_EXTERN || (!sym->is_defined && sym->scope == SCOPE_GLOBAL)))
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

static long write_modname( FILE *fp )
{
	long modname_ptr = ftell( fp );
	xfput_count_byte_strz( fp, CURRENTMODULE->modname );		/* write module name */
	return modname_ptr;
}

static long write_code( FILE *fp )
{
	long code_ptr;
	int code_size;
	
	code_ptr  = ftell( fp );
	code_size = fwrite_module_code( fp );

	if (opts.verbose)
		printf("Module '%s' size: %ld bytes\n", CURRENTMODULE->modname, (long)code_size);

	if ( code_size > 0 )
		return code_ptr;
	else
		return -1;
}

void write_obj_file( char *source_filename )
{
	char *obj_filename;
	FILE *fp;
	long header_ptr, modname_ptr, expr_ptr, symbols_ptr, externsym_ptr, code_ptr;
	int i;

	/* open file */
	obj_filename = get_obj_filename( source_filename );
	fp = myfopen_atomic( obj_filename, "w+b" );

	/* write header */
    xfput_strz( fp, Z80objhdr );

	/* write placeholders for 5 pointers pointers */
	header_ptr = ftell( fp );
	for ( i = 0; i < 5; i++ )
	    xfput_uint32( fp, -1 );

	/* write sections, return pointers */
	expr_ptr		= write_expr( fp );
	symbols_ptr		= write_symbols( fp );
	externsym_ptr	= write_externsym( fp );
	modname_ptr		= write_modname( fp );
	code_ptr		= write_code( fp );

	/* write pointers to areas */
	fseek( fp, header_ptr, SEEK_SET );
    xfput_uint32( fp, modname_ptr );
    xfput_uint32( fp, expr_ptr );
    xfput_uint32( fp, symbols_ptr );
    xfput_uint32( fp, externsym_ptr );
    xfput_uint32( fp, code_ptr );

	/* close temp file and rename to object file */
	myfclose( fp );
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
        myfclose( self->file );

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
	STR_DEFINE(buffer, STR_SIZE);
	OFile *self;

	/* check file version */
    fseek( file, start_ptr, SEEK_SET );
	if ( ! test_header( file ) )
		return NULL;

	/* create OFile object */
	self = OBJ_NEW( OFile );

	self->file			= file;
	self->start_ptr		= start_ptr;
	self->writing		= FALSE;

    self->modname_ptr	= xfget_int32( file );
    self->expr_ptr		= xfget_int32( file );
    self->symbols_ptr	= xfget_int32( file );
    self->externsym_ptr	= xfget_int32( file );
    self->code_ptr		= xfget_int32( file );

    /* read module name */
    fseek( file, start_ptr + self->modname_ptr, SEEK_SET );
    xfget_count_byte_Str( file, buffer );
    self->modname		= strpool_add( str_data(buffer) );

	STR_DELETE(buffer);

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
			myfopen( filename, "rb" );
	if ( file == NULL )
		return NULL;

	/* read header */
	self = OFile_read_header( file, 0 );
	if ( self == NULL )
	{
		myfclose( file );
		
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
		myfclose( self->file );
		self->file = NULL;
	}
}

/*-----------------------------------------------------------------------------
*	test if a object file exists and is the correct version, return object if yes
*   return NULL if not. 
*   Object needs to be deleted by caller by OBJ_DELETE()
*----------------------------------------------------------------------------*/
OFile *OFile_test_file( char *filename )
{
	return _OFile_open_read( filename, TRUE );
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
static Bool objmodule_loaded_1( char *src_filename, Str *section_name )
{
	int code_size;
	OFile *ofile;
	Section *section;

	ofile = OFile_test_file( get_obj_filename( src_filename ) );
    if ( ofile != NULL )
    {
        CURRENTMODULE->modname = ofile->modname;        

		/* reserve space in each section; BUG_0015 */
		if ( ofile->code_ptr >= 0 )
		{
			fseek( ofile->file, ofile->start_ptr + ofile->code_ptr, SEEK_SET );

			while (TRUE)	/* read sections until end marker */
			{
				code_size = xfget_int32( ofile->file );
				if ( code_size < 0 )
					break;

				/* reserve space in section */
				xfget_count_byte_Str(ofile->file, section_name);
				section = new_section(str_data(section_name));
				read_origin(ofile->file, section);
				append_reserve( code_size );

				/* advance past code block */
				fseek( ofile->file, code_size, SEEK_CUR );
			}
		}

		OBJ_DELETE( ofile );					/* BUG_0049 */

        return TRUE;
    }
    else
        return FALSE;
}

Bool objmodule_loaded(char *src_filename)
{
	STR_DEFINE(section_name, STR_SIZE);
	Bool ret = objmodule_loaded_1(src_filename, section_name);
	STR_DELETE(section_name);
	return ret;
}
