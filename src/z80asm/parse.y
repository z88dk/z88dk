%code top {
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

Copyright (C) Paulo Custodio, 2011-2013

Bison grammar for z80asm

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/parse.y,v 1.1 2013-05-01 19:03:46 pauloscustodio Exp $
$Log: parse.y,v $
Revision 1.1  2013-05-01 19:03:46  pauloscustodio
Simplified scanner and adapted to be used with a BISON generated parser.
Removed balanced struct checking and token ring.
Removed start condition to list assembly lines, as it was difficult to keep in sync across included
files; inserted an RS char in the input before each line to trigger listing.
Allow ".NAME" and "NAME:" to return a NAME token, so that ".LD" is recognized as a label and not the LD assembly statement.
Added Integer out of range warning to number scanning routine.
Allow input lines to be any size, as long as memory can be allocated.
Created a skeleton BISON parser.

Revision 1.1  2013/03/31 13:16:48  pauloscustodio
Embryo of parse module

*/
}

/*-----------------------------------------------------------------------------
*   Includes required
*----------------------------------------------------------------------------*/
%code requires {

#include "memalloc.h"   /* before any other include */

}

/*-----------------------------------------------------------------------------
*   Exported API
*----------------------------------------------------------------------------*/
%code provides {

extern int  yyparse();
extern void yyerror(const char *s);

}

/*-----------------------------------------------------------------------------
*   YYSTYPE
*----------------------------------------------------------------------------*/
%union {
	long 	lval;
	char   *sval;
}

/*-----------------------------------------------------------------------------
*   Keyword tokens
*----------------------------------------------------------------------------*/
%token IN LD NOP PUSH POP ADC JR JP
%token B C D E H L A BC DE HL AF SP NC NZ Z PO PE P M


/*-----------------------------------------------------------------------------
*   Terminal symbol tokens
*----------------------------------------------------------------------------*/
%token <lval> NUMBER
%token <sval> STRING
%token <sval> NAME

%token EQUAL_EQUAL
%token LESS_GREATER
%token NOT_EQUAL
%token LESS_EQUAL
%token GREATER_EQUAL
%token DBL_VBAR
%token DBL_AMPERSAND
%token DBL_LESS
%token DBL_GREATER
%token DBL_ASTERISK

/* output files */
%output  "parse.c"
%defines "parse.h"

/* no #line's */
%no-lines

%%
/*-----------------------------------------------------------------------------
*   Rules
*----------------------------------------------------------------------------*/


asm		:	lines 
		|	
		;
	
lines	:	lines line
		|		  line 
		;

line	:	NAME           ends
		|	NAME statement ends
		|		 statement ends
		;

statement:	NOP
		|	LD reg8 ',' reg8
		|	LD reg8 ',' expression
		|	IN A ',' '(' C ')'
		|	PUSH reg16af
		|	POP  reg16af
		|	ADC HL ',' reg16sp
		|	JR expression
		|	JR flags4 ',' expression
		|	JP expression
		|	JP flags8 ',' expression
		;

ends	:	':'  ends
		|	'\n' ends
		|	':'
		|	'\n'
		;
	
expression:	NUMBER

reg8	:	B | C | D | E | H | L | A ;
reg16af	:	BC | DE | HL | AF ;
reg16sp	:	BC | DE | HL | SP ;
flags4	:	NC | C | NZ | Z ;
flags8	:	flags4 | PO | PE | P | M ;

%%

/*-----------------------------------------------------------------------------
*   Support code
*----------------------------------------------------------------------------*/
void yyerror(const char *s) {
	printf("Parse error: %s\n", s );
	
	/* might as well halt now: */
	exit(-1);
}

