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

Handle library file contruction, reading and writing

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/libfile.c,v 1.1 2014-05-19 00:19:33 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "array.h"
#include "fileutil.h"
#include "legacy.h"
#include "libfile.h"
#include "objfile.h"
#include "options.h"

#ifdef __LEGACY_Z80ASM_SYNTAX
char Z80libhdr[] = "Z80LMF01";
#else
char Z80libhdr[] = "Z80LMF" OBJ_VERSION;
#endif

/*-----------------------------------------------------------------------------
*	return static uint8_tArray with binary contents of given file
*	return NULL if input file is not an object, or does not exist
*	NOTE: not reentrant, reuses array on each call
*----------------------------------------------------------------------------*/
static uint8_tArray *read_obj_file_data( char *filename )
{
	static uint8_tArray *buffer = NULL;
	size_t	 size;
	OFile	*ofile;

	/* static object to read each file, not reentrant */
	INIT_OBJ( uint8_tArray, &buffer );

	/* open object file, check header */
	ofile = OFile_open_read( filename );
	if ( ofile == NULL )
		return NULL;					/* error */

    fseek( ofile->file, 0, SEEK_END );	/* file pointer to end of file */
    size = ftell( ofile->file );
    fseek( ofile->file, 0, SEEK_SET );	/* file pointer to start of file */

	/* set array size, read file */
	uint8_tArray_set_size( buffer, size );
	xfget_chars( ofile->file, (char *) uint8_tArray_item( buffer, 0 ), size );
    
	OBJ_DELETE( ofile );

	return buffer;
}

/*-----------------------------------------------------------------------------
*	make library from list of files; convert each source to object file name 
*----------------------------------------------------------------------------*/
void make_library( char *lib_filename, List *src_files )
{
	uint8_tArray *obj_file_data;
	FILE	*lib_file;
	char	*obj_filename;
	size_t	 fptr, obj_size;
	ListElem *iter, *last;

    if ( opts.verbose )
        printf("Creating library '%s'...\n", lib_filename );

	/* write library header */
	lib_file = xfopen_atomic( lib_filename, "w+b" );	/* CH_0012 */
	xfput_strz( lib_file, Z80libhdr );

	/* write each object file */
	last = List_last( src_files );
	for ( iter = List_first( src_files ); iter != NULL ; iter = List_next( iter ) )
	{
		fptr = ftell( lib_file );

		/* read object file */
		obj_filename  = get_obj_filename( iter->data );
		obj_file_data = read_obj_file_data( obj_filename );
		if ( obj_file_data == NULL )
		{
			xfclose_remove( lib_file );			/* error */
			return;
		}

        if ( opts.verbose )
            printf( "'%s' module at %08X.\n", obj_filename, fptr );

		/* write file pointer of next file, or -1 if last */
		obj_size = uint8_tArray_size( obj_file_data );
        if ( iter == last )
            xfput_uint32( lib_file, -1 );    
        else
            xfput_uint32( lib_file, fptr + 4 + 4 + obj_size ); 

		/* write module size */
        xfput_uint32( lib_file, obj_size );

		/* write module */
        xfput_chars( lib_file, (char *) uint8_tArray_item( obj_file_data, 0 ), obj_size ); 
	}

	/* close and write lib file */
	xfclose( lib_file );
}


/*
* $Log: libfile.c,v $
* Revision 1.1  2014-05-19 00:19:33  pauloscustodio
* Move library creation to libfile.c, use xfopen_atomic to make sure incomplete library
* is deleted in case of error.
*
* 
*/
