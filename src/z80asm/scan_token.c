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

Token class for tokens returned by scanner

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/scan_token.c,v 1.1 2013-04-14 18:17:00 pauloscustodio Exp $
$Log: scan_token.c,v $
Revision 1.1  2013-04-14 18:17:00  pauloscustodio
Split scanner in several modules, allow token look-ahead to simplify
parser.


*/

#include "memalloc.h"	/* before any other include */

#include "scan_token.h"
#include "strpool.h"

/*-----------------------------------------------------------------------------
*   Token
*----------------------------------------------------------------------------*/
DEF_CLASS(Token);
DEF_CLASS_RING(Token);


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

