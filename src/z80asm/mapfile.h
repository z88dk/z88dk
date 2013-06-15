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

Mapfile writing - list of all local and global address symbols after link phase

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/mapfile.h,v 1.1 2013-06-15 00:26:23 pauloscustodio Exp $
$Log: mapfile.h,v $
Revision 1.1  2013-06-15 00:26:23  pauloscustodio
Move mapfile writing to mapfile.c.


*/

#ifndef MAPFILE_H
#define MAPFILE_H

#include "memalloc.h"   /* before any other include */

extern void write_map_file( void );

#endif /* ndef MAPFILE_H */

