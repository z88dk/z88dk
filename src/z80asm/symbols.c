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
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/symbols.c,v 1.19 2012-05-18 00:28:45 pauloscustodio Exp $ */
/* $Log: symbols.c,v $
/* Revision 1.19  2012-05-18 00:28:45  pauloscustodio
/* astyle
/*
/* Revision 1.18  2012/05/18 00:23:14  pauloscustodio
/* DefineSymbol() and DefineDefSym() defined as void, a fatal error is always raised on error.
/*
/* Revision 1.17  2012/05/17 17:49:20  pauloscustodio
/* astyle
/*
/* Revision 1.16  2012/05/17 17:42:14  pauloscustodio
/* DefineSymbol() and DefineDefSym() defined as void, a fatal error is
/* always raised on error.
/*
/* Revision 1.15  2012/05/11 19:29:49  pauloscustodio
/* Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
/*         --mode=c
/*         --lineend=linux
/*         --indent=spaces=4
/*         --style=ansi --add-brackets
/*         --indent-switches --indent-classes
/*         --indent-preprocessor --convert-tabs
/*         --break-blocks
/*         --pad-oper --pad-paren-in --pad-header --unpad-paren
/*         --align-pointer=name
/*
/* Revision 1.14  2011/08/15 17:12:31  pauloscustodio
/* Upgrade to Exceptions4c 2.8.9 to solve memory leak.
/*
/* Revision 1.13  2011/08/05 20:02:32  pauloscustodio
/* CH_0004 : Exception mechanism to handle fatal errors
/* Replaced all ERR_NO_MEMORY/return sequences by an exception, captured at main().
/* Replaced all the memory allocation functions malloc, calloc, ... by corresponding
/* macros xmalloc, xcalloc, ... that raise an exception if the memory cannot be allocated,
/* removing all the test code after each memory allocation.
/* Replaced all functions that allocated memory structures by the new xcalloc_struct().
/* Replaced all free() by xfree0() macro which only frees if the pointer in non-null, and
/* sets the poiter to NULL afterwards, to avoid any used of the freed memory.
/* Created try/catch sequences to clean-up partially created memory structures and rethrow the
/* exception, to cleanup memory leaks.
/*
/* Revision 1.12  2011/07/18 00:48:25  pauloscustodio
/* Initialize MS Visual Studio DEBUG build to show memory leaks on exit
/*
/* Revision 1.11  2011/07/14 01:32:08  pauloscustodio
/*     - Unified "Integer out of range" and "Out of range" errors; they are the same error.
/*     - Unified ReportIOError as ReportError(ERR_FILE_OPEN)
/*     CH_0003 : Error messages should be more informative
/*         - Added printf-args to error messages, added "Error:" prefix.
/*     BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
/*         - Raise ERR_UNBALANCED_PAREN instead
/*
/* Revision 1.10  2011/07/12 22:47:59  pauloscustodio
/* - Moved all error variables and error reporting code to a separate module errors.c,
/*   replaced all extern declarations of these variables by include errors.h,
/*   created symbolic constants for error codes.
/* - Added test scripts for error messages.
/*
/* Revision 1.9  2011/07/11 16:07:16  pauloscustodio
/* Moved all option variables and option handling code to a separate module options.c,
/* replaced all extern declarations of these variables by include options.h.
/*
/* Revision 1.8  2011/07/09 18:25:35  pauloscustodio
/* Log keyword in checkin comment was expanded inside Log expansion... recursive
/* Added Z80asm banner to all source files
/*
/* Revision 1.7  2011/07/09 17:36:09  pauloscustodio
/* Copied cvs log into Log history
/*
/* Revision 1.6  2011/07/09 01:46:00  pauloscustodio
/* Added Log keyword
/*
/* Revision 1.5  2011/07/09 01:30:14  pauloscustodio
/* added casts to clean up warnings
/*
/* Revision 1.4  2011/06/08 22:03:35  dom
/* Vile hack
/*
/* Revision 1.3  2010/04/16 17:34:37  dom
/* Make line number an int - 32768 lines isn't big enough...
/*
/* Revision 1.2  2007/07/13 09:03:10  dom
/* allow multiple LIB/XDEF/XREF as necessary
/*
/* Revision 1.1  2000/07/04 15:33:29  dom
/* branches:  1.1.1;
/* Initial revision
/*
/* Revision 1.1.1.1  2000/07/04 15:33:29  dom
/* First import of z88dk into the sourceforge system <gulp>
/*
/* */

/* $History: SYMBOLS.C $ */
/*  */
/* *****************  Version 9  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 12:13 */
/* Updated in $/Z80asm */
/* Added Ascii Art "Z80asm" at top of source file. */
/*  */
/* *****************  Version 7  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 11:31 */
/* Updated in $/Z80asm */
/* "config.h" included before "symbol.h" */
/*  */
/* *****************  Version 6  ***************** */
/* User: Gbs          Date: 2-05-99    Time: 18:09 */
/* Updated in $/Z80asm */
/* DeclSymGlobal() and DeclSymExtern() functions improved to handle scope */
/* resolution of identifers even after the actual identifiers have been */
/* created (typically re-declaring a local symbol to a global symbol). */
/*  */
/* *****************  Version 4  ***************** */
/* User: Gbs          Date: 17-04-99   Time: 0:30 */
/* Updated in $/Z80asm */
/* New GNU programming style C format. Improved ANSI C coding style */
/* eliminating previous compiler warnings. New -o option. Asm sources file */
/* now parsed even though any line feed standards (CR,LF or CRLF) are */
/* used. */
/*  */
/* *****************  Version 2  ***************** */
/* User: Gbs          Date: 20-06-98   Time: 15:10 */
/* Updated in $/Z80asm */
/* SourceSafe Version History Comment Block added. */

#include "memalloc.h"   /* before any other include to enable memory leak detection */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "config.h"
#include "symbol.h"
#include "symbols.h"
#include "options.h"
#include "errors.h"

/* local functions */
symbol *GetSymPtr( char *identifier );
symbol *FindSymbol( char *identifier, avltree *treeptr );
static void DefLocalSymbol( char *identifier, long value, unsigned char symboltype );
int cmpidstr( symbol *kptr, symbol *p );
int cmpidval( symbol *kptr, symbol *p );
void InsertPageRef( symbol *symptr );
void AppendPageRef( symbol *symptr );
void MovePageRefs( char *identifier, symbol *definedsym );
void FreeSym( symbol *node );



/* global variables */
extern int PAGENR;
extern enum flag pass1;
extern struct module *CURRENTMODULE;    /* pointer to current module */
extern avltree *globalroot;


/* Create a new symbol
   CH_0004 : always returns non-NULL, ERR_NO_MEMORY is signalled by exception */
symbol *CreateSymbol( char *identifier, long value, unsigned char symboltype, struct module *symowner )
{
    symbol *newsym;

    newsym = xcalloc_struct( symbol );  /* Create area for a new symbol structure */

    try
    {
        newsym->symname = xstrdup( identifier );

        /* Allocate area for a new symbol identifier */
        try
        {
            if ( symtable && listing_CPY )
            {
                newsym->references = xcalloc_struct( struct symref );

                /* Create area for a new symbol structure */
                try
                {
                    newsym->references->firstref = NULL;
                    newsym->references->lastref = NULL;
                    /* Page reference list initialised... */
                    AppendPageRef( newsym );
                    /* store first page reference in listfile of this symbol */
                }
                catch ( RuntimeException )
                {
                    xfree0( newsym->references );
                    rethrow( "" );
                }
            }
            else
            {
                newsym->references = NULL;
                /* No listing file, no page references... */
            }
        }
        catch ( RuntimeException )
        {
            xfree0( newsym->symname );
            rethrow( "" );
        }
    }
    catch ( RuntimeException )
    {
        xfree0( newsym );
        rethrow( "" );
    }

    newsym->owner = symowner;
    newsym->type = symboltype;
    newsym->symvalue = value;

    return newsym;              /* pointer to new symbol node */
}



int
cmpidstr( symbol *kptr, symbol *p )
{
    return strcmp( kptr->symname, p->symname );
}


int
cmpidval( symbol *kptr, symbol *p )
{
    return kptr->symvalue - p->symvalue;
}



/*
 * DefineSymbol will create a record in memory, inserting it into an AVL tree (or creating the first record)
 */
void DefineSymbol( char *identifier,
                   long value,       /* value of symbol, label */
                   unsigned char symboltype )
{
    /* symbol is either address label or constant */
    symbol *foundsymbol;

    if ( ( foundsymbol = FindSymbol( identifier, globalroot ) ) == NULL ) /* Symbol not declared as global/extern */
    {
        DefLocalSymbol( identifier, value, symboltype );
    }
    else if ( foundsymbol->type & SYMXDEF )
    {
        if ( ( foundsymbol->type & SYMDEFINED ) == 0 )
        {
            /* symbol declared global, but not yet defined */
            foundsymbol->symvalue = value;
            foundsymbol->type |= ( symboltype | SYMDEFINED );       /* defined, and typed as address label or
                                                                 * constant */
            foundsymbol->owner = CURRENTMODULE;   /* owner of symbol is always creator */

            if ( pass1 && symtable && listing )
            {
                InsertPageRef( foundsymbol );     /* First element in list is definition of symbol */
                MovePageRefs( identifier, foundsymbol );   /* Move page references from possible forward
                                                         * referenced symbol  */
            }
        }
        else
        {
            /* global symbol already defined */
            ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_SYMBOL_REDEFINED, identifier );
        }
    }
    else
    {
        /* Extern declaration of symbol, now define local symbol. */
        /* the extern symbol is now no longer accessible */
        DefLocalSymbol( identifier, value, symboltype );
    }
}



static void DefLocalSymbol( char *identifier,
                            long value,     /* value of symbol, label */
                            unsigned char symboltype )
{
    /* symbol is either address label or constant */
    symbol *foundsymbol;

    if ( ( foundsymbol = FindSymbol( identifier, CURRENTMODULE->localroot ) ) == NULL )
    {
        /* Symbol not declared as local */
        foundsymbol = CreateSymbol( identifier, value, symboltype | SYMLOCAL | SYMDEFINED, CURRENTMODULE );
        insert( &CURRENTMODULE->localroot, foundsymbol, ( int ( * )( void *, void * ) ) cmpidstr );

        if ( pass1 && symtable && listing )
        {
            MovePageRefs( identifier, foundsymbol );    /* Move page references from forward referenced symbol */
        }
    }
    else if ( ( foundsymbol->type & SYMDEFINED ) == 0 )
    {
        /* symbol declared local, but not yet defined */
        foundsymbol->symvalue = value;
        foundsymbol->type |= symboltype | SYMLOCAL | SYMDEFINED;  /* local symbol type set to address
                                                                 * label or constant */
        foundsymbol->owner = CURRENTMODULE;       /* owner of symbol is always creator */

        if ( pass1 && symtable && listing )
        {
            InsertPageRef( foundsymbol ); /* First element in list is definition of symbol */
            MovePageRefs( identifier, foundsymbol );       /* Move page references from possible forward
                                                         * referenced symbol */
        }
    }
    else
    {
        /* local symbol already defined */
        ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_SYMBOL_REDEFINED, identifier );
    }
}


/*
 * Move pointer to list of page references from forward symbol and append it to first reference of defined symbol.
 */
void
MovePageRefs( char *identifier, symbol *definedsym )
{
    symbol *forwardsym;
    struct pageref *tmpref;

    if ( ( forwardsym = FindSymbol( identifier, CURRENTMODULE->notdeclroot ) ) != NULL )
    {
        if ( definedsym->references->firstref->pagenr == forwardsym->references->lastref->pagenr )
        {
            if ( forwardsym->references->firstref != forwardsym->references->lastref )
            {
                tmpref = forwardsym->references->firstref;        /* more than one reference */

                while ( tmpref->nextref != forwardsym->references->lastref )
                {
                    tmpref = tmpref->nextref;    /* get reference before last reference */
                }

                xfree0( tmpref->nextref ); /* remove redundant reference */
                tmpref->nextref = NULL;   /* end of list */
                forwardsym->references->lastref = tmpref;         /* update pointer to last reference */
                definedsym->references->firstref->nextref = forwardsym->references->firstref;
                definedsym->references->lastref = forwardsym->references->lastref;        /* forward page
                                                                                         * reference list
                                                                                         * appended  */
            }
            else
            {
                xfree0( forwardsym->references->firstref );    /* remove the redundant reference */
            }
        }
        else
        {
            definedsym->references->firstref->nextref = forwardsym->references->firstref;
            definedsym->references->lastref = forwardsym->references->lastref;
            /* last reference not on the same page as definition */
            /* forward page reference list now appended  */
        }

        xfree0( forwardsym->references ); /* remove pointer information to forward page reference list */
        forwardsym->references = NULL;
        /* symbol is not needed anymore, remove from symbol table of forward references */
        delete( &CURRENTMODULE->notdeclroot, forwardsym, ( int ( * )( void *, void * ) ) cmpidstr, ( void ( * )( void * ) ) FreeSym );
    }
}


/*
 * search for symbol in either local tree or global tree, return found pointer if defined/declared, otherwise return
 * NULL
 */
symbol *
GetSymPtr( char *identifier )
{
    symbol *symbolptr;            /* pointer to current search node in AVL tree */

    if ( ( symbolptr = FindSymbol( identifier, CURRENTMODULE->localroot ) ) == NULL )
    {
        if ( ( symbolptr = FindSymbol( identifier, globalroot ) ) == NULL )
        {
            if ( pass1 && symtable && listing_CPY )
            {
                if ( ( symbolptr = FindSymbol( identifier, CURRENTMODULE->notdeclroot ) ) == NULL )
                {
                    symbolptr = CreateSymbol( identifier, 0, SYM_NOTDEFINED, CURRENTMODULE );
                    insert( &CURRENTMODULE->notdeclroot, symbolptr, ( int ( * )( void *, void * ) ) cmpidstr );
                }
                else
                {
                    AppendPageRef( symbolptr );
                }      /* symbol found in forward referenced tree,

                                                 * note page reference */
            }

            return NULL;
        }
        else
        {
            if ( pass1 && symtable && listing )
            {
                AppendPageRef( symbolptr );    /* symbol found as global/extern declaration */
            }

            return symbolptr;     /* symbol at least declared - return pointer to it... */
        }
    }
    else
    {
        if ( pass1 && symtable && listing )
        {
            AppendPageRef( symbolptr );    /* symbol found as local declaration */
        }

        return symbolptr;         /* symbol at least declared - return pointer to it... */
    }
}



int
compidentifier( char *identifier, symbol *p )
{
    return strcmp( identifier, p->symname );
}


/*
 * return pointer to found symbol in a symbol tree, otherwise NULL if not found
 */
symbol *
FindSymbol( char *identifier,   /* pointer to current identifier */
            avltree *treeptr )
{
    /* pointer to root of AVL tree */
    symbol *found;

    if ( treeptr == NULL )
    {
        return NULL;
    }
    else
    {
        found = find( treeptr, identifier, ( int ( * )( void *, void * ) ) compidentifier );

        if ( found == NULL )
        {
            return NULL;
        }
        else
        {
            found->type |= SYMTOUCHED;
            return found;         /* symbol found (declared/defined) */
        }
    }
}



void DeclSymGlobal( char *identifier, unsigned char libtype )
{
    symbol *foundsym, *clonedsym;

    if ( ( foundsym = FindSymbol( identifier, CURRENTMODULE->localroot ) ) == NULL )
    {
        if ( ( foundsym = FindSymbol( identifier, globalroot ) ) == NULL )
        {
            foundsym = CreateSymbol( identifier, 0, SYM_NOTDEFINED | SYMXDEF | libtype, CURRENTMODULE );
            insert( &globalroot, foundsym, ( int ( * )( void *, void * ) ) cmpidstr ); /* declare symbol as global */
        }
        else
        {
            if ( foundsym->owner != CURRENTMODULE )
            {
                /* this symbol is declared in another module */
                if ( foundsym->type & SYMXREF )
                {
                    foundsym->owner = CURRENTMODULE;      /* symbol now owned by this module */
                    foundsym->type &= XREF_OFF;           /* re-declare symbol as global if symbol was */
                    foundsym->type |= SYMXDEF | libtype;  /* declared extern in another module */
                }
                else                                      /* cannot declare two identical global's */
                {
                    /* Already declared global */
                    ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_SYMBOL_REDECL_GLOBAL, identifier );
                }
            }
            else if ( ( foundsym->type & ( SYMXDEF | libtype ) ) != ( SYMXDEF | libtype ) )
            {
                /* re-declaration not allowed */
                ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_SYMBOL_REDECL, identifier );
            }
        }
    }
    else
    {
        if ( FindSymbol( identifier, globalroot ) == NULL )
        {
            /* If no global symbol of identical name has been created, then re-declare local symbol as global symbol */
            foundsym->type &= SYMLOCAL_OFF;
            foundsym->type |= SYMXDEF;
            clonedsym = CreateSymbol( foundsym->symname, foundsym->symvalue, foundsym->type, CURRENTMODULE );
            insert( &globalroot, clonedsym, ( int ( * )( void *, void * ) ) cmpidstr );

            /* original local symbol cloned as global symbol, now delete old local ... */
            delete( &CURRENTMODULE->localroot, foundsym, ( int ( * )( void *, void * ) ) cmpidstr, ( void ( * )( void * ) ) FreeSym );
        }
        else
        {
            /* already declared global */
            ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_SYMBOL_DECL_GLOBAL, identifier );
        }
    }
}



void DeclSymExtern( char *identifier, unsigned char libtype )
{
    symbol *foundsym, *extsym;

    if ( ( foundsym = FindSymbol( identifier, CURRENTMODULE->localroot ) ) == NULL )
    {
        if ( ( foundsym = FindSymbol( identifier, globalroot ) ) == NULL )
        {
            foundsym = CreateSymbol( identifier, 0, SYM_NOTDEFINED | SYMXREF | libtype, CURRENTMODULE );
            insert( &globalroot, foundsym, ( int ( * )( void *, void * ) ) cmpidstr ); /* declare symbol as extern */
        }
        else
        {
            if ( foundsym->owner == CURRENTMODULE )
            {
                if ( ( foundsym->type & ( SYMXREF | libtype ) ) != ( SYMXREF | libtype ) )
                    if ( sdcc_hacks )
                    {
                        foundsym->type = SYMXREF | libtype ;
                    }
                    else
                    {
                        ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_SYMBOL_REDECL, identifier );
                    }

                /* Re-declaration not allowed */
            }
        }
    }
    else
    {
        if ( FindSymbol( identifier, globalroot ) == NULL )
        {
            /* If no external symbol of identical name has been declared, then re-declare local
               symbol as external symbol, but only if local symbol is not defined yet */
            if ( ( foundsym->type & SYMDEFINED ) == 0 )
            {
                foundsym->type &= SYMLOCAL_OFF;
                foundsym->type |= ( SYMXREF | libtype );
                extsym = CreateSymbol( identifier, 0, foundsym->type, CURRENTMODULE );
                insert( &globalroot, extsym, ( int ( * )( void *, void * ) ) cmpidstr );

                /* original local symbol cloned as external symbol, now delete old local ... */
                delete( &CURRENTMODULE->localroot, foundsym, ( int ( * )( void *, void * ) ) cmpidstr, ( void ( * )( void * ) ) FreeSym );
            }
            else
            {
                ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_SYMBOL_DECL_LOCAL, identifier );
            }

            /* already declared local */
        }
        else if ( ( foundsym->type & ( SYMXREF | libtype ) ) != ( SYMXREF | libtype ) )
        {
            ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_SYMBOL_REDECL, identifier );
            /* re-declaration not allowed */
        }
    }
}



void
AppendPageRef( symbol *symptr )
{
    struct pageref *newref = NULL;

    if ( symptr->references->lastref != NULL )
        if ( symptr->references->lastref->pagenr == PAGENR ||
                symptr->references->firstref->pagenr == PAGENR )        /* symbol reference on the same page - ignore */
        {
            return;
        }

    newref = xcalloc_struct( struct pageref );
    /* new page reference of symbol - allocate... */
    newref->pagenr = PAGENR;
    newref->nextref = NULL;

    if ( symptr->references->lastref == NULL )
    {
        symptr->references->lastref = newref;
        symptr->references->firstref = newref;    /* First page reference in list */
    }
    else
    {
        symptr->references->lastref->nextref = newref;    /* current reference (last) points at new reference */
        symptr->references->lastref = newref;     /* ptr to last reference updated to new reference */
    }
}


void
InsertPageRef( symbol *symptr )
{
    struct pageref *newref = NULL, *tmpptr = NULL;

    if ( symptr->references->firstref != NULL )
        if ( symptr->references->firstref->pagenr == PAGENR )       /* symbol reference on the same page - ignore */
        {
            return;
        }

    newref = xcalloc_struct( struct pageref );
    newref->pagenr = PAGENR;
    newref->nextref = symptr->references->firstref;       /* next reference will be current first reference */

    if ( symptr->references->firstref == NULL )
    {
        /* If this is the first reference, then the... */
        symptr->references->firstref = newref;    /* Current reference (last) points at new reference */
        symptr->references->lastref = newref;     /* first page reference is also last page reference. */
    }
    else
    {
        symptr->references->firstref = newref;    /* Current reference (last) points at new reference */

        if ( newref->pagenr == symptr->references->lastref->pagenr )
        {
            /* last reference = new reference */
            tmpptr = newref;

            while ( tmpptr->nextref != symptr->references->lastref )
            {
                tmpptr = tmpptr->nextref;    /* get reference before last reference */
            }

            xfree0( tmpptr->nextref );    /* remove redundant reference */
            tmpptr->nextref = NULL;       /* end of list */
            symptr->references->lastref = tmpptr;         /* update pointer to last reference */
        }
    }
}


void DefineDefSym( char *identifier, long value, unsigned char symboltype, avltree **root )
{
    symbol *staticsym;

    if ( FindSymbol( identifier, *root ) == NULL )
    {
        staticsym = CreateSymbol( identifier, value, symboltype | SYMDEF | SYMDEFINED, NULL );
        insert( root, staticsym, ( int ( * )( void *, void * ) ) cmpidstr );
    }
    else
    {
        /* Symbol already defined */
        ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_SYMBOL_REDEFINED, identifier );
    }
}



void
FreeSym( symbol *node )
{
    struct pageref *pref, *tmpref;

    if ( node->references != NULL )
    {
        if ( node->references->firstref != NULL )
        {
            pref = node->references->firstref;    /* get first page reference in list */

            while ( pref != NULL ) /* free page reference list... */
            {
                tmpref = pref;
                pref = pref->nextref;
                xfree0( tmpref );
            }
        }

        xfree0( node->references ); /* Then remove head/end pointer record to list */
    }

    if ( node->symname != NULL )
    {
        xfree0( node->symname );    /* release symbol identifier */
    }

    xfree0( node );               /* then release the symbol record */
}


