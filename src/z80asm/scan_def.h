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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/scan_def.h,v 1.4 2014-12-04 23:30:20 pauloscustodio Exp $
*/

#include "legacy.h"

/*-----------------------------------------------------------------------------
*	Token IDs
*	Lexical tokens are returned by the lexer
*	Semantical tokens are used internally and have semantical value 
*----------------------------------------------------------------------------*/
#ifndef TOKEN_RE
#define TOKEN_RE(name, string, regexp, set_value)
#endif

#ifndef TOKEN
#define TOKEN(name, string, set_value)
#endif

/* used for alias */
#ifndef TOKEN2
#define TOKEN2(name, string, set_value)
#endif

TOKEN(	TK_END,			"",)	/* = 0; end of file reached */
TOKEN(	TK_NIL,			"", )	/* returned for rubish */
TOKEN(	TK_INVALID,		"", )	/* used as impossible to get token */
TOKEN(	TK_NAME,		"", )
TOKEN(	TK_LABEL,		"", )
TOKEN(	TK_NUMBER,		"", )
TOKEN(	TK_STRING,		"", )
TOKEN(	TK_TERN_COND,	"", )	/* cond ? true : false */
TOKEN(	TK_ASMPC,		"ASMPC", )

TOKEN(	TK_IF_STMT,		"", )
TOKEN(	TK_ELSE_STMT,	"", )
TOKEN(	TK_ENDIF_STMT,	"", )

/*-----------------------------------------------------------------------------
*	lexical tokens in ASCII order
*----------------------------------------------------------------------------*/

TOKEN(TK_NEWLINE, "\n", )

/* no token for " " */

TOKEN(TK_LOG_NOT, "!", )

/* no token for "\"" */

TOKEN(TK_CONST_EXPR, "#", )

/* no token for "$" */

TOKEN(TK_MOD, "%", )

#ifdef __LEGACY_Z80ASM_SYNTAX
TOKEN(	TK_STRING_CAT,	"&", )
#else
TOKEN(TK_BIN_AND, "&", )
#define TK_STRING_CAT	TK_COMMA
#endif

TOKEN(TK_LOG_AND, "&&", )

/* no token for "'" */

TOKEN(TK_LPAREN, "(", )
TOKEN(TK_RPAREN, ")", )
TOKEN(TK_MULTIPLY, "*", )
TOKEN(TK_PLUS, "+", )
TOKEN(TK_COMMA, ",", )
TOKEN(TK_MINUS, "-", )
TOKEN(TK_DOT, ".", )
TOKEN(TK_DIVIDE, "/", )

/* no token for "0" .. "9" */

#ifdef __LEGACY_Z80ASM_SYNTAX
TOKEN(	TK_BIN_XOR,		":", )
#define TK_COLON		TK_INVALID
#else
TOKEN(TK_COLON, ":", )
#endif

/* no token for ";" */

TOKEN(TK_LESS, "<", )
TOKEN(TK_LEFT_SHIFT, "<<", )
TOKEN(TK_LESS_EQ, "<=", )
TOKEN(TK_NOT_EQ, "<>", )
TOKEN2(TK_NOT_EQ, "!=", )
TOKEN(TK_EQUAL, "=", )
TOKEN2(TK_EQUAL, "==", )
TOKEN(TK_GREATER, ">", )
TOKEN(TK_RIGHT_SHIFT, ">>", )
TOKEN(TK_GREATER_EQ, ">=", )

#ifdef __LEGACY_Z80ASM_SYNTAX
#define TK_QUESTION		TK_INVALID
#else
TOKEN(TK_QUESTION, "?", )
#endif

/* no token for "@", "A" .. "Z" */

TOKEN(TK_LSQUARE, "[", )

/* no token for "\\" */

TOKEN(TK_RSQUARE, "]", )

#ifdef __LEGACY_Z80ASM_SYNTAX
TOKEN(	TK_POWER,		"^", )
TOKEN2(	TK_POWER,		"**", )
#else
TOKEN(TK_BIN_XOR, "^", )
TOKEN(TK_POWER, "**", )
#endif

/* no token for "_", "`", "a" .. "z" */

TOKEN(TK_LCURLY, "{", )
TOKEN(TK_BIN_OR, "|", )
TOKEN(TK_LOG_OR, "||", )
TOKEN(TK_RCURLY, "}", )

#ifdef __LEGACY_Z80ASM_SYNTAX
TOKEN(	TK_BIN_AND,		"~", )
#define TK_BIN_NOT		TK_INVALID
#else
TOKEN(TK_BIN_NOT, "~", )
#endif

/*-----------------------------------------------------------------------------
*	Assembly keywords
*----------------------------------------------------------------------------*/
#define SET_IX		tok_idx_reg = opts.swap_ix_iy ? IDX_REG_IY : IDX_REG_IX
#define SET_IY		tok_idx_reg = opts.swap_ix_iy ? IDX_REG_IX : IDX_REG_IY

/* flags */
TOKEN(TK_NZ, "NZ", tok_flag = FLAG_NZ)
TOKEN(TK_Z, "Z", tok_flag = FLAG_Z)
TOKEN(TK_NC, "NC", tok_flag = FLAG_NC)
TOKEN(TK_C, "C", tok_flag = FLAG_C; tok_reg8 = REG8_C)
TOKEN(TK_PO, "PO", tok_flag = FLAG_PO)
TOKEN(TK_PE, "PE", tok_flag = FLAG_PE)
TOKEN(TK_P, "P", tok_flag = FLAG_P)
TOKEN(TK_M, "M", tok_flag = FLAG_M)

/* 8-bit registers */
TOKEN(TK_B, "B", tok_reg8 = REG8_B)

TOKEN(TK_D, "D", tok_reg8 = REG8_D)
TOKEN(TK_E, "E", tok_reg8 = REG8_E)

TOKEN(TK_H, "H", tok_reg8 = REG8_H)
TOKEN(TK_IXH, "IXH", tok_reg8 = REG8_H; SET_IX)
TOKEN(TK_IYH, "IYH", tok_reg8 = REG8_H; SET_IY)

TOKEN(TK_L, "L", tok_reg8 = REG8_L)
TOKEN(TK_IXL, "IXL", tok_reg8 = REG8_L; SET_IX)
TOKEN(TK_IYL, "IYL", tok_reg8 = REG8_L; SET_IY)

TOKEN(TK_A, "A", tok_reg8 = REG8_A)

TOKEN(TK_F, "F", )

TOKEN(TK_I, "I", )
TOKEN(TK_IIR, "IIR", )

TOKEN(TK_R, "R", )
TOKEN(TK_EIR, "EIR", )

/* indirect 8-bit register */
TOKEN_RE(TK_IND_C, "(C)", "(" hspace "C"i hspace ")", )

/* 16-bit registers */
TOKEN(TK_BC, "BC", tok_reg16_af = tok_reg16_sp = REG16_BC)
TOKEN(TK_DE, "DE", tok_reg16_af = tok_reg16_sp = REG16_DE)

TOKEN(TK_HL, "HL", tok_reg16_af = tok_reg16_sp = REG16_HL)
TOKEN(TK_IX, "IX", tok_reg16_af = tok_reg16_sp = REG16_HL; SET_IX)
TOKEN(TK_IY, "IY", tok_reg16_af = tok_reg16_sp = REG16_HL; SET_IY)

TOKEN(TK_AF, "AF", tok_reg16_af = REG16_AF)
TOKEN(TK_SP, "SP", tok_reg16_sp = REG16_SP)

TOKEN(TK_AF1, "AF'", )

/* indirect 16-bit registers */
TOKEN_RE(TK_IND_BC, "(BC)", "(" hspace "BC"i hspace ")", tok_ind_reg16 = IND_REG16_BC)
TOKEN_RE(TK_IND_DE, "(DE)", "(" hspace "DE"i hspace ")", tok_ind_reg16 = IND_REG16_DE)

TOKEN_RE(TK_IND_HL, "(HL)", "(" hspace "HL"i hspace ")", tok_ind_reg16 = IND_REG16_HL)

TOKEN_RE(TK_IND_IX, "(IX", "(" hspace "IX"i index_reg_suffix, 
		 p--; te--; tok_ind_reg16 = IND_REG16_HL; SET_IX)
TOKEN_RE(TK_IND_IY, "(IY", "(" hspace "IY"i index_reg_suffix, 
		 p--; te--; tok_ind_reg16 = IND_REG16_HL; SET_IY)

TOKEN_RE(TK_IND_SP, "(SP)", "(" hspace "SP"i hspace ")", )

/* DEFGROUP storage specifiers */
TOKEN(TK_DS_B, "DS.B", tok_ds_size = 1 )
TOKEN(TK_DS_W, "DS.W", tok_ds_size = 2 )
TOKEN(TK_DS_P, "DS.P", tok_ds_size = 3 )
TOKEN(TK_DS_L, "DS.L", tok_ds_size = 4 )

#undef TOKEN_RE
#undef TOKEN
#undef TOKEN2
