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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/symbols.c,v 1.8 2011-07-09 18:25:35 pauloscustodio Exp $ */
/* $Log: symbols.c,v $
/* Revision 1.8  2011-07-09 18:25:35  pauloscustodio
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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "config.h"
#include "symbol.h"


/* external functions */
void ReportError (char *filename, int linenr, int errnum);

/* local functions */
struct symref *AllocSymRef (void);
struct pageref *AllocPageRef (void);
symbol *GetSymPtr (char *identifier);
symbol *FindSymbol (char *identifier, avltree * treeptr);
symbol *AllocSymbol (void);
symbol *CreateSymbol (char *identifier, long value, unsigned char symboltype, struct module *symowner);
char *AllocIdentifier (size_t len);
int DefineSymbol (char *identifier, long value, unsigned char symboltype);
int DefLocalSymbol (char *identifier, long value, unsigned char symboltype);
int DefineDefSym (char *identifier, long value, unsigned char symtype, avltree ** root);
int cmpidstr (symbol * kptr, symbol * p);
int cmpidval (symbol * kptr, symbol * p);
void InsertPageRef (symbol * symptr);
void AppendPageRef (symbol * symptr);
void DeclSymGlobal (char *identifier, unsigned char libtype);
void DeclSymExtern (char *identifier, unsigned char libtype);
void MovePageRefs (char *identifier, symbol * definedsym);
void FreeSym (symbol * node);


/* global variables */
extern int PAGENR;
extern enum flag symtable, listing, listing_CPY, pass1, sdcc_hacks;
extern struct module *CURRENTMODULE;	/* pointer to current module */
extern avltree *globalroot;


symbol *
CreateSymbol (char *identifier, long value, unsigned char symboltype, struct module *symowner)
{
  symbol *newsym;

  if ((newsym = AllocSymbol ()) == NULL)
    {				/* Create area for a new symbol structure */
      ReportError (NULL, 0, 3);
      return NULL;
    }
  newsym->symname = AllocIdentifier (strlen (identifier) + 1);	/* Allocate area for a new symbol identifier */
  if (newsym->symname != NULL)
    strcpy (newsym->symname, identifier);	/* store identifier symbol */
  else
    {
      free (newsym);		/* Ups no more memory left.. */
      ReportError (NULL, 0, 3);
      return NULL;
    }
  if (symtable && listing_CPY)
    {
      if ((newsym->references = AllocSymRef ()) == NULL)
	{			/* Create area for a new symbol structure */
	  free (newsym->symname);
	  free (newsym);	/* release created records */
	  ReportError (NULL, 0, 3);
	  return NULL;
	}
      newsym->references->firstref = NULL;
      newsym->references->lastref = NULL;	/* Page reference list initialised... */
      AppendPageRef (newsym);	/* store first page reference in listfile of this symbol */
    }
  else
    newsym->references = NULL;	/* No listing file, no page references... */

  newsym->owner = symowner;
  newsym->type = symboltype;
  newsym->symvalue = value;

  return newsym;		/* pointer to new symbol node */
}



int 
cmpidstr (symbol * kptr, symbol * p)
{
  return strcmp (kptr->symname, p->symname);
}


int 
cmpidval (symbol * kptr, symbol * p)
{
  return kptr->symvalue - p->symvalue;
}



/*
 * DefineSymbol will create a record in memory, inserting it into an AVL tree (or creating the first record)
 */
int 
DefineSymbol (char *identifier,
	      long value,	/* value of symbol, label */
	      unsigned char symboltype)
{				/* symbol is either address label or constant */
  symbol *foundsymbol;

  if ((foundsymbol = FindSymbol (identifier, globalroot)) == NULL)	/* Symbol not declared as global/extern */
    return DefLocalSymbol (identifier, value, symboltype);
  else if (foundsymbol->type & SYMXDEF)
    {
      if ((foundsymbol->type & SYMDEFINED) == 0)
	{			/* symbol declared global, but not yet defined */
	  foundsymbol->symvalue = value;
	  foundsymbol->type |= (symboltype | SYMDEFINED);	/* defined, and typed as address label or
								 * constant */
	  foundsymbol->owner = CURRENTMODULE;	/* owner of symbol is always creator */
	  if (pass1 && symtable && listing)
	    {
	      InsertPageRef (foundsymbol);	/* First element in list is definition of symbol */
	      MovePageRefs (identifier, foundsymbol);	/* Move page references from possible forward
							 * referenced symbol  */
	    }
	  return 1;
	}
      else
	{
	  ReportError (CURRENTFILE->fname, CURRENTFILE->line, 14);	/* global symbol already defined */
	  return 0;
	}
    }
  else
    return DefLocalSymbol (identifier, value, symboltype);	/* Extern declaration of symbol, now define
								 * local symbol. */
  /* the extern symbol is now no longer accessible */
}



int 
DefLocalSymbol (char *identifier,
		long value,	/* value of symbol, label */
		unsigned char symboltype)
{				/* symbol is either address label or constant */
  symbol *foundsymbol;

  if ((foundsymbol = FindSymbol (identifier, CURRENTMODULE->localroot)) == NULL)
    {				/* Symbol not declared as local */
      foundsymbol = CreateSymbol (identifier, value, symboltype | SYMLOCAL | SYMDEFINED, CURRENTMODULE);
      if (foundsymbol == NULL)
	return 0;
      else
        insert (&CURRENTMODULE->localroot, foundsymbol, (int (*)(void*,void*)) cmpidstr);

      if (pass1 && symtable && listing)
	MovePageRefs (identifier, foundsymbol);		/* Move page references from forward referenced symbol */
      return 1;
    }
  else if ((foundsymbol->type & SYMDEFINED) == 0)
    {				/* symbol declared local, but not yet defined */
      foundsymbol->symvalue = value;
      foundsymbol->type |= symboltype | SYMLOCAL | SYMDEFINED;	/* local symbol type set to address
								 * label or constant */
      foundsymbol->owner = CURRENTMODULE;	/* owner of symbol is always creator */
      if (pass1 && symtable && listing)
	{
	  InsertPageRef (foundsymbol);	/* First element in list is definition of symbol */
	  MovePageRefs (identifier, foundsymbol);	/* Move page references from possible forward
							 * referenced symbol */
	}
      return 1;
    }
  else
    {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 14);	/* local symbol already defined */
      return 0;
    }
}


/*
 * Move pointer to list of page references from forward symbol and append it to first reference of defined symbol.
 */
void 
MovePageRefs (char *identifier, symbol * definedsym)
{
  symbol *forwardsym;
  struct pageref *tmpref;

  if ((forwardsym = FindSymbol (identifier, CURRENTMODULE->notdeclroot)) != NULL)
    {
      if (definedsym->references->firstref->pagenr == forwardsym->references->lastref->pagenr)
	{
	  if (forwardsym->references->firstref != forwardsym->references->lastref)
	    {
	      tmpref = forwardsym->references->firstref;	/* more than one reference */
	      while (tmpref->nextref != forwardsym->references->lastref)
		tmpref = tmpref->nextref;	/* get reference before last reference */
	      free (tmpref->nextref);	/* remove redundant reference */
	      tmpref->nextref = NULL;	/* end of list */
	      forwardsym->references->lastref = tmpref;		/* update pointer to last reference */
	      definedsym->references->firstref->nextref = forwardsym->references->firstref;
	      definedsym->references->lastref = forwardsym->references->lastref;	/* forward page
											 * reference list
											 * appended  */
	    }
	  else
	    free (forwardsym->references->firstref);	/* remove the redundant reference */
	}
      else
	{
	  definedsym->references->firstref->nextref = forwardsym->references->firstref;
	  definedsym->references->lastref = forwardsym->references->lastref;
	  /* last reference not on the same page as definition */
	  /* forward page reference list now appended  */
	}

      free (forwardsym->references);	/* remove pointer information to forward page reference list */
      forwardsym->references = NULL;
      /* symbol is not needed anymore, remove from symbol table of forward references */
      delete (&CURRENTMODULE->notdeclroot, forwardsym, (int (*)(void*,void*)) cmpidstr, (void (*)(void*)) FreeSym);
    }
}


/*
 * search for symbol in either local tree or global tree, return found pointer if defined/declared, otherwise return
 * NULL
 */
symbol *
GetSymPtr (char *identifier)
{
  symbol *symbolptr;		/* pointer to current search node in AVL tree */

  if ((symbolptr = FindSymbol (identifier, CURRENTMODULE->localroot)) == NULL)
    {
      if ((symbolptr = FindSymbol (identifier, globalroot)) == NULL)
	{
	  if (pass1 && symtable && listing_CPY)
	    {
	      if ((symbolptr = FindSymbol (identifier, CURRENTMODULE->notdeclroot)) == NULL)
		{
		  symbolptr = CreateSymbol (identifier, 0, SYM_NOTDEFINED, CURRENTMODULE);
		  if (symbolptr != NULL)
                    insert (&CURRENTMODULE->notdeclroot, symbolptr, (int (*)(void*,void*)) cmpidstr);
		}
	      else
		AppendPageRef (symbolptr);	/* symbol found in forward referenced tree,
						 * note page reference */
	    }
	  return NULL;
	}
      else
	{
	  if (pass1 && symtable && listing)
	    AppendPageRef (symbolptr);	/* symbol found as global/extern declaration */
	  return symbolptr;	/* symbol at least declared - return pointer to it... */
	}
    }
  else
    {
      if (pass1 && symtable && listing)
	AppendPageRef (symbolptr);	/* symbol found as local declaration */
      return symbolptr;		/* symbol at least declared - return pointer to it... */
    }
}



int 
compidentifier (char *identifier, symbol * p)
{
  return strcmp (identifier, p->symname);
}


/*
 * return pointer to found symbol in a symbol tree, otherwise NULL if not found
 */
symbol *
FindSymbol (char *identifier,	/* pointer to current identifier */
	    avltree * treeptr)
{				/* pointer to root of AVL tree */
  symbol *found;

  if (treeptr == NULL)
    return NULL;
  else
    {
      found = find (treeptr, identifier, (int (*)(void*,void*)) compidentifier);
      if (found == NULL)
	return NULL;
      else
	{
	  found->type |= SYMTOUCHED;
	  return found;		/* symbol found (declared/defined) */
	}
    }
}



void 
DeclSymGlobal (char *identifier, unsigned char libtype)
{
  symbol *foundsym, *clonedsym;

  if ((foundsym = FindSymbol (identifier, CURRENTMODULE->localroot)) == NULL)
    {
      if ((foundsym = FindSymbol (identifier, globalroot)) == NULL)
	{
	  foundsym = CreateSymbol (identifier, 0, SYM_NOTDEFINED | SYMXDEF | libtype, CURRENTMODULE);
	  if (foundsym != NULL)
            insert (&globalroot, foundsym, (int (*)(void*,void*)) cmpidstr);    /* declare symbol as global */
	}
      else
	{
	  if (foundsym->owner != CURRENTMODULE)
	    {						/* this symbol is declared in another module */
	      if (foundsym->type & SYMXREF)
		{
		  foundsym->owner = CURRENTMODULE;	/* symbol now owned by this module */
		  foundsym->type &= XREF_OFF;		/* re-declare symbol as global if symbol was */
		  foundsym->type |= SYMXDEF | libtype;	/* declared extern in another module */
		}
	      else								/* cannot declare two identical global's */
		ReportError (CURRENTFILE->fname, CURRENTFILE->line, 22);	/* Already declared global */
	    }
	  else if ( (foundsym->type & (SYMXDEF|libtype)) != (SYMXDEF|libtype) )
	    {
	      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 23);	/* re-declaration not allowed */
	    }
	}
    }
  else
   {
      if (FindSymbol (identifier, globalroot) == NULL)
        {
          /* If no global symbol of identical name has been created, then re-declare local symbol as global symbol */
          foundsym->type &= SYMLOCAL_OFF;
          foundsym->type |= SYMXDEF;
          clonedsym = CreateSymbol (foundsym->symname, foundsym->symvalue, foundsym->type, CURRENTMODULE);
	  if (clonedsym != NULL)
            {
              insert (&globalroot, clonedsym, (int (*)(void*,void*)) cmpidstr);

              /* original local symbol cloned as global symbol, now delete old local ... */
              delete (&CURRENTMODULE->localroot, foundsym, (int (*)(void*,void*)) cmpidstr, (void (*)(void*)) FreeSym);
            }
        }
      else
       {
	  ReportError (CURRENTFILE->fname, CURRENTFILE->line, 18);	/* already declared global */
       }
   }
}



void 
DeclSymExtern (char *identifier, unsigned char libtype)
{
  symbol *foundsym, *extsym;

  if ((foundsym = FindSymbol (identifier, CURRENTMODULE->localroot)) == NULL)
    {
      if ((foundsym = FindSymbol (identifier, globalroot)) == NULL)
	{
	  foundsym = CreateSymbol (identifier, 0, SYM_NOTDEFINED | SYMXREF | libtype, CURRENTMODULE);
	  if (foundsym != NULL)
            insert (&globalroot, foundsym, (int (*)(void*,void*)) cmpidstr);    /* declare symbol as extern */
	}
      else 
        {
          if (foundsym->owner == CURRENTMODULE) {
	if ( (foundsym->type & (SYMXREF | libtype)) != (SYMXREF |libtype) )
           if (sdcc_hacks) 
             foundsym->type=SYMXREF|libtype ;
           else
     	     ReportError (CURRENTFILE->fname, CURRENTFILE->line, 23);	/* Re-declaration not allowed */
      }
    }
    }
  else
   {
      if (FindSymbol (identifier, globalroot) == NULL)
        {
          /* If no external symbol of identical name has been declared, then re-declare local 
             symbol as external symbol, but only if local symbol is not defined yet */ 
          if ((foundsym->type & SYMDEFINED) == 0)
            {
              foundsym->type &= SYMLOCAL_OFF;
	      foundsym->type |= (SYMXREF | libtype);
	      extsym = CreateSymbol (identifier, 0, foundsym->type, CURRENTMODULE);
	      if (extsym != NULL)
                {
                  insert (&globalroot, extsym, (int (*)(void*,void*)) cmpidstr);

                  /* original local symbol cloned as external symbol, now delete old local ... */
                  delete (&CURRENTMODULE->localroot, foundsym, (int (*)(void*,void*)) cmpidstr, (void (*)(void*)) FreeSym);
                }
            }
          else
	    ReportError (CURRENTFILE->fname, CURRENTFILE->line, 17);	/* already declared local */
        }
      else if ( (foundsym->type & (SYMXREF|libtype)) != (SYMXREF|libtype) ) 
	{
	  ReportError (CURRENTFILE->fname, CURRENTFILE->line, 23);	/* re-declaration not allowed */
	}
   }
}



void 
AppendPageRef (symbol * symptr)
{
  struct pageref *newref = NULL;

  if (symptr->references->lastref != NULL)
    if (symptr->references->lastref->pagenr == PAGENR ||
	symptr->references->firstref->pagenr == PAGENR)		/* symbol reference on the same page - ignore */
      return;

  if ((newref = AllocPageRef ()) == NULL)
    {				/* new page reference of symbol - allocate... */
      ReportError (NULL, 0, 3);
      return;
    }
  else
    {
      newref->pagenr = PAGENR;
      newref->nextref = NULL;
    }

  if (symptr->references->lastref == NULL)
    {
      symptr->references->lastref = newref;
      symptr->references->firstref = newref;	/* First page reference in list */
    }
  else
    {
      symptr->references->lastref->nextref = newref;	/* current reference (last) points at new reference */
      symptr->references->lastref = newref;	/* ptr to last reference updated to new reference */
    }
}


void 
InsertPageRef (symbol * symptr)
{
  struct pageref *newref = NULL, *tmpptr = NULL;

  if (symptr->references->firstref != NULL)
    if (symptr->references->firstref->pagenr == PAGENR)		/* symbol reference on the same page - ignore */
      return;

  if ((newref = AllocPageRef ()) == NULL)
    {				/* new page reference of symbol - allocate... */
      ReportError (NULL, 0, 3);
      return;
    }
  else
    {
      newref->pagenr = PAGENR;
      newref->nextref = symptr->references->firstref;	/* next reference will be current first reference */
    }

  if (symptr->references->firstref == NULL)
    {				/* If this is the first reference, then the... */
      symptr->references->firstref = newref;	/* Current reference (last) points at new reference */
      symptr->references->lastref = newref;	/* first page reference is also last page reference. */
    }
  else
    {
      symptr->references->firstref = newref;	/* Current reference (last) points at new reference */
      if (newref->pagenr == symptr->references->lastref->pagenr)
	{			/* last reference = new reference */
	  tmpptr = newref;
	  while (tmpptr->nextref != symptr->references->lastref)
	    tmpptr = tmpptr->nextref;	/* get reference before last reference */
	  free (tmpptr->nextref);	/* remove redundant reference */
	  tmpptr->nextref = NULL;	/* end of list */
	  symptr->references->lastref = tmpptr;		/* update pointer to last reference */
	}
    }
}


int 
DefineDefSym (char *identifier, long value, unsigned char symtype, avltree ** root)
{
  symbol *staticsym;

  if (FindSymbol (identifier, *root) == NULL)
    {
      staticsym = CreateSymbol (identifier, value, symtype | SYMDEF | SYMDEFINED, NULL);
      if (staticsym != NULL)
	{
          insert (root, staticsym, (int (*)(void*,void*)) cmpidstr);
	  return 1;
	}
      else
	return 0;
    }
  else
    {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 14);	/* Symbol already defined */
      return 0;
    }
}



void 
FreeSym (symbol * node)
{
  struct pageref *pref, *tmpref;

  if (node->references != NULL)
    {
      if (node->references->firstref != NULL)
	{
	  pref = node->references->firstref;	/* get first page reference in list */
	  do
	    {
	      tmpref = pref;
	      pref = pref->nextref;
	      free (tmpref);
	    }
	  while (pref != NULL);	/* free page reference list... */
	}
      free (node->references);	/* Then remove head/end pointer record to list */
    }
  if (node->symname != NULL)
    free (node->symname);	/* release symbol identifier */
  free (node);			/* then release the symbol record */
}


symbol *
AllocSymbol (void)
{
  return (symbol *) malloc (sizeof (symbol));
}


struct symref *
AllocSymRef (void)
{
  return (struct symref *) malloc (sizeof (struct symref));
}


struct pageref *
AllocPageRef (void)
{
  return (struct pageref *) malloc (sizeof (struct pageref));
}


char *
AllocIdentifier (size_t len)
{
  return (char *) malloc (len);
}
