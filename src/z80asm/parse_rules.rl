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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/parse_rules.rl,v 1.5 2014-12-19 00:59:48 pauloscustodio Exp $ 
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
			  expr %{ expr_value = pop_eval_expr(); };
	
	/* assembly statement */
	main := _TK_END
		|	_TK_NEWLINE
		|	label           _TK_NEWLINE		@{ ADD_LABEL; }
		|	label? _TK_EXX  _TK_NEWLINE		@{ ADD_OPCODE(Z80_EXX); }
		|	label? _TK_HALT _TK_NEWLINE		@{ ADD_OPCODE(Z80_HALT); }
		|	label? _TK_IM   const_expr _TK_NEWLINE
											@{ ADD_OPCODE(Z80_IM(expr_value)); }
		|	label? _TK_NOP  _TK_NEWLINE		@{ ADD_OPCODE(Z80_NOP); }
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
