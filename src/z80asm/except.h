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

Wrapper module for e4c to setup compile-time defines
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/except.h,v 1.1 2011-08-05 19:23:53 pauloscustodio Exp $ */
/* $Log: except.h,v $
/* Revision 1.1  2011-08-05 19:23:53  pauloscustodio
/* CH_0004 : Exception mechanism to handle fatal errors
/* Included exceptions4c 2.4, Copyright (c) 2011 Guillermo Calvo
/*
/*
/* */

#ifndef EXCEPT_H
#define EXCEPT_H

#include "memalloc.h"			/* before any other include to enable memory leak detection */

#ifndef __NO_INLINE__
#define __NO_INLINE__			/* gcc -O2 fails on "__extension__ inline" */
#endif

#define _E4C_FUNCTION_NAME	NULL	/* gcc -O2 fails on "__extension__ __FUNCTION__" */

#include "e4c.h"

/* exceptions */
E4C_DECLARE_EXCEPTION(EarlyReturnException);


#endif /* ndef EXCEPT_H */
