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

Scanner header corresponding to scan.rl
Note: the scanner is not reentrant. scan_get() relies on state variables that
need to be kept across calls.

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/scan.h,v 1.29 2014-03-11 22:59:20 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */

#include "types.h"

/* declare prsline.c externals */
extern void SetTemporaryLine( char *line );
extern char *ScanGetPos( void );
extern void  ScanSetPos( char *pos );

extern char *sym_string;	/* contains double-quoted string without quotes
							   to return with a TK_STRING */
extern long  sym_number;	/* contains number to return with a TK_NUMBER */

extern BOOL EOL;

/*-----------------------------------------------------------------------------
*   A scanner token is represented as an integer that is the ascii code for
*	the single-character token.
*	0 represents end of input.
*	Special tokens have codes that do not overlap with the above.
*----------------------------------------------------------------------------*/
typedef enum token
{
    T_END		= 0,

    T_NEWLINE 	= '\n',
	
    T_EXCLAM 	= '!',
    T_HASH 		= '#',
    T_DOLLAR 	= '$',
    T_PERCENT 	= '%',
    T_AND 		= '&',
    T_LPAREN 	= '(',
    T_RPAREN 	= ')',
    T_STAR 		= '*',
    T_PLUS 		= '+',
    T_COMMA 	= ',',
    T_MINUS 	= '-',
    T_DOT 		= '.',
    T_SLASH 	= '/',
    T_COLON 	= ':',
    T_LT 		= '<',
    T_EQ 		= '=',
    T_GT 		= '>',
    T_QUESTION 	= '?',
    T_AT 		= '@',
    T_LSQUARE 	= '[',
    T_BSLASH 	= '\\',
    T_RSQUARE 	= ']',
    T_CARET 	= '^',
    T_BQUOTE 	= '`',
    T_LCURLY 	= '{',
    T_VBAR 		= '|',
    T_RCURLY 	= '}',
    T_TILDE 	= '~',

    T_EQ_EQ		= 128,	/* "==" */
    T_LT_GT,			/* "<>" */
    T_EXCLAM_EQ,		/* "!=" */
    T_LT_EQ,			/* "<=" */
    T_GT_EQ,			/* ">=" */
    T_VBAR_VBAR,		/* "||" */
    T_AND_AND,			/* "&&" */
    T_LT_LT,			/* "<<" */
    T_GT_GT,			/* ">>" */
    T_STAR_STAR,		/* "**" */

    T_NAME,				/* identifier, sets last_token_str in upper case */
    T_LABEL,			/* .identifier | identifier:, sets last_token_str 
						   in upper case */
    T_STRING,			/* double-quoted string, sets last_token_str 
						   excluding quotes */
    T_NUMBER,			/* number or single-quoted char, sets last_token_num */
	
	/* assembly keywords */
	T_ADD,
	T_LD,
	T_NOP,
	
} Token;

/*-----------------------------------------------------------------------------
* 	Globals - last token retrieved
*	last_token_num and last_token_str keep their values until a new token
*	of the same type is retrieved.
*----------------------------------------------------------------------------*/
extern Token	 last_token;
extern long		 last_token_num;
extern char		*last_token_str;

/*-----------------------------------------------------------------------------
* 	Scan API
*----------------------------------------------------------------------------*/

/* prepare for scanning string, bol = TRUE if string is at start of a line,
   to detect label definitions */
extern void scan_reset( char *text, BOOL _at_bol );

/* get the next token, set last_tokenXXX as side-effect */
extern Token scan_get( void );


/*
* $Log: scan.h,v $
* Revision 1.29  2014-03-11 22:59:20  pauloscustodio
* Move EOL flag to scanner
*
* Revision 1.28  2014/03/11 00:15:13  pauloscustodio
* Scanner reads input line-by-line instead of character-by-character.
* Factor house-keeping at each new line read in the scanner getasmline().
* Add interface to allow back-tacking of the recursive descent parser by
* getting the current input buffer position and comming back to the same later.
* SetTemporaryLine() keeps a stack of previous input lines.
* Scanner handles single-quoted strings and returns a number.
* New error for single-quoted string with length != 1.
* Scanner handles double-quoted strings and returns the quoted string.
*
* Revision 1.27  2014/02/09 10:16:15  pauloscustodio
* Remove complexity out of scan.rl by relying on srcfile to handle contexts of
* recursive includes, and reading of lines of text, and by assuming scan.c
* will not be reentred, simplifying the keeping of state variables for the scan.
*
* Revision 1.26  2014/02/03 22:04:03  pauloscustodio
* ws
*
* Revision 1.25  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.24  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.23  2014/01/10 00:15:26  pauloscustodio
* Use Str instead of glib, List instead of GSList.
* Use init.h mechanism, no need for main() calling init_scan.
* glib dependency removed from code and Makefile
*
* Revision 1.22  2013/12/15 13:18:34  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.21  2013/11/11 23:47:03  pauloscustodio
* Move source code generation tools to dev/Makefile, only called on request,
* and keep the generated files in z80asm directory, so that build does
* not require tools used for the code generation (ragel, perl).
* Remove code generation for structs - use CLASS macro instead.
*
* Revision 1.20  2013/10/15 23:24:33  pauloscustodio
* Move reading by lines or tokens and file reading interface to scan.rl
* to decouple file.c from scan.c.
* Add singleton interface to scan to be used by parser.
*
* Revision 1.19  2013/10/08 21:53:06  pauloscustodio
* Replace Flex-based lexer by a Ragel-based one.
* Add interface to file.c to read files by tokens, calling the lexer.
*
*
*/
