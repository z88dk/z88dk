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
Copyright (C) Paulo Custodio, 2011-2013
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/config.h,v 1.20 2013-01-20 21:24:28 pauloscustodio Exp $ */
/* $Log: config.h,v $
/* Revision 1.20  2013-01-20 21:24:28  pauloscustodio
/* Updated copyright year to 2013
/*
/* Revision 1.19  2012/05/24 17:09:27  pauloscustodio
/* Unify copyright header
/*
/* Revision 1.18  2012/05/11 19:29:49  pauloscustodio
/* Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
/*         --mode=c
/*         --lineend=linux
/*         --indent=spaces=4
/*         --style=ansi --add-brackets
/*         --indent-switches --indent-classes
/*         --indent-preprocessor --convert-tabs
/*         --break-blocks
/*         --pad-oper --pad-paren-in --pad-header --unpad-paren
/*         --align-pointer=name
/*
/* Revision 1.17  2011/08/21 20:19:47  pauloscustodio
/* Define FILEEXT_SEPARATOR as ".", or "_" on QDOS
/*
/* Revision 1.16  2011/07/09 18:25:35  pauloscustodio
/* Log keyword in checkin comment was expanded inside Log expansion... recursive
/* Added Z80asm banner to all source files
/*
/* Revision 1.15  2011/07/09 17:36:09  pauloscustodio
/* Copied cvs log into Log history
/*
/* Revision 1.14  2011/07/09 01:46:00  pauloscustodio
/* Added Log keyword
/*
/* Revision 1.13  2011/07/09 01:38:02  pauloscustodio
/* *** empty log message ***
/*
/* Revision 1.12  2011/07/09 01:16:47  pauloscustodio
/* added RCS keywords
/*
/* Revision 1.11  2007/06/24 16:41:41  dom
/* Don't use config.h for win32
/*
/* Revision 1.10  2002/12/09 18:49:46  dom
/* simplified the makefiles somewhat, allow cross building for Amiga on linux
/*
/* Revision 1.9  2002/12/01 15:47:17  dom
/* local install on unix resolved
/*
/* Revision 1.8  2002/12/01 15:11:51  dom
/* OS-X compile trickery
/*
/* Revision 1.7  2002/11/05 11:45:56  dom
/* powerpc endian detection
/*
/* fix for 64 bit machines, sizeof(long) != 4
/*
/* Revision 1.6  2002/10/03 21:17:17  dom
/* change the amiga default dir to zcc: to match with zcc
/*
/* Revision 1.5  2002/07/15 16:30:03  dom
/* changed default path
/*
/* Revision 1.4  2001/04/20 10:44:26  dom
/* *** empty log message ***
/*
/* Revision 1.3  2001/03/12 13:37:44  dom
/* *** empty log message ***
/*
/* Revision 1.2  2001/01/23 10:00:09  dom
/* Changes by x1cygnus:
/*
/* just added a harcoded macro Invoke, similar to callpkg except that the
/* instruction 'Invoke' resolves to a call by default (ti83) and to a RST if
/* the parameter -plus is specified on the command line.
/*
/* Changes by dom:
/* Added in a rudimentary default directory set up (Defined at compile time)
/* a bit kludgy and not very nice!
/*
/* Revision 1.1  2000/07/04 15:33:29  dom
/* branches:  1.1.1;
/* Initial revision
/*
/* Revision 1.1.1.1  2000/07/04 15:33:29  dom
/* First import of z88dk into the sourceforge system <gulp>
/*
/* */

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
#define MAXCODESIZE 65532       /* MSDOS 64K heap boundary */
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
#endif  /* __GNUC__ */
#endif

/* File name extension separator */
#ifdef QDOS
#define FILEEXT_SEPARATOR "_"
#else
#define FILEEXT_SEPARATOR "."
#endif


