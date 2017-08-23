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
#define CPU_Z80     (1 << 0)
#define CPU_Z80_ZXN	(1 << 1)
#define CPU_Z180    (1 << 2)
#define CPU_R2K		(1 << 3)
#define CPU_R3K		(1 << 4)

#define CPU_ZILOG	(CPU_Z80 | CPU_Z80_ZXN| CPU_Z180)
#define CPU_RABBIT	(CPU_R2K | CPU_R3K)
#define CPU_ALL		(CPU_ZILOG | CPU_RABBIT)
#define CPU_NOT_Z80	(CPU_ALL & ~(CPU_Z80 | CPU_Z80_ZXN))

/*-----------------------------------------------------------------------------
*   APPMAKE type
*----------------------------------------------------------------------------*/
typedef enum { APPMAKE_NONE, APPMAKE_ZX81, APPMAKE_ZX } appmake_t;

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

// define static symbols depending on options
extern void define_assembly_defines();

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

/*-----------------------------------------------------------------------------
*   Call appmake if requested in options
*----------------------------------------------------------------------------*/
extern void checkrun_appmake(void);

#define ZX_ORIGIN		 23760		/* origin for unexpanded ZX Spectrum */
#define ZX_ORIGIN_S		"23760"
#define ZX_ORIGIN_MIN	 23760
#define ZX_ORIGIN_MAX	 0xFFFF
#define ZX_APP_EXT		".tap"		/* ZX Spectrum TAP file */

#define ZX81_ORIGIN		 16514		/* origin for ZX 81 */
#define ZX81_ORIGIN_S	"16514"
#define ZX81_ORIGIN_MIN	 16514
#define ZX81_ORIGIN_MAX  16514
#define ZX81_APP_EXT	".P"		/* ZX81 .P file */
