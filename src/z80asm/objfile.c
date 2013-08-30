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

Copyright (C) Paulo Custodio, 2011-2013

Handle object file contruction, reading and writing


$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/objfile.c,v 1.7 2013-08-30 01:06:08 pauloscustodio Exp $

$Log: objfile.c,v $
Revision 1.7  2013-08-30 01:06:08  pauloscustodio
New C-like expressions, defined when LEGACY is not defined. Keeps old
behaviour under -DLEGACY (defined in legacy.h)

BACKWARDS INCOMPATIBLE CHANGE, turned OFF by default (-DLEGACY)
- Expressions now use more standard C-like operators
- Object and library files changed signature to
  "Z80RMF02", "Z80LMF02", to avoid usage of old
  object files with expressions inside in the old format

Detail:
- String concatenation in DEFM: changed from '&' to ',';  '&' will be AND
- Power:                        changed from '^' to '**'; '^' will be XOR
- XOR:                          changed from ':' to '^';
- AND:                          changed from '~' to '&';  '~' will be NOT
- NOT:                          '~' added as binary not

Revision 1.6  2013/05/12 19:46:35  pauloscustodio
New module for object file handling

Revision 1.5  2013/03/30 00:02:22  pauloscustodio
include memalloc.h before any other include

Revision 1.4  2013/01/20 21:24:28  pauloscustodio
Updated copyright year to 2013

Revision 1.3  2012/05/24 17:09:27  pauloscustodio
Unify copyright header

Revision 1.2  2012/05/11 19:29:49  pauloscustodio
Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
        --mode=c
        --lineend=linux
        --indent=spaces=4
        --style=ansi --add-brackets
        --indent-switches --indent-classes
        --indent-preprocessor --convert-tabs
        --break-blocks
        --pad-oper --pad-paren-in --pad-header --unpad-paren
        --align-pointer=name

Revision 1.1  2011/08/19 15:53:58  pauloscustodio
BUG_0010 : heap corruption when reaching MAXCODESIZE
- test for overflow of MAXCODESIZE is done before each instruction at parseline(); if only one byte is available in codearea, and a 2 byte instruction is assembled, the heap is corrupted before the exception is raised.
- Factored all the codearea-accessing code into a new module, checking for MAXCODESIZE on every write.

*/

#include "memalloc.h"   /* before any other include */

#include "class.h"
#include "errors.h"
#include "file.h"
#include "objfile.h"
#include "safestr.h"
#include "strpool.h"
#include "legacy.h"

/*-----------------------------------------------------------------------------
*   Object header
*----------------------------------------------------------------------------*/
#ifdef LEGACY
char Z80objhdr[] 	= "Z80RMF01";
#else
char Z80objhdr[] 	= "Z80RMF02";
#endif

#define Z80objhdr_size (sizeof(Z80objhdr)-1)

char objhdrprefix[] = "oomodnexprnamelibnmodc";

/*-----------------------------------------------------------------------------
*   Object file handle
*----------------------------------------------------------------------------*/
DEF_CLASS( ObjFile );

void ObjFile_init (ObjFile *self) 
{
	strpool_init();
	self->org_addr = -1;
	self->modname_ptr = self->expr_ptr = self->symbols_ptr = self->externsym_ptr 
					  = self->code_ptr = -1;
	self->code_size = 0;
}

void ObjFile_copy (ObjFile *self, ObjFile *other) { }

void ObjFile_fini (ObjFile *self)
{
	if ( self->file != NULL && ! self->in_library )
		fclose( self->file );
	
	if ( self->writing && ! self->in_library && 
		 self->file != NULL && self->filename != NULL )
		remove( self->filename );
}

/*-----------------------------------------------------------------------------
*   Check that file exists and at least as long as the obj header
*----------------------------------------------------------------------------*/
static BOOL objfile_exists( char *filename )
{
	struct stat filestat;
	return ( stat( filename, &filestat ) == 0 &&
			 (filestat.st_mode & S_IFREG) &&
			 (filestat.st_mode & S_IREAD) &&
			 filestat.st_size > (long)Z80objhdr_size );
}

/*-----------------------------------------------------------------------------
*   Check the object file header
*----------------------------------------------------------------------------*/
static BOOL test_header( FILE *file )
{
	char buffer[Z80objhdr_size];

	if ( fread(  buffer, sizeof(char), Z80objhdr_size, file ) == Z80objhdr_size &&
		 memcmp( buffer, Z80objhdr, Z80objhdr_size ) == 0 
	   )
		return TRUE;
	else
		return FALSE;
}

/*-----------------------------------------------------------------------------
*   Read the given object file and return the ObjFile object
*	If libfile is NULL, file is opened
*	Raises errors on failure if not in test_mode
*----------------------------------------------------------------------------*/
ObjFile *_ObjFile_read( char *filename, FILE *libfile, BOOL test_mode )
{
	SSTR_DEFINE( buffer, MAXLINE );
	ObjFile *self;
	FILE    *file;
	long	 start_ptr;
	BOOL	 in_library = libfile == NULL ? FALSE : TRUE;

	/* open file if needed */
	if ( in_library )
		file = libfile;
	else
	{
		/* checking at compile phase? */
		if ( test_mode && ! objfile_exists(filename) )
			return NULL;

		/* open file - no error in test_mode, as we bailed out just above */
		file = xfopen( filename, "rb" );
	}

	/* check header, bail out if wrong */
	start_ptr = ftell(file);
	if ( ! test_header(file) )
	{
		if ( ! test_mode )
			error( ERR_NOT_OBJ_FILE, filename );	/* error except test_mode */

		if ( ! in_library )
			xfclose(file);							/* close except in library */

		return NULL;
	}

	/* create ObjFile and fill-in header */
	self = OBJ_NEW(ObjFile);

	self->file			= file;
	self->start_ptr		= start_ptr;
	self->filename		= strpool_add(filename);
	self->in_library	= in_library;
	self->writing		= FALSE;

	/* read object file header */
	self->org_addr		= xfget_u16( self->file );
	if ( self->org_addr == 0xFFFF )
		self->org_addr = -1;

	self->modname_ptr	= xfget_i32( self->file );
	self->expr_ptr		= xfget_i32( self->file );
	self->symbols_ptr	= xfget_i32( self->file );
	self->externsym_ptr	= xfget_i32( self->file );
	self->code_ptr		= xfget_i32( self->file );

	/* read module name */
	fseek( self->file, self->start_ptr + self->modname_ptr, SEEK_SET );
	xfget_c1sstr( buffer, self->file );
	self->modname = strpool_add( sstr_data(buffer) );

	/* read code size */
	if ( self->code_ptr < 0 )
		self->code_size = 0;
	else
	{
		fseek( self->file, self->start_ptr + self->code_ptr, SEEK_SET );
		self->code_size = xfget_u16( self->file );
		if ( self->code_size == 0 )		/* BUG_0008 */
			self->code_size = 0x10000;
	}

	return self;
}

/*-----------------------------------------------------------------------------
*   open object file for reading, return new object that needs to be deleted
*   by OBJ_DELETE() by caller; 
*   return NULL and raise error on invalid file or file not found;
*   In test_mode does not raise errors - used when deciding if an existent
*   object file can be reused or needs to be assembled again.
*----------------------------------------------------------------------------*/
ObjFile *ObjFile_open_read( char *filename, BOOL test_mode )
{
	return _ObjFile_read( filename, NULL, test_mode );
}

/*-----------------------------------------------------------------------------
*   read an object file from an open library file, return new object that 
*	needs to be deleted by OBJ_DELETE() by caller; 
*   return NULL and raise error on invalid file;
*----------------------------------------------------------------------------*/
ObjFile *ObjFile_read( char *filename, FILE *libfile )
{
	return _ObjFile_read( filename, libfile, FALSE );
}
