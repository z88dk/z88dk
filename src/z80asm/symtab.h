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

Symbol table
Replaced avltree from original assembler by hash table because:
a) code simplicity
b) performance - avltree 50% slower when loading the symbols from the ZX 48 ROM assembly,
   see t\developer\benchmark_symtab.t

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/symtab.h,v 1.16 2014-04-27 09:08:15 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */

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

/* define a static DEF symbol (e.g. from -D command line, OS_ID) */
extern Symbol *define_static_def_sym( char *name, long value );

/* define a global DEF symbol (e.g. ASMSIZE, ASMTAIL) */
extern Symbol *define_global_def_sym( char *name, long value );

/* define a local DEF symbol (e.g. DEFINE) */
extern Symbol *define_local_def_sym( char *name, long value );

/* define a new symbol in the local or global tabs */
extern Symbol *define_local_sym( char *name, long value, byte_t type );
extern Symbol *define_global_sym( char *name, long value, byte_t type );

/* get the list of symbols that match the given type mask,
   mapped NAME@MODULE -> Symbol, needs to be deleted by OBJ_DELETE()
   Selects symbols where (type & type_mask) == type_value */
extern SymbolHash *get_all_syms( byte_t type_mask, byte_t type_value );

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
extern void define_symbol( char *name, long value, byte_t type );

/* declare a PUBLIC symbol */
extern void declare_public_symbol( char *name );

/* declare an EXTERN symbol */
extern void declare_extern_symbol( char *name );

/* sort functions for SymbolHash_sort */
extern int SymbolHash_by_name( SymbolHashElem *a, SymbolHashElem *b );
extern int SymbolHash_by_value( SymbolHashElem *a, SymbolHashElem *b );


/*
* $Log: symtab.h,v $
* Revision 1.16  2014-04-27 09:08:15  pauloscustodio
* comments
*
* Revision 1.15  2014/04/22 23:32:42  pauloscustodio
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
* Revision 1.14  2014/04/13 11:54:01  pauloscustodio
* CH_0025: PUBLIC and EXTERN instead of LIB, XREF, XDEF, XLIB
* Use new keywords PUBLIC and EXTERN, make the old ones synonyms.
* Remove 'X' scope for symbols in object files used before for XLIB -
* all PUBLIC symbols have scope 'G'.
* Remove SDCC hack on object files trating XLIB and XDEF the same.
* Created a warning to say XDEF et.al. are deprecated, but for the
* momment keep it commented.
*
* Revision 1.13  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.12  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
* 
* Revision 1.11  2014/01/05 23:20:39  pauloscustodio
* List, StrHash classlist and classhash receive the address of the container
* object in all functions that add items to the container, and create the
* container on first use. This allows a container to be staticaly
* initialized with NULL and instantiated on first push/unshift/set.
* Add count attribute to StrHash, classhash to count elements in container.
* Add free_data attribute in StrHash to register a free fucntion to delete
* the data container when the hash is removed or a key is overwritten.
* 
* Revision 1.10  2013/12/15 13:18:34  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
* 
* Revision 1.9  2013/06/16 22:25:39  pauloscustodio
* New remove_all_{local,static,global}_syms( void ) functions
* to encapsulate calls to get_global_tab().
* 
* Revision 1.8  2013/06/16 20:14:39  pauloscustodio
* Move deffile writing to deffile.c, remove global variable deffile
* 
* Revision 1.7  2013/06/16 17:51:57  pauloscustodio
* get_all_syms() to get list of symbols matching a type mask, use in mapfile to decouple
* it from get_global_tab()
* 
* Revision 1.6  2013/06/14 22:14:36  pauloscustodio
* find_local_symbol() and find_global_symbol() to encapsulate usage of get_global_tab()
* 
* Revision 1.5  2013/06/11 23:16:06  pauloscustodio
* Move symbol creation logic fromReadNames() in  modlink.c to symtab.c.
* Add error message for invalid symbol and scope chars in object file.
* 
* Revision 1.4  2013/06/08 23:37:32  pauloscustodio
* Replace define_def_symbol() by one function for each symbol table type: define_static_def_sym(),
*  define_global_def_sym(), define_local_def_sym(), encapsulating the symbol table used.
* Define keywords for special symbols ASMSIZE, ASMTAIL
* 
* Revision 1.3  2013/06/08 23:07:53  pauloscustodio
* Add global ASMPC Symbol pointer, to avoid "ASMPC" symbol table lookup on every instruction.
* Encapsulate get_global_tab() and get_static_tab() by using new functions define_static_def_sym()
*  and define_global_def_sym().
* 
* Revision 1.2  2013/06/01 01:24:22  pauloscustodio
* CH_0022 : Replace avltree by hash table for symbol table
* 
* Revision 1.1  2013/05/23 22:22:24  pauloscustodio
* Move symbol to sym.c, rename to Symbol
* 
* 
*/
