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

Mapfile writing - list of all local and global address symbols after link phase

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/mapfile.c,v 1.14 2014-03-03 13:27:07 pauloscustodio Exp $
*/


#include "xmalloc.h"   /* before any other include */

#include "fileutil.h"
#include "listfile.h"
#include "mapfile.h"
#include "options.h"
#include "strpool.h"
#include "strutil.h"
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

        if ( sym->type & SYM_LOCAL )
            fputc( 'L', file );
        else
            fputc( 'G', file );

        fprintf( file, ": %s\n", sym->owner->mname );
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

    /* use first module filename to create global map file */
    filename = get_map_filename( modulehdr->first->cfile->fname ); /* set '.map' extension */

    /* Create MAP file */
    file = xfopen( filename, "w" );           /* CH_0012 */

    if ( opts.verbose )
    {
        puts( "Creating map..." );
    }

    /* BUG_0036 - need to create coposed symbol names NAME@MODULE, so that local symbols
       in different modules are shown */
    map_symtab = get_all_syms( SYM_ADDR, SYM_ADDR );

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

    OBJ_DELETE( map_symtab );

    xfclose( file );
}


/*
* $Log: mapfile.c,v $
* Revision 1.14  2014-03-03 13:27:07  pauloscustodio
* Rename symbol type constants
*
* Revision 1.13  2014/01/20 23:29:18  pauloscustodio
* Moved file.c to lib/fileutil.c
*
* Revision 1.12  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.11  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
* 
* Revision 1.10  2013/12/30 02:05:32  pauloscustodio
* Merge dynstr.c and safestr.c into lib/strutil.c; the new Str type
* handles both dynamically allocated strings and fixed-size strings.
* Replaced g_strchomp by chomp by; g_ascii_tolower by tolower;
* g_ascii_toupper by toupper; g_ascii_strcasecmp by stricompare.
* 
* Revision 1.9  2013/12/15 13:18:34  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
* 
* Revision 1.8  2013/10/04 23:09:25  pauloscustodio
* Parse command line options via look-up tables:
* -R, --relocatable
* --RCMX000
* 
* Revision 1.7  2013/09/30 00:24:25  pauloscustodio
* Parse command line options via look-up tables:
* -e, --asm-ext
* -M, --obj-ext
* Move filename extension functions to options.c
* 
* Revision 1.6  2013/09/27 01:14:33  pauloscustodio
* Parse command line options via look-up tables:
* --help, --verbose
* 
* Revision 1.5  2013/09/22 21:34:48  pauloscustodio
* Remove legacy xxx_err() interface
* 
* Revision 1.4  2013/06/16 20:14:39  pauloscustodio
* Move deffile writing to deffile.c, remove global variable deffile
* 
* Revision 1.3  2013/06/16 17:51:57  pauloscustodio
* get_all_syms() to get list of symbols matching a type mask, use in mapfile to decouple
* it from get_global_tab()
* 
* Revision 1.2  2013/06/16 16:49:20  pauloscustodio
* Symbol_fullname() to return full symbol name NAME@MODULE
* 
* Revision 1.1  2013/06/15 00:26:23  pauloscustodio
* Move mapfile writing to mapfile.c.
* 
*/
