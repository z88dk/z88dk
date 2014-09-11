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

One symbol from the assembly code - label or constant.

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/sym.h,v 1.24 2014-09-11 22:28:35 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */

#include "class.h"
#include "symref.h"
#include "types.h"

struct Module;
struct Section;

/*-----------------------------------------------------------------------------
*   Type of symbol
*	Expressions have the type of the greatest symbol used
*----------------------------------------------------------------------------*/
typedef enum {
	TYPE_UNKNOWN,						/* symbol not defined */
	TYPE_CONSTANT,						/* can be computed */
	TYPE_ADDRESS,						/* depends on ASMPC, can be computed after
										   address allocation */
	TYPE_COMPUTED,						/* depends on the result of an expression
										   that has this symbol as target */
} sym_type_t;

/*-----------------------------------------------------------------------------
*   Symbol
*----------------------------------------------------------------------------*/
CLASS( Symbol )
	char		   *name;				/* name, kept in strpool */
	long			value;				/* computed value of symbol */
	sym_type_t		sym_type;			/* type of symbol */
	Bool			computed;			/* TRUE if TYPE_COMPUTED or TYPE_ADDRESS 
										   and value already known */

	Byte			sym_type_mask;		/* type of symbol */
	struct Module  *module;				/* module which owns symbol (weak ref) */
	struct Section *section;			/* section where expression is defined (weak ref) */
	SymbolRefList  *references;			/* pointer to all found references of symbol */
END_CLASS;

/*-----------------------------------------------------------------------------
*   Symbol API
*----------------------------------------------------------------------------*/

/* create a new symbol, needs to be deleted by OBJ_DELETE()
   adds a reference to the page were referred to */
extern Symbol *Symbol_create( char *name, long value, sym_type_t sym_type, Byte type_mask, 
							  struct Module *module, struct Section *section );

/* return full symbol name NAME@MODULE stored in strpool */
extern char *Symbol_fullname( Symbol *sym );
