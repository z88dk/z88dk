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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/parse_rules.rl,v 1.41 2015-01-21 23:34:54 pauloscustodio Exp $ 
*/

#include "legacy.h"

#define NO_TOKEN_ENUM
#include "scan_tokens.h"

/*-----------------------------------------------------------------------------
*   Helper macros
*----------------------------------------------------------------------------*/

/* macros for actions - labels */
#define DO_LABEL(name) \
			if (compile_active) { \
				asm_LABEL(name); \
			}

#define DO_STMT_LABEL() \
			if (stmt_label->len) { \
				DO_LABEL(stmt_label->str); \
				stmt_label->len = 0; \
			}

/* macros for actions - statements */
#define DO_stmt(opcode) \
			if (compile_active) { \
				DO_STMT_LABEL(); \
				add_opcode(opcode); \
			}

#define _DO_stmt_(suffix, opcode) \
			{ 	Expr *expr = pop_expr(ctx); \
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
			{ 	Expr *n_expr   = pop_expr(ctx); \
				Expr *idx_expr = pop_expr(ctx); \
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

#define DO_stmt_emul(opcode, emul_func) \
			{	if (compile_active) { \
					DO_STMT_LABEL(); \
					add_opcode_emul((opcode), #emul_func); \
				} \
			}

#define DO_stmt_call_flag(flag) \
			{ 	Expr *expr = pop_expr(ctx); \
				if (compile_active) { \
					DO_STMT_LABEL(); \
					add_call_flag(FLAG_##flag, expr); \
				} \
				else \
					OBJ_DELETE(expr); \
			}

/*-----------------------------------------------------------------------------
*   Expression macros
*----------------------------------------------------------------------------*/
#define EXPR_START_ACTION() \
			ctx->expr_start = ctx->p; \
			ctx->expr_in_parens = (ctx->expr_start->tok == TK_LPAREN) ? TRUE : FALSE; \
			ctx->expr_open_parens = 0;

/*-----------------------------------------------------------------------------
*   State Machine
*----------------------------------------------------------------------------*/

%%{
	machine parser;

	/* type of token and way to retrieve */
	alphtype short;
	getkey ((int)ctx->p->tok);
	variable cs  ctx->cs;
	variable p   ctx->p;
	variable pe  ctx->pe;
	variable eof ctx->eof;

	/* label, name */
	label  = _TK_LABEL  @{ Str_set_n(stmt_label, ctx->p->tstart, ctx->p->tlen); };
	name   = _TK_NAME   @{ Str_set_n(name,       ctx->p->tstart, ctx->p->tlen); };
	string = _TK_STRING @{ Str_set_n(name,       ctx->p->tstart, ctx->p->tlen); };
	
	/* expression */
	action parens_open { ctx->expr_open_parens > 0 }
	lparen = (_TK_LPAREN | _TK_LSQUARE) 
			>{ ctx->expr_open_parens++; };
	rparen = (_TK_RPAREN | _TK_RSQUARE) when parens_open
			%{ ctx->expr_open_parens--; };

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
			  %{ push_expr(ctx); };
	
	/* expression within parentheses */
	paren_expr = expr1 
			  >{ EXPR_START_ACTION(); }
			  %{ if (! ctx->expr_in_parens)
					return FALSE;		/* syntax error */
				 push_expr(ctx); 
			   };
	
	const_expr = 
			  expr %{ pop_eval_expr(ctx); };
	
	/*---------------------------------------------------------------------
	*   DEFGROUP
	*--------------------------------------------------------------------*/
	asm_DEFGROUP =
		  _TK_DEFGROUP _TK_NEWLINE
		  @{ asm_DEFGROUP_start(0);
		     ctx->current_sm = SM_DEFGROUP_OPEN; }
		| _TK_DEFGROUP _TK_LCURLY _TK_NEWLINE
		  @{ asm_DEFGROUP_start(0);
		     ctx->current_sm = SM_DEFGROUP_LINE; }
		;

	defgroup_var_value =
		  name _TK_EQUAL const_expr	
		  %{ if (! ctx->expr_error) 
				asm_DEFGROUP_start(ctx->expr_value);
			 asm_DEFGROUP_define_const(name->str);
		  };
	
	defgroup_var_next =
		  name
		  %{ asm_DEFGROUP_define_const(name->str); }
		;

	defgroup_var = defgroup_var_value | defgroup_var_next;
	
	defgroup_open :=
		  _TK_NEWLINE
		| _TK_END 					@{ error_missing_block(); }
		| _TK_LCURLY _TK_NEWLINE 	@{ ctx->current_sm = SM_DEFGROUP_LINE; }
		;
	
	defgroup_line := 
		  _TK_NEWLINE
		| _TK_END 					@{ error_missing_close_block(); }
		| _TK_RCURLY _TK_NEWLINE	@{ ctx->current_sm = SM_MAIN; }
		| defgroup_var (_TK_COMMA defgroup_var)* _TK_COMMA? _TK_NEWLINE
		;
	
	/*---------------------------------------------------------------------
	*   DEFVARS
	*--------------------------------------------------------------------*/
	asm_DEFVARS = 
		  _TK_DEFVARS const_expr _TK_NEWLINE
		  @{ if (! ctx->expr_error) 
				asm_DEFVARS_start(ctx->expr_value);
			 ctx->current_sm = SM_DEFVARS_OPEN;
		  }
		| _TK_DEFVARS const_expr _TK_LCURLY _TK_NEWLINE
		  @{ if (! ctx->expr_error) 
				asm_DEFVARS_start(ctx->expr_value);
			 ctx->current_sm = SM_DEFVARS_LINE;
		  }
		;
		
	defvars_open :=
		  _TK_NEWLINE
		| _TK_END 					@{ error_missing_block(); }
		| _TK_LCURLY _TK_NEWLINE 	@{ ctx->current_sm = SM_DEFVARS_LINE; }
		;
		
	defvars_line := 
		  _TK_NEWLINE
		| _TK_END 					@{ error_missing_close_block(); }
		| _TK_RCURLY _TK_NEWLINE	@{ ctx->current_sm = SM_MAIN; }
		| name _TK_NEWLINE
		  @{ asm_DEFVARS_define_const( name->str, 0, 0 ); }
#foreach <S> in B, W, P, L
		| name _TK_DS_<S> const_expr _TK_NEWLINE
		  @{ if (! ctx->expr_error) 
				asm_DEFVARS_define_const( name->str, DEFVARS_SIZE_<S>, ctx->expr_value ); 
		  }
#endfor  <S>
		;

	/*---------------------------------------------------------------------
	*   DEFS
	*--------------------------------------------------------------------*/
	asm_DEFS = 
		  label? _TK_DEFS const_expr _TK_NEWLINE 
		  @{ DO_STMT_LABEL(); 
		     if (compile_active && ! ctx->expr_error) asm_DEFS(ctx->expr_value, 0); }
		| label? _TK_DEFS 
				const_expr _TK_COMMA
				@{ value1 = ctx->expr_error ? 0 : ctx->expr_value; }
				const_expr _TK_NEWLINE
		  @{ DO_STMT_LABEL(); 
		     if (compile_active && ! ctx->expr_error) asm_DEFS(value1, ctx->expr_value); }
		;			     
		
	/*---------------------------------------------------------------------
	*   directives without arguments
	*--------------------------------------------------------------------*/
#foreach <OP> in LSTON, LSTOFF
	asm_<OP> = _TK_<OP> _TK_NEWLINE @{ asm_<OP>(); };
#endfor  <OP>
	directives_no_args = asm_LSTON | asm_LSTOFF;
	
	/*---------------------------------------------------------------------
	*   directives with contant number argument
	*--------------------------------------------------------------------*/
#foreach <OP> in LINE, ORG
	asm_<OP> = _TK_<OP> const_expr _TK_NEWLINE 
			@{ if (!ctx->expr_error) asm_<OP>(ctx->expr_value); };
#endfor  <OP>
	directives_n = asm_LINE | asm_ORG;

	/*---------------------------------------------------------------------
	*   directives with string argument
	*--------------------------------------------------------------------*/
#foreach <OP> in INCLUDE, BINARY
	asm_<OP> = _TK_<OP> string _TK_NEWLINE
			@{ asm_<OP>(name->str); };
#endfor  <OP>
	directives_str = asm_INCLUDE | asm_BINARY;

	/*---------------------------------------------------------------------
	*   directives with NAME argument
	*--------------------------------------------------------------------*/
#foreach <OP> in MODULE, SECTION
	asm_<OP> = _TK_<OP> name _TK_NEWLINE
			@{ asm_<OP>(name->str); };
#endfor  <OP>
	directives_name = asm_MODULE | asm_SECTION;

	/*---------------------------------------------------------------------
	*   directives with list of names argument, function called for each 
	*	argument
	*--------------------------------------------------------------------*/
#foreach <OP> in EXTERN, XREF, LIB, PUBLIC, XDEF, XLIB
	action <OP>_action { asm_<OP>(name->str); }
	
	asm_<OP> = _TK_<OP> name @<OP>_action
		    ( _TK_COMMA name @<OP>_action )*
		    _TK_NEWLINE ;
#endfor  <OP>
	directives_names = asm_EXTERN | asm_XREF | asm_LIB |
					   asm_PUBLIC | asm_XDEF | asm_XLIB;

	/*---------------------------------------------------------------------
	*   assembly statement
	*--------------------------------------------------------------------*/
	main := 
		  _TK_END
		| _TK_NEWLINE
		| directives_no_args | directives_n | directives_str
		| directives_name | directives_names
		| asm_DEFGROUP
		| asm_DEFVARS
		| asm_DEFS
		
		/*---------------------------------------------------------------------
		*   Z80 assembly
		*--------------------------------------------------------------------*/
		| label _TK_NEWLINE @{ DO_STMT_LABEL(); }

		/*---------------------------------------------------------------------
		*   8-bit load group
		*--------------------------------------------------------------------*/
#foreach <R1> in   B, C, D, E, H, L, A
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
					_TK_IND_<X> expr _TK_RPAREN _TK_NEWLINE \
			@{ DO_stmt_idx( P_<X> + Z80_LD_r_r( REG_<R1>, REG_idx ) ); }
			
		/* LD (ix),r */
		|	label? _TK_LD _TK_IND_<X> _TK_RPAREN 
					_TK_COMMA _TK_<R1> _TK_NEWLINE \
			@{ DO_stmt( (P_<X> + Z80_LD_r_r( REG_idx, REG_<R1> ) ) << 8 ); }
			
		/* LD (ix+d),r */
		|	label? _TK_LD _TK_IND_<X> expr _TK_RPAREN 
					_TK_COMMA _TK_<R1> _TK_NEWLINE \
			@{ DO_stmt_idx( P_<X> + Z80_LD_r_r( REG_idx, REG_<R1> ) ); }
  #endfor  <X>
		
		/* LD r,N | LD A,(NN) */
		|	label? _TK_LD _TK_<R1> _TK_COMMA expr _TK_NEWLINE
			@{ 
				if ( ctx->expr_in_parens ) {
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
		|	label? _TK_LD _TK_IND_<X> expr _TK_RPAREN 
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
				if (! ctx->expr_in_parens)
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
#foreach <DD> in BC, DE, HL, SP, IX, IY
		/* ld dd,NN | ld dd,(NN) */
		| label? _TK_LD _TK_<DD> _TK_COMMA expr _TK_NEWLINE
		  @{
				if ( ctx->expr_in_parens ) {
					if ( REG_<DD> == REG_HL ) {		/* ld hl,(NN) */
						DO_stmt_nn( P_<DD> + Z80_LD_idx_IND_nn );
					}
					else {							/* ld dd,(NN) */
						DO_stmt_nn( Z80_LD_dd_IND_nn( REG_<DD> ) );
					}
				}
				else {								/* ld dd,NN */
					DO_stmt_nn( P_<DD> + Z80_LD_dd_nn( REG_<DD> ) );
				}
			}
#endfor  <DD>

		/* ld (NN),hl|ix|iy */
#foreach <DD> in HL, IX, IY
		| label? _TK_LD expr _TK_COMMA _TK_<DD> _TK_NEWLINE
		  @{
				if (! ctx->expr_in_parens)
					return FALSE;			/* syntax error */
					
				DO_stmt_nn( P_<DD> + Z80_LD_IND_nn_idx );
			}
#endfor  <DD>

		/* ld (NN),dd */
#foreach <DD> in BC, DE, SP
		| label? _TK_LD expr _TK_COMMA _TK_<DD> _TK_NEWLINE
		  @{
				if (! ctx->expr_in_parens)
					return FALSE;			/* syntax error */
					
				DO_stmt_nn( Z80_LD_IND_nn_dd( REG_<DD> ) );	/* ld (NN),dd */
			}
#endfor  <DD>

		/* ld sp,hl|ix|iy */
#foreach <DD> in HL, IX, IY
		| label? _TK_LD _TK_SP _TK_COMMA _TK_<DD> _TK_NEWLINE
		  @{ DO_stmt( P_<DD> + Z80_LD_SP_idx ); }
#endfor  <DD>

		/*---------------------------------------------------------------------
		*   PUSH / POP
		*--------------------------------------------------------------------*/
#foreach <OP> in PUSH, POP
  #foreach <DD> in BC, DE, HL, AF, IX, IY
		| label? _TK_<OP> _TK_<DD> _TK_NEWLINE
		  @{ DO_stmt( P_<DD> + Z80_<OP>( REG_<DD> ) ); }
  #endfor  <DD>
#endfor  <OP>

		/*---------------------------------------------------------------------
		*   EX, EXX
		*--------------------------------------------------------------------*/
		| label? _TK_EXX _TK_NEWLINE
		  @{ DO_stmt( Z80_EXX ); }
		  
#foreach <DD> in AF, AF1
		| label? _TK_EX _TK_AF _TK_COMMA _TK_<DD> _TK_NEWLINE
		  @{ DO_stmt( Z80_EX_AF_AF ); }
#endfor  <DD>

		| label? _TK_EX _TK_DE _TK_COMMA _TK_HL _TK_NEWLINE
		  @{ DO_stmt( Z80_EX_DE_HL ); }

		| label? _TK_EX _TK_IND_SP _TK_COMMA _TK_HL _TK_NEWLINE
		  @{ DO_stmt( Z80_EX_IND_SP_HL ); }

#foreach <DD> in IX, IY
		| label? _TK_EX _TK_IND_SP _TK_COMMA _TK_<DD> _TK_NEWLINE
		  @{ DO_stmt( P_<DD> + Z80_EX_IND_SP_idx ); }
#endfor  <DD>

		/*---------------------------------------------------------------------
		*   Emulated opcodes
		*--------------------------------------------------------------------*/
#foreach <OP> in CPI, CPIR, CPD, CPDR, RLD, RRD
		| label? _TK_<OP> _TK_NEWLINE \
		  @{ DO_stmt_emul( Z80_<OP>, #LCASE( rcmx_<OP> ) ); }  
#endfor  <OP>

		/*---------------------------------------------------------------------
		*   8-bit ALU
		*--------------------------------------------------------------------*/
#foreach <OP> in ADC, ADD, AND, CP, OR, SBC, SUB, XOR
	#foreach <R> in B, C, D, E, H, L, A
		| label? _TK_<OP> (_TK_A _TK_COMMA)? _TK_<R> _TK_NEWLINE
		  @{ DO_stmt( Z80_<OP>( REG_<R> ) ); }
	#endfor  <R>

	#foreach <X> in IX, IY
		#foreach <R> in L, H
		| label? _TK_<OP> (_TK_A _TK_COMMA)? _TK_<X><R> _TK_NEWLINE
		  @{ DO_stmt( P_<X> + Z80_<OP>( REG_<R> ) ); }
		#endfor  <R>
		
		/* (x) */
		| label? _TK_<OP> (_TK_A _TK_COMMA)? 
					_TK_IND_<X> _TK_RPAREN  _TK_NEWLINE
		  @{ DO_stmt( ( P_<X> + Z80_<OP>( REG_idx ) ) << 8 ); }
			
		/* (x+d) */
		| label? _TK_<OP> (_TK_A _TK_COMMA)? 
					_TK_IND_<X> expr _TK_RPAREN  _TK_NEWLINE
		  @{ DO_stmt_idx( P_<X> + Z80_<OP>( REG_idx ) ); }
	#endfor  <X>
	
		/* (hl) */
		| label? _TK_<OP> (_TK_A _TK_COMMA)? _TK_IND_HL _TK_NEWLINE
		  @{ DO_stmt( Z80_<OP>( REG_idx ) ); }

		/* N */
		| label? _TK_<OP> (_TK_A _TK_COMMA)? expr _TK_NEWLINE
		  @{ DO_stmt_n( Z80_<OP>_n ); }
#endfor  <OP>

		/*---------------------------------------------------------------------
		*   16-bit ALU
		*--------------------------------------------------------------------*/
#foreach <X> in HL, IX, IY
  #foreach <DD> in BC, DE, HL, SP
		| label? _TK_ADD _TK_<X> _TK_COMMA 
					#SUBST( _TK_<DD>, HL, <X> ) 
					_TK_NEWLINE
		  @{ DO_stmt( P_<X> + Z80_ADD16( REG_<DD> ) ); }
  #endfor  <DD>
#endfor  <X>

#foreach <OP> in SBC, ADC
  #foreach <DD> in BC, DE, HL, SP
		| label? _TK_<OP> _TK_HL _TK_COMMA _TK_<DD> _TK_NEWLINE
		  @{ DO_stmt( Z80_<OP>16( REG_<DD> ) ); }
  #endfor  <DD>
#endfor  <OP>

		/*---------------------------------------------------------------------
		*   INC / DEC
		*--------------------------------------------------------------------*/
#foreach <OP> in INC, DEC
	#foreach <R> in B, C, D, E, H, L, A
		| label? _TK_<OP> _TK_<R> _TK_NEWLINE
		  @{ DO_stmt( Z80_<OP>( REG_<R> ) ); }
	#endfor  <R>

	#foreach <X> in IX, IY
		#foreach <R> in L, H
		| label? _TK_<OP> _TK_<X><R> _TK_NEWLINE
		  @{ DO_stmt( P_<X> + Z80_<OP>( REG_<R> ) ); }
		#endfor  <R>
		
		/* (x) */
		| label? _TK_<OP>  
					_TK_IND_<X> _TK_RPAREN _TK_NEWLINE
		  @{ DO_stmt( ( P_<X> + Z80_<OP>( REG_idx ) ) << 8 ); }
			
		/* (x+d) */
		| label? _TK_<OP>  
					_TK_IND_<X> expr _TK_RPAREN _TK_NEWLINE
		  @{ DO_stmt_idx( P_<X> + Z80_<OP>( REG_idx ) ); }
	#endfor  <X>
	
		/* (hl) */
		| label? _TK_<OP> _TK_IND_HL _TK_NEWLINE
		  @{ DO_stmt( Z80_<OP>( REG_idx ) ); }

  #foreach <DD> in BC, DE, HL, SP, IX, IY
		| label? _TK_<OP> _TK_<DD> _TK_NEWLINE
		  @{ DO_stmt( P_<DD> + Z80_<OP>16( REG_<DD> ) ); }
  #endfor  <DD>
#endfor  <OP>

		/*---------------------------------------------------------------------
		*   Rotate and shift group
		*--------------------------------------------------------------------*/
#foreach <OP> in RLC, RRC, RL, RR, SLA, SRA, SLL, SRL
	#foreach <R> in B, C, D, E, H, L, A
		| label? _TK_<OP> _TK_<R> _TK_NEWLINE
		  @{ DO_stmt( Z80_<OP>( REG_<R> ) ); }
	#endfor  <R>

	#foreach <X> in IX, IY
		/* (x) */
		| label? _TK_<OP>  
					_TK_IND_<X> _TK_RPAREN _TK_NEWLINE
		  @{ DO_stmt( ((P_<X>               << 16) & 0xFF000000) +
					  ((Z80_<OP>( REG_idx ) << 8 ) & 0x00FF0000) +
					  ((0                   << 8 ) & 0x0000FF00) +
					  ((Z80_<OP>( REG_idx ) << 0 ) & 0x000000FF) ); }
			
		/* (x+d) */
		| label? _TK_<OP>  
					_TK_IND_<X> expr _TK_RPAREN _TK_NEWLINE
		  @{ DO_stmt_idx( ((P_<X> << 8) & 0xFF0000) + 
						  Z80_<OP>( REG_idx ) ); }
	#endfor  <X>
	
		/* (hl) */
		| label? _TK_<OP> _TK_IND_HL _TK_NEWLINE
		  @{ DO_stmt( Z80_<OP>( REG_idx ) ); }
#endfor  <OP>
		
		/*---------------------------------------------------------------------
		*   Bit Set, Reset and Test Group
		*--------------------------------------------------------------------*/
#foreach <OP> in BIT, SET, RES
	#foreach <R> in B, C, D, E, H, L, A
		| label? _TK_<OP> const_expr _TK_COMMA _TK_<R> _TK_NEWLINE
		  @{ if (!ctx->expr_error)
				DO_stmt( Z80_<OP>( ctx->expr_value, REG_<R> ) ); 
		  }
	#endfor  <R>
	
	#foreach <X> in IX, IY
		/* (x) */
		| label? _TK_<OP> const_expr _TK_COMMA  
					_TK_IND_<X> _TK_RPAREN _TK_NEWLINE
		  @{ if (!ctx->expr_error)
				DO_stmt( ((P_<X>                           << 16) & 0xFF000000) +
						 ((Z80_<OP>( ctx->expr_value, REG_idx ) << 8 ) & 0x00FF0000) +
						 ((0                               << 8 ) & 0x0000FF00) +
						 ((Z80_<OP>( ctx->expr_value, REG_idx ) << 0 ) & 0x000000FF) );
		   }
			
		/* (x+d) */
		| label? _TK_<OP> const_expr _TK_COMMA  
					_TK_IND_<X> expr _TK_RPAREN _TK_NEWLINE
		  @{ if (!ctx->expr_error)
				DO_stmt_idx( ((P_<X> << 8) & 0xFF0000) + 
						     Z80_<OP>( ctx->expr_value, REG_idx ) ); 
		  }
	#endfor  <X>
	
		/* (hl) */
		| label? _TK_<OP>  const_expr _TK_COMMA
					_TK_IND_HL _TK_NEWLINE
		  @{ if (!ctx->expr_error)
				DO_stmt( Z80_<OP>( ctx->expr_value, REG_idx ) ); 
		  }
#endfor  <OP>

		/*---------------------------------------------------------------------
		*   JP, JR, DJNZ, CALL, RET
		*--------------------------------------------------------------------*/
#foreach <OP> in JR, DJNZ
		| label? _TK_<OP> expr _TK_NEWLINE
		  @{ DO_stmt_jr( Z80_<OP> ); }
#endfor  <OP>

#foreach <OP> in JP, CALL
		| label? _TK_<OP> expr _TK_NEWLINE
		  @{ DO_stmt_nn( Z80_<OP> ); }
#endfor  <OP>

#foreach <FLAG> in NZ, Z, NC, C
		| label? _TK_JR _TK_<FLAG> _TK_COMMA expr _TK_NEWLINE
		  @{ DO_stmt_jr( Z80_JR_FLAG( FLAG_<FLAG> ) ); }
#endfor  <FLAG>

#foreach <FLAG> in NZ, Z, NC, C, PO, PE, P, M
		| label? _TK_JP _TK_<FLAG> _TK_COMMA expr _TK_NEWLINE
		  @{ DO_stmt_nn( Z80_JP_FLAG( FLAG_<FLAG> ) ); }

		| label? _TK_CALL _TK_<FLAG> _TK_COMMA expr _TK_NEWLINE
		  @{ DO_stmt_call_flag( <FLAG> ); }

		| label? _TK_RET _TK_<FLAG> _TK_NEWLINE
		  @{ DO_stmt( Z80_RET_FLAG( FLAG_<FLAG> ) ); }
#endfor  <FLAG>

		| label? _TK_JP _TK_IND_HL _TK_NEWLINE
		  @{ DO_stmt( Z80_JP_idx ); }
		
#foreach <X> in IX, IY
		| label? _TK_JP _TK_IND_<X> _TK_RPAREN _TK_NEWLINE
		  @{ DO_stmt( P_<X> + Z80_JP_idx ); }
#endfor  <X>

		/*---------------------------------------------------------------------
		*   IN, OUT
		*--------------------------------------------------------------------*/
#foreach <R> in B, C, D, E, H, L, A
		| label? _TK_IN _TK_<R> _TK_COMMA _TK_IND_C _TK_NEWLINE
		  @{ DO_stmt( Z80_IN_REG_C( REG_<R> ) ); }
		
		| label? _TK_OUT _TK_IND_C _TK_COMMA _TK_<R> _TK_NEWLINE 
		  @{ DO_stmt( Z80_OUT_C_REG( REG_<R> ) ); }
#endfor  <R>

		| label? _TK_IN _TK_A _TK_COMMA paren_expr _TK_NEWLINE
		  @{ DO_stmt_n( Z80_IN_A_n ); }
		
		| label? _TK_OUT paren_expr _TK_COMMA _TK_A _TK_NEWLINE 
		  @{ DO_stmt_n( Z80_OUT_n_A ); }

		/*---------------------------------------------------------------------
		*   opcodes without arguments
		*--------------------------------------------------------------------*/
#foreach <OP> in RLA, RLCA, RRA, RRCA, \
				 CPL, NEG, CCF, SCF, NOP, \
				 DAA, DI, EI, HALT, \
				 LDI, LDIR, LDD, LDDR, \
				 INI, INIR, IND, INDR, \
				 RET, RETN, RETI, \
				 OTDR, OTIR, OUTD, OUTI
		| label? _TK_<OP> _TK_NEWLINE
		  @{ DO_stmt( Z80_<OP> ); }
#endfor  <OP>		

		/*---------------------------------------------------------------------
		*   opcodes constant argument
		*--------------------------------------------------------------------*/
#foreach <OP> in IM, RST
		| label? _TK_<OP> const_expr _TK_NEWLINE
		  @{ if (!ctx->expr_error)
				DO_stmt( Z80_<OP>( ctx->expr_value ) );
		  }
#endfor  <OP>

		; /* end of main */
		
}%%

%%write data;

static Bool _parse_statement(ParseCtx *ctx, Bool compile_active)
{
	static Str  *name = NULL;		/* identifier name */
	static Str  *stmt_label = NULL;	/* statement label, NULL if none */
	int value1 = 0;
	int start_num_errors = get_num_errors();;

	INIT_OBJ(Str, &name); 		Str_clear(name);
	INIT_OBJ(Str, &stmt_label);	Str_clear(stmt_label);
	
	%%write init nocs;
	switch (ctx->current_sm)
	{
	case SM_MAIN:			ctx->cs = parser_en_main; break;
	case SM_DEFVARS_OPEN:	ctx->cs = parser_en_defvars_open;  scan_expect_operands(); break;
	case SM_DEFVARS_LINE:	ctx->cs = parser_en_defvars_line;  scan_expect_operands(); break;
	case SM_DEFGROUP_OPEN:	ctx->cs = parser_en_defgroup_open; scan_expect_operands(); break;
	case SM_DEFGROUP_LINE:	ctx->cs = parser_en_defgroup_line; scan_expect_operands(); break;
	default: assert(0);
	}
	
	ctx->p = ctx->pe = ctx->eof = ctx->expr_start = NULL;
	
	while ( ctx->eof == NULL || ctx->eof != ctx->pe )
	{
		read_token(ctx);
		
		%%write exec;

		/* Did parsing succeed? */
		if ( ctx->cs == %%{ write error; }%% )
			return FALSE;
		
		if ( ctx->cs >= %%{ write first_final; }%% )
			return TRUE;
			
		/* assembly error? must test after check for end of parse */
		if (get_num_errors() != start_num_errors) 
			break;
	}
	
	return FALSE;
}
