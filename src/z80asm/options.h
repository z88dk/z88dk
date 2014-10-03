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
Copyright (C) Paulo Custodio, 2011-2014

Parse command line options

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/options.h,v 1.46 2014-10-03 22:57:50 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */

#include "types.h"
#include "list.h"

/*-----------------------------------------------------------------------------
*   CPU type
*----------------------------------------------------------------------------*/
#define CPU_Z80     1
#define CPU_RCM2000 2
#define CPU_RCM3000 4
#define CPU_Z180    8

#define CPU_RABBIT (CPU_RCM2000|CPU_RCM3000)
#define CPU_ZILOG  (CPU_Z80    |CPU_Z180)
#define CPU_ALL    (CPU_ZILOG  |CPU_RABBIT)

/*-----------------------------------------------------------------------------
*   singleton opts
*----------------------------------------------------------------------------*/
#define OPT_VAR(type, name, default)	type name;
typedef struct Opts
{
#include "options_def.h"
}
Opts;

extern Opts opts;

/*-----------------------------------------------------------------------------
*   Parse command line, set options, including opts.files with list of
*	input files, including parsing of '@' lists
*----------------------------------------------------------------------------*/
extern void parse_argv( int argc, char *argv[] );

/*-----------------------------------------------------------------------------
*   Change extension of given file name, return pointer to file name in
*	strpool
*	Extensions may be changed by options.
*----------------------------------------------------------------------------*/
extern char *get_asm_filename( char *filename );
extern char *get_lst_filename( char *filename );
extern char *get_obj_filename( char *filename );
extern char *get_def_filename( char *filename );
extern char *get_err_filename( char *filename );
extern char *get_bin_filename( char *filename );
extern char *get_lib_filename( char *filename );
extern char *get_sym_filename( char *filename );
extern char *get_map_filename( char *filename );
