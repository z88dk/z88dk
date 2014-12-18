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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/scan_def.h,v 1.7 2014-12-18 14:23:20 pauloscustodio Exp $
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
TOKEN(TK_STRING_CAT, "&", )
#else
TOKEN(TK_BIN_AND, "&", )
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
TOKEN(TK_BIN_XOR, ":", )
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
#else
TOKEN(TK_BIN_NOT, "~", )
#endif

/*-----------------------------------------------------------------------------
*	Assembly keywords
*----------------------------------------------------------------------------*/
#define SET_IX		sym.cpu_idx_reg = opts.swap_ix_iy ? IDX_REG_IY : IDX_REG_IX
#define SET_IY		sym.cpu_idx_reg = opts.swap_ix_iy ? IDX_REG_IX : IDX_REG_IY

#define FOR_Z80		if ( opts.cpu & CPU_RABBIT ) { \
						error_illegal_ident(); \
					}
						
#define FOR_RABBIT	if ( ! (opts.cpu & CPU_RABBIT) ) { \
						error_illegal_ident(); \
					}	

/* flags */
TOKEN(TK_NZ, "NZ", sym.cpu_flag = FLAG_NZ)
TOKEN(TK_Z, "Z", sym.cpu_flag = FLAG_Z)
TOKEN(TK_NC, "NC", sym.cpu_flag = FLAG_NC)
TOKEN(TK_C, "C", sym.cpu_flag = FLAG_C; sym.cpu_reg8 = REG8_C)
TOKEN(TK_PO, "PO", sym.cpu_flag = FLAG_PO)
TOKEN(TK_PE, "PE", sym.cpu_flag = FLAG_PE)
TOKEN(TK_P, "P", sym.cpu_flag = FLAG_P)
TOKEN(TK_M, "M", sym.cpu_flag = FLAG_M)

/* 8-bit registers */
TOKEN(TK_B, "B", sym.cpu_reg8 = REG8_B)

TOKEN(TK_D, "D", sym.cpu_reg8 = REG8_D)
TOKEN(TK_E, "E", sym.cpu_reg8 = REG8_E)

TOKEN(TK_H, "H", sym.cpu_reg8 = REG8_H)
TOKEN(TK_IXH, "IXH", sym.cpu_reg8 = REG8_H; SET_IX)
TOKEN(TK_IYH, "IYH", sym.cpu_reg8 = REG8_H; SET_IY)

TOKEN(TK_L, "L", sym.cpu_reg8 = REG8_L)
TOKEN(TK_IXL, "IXL", sym.cpu_reg8 = REG8_L; SET_IX)
TOKEN(TK_IYL, "IYL", sym.cpu_reg8 = REG8_L; SET_IY)

TOKEN(TK_A, "A", sym.cpu_reg8 = REG8_A)

TOKEN(TK_F, "F", )

TOKEN(TK_I, "I", )
TOKEN(TK_IIR, "IIR", )

TOKEN(TK_R, "R", )
TOKEN(TK_EIR, "EIR", )

/* indirect 8-bit register */
TOKEN_RE(TK_IND_C, "(C)", "(" hspace "C"i hspace ")", )

/* 16-bit registers */
TOKEN(TK_BC, "BC", sym.cpu_reg16_af = sym.cpu_reg16_sp = REG16_BC)
TOKEN(TK_DE, "DE", sym.cpu_reg16_af = sym.cpu_reg16_sp = REG16_DE)

TOKEN(TK_HL, "HL", sym.cpu_reg16_af = sym.cpu_reg16_sp = REG16_HL)
TOKEN(TK_IX, "IX", sym.cpu_reg16_af = sym.cpu_reg16_sp = REG16_HL; SET_IX)
TOKEN(TK_IY, "IY", sym.cpu_reg16_af = sym.cpu_reg16_sp = REG16_HL; SET_IY)

TOKEN(TK_AF, "AF", sym.cpu_reg16_af = REG16_AF)
TOKEN(TK_SP, "SP", sym.cpu_reg16_sp = REG16_SP)

TOKEN(TK_AF1, "AF'", )

/* indirect 16-bit registers */
TOKEN_RE(TK_IND_BC, "(BC)", "(" hspace "BC"i hspace ")", sym.cpu_ind_reg16 = IND_REG16_BC)
TOKEN_RE(TK_IND_DE, "(DE)", "(" hspace "DE"i hspace ")", sym.cpu_ind_reg16 = IND_REG16_DE)

TOKEN_RE(TK_IND_HL, "(HL)", "(" hspace "HL"i hspace ")", sym.cpu_ind_reg16 = IND_REG16_HL)

TOKEN_RE(TK_IND_IX, "(IX", "(" hspace "IX"i index_reg_suffix, 
		 p--; te--; sym.cpu_ind_reg16 = IND_REG16_HL; SET_IX)
TOKEN_RE(TK_IND_IY, "(IY", "(" hspace "IY"i index_reg_suffix, 
		 p--; te--; sym.cpu_ind_reg16 = IND_REG16_HL; SET_IY)

TOKEN_RE(TK_IND_SP, "(SP)", "(" hspace "SP"i hspace ")", )

/* DEFGROUP storage specifiers */
TOKEN(TK_DS_B, "DS.B", sym.ds_size = 1 )
TOKEN(TK_DS_W, "DS.W", sym.ds_size = 2 )
TOKEN(TK_DS_P, "DS.P", sym.ds_size = 3 )
TOKEN(TK_DS_L, "DS.L", sym.ds_size = 4 )

/* Z80 opcode specifiers */
TOKEN(TK_HALT, "HALT", FOR_Z80)
TOKEN(TK_IM,   "IM",   FOR_Z80)
TOKEN(TK_NOP,  "NOP", )

#undef TOKEN_RE
#undef TOKEN
#undef TOKEN2
