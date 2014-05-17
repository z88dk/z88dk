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

Copyright (C) Paulo Custodio, 2011-2014

Define command line options

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/options_def.h,v 1.38 2014-05-17 23:08:03 pauloscustodio Exp $
*/

/*-----------------------------------------------------------------------------
*   define option variables
*----------------------------------------------------------------------------*/
#ifndef OPT_VAR
#define OPT_VAR(type, name, default)
#endif

OPT_VAR( BOOL,		verbose,	FALSE	)
OPT_VAR( BOOL,		symtable,	TRUE	)
OPT_VAR( BOOL,		list,		FALSE	)	/* -l flag */
OPT_VAR( BOOL,		cur_list,	FALSE	)	/* current LSTON/LSTOFF status */
OPT_VAR( BOOL,		map,		TRUE	)
OPT_VAR( BOOL,		sdcc,		FALSE	)
OPT_VAR( BOOL,		ti83plus,	FALSE	)
OPT_VAR( BOOL,		swap_ix_iy,	FALSE	)
OPT_VAR( BOOL,		force_xlib,	FALSE	)
OPT_VAR( BOOL,		line_mode,	FALSE	)
OPT_VAR( BOOL,		globaldef,	FALSE	)
OPT_VAR( BOOL,		make_bin,	FALSE	)
OPT_VAR( BOOL,		date_stamp,	FALSE	)
OPT_VAR( BOOL,		code_seg,	FALSE	)
OPT_VAR( BOOL,		relocatable, FALSE	)
OPT_VAR( BOOL,		library,	FALSE	)	/* true if linking with libs */

OPT_VAR( int32_t,	origin,		-1	)		/* -1 == not defined */
OPT_VAR( int, 		cpu,		CPU_Z80	)

OPT_VAR( char *,	asm_ext,	( FILEEXT_ASM ) + 1 )	/* skip "." */
OPT_VAR( char *,	obj_ext,	( FILEEXT_OBJ ) + 1 )	/* skip "." */
OPT_VAR( char *,	bin_file,	NULL	)	/* set by -o */
OPT_VAR( char *,	lib_file,	NULL	)	/* set by -x */

OPT_VAR( List *,	inc_path,	NULL )		/* path for include files */
OPT_VAR( List *,	lib_path,	NULL )		/* path for library files */

OPT_VAR( List *,	files,		NULL )		/* list of input files */

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
#define OPT_HELP_FORCE_XLIB		"Force PUBLIC call on MODULE directive"
#define OPT_HELP_LINE_MODE		"Enable LINE directive"

#define OPT_HELP_MAKE_BIN		"Assemble and link/relocate to file" FILEEXT_BIN
#define OPT_HELP_NO_MAKE_BIN	"No binary file"

#define OPT_HELP_DATE_STAMP		"Assemble only updated files"
#define OPT_HELP_NO_DATE_STAMP	"Assemble all files"

#define OPT_HELP_MAKE_UPDATED_BIN	\
								"Assemble updated files and link/relocate to file" FILEEXT_BIN
#define OPT_HELP_ORIGIN			"Relocate binary file to given address"

#define OPT_HELP_CODE_SEG		"Split code in 16K banks"
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
OPT( OptSet,	&opts.force_xlib,
     "-forcexlib", "--forcexlib",	OPT_HELP_FORCE_XLIB, "" )
OPT( OptSet,	&opts.line_mode,
     "-C",	"--line-mode",		OPT_HELP_LINE_MODE, "" )

OPT_TITLE(	"Environment:"	)
OPT( OptStringList,	&opts.inc_path,	"-I", "--inc-path",		OPT_HELP_INC_PATH, "PATH" )
OPT( OptStringList,	&opts.lib_path,	"-L", "--lib-path",		OPT_HELP_LIB_PATH, "PATH" )
OPT( OptCallArg,	option_define,	"-D", "--define",		OPT_HELP_DEFINE, "SYMBOL" )

OPT( OptCallOptArg, option_make_lib, "-x", 	"--make-lib", 		OPT_HELP_MAKE_LIB, "[FILE]" )
OPT( OptCallOptArg, option_use_lib,	"-i", 	"--use-lib", 		OPT_HELP_USE_LIB,  "[FILE]" )


OPT_TITLE(	"Output Options:" )
OPT( OptSet,	&opts.make_bin,	"-b", 	"--make-bin", 		OPT_HELP_MAKE_BIN, "" )
OPT( OptClear,	&opts.make_bin,	"-nb", 	"--no-make-bin",	OPT_HELP_NO_MAKE_BIN, "" )

OPT( OptSet,	&opts.date_stamp, "-d", 	"--date-stamp", 	OPT_HELP_DATE_STAMP, "" )
OPT( OptClear,	&opts.date_stamp, "-nd", "--no-date-stamp",	OPT_HELP_NO_DATE_STAMP, "" )

OPT( OptCall,	option_make_updated_bin,
     "-a", 	"--make-updated-bin",
     OPT_HELP_MAKE_UPDATED_BIN, "" )
OPT( OptCallArg, option_origin,	"-r", 	"--origin",			OPT_HELP_ORIGIN, "ORG_HEX" )
OPT( OptSet,	&opts.code_seg,	"-c", 	"--code-seg",		OPT_HELP_CODE_SEG, "" )
OPT( OptSet,	&opts.relocatable,
     "-R", 	"--relocatable",	OPT_HELP_RELOCATABLE, "" )

OPT_TITLE(	"Other Output File Options:" )
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


/*
* $Log: options_def.h,v $
* Revision 1.38  2014-05-17 23:08:03  pauloscustodio
* Change origin to int32_t, use -1 to signal as not defined
*
* Revision 1.37  2014/05/17 14:27:12  pauloscustodio
* Use C99 integer types int8_t, uint8_t, int16_t, uint16_t, int32_t, uint32_t
*
* Revision 1.36  2014/05/17 10:57:45  pauloscustodio
* Parse argv generates list of files that can be iterated by assembler,
* linker and librarian.
*
* Revision 1.35  2014/04/15 20:06:43  pauloscustodio
* Solve warning: no newline at end of file
*
* Revision 1.34  2014/04/13 20:32:06  pauloscustodio
* PUBLIC and EXTERN instead of LIB, XREF, XDEF, XLIB
*
* Revision 1.33  2014/02/08 18:30:49  pauloscustodio
* lib/srcfile.c to read source files and handle recursive includes,
* used to read @lists, removed opts.files;
* model.c to hold global data model
*
* Revision 1.32  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.31  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.30  2014/01/02 17:18:16  pauloscustodio
* StrList removed, replaced by List
*
* Revision 1.29  2014/01/02 02:31:42  pauloscustodio
* parse_argv() collects all files from command line in opts.files, expanding @lists;
* main() iterates through opts.files, eliminating the call-back.
*
* Revision 1.28  2013/12/26 23:42:27  pauloscustodio
* Replace StringList from strutil by StrList in new strlis.c, to keep lists of strings (e.g. directory search paths)
*
* Revision 1.27  2013/10/05 13:43:05  pauloscustodio
* Parse command line options via look-up tables:
* -i, --use-lib
* -x, --make-lib
*
* Revision 1.26  2013/10/05 11:31:46  pauloscustodio
* Parse command line options via look-up tables:
* -D, --define
*
* Revision 1.25  2013/10/05 10:54:36  pauloscustodio
* Parse command line options via look-up tables:
* -I, --inc-path
* -L, --lib-path
*
* Revision 1.24  2013/10/05 09:24:13  pauloscustodio
* Parse command line options via look-up tables:
* -t (deprecated)
*
* Revision 1.23  2013/10/05 08:54:01  pauloscustodio
* Parse command line options via look-up tables:
* -forcexlib, --forcexlib
*
* Revision 1.22  2013/10/05 08:14:43  pauloscustodio
* Parse command line options via look-up tables:
* -C, --line-mode
*
* Revision 1.21  2013/10/04 23:31:50  pauloscustodio
* Parse command line options via look-up tables:
* -IXIY, --swap-ix-iy
*
* Revision 1.20  2013/10/04 23:20:21  pauloscustodio
* Parse command line options via look-up tables:
* -plus, --ti83plus
*
* Revision 1.19  2013/10/04 23:09:25  pauloscustodio
* Parse command line options via look-up tables:
* -R, --relocatable
* --RCMX000
*
* Revision 1.18  2013/10/04 22:24:01  pauloscustodio
* Parse command line options via look-up tables:
* -c, --code-seg
*
* Revision 1.17  2013/10/04 22:04:52  pauloscustodio
* Unify option describing texts
*
* Revision 1.16  2013/10/03 23:48:31  pauloscustodio
* Parse command line options via look-up tables:
* -r, --origin=ORG_HEX
*
* Revision 1.15  2013/10/03 22:54:06  pauloscustodio
* Parse command line options via look-up tables:
* -a, --make-updated-bin
*
* Revision 1.14  2013/10/03 22:35:21  pauloscustodio
* Parse command line options via look-up tables:
* -d, --date-stamp
* -nd, --no-date-stamp
*
* Revision 1.13  2013/10/03 22:20:10  pauloscustodio
* Parse command line options via look-up tables:
* -o, --output
*
* Revision 1.12  2013/10/03 21:58:41  pauloscustodio
* Parse command line options via look-up tables:
* -b, --make-bin
* -nb, --no-make-bin
*
* Revision 1.10  2013/10/02 23:43:57  pauloscustodio
* add log
*
* Revision 1.9  2013/10/02 23:42:09  pauloscustodio
* Parse command line options via look-up tables:
* add --sdcc in addition to -sdcc, for consistency
*
* Revision 1.8  2013/10/02 23:20:44  pauloscustodio
* Parse command line options via look-up tables:
* -g, --globaldef
* -ng, --no-globaldef
*
* Revision 1.7  2013/10/01 23:46:28  pauloscustodio
* Parse command line options via look-up tables:
* -m, --map
* -nm, --no-map
*
* Revision 1.6  2013/10/01 23:23:53  pauloscustodio
* Parse command line options via look-up tables:
* -l, --list
* -nl, --no-list
*
* Revision 1.5  2013/10/01 22:50:26  pauloscustodio
* Parse command line options via look-up tables:
* -s, --symtable
* -ns, --no-symtable
*
* Revision 1.4  2013/10/01 22:09:33  pauloscustodio
* Parse command line options via look-up tables:
* -sdcc
*
* Revision 1.3  2013/09/30 00:33:11  pauloscustodio
* help text
*
* Revision 1.2  2013/09/30 00:24:25  pauloscustodio
* Parse command line options via look-up tables:
* -e, --asm-ext
* -M, --obj-ext
* Move filename extension functions to options.c
*
* Revision 1.1  2013/09/27 01:14:33  pauloscustodio
* Parse command line options via look-up tables:
* --help, --verbose
*/
