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

Handles reading lines from source files, allowing recursive inclusion of files.
Handles the include paths to search for files.
Allows pushing back of lines, for example to expand macros.
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/srcfile.c,v 1.1 2013-02-27 22:31:43 pauloscustodio Exp $ */
/* $Log: srcfile.c,v $
/* Revision 1.1  2013-02-27 22:31:43  pauloscustodio
/* New srcfile.c to handle reading lines from source files
/*
/*
/*
/* */

#include "memalloc.h"   /* before any other include */

#include "file.h"
#include "srcfile.h"
#include "strlist.h"
#include <stdio.h>

/*-----------------------------------------------------------------------------
*   Include path handling
*----------------------------------------------------------------------------*/

/* directory list for search_source_file() */
static SzList *source_path = NULL;

/* add a directory to the search path */
void add_source_file_path( char *directory )
{
	if ( source_path == NULL )
		source_path = OBJ_NEW(SzList);

	SzList_push( source_path, directory );
}

/* search for a source file in the list of directories - path is returned 
   in strpool, no need to free */
char *search_source_file( char *filename )
{
	return search_file( filename, source_path );
}

#if 0

/*-----------------------------------------------------------------------------
*   Class to hold stack of input lines to read next
*----------------------------------------------------------------------------*/
DEF_CLASS_LIST( Str );



/*-----------------------------------------------------------------------------
*   Include path handling, used by SourceFile_open() to search for file in disk
*----------------------------------------------------------------------------*/


/*-----------------------------------------------------------------------------
*   Class to hold current source file
*----------------------------------------------------------------------------*/
CLASS( SourceFile )
	char	*filename;				/* source file name, held in strpool */
	FILE	*file;					/* open file */
	Str		*line;					/* current input line, i.e. last returned */
	int		 line_nr;				/* current line number, i.e. last returned */

	StrList	*line_stack;			/* stack of input lines to read by getline()
									   before reading next line from the file.
									   Next line read is on the top of the stack */
END_CLASS;

/*-----------------------------------------------------------------------------
*	SourceFile API
*----------------------------------------------------------------------------*/

/* open the source file for reading, calls search_source_file() to search
   the source file path list */
extern void SourceFile_open( SourceFile *self, char *source_file );

/* get the next line of input, normalize end of line termination (i.e. convert
   "\r", "\r\n" and "\n\r" to "\n"
   Returns the pointer to the null-terminated text data in Str *line.
   Returns NULL on end of file, and closes the file */
extern char *SourceFile_getline( SourceFile *self );

/* push lines to the line_stack, to be read next - they need to be pushed 
   in reverse order, i.e. last pushed is next to be retrieved */
extern void SourceFile_ungetline( SourceFile *self, char *line );

/*-----------------------------------------------------------------------------
*	Singleton API - all methods work on one global list object
*	See description for corresponding method above
*----------------------------------------------------------------------------*/

#endif /* ndef SRCFILE_H */
