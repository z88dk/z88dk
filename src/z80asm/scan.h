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

Scanner. Scanning engine is built by ragel from scan_rules.rl.

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/scan.h,v 1.35 2014-07-06 23:11:25 pauloscustodio Exp $
*/

#pragma once

#include "types.h"

/*-----------------------------------------------------------------------------
*	Token IDs
*----------------------------------------------------------------------------*/
#define TOKEN(name, string) name,
#define TOKEN2(name, string)
typedef enum tokid_t
{
#include "scan_def.h"
} tokid_t;

/*-----------------------------------------------------------------------------
* 	Globals - last token retrieved
*----------------------------------------------------------------------------*/
extern tokid_t tok;			/* current token */
extern char	  *tok_text;	/* contains characters of the retrieved token, only for
							   symbols used in the expression parser */
extern char   *tok_name;	/* contains identifier to return with TK_NAME and TK_LABEL */
extern char   *tok_string;	/* contains double-quoted string without quotes
							   to return with a TK_STRING */
extern long    tok_number;	/* contains number to return with TK_NUMBER */
extern void  (*tok_parser)(void);	/* parser for this keyword as opcode */

extern Bool EOL;			/* scanner EOL state */

/*-----------------------------------------------------------------------------
*	Scan API
*----------------------------------------------------------------------------*/

/* get the next token, fill the corresponding tok* variables */
extern tokid_t GetSym( void );

/* save the current scan position and back-track to a saved position */
extern char *ScanGetPos( void );
extern void  ScanSetPos( char *pos );

/* insert the given text at the current scan position */
extern void SetTemporaryLine( char *line );

/* skip line past the newline, set EOL */
extern void  Skipline( void );
extern Bool EOL;
