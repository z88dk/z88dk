/*
Keep pool of strings for all duration of the program.
Most keywords in input program are the same, no need to keep several copies
and manage strdup/free for each token.
Strings with the same contents are reused.

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/strpool.c,v 1.7 2014-05-06 22:17:38 pauloscustodio Exp $
*/

#include "xmalloc.h"
#include "die.h"
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
    char *str;					/* xstrdup */

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
    UINT num_chars;

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

/*
* $Log: strpool.c,v $
* Revision 1.7  2014-05-06 22:17:38  pauloscustodio
* Made types BYTE, UINT and ULONG all-caps to avoid conflicts with /usr/include/i386-linux-gnu/sys/types.h
*
* Revision 1.6  2014/05/02 21:34:58  pauloscustodio
* byte_t, uint_t and ulong_t renamed to BYTE, UINT and ULONG
*
* Revision 1.5  2014/03/05 23:44:55  pauloscustodio
* Renamed 64-bit portability to BUG_0042
*
* Revision 1.4  2014/02/19 23:59:27  pauloscustodio
* BUG_0042: 64-bit portability issues
* size_t changes to unsigned long in 64-bit. Usage of size_t * to
* retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
* breaks on a 64-bit architecture. Make the functions return the value instead
* of being passed the pointer to the return value, so that the compiler
* takes care of size convertions.
* Create UINT and ULONG, use UINT instead of size_t.
*
* Revision 1.3  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.2  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.1  2013/12/18 01:46:22  pauloscustodio
* Move strpool.c to the z80asm/lib directory
*
* Revision 1.6  2013/06/08 23:09:06  pauloscustodio
* Show strpool on exit if DEBUG
*
* Revision 1.5  2013/03/30 00:00:26  pauloscustodio
* Accept special case NULL in strpool_add, return NULL
*
* Revision 1.4  2013/01/20 21:24:28  pauloscustodio
* Updated copyright year to 2013
*
* Revision 1.3  2013/01/19 01:33:16  pauloscustodio
* Clean-up strpool code
*
* Revision 1.1  2012/05/24 17:50:02  pauloscustodio
* CH_0010 : new string pool to hold strings for all program duration
*
*/
