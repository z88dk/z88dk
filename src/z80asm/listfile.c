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

Handle assembly listing and symbol table listing.
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/listfile.c,v 1.1 2013-02-19 22:52:40 pauloscustodio Exp $ */
/* $Log: listfile.c,v $
/* Revision 1.1  2013-02-19 22:52:40  pauloscustodio
/* BUG_0030 : List bytes patching overwrites header
/* BUG_0031 : List file garbled with input lines with 255 chars
/* New listfile.c with all the listing related code
/*
/*
/* */

#include "memalloc.h"   /* before any other include */
#include "listfile.h"
#include "file.h"
#include "options.h"
#include "z80asm.h"
#include "errors.h"
#include "hist.h"
#include "class.h"
#include "strpool.h"
#include "types.h"
#include "safestr.h"
#include "strutil.h"
#include "codearea.h"

#include <stdio.h>
#include <time.h>
#include <stdarg.h>

/*-----------------------------------------------------------------------------
*   Static variables
*----------------------------------------------------------------------------*/
static int header_size = 0;
static int newline_size = 0;
static time_t list_time;		/* time   of assembly in seconds */
static char *list_date;			/* pointer to datestring calculated from list_time */

/*-----------------------------------------------------------------------------
*   Class to hold current list file
*----------------------------------------------------------------------------*/
CLASS( ListFile )
	char	*filename;				/* list file name, held in strpool */
	FILE	*file;					/* open file */
	long	start_line_pos;			/* ftell() position at start of next list line */

	int		page_nr;				/* current page number */
	int		line_nr;				/* current line number in page */
END_CLASS;

DEF_CLASS(ListFile);

/* declare methods */
void ListFile_open( ListFile *self, char *source_file );
void ListFile_close( ListFile *self, BOOL keep_file );
void ListFile_init_page( ListFile *self );
void ListFile_vfprintf( ListFile *self, char *msg, va_list argptr );
void ListFile_fprintf( ListFile *self, char *msg, ... );
void ListFile_write_header( ListFile *self );
void ListFile_write_asmln( ListFile *self, char *asm_line );
long ListFile_patch_pos( ListFile *self, int byte_offset );
void ListFile_patch( ListFile *self, long patch_pos, long value, int num_bytes );


void ListFile_init ( ListFile *self )
{ 
    /* force init strpool to make sure ListFile is destroyed before StrPool */
    strpool_init();
}

void ListFile_copy ( ListFile *self, ListFile *other )
{
	/* cannot copy object because of external resources held - open file */
	self->filename = NULL;
	self->file     = NULL;
}

void ListFile_fini ( ListFile *self )   
{
	/* delete file if object is garbage-collected - unexpected exit */
	ListFile_close( self, FALSE );
}

void ListFile_open( ListFile *self, char *source_file )
{
	char list_filename[FILENAME_MAX];

	/* close and discard any open list file */
	ListFile_close( self, FALSE );

	/* compute time for header */
    time( &list_time );
    list_date = asctime( localtime( &list_time ) ); /* get current system time for date in list file */

	/* open the file */
	path_replace_ext( list_filename, source_file,
						listing ? 
						FILEEXT_LST             /* set '.lst' extension */
						: FILEEXT_SYM );			/* set '.sym' extension */

	self->filename	= strpool_add(list_filename);
	self->file		= fopen_err( list_filename, "w+" );

	/* output header */
	ListFile_init_page( self );
}

void ListFile_close( ListFile *self, BOOL keep_file )
{
	if ( self->file != NULL ) 
	{
        fputc_err( '\f', self->file );     /* end listing with a FF */
        fclose( self->file );

		if ( ! keep_file) 
		{
            remove( self->filename );
		}
	}

	self->file = NULL;
}

void ListFile_init_page( ListFile *self )
{
	if ( self->file != NULL ) 
	{
		self->page_nr = 0;
		ListFile_write_header( self );			/* Begin list file with a header */
		self->start_line_pos = ftell( self->file );	/* Get file pos. of next line in list file */
	}
}

void ListFile_vfprintf( ListFile *self, char *msg, va_list argptr )
{
    SSTR_DEFINE( str, MAXLINE );
	char *p;

	if ( self->file != NULL ) 
	{
		sstr_vfset( str, msg, argptr );			/* build list line */

		/* output to list file, advance line if newline, insert header on new page */
		for ( p = sstr_data(str) ; *p ; p++ ) 
		{
			fputc_err( *p, self->file );
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
}

void ListFile_fprintf( ListFile *self, char *msg, ... )
{
    va_list argptr;
    va_start( argptr, msg ); /* init variable args */

	ListFile_vfprintf( self, msg, argptr );
}

void ListFile_write_header( ListFile *self )
{
	long	fpos1, fpos2, fpos3;

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

		fputc_err( '\n', self->file );

		/* compute header size and newline size on first call */
		if ( header_size == 0 ) 
		{
			fpos3 = ftell( self->file );		/* after header */

			newline_size = (int)(fpos3 - fpos2);

			/* header between pages has "\f\n" more */
			header_size  = (int)(fpos3 - fpos1) + 1 + newline_size;	
		}
	}
}

/* Write current source line to list file with Hex dump of assembled instruction */
void ListFile_write_asmln( ListFile *self, char *asm_line )
{
    int len, i;
    size_t byteptr;

	if ( self->file != NULL ) 
	{
		/* remove end new-line and spaces (BUG_0031) */
		chomp(asm_line);						

		/* get length of hex dump and address of first byte (BUG_0015) */
		len = get_PC() - get_oldPC();
		byteptr = get_codeindex() - len;

		/* output line number and address */
		ListFile_fprintf( self, "%-5d %04X  ", CURRENTFILE->line, get_oldPC() );

		/* output hex dump */
		for ( i = 0 ; i < len ; i++ )
		{
			ListFile_fprintf( self, "%02X ", get_byte( &byteptr ) );
			if ( i < len - 1 && 
				 ( (i+1) % HEX_DUMP_WIDTH) == 0 )
			{
				ListFile_fprintf( self, "\n      %04X  ", get_oldPC() + i + 1 );
			}
		}

		/* output line */
		if ( len <= 4 )
		{
			ListFile_fprintf( self, "%*s", (4 - len) * 3, "" );		/* pad to start of asm line */
		}
		else 
		{
			ListFile_fprintf( self, "\n%*s", 5 + 1 + 4 + 2 + (4 * 3), "" );		/* pad to start of asm line */
		}

		ListFile_fprintf( self, "%s\n", asm_line );

		/* prepare for next list line */
		self->start_line_pos = ftell( self->file );      /* Get file position for beginning of next line in list file */
		set_oldPC();
	}
}

/* compute patch position of given byte, take page size and header into account */
long ListFile_patch_pos( ListFile *self, int byte_offset )
{
	int line_nr;
	int start_line_pos;

	if ( self->file == NULL ) 
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
			start_line_pos += 5 + 1 + 4 + 2 + (HEX_DUMP_WIDTH * 3) + newline_size;
			if ( line_nr >= PAGE_LEN )
			{
				start_line_pos += header_size;
				line_nr = 4;
			}
			byte_offset -= HEX_DUMP_WIDTH;
		}

		return start_line_pos + 5 + 1 + 4 + 2 + (byte_offset * 3);
	}
}

/* patch list file hex bytes */
void ListFile_patch( ListFile *self, long patch_pos, long value, int num_bytes )
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

/*-----------------------------------------------------------------------------
*   Global state variables
*----------------------------------------------------------------------------*/
static ListFile *the_list = NULL;

/*-----------------------------------------------------------------------------
*   Module API
*----------------------------------------------------------------------------*/
void open_list_file( char *source_file )
{
    if ( option_list || symfile )
	{
		if (the_list == NULL)
		{
			the_list = OBJ_NEW(ListFile);
		}

		ListFile_open( the_list, source_file );
	}
}

void close_list_file( BOOL keep_file )
{
	if ( the_list != NULL )
	{
		ListFile_close( the_list, keep_file );
	}
}

int get_page_nr( void )
{
	return the_list == NULL ? 0 : the_list->page_nr;
}

void fprintf_list_file( char *msg, ... )
{
    va_list argptr;
    va_start( argptr, msg ); /* init variable args */

	if ( the_list != NULL )
	{
		ListFile_vfprintf( the_list, msg, argptr );
	}
}

void write_asmln_list_file( char *asm_line )
{
	if ( the_list != NULL )
	{
		ListFile_write_asmln( the_list, asm_line );
	}
}

long list_file_patch_pos( int byte_offset )
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

void list_file_patch( long patch_pos, long value, int num_bytes )
{
	if ( the_list != NULL )
	{
		ListFile_patch( the_list, patch_pos, value, num_bytes );
	}
}