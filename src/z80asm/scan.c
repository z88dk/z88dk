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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/scan.c,v 1.68 2015-01-03 18:39:06 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "errors.h"
#include "init.h"
#include "list.h"
#include "model.h"
#include "options.h"
#include "scan.h"
#include "strutil.h"
#include "utarray.h"
#include <assert.h>
#include <ctype.h>

/*-----------------------------------------------------------------------------
* 	Globals
*----------------------------------------------------------------------------*/
Sym  sym;
Bool EOL;

/*-----------------------------------------------------------------------------
* 	Static - current scan context
*----------------------------------------------------------------------------*/
static Str  *input_buf = NULL;			/* current input buffer */
static List *input_stack;				/* stack of previous contexts */

static Bool	 at_bol;					/* true if at beginning of line */

static int	 cs, act;					/* Ragel state variables */
static char	*p, *pe, *eof, *ts, *te;	/* Ragel state variables */

static DEFINE_STR(sym_string, MAXLINE);

static Bool	expect_opcode;				/* true to return opcodes as tokens, 
										*  false to return as names */

/* save scan status */
typedef struct scan_state_t
{
	Sym		 sym;
	char	*input_buf;
	Bool	 at_bol;
	Bool	 EOL;
	int		 cs, act;
	int		 p, pe, eof, ts, te;
	char	*sym_string;
	Bool	 expect_opcode;
} ScanState;

static void ut_scan_state_dtor(void *elt) 
{ 
	ScanState *state = elt; 
	xfree(state->input_buf); 
	xfree(state->sym_string);
}
static UT_array *scan_state;
static UT_icd ut_scan_state_icd = { sizeof(ScanState), NULL, NULL, ut_scan_state_dtor };

/*-----------------------------------------------------------------------------
* 	Init, save and restore current sym
*----------------------------------------------------------------------------*/
static void init_sym(void)
{
	sym.tok = TK_END;
	sym.text = sym.ts = sym.te = "";
	sym.string = NULL;
	sym.filename = NULL;
	sym.line_nr = 0;
	sym.number = 0;
}

/*-----------------------------------------------------------------------------
*   Init functions
*----------------------------------------------------------------------------*/
DEFINE_init()
{
	input_buf = OBJ_NEW(Str);
	Str_set_alias( input_buf, &p );		/* Ragel pointer to current scan position */

	input_stack	 = OBJ_NEW(List);
	input_stack->free_data = xfreef;

	init_sym();
	utarray_new(scan_state, &ut_scan_state_icd);
}

DEFINE_fini()
{
	OBJ_DELETE(input_buf);
	OBJ_DELETE(input_stack);
	utarray_free(scan_state);
}

/*-----------------------------------------------------------------------------
* 	Save and restore current state
*----------------------------------------------------------------------------*/
void save_scan_state(void)
{
	ScanState save;

	init();

	save.sym = sym;
	save.input_buf = xstrdup(input_buf->str);
	save.at_bol = at_bol;
	save.EOL = EOL;
	save.cs = cs;
	save.act = act;
	save.p   = p   ? p   - input_buf->str : -1;
	save.pe  = pe  ? pe  - input_buf->str : -1;
	save.eof = eof ? eof - input_buf->str : -1;
	save.ts  = ts  ? ts  - input_buf->str : -1;
	save.te  = te  ? te  - input_buf->str : -1;
	save.sym_string = xstrdup(sym_string->str);
	save.expect_opcode = expect_opcode;

	utarray_push_back(scan_state, &save);
}

void restore_scan_state(void)
{
	ScanState *save;

	init();

	save = (ScanState *)utarray_back(scan_state);
	sym = save->sym;
	Str_set(input_buf, save->input_buf);
	at_bol = save->at_bol;
	EOL = save->EOL;
	cs = save->cs;
	act = save->act;
	p   = save->p   >= 0 ? input_buf->str + save->p   : NULL;
	pe  = save->pe  >= 0 ? input_buf->str + save->pe  : NULL;
	eof = save->eof >= 0 ? input_buf->str + save->eof : NULL;
	ts  = save->ts  >= 0 ? input_buf->str + save->ts  : NULL;
	te  = save->te  >= 0 ? input_buf->str + save->te  : NULL;
	Str_set(sym_string, save->sym_string);
	expect_opcode = save->expect_opcode;

	utarray_pop_back(scan_state);
}

void drop_scan_state(void)
{
	init();

	utarray_pop_back(scan_state);
}

void scan_expect_opcode(void)
{
	init();

	expect_opcode = TRUE;
}

void scan_expect_operands(void)
{
	init();

	expect_opcode = FALSE;
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
static void set_tok_name(void)
{
	Str_set_n(sym_string, ts, te - ts);
	sym.string = sym_string->str;
}

/*-----------------------------------------------------------------------------
*   copy tok_string, start with p pointing at the start quote (' or "),
*	end with p pointing at the end quote, copy characters to tok_string
*	handling C escape sequences. Return false if string not terminated.
*----------------------------------------------------------------------------*/
static Bool get_sym_string( void )
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

			Str_set_n(sym_string, ts, te - ts);
			sym.string = sym_string->str;

			Str_compress_escapes(sym_string);

			return TRUE;
		}
		else if ( *p == '\n' || *p == '\0' )
{
			te = p;
			p--;						/* point to before separator */

			Str_clear(sym_string);
			sym.string = sym_string->str;

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

	init_sym();

	/* keep returning TK_NEWLINE until EOL is cleared 
	*  NOTE: HACK for inconsistent parser in handling newlines, should be removed */
	if ( EOL )
	{
		at_bol = TRUE;
		sym.text = "\n";
		return (sym.tok = TK_NEWLINE);			/* assign and return */
	}

	/* loop filling buffer when needed */
	do 
	{
		/* refill buffer if needed, check for end of file */
		if ( ! fill_buffer() )
		{
			sym.tok = TK_END;
			break;
		}

		/* run the state machine */
		sym.tok = _scan_get();

	} while ( sym.tok == TK_END );

	sym.ts = ts; sym.te = te;			/* remember token position */

	at_bol = EOL = (sym.tok == TK_NEWLINE) ? TRUE : FALSE;
	return sym.tok;
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

	if (sym.tok != expected_tok)
		error_syntax();
}


/*-----------------------------------------------------------------------------
*   Insert the given text at the current scan position
*----------------------------------------------------------------------------*/
void SetTemporaryLine( char *line )
{
	init();

#if 0
	if (*p != '\0')
		List_push(&input_stack, xstrdup(p));		/* save current input */
#endif
	set_scan_buf( line, FALSE );					/* assume not at BOL */
}
