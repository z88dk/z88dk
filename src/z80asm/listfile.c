/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2015
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

Handle assembly listing and symbol table listing.
*/

#include "listfile.h"
#include "fileutil.h"
#include "options.h"
#include "z80asm.h"
#include "errors.h"
#include "hist.h"
#include "strpool.h"
#include "types.h"
#include "codearea.h"

#include <stdio.h>
#include <time.h>

/*-----------------------------------------------------------------------------
*   Static variables
*----------------------------------------------------------------------------*/
static int header_size = 0;
static int newline_size = 0;
static time_t list_time;		/* time   of assembly in seconds */
static char *list_date;			/* pointer to datestring calculated from list_time */

/*-----------------------------------------------------------------------------
*   Global state variables
*----------------------------------------------------------------------------*/
static ListFile *the_list = NULL;

/*-----------------------------------------------------------------------------
*   Class to hold current list file
*----------------------------------------------------------------------------*/
DEF_CLASS( ListFile );

/*-----------------------------------------------------------------------------
*	Class helper methods
*----------------------------------------------------------------------------*/
void ListFile_init( ListFile *self )
{
	self->bytes = str_new(STR_SIZE);
	self->line = str_new(STR_SIZE);
}

void ListFile_copy( ListFile *self, ListFile *other )
{
    /* cannot copy object because of external resources held - open file */
    self->filename		= NULL;
    self->file			= NULL;
    self->bytes			= NULL;
    self->source_file	= NULL;
    self->line			= NULL;
}

void ListFile_fini( ListFile *self )
{
    /* delete file if object is garbage-collected - unexpected exit */
    ListFile_close( self, FALSE );

	str_delete(self->bytes);
	str_delete(self->line);
}

/*-----------------------------------------------------------------------------
*	output one line to the list file
*----------------------------------------------------------------------------*/
static void ListFile_write_header( ListFile *self );
static void ListFile_fprintf( ListFile *self, char *msg, ... )
{
	STR_DEFINE(str, STR_SIZE);
    va_list argptr;
    char *p;

    if ( self->file != NULL )
    {
	    va_start( argptr, msg );				/* BUG_0046 */
        str_vsprintf( str, msg, argptr );		/* ignore ret, as we dont retry */
		va_end( argptr );

        /* output to list file, advance line if newline, insert header on new page */
        for ( p = str_data(str) ; *p ; p++ )
        {
            fputc( *p, self->file );

            if ( *p == '\n' )
            {
                self->line_nr++;

                if ( self->line_nr >= PAGE_LEN )
                {
                    fprintf( self->file, "\f\n" );    /* send FORM FEED to file */
                    ListFile_write_header( self );
                }
            }
        }
    }

	STR_DELETE(str);
}

/*-----------------------------------------------------------------------------
*	Draw the page header
*----------------------------------------------------------------------------*/
static void ListFile_write_header( ListFile *self )
{
    long	fpos1 = 0, fpos2 = 0, fpos3 = 0;

    if ( self->file != NULL )
    {
        /* new page */
        self->page_nr++;
        self->line_nr = 0;

        /* compute header size and newline size on first call */
        if ( header_size == 0 )
        {
            fpos1 = ftell( self->file );		/* before header */
        }

#ifdef QDOS
        ListFile_fprintf( self, "%s %s, %s", _prog_name, _version, _copyright );
        ListFile_fprintf( self, "%*.*s", PAGE_WIDTH - strlen( _prog_name ) - strlen( _version ) - strlen( _copyright ) - 3,
                          strlen( list_date ), list_date );		/* list_date ends with newline */
#else
        ListFile_fprintf( self, "%s%*s%s",
                          copyrightmsg,
                          PAGE_WIDTH - strlen( copyrightmsg ) - strlen( list_date ) + 1,		/* dont count \n */
                          "",
                          list_date );														/* list_date ends with newline */
#endif
        ListFile_fprintf( self, "Page %03d%*s'%s'\n\n",
                          self->page_nr,
                          PAGE_WIDTH - 8 - 2 - strlen( self->filename ),
                          "",
                          self->filename );

        /* compute header size and newline size on first call */
        if ( header_size == 0 )
        {
            fpos2 = ftell( self->file );		/* before last newline */
        }

        fputc( '\n', self->file );

        /* compute header size and newline size on first call */
        if ( header_size == 0 )
        {
            fpos3 = ftell( self->file );		/* after header */

            newline_size = ( int )( fpos3 - fpos2 );

            /* header between pages has "\f\n" more */
            header_size  = ( int )( fpos3 - fpos1 ) + 1 + newline_size;
        }
    }
}

/*-----------------------------------------------------------------------------
*	Initialize the page
*----------------------------------------------------------------------------*/
static void ListFile_init_page( ListFile *self )
{
    if ( self->file != NULL )
    {
        self->page_nr = 0;
        ListFile_write_header( self );			/* Begin list file with a header */
        self->start_line_pos = ftell( self->file );	/* Get file pos. of next line in list file */
    }
}

/*-----------------------------------------------------------------------------
*	open the list file
*----------------------------------------------------------------------------*/
void ListFile_open( ListFile *self, char *list_file )
{
    /* close and discard any open list file */
    ListFile_close( self, FALSE );

    /* compute time for header */
    time( &list_time );
    list_date = asctime( localtime( &list_time ) ); /* get current system time for date in list file */

    /* open the file */
    self->filename	= strpool_add( list_file );
    self->file		= myfopen( list_file, "w+" );
    self->source_list_ended = FALSE;

    /* output header */
    ListFile_init_page( self );
}

void list_open( char *list_file )
{
    if ( the_list == NULL )
    {
        the_list = OBJ_NEW( ListFile );
    }

    ListFile_open( the_list, list_file );
}

/*-----------------------------------------------------------------------------
*	close the list file
*----------------------------------------------------------------------------*/
void ListFile_close( ListFile *self, Bool keep_file )
{
    if ( self->file != NULL )
    {
        /* close any pending line started */
        ListFile_end( self );

        fputc( '\f', self->file );     /* end listing with a FF */
        myfclose( self->file );

        if ( ! keep_file )
            remove( self->filename );
    }

    self->file = NULL;
}

void list_close( Bool keep_file )
{
    if ( the_list != NULL )
    {
        ListFile_close( the_list, keep_file );
    }
}

/*-----------------------------------------------------------------------------
*	start output of list line
*----------------------------------------------------------------------------*/
void ListFile_start_line( ListFile *self, int address,
                          char *source_file, int source_line_nr, char *line )
{
    if ( self->file != NULL && ! self->source_list_ended )
    {
        /* close any pending line */
        ListFile_end_line( self );

        self->line_started = TRUE;			/* signal: in line */

        /* Get file position for beginning of next line in list file */
        self->start_line_pos = ftell( self->file );

        /* init all line-related variables */
        self->address = address;
        str_clear( self->bytes );

        self->source_file = strpool_add( source_file );
        self->source_line_nr = source_line_nr;

        /* normalize the line end (BUG_0031) */
        str_set( self->line, line );
        str_chomp( self->line );
        str_append_char( self->line, '\n' );
    }
}

void list_start_line( int address,
                      char *source_file, int source_line_nr, char *line )
{
    if ( the_list != NULL )
    {
        ListFile_start_line( the_list, address,
                             source_file, source_line_nr, line );
    }
}

/*-----------------------------------------------------------------------------
*	append one byte / word / long to list line
*----------------------------------------------------------------------------*/
void ListFile_append( ListFile *self, long value, int num_bytes )
{
    Byte byte1;

    if ( self->file != NULL && ! self->source_list_ended )
    {
        while ( num_bytes-- > 0 )
        {
            byte1 = value & 0xFF;
            str_append_char( self->bytes, byte1 );
            value >>= 8;
        }
    }
}

void ListFile_append_byte( ListFile *self, Byte byte1 )
{
    ListFile_append( self, byte1, 1 );
}

void ListFile_append_word( ListFile *self, int word )
{
    ListFile_append( self, word, 2 );
}

void ListFile_append_long( ListFile *self, long dword )
{
    ListFile_append( self, dword, 4 );
}

void list_append( long value, int num_bytes )
{
    if ( the_list != NULL )
    {
        ListFile_append( the_list, value, num_bytes );
    }
}

void list_append_byte( Byte byte1 )
{
    list_append( byte1, 1 );
}

void list_append_word( int word )
{
    list_append( word, 2 );
}

void list_append_long( long dword )
{
    list_append( dword, 4 );
}

/*-----------------------------------------------------------------------------
*	compute list file position (ftell()) for patching byte at given offset,
*	take page size and header into account
*	from start of line, return -1 if no list file open
*----------------------------------------------------------------------------*/
long ListFile_patch_pos( ListFile *self, int byte_offset )
{
    int line_nr;
    int start_line_pos;

    if ( self->file == NULL || self->source_list_ended )
    {
        return -1;
    }
    else
    {
        line_nr = self->line_nr;
        start_line_pos = self->start_line_pos;

        while ( byte_offset >= HEX_DUMP_WIDTH )
        {
            line_nr++;
            start_line_pos += 5 + 1 + 4 + 2 + ( HEX_DUMP_WIDTH * 3 ) + newline_size;

            if ( line_nr >= PAGE_LEN )
            {
                start_line_pos += header_size;
                line_nr = 4;
            }

            byte_offset -= HEX_DUMP_WIDTH;
        }

        return start_line_pos + 5 + 1 + 4 + 2 + ( byte_offset * 3 );
    }
}

long list_patch_pos( int byte_offset )
{
    if ( the_list != NULL )
    {
        return ListFile_patch_pos( the_list, byte_offset );
    }
    else
    {
        return -1;
    }
}

/*-----------------------------------------------------------------------------
*	output the current assembly line to the list file with Hex dump
*----------------------------------------------------------------------------*/
void ListFile_end_line( ListFile *self )
{
    int len, i;
    Byte *byteptr;

    if ( self->file != NULL && self->line_started && ! self->source_list_ended )
    {
        /* get length of hex dump and pointer to data bytes (BUG_0015) */
        len     = str_len(self->bytes);
        byteptr = (Byte *) str_data(self->bytes);

        /* output line number and address */
        ListFile_fprintf( self, "%-5d %04X  ", self->source_line_nr, self->address );

        /* output hex dump */
        for ( i = 0 ; i < len ; i++ )
        {
            ListFile_fprintf( self, "%02X ", *byteptr++ );

            if ( i < len - 1 &&
                    ( ( i + 1 ) % HEX_DUMP_WIDTH ) == 0 )
            {
                ListFile_fprintf( self, "\n      %04X  ", self->address + i + 1 );
            }
        }

        /* output line - pad to start of asm line*/
        if ( len <= 4 )
        {
            ListFile_fprintf( self, "%*s", ( 4 - len ) * 3, "" );
        }
        else
        {
            ListFile_fprintf( self, "\n%*s", 5 + 1 + 4 + 2 + ( 4 * 3 ), "" );
        }

        ListFile_fprintf( self, "%s", str_data(self->line) );

        self->line_started = FALSE;				/* no longer in line */
    }
}

void list_end_line( void )
{
    if ( the_list != NULL )
    {
        ListFile_end_line( the_list );
    }
}

/*-----------------------------------------------------------------------------
*	signal end of list file
*----------------------------------------------------------------------------*/
void ListFile_end( ListFile *self )
{
    ListFile_end_line( self );
    self->source_list_ended = TRUE;
}

void list_end( void )
{
    if ( the_list != NULL )
    {
        ListFile_end( the_list );
    }
}

/*-----------------------------------------------------------------------------
*	patch list file
*----------------------------------------------------------------------------*/
void ListFile_patch_data( ListFile *self, long patch_pos, long value, int num_bytes )
{
    if ( self->file != NULL && patch_pos >= 0 )
    {
        fseek( self->file, patch_pos, SEEK_SET );		/* set file pointer in list file */

        while ( num_bytes-- > 0 )
        {
            ListFile_fprintf( self, "%02X ", value & 0xFF );
            value >>= 8;
        }

        fseek( self->file, 0, SEEK_END );				/* set file pointer to end of list file */
    }
}

void list_patch_data( long patch_pos, long value, int num_bytes )
{
    if ( the_list != NULL )
    {
        ListFile_patch_data( the_list, patch_pos, value, num_bytes );
    }
}

/*-----------------------------------------------------------------------------
*	start symbol table
*----------------------------------------------------------------------------*/
void ListFile_start_table( ListFile *self, char *title )
{
    if ( self->file != NULL )
    {
        ListFile_fprintf( self, "\n\n%s\n\n", title );
    }
}

void list_start_table( char *title )
{
    if ( the_list != NULL )
    {
        ListFile_start_table( the_list, title );
    }
}

/*-----------------------------------------------------------------------------
*	output symbol
*----------------------------------------------------------------------------*/
void ListFile_symbol( ListFile *self, char *symbol_name, long symbol_value,
                      SymbolRefList *references )
{
    char *symbol_output;
    int count_page_ref;
    SymbolRefListElem *iter;
    Bool first;

    if ( self->file != NULL )
    {
        /* BUG_0027 */
        if ( strlen( symbol_name ) < COLUMN_WIDTH )
        {
            symbol_output = symbol_name;	/* one line with symbol name and value */
        }
        else
        {
            symbol_output = "";				/* one line with symbol name, next line with blanks */
            ListFile_fprintf( self, "%s\n", symbol_name );
        }

        ListFile_fprintf( self, "%-*s= %04lX", COLUMN_WIDTH, symbol_output, symbol_value );

        /* BUG_0028 */
        for ( iter = SymbolRefList_first( references ), first = TRUE, count_page_ref = 0 ;
                iter != NULL ;
                iter = SymbolRefList_next( iter ), first = FALSE, count_page_ref++ )
        {
            /* output separator on first reference */
            if ( count_page_ref == 0 )
            {
                ListFile_fprintf( self, " :" );
            }
            /* output newline after x references */
            else if ( ( count_page_ref % REF_PER_LINE ) == 0 )
            {
                ListFile_fprintf( self, "\n%*s", COLUMN_WIDTH + 2 + 8 + 2, "" );
            }

            /* output page reference */
            ListFile_fprintf( self, "%4d%c", iter->obj->page_nr, first ? '*' : ' ' );
        }

        ListFile_fprintf( self, "\n" );
    }
}

void list_symbol( char *symbol_name, long symbol_value,
                  SymbolRefList *references )
{
    if ( the_list != NULL )
    {
        ListFile_symbol( the_list, symbol_name, symbol_value, references );
    }
}

/*-----------------------------------------------------------------------------
*	get current page number
*----------------------------------------------------------------------------*/
int ListFile_get_page_nr( ListFile *self )
{
    return ( self->file != NULL && ! self->source_list_ended ) ? self->page_nr : -1;
}

int list_get_page_nr( void )
{
    return the_list != NULL ? ListFile_get_page_nr( the_list ) : -1;
}
