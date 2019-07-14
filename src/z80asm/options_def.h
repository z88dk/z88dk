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

OPT_VAR( bool,		verbose,	false	)
OPT_VAR( bool,		symtable,	false	)
OPT_VAR( bool,		list,		false	)	/* -l flag */
OPT_VAR( bool,		cur_list,	false	)	/* current LSTON/LSTOFF status */
OPT_VAR( bool,		map,		false	)
OPT_VAR( bool,		ti83plus,	false	)
OPT_VAR( bool,		swap_ix_iy,	false	)
OPT_VAR( bool,      debug_info, false   )	/* add debug info to map file */
OPT_VAR( bool,		globaldef,	false	)
OPT_VAR( bool,		make_bin,	false	)
OPT_VAR( bool,		split_bin,	false   )	/* true to split binary file per section */
OPT_VAR( bool,		date_stamp,	false	)
OPT_VAR( bool,		relocatable, false	)
OPT_VAR( bool,      reloc_info, false   )	/* generate .reloc file */
OPT_VAR( bool,		library,	false	)	/* true if linking with libs */
OPT_VAR( bool,		opt_speed,	false   )

OPT_VAR(appmake_t, appmake, APPMAKE_NONE)
OPT_VAR(const char *, appmake_opts, "")
OPT_VAR(const char *, appmake_ext, "")
OPT_VAR(int, appmake_origin_min, -1)
OPT_VAR(int, appmake_origin_max, -1)

OPT_VAR(int, cpu, CPU_Z80)
OPT_VAR(const char *, cpu_name, CPU_Z80_NAME)

OPT_VAR(const char *,	bin_file,	NULL	)	/* set by -o */
OPT_VAR(const char *,	lib_file,	NULL	)	/* set by -x */
OPT_VAR(const char *,    consol_obj_file, NULL)	/* set by -o and no -b */
OPT_VAR(const char *,    output_directory, NULL)	/* set by -O */

OPT_VAR(argv_t *,	inc_path, NULL)			/* path for include files */
OPT_VAR(argv_t *,	lib_path, NULL)			/* path for library files */

OPT_VAR(argv_t *,	files,	  NULL)			/* list of input files */

OPT_VAR(int,		filler,		0)			/* filler byte for defs */

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
OPT(OptCall, option_cpu_z80n, "", "--cpu=z80n", "Assemble for the Z80 variant of ZX Next", "")
OPT(OptCall, option_cpu_z80, "", "--cpu=z80", "Assemble for the Z80", "")
OPT(OptCall, option_cpu_z180, "", "--cpu=z180", "Assemble for the Z180", "")
OPT(OptCall, option_cpu_r2k, "", "--cpu=r2k", "Assemble for the Rabbit 2000", "")
OPT(OptCall, option_cpu_r3k, "", "--cpu=r3k", "Assemble for the Rabbit 3000", "")
OPT(OptCall, option_cpu_ti83plus, "", "--cpu=ti83plus", "Assemble for the TI83Plus", "")
OPT(OptCall, option_cpu_ti83, "", "--cpu=ti83", "Assemble for the TI83", "")
OPT(OptSet, &opts.swap_ix_iy, "-IXIY", "--IXIY", "Swap IX and IY registers", "")
OPT(OptSet, &opts.opt_speed, "", "--opt=speed", "Optimize for speed", "")
OPT(OptCall, option_debug_info, "", "--debug", "Add debug info to map file", "")

OPT_TITLE("Environment:")
OPT(OptStringList, &opts.inc_path, "-I", "--inc-path", "Add directory to include search path", "PATH")
OPT(OptStringList, &opts.lib_path, "-L", "--lib-path", "Add directory to library search path", "PATH")
OPT(OptCallArg, option_define, "-D", "--define", "Define a static symbol", "SYMBOL")

OPT_TITLE("Libraries:")
OPT(OptCallArg, option_make_lib, "-x", "--make-lib", "Create a library file" FILEEXT_LIB, "FILE")
OPT(OptCallArg, option_use_lib, "-i", "--use-lib", "Use library file" FILEEXT_LIB, "FILE")

OPT_TITLE("Binary Output:")
OPT(OptString, (void*)&opts.output_directory, "-O", "--out-dir", "Output directory", "DIR")
OPT(OptString, (void*)&opts.bin_file, "-o", "--output", "Output binary file", "FILE")
OPT(OptSet, &opts.make_bin, "-b", "--make-bin", "Assemble and link/relocate to file" FILEEXT_BIN, "")
OPT(OptSet, &opts.split_bin, "", "--split-bin", "Create one binary file per section", "")
OPT(OptSet, &opts.date_stamp, "-d", "--update", "Assemble only updated files", "")
OPT(OptCallArg, option_origin, "-r", "--origin", "Relocate binary file to given address (decimal or hex)", "ADDR")
OPT(OptSet, &opts.relocatable, "-R", "--relocatable", "Create relocatable code", "")
OPT(OptSet, &opts.reloc_info, "", "--reloc-info", "Geneate binary file relocation information", "")
OPT(OptCallArg, option_filler, "", "--filler", "Default value to fill in DEFS (decimal or hex)", "BYTE")

OPT_TITLE("Output File Options:")
OPT(OptSet, &opts.symtable, "-s", "--symtable", "Create symbol table file" FILEEXT_SYM, "")
OPT(OptSet, &opts.list, "-l", "--list", "Create listing file" FILEEXT_LIST, "")
OPT(OptSet, &opts.map, "-m", "--map", "Create address map file" FILEEXT_MAP, "")
OPT(OptSet, &opts.globaldef, "-g", "--globaldef", "Create global definition file" FILEEXT_DEF, "")

OPT_TITLE("Appmake Options:")
OPT(OptCall, option_appmake_zx81, "", "+zx81", "Generate ZX81 .P file, origin at " ZX81_ORIGIN_S, "")
OPT(OptCall, option_appmake_zx, "", "+zx", "Generate ZX Spectrum .tap file, origin defaults to\n"
	"                         " ZX_ORIGIN_S " (in a REM), but can be set with -rORG >= 24000\n"
	"                         for above RAMTOP", "")

/*-----------------------------------------------------------------------------
*   clear macros
*----------------------------------------------------------------------------*/
#undef OPT_VAR
#undef OPT_TITLE
#undef OPT
