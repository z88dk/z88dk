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
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/options.h,v 1.3 2011-08-21 20:25:31 pauloscustodio Exp $ */
/* $Log: options.h,v $
/* Revision 1.3  2011-08-21 20:25:31  pauloscustodio
/* BUG_0012 : binfilename[] array is too short, should be FILENAME_MAX
/* CH_0005 : handle files as char[FILENAME_MAX] instead of strdup for every operation
/* - Factor all pathname manipulation into module file.c.
/* - Make default extensions constants.
/* - Move srcext[] and objext[] to the options.c module.
/*
/* Revision 1.2  2011/07/12 22:47:59  pauloscustodio
/* - Moved all error variables and error reporting code to a separate module errors.c,
/*   replaced all extern declarations of these variables by include errors.h,
/*   created symbolic constants for error codes.
/* - Added test scripts for error messages.
/*
/* Revision 1.1  2011/07/11 15:40:46  pauloscustodio
/* Moved all option variables and option handling code to a separate module options.c
/*
/* */

#ifndef OPTIONS_H
#define OPTIONS_H

#include "symbol.h"

/* global option variables */
extern enum flag smallc_source;
extern enum flag ti83plus;
extern enum flag swapIXIY;
extern enum flag clinemode;
extern long clineno;
extern enum flag codesegment;
extern enum flag datestamp;
extern enum flag sdcc_hacks;
extern enum flag force_xlib;
extern enum flag listing;
extern enum flag listing_CPY;
extern enum flag symtable;
extern enum flag symfile;
extern enum flag z80bin;
extern enum flag mapref;
extern enum flag verbose;
extern enum flag globaldef;
extern enum flag autorelocate;
extern enum flag deforigin;
extern enum flag expl_binflnm;
extern char binfilename[];		/* -o explicit filename buffer */
extern char srcext[];			/* ".asm"/"_asm" extension, or whatever defined by -e */
extern char objext[];			/* ".obj"/"_obj" extension, or whatever defined by -M */

/* reset default options */
extern void ResetOptions (void);

/* parse one command line option */
extern void SetAsmFlag (char *flagid);

#endif /* ndef OPTIONS_H */
