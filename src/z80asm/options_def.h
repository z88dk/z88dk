/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2015
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

Define command line options
*/

/*-----------------------------------------------------------------------------
*   define option variables
*----------------------------------------------------------------------------*/
#ifndef OPT_VAR
#define OPT_VAR(type, name, default)
#endif

OPT_VAR( Bool,		verbose,	FALSE	)
OPT_VAR( Bool,		symtable,	TRUE	)
OPT_VAR( Bool,		list,		FALSE	)	/* -l flag */
OPT_VAR( Bool,		cur_list,	FALSE	)	/* current LSTON/LSTOFF status */
OPT_VAR( Bool,		map,		TRUE	)
OPT_VAR( Bool,		sdcc,		FALSE	)
OPT_VAR( Bool,		ti83plus,	FALSE	)
OPT_VAR( Bool,		swap_ix_iy,	FALSE	)
OPT_VAR( Bool,		line_mode,	FALSE	)
OPT_VAR( Bool,		globaldef,	FALSE	)
OPT_VAR( Bool,		make_bin,	FALSE	)
OPT_VAR( Bool,		split_bin,	FALSE   )	/* true to split binary file per section */
OPT_VAR( Bool,		date_stamp,	FALSE	)
OPT_VAR( Bool,		relocatable, FALSE	)
OPT_VAR( Bool,		library,	FALSE	)	/* true if linking with libs */

OPT_VAR( int, 		cpu,		CPU_Z80	)

OPT_VAR( char *,	asm_ext,	( FILEEXT_ASM ) + 1 )	/* skip "." */
OPT_VAR( char *,	obj_ext,	( FILEEXT_OBJ ) + 1 )	/* skip "." */
OPT_VAR( char *,	bin_file,	NULL	)	/* set by -o */
OPT_VAR( char *,	lib_file,	NULL	)	/* set by -x */

OPT_VAR(UT_array *,	inc_path,	NULL )		/* path for include files */
OPT_VAR(UT_array *,	lib_path,	NULL )		/* path for library files */

OPT_VAR(UT_array  *, files, 	NULL)		/* list of input files */

/*-----------------------------------------------------------------------------
*   define help text
*----------------------------------------------------------------------------*/
#define OPT_HELP_HELP			"Show help options"
#define OPT_HELP_VERBOSE		"Be verbose"
#define OPT_HELP_NOT_VERBOSE	"Don't be verbose"

#define OPT_HELP_ASM_EXT		"Assembly file extension excluding '" FILEEXT_SEPARATOR "'"
#define OPT_HELP_OBJ_EXT		"Object file extension excluding '" FILEEXT_SEPARATOR "'"
#define OPT_HELP_BIN_FILE		"Output binary file"

#define OPT_HELP_CPU_RCM2000	"Assemble for RCM2000/RCM3000 series of Z80-like CPU"
#define OPT_HELP_SDCC			"Assemble for Small Device C Compiler"
#define OPT_HELP_TI83PLUS		"Interpret 'Invoke' as RST 28h"
#define OPT_HELP_SWAP_IX_IY		"Swap IX and IY registers"
#define OPT_HELP_LINE_MODE		"Enable LINE directive"

#define OPT_HELP_MAKE_BIN		"Assemble and link/relocate to file" FILEEXT_BIN
#define OPT_HELP_NO_MAKE_BIN	"No binary file"
#define OPT_HELP_SPLIT_BIN		"Create one binary file per section"

#define OPT_HELP_DATE_STAMP		"Assemble only updated files"
#define OPT_HELP_NO_DATE_STAMP	"Assemble all files"

#define OPT_HELP_MAKE_UPDATED_BIN	\
								"Assemble updated files and link/relocate to file" FILEEXT_BIN
#define OPT_HELP_ORIGIN			"Relocate binary file to given address"

#define OPT_HELP_RELOCATABLE	"Create relocatable code"

#define OPT_HELP_SYMTABLE		"Create symbol table file" FILEEXT_SYM
#define OPT_HELP_NO_SYMTABLE	"No symbol table file"

#define OPT_HELP_LIST			"Create listing file" FILEEXT_LST
#define OPT_HELP_NO_LIST		"No listing file"

#define OPT_HELP_MAP			"Create address map file" FILEEXT_MAP
#define OPT_HELP_NO_MAP			"No address map file"

#define OPT_HELP_GLOBALDEF		"Create global definition file" FILEEXT_DEF
#define OPT_HELP_NO_GLOBALDEF	"No global definition file"

#define OPT_HELP_INC_PATH		"Add directory to include search path"
#define OPT_HELP_LIB_PATH		"Add directory to library search path"
#define OPT_HELP_DEFINE			"Define a static symbol"

#define OPT_HELP_MAKE_LIB		"Create a library file" FILEEXT_LIB
#define OPT_HELP_USE_LIB		"Link library file" FILEEXT_LIB


/*-----------------------------------------------------------------------------
*   define options
*----------------------------------------------------------------------------*/
#ifndef OPT_TITLE
#define OPT_TITLE(text)
#endif

#ifndef OPT
#define OPT(type, arg, short_opt, long_opt, help_text, help_arg)
#endif

OPT_TITLE(	"Help Options:"	)
OPT( OptCall,	exit_help,		"-h", 	"--help",			OPT_HELP_HELP, "" )
OPT( OptSet,	&opts.verbose,	"-v", 	"--verbose", 		OPT_HELP_VERBOSE, "" )
OPT( OptClear,	&opts.verbose,	"-nv", 	"--not-verbose",	OPT_HELP_NOT_VERBOSE, "" )

OPT_TITLE(	"Input / Output File Options:"	)
OPT( OptString,	&opts.asm_ext,	"-e", 	"--asm-ext", 		OPT_HELP_ASM_EXT, "EXT" )
OPT( OptString,	&opts.obj_ext,	"-M", 	"--obj-ext", 		OPT_HELP_OBJ_EXT, "EXT" )
OPT( OptString,	&opts.bin_file,	"-o", 	"--output", 		OPT_HELP_BIN_FILE, "FILE" )

OPT_TITLE(	"Code Generation Options:" )
OPT( OptCall,	option_cpu_RCM2000,
     "-RCMX000", "--RCMX000",	OPT_HELP_CPU_RCM2000, "" )
OPT( OptSet,	&opts.sdcc,		"-sdcc", "--sdcc",			OPT_HELP_SDCC, "" )
OPT( OptSet,	&opts.ti83plus,	"-plus", "--ti83plus",		OPT_HELP_TI83PLUS, "" )
OPT( OptSet,	&opts.swap_ix_iy,
     "-IXIY", "--swap-ix-iy",		OPT_HELP_SWAP_IX_IY, "" )
OPT( OptSet,	&opts.line_mode,
     "-C",	"--line-mode",		OPT_HELP_LINE_MODE, "" )

OPT_TITLE(	"Environment:"	)
OPT( OptStringList,	&opts.inc_path,	"-I", "--inc-path",		OPT_HELP_INC_PATH, "PATH" )
OPT( OptStringList,	&opts.lib_path,	"-L", "--lib-path",		OPT_HELP_LIB_PATH, "PATH" )
OPT( OptCallArg,	option_define,	"-D", "--define",		OPT_HELP_DEFINE, "SYMBOL" )

OPT_TITLE(	"Libraries:"	)
OPT( OptCallOptArg, option_make_lib, "-x", 	"--make-lib", 		OPT_HELP_MAKE_LIB, "[FILE]" )
OPT( OptCallOptArg, option_use_lib,	 "-i", 	"--use-lib", 		OPT_HELP_USE_LIB,  "[FILE]" )


OPT_TITLE(	"Binary Output:" )
OPT( OptSet,	&opts.make_bin,	"-b", 	"--make-bin", 		OPT_HELP_MAKE_BIN, "" )
OPT( OptClear,	&opts.make_bin,	"-nb", 	"--no-make-bin",	OPT_HELP_NO_MAKE_BIN, "" )

OPT( OptSet,	&opts.split_bin, "", "--split-bin", OPT_HELP_SPLIT_BIN, "")

OPT( OptSet,	&opts.date_stamp, "-d",  "--date-stamp",    OPT_HELP_DATE_STAMP, "")
OPT( OptClear,	&opts.date_stamp, "-nd", "--no-date-stamp",	OPT_HELP_NO_DATE_STAMP, "" )

OPT( OptCall,	option_make_updated_bin,
     "-a", 	"--make-updated-bin",
     OPT_HELP_MAKE_UPDATED_BIN, "" )
OPT( OptCallArg, option_origin,	"-r", 	"--origin",			OPT_HELP_ORIGIN, "ORG_HEX" )
OPT( OptSet,	&opts.relocatable,
     "-R", 	"--relocatable",	OPT_HELP_RELOCATABLE, "" )

OPT_TITLE(	"Output File Options:" )
OPT( OptSet,	&opts.symtable,	"-s", 	"--symtable", 		OPT_HELP_SYMTABLE, "" )
OPT( OptClear,	&opts.symtable,	"-ns", 	"--no-symtable",	OPT_HELP_NO_SYMTABLE, "" )

OPT( OptSet,	&opts.list,		"-l", 	"--list", 			OPT_HELP_LIST, "" )
OPT( OptClear,	&opts.list,		"-nl", 	"--no-list",		OPT_HELP_NO_LIST, "" )

OPT( OptSet,	&opts.map,		"-m", 	"--map", 			OPT_HELP_MAP, "" )
OPT( OptClear,	&opts.map,		"-nm", 	"--no-map",			OPT_HELP_NO_MAP, "" )

OPT( OptSet,	&opts.globaldef, "-g", 	"--globaldef", 		OPT_HELP_GLOBALDEF, "" )
OPT( OptClear,	&opts.globaldef, "-ng", 	"--no-globaldef",	OPT_HELP_NO_GLOBALDEF, "" )


OPT( OptDeprecated,	NULL,		"-t", 	"",					"", "" )

/*-----------------------------------------------------------------------------
*   clear macros
*----------------------------------------------------------------------------*/
#undef OPT_VAR
#undef OPT_TITLE
#undef OPT
