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

Str : Dynamic-length strings based on http://uthash.sourceforge.net/utstring
Using class.h for automatic garbage collection.
Strings may contain zero byte, length is defined by separate field.
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/dynstr.h,v 1.9 2013-12-15 13:18:33 pauloscustodio Exp $ */
/* $Log: dynstr.h,v $
/* Revision 1.9  2013-12-15 13:18:33  pauloscustodio
/* Move memory allocation routines to lib/xmalloc, instead of glib,
/* introduce memory leak report on exit and memory fence check.
/*
/* Revision 1.8  2013/09/24 00:05:35  pauloscustodio
/* Replaced chomp by g_strchomp; tolower by g_ascii_tolower;
/* toupper by g_ascii_toupper; stricompare by g_ascii_strcasecmp.
/* Removed normalize_eol.
/*
/* Revision 1.7  2013/05/01 21:10:49  pauloscustodio
/* Add getline to Str, converting EOL sequences to LF.
/*
/* Revision 1.6  2013/04/29 22:24:33  pauloscustodio
/* Add utility functions to convert end-of-line sequences CR, CRLF, LFCR, LF all to LF
/*
/* Revision 1.5  2013/02/28 00:32:35  pauloscustodio
/* New interface to Str to copy characters to string
/*
/* Revision 1.4  2013/02/22 17:21:29  pauloscustodio
/* Added chomp()
/*
/* Revision 1.3  2013/01/20 21:24:28  pauloscustodio
/* Updated copyright year to 2013
/*
/* Revision 1.2  2012/11/03 17:39:36  pauloscustodio
/* astyle, comments
/*
/* Revision 1.1  2012/06/14 15:03:45  pauloscustodio
/* CH_0014 : New Dynamic Strings that grow automatically on creation / concatenation
/*
/*
/* */

#ifndef DYNSTR_H
#define DYNSTR_H

#include "xmalloc.h"   /* before any other include */

#include "class.h"
#include "types.h"
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*-----------------------------------------------------------------------------
*   PUBLIC INTERFACE
*   Str *str = OBJ_NEW(Str);
*   OBJ_DELETE(Str);
*----------------------------------------------------------------------------*/
CLASS( Str )
	char    *data;      /* data bytes */
	size_t  size;       /* allocated size */
	size_t  len;        /* sring length (excluding zero terminator) */
END_CLASS;

/* address of string chars */
#define Str_data(self)  ((self)->data)

/* string length (excluding zero terminator) */
#define Str_len(self)   ((self)->len)

/* sync length in case string was modified in place */
#define Str_sync_len(self)  ((self)->len = strlen((self)->data))

/* expand if needed to store at least more num_chars plus a zero byte */
extern void Str_reserve( Str *self, size_t num_chars );

/* delete extra unused space */
extern void Str_unreserve( Str *self );

/* clear the string, keep allocated space */
#define Str_clear(self)     ((self)->data[0] = 0, (self)->len = 0)

/* set / cat from memory buffer, add always a zero byte after */
extern void Str_bset( Str *self, char *source, size_t size );
extern void Str_bcat( Str *self, char *source, size_t size );

/* set / cat from char */
extern void Str_chset( Str *self, char ch );
extern void Str_chcat( Str *self, char ch );

/* set / cat from char* */
#define Str_szset(self,source)  Str_bset((self),(source),strlen(source))
#define Str_szcat(self,source)  Str_bcat((self),(source),strlen(source))

/* set / cat from Str */
#define Str_set(self,source)    Str_bset((self),(source)->data,(source)->len)
#define Str_cat(self,source)    Str_bcat((self),(source)->data,(source)->len)

/* sprintf-like set / cat */
extern void Str_fset( Str *self, char *format, ... );
extern void Str_fcat( Str *self, char *format, ... );
extern void Str_vfset( Str *self, char *format, va_list argptr );
extern void Str_vfcat( Str *self, char *format, va_list argptr );

/* compare two Str */
#define Str_compare(s1,s2)  ((s1)->len < (s2)->len ? -1 : \
                             (s1)->len > (s2)->len ?  1 : \
                             memcmp((s1)->data, (s2)->data, (s1)->len))

/* remove end newlines and whitespace */
extern void Str_chomp( Str *self );

/* get one line from input, convert end-of-line sequences, 
   return string including one LF character
   return FALSE on end of input */
extern BOOL Str_getline( Str *self, FILE *fp );
 
#endif /* ndef DYNSTR_H */

