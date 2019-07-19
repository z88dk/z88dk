/*
Z88DK Z80 Module Assembler

Copyright (C) Paulo Custodio, 2011-2019
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

Define lexer tokens
*/

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

#ifndef TOKEN_OPCODE1
#define TOKEN_OPCODE1(opcode, string)
#endif

TOKEN(	TK_END,			"",)	/* = 0; end of file reached */
TOKEN(	TK_NIL,			"", )	/* returned for rubish */
TOKEN(	TK_NAME,		"", )
TOKEN(	TK_LABEL,		"", )
TOKEN(	TK_NUMBER,		"", )
TOKEN(	TK_STRING,		"", )
TOKEN(	TK_TERN_COND,	"", )	/* cond ? true : false */
TOKEN(	TK_ASMPC,		"ASMPC", )
TOKEN2(	TK_ASMPC,		"$", )

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

TOKEN(TK_BIN_AND, "&", )

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

TOKEN(TK_COLON, ":", )

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

TOKEN(TK_QUESTION, "?", )

/* no token for "@", "A" .. "Z" */

TOKEN(TK_LSQUARE, "[", )

/* no token for "\\" */

TOKEN(TK_RSQUARE, "]", )

TOKEN(TK_BIN_XOR, "^", )
TOKEN(TK_POWER, "**", )

/* no token for "_", "`", "a" .. "z" */

TOKEN(TK_LCURLY, "{", )
TOKEN(TK_BIN_OR, "|", )
TOKEN(TK_LOG_OR, "||", )
TOKEN(TK_RCURLY, "}", )

TOKEN(TK_BIN_NOT, "~", )

/*-----------------------------------------------------------------------------
*	Assembly keywords
*----------------------------------------------------------------------------*/

/* flags */
TOKEN_KW(NZ, )
TOKEN_KW(Z,  )
TOKEN_KW(NC, )
TOKEN_KW(C,  )
TOKEN_KW(PO, )
TOKEN_KW(PE, )
TOKEN_KW(P,  )
TOKEN_KW(M,  )
TOKEN_RABBIT(LZ)		// issue #577
TOKEN_RABBIT(LO)		// issue #577
TOKEN_KW(NV, )
TOKEN_KW(V, )

/* 8-bit registers */
TOKEN_KW(B, )

TOKEN_KW(D, )
TOKEN_KW(E, )

TOKEN_KW(H, )
TOKEN_KW(IXH, )
TOKEN_KW(IYH, )

TOKEN_KW(L, )
TOKEN_KW(IXL, )
TOKEN_KW(IYL, )

TOKEN_KW(A, )

TOKEN_KW(F, )

TOKEN_KW(I,   )
TOKEN_KW(IIR, )

TOKEN_KW(R,   )
TOKEN_KW(EIR, )

TOKEN_ZXN(X)

/* 16-bit registers */
TOKEN_KW(BC, )
TOKEN_KW(DE, )

TOKEN_KW(HL, )
TOKEN_KW(IX, )
TOKEN_KW(IY, )

TOKEN_KW(AF, )
TOKEN_KW(SP, )
TOKEN_KW(IP, )
TOKEN_KW(SU, )
TOKEN_KW(XPC, )

TOKEN(TK_B1, "B'", )
TOKEN(TK_C1, "C'", )
TOKEN(TK_D1, "D'", )
TOKEN(TK_E1, "E'", )
TOKEN(TK_H1, "H'", )
TOKEN(TK_L1, "L'", )
TOKEN(TK_A1, "A'", )
TOKEN(TK_F1, "F'", )

TOKEN(TK_BC1, "BC'", )
TOKEN(TK_DE1, "DE'", )
TOKEN(TK_HL1, "HL'", )
TOKEN(TK_AF1, "AF'", )

/* indirect 8- and 16-bit registers */
/* TK_IND_IX|IY|HL is followed by ')', '+' or '-', but follow char is not matched - 
*  can collect expression, will be positive or negative depending on symbol */
TOKEN_RE(TK_IND_BC, "(BC", "(" hspace "BC"i index_reg_suffix, p--; te--)
TOKEN_RE(TK_IND_DE, "(DE", "(" hspace "DE"i index_reg_suffix, p--; te--)
TOKEN_RE(TK_IND_IX, "(IX", "(" hspace "IX"i index_reg_suffix, p--; te--)
TOKEN_RE(TK_IND_IY, "(IY", "(" hspace "IY"i index_reg_suffix, p--; te--)
TOKEN_RE(TK_IND_HL, "(HL", "(" hspace "HL"i index_reg_suffix, p--; te--)
TOKEN_RE(TK_IND_SP, "(SP", "(" hspace "SP"i index_reg_suffix, p--; te--)

TOKEN_RE(TK_IND_C,  "(C",  "(" hspace "C"i  index_reg_suffix, p--; te--)

/* 32-bit registers */
TOKEN_KW(A32, )
TOKEN_KW(DEHL, )

/* assembly directives */
TOKEN_OPCODE(ALIGN		)
TOKEN_OPCODE(BINARY		)
TOKEN_OPCODE(C_LINE		)
TOKEN_OPCODE(DEFB		)
TOKEN_OPCODE(DEFC		)
TOKEN_OPCODE(DEFDB		)
TOKEN_OPCODE(DEFGROUP	)
TOKEN_OPCODE(DEFINE		)
TOKEN_OPCODE(DEFM		)
TOKEN_OPCODE(DEFQ		)
TOKEN_OPCODE(DEFS		)
TOKEN_OPCODE(DEFVARS	)
TOKEN_OPCODE(DEFW		)
TOKEN_OPCODE(DEPHASE	)
TOKEN_OPCODE(ELSE		)
TOKEN_OPCODE(ELIF		)
TOKEN_OPCODE(ELIFDEF	)
TOKEN_OPCODE(ELIFNDEF	)
TOKEN_OPCODE(ENDIF		)
TOKEN_OPCODE(EXTERN		)
TOKEN_OPCODE(GLOBAL     )
TOKEN_OPCODE(IF         )
TOKEN_OPCODE(IFDEF		)
TOKEN_OPCODE(IFNDEF		)
TOKEN_OPCODE(INCLUDE	)
TOKEN_OPCODE(LIB		)
TOKEN_OPCODE(LINE		)
TOKEN_OPCODE(LSTOFF		)
TOKEN_OPCODE(LSTON		)
TOKEN_OPCODE(MODULE		)
TOKEN_OPCODE(ORG		)
TOKEN_OPCODE(PHASE		)
TOKEN_OPCODE(PUBLIC		)
TOKEN_OPCODE(SECTION	)
TOKEN_OPCODE(UNDEFINE	)
TOKEN_OPCODE(XDEF		)
TOKEN_OPCODE(XLIB		)
TOKEN_OPCODE(XREF		)

/* DEFGROUP storage specifiers */
TOKEN(TK_DS_B, "DS.B", )
TOKEN(TK_DS_W, "DS.W", )
TOKEN(TK_DS_P, "DS.P", )
TOKEN(TK_DS_Q, "DS.Q", )

/* Z80 opcode specifiers */
TOKEN_OPCODE(ADC  )
TOKEN_OPCODE(ADD  )
TOKEN_OPCODE(AND  )
TOKEN_OPCODE(BIT  )
TOKEN_OPCODE(CALL )
TOKEN_OPCODE(CCF  )
TOKEN_OPCODE1(CCF1, "ccf'")
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
TOKEN_OPCODE1(RLA1, "rla'")
TOKEN_OPCODE(RLC  )
TOKEN_OPCODE(RLCA )
TOKEN_OPCODE1(RLCA1, "rlca'")
TOKEN_OPCODE(RLD  )
TOKEN_OPCODE(RR   )
TOKEN_OPCODE(RRA  )
TOKEN_OPCODE1(RRA1, "rra'")
TOKEN_OPCODE(RRC  )
TOKEN_OPCODE(RRCA )
TOKEN_OPCODE1(RRCA1, "rrca'")
TOKEN_OPCODE(RRD  )
TOKEN_OPCODE(RST  )
TOKEN_OPCODE(SBC  )
TOKEN_OPCODE(SCF  )
TOKEN_OPCODE1(SCF1, "scf'")
TOKEN_OPCODE(SET  )
TOKEN_OPCODE(SLA  )
TOKEN_OPCODE(SLL  )
TOKEN_OPCODE(SLI  )
TOKEN_OPCODE(SRA  )
TOKEN_OPCODE(SRL  )
TOKEN_OPCODE(SUB  )
TOKEN_OPCODE(XOR  )

/* Z80-ZXN specific opcodes */
TOKEN_OPCODE(SWAPNIB)
TOKEN_OPCODE(SWAP)
TOKEN_OPCODE(OUTINB)
TOKEN_OPCODE(LDIX)
TOKEN_OPCODE(LDIRX)
TOKEN_OPCODE(LDDX)
TOKEN_OPCODE(LDDRX)
TOKEN_OPCODE(LDIRSCALE)
TOKEN_OPCODE(LDPIRX)
TOKEN_OPCODE(LDWS)
TOKEN_OPCODE(FILL)
TOKEN_OPCODE(FILLDE)
TOKEN_OPCODE(MIRROR)
TOKEN_OPCODE(NEXTREG)
TOKEN_OPCODE(PIXELDN)
TOKEN_OPCODE(PIXELAD)
TOKEN_OPCODE(SETAE)
TOKEN_OPCODE(TEST)
TOKEN_OPCODE(MMU)
TOKEN_OPCODE(MMU0)
TOKEN_OPCODE(MMU1)
TOKEN_OPCODE(MMU2)
TOKEN_OPCODE(MMU3)
TOKEN_OPCODE(MMU4)
TOKEN_OPCODE(MMU5)
TOKEN_OPCODE(MMU6)
TOKEN_OPCODE(MMU7)
TOKEN_OPCODE1(CU_WAIT, "cu.wait")
TOKEN_OPCODE1(CU_MOVE, "cu.move")
TOKEN_OPCODE1(CU_STOP, "cu.stop")
TOKEN_OPCODE1(CU_NOP,  "cu.nop")
TOKEN_OPCODE1(DMA_WR0, "dma.wr0")
TOKEN_OPCODE1(DMA_WR1, "dma.wr1")
TOKEN_OPCODE1(DMA_WR2, "dma.wr2")
TOKEN_OPCODE1(DMA_WR3, "dma.wr3")
TOKEN_OPCODE1(DMA_WR4, "dma.wr4")
TOKEN_OPCODE1(DMA_WR5, "dma.wr5")
TOKEN_OPCODE1(DMA_WR6, "dma.wr6")
TOKEN_OPCODE1(DMA_CMD, "dma.cmd")
TOKEN_OPCODE(BSLA)
TOKEN_OPCODE(BSRA)
TOKEN_OPCODE(BSRL)
TOKEN_OPCODE(BSRF)
TOKEN_OPCODE(BRLC)

/* Z180 opcodes */
TOKEN_OPCODE(IN0)
TOKEN_OPCODE(MLT)
TOKEN_OPCODE(OTDM)
TOKEN_OPCODE(OTDMR)
TOKEN_OPCODE(OTIM)
TOKEN_OPCODE(OTIMR)
TOKEN_OPCODE(OUT0)
TOKEN_OPCODE(SLP)
TOKEN_OPCODE(TST)
TOKEN_OPCODE(TSTIO)

/* Rabbit opcodes */
TOKEN_OPCODE(ALTD)
TOKEN_OPCODE(BOOL)
TOKEN_OPCODE(IDET)
TOKEN_OPCODE(IOE)
TOKEN_OPCODE(IOI)
TOKEN_OPCODE(IPRES)
TOKEN_OPCODE(IPSET)
TOKEN_OPCODE(LDDSR)
TOKEN_OPCODE(LDISR)
TOKEN_OPCODE(LDP)
TOKEN_OPCODE(LSDR)
TOKEN_OPCODE(LSIR)
TOKEN_OPCODE(LSDDR)
TOKEN_OPCODE(LSIDR)
TOKEN_OPCODE(MUL)
TOKEN_OPCODE(RDMODE)
TOKEN_OPCODE(SETUSR)
TOKEN_OPCODE(SURES)
TOKEN_OPCODE(SYSCALL)
TOKEN_OPCODE(UMA)
TOKEN_OPCODE(UMS)

/* Z88DK specific opcodes */
TOKEN_OPCODE(CALL_OZ)
TOKEN_OPCODE(CALL_PKG)
TOKEN_OPCODE(FPP	)
TOKEN_OPCODE(INVOKE	)

#undef TOKEN_OPCODE
#undef TOKEN_KW
#undef TOKEN_RE
#undef TOKEN
#undef TOKEN2
