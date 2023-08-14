/*
Z88-DK Z80ASM - Z80 Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2023
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

Symbol1 table
Replaced avltree from original assembler by hash table because:
a) code simplicity
b) performance - avltree 50% slower when loading the symbols from the ZX 48 ROM assembly,
   see t\developer\benchmark_symtab.t
*/

#pragma once

#include "classhash.h"
#include "sym.h"

/*-----------------------------------------------------------------------------
*   Symbol1 Table
*----------------------------------------------------------------------------*/
CLASS_HASH( Symbol1 );				/* defines Symbol1Hash */

/* join two symbol tables, adding all symbols from source to the target
   symbol table; if symbols with the same name exist, the one from source
   overwrites the one at target */
extern void SymbolHash_cat( Symbol1Hash **ptarget, Symbol1Hash *source );

/*-----------------------------------------------------------------------------
*   API
*----------------------------------------------------------------------------*/

/* return pointer to found symbol in a symbol table, otherwise NULL if not found */
extern Symbol1 *find_symbol(const char *name, Symbol1Hash *symtab );
extern Symbol1 *find_local_symbol(const char *name );
extern Symbol1 *find_global_symbol(const char *name );

/* refer to a symbol in an expression
   search for symbol in either local tree or global table,
   create undefined symbol if not found, return symbol */
extern Symbol1 *get_used_symbol(const char *name );

/* define/undefine a static DEF symbol (e.g. from -D command line) */
extern Symbol1 *define_static_def_sym(const char *name, long value );
extern void undefine_static_def_sym(const char* name);

/* define a global DEF symbol (e.g. ASMSIZE, ASMTAIL) */
extern Symbol1 *define_global_def_sym(const char *name, long value );

/* define/undefine a local DEF symbol (e.g. DEFINE) */
extern Symbol1 *define_local_def_sym(const char *name, long value );
extern void undefine_local_def_sym(const char* name);

/* define a new symbol in the local or global tabs */
extern Symbol1 *define_local_sym(const char *name, long value, sym_type_t type);
extern Symbol1 *define_global_sym(const char *name, long value, sym_type_t type);

/* get the symbols for which the passed function returns true,
   mapped NAME@MODULE -> Symbol1, needs to be deleted by OBJ_DELETE() */
extern Symbol1Hash *select_symbols( bool (*cond)(Symbol1 *sym) );
extern Symbol1Hash *select_module_symbols( struct Module1 *module, bool (*cond)(Symbol1 *sym) );

/* copy the static symbols to CURRENTMODULE->local_symtab */
extern void copy_static_syms( void );

/* delete the local, static and global symbols */
extern void remove_all_local_syms( void );
extern void remove_all_static_syms( void );
extern void remove_all_global_syms( void );

/*-----------------------------------------------------------------------------
*   Global Symbol1 Tables
*----------------------------------------------------------------------------*/
extern Symbol1Hash *global_symtab;
extern Symbol1Hash *static_symtab;

/* create a symbol in the local or global tree:
   a) if not already global/extern, create in the local (CURRENTMODULE) symbol table
   b) if declared global/extern and not defined, define now
   c) if declared global/extern and defined -> error REDEFINED
   d) if in global table and not global/extern -> define a new local symbol */
extern Symbol1 *define_symbol(const char *name, long value, sym_type_t type);

/* update a symbol value, used to compute EQU symbols */
extern void update_symbol(const char *name, long value, sym_type_t type );

/* declare a GLOBAL symbol, i.e. PUBLIC if defined, EXTERN if not defined */
extern void declare_global_symbol(const char *name);

/* declare a PUBLIC symbol */
extern void declare_public_symbol(const char *name);

/* declare an EXTERN symbol */
extern void declare_extern_symbol(const char *name );

/*-----------------------------------------------------------------------------
*   Write symbols to files
*----------------------------------------------------------------------------*/
extern void write_map_file(void);
extern void write_def_file(void);
extern void write_sym_file(struct Module1 *module);

extern void check_undefined_symbols(Symbol1Hash *symtab);
