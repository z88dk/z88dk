/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2022
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

Define command line options
*/

/*-----------------------------------------------------------------------------
*   define option variables
*----------------------------------------------------------------------------*/
#ifndef OPT_VAR
#define OPT_VAR(type, name, default)
#endif

OPT_VAR(bool, verbose, false)
OPT_VAR(bool, symtable, false)
OPT_VAR(bool, list, false)	/* -l flag */
OPT_VAR(bool, cur_list, false)	/* current LSTON/LSTOFF status */
OPT_VAR(bool, map, false)
OPT_VAR(bool, ti83, false)
OPT_VAR(bool, ti83plus, false)
OPT_VAR(bool, swap_ix_iy, false)
OPT_VAR(bool, debug_info, false)	/* add debug info to map file */
OPT_VAR(bool, globaldef, false)
OPT_VAR(bool, make_bin, false)
OPT_VAR(bool, split_bin, false)	/* true to split binary file per section */
OPT_VAR(bool, date_stamp, false)
OPT_VAR(bool, relocatable, false)
OPT_VAR(bool, reloc_info, false)	/* generate .reloc file */
OPT_VAR(bool, opt_speed, false)
OPT_VAR(bool, ucase, false)	/* convert identifies to upper case */

OPT_VAR(appmake_t, appmake, APPMAKE_NONE)
OPT_VAR(const char*, appmake_opts, "")
OPT_VAR(const char*, appmake_ext, "")
OPT_VAR(int, appmake_origin_min, -1)
OPT_VAR(int, appmake_origin_max, -1)

OPT_VAR(int, cpu, CPU_Z80)
OPT_VAR(const char*, cpu_name, CPU_Z80_NAME)

OPT_VAR(const char*, bin_file, NULL)	/* set by -o */
OPT_VAR(const char*, lib_file, NULL)	/* set by -x */
OPT_VAR(const char*, consol_obj_file, NULL)	/* set by -o and no -b */
OPT_VAR(const char*, output_directory, NULL)	/* set by -O */

OPT_VAR(argv_t*, inc_path, NULL)			/* path for include files */
OPT_VAR(argv_t*, lib_path, NULL)			/* path for library files */

OPT_VAR(argv_t*, files, NULL)			/* list of input files */

OPT_VAR(int, filler, 0)			/* filler byte for defs */

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
OPT(OptCall, exit_help, "-h", "", "Show help options", "")
OPT(OptSet, &opts.verbose, "-v", "", "Be verbose", "")

OPT_TITLE("Preprocessor Options:")
OPT(OptSet, &opts.swap_ix_iy, "-IXIY", "", "Swap IX and IY registers", "")
OPT(OptStringList, &opts.inc_path, "-I", "", "Add directory to include search path", "PATH")
OPT(OptCallArg, option_define, "-D", "", "Define a static symbol", "SYMBOL[=VALUE]")
OPT(OptSet, &opts.ucase, "-ucase", "", "Convert identifiers to upper case", "")
OPT(OptCall, option_dummy, "-float=FORMAT", "", "Set default float format", "")

OPT_TITLE("Code Generation Options:")
OPT(OptCall, option_cpu_z80n, "-mz80n", "", "Assemble for the Z80 variant of ZX Next", "")
OPT(OptCall, option_cpu_z80, "-mz80", "", "Assemble for the Z80", "")
OPT(OptCall, option_cpu_gbz80, "-mgbz80", "", "Assemble for the GameBoy Z80", "")
OPT(OptCall, option_cpu_8080, "-m8080", "", "Assemble for the 8080 (with Zilog or Intel mnemonics)", "")
OPT(OptCall, option_cpu_8085, "-m8085", "", "Assemble for the 8085 (with Zilog or Intel mnemonics)", "")
OPT(OptCall, option_cpu_z180, "-mz180", "", "Assemble for the Z180", "")
OPT(OptCall, option_cpu_r2ka, "-mr2ka", "", "Assemble for the Rabbit 2000A", "")
OPT(OptCall, option_cpu_r3k, "-mr3k", "", "Assemble for the Rabbit 3000", "")
OPT(OptCall, option_cpu_ti83plus, "-mti83plus", "", "Assemble for the TI83Plus", "")
OPT(OptCall, option_cpu_ti83, "-mti83", "", "Assemble for the TI83", "")
OPT(OptSet, &opts.opt_speed, "-opt-speed", "", "Optimize for speed", "")
OPT(OptCall, option_debug_info, "-debug", "", "Add debug info to map file", "")

OPT_TITLE("Libraries:")
OPT(OptStringList, &opts.lib_path, "-L", "", "Add directory to library search path", "PATH")
OPT(OptCallArg, option_make_lib, "-x", "", "Create a library file" FILEEXT_LIB, "FILE")
OPT(OptCallArg, option_use_lib, "-l", "", "Use library file" FILEEXT_LIB, "FILE")

OPT_TITLE("Binary Output:")
OPT(OptString, (void*)&opts.output_directory, "-O", "", "Output directory", "DIR")
OPT(OptString, (void*)&opts.bin_file, "-o", "", "Output binary file", "FILE")
OPT(OptSet, &opts.make_bin, "-b", "", "Assemble and link/relocate to file" FILEEXT_BIN, "")
OPT(OptSet, &opts.split_bin, "-split-bin", "", "Create one binary file per section", "")
OPT(OptSet, &opts.date_stamp, "-d", "", "Assemble only updated files", "")
OPT(OptCallArg, option_origin, "-r", "", "Relocate binary file to given address (decimal or hex)", "ADDR")
OPT(OptSet, &opts.relocatable, "-R", "", "Create relocatable code", "")
OPT(OptSet, &opts.reloc_info, "-reloc-info", "", "Generate binary file relocation information", "")
OPT(OptCallArg, option_filler, "-f", "", "Default value to fill in DEFS (decimal or hex)", "BYTE")

OPT_TITLE("Output File Options:")
OPT(OptSet, &opts.symtable, "-s", "", "Create symbol table file" FILEEXT_SYM, "")
OPT(OptSet, &opts.list, "-l", "", "Create listing file" FILEEXT_LIST, "")
OPT(OptSet, &opts.map, "-m", "", "Create address map file" FILEEXT_MAP, "")
OPT(OptSet, &opts.globaldef, "-g", "", "Create global definition file" FILEEXT_DEF, "")

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
