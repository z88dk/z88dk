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

Define file writing - list of all global address symbols after link phase in DEFC format

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/deffile.c,v 1.18 2014-07-06 22:48:53 pauloscustodio Exp $

*/

#include "xmalloc.h"   /* before any other include */

#include "deffile.h"
#include "fileutil.h"
#include "listfile.h"
#include "options.h"
#include "symbol.h"
#include "symtab.h"
#include "z80asm.h"

/*-----------------------------------------------------------------------------
*   Write all symbols in given symbol table to given file
*----------------------------------------------------------------------------*/
static void write_def_syms( FILE *file, SymbolHash *symtab )
{
    SymbolHashElem *iter;
    Symbol         *sym;

    for ( iter = SymbolHash_first( symtab ); iter; iter = SymbolHash_next( iter ) )
    {
        sym = ( Symbol * )iter->value;

        /* CH_0017 */
        fprintf( file, "DEFC %-*s ", COLUMN_WIDTH - 1, sym->name );

        if ( opts.relocatable )
        {
            fprintf( file, "= $%04lX ; ", sizeof_relocroutine + sizeof_reloctable + 4 + sym->value );
        }
        else
        {
            fprintf( file, "= $%04lX ; ", sym->value );
        }

        fprintf( file, "Module %s\n", sym->module ? sym->module->modname : "" );
    }
}

/*-----------------------------------------------------------------------------
*   write full defition file to FILE.def, where FILE is the name of the first
*	linked source module
*----------------------------------------------------------------------------*/
static Bool cond_global_addr_symbols(Symbol *sym) 
{ 
	return (sym->sym_type == TYPE_ADDRESS) && ! (sym->sym_type_mask & SYM_LOCAL); 
}

void write_def_file( void )
{
    char *filename;
    FILE *file;
    SymbolHash *def_symtab;

    /* use first module filename to create global def file */
    filename = get_def_filename( get_first_module( NULL )->filename ); /* set '.def' extension */

    /* Create DEF file */
    file = xfopen( filename, "w" );           /* CH_0012 */

    if ( opts.verbose )
    {
        puts( "Creating global definition file..." );
    }

	/* all global addresses */
    def_symtab = select_symbols( cond_global_addr_symbols );

    /* Write symbols by address */
    SymbolHash_sort( def_symtab, SymbolHash_by_value );
    write_def_syms( file, def_symtab );

    OBJ_DELETE( def_symtab );

    xfclose( file );
}
