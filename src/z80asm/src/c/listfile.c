/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2021
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

Handle assembly listing and symbol table listing.
*/

#include "codearea.h"
#include "errors.h"
#include "fileutil.h"
#include "hist.h"
#include "if.h"
#include "listfile.h"
#include "options.h"
#include "strutil.h"
#include "types.h"
#include "utstring.h"
#include "z80asm.h"
#include "zutils.h"
#include <stdio.h>
#include <time.h>

/*-----------------------------------------------------------------------------
*   Static variables
*----------------------------------------------------------------------------*/
static int newline_size = 0;

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
	self->bytes = Str_new(STR_SIZE);
	self->line = Str_new(STR_SIZE);
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
    ListFile_close( self, false );

	Str_delete(self->bytes);
	Str_delete(self->line);
}

/*-----------------------------------------------------------------------------
*	output one line to the list file
*----------------------------------------------------------------------------*/
static void ListFile_fprintf( ListFile *self, char *msg, ... )
{
	STR_DEFINE(str, STR_SIZE);
    va_list argptr;

    if ( self->file != NULL )
    {
	    va_start( argptr, msg );				/* BUG_0046 */
        Str_vsprintf( str, msg, argptr );		/* ignore ret, as we dont retry */
		va_end( argptr );

		fputs(Str_data(str), self->file);
    }

	STR_DELETE(str);
}

/*-----------------------------------------------------------------------------
*	open the list file
*----------------------------------------------------------------------------*/
void ListFile_open( ListFile *self, const char *list_file )
{
    /* close and discard any open list file */
    ListFile_close( self, false );

    /* open the file */
    self->filename	= spool_add( list_file );
    self->file		= xfopen( list_file, "w" );
    self->source_list_ended = false;

    /* init '\n' size */
	fputc('\n', self->file);
	newline_size = (int)(ftell(self->file));
	fseek(self->file, 0, SEEK_SET);

	self->start_line_pos = 0;
}

void list_open(const char *list_file )
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
void ListFile_close( ListFile *self, bool keep_file )
{
    if ( self->file != NULL )
    {
        /* close any pending line started */
        ListFile_end( self );

        xfclose( self->file );

        if ( ! keep_file )
            remove( self->filename );
    }

    self->file = NULL;
}

void list_close( bool keep_file )
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
	const char *source_file, int source_line_nr, const char *line )
{
    if ( self->file != NULL && ! self->source_list_ended )
    {
        /* close any pending line */
        ListFile_end_line( self );

        self->line_started = true;			/* signal: in line */

        /* Get file position for beginning of next line in list file */
        self->start_line_pos = ftell( self->file );

        /* init all line-related variables */
        self->address = address;
        Str_clear( self->bytes );

        self->source_file = spool_add( source_file );
        self->source_line_nr = source_line_nr;

        /* normalize the line end (BUG_0031) */
        Str_set( self->line, line );
		strchomp(Str_data(self->line));
		Str_sync_len(self->line);
		Str_append_char(self->line, '\n');
    }
}

void list_start_line( int address,
	const char *source_file, int source_line_nr, const char *line )
{
    if ( the_list != NULL )
    {
        ListFile_start_line( the_list, address,
                             source_file, source_line_nr, line );
    }
}

void got_source_line(const char* filename, int line_num, const char* text) {
	set_error_file(filename);			// file for error messages
	if (filename) {
		set_error_line(line_num);		// line number for error messages

		// send line to list file
		if (opts.cur_list)
			list_start_line(get_phased_PC() >= 0 ? get_phased_PC() : get_PC(),
				filename, line_num, text);
	}
#ifdef LOG_INPUT
	printf("%s:%d:%s", filename, line_num, text);
#endif
}

/*-----------------------------------------------------------------------------
*	append one byte / word / long to list line
*----------------------------------------------------------------------------*/
void ListFile_append( ListFile *self, long value, int num_bytes )
{
    byte_t byte1;

    if ( self->file != NULL && ! self->source_list_ended )
    {
        while ( num_bytes-- > 0 )
        {
            byte1 = value & 0xFF;
            Str_append_char( self->bytes, byte1 );
            value >>= 8;
        }
    }
}

void ListFile_append_byte( ListFile *self, byte_t byte1 )
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

void list_append_byte( byte_t byte1 )
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
    int start_line_pos;

    if ( self->file == NULL || self->source_list_ended )
    {
        return -1;
    }
    else
    {
        start_line_pos = self->start_line_pos;

        while ( byte_offset >= HEX_DUMP_WIDTH )
        {
            start_line_pos += 5 + 1 + 4 + 2 + ( HEX_DUMP_WIDTH * 3 ) + newline_size;
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
    byte_t *byteptr;

    if ( self->file != NULL && self->line_started && ! self->source_list_ended )
    {
        /* get length of hex dump and pointer to data bytes (BUG_0015) */
        len     = Str_len(self->bytes);
        byteptr = (byte_t *) Str_data(self->bytes);

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

        ListFile_fprintf( self, "%s", Str_data(self->line) );

        self->line_started = false;				/* no longer in line */
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
    self->source_list_ended = true;
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
