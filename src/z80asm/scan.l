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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/scan.l,v 1.2 2013-03-31 18:28:30 pauloscustodio Exp $ */
/* $Log: scan.l,v $
/* Revision 1.2  2013-03-31 18:28:30  pauloscustodio
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

#include "class.h"
#include "classlist.h"
#include "dynstr.h"

/*-----------------------------------------------------------------------------
*   Token Type
*----------------------------------------------------------------------------*/
typedef enum TokType
{
	/* mark end of input */
	TOK_NULL			= 0,
	
    /* single character tokens */
    TOK_NEWLINE         = '\n',
	
    TOK_EXCLAM          = '!',
    TOK_HASH            = '#',
    TOK_DOLLAR          = '$',
    TOK_PERCENT         = '%',
    TOK_AMPERSAND       = '&',
    TOK_LPAREN          = '(',
    TOK_RPAREN          = ')',
    TOK_ASTERISK        = '*',
    TOK_PLUS            = '+',
    TOK_COMMA           = ',',
    TOK_HYPHEN          = '-',
    TOK_PERIOD          = '.',
    TOK_SLASH           = '/',
    TOK_COLON           = ':',
    TOK_LESS            = '<',
    TOK_EQUAL           = '=',
    TOK_GREATER         = '>',
    TOK_QUESTION        = '?',
    TOK_ATSIGN          = '@',
    TOK_LSQUARE         = '[',
    TOK_BACKSLASH       = '\\',
    TOK_RSQUARE         = ']',
    TOK_CARET           = '^',
    TOK_BACKQUOTE       = '`',
    TOK_LCURLY          = '{',
    TOK_VBAR            = '|',
    TOK_RCURLY          = '}',
    TOK_TILDE           = '~',
	
    /* multi-character tokens */
    TOK_EQUAL_EQUAL     = 0x100,/* "==" */
    TOK_LESS_GREATER,           /* "<>" */
    TOK_NOT_EQUAL,              /* "!=" */
    TOK_LESS_EQUAL,             /* "<=" */
    TOK_GREATER_EQUAL,          /* ">=" */
    TOK_DBL_VBAR,               /* "||" */
    TOK_DBL_AMPERSAND,          /* "&&" */
    TOK_DBL_LESS,               /* "<<" */
    TOK_DBL_GREATER,            /* ">>" */
    TOK_DBL_ASTERISK,           /* "**" */

    /* language tokens */
    TOK_NAME,                   /* any identifier */
    TOK_LABEL,                  /* label definition, i.e. ". NAME" or "NAME :" */
    TOK_NUMBER,
    TOK_STRING,                 /* single- or double-quoted string */
    TOK_PREPROC,                /* preprocessor command */

} TokType;

/*-----------------------------------------------------------------------------
*   Token and list of tokens
*----------------------------------------------------------------------------*/
CLASS(Token)
	TokType	tok_type;			/* type of token */
	long	num_value;			/* numeric value, if any */
	Str	   *str_value;			/* string value, if any */
	char   *filename;			/* file name - kept in strpool */
	int 	line_nr;			/* input line number */
END_CLASS;

CLASS_LIST(Token);

/*-----------------------------------------------------------------------------
*   API - uses srcfile.h singleton API
*----------------------------------------------------------------------------*/

/* Start reading file / text at current position */
extern void scan_file( char *filename );
extern void scan_text( char *text );

/* scan input for next token, return token type; 
   use scan_xxx() to last returned token attributes, only valid until next
   scan_get()/scan_unget() call */
extern TokType scan_get( void );
extern TokType scan_tok_type( void );
extern long	   scan_num_value( void );
extern char   *scan_str_value( void );
extern char   *scan_filename( void );
extern int 	   scan_line_nr( void );

/* push back token to input stream */
extern void scan_unget( TokType tok_type, long num_value, char *str_value,
						char *filename, int line_nr );

/* stack of nested constructs, i.e. IF / ELSE / ENDIF
   local to each input file, stack must be empty at the end of file */
extern void scan_push_struct( int id, int value );
extern int  scan_top_id( void );						
extern int  scan_top_value( void );
extern void scan_replace_struct( int id, int value );
extern void scan_pop_struct( int id );		/* syntaxt error if id != top_id */

/* forward declaration for YY_EXTRA_TYPE */
struct Context;

#endif /* ndef SCAN_H */

}

%{
#include "codearea.h"
#include "ctype.h"
#include "die.h"
#include "errors.h"
#include "listfile.h"
#include "options.h"
#include "srcfile.h"
#include "strutil.h"
#include "strpool.h"

/*-----------------------------------------------------------------------------
*   Types
*----------------------------------------------------------------------------*/

/* Stack of nested constructs on each context */
CLASS(Struct)
	int		id;					/* user-defined ID */
	int		value;				/* user-defined VALUE */
	int		line_nr;			/* line where struct started */
END_CLASS;
CLASS_LIST(Struct);

/* Scanner context - current input file/buffer */
CLASS(Context)
	yyscan_t	scanner;		/* current scanner object */

	FILE   *file; 				/* file handle */
	char   *filename;			/* file name - kept in strpool so that it is 
								   available after file has been closed */
	int 	line_nr;			/* input line number */
	int 	line_inc;			/* increment line number on each newline */
	
	BOOL	do_list;			/* true to output list lines */

	StructList *struct_stack;	/* stack of open structs, empty if none */
	
END_CLASS;

/* Scanner context - scack of contexts, top of stack is current */
CLASS_LIST(Context);

/* List of tokens for unget queue */

/* Scanner global data */
CLASS(Scan)
	ContextList	*contexts;			/* stack of input contexts */
	TokenList	*token_queue;		/* stack of pushed-back tokens */
	Token		*token;				/* last token */
END_CLASS;

/*-----------------------------------------------------------------------------
*   Globals
*----------------------------------------------------------------------------*/
static Scan *scan = NULL;

/*-----------------------------------------------------------------------------
*   Forward declatations
*----------------------------------------------------------------------------*/
static long scan_num (char *text, int num_suffix_chars, int base);
static Context *get_context( void );

/* init_scan() implemented as macro */
#define init_scan() if ( scan == NULL ) scan = OBJ_NEW( Scan )


/*-----------------------------------------------------------------------------
*   Configure scanner
*----------------------------------------------------------------------------*/

/* handle line number */
#define YY_USER_ACTION 														\
	scan->token->filename = context->filename;								\
	scan->token->line_nr  = context->line_nr;								\
	if ( !clinemode )														\
	{																		\
		set_error_line( scan->token->line_nr ); 							\
	}
	
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
			Token   *token   = scan->token;
			
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
				return TOK_NEWLINE;
			}			

{SPACE}+	/* blanks */
;.* 		/* comment */


			/* Identifier */
{ID}		{
				Str_bset( token->str_value, yytext, yyleng ); 	
				strtoupper( Str_data( token->str_value ) );		
				return TOK_NAME;
			}

			/* Label */
"."{SPACE}*{ID}{SPACE}*":"?	|
"."?{SPACE}*{ID}{SPACE}*":"	{
				/* trim starting dot and ending colon */
				while ( yytext[0] == '.' || isspace( yytext[0] ) ) 
				{
					yytext++;
					yyleng--;
				}
				while ( yytext[yyleng-1] == ':' || isspace( yytext[yyleng-1] ) ) 
				{
					yyleng--;
				}
				Str_bset( token->str_value, yytext, yyleng ); 	
				strtoupper( Str_data( token->str_value ) );		
				return TOK_LABEL;
			}

			/* String - return string without quotes */
[\'][^\'\r\n]*[\'] 	|
[\"][^\"\r\n]*[\"]	{
				Str_bset( token->str_value, yytext+1, yyleng-2 ); 	
				return TOK_STRING;
			}

[\'][^\'\r\n]* 	|
[\"][^\"\r\n]*	error( ERR_UNCLOSED_STR );

			/* Number - return value in yyvalue */
{D10}+				token->num_value = scan_num(yytext,     0, 10); return TOK_NUMBER;
{D10}{D16}*h		token->num_value = scan_num(yytext,     1, 16); return TOK_NUMBER;
[\$\#]{D16}+		token->num_value = scan_num(yytext + 1, 0, 16); return TOK_NUMBER;
0x{D16}+			token->num_value = scan_num(yytext + 2, 0, 16); return TOK_NUMBER;
{D2}+b				token->num_value = scan_num(yytext,     1,  2); return TOK_NUMBER;
[\@\%]{D2}+			token->num_value = scan_num(yytext + 1, 0,  2); return TOK_NUMBER;
0b{D2}+				token->num_value = scan_num(yytext + 2, 0,  2); return TOK_NUMBER;
[\@\%][\'][-#]+[\']	token->num_value = scan_num(yytext + 2, 1,  2); return TOK_NUMBER;
[\@\%][\"][-#]+[\"]	token->num_value = scan_num(yytext + 2, 1,  2); return TOK_NUMBER;
			
			/* multi-char tokens */			
"=="		return TOK_EQUAL_EQUAL;
"<>"		return TOK_LESS_GREATER;
"!="		return TOK_NOT_EQUAL;
"<="		return TOK_LESS_EQUAL;
">="		return TOK_GREATER_EQUAL;
"||"		return TOK_DBL_VBAR;
"&&"		return TOK_DBL_AMPERSAND;
"<<"		return TOK_DBL_LESS;
">>"		return TOK_DBL_GREATER;
"**"		return TOK_DBL_ASTERISK;

			/* default rule - one character token */
.			return (TokType)yytext[0];

%%

/*-----------------------------------------------------------------------------
*   Token
*----------------------------------------------------------------------------*/
DEF_CLASS(Token);
DEF_CLASS_LIST(Token);

void Token_init( Token *self ) 
{
    /* force init strpool to make sure Context is destroyed before StrPool */
    strpool_init();

	self->str_value = OBJ_NEW(Str);
	OBJ_AUTODELETE( self->str_value ) = FALSE;
}

void Token_copy( Token *self, Token *other )
{
	self->str_value = Str_clone( other->str_value );
}

void Token_fini( Token *self ) 
{ 
	OBJ_DELETE( self->str_value );
}

/* set a token by copy of another */
void Token_set( Token *self, Token *other )
{
	self->tok_type	= other->tok_type;
	self->num_value	= other->num_value;
	
	Str_set( self->str_value, other->str_value );
	
	self->filename	= other->filename;	/* point to same strpool area */
	self->line_nr	= other->line_nr;
}

/* clear a token */
void Token_clear( Token *self )
{
	self->tok_type	= TOK_NULL;
	self->num_value	= 0;
	
	Str_clear( self->str_value );
	
	self->filename	= NULL;
	self->line_nr	= 0;
}

/*-----------------------------------------------------------------------------
*   Stack of nested constructs
*----------------------------------------------------------------------------*/
DEF_CLASS(Struct);
DEF_CLASS_LIST(Struct);

void Struct_init( Struct *self ) { }

void Struct_copy( Struct *self, Struct *other ) { }

void Struct_fini( Struct *self ) { }

/* push start of new struct to stack, fatal error if no context */
void scan_push_struct( int id, int value )
{
	Context	*context;
	Struct  *elem;
	
	init_scan();
	
	context = get_context();
	if ( context == NULL )
	{
		error( ERR_UNBALANCED_STRUCT );
	}
	else 
	{
		elem = OBJ_NEW( Struct );
		elem->id 		= id;
		elem->value 	= value;
		elem->line_nr	= context->line_nr;
		
		StructList_push( context->struct_stack, elem );
	}
}

static Struct *scan_top( void )
{
	Context	*context;

	init_scan();
	
	context = get_context();
	if ( context == NULL || StructList_empty( context->struct_stack ) )
	{
		error( ERR_UNBALANCED_STRUCT );
		return NULL;
	}
	else
	{
		return StructList_last( context->struct_stack )->obj;
	}
}

/* return ID of top of struct stack, -1 if none */
int scan_top_id( void )						
{
	Struct *elem = scan_top();
	return elem ? elem->id : -1;
}

/* return VALUE of top of struct stack, -1 if none */
int scan_top_value( void )
{
	Struct *elem = scan_top();
	return elem ? elem->value : -1;
}

/* replace ID, VALUE of top element, e.g replace IF by ELSE */
void scan_replace_struct( int id, int value )
{
	Context	*context;
	Struct  *elem;
	
	init_scan();
	
	context = get_context();
	if ( context == NULL )
	{
		error( ERR_UNBALANCED_STRUCT );
	}
	else 
	{
		elem = scan_top();
		elem->id 		= id;
		elem->value 	= value;
		elem->line_nr	= context->line_nr;
	}
}

/* pop top element, syntaxt error if id != top_id */
void scan_pop_struct( int id )
{
	Context	*context;
	Struct  *elem;
	
	init_scan();
	
	context = get_context();
	if ( context == NULL || StructList_empty( context->struct_stack ) )
	{
		error( ERR_UNBALANCED_STRUCT );
	}
	else 
	{
		elem = StructList_pop( context->struct_stack );
		if ( elem->id != id ) 
		{
			error( ERR_UNBALANCED_STRUCT_AT, 
				   elem->line_nr );
		}
		
		OBJ_DELETE( elem );	
	}
}


/*-----------------------------------------------------------------------------
*   Scanner context - current input file/buffer
*----------------------------------------------------------------------------*/
DEF_CLASS(Context);
DEF_CLASS_LIST(Context);

void Context_init( Context *self )	/* only init non-null items */
{
    /* force init strpool to make sure Context is destroyed before StrPool */
    strpool_init();
	
	self->struct_stack = OBJ_NEW( StructList );
	OBJ_AUTODELETE( self->struct_stack ) = FALSE;
}

void Context_copy( Context *self, Context *other ) { }

void Context_fini( Context *self )	/* free resources */
{
	if ( self->scanner ) {
		yylex_destroy( self->scanner );
	}
	
	if ( self->file )
	{
		fclose( self->file );
	}
	
	OBJ_DELETE( self->struct_stack );
}

/* create a new context and switch yylex to its buffer */
Context *Context_create( FILE *file, char *filename, int line_nr, int line_inc )
{
	Context *self;

	/* allocate and init new context */
	self = OBJ_NEW(Context);
	self->file		= file;
	self->filename	= strpool_add(filename);
	self->line_nr	= line_nr;
	self->line_inc	= line_inc;
	
	/* init a new scanner */
	yylex_init_extra( self, &self->scanner );
	
	/* interface with errors */
	set_error_null();
	set_error_file( filename );   			/* error location */
	
	return self;
}

/* return current context */
static Context *get_context( void )
{
	init_scan();
	
	if ( ContextList_empty( scan->contexts ) )
		return NULL;
	else
		return ContextList_last( scan->contexts )->obj;
}

/* pop the stack of input files, return TRUE to continue reading, FALSE on end */
static BOOL pop_context( void ) 
{
	Context *context;
	
	init_scan();
	
	/* interface with errors */
	set_error_null();

	context = ContextList_pop( scan->contexts );
	if ( context == NULL )
	{
		return FALSE;					/* no more input */
	}
	else 
	{
		/* destroy context */
		OBJ_DELETE( context );
		
		/* switch to previous context, if any */
		context = get_context();
		if ( context == NULL )
		{
			return FALSE;				/* no more input */
		}
		else 
		{
			/* interface with errors */
			set_error_file( context->filename );
			set_error_line( context->line_nr );

			return TRUE;				/* continue scanning */
		}
	}
}

/*-----------------------------------------------------------------------------
*	Scanner global data
*----------------------------------------------------------------------------*/
DEF_CLASS(Scan);

void Scan_init( Scan *self ) 
{
    /* force init strpool to make sure Context is destroyed before StrPool */
    strpool_init();

	self->contexts = OBJ_NEW( ContextList );
	OBJ_AUTODELETE( self->contexts ) = FALSE;
	
	self->token_queue = OBJ_NEW( TokenList );
	OBJ_AUTODELETE( self->token_queue ) = FALSE;
	
	self->token = OBJ_NEW( Token );
	OBJ_AUTODELETE( self->token ) = FALSE;
}

void Scan_copy( Scan *self, Scan *other ) { }

void Scan_fini( Scan *self ) 
{ 
	OBJ_DELETE( self->contexts );
	OBJ_DELETE( self->token_queue );
	OBJ_DELETE( self->token );
}

/*-----------------------------------------------------------------------------
*   Get / Unget token
*----------------------------------------------------------------------------*/

/* scan input for next token, set scan->token with last token value */
TokType scan_get( void )
{
	Context	*context;
	Token 	*token;
	Struct  *elem;

	init_scan();

	/* init scan->token */
	Token_clear( scan->token );
	
	/* get token from queue */
	token = TokenList_pop( scan->token_queue );
	if ( token != NULL )
	{
		Token_set( scan->token, token );
		OBJ_DELETE( token );
	}
	else
	{
		/* loop until input ended for all existing contexts, or token found */
		while ( (context = get_context()) != NULL )
		{
			if ( ( scan->token->tok_type = yylex( context->scanner ) ) != TOK_NULL )
			{
				break;					/* found input */
			}
			
			/* check for open structs */
			while ( (elem = StructList_pop( context->struct_stack )) != NULL )
			{
				error( ERR_UNBALANCED_STRUCT_AT, 
					   elem->line_nr );
				OBJ_DELETE( elem );
			}
			
			pop_context();				/* pop top context, clear error location */
		}
	}
	
	return scan->token->tok_type;
}


/* unget the given token to the list */
void scan_unget( TokType tok_type, long num_value, char *str_value,
				 char *filename, int line_nr )
{
	Token *token;

	init_scan();
	
	/* init token object */
	token = OBJ_NEW(Token);
	token->tok_type		= tok_type;
	token->num_value	= num_value;
	
	Str_szset( token->str_value, str_value ? str_value : "" );	/* copy string */
	Str_unreserve( token->str_value );			/* reclaim extra memory for queue */
	
	token->filename 	= strpool_add( filename );
	token->line_nr		= line_nr;
	
	/* set last token */
	Token_set( scan->token, token );
	
	TokenList_push( scan->token_queue, token );
}

/*-----------------------------------------------------------------------------
*   Get last token
*----------------------------------------------------------------------------*/
TokType scan_tok_type( void )
{
	init_scan();
	return scan->token->tok_type;
}

long scan_num_value( void )
{
	init_scan();
	return scan->token->num_value;
}

char *scan_str_value( void )
{
	init_scan();
	return Str_data( scan->token->str_value );
}

char *scan_filename( void )
{
	init_scan();
	return scan->token->filename;
}

int scan_line_nr( void )
{
	init_scan();
	return scan->token->line_nr;
}

/*-----------------------------------------------------------------------------
*	Context stack
*----------------------------------------------------------------------------*/

/* check circular includes, error if found */
static void check_circular_includes( char *filename ) 
{
	ContextListElem *iter;
	
	for ( iter = ContextList_first( scan->contexts ) ; iter != NULL ; 
		  iter = ContextList_next( iter ) )
	{
		if ( iter->obj->file != NULL &&			/* open file, not scanned text */
		     strcmp( filename, iter->obj->filename ) == 0 )
		{
            fatal_error( ERR_INCLUDE_RECURSION, filename );
		}
	}
}	

/* create a context to scan a file */
void scan_file( char *filename ) 
{
	FILE 	*file;
	Context	*context;
	
	init_scan();
	
	/* search source path */
	filename = search_source_file( filename );
	
	/* check for circular includes */
	check_circular_includes( filename );
	
	/* try to open the file */
	file = fopen( filename, "rb" ); 		/* b: to ready \r and \n */
	if ( file == NULL ) 
	{
		fatal_error( ERR_FOPEN_READ, filename );
	}

	/* create new flex instance */
	context = Context_create( file, filename, 1, 1 );
	ContextList_push( scan->contexts, context );
	
	/* set input file */
	yyset_in( file, context->scanner );
	
	/* prepare for list */
	if ( listing )
	{
		context->do_list = TRUE;
	}
}

/* create a context to scan a text block */
void scan_text( char *text )
{
	Context 	   *context, *prev_context;
	char 		   *prev_filename;
	int 			prev_line_nr;
	
	init_scan();
	
	/* if already reading input, copy file and line_nr of last item in stack */
	prev_context = get_context();
	prev_filename = prev_context != NULL ? prev_context->filename : NULL;
	prev_line_nr  = prev_context != NULL ? prev_context->line_nr  : 0;

	/* create new flex instance */
	context = Context_create( NULL, prev_filename, prev_line_nr, 0 );
	ContextList_push( scan->contexts, context );
	
	/* switch to text buffer */
	yy_scan_string( text, context->scanner );
}

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

