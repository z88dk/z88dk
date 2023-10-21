/*
Z88DK Z80 Macro Assembler

Copyright (C) Paulo Custodio, 2011-2023
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

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

#define TOKEN_OPCODE_RE(name, string, regexp, set_value)	 \
	regexp									<NL> \
	{										<NL> \
		<TAB>	sym.tok        = name;		<NL> \
		<TAB>	sym.tok_opcode = name;		<NL> \
		<TAB>	set_value;					<NL> \
		<TAB>	expect_opcode  = false;		<NL> \
		<TAB>	fbreak; 					<NL> \
	};										<NL>

#define TOKEN(name, string, set_value)	\
		TOKEN_RE(name, string, string <CAT> i, set_value)

#define TOKEN2(name, string, set_value)	\
		TOKEN(name, string, set_value)

#define TOKEN_OPCODE1(opcode, string)	 \
	string <CAT> i										<NL> \
	{													<NL> \
		<TAB>		if (expect_opcode) {				<NL> \
		<TAB><TAB>		sym.tok        = TK_##opcode;	<NL> \
		<TAB><TAB>		sym.tok_opcode = TK_##opcode;	<NL> \
		<TAB><TAB>		expect_opcode  = false;			<NL> \
		<TAB>		}									<NL> \
		<TAB>		else {								<NL> \
		<TAB><TAB>		sym.tok        = TK_NAME;		<NL> \
		<TAB><TAB>		sym.tok_opcode = TK_##opcode;	<NL> \
		<TAB>		}									<NL> \
		<TAB>		fbreak; 							<NL> \
	};													<NL>

#define TOKEN_OPCODE(opcode)	 \
	TOKEN_OPCODE1(opcode, #opcode)

#define TOKEN_RABBIT1(opcode, string)	 \
	string <CAT> i										<NL> \
	{													<NL> \
		<TAB>		if ((option_cpu() == CPU_R2KA) || (option_cpu() == CPU_R3K) || \
                        (option_cpu() == CPU_R4K) || (option_cpu() == CPU_R5K)) {	<NL> \
		<TAB><TAB>		sym.tok        = TK_##opcode;	<NL> \
		<TAB>		}									<NL> \
		<TAB>		else {								<NL> \
		<TAB><TAB>		sym.tok        = TK_NAME;		<NL> \
		<TAB>		}									<NL> \
		<TAB>		fbreak; 							<NL> \
	};													<NL>

#define TOKEN_RABBIT(opcode)	 \
	TOKEN_RABBIT1(opcode, #opcode)

#define TOKEN_ZXN1(opcode, string)	 \
	string <CAT> i										<NL> \
	{													<NL> \
		<TAB>		if (option_cpu() == CPU_Z80N) {			<NL> \
		<TAB><TAB>		sym.tok        = TK_##opcode;	<NL> \
		<TAB>		}									<NL> \
		<TAB>		else {								<NL> \
		<TAB><TAB>		sym.tok        = TK_NAME;		<NL> \
		<TAB>		}									<NL> \
		<TAB>		fbreak; 							<NL> \
	};													<NL>

#define TOKEN_ZXN(opcode)	 \
	TOKEN_ZXN1(opcode, #opcode)

#define TOKEN_8085_1(opcode, string)	 \
	string <CAT> i										<NL> \
	{													<NL> \
		<TAB>		if (option_cpu() == CPU_8085) {		<NL> \
		<TAB><TAB>		sym.tok        = TK_##opcode;	<NL> \
		<TAB>		}									<NL> \
		<TAB>		else {								<NL> \
		<TAB><TAB>		sym.tok        = TK_NAME;		<NL> \
		<TAB>		}									<NL> \
		<TAB>		fbreak; 							<NL> \
	};													<NL>

#define TOKEN_8085(opcode)	 \
	TOKEN_8085_1(opcode, #opcode)

#define TOKEN_EZ80_1(opcode, string)	 \
	string <CAT> i										<NL> \
	{													<NL> \
		<TAB>		if (option_cpu() == CPU_EZ80 ||		<NL> \
					    option_cpu() == CPU_EZ80_Z80) {	<NL> \
		<TAB><TAB>		sym.tok        = TK_##opcode;	<NL> \
		<TAB>		}									<NL> \
		<TAB>		else {								<NL> \
		<TAB><TAB>		sym.tok        = TK_NAME;		<NL> \
		<TAB>		}									<NL> \
		<TAB>		fbreak; 							<NL> \
	};													<NL>

#define TOKEN_EZ80(opcode)	 \
	TOKEN_EZ80_1(opcode, #opcode)

%%{
machine lexer;

variable eof eof_;

/* check predicates - beginning of line */
action at_bol 		{ at_bol }	

/* horizontal white space */
hspace0 = (" " | "\t")*;
hspace1 = (" " | "\t")+;

/* Alpha numeric characters or underscore. */
alnum_u = alnum | '_';

/* Alpha characters or underscore. */
alpha_u = alpha | '_';

/* Name */
name = alpha_u alnum_u*;

/* Label */
label = "." hspace0 name | name hspace0 ":";

/* binary digit */
bdigit = [01];

/* index register suffix */
index_reg_suffix = hspace0 ( "+" | "-" | ")" );

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
		sym.number = 0;
		if ( get_sym_string() ) /* consumes input up to end quote or \n */
		{
			STR_DEFINE(string, STR_SIZE);
			
			Str_set_bytes(string, ts, te-ts);
			Str_len(string) = str_compress_escapes(Str_data(string));		/* process escape sequeneces */
			if (Str_len(string) == 1)
				sym.number = Str_data(string)[0];
			else
				error_invalid_char_const(); 
				
			STR_DELETE(string);
		}
		else
		{
			error_invalid_char_const(); 
		}
		ts = te = p;
		fbreak;
	};
	
	/* Double Quote */
	'"'
	{ 
		sym.tok = TK_STRING;
		if ( ! get_sym_string() )	/* consumes input up to end quote or \n */
			error_missing_quote(); 
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

static void set_scan_buf( const char *text, bool _at_bol )
{
	Str_set( input_buf, text );		
	p = Str_data(input_buf);
	
	/* init state */
	at_bol  = _at_bol;
	pe		= Str_data(input_buf) + Str_len(input_buf);
	eof_	= pe;	/* tokens are not split acros input lines */
	
	%%write init;
}

static tokid_t _scan_get( void )
{
	%%write exec;
	return sym.tok;
}
