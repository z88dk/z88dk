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
Copyright (C) Paulo Custodio, 2011-2013

One symbol from the assembly code - label or constant.

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/sym.h,v 1.1 2013-05-16 23:39:48 pauloscustodio Exp $
$Log: sym.h,v $
Revision 1.1  2013-05-16 23:39:48  pauloscustodio
Move struct node to sym.c, rename to Symbol
Move SymbolRef to symref.c


*/

#ifndef SYM_H
#define SYM_H

#include "memalloc.h"   /* before any other include */

#include "class.h"
#include "symbol.h"
#include "symref.h"
#include "types.h"

/*-----------------------------------------------------------------------------
*   Symbol
*----------------------------------------------------------------------------*/
CLASS( Symbol )
	char		   *name;				/* name, kept in strpool */
	long			value;				/* computed value of symbol */
    byte_t			type;				/* type of symbol  */
    SymbolRefList  *references;			/* pointer to all found references of symbol */
    struct module  *owner;				/* week pointer to module which owns symbol */
END_CLASS;

/*-----------------------------------------------------------------------------
*   Symbol type bitmasks
*----------------------------------------------------------------------------*/
#define SYMDEFINED      1       /* bitmask 00000001 */	/* symbol is defined */
#define SYMTOUCHED      2       /* bitmask 00000010 */	/* symbol was used, e.g. returned by a symbol table search */
#define SYMDEF          4       /* bitmask 00000100 */	/* DEFINE, -D, ASMPC, OS_ID, LIB, XLIB, global library; not output in sym list */
#define SYMADDR         8       /* bitmask 00001000 */	/* symbol is address */
#define SYMLOCAL        16      /* bitmask 00010000 */	/* symbol is local */
#define SYMXDEF         32      /* bitmask 00100000 */	/* symbol is global (SYMXDEF) or global library (SYMXDEF|SYMDEF) */
#define SYMXREF         64      /* bitmask 01000000 */	/* symbol is external (SYMXREF) or external library (SYMXREF|SYMDEF) */

#define XDEF_OFF        223     /* bitmask 11011111 */
#define XREF_OFF        191     /* bitmask 10111111 */
#define SYMLOCAL_OFF    239     /* bitmask 11101111 */
#define SYMTYPE         120     /* bitmask 01111000 */
#define SYM_NOTDEFINED  0		

/* OLD, to be deleted */
typedef struct node
{
    byte_t				type;				/* type of symbol  */
    char				*symname;			/* pointer to symbol identifier */
    long				symvalue;			/* value of symbol */
    SymbolRefList		*references;		/* pointer to all found references of symbol */
    struct module		*owner;				/* pointer to module which ownes symbol */
} symbol;

#endif /* ndef SYM_H */

