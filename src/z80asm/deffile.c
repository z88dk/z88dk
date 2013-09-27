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

Define file writing - list of all global address symbols after link phase in DEFC format

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/deffile.c,v 1.2 2013-09-27 01:14:33 pauloscustodio Exp $
$Log: deffile.c,v $
Revision 1.2  2013-09-27 01:14:33  pauloscustodio
Parse command line options via look-up tables:
--help, --verbose

Revision 1.1  2013/06/16 20:14:39  pauloscustodio
Move deffile writing to deffile.c, remove global variable deffile



*/

#include "memalloc.h"   /* before any other include */

#include "deffile.h"
#include "file.h"
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
		sym = (Symbol *)iter->value;

		/* CH_0017 */
		fprintf( file, "DEFC %-*s ", COLUMN_WIDTH - 1, sym->name );

		if ( autorelocate )
		{
			fprintf( file, "= $%04lX ; ", sizeof_relocroutine + sizeof_reloctable + 4 + sym->value );
		}
		else
		{
			fprintf( file, "= $%04lX ; ", sym->value );
		}

		fprintf( file, "Module %s\n", sym->owner->mname );
    }
}

/*-----------------------------------------------------------------------------
*   write full defition file to FILE.def, where FILE is the name of the first
*	linked source module
*----------------------------------------------------------------------------*/
void write_def_file( void )
{
    char *filename;
	FILE *file;
	SymbolHash *def_symtab;

	/* use first module filename to create global def file */
	filename = def_filename_ext( modulehdr->first->cfile->fname ); /* set '.def' extension */

    /* Create DEF file */
    file = xfopen( filename, "w" );           /* CH_0012 */

    if ( opts.verbose )
    {
        puts( "Creating global definition file..." );
    }

	def_symtab = get_all_syms( SYMADDR | SYMLOCAL | SYMXDEF | SYMDEF, 
							   SYMADDR | 0        | SYMXDEF | 0      );

	/* Write symbols by address */
	SymbolHash_sort( def_symtab, SymbolHash_by_value );
	write_def_syms( file, def_symtab );

	OBJ_DELETE(def_symtab);

    xfclose( file );
}



