/*
*      Front End for The Small C+ Compiler
*
*      Based on the frontend from zcc096 but substantially
*      reworked
*
*      Each file is now processed in turn (all the way through)
*      And then everything is linked at the end, this makes it
*      quite a bit nicer, and a bit more standard - saves having
*      to preprocess all files and then find out there's an error
*      at the start of the first one!
*
*      $Id: zcc.c,v 1.195 2017-01-09 17:53:07 aralbrec Exp $
*/


#include        <stdio.h>
#include        <string.h>
#include        <stdlib.h>
#include        <stdarg.h>
#include        <ctype.h>
#include        <stddef.h>
#include        <stdint.h>
#include        <time.h>
#include        <sys/stat.h>
#include        "zcc.h"
#include        "regex/regex.h"

#ifdef WIN32
#include        <direct.h>
#else
#include        <unistd.h>
#endif


#ifdef WIN32
#define strcasecmp(a,b) stricmp(a,b)
#endif

#if (_BSD_SOURCE || _SVID_SOURCE || _XOPEN_SOURCE >= 500)
#define mktempfile(a) mkstemp(a)
#else
#define mktempfile(a) mktemp(a)
#endif


typedef struct arg_s arg_t;


/* All our function prototypes */

static void            add_option_to_compiler(char *arg);
static void            gather_from_list_file(char *filename);
static void            add_file_to_process(char *filename);

static void            SetNumber(arg_t *argument, char *arg);
static void            SetStringConfig(arg_t *argument, char *arg);
static void            parse_cmdline_arg(char *arg);
static void            SetBoolean(arg_t *arg, char *val);
static void            AddPreProc(arg_t *arg, char *);
static void            AddPreProcIncPath(arg_t *arg, char *);
static void            AddToArgs(arg_t *arg, char *);
static void            AddToArgsQuoted(arg_t *arg, char *);
static void            AddAppmake(arg_t *arg, char *);
static void            AddLinkLibrary(arg_t *arg, char *);
static void            AddLinkSearchPath(arg_t *arg, char *);
static void            print_help_config(arg_t *arg, char *);
static void            print_help_text();
static void            SetString(arg_t *arg, char *);
static void            GlobalDefc(arg_t *argument, char *);
static void            PragmaDefine(arg_t *arg, char *);
static void            PragmaExport(arg_t *arg, char *);
static void            PragmaRedirect(arg_t *arg, char *);
static void            PragmaNeed(arg_t *arg, char *);
static void            PragmaBytes(arg_t *arg, char *);
static void            PragmaInclude(arg_t *arg, char *);
static void            AddArray(arg_t *arg, char *);
static void            write_zcc_defined(char *name, int value, int export);


static void           *mustmalloc(size_t);
static char           *muststrdup(const char *s);
static char           *strstrip(char *s);
static int             hassuffix(char *file, char *suffix_to_check);
static char           *stripsuffix(char *, char *);
static char           *changesuffix(char *, char *);
static char           *find_file_ext(char *filename);
static char           *last_path_char(char *filename);
static int             is_path_absolute(char *filename);
static int             process(char *, char *, char *, char *, enum iostyle, int, int, int);
static int             linkthem(char *);
static int             get_filetype_by_suffix(char *);
static void            BuildAsmLine(char *, size_t, char *);
static void            parse_cmdline_arg(char *option);
static void            BuildOptions(char **, char *);
static void            BuildOptions_start(char **, char *);
static void            BuildOptionsQuoted(char **, char *);
static void            copy_output_files_to_destdir(char *suffix, int die_on_fail);
static void            parse_configfile_line(char *config_line);
static void            KillEOL(char *line);
static int             add_variant_args(char *wanted, int num_choices, char **choices);

static void            configure_assembler();
static void            configure_compiler();
static void            configure_misc_options();
static void            configure_maths_library(char **libstring);


static void            remove_temporary_files(void);
static void            remove_file_with_extension(char *file, char *suffix);
static void            ShowErrors(char *, char *);
static int             copyprepend_file(char *src, char *src_extension, char *dest, char *dest_extension, char *prepend);
static int             copy_file(char *src, char *src_extension, char *dest, char *dest_extension);
static int             prepend_file(char *src, char *src_extension, char *dest, char *dest_extension, char *prepend);
static int             copy_defc_file(char *name1, char *ext1, char *name2, char *ext2);
static void            tempname(char *);
static int             find_zcc_config_fileFile(char *arg, int argc, char *buf, size_t buflen);
static void            parse_option(char *option);
static void            linkargs_mangle(char *linkargs);
static void            add_zccopt(char *fmt, ...);
static char           *replace_str(const char *str, const char *old, const char *new);
static void            setup_default_configuration();
static void            print_specs();
static int             isquote(unsigned char c);
static char           *qstrtok(char *s, const char *delim);
static char           *strip_inner_quotes(char *p);
static char           *strip_outer_quotes(char *p);
static int             zcc_asprintf(char **s, const char *fmt, ...);
static int             zcc_getdelim(char **lineptr, unsigned int *n, int delimiter, FILE *stream);


static int             preserve = 0;    /* don't destroy zcc_opt */
static int             createapp = 0;    /* Go the next stage and create the app */
static int             z80verbose = 0;
static int             cleanup = 1;
static int             assembleonly = 0;
static int             lstcwd = 0;
static int             compileonly = 0;
static int             m4only = 0;
static int             clangonly = 0;
static int             llvmonly = 0;
static int             makelib = 0;
static int             build_bin = 0;
static int             c_code_in_asm = 0;
static int             opt_code_size = 0;
static int             zopt = 0;
static int             verbose = 0;
static int             peepholeopt = 0;
static int             sdccpeepopt = 0;
static int             symbolson = 0;
static int             lston = 0;
static int             mapon = 0;
static int             globaldefon = 0;
static char           *globaldefrefile = NULL;
static int             preprocessonly = 0;
static int             relocate = 0;
static int             relocinfo = 0;
static int             sdcc_signed_char = 0;
static int             crtcopied = 0;    /* Copied the crt0 code over? */
static int             swallow_M = 0;
static int             c_print_specs = 0;
static int             c_zorg = -1;
static int             max_argc;
static int             gargc;
static char          **gargv;
/* filelist has to stay as ** because we change suffix all the time */
static int             nfiles = 0;
static char          **filelist = NULL;              /* Working filenames   */
static char          **original_filenames = NULL;    /* Original filenames  */
static char          **temporary_filenames = NULL;   /* Temporary filenames */
static char           *outputfile = NULL;
static char           *c_linker_output_file = NULL;
static char           *cpparg;
static char           *cpp_incpath_first;
static char           *cpp_incpath_last;
static char           *comparg;
static char           *clangarg;
static char           *clangcpparg = "-D\"__attribute__(x)= \" -D\"__builtin_unreachable(x)= \" ";
static char           *llvmopt;
static char           *llvmarg;
static char           *linkargs;
static char           *linker_libpath_first;
static char           *linker_libpath_last;
static char           *linklibs;
static char           *linker_linklib_first;
static char           *linker_linklib_last;
static char           *asmargs;
static char           *appmakeargs;
static char           *sccz80arg = NULL;
static char           *sdccarg = NULL;
static char           *m4arg = NULL;
static char           *pragincname = NULL;  /* File containing pragmas to append to zcc_opt.def */
static char           *zccopt = NULL;       /* Text to append to zcc_opt.def */
static char           *c_subtype = NULL;
static char           *c_clib = NULL;
static int             c_startup = -2;
static int             c_nostdlib = 0;
static int             mz180 = 0;
static int             mr2k = 0;
static int             c_nocrt = 0;
static char           *c_crt_incpath = NULL;
static int             processing_user_command_line_arg = 0;
static char            c_sccz80_r2l_calling;

static char            filenamebuf[FILENAME_MAX + 1];
static char            tmpnambuf[] = "zccXXXX";

#define ASM_Z80ASM 0
#define ASM_ASXX   1
#define ASM_VASM   2
#define ASM_GNU    3
static char           *c_assembler_type = "z80asm";
static int             assembler_type = ASM_Z80ASM;
static enum iostyle    assembler_style = outimplied;
static char           *sdcc_assemblernames[] = { "z80asm", "asxxxx", "z80asm", "binutils" };
static int             linker_output_separate_arg = 0;

static enum iostyle    compiler_style = outimplied;

#define CC_SCCZ80 0 
#define CC_SDCC   1
static char           *c_compiler_type = "sccz80";
static int             compiler_type = CC_SCCZ80;

#define IS_ASM(x)  ( assembler_type == (x) )


static char           *defaultout = "a.bin";


struct arg_s {
	char  *name;
	int    flags;
	void(*setfunc)(arg_t *arg, char *);
	void  *data;
	int   *num_ptr;
	char  *help;
	char  *defvalue;
};



#define AF_BOOL_TRUE      1
#define AF_BOOL_FALSE     2
#define AF_MORE           4
#define AF_DEPRECATED     8

static char  *c_install_dir = PREFIX "/";
static char  *c_options = NULL;


static char  *c_z80asm_exe = "z80asm";
static char  *c_mpm_exe = "mpm";
static char  *c_vasm_exe = "vasmz80";
static char  *c_vlink_exe = "vlink";
static char  *c_gnuas_exe = "z80-unknown-coff-as";
static char  *c_gnuld_exe = "z80-unknown-coff-ld";
static char  *c_asz80_exe = "asz80";
static char  *c_aslink_exe = "aslink";

static char  *c_clang_exe = "zclang";
static char  *c_llvm_exe = "zllvm-cbe";
static char  *c_sdcc_exe = "zsdcc";
static char  *c_sccz80_exe = "sccz80";
static char  *c_cpp_exe = "zcpp";
static char  *c_sdcc_preproc_exe = "zsdcpp";
static char  *c_zpragma_exe = "zpragma";
static char  *c_copt_exe = "copt";
static char  *c_appmake_exe = "appmake";
#ifndef WIN32
static char  *c_copycmd = "cat";
#else
static char  *c_copycmd = "type";
#endif
static char  *c_extension_config = "o";
static char  *c_incpath = NULL;
static char  *c_clangincpath = NULL;
static char  *c_m4opts = NULL;
static char  *c_coptrules1 = NULL;
static char  *c_coptrules2 = NULL;
static char  *c_coptrules3 = NULL;
static char  *c_coptrules9 = NULL;
static char  *c_coptrules_cpu = NULL;
static char  *c_sdccopt1 = NULL;
static char  *c_sdccopt2 = NULL;
static char  *c_sdccopt3 = NULL;
static char  *c_sdccopt9 = NULL;
static char  *c_sdccpeeph0 = NULL;
static char  *c_sdccpeeph1 = NULL;
static char  *c_sdccpeeph2 = NULL;
static char  *c_sdccpeeph3 = NULL;
static char  *c_sdccpeeph0cs = NULL;
static char  *c_sdccpeeph1cs = NULL;
static char  *c_sdccpeeph2cs = NULL;
static char  *c_sdccpeeph3cs = NULL;
static char  *c_crt0 = NULL;
static char  *c_linkopts = NULL;
static char  *c_asmopts = NULL;
static char  *c_altmathlib = NULL;
static char  *c_altmathflags = NULL; // "-math-z88 -D__NATIVE_MATH__";
static char  *c_startuplib = "z80_crt0";
static char  *c_genmathlib = "gen_math";
static int    c_stylecpp = outspecified;
static char  *c_vasmopts = NULL;
static char  *c_vlinkopts = NULL;
static char  *c_asz80opts = "";
static char  *c_aslinkopts = "";
static char  *c_gnuasopts = "";
static char  *c_gnulinkopts = "";

static char  *c_extension = NULL;
static char  *c_assembler = NULL;
static char  *c_asmarg = NULL;
static char  *c_linker = NULL;
static char  *c_compiler = NULL;
static char **c_subtype_array = NULL;
static int    c_subtype_array_num = 0;
static char **c_clib_array = NULL;
static int    c_clib_array_num = 0;

static arg_t  config[] = {
	{ "OPTIONS", 0, SetStringConfig, &c_options, NULL, "Extra options for port" },

	{ "MPMEXE", 0, SetStringConfig, &c_mpm_exe, NULL,"Name of the mpm binary" },

	{ "VASMEXE", 0, SetStringConfig, &c_vasm_exe, NULL, "Name of the vasm binary" },
	{ "VLINKEXE", 0, SetStringConfig, &c_vlink_exe, NULL, "Name of the vlink binary" },
	{ "VASMOPTS", 0, SetStringConfig, &c_vasmopts, NULL, "Options for VASM", "-quiet -Fvobj -I\"DESTDIR/lib\"" },
	{ "VLINKOPTS", 0, SetStringConfig, &c_vlinkopts, NULL, "", "-L\"DESTDIR/lib/vlink/\"" },

	{ "GNUASEXE", 0, SetStringConfig, &c_gnuas_exe, NULL, "Name of the GNU as binary" },
	{ "GNULDEXE", 0, SetStringConfig, &c_gnuld_exe, NULL, "Name of the GNU ld binary" },
	{ "GNUASOPTS", 0, SetStringConfig, &c_gnuasopts, NULL, "" },
	{ "GNULINKOPTS", 0, SetStringConfig, &c_gnulinkopts, NULL, "" },

	{ "ASZ80EXE", 0, SetStringConfig, &c_asz80_exe, NULL, "Name of the asz80 binary" },
	{ "ASLINKEXE", 0, SetStringConfig, &c_aslink_exe, NULL, "Name of the aslink binary" },
	{ "ASZ80OPTS", 0, SetStringConfig, &c_asz80opts, NULL, "" },
	{ "ASLINKOPTS", 0, SetStringConfig, &c_aslinkopts, NULL, "" },

	{ "CPP", 0, SetStringConfig, &c_cpp_exe, NULL, "Name of the cpp binary" },
	{ "SDCPP", 0, SetStringConfig, &c_sdcc_preproc_exe, NULL, "Name of the SDCC cpp binary" },
	{ "STYLECPP", 0, SetNumber, &c_stylecpp, NULL, "" },
	{ "ZPRAGMAEXE", 0, SetStringConfig, &c_zpragma_exe, NULL, "Name of the zpragma binary" },

	{ "Z80EXE", 0, SetStringConfig, &c_z80asm_exe, NULL, "Name of the z80asm binary" },
	{ "LINKOPTS", 0, SetStringConfig, &c_linkopts, NULL, "Options for z80asm as linker", " -L\"DESTDIR/lib/clibs\" -I\"DESTDIR/lib\" " },
	{ "ASMOPTS", 0, SetStringConfig, &c_asmopts, NULL, "Options for z80asm as assembler", "-I\"DESTDIR/lib\"" },

	{ "COMPILER", AF_DEPRECATED, SetStringConfig, &c_compiler, NULL, "Name of sccz80 binary (use SCCZ80EXE)" },
	{ "SCCZ80EXE", 0, SetStringConfig, &c_sccz80_exe, NULL, "Name of sccz80 binary" },
	{ "ZSDCCEXE", 0, SetStringConfig, &c_sdcc_exe, NULL, "Name of the sdcc binary" },
	{ "ZCLANGEXE", 0, SetStringConfig, &c_clang_exe, NULL, "Name of the clang binary" },
	{ "ZLLVMEXE", 0, SetStringConfig, &c_llvm_exe, NULL, "Name of the llvm-cbe binary" },

	{ "APPMAKEEXE", 0, SetStringConfig, &c_appmake_exe, NULL, "" },
	{ "APPMAKER", AF_DEPRECATED, SetStringConfig, &c_appmake_exe, NULL, "Name of the applink binary (use APPMAKEEXE)" },

	{ "COPTEXE", 0, SetStringConfig, &c_copt_exe, NULL, "" },
	{ "COPYCMD", 0, SetStringConfig, &c_copycmd, NULL, "" },

	{ "INCPATH", 0, SetStringConfig, &c_incpath, NULL, "", "-I\"DESTDIR/include\" " },
	{ "CLANGINCPATH", 0, SetStringConfig, &c_clangincpath, NULL, "", "-isystem \"DESTDIR/include/_DEVELOPMENT/clang\" " },
	{ "M4OPTS", 0, SetStringConfig, &c_m4opts, NULL, "", " -I \"DESTDIR/src/m4\" " },
	{ "COPTRULES1", 0, SetStringConfig, &c_coptrules1, NULL, "", "\"DESTDIR/lib/z80rules.1\"" },
	{ "COPTRULES2", 0, SetStringConfig, &c_coptrules2, NULL, "", "\"DESTDIR/lib/z80rules.2\"" },
	{ "COPTRULES3", 0, SetStringConfig, &c_coptrules3, NULL, "", "\"DESTDIR/lib/z80rules.0\"" },
	{ "COPTRULES9", 0, SetStringConfig, &c_coptrules9, NULL, "", "\"DESTDIR/lib/z80rules.9\"" },
	{ "COPTRULESCPU", 0, SetStringConfig, &c_coptrules_cpu, NULL, "An extra copt file for CPU optimisation", NULL },
	{ "SDCCOPT1", 0, SetStringConfig, &c_sdccopt1, NULL, "", "\"DESTDIR/libsrc/_DEVELOPMENT/sdcc_opt.1\"" },
	{ "SDCCOPT2", 0, SetStringConfig, &c_sdccopt2, NULL, "", "\"DESTDIR/libsrc/_DEVELOPMENT/sdcc_opt.2\"" },
	{ "SDCCOPT3", 0, SetStringConfig, &c_sdccopt3, NULL, "", "\"DESTDIR/libsrc/_DEVELOPMENT/sdcc_opt.3\"" },
	{ "SDCCOPT9", 0, SetStringConfig, &c_sdccopt9, NULL, "", "\"DESTDIR/libsrc/_DEVELOPMENT/sdcc_opt.9\"" },
	{ "SDCCPEEP0", 0, SetStringConfig, &c_sdccpeeph0, NULL, "", " --no-peep --peep-file \"DESTDIR/libsrc/_DEVELOPMENT/sdcc_peeph.0\"" },
	{ "SDCCPEEP1", 0, SetStringConfig, &c_sdccpeeph1, NULL, "", " --no-peep --peep-file \"DESTDIR/libsrc/_DEVELOPMENT/sdcc_peeph.1\"" },
	{ "SDCCPEEP2", 0, SetStringConfig, &c_sdccpeeph2, NULL, "", " --no-peep --peep-file \"DESTDIR/libsrc/_DEVELOPMENT/sdcc_peeph.2\"" },
	{ "SDCCPEEP3", 0, SetStringConfig, &c_sdccpeeph3, NULL, "", " --no-peep --peep-file \"DESTDIR/libsrc/_DEVELOPMENT/sdcc_peeph.3\"" },
	{ "SDCCOPTSZ0", 0, SetStringConfig, &c_sdccpeeph0cs, NULL, "", " --no-peep --peep-file \"DESTDIR/libsrc/_DEVELOPMENT/sdcc_peeph_cs.0\"" },
	{ "SDCCOPTSZ1", 0, SetStringConfig, &c_sdccpeeph1cs, NULL, "", " --no-peep --peep-file \"DESTDIR/libsrc/_DEVELOPMENT/sdcc_peeph_cs.1\"" },
	{ "SDCCOPTSZ2", 0, SetStringConfig, &c_sdccpeeph2cs, NULL, "", " --no-peep --peep-file \"DESTDIR/libsrc/_DEVELOPMENT/sdcc_peeph_cs.2\"" },
	{ "SDCCOPTSZ3", 0, SetStringConfig, &c_sdccpeeph3cs, NULL, "", " --no-peep --peep-file \"DESTDIR/libsrc/_DEVELOPMENT/sdcc_peeph_cs.3\"" },
	{ "CRT0", 0, SetStringConfig, &c_crt0, NULL, "" },

	{ "ALTMATHLIB", 0, SetStringConfig, &c_altmathlib, NULL, "Name of the alt maths library" },
	{ "ALTMATHFLG", 0, SetStringConfig, &c_altmathflags, NULL, "Additional options for non-generic maths" },
	{ "Z88MATHLIB", AF_DEPRECATED, SetStringConfig, &c_altmathlib, NULL, "Name of the alt maths library (use ALTMATHLIB)" },
	{ "Z88MATHFLG", AF_DEPRECATED, SetStringConfig, &c_altmathflags, NULL, "Additional options for non-generic maths (use ALTMATHFLG)" },
	{ "STARTUPLIB", 0, SetStringConfig, &c_startuplib, NULL, "" },
	{ "GENMATHLIB", 0, SetStringConfig, &c_genmathlib, NULL, "" },
	{ "SUBTYPE",  0, AddArray, &c_subtype_array, &c_subtype_array_num, "Add a sub-type alias and config" },
	{ "CLIB",  0, AddArray, &c_clib_array, &c_clib_array_num, "Add a clib variant config" },
	{ "", 0, NULL, NULL }
};






static arg_t     myargs[] = {
	{ "z80-verb", AF_BOOL_TRUE, SetBoolean, &z80verbose, NULL, "Make the assembler more verbose" },
	{ "cleanup",  AF_BOOL_TRUE, SetBoolean, &cleanup, NULL,    "(default) Cleanup temporary files" },
	{ "no-cleanup", AF_BOOL_FALSE, SetBoolean, &cleanup, NULL, "Don't cleanup temporary files" },
	{ "preserve", AF_BOOL_TRUE, SetBoolean, &preserve, NULL, "Don't remove zcc_opt.def at start of run" },
	{ "create-app", AF_BOOL_TRUE, SetBoolean, &createapp, NULL, "Run appmake on the resulting binary to create emulator usable file" },
	{ "specs", AF_BOOL_TRUE, SetBoolean, &c_print_specs, NULL, "Print out compiler specs" },
	{ "asm", AF_MORE, SetString, &c_assembler_type, NULL, "Set the assembler type from the command line (z80asm, mpm, asxx, vasm, binutils)" },
	{ "compiler", AF_MORE, SetString, &c_compiler_type, NULL, "Set the compiler type from the command line (sccz80, sdcc)" },
    { "mz180", AF_BOOL_TRUE, SetBoolean, &mz180, NULL, "Target the z180 cpu" },
	{ "mr2k", AF_BOOL_TRUE, SetBoolean, &mr2k, NULL, "Target the Rabbit 2/3000 cpu" },
	{ "crt0", AF_MORE, SetString, &c_crt0, NULL, "Override the crt0 assembler file to use" },
	{ "-no-crt", AF_BOOL_TRUE, SetBoolean, &c_nocrt, NULL, "Link without crt0 file" },
	{ "pragma-redirect",AF_MORE,PragmaRedirect,NULL, NULL, "Redirect a function" },
	{ "pragma-define",AF_MORE,PragmaDefine,NULL, NULL, "Define the option in zcc_opt.def" },
	{ "pragma-export",AF_MORE,PragmaExport,NULL, NULL, "Define the option in zcc_opt.def and export as public" },
	{ "pragma-need",AF_MORE,PragmaNeed,NULL, NULL, "NEED the option in zcc_opt.def" },
	{ "pragma-bytes",AF_MORE,PragmaBytes,NULL, NULL, "Dump a string of bytes zcc_opt.def" },
	{ "pragma-include",AF_MORE,PragmaInclude,NULL, NULL, "Process include file containing pragmas" },
	{ "subtype", AF_MORE, SetString, &c_subtype, NULL, "Set the target subtype" },
	{ "clib", AF_MORE, SetString, &c_clib, NULL, "Set the target clib type" },
	{ "startup", AF_MORE, SetNumber, &c_startup, NULL, "Set the startup type" },
	{ "zorg", AF_MORE, SetNumber, &c_zorg, NULL, "Set the origin (only certain targets)" },
	{ "nostdlib", AF_BOOL_TRUE, SetBoolean, &c_nostdlib, NULL, "If set ignore INCPATH, STARTUPLIB" },
	{ "Cm", AF_MORE, AddToArgs, &m4arg, NULL, "Add an option to m4" },
	{ "Cp", AF_MORE, AddToArgs, &cpparg, NULL, "Add an option to the preprocessor" },
	{ "Cc", AF_MORE, AddToArgs, &sccz80arg, NULL, "Add an option to sccz80" },
	{ "Cg", AF_MORE, AddToArgs, &clangarg, NULL, "Add an option to clang" },
	{ "Cs", AF_MORE, AddToArgs, &sdccarg, NULL, "Add an option to sdcc" },
	{ "Ca", AF_MORE, AddToArgsQuoted, &asmargs, NULL, "Add an option to the assembler" },
	{ "Cl", AF_MORE, AddToArgsQuoted, &linkargs, NULL, "Add an option to the linker" },
	{ "Co", AF_MORE, AddToArgs, &llvmopt, NULL, "Add an option to llvm-opt" },
	{ "Cv", AF_MORE, AddToArgs, &llvmarg, NULL, "Add an option to llvm-cbe" },
	{ "Cz", AF_MORE, AddToArgs, &appmakeargs, NULL, "Add an option to appmake" },
	{ "m4", AF_BOOL_TRUE, SetBoolean, &m4only, NULL, "Stop after processing m4 files" },
	{ "clang", AF_BOOL_TRUE, SetBoolean, &clangonly, NULL, "Stop after translating .c files to llvm ir" },
	{ "llvm", AF_BOOL_TRUE, SetBoolean, &llvmonly, NULL, "Stop after llvm-cbe generates new .cbe.c files" },
	{ "E", AF_BOOL_TRUE, SetBoolean, &preprocessonly, NULL, "Stop after preprocessing files" },
	{ "R", AF_BOOL_TRUE, SetBoolean, &relocate, NULL, "Generate relocatable code (deprecated)" },
	{ "-reloc-info", AF_BOOL_TRUE, SetBoolean, &relocinfo, NULL, "Generate binary file relocation information" },
	{ "D", AF_MORE, AddPreProc, NULL, NULL, "Define a preprocessor option" },
	{ "U", AF_MORE, AddPreProc, NULL, NULL, "Undefine a preprocessor option" },
	{ "I", AF_MORE, AddPreProcIncPath, NULL, NULL, "Add an include directory for the preprocessor" },
	{ "L", AF_MORE, AddLinkSearchPath, NULL, NULL, "Add a library search path" },
	{ "l", AF_MORE, AddLinkLibrary, NULL, NULL, "Add a library" },
	{ "O", AF_MORE, SetNumber, &peepholeopt, NULL, "Set the peephole optimiser setting for copt" },
	{ "SO", AF_MORE, SetNumber, &sdccpeepopt, NULL, "Set the peephole optimiser setting for sdcc-peephole" },
	{ "h", 0, print_help_config, NULL, NULL, "Display this text" },
	{ "v", AF_BOOL_TRUE, SetBoolean, &verbose, NULL, "Output all commands that are run (-vn suppresses)" },
	{ "bn", AF_MORE, SetString, &c_linker_output_file, NULL, "Set the output file for the linker stage" },
	{ "vn", AF_BOOL_FALSE, SetBoolean, &verbose, NULL, "Run the compile stages silently" },
	{ "c", AF_BOOL_TRUE, SetBoolean, &compileonly, NULL, "Stop after compiling .c .s .asm files to .o files" },
	{ "a", AF_BOOL_TRUE, SetBoolean, &assembleonly, NULL, "Stop after compiling .c .s files to .asm files" },
	{ "S", AF_BOOL_TRUE, SetBoolean, &assembleonly, NULL, "Stop after compiling .c .s files to .asm files" },
	{ "-lstcwd", AF_BOOL_TRUE, SetBoolean, &lstcwd, NULL, "Paths in .lst files are relative to the current working dir" },
	{ "x", AF_BOOL_TRUE, SetBoolean, &makelib, NULL, "Make a library out of source files" },
	{ "-c-code-in-asm", AF_BOOL_TRUE, SetBoolean, &c_code_in_asm, NULL, "Add C code to .asm files" },
	{ "-opt-code-size", AF_BOOL_TRUE, SetBoolean, &opt_code_size, NULL, "Optimize for code size (sdcc only)" },
	{ "zopt", AF_BOOL_TRUE, SetBoolean, &zopt, NULL, "Enable llvm-optimizer (clang only)" },
	{ "m", AF_BOOL_TRUE, SetBoolean, &mapon, NULL, "Generate an output map of the final executable" },
	{ "g", AF_MORE, GlobalDefc, &globaldefrefile, &globaldefon, "Generate a global defc file of the final executable (-g, -gp, -gpf filename)" },
	{ "s", AF_BOOL_TRUE, SetBoolean, &symbolson, NULL, "Generate a symbol map of the final executable" },
	{ "-list", AF_BOOL_TRUE, SetBoolean, &lston, NULL, "Generate list files" },
	{ "o", AF_MORE, SetString, &outputfile, NULL, "Set the output files" },
	{ "nt", 0, AddAppmake, NULL, NULL, "Set notruncate on the appmake options" },
	{ "set-r2l-by-default", AF_BOOL_TRUE, SetBoolean, &c_sccz80_r2l_calling, NULL, "(sccz80) Use r2l calling convention by default"},
	{ "+", NO, AddPreProc, NULL, NULL, NULL },    /* Strips // comments in vcpp */
	{ "-fsigned-char", AF_BOOL_TRUE, SetBoolean, &sdcc_signed_char, NULL, NULL },    /* capture sdcc signed char flag */
	{ "M", AF_BOOL_TRUE, SetBoolean, &swallow_M, NULL, NULL },    /* swallow unsupported -M flag that configs are still generating (causes prob with sdcc) */
	{ "", 0, NULL, NULL }
};



static void *mustmalloc(size_t n)
{
	void           *p;

	if ((p = malloc(n)) == 0) {
		fprintf(stderr, "malloc failed\n");
		exit(1);
	}
	return (p);
}

static char *muststrdup(const char *s)
{
	char *r;

	if ((r = strdup(s)) == NULL) {
		fprintf(stderr, "strdup failed\n");
		exit(1);
	}
	return r;
}

static char *strstrip(char *s)
{
    char *p;

    while (isspace(*s)) ++s;

    for (p = s + strlen(s); p != s; *p = 0)
        if (!isspace(*--p)) break;

    return s;
}
static int hassuffix(char *name, char *suffix)
{
	int             nlen, slen;

	nlen = strlen(name);
	slen = strlen(suffix);

	if (slen > nlen)
		return (0);
	return (strcmp(&name[nlen - slen], suffix) == 0);
}

static char *stripsuffix(char *name, char *suffix)
{
	char *p, *r;

	/* Recursively strip suffix */
	r = muststrdup(name);
	while (((p = find_file_ext(r)) != NULL) && (strcmp(p, suffix) == 0))
		*p = '\0';
	return r;
}

static char *changesuffix(char *name, char *suffix)
{
	char *p, *r;

	if ((p = find_file_ext(name)) == NULL) {
		r = mustmalloc(strlen(name) + strlen(suffix) + 1);
		sprintf(r, "%s%s", name, suffix);
	}
	else {
		r = mustmalloc(p - name + strlen(suffix) + 1);
		r[0] = '\0';
		strncat(r, name, p - name);
		strcat(r, suffix);
	}

	return (r);
}

int
process(char *suffix, char *nextsuffix, char *processor, char *extraargs, enum iostyle ios, int number, int needsuffix, int src_is_original)
{
	int             status, errs;
	int             tstore;
	char            buffer[8192], *outname;

	errs = 0;

	if (!hassuffix(filelist[number], suffix))
		return (0);

	outname = changesuffix(temporary_filenames[number], nextsuffix);

	switch (ios) {
	case outimplied:
		/* Dropping the suffix for Z80..cheating! */
		tstore = strlen(filelist[number]) - strlen(suffix);
		if (!needsuffix)
			filelist[number][tstore] = 0;
		snprintf(buffer, sizeof(buffer), "%s %s \"%s\"", processor, extraargs, filelist[number]);
		filelist[number][tstore] = '.';
		break;
	case outspecified:
		snprintf(buffer, sizeof(buffer), "%s %s \"%s\" \"%s\"", processor, extraargs, filelist[number], outname);
		break;
	case outspecified_flag:
		snprintf(buffer, sizeof(buffer), "%s %s \"%s\" -o \"%s\"", processor, extraargs, filelist[number], outname);
		break;
	case filter:
		snprintf(buffer, sizeof(buffer), "%s %s < \"%s\" > \"%s\"", processor, extraargs, filelist[number], outname);
		break;
	case filter_outspecified_flag:
		snprintf(buffer, sizeof(buffer), "%s %s < \"%s\" -o \"%s\"", processor, extraargs, filelist[number], outname);
		break;
	}

	if (verbose) {
		printf("%s\n", buffer);
	}

	status = system(buffer);

	if (status != 0) {
		errs = 1;
		free(outname);
	}
	else {
		/* Free up the allocated memory */
		free(filelist[number]);
		filelist[number] = outname;
	}

	return (errs);
}


int linkthem(char *linker)
{
	int             i, len, offs, status;
	char           *temp, *cmdline;
	char           *asmline = "";
	char            tname[FILENAME_MAX + 1];
	FILE           *out, *prj;

	linkargs_mangle(linklibs);
	linkargs_mangle(linkargs);

	if (compileonly)
    {
		len = offs = zcc_asprintf(&temp, "%s %s --output=\"%s\" %s",
			linker,
            mz180 ? "--cpu=z180" : "",
			outputfile,
			linkargs);
	}
	else if (makelib)
    {
		len = offs = zcc_asprintf(&temp, "%s %s %s -d %s %s -x\"%s\"",
			linker,
			(z80verbose && IS_ASM(ASM_Z80ASM)) ? "-v" : "",
            mz180 ? "--cpu=z180" : "",
			IS_ASM(ASM_Z80ASM) ? "" : "-Mo ",
			linkargs,
			outputfile);
	}
	else
    {
        // late assembly for first file which acts as crt
        if (verbose) printf("\nPROCESSING CRT\n");
        if (process(".asm", c_extension, c_assembler, c_crt_incpath ? c_crt_incpath : "", assembler_style, 0, YES, NO))
            exit(1);
        if (verbose) puts("");
        free(c_crt_incpath);

        len = offs = zcc_asprintf(&temp, "%s %s -b -d %s -o%s\"%s\" %s%s%s%s%s%s%s%s%s",
            linker,
            mz180 ? "--cpu=z180" : "",
            IS_ASM(ASM_Z80ASM) ? "" : "-Mo ",
            linker_output_separate_arg ? " " : "",
            outputfile,
            (z80verbose && IS_ASM(ASM_Z80ASM)) ? "-v " : "",
            (relocate && IS_ASM(ASM_Z80ASM)) ? "-R " : "",
            globaldefon ? "-g " : "",
            (createapp || mapon) ? "-m " : "",
            (createapp || symbolson) ? "-s " : "",
            relocinfo ? "--reloc-info " : "",
            linkargs,
            (c_nostdlib == 0) ? c_linkopts : "",
            linklibs);
	}

	tname[0] = '\0';
	prj = z80verbose ? fopen(PROJFILE, "w") : NULL;

	if ((nfiles > 2) && IS_ASM(ASM_Z80ASM))
    {
		// place source files into a list file for z80asm

		tempname(tname);
		strcat(tname, ".lst");
		if ((out = fopen(tname, "w")) == NULL) goto USE_COMMANDLINE;

		for (i = 0; i < nfiles; ++i)
        {
            if (hassuffix(filelist[i], c_extension))
            {
                fprintf(out, "%s\n", filelist[i]);
                if (prj) fprintf(prj, "%s\n", original_filenames[i]);
            }
		}

		fclose(out);

		len += strlen(tname) + 5;
		cmdline = calloc(len, sizeof(char));

		snprintf(cmdline, len, "%s \"@%s\"", temp, tname);
	}
	else
    {
	USE_COMMANDLINE:

		// place source files on the command line

		for (i = 0; i < nfiles; i++)
			len += strlen(filelist[i]) + 7;
		len++;

		/* So the total length we need is now in len, let's malloc and do it */

		cmdline = calloc(len, sizeof(char));
		strcpy(cmdline, temp);

		for (i = 0; i < nfiles; ++i)
        {
            if (hassuffix(filelist[i], c_extension))
            {
                offs += snprintf(cmdline + offs, len - offs, " \"%s\"", filelist[i]);
                if (prj) fprintf(prj, "%s\n", original_filenames[i]);
            }
		}
	}

	if (prj) fclose(prj);

	if (verbose)
		printf("%s\n", cmdline);
	status = system(cmdline);

	if (cleanup && strlen(tname))
		remove_file_with_extension(tname, ".lst");

	free(cmdline);
	free(temp);

	return (status);
}

int main(int argc, char **argv)
{
	int             i, ft, gc;
	char           *ptr;
	char            config_filename[FILENAME_MAX + 1];
	char            asmarg[4096];    /* Hell, that should be long enough! */
	char            buffer[LINEMAX + 1];    /* For reading in option file */
	FILE           *fp;

#ifdef WIN32
	/* Randomize temporary filenames for windows */
	snprintf(tmpnambuf, sizeof(tmpnambuf), "zcc%04X", ((unsigned int)time(NULL)) & 0xffff);
#endif

	processing_user_command_line_arg = 0;

	asmargs = linkargs = cpparg = clangarg = llvmopt = llvmarg = NULL;
	linklibs = muststrdup("");

	cpp_incpath_first = cpp_incpath_last = NULL;
	linker_libpath_first = linker_libpath_last = NULL;
	linker_linklib_first = linker_linklib_last = NULL;

	atexit(remove_temporary_files);
	add_option_to_compiler("");

	gc = 1;            /* Set for the first argument to scan for */
	if (argc == 1) {
		print_help_text();
		exit(1);
	}

	/* Setup the install prefix based on ZCCCFG */
	if ((ptr = getenv("ZCCCFG")) != NULL) {
#ifdef WIN32
		snprintf(config_filename, sizeof(config_filename), "%s\\..\\..\\", ptr);
#else
		snprintf(config_filename, sizeof(config_filename), "%s/../../", ptr);
#endif
		c_install_dir = muststrdup(config_filename);
	}

	setup_default_configuration();

	gc = find_zcc_config_fileFile(argv[gc], gc, config_filename, sizeof(config_filename));
	/* Okay, so now we read in the options file and get some info for us */
	if ((fp = fopen(config_filename, "r")) == NULL) {
		fprintf(stderr, "Can't open config file %s\n", config_filename);
		exit(1);
	}
	while (fgets(buffer, LINEMAX, fp) != NULL) {
		if (!isupper(buffer[0]))
			continue;
		parse_configfile_line(buffer);
	}
	fclose(fp);

	/* Now, parse the default options list */
	if (c_options != NULL) {
		parse_option(muststrdup(c_options));
	}

	/* Now, let's parse the command line arguments */
	max_argc = argc;
	gargv = argv;        /* Point argv to start of command line */

	processing_user_command_line_arg = 1;
	for (gargc = gc; gargc < argc; gargc++) {
		if (argv[gargc][0] == '-')
			parse_cmdline_arg(argv[gargc]);
		else
			add_file_to_process(argv[gargc]);
	}
	processing_user_command_line_arg = 0;

	if (c_print_specs) {
		print_specs();
		exit(0);
	}


	if (add_variant_args(c_subtype, c_subtype_array_num, c_subtype_array) == -1) {
		fprintf(stderr, "Cannot find definition for target -subtype=%s\n", c_subtype);
		exit(1);
	}
	if (add_variant_args(c_clib, c_clib_array_num, c_clib_array) == -1) {
		fprintf(stderr, "Cannot find definition for -clib=%s\n", c_clib);
		exit(1);
	}

	/* We must have at least a crt file - we can rely on defaults for everything else */
	if (c_crt0 == NULL) {
		fprintf(stderr, "No CRT0 defined in configuration file <%s>\n", config_filename);
		exit(1);
	}

	configure_assembler();
	configure_compiler();
	configure_misc_options();

	if (c_nostdlib == 0) {
		/* Add the startup library to the linker arguments */
		if (c_startuplib && strlen(c_startuplib)) {
			snprintf(buffer, sizeof(buffer), "-l\"%s\" ", c_startuplib);
			AddLinkLibrary(NULL, buffer);
			/* Add the default cpp path */
			AddPreProcIncPath(NULL, c_incpath);
		}
	}

	if (lston) {
		/* list on so add list options to assembler and linker */
		BuildOptions(&asmargs, "--list ");
		BuildOptions(&linkargs, "--list ");
	}


	/* clear zcc_opt.def */
	if (preserve == NO) {
		if ((fp = fopen(DEFFILE, "w")) != NULL) {
			fclose(fp);
			if (remove(DEFFILE) < 0) {
				fprintf(stderr, "Cannot remove %s: File in use?\n", DEFFILE);
				exit(1);
			}
		}
		else {
			fprintf(stderr, "Cannot open %s: File in use?\n", DEFFILE);
			exit(1);
		}
	}

	if (c_zorg != -1) {
		write_zcc_defined("CRT_ORG_CODE", c_zorg, 0);
	}

	if ((fp = fopen(DEFFILE, "a")) != NULL) {
		fprintf(fp, "%s", zccopt ? zccopt : "");
		fclose(fp);
	}
	else {
		fprintf(stderr, "Could not create %s: File in use?\n", DEFFILE);
		exit(1);
	}

	/* process pragma-include */
	if (pragincname)
	{
		char cmdline[FILENAME_MAX + 128];

#ifdef _WIN32
		snprintf(cmdline, FILENAME_MAX + 127, "zpragma < \"%s\" > nul", pragincname);
#else
		snprintf(cmdline, FILENAME_MAX + 127, "zpragma < \"%s\" > /dev/null", pragincname);
#endif
		if (verbose) printf("%s\n", cmdline);
		system(cmdline);
	}


	if (nfiles <= 0) {
		print_help_text();
		exit(0);
	}


	/* Mangle math lib name but only for classic compiles */
	if ((c_clib == 0) || (!strstr(c_clib, "new") && !strstr(c_clib, "sdcc") && !strstr(c_clib, "clang")))
		if (linker_linklib_first) configure_maths_library(&linker_linklib_first);   // -lm appears here

    /* Options that must be sequenced in specific order */
	if (compiler_type == CC_SDCC)
		BuildOptions_start(&comparg, "--constseg rodata_compiler ");

	BuildOptions(&clangarg, c_clangincpath);
	if (cpp_incpath_last) {
		BuildOptions(&cpparg, cpp_incpath_last);
		BuildOptions(&clangarg, cpp_incpath_last);
	}
	if (cpp_incpath_first) {
		BuildOptions_start(&cpparg, cpp_incpath_first);
		BuildOptions_start(&clangarg, cpp_incpath_first);
	}
	clangarg = replace_str(ptr = clangarg, "-I", "-idirafter ");
	free(ptr);
	clangarg = replace_str(ptr = clangarg, "-D__SDCC", "-D__CLANG");
	free(ptr);

	BuildOptions(&linker_libpath_first, "-L. ");
	if (linker_libpath_last)
		BuildOptions(&linker_libpath_first, linker_libpath_last);
	BuildOptions_start(&linkargs, linker_libpath_first);

	if (linker_linklib_last)
		BuildOptions(&linker_linklib_first, linker_linklib_last);
	if (linker_linklib_first)
		BuildOptions_start(&linklibs, linker_linklib_first);

	/* CLANG & LLVM options */
	BuildOptions_start(&clangarg, "--target=sdcc-z80 -S -emit-llvm ");
	if (!sdcc_signed_char) BuildOptions_start(&clangarg, "-fno-signed-char ");
	BuildOptions(&llvmarg, llvmarg ? "-disable-partial-libcall-inlining " : "-O2 -disable-partial-libcall-inlining ");
	BuildOptions(&llvmopt, llvmopt ? "-disable-simplify-libcalls -disable-loop-vectorization -disable-slp-vectorization -S " : "-O2 -disable-simplify-libcalls -disable-loop-vectorization -disable-slp-vectorization -S ");


	/* Peephole optimization level for sdcc */
	if (compiler_type == CC_SDCC)
	{
		switch (sdccpeepopt)
		{
		case 0:
			add_option_to_compiler(opt_code_size ? c_sdccpeeph0cs : c_sdccpeeph0);
			break;
		case 1:
			add_option_to_compiler(opt_code_size ? c_sdccpeeph1cs : c_sdccpeeph1);
			break;
		case 2:
			add_option_to_compiler(opt_code_size ? c_sdccpeeph2cs : c_sdccpeeph2);
			break;
		default:
			add_option_to_compiler(opt_code_size ? c_sdccpeeph3cs : c_sdccpeeph3);
			break;
		}
	}

    /* m4 include path points to target's home directory */
    if ((ptr = last_path_char(c_crt0)) != NULL) {
        char *p;
        p = mustmalloc((ptr - c_crt0 + 7) * sizeof(char));
        sprintf(p, "-I \"%.*s\"",(int)( ptr - c_crt0), c_crt0);
        BuildOptions(&m4arg, p);
        free(p);
    }

    /* m4 include path finds z88dk macro definition file "z88dk.m4" */
    BuildOptions(&m4arg, c_m4opts);

    build_bin = !m4only && !clangonly && !llvmonly && !preprocessonly && !assembleonly && !compileonly && !makelib;

    /* Activate target's crt file */
    if ((c_nocrt == 0) && build_bin) {
        // append target crt to end of filelist
        add_file_to_process(c_crt0);
        // move crt to front of filelist
        ptr = original_filenames[nfiles - 1];
        memmove(&original_filenames[1], &original_filenames[0], (nfiles - 1) * sizeof(*original_filenames));
        original_filenames[0] = ptr;
        ptr = filelist[nfiles - 1];
        memmove(&filelist[1], &filelist[0], (nfiles - 1) * sizeof(*filelist));
        filelist[0] = ptr;
        ptr = temporary_filenames[nfiles - 1];
        memmove(&temporary_filenames[1], &temporary_filenames[0], (nfiles - 1) * sizeof(*temporary_filenames));
        temporary_filenames[0] = ptr;
    }

    /* crt file is now the first file in filelist */
    c_crt0 = temporary_filenames[0];

	// Parse through the files, handling each one in turn
	for (i = 0; i < nfiles; i++) {
		if (verbose) printf("\nPROCESSING %s\n", original_filenames[i]);
	SWITCH_REPEAT:
		switch (get_filetype_by_suffix(filelist[i])) {
		case M4FILE:
			if (process(".m4", "", "m4", (m4arg == NULL) ? "" : m4arg, filter, i, YES, YES))
				exit(1);
			// Disqualify recursive .m4 extensions
			ft = get_filetype_by_suffix(filelist[i]);
			if (ft == M4FILE) {
				fprintf(stderr, "Cannot process recursive .m4 file %s\n", original_filenames[i]);
				exit(1);
			}
			// Write processed file to original source location immediately
			ptr = stripsuffix(original_filenames[i], ".m4");
			if (copy_file(filelist[i], "", ptr, "")) {
				fprintf(stderr, "Couldn't write output file %s\n", ptr);
				exit(1);
			}
			// Copied file becomes the new original file
			free(original_filenames[i]);
			free(filelist[i]);
			original_filenames[i] = ptr;
			filelist[i] = muststrdup(ptr);
			// No more processing for .h and .inc files
			ft = get_filetype_by_suffix(filelist[i]);
			if ((ft == HDRFILE) || (ft == INCFILE)) continue;
			// Continue processing macro expanded source file
			goto SWITCH_REPEAT;
			break;
		CASE_LLFILE:
		case LLFILE:
			if (m4only || clangonly) continue;
			// llvm-cbe translates llvm-ir to c
			if (zopt && process(".ll", ".opt.ll", "zopt", llvmopt, outspecified_flag, i, YES, NO))
                exit(1);
			if (process(".ll", ".cbe.c", c_llvm_exe, llvmarg, outspecified_flag, i, YES, NO))
				exit(1);
			// Write .cbe.c to original directory immediately
			ptr = changesuffix(original_filenames[i], ".cbe.c");
			if (copy_file(filelist[i], "", ptr, "")) {
				fprintf(stderr, "Couldn't write output file %s\n", ptr);
				exit(1);
			}
			// Copied file becomes the new original file
			free(original_filenames[i]);
			free(filelist[i]);
			original_filenames[i] = ptr;
			filelist[i] = muststrdup(ptr);
		case CFILE:
			if (m4only) continue;
			// special treatment for clang+llvm
			if ((strcmp(c_compiler_type, "clang") == 0) && !hassuffix(filelist[i], ".cbe.c")) {
				if (process(".c", ".ll", c_clang_exe, clangarg, outspecified_flag, i, YES, NO))
                    exit(1);
				goto CASE_LLFILE;
			}
			if (clangonly || llvmonly) continue;
			if (hassuffix(filelist[i], ".cbe.c"))
				BuildOptions(&cpparg, clangcpparg);
			// past clang+llvm related pre-processing
			if (compiler_type == CC_SDCC) {
				if (process(".c", ".i2", c_cpp_exe, cpparg, c_stylecpp, i, YES, YES))
					exit(1);
				if (process(".i2", ".i", c_zpragma_exe, "", filter, i, YES, NO))
					exit(1);
			}
			else {
				if (process(".c", ".i2", c_cpp_exe, cpparg, c_stylecpp, i, YES, YES))
					exit(1);
				if (process(".i2", ".i", c_zpragma_exe, "-sccz80", filter, i, YES, NO))
					exit(1);
			}
		case CPPFILE:
			if (m4only || clangonly || llvmonly || preprocessonly) continue;
			if (process(".i", ".opt", c_compiler, comparg, compiler_style, i, YES, NO))
				exit(1);
		case OPTFILE:
			if (m4only || clangonly || llvmonly || preprocessonly) continue;
			if (compiler_type == CC_SDCC)
			{
				char *before_cpuext = ".asm";

				if ( c_coptrules_cpu ) {
					before_cpuext = ".opc";
				}
				/* sdcc_opt.9 implements bugfixes and code size reduction and should be applied to every sdcc compile */
				switch (peepholeopt)
				{
				case 0:
					// the output will be in asz80 syntax which is stored in a .s file
					if (process(".opt", ".s", c_copt_exe, c_sdccopt9, filter, i, YES, NO))
						exit(1);
					break;
				case 1:
					if (process(".opt", ".op1", c_copt_exe, c_sdccopt1, filter, i, YES, NO))
						exit(1);
					if (process(".op1", before_cpuext, c_copt_exe, c_sdccopt9, filter, i, YES, NO))
						exit(1);
					if ( c_coptrules_cpu && process(before_cpuext, ".asm", c_copt_exe, c_coptrules_cpu, filter, i, YES, NO))
						exit(1);
					break;
				default:
					if (process(".opt", ".op1", c_copt_exe, c_sdccopt1, filter, i, YES, NO))
						exit(1);
					if (process(".op1", ".op2", c_copt_exe, c_sdccopt9, filter, i, YES, NO))
						exit(1);
					if (process(".op2", before_cpuext, c_copt_exe, c_sdccopt2, filter, i, YES, NO))
						exit(1);
					if ( c_coptrules_cpu && process(before_cpuext, ".asm", c_copt_exe, c_coptrules_cpu, filter, i, YES, NO))
						exit(1);
					break;
				}
			}
			else
			{
				char *before_cpuext = ".asm";

				if ( c_coptrules_cpu ) {
					before_cpuext = ".opc";
				}
				/* z80rules.9 implements intrinsics and should be applied to every sccz80 compile */
				switch (peepholeopt)
				{
				case 0:
					if (process(".opt", before_cpuext, c_copt_exe, c_coptrules9, filter, i, YES, NO))
						exit(1);
					if ( c_coptrules_cpu && process(before_cpuext, ".asm", c_copt_exe, c_coptrules_cpu, filter, i, YES, NO))
						exit(1);
					break;
				case 1:
					if (process(".opt", ".op1", c_copt_exe, c_coptrules9, filter, i, YES, NO))
						exit(1);
					if (process(".op1", before_cpuext, c_copt_exe, c_coptrules1, filter, i, YES, NO))
						exit(1);
					if ( c_coptrules_cpu && process(before_cpuext, ".asm", c_copt_exe, c_coptrules_cpu, filter, i, YES, NO))
						exit(1);
					break;
				case 2:
					/* Double optimization! */
					if (process(".opt", ".op1", c_copt_exe, c_coptrules9, filter, i, YES, NO))
						exit(1);
					if (process(".op1", ".op2", c_copt_exe, c_coptrules2, filter, i, YES, NO))
						exit(1);
					if (process(".op2", before_cpuext, c_copt_exe, c_coptrules1, filter, i, YES, NO))
						exit(1);
					if ( c_coptrules_cpu && process(before_cpuext, ".asm", c_copt_exe, c_coptrules_cpu, filter, i, YES, NO))
						exit(1);
					break;
				default:
					/*
					* Triple opt (last level adds routines but
					* can save space..)
					*/
					if (process(".opt", ".op1", c_copt_exe, c_coptrules9, filter, i, YES, NO))
						exit(1);
					if (process(".op1", ".op2", c_copt_exe, c_coptrules2, filter, i, YES, NO))
						exit(1);
					if (process(".op2", ".op3", c_copt_exe, c_coptrules1, filter, i, YES, NO))
						exit(1);
					if (process(".op3", before_cpuext, c_copt_exe, c_coptrules3, filter, i, YES, NO))
						exit(1);
					if ( c_coptrules_cpu && process(before_cpuext, ".asm", c_copt_exe, c_coptrules_cpu, filter, i, YES, NO))
						exit(1);
					break;
				}
			}
			// continue processing if this is not a .s file
			if ((compiler_type != CC_SDCC) || (peepholeopt != 0))
				goto CASE_ASMFILE;
			// user wants to stop at the .s file if stopping at assembly translation
			if (assembleonly) continue;
		case SFILE:
			if (m4only || clangonly || llvmonly || preprocessonly) continue;
			if (process(".s", ".asm", c_copt_exe, c_sdccopt1, filter, i, YES, NO))
				exit(1);
		CASE_ASMFILE:
		case ASMFILE:
			if (m4only || clangonly || llvmonly || preprocessonly || assembleonly)
                continue;

            // See #16 on github.
            // z80asm is unable to output object files to an arbitrary destination directory.
            // We don't want to assemble files in their original source directory because that would
            // create a temporary object file there which may accidentally overwrite user files.
            
            // Instead the plan is to copy the asm file to the temp directory and add the original
            // source directory to the include search path
            
            BuildAsmLine(asmarg, sizeof(asmarg), " -s ");

            // Check if source .asm file is in the temp directory already (indicates this is an intermediate file)
            ptr = changesuffix(temporary_filenames[i], ".asm");
            if (strcmp(ptr, filelist[i]) == 0)
            {
                free(ptr);
                ptr = muststrdup(asmarg);
            }
            else
            {
                char *p, tmp[FILENAME_MAX*2 + 2];

                // copy .asm file to temp directory
                if (copy_file(filelist[i], "", ptr, "")) {
                    fprintf(stderr, "Couldn't write output file %s\n", ptr);
                    exit(1);
                }

                // determine path to original source directory
                p = last_path_char(filelist[i]);

                if (!is_path_absolute(filelist[i]))
                {
                    int len;
#ifdef WIN32
                    if (_getcwd(tmp, sizeof(tmp) - 1) == NULL)
                        *tmp = '\0';
#else
                    if (getcwd(tmp, sizeof(tmp) - 1) == NULL)
                        *tmp = '\0';
#endif
                    if (p)
                    {
                        len = strlen(tmp);
                        snprintf(tmp + len, sizeof(tmp) - len - 1, "/%.*s", (int)(p - filelist[i]), filelist[i]);
                    }

                    if (*tmp == '\0')
                        strcpy(tmp, ".");
                }
                else if (p)
                    snprintf(tmp, sizeof(tmp) - 1, "%.*s", (int)(p - filelist[i]), filelist[i]);
                else
                    strcpy(tmp, ".");

                // working file is now the .asm file in the temp directory
                free(filelist[i]);
                filelist[i] = ptr;

                // add original source directory to the include path
                ptr = mustmalloc((strlen(asmarg) + strlen(tmp) + 7) * sizeof(char));
                sprintf(ptr, "%s -I\"%s\" ", asmarg, tmp);
            }

            // insert module directive at front of .asm file see issue #46 on github
            // this is a bit of a hack - foo.asm is copied to foo.tmp and then foo.tmp is written back to foo.asm with module header

            {
                char *p, *q, tmp[FILENAME_MAX + 10];

                p = changesuffix(temporary_filenames[i], ".tmp");

                if (copy_file(filelist[i], "", p, "")) {
                    fprintf(stderr, "Couldn't write output file %s\n", p);
                    exit(1);
                }

                if ((q = last_path_char(original_filenames[i])) != NULL )
                    q++;
                else
                    q = original_filenames[i];

                snprintf(tmp, sizeof(tmp) - 3, "MODULE %s", q);

                // be consistent with z80asm by not having the asm extension part of the module name
                if ((q = find_file_ext(tmp)) && (strcmp(q, ".asm") == 0))
                    *q = '\0';
                strcat(tmp, "\n\n");

                for (q = tmp+7; *q != '\n'; ++q)
                    if (!isalnum(*q)) *q = '_';

                if (prepend_file(p, "", filelist[i], "", tmp)) {
                    fprintf(stderr, "Couldn't append output file %s\n", p);
                    exit(1);
                }

                free(p);
            }

            // must be late assembly for the first file when making a binary
            if ((i == 0) && build_bin)
            {
                c_crt_incpath = ptr;
                if (verbose) printf("WILL ACT AS CRT\n");
                continue;
            }

			if (process(".asm", c_extension, c_assembler, ptr, assembler_style, i, YES, NO))
				exit(1);
            free(ptr);
			break;
		case OBJFILE:
			break;
		default:
			if (strcmp(filelist[i], original_filenames[i]) == 0)
				fprintf(stderr, "Filetype of %s unrecognized\n", filelist[i]);
			else
				fprintf(stderr, "Filetype of %s (%s) unrecognized\n", filelist[i], original_filenames[i]);
			exit(1);
		}
	}

	if (verbose) printf("\nGENERATING OUTPUT\n");

	if (m4only) exit(0);

	if (clangonly) {
		if (nfiles > 1) outputfile = NULL;
		copy_output_files_to_destdir(".ll", 1);
		exit(0);
	}

	if (llvmonly) exit(0);

	if (preprocessonly) {
		if (nfiles > 1) outputfile = NULL;
		copy_output_files_to_destdir(".i", 1);
		exit(0);
	}

	if (assembleonly) {
		if (nfiles > 1) outputfile = NULL;
		copy_output_files_to_destdir(".asm", 1);
		copy_output_files_to_destdir(".s", 1);
		exit(0);
	}

	{
		char *tempofile = outputfile;
		outputfile = NULL;
		if (lston) copy_output_files_to_destdir(".lis", 1);
		if (symbolson) copy_output_files_to_destdir(".sym", 1);
		outputfile = tempofile;
	}

	if (compileonly) {
		if ((nfiles > 1) && (outputfile != NULL)) {
			/* consolidated object file */
			outputfile = changesuffix(outputfile, ".o");
			if (linkthem(c_linker))
				exit(1);
		}
		else
		{
			/* independent object files */
			copy_output_files_to_destdir(c_extension, 1);
		}
		exit(0);
	}

	/* Set the default name as necessary */
	if (outputfile == NULL)
		outputfile = c_linker_output_file ? c_linker_output_file : defaultout;

	if (linkthem(c_linker))
		exit(1);

	if (build_bin) {

		if (createapp) {
			/* Building an application - run the appmake command on it */
			snprintf(buffer, sizeof(buffer), "%s %s -b \"%s\" -c \"%s\"", c_appmake_exe, appmakeargs ? appmakeargs : "", outputfile, c_crt0);
			if (verbose)
				printf("%s\n", buffer);
			if (system(buffer)) {
				fprintf(stderr, "Building application code failed\n");
				exit(1);
			}
		}

		{
			char *oldptr;
			int status = 0;

			strcpy(filenamebuf, outputfile);
			if ((oldptr = find_file_ext(filenamebuf)) != NULL )
				*oldptr = 0;

			if (mapon && copy_file(c_crt0, ".map", filenamebuf, ".map")) {
				fprintf(stderr, "Cannot copy map file\n");
				status = 1;
			}

			if (symbolson && copy_file(c_crt0, ".sym", filenamebuf, ".sym")) {
				fprintf(stderr, "Cannot copy symbols file\n");
				status = 1;
			}

			if (globaldefon && copy_defc_file(c_crt0, ".def", filenamebuf, ".def")) {
				fprintf(stderr, "Cannot create global defc file\n");
				status = 1;
			}

			if (lston && copy_file(c_crt0, ".lis", filenamebuf, ".lis")) {
				fprintf(stderr, "Cannot copy crt0 list file\n");
				status = 1;
			}

			if (status) exit(status);
		}
	}

	exit(0);
}


/* Filter global defc file as it is written to the destination directory.
 * 
 * (globaldefon     &   0x2) = make symbols PUBLIC
 * (globaldefrefile != NULL) = file holding one regular expression per line with
 *                             leading +- indicating acceptance or rejection for matches
*/

typedef struct gfilter_s {
    int      accept;
    regex_t  preg;
} GFILTER;

void gdf_cleanup(GFILTER *filter, int nfilter)
{
    while (nfilter > 1)
        regfree(&filter[--nfilter].preg);
    free(filter);
}

int copy_defc_file(char *name1, char *ext1, char *name2, char *ext2)
{
    FILE *in, *out, *rules;
    char buffer[LINEMAX + 1];
    char *line, *ptr;
    GFILTER *filter;
    regmatch_t pmatch[3];
    int nfilter, errcode, lineno;
    unsigned int len;

    // the first regular expression is used to parse a z80asm generated defc line
    filter  = mustmalloc(sizeof(*filter));
    nfilter = 1;
    if (regcomp(&filter->preg, "(defc|DEFC)[\t ]+([^\t =]+)", REG_EXTENDED))
    {
        fprintf(stderr, "Cannot create regular expressions\n");
        return 1;
    }

    // read the filters from the regular expression file
    if (globaldefrefile)
    {
        if ((rules = fopen(globaldefrefile, "r")) == NULL)
        {
            fprintf(stderr, "Cannot open rules file %s\n", globaldefrefile);
            gdf_cleanup(filter, nfilter);
            return 1;
        }

        line = NULL;
        for (lineno = 1; zcc_getdelim(&line, &len, '\n', rules) > 0; ++lineno)
        {
            ptr = strstrip(line);
            if ((*ptr == 0) || (*ptr == ';')) continue;
            if ((filter = realloc(filter, (nfilter + 1) * sizeof(*filter))) == NULL)
            {
                fprintf(stderr, "Cannot realloc global defc filter\n");
                gdf_cleanup(filter, nfilter);
                free(line);
                fclose(rules);
                return 1;
            }
            filter[nfilter].accept = !(*ptr == '-');
            if ((*ptr == '+') || (*ptr == '-')) ++ptr;
            while (isspace(*ptr)) ++ptr;
            if ( (errcode = regcomp(&filter[nfilter].preg, ptr, REG_EXTENDED)) )
            {
                regerror(errcode, &filter[nfilter].preg, buffer, sizeof(buffer));
                fprintf(stderr, "Ignoring %s line %u: %s", globaldefrefile, lineno, buffer);
                regfree(&filter[nfilter].preg);
                continue;
            }
            ++nfilter;
        }
        free(line);
        fclose(rules);
    }

    // open the defc file generated by z80asm
    buffer[sizeof(LINEMAX)] = 0;
    snprintf(buffer, sizeof(buffer) - 1, "%s%s", name1, ext1);
    if ((in = fopen(buffer, "r")) == NULL)
    {
        gdf_cleanup(filter, nfilter);
        return 1;
    }

    // create the output defc file
    snprintf(buffer, sizeof(buffer) - 1, "%s%s", name2, ext2);
    if ((out = fopen(buffer, "w")) == NULL)
    {
        gdf_cleanup(filter, nfilter);
        fclose(in);
        return 1;
    }

    line = NULL;
    while(zcc_getdelim(&line, &len, '\n', in) > 0)
    {
        // determine symbol name
        if (regexec(&filter->preg, line, sizeof(pmatch)/sizeof(pmatch[0]), pmatch, 0) != 0)
        {
            fprintf(stderr, "Cannot find symbol name in:\n%s", line);
            gdf_cleanup(filter, nfilter);
            free(line);
            fclose(in);
            fclose(out);
            return 1;
        }
        snprintf(buffer, sizeof(buffer) - 1, "%.*s",(int)(pmatch[2].rm_eo - pmatch[2].rm_so), &line[pmatch[2].rm_so]);

        // accept or reject
        if (globaldefrefile)
        {
            for (lineno = 1; lineno < nfilter; ++lineno)
            {
                if (regexec(&filter[lineno].preg, buffer, 0, NULL, 0) == 0)
                {
                    // symbol name matches rule
                    if (filter[lineno].accept)
                    {
                        if (globaldefon & 0x2)
                            fprintf(out, "\nPUBLIC %s\n", buffer);
                        fprintf(out, "%s", line);
                    }
                    break;
                }
            }
        }
        else
        {
            if (globaldefon & 0x2)
                fprintf(out, "\nPUBLIC %s\n", buffer);
            fprintf(out, "%s", line);
        }
    }

    gdf_cleanup(filter, nfilter);
    free(line);

    fclose(in);
    fclose(out);

    return 0;
}


int copyprepend_file(char *name1, char *ext1, char *name2, char *ext2, char *prepend)
{
    FILE           *out;
	char            buffer[LINEMAX + 1];
	char           *cmd;
	int             ret;

    if (prepend == NULL) prepend = "";

    buffer[sizeof(LINEMAX)] = 0;
    snprintf(buffer, sizeof(buffer) - 1, "%s%s", name2, ext2);

    if ((out = fopen(buffer, "w")) == NULL)
        return 1;

    fprintf(out, "%s", prepend);
    fclose(out);

#ifdef WIN32
	snprintf(buffer, sizeof(buffer), "%s \"%s%s\" >> \"%s%s\"", c_copycmd, name1, ext1, name2, ext2);
#else
	snprintf(buffer, sizeof(buffer), "%s \"%s%s\" >> \"%s%s\"", c_copycmd, name1, ext1, name2, ext2);
#endif
#ifdef WIN32
	// Argh....annoying
	if ((strcmp(c_copycmd, "type") == 0) || (strcmp(c_copycmd, "copy") == 0)){
		cmd = replace_str(buffer, "/", "\\");
	}
	else {
		cmd = muststrdup(buffer);
	}
#else
	cmd = muststrdup(buffer);
#endif
	if (verbose)
		printf("%s\n", buffer);
	ret = (system(cmd));
	free(cmd);
	return ret;
}

int copy_file(char *name1, char *ext1, char *name2, char *ext2)
{
    return copyprepend_file(name1, ext1, name2, ext2, NULL);
}

int prepend_file(char *name1, char *ext1, char *name2, char *ext2, char *prepend)
{
    return copyprepend_file(name1, ext1, name2, ext2, prepend);
}


int get_filetype_by_suffix(char *name)
{
	char      *ext = find_file_ext(name);

	if (ext == NULL) {
		return 0;
	}
	if (strcmp(ext, ".c") == 0)
		return CFILE;
	if (strcmp(ext, ".i") == 0)
		return CPPFILE;
	if (strcmp(ext, ".opt") == 0)
		return OPTFILE;
	if (strcmp(ext, ".s") == 0)
		return SFILE;
	if (strcmp(ext, ".asm") == 0)
		return ASMFILE;
	if (strcmp(ext, ".o") == 0)
		return OBJFILE;
	if (strcmp(ext, ".m4") == 0)
		return M4FILE;
	if (strcmp(ext, ".h") == 0)
		return HDRFILE;
	if (strcmp(ext, ".inc") == 0)
		return INCFILE;
	if (strcmp(ext, ".ll") == 0)
		return LLFILE;
	return 0;
}


int add_variant_args(char *wanted, int num_choices, char **choices)
{
	int  i;

	if (wanted != NULL) {
		size_t len = strlen(wanted);
		for (i = 0; i < num_choices; i++) {
			if (strncmp(wanted, choices[i], len) == 0 && isspace(choices[i][len])) {
				parse_option(muststrdup(choices[i] + len));
				break;
			}
		}
		if (i == num_choices) {
			return -1;
		}
	}
	return 0;
}


void BuildAsmLine(char *dest, size_t destlen, char *prefix)
{
	size_t offs;
	offs = snprintf(dest, destlen, "%s", asmargs ? asmargs : " ");

	if (IS_ASM(ASM_Z80ASM)) {
		offs += snprintf(dest + offs, destlen - offs, "%s%s%s%s",
			prefix,
			z80verbose ? " -v " : " ",
            mz180 ? " --cpu=z180 " : " ",
			symbolson ? " -s " : " ");
	}

	snprintf(dest + offs, destlen - offs, "%s", c_asmopts);
}



void SetBoolean(arg_t *arg, char *val)
{
	if ((arg->flags & AF_BOOL_TRUE)) {
		*(int *)arg->data = YES;
	}
	else {
		*(int *)arg->data = NO;
	}
}


void SetString(arg_t *argument, char *arg)
{
	char  *ptr = arg + 1;

	if (strncmp(ptr, argument->name, strlen(argument->name)) == 0) {
		ptr += strlen(argument->name);
	}
	if (*ptr == '=') {
		ptr++;
	}

	if (strlen(ptr)) {
		*(char **)argument->data = muststrdup(ptr);
	}
	else {
		/* Try the next argument up */
		if ((gargc + 1) < max_argc && gargv[gargc + 1][0] != '-') {
			/* Aha...non option comes next... */
			gargc++;
			*(char **)argument->data = muststrdup(gargv[gargc]);
		}
		else {
			// No option given..
		}
	}
}

void GlobalDefc(arg_t *argument, char *arg)
{
    char *ptr = arg + 1;

    if (*ptr++ == 'g')
    {
        // global defc is on
        *argument->num_ptr = 0x1;

        if (*ptr == 'p')
        {
            // make defc symbols public
            *argument->num_ptr |= 0x2;
            ++ptr;
        }

        if (*ptr == 'f')
        {
            // filename containing regular expressions
            if (*++ptr == '=') ++ptr;
            while (isspace(*ptr)) ++ptr;

            if (*ptr != 0)
                *(char **)argument->data = muststrdup(ptr);
            else
            {
                // try following argument for filename
                if ((gargc + 1) < max_argc && gargv[gargc + 1][0] != '-')
                {
                    /* Aha...non option comes next... */
                    gargc++;
                    *(char **)argument->data = muststrdup(gargv[gargc]);
                }
                else {
                    // No option given..
                }
            }
        }
    }
}


static char *expand_macros(char *arg)
{
	char  *ptr, *nval;
	char  *rep, *start;
	char  *value = muststrdup(arg);
	char   varname[300];


	start = value;
	while ((ptr = strchr(start, '$')) != NULL) {
		if (*(ptr + 1) == '{') {
			char  *end = strchr(ptr + 1, '}');

			if (end != NULL) {
				snprintf(varname, sizeof(varname), "%.*s", (int)(end - ptr - 2), ptr + 2);
				rep = getenv(varname);
				if (rep == NULL) {
					rep = "";
				}

				snprintf(varname, sizeof(varname), "%.*s", (int)(end - ptr + 1), ptr);
				nval = replace_str(value, varname, rep);
				free(value);
				value = nval;
				start = value + (ptr - start);
			}
		}
		else {
			start++;
		}
	}

	nval = replace_str(value, "DESTDIR", c_install_dir);
	free(value);
	return nval;
}

void SetStringConfig(arg_t *argument, char *arg)
{
	*(char **)argument->data = expand_macros(arg);
}

void SetNumber(arg_t *argument, char *arg)
{
	char *ptr = arg + 1;
	char *end;
	int   val;

	if (strncmp(ptr, argument->name, strlen(argument->name)) == 0) {
		ptr += strlen(argument->name);
	}

	while (ispunct(*ptr)) ++ptr;
	val = (int)strtol(ptr, &end, 0);

	if (end != ptr) {
		*(int *)argument->data = val;
	}
}

void AddArray(arg_t *argument, char *arg)
{
	int   i = *argument->num_ptr;
	char **arr = *(char ***)argument->data;
	*argument->num_ptr = *argument->num_ptr + 1;
	arr = realloc(arr, *argument->num_ptr * sizeof(char *));
    arr[i] = expand_macros(arg);
    *(char ***)argument->data = arr;
}



void AddAppmake(arg_t *argument, char *arg)
{
    BuildOptions(&appmakeargs, arg);
}


void AddToArgs(arg_t *argument, char *arg)
{
    BuildOptions(argument->data, arg + 3);
}

void AddToArgsQuoted(arg_t *argument, char *arg)
{
    BuildOptionsQuoted(argument->data, arg + 3);
}

void AddPreProcIncPath(arg_t *argument, char *arg)
{
    /* user-supplied inc path takes precedence over system-supplied inc path */
    if (processing_user_command_line_arg)
        BuildOptionsQuoted(&cpp_incpath_first, arg);
    else
        BuildOptionsQuoted(&cpp_incpath_last, arg);
}

void AddPreProc(arg_t *argument, char *arg)
{
    BuildOptions(&cpparg, arg);
    BuildOptions(&clangarg, arg);
}


void AddLinkLibrary(arg_t *argument, char *arg)
{
    /* user-supplied lib takes precedence over system-supplied lib */
    if (processing_user_command_line_arg)
        BuildOptionsQuoted(&linker_linklib_first, arg);
    else
        BuildOptionsQuoted(&linker_linklib_last, arg);
}

void AddLinkSearchPath(arg_t *argument, char *arg)
{
    /* user-supplied lib path takes precedence over system-supplied lib path */
    if (processing_user_command_line_arg)
        BuildOptionsQuoted(&linker_libpath_first, arg);
    else
        BuildOptionsQuoted(&linker_libpath_last, arg);
}


/** \brief Append arg to *list
*/
void BuildOptions(char **list, char *arg)
{
    char           *val;
    char           *orig = *list;

    zcc_asprintf(&val, "%s%s ", orig ? orig : "", arg);

    free(orig);
    *list = val;
}

void BuildOptions_start(char **list, char *arg)
{
    char           *val;
    char           *orig = *list;

    zcc_asprintf(&val, "%s %s", arg, orig ? orig : "");

    free(orig);
    *list = val;
}

void BuildOptionsQuoted(char **list, char *arg)
{
    char           *val;
    char           *orig = *list;

    if (((strncmp(arg, "-I", 2) == 0) || (strncmp(arg, "-L", 2) == 0)) && (strchr(arg, '"') == NULL) && (strchr(arg, '\'') == NULL))
    {
        zcc_asprintf(&val, "%s%.2s\"%s\" ", orig ? orig : "", arg, arg+2);

        free(orig);
        *list = val;
    }
    else
        BuildOptions(list, arg);
}


void add_option_to_compiler(char *arg)
{
    BuildOptions(&comparg, arg);
}


char *find_file_ext(char *filename)
{
    char *p;

    if ((p = last_path_char(filename)) == NULL)
        p = filename;
    return strrchr(p, '.');
}

char *last_path_char(char *filename)
{
    char *p, *q;

    // return pointer to last slash character in filename
    // return NULL if no slash character found

    p = strrchr(filename, '/');
    q = strrchr(filename, '\\');
    if ((p == NULL) || ((q != NULL) && ((q - filename) > (p - filename))))
        p = q;

    return p;
}

int is_path_absolute(char *p)
{
    while (*p && isspace(*p))
        ++p;

#ifdef WIN32
    return ((*p == '/') || (*p == '\\') || (isalpha(*p) && (*(p + 1) == ':')));
#else
    return (*p == '/') || (*p == '\\');
#endif
}

void gather_from_list_file(char *filename)
{
	FILE *in;
    char *line, *p;
	unsigned int len;
	char pathname[FILENAME_MAX + 1];
	char outname[FILENAME_MAX * 2 + 2];

	// reject non-filenames
	if (((filename = strtok(filename, " \r\n\t")) == NULL) || !(*filename))
		return;

	// open list file for reading
	if ((in = fopen(filename, "r")) == NULL) {
		fprintf(stderr, "Unable to open list file \"%s\"\n", filename);
		exit(1);
	}

	// extract path from filename
	p = last_path_char(filename);
	memset(pathname, 0, sizeof(pathname));
	if (p != NULL)
	    strncpy(pathname, filename, p - filename + 1);

	// read filenames from list file
	line = NULL;
	while (zcc_getdelim(&line, &len, '\n', in) > 0) {
		if (((p = strtok(line, " \r\n\t")) != NULL) && *p) {
			// clear output filename
			*outname = '\0';

			// prepend list file indicator if the filename is a list file
			if (*p == '@') {
				strcpy(outname, "@");
				if (((p = strtok(p + 1, " \r\n\t")) == NULL) || !(*p))
					continue;
			}

			// sanity check
			if (strlen(p) > FILENAME_MAX) {
				fprintf(stderr, "Filename is too long \"%s\"\n", p);
				exit(1);
			}

			// prepend path if filename is not absolute
			if (!lstcwd && !is_path_absolute(p))
				strcat(outname, pathname);

			// append rest of filename
			strcat(outname, p);

			// add file to process

			if (strlen(outname) >= FILENAME_MAX) {
				fprintf(stderr, "Filename is too long \"%s\"\n", outname);
				exit(1);
			}

			add_file_to_process(outname);
		}
	}

	if (!feof(in)) {
		fprintf(stderr, "Malformed line in list file \"%s\"\n", filename);
		exit(1);
	}

	free(line);
	fclose(in);
}

void add_file_to_process(char *filename)
{
	FILE *fclaim;
	char tname[FILENAME_MAX + 1];
	char *p;
	struct stat tmp;

	if (((p = strtok(filename, " \r\n\t")) != NULL) && *p)
    {
        p = strip_outer_quotes(p);

        if (*p == '@')
            gather_from_list_file(p + 1);
        else if (*p != ';')  /* ignore filename leading with semicolon; these indicate a comment in lst files */
        {
			/* Expand memory for filenames */
			if ((original_filenames = realloc(original_filenames, (nfiles + 1) * sizeof(char *))) == NULL) {
				fprintf(stderr, "Unable to realloc memory for input filenames\n");
				exit(1);
			}
			if ((filelist = realloc(filelist, (nfiles + 1) * sizeof(char *))) == NULL) {
				fprintf(stderr, "Unable to realloc memory for input filenames\n");
				exit(1);
			}
			if ((temporary_filenames = realloc(temporary_filenames, (nfiles + 1) * sizeof(char *))) == NULL) {
				fprintf(stderr, "Unable to realloc memory for input filenames\n");
				exit(1);
			}

			/* Add this file to the list of original files */
			if (find_file_ext(p) == NULL) {
				// file without extension - see if it exists, exclude directories
				if ((stat(p, &tmp) == 0) && (!(tmp.st_mode & S_IFDIR))) {
					fprintf(stderr, "Unrecognized file type %s\n", p);
					exit(1);
				}
				// input file has no extension and does not exist so assume .asm then .o then .asm.m4
				original_filenames[nfiles] = mustmalloc((strlen(p) + 8) * sizeof(char));
				strcpy(original_filenames[nfiles], p);
				strcat(original_filenames[nfiles], ".asm");
                if (stat(original_filenames[nfiles], &tmp) != 0)
                {
                    strcpy(strrchr(original_filenames[nfiles], '.'), ".o");
                    if (stat(original_filenames[nfiles], &tmp) != 0)
                        strcpy(strrchr(original_filenames[nfiles], '.'), ".asm.m4");
                }
			}
			else
				original_filenames[nfiles] = muststrdup(p);

			/* Working file is the original file */
			filelist[nfiles] = muststrdup(original_filenames[nfiles]);

			/* Now work out temporary filename */
			tempname(tname);
			temporary_filenames[nfiles] = muststrdup(tname);

			/* Claim the temporary filename */
			if ((fclaim = fopen(temporary_filenames[nfiles], "w")) == NULL) {
				fprintf(stderr, "Unable to claim temporary filename %s\n", temporary_filenames[nfiles]);
				exit(1);
			}
			fclose(fclaim);

			nfiles++;
		}
	}
}




void print_help_config(arg_t *arg, char *val)
{
	print_help_text();
}

void print_help_text()
{
	arg_t      *cur = &myargs[0];

	printf("zcc - Frontend for the z88dk Cross-C Compiler\n");
	printf("%s", version);
	printf("\nOptions:\n\n");

	while (cur->help) {
		printf("-%-20s %s%s\n", cur->name, cur->flags & AF_DEPRECATED ? "(deprecated) " : "", cur->help);
		cur++;
	}

	exit(0);
}



void parse_cmdline_arg(char *arg)
{
	arg_t          *pargs = myargs;

	while (pargs->setfunc) {
		if ((pargs->flags & AF_MORE)) {
			/* More info follows the option */
			if (strncmp(arg + 1, pargs->name, strlen(pargs->name)) == 0) {
				(*pargs->setfunc) (pargs, arg);
				return;
			}
		}
		else {
			if (strcmp(arg + 1, pargs->name) == 0) {
				(*pargs->setfunc) (pargs, arg);
				return;
			}
		}
		pargs++;
	}
	add_option_to_compiler(arg);
}

void parse_configfile_line(char *arg)
{
	arg_t          *pargs = config;

	while (pargs->setfunc) {
		if (strncmp(arg, pargs->name, strlen(pargs->name)) == 0) {
			char *val = arg + strlen(pargs->name);
			while (isspace(*val)) {
				val++;
			}
			KillEOL(val);
			(*pargs->setfunc) (pargs, val);
			return;
		}
		pargs++;
	}
	printf("Unrecognised config option: %s\n", arg);
	return;
}

static void configure_misc_options()
{
	char     buf[256];

	/* Setup the extension - config files just seem to specify -M, so fudge it */
	snprintf(buf, sizeof(buf), ".%s", c_extension_config && strlen(c_extension_config) ? c_extension_config : "o");
	c_extension = muststrdup(buf);

	// the new c lib uses startup=-1 to mean user supplies the crt
	// current working dir will be different than when using -crt0
	if (c_startup >= -1) {
        char tmp[64];
		write_zcc_defined("startup", c_startup, 0);
        snprintf(tmp, sizeof(tmp), "--define=__STARTUP=%d", c_startup);
        tmp[sizeof(tmp) - 1] = 0;
        BuildOptions(&m4arg, tmp);
	}

	if (linkargs == NULL) {
		linkargs = muststrdup("");
	}

	if (linklibs == NULL) {
		linklibs = muststrdup("");
	}
}

static void configure_maths_library(char **libstring)
{
	char   buf[1024];

	/* By convention, -lm refers to GENMATH, -lmz to Z88MATHLIB/ALTMATHLIB */

	if (c_altmathlib) {
		if (strstr(*libstring, "-lmz ") != NULL) {
			snprintf(buf, sizeof(buf), "-l\"%s\" ", c_altmathlib);
			if ((*libstring = replace_str(*libstring, "-lmz ", buf)) == NULL) {
				fprintf(stderr, "Malloc failed\n");
				exit(1);
			}
			parse_option(c_altmathflags);
		}
	}

	if (c_genmathlib) {
		if (strstr(*libstring, "-lm ") != NULL) {
			snprintf(buf, sizeof(buf), "-l\"%s\" ", c_genmathlib);
			if ((*libstring = replace_str(*libstring, "-lm ", buf)) == NULL) {
				fprintf(stderr, "Malloc failed\n");
				exit(1);
			}
		}
	}
}

static void configure_assembler()
{
	char           *assembler = NULL;
	char           *linker = NULL;
	int             type = ASM_Z80ASM;
	enum iostyle    style = outimplied;
	char           *name = c_assembler_type;

	if (strcasecmp(name, "z80asm") == 0) {
		type = ASM_Z80ASM;
		linker = c_z80asm_exe;
		assembler = c_z80asm_exe;
	}
	else if (strcasecmp(name, "mpm") == 0) {
		type = ASM_Z80ASM;
		linker = c_mpm_exe;
		assembler = c_mpm_exe;
	}
	else if (strcasecmp(name, "asxx") == 0) {
		type = ASM_ASXX;
		linker = c_aslink_exe;
		assembler = c_asz80_exe;
		c_asmopts = c_asz80opts;
		c_linkopts = c_aslinkopts;
	}
	else if (strcasecmp(name, "vasm") == 0) {
		type = ASM_VASM;
		linker = c_vlink_exe;
		assembler = c_vasm_exe;

		/* Switch config around */
		c_asmopts = c_vasmopts;
		c_linkopts = c_vlinkopts;

		style = outspecified_flag;
		linker_output_separate_arg = 1;
	}
	else if (strcasecmp(name, "binutils") == 0) {
		type = ASM_GNU;
		linker = c_gnuld_exe;
		assembler = c_gnuas_exe;

		c_asmopts = c_gnuasopts;
		c_linkopts = c_gnulinkopts;
		style = outspecified_flag;
		linker_output_separate_arg = 1;
	}
	assembler_type = type;
	assembler_style = style;
	if (assembler) {
		c_assembler = assembler;
	}
	if (linker) {
		c_linker = linker;
	}
}




static void configure_compiler()
{
	char *preprocarg;
	char  buf[256];

	compiler_type = CC_SCCZ80;

	/* compiler= */
	if ((strcmp(c_compiler_type, "clang") == 0) || (strcmp(c_compiler_type, "sdcc") == 0)) {
		compiler_type = CC_SDCC;
		snprintf(buf, sizeof(buf), "%s --no-optsdcc-in-asm --c1mode --emit-externs %s %s %s ", \
            (mz180 ? "-mz180 -portmode=z180" : ( mr2k ? "-mr2k" : "-mz80")), \
            (sdcc_signed_char ? "--fsigned-char" : ""), \
            (c_code_in_asm ? "" : "--no-c-code-in-asm"), \
            (opt_code_size ? "--opt-code-size" : ""));
		add_option_to_compiler(buf);
		if (sdccarg) {
			add_option_to_compiler(sdccarg);
		}
		preprocarg = " -DZ88DK_USES_SDCC=1";
		BuildOptions(&cpparg, preprocarg);
		//if ( assembler_type == ASM_Z80ASM ) {
		//    parse_cmdline_arg("-Ca-sdcc");
		//}
		c_compiler = c_sdcc_exe;
		c_cpp_exe = c_sdcc_preproc_exe;
		compiler_style = filter_outspecified_flag;
		write_zcc_defined("Z88DK_USES_SDCC", 1, 0);
	}
	else {
		preprocarg = " -DSCCZ80 -DSMALL_C";
		BuildOptions(&cpparg, preprocarg);
		/* Indicate to sccz80 what assembler we want */
		snprintf(buf, sizeof(buf), "-asm=%s -ext=opt %s", c_assembler_type,
		            (mz180 ? "-mz180" : ( mr2k ? "-mr2k" : "-mz80")));

		add_option_to_compiler(buf);
		if (sccz80arg) {
			add_option_to_compiler(sccz80arg);
		}
		if (c_code_in_asm) {
			add_option_to_compiler("-cc");
		}
		if (c_sccz80_r2l_calling) {
			add_option_to_compiler("-set-r2l-by-default");
			preprocarg = " -DZ88DK_R2L_CALLING_CONVENTION";
			BuildOptions(&cpparg, preprocarg);
		}
		c_compiler = c_sccz80_exe;
		compiler_style = outimplied;
	}
}


void PragmaInclude(arg_t *arg, char *val)
{
	char *ptr = strip_outer_quotes(val + strlen(arg->name) + 1);

	while (ispunct(*ptr)) ++ptr;

	if (*ptr != '\0') {
		free(pragincname);
		pragincname = muststrdup(ptr);
	}
}

void PragmaRedirect(arg_t *arg, char *val)
{
	char *eql;
	char *ptr = val + strlen(arg->name) + 1;
	char *value = "";

	while (ispunct(*ptr)) ++ptr;

	if ((eql = strchr(ptr, '=')) != NULL) {
		*eql = 0;
		value = eql + 1;
	}
	if (strlen(value)) {
		add_zccopt("\nIF !DEFINED_%s\n", ptr);
		add_zccopt("\tPUBLIC %s\n", ptr);
		add_zccopt("\tEXTERN %s\n", value);
		add_zccopt("\tdefc\tDEFINED_%s = 1\n", ptr);
		add_zccopt("\tdefc %s = %s\n", ptr, value);
		add_zccopt("ENDIF\n\n");
	}
}

void PragmaDefine(arg_t *arg, char *val)
{
	char *ptr = val + strlen(arg->name) + 1;
	int   value = 0;
	char *eql;

	while (ispunct(*ptr)) ++ptr;

	if ((eql = strchr(ptr, '=')) != NULL) {
		*eql = 0;
		value = (int)strtol(eql + 1, NULL, 0);
	}
	write_zcc_defined(ptr, value, 0);
}

void PragmaExport(arg_t *arg, char *val)
{
	char *ptr = val + strlen(arg->name) + 1;
	int   value = 0;
	char *eql;

	while (ispunct(*ptr)) ++ptr;

	if ((eql = strchr(ptr, '=')) != NULL) {
		*eql = 0;
		value = (int)strtol(eql + 1, NULL, 0);
	}
	write_zcc_defined(ptr, value, 1);
}

void write_zcc_defined(char *name, int value, int export)
{
	add_zccopt("\nIF !DEFINED_%s\n", name);
	add_zccopt("\tdefc\tDEFINED_%s = 1\n", name);
	if (export) add_zccopt("\tPUBLIC\t%s\n", name);
	add_zccopt("\tdefc %s = %d\n", name, value);
	add_zccopt("\tIFNDEF %s\n\tENDIF\n", name);
	add_zccopt("ENDIF\n\n");
}

void PragmaNeed(arg_t *arg, char *val)
{
	char *ptr = val + strlen(arg->name) + 1;

	while (ispunct(*ptr)) ++ptr;

	add_zccopt("\nIF !NEED_%s\n", ptr);
	add_zccopt("\tDEFINE\tNEED_%s\n", ptr);
	add_zccopt("ENDIF\n\n");
}


void PragmaBytes(arg_t *arg, char *val)
{
	char *ptr = val + strlen(arg->name) + 1;
	char *value;

	while (ispunct(*ptr)) ++ptr;

	if ((value = strchr(ptr, '=')) != NULL) {
		*value++ = 0;
	}
	else {
		return;
	}

	add_zccopt("\nIF NEED_%s\n", ptr);
	add_zccopt("\tDEFINED\tDEFINED_NEED_%s\n", ptr);
	add_zccopt("\tdefb\t%s\n", value);
	add_zccopt("ENDIF\n\n");
}

/** \brief Remove line feeds at the end of a line
*/
void KillEOL(char *str)
{
	char           *ptr;
	if ((ptr = strrchr(str, '\n')))
		*ptr = 0;
	if ((ptr = strrchr(str, '\r')))
		*ptr = 0;
}


/** \brief Copy any generated output files back to the directory they came from
*/
void copy_output_files_to_destdir(char *suffix, int die_on_fail)
{
	int             j;
	char           *ptr, *p, *name;
	struct stat     tmp;
	char            fname[FILENAME_MAX + 32];

	// copy each output file having indicated extension
	for (j = build_bin ? 1 : 0; j < nfiles; ++j) {

		// check that original file was actually processed
		if (((ptr = find_file_ext(original_filenames[j])) == NULL) || (strcmp(ptr, suffix) != 0)) {

			ptr = changesuffix(filelist[j], suffix);

			// check that this file was generated
			if (stat(ptr, &tmp) == 0) {

				// generate output filename
				if (outputfile != NULL)
					strcpy(fname, outputfile);                                  // use supplied output filename
				else {
					// using original filename to create output filename
					name = stripsuffix(original_filenames[j], ".m4");
					if (strcmp(suffix, c_extension) == 0) {
						p = changesuffix(name, suffix);                         // for .o, use original filename with extension changed to .o
						strcpy(fname, p);
						free(p);
					}
					else {
						p = stripsuffix(name, suffix);
						snprintf(fname, sizeof(fname), "%s%s", p, suffix);      // use original filename with extension appended
						free(p);
					}
					free(name);
				}

				// copy to output directory
				if (copy_file(ptr, "", fname, "")) {
					fprintf(stderr, "Couldn't copy output file %s\n", fname);
					if (die_on_fail) {
						free(ptr);
						exit(1);
					}
				}
			}

			free(ptr);
		}
	}
}


void remove_temporary_files(void)
{
	int             j;

	/* Show all error files */

	for (j = 0; j < nfiles; j++) {
		ShowErrors(filelist[j], original_filenames[j]);
	}

	if (cleanup) {    /* Default is yes */
		for (j = 0; j < nfiles; j++) {
			remove_file_with_extension(temporary_filenames[j], "");
			remove_file_with_extension(temporary_filenames[j], ".ll");
			remove_file_with_extension(temporary_filenames[j], ".i");
			remove_file_with_extension(temporary_filenames[j], ".i2");
			remove_file_with_extension(temporary_filenames[j], ".asm");
			remove_file_with_extension(temporary_filenames[j], ".err");
			remove_file_with_extension(temporary_filenames[j], ".op1");
			remove_file_with_extension(temporary_filenames[j], ".op2");
			remove_file_with_extension(temporary_filenames[j], ".op3");
			remove_file_with_extension(temporary_filenames[j], ".opc");
			remove_file_with_extension(temporary_filenames[j], ".opt");
			remove_file_with_extension(temporary_filenames[j], ".o");
            remove_file_with_extension(temporary_filenames[j], ".map");
			remove_file_with_extension(temporary_filenames[j], ".sym");
			remove_file_with_extension(temporary_filenames[j], ".def");
            remove_file_with_extension(temporary_filenames[j], ".tmp");
		}
	}
}


void remove_file_with_extension(char *file, char *ext)
{
	char           *temp;
	temp = changesuffix(file, ext);
	remove(temp);
	free(temp);
}


void
ShowErrors(char *filen, char *orig)
{
	char           *temp;
	char            buffer[LINEMAX + 1];
	char            buffer2[LINEMAX + 1];
	char            filenamebuf[LINEMAX + 1];
	int             j, linepos;
	FILE           *fp, *fp2;

	temp = changesuffix(filen, ".err");
	if ((fp = fopen(temp, "r")) != NULL) {
		if (orig)
			fprintf(stderr, "Errors in source file %s:\n", orig);
		else {
			/* We're printing linking errors, better print a key! */
			fprintf(stderr, "Key to filenames:\n");
			for (j = 0; j < nfiles; j++) {
				fprintf(stderr, "%s = %s\n", filelist[j], original_filenames[j]);
			}
		}

		while (fgets(buffer, LINEMAX, fp) != NULL) {
			fprintf(stderr, "%s", buffer);

			/* Dig into asm source file and show the corresponding line.. */
			if (strstr(buffer, " line ") >0) {    /* ..only if a line number is given */
				linepos = atoi(strstr(buffer, " line ") + strlen(" line "));
				strcpy(filenamebuf, strstr(buffer, "'") + strlen("'"));
				sprintf(strstr(filenamebuf, "'"), "");
				if ((linepos > 1) && ((fp2 = fopen(filenamebuf, "r")) != NULL)) {
					for (j = 1; j < linepos; j++)
						fgets(buffer2, LINEMAX, fp2);
					fprintf(stderr, "                   ^ ---- %s", fgets(buffer2, LINEMAX, fp2));
					fclose(fp2);
				}
			}

		}
		fclose(fp);

	}
	free(temp);        /* Free temp buffer */

}


/** \brief Get a temporary filename
*/
void tempname(char *filen)
{
#ifdef _WIN32

	char   *ptr;

	if ((ptr = _tempnam(".\\", tmpnambuf)) == NULL) {
		fprintf(stderr, "Failed to create temporary filename\n");
		exit(1);
	}
	strcpy(filen, ptr);
	free(ptr);

#elif defined(__MSDOS__) && defined(__TURBOC__)
	/* Both predefined by Borland's Turbo C/C++ and Borland C/C++ */

	if (ptr = getenv("TEMP")) {    /* From MS-DOS 5, C:\TEMP, C:\DOS,
								   * C:\WINDOWS\TEMP or whatever or
								   * nothing */
		strcpy(filen, ptr);    /* Directory is not guaranteed to
							   * exist */
		strcat(filen, "\\");
		tmpnam(filen + strlen(filen));    /* Adds strings like
										  * TMP1.$$$, TMP2.$$$ */
	}
	/* Allways starts at TMP1.$$$. Does not */
	else            /* check if file already exists. So is  */
		tmpnam(filen);    /* not suitable for executing zcc more  */
	if (ptr = find_file_ext(filen))    /* than once without cleaning out
									  * files. */
		*ptr = 0;    /* Don't want to risk too long filenames */
#else
	strcpy(filen, "/tmp/tmpXXXXXXXX");
	mktempfile(filen);
#endif
}

/*
*    Find a config file to use:
*
*    Scheme is as follows:
*    Use ZCCFILE for compatibility
*    If not, use ZCCCFG/zcc.cfg
*        or  ZCCCFG/argv[1]
*    Or as a first resort argv[1]
*    Returns gc (or exits)
*
*    If ZCCCFG doesn't exist then we take the c_install_dir/lib/config/zcc.cfg
*/
int find_zcc_config_fileFile(char *arg, int gc, char *buf, size_t buflen)
{
	FILE           *fp;
	char           *cfgfile;

	/* Scan for an option file on the command line */
	if (arg[0] == '+') {
		snprintf(buf, buflen, "%s", arg + 1);
		gc++;        /* Increment first arg to search from */
		if (strstr(arg, ".cfg") != NULL) {
			if ((fp = fopen(buf, "r")) != NULL) {
				/* Local config file */
				fclose(fp);
				return (gc);
			}
		}
		cfgfile = getenv("ZCCCFG");
		if (cfgfile != NULL) {
			if (strlen(cfgfile) > FILENAME_MAX) {
				fprintf(stderr, "Possibly corrupt env variable ZCCCFG\n");
				exit(1);
			}
			/* Config file in config directory */
			snprintf(buf, buflen, "%s/%s.cfg", cfgfile, arg + 1);
			return (gc);
		}
		else {
			snprintf(buf, buflen, "%s/lib/config/%s.cfg", c_install_dir, arg + 1);
		}
		/*
		* User supplied invalid config file, let it fall over back
		* when
		*/
		return (gc);
	}
	/* Okay, nowt specified so get the old style entry */
	cfgfile = getenv("ZCCFILE");
	if (cfgfile != NULL) {
		if (strlen(cfgfile) > FILENAME_MAX) {
			fprintf(stderr, "Possibly corrupt env variable ZCCFILE\n");
			exit(1);
		}
		snprintf(buf, buflen, "%s", cfgfile);
		return (gc);
	}
	/*
	* Last resort!
	* New style config take ZCCCFG/zcc.cfg
	*/
	cfgfile = getenv("ZCCCFG");
	if (cfgfile != NULL) {
		if (strlen(cfgfile) > FILENAME_MAX) {
			fprintf(stderr, "Possibly corrupt env variable ZCCCFG\n");
			exit(1);
		}
		snprintf(buf, buflen, "%s/zcc.cfg", cfgfile);
	}
	else {
		// Fall back to a sensible default
		snprintf(buf, buflen, "%slib/config/zcc.cfg", c_install_dir);
	}
	return (gc);
}


/* Parse options - rewritten to use qstrtok which is like strtok but understands quoting */
void parse_option(char *option)
{
	char           *ptr;

	if (option != NULL) {
		ptr = qstrtok(option, " \t\r\n");
		while (ptr != NULL) {
			if (ptr[0] == '-') {
				parse_cmdline_arg(strip_inner_quotes(ptr));
			}
			else {
				add_file_to_process(strip_outer_quotes(ptr));
			}
			ptr = qstrtok(NULL, " \t\r\n");
		}
	}
}


/* Check link arguments (-l) to -i for z80asm */
void linkargs_mangle(char *linkargs)
{
	char           *ptr = linkargs;

	if (IS_ASM(ASM_Z80ASM)) {
		if (strncmp(linkargs, "-l", 2) == 0) linkargs[1] = 'i';
		while ((ptr = strstr(linkargs, " -l")) != NULL) {
			ptr[2] = 'i';
		}
	}
}

void add_zccopt(char *fmt, ...)
{
	char   buf[4096];
	size_t len = zccopt ? strlen(zccopt) : 0;
	size_t extra;
	va_list ap;

	va_start(ap, fmt);
	extra = vsnprintf(buf, sizeof(buf), fmt, ap);
	va_end(ap);

	zccopt = realloc(zccopt, len + extra + 1);
	strcpy(zccopt + len, buf);
}

/* From: http://creativeandcritical.net/str-replace-c/ */
char *replace_str(const char *str, const char *old, const char *new)
{
	char *ret, *r;
	const char *p, *q;
	size_t oldlen = strlen(old);
	size_t count, retlen, newlen = strlen(new);

	if (oldlen != newlen) {
		for (count = 0, p = str; (q = strstr(p, old)) != NULL; p = q + oldlen)
			count++;
		/* this is undefined if p - str > PTRDIFF_MAX */
		retlen = p - str + strlen(p) + count * (newlen - oldlen);
	}
	else
		retlen = strlen(str);

	ret = mustmalloc(retlen + 1);

	for (r = ret, p = str; (q = strstr(p, old)) != NULL; p = q + oldlen) {
		/* this is undefined if q - p > PTRDIFF_MAX */
		ptrdiff_t l = q - p;
		memcpy(r, p, l);
		r += l;
		memcpy(r, new, newlen);
		r += newlen;
	}
	strcpy(r, p);

	return ret;
}

static void setup_default_configuration()
{
	char    buf[1024];
	arg_t  *pargs = config;

	while (pargs->setfunc) {
		if (pargs->defvalue) {
			snprintf(buf, sizeof(buf), "%s %s", pargs->name, pargs->defvalue);
			parse_configfile_line(buf);
		}
		pargs++;
	}
}

static void print_specs()
{
	arg_t  *pargs = config;
	int     i;

	while (pargs->setfunc) {
		if ((pargs->flags & AF_DEPRECATED) == 0 && pargs->setfunc == SetStringConfig) {
			if (*(char **)pargs->data != NULL && strlen(*(char **)pargs->data)) {
				printf("%-20s\t%s\n", pargs->name, *(char **)pargs->data);
			}
			else {
				printf("%-20s\t[undefined]\n", pargs->name);
			}
		}
		else if (pargs->setfunc == AddArray) {
			for (i = 0; i < *pargs->num_ptr; i++) {
				printf("%-20s\t%s\n", pargs->name, (*(char ***)pargs->data)[i]);
			}
		}
		pargs++;
	}
}


static int isquote(unsigned char c)
{
	return ((c == '"') || (c == '\''));
}


/* strtok with quoting */
static char *qstrtok(char *s, const char *delim)
{
	static char *start = NULL;
	char *ret;
	uint32_t quote_mask = 0;
	uint32_t quote_type = 0;
	int type = 0;

	// check for new string
	if (s != NULL)
	{
		// clear inquote indicators
		quote_mask = quote_type = 0;

		// skip initial delimiters
		for (start = s; *start; ++start)
			if ((strchr(delim, *start) == NULL) || isquote(*start))
				break;

		if (*start == '\0') start = NULL;
	}

	// check if current string is done
	if (start == NULL) return NULL;

	// look for next token in current string
	for (ret = start; *start; ++start)
	{
		if (quote_mask)
		{
			// inside quote, ignore delim
			if (isquote(*start))
			{
				type = (*start == '"');
				if (type == (quote_type & 0x01))
				{
					// undoing one level of quote
					quote_mask >>= 1;
					quote_type >>= 1;
				}
				else
				{
					// adding a level of quote
					if (quote_mask & 0x80000000UL)
					{
						fprintf(stderr, "Error: Reached maximum quoting level\n");
						exit(1);
					}

					quote_mask = (quote_mask << 1) + 1;
					quote_type = (quote_type << 1) + type;
				}
			}
		}
		else
		{
			// behave like strtok, delim takes precedence over quoting
			if (strchr(delim, *start))
				break;
			// check for quoting
			if (isquote(*start))
			{
				quote_mask = 1;
				quote_type = (*start == '"');
			}
		}
	}

	if (*start == '\0')
		start = NULL;
	else
		*start++ = '\0';
	return ret;
}


/* strip away first level of quotes inside string */
static char *strip_inner_quotes(char *p)
{
	char *first, *last, *temp;
	size_t len;

	len = strlen(p);

	first = strchr(p, '"');
	temp = strchr(p, '\'');

	if ((first == NULL) || ((temp != NULL) && (first > temp)))
		first = temp;

	last = strrchr(p, '"');
	temp = strrchr(p, '\'');

	if ((last == NULL) || ((temp != NULL) && (last < temp)))
		last = temp;

	if ((first != NULL) && (first != last) && (*first == *last))
	{
		memmove(first, first + 1, last - first - 1);
		memmove(last - 1, last, p + len - last - 1);
		p[len - 2] = '\0';
	}

	return p;
}


/* strip away outer quotes if string is quoted */
static char *strip_outer_quotes(char *p)
{
	size_t q = strlen(p);

	if (isquote(*p) && (p[0] == p[q - 1]))
	{
		p[q - 1] = '\0';
        p++;
	}

	return p;
}


static int zcc_vasprintf(char **s, const char *fmt, va_list ap)
{
	FILE       *fp;
	va_list     saveap;
	size_t      req;
	char       *ret;

	/* MSC Visual Studio 2010 does not have va_copy and va_list is a simple pointer */
#ifdef _MSC_VER
	saveap = ap;
#else
	va_copy(saveap, ap);
#endif

	/* This isn't performant, but we don't use it that much */
	if (
#ifndef WIN32
	(fp = fopen("/dev/null", "w")) != NULL
#else
		(fp = fopen("NUL", "w")) != NULL
#endif
		) {
		req = vfprintf(fp, fmt, ap);
		fclose(fp);
		ret = calloc(req + 1, sizeof(char));
		req = vsnprintf(ret, req + 1, fmt, saveap);
		*s = ret;
	}
	else {
		*s = NULL;
		req = -1;
	}
	return req;
}



static int zcc_asprintf(char **s, const char *fmt, ...)
{
	va_list arg;
	int     res;

	va_start(arg, fmt);
	res = zcc_vasprintf(s, fmt, arg);
	va_end(arg);
	return res;
}




/*
* zcc_getdelim()
* Copyright (C) 2003 ETC s.r.o.
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public License
* as published by the Free Software Foundation; either version 2
* of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program; if not, write to the Free Software
* Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
* 02111-1307, USA.
*
* Written by Marcel Telka <marcel@telka.sk>, 2003.
*
*/

#ifndef GETDELIM_BUFFER
#define GETDELIM_BUFFER 128
#endif

static int zcc_getdelim(char **lineptr, unsigned int *n, int delimiter, FILE *stream)
{

	char *p, *np;
	int c;
	unsigned int len = 0;

	if (!lineptr || !n)
		return -1;

	/* allocate initial buffer */
	if (!*lineptr || !*n) {
		np = realloc(*lineptr, GETDELIM_BUFFER);
		if (!np)
			return -1;
		*n = GETDELIM_BUFFER;
		*lineptr = np;
	}

	p = *lineptr;

	/* read characters from stream */
	while ((c = fgetc(stream)) != EOF) {
		if (len >= *n) {
			np = realloc(*lineptr, *n * 2);
			if (!np)
				return -1;
			p = np + (p - *lineptr);
			*lineptr = np;
			*n *= 2;
		}
		*p++ = (char)c;
		len++;
		if (delimiter == c)
			break;
	}

	/* end of file without any bytes read */
	if ((c == EOF) && (len == 0))
		return -1;

	/* trailing '\0' */
	if (len >= *n) {
		np = realloc(*lineptr, *n + 1);
		if (!np)
			return -1;
		p = np + (p - *lineptr);
		*lineptr = np;
		*n += 1;
	}
	*p = '\0';

	return len;
}



/*
* Local Variables:
*  indent-tabs-mode:nil
*  require-final-newline:t
*  c-basic-offset: 4
*  eval: (c-set-offset 'case-label 0)
*  eval: (c-set-offset 'substatement-open 0)
*  eval: (c-set-offset 'access-label 0)
*  eval: (c-set-offset 'class-open 4)
*  eval: (c-set-offset 'class-close 4)
* End:
*/
