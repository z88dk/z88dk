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

Define rules for a ragel-based scanner. Needs to be pre-preocessed before calling
ragel, to expand token definition from token_def.h.

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/scan_rules.rl,v 1.2 2014-03-30 10:39:51 pauloscustodio Exp $ 
*/

#define TOKEN(name, string)				 \
	string <CAT> i					<NL> \
	{								<NL> \
		<TAB>	tok = name;			<NL> \
		<TAB>	tok_text = string;	<NL> \
		<TAB>	fbreak; 			<NL> \
	};								<NL>

#define TOKEN2(name, string)	TOKEN(name, string)

#define KEYWORD(name, parser, value) 	 \
	#name <CAT> i					<NL> \
	{				 				<NL> \
		<TAB>	tok = TK_NAME; 		<NL> \
		<TAB>	tok_name = #name; 	<NL> \
		<TAB>	tok_parser = parser;<NL> \
		<TAB>	tok_number = value; <NL> \
		<TAB>	fbreak; 			<NL> \
	};								<NL>

%%{
machine asm;

/* check predicates - beginning of line */
action at_bol 		{ at_bol }	

/* Alpha numeric characters or underscore. */
alnum_u = alnum | '_';

/* Alpha characters or underscore. */
alpha_u = alpha | '_';

/* Name */
name = alpha_u alnum_u*;

/* Label */
label = "." [ \t]* name | name [ \t]* ":";

/* binary digit */
bdigit = [01];


/* STATE MACHINE */
main := |*
	
	/* Comment */
	';' [^\n]*  				; 
	
	/* Whitespace is standard ws, newlines and control codes */
	any - 0x21..0x7e - '\n'		;
	
	/* Identifier */
	name | "af'"i
	{
		tok = TK_NAME;
		set_tok_name();
		fbreak;
	};
	
	/* Label */
	label when at_bol
	{
		/* remove '.' and ':' */
		while ( ts[ 0] == '.' || isspace(ts[ 0]) ) ts++;
		while ( te[-1] == ':' || isspace(te[-1]) ) te--;
		
		/* copy token */
		tok = TK_LABEL;
		set_tok_name();
		fbreak;
	};
	
	/* Numbers - do not accept 'D' */
	digit+ /* 'd'i? */
	{ 
		/* remove 'D' 
		if ( toupper(te[-1]) == 'D' ) te--;
		*/
		
		tok = TK_NUMBER;
		tok_number = scan_num( ts, te - ts, 10 ); 
		fbreak;
	};
	digit xdigit* 'h'i
	{ 
		tok = TK_NUMBER;
		tok_number = scan_num( ts, te - ts - 1, 16 ); 
		fbreak;
	};
	"$" xdigit+
	{ 
		tok = TK_NUMBER;
		tok_number = scan_num( ts + 1, te - ts - 1, 16 ); 
		fbreak;
	};
	'0x'i xdigit+
	{ 
		tok = TK_NUMBER;
		tok_number = scan_num( ts + 2, te - ts - 2, 16 ); 
		fbreak;
	};
	bdigit+ 'b'i
	{ 
		tok = TK_NUMBER;
		tok_number = scan_num( ts, te - ts - 1, 2 ); 
		fbreak;
	};
	"@" bdigit+
	{ 
		tok = TK_NUMBER;
		tok_number = scan_num( ts + 1, te - ts - 1, 2 ); 
		fbreak;
	};
	'0b'i bdigit+
	{ 
		tok = TK_NUMBER;
		tok_number = scan_num( ts + 2, te - ts - 2, 2 ); 
		fbreak;
	};
	'@' '"' [\-#]+ '"'
	{ 
		tok = TK_NUMBER;
		tok_number = scan_num( ts + 2, te - ts - 3, 2 ); 
		fbreak;
	};
	
	/* Single Quote */
	"'"
	{ 
		tok = TK_NUMBER;
		if ( get_tok_string() && 		/* consumes input up to end quote or \n */
		     tok_string_buf->len == 1 )
		{
			tok_number = tok_string[0];
		}
		else
		{
			tok_number = 0;
			error_invalid_squoted_string(); 
		}
		fbreak;
	};
	
	/* Double Quote */
	'"'
	{ 
		tok = TK_STRING;
		if ( ! get_tok_string() )	/* consumes input up to end quote or \n */
			error_unclosed_string(); 
		fbreak;
	};
	

/* import token state machines */
#include "token_def.h"	
	
	/* default */
	any
	{
		tok = TK_NIL;
		skip_to_newline();
		fbreak;
	};
	
*|;
}%%

%% write data nofinal;

static void set_scan_buf( char *text, BOOL _at_bol )
{
	Str_set( input_buf, text );		/* sets p = input_buf->str */
	
	/* init state */
	at_bol  = _at_bol;
	pe		= input_buf->str + input_buf->len;
	eof		= pe;	/* tokens are not split acros input lines */
	
	%% write init;
}

static tokid_t _scan_get( void )
{
	%% write exec;
	return tok;
}
