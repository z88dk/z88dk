/*
Keep pool of strings for all duration of the program.
Most keywords in input program are the same, no need to keep several copies
and manage strdup/free for each token.
Strings with the same contents are reused.

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/strpool.c,v 1.12 2014-07-06 15:45:39 pauloscustodio Exp $
*/

#include "xmalloc.h"
#include "init.h"
#include "queue.h"
#include "strpool.h"
#include "types.h"
#include "uthash.h"

#include <stdio.h>

/*-----------------------------------------------------------------------------
*   String pool
*----------------------------------------------------------------------------*/
typedef struct Element
{
    char *str;							/* xstrdup */

    UT_hash_handle hh;      			/* hash table */
} Element;

static Element *the_pool = NULL;		/* singleton */

/*-----------------------------------------------------------------------------
*   Init and Fini functions
*----------------------------------------------------------------------------*/
DEFINE_init()
{
    xmalloc_init();			/* force xmalloc to be terminated last */
    the_pool = NULL;
}

DEFINE_fini()
{
    Element *elem, *tmp;

    HASH_ITER( hh, the_pool, elem, tmp )
    {
#ifdef STRPOOL_DEBUG
        warn( "strpool: free %s\n", elem->str );
#endif
        HASH_DEL( the_pool, elem );
        xfree( elem->str );
        xfree( elem );
    }
}

/*-----------------------------------------------------------------------------
*   Initialize module
*----------------------------------------------------------------------------*/
void strpool_init( void )
{
    init();
}

/*-----------------------------------------------------------------------------
*   Add string to pool
*----------------------------------------------------------------------------*/
char *strpool_add( char *str )
{
    Element *elem;
    size_t num_chars;

    init();

    /* special case : NULL string */
    if ( str == NULL )
        return NULL;

    /* check if string exists already */
    num_chars = strlen( str );
    HASH_FIND( hh, the_pool, str, num_chars, elem );

    if ( elem )
        return elem->str;    /* found */

    /* add to elem */
    elem = xnew( Element );
    elem->str = xstrdup( ( char * ) str ); /* alloc string */

    HASH_ADD_KEYPTR( hh, the_pool, elem->str, num_chars, elem );

#ifdef STRPOOL_DEBUG
    warn( "strpool: add %s\n", elem->str );
#endif

    return elem->str;
}
