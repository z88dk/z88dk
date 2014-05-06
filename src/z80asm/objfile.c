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


$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/objfile.c,v 1.23 2014-05-06 22:17:38 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "class.h"
#include "errors.h"
#include "fileutil.h"
#include "objfile.h"
#include "strpool.h"
#include "strutil.h"
#include "legacy.h"

#include <sys/stat.h>


/*-----------------------------------------------------------------------------
*   Object header
*----------------------------------------------------------------------------*/
#ifdef __LEGACY_Z80ASM_SYNTAX
char Z80objhdr[] 	= "Z80RMF01";
#else
char Z80objhdr[] 	= "Z80RMF" OBJ_VERSION;
#endif

#define Z80objhdr_size (sizeof(Z80objhdr)-1)

char objhdrprefix[] = "oomodnexprnamelibnmodc";

/*-----------------------------------------------------------------------------
*   Object file handle
*----------------------------------------------------------------------------*/
DEF_CLASS( ObjFile );

void ObjFile_init( ObjFile *self )
{
    self->org_addr = -1;
    self->modname_ptr = self->expr_ptr = self->symbols_ptr = self->externsym_ptr
                                         = self->code_ptr = -1;
    self->code_size = 0;
}

void ObjFile_copy( ObjFile *self, ObjFile *other ) { }

void ObjFile_fini( ObjFile *self )
{
    if ( self->file != NULL && ! self->in_library )
        xfclose( self->file );

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
             ( filestat.st_mode & S_IFREG ) &&
             ( filestat.st_mode & S_IREAD ) &&
             filestat.st_size > ( long )Z80objhdr_size );
}

/*-----------------------------------------------------------------------------
*   Check the object file header
*----------------------------------------------------------------------------*/
static BOOL test_header( FILE *file )
{
    char buffer[Z80objhdr_size];

    if ( fread( buffer, sizeof( char ), Z80objhdr_size, file ) == Z80objhdr_size &&
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
    DEFINE_STR( buffer, MAXLINE );
    ObjFile *self;
    FILE    *file;
    long	 start_ptr;
	UINT	 org_addr;
    BOOL	 in_library = libfile == NULL ? FALSE : TRUE;

    /* open file if needed */
    if ( in_library )
        file = libfile;
    else
    {
        /* checking at compile phase? */
        if ( test_mode && ! objfile_exists( filename ) )
            return NULL;

        /* open file - no error in test_mode, as we bailed out just above */
        file = xfopen( filename, "rb" );
    }

    /* check header, bail out if wrong */
    start_ptr = ftell( file );

    if ( ! test_header( file ) )
    {
        if ( ! test_mode )
            error_not_obj_file( filename );	/* error except test_mode */

        if ( ! in_library )
            xfclose( file );							/* close except in library */

        return NULL;
    }

    /* create ObjFile and fill-in header */
    self = OBJ_NEW( ObjFile );

    self->file			= file;
    self->start_ptr		= start_ptr;
    self->filename		= strpool_add( filename );
    self->in_library	= in_library;
    self->writing		= FALSE;

    /* read object file header */
    org_addr			= xfget_uint16( self->file );
	self->org_addr		= (org_addr == 0xFFFF) ? -1 : (int) org_addr;

    self->modname_ptr	= xfget_int32( self->file );
    self->expr_ptr		= xfget_int32( self->file );
    self->symbols_ptr	= xfget_int32( self->file );
    self->externsym_ptr	= xfget_int32( self->file );
    self->code_ptr		= xfget_int32( self->file );

    /* read module name */
    fseek( self->file, self->start_ptr + self->modname_ptr, SEEK_SET );
    xfget_count_byte_Str( self->file, buffer );
    self->modname = strpool_add( buffer->str );

    /* read code size */
    if ( self->code_ptr < 0 )
        self->code_size = 0;
    else
    {
        fseek( self->file, self->start_ptr + self->code_ptr, SEEK_SET );
        self->code_size = xfget_uint16( self->file );

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


/*
* $Log: objfile.c,v $
* Revision 1.23  2014-05-06 22:17:38  pauloscustodio
* Made types BYTE, UINT and ULONG all-caps to avoid conflicts with /usr/include/i386-linux-gnu/sys/types.h
*
* Revision 1.22  2014/05/02 21:34:58  pauloscustodio
* byte_t, uint_t and ulong_t renamed to BYTE, UINT and ULONG
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
* Create UINT and ULONG, use UINT instead of size_t.
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
