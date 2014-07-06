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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/scan_def.h,v 1.3 2014-07-06 23:11:25 pauloscustodio Exp $
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
TOKEN(	TK_ASMPC,		"ASMPC" )

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
