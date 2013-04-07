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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/options.h,v 1.13 2013-04-07 22:26:07 pauloscustodio Exp $ */
/* $Log: options.h,v $
/* Revision 1.13  2013-04-07 22:26:07  pauloscustodio
/* Removed global variable smallc_source, no longer used
/*
/* Revision 1.12  2013/04/06 13:15:04  pauloscustodio
/* Move default asm and obj extension handling to file.c.
/* srcfilename and objfilename are now pointers to static variables in file.c
/*
/* Revision 1.11  2013/04/03 22:52:56  pauloscustodio
/* Move libfilename to options.c, keep it in strpool
/*
/* Revision 1.10  2013/02/27 22:34:16  pauloscustodio
/* Move include path search to srcfile.c
/*
/* Revision 1.9  2013/02/19 22:52:40  pauloscustodio
/* BUG_0030 : List bytes patching overwrites header
/* BUG_0031 : List file garbled with input lines with 255 chars
/* New listfile.c with all the listing related code
/*
/* Revision 1.8  2013/01/20 21:24:28  pauloscustodio
/* Updated copyright year to 2013
/*
/* Revision 1.7  2012/05/24 21:48:24  pauloscustodio
/* Remove the global variables include_dir, lib_dir, and respective
/* counts, create instead the paths in the options module and
/* create new search_include_file() and search_lib_file()
/* functions to replace SearchFile().
/*
/* Revision 1.6  2012/05/24 17:09:27  pauloscustodio
/* Unify copyright header
/*
/* Revision 1.5  2012/05/11 19:29:49  pauloscustodio
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
/* Revision 1.4  2011/10/14 14:57:45  pauloscustodio
/* - Move cpu_type to options.c.
/* - Replace strncpy by strncat, when used to make a safe copy without buffer overruns. The former pads the string with nulls.
/*
/* Revision 1.3  2011/08/21 20:25:31  pauloscustodio
/* BUG_0012 : binfilename[] array is too short, should be FILENAME_MAX
/* CH_0005 : handle files as char[FILENAME_MAX] instead of strdup for every operation
/* - Factor all pathname manipulation into module file.c.
/* - Make default extensions constants.
/* - Move asm_ext[] and obj_ext[] to the options.c module.
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
extern enum flag ti83plus;
extern enum flag swapIXIY;
extern enum flag clinemode;
extern long clineno;
extern enum flag codesegment;
extern enum flag datestamp;
extern enum flag sdcc_hacks;
extern enum flag force_xlib;
extern enum flag listing;
extern enum flag option_list;
extern enum flag option_symtable;
extern enum flag symfile;
extern enum flag z80bin;
extern enum flag mapref;
extern enum flag verbose;
extern enum flag globaldef;
extern enum flag autorelocate;
extern enum flag deforigin;
extern enum flag expl_binflnm;
extern char *libfilename;				/* -i, -x library file, kept in strpool */
extern char binfilename[];              /* -o explicit filename buffer */

/* CPU type */
#define CPU_Z80     1
#define CPU_RCM2000 2
#define CPU_RCM3000 4
#define CPU_Z180    8

#define CPU_RABBIT (CPU_RCM2000|CPU_RCM3000)
#define CPU_ZILOG  (CPU_Z80    |CPU_Z180)
#define CPU_ALL    (CPU_ZILOG  |CPU_RABBIT)

extern int cpu_type;

/* reset default options */
extern void reset_options( void );

/* parse one command line option */
extern void set_asm_flag( char *flagid );

/* search files in paths */
extern char *search_lib_file( char *filename );

#endif /* ndef OPTIONS_H */

