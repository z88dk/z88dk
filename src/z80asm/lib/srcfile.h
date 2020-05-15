/*
Z88DK Z80 Macro Assembler

Handle reading of source files, normalizing newline sequences, and allowing recursive
includes.
Allows pushing back of lines, for example to expand macros.
Call back interface to declare that a new line has been read.

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2020
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk
*/

#pragma once

#include "class.h"
#include "list.h"
#include "str.h"
#include "types.h"
#include "utarray.h"
#include <stdio.h>

/*-----------------------------------------------------------------------------
*   Call-back interace to declare a new line has been read, telling the
* 	file name and line number
*----------------------------------------------------------------------------*/
typedef void (*new_line_cb_t)(const char *filename, int line_nr, const char *text );

/* set call-back when reading a new line; return old call-back */
extern new_line_cb_t set_new_line_cb( new_line_cb_t func );

/*-----------------------------------------------------------------------------
*   Call-back interace to exit with error on recursive include files
*----------------------------------------------------------------------------*/
typedef void (*incl_recursion_err_cb_t)(const char *filename );

/* set call-back when reading a new line; return old call-back */
extern incl_recursion_err_cb_t set_incl_recursion_err_cb( incl_recursion_err_cb_t func );

/*-----------------------------------------------------------------------------
*   Class to hold current source file and stack of previous open files
*----------------------------------------------------------------------------*/
CLASS( SrcFile )
	FILE	*file;					/* open file */
	const char *filename;			/* source file name, held in strpool */
	const char *line_filename;		/* source file name of LINE statement, held in strpool */
	int		 line_nr;				/* current line number, i.e. last returned */
	int		 line_inc;				/* increment on each line read */
	Str		*line;					/* current input line, i.e. last returned */
	bool	is_c_source;			/* true if C_LINE was called */

	List	*line_stack;			/* stack of input lines to read by getline()
									   before reading next line from the file.
									   Next line read is on the top of the stack.
									   Lines are created by m_strdup(), 
									   removed by m_free() */
	List	*file_stack;			/* stack of files opened before this one,
									   to process recursive includes */
END_CLASS;

/*-----------------------------------------------------------------------------
*	SrcFile API
*----------------------------------------------------------------------------*/

/* Open the source file for reading, closing any previously open file.
   If dir_list is not NULL, calls path_search() to search the file in dir_list
   calls incl_recursion_err_cb pointed fucntion in case of recursive include */
extern bool SrcFile_open( SrcFile *self, const char *filename, UT_array *dir_list );

/* get the next line of input, normalize end of line termination (i.e. convert
   "\r", "\r\n" and "\n\r" to "\n"
   Calls the new_line_cb call back and returns the pointer to the null-terminated 
   text data in Str *line, including the final "\n".
   Returns NULL on end of file. */
extern char *SrcFile_getline( SrcFile *self );

/* push lines to the line_stack, to be read next - they need to be pushed
   in reverse order, i.e. last pushed is next to be retrieved
   line may contain multiple lines separated by '\n', they are split and
   pushed back-to-forth so that first text is first to retrieve from getline() */
extern void SrcFile_ungetline( SrcFile *self, const char *lines );

/* return the current file name and line number */
extern const char *SrcFile_filename( SrcFile *self );		/* string in strpool */
extern int         SrcFile_line_nr(SrcFile *self);
extern bool        ScrFile_is_c_source(SrcFile *self);


extern void SrcFile_set_filename(SrcFile *self, const char *filename);
extern void SrcFile_set_line_nr(SrcFile *self, int line_nr, int line_inc);
extern void SrcFile_set_c_source(SrcFile *self);

/* stack of input files manipulation:
   push saves current file on the stack and prepares for a new open
   pop returns false if the stack is empty; else retrieves last file from stack
   and updates current input */
extern void SrcFile_push( SrcFile *self );
extern bool SrcFile_pop( SrcFile *self );
