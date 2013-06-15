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

Mapfile writing - list of all local and global address symbols after link phase

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/mapfile.c,v 1.1 2013-06-15 00:26:23 pauloscustodio Exp $
$Log: mapfile.c,v $
Revision 1.1  2013-06-15 00:26:23  pauloscustodio
Move mapfile writing to mapfile.c.


*/


#include "memalloc.h"   /* before any other include */

#include "file.h"
#include "listfile.h"
#include "mapfile.h"
#include "options.h"
#include "safestr.h"
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
		sym = (Symbol *)iter->value;

		/* CH_0017 */
		fprintf( file, "%-*s ", COLUMN_WIDTH - 1, sym->name );

		if ( autorelocate )
		{
			fprintf( file, "= %04lX, ", sizeof_relocroutine + sizeof_reloctable + 4 + sym->value );
		}
		else
		{
			fprintf( file, "= %04lX, ", sym->value );
		}

		if ( sym->type & SYMLOCAL )
		{
			fputc_err( 'L', file );
		}
		else
		{
			fputc_err( 'G', file );
		}

		fprintf( file, ": %s\n", sym->owner->mname );
    }
}

/*-----------------------------------------------------------------------------
*   return NAME@MODULE in strpool
*----------------------------------------------------------------------------*/
static char *full_sym_name( Symbol *sym )
{
	SSTR_DEFINE(name, MAXLINE);

	sstr_set(name, sym->name);
	if ( sym->owner && sym->owner->mname ) 
	{
		sstr_cat(name, "@");
		sstr_cat(name, sym->owner->mname);
	}

	return strpool_add(sstr_data(name));
}

/*-----------------------------------------------------------------------------
*   copy all SYMADDR symbols to target, replacing NAME by NAME@MODULE
*----------------------------------------------------------------------------*/
static void copy_full_sym_names( SymbolHash *target, SymbolHash *source )
{
	SymbolHashElem *iter;
	Symbol         *sym;

	for ( iter = SymbolHash_first( source ); iter; iter = SymbolHash_next( iter ) )
	{
		sym = (Symbol *)iter->value;
			
		if ( sym->type & SYMADDR )
			SymbolHash_set( target, full_sym_name(sym), Symbol_clone(sym) );
	}	
}

/*-----------------------------------------------------------------------------
*   write full mapfile to FILE.map, where FILE is the name of the first
*	linked source module
*----------------------------------------------------------------------------*/
void write_map_file( void )
{
    char *filename;
	FILE *file;
	SymbolHash *map_symtab;
    struct module *cmodule;

	/* use first module filename to create global map file */
	filename = map_filename_ext( modulehdr->first->cfile->fname ); /* set '.map' extension */

    /* Create MAP file */
    file = xfopen( filename, "w" );           /* CH_0012 */

    if ( verbose )
    {
        puts( "Creating map..." );
    }

	/* copy all local symbols from all modules to a map_symtab */

	/* BUG_0036 - need to create coposed symbol names NAME@MODULE, so that local symbols in different modules
	   are shown */
	map_symtab = OBJ_NEW(SymbolHash);
	for ( cmodule = modulehdr->first; cmodule != NULL; cmodule = cmodule->nextmodule )
    {
	    copy_full_sym_names( map_symtab, cmodule->local_tab );
    }

    copy_full_sym_names( map_symtab, get_global_tab() );

    if ( SymbolHash_empty( map_symtab ) )
    {
        fputs( "None.\n", file );
    }
    else
    {
		/* Write map symbols alphabetically */
		SymbolHash_sort( map_symtab, SymbolHash_by_name );
		write_map_syms( file, map_symtab );

        fputs( "\n\n", file );

		/* Write map symbols numerically */
		SymbolHash_sort( map_symtab, SymbolHash_by_value );
		write_map_syms( file, map_symtab );
    }

	OBJ_DELETE(map_symtab);

    xfclose( file );
}

