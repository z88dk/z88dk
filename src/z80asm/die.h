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

Exit with a fatal error, warn on stderr
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/die.h,v 1.5 2013-01-20 21:24:28 pauloscustodio Exp $ */
/* $Log: die.h,v $
/* Revision 1.5  2013-01-20 21:24:28  pauloscustodio
/* Updated copyright year to 2013
/*
/* Revision 1.4  2012/05/24 17:09:27  pauloscustodio
/* Unify copyright header
/*
/* Revision 1.3  2012/05/20 06:04:18  pauloscustodio
/* die() with exception instead of exit(1)
/*
/* Revision 1.2  2012/05/17 15:10:47  pauloscustodio
/* normalize constant for include-once #ifndef
/*
/* Revision 1.1  2012/05/17 14:40:39  pauloscustodio
/* Exit with a fatal error, warn on stderr
/*
/*
/* */

#ifndef DIE_H
#define DIE_H

#include "except.h"             /* CH_0004 : Exception mechanism to handle fatal errors */

/* fatal error on stderr with printf-like argument */
extern void die( e4c_exception_type exception, char *msg, ... );

/* warning on stderr with printf-like argument */
extern void warn( char *msg, ... );

#endif /* ndef DIE_H */
