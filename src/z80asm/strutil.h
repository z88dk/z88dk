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

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2012

Utilities for string handling
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/strutil.h,v 1.3 2012-05-22 20:26:17 pauloscustodio Exp $ */
/* $Log: strutil.h,v $
/* Revision 1.3  2012-05-22 20:26:17  pauloscustodio
/* Safe strings
/* New type safestr_t to hold strings with size to prevent buffer overruns.
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
*   A safestr_t can be defined and initialized in the stack or as global with:
*
*       SAFESTR_DEFINE( name, maxsize );        // name isa safestr_t * name
*
*	To define a safestr_t pointing to an existent buffer, do:
*
*		char buffer[SIZE];
*		SAFESTR_DEFINE_REF( name, buffer, sizeof(buffer) );
*
*----------------------------------------------------------------------------*/
typedef struct safestr_t
{
    char    *data;              /* point char array */
    size_t  size;               /* allocated size */
} safestr_t;

#define SAFESTR_DEFINE_REF(name, buffer, maxsize)   \
    safestr_t   name##_struct = { buffer, maxsize }; \
    safestr_t * name = & name##_struct

#define SAFESTR_DEFINE(name, maxsize)   \
    char        name##_data [ maxsize ] = "";   \
	SAFESTR_DEFINE_REF(name, name##_data, maxsize)

/* address of string chars */
#define safestr_data(self)  \
    ((self)->data)

/* string length (excluding zero terminator) */
#define safestr_len(self)   \
    strlen((self)->data)

/* clear a string */
#define safestr_clear(self) \
    ((self)->data[0] = 0)

/* set / cat from char * */
extern char *safestr_set( safestr_t *self, char *source );
extern char *safestr_cat( safestr_t *self, char *source );

/* sprintf-like set / cat */
extern char *safestr_fset( safestr_t *self, char *format, ... );
extern char *safestr_fcat( safestr_t *self, char *format, ... );
extern char *safestr_vfset( safestr_t *self, char *format, va_list argptr );
extern char *safestr_vfcat( safestr_t *self, char *format, va_list argptr );

/*-----------------------------------------------------------------------------
*   Utilities working on char *
*----------------------------------------------------------------------------*/

#endif /* ndef STRUTIL_H */

