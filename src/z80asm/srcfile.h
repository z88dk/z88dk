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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/srcfile.h,v 1.4 2013-12-15 13:18:34 pauloscustodio Exp $ */
/* $Log: srcfile.h,v $
/* Revision 1.4  2013-12-15 13:18:34  pauloscustodio
/* Move memory allocation routines to lib/xmalloc, instead of glib,
/* introduce memory leak report on exit and memory fence check.
/*
/* Revision 1.3  2013/10/05 10:54:36  pauloscustodio
/* Parse command line options via look-up tables:
/* -I, --inc-path
/* -L, --lib-path
/*
/* Revision 1.2  2013/03/02 23:52:49  pauloscustodio
/* Add API to handle a stack of open sorce files and singleton API
/*
/* Revision 1.1  2013/02/27 22:31:43  pauloscustodio
/* New srcfile.c to handle reading lines from source files
/*
/*
/*
/* */

#ifndef SRCFILE_H
#define SRCFILE_H

#include "xmalloc.h"   /* before any other include */

#include "class.h"
#include "classlist.h"
#include "dynstr.h"
#include "types.h"

/*-----------------------------------------------------------------------------
*   Class to hold stack of input lines to read next
*----------------------------------------------------------------------------*/
CLASS_LIST( Str );

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

/* open the source file for reading, calls search_file() to search
   the source file path list */
extern void SourceFile_open( SourceFile *self, char *source_file );

/* get the next line of input, normalize end of line termination (i.e. convert
   "\r", "\r\n" and "\n\r" to "\n"
   Returns the pointer to the null-terminated text data in Str *line.
   Returns NULL on end of file, and closes the file */
extern char *SourceFile_getline( SourceFile *self );

/* push lines to the line_stack, to be read next - they need to be pushed 
   in reverse order, i.e. last pushed is next to be retrieved 
   line may contain multiple lines separated by '\n', they are split and
   pushed back-to-forth so that first text is first to retrieve from getline() */
extern void SourceFile_ungetline( SourceFile *self, char *line );


/*-----------------------------------------------------------------------------
*   Class to hold stack of input files, current is on top
*----------------------------------------------------------------------------*/
CLASS_LIST( SourceFile );


/*-----------------------------------------------------------------------------
*	SourceFileList API - same as SourceFile, but keep all open files in a
*	stack, manipulate the top element
*----------------------------------------------------------------------------*/
/* open a new file pushing it to top of stack
   abort with error if same file already open below in stack,
   to avoid infinite include recursion */
extern void  SourceFileList_open( SourceFileList *self, char *source_file );
extern char *SourceFileList_getline( SourceFileList *self );
extern void  SourceFileList_ungetline( SourceFileList *self, char *line );

/* get current file, line and line number */
extern char *SourceFileList_filename( SourceFileList *self );
extern char *SourceFileList_line( SourceFileList *self );
extern int   SourceFileList_line_nr( SourceFileList *self );


/*-----------------------------------------------------------------------------
*	Singleton API - all methods work on one global list object
*	See description for corresponding method above
*----------------------------------------------------------------------------*/
extern void  source_open( char *source_file );
extern char *source_getline( void );
extern void  source_ungetline( char *line );
extern char *source_filename( void );
extern char *source_line( void );
extern int   source_line_nr( void );


#endif /* ndef SRCFILE_H */
