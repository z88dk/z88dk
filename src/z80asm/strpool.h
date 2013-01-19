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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/strpool.h,v 1.2 2013-01-19 01:33:16 pauloscustodio Exp $ */
/* $Log: strpool.h,v $
/* Revision 1.2  2013-01-19 01:33:16  pauloscustodio
/* Clean-up strpool code
/*
/* Revision 1.1  2012/05/24 17:50:02  pauloscustodio
/* CH_0010 : new string pool to hold strings for all program duration
/*
/*
/* */

#ifndef STRPOOL_H
#define STRPOOL_H

/* If the given string exists in the pool, return pointer to it.
   Else copies it to the pool and returns pointer
*/
extern char *strpool_add( char *string );

/* initialize module; called automatically by strpool_add(), but may be needed to force
   initialization on the T_init() function of a class that uses the pool, to make sure
   destruction is in the correct order (first T, then pool)
*/
extern void strpool_init( void );

#endif /* ndef STRPOOL_H */

