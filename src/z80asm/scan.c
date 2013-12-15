
//#line 1 "scan.rl"
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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/scan.c,v 1.28 2013-12-15 13:18:34 pauloscustodio Exp $ 
*/

#include "xmalloc.h"   /* before any other include */

#include "scan.h"

#include "codearea.h"
#include "ctype.h"
#include "errors.h"
#include "file.h"
#include "legacy.h"
#include "listfile.h"
#include "options.h"
#include "strpool.h"
#include "types.h"

static int scan_num(char *text, int num_suffix_chars, int base);

/*-----------------------------------------------------------------------------
* Globals that keep last token read
*----------------------------------------------------------------------------*/
enum token last_token;
int		   last_token_num;
GString	  *last_token_str;

static Scan *the_scan;

/*-----------------------------------------------------------------------------
* Z80ASM scanner
*----------------------------------------------------------------------------*/

//#line 230 "scan.rl"



//#line 56 "scan.c"
static const int asm_start = 7;
static const int asm_error = 0;

static const int asm_en_main = 7;


//#line 233 "scan.rl"

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
* Initialize and Terminate module
*----------------------------------------------------------------------------*/
void init_scan(void)
{
	last_token_str = g_string_new("");
	the_scan = OBJ_NEW(Scan);
}
	
void fini_scan(void)
{
	g_string_free( last_token_str, TRUE );
	OBJ_DELETE(the_scan);
}

/*-----------------------------------------------------------------------------
* Initialize and Terminate scan context
*----------------------------------------------------------------------------*/
DEF_CLASS(ScanContext);

void ScanContext_init(ScanContext *self)
{
	self->input = g_string_new("");
}

void ScanContext_fini(ScanContext *self)
{
	if ( self->input )
		g_string_free( self->input, TRUE );
	
	if ( self->file )
		xfclose( self->file );
}

void ScanContext_copy(ScanContext *self, ScanContext *other)
{
}


/*-----------------------------------------------------------------------------
* Initialize and Terminate scan
*----------------------------------------------------------------------------*/
DEF_CLASS(Scan);

void Scan_init(Scan *self)
{
}

void Scan_fini(Scan *self)
{
	/* delete all list elements */
	g_slist_foreach( self->stack, (GFunc) ScanContext_delete, 0 );
	g_slist_free( self->stack );
	
	OBJ_DELETE(self->ctx);
}

void Scan_copy(Scan *self, Scan *other)
{
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
* Initialize the scanner to read ctx->input
*----------------------------------------------------------------------------*/
static void reset_scan( ScanContext *ctx )
{
	/* init state structure */
	ctx->bol   	= TRUE;
	ctx->p		= ctx->input->str;
	ctx->pe		= ctx->input->str + ctx->input->len;
	ctx->eof	= ctx->pe;	/* tokens are not split acros input lines */
	
	
//#line 197 "scan.c"
	{
	(		ctx->cs) = asm_start;
	(		ctx->ts) = 0;
	(		ctx->te) = 0;
	(	ctx->act) = 0;
	}

//#line 366 "scan.rl"

	reset_last_token();
}

/*-----------------------------------------------------------------------------
* Interface with error location
*----------------------------------------------------------------------------*/
static void set_error_location( ScanContext *ctx )
{
	/* set error location; in line_mode, only set error line at LINE directive */
	set_error_file( ctx->filename );
	if ( !opts.line_mode )
		set_error_line( ctx->line_nr );
}

/*-----------------------------------------------------------------------------
* Read the next line to input
*----------------------------------------------------------------------------*/
static BOOL read_next_line( ScanContext *ctx )
{
	int c1, c2;
	
	g_string_truncate( ctx->input, 0 );
	while ( (c1 = getc( ctx->file )) != EOF && c1 != '\n' && c1 != '\r' )
		g_string_append_c( ctx->input, c1 );
	
	if ( c1 == EOF )
	{
		if ( ctx->input->len > 0 )					/* read some chars */
			g_string_append_c( ctx->input, '\n' );	/* missing newline at end of line */
	}
	else 						
	{
		g_string_append_c( ctx->input, '\n' );		/* end of line */
		
		if ( (c2 = getc( ctx->file )) != EOF &&
			 ! ( c1 == '\n' && c2 == '\r' ||
				 c1 == '\r' && c2 == '\n' ) )
		{
			ungetc( c2, ctx->file );				/* push back to input */
		}
	}
	
	if ( ctx->input->len > 0 )
	{
		ctx->line_nr++;
	
		/* call listing */
		if ( opts.cur_list )
			list_start_line( get_PC(), ctx->filename, ctx->line_nr, ctx->input->str );

		set_error_location( ctx );

		return TRUE;
	}
	else
	{
		/* clear error location */
		set_error_null();

		return FALSE;
	}
}

/*-----------------------------------------------------------------------------
* Push the current context, create a new one
*----------------------------------------------------------------------------*/
static void push_context( Scan *self )
{
	char *filename = NULL;
	int	  line_nr  = 0;
	
	if ( self->ctx )
	{
		/* copy current filename/line_nr to new context */
		filename = self->ctx->filename;
		line_nr  = self->ctx->line_nr;

		/* push current top context to stack */
		self->stack = g_slist_prepend( self->stack, self->ctx );
	}

	/* create the new context */
	self->ctx = OBJ_NEW(ScanContext);
	OBJ_AUTODELETE(self->ctx) = FALSE;
	
	/* init filename/line_nr */
	self->ctx->filename = filename;
	self->ctx->line_nr  = line_nr;
}

/*-----------------------------------------------------------------------------
* Pop and delete the current context
*----------------------------------------------------------------------------*/
static void pop_context( Scan *self )
{
	OBJ_DELETE(self->ctx);
	if ( self->stack )
	{
		/* pop one */
		self->ctx = self->stack->data;
		self->stack = g_slist_remove( self->stack, self->ctx );

		set_error_location( self->ctx );
	}
	else
	{
		set_error_null();
	}
}

/*-----------------------------------------------------------------------------
* push current scan context, start scanning a string
*----------------------------------------------------------------------------*/
void scan_string( char *text )
{
	scan_string_Scan( the_scan, text );
}

void scan_string_Scan( Scan *self, char *text )
{
	push_context( self );
	g_string_assign( self->ctx->input, text );
	reset_scan( self->ctx );
}

/*-----------------------------------------------------------------------------
* push current scan context, start scanning a file
*----------------------------------------------------------------------------*/
void scan_file( char *filename )
{
	scan_file_Scan( the_scan, filename );
}

void scan_file_Scan( Scan *self, char *filename )
{
	GSList		*i;
	ScanContext *ctx;

	/* create the context */
	push_context( self );
	
	/* check for recursive includes */
	for ( i = self->stack; i; i = g_slist_next(i) )
	{
		ctx = i->data;
		if ( ctx->file && ctx->filename &&
		     strcmp(filename, ctx->filename) == 0 )
			fatal_include_recursion( filename );
	}

	/* open the file */
	self->ctx->file		= xfopen( filename, "rb" );		/* "b" to return eol chars */
	self->ctx->filename = strpool_add( filename );
	self->ctx->line_nr  = 0;
	
	set_error_location( self->ctx );

	reset_scan( self->ctx );
}

/*-----------------------------------------------------------------------------
* get the next token or line workhorse
*----------------------------------------------------------------------------*/
static enum token _get_token_Scan( Scan *self, BOOL by_lines )
{
	ScanContext *ctx;
	char c;
	
	reset_last_token();			/* sets last_token to t_end */
	
	while ( (ctx = self->ctx) != NULL )
	{
		
//#line 380 "scan.c"
	{
	short _widec;
	if ( (		ctx->p) == (		ctx->pe) )
		goto _test_eof;
	switch ( (		ctx->cs) )
	{
tr0:
//#line 102 "scan.rl"
	{{(		ctx->p) = (((		ctx->te)))-1;}{ last_token = ctx->ts[0];	{(		ctx->p)++; (		ctx->cs) = 7; goto _out;} }}
	goto st7;
tr2:
//#line 1 "NONE"
	{	switch( (	ctx->act) ) {
	case 4:
	{{(		ctx->p) = (((		ctx->te)))-1;} last_token = ctx->ts[0];	{(		ctx->p)++; (		ctx->cs) = 7; goto _out;} }
	break;
	case 5:
	{{(		ctx->p) = (((		ctx->te)))-1;} last_token = t_eq_eq; 	{(		ctx->p)++; (		ctx->cs) = 7; goto _out;} }
	break;
	case 6:
	{{(		ctx->p) = (((		ctx->te)))-1;} last_token = t_lt_gt; 	{(		ctx->p)++; (		ctx->cs) = 7; goto _out;} }
	break;
	case 7:
	{{(		ctx->p) = (((		ctx->te)))-1;} last_token = t_exclam_eq; {(		ctx->p)++; (		ctx->cs) = 7; goto _out;} }
	break;
	case 8:
	{{(		ctx->p) = (((		ctx->te)))-1;} last_token = t_lt_eq; 	{(		ctx->p)++; (		ctx->cs) = 7; goto _out;} }
	break;
	case 9:
	{{(		ctx->p) = (((		ctx->te)))-1;} last_token = t_gt_eq; 	{(		ctx->p)++; (		ctx->cs) = 7; goto _out;} }
	break;
	case 10:
	{{(		ctx->p) = (((		ctx->te)))-1;} last_token = t_vbar_vbar; {(		ctx->p)++; (		ctx->cs) = 7; goto _out;} }
	break;
	case 11:
	{{(		ctx->p) = (((		ctx->te)))-1;} last_token = t_and_and; 	{(		ctx->p)++; (		ctx->cs) = 7; goto _out;} }
	break;
	case 12:
	{{(		ctx->p) = (((		ctx->te)))-1;} last_token = t_lt_lt; 	{(		ctx->p)++; (		ctx->cs) = 7; goto _out;} }
	break;
	case 13:
	{{(		ctx->p) = (((		ctx->te)))-1;} last_token = t_gt_gt; 	{(		ctx->p)++; (		ctx->cs) = 7; goto _out;} }
	break;
	case 14:
	{{(		ctx->p) = (((		ctx->te)))-1;} last_token = t_star_star; {(		ctx->p)++; (		ctx->cs) = 7; goto _out;} }
	break;
	case 15:
	{{(		ctx->p) = (((		ctx->te)))-1;} 
		last_token_num = scan_num( ctx->ts, ctx->te - ctx->ts, 10 ); 
		last_token = t_number;
		{(		ctx->p)++; (		ctx->cs) = 7; goto _out;}
	}
	break;
	case 16:
	{{(		ctx->p) = (((		ctx->te)))-1;} 
		last_token_num = scan_num( ctx->ts, ctx->te - ctx->ts - 1, 16 ); 
		last_token = t_number;
		{(		ctx->p)++; (		ctx->cs) = 7; goto _out;}
	}
	break;
	case 17:
	{{(		ctx->p) = (((		ctx->te)))-1;} 
		last_token_num = scan_num( ctx->ts + 1, ctx->te - ctx->ts - 1, 16 ); 
		last_token = t_number;
		{(		ctx->p)++; (		ctx->cs) = 7; goto _out;}
	}
	break;
	case 18:
	{{(		ctx->p) = (((		ctx->te)))-1;} 
		last_token_num = scan_num( ctx->ts + 2, ctx->te - ctx->ts - 2, 16 ); 
		last_token = t_number;
		{(		ctx->p)++; (		ctx->cs) = 7; goto _out;}
	}
	break;
	case 19:
	{{(		ctx->p) = (((		ctx->te)))-1;} 
		last_token_num = scan_num( ctx->ts, ctx->te - ctx->ts - 1, 2 ); 
		last_token = t_number;
		{(		ctx->p)++; (		ctx->cs) = 7; goto _out;}
	}
	break;
	case 21:
	{{(		ctx->p) = (((		ctx->te)))-1;} 
		last_token_num = scan_num( ctx->ts + 2, ctx->te - ctx->ts - 2, 2 ); 
		last_token = t_number;
		{(		ctx->p)++; (		ctx->cs) = 7; goto _out;}
	}
	break;
	case 22:
	{{(		ctx->p) = (((		ctx->te)))-1;} 
		last_token_num = scan_num( ctx->ts + 2, ctx->te - ctx->ts - 3, 2 ); 
		last_token = t_number;
		{(		ctx->p)++; (		ctx->cs) = 7; goto _out;}
	}
	break;
	case 23:
	{{(		ctx->p) = (((		ctx->te)))-1;}
		c = *(ctx->te); *(ctx->te) = '\0';			/* make substring */
		g_string_assign( last_token_str, ctx->ts );
		g_string_ascii_up( last_token_str );
		*(ctx->te) = c;								/* recover input */
		last_token = t_name;
		{(		ctx->p)++; (		ctx->cs) = 7; goto _out;}
	}
	break;
	case 24:
	{{(		ctx->p) = (((		ctx->te)))-1;}
		/* remove '.' and ':' */
		while ( *(ctx->ts)     == '.' || isspace(*(ctx->ts))   ) (ctx->ts)++;
		while ( *((ctx->te)-1) == ':' || isspace(*(ctx->te-1)) ) (ctx->te)--;
		
		/* copy token */
		c = *(ctx->te); *(ctx->te) = '\0';		/* make substring */
		g_string_assign( last_token_str, ctx->ts );
		g_string_ascii_up( last_token_str );
		*(ctx->te) = c;							/* recover input */
		last_token = t_label;
		{(		ctx->p)++; (		ctx->cs) = 7; goto _out;}
	}
	break;
	case 25:
	{{(		ctx->p) = (((		ctx->te)))-1;}
		if ( ctx->te - ctx->ts == 3 )
		{
			last_token_num = *(ctx->ts + 1);
			last_token = t_number;
			{(		ctx->p)++; (		ctx->cs) = 7; goto _out;}
		}
		else
			error_invalid_squoted_string();
	}
	break;
	case 27:
	{{(		ctx->p) = (((		ctx->te)))-1;}
		c = *(ctx->te-1); *(ctx->te-1) = '\0';		/* make substring */
		g_string_assign( last_token_str, ctx->ts+1 );
		*(ctx->te-1) = c;							/* recover input */
		last_token = t_string;
		{(		ctx->p)++; (		ctx->cs) = 7; goto _out;}
	}
	break;
	case 29:
	{{(		ctx->p) = (((		ctx->te)))-1;}
		c = *(ctx->te); *(ctx->te) = '\0';			/* make substring */
		g_string_assign( last_token_str, ctx->ts );
		*(ctx->te) = c;								/* recover input */
		last_token = t_string;
		{(		ctx->p)++; (		ctx->cs) = 7; goto _out;}
	}
	break;
	default:
	{{(		ctx->p) = (((		ctx->te)))-1;}}
	break;
	}
	}
	goto st7;
tr3:
//#line 158 "scan.rl"
	{(		ctx->te) = (		ctx->p)+1;{ 
		last_token_num = scan_num( ctx->ts + 2, ctx->te - ctx->ts - 3, 2 ); 
		last_token = t_number;
		{(		ctx->p)++; (		ctx->cs) = 7; goto _out;}
	}}
	goto st7;
tr5:
//#line 122 "scan.rl"
	{(		ctx->te) = (		ctx->p)+1;{ 
		last_token_num = scan_num( ctx->ts, ctx->te - ctx->ts - 1, 16 ); 
		last_token = t_number;
		{(		ctx->p)++; (		ctx->cs) = 7; goto _out;}
	}}
	goto st7;
tr6:
//#line 116 "scan.rl"
	{{(		ctx->p) = (((		ctx->te)))-1;}{ 
		last_token_num = scan_num( ctx->ts, ctx->te - ctx->ts, 10 ); 
		last_token = t_number;
		{(		ctx->p)++; (		ctx->cs) = 7; goto _out;}
	}}
	goto st7;
tr11:
//#line 177 "scan.rl"
	{(		ctx->te) = (		ctx->p)+1;{
		/* remove '.' and ':' */
		while ( *(ctx->ts)     == '.' || isspace(*(ctx->ts))   ) (ctx->ts)++;
		while ( *((ctx->te)-1) == ':' || isspace(*(ctx->te-1)) ) (ctx->te)--;
		
		/* copy token */
		c = *(ctx->te); *(ctx->te) = '\0';		/* make substring */
		g_string_assign( last_token_str, ctx->ts );
		g_string_ascii_up( last_token_str );
		*(ctx->te) = c;							/* recover input */
		last_token = t_label;
		{(		ctx->p)++; (		ctx->cs) = 7; goto _out;}
	}}
	goto st7;
tr14:
//#line 221 "scan.rl"
	{(		ctx->te) = (		ctx->p)+1;{
		c = *(ctx->te); *(ctx->te) = '\0';			/* make substring */
		g_string_assign( last_token_str, ctx->ts );
		*(ctx->te) = c;								/* recover input */
		last_token = t_string;
		{(		ctx->p)++; (		ctx->cs) = 7; goto _out;}
	}}
	goto st7;
tr15:
//#line 98 "scan.rl"
	{(		ctx->te) = (		ctx->p)+1;}
	goto st7;
tr16:
//#line 89 "scan.rl"
	{(		ctx->te) = (		ctx->p)+1;{ 
		last_token = t_newline; 
		{(		ctx->p)++; (		ctx->cs) = 7; goto _out;} 
	}}
	goto st7;
tr23:
//#line 102 "scan.rl"
	{(		ctx->te) = (		ctx->p)+1;{ last_token = ctx->ts[0];	{(		ctx->p)++; (		ctx->cs) = 7; goto _out;} }}
	goto st7;
tr58:
//#line 102 "scan.rl"
	{(		ctx->te) = (		ctx->p);(		ctx->p)--;{ last_token = ctx->ts[0];	{(		ctx->p)++; (		ctx->cs) = 7; goto _out;} }}
	goto st7;
tr59:
//#line 105 "scan.rl"
	{(		ctx->te) = (		ctx->p)+1;{ last_token = t_exclam_eq; {(		ctx->p)++; (		ctx->cs) = 7; goto _out;} }}
	goto st7;
tr60:
//#line 214 "scan.rl"
	{(		ctx->te) = (		ctx->p);(		ctx->p)--;{ error_unclosed_string(); }}
	goto st7;
tr61:
//#line 207 "scan.rl"
	{(		ctx->te) = (		ctx->p)+1;{
		c = *(ctx->te-1); *(ctx->te-1) = '\0';		/* make substring */
		g_string_assign( last_token_str, ctx->ts+1 );
		*(ctx->te-1) = c;							/* recover input */
		last_token = t_string;
		{(		ctx->p)++; (		ctx->cs) = 7; goto _out;}
	}}
	goto st7;
tr65:
//#line 146 "scan.rl"
	{(		ctx->te) = (		ctx->p);(		ctx->p)--;{ 
		last_token_num = scan_num( ctx->ts + 1, ctx->te - ctx->ts - 1, 2 ); 
		last_token = t_number;
		{(		ctx->p)++; (		ctx->cs) = 7; goto _out;}
	}}
	goto st7;
tr66:
//#line 109 "scan.rl"
	{(		ctx->te) = (		ctx->p)+1;{ last_token = t_and_and; 	{(		ctx->p)++; (		ctx->cs) = 7; goto _out;} }}
	goto st7;
tr67:
//#line 203 "scan.rl"
	{(		ctx->te) = (		ctx->p);(		ctx->p)--;{ error_invalid_squoted_string(); }}
	goto st7;
tr68:
//#line 193 "scan.rl"
	{(		ctx->te) = (		ctx->p)+1;{
		if ( ctx->te - ctx->ts == 3 )
		{
			last_token_num = *(ctx->ts + 1);
			last_token = t_number;
			{(		ctx->p)++; (		ctx->cs) = 7; goto _out;}
		}
		else
			error_invalid_squoted_string();
	}}
	goto st7;
tr69:
//#line 112 "scan.rl"
	{(		ctx->te) = (		ctx->p)+1;{ last_token = t_star_star; {(		ctx->p)++; (		ctx->cs) = 7; goto _out;} }}
	goto st7;
tr70:
//#line 116 "scan.rl"
	{(		ctx->te) = (		ctx->p);(		ctx->p)--;{ 
		last_token_num = scan_num( ctx->ts, ctx->te - ctx->ts, 10 ); 
		last_token = t_number;
		{(		ctx->p)++; (		ctx->cs) = 7; goto _out;}
	}}
	goto st7;
tr75:
//#line 140 "scan.rl"
	{(		ctx->te) = (		ctx->p);(		ctx->p)--;{ 
		last_token_num = scan_num( ctx->ts, ctx->te - ctx->ts - 1, 2 ); 
		last_token = t_number;
		{(		ctx->p)++; (		ctx->cs) = 7; goto _out;}
	}}
	goto st7;
tr77:
//#line 134 "scan.rl"
	{(		ctx->te) = (		ctx->p);(		ctx->p)--;{ 
		last_token_num = scan_num( ctx->ts + 2, ctx->te - ctx->ts - 2, 16 ); 
		last_token = t_number;
		{(		ctx->p)++; (		ctx->cs) = 7; goto _out;}
	}}
	goto st7;
tr78:
//#line 95 "scan.rl"
	{(		ctx->te) = (		ctx->p);(		ctx->p)--;}
	goto st7;
tr79:
//#line 110 "scan.rl"
	{(		ctx->te) = (		ctx->p)+1;{ last_token = t_lt_lt; 	{(		ctx->p)++; (		ctx->cs) = 7; goto _out;} }}
	goto st7;
tr80:
//#line 106 "scan.rl"
	{(		ctx->te) = (		ctx->p)+1;{ last_token = t_lt_eq; 	{(		ctx->p)++; (		ctx->cs) = 7; goto _out;} }}
	goto st7;
tr81:
//#line 104 "scan.rl"
	{(		ctx->te) = (		ctx->p)+1;{ last_token = t_lt_gt; 	{(		ctx->p)++; (		ctx->cs) = 7; goto _out;} }}
	goto st7;
tr82:
//#line 103 "scan.rl"
	{(		ctx->te) = (		ctx->p)+1;{ last_token = t_eq_eq; 	{(		ctx->p)++; (		ctx->cs) = 7; goto _out;} }}
	goto st7;
tr83:
//#line 107 "scan.rl"
	{(		ctx->te) = (		ctx->p)+1;{ last_token = t_gt_eq; 	{(		ctx->p)++; (		ctx->cs) = 7; goto _out;} }}
	goto st7;
tr84:
//#line 111 "scan.rl"
	{(		ctx->te) = (		ctx->p)+1;{ last_token = t_gt_gt; 	{(		ctx->p)++; (		ctx->cs) = 7; goto _out;} }}
	goto st7;
tr85:
//#line 108 "scan.rl"
	{(		ctx->te) = (		ctx->p)+1;{ last_token = t_vbar_vbar; {(		ctx->p)++; (		ctx->cs) = 7; goto _out;} }}
	goto st7;
tr91:
//#line 221 "scan.rl"
	{(		ctx->te) = (		ctx->p);(		ctx->p)--;{
		c = *(ctx->te); *(ctx->te) = '\0';			/* make substring */
		g_string_assign( last_token_str, ctx->ts );
		*(ctx->te) = c;								/* recover input */
		last_token = t_string;
		{(		ctx->p)++; (		ctx->cs) = 7; goto _out;}
	}}
	goto st7;
tr112:
//#line 166 "scan.rl"
	{(		ctx->te) = (		ctx->p);(		ctx->p)--;{
		c = *(ctx->te); *(ctx->te) = '\0';			/* make substring */
		g_string_assign( last_token_str, ctx->ts );
		g_string_ascii_up( last_token_str );
		*(ctx->te) = c;								/* recover input */
		last_token = t_name;
		{(		ctx->p)++; (		ctx->cs) = 7; goto _out;}
	}}
	goto st7;
tr114:
//#line 166 "scan.rl"
	{(		ctx->te) = (		ctx->p)+1;{
		c = *(ctx->te); *(ctx->te) = '\0';			/* make substring */
		g_string_assign( last_token_str, ctx->ts );
		g_string_ascii_up( last_token_str );
		*(ctx->te) = c;								/* recover input */
		last_token = t_name;
		{(		ctx->p)++; (		ctx->cs) = 7; goto _out;}
	}}
	goto st7;
tr115:
//#line 177 "scan.rl"
	{(		ctx->te) = (		ctx->p);(		ctx->p)--;{
		/* remove '.' and ':' */
		while ( *(ctx->ts)     == '.' || isspace(*(ctx->ts))   ) (ctx->ts)++;
		while ( *((ctx->te)-1) == ':' || isspace(*(ctx->te-1)) ) (ctx->te)--;
		
		/* copy token */
		c = *(ctx->te); *(ctx->te) = '\0';		/* make substring */
		g_string_assign( last_token_str, ctx->ts );
		g_string_ascii_up( last_token_str );
		*(ctx->te) = c;							/* recover input */
		last_token = t_label;
		{(		ctx->p)++; (		ctx->cs) = 7; goto _out;}
	}}
	goto st7;
st7:
//#line 1 "NONE"
	{(		ctx->ts) = 0;}
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof7;
case 7:
//#line 1 "NONE"
	{(		ctx->ts) = (		ctx->p);}
//#line 769 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 58 ) {
		if ( (*(		ctx->p)) < 38 ) {
			if ( (*(		ctx->p)) < 33 ) {
				if ( (*(		ctx->p)) < 10 ) {
					if ( (*(		ctx->p)) <= 9 ) {
						_widec = (short)(2688 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
						if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
					}
				} else if ( (*(		ctx->p)) > 10 ) {
					if ( 11 <= (*(		ctx->p)) && (*(		ctx->p)) <= 32 ) {
						_widec = (short)(2688 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
						if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
					}
				} else {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else if ( (*(		ctx->p)) > 33 ) {
				if ( (*(		ctx->p)) < 35 ) {
					if ( 34 <= (*(		ctx->p)) && (*(		ctx->p)) <= 34 ) {
						_widec = (short)(2688 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
						if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
					}
				} else if ( (*(		ctx->p)) > 35 ) {
					if ( (*(		ctx->p)) > 36 ) {
						if ( 37 <= (*(		ctx->p)) && (*(		ctx->p)) <= 37 ) {
							_widec = (short)(2688 + ((*(		ctx->p)) - -128));
							if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
							if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
						}
					} else if ( (*(		ctx->p)) >= 36 ) {
						_widec = (short)(2688 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
						if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
					}
				} else {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else if ( (*(		ctx->p)) > 38 ) {
			if ( (*(		ctx->p)) < 43 ) {
				if ( (*(		ctx->p)) < 40 ) {
					if ( 39 <= (*(		ctx->p)) && (*(		ctx->p)) <= 39 ) {
						_widec = (short)(2688 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
						if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
					}
				} else if ( (*(		ctx->p)) > 41 ) {
					if ( 42 <= (*(		ctx->p)) && (*(		ctx->p)) <= 42 ) {
						_widec = (short)(2688 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
						if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
					}
				} else {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else if ( (*(		ctx->p)) > 45 ) {
				if ( (*(		ctx->p)) < 47 ) {
					if ( 46 <= (*(		ctx->p)) && (*(		ctx->p)) <= 46 ) {
						_widec = (short)(3712 + ((*(		ctx->p)) - -128));
						if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
						if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
					}
				} else if ( (*(		ctx->p)) > 47 ) {
					if ( (*(		ctx->p)) > 48 ) {
						if ( 49 <= (*(		ctx->p)) && (*(		ctx->p)) <= 57 ) {
							_widec = (short)(2688 + ((*(		ctx->p)) - -128));
							if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
							if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
						}
					} else if ( (*(		ctx->p)) >= 48 ) {
						_widec = (short)(2688 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
						if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
					}
				} else {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else {
			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else if ( (*(		ctx->p)) > 58 ) {
		if ( (*(		ctx->p)) < 91 ) {
			if ( (*(		ctx->p)) < 62 ) {
				if ( (*(		ctx->p)) < 60 ) {
					if ( 59 <= (*(		ctx->p)) && (*(		ctx->p)) <= 59 ) {
						_widec = (short)(2688 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
						if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
					}
				} else if ( (*(		ctx->p)) > 60 ) {
					if ( 61 <= (*(		ctx->p)) && (*(		ctx->p)) <= 61 ) {
						_widec = (short)(2688 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
						if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
					}
				} else {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else if ( (*(		ctx->p)) > 62 ) {
				if ( (*(		ctx->p)) < 64 ) {
					if ( 63 <= (*(		ctx->p)) && (*(		ctx->p)) <= 63 ) {
						_widec = (short)(2688 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
						if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
					}
				} else if ( (*(		ctx->p)) > 64 ) {
					if ( (*(		ctx->p)) > 65 ) {
						if ( 66 <= (*(		ctx->p)) && (*(		ctx->p)) <= 90 ) {
							_widec = (short)(3712 + ((*(		ctx->p)) - -128));
							if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
							if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
							if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
						}
					} else if ( (*(		ctx->p)) >= 65 ) {
						_widec = (short)(3712 + ((*(		ctx->p)) - -128));
						if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
						if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
					}
				} else {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else if ( (*(		ctx->p)) > 94 ) {
			if ( (*(		ctx->p)) < 98 ) {
				if ( (*(		ctx->p)) < 96 ) {
					if ( 95 <= (*(		ctx->p)) && (*(		ctx->p)) <= 95 ) {
						_widec = (short)(3712 + ((*(		ctx->p)) - -128));
						if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
						if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
					}
				} else if ( (*(		ctx->p)) > 96 ) {
					if ( 97 <= (*(		ctx->p)) && (*(		ctx->p)) <= 97 ) {
						_widec = (short)(3712 + ((*(		ctx->p)) - -128));
						if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
						if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
					}
				} else {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else if ( (*(		ctx->p)) > 122 ) {
				if ( (*(		ctx->p)) < 124 ) {
					if ( 123 <= (*(		ctx->p)) && (*(		ctx->p)) <= 123 ) {
						_widec = (short)(2688 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
						if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
					}
				} else if ( (*(		ctx->p)) > 124 ) {
					if ( (*(		ctx->p)) > 126 ) {
						if ( 127 <= (*(		ctx->p)) )
 {							_widec = (short)(2688 + ((*(		ctx->p)) - -128));
							if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
							if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
						}
					} else if ( (*(		ctx->p)) >= 125 ) {
						_widec = (short)(2688 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
						if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
					}
				} else {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else {
				_widec = (short)(3712 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
			}
		} else {
			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else {
		_widec = (short)(2688 + ((*(		ctx->p)) - -128));
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
	}
	switch( _widec ) {
		case 3082: goto tr14;
		case 3168: goto tr12;
		case 3338: goto tr16;
		case 3361: goto st9;
		case 3362: goto st10;
		case 3365: goto tr20;
		case 3366: goto st14;
		case 3367: goto st15;
		case 3370: goto st16;
		case 3375: goto tr23;
		case 3376: goto tr25;
		case 3387: goto st23;
		case 3388: goto st24;
		case 3389: goto st25;
		case 3390: goto st26;
		case 3392: goto tr20;
		case 3424: goto tr23;
		case 3452: goto st27;
		case 3455: goto tr15;
		case 3594: goto tr16;
		case 3617: goto st28;
		case 3618: goto st29;
		case 3621: goto tr36;
		case 3622: goto st35;
		case 3623: goto st36;
		case 3626: goto st37;
		case 3631: goto tr39;
		case 3632: goto tr41;
		case 3643: goto st44;
		case 3644: goto st45;
		case 3645: goto st46;
		case 3646: goto st47;
		case 3648: goto tr36;
		case 3680: goto tr39;
		case 3708: goto st48;
		case 3711: goto tr32;
		case 4398: goto tr12;
		case 4447: goto tr12;
		case 4654: goto tr12;
		case 4703: goto tr12;
		case 4910: goto tr23;
		case 4929: goto st49;
		case 4959: goto st50;
		case 4961: goto st49;
		case 5166: goto tr50;
		case 5185: goto tr51;
		case 5215: goto tr52;
		case 5217: goto tr51;
		case 5422: goto tr39;
		case 5441: goto st57;
		case 5471: goto st58;
		case 5473: goto st57;
		case 5678: goto tr55;
		case 5697: goto tr56;
		case 5727: goto tr57;
		case 5729: goto tr56;
	}
	if ( _widec < 3633 ) {
		if ( _widec < 3368 ) {
			if ( _widec < 3163 ) {
				if ( _widec > 3117 ) {
					if ( 3119 <= _widec && _widec <= 3136 )
						goto tr12;
				} else if ( _widec >= 2944 )
					goto tr12;
			} else if ( _widec > 3166 ) {
				if ( _widec < 3200 ) {
					if ( 3195 <= _widec && _widec <= 3199 )
						goto tr12;
				} else if ( _widec > 3360 ) {
					if ( 3363 <= _widec && _widec <= 3364 )
						goto tr19;
				} else
					goto tr15;
			} else
				goto tr12;
		} else if ( _widec > 3373 ) {
			if ( _widec < 3451 ) {
				if ( _widec < 3386 ) {
					if ( 3377 <= _widec && _widec <= 3385 )
						goto tr26;
				} else if ( _widec > 3391 ) {
					if ( 3419 <= _widec && _widec <= 3422 )
						goto tr23;
				} else
					goto tr23;
			} else if ( _widec > 3454 ) {
				if ( _widec < 3619 ) {
					if ( 3456 <= _widec && _widec <= 3616 )
						goto tr32;
				} else if ( _widec > 3620 ) {
					if ( 3624 <= _widec && _widec <= 3629 )
						goto tr39;
				} else
					goto tr35;
			} else
				goto tr23;
		} else
			goto tr23;
	} else if ( _widec > 3641 ) {
		if ( _widec < 4930 ) {
			if ( _widec < 4417 ) {
				if ( _widec < 3675 ) {
					if ( 3642 <= _widec && _widec <= 3647 )
						goto tr39;
				} else if ( _widec > 3678 ) {
					if ( 3707 <= _widec && _widec <= 3710 )
						goto tr39;
				} else
					goto tr39;
			} else if ( _widec > 4442 ) {
				if ( _widec < 4673 ) {
					if ( 4449 <= _widec && _widec <= 4474 )
						goto tr12;
				} else if ( _widec > 4698 ) {
					if ( 4705 <= _widec && _widec <= 4730 )
						goto tr12;
				} else
					goto tr12;
			} else
				goto tr12;
		} else if ( _widec > 4954 ) {
			if ( _widec < 5442 ) {
				if ( _widec < 5186 ) {
					if ( 4962 <= _widec && _widec <= 4986 )
						goto st50;
				} else if ( _widec > 5210 ) {
					if ( 5218 <= _widec && _widec <= 5242 )
						goto tr52;
				} else
					goto tr52;
			} else if ( _widec > 5466 ) {
				if ( _widec < 5698 ) {
					if ( 5474 <= _widec && _widec <= 5498 )
						goto st58;
				} else if ( _widec > 5722 ) {
					if ( 5730 <= _widec && _widec <= 5754 )
						goto tr57;
				} else
					goto tr57;
			} else
				goto st58;
		} else
			goto st50;
	} else
		goto tr42;
	goto st0;
st0:
(		ctx->cs) = 0;
	goto _out;
tr122:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 177 "scan.rl"
	{(	ctx->act) = 24;}
	goto st8;
tr12:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 221 "scan.rl"
	{(	ctx->act) = 29;}
	goto st8;
tr39:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 102 "scan.rl"
	{(	ctx->act) = 4;}
	goto st8;
tr32:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 98 "scan.rl"
	{(	ctx->act) = 3;}
	goto st8;
tr118:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 166 "scan.rl"
	{(	ctx->act) = 23;}
	goto st8;
tr86:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 105 "scan.rl"
	{(	ctx->act) = 7;}
	goto st8;
tr87:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 207 "scan.rl"
	{(	ctx->act) = 27;}
	goto st8;
tr93:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 158 "scan.rl"
	{(	ctx->act) = 22;}
	goto st8;
tr94:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 109 "scan.rl"
	{(	ctx->act) = 11;}
	goto st8;
tr95:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 193 "scan.rl"
	{(	ctx->act) = 25;}
	goto st8;
tr96:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 112 "scan.rl"
	{(	ctx->act) = 14;}
	goto st8;
tr100:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 122 "scan.rl"
	{(	ctx->act) = 16;}
	goto st8;
tr105:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 110 "scan.rl"
	{(	ctx->act) = 12;}
	goto st8;
tr106:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 106 "scan.rl"
	{(	ctx->act) = 8;}
	goto st8;
tr107:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 104 "scan.rl"
	{(	ctx->act) = 6;}
	goto st8;
tr108:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 103 "scan.rl"
	{(	ctx->act) = 5;}
	goto st8;
tr109:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 107 "scan.rl"
	{(	ctx->act) = 9;}
	goto st8;
tr110:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 111 "scan.rl"
	{(	ctx->act) = 13;}
	goto st8;
tr111:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 108 "scan.rl"
	{(	ctx->act) = 10;}
	goto st8;
st8:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof8;
case 8:
//#line 1407 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 10 ) {
		if ( (*(		ctx->p)) <= 9 ) {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 10 ) {
		if ( 11 <= (*(		ctx->p)) )
 {			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else {
		_widec = (short)(2176 + ((*(		ctx->p)) - -128));
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
	}
	if ( _widec == 2570 )
		goto tr14;
	if ( 2432 <= _widec && _widec <= 2687 )
		goto tr12;
	goto tr2;
st9:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof9;
case 9:
	_widec = (*(		ctx->p));
	if ( 61 <= (*(		ctx->p)) && (*(		ctx->p)) <= 61 ) {
		_widec = (short)(128 + ((*(		ctx->p)) - -128));
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
	}
	if ( _widec == 573 )
		goto tr59;
	goto tr58;
st10:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof10;
case 10:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 11 ) {
		if ( (*(		ctx->p)) <= 9 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 33 ) {
		if ( (*(		ctx->p)) > 34 ) {
			if ( 35 <= (*(		ctx->p)) )
 {				_widec = (short)(128 + ((*(		ctx->p)) - -128));
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) >= 34 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*(		ctx->p)) - -128));
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
	}
	if ( _widec == 546 )
		goto tr61;
	if ( _widec > 521 ) {
		if ( 523 <= _widec && _widec <= 639 )
			goto st10;
	} else if ( _widec >= 384 )
		goto st10;
	goto tr60;
tr19:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 102 "scan.rl"
	{(	ctx->act) = 4;}
	goto st11;
tr62:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 128 "scan.rl"
	{(	ctx->act) = 17;}
	goto st11;
st11:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof11;
case 11:
//#line 1504 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 65 ) {
		if ( 48 <= (*(		ctx->p)) && (*(		ctx->p)) <= 57 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 70 ) {
		if ( 97 <= (*(		ctx->p)) && (*(		ctx->p)) <= 102 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*(		ctx->p)) - -128));
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
	}
	if ( _widec < 577 ) {
		if ( 560 <= _widec && _widec <= 569 )
			goto tr62;
	} else if ( _widec > 582 ) {
		if ( 609 <= _widec && _widec <= 614 )
			goto tr62;
	} else
		goto tr62;
	goto tr2;
tr20:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 102 "scan.rl"
	{(	ctx->act) = 4;}
	goto st12;
st12:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof12;
case 12:
//#line 1545 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 48 ) {
		if ( 34 <= (*(		ctx->p)) && (*(		ctx->p)) <= 34 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 48 ) {
		if ( 49 <= (*(		ctx->p)) && (*(		ctx->p)) <= 49 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*(		ctx->p)) - -128));
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
	}
	if ( _widec == 546 )
		goto st1;
	if ( 560 <= _widec && _widec <= 561 )
		goto st13;
	goto tr58;
st1:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof1;
case 1:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) > 35 ) {
		if ( 45 <= (*(		ctx->p)) && (*(		ctx->p)) <= 45 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) >= 35 ) {
		_widec = (short)(128 + ((*(		ctx->p)) - -128));
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
	}
	switch( _widec ) {
		case 547: goto st2;
		case 557: goto st2;
	}
	goto tr0;
st2:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof2;
case 2:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 35 ) {
		if ( 34 <= (*(		ctx->p)) && (*(		ctx->p)) <= 34 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 35 ) {
		if ( 45 <= (*(		ctx->p)) && (*(		ctx->p)) <= 45 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*(		ctx->p)) - -128));
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
	}
	switch( _widec ) {
		case 546: goto tr3;
		case 547: goto st2;
		case 557: goto st2;
	}
	goto tr2;
st13:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof13;
case 13:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) > 48 ) {
		if ( 49 <= (*(		ctx->p)) && (*(		ctx->p)) <= 49 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) >= 48 ) {
		_widec = (short)(128 + ((*(		ctx->p)) - -128));
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
	}
	if ( 560 <= _widec && _widec <= 561 )
		goto st13;
	goto tr65;
st14:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof14;
case 14:
	_widec = (*(		ctx->p));
	if ( 38 <= (*(		ctx->p)) && (*(		ctx->p)) <= 38 ) {
		_widec = (short)(128 + ((*(		ctx->p)) - -128));
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
	}
	if ( _widec == 550 )
		goto tr66;
	goto tr58;
st15:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof15;
case 15:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 11 ) {
		if ( (*(		ctx->p)) <= 9 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 38 ) {
		if ( (*(		ctx->p)) > 39 ) {
			if ( 40 <= (*(		ctx->p)) )
 {				_widec = (short)(128 + ((*(		ctx->p)) - -128));
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) >= 39 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*(		ctx->p)) - -128));
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
	}
	if ( _widec == 551 )
		goto tr68;
	if ( _widec > 521 ) {
		if ( 523 <= _widec && _widec <= 639 )
			goto st15;
	} else if ( _widec >= 384 )
		goto st15;
	goto tr67;
st16:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof16;
case 16:
	_widec = (*(		ctx->p));
	if ( 42 <= (*(		ctx->p)) && (*(		ctx->p)) <= 42 ) {
		_widec = (short)(128 + ((*(		ctx->p)) - -128));
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
	}
	if ( _widec == 554 )
		goto tr69;
	goto tr58;
tr25:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 116 "scan.rl"
	{(	ctx->act) = 15;}
	goto st17;
st17:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof17;
case 17:
//#line 1725 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 72 ) {
		if ( (*(		ctx->p)) < 50 ) {
			if ( (*(		ctx->p)) > 48 ) {
				if ( 49 <= (*(		ctx->p)) && (*(		ctx->p)) <= 49 ) {
					_widec = (short)(128 + ((*(		ctx->p)) - -128));
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) >= 48 ) {
				_widec = (short)(128 + ((*(		ctx->p)) - -128));
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 57 ) {
			if ( (*(		ctx->p)) < 66 ) {
				if ( 65 <= (*(		ctx->p)) && (*(		ctx->p)) <= 65 ) {
					_widec = (short)(128 + ((*(		ctx->p)) - -128));
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) > 66 ) {
				if ( 67 <= (*(		ctx->p)) && (*(		ctx->p)) <= 70 ) {
					_widec = (short)(128 + ((*(		ctx->p)) - -128));
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
				}
			} else {
				_widec = (short)(128 + ((*(		ctx->p)) - -128));
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 72 ) {
		if ( (*(		ctx->p)) < 98 ) {
			if ( (*(		ctx->p)) > 88 ) {
				if ( 97 <= (*(		ctx->p)) && (*(		ctx->p)) <= 97 ) {
					_widec = (short)(128 + ((*(		ctx->p)) - -128));
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) >= 88 ) {
				_widec = (short)(128 + ((*(		ctx->p)) - -128));
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 98 ) {
			if ( (*(		ctx->p)) < 104 ) {
				if ( 99 <= (*(		ctx->p)) && (*(		ctx->p)) <= 102 ) {
					_widec = (short)(128 + ((*(		ctx->p)) - -128));
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) > 104 ) {
				if ( 120 <= (*(		ctx->p)) && (*(		ctx->p)) <= 120 ) {
					_widec = (short)(128 + ((*(		ctx->p)) - -128));
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
				}
			} else {
				_widec = (short)(128 + ((*(		ctx->p)) - -128));
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*(		ctx->p)) - -128));
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
	}
	switch( _widec ) {
		case 578: goto tr72;
		case 584: goto tr5;
		case 600: goto st4;
		case 610: goto tr72;
		case 616: goto tr5;
		case 632: goto st4;
	}
	if ( _widec < 562 ) {
		if ( 560 <= _widec && _widec <= 561 )
			goto tr26;
	} else if ( _widec > 569 ) {
		if ( _widec > 582 ) {
			if ( 609 <= _widec && _widec <= 614 )
				goto st3;
		} else if ( _widec >= 577 )
			goto st3;
	} else
		goto tr71;
	goto tr70;
tr26:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 116 "scan.rl"
	{(	ctx->act) = 15;}
	goto st18;
st18:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof18;
case 18:
//#line 1847 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 67 ) {
		if ( (*(		ctx->p)) < 50 ) {
			if ( (*(		ctx->p)) > 48 ) {
				if ( 49 <= (*(		ctx->p)) && (*(		ctx->p)) <= 49 ) {
					_widec = (short)(128 + ((*(		ctx->p)) - -128));
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) >= 48 ) {
				_widec = (short)(128 + ((*(		ctx->p)) - -128));
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 57 ) {
			if ( (*(		ctx->p)) > 65 ) {
				if ( 66 <= (*(		ctx->p)) && (*(		ctx->p)) <= 66 ) {
					_widec = (short)(128 + ((*(		ctx->p)) - -128));
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) >= 65 ) {
				_widec = (short)(128 + ((*(		ctx->p)) - -128));
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 70 ) {
		if ( (*(		ctx->p)) < 98 ) {
			if ( (*(		ctx->p)) > 72 ) {
				if ( 97 <= (*(		ctx->p)) && (*(		ctx->p)) <= 97 ) {
					_widec = (short)(128 + ((*(		ctx->p)) - -128));
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) >= 72 ) {
				_widec = (short)(128 + ((*(		ctx->p)) - -128));
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 98 ) {
			if ( (*(		ctx->p)) > 102 ) {
				if ( 104 <= (*(		ctx->p)) && (*(		ctx->p)) <= 104 ) {
					_widec = (short)(128 + ((*(		ctx->p)) - -128));
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) >= 99 ) {
				_widec = (short)(128 + ((*(		ctx->p)) - -128));
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*(		ctx->p)) - -128));
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
	}
	switch( _widec ) {
		case 578: goto tr74;
		case 584: goto tr5;
		case 610: goto tr74;
		case 616: goto tr5;
	}
	if ( _widec < 562 ) {
		if ( 560 <= _widec && _widec <= 561 )
			goto tr26;
	} else if ( _widec > 569 ) {
		if ( _widec > 582 ) {
			if ( 609 <= _widec && _widec <= 614 )
				goto st3;
		} else if ( _widec >= 577 )
			goto st3;
	} else
		goto tr71;
	goto tr70;
tr71:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 116 "scan.rl"
	{(	ctx->act) = 15;}
	goto st19;
st19:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof19;
case 19:
//#line 1953 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 72 ) {
		if ( (*(		ctx->p)) > 57 ) {
			if ( 65 <= (*(		ctx->p)) && (*(		ctx->p)) <= 70 ) {
				_widec = (short)(128 + ((*(		ctx->p)) - -128));
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) >= 48 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 72 ) {
		if ( (*(		ctx->p)) > 102 ) {
			if ( 104 <= (*(		ctx->p)) && (*(		ctx->p)) <= 104 ) {
				_widec = (short)(128 + ((*(		ctx->p)) - -128));
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) >= 97 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*(		ctx->p)) - -128));
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
	}
	switch( _widec ) {
		case 584: goto tr5;
		case 616: goto tr5;
	}
	if ( _widec < 577 ) {
		if ( 560 <= _widec && _widec <= 569 )
			goto tr71;
	} else if ( _widec > 582 ) {
		if ( 609 <= _widec && _widec <= 614 )
			goto st3;
	} else
		goto st3;
	goto tr70;
st3:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof3;
case 3:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 72 ) {
		if ( (*(		ctx->p)) > 57 ) {
			if ( 65 <= (*(		ctx->p)) && (*(		ctx->p)) <= 70 ) {
				_widec = (short)(128 + ((*(		ctx->p)) - -128));
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) >= 48 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 72 ) {
		if ( (*(		ctx->p)) > 102 ) {
			if ( 104 <= (*(		ctx->p)) && (*(		ctx->p)) <= 104 ) {
				_widec = (short)(128 + ((*(		ctx->p)) - -128));
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) >= 97 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*(		ctx->p)) - -128));
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
	}
	switch( _widec ) {
		case 584: goto tr5;
		case 616: goto tr5;
	}
	if ( _widec < 577 ) {
		if ( 560 <= _widec && _widec <= 569 )
			goto st3;
	} else if ( _widec > 582 ) {
		if ( 609 <= _widec && _widec <= 614 )
			goto st3;
	} else
		goto st3;
	goto tr2;
tr74:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 140 "scan.rl"
	{(	ctx->act) = 19;}
	goto st20;
st20:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof20;
case 20:
//#line 2064 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 72 ) {
		if ( (*(		ctx->p)) > 57 ) {
			if ( 65 <= (*(		ctx->p)) && (*(		ctx->p)) <= 70 ) {
				_widec = (short)(128 + ((*(		ctx->p)) - -128));
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) >= 48 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 72 ) {
		if ( (*(		ctx->p)) > 102 ) {
			if ( 104 <= (*(		ctx->p)) && (*(		ctx->p)) <= 104 ) {
				_widec = (short)(128 + ((*(		ctx->p)) - -128));
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) >= 97 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*(		ctx->p)) - -128));
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
	}
	switch( _widec ) {
		case 584: goto tr5;
		case 616: goto tr5;
	}
	if ( _widec < 577 ) {
		if ( 560 <= _widec && _widec <= 569 )
			goto st3;
	} else if ( _widec > 582 ) {
		if ( 609 <= _widec && _widec <= 614 )
			goto st3;
	} else
		goto st3;
	goto tr75;
tr72:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 140 "scan.rl"
	{(	ctx->act) = 19;}
	goto st21;
tr76:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 152 "scan.rl"
	{(	ctx->act) = 21;}
	goto st21;
st21:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof21;
case 21:
//#line 2129 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 65 ) {
		if ( (*(		ctx->p)) < 49 ) {
			if ( 48 <= (*(		ctx->p)) && (*(		ctx->p)) <= 48 ) {
				_widec = (short)(128 + ((*(		ctx->p)) - -128));
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 49 ) {
			if ( 50 <= (*(		ctx->p)) && (*(		ctx->p)) <= 57 ) {
				_widec = (short)(128 + ((*(		ctx->p)) - -128));
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 70 ) {
		if ( (*(		ctx->p)) < 97 ) {
			if ( 72 <= (*(		ctx->p)) && (*(		ctx->p)) <= 72 ) {
				_widec = (short)(128 + ((*(		ctx->p)) - -128));
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 102 ) {
			if ( 104 <= (*(		ctx->p)) && (*(		ctx->p)) <= 104 ) {
				_widec = (short)(128 + ((*(		ctx->p)) - -128));
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*(		ctx->p)) - -128));
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
	}
	switch( _widec ) {
		case 584: goto tr5;
		case 616: goto tr5;
	}
	if ( _widec < 562 ) {
		if ( 560 <= _widec && _widec <= 561 )
			goto tr76;
	} else if ( _widec > 569 ) {
		if ( _widec > 582 ) {
			if ( 609 <= _widec && _widec <= 614 )
				goto st3;
		} else if ( _widec >= 577 )
			goto st3;
	} else
		goto st3;
	goto tr2;
st4:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof4;
case 4:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 65 ) {
		if ( 48 <= (*(		ctx->p)) && (*(		ctx->p)) <= 57 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 70 ) {
		if ( 97 <= (*(		ctx->p)) && (*(		ctx->p)) <= 102 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*(		ctx->p)) - -128));
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
	}
	if ( _widec < 577 ) {
		if ( 560 <= _widec && _widec <= 569 )
			goto st22;
	} else if ( _widec > 582 ) {
		if ( 609 <= _widec && _widec <= 614 )
			goto st22;
	} else
		goto st22;
	goto tr6;
st22:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof22;
case 22:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 65 ) {
		if ( 48 <= (*(		ctx->p)) && (*(		ctx->p)) <= 57 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 70 ) {
		if ( 97 <= (*(		ctx->p)) && (*(		ctx->p)) <= 102 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*(		ctx->p)) - -128));
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
	}
	if ( _widec < 577 ) {
		if ( 560 <= _widec && _widec <= 569 )
			goto st22;
	} else if ( _widec > 582 ) {
		if ( 609 <= _widec && _widec <= 614 )
			goto st22;
	} else
		goto st22;
	goto tr77;
st23:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof23;
case 23:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) > 9 ) {
		if ( 11 <= (*(		ctx->p)) )
 {			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*(		ctx->p)) - -128));
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
	}
	if ( _widec > 521 ) {
		if ( 523 <= _widec && _widec <= 639 )
			goto st23;
	} else if ( _widec >= 384 )
		goto st23;
	goto tr78;
st24:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof24;
case 24:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 61 ) {
		if ( 60 <= (*(		ctx->p)) && (*(		ctx->p)) <= 60 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 61 ) {
		if ( 62 <= (*(		ctx->p)) && (*(		ctx->p)) <= 62 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*(		ctx->p)) - -128));
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
	}
	switch( _widec ) {
		case 572: goto tr79;
		case 573: goto tr80;
		case 574: goto tr81;
	}
	goto tr58;
st25:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof25;
case 25:
	_widec = (*(		ctx->p));
	if ( 61 <= (*(		ctx->p)) && (*(		ctx->p)) <= 61 ) {
		_widec = (short)(128 + ((*(		ctx->p)) - -128));
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
	}
	if ( _widec == 573 )
		goto tr82;
	goto tr58;
st26:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof26;
case 26:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) > 61 ) {
		if ( 62 <= (*(		ctx->p)) && (*(		ctx->p)) <= 62 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) >= 61 ) {
		_widec = (short)(128 + ((*(		ctx->p)) - -128));
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
	}
	switch( _widec ) {
		case 573: goto tr83;
		case 574: goto tr84;
	}
	goto tr58;
st27:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof27;
case 27:
	_widec = (*(		ctx->p));
	if ( 124 <= (*(		ctx->p)) && (*(		ctx->p)) <= 124 ) {
		_widec = (short)(128 + ((*(		ctx->p)) - -128));
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
	}
	if ( _widec == 636 )
		goto tr85;
	goto tr58;
st28:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof28;
case 28:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 11 ) {
		if ( (*(		ctx->p)) > 9 ) {
			if ( 10 <= (*(		ctx->p)) && (*(		ctx->p)) <= 10 ) {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 60 ) {
		if ( (*(		ctx->p)) > 61 ) {
			if ( 62 <= (*(		ctx->p)) )
 {				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) >= 61 ) {
			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else {
		_widec = (short)(2176 + ((*(		ctx->p)) - -128));
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
	}
	switch( _widec ) {
		case 2570: goto tr14;
		case 3133: goto tr12;
		case 3389: goto tr59;
		case 3645: goto tr86;
	}
	if ( _widec > 2620 ) {
		if ( 2622 <= _widec && _widec <= 2687 )
			goto tr12;
	} else if ( _widec >= 2432 )
		goto tr12;
	goto tr58;
st29:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof29;
case 29:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 11 ) {
		if ( (*(		ctx->p)) > 9 ) {
			if ( 10 <= (*(		ctx->p)) && (*(		ctx->p)) <= 10 ) {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else if ( (*(		ctx->p)) > 33 ) {
		if ( (*(		ctx->p)) > 34 ) {
			if ( 35 <= (*(		ctx->p)) )
 {				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else if ( (*(		ctx->p)) >= 34 ) {
			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else {
		_widec = (short)(2688 + ((*(		ctx->p)) - -128));
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
	}
	switch( _widec ) {
		case 2570: goto tr14;
		case 3362: goto tr61;
		case 3618: goto tr87;
	}
	if ( _widec < 3200 ) {
		if ( _widec > 3081 ) {
			if ( 3083 <= _widec && _widec <= 3199 )
				goto tr12;
		} else if ( _widec >= 2944 )
			goto tr12;
	} else if ( _widec > 3337 ) {
		if ( _widec < 3456 ) {
			if ( 3339 <= _widec && _widec <= 3455 )
				goto st10;
		} else if ( _widec > 3593 ) {
			if ( 3595 <= _widec && _widec <= 3711 )
				goto st29;
		} else
			goto st29;
	} else
		goto st10;
	goto tr60;
tr35:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 102 "scan.rl"
	{(	ctx->act) = 4;}
	goto st30;
tr88:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 128 "scan.rl"
	{(	ctx->act) = 17;}
	goto st30;
st30:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof30;
case 30:
//#line 2513 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 58 ) {
		if ( (*(		ctx->p)) < 10 ) {
			if ( (*(		ctx->p)) <= 9 ) {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 10 ) {
			if ( (*(		ctx->p)) > 47 ) {
				if ( 48 <= (*(		ctx->p)) && (*(		ctx->p)) <= 57 ) {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else if ( (*(		ctx->p)) >= 11 ) {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 64 ) {
		if ( (*(		ctx->p)) < 71 ) {
			if ( 65 <= (*(		ctx->p)) && (*(		ctx->p)) <= 70 ) {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else if ( (*(		ctx->p)) > 96 ) {
			if ( (*(		ctx->p)) > 102 ) {
				if ( 103 <= (*(		ctx->p)) )
 {					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) >= 97 ) {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else {
		_widec = (short)(2176 + ((*(		ctx->p)) - -128));
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
	}
	if ( _widec == 2570 )
		goto tr14;
	if ( _widec < 3169 ) {
		if ( _widec < 2631 ) {
			if ( _widec > 2607 ) {
				if ( 2618 <= _widec && _widec <= 2624 )
					goto tr12;
			} else if ( _widec >= 2432 )
				goto tr12;
		} else if ( _widec > 2656 ) {
			if ( _widec < 3120 ) {
				if ( 2663 <= _widec && _widec <= 2687 )
					goto tr12;
			} else if ( _widec > 3129 ) {
				if ( 3137 <= _widec && _widec <= 3142 )
					goto tr12;
			} else
				goto tr12;
		} else
			goto tr12;
	} else if ( _widec > 3174 ) {
		if ( _widec < 3425 ) {
			if ( _widec > 3385 ) {
				if ( 3393 <= _widec && _widec <= 3398 )
					goto tr62;
			} else if ( _widec >= 3376 )
				goto tr62;
		} else if ( _widec > 3430 ) {
			if ( _widec < 3649 ) {
				if ( 3632 <= _widec && _widec <= 3641 )
					goto tr88;
			} else if ( _widec > 3654 ) {
				if ( 3681 <= _widec && _widec <= 3686 )
					goto tr88;
			} else
				goto tr88;
		} else
			goto tr62;
	} else
		goto tr12;
	goto tr2;
tr36:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 102 "scan.rl"
	{(	ctx->act) = 4;}
	goto st31;
st31:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof31;
case 31:
//#line 2637 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 34 ) {
		if ( (*(		ctx->p)) < 10 ) {
			if ( (*(		ctx->p)) <= 9 ) {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 10 ) {
			if ( 11 <= (*(		ctx->p)) && (*(		ctx->p)) <= 33 ) {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 34 ) {
		if ( (*(		ctx->p)) < 48 ) {
			if ( 35 <= (*(		ctx->p)) && (*(		ctx->p)) <= 47 ) {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 48 ) {
			if ( (*(		ctx->p)) > 49 ) {
				if ( 50 <= (*(		ctx->p)) )
 {					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) >= 49 ) {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else {
			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else {
		_widec = (short)(2688 + ((*(		ctx->p)) - -128));
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
	}
	switch( _widec ) {
		case 2570: goto tr14;
		case 3106: goto tr12;
		case 3362: goto st1;
		case 3618: goto tr89;
	}
	if ( _widec < 2610 ) {
		if ( _widec > 2593 ) {
			if ( 2595 <= _widec && _widec <= 2607 )
				goto tr12;
		} else if ( _widec >= 2432 )
			goto tr12;
	} else if ( _widec > 2687 ) {
		if ( _widec < 3376 ) {
			if ( 3120 <= _widec && _widec <= 3121 )
				goto tr12;
		} else if ( _widec > 3377 ) {
			if ( 3632 <= _widec && _widec <= 3633 )
				goto st34;
		} else
			goto st13;
	} else
		goto tr12;
	goto tr58;
tr89:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 221 "scan.rl"
	{(	ctx->act) = 29;}
	goto st32;
st32:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof32;
case 32:
//#line 2737 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 35 ) {
		if ( (*(		ctx->p)) < 10 ) {
			if ( (*(		ctx->p)) <= 9 ) {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 10 ) {
			if ( 11 <= (*(		ctx->p)) && (*(		ctx->p)) <= 34 ) {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 35 ) {
		if ( (*(		ctx->p)) < 45 ) {
			if ( 36 <= (*(		ctx->p)) && (*(		ctx->p)) <= 44 ) {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 45 ) {
			if ( 46 <= (*(		ctx->p)) )
 {				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else {
		_widec = (short)(2688 + ((*(		ctx->p)) - -128));
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
	}
	switch( _widec ) {
		case 2570: goto tr14;
		case 3107: goto tr12;
		case 3117: goto tr12;
		case 3363: goto st2;
		case 3373: goto st2;
		case 3619: goto tr92;
		case 3629: goto tr92;
	}
	if ( _widec < 2596 ) {
		if ( 2432 <= _widec && _widec <= 2594 )
			goto tr12;
	} else if ( _widec > 2604 ) {
		if ( 2606 <= _widec && _widec <= 2687 )
			goto tr12;
	} else
		goto tr12;
	goto tr91;
tr92:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 221 "scan.rl"
	{(	ctx->act) = 29;}
	goto st33;
st33:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof33;
case 33:
//#line 2821 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 34 ) {
		if ( (*(		ctx->p)) < 10 ) {
			if ( (*(		ctx->p)) <= 9 ) {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 10 ) {
			if ( 11 <= (*(		ctx->p)) && (*(		ctx->p)) <= 33 ) {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 34 ) {
		if ( (*(		ctx->p)) < 36 ) {
			if ( 35 <= (*(		ctx->p)) && (*(		ctx->p)) <= 35 ) {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else if ( (*(		ctx->p)) > 44 ) {
			if ( (*(		ctx->p)) > 45 ) {
				if ( 46 <= (*(		ctx->p)) )
 {					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) >= 45 ) {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else {
		_widec = (short)(2688 + ((*(		ctx->p)) - -128));
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
	}
	switch( _widec ) {
		case 2570: goto tr14;
		case 3117: goto tr12;
		case 3362: goto tr3;
		case 3363: goto st2;
		case 3373: goto st2;
		case 3618: goto tr93;
		case 3619: goto tr92;
		case 3629: goto tr92;
	}
	if ( _widec < 2596 ) {
		if ( 2432 <= _widec && _widec <= 2593 )
			goto tr12;
	} else if ( _widec > 2604 ) {
		if ( _widec > 2687 ) {
			if ( 3106 <= _widec && _widec <= 3107 )
				goto tr12;
		} else if ( _widec >= 2606 )
			goto tr12;
	} else
		goto tr12;
	goto tr91;
st34:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof34;
case 34:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 11 ) {
		if ( (*(		ctx->p)) > 9 ) {
			if ( 10 <= (*(		ctx->p)) && (*(		ctx->p)) <= 10 ) {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 47 ) {
		if ( (*(		ctx->p)) < 49 ) {
			if ( 48 <= (*(		ctx->p)) && (*(		ctx->p)) <= 48 ) {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else if ( (*(		ctx->p)) > 49 ) {
			if ( 50 <= (*(		ctx->p)) )
 {				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else {
		_widec = (short)(2176 + ((*(		ctx->p)) - -128));
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
	}
	if ( _widec == 2570 )
		goto tr14;
	if ( _widec < 3120 ) {
		if ( _widec > 2607 ) {
			if ( 2610 <= _widec && _widec <= 2687 )
				goto tr12;
		} else if ( _widec >= 2432 )
			goto tr12;
	} else if ( _widec > 3121 ) {
		if ( _widec > 3377 ) {
			if ( 3632 <= _widec && _widec <= 3633 )
				goto st34;
		} else if ( _widec >= 3376 )
			goto st13;
	} else
		goto tr12;
	goto tr65;
st35:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof35;
case 35:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 11 ) {
		if ( (*(		ctx->p)) > 9 ) {
			if ( 10 <= (*(		ctx->p)) && (*(		ctx->p)) <= 10 ) {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 37 ) {
		if ( (*(		ctx->p)) > 38 ) {
			if ( 39 <= (*(		ctx->p)) )
 {				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) >= 38 ) {
			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else {
		_widec = (short)(2176 + ((*(		ctx->p)) - -128));
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
	}
	switch( _widec ) {
		case 2570: goto tr14;
		case 3110: goto tr12;
		case 3366: goto tr66;
		case 3622: goto tr94;
	}
	if ( _widec > 2597 ) {
		if ( 2599 <= _widec && _widec <= 2687 )
			goto tr12;
	} else if ( _widec >= 2432 )
		goto tr12;
	goto tr58;
st36:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof36;
case 36:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 11 ) {
		if ( (*(		ctx->p)) > 9 ) {
			if ( 10 <= (*(		ctx->p)) && (*(		ctx->p)) <= 10 ) {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else if ( (*(		ctx->p)) > 38 ) {
		if ( (*(		ctx->p)) > 39 ) {
			if ( 40 <= (*(		ctx->p)) )
 {				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else if ( (*(		ctx->p)) >= 39 ) {
			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else {
		_widec = (short)(2688 + ((*(		ctx->p)) - -128));
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
	}
	switch( _widec ) {
		case 2570: goto tr14;
		case 3367: goto tr68;
		case 3623: goto tr95;
	}
	if ( _widec < 3200 ) {
		if ( _widec > 3081 ) {
			if ( 3083 <= _widec && _widec <= 3199 )
				goto tr12;
		} else if ( _widec >= 2944 )
			goto tr12;
	} else if ( _widec > 3337 ) {
		if ( _widec < 3456 ) {
			if ( 3339 <= _widec && _widec <= 3455 )
				goto st15;
		} else if ( _widec > 3593 ) {
			if ( 3595 <= _widec && _widec <= 3711 )
				goto st36;
		} else
			goto st36;
	} else
		goto st15;
	goto tr67;
st37:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof37;
case 37:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 11 ) {
		if ( (*(		ctx->p)) > 9 ) {
			if ( 10 <= (*(		ctx->p)) && (*(		ctx->p)) <= 10 ) {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 41 ) {
		if ( (*(		ctx->p)) > 42 ) {
			if ( 43 <= (*(		ctx->p)) )
 {				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) >= 42 ) {
			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else {
		_widec = (short)(2176 + ((*(		ctx->p)) - -128));
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
	}
	switch( _widec ) {
		case 2570: goto tr14;
		case 3114: goto tr12;
		case 3370: goto tr69;
		case 3626: goto tr96;
	}
	if ( _widec > 2601 ) {
		if ( 2603 <= _widec && _widec <= 2687 )
			goto tr12;
	} else if ( _widec >= 2432 )
		goto tr12;
	goto tr58;
tr41:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 116 "scan.rl"
	{(	ctx->act) = 15;}
	goto st38;
st38:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof38;
case 38:
//#line 3170 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 72 ) {
		if ( (*(		ctx->p)) < 50 ) {
			if ( (*(		ctx->p)) < 11 ) {
				if ( (*(		ctx->p)) > 9 ) {
					if ( 10 <= (*(		ctx->p)) && (*(		ctx->p)) <= 10 ) {
						_widec = (short)(2176 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					}
				} else {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) > 47 ) {
				if ( (*(		ctx->p)) > 48 ) {
					if ( 49 <= (*(		ctx->p)) && (*(		ctx->p)) <= 49 ) {
						_widec = (short)(2688 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
						if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
					}
				} else if ( (*(		ctx->p)) >= 48 ) {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 57 ) {
			if ( (*(		ctx->p)) < 66 ) {
				if ( (*(		ctx->p)) > 64 ) {
					if ( 65 <= (*(		ctx->p)) && (*(		ctx->p)) <= 65 ) {
						_widec = (short)(2688 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
						if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
					}
				} else if ( (*(		ctx->p)) >= 58 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) > 66 ) {
				if ( (*(		ctx->p)) > 70 ) {
					if ( 71 <= (*(		ctx->p)) && (*(		ctx->p)) <= 71 ) {
						_widec = (short)(2176 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					}
				} else if ( (*(		ctx->p)) >= 67 ) {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else {
			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else if ( (*(		ctx->p)) > 72 ) {
		if ( (*(		ctx->p)) < 99 ) {
			if ( (*(		ctx->p)) < 89 ) {
				if ( (*(		ctx->p)) > 87 ) {
					if ( 88 <= (*(		ctx->p)) && (*(		ctx->p)) <= 88 ) {
						_widec = (short)(2688 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
						if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
					}
				} else if ( (*(		ctx->p)) >= 73 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) > 96 ) {
				if ( (*(		ctx->p)) > 97 ) {
					if ( 98 <= (*(		ctx->p)) && (*(		ctx->p)) <= 98 ) {
						_widec = (short)(2688 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
						if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
					}
				} else if ( (*(		ctx->p)) >= 97 ) {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 102 ) {
			if ( (*(		ctx->p)) < 105 ) {
				if ( (*(		ctx->p)) > 103 ) {
					if ( 104 <= (*(		ctx->p)) && (*(		ctx->p)) <= 104 ) {
						_widec = (short)(2688 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
						if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
					}
				} else if ( (*(		ctx->p)) >= 103 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) > 119 ) {
				if ( (*(		ctx->p)) > 120 ) {
					if ( 121 <= (*(		ctx->p)) )
 {						_widec = (short)(2176 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					}
				} else if ( (*(		ctx->p)) >= 120 ) {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else {
		_widec = (short)(2688 + ((*(		ctx->p)) - -128));
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
	}
	switch( _widec ) {
		case 2570: goto tr14;
		case 2631: goto tr12;
		case 2663: goto tr12;
		case 3144: goto tr12;
		case 3160: goto tr12;
		case 3176: goto tr12;
		case 3192: goto tr12;
		case 3394: goto tr72;
		case 3400: goto tr5;
		case 3416: goto st4;
		case 3426: goto tr72;
		case 3432: goto tr5;
		case 3448: goto st4;
		case 3650: goto tr99;
		case 3656: goto tr100;
		case 3672: goto tr101;
		case 3682: goto tr99;
		case 3688: goto tr100;
		case 3704: goto tr101;
	}
	if ( _widec < 3169 ) {
		if ( _widec < 2649 ) {
			if ( _widec < 2618 ) {
				if ( 2432 <= _widec && _widec <= 2607 )
					goto tr12;
			} else if ( _widec > 2624 ) {
				if ( 2633 <= _widec && _widec <= 2647 )
					goto tr12;
			} else
				goto tr12;
		} else if ( _widec > 2656 ) {
			if ( _widec < 2681 ) {
				if ( 2665 <= _widec && _widec <= 2679 )
					goto tr12;
			} else if ( _widec > 2687 ) {
				if ( _widec > 3129 ) {
					if ( 3137 <= _widec && _widec <= 3142 )
						goto tr12;
				} else if ( _widec >= 3120 )
					goto tr12;
			} else
				goto tr12;
		} else
			goto tr12;
	} else if ( _widec > 3174 ) {
		if ( _widec < 3425 ) {
			if ( _widec < 3378 ) {
				if ( 3376 <= _widec && _widec <= 3377 )
					goto tr26;
			} else if ( _widec > 3385 ) {
				if ( 3393 <= _widec && _widec <= 3398 )
					goto st3;
			} else
				goto tr71;
		} else if ( _widec > 3430 ) {
			if ( _widec < 3634 ) {
				if ( 3632 <= _widec && _widec <= 3633 )
					goto tr42;
			} else if ( _widec > 3641 ) {
				if ( _widec > 3654 ) {
					if ( 3681 <= _widec && _widec <= 3686 )
						goto tr98;
				} else if ( _widec >= 3649 )
					goto tr98;
			} else
				goto tr97;
		} else
			goto st3;
	} else
		goto tr12;
	goto tr70;
tr42:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 116 "scan.rl"
	{(	ctx->act) = 15;}
	goto st39;
st39:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof39;
case 39:
//#line 3453 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 67 ) {
		if ( (*(		ctx->p)) < 49 ) {
			if ( (*(		ctx->p)) < 10 ) {
				if ( (*(		ctx->p)) <= 9 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) > 10 ) {
				if ( (*(		ctx->p)) > 47 ) {
					if ( 48 <= (*(		ctx->p)) && (*(		ctx->p)) <= 48 ) {
						_widec = (short)(2688 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
						if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
					}
				} else if ( (*(		ctx->p)) >= 11 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 49 ) {
			if ( (*(		ctx->p)) < 58 ) {
				if ( 50 <= (*(		ctx->p)) && (*(		ctx->p)) <= 57 ) {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else if ( (*(		ctx->p)) > 64 ) {
				if ( (*(		ctx->p)) > 65 ) {
					if ( 66 <= (*(		ctx->p)) && (*(		ctx->p)) <= 66 ) {
						_widec = (short)(2688 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
						if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
					}
				} else if ( (*(		ctx->p)) >= 65 ) {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else if ( (*(		ctx->p)) > 70 ) {
		if ( (*(		ctx->p)) < 98 ) {
			if ( (*(		ctx->p)) < 72 ) {
				if ( 71 <= (*(		ctx->p)) && (*(		ctx->p)) <= 71 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) > 72 ) {
				if ( (*(		ctx->p)) > 96 ) {
					if ( 97 <= (*(		ctx->p)) && (*(		ctx->p)) <= 97 ) {
						_widec = (short)(2688 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
						if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
					}
				} else if ( (*(		ctx->p)) >= 73 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else if ( (*(		ctx->p)) > 98 ) {
			if ( (*(		ctx->p)) < 103 ) {
				if ( 99 <= (*(		ctx->p)) && (*(		ctx->p)) <= 102 ) {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else if ( (*(		ctx->p)) > 103 ) {
				if ( (*(		ctx->p)) > 104 ) {
					if ( 105 <= (*(		ctx->p)) )
 {						_widec = (short)(2176 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					}
				} else if ( (*(		ctx->p)) >= 104 ) {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else {
		_widec = (short)(2688 + ((*(		ctx->p)) - -128));
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
	}
	switch( _widec ) {
		case 2570: goto tr14;
		case 2631: goto tr12;
		case 2663: goto tr12;
		case 3144: goto tr12;
		case 3176: goto tr12;
		case 3394: goto tr74;
		case 3400: goto tr5;
		case 3426: goto tr74;
		case 3432: goto tr5;
		case 3650: goto tr102;
		case 3656: goto tr100;
		case 3682: goto tr102;
		case 3688: goto tr100;
	}
	if ( _widec < 3376 ) {
		if ( _widec < 2665 ) {
			if ( _widec < 2618 ) {
				if ( 2432 <= _widec && _widec <= 2607 )
					goto tr12;
			} else if ( _widec > 2624 ) {
				if ( 2633 <= _widec && _widec <= 2656 )
					goto tr12;
			} else
				goto tr12;
		} else if ( _widec > 2687 ) {
			if ( _widec < 3137 ) {
				if ( 3120 <= _widec && _widec <= 3129 )
					goto tr12;
			} else if ( _widec > 3142 ) {
				if ( 3169 <= _widec && _widec <= 3174 )
					goto tr12;
			} else
				goto tr12;
		} else
			goto tr12;
	} else if ( _widec > 3377 ) {
		if ( _widec < 3632 ) {
			if ( _widec < 3393 ) {
				if ( 3378 <= _widec && _widec <= 3385 )
					goto tr71;
			} else if ( _widec > 3398 ) {
				if ( 3425 <= _widec && _widec <= 3430 )
					goto st3;
			} else
				goto st3;
		} else if ( _widec > 3633 ) {
			if ( _widec < 3649 ) {
				if ( 3634 <= _widec && _widec <= 3641 )
					goto tr97;
			} else if ( _widec > 3654 ) {
				if ( 3681 <= _widec && _widec <= 3686 )
					goto tr98;
			} else
				goto tr98;
		} else
			goto tr42;
	} else
		goto tr26;
	goto tr70;
tr97:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 116 "scan.rl"
	{(	ctx->act) = 15;}
	goto st40;
st40:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof40;
case 40:
//#line 3690 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 71 ) {
		if ( (*(		ctx->p)) < 11 ) {
			if ( (*(		ctx->p)) > 9 ) {
				if ( 10 <= (*(		ctx->p)) && (*(		ctx->p)) <= 10 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 47 ) {
			if ( (*(		ctx->p)) < 58 ) {
				if ( 48 <= (*(		ctx->p)) && (*(		ctx->p)) <= 57 ) {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else if ( (*(		ctx->p)) > 64 ) {
				if ( 65 <= (*(		ctx->p)) && (*(		ctx->p)) <= 70 ) {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 71 ) {
		if ( (*(		ctx->p)) < 97 ) {
			if ( (*(		ctx->p)) > 72 ) {
				if ( 73 <= (*(		ctx->p)) && (*(		ctx->p)) <= 96 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) >= 72 ) {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else if ( (*(		ctx->p)) > 102 ) {
			if ( (*(		ctx->p)) < 104 ) {
				if ( 103 <= (*(		ctx->p)) && (*(		ctx->p)) <= 103 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) > 104 ) {
				if ( 105 <= (*(		ctx->p)) )
 {					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else {
			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else {
		_widec = (short)(2176 + ((*(		ctx->p)) - -128));
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
	}
	switch( _widec ) {
		case 2570: goto tr14;
		case 2631: goto tr12;
		case 2663: goto tr12;
		case 3144: goto tr12;
		case 3176: goto tr12;
		case 3400: goto tr5;
		case 3432: goto tr5;
		case 3656: goto tr100;
		case 3688: goto tr100;
	}
	if ( _widec < 3169 ) {
		if ( _widec < 2633 ) {
			if ( _widec > 2607 ) {
				if ( 2618 <= _widec && _widec <= 2624 )
					goto tr12;
			} else if ( _widec >= 2432 )
				goto tr12;
		} else if ( _widec > 2656 ) {
			if ( _widec < 3120 ) {
				if ( 2665 <= _widec && _widec <= 2687 )
					goto tr12;
			} else if ( _widec > 3129 ) {
				if ( 3137 <= _widec && _widec <= 3142 )
					goto tr12;
			} else
				goto tr12;
		} else
			goto tr12;
	} else if ( _widec > 3174 ) {
		if ( _widec < 3425 ) {
			if ( _widec > 3385 ) {
				if ( 3393 <= _widec && _widec <= 3398 )
					goto st3;
			} else if ( _widec >= 3376 )
				goto tr71;
		} else if ( _widec > 3430 ) {
			if ( _widec < 3649 ) {
				if ( 3632 <= _widec && _widec <= 3641 )
					goto tr97;
			} else if ( _widec > 3654 ) {
				if ( 3681 <= _widec && _widec <= 3686 )
					goto tr98;
			} else
				goto tr98;
		} else
			goto st3;
	} else
		goto tr12;
	goto tr70;
tr98:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 221 "scan.rl"
	{(	ctx->act) = 29;}
	goto st41;
tr102:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 140 "scan.rl"
	{(	ctx->act) = 19;}
	goto st41;
st41:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof41;
case 41:
//#line 3863 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 71 ) {
		if ( (*(		ctx->p)) < 11 ) {
			if ( (*(		ctx->p)) > 9 ) {
				if ( 10 <= (*(		ctx->p)) && (*(		ctx->p)) <= 10 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 47 ) {
			if ( (*(		ctx->p)) < 58 ) {
				if ( 48 <= (*(		ctx->p)) && (*(		ctx->p)) <= 57 ) {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else if ( (*(		ctx->p)) > 64 ) {
				if ( 65 <= (*(		ctx->p)) && (*(		ctx->p)) <= 70 ) {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 71 ) {
		if ( (*(		ctx->p)) < 97 ) {
			if ( (*(		ctx->p)) > 72 ) {
				if ( 73 <= (*(		ctx->p)) && (*(		ctx->p)) <= 96 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) >= 72 ) {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else if ( (*(		ctx->p)) > 102 ) {
			if ( (*(		ctx->p)) < 104 ) {
				if ( 103 <= (*(		ctx->p)) && (*(		ctx->p)) <= 103 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) > 104 ) {
				if ( 105 <= (*(		ctx->p)) )
 {					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else {
			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else {
		_widec = (short)(2176 + ((*(		ctx->p)) - -128));
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
	}
	switch( _widec ) {
		case 2570: goto tr14;
		case 2631: goto tr12;
		case 2663: goto tr12;
		case 3144: goto tr12;
		case 3176: goto tr12;
		case 3400: goto tr5;
		case 3432: goto tr5;
		case 3656: goto tr100;
		case 3688: goto tr100;
	}
	if ( _widec < 3169 ) {
		if ( _widec < 2633 ) {
			if ( _widec > 2607 ) {
				if ( 2618 <= _widec && _widec <= 2624 )
					goto tr12;
			} else if ( _widec >= 2432 )
				goto tr12;
		} else if ( _widec > 2656 ) {
			if ( _widec < 3120 ) {
				if ( 2665 <= _widec && _widec <= 2687 )
					goto tr12;
			} else if ( _widec > 3129 ) {
				if ( 3137 <= _widec && _widec <= 3142 )
					goto tr12;
			} else
				goto tr12;
		} else
			goto tr12;
	} else if ( _widec > 3174 ) {
		if ( _widec < 3425 ) {
			if ( _widec > 3385 ) {
				if ( 3393 <= _widec && _widec <= 3398 )
					goto st3;
			} else if ( _widec >= 3376 )
				goto st3;
		} else if ( _widec > 3430 ) {
			if ( _widec < 3649 ) {
				if ( 3632 <= _widec && _widec <= 3641 )
					goto tr98;
			} else if ( _widec > 3654 ) {
				if ( 3681 <= _widec && _widec <= 3686 )
					goto tr98;
			} else
				goto tr98;
		} else
			goto st3;
	} else
		goto tr12;
	goto tr2;
tr99:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 140 "scan.rl"
	{(	ctx->act) = 19;}
	goto st42;
tr103:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 152 "scan.rl"
	{(	ctx->act) = 21;}
	goto st42;
st42:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof42;
case 42:
//#line 4036 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 65 ) {
		if ( (*(		ctx->p)) < 48 ) {
			if ( (*(		ctx->p)) < 10 ) {
				if ( (*(		ctx->p)) <= 9 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) > 10 ) {
				if ( 11 <= (*(		ctx->p)) && (*(		ctx->p)) <= 47 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 48 ) {
			if ( (*(		ctx->p)) < 50 ) {
				if ( 49 <= (*(		ctx->p)) && (*(		ctx->p)) <= 49 ) {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else if ( (*(		ctx->p)) > 57 ) {
				if ( 58 <= (*(		ctx->p)) && (*(		ctx->p)) <= 64 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else {
			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else if ( (*(		ctx->p)) > 70 ) {
		if ( (*(		ctx->p)) < 97 ) {
			if ( (*(		ctx->p)) < 72 ) {
				if ( 71 <= (*(		ctx->p)) && (*(		ctx->p)) <= 71 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) > 72 ) {
				if ( 73 <= (*(		ctx->p)) && (*(		ctx->p)) <= 96 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else if ( (*(		ctx->p)) > 102 ) {
			if ( (*(		ctx->p)) < 104 ) {
				if ( 103 <= (*(		ctx->p)) && (*(		ctx->p)) <= 103 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) > 104 ) {
				if ( 105 <= (*(		ctx->p)) )
 {					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else {
			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else {
		_widec = (short)(2688 + ((*(		ctx->p)) - -128));
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
	}
	switch( _widec ) {
		case 2570: goto tr14;
		case 2631: goto tr12;
		case 2663: goto tr12;
		case 3144: goto tr12;
		case 3176: goto tr12;
		case 3400: goto tr5;
		case 3432: goto tr5;
		case 3656: goto tr100;
		case 3688: goto tr100;
	}
	if ( _widec < 3376 ) {
		if ( _widec < 2665 ) {
			if ( _widec < 2618 ) {
				if ( 2432 <= _widec && _widec <= 2607 )
					goto tr12;
			} else if ( _widec > 2624 ) {
				if ( 2633 <= _widec && _widec <= 2656 )
					goto tr12;
			} else
				goto tr12;
		} else if ( _widec > 2687 ) {
			if ( _widec < 3137 ) {
				if ( 3120 <= _widec && _widec <= 3129 )
					goto tr12;
			} else if ( _widec > 3142 ) {
				if ( 3169 <= _widec && _widec <= 3174 )
					goto tr12;
			} else
				goto tr12;
		} else
			goto tr12;
	} else if ( _widec > 3377 ) {
		if ( _widec < 3632 ) {
			if ( _widec < 3393 ) {
				if ( 3378 <= _widec && _widec <= 3385 )
					goto st3;
			} else if ( _widec > 3398 ) {
				if ( 3425 <= _widec && _widec <= 3430 )
					goto st3;
			} else
				goto st3;
		} else if ( _widec > 3633 ) {
			if ( _widec < 3649 ) {
				if ( 3634 <= _widec && _widec <= 3641 )
					goto tr98;
			} else if ( _widec > 3654 ) {
				if ( 3681 <= _widec && _widec <= 3686 )
					goto tr98;
			} else
				goto tr98;
		} else
			goto tr103;
	} else
		goto tr76;
	goto tr2;
tr101:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 221 "scan.rl"
	{(	ctx->act) = 29;}
	goto st43;
tr104:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 134 "scan.rl"
	{(	ctx->act) = 18;}
	goto st43;
st43:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof43;
case 43:
//#line 4235 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 58 ) {
		if ( (*(		ctx->p)) < 10 ) {
			if ( (*(		ctx->p)) <= 9 ) {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 10 ) {
			if ( (*(		ctx->p)) > 47 ) {
				if ( 48 <= (*(		ctx->p)) && (*(		ctx->p)) <= 57 ) {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else if ( (*(		ctx->p)) >= 11 ) {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 64 ) {
		if ( (*(		ctx->p)) < 71 ) {
			if ( 65 <= (*(		ctx->p)) && (*(		ctx->p)) <= 70 ) {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else if ( (*(		ctx->p)) > 96 ) {
			if ( (*(		ctx->p)) > 102 ) {
				if ( 103 <= (*(		ctx->p)) )
 {					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) >= 97 ) {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else {
		_widec = (short)(2176 + ((*(		ctx->p)) - -128));
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
	}
	if ( _widec == 2570 )
		goto tr14;
	if ( _widec < 3169 ) {
		if ( _widec < 2631 ) {
			if ( _widec > 2607 ) {
				if ( 2618 <= _widec && _widec <= 2624 )
					goto tr12;
			} else if ( _widec >= 2432 )
				goto tr12;
		} else if ( _widec > 2656 ) {
			if ( _widec < 3120 ) {
				if ( 2663 <= _widec && _widec <= 2687 )
					goto tr12;
			} else if ( _widec > 3129 ) {
				if ( 3137 <= _widec && _widec <= 3142 )
					goto tr12;
			} else
				goto tr12;
		} else
			goto tr12;
	} else if ( _widec > 3174 ) {
		if ( _widec < 3425 ) {
			if ( _widec > 3385 ) {
				if ( 3393 <= _widec && _widec <= 3398 )
					goto st22;
			} else if ( _widec >= 3376 )
				goto st22;
		} else if ( _widec > 3430 ) {
			if ( _widec < 3649 ) {
				if ( 3632 <= _widec && _widec <= 3641 )
					goto tr104;
			} else if ( _widec > 3654 ) {
				if ( 3681 <= _widec && _widec <= 3686 )
					goto tr104;
			} else
				goto tr104;
		} else
			goto st22;
	} else
		goto tr12;
	goto tr2;
st44:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof44;
case 44:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 10 ) {
		if ( (*(		ctx->p)) <= 9 ) {
			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else if ( (*(		ctx->p)) > 10 ) {
		if ( 11 <= (*(		ctx->p)) )
 {			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else {
		_widec = (short)(2176 + ((*(		ctx->p)) - -128));
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
	}
	if ( _widec == 2570 )
		goto tr14;
	if ( _widec < 3200 ) {
		if ( _widec > 3081 ) {
			if ( 3083 <= _widec && _widec <= 3199 )
				goto tr12;
		} else if ( _widec >= 2944 )
			goto tr12;
	} else if ( _widec > 3337 ) {
		if ( _widec < 3456 ) {
			if ( 3339 <= _widec && _widec <= 3455 )
				goto st23;
		} else if ( _widec > 3593 ) {
			if ( 3595 <= _widec && _widec <= 3711 )
				goto st44;
		} else
			goto st44;
	} else
		goto st23;
	goto tr78;
st45:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof45;
case 45:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 60 ) {
		if ( (*(		ctx->p)) < 10 ) {
			if ( (*(		ctx->p)) <= 9 ) {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 10 ) {
			if ( 11 <= (*(		ctx->p)) && (*(		ctx->p)) <= 59 ) {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 60 ) {
		if ( (*(		ctx->p)) < 62 ) {
			if ( 61 <= (*(		ctx->p)) && (*(		ctx->p)) <= 61 ) {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else if ( (*(		ctx->p)) > 62 ) {
			if ( 63 <= (*(		ctx->p)) )
 {				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else {
		_widec = (short)(2688 + ((*(		ctx->p)) - -128));
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
	}
	switch( _widec ) {
		case 2570: goto tr14;
		case 3388: goto tr79;
		case 3389: goto tr80;
		case 3390: goto tr81;
		case 3644: goto tr105;
		case 3645: goto tr106;
		case 3646: goto tr107;
	}
	if ( _widec < 2623 ) {
		if ( 2432 <= _widec && _widec <= 2619 )
			goto tr12;
	} else if ( _widec > 2687 ) {
		if ( 3132 <= _widec && _widec <= 3134 )
			goto tr12;
	} else
		goto tr12;
	goto tr58;
st46:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof46;
case 46:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 11 ) {
		if ( (*(		ctx->p)) > 9 ) {
			if ( 10 <= (*(		ctx->p)) && (*(		ctx->p)) <= 10 ) {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 60 ) {
		if ( (*(		ctx->p)) > 61 ) {
			if ( 62 <= (*(		ctx->p)) )
 {				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) >= 61 ) {
			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else {
		_widec = (short)(2176 + ((*(		ctx->p)) - -128));
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
	}
	switch( _widec ) {
		case 2570: goto tr14;
		case 3133: goto tr12;
		case 3389: goto tr82;
		case 3645: goto tr108;
	}
	if ( _widec > 2620 ) {
		if ( 2622 <= _widec && _widec <= 2687 )
			goto tr12;
	} else if ( _widec >= 2432 )
		goto tr12;
	goto tr58;
st47:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof47;
case 47:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 11 ) {
		if ( (*(		ctx->p)) > 9 ) {
			if ( 10 <= (*(		ctx->p)) && (*(		ctx->p)) <= 10 ) {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 60 ) {
		if ( (*(		ctx->p)) < 62 ) {
			if ( 61 <= (*(		ctx->p)) && (*(		ctx->p)) <= 61 ) {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else if ( (*(		ctx->p)) > 62 ) {
			if ( 63 <= (*(		ctx->p)) )
 {				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else {
		_widec = (short)(2176 + ((*(		ctx->p)) - -128));
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
	}
	switch( _widec ) {
		case 2570: goto tr14;
		case 3389: goto tr83;
		case 3390: goto tr84;
		case 3645: goto tr109;
		case 3646: goto tr110;
	}
	if ( _widec < 2623 ) {
		if ( 2432 <= _widec && _widec <= 2620 )
			goto tr12;
	} else if ( _widec > 2687 ) {
		if ( 3133 <= _widec && _widec <= 3134 )
			goto tr12;
	} else
		goto tr12;
	goto tr58;
st48:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof48;
case 48:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 11 ) {
		if ( (*(		ctx->p)) > 9 ) {
			if ( 10 <= (*(		ctx->p)) && (*(		ctx->p)) <= 10 ) {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 123 ) {
		if ( (*(		ctx->p)) > 124 ) {
			if ( 125 <= (*(		ctx->p)) )
 {				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) >= 124 ) {
			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else {
		_widec = (short)(2176 + ((*(		ctx->p)) - -128));
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
	}
	switch( _widec ) {
		case 2570: goto tr14;
		case 3196: goto tr12;
		case 3452: goto tr85;
		case 3708: goto tr111;
	}
	if ( _widec > 2683 ) {
		if ( 2685 <= _widec && _widec <= 2687 )
			goto tr12;
	} else if ( _widec >= 2432 )
		goto tr12;
	goto tr58;
st49:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof49;
case 49:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 71 ) {
		if ( (*(		ctx->p)) < 65 ) {
			if ( 48 <= (*(		ctx->p)) && (*(		ctx->p)) <= 57 ) {
				_widec = (short)(128 + ((*(		ctx->p)) - -128));
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 69 ) {
			if ( 70 <= (*(		ctx->p)) && (*(		ctx->p)) <= 70 ) {
				_widec = (short)(128 + ((*(		ctx->p)) - -128));
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 90 ) {
		if ( (*(		ctx->p)) < 97 ) {
			if ( 95 <= (*(		ctx->p)) && (*(		ctx->p)) <= 95 ) {
				_widec = (short)(128 + ((*(		ctx->p)) - -128));
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 101 ) {
			if ( (*(		ctx->p)) > 102 ) {
				if ( 103 <= (*(		ctx->p)) && (*(		ctx->p)) <= 122 ) {
					_widec = (short)(128 + ((*(		ctx->p)) - -128));
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) >= 102 ) {
				_widec = (short)(128 + ((*(		ctx->p)) - -128));
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*(		ctx->p)) - -128));
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
	}
	switch( _widec ) {
		case 582: goto st51;
		case 607: goto st50;
		case 614: goto st51;
	}
	if ( _widec < 577 ) {
		if ( 560 <= _widec && _widec <= 569 )
			goto st50;
	} else if ( _widec > 602 ) {
		if ( 609 <= _widec && _widec <= 634 )
			goto st50;
	} else
		goto st50;
	goto tr112;
st50:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof50;
case 50:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 65 ) {
		if ( 48 <= (*(		ctx->p)) && (*(		ctx->p)) <= 57 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 90 ) {
		if ( (*(		ctx->p)) > 95 ) {
			if ( 97 <= (*(		ctx->p)) && (*(		ctx->p)) <= 122 ) {
				_widec = (short)(128 + ((*(		ctx->p)) - -128));
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) >= 95 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*(		ctx->p)) - -128));
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
	}
	if ( _widec == 607 )
		goto st50;
	if ( _widec < 577 ) {
		if ( 560 <= _widec && _widec <= 569 )
			goto st50;
	} else if ( _widec > 602 ) {
		if ( 609 <= _widec && _widec <= 634 )
			goto st50;
	} else
		goto st50;
	goto tr112;
st51:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof51;
case 51:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 65 ) {
		if ( (*(		ctx->p)) > 39 ) {
			if ( 48 <= (*(		ctx->p)) && (*(		ctx->p)) <= 57 ) {
				_widec = (short)(128 + ((*(		ctx->p)) - -128));
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) >= 39 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 90 ) {
		if ( (*(		ctx->p)) > 95 ) {
			if ( 97 <= (*(		ctx->p)) && (*(		ctx->p)) <= 122 ) {
				_widec = (short)(128 + ((*(		ctx->p)) - -128));
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) >= 95 ) {
			_widec = (short)(128 + ((*(		ctx->p)) - -128));
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*(		ctx->p)) - -128));
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
	}
	switch( _widec ) {
		case 551: goto tr114;
		case 607: goto st50;
	}
	if ( _widec < 577 ) {
		if ( 560 <= _widec && _widec <= 569 )
			goto st50;
	} else if ( _widec > 602 ) {
		if ( 609 <= _widec && _widec <= 634 )
			goto st50;
	} else
		goto st50;
	goto tr112;
tr50:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 102 "scan.rl"
	{(	ctx->act) = 4;}
	goto st52;
st52:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof52;
case 52:
//#line 4835 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 65 ) {
		if ( (*(		ctx->p)) > 9 ) {
			if ( 32 <= (*(		ctx->p)) && (*(		ctx->p)) <= 32 ) {
				_widec = (short)(1152 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else if ( (*(		ctx->p)) >= 9 ) {
			_widec = (short)(1152 + ((*(		ctx->p)) - -128));
			if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else if ( (*(		ctx->p)) > 90 ) {
		if ( (*(		ctx->p)) > 95 ) {
			if ( 97 <= (*(		ctx->p)) && (*(		ctx->p)) <= 122 ) {
				_widec = (short)(1152 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else if ( (*(		ctx->p)) >= 95 ) {
			_widec = (short)(1152 + ((*(		ctx->p)) - -128));
			if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else {
		_widec = (short)(1152 + ((*(		ctx->p)) - -128));
		if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
	}
	switch( _widec ) {
		case 2057: goto st5;
		case 2080: goto st5;
		case 2143: goto tr9;
	}
	if ( _widec > 2138 ) {
		if ( 2145 <= _widec && _widec <= 2170 )
			goto tr9;
	} else if ( _widec >= 2113 )
		goto tr9;
	goto tr58;
st5:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof5;
case 5:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 65 ) {
		if ( (*(		ctx->p)) > 9 ) {
			if ( 32 <= (*(		ctx->p)) && (*(		ctx->p)) <= 32 ) {
				_widec = (short)(1152 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else if ( (*(		ctx->p)) >= 9 ) {
			_widec = (short)(1152 + ((*(		ctx->p)) - -128));
			if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else if ( (*(		ctx->p)) > 90 ) {
		if ( (*(		ctx->p)) > 95 ) {
			if ( 97 <= (*(		ctx->p)) && (*(		ctx->p)) <= 122 ) {
				_widec = (short)(1152 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else if ( (*(		ctx->p)) >= 95 ) {
			_widec = (short)(1152 + ((*(		ctx->p)) - -128));
			if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else {
		_widec = (short)(1152 + ((*(		ctx->p)) - -128));
		if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
	}
	switch( _widec ) {
		case 2057: goto st5;
		case 2080: goto st5;
		case 2143: goto tr9;
	}
	if ( _widec > 2138 ) {
		if ( 2145 <= _widec && _widec <= 2170 )
			goto tr9;
	} else if ( _widec >= 2113 )
		goto tr9;
	goto tr2;
tr9:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 177 "scan.rl"
	{(	ctx->act) = 24;}
	goto st53;
st53:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof53;
case 53:
//#line 4972 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 58 ) {
		if ( (*(		ctx->p)) < 32 ) {
			if ( 9 <= (*(		ctx->p)) && (*(		ctx->p)) <= 9 ) {
				_widec = (short)(1152 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else if ( (*(		ctx->p)) > 32 ) {
			if ( 48 <= (*(		ctx->p)) && (*(		ctx->p)) <= 57 ) {
				_widec = (short)(1152 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else {
			_widec = (short)(1152 + ((*(		ctx->p)) - -128));
			if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else if ( (*(		ctx->p)) > 58 ) {
		if ( (*(		ctx->p)) < 95 ) {
			if ( 65 <= (*(		ctx->p)) && (*(		ctx->p)) <= 90 ) {
				_widec = (short)(1152 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else if ( (*(		ctx->p)) > 95 ) {
			if ( 97 <= (*(		ctx->p)) && (*(		ctx->p)) <= 122 ) {
				_widec = (short)(1152 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else {
			_widec = (short)(1152 + ((*(		ctx->p)) - -128));
			if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else {
		_widec = (short)(1152 + ((*(		ctx->p)) - -128));
		if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
	}
	switch( _widec ) {
		case 2057: goto st6;
		case 2080: goto st6;
		case 2106: goto tr11;
		case 2143: goto tr9;
	}
	if ( _widec < 2113 ) {
		if ( 2096 <= _widec && _widec <= 2105 )
			goto tr9;
	} else if ( _widec > 2138 ) {
		if ( 2145 <= _widec && _widec <= 2170 )
			goto tr9;
	} else
		goto tr9;
	goto tr115;
st6:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof6;
case 6:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 32 ) {
		if ( 9 <= (*(		ctx->p)) && (*(		ctx->p)) <= 9 ) {
			_widec = (short)(1152 + ((*(		ctx->p)) - -128));
			if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else if ( (*(		ctx->p)) > 32 ) {
		if ( 58 <= (*(		ctx->p)) && (*(		ctx->p)) <= 58 ) {
			_widec = (short)(1152 + ((*(		ctx->p)) - -128));
			if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else {
		_widec = (short)(1152 + ((*(		ctx->p)) - -128));
		if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
	}
	switch( _widec ) {
		case 2057: goto st6;
		case 2080: goto st6;
		case 2106: goto tr11;
	}
	goto tr2;
tr51:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 166 "scan.rl"
	{(	ctx->act) = 23;}
	goto st54;
st54:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof54;
case 54:
//#line 5108 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 70 ) {
		if ( (*(		ctx->p)) < 48 ) {
			if ( (*(		ctx->p)) > 9 ) {
				if ( 32 <= (*(		ctx->p)) && (*(		ctx->p)) <= 32 ) {
					_widec = (short)(1152 + ((*(		ctx->p)) - -128));
					if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else if ( (*(		ctx->p)) >= 9 ) {
				_widec = (short)(1152 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else if ( (*(		ctx->p)) > 57 ) {
			if ( (*(		ctx->p)) > 58 ) {
				if ( 65 <= (*(		ctx->p)) && (*(		ctx->p)) <= 69 ) {
					_widec = (short)(1152 + ((*(		ctx->p)) - -128));
					if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else if ( (*(		ctx->p)) >= 58 ) {
				_widec = (short)(1152 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else {
			_widec = (short)(1152 + ((*(		ctx->p)) - -128));
			if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else if ( (*(		ctx->p)) > 70 ) {
		if ( (*(		ctx->p)) < 97 ) {
			if ( (*(		ctx->p)) > 90 ) {
				if ( 95 <= (*(		ctx->p)) && (*(		ctx->p)) <= 95 ) {
					_widec = (short)(1152 + ((*(		ctx->p)) - -128));
					if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else if ( (*(		ctx->p)) >= 71 ) {
				_widec = (short)(1152 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else if ( (*(		ctx->p)) > 101 ) {
			if ( (*(		ctx->p)) > 102 ) {
				if ( 103 <= (*(		ctx->p)) && (*(		ctx->p)) <= 122 ) {
					_widec = (short)(1152 + ((*(		ctx->p)) - -128));
					if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else if ( (*(		ctx->p)) >= 102 ) {
				_widec = (short)(1152 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else {
			_widec = (short)(1152 + ((*(		ctx->p)) - -128));
			if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else {
		_widec = (short)(1152 + ((*(		ctx->p)) - -128));
		if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
	}
	switch( _widec ) {
		case 1862: goto st51;
		case 1887: goto st50;
		case 1894: goto st51;
		case 2057: goto st6;
		case 2080: goto st6;
		case 2106: goto tr11;
		case 2118: goto tr116;
		case 2143: goto tr52;
		case 2150: goto tr116;
	}
	if ( _widec < 1889 ) {
		if ( _widec > 1849 ) {
			if ( 1857 <= _widec && _widec <= 1882 )
				goto st50;
		} else if ( _widec >= 1840 )
			goto st50;
	} else if ( _widec > 1914 ) {
		if ( _widec < 2113 ) {
			if ( 2096 <= _widec && _widec <= 2105 )
				goto tr52;
		} else if ( _widec > 2138 ) {
			if ( 2145 <= _widec && _widec <= 2170 )
				goto tr52;
		} else
			goto tr52;
	} else
		goto st50;
	goto tr112;
tr52:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 166 "scan.rl"
	{(	ctx->act) = 23;}
	goto st55;
st55:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof55;
case 55:
//#line 5258 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 58 ) {
		if ( (*(		ctx->p)) < 32 ) {
			if ( 9 <= (*(		ctx->p)) && (*(		ctx->p)) <= 9 ) {
				_widec = (short)(1152 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else if ( (*(		ctx->p)) > 32 ) {
			if ( 48 <= (*(		ctx->p)) && (*(		ctx->p)) <= 57 ) {
				_widec = (short)(1152 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else {
			_widec = (short)(1152 + ((*(		ctx->p)) - -128));
			if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else if ( (*(		ctx->p)) > 58 ) {
		if ( (*(		ctx->p)) < 95 ) {
			if ( 65 <= (*(		ctx->p)) && (*(		ctx->p)) <= 90 ) {
				_widec = (short)(1152 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else if ( (*(		ctx->p)) > 95 ) {
			if ( 97 <= (*(		ctx->p)) && (*(		ctx->p)) <= 122 ) {
				_widec = (short)(1152 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else {
			_widec = (short)(1152 + ((*(		ctx->p)) - -128));
			if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else {
		_widec = (short)(1152 + ((*(		ctx->p)) - -128));
		if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
	}
	switch( _widec ) {
		case 1887: goto st50;
		case 2057: goto st6;
		case 2080: goto st6;
		case 2106: goto tr11;
		case 2143: goto tr52;
	}
	if ( _widec < 1889 ) {
		if ( _widec > 1849 ) {
			if ( 1857 <= _widec && _widec <= 1882 )
				goto st50;
		} else if ( _widec >= 1840 )
			goto st50;
	} else if ( _widec > 1914 ) {
		if ( _widec < 2113 ) {
			if ( 2096 <= _widec && _widec <= 2105 )
				goto tr52;
		} else if ( _widec > 2138 ) {
			if ( 2145 <= _widec && _widec <= 2170 )
				goto tr52;
		} else
			goto tr52;
	} else
		goto st50;
	goto tr112;
tr116:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 166 "scan.rl"
	{(	ctx->act) = 23;}
	goto st56;
st56:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof56;
case 56:
//#line 5364 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 48 ) {
		if ( (*(		ctx->p)) < 32 ) {
			if ( 9 <= (*(		ctx->p)) && (*(		ctx->p)) <= 9 ) {
				_widec = (short)(1152 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else if ( (*(		ctx->p)) > 32 ) {
			if ( 39 <= (*(		ctx->p)) && (*(		ctx->p)) <= 39 ) {
				_widec = (short)(128 + ((*(		ctx->p)) - -128));
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(1152 + ((*(		ctx->p)) - -128));
			if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else if ( (*(		ctx->p)) > 57 ) {
		if ( (*(		ctx->p)) < 65 ) {
			if ( 58 <= (*(		ctx->p)) && (*(		ctx->p)) <= 58 ) {
				_widec = (short)(1152 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else if ( (*(		ctx->p)) > 90 ) {
			if ( (*(		ctx->p)) > 95 ) {
				if ( 97 <= (*(		ctx->p)) && (*(		ctx->p)) <= 122 ) {
					_widec = (short)(1152 + ((*(		ctx->p)) - -128));
					if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else if ( (*(		ctx->p)) >= 95 ) {
				_widec = (short)(1152 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else {
			_widec = (short)(1152 + ((*(		ctx->p)) - -128));
			if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else {
		_widec = (short)(1152 + ((*(		ctx->p)) - -128));
		if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
	}
	switch( _widec ) {
		case 551: goto tr114;
		case 1887: goto st50;
		case 2057: goto st6;
		case 2080: goto st6;
		case 2106: goto tr11;
		case 2143: goto tr52;
	}
	if ( _widec < 1889 ) {
		if ( _widec > 1849 ) {
			if ( 1857 <= _widec && _widec <= 1882 )
				goto st50;
		} else if ( _widec >= 1840 )
			goto st50;
	} else if ( _widec > 1914 ) {
		if ( _widec < 2113 ) {
			if ( 2096 <= _widec && _widec <= 2105 )
				goto tr52;
		} else if ( _widec > 2138 ) {
			if ( 2145 <= _widec && _widec <= 2170 )
				goto tr52;
		} else
			goto tr52;
	} else
		goto st50;
	goto tr112;
st57:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof57;
case 57:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 71 ) {
		if ( (*(		ctx->p)) < 48 ) {
			if ( (*(		ctx->p)) < 10 ) {
				if ( (*(		ctx->p)) <= 9 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) > 10 ) {
				if ( 11 <= (*(		ctx->p)) && (*(		ctx->p)) <= 47 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 57 ) {
			if ( (*(		ctx->p)) < 65 ) {
				if ( 58 <= (*(		ctx->p)) && (*(		ctx->p)) <= 64 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) > 69 ) {
				if ( 70 <= (*(		ctx->p)) && (*(		ctx->p)) <= 70 ) {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else {
			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else if ( (*(		ctx->p)) > 90 ) {
		if ( (*(		ctx->p)) < 97 ) {
			if ( (*(		ctx->p)) < 95 ) {
				if ( 91 <= (*(		ctx->p)) && (*(		ctx->p)) <= 94 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) > 95 ) {
				if ( 96 <= (*(		ctx->p)) && (*(		ctx->p)) <= 96 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else if ( (*(		ctx->p)) > 101 ) {
			if ( (*(		ctx->p)) < 103 ) {
				if ( 102 <= (*(		ctx->p)) && (*(		ctx->p)) <= 102 ) {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else if ( (*(		ctx->p)) > 122 ) {
				if ( 123 <= (*(		ctx->p)) )
 {					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else {
			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else {
		_widec = (short)(2688 + ((*(		ctx->p)) - -128));
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
	}
	switch( _widec ) {
		case 2570: goto tr14;
		case 2656: goto tr12;
		case 3167: goto tr12;
		case 3398: goto st51;
		case 3423: goto st50;
		case 3430: goto st51;
		case 3654: goto st59;
		case 3679: goto st58;
		case 3686: goto st59;
	}
	if ( _widec < 3169 ) {
		if ( _widec < 2651 ) {
			if ( _widec > 2607 ) {
				if ( 2618 <= _widec && _widec <= 2624 )
					goto tr12;
			} else if ( _widec >= 2432 )
				goto tr12;
		} else if ( _widec > 2654 ) {
			if ( _widec < 3120 ) {
				if ( 2683 <= _widec && _widec <= 2687 )
					goto tr12;
			} else if ( _widec > 3129 ) {
				if ( 3137 <= _widec && _widec <= 3162 )
					goto tr12;
			} else
				goto tr12;
		} else
			goto tr12;
	} else if ( _widec > 3194 ) {
		if ( _widec < 3425 ) {
			if ( _widec > 3385 ) {
				if ( 3393 <= _widec && _widec <= 3418 )
					goto st50;
			} else if ( _widec >= 3376 )
				goto st50;
		} else if ( _widec > 3450 ) {
			if ( _widec < 3649 ) {
				if ( 3632 <= _widec && _widec <= 3641 )
					goto st58;
			} else if ( _widec > 3674 ) {
				if ( 3681 <= _widec && _widec <= 3706 )
					goto st58;
			} else
				goto st58;
		} else
			goto st50;
	} else
		goto tr12;
	goto tr112;
st58:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof58;
case 58:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 65 ) {
		if ( (*(		ctx->p)) < 11 ) {
			if ( (*(		ctx->p)) > 9 ) {
				if ( 10 <= (*(		ctx->p)) && (*(		ctx->p)) <= 10 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 47 ) {
			if ( (*(		ctx->p)) > 57 ) {
				if ( 58 <= (*(		ctx->p)) && (*(		ctx->p)) <= 64 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) >= 48 ) {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 90 ) {
		if ( (*(		ctx->p)) < 96 ) {
			if ( (*(		ctx->p)) > 94 ) {
				if ( 95 <= (*(		ctx->p)) && (*(		ctx->p)) <= 95 ) {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else if ( (*(		ctx->p)) >= 91 ) {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 96 ) {
			if ( (*(		ctx->p)) > 122 ) {
				if ( 123 <= (*(		ctx->p)) )
 {					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) >= 97 ) {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else {
		_widec = (short)(2688 + ((*(		ctx->p)) - -128));
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
	}
	switch( _widec ) {
		case 2570: goto tr14;
		case 2656: goto tr12;
		case 3167: goto tr12;
		case 3423: goto st50;
		case 3679: goto st58;
	}
	if ( _widec < 3169 ) {
		if ( _widec < 2651 ) {
			if ( _widec > 2607 ) {
				if ( 2618 <= _widec && _widec <= 2624 )
					goto tr12;
			} else if ( _widec >= 2432 )
				goto tr12;
		} else if ( _widec > 2654 ) {
			if ( _widec < 3120 ) {
				if ( 2683 <= _widec && _widec <= 2687 )
					goto tr12;
			} else if ( _widec > 3129 ) {
				if ( 3137 <= _widec && _widec <= 3162 )
					goto tr12;
			} else
				goto tr12;
		} else
			goto tr12;
	} else if ( _widec > 3194 ) {
		if ( _widec < 3425 ) {
			if ( _widec > 3385 ) {
				if ( 3393 <= _widec && _widec <= 3418 )
					goto st50;
			} else if ( _widec >= 3376 )
				goto st50;
		} else if ( _widec > 3450 ) {
			if ( _widec < 3649 ) {
				if ( 3632 <= _widec && _widec <= 3641 )
					goto st58;
			} else if ( _widec > 3674 ) {
				if ( 3681 <= _widec && _widec <= 3706 )
					goto st58;
			} else
				goto st58;
		} else
			goto st50;
	} else
		goto tr12;
	goto tr112;
st59:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof59;
case 59:
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 58 ) {
		if ( (*(		ctx->p)) < 11 ) {
			if ( (*(		ctx->p)) > 9 ) {
				if ( 10 <= (*(		ctx->p)) && (*(		ctx->p)) <= 10 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 38 ) {
			if ( (*(		ctx->p)) < 40 ) {
				if ( 39 <= (*(		ctx->p)) && (*(		ctx->p)) <= 39 ) {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else if ( (*(		ctx->p)) > 47 ) {
				if ( 48 <= (*(		ctx->p)) && (*(		ctx->p)) <= 57 ) {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 64 ) {
		if ( (*(		ctx->p)) < 95 ) {
			if ( (*(		ctx->p)) > 90 ) {
				if ( 91 <= (*(		ctx->p)) && (*(		ctx->p)) <= 94 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) >= 65 ) {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else if ( (*(		ctx->p)) > 95 ) {
			if ( (*(		ctx->p)) < 97 ) {
				if ( 96 <= (*(		ctx->p)) && (*(		ctx->p)) <= 96 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) > 122 ) {
				if ( 123 <= (*(		ctx->p)) )
 {					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else {
				_widec = (short)(2688 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
			}
		} else {
			_widec = (short)(2688 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
		}
	} else {
		_widec = (short)(2176 + ((*(		ctx->p)) - -128));
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
	}
	switch( _widec ) {
		case 2570: goto tr14;
		case 2656: goto tr12;
		case 3111: goto tr12;
		case 3167: goto tr12;
		case 3367: goto tr114;
		case 3423: goto st50;
		case 3623: goto tr118;
		case 3679: goto st58;
	}
	if ( _widec < 3137 ) {
		if ( _widec < 2618 ) {
			if ( _widec > 2598 ) {
				if ( 2600 <= _widec && _widec <= 2607 )
					goto tr12;
			} else if ( _widec >= 2432 )
				goto tr12;
		} else if ( _widec > 2624 ) {
			if ( _widec < 2683 ) {
				if ( 2651 <= _widec && _widec <= 2654 )
					goto tr12;
			} else if ( _widec > 2687 ) {
				if ( 3120 <= _widec && _widec <= 3129 )
					goto tr12;
			} else
				goto tr12;
		} else
			goto tr12;
	} else if ( _widec > 3162 ) {
		if ( _widec < 3425 ) {
			if ( _widec < 3376 ) {
				if ( 3169 <= _widec && _widec <= 3194 )
					goto tr12;
			} else if ( _widec > 3385 ) {
				if ( 3393 <= _widec && _widec <= 3418 )
					goto st50;
			} else
				goto st50;
		} else if ( _widec > 3450 ) {
			if ( _widec < 3649 ) {
				if ( 3632 <= _widec && _widec <= 3641 )
					goto st58;
			} else if ( _widec > 3674 ) {
				if ( 3681 <= _widec && _widec <= 3706 )
					goto st58;
			} else
				goto st58;
		} else
			goto st50;
	} else
		goto tr12;
	goto tr112;
tr119:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 221 "scan.rl"
	{(	ctx->act) = 29;}
	goto st60;
tr55:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 102 "scan.rl"
	{(	ctx->act) = 4;}
	goto st60;
st60:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof60;
case 60:
//#line 5968 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 33 ) {
		if ( (*(		ctx->p)) < 10 ) {
			if ( (*(		ctx->p)) > 8 ) {
				if ( 9 <= (*(		ctx->p)) && (*(		ctx->p)) <= 9 ) {
					_widec = (short)(3712 + ((*(		ctx->p)) - -128));
					if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
				}
			} else {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 10 ) {
			if ( (*(		ctx->p)) > 31 ) {
				if ( 32 <= (*(		ctx->p)) && (*(		ctx->p)) <= 32 ) {
					_widec = (short)(3712 + ((*(		ctx->p)) - -128));
					if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
				}
			} else if ( (*(		ctx->p)) >= 11 ) {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 64 ) {
		if ( (*(		ctx->p)) < 95 ) {
			if ( (*(		ctx->p)) > 90 ) {
				if ( 91 <= (*(		ctx->p)) && (*(		ctx->p)) <= 94 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) >= 65 ) {
				_widec = (short)(3712 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
			}
		} else if ( (*(		ctx->p)) > 95 ) {
			if ( (*(		ctx->p)) < 97 ) {
				if ( 96 <= (*(		ctx->p)) && (*(		ctx->p)) <= 96 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) > 122 ) {
				if ( 123 <= (*(		ctx->p)) )
 {					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else {
				_widec = (short)(3712 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
			}
		} else {
			_widec = (short)(3712 + ((*(		ctx->p)) - -128));
			if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
		}
	} else {
		_widec = (short)(2176 + ((*(		ctx->p)) - -128));
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
	}
	switch( _widec ) {
		case 2570: goto tr14;
		case 2656: goto tr12;
		case 4361: goto tr12;
		case 4384: goto tr12;
		case 4447: goto tr12;
		case 4617: goto tr12;
		case 4640: goto tr12;
		case 4703: goto tr12;
		case 5129: goto st5;
		case 5152: goto st5;
		case 5215: goto tr9;
		case 5385: goto tr12;
		case 5408: goto tr12;
		case 5471: goto tr12;
		case 5641: goto tr119;
		case 5664: goto tr119;
		case 5727: goto tr120;
	}
	if ( _widec < 4673 ) {
		if ( _widec < 2651 ) {
			if ( _widec < 2571 ) {
				if ( 2432 <= _widec && _widec <= 2568 )
					goto tr12;
			} else if ( _widec > 2591 ) {
				if ( 2593 <= _widec && _widec <= 2624 )
					goto tr12;
			} else
				goto tr12;
		} else if ( _widec > 2654 ) {
			if ( _widec < 4417 ) {
				if ( 2683 <= _widec && _widec <= 2687 )
					goto tr12;
			} else if ( _widec > 4442 ) {
				if ( 4449 <= _widec && _widec <= 4474 )
					goto tr12;
			} else
				goto tr12;
		} else
			goto tr12;
	} else if ( _widec > 4698 ) {
		if ( _widec < 5441 ) {
			if ( _widec < 5185 ) {
				if ( 4705 <= _widec && _widec <= 4730 )
					goto tr12;
			} else if ( _widec > 5210 ) {
				if ( 5217 <= _widec && _widec <= 5242 )
					goto tr9;
			} else
				goto tr9;
		} else if ( _widec > 5466 ) {
			if ( _widec < 5697 ) {
				if ( 5473 <= _widec && _widec <= 5498 )
					goto tr12;
			} else if ( _widec > 5722 ) {
				if ( 5729 <= _widec && _widec <= 5754 )
					goto tr120;
			} else
				goto tr120;
		} else
			goto tr12;
	} else
		goto tr12;
	goto tr2;
tr120:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 177 "scan.rl"
	{(	ctx->act) = 24;}
	goto st61;
st61:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof61;
case 61:
//#line 6157 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 58 ) {
		if ( (*(		ctx->p)) < 11 ) {
			if ( (*(		ctx->p)) < 9 ) {
				if ( (*(		ctx->p)) <= 8 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) > 9 ) {
				if ( 10 <= (*(		ctx->p)) && (*(		ctx->p)) <= 10 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else {
				_widec = (short)(3712 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
			}
		} else if ( (*(		ctx->p)) > 31 ) {
			if ( (*(		ctx->p)) < 33 ) {
				if ( 32 <= (*(		ctx->p)) && (*(		ctx->p)) <= 32 ) {
					_widec = (short)(3712 + ((*(		ctx->p)) - -128));
					if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
				}
			} else if ( (*(		ctx->p)) > 47 ) {
				if ( 48 <= (*(		ctx->p)) && (*(		ctx->p)) <= 57 ) {
					_widec = (short)(3712 + ((*(		ctx->p)) - -128));
					if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
				}
			} else {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 58 ) {
		if ( (*(		ctx->p)) < 95 ) {
			if ( (*(		ctx->p)) < 65 ) {
				if ( 59 <= (*(		ctx->p)) && (*(		ctx->p)) <= 64 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) > 90 ) {
				if ( 91 <= (*(		ctx->p)) && (*(		ctx->p)) <= 94 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else {
				_widec = (short)(3712 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
			}
		} else if ( (*(		ctx->p)) > 95 ) {
			if ( (*(		ctx->p)) < 97 ) {
				if ( 96 <= (*(		ctx->p)) && (*(		ctx->p)) <= 96 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) > 122 ) {
				if ( 123 <= (*(		ctx->p)) )
 {					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else {
				_widec = (short)(3712 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
			}
		} else {
			_widec = (short)(3712 + ((*(		ctx->p)) - -128));
			if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
		}
	} else {
		_widec = (short)(3712 + ((*(		ctx->p)) - -128));
		if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
	}
	switch( _widec ) {
		case 2570: goto tr14;
		case 2656: goto tr12;
		case 4361: goto tr12;
		case 4384: goto tr12;
		case 4447: goto tr12;
		case 4617: goto tr12;
		case 4640: goto tr12;
		case 4703: goto tr12;
		case 5129: goto st6;
		case 5152: goto st6;
		case 5178: goto tr11;
		case 5215: goto tr9;
		case 5385: goto tr12;
		case 5408: goto tr12;
		case 5471: goto tr12;
		case 5641: goto tr121;
		case 5664: goto tr121;
		case 5690: goto tr122;
		case 5727: goto tr120;
	}
	if ( _widec < 4673 ) {
		if ( _widec < 2651 ) {
			if ( _widec < 2571 ) {
				if ( 2432 <= _widec && _widec <= 2568 )
					goto tr12;
			} else if ( _widec > 2591 ) {
				if ( _widec > 2607 ) {
					if ( 2619 <= _widec && _widec <= 2624 )
						goto tr12;
				} else if ( _widec >= 2593 )
					goto tr12;
			} else
				goto tr12;
		} else if ( _widec > 2654 ) {
			if ( _widec < 4417 ) {
				if ( _widec > 2687 ) {
					if ( 4400 <= _widec && _widec <= 4410 )
						goto tr12;
				} else if ( _widec >= 2683 )
					goto tr12;
			} else if ( _widec > 4442 ) {
				if ( _widec > 4474 ) {
					if ( 4656 <= _widec && _widec <= 4666 )
						goto tr12;
				} else if ( _widec >= 4449 )
					goto tr12;
			} else
				goto tr12;
		} else
			goto tr12;
	} else if ( _widec > 4698 ) {
		if ( _widec < 5424 ) {
			if ( _widec < 5168 ) {
				if ( 4705 <= _widec && _widec <= 4730 )
					goto tr12;
			} else if ( _widec > 5177 ) {
				if ( _widec > 5210 ) {
					if ( 5217 <= _widec && _widec <= 5242 )
						goto tr9;
				} else if ( _widec >= 5185 )
					goto tr9;
			} else
				goto tr9;
		} else if ( _widec > 5434 ) {
			if ( _widec < 5680 ) {
				if ( _widec > 5466 ) {
					if ( 5473 <= _widec && _widec <= 5498 )
						goto tr12;
				} else if ( _widec >= 5441 )
					goto tr12;
			} else if ( _widec > 5689 ) {
				if ( _widec > 5722 ) {
					if ( 5729 <= _widec && _widec <= 5754 )
						goto tr120;
				} else if ( _widec >= 5697 )
					goto tr120;
			} else
				goto tr120;
		} else
			goto tr12;
	} else
		goto tr12;
	goto tr115;
tr121:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 221 "scan.rl"
	{(	ctx->act) = 29;}
	goto st62;
st62:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof62;
case 62:
//#line 6399 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 11 ) {
		if ( (*(		ctx->p)) < 9 ) {
			if ( (*(		ctx->p)) <= 8 ) {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 9 ) {
			if ( 10 <= (*(		ctx->p)) && (*(		ctx->p)) <= 10 ) {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(3712 + ((*(		ctx->p)) - -128));
			if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
		}
	} else if ( (*(		ctx->p)) > 31 ) {
		if ( (*(		ctx->p)) < 33 ) {
			if ( 32 <= (*(		ctx->p)) && (*(		ctx->p)) <= 32 ) {
				_widec = (short)(3712 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
			}
		} else if ( (*(		ctx->p)) > 57 ) {
			if ( (*(		ctx->p)) > 58 ) {
				if ( 59 <= (*(		ctx->p)) )
 {					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) >= 58 ) {
				_widec = (short)(3712 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
			}
		} else {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else {
		_widec = (short)(2176 + ((*(		ctx->p)) - -128));
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
	}
	switch( _widec ) {
		case 2570: goto tr14;
		case 4361: goto tr12;
		case 4384: goto tr12;
		case 4410: goto tr12;
		case 4617: goto tr12;
		case 4640: goto tr12;
		case 4666: goto tr12;
		case 5129: goto st6;
		case 5152: goto st6;
		case 5178: goto tr11;
		case 5385: goto tr12;
		case 5408: goto tr12;
		case 5434: goto tr12;
		case 5641: goto tr121;
		case 5664: goto tr121;
		case 5690: goto tr122;
	}
	if ( _widec < 2571 ) {
		if ( 2432 <= _widec && _widec <= 2568 )
			goto tr12;
	} else if ( _widec > 2591 ) {
		if ( _widec > 2617 ) {
			if ( 2619 <= _widec && _widec <= 2687 )
				goto tr12;
		} else if ( _widec >= 2593 )
			goto tr12;
	} else
		goto tr12;
	goto tr91;
tr56:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 166 "scan.rl"
	{(	ctx->act) = 23;}
	goto st63;
st63:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof63;
case 63:
//#line 6514 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 65 ) {
		if ( (*(		ctx->p)) < 32 ) {
			if ( (*(		ctx->p)) < 9 ) {
				if ( (*(		ctx->p)) <= 8 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) > 9 ) {
				if ( (*(		ctx->p)) > 10 ) {
					if ( 11 <= (*(		ctx->p)) && (*(		ctx->p)) <= 31 ) {
						_widec = (short)(2176 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					}
				} else if ( (*(		ctx->p)) >= 10 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else {
				_widec = (short)(3712 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
			}
		} else if ( (*(		ctx->p)) > 32 ) {
			if ( (*(		ctx->p)) < 48 ) {
				if ( 33 <= (*(		ctx->p)) && (*(		ctx->p)) <= 47 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) > 57 ) {
				if ( (*(		ctx->p)) > 58 ) {
					if ( 59 <= (*(		ctx->p)) && (*(		ctx->p)) <= 64 ) {
						_widec = (short)(2176 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					}
				} else if ( (*(		ctx->p)) >= 58 ) {
					_widec = (short)(3712 + ((*(		ctx->p)) - -128));
					if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
				}
			} else {
				_widec = (short)(3712 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
			}
		} else {
			_widec = (short)(3712 + ((*(		ctx->p)) - -128));
			if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
		}
	} else if ( (*(		ctx->p)) > 69 ) {
		if ( (*(		ctx->p)) < 96 ) {
			if ( (*(		ctx->p)) < 71 ) {
				if ( 70 <= (*(		ctx->p)) && (*(		ctx->p)) <= 70 ) {
					_widec = (short)(3712 + ((*(		ctx->p)) - -128));
					if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
				}
			} else if ( (*(		ctx->p)) > 90 ) {
				if ( (*(		ctx->p)) > 94 ) {
					if ( 95 <= (*(		ctx->p)) && (*(		ctx->p)) <= 95 ) {
						_widec = (short)(3712 + ((*(		ctx->p)) - -128));
						if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
						if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
					}
				} else if ( (*(		ctx->p)) >= 91 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else {
				_widec = (short)(3712 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
			}
		} else if ( (*(		ctx->p)) > 96 ) {
			if ( (*(		ctx->p)) < 102 ) {
				if ( 97 <= (*(		ctx->p)) && (*(		ctx->p)) <= 101 ) {
					_widec = (short)(3712 + ((*(		ctx->p)) - -128));
					if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
				}
			} else if ( (*(		ctx->p)) > 102 ) {
				if ( (*(		ctx->p)) > 122 ) {
					if ( 123 <= (*(		ctx->p)) )
 {						_widec = (short)(2176 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					}
				} else if ( (*(		ctx->p)) >= 103 ) {
					_widec = (short)(3712 + ((*(		ctx->p)) - -128));
					if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
				}
			} else {
				_widec = (short)(3712 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
			}
		} else {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else {
		_widec = (short)(3712 + ((*(		ctx->p)) - -128));
		if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
	}
	switch( _widec ) {
		case 2570: goto tr14;
		case 2656: goto tr12;
		case 4361: goto tr12;
		case 4384: goto tr12;
		case 4447: goto tr12;
		case 4617: goto tr12;
		case 4640: goto tr12;
		case 4703: goto tr12;
		case 4934: goto st51;
		case 4959: goto st50;
		case 4966: goto st51;
		case 5129: goto st6;
		case 5152: goto st6;
		case 5178: goto tr11;
		case 5190: goto tr116;
		case 5215: goto tr52;
		case 5222: goto tr116;
		case 5385: goto tr12;
		case 5408: goto tr12;
		case 5434: goto tr12;
		case 5446: goto st59;
		case 5471: goto st58;
		case 5478: goto st59;
		case 5641: goto tr121;
		case 5664: goto tr121;
		case 5690: goto tr122;
		case 5702: goto tr123;
		case 5727: goto tr57;
		case 5734: goto tr123;
	}
	if ( _widec < 4705 ) {
		if ( _widec < 2683 ) {
			if ( _widec < 2593 ) {
				if ( _widec > 2568 ) {
					if ( 2571 <= _widec && _widec <= 2591 )
						goto tr12;
				} else if ( _widec >= 2432 )
					goto tr12;
			} else if ( _widec > 2607 ) {
				if ( _widec > 2624 ) {
					if ( 2651 <= _widec && _widec <= 2654 )
						goto tr12;
				} else if ( _widec >= 2619 )
					goto tr12;
			} else
				goto tr12;
		} else if ( _widec > 2687 ) {
			if ( _widec < 4449 ) {
				if ( _widec > 4410 ) {
					if ( 4417 <= _widec && _widec <= 4442 )
						goto tr12;
				} else if ( _widec >= 4400 )
					goto tr12;
			} else if ( _widec > 4474 ) {
				if ( _widec > 4666 ) {
					if ( 4673 <= _widec && _widec <= 4698 )
						goto tr12;
				} else if ( _widec >= 4656 )
					goto tr12;
			} else
				goto tr12;
		} else
			goto tr12;
	} else if ( _widec > 4730 ) {
		if ( _widec < 5217 ) {
			if ( _widec < 4961 ) {
				if ( _widec > 4921 ) {
					if ( 4929 <= _widec && _widec <= 4954 )
						goto st50;
				} else if ( _widec >= 4912 )
					goto st50;
			} else if ( _widec > 4986 ) {
				if ( _widec > 5177 ) {
					if ( 5185 <= _widec && _widec <= 5210 )
						goto tr52;
				} else if ( _widec >= 5168 )
					goto tr52;
			} else
				goto st50;
		} else if ( _widec > 5242 ) {
			if ( _widec < 5473 ) {
				if ( _widec > 5433 ) {
					if ( 5441 <= _widec && _widec <= 5466 )
						goto st58;
				} else if ( _widec >= 5424 )
					goto st58;
			} else if ( _widec > 5498 ) {
				if ( _widec < 5697 ) {
					if ( 5680 <= _widec && _widec <= 5689 )
						goto tr57;
				} else if ( _widec > 5722 ) {
					if ( 5729 <= _widec && _widec <= 5754 )
						goto tr57;
				} else
					goto tr57;
			} else
				goto st58;
		} else
			goto tr52;
	} else
		goto tr12;
	goto tr112;
tr57:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 166 "scan.rl"
	{(	ctx->act) = 23;}
	goto st64;
st64:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof64;
case 64:
//#line 6827 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 58 ) {
		if ( (*(		ctx->p)) < 11 ) {
			if ( (*(		ctx->p)) < 9 ) {
				if ( (*(		ctx->p)) <= 8 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) > 9 ) {
				if ( 10 <= (*(		ctx->p)) && (*(		ctx->p)) <= 10 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else {
				_widec = (short)(3712 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
			}
		} else if ( (*(		ctx->p)) > 31 ) {
			if ( (*(		ctx->p)) < 33 ) {
				if ( 32 <= (*(		ctx->p)) && (*(		ctx->p)) <= 32 ) {
					_widec = (short)(3712 + ((*(		ctx->p)) - -128));
					if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
				}
			} else if ( (*(		ctx->p)) > 47 ) {
				if ( 48 <= (*(		ctx->p)) && (*(		ctx->p)) <= 57 ) {
					_widec = (short)(3712 + ((*(		ctx->p)) - -128));
					if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
				}
			} else {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 58 ) {
		if ( (*(		ctx->p)) < 95 ) {
			if ( (*(		ctx->p)) < 65 ) {
				if ( 59 <= (*(		ctx->p)) && (*(		ctx->p)) <= 64 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) > 90 ) {
				if ( 91 <= (*(		ctx->p)) && (*(		ctx->p)) <= 94 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else {
				_widec = (short)(3712 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
			}
		} else if ( (*(		ctx->p)) > 95 ) {
			if ( (*(		ctx->p)) < 97 ) {
				if ( 96 <= (*(		ctx->p)) && (*(		ctx->p)) <= 96 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) > 122 ) {
				if ( 123 <= (*(		ctx->p)) )
 {					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else {
				_widec = (short)(3712 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
			}
		} else {
			_widec = (short)(3712 + ((*(		ctx->p)) - -128));
			if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
			if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
		}
	} else {
		_widec = (short)(3712 + ((*(		ctx->p)) - -128));
		if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
	}
	switch( _widec ) {
		case 2570: goto tr14;
		case 2656: goto tr12;
		case 4361: goto tr12;
		case 4384: goto tr12;
		case 4447: goto tr12;
		case 4617: goto tr12;
		case 4640: goto tr12;
		case 4703: goto tr12;
		case 4959: goto st50;
		case 5129: goto st6;
		case 5152: goto st6;
		case 5178: goto tr11;
		case 5215: goto tr52;
		case 5385: goto tr12;
		case 5408: goto tr12;
		case 5434: goto tr12;
		case 5471: goto st58;
		case 5641: goto tr121;
		case 5664: goto tr121;
		case 5690: goto tr122;
		case 5727: goto tr57;
	}
	if ( _widec < 4705 ) {
		if ( _widec < 2683 ) {
			if ( _widec < 2593 ) {
				if ( _widec > 2568 ) {
					if ( 2571 <= _widec && _widec <= 2591 )
						goto tr12;
				} else if ( _widec >= 2432 )
					goto tr12;
			} else if ( _widec > 2607 ) {
				if ( _widec > 2624 ) {
					if ( 2651 <= _widec && _widec <= 2654 )
						goto tr12;
				} else if ( _widec >= 2619 )
					goto tr12;
			} else
				goto tr12;
		} else if ( _widec > 2687 ) {
			if ( _widec < 4449 ) {
				if ( _widec > 4410 ) {
					if ( 4417 <= _widec && _widec <= 4442 )
						goto tr12;
				} else if ( _widec >= 4400 )
					goto tr12;
			} else if ( _widec > 4474 ) {
				if ( _widec > 4666 ) {
					if ( 4673 <= _widec && _widec <= 4698 )
						goto tr12;
				} else if ( _widec >= 4656 )
					goto tr12;
			} else
				goto tr12;
		} else
			goto tr12;
	} else if ( _widec > 4730 ) {
		if ( _widec < 5217 ) {
			if ( _widec < 4961 ) {
				if ( _widec > 4921 ) {
					if ( 4929 <= _widec && _widec <= 4954 )
						goto st50;
				} else if ( _widec >= 4912 )
					goto st50;
			} else if ( _widec > 4986 ) {
				if ( _widec > 5177 ) {
					if ( 5185 <= _widec && _widec <= 5210 )
						goto tr52;
				} else if ( _widec >= 5168 )
					goto tr52;
			} else
				goto st50;
		} else if ( _widec > 5242 ) {
			if ( _widec < 5473 ) {
				if ( _widec > 5433 ) {
					if ( 5441 <= _widec && _widec <= 5466 )
						goto st58;
				} else if ( _widec >= 5424 )
					goto st58;
			} else if ( _widec > 5498 ) {
				if ( _widec < 5697 ) {
					if ( 5680 <= _widec && _widec <= 5689 )
						goto tr57;
				} else if ( _widec > 5722 ) {
					if ( 5729 <= _widec && _widec <= 5754 )
						goto tr57;
				} else
					goto tr57;
			} else
				goto st58;
		} else
			goto tr52;
	} else
		goto tr12;
	goto tr112;
tr123:
//#line 1 "NONE"
	{(		ctx->te) = (		ctx->p)+1;}
//#line 166 "scan.rl"
	{(	ctx->act) = 23;}
	goto st65;
st65:
	if ( ++(		ctx->p) == (		ctx->pe) )
		goto _test_eof65;
case 65:
//#line 7080 "scan.c"
	_widec = (*(		ctx->p));
	if ( (*(		ctx->p)) < 48 ) {
		if ( (*(		ctx->p)) < 11 ) {
			if ( (*(		ctx->p)) < 9 ) {
				if ( (*(		ctx->p)) <= 8 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else if ( (*(		ctx->p)) > 9 ) {
				if ( 10 <= (*(		ctx->p)) && (*(		ctx->p)) <= 10 ) {
					_widec = (short)(2176 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
				}
			} else {
				_widec = (short)(3712 + ((*(		ctx->p)) - -128));
				if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
				if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
			}
		} else if ( (*(		ctx->p)) > 31 ) {
			if ( (*(		ctx->p)) < 33 ) {
				if ( 32 <= (*(		ctx->p)) && (*(		ctx->p)) <= 32 ) {
					_widec = (short)(3712 + ((*(		ctx->p)) - -128));
					if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
				}
			} else if ( (*(		ctx->p)) > 38 ) {
				if ( (*(		ctx->p)) > 39 ) {
					if ( 40 <= (*(		ctx->p)) && (*(		ctx->p)) <= 47 ) {
						_widec = (short)(2176 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					}
				} else if ( (*(		ctx->p)) >= 39 ) {
					_widec = (short)(2688 + ((*(		ctx->p)) - -128));
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 512;
				}
			} else {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else if ( (*(		ctx->p)) > 57 ) {
		if ( (*(		ctx->p)) < 91 ) {
			if ( (*(		ctx->p)) < 59 ) {
				if ( 58 <= (*(		ctx->p)) && (*(		ctx->p)) <= 58 ) {
					_widec = (short)(3712 + ((*(		ctx->p)) - -128));
					if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
				}
			} else if ( (*(		ctx->p)) > 64 ) {
				if ( 65 <= (*(		ctx->p)) && (*(		ctx->p)) <= 90 ) {
					_widec = (short)(3712 + ((*(		ctx->p)) - -128));
					if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
				}
			} else {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else if ( (*(		ctx->p)) > 94 ) {
			if ( (*(		ctx->p)) < 96 ) {
				if ( 95 <= (*(		ctx->p)) && (*(		ctx->p)) <= 95 ) {
					_widec = (short)(3712 + ((*(		ctx->p)) - -128));
					if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
				}
			} else if ( (*(		ctx->p)) > 96 ) {
				if ( (*(		ctx->p)) > 122 ) {
					if ( 123 <= (*(		ctx->p)) )
 {						_widec = (short)(2176 + ((*(		ctx->p)) - -128));
						if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
					}
				} else if ( (*(		ctx->p)) >= 97 ) {
					_widec = (short)(3712 + ((*(		ctx->p)) - -128));
					if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
					if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
					if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
				}
			} else {
				_widec = (short)(2176 + ((*(		ctx->p)) - -128));
				if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
			}
		} else {
			_widec = (short)(2176 + ((*(		ctx->p)) - -128));
			if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 256;
		}
	} else {
		_widec = (short)(3712 + ((*(		ctx->p)) - -128));
		if ( 
//#line 60 "scan.rl"
 ctx->bol  ) _widec += 256;
		if ( 
//#line 63 "scan.rl"
   by_lines  ) _widec += 512;
		if ( 
//#line 64 "scan.rl"
 ! by_lines  ) _widec += 1024;
	}
	switch( _widec ) {
		case 2570: goto tr14;
		case 2656: goto tr12;
		case 3111: goto tr12;
		case 3367: goto tr114;
		case 3623: goto tr118;
		case 4361: goto tr12;
		case 4384: goto tr12;
		case 4447: goto tr12;
		case 4617: goto tr12;
		case 4640: goto tr12;
		case 4703: goto tr12;
		case 4959: goto st50;
		case 5129: goto st6;
		case 5152: goto st6;
		case 5178: goto tr11;
		case 5215: goto tr52;
		case 5385: goto tr12;
		case 5408: goto tr12;
		case 5434: goto tr12;
		case 5471: goto st58;
		case 5641: goto tr121;
		case 5664: goto tr121;
		case 5690: goto tr122;
		case 5727: goto tr57;
	}
	if ( _widec < 4705 ) {
		if ( _widec < 2651 ) {
			if ( _widec < 2593 ) {
				if ( _widec > 2568 ) {
					if ( 2571 <= _widec && _widec <= 2591 )
						goto tr12;
				} else if ( _widec >= 2432 )
					goto tr12;
			} else if ( _widec > 2598 ) {
				if ( _widec > 2607 ) {
					if ( 2619 <= _widec && _widec <= 2624 )
						goto tr12;
				} else if ( _widec >= 2600 )
					goto tr12;
			} else
				goto tr12;
		} else if ( _widec > 2654 ) {
			if ( _widec < 4417 ) {
				if ( _widec > 2687 ) {
					if ( 4400 <= _widec && _widec <= 4410 )
						goto tr12;
				} else if ( _widec >= 2683 )
					goto tr12;
			} else if ( _widec > 4442 ) {
				if ( _widec < 4656 ) {
					if ( 4449 <= _widec && _widec <= 4474 )
						goto tr12;
				} else if ( _widec > 4666 ) {
					if ( 4673 <= _widec && _widec <= 4698 )
						goto tr12;
				} else
					goto tr12;
			} else
				goto tr12;
		} else
			goto tr12;
	} else if ( _widec > 4730 ) {
		if ( _widec < 5217 ) {
			if ( _widec < 4961 ) {
				if ( _widec > 4921 ) {
					if ( 4929 <= _widec && _widec <= 4954 )
						goto st50;
				} else if ( _widec >= 4912 )
					goto st50;
			} else if ( _widec > 4986 ) {
				if ( _widec > 5177 ) {
					if ( 5185 <= _widec && _widec <= 5210 )
						goto tr52;
				} else if ( _widec >= 5168 )
					goto tr52;
			} else
				goto st50;
		} else if ( _widec > 5242 ) {
			if ( _widec < 5473 ) {
				if ( _widec > 5433 ) {
					if ( 5441 <= _widec && _widec <= 5466 )
						goto st58;
				} else if ( _widec >= 5424 )
					goto st58;
			} else if ( _widec > 5498 ) {
				if ( _widec < 5697 ) {
					if ( 5680 <= _widec && _widec <= 5689 )
						goto tr57;
				} else if ( _widec > 5722 ) {
					if ( 5729 <= _widec && _widec <= 5754 )
						goto tr57;
				} else
					goto tr57;
			} else
				goto st58;
		} else
			goto tr52;
	} else
		goto tr12;
	goto tr112;
	}
	_test_eof7: (		ctx->cs) = 7; goto _test_eof; 
	_test_eof8: (		ctx->cs) = 8; goto _test_eof; 
	_test_eof9: (		ctx->cs) = 9; goto _test_eof; 
	_test_eof10: (		ctx->cs) = 10; goto _test_eof; 
	_test_eof11: (		ctx->cs) = 11; goto _test_eof; 
	_test_eof12: (		ctx->cs) = 12; goto _test_eof; 
	_test_eof1: (		ctx->cs) = 1; goto _test_eof; 
	_test_eof2: (		ctx->cs) = 2; goto _test_eof; 
	_test_eof13: (		ctx->cs) = 13; goto _test_eof; 
	_test_eof14: (		ctx->cs) = 14; goto _test_eof; 
	_test_eof15: (		ctx->cs) = 15; goto _test_eof; 
	_test_eof16: (		ctx->cs) = 16; goto _test_eof; 
	_test_eof17: (		ctx->cs) = 17; goto _test_eof; 
	_test_eof18: (		ctx->cs) = 18; goto _test_eof; 
	_test_eof19: (		ctx->cs) = 19; goto _test_eof; 
	_test_eof3: (		ctx->cs) = 3; goto _test_eof; 
	_test_eof20: (		ctx->cs) = 20; goto _test_eof; 
	_test_eof21: (		ctx->cs) = 21; goto _test_eof; 
	_test_eof4: (		ctx->cs) = 4; goto _test_eof; 
	_test_eof22: (		ctx->cs) = 22; goto _test_eof; 
	_test_eof23: (		ctx->cs) = 23; goto _test_eof; 
	_test_eof24: (		ctx->cs) = 24; goto _test_eof; 
	_test_eof25: (		ctx->cs) = 25; goto _test_eof; 
	_test_eof26: (		ctx->cs) = 26; goto _test_eof; 
	_test_eof27: (		ctx->cs) = 27; goto _test_eof; 
	_test_eof28: (		ctx->cs) = 28; goto _test_eof; 
	_test_eof29: (		ctx->cs) = 29; goto _test_eof; 
	_test_eof30: (		ctx->cs) = 30; goto _test_eof; 
	_test_eof31: (		ctx->cs) = 31; goto _test_eof; 
	_test_eof32: (		ctx->cs) = 32; goto _test_eof; 
	_test_eof33: (		ctx->cs) = 33; goto _test_eof; 
	_test_eof34: (		ctx->cs) = 34; goto _test_eof; 
	_test_eof35: (		ctx->cs) = 35; goto _test_eof; 
	_test_eof36: (		ctx->cs) = 36; goto _test_eof; 
	_test_eof37: (		ctx->cs) = 37; goto _test_eof; 
	_test_eof38: (		ctx->cs) = 38; goto _test_eof; 
	_test_eof39: (		ctx->cs) = 39; goto _test_eof; 
	_test_eof40: (		ctx->cs) = 40; goto _test_eof; 
	_test_eof41: (		ctx->cs) = 41; goto _test_eof; 
	_test_eof42: (		ctx->cs) = 42; goto _test_eof; 
	_test_eof43: (		ctx->cs) = 43; goto _test_eof; 
	_test_eof44: (		ctx->cs) = 44; goto _test_eof; 
	_test_eof45: (		ctx->cs) = 45; goto _test_eof; 
	_test_eof46: (		ctx->cs) = 46; goto _test_eof; 
	_test_eof47: (		ctx->cs) = 47; goto _test_eof; 
	_test_eof48: (		ctx->cs) = 48; goto _test_eof; 
	_test_eof49: (		ctx->cs) = 49; goto _test_eof; 
	_test_eof50: (		ctx->cs) = 50; goto _test_eof; 
	_test_eof51: (		ctx->cs) = 51; goto _test_eof; 
	_test_eof52: (		ctx->cs) = 52; goto _test_eof; 
	_test_eof5: (		ctx->cs) = 5; goto _test_eof; 
	_test_eof53: (		ctx->cs) = 53; goto _test_eof; 
	_test_eof6: (		ctx->cs) = 6; goto _test_eof; 
	_test_eof54: (		ctx->cs) = 54; goto _test_eof; 
	_test_eof55: (		ctx->cs) = 55; goto _test_eof; 
	_test_eof56: (		ctx->cs) = 56; goto _test_eof; 
	_test_eof57: (		ctx->cs) = 57; goto _test_eof; 
	_test_eof58: (		ctx->cs) = 58; goto _test_eof; 
	_test_eof59: (		ctx->cs) = 59; goto _test_eof; 
	_test_eof60: (		ctx->cs) = 60; goto _test_eof; 
	_test_eof61: (		ctx->cs) = 61; goto _test_eof; 
	_test_eof62: (		ctx->cs) = 62; goto _test_eof; 
	_test_eof63: (		ctx->cs) = 63; goto _test_eof; 
	_test_eof64: (		ctx->cs) = 64; goto _test_eof; 
	_test_eof65: (		ctx->cs) = 65; goto _test_eof; 

	_test_eof: {}
	if ( (		ctx->p) == (	ctx->eof) )
	{
	switch ( (		ctx->cs) ) {
	case 8: goto tr2;
	case 9: goto tr58;
	case 10: goto tr60;
	case 11: goto tr2;
	case 12: goto tr58;
	case 1: goto tr0;
	case 2: goto tr2;
	case 13: goto tr65;
	case 14: goto tr58;
	case 15: goto tr67;
	case 16: goto tr58;
	case 17: goto tr70;
	case 18: goto tr70;
	case 19: goto tr70;
	case 3: goto tr2;
	case 20: goto tr75;
	case 21: goto tr2;
	case 4: goto tr6;
	case 22: goto tr77;
	case 23: goto tr78;
	case 24: goto tr58;
	case 25: goto tr58;
	case 26: goto tr58;
	case 27: goto tr58;
	case 28: goto tr58;
	case 29: goto tr60;
	case 30: goto tr2;
	case 31: goto tr58;
	case 32: goto tr91;
	case 33: goto tr91;
	case 34: goto tr65;
	case 35: goto tr58;
	case 36: goto tr67;
	case 37: goto tr58;
	case 38: goto tr70;
	case 39: goto tr70;
	case 40: goto tr70;
	case 41: goto tr2;
	case 42: goto tr2;
	case 43: goto tr2;
	case 44: goto tr78;
	case 45: goto tr58;
	case 46: goto tr58;
	case 47: goto tr58;
	case 48: goto tr58;
	case 49: goto tr112;
	case 50: goto tr112;
	case 51: goto tr112;
	case 52: goto tr58;
	case 5: goto tr2;
	case 53: goto tr115;
	case 6: goto tr2;
	case 54: goto tr112;
	case 55: goto tr112;
	case 56: goto tr112;
	case 57: goto tr112;
	case 58: goto tr112;
	case 59: goto tr112;
	case 60: goto tr2;
	case 61: goto tr115;
	case 62: goto tr91;
	case 63: goto tr112;
	case 64: goto tr112;
	case 65: goto tr112;
	}
	}

	_out: {}
	}

//#line 540 "scan.rl"
		
		ctx->bol = (last_token == t_newline) ? TRUE : FALSE;
	
		if ( last_token != t_end )
			return last_token;

		/* if reading from file, get next line */
		if ( ctx->file && read_next_line( ctx ) )
			reset_scan( ctx );
		else
			pop_context( self );	/* pop context and try again */
	}
	
	return t_end;					/* no more input */
}

/*-----------------------------------------------------------------------------
* get the next token, set last_tokenXXX as side-effect
*----------------------------------------------------------------------------*/
enum token get_token( void )
{
	return get_token_Scan( the_scan );
}

enum token get_token_Scan( Scan *self )
{
	return _get_token_Scan( self, FALSE );	/* by tokens */
}

/*-----------------------------------------------------------------------------
* get the next input line from file - return pointer to last_token_str->str, 
* or NULL at end of input
*----------------------------------------------------------------------------*/
char *get_line( void )
{
	return get_line_Scan( the_scan );
}

char *get_line_Scan( Scan *self )
{
	enum token token = _get_token_Scan( self, TRUE );	/* by lines */
	if ( token == t_string )
		return last_token_str->str;
	else
		return NULL;
}

#if 0
/*-----------------------------------------------------------------------------
* Bridge to OLD-SCAN interface
*----------------------------------------------------------------------------*/
enum symbols sym = nil;
char ident[MAXLINE];

static enum symbols map_sym( enum token token )
{
	switch (token)
	{
		case t_end:			return nil;
		case t_name:		return name;
		case t_label:		return label;
		case t_number:		return number;
		case t_string:		return string;
		case t_newline:		return newline;
		case t_exclam:		return log_not;
		case t_hash:		return constexpr;
		case t_percent:		return mod;
		case t_lparen:		return lparen;
		case t_rparen:		return rparen;
		case t_star:		return multiply;
		case t_plus:		return plus;
		case t_comma:		return comma;
		case t_minus:		return minus;
		case t_dot:			return fullstop;
		case t_slash:		return divi;
		case t_lt:			return less;
		case t_eq:			return assign;
		case t_gt:			return greater;
		case t_lsquare:		return lsquare;
		case t_rsquare:		return rsquare;
		case t_lcurly:		return lcurly;
		case t_vbar:		return bin_or;
		case t_rcurly:		return rcurly;
		case t_lt_gt:		return notequal;
		case t_exclam_eq:	return notequal;
		case t_lt_eq:		return lessequal;
		case t_gt_eq:		return greatequal;
		case t_star_star:	return power;
#ifdef __LEGACY_Z80ASM_SYNTAX
		case t_and:			return strconq;
		case t_tilde:		return bin_and;
		case t_colon:		return bin_xor;
		case t_caret:		return power;
#else
		case t_and:			return bin_and;
		case t_tilde:		return bin_not;
		case t_colon:		return colon;
		case t_caret:		return bin_xor;
#endif

		/* unused */
		case t_dollar:
		case t_question:	
		case t_at:			
		case t_bslash:		
		case t_bquote:		
		case t_eq_eq:		
		case t_vbar_vbar:	
		case t_and_and:		
		case t_lt_lt:		
		case t_gt_gt:		
		default: 			return nil;
	}
}

/* get the next token */
enum symbols GetSym( void )
{
	/* call lexer, set token, ident */
	sym = map_sym( get_token() );
	g_strlcpy( ident, last_token_str->str, sizeof(ident) );
	
	return sym;
}

/* skip to end of line */
void Skipline( void )
{
	while ( sym != newline && sym != nil )
		GetSym();
}
#endif



/*
* $Log: scan.c,v $
* Revision 1.28  2013-12-15 13:18:34  pauloscustodio
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
