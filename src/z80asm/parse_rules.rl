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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/parse_rules.rl,v 1.25 2014-12-31 16:11:15 pauloscustodio Exp $ 
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

#define DO_stmt_idx_n(opcode) \
			{ 	Expr *n_expr   = pop_expr(); \
				Expr *idx_expr = pop_expr(); \
				if (compile_active) { \
					DO_STMT_LABEL(); \
					add_opcode_idx_n((opcode), \
									 idx_expr, n_expr); \
				} \
				else { \
					OBJ_DELETE(n_expr); \
					OBJ_DELETE(idx_expr); \
				} \
			}


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
*   INC / DEC operations
*----------------------------------------------------------------------------*/
#define _OP_id_idx(id, idx) \
			label? _TK_##id _TK_IND_##idx \
					_TK_RPAREN _TK_NEWLINE					/* (ix) */ \
			@{ DO_stmt((Z80_##id(REG_idx) + P_##idx) << 8); } \
		|	label? _TK_##id _TK_IND_##idx \
					_TK_PLUS expr _TK_RPAREN _TK_NEWLINE	/* (ix+d) */ \
			@{ DO_stmt_idx(Z80_##id(REG_idx) + P_##idx); } \
		|	label? _TK_##id _TK_IND_##idx \
					_TK_MINUS neg_expr _TK_RPAREN _TK_NEWLINE	/* (ix-d) */ \
			@{ DO_stmt_idx(Z80_##id(REG_idx) + P_##idx); }			

#define _OP_id_reg(id, reg) \
			label? _TK_##id _TK_##reg _TK_NEWLINE			/* reg */ \
			@{ DO_stmt(Z80_##id(REG_##reg)); }

#define _OP_id_idx8(id, idx) \
			label? _TK_##id _TK_##idx##H _TK_NEWLINE		/* ixh */ \
			@{ DO_stmt(Z80_##id(REG_H) + P_##idx); } \
		|	label? _TK_##id _TK_##idx##L _TK_NEWLINE		/* ixl */ \
			@{ DO_stmt(Z80_##id(REG_L) + P_##idx); } \

#define _OP_id(id) \
			label? _TK_##id _TK_IND_HL _TK_NEWLINE 		/* (hl) */ \
			@{ DO_stmt(Z80_##id(REG_idx)); } \
		|	_OP_id_idx(id, IX) \
		|	_OP_id_idx(id, IY) \
		|	_OP_id_reg(id, B) \
		|	_OP_id_reg(id, C) \
		|	_OP_id_reg(id, D) \
		|	_OP_id_reg(id, E) \
		|	_OP_id_reg(id, H) \
		|	_OP_id_reg(id, L) \
		|	_OP_id_reg(id, A) \
		|	_OP_id_idx8(id, IX) \
		|	_OP_id_idx8(id, IY)

#define _OP_id16_reg(id, reg, p, p_reg) \
			label? _TK_##id _TK_##reg _TK_NEWLINE \
			@{ DO_stmt((p) + Z80_##id##16(REG_##p_reg)); } \

#define _OP_id16(id) \
			_OP_id16_reg(id, BC, 0,    BC)	\
		|	_OP_id16_reg(id, DE, 0,    DE)	\
		|	_OP_id16_reg(id, HL, 0,    HL)	\
		|	_OP_id16_reg(id, SP, 0,    SP)	\
		|	_OP_id16_reg(id, IX, P_IX, HL)	\
		|	_OP_id16_reg(id, IY, P_IY, HL)
		
#define OP_inc_dec() \
			_OP_id(INC) \
		|	_OP_id(DEC) \
		|	_OP_id16(INC) \
		|	_OP_id16(DEC)

/*-----------------------------------------------------------------------------
*   Rotate and Shift operations
*----------------------------------------------------------------------------*/
#define _OP_rs_idx(rs, idx) \
			label? _TK_##rs _TK_IND_##idx \
					_TK_RPAREN _TK_NEWLINE					/* (ix) */ \
			@{ DO_stmt( ((P_##idx << 16) & 0xFF000000) + \
						((Z80_##rs(REG_idx) << 8) & 0xFF0000) + \
						((0 << 8) & 0xFF00) + \
						((Z80_##rs(REG_idx) << 0) & 0xFF) ); } \
		|	label? _TK_##rs _TK_IND_##idx \
					_TK_PLUS expr _TK_RPAREN _TK_NEWLINE	/* (ix+d) */ \
			@{ DO_stmt_idx( ((P_##idx << 8) & 0xFF0000) + \
						    Z80_##rs(REG_idx) ); } \
		|	label? _TK_##rs _TK_IND_##idx \
					_TK_MINUS neg_expr _TK_RPAREN _TK_NEWLINE	/* (ix-d) */ \
			@{ DO_stmt_idx( ((P_##idx << 8) & 0xFF0000) + \
						    Z80_##rs(REG_idx) ); } \

#define _OP_rs_reg(rs, reg) \
			label? _TK_##rs _TK_##reg _TK_NEWLINE			/* reg */ \
			@{ DO_stmt(Z80_##rs(REG_##reg)); }

#define _OP_rs(rs) \
			label? _TK_##rs _TK_IND_HL _TK_NEWLINE 			/* (hl) */ \
			@{ DO_stmt(Z80_##rs(REG_idx)); } \
		|	_OP_rs_idx(rs, IX) \
		|	_OP_rs_idx(rs, IY) \
		|	_OP_rs_reg(rs, B) \
		|	_OP_rs_reg(rs, C) \
		|	_OP_rs_reg(rs, D) \
		|	_OP_rs_reg(rs, E) \
		|	_OP_rs_reg(rs, H) \
		|	_OP_rs_reg(rs, L) \
		|	_OP_rs_reg(rs, A) \

#define OP_rot_shift() \
			_OP_rs(RLC) \
		|	_OP_rs(RRC) \
		|	_OP_rs(RL) \
		|	_OP_rs(RR)  \
		|	_OP_rs(SLA)  \
		|	_OP_rs(SRA) \
		|	_OP_rs(SLL) \
		|	_OP_rs(SRL)

/*-----------------------------------------------------------------------------
*   Bit, Set and Reset operations
*----------------------------------------------------------------------------*/
#define _OP_brs_idx(brs, idx) \
			label? _TK_##brs const_expr _TK_COMMA _TK_IND_##idx \
					_TK_RPAREN _TK_NEWLINE					/* (ix) */ \
			@{ if ( ! expr_error ) \
				DO_stmt( ((P_##idx << 16) & 0xFF000000) + \
						 ((Z80_##brs(expr_value, REG_idx) << 8) & 0xFF0000) + \
						 ((0 << 8) & 0xFF00) + \
						 ((Z80_##brs(expr_value, REG_idx) << 0) & 0xFF) ); } \
		|	label? _TK_##brs const_expr _TK_COMMA _TK_IND_##idx \
					_TK_PLUS expr _TK_RPAREN _TK_NEWLINE	/* (ix+d) */ \
			@{ if ( ! expr_error ) \
				DO_stmt_idx( ((P_##idx << 8) & 0xFF0000) + \
						     Z80_##brs(expr_value, REG_idx) ); } \
		|	label? _TK_##brs const_expr _TK_COMMA _TK_IND_##idx \
					_TK_MINUS neg_expr _TK_RPAREN _TK_NEWLINE	/* (ix-d) */ \
			@{ if ( ! expr_error ) \
				DO_stmt_idx( ((P_##idx << 8) & 0xFF0000) + \
						    Z80_##brs(expr_value, REG_idx) ); } \

#define _OP_brs_reg(brs, reg) \
			label? _TK_##brs const_expr _TK_COMMA _TK_##reg _TK_NEWLINE			/* reg */ \
			@{ if ( ! expr_error ) \
				DO_stmt(Z80_##brs(expr_value, REG_##reg)); }

#define _OP_brs(brs) \
			label? _TK_##brs const_expr _TK_COMMA _TK_IND_HL _TK_NEWLINE 			/* (hl) */ \
			@{ if ( ! expr_error ) \
				DO_stmt(Z80_##brs(expr_value, REG_idx)); } \
		|	_OP_brs_idx(brs, IX) \
		|	_OP_brs_idx(brs, IY) \
		|	_OP_brs_reg(brs, B) \
		|	_OP_brs_reg(brs, C) \
		|	_OP_brs_reg(brs, D) \
		|	_OP_brs_reg(brs, E) \
		|	_OP_brs_reg(brs, H) \
		|	_OP_brs_reg(brs, L) \
		|	_OP_brs_reg(brs, A) \

#define OP_bit_res_set() \
			_OP_brs(BIT) \
		|	_OP_brs(RES) \
		|	_OP_brs(SET)

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
			label? _TK_IN _TK_A _TK_COMMA paren_expr _TK_NEWLINE \
			@{ DO_stmt_n(Z80_IN_A_n); }

#define _OP_out_reg(reg) \
			label? _TK_OUT _TK_IND_C _TK_COMMA _TK_##reg _TK_NEWLINE \
			@{ DO_stmt(Z80_OUT_C_REG(REG_##reg)); }

#define _OP_out_A \
			label? _TK_OUT paren_expr _TK_COMMA _TK_A _TK_NEWLINE \
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
		|	_OP_out_reg(A)	\
		|	_OP_out_A

/*-----------------------------------------------------------------------------
*   Expression macros
*----------------------------------------------------------------------------*/
#define EXPR_START_ACTION() \
			expr_start = p; \
			expr_in_parens = (expr_start->tok == TK_LPAREN) ? TRUE : FALSE; \
			expr_open_parens = 0;

/*-----------------------------------------------------------------------------
*   State Machine
*----------------------------------------------------------------------------*/

%%{
	machine parser;

	/* type of token and way to retrieve */
	alphtype short;
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
	action parens_open { expr_open_parens > 0 }
	lparen = (_TK_LPAREN | _TK_LSQUARE) 
			>{ expr_open_parens++; };
	rparen = (_TK_RPAREN | _TK_RSQUARE) when parens_open
			%{ expr_open_parens--; };

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

	term 	= ( unary | lparen )* 
			  ( _TK_ASMPC | _TK_NAME | _TK_NUMBER )
			  ( rparen )*;
			  
	expr1 	= _TK_CONST_EXPR ? term ( binary term )**;
	
	/* expression */
	expr 	= expr1 
			  >{ EXPR_START_ACTION(); }
			  %{ push_expr(expr_start, p); };
	
	/* expression that needs to be negated */
	neg_expr = expr1 
			  >{ EXPR_START_ACTION(); }
			  %{ push_neg_expr(expr_start, p); };
	
	/* expression within parentheses */
	paren_expr = expr1 
			  >{ EXPR_START_ACTION(); }
			  %{ if (! expr_in_parens)
					return FALSE;		/* syntax error */
				 push_expr(expr_start, p); 
			   };
	
	const_expr = 
			  expr %{ pop_eval_expr(&expr_value, &expr_error); };
	
	/* assembly statement */
	main := _TK_END
		|	_TK_NEWLINE
		|	label _TK_NEWLINE @{ DO_STMT_LABEL(); }
		|	OP_alu16()
		|	OP_bit_res_set()
		|	OP_call()
		|	OP_emulated()
		|	OP_ex()
		|	OP_inc_dec()
		|	OP_in_out()
		|	OP_jump()
		|	OP_push_pop()
		|	OP_ret()
		|	OP_rot_shift()

		/*---------------------------------------------------------------------
		*   8-bit load group
		*--------------------------------------------------------------------*/
#foreach <R1> in     B, C, D, E, H, L, A
  #foreach <R2> in B, C, D, E, H, L, A
		/* LD r,r */
		|	label? _TK_LD _TK_<R1> _TK_COMMA _TK_<R2> _TK_NEWLINE \
			@{ DO_stmt( Z80_LD_r_r( REG_<R1>, REG_<R2> ) ); }
  #endfor  <R2>
	
		/* LD r,(hl) */
		|	label? _TK_LD _TK_<R1> _TK_COMMA _TK_IND_HL _TK_NEWLINE \
			@{ DO_stmt( Z80_LD_r_r( REG_<R1>, REG_idx ) ); }

		/* LD (hl),r */
		|	label? _TK_LD _TK_IND_HL _TK_COMMA _TK_<R1> _TK_NEWLINE \
			@{ DO_stmt( Z80_LD_r_r( REG_idx, REG_<R1> ) ); }

  #foreach <X> in IX, IY
		/* LD r,(ix) */
		|	label? _TK_LD _TK_<R1> _TK_COMMA 
					_TK_IND_<X> _TK_RPAREN _TK_NEWLINE \
			@{ DO_stmt( (P_<X> + Z80_LD_r_r( REG_<R1>, REG_idx ) ) << 8 ); }
			
		/* LD r,(ix+d) */
		|	label? _TK_LD _TK_<R1> _TK_COMMA 
					_TK_IND_<X> _TK_PLUS expr _TK_RPAREN _TK_NEWLINE \
			@{ DO_stmt_idx( P_<X> + Z80_LD_r_r( REG_<R1>, REG_idx ) ); }
			
		/* LD r,(ix-d) */
		|	label? _TK_LD _TK_<R1> _TK_COMMA 
					_TK_IND_<X> _TK_MINUS neg_expr _TK_RPAREN _TK_NEWLINE \
			@{ DO_stmt_idx( P_<X> + Z80_LD_r_r( REG_<R1>, REG_idx ) ); }

		/* LD (ix),r */
		|	label? _TK_LD _TK_IND_<X> _TK_RPAREN 
					_TK_COMMA _TK_<R1> _TK_NEWLINE \
			@{ DO_stmt( (P_<X> + Z80_LD_r_r( REG_idx, REG_<R1> ) ) << 8 ); }
			
		/* LD (ix+d),r */
		|	label? _TK_LD _TK_IND_<X> _TK_PLUS expr _TK_RPAREN 
					_TK_COMMA _TK_<R1> _TK_NEWLINE \
			@{ DO_stmt_idx( P_<X> + Z80_LD_r_r( REG_idx, REG_<R1> ) ); }
			
		/* LD (ix-d),r */
		|	label? _TK_LD _TK_IND_<X> _TK_MINUS neg_expr _TK_RPAREN 
					_TK_COMMA _TK_<R1> _TK_NEWLINE \
			@{ DO_stmt_idx( P_<X> + Z80_LD_r_r( REG_idx, REG_<R1> ) ); }

  #endfor  <X>
		
		/* LD r,N | LD A,(NN) */
		|	label? _TK_LD _TK_<R1> _TK_COMMA expr _TK_NEWLINE
			@{ 
				if ( expr_in_parens ) {
					if ( REG_<R1> == REG_A ) {
						DO_stmt_nn( Z80_LD_A_IND_NN );		/* ld a,(NN) */
					}
					else
						return FALSE;			/* syntax error */
				}
				else {
					DO_stmt_n( Z80_LD_r_n( REG_<R1> ) );	/* ld r,N */
				}
			}	
#endfor  <R1>

#foreach <X> in IX, IY
  #foreach <R1> in <X>H, <X>L
	#foreach <R2> in B, C, D, E, <X>H, <X>L, A

		/* LD r,r */
#ifndef _LD_<R1>_<R2>_DEFINED
#define _LD_<R1>_<R2>_DEFINED
		|	label? _TK_LD _TK_<R1> _TK_COMMA _TK_<R2> _TK_NEWLINE \
			@{ DO_stmt( P_<X> + Z80_LD_r_r( REG_<R1>, REG_<R2> ) ); }
#endif

#ifndef _LD_<R2>_<R1>_DEFINED
#define _LD_<R2>_<R1>_DEFINED
		|	label? _TK_LD _TK_<R2> _TK_COMMA _TK_<R1> _TK_NEWLINE \
			@{ DO_stmt( P_<X> + Z80_LD_r_r( REG_<R2>, REG_<R1> ) ); }
#endif

	#endfor  <R2>

		/* LD r,N */
		|	label? _TK_LD _TK_<R1> _TK_COMMA expr _TK_NEWLINE
			@{ DO_stmt_n( P_<X> + Z80_LD_r_n( REG_<R1> ) ); }

  #endfor  <R1>
#endfor  <X>

		/* LD (hl),N */
		|	label? _TK_LD _TK_IND_HL _TK_COMMA expr _TK_NEWLINE
			@{ DO_stmt_n( Z80_LD_r_n( REG_idx ) ); }

#foreach <X> in IX, IY
		/* LD (ix),N */
		|	label? _TK_LD _TK_IND_<X> _TK_RPAREN 
					_TK_COMMA expr _TK_NEWLINE \
			@{ DO_stmt_n( (P_<X> + Z80_LD_r_n( REG_idx ) ) << 8 ); }
			
		/* LD (ix+d),N */
		|	label? _TK_LD _TK_IND_<X> _TK_PLUS expr _TK_RPAREN 
					_TK_COMMA expr _TK_NEWLINE \
			@{ DO_stmt_idx_n( P_<X> + Z80_LD_r_n( REG_idx ) ); }
			
		/* LD (ix-d),r */
		|	label? _TK_LD _TK_IND_<X> _TK_MINUS neg_expr _TK_RPAREN 
					_TK_COMMA expr _TK_NEWLINE \
			@{ DO_stmt_idx_n( P_<X> + Z80_LD_r_n( REG_idx ) ); }
#endfor  <X>		

#foreach <DD> in BC, DE
		/* LD a,(bc|de) */
		|	label? _TK_LD _TK_A _TK_COMMA _TK_IND_<DD> _TK_NEWLINE \
			@{ DO_stmt( Z80_LD_A_IND_dd( REG_IND_<DD> ) ); }

		/* LD (bc|de),a */
		|	label? _TK_LD _TK_IND_<DD> _TK_COMMA _TK_A _TK_NEWLINE \
			@{ DO_stmt( Z80_LD_IND_dd_A( REG_IND_<DD> ) ); }
#endfor  <DD>		

		/* ld (NN),A */
		| label? _TK_LD expr _TK_COMMA _TK_A _TK_NEWLINE
		  @{
				if (! expr_in_parens)
					return FALSE;			/* syntax error */
					
				DO_stmt_nn( Z80_LD_IND_NN_A );		/* ld (NN),a */
			}

		/* load I, R */
#foreach <IR> in I, IIR, R, EIR
		|	label? _TK_LD _TK_<IR> _TK_COMMA _TK_A _TK_NEWLINE \
			@{ DO_stmt( Z80_LD_<IR>_A ); }
		|	label? _TK_LD _TK_A _TK_COMMA _TK_<IR> _TK_NEWLINE \
			@{ DO_stmt( Z80_LD_A_<IR> ); }
#endfor  <IR>

		/*---------------------------------------------------------------------
		*   16-bit load group
		*--------------------------------------------------------------------*/
#foreach <DD> in BC, DE, HL, SP
		/* ld dd,NN | ld dd,(NN) */
		| label? _TK_LD _TK_<DD> _TK_COMMA expr _TK_NEWLINE
		  @{
				if ( expr_in_parens ) {
					if ( REG_<DD> == REG_HL ) {		/* ld hl,(NN) */
						DO_stmt_nn( Z80_LD_idx_IND_nn );
					}
					else {							/* ld dd,(NN) */
						DO_stmt_nn( Z80_LD_dd_IND_nn( REG_<DD> ) );
					}
				}
				else {								/* ld dd,NN */
					DO_stmt_nn( Z80_LD_dd_nn( REG_<DD> ) );
				}
			}
#endfor  <DD>

#foreach <X> in IX, IY
		/* ld x,NN | ld x,(NN) */
		| label? _TK_LD _TK_<X> _TK_COMMA expr _TK_NEWLINE
		  @{
				if ( expr_in_parens ) {				/* ld x,(NN) */
					DO_stmt_nn( P_<X> + Z80_LD_idx_IND_nn );
				}
				else {								/* ld x,NN */
					DO_stmt_nn( P_<X> + Z80_LD_dd_nn( REG_<X> ) );
				}
			}
#endfor  <X>

		/* ld (NN),hl */
		| label? _TK_LD expr _TK_COMMA _TK_HL _TK_NEWLINE
		  @{
				if (! expr_in_parens)
					return FALSE;			/* syntax error */
					
				DO_stmt_nn( Z80_LD_IND_nn_idx );	/* ld (NN),hl */
			}

#foreach <DD> in BC, DE, SP
		/* ld (NN),dd */
		| label? _TK_LD expr _TK_COMMA _TK_<DD> _TK_NEWLINE
		  @{
				if (! expr_in_parens)
					return FALSE;			/* syntax error */
					
				DO_stmt_nn( Z80_LD_IND_nn_dd( REG_<DD> ) );	/* ld (NN),dd */
			}
#endfor  <DD>

		/* ld (NN),x */
#foreach <X> in IX, IY
		| label? _TK_LD expr _TK_COMMA _TK_<X> _TK_NEWLINE
		  @{
				if (! expr_in_parens)
					return FALSE;			/* syntax error */
				
				DO_stmt_nn( P_<X> + Z80_LD_IND_nn_idx );	/* ld (NN),x */
			}
#endfor  <X>


		/* ld sp,hl|ix|iy */
		| label? _TK_LD _TK_SP _TK_COMMA _TK_HL _TK_NEWLINE
		  @{ DO_stmt( Z80_LD_SP_idx ); }			/* ld sp,hl */
		  
#foreach <X> in IX, IY
		| label? _TK_LD _TK_SP _TK_COMMA _TK_<X> _TK_NEWLINE
		  @{ DO_stmt( P_<X> + Z80_LD_SP_idx ); }	/* ld sp,x */
#endfor  <X>




		/* opcodes without arguments */
#foreach <OP> in CCF, CPL, DAA, DI, EI, HALT, \
				 IND, INDR, INI, INIR, \
				 LDD, LDDR, LDI, LDIR, \
				 NEG, NOP, \
				 RLA, RLCA, RRA, RRCA, \
				 SCF
		|	OP_stmt(<OP>)
#endfor  <OP>

		/* opcodes with constant argument */
#foreach <OP> in IM, RST
		|	OP_stmt_const(<OP>)
#endfor  <OP>

		/* ALU */
#foreach <OP> in ADC, ADD, AND, CP, OR, SBC, SUB, XOR
	#foreach <R> in B, C, D, E, H, L, A
		|	label? _TK_<OP> (_TK_A _TK_COMMA)? _TK_<R> _TK_NEWLINE
			@{ DO_stmt( Z80_<OP>( REG_<R> ) ); }
	#endfor  <R>

	#foreach <X> in IX, IY
		#foreach <R> in L, H
		|	label? _TK_<OP> (_TK_A _TK_COMMA)? _TK_<X><R> _TK_NEWLINE
			@{ DO_stmt( P_<X> + Z80_<OP>( REG_<R> ) ); }
		#endfor  <R>
		
		/* (x) */
		|	label? _TK_<OP> (_TK_A _TK_COMMA)? 
					_TK_IND_<X> _TK_RPAREN  _TK_NEWLINE
			@{ DO_stmt( ( P_<X> + Z80_<OP>( REG_idx ) ) << 8 ); }
			
		/* (x+d) */
		|	label? _TK_<OP> (_TK_A _TK_COMMA)? 
					_TK_IND_<X> _TK_PLUS expr _TK_RPAREN  _TK_NEWLINE
			@{ DO_stmt_idx( P_<X> + Z80_<OP>( REG_idx ) ); }
			
		/* (x-d) */
		|	label? _TK_<OP> (_TK_A _TK_COMMA)? 
					_TK_IND_<X> _TK_MINUS neg_expr _TK_RPAREN  _TK_NEWLINE
			@{ DO_stmt_idx( P_<X> + Z80_<OP>( REG_idx ) ); }
	#endfor  <X>
	
		/* (hl) */
		|	label? _TK_<OP> (_TK_A _TK_COMMA)? _TK_IND_HL _TK_NEWLINE
			@{ DO_stmt( Z80_<OP>( REG_idx ) ); }

		/* N */
		|	label? _TK_<OP> (_TK_A _TK_COMMA)? expr _TK_NEWLINE
			@{ DO_stmt_n( Z80_<OP>_n ); }

#endfor  <OP>
		;

}%%

%%write data;

static Bool _parse_statement(Bool compile_active)
{
	int start_num_errors;
	
	p = pe = eof = NULL;
	
	%%write init;
	
	start_num_errors = get_num_errors();
	while ( (eof == NULL || eof != pe) &&
			get_num_errors() == start_num_errors )
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
