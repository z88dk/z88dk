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

List of strings (e.g. include path); strings kept in strpool.h
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/strlist.h,v 1.3 2013-02-25 21:36:17 pauloscustodio Exp $ */
/* $Log: strlist.h,v $
/* Revision 1.3  2013-02-25 21:36:17  pauloscustodio
/* Uniform the APIs of classhash, classlist, strhash, strlist
/*
/* Revision 1.2  2013/01/19 00:04:53  pauloscustodio
/* Implement StrHash_clone, required change in API of class.h and all classes that used it.
/*
/* Revision 1.1  2012/05/24 21:42:42  pauloscustodio
/* CH_0011 : new string list class to hold lists of strings
/*
/*
/* */

#ifndef STRLIST_H
#define STRLIST_H

#include "memalloc.h"   /* before any other include */
#include "class.h"
#include "types.h"
#include "queue.h"

/*-----------------------------------------------------------------------------
*   PUBLIC INTERFACE
*   StrList *list = OBJ_NEW(StrList);
*   StrList_push(list, ".");
*
*   StrListElem *iter; char *string;
*   for ( iter = StrList_first(list); iter != NULL; iter = StrList_next(iter) ) 
*	{ use iter->string }
*
*   OBJ_DELETE(StrList);
*----------------------------------------------------------------------------*/
typedef struct StrListElem
{
    char    *string;                /* string kept in strpool.h */

    TAILQ_ENTRY( StrListElem ) entries;   /* Tail queue. */
} StrListElem;

CLASS( StrList )
TAILQ_HEAD( StrListHead, StrListElem ) head; /* head of queue */
END_CLASS;

/* methods */
extern void         StrList_push( StrList *self, char *string );
extern StrListElem *StrList_first( StrList *self );
extern StrListElem *StrList_next( StrListElem *iter );

extern BOOL StrList_empty( StrList *self );

#endif /* ndef STRLIST_H */
