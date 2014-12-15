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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/parse_rules.rl,v 1.3 2014-12-15 22:48:41 pauloscustodio Exp $ 
*/

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
	prepush {
		utarray_reserve(state_stack, 1);
		stack = (int *)utarray_front(state_stack);
	}

	/* label */
	label = _TK_LABEL 		@{ stmt_label = p->string; };
	
	/* assembly statement */
	main := _TK_END
		|	_TK_NEWLINE
		|	label             . _TK_NEWLINE		@{ ADD_LABEL; }
		|	label? . _TK_HALT . _TK_NEWLINE		@{ ADD_OPCODE(Z80_HALT); }
		|	label? . _TK_NOP  . _TK_NEWLINE		@{ ADD_OPCODE(Z80_NOP); }
		;

}%%

%%write data;

static Bool _parse_statement(Bool compile_active)
{
	p = (Sym *)utarray_front(tokens);
	pe = eof = (Sym *)utarray_back(tokens) + 1;
	
	%%write init;
	
	%%write exec;
	
	/* Did parsing succeed? */
	if ( cs < %%{ write first_final; }%% )
		return FALSE;

	return TRUE;
}
