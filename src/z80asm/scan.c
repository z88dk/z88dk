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

Copyright (C) Paulo Custodio, 2011-2014

Scanner. Scanning engine is built by ragel from scan_rules.rl.

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/scan.c,v 1.50 2014-05-25 01:02:29 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "errors.h"
#include "init.h"
#include "list.h"
#include "model.h"
#include "scan.h"
#include "strutil.h"
#include <assert.h>
#include <ctype.h>

/*-----------------------------------------------------------------------------
* 	Globals - last token retrieved
*----------------------------------------------------------------------------*/
tokid_t		 tok			= TK_NIL;

char		*tok_text       = "";

static Str	*tok_name_buf   = NULL;
char		*tok_name       = "";

static Str	*tok_string_buf = NULL;
char		*tok_string     = "";

long		 tok_number		= 0;

void       (*tok_parser)(void) = NULL;

Bool EOL;								/* scanner EOL state */

/*-----------------------------------------------------------------------------
* 	Static - current scan context
*----------------------------------------------------------------------------*/
static Str  *input_buf	= NULL;			/* current input buffer */
static List *input_stack;				/* stack of previous contexts */

static Bool	 at_bol;					/* true if at beginning of line */

static int	 cs, act;					/* Ragel state variables */
static char	*p, *pe, *eof, *ts, *te;	/* Ragel state variables */

/*-----------------------------------------------------------------------------
*   Clear the current token
*----------------------------------------------------------------------------*/
static void init_tok( void )
{
	tok			= TK_END;
	tok_text	= "";
	tok_number	= 0;
	tok_parser	= NULL;

	Str_clear( tok_name_buf );
	Str_clear( tok_string_buf );
}

/*-----------------------------------------------------------------------------
*   Init functions
*----------------------------------------------------------------------------*/
DEFINE_init()
{
	tok_name_buf = OBJ_NEW(Str);
	Str_set_alias( tok_name_buf, &tok_name );

	tok_string_buf = OBJ_NEW(Str);
	Str_set_alias( tok_string_buf, &tok_string );

	input_buf = OBJ_NEW(Str);
	Str_set_alias( input_buf, &p );		/* Ragel pointer to current scan position */

	input_stack	 = OBJ_NEW(List);
	input_stack->free_data = xfreef;

	init_tok();
}

DEFINE_fini()
{
	OBJ_DELETE(tok_name_buf);
	OBJ_DELETE(tok_string_buf);
	OBJ_DELETE(input_buf);
	OBJ_DELETE(input_stack);
}

/*-----------------------------------------------------------------------------
*	convert number to int, range warning if greater than INT_MAX
*----------------------------------------------------------------------------*/
static long scan_num ( char *text, int length, int base )
{
	long value;
	int digit = 0;
	char c;
	int i;
	Bool range_err;
	
	value = 0;
	range_err = FALSE;
	for ( i = 0 ; i < length ; i++ ) 
	{
		c = *text++;					/* read each digit */
		if ( isdigit(c) ) 
		{
			digit = c - '0';
		}
		else if ( isalpha(c) ) 
		{
			digit = toupper(c) - 'A' + 10;
		}
		else if ( base == 2 && (c == '-' || c == '#') ) 
		{
			digit = (c == '#') ? 1 : 0;
		}
		else 
		{
			assert(0); /* invalid digit - should not be reached */
		}

		if (digit >= base) 
		{
			assert(0); /* digit out of range - should not be reached */
		}
		
		value = value * base + digit;

		if ( ! range_err && value < 0 )	/* overflow to sign bit */
		{
			range_err = TRUE;		
		}
	}
	
	if ( range_err )
	{
#if 0
		warn_int_range( value );
#endif
	}
		
	return value;
}

/*-----------------------------------------------------------------------------
*   copy ts to te to text and name, upper case name
*----------------------------------------------------------------------------*/
static void set_tok_name( void )
{
	Str_set_n(  tok_name_buf, ts, te-ts );
}

/*-----------------------------------------------------------------------------
*   copy tok_string, start with p pointing at the start quote (' or "),
*	end with p pointing at the end quote, copy characters to tok_string
*	handling C escape sequences. Return false if string not terminated.
*----------------------------------------------------------------------------*/
static Bool get_tok_string( void )
{
	char quote;

	/* mark token start */
	quote = *p++;
	assert( quote == '"' || quote == '\'' );
	ts = p;

	/* search for end quote or end of string */
	while (TRUE)
	{
		if ( *p == '\\' && p[1] != '\0' )
		{
			p++;						/* skip char after backslash, may be a quote */
		}
		else if ( *p == quote )
		{
			te = p;
			Str_set_n( tok_string_buf, ts, te - ts );
			Str_compress_escapes( tok_string_buf );
			return TRUE;
		}
		else if ( *p == '\n' || *p == '\0' )
		{
			te = p;
			p--;						/* point to before separator */
			Str_clear( tok_string_buf );
			return FALSE;
		}
		p++;
	}
}

/*-----------------------------------------------------------------------------
*   skip up to and not including newline
*----------------------------------------------------------------------------*/
static void skip_to_newline( void )
{
	char *newline = strchr( p, '\n' );
	if ( newline != NULL && newline > p )
		p = newline - 1;
}

/*-----------------------------------------------------------------------------
*   Skip line past the newline, set EOL
*----------------------------------------------------------------------------*/
void Skipline( void )
{
	init();
	if ( ! EOL )
	{
		char *newline = strchr( p, '\n' );
		if ( newline == NULL )
			p += strlen(p);
		else 
			p = newline + 1;
		
		EOL = TRUE;
	}
}


/*-----------------------------------------------------------------------------
*   Import scanner generated by ragel
*----------------------------------------------------------------------------*/
#include "scan_rules.h"

/*-----------------------------------------------------------------------------
*   Fill scan buffer if needed, return FALSE on end of file
*----------------------------------------------------------------------------*/
static Bool fill_buffer( void )
{
	char *line;

	while ( *p == '\0' )
	{
		/* get last buffer from stack, if any */
		line = List_pop( input_stack );
		if ( line != NULL )
		{
			set_scan_buf( line, FALSE );	/* read from stack - assume not at BOL */
			xfree( line );
		}
		else 
		{
			/* get next line from input source file */
			line = src_getline();
			if ( line == NULL )
				return FALSE;

			/* got new line */
			set_scan_buf( line, TRUE );		/* read from file - at BOL */
		}
	}

	return TRUE;
}

/*-----------------------------------------------------------------------------
*   Get the next token, fill the corresponding tok* variables
*----------------------------------------------------------------------------*/
tokid_t GetSym( void )
{
	init();

	init_tok();

	/* keep returning TK_NEWLINE until EOL is cleared 
	*  NOTE: HACK for inconsistent parser in handling newlines, should be removed */
	if ( EOL )
	{
		at_bol = TRUE;
		tok_text = "\n";
		return (tok = TK_NEWLINE);			/* assign and return */
	}

	/* loop filling buffer when needed */
	do 
	{
		/* refill buffer if needed, check for end of file */
		if ( ! fill_buffer() )
		{
			tok = TK_END;
			break;
		}

		/* run the state machine */
		tok = _scan_get();

	} while ( tok == TK_END );

	at_bol = EOL = (tok == TK_NEWLINE) ? TRUE : FALSE;
	return tok;
}

/*-----------------------------------------------------------------------------
*   Save the current scan position and back-track to a saved position
*----------------------------------------------------------------------------*/
char *ScanGetPos( void )
{
	init();
	return p;
}

void ScanSetPos( char *pos )
{
	init();

	assert( pos != NULL );
	assert( pos >= input_buf->str && pos <= input_buf->str + input_buf->len );

	p = pos;
}

/*-----------------------------------------------------------------------------
*   Insert the given text at the current scan position
*----------------------------------------------------------------------------*/
void SetTemporaryLine( char *line )
{
	init();
	if ( *p != '\0' )
		List_push( & input_stack, xstrdup( p ) );	/* save current input */
	set_scan_buf( line, FALSE );					/* assume not at BOL */
}

/*
* $Log: scan.c,v $
* Revision 1.50  2014-05-25 01:02:29  pauloscustodio
* Byte, Int, UInt added
*
* Revision 1.49  2014/05/17 14:27:12  pauloscustodio
* Use C99 integer types
*
* Revision 1.48  2014/05/06 22:17:38  pauloscustodio
* Made types all-caps to avoid conflicts with /usr/include/i386-linux-gnu/sys/types.h
*
* Revision 1.47  2014/05/02 21:34:58  pauloscustodio
* byte_t and uint_t renamed to Byte, uint32_t
*
* Revision 1.46  2014/04/05 23:36:11  pauloscustodio
* CH_0024: Case-preserving, case-insensitive symbols
* Symbols no longer converted to upper-case, but still case-insensitive
* searched. Warning when a symbol is used with different case than
* defined. Intermidiate stage before making z80asm case-sensitive, to
* be more C-code friendly.
*
* Revision 1.45  2014/03/30 10:39:51  pauloscustodio
* CH_0023: Accept C-like escape sequences in character constants and strings
* Accepts \a, \b, \e (0x1B), \f, \n, \r, \t, \v, \{any character}, \{octal}, \x{hexadecimal}, allows \0 within the string.
* Existing code may have to be modified, e.g. defb '\' --> defb '\\'
*
* Revision 1.44  2014/03/29 00:33:28  pauloscustodio
* BUG_0044: binary constants with more than 8 bits not accepted
* CH_0022: Added syntax to define binary numbers as bitmaps
* Replaced tokenizer with Ragel based scanner.
* Simplified scanning code by using ragel instead of hand-built scanner
* and tokenizer.
* Removed 'D' suffix to signal decimal number.
* Parse AF' correctly.
* Decimal numbers expressed as sequence of digits, e.g. 1234.
* Hexadecimal numbers either prefixed with '0x' or '$' or suffixed with 'H',
* in which case they need to start with a digit, or start with a zero,
* e.g. 0xFF, $ff, 0FFh.
* Binary numbers either prefixed with '0b' or '@', or suffixed with 'B',
* e.g. 0b10101, @10101, 10101b.
*
* Revision 1.14  2014/03/05 23:44:55  pauloscustodio
* Renamed 64-bit portability to BUG_0042
*
* Revision 1.13  2014/02/19 23:59:26  pauloscustodio
* BUG_0042: 64-bit portability issues
* size_t changes to unsigned long in 64-bit. Usage of size_t * to
* retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
* breaks on a 64-bit architecture. Make the functions return the value instead
* of being passed the pointer to the return value, so that the compiler
* takes care of size convertions.
* Create uint32_t, use uint32_t instead of size_t.
*
* Revision 1.12  2014/02/09 10:16:15  pauloscustodio
* Remove complexity out of scan.rl by relying on srcfile to handle contexts of
* recursive includes, and reading of lines of text, and by assuming scan.c
* will not be reentred, simplifying the keeping of state variables for the scan.
*
* Revision 1.11  2014/01/20 23:29:18  pauloscustodio
* Moved file.c to lib/fileutil.c
*
* Revision 1.10  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.9  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.8  2014/01/10 00:15:27  pauloscustodio
* Use Str instead of glib, List instead of GSList.
* Use init.h mechanism, no need for main() calling init_scan.
* glib dependency removed from code and Makefile
*
* Revision 1.7  2013/12/15 13:18:34  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.6  2013/11/11 23:47:04  pauloscustodio
* Move source code generation tools to dev/Makefile, only called on request,
* and keep the generated files in z80asm directory, so that build does
* not require tools used for the code generation (ragel, perl).
* Remove code generation for structs - use CLASS macro instead.
*
* Revision 1.5  2013/11/02 23:14:05  pauloscustodio
* g_slist_free_full() requires GLib 2.28, replaced by g_slist_foreach() and g_slist_free()
*
* Revision 1.4  2013/10/16 21:42:07  pauloscustodio
* Allocate minimum-sized string, grow as needed.
* Allocate a GString text inside of File, to be used by file reading methods.
*
* Revision 1.3  2013/10/16 00:14:37  pauloscustodio
* Move FileStack implementation to scan.c, remove FileStack.
* Move getline_File() to scan.c.
*
* Revision 1.2  2013/10/15 23:24:33  pauloscustodio
* Move reading by lines or tokens and file reading interface to scan.rl
* to decouple file.c from scan.c.
* Add singleton interface to scan to be used by parser.
*
* Revision 1.1  2013/10/08 21:53:06  pauloscustodio
* Replace Flex-based lexer by a Ragel-based one.
* Add interface to file.c to read files by tokens, calling the lexer.
*
*
*/
