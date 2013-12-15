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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/module.c,v 1.2 2013-12-15 13:18:34 pauloscustodio Exp $
$Log: module.c,v $
Revision 1.2  2013-12-15 13:18:34  pauloscustodio
Move memory allocation routines to lib/xmalloc, instead of glib,
introduce memory leak report on exit and memory fence check.

Revision 1.1  2013/06/08 22:57:13  pauloscustodio
Embryo of Module structure


*/

#include "xmalloc.h"   /* before any other include */

#include "module.h"


