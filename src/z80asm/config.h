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

/* MSDOS definitions: 
#define OS_ID "MSDOS"
#define MSDOS 1
#define DEFLIBDIR "c:\\z88dk\\lib\\"
*/

/* UNIX definitions: */
#define OS_ID "UNIX"
#define UNIX 1
#define DEFLIBDIR "/usr/local/lib/z88dk/lib/"

/* QDOS definitions: 
#define OS_ID "QDOS"
#define QDOS 1
#define ENDIAN 1
#define DEFLIBDIR ""
*/

/* AMIGA definitions:
#define OS_ID "AMIGA"
#define AMIGA 1
#define ENDIAN 1
#define DEFLIBDIR "zcc:lib/"
*/

/* WIN32 definitions:
#define OS_ID "WIN32"
#define WIN32 1
#define DEFLIBDIR "c:\\z88dk\\lib\\"
*/

#ifdef MSDOS
#define MAXCODESIZE 65532	/* MSDOS 64K heap boundary */
#else
#define MAXCODESIZE 65536
#endif

/* Some clever config-ing if we're using GNUC */

#ifdef __GNUC__
#if #cpu(m68k) || #cpu(sparc) || #cpu(hppa)
#define ENDIAN 1
#endif
#endif	/* __GNUC__ */
