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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/parse_rules.rl,v 1.20 2014-12-29 18:33:30 pauloscustodio Exp $ 
*/

#include "legacy.h"

#define NO_TOKEN_ENUM
#include "scan_tokens.h"

/*-----------------------------------------------------------------------------
*   Helper macros
*----------------------------------------------------------------------------*/

/* macros for actions - labels */
#define DO_LABEL(name, offset) \
			if (compile_active) { \
				define_symbol((name), get_PC() + (offset), \
							  TYPE_ADDRESS, SYM_TOUCHED); \
			}

#define DO_STMT_LABEL() \
			if (stmt_label) { \
				DO_LABEL(stmt_label, 0); \
				stmt_label = NULL; \
			}

/* macros for actions - statements */
#define DO_stmt(opcode) \
			if (compile_active) { \
				DO_STMT_LABEL(); \
				add_opcode(opcode); \
			}

#define _DO_stmt_(suffix, opcode) \
			{ 	Expr *expr = pop_expr(); \
				if (compile_active) { \
					DO_STMT_LABEL(); \
					add_opcode_##suffix((opcode), expr); \
				} \
				else \
					OBJ_DELETE(expr); \
			}

#define DO_stmt_jr( opcode)		_DO_stmt_(jr,  opcode)
#define DO_stmt_n(  opcode)		_DO_stmt_(n,   opcode)
#define DO_stmt_nn( opcode)		_DO_stmt_(nn,  opcode)
#define DO_stmt_idx(opcode)		_DO_stmt_(idx, opcode)


/* macros for rules */
#define RULE_stmt(token, args, value) \
			label? _TK_##token args _TK_NEWLINE \
			@{ DO_stmt(value); }

#define OP_stmt(op) \
			RULE_stmt(op, , Z80_##op)

#define OP_stmt_reg(op, reg1) \
			RULE_stmt(op, _TK_##reg1, Z80_##op(REG_##reg1))

#define OP_stmt_idx(op, idx1) \
			RULE_stmt(op, _TK_##idx1, Z80_##op(REG_HL) + P_##idx1)

#define OP_stmt_arg(op, arg1, value) \
			RULE_stmt(op, _TK_##arg1, (value))

#define OP_stmt_arg_arg(op, arg1, arg2, value) \
			RULE_stmt(op, _TK_##arg1 _TK_COMMA _TK_##arg2, (value))

#define OP_stmt_const(op) \
			label? _TK_##op const_expr _TK_NEWLINE	\
			@{ \
				if (!expr_error) { \
					DO_stmt(Z80_##op(expr_value)); \
				} \
			}

			
#define RULE_stmt_nn(token, value) \
			label? _TK_##token expr _TK_NEWLINE \
			@{ DO_stmt_nn(value); }

#define OP_stmt_nn(op) \
			RULE_stmt_nn(op, Z80_##op)

			
#define RULE_stmt_jr(token, value) \
			label? _TK_##token expr _TK_NEWLINE \
			@{ DO_stmt_jr(value); }

#define OP_stmt_jr(op) \
			RULE_stmt_jr(op, Z80_##op)

			
#define RULE_stmt_flag_nn(token, flag, value) \
			label? _TK_##token _TK_##flag _TK_COMMA expr _TK_NEWLINE \
			@{ DO_stmt_nn(value); }

#define OP_stmt_flag_nn(op, flag) \
			RULE_stmt_flag_nn(op, flag, Z80_##op##_FLAG(FLAG_##flag))


#define RULE_stmt_flag_jr(token, flag, value) \
			label? _TK_##token _TK_##flag _TK_COMMA expr _TK_NEWLINE \
			@{ DO_stmt_jr(value); }

#define OP_stmt_flag_jr(op, flag) \
			RULE_stmt_flag_jr(op, flag, Z80_##op##_FLAG(FLAG_##flag))


#define RULE_stmt_flag(token, flag, value) \
			label? _TK_##token _TK_##flag _TK_NEWLINE \
			@{ DO_stmt(value); }

#define OP_stmt_flag(op, flag) \
			RULE_stmt_flag(op, flag, Z80_##op##_FLAG(FLAG_##flag))

/*-----------------------------------------------------------------------------
*   ALU operations
*----------------------------------------------------------------------------*/
#define _ALU_TOKENS(alu) \
			label? _TK_##alu (_TK_A _TK_COMMA)? 

#define _OP_alu_idx(alu, idx) \
			_ALU_TOKENS(alu) _TK_IND_##idx \
					_TK_RPAREN _TK_NEWLINE					/* (ix) */ \
			@{ DO_stmt((Z80_##alu(REG_idx) + P_##idx) << 8); } \
		|	_ALU_TOKENS(alu) _TK_IND_##idx \
					_TK_PLUS expr _TK_RPAREN _TK_NEWLINE	/* (ix+d) */ \
			@{ DO_stmt_idx(Z80_##alu(REG_idx) + P_##idx); } \
		|	_ALU_TOKENS(alu) _TK_IND_##idx \
					_TK_MINUS neg_expr _TK_RPAREN _TK_NEWLINE	/* (ix-d) */ \
			@{ DO_stmt_idx(Z80_##alu(REG_idx) + P_##idx); }			

#define _OP_alu_reg(alu, reg) \
			_ALU_TOKENS(alu) _TK_##reg _TK_NEWLINE			/* reg */ \
			@{ DO_stmt(Z80_##alu(REG_##reg)); }

#define _OP_alu_idx8(alu, idx) \
			_ALU_TOKENS(alu) _TK_##idx##H _TK_NEWLINE		/* ixh */ \
			@{ DO_stmt(Z80_##alu(REG_H) + P_##idx); } \
		|	_ALU_TOKENS(alu) _TK_##idx##L _TK_NEWLINE		/* ixl */ \
			@{ DO_stmt(Z80_##alu(REG_L) + P_##idx); } \

#define _OP_alu(alu) \
			_ALU_TOKENS(alu) _TK_IND_HL _TK_NEWLINE 		/* (hl) */ \
			@{ DO_stmt(Z80_##alu(REG_idx)); } \
		|	_OP_alu_idx(alu, IX) \
		|	_OP_alu_idx(alu, IY) \
		|	_OP_alu_reg(alu, B) \
		|	_OP_alu_reg(alu, C) \
		|	_OP_alu_reg(alu, D) \
		|	_OP_alu_reg(alu, E) \
		|	_OP_alu_reg(alu, H) \
		|	_OP_alu_reg(alu, L) \
		|	_OP_alu_reg(alu, A) \
		|	_OP_alu_idx8(alu, IX) \
		|	_OP_alu_idx8(alu, IY) \
		|	_ALU_TOKENS(alu) expr _TK_NEWLINE 				/* n */ \
			@{ DO_stmt_n(Z80_##alu##_n); }

#define OP_alu() \
			_OP_alu(ADC) \
		|	_OP_alu(ADD) \
		|	_OP_alu(AND) \
		|	_OP_alu(CP)  \
		|	_OP_alu(OR)  \
		|	_OP_alu(SBC) \
		|	_OP_alu(SUB) \
		|	_OP_alu(XOR)

/*-----------------------------------------------------------------------------
*   ALU-16 operations
*----------------------------------------------------------------------------*/
#define _OP_alu16_reg(alu, idx, reg, prefix) \
			label? _TK_##alu _TK_##idx _TK_COMMA _TK_##reg _TK_NEWLINE \
			@{ DO_stmt(Z80_##alu##16(REG_##reg) + prefix); }

#define _OP_alu16(alu, idx, prefix) \
			_OP_alu16_reg(alu, idx, BC,  prefix) \
		|	_OP_alu16_reg(alu, idx, DE,  prefix) \
		|	_OP_alu16_reg(alu, idx, idx, prefix) \
		|	_OP_alu16_reg(alu, idx, SP,  prefix)
		
#define OP_alu16() \
			_OP_alu16(ADD, HL, 0) \
		|	_OP_alu16(ADD, IX, P_IX) \
		|	_OP_alu16(ADD, IY, P_IY) \
		|	_OP_alu16(ADC, HL, 0) \
		|	_OP_alu16(SBC, HL, 0)

/*-----------------------------------------------------------------------------
*   CALL opcodes
*----------------------------------------------------------------------------*/
#define _OP_call_flag_nn(flag) \
			label? _TK_CALL _TK_##flag _TK_COMMA expr _TK_NEWLINE \
			@{ \
			 	Expr *expr = pop_expr(); \
				if (compile_active) { \
					DO_STMT_LABEL(); \
					add_call_flag(FLAG_##flag, expr); \
				} \
				else \
					OBJ_DELETE(expr); \
			}

#define OP_call() \
			_OP_call_flag_nn(C)  \
		|	_OP_call_flag_nn(M)  \
		|	_OP_call_flag_nn(NC) \
		|	_OP_call_flag_nn(NZ) \
		|	_OP_call_flag_nn(P)  \
		|	_OP_call_flag_nn(PE) \
		|	_OP_call_flag_nn(PO) \
		|	_OP_call_flag_nn(Z)  \
		|	OP_stmt_nn(CALL)
		
/*-----------------------------------------------------------------------------
*   JP, JR, DJNZ opcodes
*----------------------------------------------------------------------------*/
#define OP_jump() \
			OP_stmt_arg(JP, IND_HL, 			Z80_JP_idx)			\
		|	OP_stmt_arg(JP, IND_IX _TK_RPAREN, 	Z80_JP_idx + P_IX)	\
		|	OP_stmt_arg(JP, IND_IY _TK_RPAREN, 	Z80_JP_idx + P_IY)	\
		|	OP_stmt_flag_jr(JR, C)	\
		|	OP_stmt_flag_jr(JR, NC)	\
		|	OP_stmt_flag_jr(JR, NZ)	\
		|	OP_stmt_flag_jr(JR, Z)	\
		|	OP_stmt_flag_nn(JP, C)	\
		|	OP_stmt_flag_nn(JP, M)	\
		|	OP_stmt_flag_nn(JP, NC)	\
		|	OP_stmt_flag_nn(JP, NZ)	\
		|	OP_stmt_flag_nn(JP, P)	\
		|	OP_stmt_flag_nn(JP, PE)	\
		|	OP_stmt_flag_nn(JP, PO)	\
		|	OP_stmt_flag_nn(JP, Z)	\
		|	OP_stmt_jr(DJNZ)		\
		|	OP_stmt_jr(JR)			\
		|	OP_stmt_nn(JP)

/*-----------------------------------------------------------------------------
*   RETx opcodes
*----------------------------------------------------------------------------*/
#define OP_ret() \
			OP_stmt(RET)			\
		|	OP_stmt(RETI)			\
		|	OP_stmt(RETN)			\
		|	OP_stmt_flag(RET, C)	\
		|	OP_stmt_flag(RET, M)	\
		|	OP_stmt_flag(RET, NC)	\
		|	OP_stmt_flag(RET, NZ)	\
		|	OP_stmt_flag(RET, P)	\
		|	OP_stmt_flag(RET, PE)	\
		|	OP_stmt_flag(RET, PO)	\
		|	OP_stmt_flag(RET, Z)

/*-----------------------------------------------------------------------------
*   Emulated opcodes
*----------------------------------------------------------------------------*/
#define _OP_stmt_emul(op, emul_func) \
			label? _TK_##op _TK_NEWLINE \
			@{ \
				if (compile_active) { \
					DO_STMT_LABEL(); \
					add_opcode_emul(Z80_##op, #emul_func); \
				} \
			}

#define OP_emulated() \
			_OP_stmt_emul(CPD,  rcmx_cpd)	\
		|	_OP_stmt_emul(CPDR, rcmx_cpdr)	\
		|	_OP_stmt_emul(CPI,  rcmx_cpi)	\
		|	_OP_stmt_emul(CPIR, rcmx_cpir)	\
		|	_OP_stmt_emul(RLD,  rcmx_rld)	\
		|	_OP_stmt_emul(RRD,  rcmx_rrd)

/*-----------------------------------------------------------------------------
*   PUSH / POP
*----------------------------------------------------------------------------*/
#define OP_push_pop() \
			OP_stmt_idx(POP,  IX)	\
		|	OP_stmt_idx(POP,  IY)	\
		|	OP_stmt_idx(PUSH, IX)	\
		|	OP_stmt_idx(PUSH, IY)	\
		|	OP_stmt_reg(POP,  AF)	\
		|	OP_stmt_reg(POP,  BC)	\
		|	OP_stmt_reg(POP,  DE)	\
		|	OP_stmt_reg(POP,  HL)	\
		|	OP_stmt_reg(PUSH, AF)	\
		|	OP_stmt_reg(PUSH, BC)	\
		|	OP_stmt_reg(PUSH, DE)	\
		|	OP_stmt_reg(PUSH, HL)

/*-----------------------------------------------------------------------------
*   EX, EXX
*----------------------------------------------------------------------------*/
#define OP_ex() \
			OP_stmt(EXX)	\
		|	OP_stmt_arg_arg(EX, AF, AF,		Z80_EX_AF_AF)	\
		|	OP_stmt_arg_arg(EX, AF, AF1, 	Z80_EX_AF_AF)	\
		|	OP_stmt_arg_arg(EX, DE, HL,  	Z80_EX_DE_HL)	\
		|	OP_stmt_arg_arg(EX, IND_SP, HL, Z80_EX_IND_SP_HL)	\
		|	OP_stmt_arg_arg(EX, IND_SP, IX, Z80_EX_IND_SP_idx + P_IX)	\
		|	OP_stmt_arg_arg(EX, IND_SP, IY, Z80_EX_IND_SP_idx + P_IY)

/*-----------------------------------------------------------------------------
*   IN, OUT
*----------------------------------------------------------------------------*/
#define _OP_in_reg(reg) \
			label? _TK_IN _TK_##reg _TK_COMMA _TK_IND_C _TK_NEWLINE \
			@{ DO_stmt(Z80_IN_REG_C(REG_##reg)); }

#define _OP_in_A \
			label? _TK_IN _TK_A _TK_COMMA \
					_TK_LPAREN expr _TK_RPAREN _TK_NEWLINE \
			@{ DO_stmt_n(Z80_IN_A_n); }

#define _OP_out_reg(reg) \
			label? _TK_OUT _TK_IND_C _TK_COMMA _TK_##reg _TK_NEWLINE \
			@{ DO_stmt(Z80_OUT_C_REG(REG_##reg)); }

#define _OP_out_A \
			label? _TK_OUT _TK_LPAREN expr _TK_RPAREN \
					_TK_COMMA _TK_A _TK_NEWLINE \
			@{ DO_stmt_n(Z80_OUT_n_A); }

#define OP_in_out() \
			_OP_in_reg(B) 	\
		|	_OP_in_reg(C) 	\
		|	_OP_in_reg(D) 	\
		|	_OP_in_reg(E) 	\
		|	_OP_in_reg(H) 	\
		|	_OP_in_reg(L) 	\
		|	_OP_in_reg(A) 	\
		|	_OP_in_A		\
		|	OP_stmt(OTDR)	\
		|	OP_stmt(OTIR)	\
		|	OP_stmt(OUTD)	\
		|	OP_stmt(OUTI)	\
		|	_OP_out_reg(B)	\
		|	_OP_out_reg(C)	\
		|	_OP_out_reg(D)	\
		|	_OP_out_reg(E)	\
		|	_OP_out_reg(H)	\
		|	_OP_out_reg(L)	\
		|	_OP_out_reg(A)	
#if 0
		|	_OP_out_A			/* Ragel cannot parse (expr) */
#endif

/*-----------------------------------------------------------------------------
*   State Machine
*----------------------------------------------------------------------------*/

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
	label = _TK_LABEL @{ stmt_label = p->string; };
	
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
	
	neg_expr = expr1 
			  >{ expr_start = p; }
			  %{ push_neg_expr(expr_start->ts, (p-1)->te); };
	
	const_expr = 
			  expr %{ pop_eval_expr(&expr_value, &expr_error); };
	
	/* assembly statement */
	main := _TK_END
		|	_TK_NEWLINE
		|	label _TK_NEWLINE @{ DO_STMT_LABEL(); }
		|	OP_alu()
		|	OP_alu16()
		|	OP_call()
		|	OP_emulated()
		|	OP_ex()
		|	OP_in_out()
		|	OP_jump()
		|	OP_push_pop()
		|	OP_ret()
		|	OP_stmt(CCF)
		|	OP_stmt(CPL)
		|	OP_stmt(DAA)
		|	OP_stmt(DI)
		|	OP_stmt(EI)
		|	OP_stmt(HALT)
		|	OP_stmt(IND)
		|	OP_stmt(INDR)
		|	OP_stmt(INI)
		|	OP_stmt(INIR)
		|	OP_stmt(LDD)
		|	OP_stmt(LDDR)
		|	OP_stmt(LDI)
		|	OP_stmt(LDIR)
		|	OP_stmt(NEG)
		|	OP_stmt(NOP)
		|	OP_stmt(RLA)
		|	OP_stmt(RLCA)
		|	OP_stmt(RRA)
		|	OP_stmt(RRCA)
		|	OP_stmt(SCF)
		|	OP_stmt_const(IM)
		|	OP_stmt_const(RST)
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
