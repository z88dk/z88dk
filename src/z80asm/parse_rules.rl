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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/parse_rules.rl,v 1.16 2014-12-27 23:16:51 pauloscustodio Exp $ 
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

#define DO_stmt_dis(opcode) 	_DO_stmt_(dis, opcode)
#define DO_stmt_n(  opcode)		_DO_stmt_(n,   opcode)
#define DO_stmt_nn( opcode)		_DO_stmt_(nn,  opcode)

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

			
#define RULE_stmt_dis(token, value) \
			label? _TK_##token expr _TK_NEWLINE \
			@{ DO_stmt_dis(value); }

#define OP_stmt_dis(op) \
			RULE_stmt_dis(op, Z80_##op)

			
#define RULE_stmt_flag_nn(token, flag, value) \
			label? _TK_##token _TK_##flag _TK_COMMA expr _TK_NEWLINE \
			@{ DO_stmt_nn(value); }

#define OP_stmt_flag_nn(op, flag) \
			RULE_stmt_flag_nn(op, flag, Z80_##op##_FLAG(FLAG_##flag))


#define RULE_stmt_flag_dis(token, flag, value) \
			label? _TK_##token _TK_##flag _TK_COMMA expr _TK_NEWLINE \
			@{ DO_stmt_dis(value); }

#define OP_stmt_flag_dis(op, flag) \
			RULE_stmt_flag_dis(op, flag, Z80_##op##_FLAG(FLAG_##flag))


#define RULE_stmt_flag(token, flag, value) \
			label? _TK_##token _TK_##flag _TK_NEWLINE \
			@{ DO_stmt(value); }

#define OP_stmt_flag(op, flag) \
			RULE_stmt_flag(op, flag, Z80_##op##_FLAG(FLAG_##flag))



 
/* special opcodes */
#define OP_CALL_flag_nn(flag) \
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

#define OP_stmt_emul(op, emul_func) \
			label? _TK_##op _TK_NEWLINE \
			@{ \
				if (compile_active) { \
					DO_STMT_LABEL(); \
					add_opcode_emul(Z80_##op, #emul_func); \
				} \
			}


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
	
	const_expr = 
			  expr %{ pop_eval_expr(&expr_value, &expr_error); };
	
	/* assembly statement */
	main := _TK_END
		|	_TK_NEWLINE
		|	label _TK_NEWLINE @{ DO_STMT_LABEL(); }
		|	OP_CALL_flag_nn(C)
		|	OP_CALL_flag_nn(M)
		|	OP_CALL_flag_nn(NC)
		|	OP_CALL_flag_nn(NZ)
		|	OP_CALL_flag_nn(P)
		|	OP_CALL_flag_nn(PE)
		|	OP_CALL_flag_nn(PO)
		|	OP_CALL_flag_nn(Z)
		|	OP_stmt(CCF)
		|	OP_stmt(CPL)
		|	OP_stmt(DAA)
		|	OP_stmt(DI)
		|	OP_stmt(EI)
		|	OP_stmt(EXX)
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
		|	OP_stmt(OTDR)
		|	OP_stmt(OTIR)
		|	OP_stmt(OUTD)
		|	OP_stmt(OUTI)
		|	OP_stmt(RET)
		|	OP_stmt(RETI)
		|	OP_stmt(RETN)
		|	OP_stmt(RLA)
		|	OP_stmt(RLCA)
		|	OP_stmt(RRA)
		|	OP_stmt(RRCA)
		|	OP_stmt(SCF)
		|	OP_stmt_arg(JP, IND_HL, 			Z80_JP_idx)
		|	OP_stmt_arg(JP, IND_IX _TK_RPAREN, 	Z80_JP_idx + P_IX)
		|	OP_stmt_arg(JP, IND_IY _TK_RPAREN, 	Z80_JP_idx + P_IY)
		|	OP_stmt_arg_arg(EX, AF, AF,		Z80_EX_AF_AF)
		|	OP_stmt_arg_arg(EX, AF, AF1, 	Z80_EX_AF_AF)
		|	OP_stmt_arg_arg(EX, DE, HL,  	Z80_EX_DE_HL)
		|	OP_stmt_arg_arg(EX, IND_SP, HL, Z80_EX_IND_SP_HL)
		|	OP_stmt_arg_arg(EX, IND_SP, IX, Z80_EX_IND_SP_idx + P_IX)
		|	OP_stmt_arg_arg(EX, IND_SP, IY, Z80_EX_IND_SP_idx + P_IY)
		|	OP_stmt_const(IM)
		|	OP_stmt_const(RST)
		|	OP_stmt_dis(DJNZ)
		|	OP_stmt_dis(JR)
		|	OP_stmt_emul(CPD,  rcmx_cpd)
		|	OP_stmt_emul(CPDR, rcmx_cpdr)
		|	OP_stmt_emul(CPI,  rcmx_cpi)
		|	OP_stmt_emul(CPIR, rcmx_cpir)
		|	OP_stmt_emul(RLD,  rcmx_rld)
		|	OP_stmt_emul(RRD,  rcmx_rrd)
		|	OP_stmt_flag(RET, C)
		|	OP_stmt_flag(RET, M)
		|	OP_stmt_flag(RET, NC)
		|	OP_stmt_flag(RET, NZ)
		|	OP_stmt_flag(RET, P)
		|	OP_stmt_flag(RET, PE)
		|	OP_stmt_flag(RET, PO)
		|	OP_stmt_flag(RET, Z)
		|	OP_stmt_flag_dis(JR, C)
		|	OP_stmt_flag_dis(JR, NC)
		|	OP_stmt_flag_dis(JR, NZ)
		|	OP_stmt_flag_dis(JR, Z)
		|	OP_stmt_flag_nn(JP, C)
		|	OP_stmt_flag_nn(JP, M)
		|	OP_stmt_flag_nn(JP, NC)
		|	OP_stmt_flag_nn(JP, NZ)
		|	OP_stmt_flag_nn(JP, P)
		|	OP_stmt_flag_nn(JP, PE)
		|	OP_stmt_flag_nn(JP, PO)
		|	OP_stmt_flag_nn(JP, Z)
		|	OP_stmt_idx(POP,  IX)
		|	OP_stmt_idx(POP,  IY)
		|	OP_stmt_idx(PUSH, IX)
		|	OP_stmt_idx(PUSH, IY)
		|	OP_stmt_nn(CALL)
		|	OP_stmt_nn(JP)
		|	OP_stmt_reg(POP,  AF)
		|	OP_stmt_reg(POP,  BC)
		|	OP_stmt_reg(POP,  DE)
		|	OP_stmt_reg(POP,  HL)
		|	OP_stmt_reg(PUSH, AF)
		|	OP_stmt_reg(PUSH, BC)
		|	OP_stmt_reg(PUSH, DE)
		|	OP_stmt_reg(PUSH, HL)
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
