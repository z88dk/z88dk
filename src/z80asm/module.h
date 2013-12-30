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

Assembled module, i.e. result of assembling a .asm file

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/module.h,v 1.3 2013-12-30 02:05:32 pauloscustodio Exp $
$Log: module.h,v $
Revision 1.3  2013-12-30 02:05:32  pauloscustodio
Merge dynstr.c and safestr.c into lib/strutil.c; the new Str type
handles both dynamically allocated strings and fixed-size strings.
Replaced g_strchomp by chomp by; g_ascii_tolower by tolower;
g_ascii_toupper by toupper; g_ascii_strcasecmp by stricompare.

Revision 1.2  2013/12/15 13:18:34  pauloscustodio
Move memory allocation routines to lib/xmalloc, instead of glib,
introduce memory leak report on exit and memory fence check.

Revision 1.1  2013/06/08 22:57:13  pauloscustodio
Embryo of Module structure


*/

#ifndef MODULE_H
#define MODULE_H

#include "xmalloc.h"   /* before any other include */

#include "class.h"
#include "classlist.h"
#include "strutil.h"
#include "symtab.h"

/*-----------------------------------------------------------------------------
*   Code section, one assembly instruction
*----------------------------------------------------------------------------*/
CLASS(CodeSection)
	char    *source_filename;		/* input file name, kept in strpool */
	int		line_nr;				/* input line number */
	Str    *bytes;					/* bytes of this opcode */
END_CLASS;


#endif /* ndef MODULE_H */

