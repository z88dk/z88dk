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

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2014

One symbol from the assembly code - label or constant.

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/sym.c,v 1.21 2014-06-09 13:15:26 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "listfile.h"
#include "options.h"
#include "strpool.h"
#include "strutil.h"
#include "sym.h"
#include "symbol.h"

/*-----------------------------------------------------------------------------
*   Symbol
*----------------------------------------------------------------------------*/
DEF_CLASS( Symbol )

void Symbol_init( Symbol *self )
{
    self->references = OBJ_NEW( SymbolRefList );
    OBJ_AUTODELETE( self->references ) = FALSE;
}

void Symbol_copy( Symbol *self, Symbol *other )
{
    self->references = SymbolRefList_clone( other->references );
}

void Symbol_fini( Symbol *self )
{
    OBJ_DELETE( self->references );
}

/*-----------------------------------------------------------------------------
*   create a new symbol, needs to be deleted by OBJ_DELETE()
*	adds a reference to the page were referred to
*----------------------------------------------------------------------------*/
Symbol *Symbol_create( char *name, long value, Byte type, Module *owner )
{
    Symbol *self 	= OBJ_NEW( Symbol );

	self->name 		= strpool_add( name );			/* name in strpool, not freed */
	self->value 	= value;
	self->sym_type	= type;
	self->owner 	= owner;

    /* add reference */
    add_symbol_ref( self->references, list_get_page_nr(), FALSE );

    return self;              						/* pointer to new symbol */
}

/*-----------------------------------------------------------------------------
*   return full symbol name NAME@MODULE stored in strpool
*----------------------------------------------------------------------------*/
char *Symbol_fullname( Symbol *sym )
{
    DEFINE_STR( name, MAXLINE );

    Str_set( name, sym->name );

    if ( sym->owner && sym->owner->modname )
    {
        Str_append_char( name, '@' );
        Str_append( name, sym->owner->modname );
    }

    return strpool_add( name->str );
}


/*
* $Log: sym.c,v $
* Revision 1.21  2014-06-09 13:15:26  pauloscustodio
* Int and UInt types
*
* Revision 1.20  2014/05/25 01:02:29  pauloscustodio
* Byte, Int, UInt added
*
* Revision 1.19  2014/05/17 14:27:13  pauloscustodio
* Use C99 integer types
*
* Revision 1.18  2014/05/06 22:17:38  pauloscustodio
* Made types all-caps to avoid conflicts with /usr/include/i386-linux-gnu/sys/types.h
*
* Revision 1.17  2014/05/02 21:34:58  pauloscustodio
* byte_t and uint_t renamed to Byte, UInt
*
* Revision 1.16  2014/05/02 20:24:38  pauloscustodio
* New class Module to replace struct module and struct modules
*
* Revision 1.15  2014/04/18 17:46:18  pauloscustodio
* - Change struct expr to Expr class, use CLASS_LIST instead of linked list
*   manipulating.
* - Factor parsing and evaluating contants.
* - Factor symbol-not-defined error during expression evaluation.
* - Store module name in strpool instead of xstrdup/xfree.
*
* Revision 1.14  2014/04/05 23:36:11  pauloscustodio
* CH_0024: Case-preserving, case-insensitive symbols
* Symbols no longer converted to upper-case, but still case-insensitive
* searched. Warning when a symbol is used with different case than
* defined. Intermidiate stage before making z80asm case-sensitive, to
* be more C-code friendly.
*
* Revision 1.13  2014/03/03 14:09:20  pauloscustodio
* Renamed symbol type attribute
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
* Revision 1.8  2013/10/05 13:43:05  pauloscustodio
* Parse command line options via look-up tables:
* -i, --use-lib
* -x, --make-lib
* 
* Revision 1.7  2013/10/01 22:50:26  pauloscustodio
* Parse command line options via look-up tables:
* -s, --symtable
* -ns, --no-symtable
* 
* Revision 1.6  2013/09/01 18:46:01  pauloscustodio
* Remove call to strpool_init(). String pool is initialized in init.c before main() starts.
* 
* Revision 1.5  2013/06/16 16:49:20  pauloscustodio
* Symbol_fullname() to return full symbol name NAME@MODULE
* 
* Revision 1.4  2013/06/08 23:08:38  pauloscustodio
* comments
* 
* Revision 1.3  2013/06/01 01:21:02  pauloscustodio
* Symbol references were being created twice
* 
* Revision 1.2  2013/05/23 22:22:23  pauloscustodio
* Move symbol to sym.c, rename to Symbol
* 
* Revision 1.1  2013/05/16 23:39:48  pauloscustodio
* Move struct node to sym.c, rename to Symbol
* Move SymbolRef to symref.c
* 
*/
