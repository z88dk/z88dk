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
Changed to use GLib String Chunks
*/

#include "xmalloc.h"   /* before any other include */

#include "strpool.h"
#include "types.h"
#include <glib.h>

/*-----------------------------------------------------------------------------
*   Global String Chunks pool
*----------------------------------------------------------------------------*/
static GStringChunk *str_pool;

/*-----------------------------------------------------------------------------
*   Initialize and Terminate functions called by init()
*----------------------------------------------------------------------------*/
void init_strpool(void)
{
	str_pool = g_string_chunk_new( MAXLINE );
}

void fini_strpool(void)
{
	g_string_chunk_free( str_pool );
}

/*-----------------------------------------------------------------------------
*   Add a const string to the pool, return it's address; may be NULL
*----------------------------------------------------------------------------*/
char *strpool_add( char *string )
{
    return string == NULL ? 
			string : 
			g_string_chunk_insert_const( str_pool, string );
}


/* */
/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/strpool.c,v 1.9 2013-12-15 13:18:34 pauloscustodio Exp $ */
/* $Log: strpool.c,v $
/* Revision 1.9  2013-12-15 13:18:34  pauloscustodio
/* Move memory allocation routines to lib/xmalloc, instead of glib,
/* introduce memory leak report on exit and memory fence check.
/*
/* Revision 1.8  2013/09/08 00:36:42  pauloscustodio
/* strpool_add() accepts NULL
/*
/* Revision 1.7  2013/09/01 16:51:26  pauloscustodio
/* Replaced strpool code by GLib String Chunks.
/*
/* Revision 1.6  2013/06/08 23:09:06  pauloscustodio
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
/* */

