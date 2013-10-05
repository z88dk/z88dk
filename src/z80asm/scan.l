%top{
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

Scanner - to be processed by: flex -L scan.l

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/scan.l,v 1.16 2013-10-05 10:54:36 pauloscustodio Exp $ 
$Log: scan.l,v $
Revision 1.16  2013-10-05 10:54:36  pauloscustodio
Parse command line options via look-up tables:
-I, --inc-path
-L, --lib-path

Revision 1.15  2013/10/05 08:14:43  pauloscustodio
Parse command line options via look-up tables:
-C, --line-mode

Revision 1.14  2013/10/01 23:23:53  pauloscustodio
Parse command line options via look-up tables:
-l, --list
-nl, --no-list

Revision 1.13  2013/09/24 00:05:36  pauloscustodio
Replaced chomp by g_strchomp; tolower by g_ascii_tolower;
toupper by g_ascii_toupper; stricompare by g_ascii_strcasecmp.
Removed normalize_eol.

Revision 1.12  2013/09/12 00:10:02  pauloscustodio
Create g_free0() macro that NULLs the pointer after free, required
by z80asm to find out if a pointer was already freed.

Revision 1.11  2013/09/08 08:29:21  pauloscustodio
Replaced xmalloc et al with g_malloc0 et al.

Revision 1.10  2013/09/08 00:43:59  pauloscustodio
New error module with one error function per error, no need for the error
constants. Allows compiler to type-check error message arguments.
Included the errors module in the init() mechanism, no need to call
error initialization from main(). Moved all error-testing scripts to
one file errors.t.

Revision 1.9  2013/05/01 21:10:49  pauloscustodio
Add getline to Str, converting EOL sequences to LF.

Revision 1.8  2013/05/01 19:03:45  pauloscustodio
Simplified scanner and adapted to be used with a BISON generated parser.
Removed balanced struct checking and token ring.
Removed start condition to list assembly lines, as it was difficult to keep in sync across included
files; inserted an RS char in the input before each line to trigger listing.
Allow ".NAME" and "NAME:" to return a NAME token, so that ".LD" is recognized as a label and not the LD assembly statement.
Added Integer out of range warning to number scanning routine.
Allow input lines to be any size, as long as memory can be allocated.
Created a skeleton BISON parser.

Revision 1.7  2013/04/23 19:23:14  pauloscustodio
Comments

Revision 1.6  2013/04/21 22:51:03  pauloscustodio
Include io.h only in MSVC

Revision 1.5  2013/04/14 20:47:27  pauloscustodio
TOK_LABEL for a label definition, i.e. ".NAME" or "NAME:", with no spaces between symbols
colon to separate assembly statements in a line needs spaces.

Revision 1.4  2013/04/14 18:16:58  pauloscustodio
Split scanner in several modules, allow token look-ahead to simplify
parser.

Revision 1.3  2013/04/09 20:56:50  pauloscustodio
TOK_LABEL removed - identifying a label as XXX: has to be a parsing action in order to
distinguish a label from a continuation statement, e.g.
LABEL: ld a,VALUE : inc a ; LABEL is label, VALUE is name

Revision 1.2  2013/03/31 18:28:30  pauloscustodio
New TOK_LABEL for a label definition, i.e. ". NAME" or "NAME :"

Revision 1.1  2013/03/29 23:53:08  pauloscustodio
Added GNU Flex-based scanner. Not yet integrated into assembler.

*/

#include "memalloc.h"			/* before any other include */

#define YY_NO_UNISTD_H	1		/* don't include unistd */

#ifndef SCAN_H
#define SCAN_H

#include "parse.h"
#include "types.h"
#include "file.h"

/*-----------------------------------------------------------------------------
*   scan API
*----------------------------------------------------------------------------*/

/* Start reading file / text at current position */
extern void scan_file( char *filename );
extern void scan_text( char *text );

/* Current location */
extern char *scan_filename( void );	/* NULL if no file open */
extern int   scan_line_nr( void );		/* 0 if no line number */

#endif /* ndef SCAN_H */
}

%{
#include "codearea.h"
#include "ctype.h"
#include "class.h"
#include "classlist.h"
#include "die.h"
#include "dynstr.h"
#include "errors.h"
#include "listfile.h"
#include "options.h"
#include "srcfile.h"
#include "strpool.h"
#include "strutil.h"
#include <stdio.h>

static long scan_num (char *text, int num_suffix_chars, int base);
int yylex_destroy (void);

/* die on error */
#define YY_FATAL_ERROR(msg) 										\
	die( msg )

/* input function to convert different eol sequences (\r\n, \r, \n) into \n 
   and insert a RS (0x30 - record separator) character before every line,
   used to read the whole line and call srclist */
int yy_input( char *buffer, size_t size );
#define YY_INPUT(buf,result,size) 	\
	(result) = yy_input( (char *) (buf), (size))

#define RS '\x1E'

/*-----------------------------------------------------------------------------
*   Scanner context
*----------------------------------------------------------------------------*/

/* Scanner context - current input file/buffer */
CLASS(Context)
	FILE   *file; 			/* current input file, NULL if reading from buffer */
	char   *filename;		/* point to filename in strpool */
	int 	line_nr;		/* current line number */
	
	Str    *buffer;			/* scan buffer */
	size_t	buffer_start;	/* point to first char in buffer, in case we read it
							   in chunks */
END_CLASS;
DEF_CLASS(Context);

void Context_init( Context *self )
{
	self->buffer = OBJ_NEW(Str);
	OBJ_AUTODELETE(self->buffer) = FALSE;
}

void Context_copy( Context *self, Context *other ) { }

void Context_fini( Context *self )	/* free resources */
{
	if ( self->file )
		xfclose( self->file );
	
	OBJ_DELETE(self->buffer);
}

Context *Context_create( FILE *file, char *filename, int line_nr )
{
	Context *self;

	/* allocate and init new context */
	self = OBJ_NEW(Context);
	self->file		= file;
	self->filename	= strpool_add(filename);
	self->line_nr	= line_nr;
	
	/* interface with errors */
	set_error_null();
	set_error_file( filename );   			/* error location */
	
	return self;
}

/* Scanner context - scack of contexts, top of stack is current */
CLASS_LIST(Context);
DEF_CLASS_LIST(Context);

static ContextList *contexts;

#define init_contexts() \
				( contexts != NULL ? \
				  contexts : \
				  ( contexts = OBJ_NEW(ContextList) ) )

static Context *top_context( void )
{
	init_contexts();
	
	return ContextList_empty( contexts ) ?
				NULL : 
				ContextList_last( contexts )->obj;
}

/* check circular includes, error if found */
static void check_circular_includes( char *filename ) 
{
	ContextListElem *iter;
	
	init_contexts();
	
	for ( iter = ContextList_last( contexts ) ; iter != NULL ; 
		  iter = ContextList_prev( iter ) )
	{
		if ( iter->obj->file != NULL &&			/* open file, not scanned text */
		     strcmp( filename, iter->obj->filename ) == 0 )
		{
            fatal_include_recursion( filename );
		}
	}
}	

/*-----------------------------------------------------------------------------
*   Call YY_destroy on exit
*----------------------------------------------------------------------------*/
CLASS(Scan)
END_CLASS;
DEF_CLASS(Scan);

static Scan *scan;

void Scan_init( Scan *self )
{
    /* force init contexts to make sure Contexts are destroyed before Scan */
    init_contexts();
}

void Scan_copy( Scan *self, Scan *other ) { }

void Scan_fini( Scan *self )	/* free resources */
{
	yylex_destroy();
}

#define init_scan() \
			( scan != NULL ? \
			  scan : \
			  ( scan = OBJ_NEW(Scan) ) )


%}

/*-----------------------------------------------------------------------------
*	Options
*----------------------------------------------------------------------------*/
%option header-file="scan.h" outfile="scan.c"
%option case-insensitive 8bit 
%option pointer nounistd
%option warn noverbose 
%option noyywrap nodefault noyylineno
%option noyyalloc noyyrealloc noyyfree
%option batch fast align never-interactive
%option bison-bridge

RS		\x1E
NEWLINE	\n
SPACE	[ \t\f\r]
ID		[_a-zA-Z][_a-zA-Z0-9]*
D2		[01]
D10		[0-9]
D16		[0-9a-fA-F]

/*-----------------------------------------------------------------------------
*	Rules
*----------------------------------------------------------------------------*/

%%
			Context *context = top_context();
			
			/* return unless a text is being read */
			if ( context == NULL )
				yyterminate();

			/* read whole line, increment line number */
{RS}.*{NEWLINE}	{
				context->line_nr++;
				if ( !opts.line_mode )
					set_error_line( context->line_nr );

				if ( opts.cur_list )
					list_start_line( get_PC(), 
									 context->filename, context->line_nr, 
									 yytext + 1 );
				yyless( 1 );				/* push all text except RS back to input */
			}

{SPACE}+	/* blanks */
;.*			/* comment */

			/* Identifier */
{ID}		strtoupper( yylval->sval = g_strdup( yytext ) ); return NAME;
"."{ID}		strtoupper( yylval->sval = g_strdup( yytext + 1 ) ); return NAME;
{ID}":"		strtoupper( yylval->sval = g_strdup( yytext ) ); yylval->sval[ yyleng - 1 ] = '\0';return NAME;

			/* String - return string without quotes */
[\'][^\'\r\n]*[\'] 	|
[\"][^\"\r\n]*[\"]	{
				yylval->sval = g_strdup( yytext + 1 );
				yylval->sval[ yyleng - 2 ] = '\0';
				return STRING;
			}

[\'][^\'\r\n]* 	|
[\"][^\"\r\n]*	error_unclosed_string();

			/* Number - return value in yylval */
{D10}+				yylval->lval = scan_num(yytext,     0, 10); return NUMBER;
{D10}{D16}*h		yylval->lval = scan_num(yytext,     1, 16); return NUMBER;
[\$\#]{D16}+		yylval->lval = scan_num(yytext + 1, 0, 16); return NUMBER;
0x{D16}+			yylval->lval = scan_num(yytext + 2, 0, 16); return NUMBER;
{D2}+b				yylval->lval = scan_num(yytext,     1,  2); return NUMBER;
[\@\%]{D2}+			yylval->lval = scan_num(yytext + 1, 0,  2); return NUMBER;
0b{D2}+				yylval->lval = scan_num(yytext + 2, 0,  2); return NUMBER;
[\@\%][\'][-#]+[\']	yylval->lval = scan_num(yytext + 2, 1,  2); return NUMBER;
[\@\%][\"][-#]+[\"]	yylval->lval = scan_num(yytext + 2, 1,  2); return NUMBER;
			
			/* multi-char tokens */			
"=="		return EQUAL_EQUAL;
"<>"		return LESS_GREATER;
"!="		return NOT_EQUAL;
"<="		return LESS_EQUAL;
">="		return GREATER_EQUAL;
"||"		return DBL_VBAR;
"&&"		return DBL_AMPERSAND;
"<<"		return DBL_LESS;
">>"		return DBL_GREATER;
"**"		return DBL_ASTERISK;

			/* default rule - one character token */
.|{NEWLINE}	return yytext[0];

			/* pop context at end of input */
<<EOF>> 	{
				/* pop context */
				set_error_null();
			
				yypop_buffer_state();		/* remove lex buffer */
				
				context = ContextList_pop( contexts );
				OBJ_DELETE(context);		/* remove context */
				
				context = top_context();	/* new top context */
				if ( context == NULL )
					yyterminate();			/* popped last context */
					
				set_error_file( context->filename );
				set_error_line( context->line_nr );
			}
%%

/*-----------------------------------------------------------------------------
*   Memory allocation used in scanner
*----------------------------------------------------------------------------*/
void *yyalloc( size_t bytes )
{
    return g_malloc0( bytes );
}

void *yyrealloc( void *ptr, size_t bytes )
{
    return g_realloc( ptr, bytes );
}

void yyfree( void *ptr )
{
    g_free0( ptr );
}

/*-----------------------------------------------------------------------------
*	convert number to long, range warning if greater than LONG_MAX
*----------------------------------------------------------------------------*/
static long scan_num (char *text, int num_suffix_chars, int base)
{
	long value;
	int digit = 0;
	int length;
	char c;
	int i;
	BOOL range_err;
	
	/* ignore any suffix characters */
	length = strlen(text) - num_suffix_chars;
	
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
		if ( value < 0 )
			range_err = TRUE;			/* overflow to sign bit */
	}
	
	if ( range_err )
		warn_int_range( value );
		
	return value;
}

/*-----------------------------------------------------------------------------
* 	input function to convert different eol sequences 
*	("\r\n", "\n\r", "\r", "\n") into "\n", add a terminating "\n" if not found 
*	in input, and insert a RS (0x30 - record separator) character before 
*	every line, used to read the whole line and call srclist.
*	Return when buffer is (almost)full, make sure a line is not split
*	between buffer and out of buffer
*----------------------------------------------------------------------------*/
int yy_input( char *buffer, size_t size )
{
	Context *context;
	char *buffer_ptr;
	size_t num_copy;

	/* get context */
	context = top_context();
	if ( context == NULL )
		return 0;								/* paranoid check */
	
	/* read until buffer full or eof */
	for ( buffer_ptr = buffer ; size >= 2 ; )	/* minimum line = RS LF */
	{
		/* fill context buffer with next line, if empty */
		if ( Str_len( context->buffer ) == 0 )
		{
			/* read one line, insert RS char in buffer if line found */
			if ( Str_getline( context->buffer, context->file ) )
			{
				*buffer_ptr++ = RS;
				size--;
			}
			context->buffer_start = 0;
		}
		
		/* check for end of input */
		if ( Str_len( context->buffer ) == 0 )
			break;

		/* return next chunk from input from buffer */
		num_copy = Str_len( context->buffer ) - context->buffer_start;
		if ( num_copy > size )
			num_copy = size;
		
		memcpy( buffer_ptr, Str_data( context->buffer ) + context->buffer_start, num_copy ); 
		buffer_ptr 				+= num_copy; 
		size 					-= num_copy;
		context->buffer_start 	+= num_copy;

		/* clear input buffer for next round */
		if ( context->buffer_start >= Str_len( context->buffer ) )
		{
			Str_clear( context->buffer );
			context->buffer_start = 0;
		}
	}
	
	return buffer_ptr - buffer;						/* number of chars read */
}


/*-----------------------------------------------------------------------------
*   Start reading file at current position
*----------------------------------------------------------------------------*/
void scan_file( char *filename )
{
	Context *context;
	FILE 	*file;
	
	init_scan();
	
	/* search source path */
	filename = search_file( filename, opts.inc_path );
	
	/* check for circular includes */
	check_circular_includes( filename );
	
	/* try to open the file */
	file = xfopen( filename, "rb" ); 		/* b: to ready \r and \n */

	/* create a new context */
	context = Context_create( file, filename, 0 );
	ContextList_push( contexts, context );
	
	/* save lexer state */
	yypush_buffer_state( yy_create_buffer( NULL, YY_BUF_SIZE ) );
}

/*-----------------------------------------------------------------------------
*   Start reading text at current position
*----------------------------------------------------------------------------*/
void scan_text( char *text )
{
	Context *context;
	Context *prev_context;
	char 	*prev_filename;
	int 	 prev_line_nr;
	YY_BUFFER_STATE temp_yy_buffer;
	
	init_scan();
	
	/* if already reading input, copy file and line_nr of last item in stack */
	prev_context  = top_context();
	if ( prev_context == NULL )
	{
		prev_filename = NULL;
		prev_line_nr  = 0;
	}
	else 
	{
		prev_filename = prev_context->filename;
		prev_line_nr  = prev_context->line_nr;
	}

	/* create a new context */
	context = Context_create( NULL, prev_filename, prev_line_nr );
	ContextList_push( contexts, context );
	
	/* make a copy of text and normalize eol sequences; yy_scan_string() will make  
	   a new copy of string */
	Str_szset( context->buffer, text );
	Str_chomp( context->buffer );
	Str_bcat( context->buffer, "\n\0\0", 3 );
	
	/* save lexer state - need to push a dummy created buffer, replaced afterwards
	   by yy_scan_buffer() because of bug in yy_scan_buffer(): overwrites last
       stack entry, destroying current context; then we yypush_buffer_state() getting
	   two copies of the buffer on the two top stack entries; when the top is 
	   destroyed by yy_pop_buffer_state(), we get an invalid buffer on the top
	   of the stack */
	temp_yy_buffer = yy_create_buffer( NULL, 2 );	/* very small buffer size */
	yypush_buffer_state( temp_yy_buffer );	
	yy_scan_buffer( Str_data( context->buffer ), Str_len( context->buffer ) );
	yy_delete_buffer( temp_yy_buffer );
}

/*-----------------------------------------------------------------------------
*   Current location
*----------------------------------------------------------------------------*/
char *scan_filename( void )
{
	Context *context = top_context();
	return context == NULL ? NULL : context->filename;
}

int scan_line_nr( void )
{
	Context *context = top_context();
	return context == NULL ? 0 : context->line_nr;
}
