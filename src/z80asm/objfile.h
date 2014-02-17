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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/objfile.h,v 1.11 2014-02-17 23:12:38 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */

#include "class.h"
#include "types.h"
#include <stdio.h>
#include <stdlib.h>

/*-----------------------------------------------------------------------------
*   Object file handle
*----------------------------------------------------------------------------*/
CLASS( ObjFile )
	FILE   *file;				/* file handle, if file open */
	long	start_ptr;			/* offset in file to start of object file
								   used when object module is part of a library */

	char   *filename;			/* object file name, in strpool */
	char   *modname;			/* module name, in strpool */

	BOOL	in_library;			/* true if this file is part of a library */
	BOOL	writing;			/* TRUE if writing a new object file,
								   FALSE if reading */

	int		org_addr;			/* defined ORG address, -1 if not defined */

	/* all file pointers are -1 if not defined */
	long	modname_ptr;		/* offset in file to Module Name */
	long	expr_ptr;			/* offset if file to Expression Declaration */
	long	symbols_ptr;		/* offset if file to Name Definition */
	long	externsym_ptr;		/* offset if file to External Name Declaration */
	long	code_ptr;			/* offset if file to Machine Code Block */

	size_t	code_size;			/* size of code block */

END_CLASS;

/*-----------------------------------------------------------------------------
*   API
*----------------------------------------------------------------------------*/

/* open object file for reading, return new object that needs to be deleted
   by OBJ_DELETE() by caller;
   return NULL and raise error on invalid file or file not found;
   In test_mode does not raise errors - used when deciding if an existent
   object file can be reused or needs to be assembled again */
extern ObjFile *ObjFile_open_read( char *filename, BOOL test_mode );

/* read an object file from an open library file, return new object that
   needs to be deleted by OBJ_DELETE() by caller;
   return NULL and raise error on invalid file */
extern ObjFile *ObjFile_read( char *filename, FILE *libfile );


/*
* $Log: objfile.h,v $
* Revision 1.11  2014-02-17 23:12:38  pauloscustodio
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
* Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
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
* - test for overflow of MAXCODESIZE is done before each instruction at parseline(); if only one byte is available in codearea, and a 2 byte instruction is assembled, the heap is corrupted before the exception is raised.
* - Factored all the codearea-accessing code into a new module, checking for MAXCODESIZE on every write.
* 
*/
