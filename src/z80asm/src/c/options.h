//-----------------------------------------------------------------------------
// Z88DK Z80 Macro Assembler
// Parse command line options
// Copyright (C) Paulo Custodio, 2011-2022
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#pragma once

#include "if.h"
#include "strutil.h"
#include "types.h"
#include "utarray.h"
#include "utstring.h"

/*-----------------------------------------------------------------------------
*   CPU type
*----------------------------------------------------------------------------*/
#define CPU_Z80     (1 << 0)
#define CPU_Z80N	(1 << 1)
#define CPU_Z180    (1 << 2)
#define CPU_R2KA	(1 << 3)
#define CPU_R3K		(1 << 4)
#define CPU_8080	(1 << 5)
#define CPU_8085	(1 << 6)
#define CPU_GBZ80	(1 << 7)

#define CPU_Z80_NAME		"z80"
#define CPU_Z80N_NAME		"z80n"
#define CPU_Z180_NAME		"z180"
#define CPU_R2KA_NAME		"r2ka"
#define CPU_R3K_NAME		"r3k"
#define CPU_8080_NAME		"8080"
#define CPU_8085_NAME		"8085"
#define CPU_GBZ80_NAME		"gbz80"

#define CPU_ZILOG	(CPU_Z80 | CPU_Z80N| CPU_Z180)
#define CPU_RABBIT	(CPU_R2KA | CPU_R3K)
#define CPU_ALL		(CPU_ZILOG | CPU_RABBIT)
#define CPU_NOT_Z80	(CPU_ALL & ~(CPU_Z80 | CPU_Z80N))

/*-----------------------------------------------------------------------------
*   Assembler standard library
*----------------------------------------------------------------------------*/
#define Z80ASM_LIB	"z88dk-z80asm-%s-%s.lib"
#define SWAP_IX_IY_NAME	(opts.swap_ix_iy ? "ixiy" : "")

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

/*-----------------------------------------------------------------------------
*   Change extension of given file name, return pointer to file name in
*	strpool
*	Extensions may be changed by options.
*----------------------------------------------------------------------------*/
extern const char *get_asm_filename(const char *filename );
extern const char *get_list_filename(const char *filename );
extern const char *get_obj_filename(const char *filename );
extern const char *get_def_filename(const char *filename );
extern const char *get_bin_filename(const char *filename );
extern const char *get_lib_filename(const char *filename );
extern const char *get_sym_filename(const char *filename );
extern const char *get_map_filename(const char *filename);
extern const char *get_reloc_filename(const char *filename);
extern const char* path_prepend_output_dir(const char* filename);

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

/*-----------------------------------------------------------------------------
*   options function interface
*----------------------------------------------------------------------------*/
bool option_ucase();
bool option_list_file();
bool option_cur_list();
bool option_single_binary_block();	// required by opts.relocatable and aps.appmake
