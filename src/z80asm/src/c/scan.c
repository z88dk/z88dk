/*
Z88-DK Z80ASM - Z80 Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2022
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

Scanner. Scanning engine is built by ragel from scan_rules.rl.
*/

#include "alloc.h"
#include "die.h"
#include "if.h"
#include "init.h"
#include "list.h"
#include "options.h"
#include "scan.h"
#include "str.h"
#include "utarray.h"
#include "zutils.h"
#include <ctype.h>

/*-----------------------------------------------------------------------------
* 	Globals
*----------------------------------------------------------------------------*/
Sym  sym;
bool found_EOL;

/*-----------------------------------------------------------------------------
* 	Static - current scan context
*----------------------------------------------------------------------------*/
static Str	*input_buf;					/* current input buffer */
static List *input_stack;				/* stack of previous contexts */

static bool	 at_bol;					/* true if at beginning of line */

static int	 cs, act;					/* Ragel state variables */
static char	*p, *pe, *eof_, *ts, *te;	/* Ragel state variables */

/* static DEFINE_STR(sym_string, STR_SIZE); */

static bool	expect_opcode;				/* true to return opcodes as tokens, 
										*  false to return as names */

/* save scan status */
typedef struct scan_state_t
{
	Sym		 sym;
	char	*input_buf;
	bool	 at_bol;
	bool	 found_EOL;
	int		 cs, act;
	int		 p, pe, eof_, ts, te;
//	char	*sym_string;
	bool	 expect_opcode;
} ScanState;

static void ut_scan_state_dtor(void *elt) 
{ 
	ScanState *state = elt; 
	m_free(state->input_buf); 
//	m_free(state->sym_string);
}
static UT_array *scan_state;
static UT_icd ut_scan_state_icd = { sizeof(ScanState), NULL, NULL, ut_scan_state_dtor };

/*-----------------------------------------------------------------------------
* 	Init, save and restore current sym
*----------------------------------------------------------------------------*/
static void init_sym(void)
{
	sym.tok = sym.tok_opcode = TK_END;
	sym.tstart = ""; 
	sym.tlen = 0;
	sym.number = 0;
}

/*-----------------------------------------------------------------------------
*   Init functions
*----------------------------------------------------------------------------*/
DEFINE_init_module()
{
	input_buf = Str_new(STR_SIZE);
	p = Str_data(input_buf);

	input_stack	 = OBJ_NEW(List);
	input_stack->free_data = m_free_compat;

	init_sym();
	utarray_new(scan_state, &ut_scan_state_icd);
}

DEFINE_dtor_module()
{
	Str_delete(input_buf);
	OBJ_DELETE(input_stack);
	utarray_free(scan_state);
}

/*-----------------------------------------------------------------------------
* 	Save and restore current state
*----------------------------------------------------------------------------*/
void save_scan_state(void)
{
	ScanState save;

	init_module();

	save.sym = sym;
	save.input_buf = m_strdup(Str_data(input_buf));
	save.at_bol = at_bol;
	save.found_EOL = found_EOL;
	save.cs = cs;
	save.act = act;
	save.p   = p   ? p   - Str_data(input_buf) : -1;
	save.pe  = pe  ? pe  - Str_data(input_buf) : -1;
	save.eof_ = eof_ ? eof_ - Str_data(input_buf) : -1;
	save.ts  = ts  ? ts  - Str_data(input_buf) : -1;
	save.te  = te  ? te  - Str_data(input_buf) : -1;
//	save.sym_string = m_strdup(sym_string->str);
	save.expect_opcode = expect_opcode;

	utarray_push_back(scan_state, &save);
}

void restore_scan_state(void)
{
	ScanState *save;

	init_module();

	save = (ScanState *)utarray_back(scan_state);
	sym = save->sym;
	Str_set(input_buf, save->input_buf);
	at_bol = save->at_bol;
	found_EOL = save->found_EOL;
	cs = save->cs;
	act = save->act;
	p   = save->p   >= 0 ? Str_data(input_buf) + save->p   : NULL;
	pe  = save->pe  >= 0 ? Str_data(input_buf) + save->pe  : NULL;
	eof_ = save->eof_ >= 0 ? Str_data(input_buf) + save->eof_ : NULL;
	ts  = save->ts  >= 0 ? Str_data(input_buf) + save->ts  : NULL;
	te  = save->te  >= 0 ? Str_data(input_buf) + save->te  : NULL;
//	Str_set(sym_string, save->sym_string);
	expect_opcode = save->expect_opcode;

	utarray_pop_back(scan_state);
}

void drop_scan_state(void)
{
	init_module();

	utarray_pop_back(scan_state);
}

void scan_expect_opcode(void)
{
	init_module();

	expect_opcode = true;

	/* convert current symbol */
	if (sym.tok_opcode)
		sym.tok = sym.tok_opcode;
}

void scan_expect_operands(void)
{
	init_module();

	expect_opcode = false;

	/* convert current symbol */
	if (sym.tok_opcode)
		sym.tok = TK_NAME;
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
	
	value = 0;
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
			xassert(0); /* invalid digit - should not be reached */
		}

		if (digit >= base) 
		{
			xassert(0); /* digit out of range - should not be reached */
		}
		
		value = value * base + digit;
	}
	
	return value;
}

/*-----------------------------------------------------------------------------
*   copy tok_string, start with p pointing at the start quote (' or "),
*	end with p pointing at the end quote, copy characters to tok_string
*	handling C escape sequences. Return false if string not terminated.
*----------------------------------------------------------------------------*/
static bool get_sym_string( void )
{
	char quote;

	/* mark token start */
	quote = *p++;
	xassert( quote == '"' || quote == '\'' );
	ts = p;

	/* search for end quote or end of string */
	while (true)
	{
		if (*p == '\\' && p[1] != '\0')
			p++;						/* skip char after backslash, may be a quote */
		else if (*p == quote)
		{
			te = p;
			return true;
		}
		else if (*p == '\n' || *p == '\0')
		{
			te = ts;
			p--;						/* point to before separator */
			return false;
		}
		
		/* advance to next */
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
*   Skip line past the newline, set found_EOL
*----------------------------------------------------------------------------*/
void Skipline( void )
{
	init_module();

	if ( ! found_EOL )
	{
		char *newline = strchr( p, '\n' );
		if ( newline == NULL )
			p += strlen(p);
		else 
			p = newline + 1;
		
		found_EOL = true;
	}
}


/*-----------------------------------------------------------------------------
*   Import scanner generated by ragel
*----------------------------------------------------------------------------*/
#include "scan_rules.h"

/*-----------------------------------------------------------------------------
*   Fill scan buffer if needed, return false on end of file
*----------------------------------------------------------------------------*/
static bool fill_buffer( void )
{
	while ( *p == '\0' )
	{
		/* get last buffer from stack, if any */
		char* line = List_pop( input_stack );
		if ( line != NULL )
		{
			set_scan_buf( line, false );	/* read from stack - assume not at BOL */
			m_free( line );
		}
		else 
		{
			/* get next line from input source file */
			char* line = sfile_get_source_line();
			if ( line == NULL )
				return false;

			/* got new line */
			set_scan_buf( line, true );		/* read from file - at BOL */
			xfree(line);
		}
	}

	return true;
}

/*-----------------------------------------------------------------------------
*   Get the next token, fill the corresponding tok* variables
*----------------------------------------------------------------------------*/
tokid_t GetSym( void )
{
	init_module();

	init_sym();

	/* keep returning TK_NEWLINE until found_EOL is cleared 
	*  NOTE: HACK for inconsistent parser in handling newlines, should be removed */
	if ( found_EOL )
	{
		at_bol = true;
		sym.tstart = "\n"; sym.tlen = 1;
		return (sym.tok = TK_NEWLINE);			/* assign and return */
	}

	/* loop filling buffer when needed */
	do 
	{
		/* refill buffer if needed, check for end of file */
		if ( ! fill_buffer() )
		{
			sym.tok = TK_END;
			ts = te = p;
			break;
		}

		/* run the state machine */
		sym.tok = _scan_get();
		
	} while ( sym.tok == TK_END );

	sym.tstart = ts; sym.tlen = te - ts;			/* remember token position */

	at_bol = found_EOL = (sym.tok == TK_NEWLINE) ? true : false;
	return sym.tok;
}


/* get the next token, error if not the expected one */
void GetSymExpect(tokid_t expected_tok)
{
	init_module();

	GetSym();
	CurSymExpect(expected_tok);
}


/* check the current token, error if not the expected one */
void CurSymExpect(tokid_t expected_tok)
{
	init_module();

	if (sym.tok != expected_tok)
		error_syntax();
}


/*-----------------------------------------------------------------------------
*   Insert the given text at the current scan position
*----------------------------------------------------------------------------*/
void SetTemporaryLine(const char *line )
{
	init_module();
	set_scan_buf( line, false );					/* assume not at BOL */
}

/*-----------------------------------------------------------------------------
*   return static string with current token text
*   non-reentrant, string needs to be saved by caller
*----------------------------------------------------------------------------*/
char *sym_text(Sym *sym)
{
	static STR_DEFINE(text, STR_SIZE);

	Str_set_bytes(text, sym->tstart, sym->tlen);
	return Str_data(text);
}
