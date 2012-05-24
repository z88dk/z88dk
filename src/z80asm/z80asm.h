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
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/z80asm.h,v 1.16 2012-05-24 17:09:27 pauloscustodio Exp $ */
/* $Log: z80asm.h,v $
/* Revision 1.16  2012-05-24 17:09:27  pauloscustodio
/* Unify copyright header
/*
/* Revision 1.15  2012/05/20 06:01:03  pauloscustodio
/* Moved MAXLINE, WIN32 versions of snprintf, vsnprintf to types.h
/*
/* Revision 1.14  2012/05/17 14:47:39  pauloscustodio
/* NUM_ELEMS() moved to types.h
/*
/* Revision 1.13  2012/05/11 19:29:49  pauloscustodio
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
/* Revision 1.12  2011/10/14 15:00:22  pauloscustodio
/* - Move cpu_type to options.c.
/* - Replace strncpy by strncat, when used to make a safe copy without buffer overruns. The former pads the string with nulls.
/* - Factor strtoupper() to new module strutil.c.
/*
/* Revision 1.11  2011/08/21 20:37:20  pauloscustodio
/* CH_0005 : handle files as char[FILENAME_MAX] instead of strdup for every operation
/* - Factor all pathname manipulation into module file.c.
/* - Make default extensions constants.
/* - Move srcext[] and objext[] to the options.c module.
/*
/* Revision 1.10  2011/07/14 01:32:08  pauloscustodio
/*     - Unified "Integer out of range" and "Out of range" errors; they are the same error.
/*     - Unified ReportIOError as ReportError(ERR_FILE_OPEN)
/*     CH_0003 : Error messages should be more informative
/*         - Added printf-args to error messages, added "Error:" prefix.
/*     BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
/*         - Raise ERR_UNBALANCED_PAREN instead
/*
/* Revision 1.9  2011/07/12 22:47:59  pauloscustodio
/* - Moved all error variables and error reporting code to a separate module errors.c,
/*   replaced all extern declarations of these variables by include errors.h,
/*   created symbolic constants for error codes.
/* - Added test scripts for error messages.
/*
/* Revision 1.8  2011/07/11 16:16:45  pauloscustodio
/* Moved all option variables and option handling code to a separate module options.c,
/* replaced all extern declarations of these variables by include options.h.
/* Created declarations in z80asm.h of objects defined in z80asm.c.
/*
/* Revision 1.7  2011/07/09 18:25:35  pauloscustodio
/* Log keyword in checkin comment was expanded inside Log expansion... recursive
/* Added Z80asm banner to all source files
/*
/* Revision 1.6  2011/07/09 17:36:09  pauloscustodio
/* Copied cvs log into Log history
/*
/* Revision 1.5  2011/07/09 01:46:00  pauloscustodio
/* Added Log keyword
/*
/* Revision 1.4  2011/07/09 01:38:02  pauloscustodio
/* *** empty log message ***
/*
/* Revision 1.3  2011/07/09 01:31:24  pauloscustodio
/* Moved snprintf macro to z80asm.h
/*
/* Revision 1.2  2009/07/18 23:23:15  dom
/* clean up the code a bit more (Formatting and a fewer magic numbers)
/*
/* Revision 1.1  2009/06/13 17:36:24  dom
/* Add -I and -L to specify search paths for libraries and includes
/*
/* */

/* $History: Z80ASM.C $ */
/*  */

#ifndef Z80ASM_H
#define Z80ASM_H

#include <stdio.h>
#include <stdlib.h>
#include "config.h"
#include "avltree.h"
#include "types.h"

/* default file name extensions */
#define FILEEXT_MAX     (1+3+1)                 /* size of fileext char[]: separator + 3 chars + null */

#define FILEEXT_ASM     FILEEXT_SEPARATOR "asm"    /* ".asm" / "_asm" */
#define FILEEXT_LST     FILEEXT_SEPARATOR "lst"    /* ".lst" / "_lst" */
#define FILEEXT_OBJ     FILEEXT_SEPARATOR "obj"    /* ".obj" / "_obj" */
#define FILEEXT_DEF     FILEEXT_SEPARATOR "def"    /* ".def" / "_def" */
#define FILEEXT_ERR     FILEEXT_SEPARATOR "err"    /* ".err" / "_err" */
#define FILEEXT_BIN     FILEEXT_SEPARATOR "bin"    /* ".bin" / "_bin" */
#define FILEEXT_SEGBIN  FILEEXT_SEPARATOR "bn0"    /* ".bn0" / "_bn0" */
#define FILEEXT_LIB     FILEEXT_SEPARATOR "lib"    /* ".lib" / "_lib" */
#define FILEEXT_SYM     FILEEXT_SEPARATOR "sym"    /* ".sym" / "_sym" */
#define FILEEXT_MAP     FILEEXT_SEPARATOR "map"    /* ".map" / "_map" */

/* CH_0005 : handle files as char[FILENAME_MAX] instead of strdup for every operation */
extern char srcfilename[];
extern char lstfilename[];
extern char objfilename[];
extern char errfilename[];
extern char libfilename[];


#define REG16_BC   0
#define REG16_DE   1
#define REG16_HL   2
#define REG16_SP   3
#define REG16_AF   4
#define REG16_IX   5
#define REG16_IY   6

#define FLAGS_NZ 0
#define FLAGS_Z  1
#define FLAGS_NC 2
#define FLAGS_C  3
#define FLAGS_PO 4
#define FLAGS_PE 5
#define FLAGS_P 6
#define FLAGS_M 7


extern size_t EXPLICIT_ORIGIN;
extern int TAB_DIST, COLUMN_WIDTH;
extern char ident[];
extern char separators[];
extern avltree *globalroot, *staticroot;
extern struct module *CURRENTMODULE;
extern FILE *listfile, *mapfile, *z80asmfile, *errfile, *deffile, *libfile;

extern int      include_dir_num;
extern char   **include_dir;
extern int      lib_dir_num;
extern char   **lib_dir;

extern char *Fetchfilename( FILE *fptr );
extern char *SearchFile( char *base, int is_include );
extern void CreateLibfile( char *filename );
extern void GetLibfile( char *filename );
extern void usage( void );

#endif

