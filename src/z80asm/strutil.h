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

Copyright (C) Paulo Custodio, 2011-2012

Utilities for string handling
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/strutil.h,v 1.7 2012-05-24 17:09:27 pauloscustodio Exp $ */
/* $Log: strutil.h,v $
/* Revision 1.7  2012-05-24 17:09:27  pauloscustodio
/* Unify copyright header
/*
/* Revision 1.6  2012/05/24 17:00:43  pauloscustodio
/* astyle
/*
/* Revision 1.5  2012/05/24 15:07:03  pauloscustodio
/* Rename safestr_t to sstr_t, keep length to speed-up appending chars
/*
/* Revision 1.4  2012/05/22 20:35:26  pauloscustodio
/* astyle
/*
/* Revision 1.3  2012/05/22 20:26:17  pauloscustodio
/* Safe strings
/* New type sstr_t to hold strings with size to prevent buffer overruns.
/* Remove strtoupper, use POSIX strupr instead
/*
/* Revision 1.2  2012/05/11 19:29:49  pauloscustodio
/* Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
/*         --mode=c
/*         --lineend=linux
/*         --indent=spaces=4
/*         --style=ansi --add-brackets
/*         --indent-switches --indent-classes
/*         --indent-preprocessor --convert-tabs
/*         --break-blocks
/*         --pad-oper --pad-paren-in --pad-header --unpad-paren
/*         --align-pointer=name
/*
/* Revision 1.1  2011/10/14 13:48:05  pauloscustodio
/* String utilities
/*
/*
/* */

#ifndef STRUTIL_H
#define STRUTIL_H

#include "memalloc.h"                   /* before any other include to enable memory leak detection */

#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#include "types.h"

/*-----------------------------------------------------------------------------
*   Safe strings : char array with the size
*
*   A sstr_t can be defined and initialized in the stack or as global with:
*
*       SSTR_DEFINE( name, maxsize );        // name isa sstr_t * name
*
*   To define a sstr_t pointing to an existent buffer, do:
*
*       char buffer[SIZE];
*       SSTR_DEFINE_REF( name, buffer, sizeof(buffer) );
*
*   The string keeps the length in an attribute to speed-up sstr_cat().
*   If the buffer is manipulated, sstr_sync_len() needs to be called
*   to synchronize the attribute with the string length.
*----------------------------------------------------------------------------*/
typedef struct sstr_t
{
    char    *data;              /* point char array */
    size_t  size;               /* allocated size */
    size_t  len;                /* sring length (excluding zero terminator) */
} sstr_t;

#define SSTR_DEFINE_REF(name, buffer, maxsize)   \
    sstr_t   name##_struct = { buffer, maxsize, (buffer[0] = 0) }; \
    sstr_t * name = & name##_struct

#define SSTR_DEFINE(name, maxsize)   \
    char        name##_data [ maxsize ] = "";   \
    SSTR_DEFINE_REF(name, name##_data, maxsize)

/* address of string chars */
#define sstr_data(self)  \
    ((self)->data)

/* string length (excluding zero terminator) */
#define sstr_len(self)   \
    ((self)->len)

/* sync length in case string was modified in place */
#define sstr_sync_len(self) \
    ((self)->len = strlen((self)->data))

/* clear a string */
#define sstr_clear(self) \
    ((self)->data[0] = (self)->len = 0)

/* set / cat from char * */
extern char *sstr_set( sstr_t *self, char *source );
extern char *sstr_cat( sstr_t *self, char *source );

/* sprintf-like set / cat */
extern char *sstr_fset( sstr_t *self, char *format, ... );
extern char *sstr_fcat( sstr_t *self, char *format, ... );
extern char *sstr_vfset( sstr_t *self, char *format, va_list argptr );
extern char *sstr_vfcat( sstr_t *self, char *format, va_list argptr );

/*-----------------------------------------------------------------------------
*   Utilities working on char *
*----------------------------------------------------------------------------*/

#endif /* ndef STRUTIL_H */

