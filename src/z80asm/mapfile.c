/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2015
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

Mapfile writing - list of all local and global address symbols after link phase
*/


#include "fileutil.h"
#include "listfile.h"
#include "mapfile.h"
#include "options.h"
#include "strpool.h"
#include "symbol.h"
#include "symtab.h"
#include "z80asm.h"

/*-----------------------------------------------------------------------------
*   Write all symbols in given symbol table to given file
*----------------------------------------------------------------------------*/
static void write_map_syms( FILE *file, SymbolHash *symtab )
{
    SymbolHashElem *iter;
    Symbol         *sym;

    for ( iter = SymbolHash_first( symtab ); iter; iter = SymbolHash_next( iter ) )
    {
        sym = ( Symbol * )iter->value;

        /* CH_0017 */
        fprintf( file, "%-*s ", COLUMN_WIDTH - 1, sym->name );

        if ( opts.relocatable )
        {
            fprintf( file, "= %04lX, ", sizeof_relocroutine + sizeof_reloctable + 4 + sym->value );
        }
        else
        {
            fprintf( file, "= %04lX, ", sym->value );
        }

        if ( sym->scope == SCOPE_LOCAL )
            fputc( 'L', file );
        else
            fputc( 'G', file );

        fprintf( file, ": %s\n", sym->module ? sym->module->modname : "" );
    }
}

/*-----------------------------------------------------------------------------
*   write full mapfile to FILE.map, where FILE is the name of the first
*	linked source module
*----------------------------------------------------------------------------*/
static Bool cond_all_symbols(Symbol *sym) { return TRUE; }

void write_map_file( void )
{
    char *filename;
    FILE *file;
    SymbolHash *map_symtab;

    /* use first module filename to create global map file */
    filename = get_map_filename( get_first_module( NULL )->filename ); /* set '.map' extension */

    /* Create MAP file */
    file = myfopen( filename, "w" );           
	if (file)
	{
		if (opts.verbose)
			puts("Creating map...");

		/* BUG_0036, BUG_0051 */
		map_symtab = select_symbols(cond_all_symbols);

		if (SymbolHash_empty(map_symtab))
		{
			fputs("None.\n", file);
		}
		else
		{
			/* Write map symbols alphabetically */
			SymbolHash_sort(map_symtab, SymbolHash_by_name);
			write_map_syms(file, map_symtab);

			fputs("\n\n", file);

			/* Write map symbols numerically */
			SymbolHash_sort(map_symtab, SymbolHash_by_value);
			write_map_syms(file, map_symtab);
		}

		OBJ_DELETE(map_symtab);

		myfclose(file);
	}
}
