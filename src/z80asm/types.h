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

Common types
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/types.h,v 1.2 2012-05-17 15:10:47 pauloscustodio Exp $ */
/* $Log: types.h,v $
/* Revision 1.2  2012-05-17 15:10:47  pauloscustodio
/* normalize constant for include-once #ifndef
/*
/* Revision 1.1  2012/05/17 14:45:22  pauloscustodio
/* Common types
/*
/*
/* */

#ifndef TYPES_H
#define TYPES_H

/* bool type and constants */
typedef int bool;
#define FALSE 0
#define TRUE (!FALSE)

/* number of elements of an array */
#define NUM_ELEMS(x) (sizeof(x)/sizeof(x[0]))

#endif /* ndef TYPES_H */
