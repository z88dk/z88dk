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

Keep pool of strings for all duration of the program.
Most keywords in input program are the same, no need to keep several copies
and manage strdup/free for each token.
Strings with the same contents are reused.
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/strpool.c,v 1.6 2013-06-08 23:09:06 pauloscustodio Exp $ */
/* $Log: strpool.c,v $
/* Revision 1.6  2013-06-08 23:09:06  pauloscustodio
/* Show strpool on exit if DEBUG
/*
/* Revision 1.5  2013/03/30 00:00:26  pauloscustodio
/* Accept special case NULL in strpool_add, return NULL
/*
/* Revision 1.4  2013/01/20 21:24:28  pauloscustodio
/* Updated copyright year to 2013
/*
/* Revision 1.3  2013/01/19 01:33:16  pauloscustodio
/* Clean-up strpool code
/*
/* Revision 1.1  2012/05/24 17:50:02  pauloscustodio
/* CH_0010 : new string pool to hold strings for all program duration
/*
/*
/* */

#include "memalloc.h"   /* before any other include */
#include "strpool.h"
#include "class.h"
#include "types.h"
#include "uthash.h"
#include "queue.h"

/*-----------------------------------------------------------------------------
*   String pool entry
*----------------------------------------------------------------------------*/
typedef struct StrPoolEntry
{
    char    *string;        /* xstrdup */

    UT_hash_handle hh;      /* hash table */

} StrPoolEntry;

/*-----------------------------------------------------------------------------
*   Class
*----------------------------------------------------------------------------*/
CLASS( StrPool )
StrPoolEntry	*hash;
END_CLASS;

DEF_CLASS( StrPool );

static StrPool *str_pool = NULL;	/* sigleton */

/*-----------------------------------------------------------------------------
*   Initialize
*----------------------------------------------------------------------------*/
void StrPool_init( StrPool *self )   
{
	self->hash = NULL;
}

/*-----------------------------------------------------------------------------
*   Clone
*----------------------------------------------------------------------------*/
void StrPool_copy( StrPool *self, StrPool *other )
{
	/* clone points to the same hash - sigleton */
}

/*-----------------------------------------------------------------------------
*   Add and return string
*----------------------------------------------------------------------------*/
char *StrPool_add( StrPool *self, char *string )
{
	StrPoolEntry *elem;
    size_t num_chars;
	
	/* special case : NULL string */
	if ( string == NULL ) 
	{
		return NULL;
	}
	
    /* check if string exists already */
	num_chars = strlen( string );
    HASH_FIND( hh, self->hash, string, num_chars, elem );
    if ( elem )
    {
        return elem->string;    /* found */
    }

    /* add to elem */
    elem = xcalloc_struct( StrPoolEntry );
    elem->string = xstrdup( string );   /* alloc string */

    HASH_ADD_KEYPTR( hh, self->hash, elem->string, num_chars, elem );

    return elem->string;
}

/*-----------------------------------------------------------------------------
*   Delete all
*----------------------------------------------------------------------------*/
void StrPool_fini( StrPool *self )
{
    StrPoolEntry *elem, *tmp;

    HASH_ITER( hh, self->hash, elem, tmp )
    {
#ifdef DEBUG
		puts( elem->string );
#endif
        HASH_DEL( self->hash, elem );
        xfree( elem->string );
        xfree( elem );
    }
}


/*-----------------------------------------------------------------------------
*   Public interface
*----------------------------------------------------------------------------*/
char *strpool_add( char *string )
{
    strpool_init();
    return StrPool_add( str_pool, string );
}

void strpool_init( void )
{
    /* create object to destory hash on first time */
    if ( str_pool == NULL )
    {
        str_pool = OBJ_NEW( StrPool );
    }
}
