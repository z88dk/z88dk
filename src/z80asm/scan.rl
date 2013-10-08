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

Scanner - to be processed by: ragel -G2 scan.rl

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/scan.rl,v 1.1 2013-10-08 21:53:06 pauloscustodio Exp $ 
*/

#include "memalloc.h"   /* before any other include */

#include "scan.h"
#include "types.h"

static int scan_num(char *text, int num_suffix_chars, int base);

/*-----------------------------------------------------------------------------
* Globals that keep last token read
*----------------------------------------------------------------------------*/
enum token last_token;
int		   last_token_num;
GString	  *last_token_str;

/*-----------------------------------------------------------------------------
* Z80ASM scanner
*----------------------------------------------------------------------------*/
%%{
	machine asm;

	variable cs		self->cs;
	variable act	self->act;
	variable p		self->p;
	variable pe		self->pe;
	variable eof	self->eof;
	variable ts		self->ts;
	variable te		self->te;

	# check for beginning of line
	action at_bol { self->bol }
	
	# Alpha numeric characters or underscore.
	alnum_u = alnum | '_';

	# Alpha charactres or underscore.
	alpha_u = alpha | '_';

	# Name
	name = alpha_u alnum_u*;
	
	# Label
	label = "." name | name ":" | "." name ":";
	
	# binary digit
	bdigit = [01];
	
	

	any_count_line = any | '\n';

	main := |*

	# Newline
	'\n' 
	{ 
		last_token = t_newline; 
		fbreak; 
	};
	
	# Comment
	';' [^\n]* ;
	
	# Whitespace is standard ws, newlines and control codes.
	any - 0x21..0x7e - '\n';

	# Symbols
	( punct - [_'";] ) 	{ last_token = self->ts[0];	fbreak; };
	'==' 				{ last_token = t_eq_eq; 	fbreak; };
	'<>' 				{ last_token = t_lt_gt; 	fbreak; };
	'!=' 				{ last_token = t_exclam_eq; fbreak; };
	'<=' 				{ last_token = t_lt_eq; 	fbreak; };
	'>=' 				{ last_token = t_gt_eq; 	fbreak; };
	'||' 				{ last_token = t_vbar_vbar; fbreak; };
	'&&' 				{ last_token = t_and_and; 	fbreak; };
	'<<' 				{ last_token = t_lt_lt; 	fbreak; };
	'>>' 				{ last_token = t_gt_gt; 	fbreak; };
	'**' 				{ last_token = t_star_star; fbreak; };

	# Numbers
	digit+ 
	{ 
		last_token_num = scan_num( self->ts, self->te - self->ts, 10 ); 
		last_token = t_number;
		fbreak;
	};
	digit xdigit* 'h'i
	{ 
		last_token_num = scan_num( self->ts, self->te - self->ts - 1, 16 ); 
		last_token = t_number;
		fbreak;
	};
	[$#] xdigit+
	{ 
		last_token_num = scan_num( self->ts + 1, self->te - self->ts - 1, 16 ); 
		last_token = t_number;
		fbreak;
	};
	'0x'i xdigit+
	{ 
		last_token_num = scan_num( self->ts + 2, self->te - self->ts - 2, 16 ); 
		last_token = t_number;
		fbreak;
	};
	digit bdigit* 'b'i
	{ 
		last_token_num = scan_num( self->ts, self->te - self->ts - 1, 2 ); 
		last_token = t_number;
		fbreak;
	};
	[@%] bdigit+
	{ 
		last_token_num = scan_num( self->ts + 1, self->te - self->ts - 1, 2 ); 
		last_token = t_number;
		fbreak;
	};
	'0b'i bdigit+
	{ 
		last_token_num = scan_num( self->ts + 2, self->te - self->ts - 2, 2 ); 
		last_token = t_number;
		fbreak;
	};
	[@%] '"' [\-#]+ '"'
	{ 
		last_token_num = scan_num( self->ts + 2, self->te - self->ts - 3, 2 ); 
		last_token = t_number;
		fbreak;
	};
	
	# Identifier
	name | "af'"i 
	{
		char c = *(self->te); *(self->te) = '\0';		/* make substring */
		g_string_assign( last_token_str, self->ts );
		g_string_ascii_up( last_token_str );
		*(self->te) = c;								/* recover input */
		last_token = t_name;
		fbreak;
	};
	
	# Label
	( label when at_bol )
	{
		char *ts = self->ts;
		char *te = self->te;
		char c;
		
		/* remove '.' and ':' */
		if ( *ts     == '.' ) ts++;
		if ( *(te-1) == ':' ) te--;
		
		/* copy token */
		c = *te; *te = '\0';				/* make substring */
		g_string_assign( last_token_str, ts );
		g_string_ascii_up( last_token_str );
		*te = c;							/* recover input */
		last_token = t_label;
		fbreak;
	};
	
	# Single Quote
	"'" [^'\n]* "'"
	{
		if ( self->te - self->ts == 3 )
		{
			last_token_num = *(self->ts + 1);
			last_token = t_number;
			fbreak;
		}
		else
			error_invalid_squoted_string();
	};
	"'" [^'\n]*					{ error_invalid_squoted_string(); };

	# Double Quote
	'"' [^"\n]* '"'
	{
		char c = *(self->te-1); *(self->te-1) = '\0';		/* make substring */
		g_string_assign( last_token_str, self->ts+1 );
		*(self->te-1) = c;									/* recover input */
		last_token = t_string;
		fbreak;
	};
	'"' [^"\n]* 				{ error_unclosed_string(); };
	
	*|;
}%%

%% write data nofinal;

/*-----------------------------------------------------------------------------
* Initialize and Terminate module
*----------------------------------------------------------------------------*/
void init_scan(void)
{
	last_token_str = g_string_new("");
}
	
void fini_scan(void)
{
	g_string_free( last_token_str, TRUE );
	last_token_str = NULL;
}

/*-----------------------------------------------------------------------------
*	convert number to int, range warning if greater than INT_MAX
*----------------------------------------------------------------------------*/
static int scan_num (char *text, int length, int base)
{
	int value;
	int digit = 0;
	char c;
	int i;
	BOOL range_err;
	
	value = 0;
	range_err = FALSE;
	for ( i = 0 ; i < length ; i++ ) 
	{
		c = *text++;					/* read each digit */
		if (isdigit(c)) 
		{
			digit = c - '0';
		}
		else if (isalpha(c)) 
		{
			digit = toupper(c) - 'A' + 10;
		}
		else if (base == 2 && (c == '-' || c == '#')) 
		{
			digit = (c == '#') ? 1 : 0;
		}
		else {							/* invalid digit - should not be reached */
			error_syntax();
		}

		if (digit >= base) {			/* digit out of range - should not be reached */
			error_syntax();
		}
		
		value = value * base + digit;

		if ( ! range_err && value < 0 )	/* overflow to sign bit */
		{
			range_err = TRUE;		
			warn_int_range( value );
		}
	}
		
	return value;
}

/*-----------------------------------------------------------------------------
* Reset last token variables before each new scan
*----------------------------------------------------------------------------*/
static void reset_last_token(void)
{
	last_token = t_end;
	last_token_num = 0;
	g_string_truncate( last_token_str, 0 );
}

/*-----------------------------------------------------------------------------
* Get the scan position before a scan, to be able to set if afterwards to rollback
*----------------------------------------------------------------------------*/
int get_scan_pos( ScanState *self )
{
	return self->p - self->input->str;
}

void set_scan_pos( ScanState *self, int pos )
{
	self->p = CLAMP( self->input->str + pos,
					 self->input->str,
					 self->input->str + self->input->len );
	self->bol = (self->p == self->input->str) ? TRUE : FALSE;
}

/*-----------------------------------------------------------------------------
* Initialize the scanner to read the given string
*----------------------------------------------------------------------------*/
void start_scan( ScanState *self, GString *input )
{
	/* init state structure */
	self->input	= input;	
	self->bol   = TRUE;
	self->p		= input->str;
	self->pe	= input->str + input->len;
	self->eof	= self->pe;
	%% write init;

	reset_last_token();
}

/*-----------------------------------------------------------------------------
* Insert new text to scan in the input at the current position
*----------------------------------------------------------------------------*/
void insert_to_scan( ScanState *self, char *new_text )
{
	char 	*old_str;
	gssize 	 pos;
	
	/* take note of old str pointer, string may be expanded and relocated by insertion */
	old_str = self->input->str;
	
	/* insert new text at p, surounded by spaces */
	pos = self->p - old_str;
	g_string_insert( self->input, pos, "  ");
	g_string_insert( self->input, pos + 1, new_text);
	
	/* relocate pointers if needed */
	if ( old_str != self->input->str )
	{
		int delta = self->input->str - old_str;
		self->p   += delta;
		self->ts  += delta;
		self->te  += delta;
	}
	
	/* recompute end */
	self->pe = self->eof = self->input->str + self->input->len;
}

/*-----------------------------------------------------------------------------
* Get the next token, set last_token, last_token_value as side-effect
*----------------------------------------------------------------------------*/
enum token get_token( ScanState *self )
{
	reset_last_token();
	
	%% write exec;
	
	self->bol = (last_token == t_newline) ? TRUE : FALSE;
	
	return last_token;
}

/*
* $Log: scan.rl,v $
* Revision 1.1  2013-10-08 21:53:06  pauloscustodio
* Replace Flex-based lexer by a Ragel-based one.
* Add interface to file.c to read files by tokens, calling the lexer.
*
*
*/
