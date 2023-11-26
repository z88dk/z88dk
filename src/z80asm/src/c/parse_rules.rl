/*
Z88DK Z80 Macro Assembler

Copyright (C) Paulo Custodio, 2011-2023
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

Define rules for a ragel-based parser.
*/

#define NO_TOKEN_ENUM
#include "tokens.h"

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
	variable eof ctx->eof_;

	/* label, name */
	label  = _TK_LABEL  @{ Str_set_n(stmt_label, ctx->p->tstart, ctx->p->tlen); };
	name   = _TK_NAME   @{ Str_set_n(name, ctx->p->tstart, ctx->p->tlen); };
	string = _TK_STRING @{ Str_set_bytes(name, ctx->p->tstart, ctx->p->tlen); };

	/*---------------------------------------------------------------------
	*   Expression
	*--------------------------------------------------------------------*/
	action parens_open {
		expr_open_parens > 0
	}

	lparen = (_TK_LPAREN | _TK_LSQUARE)
			>{ expr_open_parens++; };
	rparen = (_TK_RPAREN | _TK_RSQUARE) when parens_open
			%{ expr_open_parens--; };

	unary 	= _TK_MINUS | _TK_PLUS |
			  _TK_BIN_NOT |
			  _TK_LOG_NOT;

	binary 	= _TK_QUESTION | _TK_COLON |
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

	expr1 	= term ( binary term )**;

	action expr_start_action {
		ctx->expr_start = ctx->p;
		expr_open_parens = 0;
	}

	/* expression */
	expr 	= expr1
			  >expr_start_action
			  %{ ctx->expr_in_parens = check_expr_in_parens(ctx->expr_start, ctx->p);
			     push_expr(ctx); };

	const_expr =
			  expr %{ pop_eval_expr(ctx, &ctx->expr_value, &ctx->expr_error); };

	/*---------------------------------------------------------------------
	*   DEFGROUP
	*--------------------------------------------------------------------*/
	defgroup_var_value =
		  name _TK_EQUAL const_expr
		  %{ if (ctx->expr_error)
				error_expected_const_expr();
			else {
				asm_DEFGROUP_start(ctx->expr_value);
				asm_DEFGROUP_define_const(Str_data(name));
			}
		  };

	defgroup_var_next =
		  name
		  %{ asm_DEFGROUP_define_const(Str_data(name)); }
		;

	defgroup_var = defgroup_var_value | defgroup_var_next;

	defgroup_vars = defgroup_var (_TK_COMMA defgroup_var)* _TK_COMMA? ;

	asm_DEFGROUP =
		  _TK_DEFGROUP _TK_NEWLINE		  		@{ asm_DEFGROUP_start(0);
												   ctx->current_sm = SM_DEFGROUP_OPEN; }
		| _TK_DEFGROUP _TK_LCURLY _TK_NEWLINE	@{ asm_DEFGROUP_start(0);
												   ctx->current_sm = SM_DEFGROUP_LINE; }
		| _TK_DEFGROUP _TK_LCURLY
												@{ asm_DEFGROUP_start(0);
												   ctx->current_sm = SM_DEFGROUP_LINE; }
		  defgroup_vars _TK_NEWLINE
		| _TK_DEFGROUP _TK_LCURLY
												@{ asm_DEFGROUP_start(0);
												   ctx->current_sm = SM_DEFGROUP_LINE; }
		  defgroup_vars
		  _TK_RCURLY _TK_NEWLINE			    @{ ctx->current_sm = SM_MAIN; }
		;

	defgroup_open :=
		  _TK_NEWLINE
		| _TK_END 								@{ error_missing_block(); }
		| _TK_LCURLY _TK_NEWLINE 				@{ ctx->current_sm = SM_DEFGROUP_LINE; }
		| _TK_LCURLY 			 				@{ ctx->current_sm = SM_DEFGROUP_LINE; }
		  defgroup_vars _TK_NEWLINE
		| _TK_LCURLY 			 				@{ ctx->current_sm = SM_DEFGROUP_LINE; }
		  defgroup_vars
		  _TK_RCURLY _TK_NEWLINE				@{ ctx->current_sm = SM_MAIN; }
		;

	defgroup_line :=
		  _TK_NEWLINE
		| _TK_END 								@{ error_missing_close_block(); }
		| _TK_RCURLY _TK_NEWLINE				@{ ctx->current_sm = SM_MAIN; }
		| defgroup_vars _TK_NEWLINE
		| defgroup_vars
		  _TK_RCURLY _TK_NEWLINE				@{ ctx->current_sm = SM_MAIN; }
		;

	/*---------------------------------------------------------------------
	*   DEFVARS
	*--------------------------------------------------------------------*/
	defvars_define =
			name _TK_NEWLINE				@{ 	asm_DEFVARS_define_const( Str_data(name), 0, 0 ); }
		|	name _TK_RCURLY _TK_NEWLINE		@{ 	asm_DEFVARS_define_const( Str_data(name), 0, 0 );
												ctx->current_sm = SM_MAIN; }
#foreach <S> in B, W, P, Q
		|	name _TK_DS_<S> const_expr _TK_NEWLINE
											@{ 	if (ctx->expr_error)
													error_expected_const_expr();
												else
													asm_DEFVARS_define_const( Str_data(name),
																			  DEFVARS_SIZE_<S>,
																			  ctx->expr_value );
											}
#endfor  <S>
#foreach <S> in B, W, P, Q
		|	name _TK_DS_<S> const_expr _TK_RCURLY _TK_NEWLINE
											@{ 	if (ctx->expr_error)
													error_expected_const_expr();
												else
													asm_DEFVARS_define_const( Str_data(name),
																			  DEFVARS_SIZE_<S>,
																			  ctx->expr_value );
												ctx->current_sm = SM_MAIN;
											}
#endfor  <S>
		;

	asm_DEFVARS =
		  _TK_DEFVARS const_expr _TK_NEWLINE
											@{ 	if (ctx->expr_error)
													error_expected_const_expr();
												else
													asm_DEFVARS_start(ctx->expr_value);
												ctx->current_sm = SM_DEFVARS_OPEN;
											}
		| _TK_DEFVARS const_expr _TK_LCURLY _TK_NEWLINE
											@{ 	if (ctx->expr_error)
													error_expected_const_expr();
												else
													asm_DEFVARS_start(ctx->expr_value);
												ctx->current_sm = SM_DEFVARS_LINE;
											}
		| _TK_DEFVARS const_expr _TK_LCURLY
											@{ 	if (ctx->expr_error)
													error_expected_const_expr();
												else
													asm_DEFVARS_start(ctx->expr_value);
												ctx->current_sm = SM_DEFVARS_LINE;
											}
		  defvars_define
		;

	defvars_open :=
		  _TK_NEWLINE
		| _TK_END 							@{ error_missing_block(); }
		| _TK_LCURLY _TK_NEWLINE 			@{ ctx->current_sm = SM_DEFVARS_LINE; }
		| _TK_LCURLY 			 			@{ ctx->current_sm = SM_DEFVARS_LINE; }
		  defvars_define
		;

	defvars_line :=
		  _TK_NEWLINE
		| _TK_END 							@{ error_missing_close_block(); }
		| _TK_RCURLY _TK_NEWLINE			@{ ctx->current_sm = SM_MAIN; }
		| defvars_define
		;

	/*---------------------------------------------------------------------
	*   DEFS
	*--------------------------------------------------------------------*/
	asm_DEFS =
		  label? (_TK_DEFS | _TK_DS) const_expr _TK_NEWLINE
		  @{ DO_STMT_LABEL();
		     if (ctx->expr_error)
				error_expected_const_expr();
			 else
				asm_DEFS(ctx->expr_value, option_filler()); }
		| label? (_TK_DEFS | _TK_DS)
				const_expr _TK_COMMA
				@{ if (ctx->expr_error)
					  error_expected_const_expr();
			       value1 = ctx->expr_error ? 0 : ctx->expr_value;
				   ctx->expr_error = false;
				}
				const_expr _TK_NEWLINE
		  @{ DO_STMT_LABEL();
		     if (ctx->expr_error)
				error_expected_const_expr();
			 else
				asm_DEFS(value1, ctx->expr_value); }
		| label? (_TK_DEFS | _TK_DS)
				const_expr _TK_COMMA
				@{ if (ctx->expr_error)
					  error_expected_const_expr();
			       value1 = ctx->expr_error ? 0 : ctx->expr_value;
				   ctx->expr_error = false;
				}
				string _TK_NEWLINE
		  @{ DO_STMT_LABEL();
			 Str_len(name) = str_compress_escapes(Str_data(name));
			 asm_DEFS_str(value1, Str_data(name), (int)Str_len(name)); }
		;

	/*---------------------------------------------------------------------
	*   BYTE / DEFB / DEFM / DB / DM
	*--------------------------------------------------------------------*/
	asm_DEFB_iter =
			asm_DEFB_next:
			(
				string (_TK_COMMA | _TK_NEWLINE)
				@{	DO_STMT_LABEL();
					Str_len(name) = str_compress_escapes(Str_data(name));
					asm_DEFB_str(Str_data(name), (int)Str_len(name));
					if ( ctx->p->tok == TK_COMMA )
						fgoto asm_DEFB_next;
				}
			|	expr (_TK_COMMA | _TK_NEWLINE)
				@{	DO_STMT_LABEL();
					asm_DEFB_expr(pop_expr(ctx));
					if ( ctx->p->tok == TK_COMMA )
						fgoto asm_DEFB_next;
				}
			);
	asm_DEFB = 	label?
				(_TK_BYTE | _TK_DEFB | _TK_DEFM | _TK_DB | _TK_DM)
				asm_DEFB_iter;

	/*---------------------------------------------------------------------
	*   DEFW / DEFQ / DEFDB
	*--------------------------------------------------------------------*/
#foreach <OP> in DEFW, DW, WORD, DEFQ, DQ, DWORD, DEFDB, DDB, DEFP, PTR, DP
	asm_<OP>_iter =
			asm_<OP>_next:
				expr (_TK_COMMA | _TK_NEWLINE)
				@{	DO_STMT_LABEL();
					asm_<OP>(pop_expr(ctx));
					if ( ctx->p->tok == TK_COMMA )
						fgoto asm_<OP>_next;
				}
			;
	asm_<OP> = 	label? _TK_<OP>	asm_<OP>_iter;
#endfor  <OP>

	directives_DEFx =
		asm_DEFS | asm_DEFB |
		asm_DEFW | asm_DW | asm_WORD |
		asm_DEFQ | asm_DQ | asm_DWORD |
		asm_DEFDB | asm_DDB |
		asm_DEFP | asm_PTR | asm_DP;

	/*---------------------------------------------------------------------
	*   directives without arguments
	*--------------------------------------------------------------------*/
#foreach <OP> in LSTON, LSTOFF
	asm_<OP> = _TK_<OP> _TK_NEWLINE @{ asm_<OP>(); };
#endfor  <OP>
	directives_no_args = asm_LSTON | asm_LSTOFF;

	/*---------------------------------------------------------------------
	*   directives with NAME argument
	*--------------------------------------------------------------------*/
#foreach <OP> in MODULE, SECTION
	asm_<OP> = _TK_<OP> name _TK_NEWLINE
			   @{ asm_<OP>(Str_data(name)); }
#foreach <KW> in A,AF,B,BC,C,D,DE,E,EIR,F,H,HL,I,IIR,IP,IX,IXH,IXL,IY,IYH,IYL,L,M,R,SP,SU,XPC
			 | _TK_<OP> _TK_<KW> _TK_NEWLINE
			   @{ asm_<OP>(sym_text(&ctx->p[-1])); }
#endfor <KW>
			 ;
#endfor <OP>
	directives_name = asm_MODULE | asm_SECTION;

	/*---------------------------------------------------------------------
	*   directives with list of names argument, function called for each
	*	argument
	*--------------------------------------------------------------------*/
#foreach <OP> in GLOBAL, PUBLIC, EXTERN, DEFINE, UNDEFINE, XDEF, XLIB, XREF, LIB
	action <OP>_action { asm_<OP>(Str_data(name)); }

	asm_<OP> = _TK_<OP> name @<OP>_action
		    ( _TK_COMMA name @<OP>_action )*
		    _TK_NEWLINE ;
#endfor  <OP>
	directives_names = asm_GLOBAL | asm_PUBLIC | asm_EXTERN |
					   asm_DEFINE | asm_UNDEFINE |
					   asm_XDEF | asm_XLIB | asm_XREF | asm_LIB;

	/*---------------------------------------------------------------------
	*   DEFC, DC, EQU, =
	*--------------------------------------------------------------------*/
#foreach <OP> in DEFC, DC
	asm_<OP>_iter =
			asm_<OP>_next:
				name _TK_EQUAL expr (_TK_COMMA | _TK_NEWLINE)
				@{	DO_STMT_LABEL();
					asm_DEFC(Str_data(name), pop_expr(ctx));
					if ( ctx->p->tok == TK_COMMA )
						fgoto asm_<OP>_next;
				};
	asm_<OP> = label? _TK_<OP> asm_<OP>_iter ;
#endfor  <OP>

	asm_EQU = name (_TK_EQU | _TK_EQUAL) expr _TK_NEWLINE
				@{	asm_DEFC(Str_data(name), pop_expr(ctx)); }
			| label (_TK_EQU | _TK_EQUAL) expr _TK_NEWLINE
				@{	asm_DEFC(Str_data(stmt_label), pop_expr(ctx)); }
			;
	
	directives_assign = asm_DEFC | asm_DC | asm_EQU;

	/*---------------------------------------------------------------------
	*   Z88DK specific opcodes
	*--------------------------------------------------------------------*/
#foreach <OP> in CALL_OZ, CALL_PKG, FPP, INVOKE
	asm_<OP> = label? _TK_<OP> const_expr _TK_NEWLINE
			@{	DO_STMT_LABEL();
			    if (ctx->expr_error)
				    error_expected_const_expr();
			    else
					add_Z88_<OP>(ctx->expr_value);
			};
#endfor  <OP>
	asm_Z88DK = asm_CALL_OZ | asm_CALL_PKG | asm_FPP | asm_INVOKE;

	/*---------------------------------------------------------------------
	*   ZXN DMA
	*--------------------------------------------------------------------*/
#define DEFINE_DMA_WR(N, TOKEN)												\
			label? TOKEN expr ( _TK_COMMA expr )* _TK_NEWLINE @{			\
				DO_STMT_LABEL(); 											\
				asm_DMA_command(N, ctx->exprs);								\
			}																\
		|	label? TOKEN expr ( _TK_COMMA expr )* _TK_COMMA _TK_NEWLINE @{ 	\
				DO_STMT_LABEL(); 											\
				ctx->dma_cmd = N;											\
				ctx->current_sm = SM_DMA_PARAMS;							\
			}

	asm_DMA =	DEFINE_DMA_WR(0, _TK_DMA_WR0)
			|	DEFINE_DMA_WR(1, _TK_DMA_WR1)
			|	DEFINE_DMA_WR(2, _TK_DMA_WR2)
			|	DEFINE_DMA_WR(3, _TK_DMA_WR3)
			|	DEFINE_DMA_WR(4, _TK_DMA_WR4)
			|	DEFINE_DMA_WR(5, _TK_DMA_WR5)
			|	DEFINE_DMA_WR(6, _TK_DMA_WR6)
			|	DEFINE_DMA_WR(6, _TK_DMA_CMD)
			;

	dma_params :=
			expr ( _TK_COMMA expr )* _TK_NEWLINE @{
				asm_DMA_command(ctx->dma_cmd, ctx->exprs);
				ctx->current_sm = SM_MAIN;
			}
		|	expr ( _TK_COMMA expr )* _TK_COMMA _TK_NEWLINE
		;

	/*---------------------------------------------------------------------
	*   assembly statement
	*--------------------------------------------------------------------*/
	main :=
		  _TK_END
		| _TK_NEWLINE
		| directives_no_args
		| directives_name | directives_names | directives_assign
		| directives_DEFx
		| asm_Z88DK
		| asm_DEFGROUP
		| asm_DEFVARS
		| asm_DMA
		/*---------------------------------------------------------------------
		*   Directives
		*--------------------------------------------------------------------*/
		| label? _TK_ASSERT const_expr _TK_NEWLINE @{
			DO_STMT_LABEL();
			if (ctx->expr_error)
				error_expected_const_expr();
			else if (ctx->expr_value == 0)
				error_assert_failed();
			else 
				; 
		}
		| label? _TK_ALIGN const_expr _TK_NEWLINE @{
		    DO_STMT_LABEL();
			if (ctx->expr_error)
				error_expected_const_expr();
			else
				asm_ALIGN(ctx->expr_value, option_filler());
		}
		| label? _TK_ALIGN const_expr _TK_COMMA
				@{ if (ctx->expr_error)
					   error_expected_const_expr();
				   value1 = ctx->expr_error ? 0 : ctx->expr_value;
				   ctx->expr_error = false;
				}
				const_expr _TK_NEWLINE @{
			DO_STMT_LABEL();
		    if (ctx->expr_error)
				error_expected_const_expr();
			else
				asm_ALIGN(value1, ctx->expr_value);
		}

		| _TK_ORG const_expr _TK_NEWLINE @{
			if (ctx->expr_error)
				error_expected_const_expr();
			else
				asm_ORG(ctx->expr_value);
		}

		| _TK_PHASE const_expr _TK_NEWLINE @{
			if (ctx->expr_error)
				error_expected_const_expr();
			else
				asm_PHASE(ctx->expr_value);
		}

		| _TK_DEPHASE _TK_NEWLINE @{
			asm_DEPHASE();
		}

		/*---------------------------------------------------------------------
		*   Z80 assembly
		*--------------------------------------------------------------------*/
		| label _TK_NEWLINE @{ DO_STMT_LABEL(); }

#include "cpu_rules.h"

		/*---------------------------------------------------------------------
		*   ZXN Copper Unit
		*--------------------------------------------------------------------*/
		| label? _TK_CU_WAIT expr _TK_COMMA	expr _TK_NEWLINE @{
			DO_STMT_LABEL();
			Expr1 *hor = pop_expr(ctx);
			Expr1 *ver = pop_expr(ctx);
			add_copper_unit_wait(ver, hor);
		}

		| label? _TK_CU_MOVE expr _TK_COMMA expr _TK_NEWLINE @{
			DO_STMT_LABEL();
			Expr1 *val = pop_expr(ctx);
			Expr1 *reg = pop_expr(ctx);
			add_copper_unit_move(reg, val);
		}

		| label? _TK_CU_STOP _TK_NEWLINE @{
			DO_STMT_LABEL();
			add_copper_unit_stop();
		}

		| label? _TK_CU_NOP _TK_NEWLINE @{
			DO_STMT_LABEL();
			add_copper_unit_nop();
		}

		/*---------------------------------------------------------------------
		*   ez80
		*--------------------------------------------------------------------*/

		| _TK_ASSUME _TK_ADL _TK_EQUAL const_expr _TK_NEWLINE @{
			if (option_cpu() != CPU_EZ80 && option_cpu() != CPU_EZ80_Z80)
				error_illegal_ident();
			else if (ctx->expr_error)
				error_expected_const_expr();
            else {
                switch (ctx->expr_value) {
                case 0: set_cpu_option(CPU_EZ80_Z80); break;
                case 1: set_cpu_option(CPU_EZ80); break;
                default: error_int_range(ctx->expr_value);
                }
            }
		}

		;

}%%

%%write data;

static int get_start_state(ParseCtx *ctx)
{
	switch (ctx->current_sm)
	{
	case SM_MAIN:
		return parser_en_main;

	case SM_DEFVARS_OPEN:
		scan_expect_operands();
		return parser_en_defvars_open;

	case SM_DEFVARS_LINE:
		scan_expect_operands();
		return parser_en_defvars_line;

	case SM_DEFGROUP_OPEN:
		scan_expect_operands();
		return parser_en_defgroup_open;

	case SM_DEFGROUP_LINE:
		scan_expect_operands();
		return parser_en_defgroup_line;

	case SM_DMA_PARAMS:
		scan_expect_operands();
		return parser_en_dma_params;

	default:
		xassert(0);
	}

	return 0;	/* not reached */
}

static bool _parse_statement_1(ParseCtx *ctx, Str *name, Str *stmt_label)
{
	int  value1 = 0;
	int  start_num_errors = get_num_errors();
	ctx->expr_value = 0;			/* last computed expression value */
	ctx->expr_error = false;		/* last computed expression error */
	ctx->expr_in_parens = false;	/* true if expression has enclosing parens */
	int  expr_open_parens = 0;		/* number of open parens */

	%%write init nocs;

	ctx->cs = get_start_state(ctx);
	ctx->p = ctx->pe = ctx->eof_ = ctx->expr_start = NULL;

	while ( ctx->eof_ == NULL || ctx->eof_ != ctx->pe )
	{
		read_token(ctx);

		%%write exec;

		/* Did parsing succeed? */
		if ( ctx->cs == %%{ write error; }%% )
			return false;

		if ( ctx->cs >= %%{ write first_final; }%% )
			return true;

		/* assembly error? must test after check for end of parse */
		if (get_num_errors() != start_num_errors)
			break;
	}

	return false;
}

static bool _parse_statement(ParseCtx *ctx)
{
	STR_DEFINE(name, STR_SIZE);			/* identifier name */
	STR_DEFINE(stmt_label, STR_SIZE);	/* statement label, NULL if none */

	bool ret = _parse_statement_1(ctx, name, stmt_label);

	STR_DELETE(name);
	STR_DELETE(stmt_label);

	return ret;
}
