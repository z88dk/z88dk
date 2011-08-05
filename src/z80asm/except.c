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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/except.c,v 1.1 2011-08-05 19:23:53 pauloscustodio Exp $ */
/* $Log: except.c,v $
/* Revision 1.1  2011-08-05 19:23:53  pauloscustodio
/* CH_0004 : Exception mechanism to handle fatal errors
/* Included exceptions4c 2.4, Copyright (c) 2011 Guillermo Calvo
/*
/*
/* */

#include "except.h"
#include "e4c.c"

/* exceptions */
E4C_DEFINE_EXCEPTION(EarlyReturnException, "early return from function", RuntimeException);
