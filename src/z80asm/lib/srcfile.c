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

#include "../errors.h"
#include "alloc.h"
#include "die.h"
#include "fileutil.h"
#include "srcfile.h"
#include "strutil.h"
#include "utstring.h"

/*-----------------------------------------------------------------------------
*   Type stored in file_stack
*----------------------------------------------------------------------------*/
typedef struct FileStackElem
{
	FILE	*file;					/* open file */
	const char *filename;				/* source file name, held in strpool */
	const char *line_filename;			/* source file name of LINE statement, held in strpool */
	int		 line_nr;				/* current line number, i.e. last returned */
	int		 line_inc;				/* increment on each line read */
	bool	 is_c_source;			/* true if C_LINE was called */
} FileStackElem;

static void free_file_stack_elem( void *_elem )
{
	FileStackElem *elem = _elem;
	
	if ( elem->file != NULL )
		xfclose( elem->file );
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
static void call_new_line_cb(const char *filename, int line_nr, const char *text )
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
	self->filename = NULL;
	self->line_filename = NULL;

	self->line = Str_new(STR_SIZE);

    self->line_stack = OBJ_NEW( List );
    OBJ_AUTODELETE( self->line_stack ) = false;
	self->line_stack->free_data = m_free_compat;

    self->file_stack = OBJ_NEW( List );
    OBJ_AUTODELETE( self->file_stack ) = false;
	self->file_stack->free_data = free_file_stack_elem;
}

void SrcFile_copy( SrcFile *self, SrcFile *other )
{
    xassert(0);
}

void SrcFile_fini( SrcFile *self )
{
    if ( self->file != NULL )
        xfclose( self->file );

	Str_delete(self->line);
    OBJ_DELETE( self->line_stack );
    OBJ_DELETE( self->file_stack );
}

/*-----------------------------------------------------------------------------
*	SrcFile API
*----------------------------------------------------------------------------*/

/* check for recursive includes, call error callback and return false abort if found
   returns true if callback not defined */
static bool check_recursive_include( SrcFile *self, const char *filename )
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
				return false;
			}
		}
	}
	return true;
}

/* Open the source file for reading, closing any previously open file.
   If dir_list is not NULL, calls path_search() to search the file in dir_list */
bool SrcFile_open( SrcFile *self, const char *filename, UT_array *dir_list )
{
	/* close last file */
	if (self->file != NULL)
	{
		xfclose(self->file);
		self->file = NULL;
	}

	/* search path, add to strpool */
	const char *filename_path = path_search(filename, dir_list);

	/* check for recursive includes, return if found */
	if (!check_recursive_include(self, filename_path))
		return false;
	
	self->filename = filename_path;
	self->line_filename = filename_path;

    /* open new file in binary mode, for cross-platform newline processing */
    self->file = fopen( self->filename, "rb" );
	if (!self->file)
		error_read_file(self->filename);

	/* init current line */
    Str_clear( self->line );
    self->line_nr = 0;
	self->line_inc = 1;
	self->is_c_source = false;

	if (self->file)
		return true;
	else
		return false;		/* error opening file */
}

/* get the next line of input, normalize end of line termination (i.e. convert
   "\r", "\r\n" and "\n\r" to "\n"
   Calls the new_line_cb call back and returns the pointer to the null-terminated 
   text data in Str *line, including the final "\n".
   Returns NULL on end of file. */
char *SrcFile_getline( SrcFile *self )
{
    int c, c1;
    bool found_newline;
    char *line;

    /* clear result string */
    Str_clear( self->line );

    /* check for line stack */
    if ( ! List_empty( self->line_stack ) )
    {
        line = List_pop( self->line_stack );

        /* we own the string now and need to release memory */
		Str_set( self->line, line );
        m_free( line );

        /* dont increment line number as we are still on same file input line */
        return Str_data(self->line);
    }

    /* check for EOF condition */
    if ( self->file == NULL )
        return NULL;

    /* read characters */
    found_newline = false;
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
            found_newline = true;
            c = '\n';

        default:
            Str_append_char( self->line, c );
        }
    }

    /* terminate string if needed */
    if ( Str_len(self->line) > 0 && ! found_newline )
        Str_append_char( self->line, '\n' );

	/* signal new line, even empty one, to show end line in list */
    self->line_nr += self->line_inc;
	call_new_line_cb( self->line_filename, self->line_nr, Str_data(self->line) );

	/* check for end of file
	   even if EOF found, we need to return any chars in line first */
    if ( Str_len(self->line) > 0 )		
    {
        return Str_data(self->line);
    }
    else
    {
        /* EOF - close file */
        xfclose( self->file );				/* close input */
        self->file = NULL;

//		call_new_line_cb( NULL, 0, NULL );
        return NULL;						/* EOF */
    }
}

/* Search for the start of the next line in string, i.e. char after '\n' except last
   Return NULL if only one line */
static const char *search_next_line(const char *lines )
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
void SrcFile_ungetline( SrcFile *self, const char *lines )
{
	char *line;
	size_t len;

	/* search next line after first '\n' */
	const char *next_line = search_next_line( lines );

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
const char *SrcFile_filename( SrcFile *self ) { return self->line_filename; }
int         SrcFile_line_nr(  SrcFile *self ) { return self->line_nr; }

bool ScrFile_is_c_source(SrcFile * self)
{
	return self->is_c_source;
}

void SrcFile_set_filename(SrcFile * self, const char * filename)
{
	self->line_filename = spool_add(filename);
}

void SrcFile_set_line_nr(SrcFile * self, int line_nr, int line_inc)
{
	self->line_nr = line_nr - line_inc;
	self->line_inc = line_inc;
}

void SrcFile_set_c_source(SrcFile * self)
{
	self->is_c_source = true;
}

/* stack of input files manipulation:
   push saves current file on the stack and prepares for a new open
   pop returns false if the stack is empty; else retrieves last file from stack
   and updates current input */
void SrcFile_push( SrcFile *self )
{
	FileStackElem *elem = m_new( FileStackElem );
	
	elem->file		= self->file;
	elem->filename = self->filename;
	elem->line_filename = self->line_filename;
	elem->line_nr   = self->line_nr;
	elem->line_inc = self->line_inc;
	elem->is_c_source = self->is_c_source;

	List_push( & self->file_stack, elem );
	
	self->file		= NULL;
	/* keep previous file name and location so that errors detected during
	*  macro expansion are shown on the correct line
	*	self->filename	= NULL;
	*	self->line_nr 	= 0;
	*/
}

bool SrcFile_pop( SrcFile *self )
{
	FileStackElem *elem;
	
	if ( List_empty( self->file_stack ) )
		return false;
		
	if ( self->file != NULL )
		xfclose( self->file );
		
	elem = List_pop( self->file_stack );
	self->file		= elem->file;
	self->filename = elem->filename;
	self->line_filename = elem->line_filename;
	self->line_nr   = elem->line_nr;
	self->line_inc = elem->line_inc;
	self->is_c_source = elem->is_c_source;

	m_free( elem );
	return true;
}
