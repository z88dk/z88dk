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


$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/z80asm.h,v 1.24 2013-04-04 23:08:18 pauloscustodio Exp $
$Log: z80asm.h,v $
Revision 1.24  2013-04-04 23:08:18  pauloscustodio
Helper functions to create file names of each of the extensions used in z80asm

Revision 1.23  2013/04/03 22:52:56  pauloscustodio
Move libfilename to options.c, keep it in strpool

Revision 1.22  2013/02/19 22:52:40  pauloscustodio
BUG_0030 : List bytes patching overwrites header
BUG_0031 : List file garbled with input lines with 255 chars
New listfile.c with all the listing related code

Revision 1.21  2013/02/12 00:55:00  pauloscustodio
CH_0017 : Align with spaces, deprecate -t option

Revision 1.20  2013/01/20 21:24:28  pauloscustodio
Updated copyright year to 2013

Revision 1.19  2012/06/07 11:54:13  pauloscustodio
- Make mapfile static to module modlink.
- Remove modsrcfile, not used.
- GetModuleSize(): use local variable for file handle instead of objfile

Revision 1.18  2012/05/26 18:51:10  pauloscustodio
CH_0012 : wrappers on OS calls to raise fatal error
CH_0013 : new errors interface to decouple calling code from errors.c

Revision 1.17  2012/05/24 21:48:24  pauloscustodio
Remove the global variables include_dir, lib_dir, and respective
counts, create instead the paths in the options module and
create new search_include_file() and search_lib_file()
functions to replace SearchFile().

Revision 1.16  2012/05/24 17:09:27  pauloscustodio
Unify copyright header

Revision 1.15  2012/05/20 06:01:03  pauloscustodio
Moved MAXLINE, WIN32 versions of snprintf, vsnprintf to types.h

Revision 1.14  2012/05/17 14:47:39  pauloscustodio
NUM_ELEMS() moved to types.h

Revision 1.13  2012/05/11 19:29:49  pauloscustodio
Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
        --mode=c
        --lineend=linux
        --indent=spaces=4
        --style=ansi --add-brackets
        --indent-switches --indent-classes
        --indent-preprocessor --convert-tabs
        --break-blocks
        --pad-oper --pad-paren-in --pad-header --unpad-paren
        --align-pointer=name

Revision 1.12  2011/10/14 15:00:22  pauloscustodio
- Move cpu_type to options.c.
- Replace strncpy by strncat, when used to make a safe copy without buffer overruns. The former pads the string with nulls.
- Factor strtoupper() to new module strutil.c.

Revision 1.11  2011/08/21 20:37:20  pauloscustodio
CH_0005 : handle files as char[FILENAME_MAX] instead of strdup for every operation
- Factor all pathname manipulation into module file.c.
- Make default extensions constants.
- Move srcext[] and objext[] to the options.c module.

Revision 1.10  2011/07/14 01:32:08  pauloscustodio
    - Unified "Integer out of range" and "Out of range" errors; they are the same error.
    - Unified ReportIOError as ReportError(ERR_FILE_OPEN)
    CH_0003 : Error messages should be more informative
        - Added printf-args to error messages, added "Error:" prefix.
    BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
        - Raise ERR_UNBALANCED_PAREN instead

Revision 1.9  2011/07/12 22:47:59  pauloscustodio
- Moved all error variables and error reporting code to a separate module errors.c,
  replaced all extern declarations of these variables by include errors.h,
  created symbolic constants for error codes.
- Added test scripts for error messages.

Revision 1.8  2011/07/11 16:16:45  pauloscustodio
Moved all option variables and option handling code to a separate module options.c,
replaced all extern declarations of these variables by include options.h.
Created declarations in z80asm.h of objects defined in z80asm.c.

Revision 1.7  2011/07/09 18:25:35  pauloscustodio
Log keyword in checkin comment was expanded inside Log expansion... recursive
Added Z80asm banner to all source files

Revision 1.6  2011/07/09 17:36:09  pauloscustodio
Copied cvs log into Log history

Revision 1.5  2011/07/09 01:46:00  pauloscustodio
Added Log keyword

Revision 1.4  2011/07/09 01:38:02  pauloscustodio
*** empty log message ***

Revision 1.3  2011/07/09 01:31:24  pauloscustodio
Moved snprintf macro to z80asm.h

Revision 1.2  2009/07/18 23:23:15  dom
clean up the code a bit more (Formatting and a fewer magic numbers)

Revision 1.1  2009/06/13 17:36:24  dom
Add -I and -L to specify search paths for libraries and includes

$History: Z80ASM.C $

*/

#ifndef Z80ASM_H
#define Z80ASM_H

#include "avltree.h"
#include "config.h"
#include "types.h"
#include <stdio.h>
#include <stdlib.h>

/* CH_0005 : handle files as char[FILENAME_MAX] instead of strdup for every operation */
extern char srcfilename[];
extern char objfilename[];
extern char errfilename[];

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
extern char line[];
extern char ident[];
extern char separators[];
extern avltree *globalroot, *staticroot;
extern struct module *CURRENTMODULE;
extern FILE *z80asmfile, *deffile, *libfile;

extern char *Fetchfilename( FILE *fptr );
extern char *CreateLibfile( char *filename );
extern char *GetLibfile( char *filename );
extern void usage( void );

#endif

