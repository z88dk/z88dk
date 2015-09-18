/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2015
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

Define file writing - list of all global address symbols after link phase in DEFC format
*/

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
	return sym->type == TYPE_ADDRESS && sym->scope != SCOPE_LOCAL; 
}

void write_def_file( void )
{
    char *filename;
    FILE *file;
    SymbolHash *def_symtab;

    /* use first module filename to create global def file */
    filename = get_def_filename( get_first_module( NULL )->filename ); /* set '.def' extension */

    /* Create DEF file */
    file = myfopen( filename, "w" );           
	if (file)
	{
		if (opts.verbose)
			puts("Creating global definition file...");

		/* all global addresses */
		def_symtab = select_symbols(cond_global_addr_symbols);

		/* Write symbols by address */
		SymbolHash_sort(def_symtab, SymbolHash_by_value);
		write_def_syms(file, def_symtab);

		OBJ_DELETE(def_symtab);

		myfclose(file);
	}
}
