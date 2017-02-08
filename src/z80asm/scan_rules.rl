/*
Z88-DK Z80ASM - Z80 Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

Define rules for a ragel-based scanner. Needs to be pre-preocessed before calling
ragel, to expand token definition from token_def.h.
*/

#define TOKEN_RE(name, string, regexp, set_value)	 \
	regexp									<NL> \
	{										<NL> \
		<TAB>	sym.tok = name;				<NL> \
		<TAB>	set_value;					<NL> \
		<TAB>	fbreak; 					<NL> \
	};										<NL>

#define TOKEN(name, string, set_value)	\
		TOKEN_RE(name, string, string <CAT> i, set_value)

#define TOKEN2(name, string, set_value)	\
		TOKEN(name, string, set_value)

#define TOKEN_OPCODE(opcode)	 \
	#opcode <CAT> i										<NL> \
	{													<NL> \
		<TAB>		if (expect_opcode) {				<NL> \
		<TAB><TAB>		sym.tok        = TK_##opcode;	<NL> \
		<TAB><TAB>		sym.tok_opcode = TK_##opcode;	<NL> \
		<TAB><TAB>		expect_opcode  = FALSE;			<NL> \
		<TAB>		}									<NL> \
		<TAB>		else {								<NL> \
		<TAB><TAB>		sym.tok        = TK_NAME;		<NL> \
		<TAB><TAB>		sym.tok_opcode = TK_##opcode;	<NL> \
		<TAB>		}									<NL> \
		<TAB>		fbreak; 							<NL> \
	};													<NL>

%%{
machine lexer;

/* check predicates - beginning of line */
action at_bol 		{ at_bol }	

/* horizontal white space */
hspace = (" " | "\t")*;

/* Alpha numeric characters or underscore. */
alnum_u = alnum | '_';

/* Alpha characters or underscore. */
alpha_u = alpha | '_';

/* Name */
name = alpha_u alnum_u*;

/* Label */
label = "." hspace name | name hspace ":";

/* binary digit */
bdigit = [01];

/* index register suffix */
index_reg_suffix = hspace ( "+" | "-" | ")" );

/* STATE MACHINE */
main := |*
	
	/* special names must come before 'Identifier */
#include "scan_def.h"	
	
	/* Comment */
	';' [^\n]*  				; 
	
	/* Whitespace is standard ws, newlines and control codes */
	any - 0x21..0x7e - '\n'		;
	
	/* Identifier */
	name
	{
		sym.tok = TK_NAME;
		/* set_tok_name(); */
		fbreak;
	};
	
	/* Label */
	label when at_bol
	{
		/* remove '.' and ':' */
		while ( ts[ 0] == '.' || isspace(ts[ 0]) ) ts++;
		while ( te[-1] == ':' || isspace(te[-1]) ) te--;
		
		/* copy token */
		sym.tok = TK_LABEL;
		/* set_tok_name(); */
		fbreak;
	};
	
	/* Numbers - do not accept 'D' */
	digit+ 
	{ 
		sym.tok = TK_NUMBER;
		sym.number = scan_num( ts, te - ts, 10 ); 
		ts = te = p;
		fbreak;
	};
	digit xdigit* 'h'i
	{ 
		sym.tok = TK_NUMBER;
		sym.number = scan_num( ts, te - ts - 1, 16 ); 
		ts = te = p;
		fbreak;
	};
	"$" xdigit+
	{ 
		sym.tok = TK_NUMBER;
		sym.number = scan_num( ts + 1, te - ts - 1, 16 ); 
		ts = te = p;
		fbreak;
	};
	'0x'i xdigit+
	{ 
		sym.tok = TK_NUMBER;
		sym.number = scan_num( ts + 2, te - ts - 2, 16 ); 
		ts = te = p;
		fbreak;
	};
	bdigit+ 'b'i
	{ 
		sym.tok = TK_NUMBER;
		sym.number = scan_num( ts, te - ts - 1, 2 ); 
		ts = te = p;
		fbreak;
	};
	[\@\%] bdigit+
	{ 
		sym.tok = TK_NUMBER;
		sym.number = scan_num( ts + 1, te - ts - 1, 2 ); 
		ts = te = p;
		fbreak;
	};
	'0b'i bdigit+
	{ 
		sym.tok = TK_NUMBER;
		sym.number = scan_num( ts + 2, te - ts - 2, 2 ); 
		ts = te = p;
		fbreak;
	};
	[\@\%] '"' [\-#]+ '"'
	{ 
		sym.tok = TK_NUMBER;
		sym.number = scan_num( ts + 2, te - ts - 3, 2 ); 
		ts = te = p;
		fbreak;
	};
	
	/* Single Quote */
	"'"
	{ 
		sym.tok = TK_NUMBER;
		if ( get_sym_string() && 		/* consumes input up to end quote or \n */
		     /* sym_string->len */ te - ts == 1 )
		{
			sym.number = *ts; //sym_string->str[0];
		}
		else
		{
			sym.number = 0;
			error_invalid_squoted_string(); 
		}
		ts = te = p;
		fbreak;
	};
	
	/* Double Quote */
	'"'
	{ 
		sym.tok = TK_STRING;
		if ( ! get_sym_string() )	/* consumes input up to end quote or \n */
			error_unclosed_string(); 
		fbreak;
	};
	
	/* default */
	any
	{
		sym.tok = TK_NIL;
		skip_to_newline();
		ts = te = p;
		fbreak;
	};
	
*|;
}%%

%%write data nofinal;

static void set_scan_buf( char *text, Bool _at_bol )
{
	str_set( input_buf, text );		
	p = str_data(input_buf);
	
	/* init state */
	at_bol  = _at_bol;
	pe		= str_data(input_buf) + str_len(input_buf);
	eof		= pe;	/* tokens are not split acros input lines */
	
	%%write init;
}

static tokid_t _scan_get( void )
{
	%%write exec;
	return sym.tok;
}
