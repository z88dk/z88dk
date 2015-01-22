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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/scan_def.h,v 1.45 2015-01-22 23:24:28 pauloscustodio Exp $
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

#define TOKEN_KW(name, set_value)	TOKEN(TK_##name, #name, set_value)

#ifndef TOKEN_OPCODE
#define TOKEN_OPCODE(opcode)
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
#define FOR_Z80		if ( opts.cpu & CPU_RABBIT ) { \
						error_illegal_ident(); \
					}
						
#define FOR_RABBIT	if ( ! (opts.cpu & CPU_RABBIT) ) { \
						error_illegal_ident(); \
					}	

/* flags */
TOKEN_KW(NZ, )
TOKEN_KW(Z,  )
TOKEN_KW(NC, )
TOKEN_KW(C,  )
TOKEN_KW(PO, )
TOKEN_KW(PE, )
TOKEN_KW(P,  )
TOKEN_KW(M,  )

/* 8-bit registers */
TOKEN_KW(B, )

TOKEN_KW(D, )
TOKEN_KW(E, )

TOKEN_KW(H, )
TOKEN_KW(IXH, FOR_Z80)
TOKEN_KW(IYH, FOR_Z80)

TOKEN_KW(L, )
TOKEN_KW(IXL, FOR_Z80)
TOKEN_KW(IYL, FOR_Z80)

TOKEN_KW(A, )

TOKEN_KW(F, )

TOKEN_KW(I,   FOR_Z80)
TOKEN_KW(IIR, FOR_RABBIT)

TOKEN_KW(R,   FOR_Z80)
TOKEN_KW(EIR, FOR_RABBIT)

/* indirect 8-bit register */
TOKEN_RE(TK_IND_C, "(C)", "(" hspace "C"i hspace ")", )

/* 16-bit registers */
TOKEN_KW(BC, )
TOKEN_KW(DE, )

TOKEN_KW(HL, )
TOKEN_KW(IX, )
TOKEN_KW(IY, )

TOKEN_KW(AF, )
TOKEN_KW(SP, )

TOKEN(TK_AF1, "AF'", )

/* indirect 16-bit registers */
TOKEN_RE(TK_IND_BC, "(BC)", "(" hspace "BC"i hspace ")", )
TOKEN_RE(TK_IND_DE, "(DE)", "(" hspace "DE"i hspace ")", )

TOKEN_RE(TK_IND_HL, "(HL)", "(" hspace "HL"i hspace ")", )

/* TK_IND_IX|IY is followed by ')', '+' or '-', but follow char is not matched - 
*  can collect expression, will be positive or negative depending on symbol */
TOKEN_RE(TK_IND_IX, "(IX", "(" hspace "IX"i index_reg_suffix, p--; te--)
TOKEN_RE(TK_IND_IY, "(IY", "(" hspace "IY"i index_reg_suffix, p--; te--)

TOKEN_RE(TK_IND_SP, "(SP)", "(" hspace "SP"i hspace ")", )

/* assembly directives */
TOKEN_OPCODE(BINARY		)
TOKEN_OPCODE(DEFGROUP	)
TOKEN_OPCODE(DEFS		)
TOKEN_OPCODE(DEFVARS	)
TOKEN_OPCODE(EXTERN		)
TOKEN_OPCODE(INCLUDE	)
TOKEN_OPCODE(LIB		)
TOKEN_OPCODE(LINE		)
TOKEN_OPCODE(LSTOFF		)
TOKEN_OPCODE(LSTON		)
TOKEN_OPCODE(MODULE		)
TOKEN_OPCODE(ORG		)
TOKEN_OPCODE(PUBLIC		)
TOKEN_OPCODE(SECTION	)
TOKEN_OPCODE(XDEF		)
TOKEN_OPCODE(XLIB		)
TOKEN_OPCODE(XREF		)

/* DEFGROUP storage specifiers */
TOKEN(TK_DS_B, "DS.B", )
TOKEN(TK_DS_W, "DS.W", )
TOKEN(TK_DS_P, "DS.P", )
TOKEN(TK_DS_L, "DS.L", )

/* Z80 opcode specifiers */
TOKEN_OPCODE(ADC  )
TOKEN_OPCODE(ADD  )
TOKEN_OPCODE(AND  )
TOKEN_OPCODE(BIT  )
TOKEN_OPCODE(CALL )
TOKEN_OPCODE(CCF  )
TOKEN_OPCODE(CP   )
TOKEN_OPCODE(CPD  )
TOKEN_OPCODE(CPDR )
TOKEN_OPCODE(CPI  )
TOKEN_OPCODE(CPIR )
TOKEN_OPCODE(CPL  )
TOKEN_OPCODE(DAA  )
TOKEN_OPCODE(DEC  )
TOKEN_OPCODE(DI   )
TOKEN_OPCODE(DJNZ )
TOKEN_OPCODE(EI   )
TOKEN_OPCODE(EX   )
TOKEN_OPCODE(EXX  )
TOKEN_OPCODE(HALT )
TOKEN_OPCODE(IM   )
TOKEN_OPCODE(IN   )
TOKEN_OPCODE(INC  )
TOKEN_OPCODE(IND  )
TOKEN_OPCODE(INDR )
TOKEN_OPCODE(INI  )
TOKEN_OPCODE(INIR )
TOKEN_OPCODE(JP   )
TOKEN_OPCODE(JR   )
TOKEN_OPCODE(LD   )
TOKEN_OPCODE(LDD  )
TOKEN_OPCODE(LDDR )
TOKEN_OPCODE(LDI  )
TOKEN_OPCODE(LDIR )
TOKEN_OPCODE(NEG  )
TOKEN_OPCODE(NOP  )
TOKEN_OPCODE(OR   )
TOKEN_OPCODE(OTDR )
TOKEN_OPCODE(OTIR )
TOKEN_OPCODE(OUT  )
TOKEN_OPCODE(OUTD )
TOKEN_OPCODE(OUTI )
TOKEN_OPCODE(POP  )
TOKEN_OPCODE(PUSH )
TOKEN_OPCODE(RES  )
TOKEN_OPCODE(RET  )
TOKEN_OPCODE(RETI )
TOKEN_OPCODE(RETN )
TOKEN_OPCODE(RL   )
TOKEN_OPCODE(RLA  )
TOKEN_OPCODE(RLC  )
TOKEN_OPCODE(RLCA )
TOKEN_OPCODE(RLD  )
TOKEN_OPCODE(RR   )
TOKEN_OPCODE(RRA  )
TOKEN_OPCODE(RRC  )
TOKEN_OPCODE(RRCA )
TOKEN_OPCODE(RRD  )
TOKEN_OPCODE(RST  )
TOKEN_OPCODE(SBC  )
TOKEN_OPCODE(SCF  )
TOKEN_OPCODE(SET  )
TOKEN_OPCODE(SLA  )
TOKEN_OPCODE(SLL  )
TOKEN_OPCODE(SRA  )
TOKEN_OPCODE(SRL  )
TOKEN_OPCODE(SUB  )
TOKEN_OPCODE(XOR  )

/* Z88DK specific opcodes */
TOKEN_OPCODE(CALL_OZ)
TOKEN_OPCODE(OZ		)
TOKEN_OPCODE(CALL_PKG)
TOKEN_OPCODE(FPP	)
TOKEN_OPCODE(INVOKE	)

#undef TOKEN_OPCODE
#undef TOKEN_KW
#undef TOKEN_RE
#undef TOKEN
#undef TOKEN2
