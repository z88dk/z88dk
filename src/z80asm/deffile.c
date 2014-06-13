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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/deffile.c,v 1.16 2014-06-13 19:14:04 pauloscustodio Exp $

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

        fprintf( file, "Module %s\n", sym->owner ? sym->owner->modname : "" );
    }
}

/*-----------------------------------------------------------------------------
*   write full defition file to FILE.def, where FILE is the name of the first
*	linked source module
*----------------------------------------------------------------------------*/
static Bool cond_global_addr_symbols(Symbol *sym) 
{ 
	return (sym->sym_type & SYM_ADDR) && ! (sym->sym_type & SYM_LOCAL); 
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


/*
* $Log: deffile.c,v $
* Revision 1.16  2014-06-13 19:14:04  pauloscustodio
* Move module list to module.c
*
* Revision 1.15  2014/05/25 01:02:29  pauloscustodio
* Byte, Int, UInt added
*
* Revision 1.14  2014/05/20 22:26:29  pauloscustodio
* BUG_0051: DEFC and DEFVARS constants do not appear in map file
* Constants defined with DEFC and DEFVARS, and declared PUBLIC are not
* written to the map file.
* Logic to select symbols for map and def files was wrong.
*
* Revision 1.13  2014/05/02 20:24:38  pauloscustodio
* New class Module to replace struct module and struct modules
*
* Revision 1.12  2014/04/18 17:46:18  pauloscustodio
* - Change struct expr to Expr class, use CLASS_LIST instead of linked list
*   manipulating.
* - Factor parsing and evaluating contants.
* - Factor symbol-not-defined error during expression evaluation.
* - Store module name in strpool instead of xstrdup/xfree.
*
* Revision 1.11  2014/04/13 11:54:00  pauloscustodio
* CH_0025: PUBLIC and EXTERN instead of LIB, XREF, XDEF, XLIB
* Use new keywords PUBLIC and EXTERN, make the old ones synonyms.
* Remove 'X' scope for symbols in object files used before for XLIB -
* all PUBLIC symbols have scope 'G'.
* Remove SDCC hack on object files trating XLIB and XDEF the same.
* Created a warning to say XDEF et.al. are deprecated, but for the
* momment keep it commented.
*
* Revision 1.10  2014/03/16 19:19:49  pauloscustodio
* Integrate use of srcfile in scanner, removing global variable z80asmfile
* and attributes CURRENTMODULE->cfile->line and CURRENTMODULE->cfile->fname.
*
* Revision 1.9  2014/03/03 13:27:06  pauloscustodio
* Rename symbol type constants
*
* Revision 1.8  2014/01/20 23:29:18  pauloscustodio
* Moved file.c to lib/fileutil.c
*
* Revision 1.7  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.6  2014/01/11 00:10:38  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
* 
* Revision 1.5  2013/12/15 13:18:33  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
* 
* Revision 1.4  2013/10/04 23:09:24  pauloscustodio
* Parse command line options via look-up tables:
* -R, --relocatable
* --RCMX000
* 
* Revision 1.3  2013/09/30 00:24:25  pauloscustodio
* Parse command line options via look-up tables:
* -e, --asm-ext
* -M, --obj-ext
* Move filename extension functions to options.c
* 
* Revision 1.2  2013/09/27 01:14:33  pauloscustodio
* Parse command line options via look-up tables:
* --help, --verbose
* 
* Revision 1.1  2013/06/16 20:14:39  pauloscustodio
* Move deffile writing to deffile.c, remove global variable deffile
* 
*/
