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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/srcfile.c,v 1.14 2013-12-26 23:42:27 pauloscustodio Exp $ */
/* $Log: srcfile.c,v $
/* Revision 1.14  2013-12-26 23:42:27  pauloscustodio
/* Replace StringList from strutil by StrList in new strlis.c, to keep lists of strings (e.g. directory search paths)
/*
/* Revision 1.13  2013/12/15 13:18:34  pauloscustodio
/* Move memory allocation routines to lib/xmalloc, instead of glib,
/* introduce memory leak report on exit and memory fence check.
/*
/* Revision 1.12  2013/10/05 10:54:36  pauloscustodio
/* Parse command line options via look-up tables:
/* -I, --inc-path
/* -L, --lib-path
/*
/* Revision 1.11  2013/10/05 08:14:43  pauloscustodio
/* Parse command line options via look-up tables:
/* -C, --line-mode
/*
/* Revision 1.10  2013/10/01 23:23:53  pauloscustodio
/* Parse command line options via look-up tables:
/* -l, --list
/* -nl, --no-list
/*
/* Revision 1.9  2013/09/23 23:14:10  pauloscustodio
/* Renamed SzList to StringList, simplified interface by assuming that
/* list lives in memory util program ends; it is used for directory searches
/* only. Moved interface to strutil.c, removed strlist.c.
/*
/* Revision 1.8  2013/09/22 21:34:48  pauloscustodio
/* Remove legacy xxx_err() interface
/*
/* Revision 1.7  2013/09/12 00:10:02  pauloscustodio
/* Create xfree() macro that NULLs the pointer after free, required
/* by z80asm to find out if a pointer was already freed.
/*
/* Revision 1.6  2013/09/08 08:29:21  pauloscustodio
/* Replaced xmalloc et al with glib functions
/*
/* Revision 1.5  2013/09/08 00:43:59  pauloscustodio
/* New error module with one error function per error, no need for the error
/* constants. Allows compiler to type-check error message arguments.
/* Included the errors module in the init() mechanism, no need to call
/* error initialization from main(). Moved all error-testing scripts to
/* one file errors.t.
/*
/* Revision 1.4  2013/09/01 18:46:01  pauloscustodio
/* Remove call to strpool_init(). String pool is initialized in init.c before main() starts.
/*
/* Revision 1.3  2013/03/10 18:00:24  pauloscustodio
/* Interface with errors (set input position for errors) and  listfile (start list of each input line)
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

#include "xmalloc.h"   /* before any other include */

#include "codearea.h"
#include "errors.h"
#include "file.h"
#include "listfile.h"
#include "options.h"
#include "srcfile.h"
#include "strutil.h"
#include "strpool.h"
#include <stdio.h>
#include <string.h>

#if 0
/*-----------------------------------------------------------------------------
*   Class to hold stack of input lines to read next
*----------------------------------------------------------------------------*/
DEF_CLASS_LIST( Str );

/*-----------------------------------------------------------------------------
*   Class to hold current source file
*----------------------------------------------------------------------------*/
DEF_CLASS( SourceFile );

void SourceFile_init( SourceFile *self )
{
	self->filename   = "";
	self->line       = OBJ_NEW( Str );		
	OBJ_AUTODELETE( self->line ) = FALSE;

	self->line_stack = OBJ_NEW( StrList );
	OBJ_AUTODELETE( self->line_stack ) = FALSE;
}

void SourceFile_copy( SourceFile *self, SourceFile *other )
{
	/* cannot copy open file */
	self->filename   = "";
	self->file       = NULL;
	self->line       = NULL;
	self->line_nr    = 0;
	self->line_stack = NULL;
}

void SourceFile_fini( SourceFile *self )
{
	if ( self->file != NULL )
	{
		fclose( self->file );
	}

	OBJ_DELETE( self->line );
	OBJ_DELETE( self->line_stack );
}

/*-----------------------------------------------------------------------------
*	SourceFile API
*----------------------------------------------------------------------------*/

/* open the source file for reading, calls search_file() to search
   the source file path list */
void SourceFile_open( SourceFile *self, char *source_file )
{
	/* close last file */
	if ( self->file != NULL )
	{
		fclose( self->file );
		self->file = NULL;
	}

	/* init state */
	self->filename = search_file( source_file, opts.inc_path );

	/* open new file in binary mode, for cross-platform newline processing */
	self->file = xfopen( self->filename, "rb" );

	Str_clear( self->line );
	self->line_nr = 0;
}


/* get the next line of input, normalize end of line termination (i.e. convert
   "\r", "\r\n" and "\n\r" to "\n"
   Returns the pointer to the null-terminated text data in Str *line.
   Returns NULL on end of file, and closes the file */
char *SourceFile_getline( SourceFile *self ) 
{
	int c, c1;
	BOOL found_newline;
	Str *str;

	/* clear result string */
	Str_clear( self->line );

	/* check for line stack */
	if ( ! StrList_empty( self->line_stack ) )
	{
		str = StrList_pop( self->line_stack );
		/* we own the string now and need to release memory */

		Str_set( self->line, str );
		OBJ_DELETE( str );

		/* dont increment line number as we are still on same file input line */
		return Str_data( self->line );
	}

	/* check for EOF condition */
	if ( self->file == NULL )
	{
		return NULL;						/* EOF */
	}

	/* read characters */
	found_newline = FALSE;
	while ( ! found_newline && (c = getc( self->file )) != EOF )
	{
		switch (c)
		{
		case '\r':
		case '\n':
			c1 = getc( self->file );
			if ( (c1 == '\r' || c1 == '\n') &&	/* next char also newline */
				 c1 != c )						/* "\r\n" or "\n\r" */
			{
				/* c1 will be discarded */
			}
			else								/* not composite newline - push back */
			{
				if (c1 != EOF)
				{
					ungetc( c1, self->file );	/* push back except EOF */
				}
			}
			
			/* normalize newline and fall through to default */
			found_newline = TRUE;
			c = '\n';

		default:
			Str_chcat( self->line, c );
		}
	}

	/* terminate string if needed */
	if ( Str_len( self->line ) > 0 && ! found_newline )
	{
		Str_szcat( self->line, "\n" );
	}

	/* check for end of file */
	if ( Str_len( self->line ) > 0 )		/* even if EOF found, we need to return any chars in line first */
	{
		self->line_nr++;

		/* interface with error - set error location */
		if ( !opts.line_mode )
		{
			set_error_file( self->filename );   /* error location */
			set_error_line( self->line_nr ); 
		}

		/* interface with list */
		if ( opts.cur_list )
		{
			list_start_line( get_PC(), self->filename, self->line_nr, Str_data( self->line ) );
		}

		return Str_data( self->line );
	}
	else 
	{
		/* interface with error - set error location */
		if ( !opts.line_mode )
		{
			set_error_null();				/* clear error location */
		}

		self->line_nr = 0;					/* no more input */
		fclose( self->file );				/* close input */
		self->file = NULL;

		return NULL;						/* EOF */
	}
}


/* push lines to the line_stack, to be read next - they need to be pushed 
   in reverse order, i.e. last pushed is next to be retrieved 
   line may contain multiple lines separated by '\n', they are split and
   pushed back-to-forth so that first text is first to retrieve from getline() */
static char *search_next_line( char *line )
{
	char *nl_ptr;

	nl_ptr = strchr( line, '\n' );
	if ( nl_ptr == NULL || nl_ptr[1] == '\0' )
	{
		return NULL;				/* only one line */
	}
	else 
	{
		return nl_ptr+1;			/* char after newline */
	}
}

static void do_ungetline( SourceFile *self, char *line )
{
	Str *str;
	char *next_line;

	/* we can modify line */
	next_line = search_next_line( line );
	if ( next_line != NULL )
	{
		/* recurse to push first all the following lines */
		do_ungetline( self, next_line );
		next_line[0] = '\0';
	}

	/* now there is no next line - push to stack and finish */
	str = OBJ_NEW( Str );
	Str_szset( str, line );
	Str_unreserve( str );					/* reclaim unused space in line */
	StrList_push( self->line_stack, str );	/* put on stack, stack will release memory */
}

void SourceFile_ungetline( SourceFile *self, char *line )
{
	char *line_cpy;

	/* is there a next line in input? */
	if ( search_next_line( line ) != NULL )
	{
		line_cpy = xstrdup( line );		/* so that we can modify line */
		do_ungetline( self, line_cpy );
		xfree( line_cpy );
	}
	else 
	{
		do_ungetline( self, line );
	}
}


/*-----------------------------------------------------------------------------
*	SourceFileList API - same as SourceFile, but keep all open files in a
*	stack, manipulate the top element
*----------------------------------------------------------------------------*/
DEF_CLASS_LIST( SourceFile );

/* open a new file pushing it to top of stack
   abort with error if same file already open below in stack,
   to avoid infinite include recursion */
void SourceFileList_open( SourceFileList *self, char *source_file )
{
	SourceFile *file;
	char *filename;
	SourceFileListElem *iter;

	/* search stack */
	filename = search_file( source_file, opts.inc_path );
	for ( iter = SourceFileList_first( self ) ; iter != NULL ; 
		  iter = SourceFileList_next( iter ) )
	{
		if ( strcmp( filename, iter->obj->filename ) == 0 )
		{
            fatal_include_recursion( filename );
            return;
		}
	}

	/* create a new SourceFile object and open the file */
	file = OBJ_NEW( SourceFile );
	SourceFile_open( file, filename );

	/* save at top of stack */
	SourceFileList_push( self, file );
}


char *SourceFileList_getline( SourceFileList *self )
{
	SourceFile *file;
	char *line;

	/* get line from top file, drop it if EOF */
	while ( ! SourceFileList_empty( self ) ) 
	{
		file = SourceFileList_last( self )->obj;
		
		line = SourceFile_getline( file );
		if ( line != NULL )
		{
			return line;		/* next line */
		}

		/* drop top file */
		file = SourceFileList_pop( self );
		OBJ_DELETE( file );
	}

	return NULL;				/* no more input */
}


void SourceFileList_ungetline( SourceFileList *self, char *line )
{
	SourceFile *file;

	/* if there is no open file, create a dummy one to receive the lines */
	if ( SourceFileList_empty( self ) )
	{
		file = OBJ_NEW( SourceFile );
		SourceFileList_push( self, file );
	}

	/* unget to file on top of stack */
	file = SourceFileList_last( self )->obj;
	SourceFile_ungetline( file, line );
}


/* get current file, line and line number */
char *SourceFileList_filename( SourceFileList *self )
{
	return SourceFileList_empty( self ) ? "" : 
				SourceFileList_last( self )->obj->filename;
}

char *SourceFileList_line( SourceFileList *self )
{
	return SourceFileList_empty( self ) ? "" : 
				Str_data( SourceFileList_last( self )->obj->line );
}

int SourceFileList_line_nr( SourceFileList *self )
{
	return SourceFileList_empty( self ) ? 0 : 
				SourceFileList_last( self )->obj->line_nr;
}


/*-----------------------------------------------------------------------------
*	Singleton API - all methods work on one global list object
*	See description for corresponding method above
*----------------------------------------------------------------------------*/
static SourceFileList *the_source ( void )
{
	static SourceFileList *source = NULL;
	if ( source == NULL )
	{
		source = OBJ_NEW( SourceFileList );
	}
	return source;
}

void source_open( char *source_file )
{
	SourceFileList_open( the_source(), source_file );
}

char *source_getline( void )
{
	return SourceFileList_getline( the_source() );
}

void source_ungetline( char *line )
{
	SourceFileList_ungetline( the_source(), line );
}

char *source_filename( void )
{
	return SourceFileList_filename( the_source() );
}

char *source_line( void )
{
	return SourceFileList_line( the_source() );
}

int source_line_nr( void )
{
	return SourceFileList_line_nr( the_source() );
}

#endif
