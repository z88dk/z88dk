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

Symbol table
Replaced avltree from original assembler by hash table because:
a) code simplicity
b) performance - avltree 50% slower when loading the symbols from the ZX 48 ROM assembly,
   see t\developer\benchmark_symtab.t

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/symtab.h,v 1.3 2013-06-08 23:07:53 pauloscustodio Exp $
$Log: symtab.h,v $
Revision 1.3  2013-06-08 23:07:53  pauloscustodio
Add global ASMPC Symbol pointer, to avoid "ASMPC" symbol table lookup on every instruction.
Encapsulate get_global_tab() and get_static_tab() by using new functions define_static_sym()
 and define_global_sym().

Revision 1.2  2013/06/01 01:24:22  pauloscustodio
CH_0022 : Replace avltree by hash table for symbol table

Revision 1.1  2013/05/23 22:22:24  pauloscustodio
Move symbol to sym.c, rename to Symbol


*/

#ifndef SYMTAB_H
#define SYMTAB_H

#include "memalloc.h"   /* before any other include */

#include "classhash.h"
#include "sym.h"

/*-----------------------------------------------------------------------------
*   Symbol Table
*----------------------------------------------------------------------------*/
CLASS_HASH(Symbol);				/* defines SymbolHash */

/* join two symbol tables, adding all symbols from source to the target 
   symbol table; if symbols with the same name exist, the one from source 
   overwrites the one at target */
extern void SymbolHash_cat( SymbolHash *target, SymbolHash *source );

/*-----------------------------------------------------------------------------
*   API
*----------------------------------------------------------------------------*/

/* define a static symbol (from -D command line) */
extern Symbol *define_static_sym( char *name, long value );

/* define a global symbol (e.g. ASMPC) */
extern Symbol *define_global_sym( char *name, long value );

/* copy the static symbols to CURRENTMODULE->local_tab */
extern void copy_static_syms( void );



/*-----------------------------------------------------------------------------
*   Global Symbol Tables
*----------------------------------------------------------------------------*/
extern SymbolHash *get_global_tab(void);

/* return pointer to found symbol in a symbol table, otherwise NULL if not found */
extern Symbol *find_symbol( char *name, SymbolHash *symtab );

/* create a symbol in the local or global tree:
   a) if not already global/extern, create in the local (CURRENTMODULE) symbol table
   b) if declared global/extern and not defined, define now
   c) if declared global/extern and defined -> error REDEFINED
   d) if in global table and not global/extern -> define a new local symbol */
extern void define_symbol( char *name, long value, byte_t type );

/* create a SYMDEF symbol in the given table, error if already defined */
extern Symbol *define_def_symbol( char *name, long value, byte_t type, SymbolHash *symtab );

/* refer to a symbol in an expression
   search for symbol in either local tree or global table, 
   return found pointer if defined/declared, otherwise return NULL */
extern Symbol *get_used_symbol( char *name );

/* declare a global symbol XDEF or XLIB */
extern void declare_global_obj_symbol( char *name );
extern void declare_global_lib_symbol( char *name );

/* declare an external symbol XREF or LIB */
extern void declare_extern_obj_symbol( char *name );
extern void declare_extern_lib_symbol( char *name );

/* sort functions for SymbolHash_sort */
extern int SymbolHash_by_name(  SymbolHashElem *a, SymbolHashElem *b);
extern int SymbolHash_by_value( SymbolHashElem *a, SymbolHashElem *b);

#endif /* ndef SYMTAB_H */

