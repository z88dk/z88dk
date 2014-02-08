/*
Handle reading of source files, normalizing newline sequences, and allowing recursive
includes.
Allows pushing back of lines, for example to expand macros.
Call back interface to declare that a new line has been read.

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/srcfile.h,v 1.1 2014-02-08 11:21:09 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */

#include "class.h"
#include "list.h"
#include "strutil.h"
#include <stdio.h>

/*-----------------------------------------------------------------------------
*   Call-back interace to declare a new line has been read, telling the
* 	file name and line number
*----------------------------------------------------------------------------*/
typedef void (*new_line_cb_t)( char *filename, int line_nr );

/* set call-back when reading a new line; return old call-back */
extern new_line_cb_t set_new_line_cb( new_line_cb_t func );

/*-----------------------------------------------------------------------------
*   Call-back interace to exit with fatal error on recursive include files
*----------------------------------------------------------------------------*/
typedef void (*incl_recursion_err_cb_t)( char *filename );

/* set call-back when reading a new line; return old call-back */
extern incl_recursion_err_cb_t set_incl_recursion_err_cb( incl_recursion_err_cb_t func );

/*-----------------------------------------------------------------------------
*   Class to hold current source file and stack of previous open files
*----------------------------------------------------------------------------*/
CLASS( SrcFile )
	FILE	*file;					/* open file */
	char	*filename;				/* source file name, held in strpool */
	int		 line_nr;				/* current line number, i.e. last returned */
	Str		*line;					/* current input line, i.e. last returned */

	List	*line_stack;			/* stack of input lines to read by getline()
									   before reading next line from the file.
									   Next line read is on the top of the stack.
									   Lines are created by xstrdup(), 
									   removed by xfree() */
	List	*file_stack;			/* stack of files opened before this one,
									   to process recursive includes */
END_CLASS;

/*-----------------------------------------------------------------------------
*	SrcFile API
*----------------------------------------------------------------------------*/

/* Open the source file for reading, closing any previously open file.
   If dir_list is not NULL, calls search_file() to search the file in dir_list
   calls incl_recursion_err_cb pointed fucntion in case of recursive include */
extern void SrcFile_open( SrcFile *self, char *filename, List *dir_list );

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
extern void SrcFile_ungetline( SrcFile *self, char *lines );

/* stack of input files manipulation:
   push saves current file on the stack and prepares for a new open
   pop returns FALSE if the stack is empty; else retrieves last file from stack
   and updates current input */
extern void SrcFile_push( SrcFile *self );
extern BOOL SrcFile_pop( SrcFile *self );


/*
* $Log: srcfile.h,v $
* Revision 1.1  2014-02-08 11:21:09  pauloscustodio
* Moved srcfile.c to lib/
*
* Revision 1.9  2014/02/03 22:04:03  pauloscustodio
* ws
*
* Revision 1.8  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.7  2014/01/11 01:06:33  pauloscustodio
* -Wall comments
*
* Revision 1.6  2013/12/30 02:05:32  pauloscustodio
* Merge dynstr.c and safestr.c into lib/strutil.c; the new Str type
* handles both dynamically allocated strings and fixed-size strings.
* Replaced g_strchomp by chomp by; g_ascii_tolower by tolower;
* g_ascii_toupper by toupper; g_ascii_strcasecmp by stricompare.
*
* Revision 1.5  2013/12/26 23:42:27  pauloscustodio
* Replace StringList from strutil by StrList in new strlis.c, to keep lists of strings (e.g. directory search paths)
*
* Revision 1.4  2013/12/15 13:18:34  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.3  2013/10/05 10:54:36  pauloscustodio
* Parse command line options via look-up tables:
* -I, --inc-path
* -L, --lib-path
*
* Revision 1.2  2013/03/02 23:52:49  pauloscustodio
* Add API to handle a stack of open sorce files and singleton API
*
* Revision 1.1  2013/02/27 22:31:43  pauloscustodio
* New srcfile.c to handle reading lines from source files
*
*/
