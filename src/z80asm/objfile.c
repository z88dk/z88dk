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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/objfile.c,v 1.35 2014-06-21 02:15:43 pauloscustodio Exp $
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
static long write_expr( FILE *fp )
{
	static Str *last_sourcefile = NULL;		/* keep last source file referred to in object */
	ExprListElem *iter;
    Expr *expr;
	char range;
	long expr_ptr;

	INIT_OBJ( Str, &last_sourcefile );

	if ( ExprList_empty( CURRENTMODULE->exprs ) )	/* no expressions */
		return -1;

	expr_ptr = ftell( fp );
	for ( iter = ExprList_first( CURRENTMODULE->exprs ); iter != NULL; iter = ExprList_next( iter ) )
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

static long write_symbols( FILE *fp )
{
	long symbols_ptr;
	int written = 0;

	symbols_ptr = ftell( fp );

	written += write_symbols_symtab( fp, CURRENTMODULE->local_symtab );
	written += write_symbols_symtab( fp, global_symtab );

	if ( written )
		return symbols_ptr;
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

static long write_modname( FILE *fp )
{
	long modname_ptr = ftell( fp );
	xfput_count_byte_strz( fp, CURRENTMODULE->modname );		/* write module name */
	return modname_ptr;
}

static long write_code( FILE *fp )
{
	long code_ptr, end_code_ptr;
	UInt code_size;
	
	code_ptr = ftell( fp );

	/* advance past size and try to write code to get back total bytes written, maybe zero*/
	fseek( fp, 2, SEEK_CUR );
	code_size = fwrite_module_code( fp );
	if ( code_size == 0 )
	{
		fseek( fp, code_ptr, SEEK_SET );
		code_ptr = -1;								/* nothing written */
	}
	else 
	{
		end_code_ptr = ftell( fp );
		fseek( fp, code_ptr, SEEK_SET );
		xfput_uint16( fp, code_size & 0xFFFF );		/* two bytes of module code size */
		fseek( fp, end_code_ptr, SEEK_SET );
	}

    if ( opts.verbose )
        printf( "Size of module '%s' is %ld bytes\n", CURRENTMODULE->modname, (long)code_size );

	return code_ptr;
}

void write_obj_file( char *source_filename )
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
	xfput_uint16( fp, CURRENTMODULE->origin );		/* two bytes of origin */

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
Bool objmodule_loaded( char *src_filename )
{
	OFile *ofile = OFile_test_file( get_obj_filename( src_filename ) );
    if ( ofile != NULL )
    {
		append_reserve( ofile->code_size );		/* BUG_0015 */
        CURRENTMODULE->modname = ofile->modname;        
		OBJ_DELETE( ofile );					/* BUG_0049 */

        return TRUE;
    }
    else
        return FALSE;
}
