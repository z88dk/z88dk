/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
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
OPT_VAR( Bool,		symtable,	FALSE	)
OPT_VAR( Bool,		list,		FALSE	)	/* -l flag */
OPT_VAR( Bool,		cur_list,	FALSE	)	/* current LSTON/LSTOFF status */
OPT_VAR( Bool,		map,		FALSE	)
OPT_VAR( Bool,		ti83plus,	FALSE	)
OPT_VAR( Bool,		swap_ix_iy,	FALSE	)
OPT_VAR( Bool,		line_mode,	FALSE	)
OPT_VAR( Bool,		globaldef,	FALSE	)
OPT_VAR( Bool,		make_bin,	FALSE	)
OPT_VAR( Bool,		split_bin,	FALSE   )	/* true to split binary file per section */
OPT_VAR( Bool,		date_stamp,	FALSE	)
OPT_VAR( Bool,		relocatable, FALSE	)
OPT_VAR( Bool,      reloc_info, FALSE   )	/* generate .reloc file */
OPT_VAR( Bool,		library,	FALSE	)	/* true if linking with libs */

OPT_VAR( int, 		cpu,		CPU_Z80	)

OPT_VAR( char *,	bin_file,	NULL	)	/* set by -o */
OPT_VAR( char *,	lib_file,	NULL	)	/* set by -x */
OPT_VAR( char *,    consol_obj_file, NULL)	/* set by -o and no -b */

OPT_VAR(UT_array *,	inc_path,	NULL )		/* path for include files */
OPT_VAR(UT_array *,	lib_path,	NULL )		/* path for library files */

OPT_VAR(UT_array  *, files, 	NULL)		/* list of input files */

/*-----------------------------------------------------------------------------
*   define options
*----------------------------------------------------------------------------*/
#ifndef OPT_TITLE
#define OPT_TITLE(text)
#endif

#ifndef OPT
#define OPT(type, arg, short_opt, long_opt, help_text, help_arg)
#endif

OPT_TITLE("Help Options:")
OPT(OptCall, exit_help, "-h", "--help", "Show help options", "")
OPT(OptSet, &opts.verbose, "-v", "--verbose", "Be verbose", "")

OPT_TITLE("Code Generation Options:")
OPT(OptCall, option_cpu_z180, "", "--cpu=z180", "Assemble for the Z180", "")
OPT(OptCall, option_cpu_RCM2000, "", "--RCMX000", "Assemble for RCM2000/RCM3000 series of Z80-like CPU", "")
OPT(OptSet, &opts.ti83plus, "", "--ti83plus", "Interpret 'Invoke' as RST 28h", "")
OPT(OptSet, &opts.swap_ix_iy, "", "--IXIY", "Swap IX and IY registers", "")
OPT(OptSet, &opts.line_mode, "-C", "--line-mode", "Enable LINE directive", "")

OPT_TITLE("Environment:")
OPT(OptStringList, &opts.inc_path, "-I", "--inc-path", "Add directory to include search path", "PATH")
OPT(OptStringList, &opts.lib_path, "-L", "--lib-path", "Add directory to library search path", "PATH")
OPT(OptCallArg, option_define, "-D", "--define", "Define a static symbol", "SYMBOL")

OPT_TITLE("Libraries:")
OPT(OptCallArg, option_make_lib, "-x", "--make-lib", "Create a library file" FILEEXT_LIB, "FILE")
OPT(OptCallArg, option_use_lib, "-i", "--use-lib", "Link library file" FILEEXT_LIB, "FILE")

OPT_TITLE("Binary Output:")
OPT(OptString, &opts.bin_file, "-o", "--output", "Output binary file", "FILE")
OPT(OptSet, &opts.make_bin, "-b", "--make-bin", "Assemble and link/relocate to file" FILEEXT_BIN, "")
OPT(OptSet, &opts.split_bin, "", "--split-bin", "Create one binary file per section", "")
OPT(OptSet, &opts.date_stamp, "-d", "--date-stamp", "Assemble only updated files", "")
OPT(OptCallArg, option_origin, "-r", "--origin", "Relocate binary file to given address (decimal or hex)", "ADDR")
OPT(OptSet, &opts.relocatable, "-R", "--relocatable", "Create relocatable code", "")
OPT(OptSet, &opts.reloc_info, "", "--reloc-info", "Geneate binary file relocation information", "")

OPT_TITLE("Output File Options:")
OPT(OptSet, &opts.symtable, "-s", "--symtable", "Create symbol table file" FILEEXT_SYM, "")
OPT(OptSet, &opts.list, "-l", "--list", "Create listing file" FILEEXT_LIST, "")
OPT(OptSet, &opts.map, "-m", "--map", "Create address map file" FILEEXT_MAP, "")
OPT(OptSet, &opts.globaldef, "-g", "--globaldef", "Create global definition file" FILEEXT_DEF, "")

/*-----------------------------------------------------------------------------
*   clear macros
*----------------------------------------------------------------------------*/
#undef OPT_VAR
#undef OPT_TITLE
#undef OPT
