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

Define file writing - list of all global address symbols after link phase in DEFC format

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/deffile.h,v 1.1 2013-06-16 20:14:39 pauloscustodio Exp $
$Log: deffile.h,v $
Revision 1.1  2013-06-16 20:14:39  pauloscustodio
Move deffile writing to deffile.c, remove global variable deffile



*/

#ifndef DEFFILE_H
#define DEFFILE_H

#include "memalloc.h"   /* before any other include */

extern void write_def_file( void );

#endif /* ndef DEFFILE_H */

