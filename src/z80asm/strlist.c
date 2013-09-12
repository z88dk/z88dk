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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/strlist.c,v 1.7 2013-09-12 00:10:02 pauloscustodio Exp $ */
/* $Log: strlist.c,v $
/* Revision 1.7  2013-09-12 00:10:02  pauloscustodio
/* Create g_free0() macro that NULLs the pointer after free, required
/* by z80asm to find out if a pointer was already freed.
/*
/* Revision 1.6  2013/09/08 08:29:21  pauloscustodio
/* Replaced xmalloc et al with g_malloc0 et al.
/*
/* Revision 1.5  2013/09/01 18:46:01  pauloscustodio
/* Remove call to strpool_init(). String pool is initialized in init.c before main() starts.
/*
/* Revision 1.4  2013/02/27 20:47:30  pauloscustodio
/* Renamed StrList to SzList to solve conflict with CLASS_LIST( Str ) also generating a class StrList
/*
/* Revision 1.3  2013/02/25 21:36:17  pauloscustodio
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

#include "memalloc.h"   /* before any other include */
#include "strlist.h"
#include "strpool.h"

/*-----------------------------------------------------------------------------
*   Define the class
*----------------------------------------------------------------------------*/
DEF_CLASS( SzList );

void SzList_init( SzList *self )
{
    TAILQ_INIT( &self->head );
}

void SzList_copy( SzList *self, SzList *other )
{
    SzListElem *elem;

    /* create new list and copy element by element from other */
    TAILQ_INIT( &self->head );

    TAILQ_FOREACH( elem, &other->head, entries )
    {
		SzList_push( self, elem->string );
    }
}

void SzList_fini( SzList *self )
{
    SzListElem *elem;

    while ( elem = TAILQ_FIRST( &self->head ) )
    {
        TAILQ_REMOVE( &self->head, elem, entries );
        g_free0( elem );
    }
}

/*-----------------------------------------------------------------------------
*   append a string to the list
*----------------------------------------------------------------------------*/
void SzList_push( SzList *self, char *string )
{
    SzListElem *elem;

    elem = g_new0( SzListElem, 1 );
    elem->string = strpool_add( string );
    TAILQ_INSERT_TAIL( &self->head, elem, entries );
}

/*-----------------------------------------------------------------------------
*   itereate through list
*----------------------------------------------------------------------------*/
SzListElem *SzList_first( SzList *self )
{
    return TAILQ_FIRST( &self->head );
}

SzListElem *SzList_next( SzListElem *iter )
{
    return iter == NULL ? NULL :
				TAILQ_NEXT( iter, entries );
}

/*-----------------------------------------------------------------------------
*   check if list is empty
*----------------------------------------------------------------------------*/
BOOL SzList_empty( SzList *self )
{
	return SzList_first(self) == NULL ? TRUE : FALSE;
}
