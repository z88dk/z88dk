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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/objfile.h,v 1.25 2014-06-02 22:29:14 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */

#include "array.h"
#include "class.h"
#include "module.h"
#include "types.h"
#include <stdio.h>
#include <stdlib.h>

#define OBJ_VERSION	"04"

/*-----------------------------------------------------------------------------
*   Write module to object file - object file name is computed
*----------------------------------------------------------------------------*/
extern void write_obj_file( char *src_filename, Module *module );




#define EXPR_DECL_FSEEK	30

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

	int32_t	 origin;			/* ORG address, -1 if not defined */

	/* all file pointers are -1 if not defined */
	int32_t	 modname_ptr;		/* offset in file to Module Name */
	int32_t	 expr_ptr;			/* offset if file to Expression Declaration */
	int32_t	 symbols_ptr;		/* offset if file to Name Definition */
	int32_t	 externsym_ptr;		/* offset if file to External Name Declaration */
	int32_t	 code_ptr;			/* offset if file to Machine Code Block */

	uint32_t code_size;			/* size of code block */
END_CLASS;	

/*-----------------------------------------------------------------------------
*   OFile API - reading
*----------------------------------------------------------------------------*/

/* test if a object file exists and is the correct version, return object if yes
   return NULL if not. 
   Object needs to be deleted by caller by OBJ_DELETE()
   Opens and closes the object file */
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
extern Bool objmodule_loaded( char *src_filename, Module *module );

/*
* $Log: objfile.h,v $
* Revision 1.25  2014-06-02 22:29:14  pauloscustodio
* Write object file in one go at the end of pass 2, instead of writing
* parts during pass 1 assembly. This allows the object file format to be
* changed more easily, to allow sections in a near future.
* Remove global variable objfile and CloseFiles().
*
* Revision 1.24  2014/05/29 00:19:37  pauloscustodio
* CH_0025: Link-time expression evaluation errors show source filename and line number
* Object file format changed to version 04, to include the source file
* location of expressions in order to give meaningful link-time error messages.
*
* Revision 1.23  2014/05/25 01:02:29  pauloscustodio
* Byte, Int, UInt added
*
* Revision 1.22  2014/05/21 20:57:27  pauloscustodio
* Embryo of write module
*
* Revision 1.21  2014/05/19 22:15:54  pauloscustodio
* Move read_obj_file_data() to objfile.c
* Move CreateLibfile() to libfile.c, rename to search_libfile()
*
* Revision 1.20  2014/05/19 00:21:10  pauloscustodio
* logic error in test for library
*
* Revision 1.19  2014/05/17 22:42:25  pauloscustodio
* Move load_module_object() that loads object file size when assembling
* with -d option to objfile.c. Change objfile API.
*
* Revision 1.18  2014/05/17 14:27:12  pauloscustodio
* Use C99 integer types
*
* Revision 1.17  2014/05/06 22:17:38  pauloscustodio
* Made types all-caps to avoid conflicts with /usr/include/i386-linux-gnu/sys/types.h
*
* Revision 1.16  2014/05/02 21:34:58  pauloscustodio
* byte_t and uint_t renamed to Byte, uint32_t
*
* Revision 1.15  2014/04/22 23:32:42  pauloscustodio
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
* Revision 1.14  2014/03/05 23:44:55  pauloscustodio
* Renamed 64-bit portability to BUG_0042
*
* Revision 1.13  2014/02/25 22:39:34  pauloscustodio
* ws
*
* Revision 1.12  2014/02/19 23:59:26  pauloscustodio
* BUG_0042: 64-bit portability issues
* size_t changes to unsigned long in 64-bit. Usage of size_t * to
* retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
* breaks on a 64-bit architecture. Make the functions return the value instead
* of being passed the pointer to the return value, so that the compiler
* takes care of size convertions.
* Create uint32_t, use uint32_t instead of size_t.
*
* Revision 1.11  2014/02/17 23:12:38  pauloscustodio
* ws
*
* Revision 1.10  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.9  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
* 
* Revision 1.8  2013/12/15 13:18:34  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
* 
* Revision 1.7  2013/06/08 23:08:38  pauloscustodio
* comments
* 
* Revision 1.6  2013/05/12 19:46:35  pauloscustodio
* New module for object file handling
* 
* Revision 1.5  2013/01/20 21:24:28  pauloscustodio
* Updated copyright year to 2013
* 
* Revision 1.4  2012/11/03 17:39:36  pauloscustodio
* astyle, comments
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
