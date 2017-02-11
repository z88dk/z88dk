/*
Z88-DK Z80ASM - Z80 Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

Symbol table
Replaced avltree from original assembler by hash table because:
a) code simplicity
b) performance - avltree 50% slower when loading the symbols from the ZX 48 ROM assembly,
   see t\developer\benchmark_symtab.t
*/

#pragma once

#include "classhash.h"
#include "sym.h"

/*-----------------------------------------------------------------------------
*   Symbol Table
*----------------------------------------------------------------------------*/
CLASS_HASH( Symbol );				/* defines SymbolHash */

/* join two symbol tables, adding all symbols from source to the target
   symbol table; if symbols with the same name exist, the one from source
   overwrites the one at target */
extern void SymbolHash_cat( SymbolHash **ptarget, SymbolHash *source );

/*-----------------------------------------------------------------------------
*   API
*----------------------------------------------------------------------------*/

/* return pointer to found symbol in a symbol table, otherwise NULL if not found */
extern Symbol *find_symbol( char *name, SymbolHash *symtab );
extern Symbol *find_local_symbol( char *name );
extern Symbol *find_global_symbol( char *name );

/* refer to a symbol in an expression
   search for symbol in either local tree or global table,
   create undefined symbol if not found, return symbol */
extern Symbol *get_used_symbol( char *name );

/* define a static DEF symbol (e.g. from -D command line) */
extern Symbol *define_static_def_sym( char *name, long value );

/* define a global DEF symbol (e.g. ASMSIZE, ASMTAIL) */
extern Symbol *define_global_def_sym( char *name, long value );

/* define a local DEF symbol (e.g. DEFINE) */
extern Symbol *define_local_def_sym( char *name, long value );

/* define a new symbol in the local or global tabs */
extern Symbol *define_local_sym(char *name, long value, sym_type_t type);
extern Symbol *define_global_sym(char *name, long value, sym_type_t type);

/* get the symbols for which the passed function returns TRUE,
   mapped NAME@MODULE -> Symbol, needs to be deleted by OBJ_DELETE() */
extern SymbolHash *select_symbols( Bool (*cond)(Symbol *sym) );
extern SymbolHash *select_module_symbols( struct Module *module, Bool (*cond)(Symbol *sym) );

/* copy the static symbols to CURRENTMODULE->local_symtab */
extern void copy_static_syms( void );

/* delete the local, static and global symbols */
extern void remove_all_local_syms( void );
extern void remove_all_static_syms( void );
extern void remove_all_global_syms( void );

/*-----------------------------------------------------------------------------
*   Global Symbol Tables
*----------------------------------------------------------------------------*/
extern SymbolHash *global_symtab;
extern SymbolHash *static_symtab;

/* create a symbol in the local or global tree:
   a) if not already global/extern, create in the local (CURRENTMODULE) symbol table
   b) if declared global/extern and not defined, define now
   c) if declared global/extern and defined -> error REDEFINED
   d) if in global table and not global/extern -> define a new local symbol */
extern Symbol *define_symbol(char *name, long value, sym_type_t type);

/* update a symbol value, used to compute EQU symbols */
extern void update_symbol( char *name, long value, sym_type_t type );

/* declare a GLOBAL symbol, i.e. PUBLIC if defined, EXTERN if not defined */
extern void declare_global_symbol(char *name);

/* declare a PUBLIC symbol */
extern void declare_public_symbol(char *name);

/* declare an EXTERN symbol */
extern void declare_extern_symbol( char *name );

/* sort functions for SymbolHash_sort */
extern int SymbolHash_by_name( SymbolHashElem *a, SymbolHashElem *b );
extern int SymbolHash_by_value( SymbolHashElem *a, SymbolHashElem *b );

/*-----------------------------------------------------------------------------
*   Write symbols to files
*----------------------------------------------------------------------------*/
extern void write_map_file(void);
extern void write_def_file(void);
extern void write_sym_file(struct Module *module);
