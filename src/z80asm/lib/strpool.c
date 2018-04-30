/*
Z88DK Z80 Macro Assembler

Keep pool of strings for all duration of the program.

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#include "alloc.h"
#include "init.h"
#include "strpool.h"
#include "types.h"
#include "uthash.h"
#include <stdio.h>

/*-----------------------------------------------------------------------------
*   String pool
*----------------------------------------------------------------------------*/
typedef struct PoolStr
{
    UT_hash_handle hh;      			/* hash table */
    char str[1];						/* string extends from str */
} PoolStr;

static PoolStr *the_pool = NULL;		/* singleton */

/*-----------------------------------------------------------------------------
*   Init and Fini functions
*----------------------------------------------------------------------------*/
DEFINE_init_module()
{
	m_alloc_init();						/* force alloc to be terminated last */
}

DEFINE_dtor_module()
{
    PoolStr *elem, *tmp;

    HASH_ITER( hh, the_pool, elem, tmp )
    {
        HASH_DEL( the_pool, elem );
        m_free( elem );
    }
}

/*-----------------------------------------------------------------------------
*   Initialize module
*----------------------------------------------------------------------------*/
void strpool_init( void )
{
    init_module();
}

/*-----------------------------------------------------------------------------
*   Check if string exists in pool
*----------------------------------------------------------------------------*/
char *strpool_exists(char *str)
{
	PoolStr *elem;

	init_module();

	/* special case : NULL string */
	if (str == NULL)
		return NULL;

	/* check if string exists already */
	HASH_FIND_STR(the_pool, str, elem);

	return elem ? elem->str : NULL;			/* NULL if not found */
}

/*-----------------------------------------------------------------------------
*   Add string to pool
*----------------------------------------------------------------------------*/
char *strpool_add( char *str )
{
    PoolStr *elem;
	char *pool_str;

    init_module();

    /* special case : NULL string */
    if ( str == NULL )
        return NULL;

    /* check if string exists already */
	pool_str = strpool_exists(str);
    if ( pool_str )
        return pool_str;		/* found */

    /* add to elem */
	elem = m_calloc(1, offsetof(PoolStr, str) + strlen(str) + 1);
	strcpy(elem->str, str);

    HASH_ADD_STR(the_pool, str, elem );

    return elem->str;
}
