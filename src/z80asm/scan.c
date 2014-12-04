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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/scan.c,v 1.53 2014-12-04 23:30:19 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "errors.h"
#include "init.h"
#include "list.h"
#include "model.h"
#include "options.h"
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
int			 tok_flag = FLAG_NONE;
int			 tok_reg8 = REG8_NONE;
int			 tok_reg16_af = REG16_NONE;
int			 tok_reg16_sp = REG16_NONE;
int			 tok_ind_reg16 = IND_REG16_NONE;
int			 tok_idx_reg = IDX_REG_HL;
int	         tok_ds_size = 0;

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
	tok = TK_END;
	tok_text = "";
	tok_number = 0;
	tok_flag = FLAG_NONE;
	tok_reg8 = REG8_NONE;
	tok_reg16_af = REG16_NONE;
	tok_reg16_sp = REG16_NONE;
	tok_ind_reg16 = IND_REG16_NONE;
	tok_idx_reg = IDX_REG_HL;
	tok_ds_size = 0;
	tok_parser = NULL;

	Str_clear(tok_name_buf);
	Str_clear(tok_string_buf);
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

/* get the next token, error if not the expected one */
void GetSymExpect(tokid_t expected_tok)
{
	init();
	GetSym();
	CurSymExpect(expected_tok);
}


/* check the current token, error if not the expected one */
void CurSymExpect(tokid_t expected_tok)
{
	init();
	if (tok != expected_tok)
		error_syntax();
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
