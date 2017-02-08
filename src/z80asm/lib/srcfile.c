/*
Z88DK Z80 Macro Assembler

Handle reading of source files, normalizing newline sequences, and allowing recursive
includes.
Allows pushing back of lines, for example to expand macros.
Call back interface to declare that a new line has been read.

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#include "alloc.h"
#include "srcfile.h"
#include "fileutil.h"
#include "strpool.h"
#include <assert.h>

/*-----------------------------------------------------------------------------
*   Type stored in file_stack
*----------------------------------------------------------------------------*/
typedef struct FileStackElem
{
	FILE	*file;					/* open file */
	char	*filename;				/* source file name, held in strpool */
	int		 line_nr;				/* current line number, i.e. last returned */
} FileStackElem;

static void free_file_stack_elem( void *_elem )
{
	FileStackElem *elem = _elem;
	
	if ( elem->file != NULL )
		myfclose( elem->file );
	m_free( elem );
}

/*-----------------------------------------------------------------------------
*   Call-back interace to declare a new line has been read, telling the
* 	file name and line number
*----------------------------------------------------------------------------*/
static new_line_cb_t new_line_cb = NULL;		/* default handler */

/* set call-back for input/output error; return old call-back */
new_line_cb_t set_new_line_cb( new_line_cb_t func )
{
	new_line_cb_t old = new_line_cb;
	new_line_cb = func;
	return old;
}

/* call callback */
static void call_new_line_cb( char *filename, int line_nr, char *text )
{
	if ( new_line_cb != NULL )
		new_line_cb( filename, line_nr, text );
}

/*-----------------------------------------------------------------------------
*   Call-back interace to show error on recursive include files
*----------------------------------------------------------------------------*/
static incl_recursion_err_cb_t incl_recursion_err_cb = NULL;		/* default handler */

/* set call-back for input/output error; return old call-back */
incl_recursion_err_cb_t set_incl_recursion_err_cb( incl_recursion_err_cb_t func )
{
	incl_recursion_err_cb_t old = incl_recursion_err_cb;
	incl_recursion_err_cb = func;
	return old;
}

/*-----------------------------------------------------------------------------
*   Class to hold current source file
*----------------------------------------------------------------------------*/
DEF_CLASS( SrcFile );

void SrcFile_init( SrcFile *self )
{
	strpool_init();
	
    self->filename   = NULL;

	self->line = str_new(STR_SIZE);

    self->line_stack = OBJ_NEW( List );
    OBJ_AUTODELETE( self->line_stack ) = FALSE;
	self->line_stack->free_data = m_free_compat;

    self->file_stack = OBJ_NEW( List );
    OBJ_AUTODELETE( self->file_stack ) = FALSE;
	self->file_stack->free_data = free_file_stack_elem;
}

void SrcFile_copy( SrcFile *self, SrcFile *other )
{
    assert(0);
}

void SrcFile_fini( SrcFile *self )
{
    if ( self->file != NULL )
        myfclose( self->file );

	str_delete(self->line);
    OBJ_DELETE( self->line_stack );
    OBJ_DELETE( self->file_stack );
}

/*-----------------------------------------------------------------------------
*	SrcFile API
*----------------------------------------------------------------------------*/

/* check for recursive includes, call error callback and return FALSE abort if found
   returns TRUE if callback not defined */
static Bool check_recursive_include( SrcFile *self, char *filename )
{
	ListElem *iter;
    FileStackElem *elem;
	
	if ( incl_recursion_err_cb != NULL )
	{
		for ( iter = List_first( self->file_stack ) ; iter != NULL ;
			iter = List_next( iter ) )
		{
			elem = iter->data;
			if ( elem->filename != NULL &&
				 strcmp( filename, elem->filename ) == 0 )
			{
				incl_recursion_err_cb( filename );
				return FALSE;
			}
		}
	}
	return TRUE;
}

/* Open the source file for reading, closing any previously open file.
   If dir_list is not NULL, calls search_file() to search the file in dir_list */
Bool SrcFile_open( SrcFile *self, char *filename, UT_array *dir_list )
{
    char *filename_path;
	
	/* close last file */
	if (self->file != NULL)
	{
		myfclose(self->file);
		self->file = NULL;
	}

	/* search path, add to strpool */
	filename_path = search_file(filename, dir_list);

	/* check for recursive includes, return if found */
	if (!check_recursive_include(self, filename_path))
		return FALSE;
	
	self->filename = filename_path;

    /* open new file in binary mode, for cross-platform newline processing */
    self->file = myfopen( self->filename, "rb" );

	/* init current line */
    str_clear( self->line );
    self->line_nr = 0;

	if (self->file)
		return TRUE;
	else
		return FALSE;		/* error opening file */
}

/* get the next line of input, normalize end of line termination (i.e. convert
   "\r", "\r\n" and "\n\r" to "\n"
   Calls the new_line_cb call back and returns the pointer to the null-terminated 
   text data in Str *line, including the final "\n".
   Returns NULL on end of file. */
char *SrcFile_getline( SrcFile *self )
{
    int c, c1;
    Bool found_newline;
    char *line;

    /* clear result string */
    str_clear( self->line );

    /* check for line stack */
    if ( ! List_empty( self->line_stack ) )
    {
        line = List_pop( self->line_stack );

        /* we own the string now and need to release memory */
		str_set( self->line, line );
        m_free( line );

        /* dont increment line number as we are still on same file input line */
        return str_data(self->line);
    }

    /* check for EOF condition */
    if ( self->file == NULL )
        return NULL;

    /* read characters */
    found_newline = FALSE;
    while ( ! found_newline && ( c = getc( self->file ) ) != EOF )
    {
        switch ( c )
        {
        case '\r':
        case '\n':
            c1 = getc( self->file );

            if ( ( c1 == '\r' || c1 == '\n' ) &&	/* next char also newline */
                    c1 != c )						/* "\r\n" or "\n\r" */
            {
                /* c1 will be discarded */
            }
            else								/* not composite newline - push back */
            {
                if ( c1 != EOF )
                {
                    ungetc( c1, self->file );	/* push back except EOF */
                }
            }

            /* normalize newline and fall through to default */
            found_newline = TRUE;
            c = '\n';

        default:
            str_append_char( self->line, c );
        }
    }

    /* terminate string if needed */
    if ( str_len(self->line) > 0 && ! found_newline )
        str_append_char( self->line, '\n' );

	/* signal new line, even empty one, to show end line in list */
    self->line_nr++;
	call_new_line_cb( self->filename, self->line_nr, str_data(self->line) );

	/* check for end of file
	   even if EOF found, we need to return any chars in line first */
    if ( str_len(self->line) > 0 )		
    {
        return str_data(self->line);
    }
    else
    {
        /* EOF - close file */
        myfclose( self->file );				/* close input */
        self->file = NULL;

//		call_new_line_cb( NULL, 0, NULL );
        return NULL;						/* EOF */
    }
}

/* Search for the start of the next line in string, i.e. char after '\n' except last
   Return NULL if only one line */
static char *search_next_line( char *lines )
{
    char *nl_ptr;

    nl_ptr = strchr( lines, '\n' );

    if ( nl_ptr == NULL || nl_ptr[1] == '\0' )
        return NULL;				/* only one line */
    else
        return nl_ptr + 1;			/* char after newline */
}

/* push lines to the line_stack, to be read next - they need to be pushed
   in reverse order, i.e. last pushed is next to be retrieved
   line may contain multiple lines separated by '\n', they are split and
   pushed back-to-forth so that first text is first to retrieve from getline() */
void SrcFile_ungetline( SrcFile *self, char *lines )
{
	char *next_line, *line;
	size_t len;

	/* search next line after first '\n' */
	next_line = search_next_line( lines );

	/* recurse to push this line at the end */
	if ( next_line )
		SrcFile_ungetline( self, next_line );

	/* now push this line, add a newline if missing */
	len = next_line ? next_line - lines : strlen( lines );

	if ( len > 0 && lines[ len - 1 ] == '\n' )
		len--;							/* ignore newline */

	line = m_malloc( len + 2 );			/* 2 bytes extra for '\n' and '\0' */
	strncpy( line, lines, len );
	line[ len     ] = '\n';
	line[ len + 1 ] = '\0';

	List_push( & self->line_stack, line );
}

/* return the current file name and line number */
char *SrcFile_filename( SrcFile *self ) { return self->filename; }
int   SrcFile_line_nr(  SrcFile *self ) { return self->line_nr; }


/* stack of input files manipulation:
   push saves current file on the stack and prepares for a new open
   pop returns FALSE if the stack is empty; else retrieves last file from stack
   and updates current input */
void SrcFile_push( SrcFile *self )
{
	FileStackElem *elem = m_new( FileStackElem );
	
	elem->file		= self->file;
	elem->filename	= self->filename;
	elem->line_nr	= self->line_nr;
	
	List_push( & self->file_stack, elem );
	
	self->file		= NULL;
	/* keep previous file name and location so that errors detected during
	*  macro expansion are shown on the correct line
	*	self->filename	= NULL;
	*	self->line_nr 	= 0;
	*/
}

Bool SrcFile_pop( SrcFile *self )
{
	FileStackElem *elem;
	
	if ( List_empty( self->file_stack ) )
		return FALSE;
		
	if ( self->file != NULL )
		myfclose( self->file );
		
	elem = List_pop( self->file_stack );
	self->file		= elem->file;
	self->filename	= elem->filename;
	self->line_nr	= elem->line_nr;
	
	m_free( elem );
	return TRUE;
}
