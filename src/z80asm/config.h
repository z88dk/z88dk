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
*/

/* Pick up the default installation path */
#ifndef WIN32
#include "../config.h"
#endif

/* MSDOS definitions: */
#ifdef MSDOS
#define OS_ID "MSDOS"
#define MSDOS 1
#define DEFLIBDIR "c:\\z88dk\\lib\\"
#endif

/* UNIX definitions: */
#ifdef UNIX
#define OS_ID "UNIX"
#ifdef PREFIX
#define DEFLIBDIR PREFIX "/lib/"
#else
#define DEFLIBDIR "/usr/local/lib/z88dk/lib/"
#endif
#endif

/* QDOS definitions:  */
#ifdef QDOS
#define OS_ID "QDOS"
#define QDOS 1
#define ENDIAN 1
#define DEFLIBDIR ""
#endif

/* AMIGA definitions: */
#ifdef AMIGA
#define OS_ID "AMIGA"
#define AMIGA 1
#define ENDIAN 1
#define DEFLIBDIR "zcc:lib/"
#endif

/* WIN32 definitions: */
#ifdef WIN32
#define OS_ID "WIN32"
#define WIN32 1
#define DEFLIBDIR "c:\\z88dk\\lib\\"
#endif

#ifdef MSDOS
#define MAXCODESIZE 65532	/* MSDOS 64K heap boundary */
#else
#define MAXCODESIZE 65536
#endif

/* Some clever config-ing if we're using GNUC */
#ifdef __BIG_ENDIAN__
/* Sadly the compiler on OS-X falls over with the #if below... */
#define ENDIAN
#else
#ifdef __GNUC__
#if #cpu(m68k) || #cpu(sparc) || #cpu(hppa) || #cpu(powerpc)
#define ENDIAN 1
#endif
#endif	/* __GNUC__ */
#endif
