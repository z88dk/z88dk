/*
List of fixed strings (e.g. include path)

Copyright (C) Paulo Custodio, 2011-2013

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/Attic/strlist.h,v 1.1 2013-12-26 23:42:27 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"		/* before any other include */
#include "class.h"
#include "types.h"
#include "queue.h"

/*-----------------------------------------------------------------------------
*   PUBLIC INTERFACE
*   StrList *list = NULL; 		// or OBJ_NEW(StrList);
*   StrList_push( &list, ".");	// calls OBJ_NEW if list is NULL
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
extern void         StrList_push( StrList **pself, char *string );
extern StrListElem *StrList_first( StrList *self );
extern StrListElem *StrList_next( StrListElem *iter );

extern BOOL StrList_empty( StrList *self );

/* 
* $Log: strlist.h,v $
* Revision 1.1  2013-12-26 23:42:27  pauloscustodio
* Replace StringList from strutil by StrList in new strlis.c, to keep lists of strings (e.g. directory search paths)
*
* Revision 1.3  2013/02/25 21:36:17  pauloscustodio
* Uniform the APIs of classhash, classlist, strhash, strlist
*
* Revision 1.2  2013/01/19 00:04:53  pauloscustodio
* Implement StrHash_clone, required change in API of class.h and all classes that used it.
*
* Revision 1.1  2012/05/24 21:42:42  pauloscustodio
* CH_0011 : new string list class to hold lists of strings
*
*/
