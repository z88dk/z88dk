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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/scan_token.h,v 1.1 2013-04-14 18:17:00 pauloscustodio Exp $
$Log: scan_token.h,v $
Revision 1.1  2013-04-14 18:17:00  pauloscustodio
Split scanner in several modules, allow token look-ahead to simplify
parser.


*/

#ifndef SCAN_TOKEN_H
#define SCAN_TOKEN_H

#include "memalloc.h"	/* before any other include */

#include "class.h"
#include "classring.h"
#include "dynstr.h"

/*-----------------------------------------------------------------------------
*   Constants
*----------------------------------------------------------------------------*/
#define MAX_LOKKAHEAD	4		/* max number of tokens to look-ahead */

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
    TOK_NUMBER,
    TOK_STRING,                 /* single- or double-quoted string */
    TOK_PREPROC,                /* preprocessor command */

	/* semantic tokens, i.e. returned by the parser */
	TOK_LABEL,

} TokType;

/*-----------------------------------------------------------------------------
*   Token and ring of tokens
*----------------------------------------------------------------------------*/
CLASS(Token)
	TokType	tok_type;			/* type of token */
	long	num_value;			/* numeric value, if any */
	Str	   *str_value;			/* string value, if any */
	char   *filename;			/* file name - kept in strpool */
	int 	line_nr;			/* input line number */
END_CLASS;

CLASS_RING(Token, MAX_LOKKAHEAD);

/* set a token by copy of another */
extern void Token_set( Token *self, Token *other );

/* clear a token */
extern void Token_clear( Token *self );


#endif /* ndef SCAN_TOKEN_H */
