/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

Handle object file contruction, reading and writing
*/

#pragma once

#include "array.h"
#include "class.h"
#include "module.h"
#include "types.h"
#include <stdio.h>
#include <stdlib.h>

#define OBJ_VERSION	"08"

/*-----------------------------------------------------------------------------
*   Write current module to object file - object file name is computed
*----------------------------------------------------------------------------*/
extern void write_obj_file( char *src_filename );

/*-----------------------------------------------------------------------------
*   Object file class
*----------------------------------------------------------------------------*/
CLASS( OFile )
	FILE	*file;				/* file handle */
	size_t	 start_ptr;			/* offset in file to start of object file
								   used when object module is part of a library */

	Bool	 writing;			/* TRUE if writing a new object file,
								   FALSE if reading */

	char	*filename;			/* object file name, in strpool */
	char	*modname;			/* module name, in strpool */

	/* all file pointers are -1 if not defined */
	long	 modname_ptr;		/* offset in file to Module Name */
	long	 expr_ptr;			/* offset if file to Expression Declaration */
	long	 symbols_ptr;		/* offset if file to Name Definition */
	long	 externsym_ptr;		/* offset if file to External Name Declaration */
	long	 code_ptr;			/* offset if file to Machine Code Block */
END_CLASS;	

/*-----------------------------------------------------------------------------
*   OFile API - reading
*----------------------------------------------------------------------------*/

/* test if a object file exists and is the correct version, return object if yes
   return NULL if not. 
   Object needs to be deleted by caller by OBJ_DELETE() */
extern OFile *OFile_test_file( char *filename );

/* read object file header from within an open library file.
   Return NULL if invalid object file or not the correct version.
   Object needs to be deleted by caller by OBJ_DELETE()
   Keeps the object file open */
extern OFile *OFile_read_header( FILE *file, size_t start_ptr );

/* open object file for reading, read header.
   Return NULL if invalid object file or not the correct version.
   Object needs to be deleted by caller by OBJ_DELETE()
   Keeps the object file open */
extern OFile *OFile_open_read( char *filename );
extern void   OFile_close( OFile *self );

/* return static ByteArray with binary contents of the given object file,
   return NULL if input file is not an object, wrong version, or does not exist
   NOTE: not reentrant, reuses array on each call */
extern ByteArray *read_obj_file_data( char *filename );

/*-----------------------------------------------------------------------------
*   Module interface to object files
*----------------------------------------------------------------------------*/

/* Updates current module name and size, if object file of given source is valid
   load module name and size, when assembling with -d and up-to-date */
extern Bool objmodule_loaded( char *src_filename );
