/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

Parse command line options
*/

#pragma once

#include "types.h"
#include "utarray.h"

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
extern char *get_list_filename( char *filename );
extern char *get_obj_filename( char *filename );
extern char *get_def_filename( char *filename );
extern char *get_err_filename( char *filename );
extern char *get_bin_filename( char *filename );
extern char *get_lib_filename( char *filename );
extern char *get_sym_filename( char *filename );
extern char *get_map_filename(char *filename);
extern char *get_reloc_filename(char *filename);
