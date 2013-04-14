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

Scanner context - current input file/buffer

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/scan_context.c,v 1.1 2013-04-14 18:16:58 pauloscustodio Exp $
$Log: scan_context.c,v $
Revision 1.1  2013-04-14 18:16:58  pauloscustodio
Split scanner in several modules, allow token look-ahead to simplify
parser.


*/

#include "memalloc.h"	/* before any other include */

#include "errors.h"
#include "options.h"
#include "scan.h"
#include "scan_context.h"
#include "scan_struct.h"
#include "srcfile.h"
#include "strpool.h"
#include <stdio.h>

/*-----------------------------------------------------------------------------
*   Global data with list of contexts
*----------------------------------------------------------------------------*/
ContextList *contexts;

#define init_contexts()	if (contexts == NULL) contexts = OBJ_NEW(ContextList); else {}

static Context *get_context( void );

/*-----------------------------------------------------------------------------
*   Scanner context
*----------------------------------------------------------------------------*/

DEF_CLASS(Context);
DEF_CLASS_LIST(Context);

void Context_init( Context *self )	/* only init non-null items */
{
    /* force init strpool to make sure Context is destroyed before StrPool */
    strpool_init();
	
	self->struct_stack = OBJ_NEW( StructList );
	OBJ_AUTODELETE( self->struct_stack ) = FALSE;
	
	self->tokens = OBJ_NEW( TokenRing );
	OBJ_AUTODELETE( self->tokens ) = FALSE;
	
	self->first_time = TRUE;		/* so that scan_get() does not discard first token */
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
	OBJ_DELETE( self->tokens );
}

/*-----------------------------------------------------------------------------
*   create a new context and init yylex
*----------------------------------------------------------------------------*/
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

/*-----------------------------------------------------------------------------
*	Return address of token N in tokens ring, 
*	return NULL if input exhausted or ring full
*----------------------------------------------------------------------------*/
static Token *Context_get_token( Context *self, int n )
{
	Token *token;
	TokType token_type;
	
	while ( TRUE ) 
	{
		token = TokenRing_get( self->tokens, n );
		if ( token != NULL )
		{
			return token;						/* already in ring */
		}
		
		/* get next token from input */
		token = TokenRing_push( self->tokens );
		if ( token == NULL )
		{
			return NULL;						/* ring full */
		}

		token_type = yylex( token, self->scanner );
		
		if ( token_type == TOK_NULL )			/* no more input */
		{
			TokenRing_pop( self->tokens );		/* discard token just pushed */
			return NULL;
		}

		/* go back as N may be > 0 and we may need top get more tokens */
	}	
}

/*-----------------------------------------------------------------------------
*   return current context
*----------------------------------------------------------------------------*/
static Context *get_context( void )
{
	init_contexts();
	
	if ( ContextList_empty( contexts ) )
		return NULL;
	else
		return ContextList_last( contexts )->obj;
}

/*-----------------------------------------------------------------------------
*   pop the stack of input files
*	return TRUE to continue reading, FALSE on end
*----------------------------------------------------------------------------*/
static BOOL pop_context( void ) 
{
	Context *context;
	
	init_contexts();
	
	/* interface with errors */
	set_error_null();

	context = ContextList_pop( contexts );
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
*	check circular includes, error if found
*----------------------------------------------------------------------------*/
static void check_circular_includes( char *filename ) 
{
	ContextListElem *iter;
	
	init_contexts();
	
	for ( iter = ContextList_first( contexts ) ; iter != NULL ; 
		  iter = ContextList_next( iter ) )
	{
		if ( iter->obj->file != NULL &&			/* open file, not scanned text */
		     strcmp( filename, iter->obj->filename ) == 0 )
		{
            fatal_error( ERR_INCLUDE_RECURSION, filename );
		}
	}
}	

/*-----------------------------------------------------------------------------
*	create a context to scan a file
*----------------------------------------------------------------------------*/
void scan_file( char *filename ) 
{
	FILE 	*file;
	Context	*context;
	
	init_contexts();
	
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
	ContextList_push( contexts, context );
	
	/* set input file */
	yyset_in( file, context->scanner );
	
	/* prepare for list */
	if ( listing )
	{
		context->do_list = TRUE;
	}
}

/*-----------------------------------------------------------------------------
*	create a context to scan a text block
*----------------------------------------------------------------------------*/
void scan_text( char *text )
{
	Context *context, *prev_context;
	char 	*prev_filename;
	int 	 prev_line_nr;
	
	init_contexts();
	
	/* if already reading input, copy file and line_nr of last item in stack */
	prev_context = get_context();
	prev_filename = prev_context != NULL ? prev_context->filename : NULL;
	prev_line_nr  = prev_context != NULL ? prev_context->line_nr  : 0;

	/* create new flex instance */
	context = Context_create( NULL, prev_filename, prev_line_nr, 0 );
	ContextList_push( contexts, context );
	
	/* switch to text buffer */
	yy_scan_string( text, context->scanner );
}

/*-----------------------------------------------------------------------------
*	scan input for next token, leave it at head of tokens
*----------------------------------------------------------------------------*/
TokType scan_get( void )
{
	Context	*context;
	Token   *token;
	Struct  *elem;

	init_contexts();

	/* loop until input ended for all existing contexts, or token found */
	while ( TRUE ) 
	{
		context = get_context();
		if ( context == NULL )
		{
			return TOK_NULL;			/* no more input */
		}
		
		/* drop first token, except first time - was the current token */
		if ( ! context->first_time )
		{
			TokenRing_shift( context->tokens );
		}
		else
		{
			context->first_time = FALSE;
		}
		
		/* get token N=0 - call yylex if ring is empty */
		token = Context_get_token( context, 0 );
		if ( token != NULL )
		{
			return token->tok_type;		/* found token */
		}
		
		/* no more input in this context, check for open structs */
		while ( TRUE )
		{
			elem = StructList_pop( context->struct_stack );
			if ( elem == NULL )
			{
				break;
			}
			error( ERR_UNBALANCED_STRUCT_AT, elem->line_nr );
			OBJ_DELETE( elem );
		}
		
		/* pop top context, clear error location */
		pop_context();
	}
}

/*-----------------------------------------------------------------------------
*   Get Nth token, NULL if none
*----------------------------------------------------------------------------*/
Token *scan_token( int n )
{
	Context	*context = get_context();
	return context == NULL ? NULL : Context_get_token( context, n );
}

/*-----------------------------------------------------------------------------
*   Get Nth token attributes
*----------------------------------------------------------------------------*/
TokType scan_tok_type( int n )
{
	Token *token = scan_token( n );
	return token == NULL ? TOK_NULL : token->tok_type;
}

long scan_num_value( int n )
{
	Token *token = scan_token( n );
	return token == NULL ? 0 : token->num_value;
}

char *scan_str_value( int n )
{
	Token *token = scan_token( n );
	return token == NULL ? "" : Str_data( token->str_value );
}

char *scan_filename( int n )
{
	Token *token = scan_token( n );
	return token == NULL ? NULL : token->filename;
}

int scan_line_nr( int n )
{
	Token *token = scan_token( n );
	return token == NULL ? 0 : token->line_nr;
}

/*-----------------------------------------------------------------------------
*   Stack of nested constructs
*----------------------------------------------------------------------------*/

/* push start of new struct to stack, fatal error if no context */
void scan_push_struct( int id, int value )
{
	Context	*context = get_context();
	if ( context == NULL )
	{
		error( ERR_UNBALANCED_STRUCT );
	}
	else 
	{
		StructList_start( context->struct_stack, id, value, context->line_nr );
	}
}

/* return ID of top of struct stack, -1 if none */
int scan_top_id( void )						
{
	Context	*context = get_context();
	if ( context == NULL )
	{
		error( ERR_UNBALANCED_STRUCT );
		return SCAN_ERR_ID;
	}
	else
	{
		return StructList_top_id( context->struct_stack );
	}
}

/* return VALUE of top of struct stack, -1 if none */
int scan_top_value( void )
{
	Context	*context = get_context();
	if ( context == NULL )
	{
		error( ERR_UNBALANCED_STRUCT );
		return SCAN_ERR_ID;
	}
	else
	{
		return StructList_top_value( context->struct_stack );
	}
}

/* replace ID, VALUE of top element, e.g replace IF by ELSE */
void scan_replace_struct( int id, int value )
{
	Context	*context = get_context();
	if ( context == NULL )
	{
		error( ERR_UNBALANCED_STRUCT );
	}
	else 
	{
		StructList_replace( context->struct_stack, id, value, context->line_nr );
	}
}

/* pop top element, syntaxt error if id != top_id */
void scan_pop_struct( int id )
{
	Context	*context = get_context();
	if ( context == NULL )
	{
		error( ERR_UNBALANCED_STRUCT );
	}
	else 
	{
		StructList_end( context->struct_stack, id );
	}
}
