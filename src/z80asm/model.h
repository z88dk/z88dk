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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/model.h,v 1.17 2014-05-21 20:56:08 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */

#include "list.h"
#include "module.h"
#include "types.h"

/*-----------------------------------------------------------------------------
*   Symbol type bitmasks - bits 3 to 6 same as Expression type bitmasks
*----------------------------------------------------------------------------*/
#define SYM_DEFINED		1       	/* 00000001 symbol is defined */
#define SYM_TOUCHED		2       	/* 00000010 symbol was used, e.g. returned by 
									   a symbol table search */
#define SYM_DEFINE		4       	/* 00000100 DEFINE, -D
									   not output in sym list */

#define SYM_TYPE		120     	/* 01111000 */

#define SYM_ADDR		8       	/* 00001000 symbol is address */
#define SYM_LOCAL		16      	/* 00010000 symbol is local */
#define SYM_PUBLIC		32      	/* 00100000 symbol is PUBLIC */
#define SYM_EXTERN		64      	/* 01000000 symbol is EXTERN */

#define SYM_NOTDEFINED  0

/*-----------------------------------------------------------------------------
*   Expression expr_type bitmasks - bits 3 to 6 same as Symbol type bitmasks
*----------------------------------------------------------------------------*/
#define RANGE           7			/* 00000111 Range types are 0 - 4 */

#define RANGE_JROFFSET  0			/* relative jump argument */
#define RANGE_8UNSIGN   1			/* 8-bit immediate */
#define RANGE_8SIGN     2			/* (ix+d) */
#define RANGE_16CONST   3			/* 16-bit immediate */
#define RANGE_32SIGN    4			/* 32-bit immediate */

/* return 1, 2 or 4 for a expr_type */
#define RANGE_SIZE(x)	(((x) & RANGE) == RANGE_32SIGN  ? 4 : \
						 ((x) & RANGE) == RANGE_16CONST ? 2 : \
														  1 )

#define EXPR_ADDR		SYM_ADDR	/* 00001000 Expression contains reloc. address label */
#define EXPR_LOCAL		SYM_LOCAL  	/* 00010000 Expression contains local symbol */
#define EXPR_PUBLIC		SYM_PUBLIC 	/* 00100000 Expression contains global symbol */
#define EXPR_EXTERN		SYM_EXTERN	/* 01000000 Expression contains extern symbol */

#define NOT_EVALUABLE	128     	/* 10000000 Expression is not evaluable */

/*-----------------------------------------------------------------------------
*   Special symbols
*----------------------------------------------------------------------------*/
#define ASMHEAD_KW	"ASMHEAD"
#define ASMTAIL_KW	"ASMTAIL"
#define ASMSIZE_KW	"ASMSIZE"

/*-----------------------------------------------------------------------------
*   Initialize data structures
*----------------------------------------------------------------------------*/
extern void model_init(void);

/*-----------------------------------------------------------------------------
*   Singleton interfaces
*----------------------------------------------------------------------------*/

/* list of modules iterator, set CURRENTMODULE */
extern void module_list_first( void );
extern BOOL module_list_next( void );

/* delete all modules */
extern void delete_modules( void );

/* current module */
extern void		   set_curr_module( Module *module );
extern Module	  *get_curr_module( void );
extern Module	  *new_curr_module( void );
extern Module	  *get_first_module( void );
extern Module	  *get_last_module( void );

#define CURRENTMODULE	(get_curr_module())
#define CURRENTSECTION	(get_curr_module()->curr_section)

/* interface to SrcFile singleton */
extern void  src_open( char *filename, List *dir_list );
extern char *src_getline( void );
extern void  src_ungetline( char *lines );
extern char *src_filename( void );
extern int   src_line_nr( void );	

extern void  src_push( void );
extern BOOL  src_pop( void );

/*
* $Log: model.h,v $
* Revision 1.17  2014-05-21 20:56:08  pauloscustodio
* Move special symbols to model.h
*
* Revision 1.16  2014/05/18 16:05:28  pauloscustodio
* Add sections to the Module structure, define default section "".
* Move module expressions to the Section structure.
*
* Revision 1.15  2014/05/06 22:52:01  pauloscustodio
* Remove OS-dependent defines and dependency on ../config.h.
* Remove OS_ID constant from predefined defines in assembly.
*
* Revision 1.14  2014/05/02 21:00:49  pauloscustodio
* Hide module list, expose only iterators on CURRENTMODULE
*
* Revision 1.13  2014/05/02 20:24:38  pauloscustodio
* New class Module to replace struct module and struct modules
*
* Revision 1.12  2014/04/22 23:32:42  pauloscustodio
* Release 2.2.0 with major fixes:
*
* - Object file format changed to version 03, to include address of start
* of the opcode of each expression stored in the object file, to allow
* ASMPC to refer to the start of the opcode instead of the patch pointer.
* This solves long standing BUG_0011 and BUG_0048.
*
* - ASMPC no longer stored in the symbol table and evaluated as a separate
* token, to allow expressions including ASMPC to be relocated. This solves
* long standing and never detected BUG_0047.
*
* - Handling ASMPC during assembly simplified - no need to call inc_PC() on
* every assembled instruction, no need to store list of JRPC addresses as
* ASMPC is now stored in the expression.
*
* BUG_0047: Expressions including ASMPC not relocated - impacts call po|pe|p|m emulation in RCMX000
* ASMPC is computed on zero-base address of the code section and expressions
* including ASMPC are not relocated at link time.
* "call po, xx" is emulated in --RCMX000 as "jp pe, ASMPC+3; call xx".
* The expression ASMPC+3 is not marked as relocateable, and the resulting
* code only works when linked at address 0.
*
* BUG_0048: ASMPC used in JP/CALL argument does not refer to start of statement
* In "JP ASMPC", ASMPC is coded as instruction-address + 1 instead
* of instruction-address.
*
* BUG_0011 : ASMPC should refer to start of statememnt, not current element in DEFB/DEFW
* Bug only happens with forward references to relative addresses in expressions.
* See example from zx48.asm ROM image in t/BUG_0011.t test file.
* Need to change object file format to correct - need patchptr and address of instruction start.
*
* Revision 1.11  2014/04/13 20:32:06  pauloscustodio
* PUBLIC and EXTERN instead of LIB, XREF, XDEF, XLIB
*
* Revision 1.10  2014/04/13 11:54:01  pauloscustodio
* CH_0025: PUBLIC and EXTERN instead of LIB, XREF, XDEF, XLIB
* Use new keywords PUBLIC and EXTERN, make the old ones synonyms.
* Remove 'X' scope for symbols in object files used before for XLIB -
* all PUBLIC symbols have scope 'G'.
* Remove SDCC hack on object files trating XLIB and XDEF the same.
* Created a warning to say XDEF et.al. are deprecated, but for the
* momment keep it commented.
*
* Revision 1.9  2014/03/15 14:35:51  pauloscustodio
* Add interface to lookup current file name and line number
*
* Revision 1.8  2014/03/03 13:43:50  pauloscustodio
* Renamed symbol and expression type attributes
*
* Revision 1.7  2014/03/03 13:27:07  pauloscustodio
* Rename symbol type constants
*
* Revision 1.6  2014/02/17 23:10:39  pauloscustodio
* Define EXPR_ADDR as SYM_ADDR, ...
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
