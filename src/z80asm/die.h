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
Copyright (C) Paulo Custodio, 2011

Exit with a fatal error, warn on stderr
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/die.h,v 1.1 2012-05-17 14:40:39 pauloscustodio Exp $ */
/* $Log: die.h,v $
/* Revision 1.1  2012-05-17 14:40:39  pauloscustodio
/* Exit with a fatal error, warn on stderr
/*
/*
/* */

#ifndef _DIE_H
#define _DIE_H

/* fatal error on stderr with printf-like argument */
extern void die( char *msg, ... );

/* warning on stderr with printf-like argument */
extern void warn( char *msg, ... );

#endif /* ndef _DIE_H */
