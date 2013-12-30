/*
List of fixed strings (e.g. include path)

Copyright (C) Paulo Custodio, 2011-2013

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/Attic/strlist.c,v 1.2 2013-12-30 15:21:10 pauloscustodio Exp $
*/

#include "xmalloc.h"		/* before any other include */
#include "strlist.h"
#include "strpool.h"

/*-----------------------------------------------------------------------------
*   Define the class
*----------------------------------------------------------------------------*/
DEF_CLASS( StrList );

void StrList_init( StrList *self )
{
	strpool_init();
	
    TAILQ_INIT( &self->head );
}

void StrList_copy( StrList *self, StrList *other )
{
    StrListElem *elem;

    /* create new list and copy element by element from other */
    TAILQ_INIT( &self->head );

    TAILQ_FOREACH( elem, &other->head, entries )
    {
		StrList_push( &self, elem->string );
    }
}

void StrList_fini( StrList *self )
{
    StrListElem *elem;

    while ( ( elem = TAILQ_FIRST( &self->head ) ) != NULL )
    {
        TAILQ_REMOVE( &self->head, elem, entries );
        xfree( elem );
    }
}

/*-----------------------------------------------------------------------------
*   append a string to the list
*----------------------------------------------------------------------------*/
void StrList_push( StrList **pself, char *string )
{
    StrListElem *elem;

	INIT_OBJ( StrList, pself ); 
    elem = xnew( StrListElem );
    elem->string = strpool_add( string );
    TAILQ_INSERT_TAIL( & ((*pself)->head), elem, entries );
}

/*-----------------------------------------------------------------------------
*   itereate through list
*----------------------------------------------------------------------------*/
StrListElem *StrList_first( StrList *self )
{
    return self == NULL ? NULL : TAILQ_FIRST( &self->head );
}

StrListElem *StrList_next( StrListElem *iter )
{
    return iter == NULL ? NULL :
				TAILQ_NEXT( iter, entries );
}

/*-----------------------------------------------------------------------------
*   check if list is empty
*----------------------------------------------------------------------------*/
BOOL StrList_empty( StrList *self )
{
	return StrList_first(self) == NULL ? TRUE : FALSE;
}

/*
* $Log: strlist.c,v $
* Revision 1.2  2013-12-30 15:21:10  pauloscustodio
* Keep strings in strpool
*
* Revision 1.1  2013/12/26 23:42:27  pauloscustodio
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
