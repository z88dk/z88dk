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

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2014

Define lexer tokens

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/scan_def.h,v 1.1 2014-04-06 23:29:26 pauloscustodio Exp $
*/

#include "legacy.h"

/*-----------------------------------------------------------------------------
*	Token IDs
*	Lexical tokens are returned by the lexer
*	Semantical tokens are used internally and have semantical value 
*----------------------------------------------------------------------------*/
#ifndef TOKEN
#define TOKEN(name, string)
#endif

/* used for alias */
#ifndef TOKEN2
#define TOKEN2(name, string)
#endif


TOKEN(	TK_END,			"" )	/* = 0; end of file reached */
TOKEN(	TK_NIL,			"" )	/* returned for rubish */
TOKEN(	TK_INVALID,		"" )	/* used as impossible to get token */
TOKEN(	TK_NAME,		"" )
TOKEN(	TK_LABEL,		"" )
TOKEN(	TK_NUMBER,		"" )
TOKEN(	TK_STRING,		"" )
TOKEN(	TK_TERN_COND,	"" )	/* cond ? true : false */

TOKEN(	TK_IF_STMT,		"" )
TOKEN(	TK_ELSE_STMT,	"" )
TOKEN(	TK_ENDIF_STMT,	"" )

/* lexical tokens in ASCII order */

TOKEN(	TK_NEWLINE,		"\n")

/* no token for " " */

TOKEN(	TK_LOG_NOT,		"!" )

/* no token for "\"" */

TOKEN(	TK_CONST_EXPR,	"#" )

/* no token for "$" */

TOKEN(	TK_MOD,			"%" )

#ifdef __LEGACY_Z80ASM_SYNTAX
TOKEN(	TK_STRING_CAT,	"&" )
#else
TOKEN(	TK_BIN_AND,		"&" )
#define TK_STRING_CAT	TK_COMMA
#endif

TOKEN(	TK_LOG_AND,		"&&" )

/* no token for "'" */

TOKEN(	TK_LPAREN,		"(" )
TOKEN(	TK_RPAREN,		")" )
TOKEN(	TK_MULTIPLY,	"*" )
TOKEN(	TK_PLUS,		"+" )
TOKEN(	TK_COMMA,		"," )
TOKEN(	TK_MINUS,		"-" )
TOKEN(	TK_DOT, 		"." )
TOKEN(	TK_DIVIDE,		"/" )

/* no token for "0" .. "9" */

#ifdef __LEGACY_Z80ASM_SYNTAX
TOKEN(	TK_BIN_XOR,		":" )
#define TK_COLON		TK_INVALID
#else
TOKEN(	TK_COLON,		":" )
#endif

/* no token for ";" */

TOKEN(	TK_LESS,		"<" )
TOKEN(	TK_LEFT_SHIFT,	"<<" )
TOKEN(	TK_LESS_EQ,		"<=" )
TOKEN(	TK_NOT_EQ,		"<>" )
TOKEN2(	TK_NOT_EQ,		"!=" )
TOKEN(	TK_EQUAL,		"=" )
TOKEN2(	TK_EQUAL,		"==" )
TOKEN(	TK_GREATER,		">" )
TOKEN(	TK_RIGHT_SHIFT,	">>" )
TOKEN(	TK_GREATER_EQ,	">=" )

#ifdef __LEGACY_Z80ASM_SYNTAX
#define TK_QUESTION		TK_INVALID
#else
TOKEN(	TK_QUESTION, 	"?" )
#endif

/* no token for "@", "A" .. "Z" */

TOKEN(	TK_LSQUARE,		"[" )

/* no token for "\\" */

TOKEN(	TK_RSQUARE,		"]" )

#ifdef __LEGACY_Z80ASM_SYNTAX
TOKEN(	TK_POWER,		"^" )
TOKEN2(	TK_POWER,		"**" )
#else
TOKEN(	TK_BIN_XOR,		"^" )
TOKEN(	TK_POWER,		"**" )
#endif

/* no token for "_", "`", "a" .. "z" */

TOKEN(	TK_LCURLY,		"{" )
TOKEN(	TK_BIN_OR,		"|" )
TOKEN(	TK_LOG_OR,		"||" )
TOKEN(	TK_RCURLY,		"}" )

#ifdef __LEGACY_Z80ASM_SYNTAX
TOKEN(	TK_BIN_AND,		"~" )
#define TK_BIN_NOT		TK_INVALID
#else
TOKEN(	TK_BIN_NOT,		"~" )
#endif

/* marker to get number of tokens */
TOKEN(	NUM_TOKENS,		""	)

#undef TOKEN

/*
* $Log: scan_def.h,v $
* Revision 1.1  2014-04-06 23:29:26  pauloscustodio
* Removed lookup functions in token.c, no longer needed with the ragel based scanner.
* Moved the token definitions from token_def.h to scan_def.h.
*
* Revision 1.18  2014/03/29 00:33:29  pauloscustodio
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
* Revision 1.17  2014/03/18 22:44:03  pauloscustodio
* Scanner decodes a number into tok_number.
* GetConstant(), TK_HEX_CONST, TK_BIN_CONST and TK_DEC_CONST removed.
* ident[] replaced by tok_name.
*
* Revision 1.16  2014/03/11 22:59:20  pauloscustodio
* Move EOL flag to scanner
*
* Revision 1.15  2014/03/11 00:15:13  pauloscustodio
* Scanner reads input line-by-line instead of character-by-character.
* Factor house-keeping at each new line read in the scanner getasmline().
* Add interface to allow back-tacking of the recursive descent parser by
* getting the current input buffer position and comming back to the same later.
* SetTemporaryLine() keeps a stack of previous input lines.
* Scanner handles single-quoted strings and returns a number.
* New error for single-quoted string with length != 1.
* Scanner handles double-quoted strings and returns the quoted string.
*
* Revision 1.14  2014/03/04 11:49:47  pauloscustodio
* Expression parser and expression evaluator use a look-up table of all
* supported unary, binary and ternary oprators, instead of a big switch
* statement to select the operation.
* Expression operations are stored in a contiguous array instead of
* a liked list to reduce administrative overhead of adding / iterating.
*
* Revision 1.13  2014/03/02 12:51:41  pauloscustodio
* Change token ids to TK_...
*
* Revision 1.12  2014/03/01 15:45:31  pauloscustodio
* CH_0021: New operators ==, !=, &&, ||, <<, >>, ?:
* Handle C-like operators, make exponentiation (**) right-associative.
* Simplify expression parser by handling composed tokens in lexer.
* Change token ids to TK_...
*
* Revision 1.11  2014/02/23 18:48:16  pauloscustodio
* CH_0021: New operators ==, !=, &&, ||, ?:
* Handle C-like operators ==, !=, &&, || and ?:.
* Simplify expression parser by handling composed tokens in lexer.
*
* Revision 1.10  2014/02/17 23:15:13  pauloscustodio
* Define NUM_TOKENS to be used as size of arrays.
*
* Revision 1.9  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.8  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.7  2013/10/15 23:24:33  pauloscustodio
* Move reading by lines or tokens and file reading interface to scan.rl
* to decouple file.c from scan.c.
* Add singleton interface to scan to be used by parser.
*
* Revision 1.6  2013/10/07 00:07:05  pauloscustodio
* log
*
* Revision 1.5  2013/10/07 00:06:18  pauloscustodio
* Create default empty TOKEN() macro if not defined
*
* Revision 1.4  2013/09/01 12:00:07  pauloscustodio
* Cleanup compilation warnings
*
* Revision 1.3  2013/08/30 21:50:43  pauloscustodio
* By suggestion of Philipp Klaus Krause: rename LEGACY to __LEGACY_Z80ASM_SYNTAX,
* as an identifier reserved by the C standard for implementation-defined behaviour
* starting with two underscores.
*
* Revision 1.2  2013/08/30 01:11:54  pauloscustodio
* Symbols in symbol.h enum definition and in z80asm.c ssyms[] must be in the exact
* same order. Moreover need to define some different symbols for the legacy
* version.
*
* Move all defintions to token_def.h, included in both other files.
*
* Revision 1.1  2013/08/30 01:06:08  pauloscustodio
* New C-like expressions, defined when __LEGACY_Z80ASM_SYNTAX is not defined. Keeps old
* behaviour under -D__LEGACY_Z80ASM_SYNTAX (defined in legacy.h)
*
* BACKWARDS INCOMPATIBLE CHANGE, turned OFF by default (-D__LEGACY_Z80ASM_SYNTAX)
* - Expressions now use more standard C-like operators
* - Object and library files changed signature to
*   "Z80RMF02", "Z80LMF02", to avoid usage of old
*   object files with expressions inside in the old format
*
* Detail:
* - String concatenation in DEFM: changed from '&' to ',';  '&' will be AND
* - Power:                        changed from '^' to '**'; '^' will be XOR
* - XOR:                          changed from ':' to '^';
* - AND:                          changed from '~' to '&';  '~' will be NOT
* - NOT:                          '~' added as binary not
*
*/
