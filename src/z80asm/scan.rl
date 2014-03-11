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

Scanner - to be processed by: ragel -G2 scan.rl
Note: the scanner is not reentrant. scan_get() relies on state variables that
need to be kept across calls.

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/scan.rl,v 1.15 2014-03-11 22:59:20 pauloscustodio Exp $ 
*/

#include "xmalloc.h"   /* before any other include */

#include "errors.h"
#include "scan.h"
#include "strutil.h"
#include "types.h"
#include <assert.h>
#include <ctype.h>

static long  scan_num( char *text, int num_suffix_chars, int base );
static char *copy_token_str( char *text, uint_t len );

/*-----------------------------------------------------------------------------
* 	Globals that keep last token read
*----------------------------------------------------------------------------*/
DEFINE_STR(	scan_buffer, MAXLINE );		/* keep a copy of string being scanned */
DEFINE_STR(	token_str, MAXLINE );		/* keep a copy of last token string */

Token	 last_token;
long	 last_token_num;
char	*last_token_str = "";

/*-----------------------------------------------------------------------------
* 	Static - current scan context
*----------------------------------------------------------------------------*/
static BOOL	 at_bol;				/* true if at beginning of line */

/* Ragel state variables */
static int	 cs, act;			
static char	*p, *pe, *eof, *ts, *te;

/*-----------------------------------------------------------------------------
* Z80ASM scanner
*----------------------------------------------------------------------------*/
%%{
	machine asm;

	# check predicates - beginning of line
	action at_bol 		{ at_bol }	
	
	# Alpha numeric characters or underscore.
	alnum_u = alnum | '_';

	# Alpha characters or underscore.
	alpha_u = alpha | '_';

	# Name
	name = alpha_u alnum_u*;
	
	# Label
	label = "." [ \t]* name | name [ \t]* ":" | "." [ \t]* name [ \t]* ":";
	
	# binary digit
	bdigit = [01];
	
	main := |*

	# Newline
	'\n'						{ last_token = T_NEWLINE; fbreak; };
	
	# Comment
	';' [^\n]*  				; 
	
	# Whitespace is standard ws, newlines and control codes.
	any - 0x21..0x7e - '\n'		;

	# Symbols
	punct - [_'";]				{ last_token = ts[0];		fbreak; };
	'=='						{ last_token = T_EQ_EQ; 	fbreak; };
	'<>'						{ last_token = T_LT_GT; 	fbreak; };
	'!='						{ last_token = T_EXCLAM_EQ; fbreak; };
	'<='						{ last_token = T_LT_EQ; 	fbreak; };
	'>='						{ last_token = T_GT_EQ; 	fbreak; };
	'||'						{ last_token = T_VBAR_VBAR; fbreak; };
	'&&'						{ last_token = T_AND_AND; 	fbreak; };
	'<<'						{ last_token = T_LT_LT; 	fbreak; };
	'>>'						{ last_token = T_GT_GT; 	fbreak; };
	'**'						{ last_token = T_STAR_STAR; fbreak; };

	# Numbers
	digit+
	{ 
		last_token_num = scan_num( ts, te - ts, 10 ); 
		last_token = T_NUMBER;
		fbreak;
	};
	digit xdigit* 'h'i
	{ 
		last_token_num = scan_num( ts, te - ts - 1, 16 ); 
		last_token = T_NUMBER;
		fbreak;
	};
	[$#] xdigit+
	{ 
		last_token_num = scan_num( ts + 1, te - ts - 1, 16 ); 
		last_token = T_NUMBER;
		fbreak;
	};
	'0x'i xdigit+
	{ 
		last_token_num = scan_num( ts + 2, te - ts - 2, 16 ); 
		last_token = T_NUMBER;
		fbreak;
	};
	digit bdigit* 'b'i
	{ 
		last_token_num = scan_num( ts, te - ts - 1, 2 ); 
		last_token = T_NUMBER;
		fbreak;
	};
	[@%] bdigit+
	{ 
		last_token_num = scan_num( ts + 1, te - ts - 1, 2 ); 
		last_token = T_NUMBER;
		fbreak;
	};
	'0b'i bdigit+
	{ 
		last_token_num = scan_num( ts + 2, te - ts - 2, 2 ); 
		last_token = T_NUMBER;
		fbreak;
	};
	[@%] '"' [\-#]+ '"'
	{ 
		last_token_num = scan_num( ts + 2, te - ts - 3, 2 ); 
		last_token = T_NUMBER;
		fbreak;
	};
	
	# Keywords
	"add"i						{ last_token = T_ADD;		fbreak; };
	"ld"i						{ last_token = T_LD;		fbreak; };
	"nop"i						{ last_token = T_NOP;		fbreak; };
	
	# Identifier
	name | "af'"i
	{
		last_token_str = strtoupper( copy_token_str( ts, te-ts ) );
		last_token = T_NAME;
		fbreak;
	};
	
	# Label
	label when at_bol
	{
		/* remove '.' and ':' */
		while ( ts[ 0] == '.' || isspace(ts[ 0]) ) ts++;
		while ( te[-1] == ':' || isspace(te[-1]) ) te--;
		
		/* copy token */
		last_token_str = strtoupper( copy_token_str( ts, te-ts ) );
		last_token = T_LABEL;
		fbreak;
	};
	
	# Single Quote
	"'" [^'\n]* "'"
	{
		if ( te - ts == 3 )
		{
			last_token_num = ts[1];
			last_token = T_NUMBER;
			fbreak;
		}
		else
			error_invalid_squoted_string();
	};
	"'" [^'\n]*					{ error_invalid_squoted_string(); };

	# Double Quote
	'"' [^"\n]* '"'
	{
		last_token_str = copy_token_str( ts+1, te-ts-2 );
		last_token = T_STRING;
		fbreak;
	};
	'"' [^"\n]*					{ error_unclosed_string(); };
	
	*|;
}%%

%% write data nofinal;

/*-----------------------------------------------------------------------------
*	convert number to int, range warning if greater than INT_MAX
*----------------------------------------------------------------------------*/
static long scan_num ( char *text, int length, int base )
{
	long value;
	int digit = 0;
	char c;
	int i;
	BOOL range_err;
	
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
		warn_int_range( value );
	}
		
	return value;
}

/*-----------------------------------------------------------------------------
*	copy characters into token string buffer, set last_token_str
*----------------------------------------------------------------------------*/
static char *copy_token_str( char *text, uint_t len )
{
	/* copy to buffer */
	Str_set( token_str, text );								/* copy all chars */
	token_str->str[ MIN( len, token_str->len ) ] = '\0';	/* truncate */
	Str_sync_len( token_str );
	
	return token_str->str;
}

/*-----------------------------------------------------------------------------
*	Scan API
*----------------------------------------------------------------------------*/

void scan_reset( char *text, BOOL _at_bol )
{
	Str_set( scan_buffer, text );
	
	/* init state */
	at_bol  = _at_bol;
	p		= scan_buffer->str;
	pe		= scan_buffer->str + scan_buffer->len;
	eof		= pe;	/* tokens are not split acros input lines */
	
	%% write init;

	last_token = T_END;
}

Token scan_get( void )
{
	last_token = T_END;

	%% write exec;
	
	at_bol = (last_token == T_NEWLINE) ? TRUE : FALSE;
	
	return last_token;
}


/*
* $Log: scan.rl,v $
* Revision 1.15  2014-03-11 22:59:20  pauloscustodio
* Move EOL flag to scanner
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
* Create uint_t and ulong_t, use uint_t instead of size_t.
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
