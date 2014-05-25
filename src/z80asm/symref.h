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

Cross reference list of symbol usage

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/symref.h,v 1.7 2014-05-25 01:02:29 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */

#include "class.h"
#include "classlist.h"
#include "types.h"

/*-----------------------------------------------------------------------------
*   Cross reference list of symbol usage
*----------------------------------------------------------------------------*/
CLASS( SymbolRef )
	int		page_nr;			/* page where symbol used/defined */
END_CLASS;

CLASS_LIST( SymbolRef );		/* list of references sorted by page_nr, with
								   definition reference at head of list */

/* add a symbol reference, create the list if NULL */
extern void add_symbol_ref( SymbolRefList *list, int page_nr, Bool defined );


/*
* $Log: symref.h,v $
* Revision 1.7  2014-05-25 01:02:29  pauloscustodio
* Byte, Int, UInt added
*
* Revision 1.6  2014/04/12 11:57:02  pauloscustodio
* whitespace
*
* Revision 1.5  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.4  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
* 
* Revision 1.3  2013/12/15 13:18:34  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
* 
* Revision 1.2  2013/10/01 22:50:27  pauloscustodio
* Parse command line options via look-up tables:
* -s, --symtable
* -ns, --no-symtable
* 
* Revision 1.1  2013/05/16 23:39:49  pauloscustodio
* Move struct node to sym.c, rename to Symbol
* Move SymbolRef to symref.c
* 
*/
