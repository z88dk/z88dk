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
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/scan.l,v 1.5 2013-04-14 20:47:27 pauloscustodio Exp $ */
/* $Log: scan.l,v $
/* Revision 1.5  2013-04-14 20:47:27  pauloscustodio
/* TOK_LABEL for a label definition, i.e. ".NAME" or "NAME:", with no spaces between symbols
/* colon to separate assembly statements in a line needs spaces.
/*
/* Revision 1.4  2013/04/14 18:16:58  pauloscustodio
/* Split scanner in several modules, allow token look-ahead to simplify
/* parser.
/*
/* Revision 1.3  2013/04/09 20:56:50  pauloscustodio
/* TOK_LABEL removed - identifying a label as XXX: has to be a parsing action in order to
/* distinguish a label from a continuation statement, e.g.
/* LABEL: ld a,VALUE : inc a ; LABEL is label, VALUE is name
/*
/* Revision 1.2  2013/03/31 18:28:30  pauloscustodio
/* New TOK_LABEL for a label definition, i.e. ". NAME" or "NAME :"
/*
/* Revision 1.1  2013/03/29 23:53:08  pauloscustodio
/* Added GNU Flex-based scanner. Not yet integrated into assembler.
/*
/*
/* */

#include "memalloc.h"	/* before any other include */

#define YY_NO_UNISTD_H	1		/* don't include unistd */

#ifndef SCAN_H
#define SCAN_H

#include "scan_context.h"
#include "scan_struct.h"
#include "scan_token.h"

/*-----------------------------------------------------------------------------
*   forward declarations
*----------------------------------------------------------------------------*/
struct Context;				/* YY_EXTRA_TYPE */
#define YY_DECL TokType yylex (Token *token, yyscan_t yyscanner)
extern YY_DECL;

/*-----------------------------------------------------------------------------
*   scan API
*----------------------------------------------------------------------------*/

/* Start reading file / text at current position */
extern void scan_file( char *filename );
extern void scan_text( char *text );

/* scan input for next token, return token type; 
   use scan_token(0) to get last returned token, only valid until next scan_get() call */
extern TokType scan_get( void );

/* get Nth token in the current context, NULL if none, 0 = current, 1 = next, ... */
extern Token *scan_token( int n );		

/* attributes of Nth token */
extern TokType scan_tok_type( int n );
extern long	   scan_num_value( int n );
extern char   *scan_str_value( int n );
extern char   *scan_filename( int n );
extern int 	   scan_line_nr( int n );

/* stack of nested constructs, i.e. IF / ELSE / ENDIF
   local to each input file, stack must be empty at the end of file */
extern void scan_push_struct( int id, int value );
extern int  scan_top_id( void );						
extern int  scan_top_value( void );
extern void scan_replace_struct( int id, int value );
extern void scan_pop_struct( int id );		/* syntaxt error if id != top_id */


#endif /* ndef SCAN_H */
}

%{
#include "codearea.h"
#include "ctype.h"
#include "die.h"
#include "errors.h"
#include "listfile.h"
#include "options.h"
#include "scan_context.h"
#include "scan_struct.h"
#include "scan_token.h"
#include "srcfile.h"
#include "strpool.h"
#include "strutil.h"
#include <io.h>

static long scan_num (char *text, int num_suffix_chars, int base);

/* handle line number */
#define YY_USER_ACTION 														\
	token->filename = context->filename;									\
	token->line_nr  = context->line_nr;										\
	if ( !clinemode )														\
	{																		\
		set_error_line( context->line_nr ); 								\
	}

/* return and set tok_type */	
#define YY_RETURN(x)														\
	return ( token->tok_type = (x) )

/* die on error */
#define YY_FATAL_ERROR(msg) 												\
	die( AssertionException, msg )

%}

/*-----------------------------------------------------------------------------
*	Options
*----------------------------------------------------------------------------*/
%option header-file="scan.h" outfile="scan.c"
%option case-insensitive 8bit 
%option pointer nounistd
%option warn noverbose 
%option reentrant noyywrap nodefault noyylineno 
%option noyyalloc noyyrealloc noyyfree
%option batch fast align never-interactive
%option extra-type="struct Context *"

NEWLINE	(\r|\n|\r\n|\n\r)
SPACE	[ \t\f]
ID		(af\'|[_a-z][_a-z0-9]*)
D2		[01]
D10		[0-9]
D16		[0-9a-f]

/*-----------------------------------------------------------------------------
*	Start conditions
*----------------------------------------------------------------------------*/

/* start condition active to read whole line for list before scanning tokens */
%x		READ_LINE		

/*-----------------------------------------------------------------------------
*	Rules
*----------------------------------------------------------------------------*/

%%
			Context *context = yyget_extra( yyscanner );
			
			/* setup state for listing, if first call of file or first call
			   after newline */
			if ( context->do_list )
			{
				BEGIN( READ_LINE );
			}

			/* process list */
<READ_LINE>[^\r\n]*{NEWLINE}?	{
				list_start_line( get_PC(), context->filename, context->line_nr, yytext );
				yyless( 0 );				/* push all text back to input */
				context->do_list = FALSE;
				BEGIN( INITIAL );
			}

			/* newline */
{NEWLINE}	{
				context->line_nr += context->line_inc;		/* count lines */
				if ( listing && context->file != NULL )
				{
					context->do_list = TRUE;				/* READ_LINE on next scan */
				}
				YY_RETURN(TOK_NEWLINE);
			}			

{SPACE}+	/* blanks */
;.* 		/* comment */


			/* Identifier */
{ID}		{
				Str_bset( token->str_value, yytext, yyleng ); 	
				strtoupper( Str_data( token->str_value ) );		
				YY_RETURN(TOK_NAME);
			}

			/* Label */
"."{ID}":"?	|
"."?{ID}":"	{
				/* trim starting dot and ending colon */
				if ( yytext[0] == '.' ) 
				{
					yytext++;
					yyleng--;
				}
				if ( yytext[yyleng-1] == ':' ) 
				{
					yyleng--;
				}
				Str_bset( token->str_value, yytext, yyleng ); 	
				strtoupper( Str_data( token->str_value ) );		
				YY_RETURN(TOK_LABEL);
			}

			/* String - return string without quotes */
[\'][^\'\r\n]*[\'] 	|
[\"][^\"\r\n]*[\"]	{
				Str_bset( token->str_value, yytext+1, yyleng-2 ); 	
				YY_RETURN(TOK_STRING);
			}

[\'][^\'\r\n]* 	|
[\"][^\"\r\n]*	error( ERR_UNCLOSED_STR );

			/* Number - return value in yyvalue */
{D10}+				token->num_value = scan_num(yytext,     0, 10); YY_RETURN(TOK_NUMBER);
{D10}{D16}*h		token->num_value = scan_num(yytext,     1, 16); YY_RETURN(TOK_NUMBER);
[\$\#]{D16}+		token->num_value = scan_num(yytext + 1, 0, 16); YY_RETURN(TOK_NUMBER);
0x{D16}+			token->num_value = scan_num(yytext + 2, 0, 16); YY_RETURN(TOK_NUMBER);
{D2}+b				token->num_value = scan_num(yytext,     1,  2); YY_RETURN(TOK_NUMBER);
[\@\%]{D2}+			token->num_value = scan_num(yytext + 1, 0,  2); YY_RETURN(TOK_NUMBER);
0b{D2}+				token->num_value = scan_num(yytext + 2, 0,  2); YY_RETURN(TOK_NUMBER);
[\@\%][\'][-#]+[\']	token->num_value = scan_num(yytext + 2, 1,  2); YY_RETURN(TOK_NUMBER);
[\@\%][\"][-#]+[\"]	token->num_value = scan_num(yytext + 2, 1,  2); YY_RETURN(TOK_NUMBER);
			
			/* multi-char tokens */			
"=="		YY_RETURN(TOK_EQUAL_EQUAL);
"<>"		YY_RETURN(TOK_LESS_GREATER);
"!="		YY_RETURN(TOK_NOT_EQUAL);
"<="		YY_RETURN(TOK_LESS_EQUAL);
">="		YY_RETURN(TOK_GREATER_EQUAL);
"||"		YY_RETURN(TOK_DBL_VBAR);
"&&"		YY_RETURN(TOK_DBL_AMPERSAND);
"<<"		YY_RETURN(TOK_DBL_LESS);
">>"		YY_RETURN(TOK_DBL_GREATER);
"**"		YY_RETURN(TOK_DBL_ASTERISK);

			/* default rule - one character token */
.			YY_RETURN((TokType)yytext[0]);

%%

/*-----------------------------------------------------------------------------
*	convert number to long, range error if greater than LONG_MAX
*----------------------------------------------------------------------------*/
static long scan_num (char *text, int num_suffix_chars, int base)
{
	long value;
	int digit;
	int length;
	char c;
	int i;
	
	/* ignore any suffix characters */
	length = strlen(text) - num_suffix_chars;
	
	value = 0;
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
			error( ERR_SYNTAX );
		}

		if (digit >= base) {			/* digit out of range - should not be reached */
			error( ERR_SYNTAX );
		}
		
		value = value * base + digit;
	}
	
	return value;
}

/*-----------------------------------------------------------------------------
*   Memory allocation used in scanner
*----------------------------------------------------------------------------*/
void *yyalloc( size_t bytes, yyscan_t scanner )
{
    return xmalloc( bytes );
}

void *yyrealloc( void *ptr, size_t bytes, yyscan_t scanner )
{
    return xrealloc( ptr, bytes );
}

void yyfree( void *ptr, yyscan_t scanner )
{
    xfree( ptr );
}

