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

Data model of assember structures
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/model.h,v 1.2 2013-02-26 02:11:32 pauloscustodio Exp $ */
/* $Log: model.h,v $
/* Revision 1.2  2013-02-26 02:11:32  pauloscustodio
/* New model_symref.c with all symbol cross-reference list handling
/*
/* Revision 1.1  2013/02/19 22:52:40  pauloscustodio
/*
/*
/* */

#ifndef MODEL_H
#define MODEL_H

#include "memalloc.h"   /* before any other include */
#include "class.h"
#include "classlist.h"
#include "types.h"

/*-----------------------------------------------------------------------------
*   Cross reference list of symbol usage
*	Defined in model_symref.c
*----------------------------------------------------------------------------*/
CLASS( SymbolRef )
	int		page_nr;			/* page where symbol used/defined */
END_CLASS;

CLASS_LIST( SymbolRef );		/* list of references sorted by page_nr, with 
								   definition reference at head of list */

/* add a symbol reference, create the list if NULL */
extern void add_symbol_ref( SymbolRefList *list, int page_nr, BOOL defined );

/* concatenate two symbol reference lists */
extern void cat_symbol_refs( SymbolRefList *list, SymbolRefList *other );

#endif /* ndef MODEL_H */
