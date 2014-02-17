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

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2014

Global data model.

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/model.h,v 1.6 2014-02-17 23:10:39 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */

#include "list.h"
#include "types.h"

/*-----------------------------------------------------------------------------
*   Symbol type bitmasks - bits 3 to 6 same as Expression type bitmasks
*----------------------------------------------------------------------------*/
#define SYMDEFINED      1       	/* 00000001 symbol is defined */
#define SYMTOUCHED      2       	/* 00000010 symbol was used, e.g. returned by 
									   a symbol table search */
#define SYMDEF          4       	/* 00000100 DEFINE, -D, ASMPC, OS_ID, LIB, XLIB, 
									   global library; not output in sym list */
#define SYMADDR         8       	/* 00001000 symbol is address */
#define SYMLOCAL        16      	/* 00010000 symbol is local */
#define SYMXDEF         32      	/* 00100000 symbol is global (SYMXDEF) 
									   or global library (SYMXDEF|SYMDEF) */
#define SYMXREF         64      	/* 01000000 symbol is external (SYMXREF) 
									   or external library (SYMXREF|SYMDEF) */

#define XDEF_OFF        223     	/* 11011111 */
#define XREF_OFF        191     	/* 10111111 */
#define SYMLOCAL_OFF    239     	/* 11101111 */
#define SYMTYPE         120     	/* 01111000 */
#define SYM_NOTDEFINED  0

/*-----------------------------------------------------------------------------
*   Expression rangetype bitmasks - bits 3 to 6 same as Symbol type bitmasks
*----------------------------------------------------------------------------*/
#define RANGE           7			/* 00000111 Range types are 0 - 4 */
#define EXPRADDR        SYMADDR		/* 00001000 Expression contains reloc. address label */
#define EXPRLOCAL       SYMLOCAL   	/* 00010000 Expression contains local symbol */
#define EXPRGLOBAL      SYMXDEF    	/* 00100000 Expression contains global symbol */
#define EXPREXTERN      SYMXREF    	/* 01000000 Expression contains extern symbol */
#define NOTEVALUABLE    128     	/* 10000000 Expression is not evaluable */
#define EVALUATED       127     	/* 01111111 Expression is evaluated */
#define CLEAR_EXPRADDR  247     	/* 11110111 Convert to constant expression */

#define RANGE_JROFFSET  0			/* relative jump argument */
#define RANGE_8UNSIGN   1			/* 8-bit immediate */
#define RANGE_8SIGN     2			/* (ix+d) */
#define RANGE_16CONST   3			/* 16-bit immediate */
#define RANGE_32SIGN    4			/* 32-bit immediate */

/* return 1, 2 or 4 for a rangetype */
#define RANGE_SIZE(x)	(((x) & RANGE) == RANGE_32SIGN  ? 4 : \
						 ((x) & RANGE) == RANGE_16CONST ? 2 : \
														  1 )

/*-----------------------------------------------------------------------------
*   Initialize data structures
*----------------------------------------------------------------------------*/
extern void model_init(void);

/*-----------------------------------------------------------------------------
*   Singleton interfaces
*----------------------------------------------------------------------------*/

/* interface to SrcFile singleton */
extern void  src_open( char *filename, List *dir_list );
extern char *src_getline( void );
extern void  src_ungetline( char *lines );
extern void  src_push( void );
extern BOOL  src_pop( void );

/*
* $Log: model.h,v $
* Revision 1.6  2014-02-17 23:10:39  pauloscustodio
* Define EXPRADDR as SYMADDR, ...
*
* Revision 1.5  2014/02/17 22:48:28  pauloscustodio
* Symbol types and Expression types need to be in sync
* Move from sym.h and symbol.h to model.h
*
* Revision 1.4  2014/02/08 18:30:49  pauloscustodio
* lib/srcfile.c to read source files and handle recursive includes,
* used to read @lists, removed opts.files;
* model.c to hold global data model
*
*
*/
