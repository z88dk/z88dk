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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/scan.h,v 1.34 2014-05-25 01:02:29 pauloscustodio Exp $
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

/*
* $Log: scan.h,v $
* Revision 1.34  2014-05-25 01:02:29  pauloscustodio
* Byte, Int, UInt added
*
* Revision 1.33  2014/04/06 23:29:26  pauloscustodio
* Removed lookup functions in token.c, no longer needed with the ragel based scanner.
* Moved the token definitions from token_def.h to scan_def.h.
*
* Revision 1.32  2014/03/29 00:33:28  pauloscustodio
* BUG_0044: binary constants with more than 8 bits not accepted
* CH_0022: Added syntax to define binary numbers as bitmaps
* Replaced tokenizer with Ragel based scanner.
* Simplified scanning code by using ragel instead of hand-built scanner
* and tokenizer.
* Removed 'D' suffix to signal decimal number.
* Parse AF' correctly.
* Decimal numbers expressed as sequence of digits, e.g. 1234.
* Hexadecimal numbers either prefixed with '0x' or '$' or suffixed with 'H',
* in which case they need to start with a digit, or start with a zero,
* e.g. 0xFF, $ff, 0FFh.
* Binary numbers either prefixed with '0b' or '@', or suffixed with 'B',
* e.g. 0b10101, @10101, 10101b.
*
* Revision 1.31  2014/03/16 19:19:49  pauloscustodio
* Integrate use of srcfile in scanner, removing global variable z80asmfile
* and attributes CURRENTMODULE->cfile->line and CURRENTMODULE->cfile->fname.
*
* Revision 1.30  2014/03/15 02:12:07  pauloscustodio
* Rename last token to tok*
* GetSym() declared in scan.h
*
* Revision 1.29  2014/03/11 22:59:20  pauloscustodio
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
