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

Define rules for a ragel-based parser. 

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/parse_rules.rl,v 1.14 2014-12-26 18:33:20 pauloscustodio Exp $ 
*/

#include "legacy.h"

#define NO_TOKEN_ENUM
#include "scan_tokens.h"

#define ADD_LABEL		if (compile_active && stmt_label) { \
							define_symbol(stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED); \
						}
						
#define ADD_OPCODE(x)	ADD_LABEL; \
						if (compile_active) { \
							add_opcode(x); \
						}

#define OPCODE(op)		label? _TK_##op _TK_NEWLINE \
						@{ ADD_OPCODE(Z80_##op); }

#define OPCODE_reg(op, reg) \
						label? _TK_##op _TK_##reg _TK_NEWLINE \
						@{ ADD_OPCODE(Z80_##op(REG_##reg)); }

#define ADD_OPCODE_JR(x) \
						ADD_LABEL; \
						{ 	Expr *expr = pop_expr(); \
							if (compile_active) \
								add_opcode_jr(x, expr); \
							else \
								OBJ_DELETE(expr); \
						}

#define ADD_OPCODE_nn(x) \
						ADD_LABEL; \
						{ 	Expr *expr = pop_expr(); \
							if (compile_active) \
								add_opcode_nn(x, expr); \
							else \
								OBJ_DELETE(expr); \
						}

#define ADD_OPCODE_call(flag) \
						ADD_LABEL; \
						{ 	Expr *expr = pop_expr(); \
							if (compile_active) { \
								if (opts.cpu & CPU_RABBIT) { \
									char *label = autolabel(); \
									Expr *label_expr; \
									int jump_size; \
									push_expr(label, label+strlen(label)); \
									label_expr = pop_expr(); \
									if (FLAG_##flag <= FLAG_C) { \
										add_opcode_jr( \
											Z80_JR_NOT(FLAG_##flag), \
											label_expr); \
										jump_size = 2; \
									} \
									else { \
										add_opcode_nn( \
											Z80_JP_NOT(FLAG_##flag), \
											label_expr); \
										jump_size = 3; \
									} \
									add_opcode_nn(Z80_CALL(FLAG_NONE), \
											expr); \
									define_symbol(label, \
											get_PC() + jump_size + 3, \
											TYPE_ADDRESS, SYM_TOUCHED); \
								} \
								else \
									add_opcode_nn(Z80_CALL(FLAG_##flag), \
												  expr); \
							} \
							else \
								OBJ_DELETE(expr); \
						}

#define OPCODE_const(op) label? _TK_##op const_expr _TK_NEWLINE	\
						@{ if (!expr_error) { \
								ADD_OPCODE(Z80_##op(expr_value)); \
						   } \
						}

#define OPCODE_EX(a,b,a1,b1)	\
						label? _TK_EX _TK_##a _TK_COMMA _TK_##b _TK_NEWLINE \
						@{ ADD_OPCODE(Z80_EX_##a1##_##b1); }
						
#define OPCODE_RET_FLAG(flag) \
						label? _TK_RET _TK_##flag _TK_NEWLINE \
						@{ ADD_OPCODE(Z80_RET(FLAG_##flag)); }
#define OPCODE_RET() \
						label? _TK_RET _TK_NEWLINE \
						@{ ADD_OPCODE(Z80_RET(FLAG_NONE)); }
						
#define OPCODE_JR_FLAG(flag) \
						label? _TK_JR _TK_##flag _TK_COMMA expr _TK_NEWLINE \
						@{ ADD_OPCODE_JR(Z80_JR(FLAG_##flag)); }

#define OPCODE_JR(op, code) \
						label? _TK_##op expr _TK_NEWLINE \
						@{ ADD_OPCODE_JR(code); }

#define OPCODE_JP_IND(reg, tail) \
						label? _TK_JP _TK_IND_##reg tail _TK_NEWLINE \
						@{ ADD_OPCODE(Z80_JP_IND_##reg); }

#define OPCODE_JP_FLAG(flag) \
						label? _TK_JP _TK_##flag _TK_COMMA expr _TK_NEWLINE \
						@{ ADD_OPCODE_nn(Z80_JP(FLAG_##flag)); }

#define OPCODE_JP() 	label? _TK_JP expr _TK_NEWLINE \
						@{ ADD_OPCODE_nn(Z80_JP(FLAG_NONE)); }

#define OPCODE_CALL_FLAG(flag) \
						label? _TK_CALL _TK_##flag _TK_COMMA expr _TK_NEWLINE \
						@{ ADD_OPCODE_call(flag); }

#define OPCODE_CALL() 	label? _TK_CALL expr _TK_NEWLINE \
						@{ ADD_OPCODE_nn(Z80_CALL(FLAG_NONE)); }

#define OPCODE_EMUL_RABBIT(op,func)	\
						label? _TK_##op _TK_NEWLINE \
						@{ 	ADD_LABEL; \
							if (compile_active) { \
								if (opts.cpu & CPU_RABBIT) \
									insert_macro("extern " #func "\n" \
												 "call   " #func "\n"); \
								else \
									add_opcode(Z80_##op); \
							} \
						}
								
					
%%{
	machine parser;

	/* type of token and way to retrieve */
	alphtype int;
	getkey ((int) p->tok);

	/* dynamically grow state stack */
#if 0
	prepush {
		utarray_reserve(state_stack, 1);
		stack = (int *)utarray_front(state_stack);
	}
#endif

	/* label */
	label = _TK_LABEL 		@{ stmt_label = p->string; };
	
	/* expression */
	unary 	= _TK_MINUS | _TK_PLUS |
#ifndef __LEGACY_Z80ASM_SYNTAX
			  _TK_BIN_NOT | 
#endif
			  _TK_LOG_NOT;
			  
	binary 	= 
#ifndef __LEGACY_Z80ASM_SYNTAX
			  _TK_QUESTION | _TK_COLON | 
#endif
			  _TK_LOG_OR | _TK_LOG_AND | _TK_BIN_OR | _TK_BIN_XOR |
			  _TK_BIN_AND | 
			  _TK_LESS | _TK_LESS_EQ | _TK_EQUAL | _TK_NOT_EQ |
			  _TK_GREATER | _TK_GREATER_EQ |
			  _TK_LEFT_SHIFT | _TK_RIGHT_SHIFT |
			  _TK_PLUS | _TK_MINUS |
			  _TK_MULTIPLY | _TK_DIVIDE | _TK_MOD |
			  _TK_POWER;

	term 	= ( unary | _TK_LPAREN | _TK_LSQUARE )* 
			  ( _TK_ASMPC | _TK_NAME | _TK_NUMBER )
			  ( _TK_RPAREN | _TK_RSQUARE )*;
			  
	expr1 	= _TK_CONST_EXPR ? term ( binary term )**;
	
	expr 	= expr1 
			  >{ expr_start = p; }
			  %{ push_expr(expr_start->ts, (p-1)->te); };
	
	const_expr = 
			  expr %{ pop_eval_expr(&expr_value, &expr_error); };
	
	/* assembly statement */
	main := _TK_END
		|	_TK_NEWLINE
		|	label           _TK_NEWLINE				@{ ADD_LABEL; }
		|	OPCODE(CCF)
		|	OPCODE(CPL)
		|	OPCODE(DAA)
		|	OPCODE(DI)
		|	OPCODE(EI)
		|	OPCODE(EXX)
		|	OPCODE(HALT)
		|	OPCODE(IND)
		|	OPCODE(INDR)
		|	OPCODE(INI)
		|	OPCODE(INIR)
		|	OPCODE(LDD)
		|	OPCODE(LDDR)
		|	OPCODE(LDI)
		|	OPCODE(LDIR)
		|	OPCODE(NEG)
		|	OPCODE(NOP)
		|	OPCODE(OTDR)
		|	OPCODE(OTIR)
		|	OPCODE(OUTD)
		|	OPCODE(OUTI)
		|	OPCODE(RETI)
		|	OPCODE(RETN)
		|	OPCODE(SCF)
		|	OPCODE_CALL()
		|	OPCODE_CALL_FLAG(C)
		|	OPCODE_CALL_FLAG(M)
		|	OPCODE_CALL_FLAG(NC)
		|	OPCODE_CALL_FLAG(NZ)
		|	OPCODE_CALL_FLAG(P)
		|	OPCODE_CALL_FLAG(PE)
		|	OPCODE_CALL_FLAG(PO)
		|	OPCODE_CALL_FLAG(Z)
		|	OPCODE_EMUL_RABBIT(CPD,  rcmx_cpd)
		|	OPCODE_EMUL_RABBIT(CPDR, rcmx_cpdr)
		|	OPCODE_EMUL_RABBIT(CPI,  rcmx_cpi)
		|	OPCODE_EMUL_RABBIT(CPIR, rcmx_cpir)
		|	OPCODE_EMUL_RABBIT(RLD,  rcmx_rld)
		|	OPCODE_EMUL_RABBIT(RRD,  rcmx_rrd)
		|	OPCODE_EX(AF,AF,  AF,AF)
		|	OPCODE_EX(AF,AF1, AF,AF)
		|	OPCODE_EX(DE,HL,  DE,HL)
		|	OPCODE_EX(IND_SP,HL, IND_SP,HL)
		|	OPCODE_EX(IND_SP,IX, IND_SP,IX)
		|	OPCODE_EX(IND_SP,IY, IND_SP,IY)
		|	OPCODE_JP()
		|	OPCODE_JP_FLAG(C)
		|	OPCODE_JP_FLAG(M)
		|	OPCODE_JP_FLAG(NC)
		|	OPCODE_JP_FLAG(NZ)
		|	OPCODE_JP_FLAG(P)
		|	OPCODE_JP_FLAG(PE)
		|	OPCODE_JP_FLAG(PO)
		|	OPCODE_JP_FLAG(Z)
		|	OPCODE_JP_IND(HL, )
		|	OPCODE_JP_IND(IX, _TK_RPAREN)
		|	OPCODE_JP_IND(IY, _TK_RPAREN)
		|	OPCODE_JR(DJNZ, Z80_DJNZ)
		|	OPCODE_JR(JR,   Z80_JR(FLAG_NONE))
		|	OPCODE_JR_FLAG(C)
		|	OPCODE_JR_FLAG(NC)
		|	OPCODE_JR_FLAG(NZ)
		|	OPCODE_JR_FLAG(Z)
		|	OPCODE_RET()
		|	OPCODE_RET_FLAG(C)
		|	OPCODE_RET_FLAG(M)
		|	OPCODE_RET_FLAG(NC)
		|	OPCODE_RET_FLAG(NZ)
		|	OPCODE_RET_FLAG(P)
		|	OPCODE_RET_FLAG(PE)
		|	OPCODE_RET_FLAG(PO)
		|	OPCODE_RET_FLAG(Z)
		|	OPCODE_const(IM)
		|	OPCODE_const(RST)
		|	OPCODE_reg(PUSH, BC)
		|	OPCODE_reg(PUSH, DE)
		|	OPCODE_reg(PUSH, HL)
		|	OPCODE_reg(PUSH, IX)
		|	OPCODE_reg(PUSH, IY)
		|	OPCODE_reg(PUSH, AF)
		|	OPCODE_reg(POP,  BC)
		|	OPCODE_reg(POP,  DE)
		|	OPCODE_reg(POP,  HL)
		|	OPCODE_reg(POP,  IX)
		|	OPCODE_reg(POP,  IY)
		|	OPCODE_reg(POP,  AF)
		;

}%%

%%write data;

static Bool _parse_statement(Bool compile_active)
{
	p = pe = eof = NULL;
	
	%%write init;
	
	while (eof == NULL || eof != pe)
	{
		read_token();
		
		%%write exec;
	
		/* Did parsing succeed? */
		if ( cs == %%{ write error; }%% )
			return FALSE;
			
		if ( cs >= %%{ write first_final; }%% )
			return TRUE;
	}
	
	return FALSE;
}
