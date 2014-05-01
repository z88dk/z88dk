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
 *      $Id: zcc.c,v 1.77 2014-05-01 21:57:49 pauloscustodio Exp $
 */


#include        <stdio.h>
#include        <string.h>
#include        <stdlib.h>
#include        <stdarg.h>
#include        <ctype.h>
#include        <stddef.h>
#include        "zcc.h"

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
static void            add_file_to_process(char *filename);

static void            SetNumber(arg_t *argument, char *arg);
static void            SetStringConfig(arg_t *argument, char *arg);
static void            parse_cmdline_arg(char *arg);
static void            SetBoolean(arg_t *arg, char *val);
static void            AddPreProc(arg_t *arg,char *);
static void            AddToArgs(arg_t *arg,char *);
static void            AddAppmake(arg_t *arg,char *);
static void            AddLinkLibrary(arg_t *arg,char *);
static void            AddLinkOption(arg_t *arg,char *);
static void            print_help_config(arg_t *arg,char *);
static void            print_help_text();
static void            SetString(arg_t *arg,char *);
static void            PragmaDefine(arg_t *arg,char *);
static void            PragmaNeed(arg_t *arg,char *);
static void            PragmaBytes(arg_t *arg,char *);
static void            AddArray(arg_t *arg,char *);
static void            write_zcc_defined(char *name, int value);


static void           *mustmalloc(size_t);
static int             hassuffix(char *file, char *suffix_to_check);
static char           *changesuffix(char *, char *);
static int             process(char *, char *, char *, char *, enum iostyle, int, int, int);
static int             linkthem(char *);
static int             get_filetype_by_suffix(char *);
static void            BuildAsmLine(char *, size_t, char *);
static void            parse_cmdline_arg(char *option);
static void            BuildOptions(char **, char *);
static void            BuildOptions_start(char **, char *);
static void            copy_output_files_to_destdir(char *suffix);
static void            parse_configfile_line(char *config_line);
static void            KillEOL(char *line);
static int             add_variant_args(char *wanted, int num_choices, char **choices);

static void            configure_assembler();
static void            configure_compiler();
static void            configure_misc_options();
static void            configure_maths_library();


static void            remove_temporary_files(void);
static void            remove_file_with_extension(char *file, char *suffix);
static void            copy_crt0_to_temp(void);
static void            ShowErrors(char *, char *);
static int             copy_file(char *src, char *src_extension, char *dest, char *dest_extension);
static void            tempname(char *);
static int             find_zcc_config_fileFile(char *arg, int argc, char *buf, size_t buflen);
static void            parse_option(char *option);
static void            linkargs_mangle(char *linkargs);
static void            add_zccopt(char *fmt,...);
static char           *replace_str(const char *str, const char *old, const char *new);
static void            setup_default_configuration();
static void            print_specs();
static int             zcc_asprintf(char **s, const char *fmt, ...);



static int             usetemp = 1;
static int             preserve = 0;    /* don't destroy zcc_opt */
static int             createapp = 0;    /* Go the next stage and create the app */
static int             makelib = 0;
static int             lateassemble = 0;
static int             makeapp = 0;
static int             z80verbose = 0;
static int             cleanup = 1;
static int             assembleonly = 0;
static int             compileonly = 0;
static int             verbose = 0;
static int             peepholeopt = 0;
static int             symbolson = 0;
static int             mapon = 0;
static int             preprocessonly = 0;
static int             relocate = 0;
static int             crtcopied = 0;    /* Copied the crt0 code over? */
static int             c_print_specs = 0;
static int             max_argc;
static int             gargc;
static char          **gargv;
/* filelist has to stay as ** because we change suffix all the time */
static int             nfiles = 0;
static char          **filelist;
static char          **original_filenames;    /* Original filenames... */
static char           *outputfile = NULL;
static char           *c_linker_output_file = NULL;
static char           *cpparg;
static char           *comparg;
static char           *linkargs;
static char           *asmargs;
static char           *appmakeargs;
static char           *zccopt = NULL;   /* Text to append to zcc_opt.def */
static char           *c_subtype = NULL;
static char           *c_clib = NULL;
static int             c_startup = -1;
static int             c_nostdlib = 0;


static char            filenamebuf[FILENAME_MAX + 1];


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
    void (*setfunc)(arg_t *arg, char *);
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
static char  *c_asz80_exe  = "asz80";
static char  *c_aslink_exe = "aslink";

static char  *c_sdcc_exe = "sdcc";
static char  *c_sccz80_exe = "sccz80";
static char  *c_cpp_exe = "zcpp";
static char  *c_zpragma_exe = "zpragma";
static char  *c_copt_exe = "copt";
static char  *c_appmake_exe = "appmake";
#ifndef WIN32
static char  *c_copycmd = "cp";
#else
static char  *c_copycmd = "copy";
#endif
static char  *c_extension_config = "o";
static char  *c_incpath = NULL;
static char  *c_coptrules1 = NULL;
static char  *c_coptrules2 = NULL;
static char  *c_coptrules3 = NULL;
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
static char  *c_linker = NULL;
static char  *c_compiler = NULL;
static char **c_subtype_array = NULL;
static int    c_subtype_array_num = 0;
static char **c_clib_array = NULL;
static int    c_clib_array_num = 0;

static arg_t  config[] = {    
    {"OPTIONS", 0, SetStringConfig, &c_options, NULL, "Extra options for port"},
    
    {"MPMEXE", 0, SetStringConfig, &c_mpm_exe, NULL,"Name of the mpm binary"},
    
    {"VASMEXE", 0, SetStringConfig, &c_vasm_exe, NULL, "Name of the vasm binary" },
    {"VLINKEXE", 0, SetStringConfig, &c_vlink_exe, NULL, "Name of the vlink binary" },
    {"VASMOPTS", 0, SetStringConfig, &c_vasmopts, NULL, "Options for VASM", "-quiet -Fvobj -IDESTDIR/lib" },
    {"VLINKOPTS", 0, SetStringConfig, &c_vlinkopts, NULL, "", "-LDESTDIR/lib/vlink/" },
    
    {"GNUASEXE", 0, SetStringConfig, &c_gnuas_exe, NULL, "Name of the GNU as binary" },
    {"GNULDEXE", 0, SetStringConfig, &c_gnuld_exe, NULL, "Name of the GNU ld binary" },
    {"GNUASOPTS", 0, SetStringConfig, &c_gnuasopts, NULL, ""},
    {"GNULINKOPTS", 0, SetStringConfig, &c_gnulinkopts, NULL, ""},
    
    {"ASZ80EXE", 0, SetStringConfig, &c_asz80_exe, NULL, "Name of the asz80 binary" },
    {"ASLINKEXE", 0, SetStringConfig, &c_aslink_exe, NULL, "Name of the aslink binary" },
    {"ASZ80OPTS", 0, SetStringConfig, &c_asz80opts, NULL, ""},
    {"ASLINKOPTS", 0, SetStringConfig, &c_aslinkopts, NULL, ""},
    
    {"CPP", 0, SetStringConfig, &c_cpp_exe, NULL, "Name of the cpp binary" },
    {"STYLECPP", 0, SetNumber, &c_stylecpp, NULL, ""},
    {"ZPRAGMAEXE", 0, SetStringConfig, &c_zpragma_exe, NULL, "Name of the zpragma binary"},

    {"Z80EXE", 0, SetStringConfig, &c_z80asm_exe, NULL, "Name of the z80asm binary"},
    {"LINKOPTS", 0, SetStringConfig, &c_linkopts, NULL, "Options for z80asm as linker", "-a -m -Mo -LDESTDIR/lib/clibs -IDESTDIR/lib" },
    {"ASMOPTS", 0, SetStringConfig, &c_asmopts, NULL, "Options for z80asm as assembler", "-Mo -IDESTDIR/lib"},
    
    {"COMPILER", AF_DEPRECATED, SetStringConfig, &c_compiler, NULL, "Name of sccz80 binary (use SCCZ80EXE)"},
    {"SCCZ80EXE", 0, SetStringConfig, &c_sccz80_exe, NULL, "Name of sccz80 binary"},
    {"SDCCEXE", 0, SetStringConfig, &c_sdcc_exe, NULL, "Name of the sdcc binary"},
    
    {"APPMAKEEXE", 0, SetStringConfig, &c_appmake_exe, NULL, ""},
    {"APPMAKER", AF_DEPRECATED, SetStringConfig, &c_appmake_exe, NULL, "Name of the applink binary (use APPMAKEEXE)"},

    
    {"COPTEXE", 0, SetStringConfig, &c_copt_exe, NULL, ""},
    {"COPYCMD", 0, SetStringConfig, &c_copycmd, NULL, ""},
    
    {"INCPATH", 0, SetStringConfig, &c_incpath, NULL, "", "-IDESTDIR/include" },
    {"COPTRULES1", 0, SetStringConfig, &c_coptrules1, NULL, "", "DESTDIR/lib/z80rules.1" },
    {"COPTRULES2", 0, SetStringConfig, &c_coptrules2, NULL, "", "DESTDIR/lib/z80rules.2"},
    {"COPTRULES3", 0, SetStringConfig, &c_coptrules3, NULL, "", "DESTDIR/lib/z80rules.0"},
    {"CRT0", 0, SetStringConfig, &c_crt0, NULL, ""},

    {"ALTMATHLIB", 0, SetStringConfig, &c_altmathlib, NULL, "Name of the alt maths library"},
    {"ALTMATHFLG", 0, SetStringConfig, &c_altmathflags, NULL, "Additional options for non-generic maths"},
    {"Z88MATHLIB", AF_DEPRECATED, SetStringConfig, &c_altmathlib, NULL, "Name of the alt maths library (use ALTMATHLIB)"},
    {"Z88MATHFLG", AF_DEPRECATED, SetStringConfig, &c_altmathflags, NULL, "Additional options for non-generic maths (use ALTMATHFLG)"},
    {"STARTUPLIB", 0, SetStringConfig, &c_startuplib, NULL, ""},
    {"GENMATHLIB", 0, SetStringConfig, &c_genmathlib, NULL, ""},
    {"SUBTYPE",  0, AddArray, &c_subtype_array, &c_subtype_array_num, "Add a sub-type alias and config" },
    {"CLIB",  0, AddArray, &c_clib_array, &c_clib_array_num, "Add a clib variant config" },
    {"", 0, NULL, NULL}
};







static arg_t     myargs[] = {
    {"z80-verb", AF_BOOL_TRUE, SetBoolean, &z80verbose, NULL, "Make the assembler more verbose"},
    {"cleanup",  AF_BOOL_TRUE, SetBoolean, &cleanup, NULL,    "(default) Cleanup temporary files"},
    {"no-cleanup", AF_BOOL_FALSE, SetBoolean, &cleanup, NULL, "Don't cleanup temporary files"},
    {"make-lib", AF_BOOL_TRUE, SetBoolean, &makelib, NULL, "Compile as if to make a library"},
    {"preserve", AF_BOOL_TRUE, SetBoolean, &preserve, NULL, "Don't remove zcc_opt.def at start of run"},
    {"make-app", AF_BOOL_TRUE, SetBoolean, &makeapp, NULL, "Create binary suitable for generated application"},
    {"create-app", AF_BOOL_TRUE, SetBoolean, &createapp, NULL, "Run appmake on the resulting binary to create emulator usable file"},
    {"usetemp", AF_BOOL_TRUE, SetBoolean, &usetemp, NULL, "(default) Use the temporary directory for intermediate files"},
    {"notemp", AF_BOOL_FALSE, SetBoolean, &usetemp, NULL, "Don't use the temporary directory for intermediate files"},
    {"specs", AF_BOOL_TRUE, SetBoolean, &c_print_specs, NULL, "Print out compiler specs" },
    {"asm", AF_MORE, SetString, &c_assembler_type, NULL, "Set the assembler type from the command line (z80asm, mpm, asxx, vasm, binutils)"},
    {"compiler", AF_MORE, SetString, &c_compiler_type, NULL, "Set the compiler type from the command line (sccz80, sdcc)"},
    {"crt0", AF_MORE, SetString, &c_crt0, NULL, "Override the crt0 assembler file to use" },
    {"pragma-define",AF_MORE,PragmaDefine,NULL, NULL, "Define the option in zcc_opt.def" },
    {"pragma-need",AF_MORE,PragmaNeed,NULL, NULL, "NEED the option in zcc_opt.def" },
    {"pragma-bytes",AF_MORE,PragmaBytes,NULL, NULL, "Dump a string of bytes zcc_opt.def" },
    {"subtype", AF_MORE, SetString, &c_subtype, NULL, "Set the target subtype" }, 
    {"clib", AF_MORE, SetString, &c_clib, NULL, "Set the target clib type" }, 
    {"startup", AF_MORE, SetNumber, &c_startup, NULL, "Set the startup type" },
    {"nostdlib", AF_BOOL_TRUE, SetBoolean, &c_nostdlib, NULL, "If set ignore INCPATH, STARTUPLIB" },
    {"Cp", AF_MORE, AddToArgs, &cpparg, NULL, "Add an option to the preprocessor"},
    {"Ca", AF_MORE, AddToArgs, &asmargs, NULL, "Add an option to the assembler"},
    {"Cl", AF_MORE, AddToArgs, &linkargs, NULL, "Add an option to the linker"},
    {"Cz", AF_MORE, AddToArgs, &appmakeargs, NULL, "Add an option to appmake"},
    {"E", AF_BOOL_TRUE, SetBoolean, &preprocessonly, NULL, "Only preprocess files"},
    {"R", AF_BOOL_TRUE, SetBoolean, &relocate, NULL, "Generate relocatable code"},
    {"D", AF_MORE, AddPreProc, NULL, NULL, "Define a preprocessor option"},
    {"U", AF_MORE, AddPreProc, NULL, NULL, "Undefine a preprocessor option"},
    {"I", AF_MORE, AddPreProc, NULL, NULL, "Add an include directory for the preprocessor"},
    {"L", AF_MORE, AddLinkOption, NULL, NULL, "Add a library search path"},
    {"l", AF_MORE, AddLinkLibrary, NULL, NULL, "Add a library"},
    {"O", AF_MORE, SetNumber, &peepholeopt, NULL, "Set the peephole optimiser setting"},
    {"h", 0, print_help_config, NULL, NULL, "Display this text"},
    {"v", AF_BOOL_TRUE, SetBoolean, &verbose, NULL, "Output all commands that are run (-vn suppresses)"},
    {"bn", AF_MORE, SetString, &c_linker_output_file, NULL, "Set the output file for the linker stage"},
    {"vn", AF_BOOL_FALSE, SetBoolean, &verbose, NULL, "Run the compile stages silently" },
    {"c", AF_BOOL_TRUE, SetBoolean, &compileonly, NULL, "Only compile the .c files to .o files"},
    {"a", AF_BOOL_TRUE, SetBoolean, &assembleonly, NULL, "Only compile the .c files to .asm/.opt files"},
    {"m", AF_BOOL_TRUE, SetBoolean, &mapon, NULL, "Generate an output map of the final executable"},
    {"s", AF_BOOL_TRUE, SetBoolean, &symbolson, NULL, "Generate a symbol map of the final executable"},
    {"o", AF_MORE, SetString, &outputfile, NULL, "Set the output files"},
    {"nt", 0, AddAppmake, NULL, NULL, "Set notruncate on the appmake options"},
    {"M",  AF_MORE, SetString, &c_extension_config, NULL, "Define the suffix of the object files (eg -Mo)"},
    {"+", NO, AddPreProc, NULL, NULL, NULL},    /* Strips // comments in vcpp */
    {"", 0, NULL, NULL}
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

static int hassuffix(char *name, char *suffix)
{
    int             nlen, slen;

    nlen = strlen(name);
    slen = strlen(suffix);

    if (slen > nlen)
        return (0);
    return (strcmp(&name[nlen - slen], suffix) == 0);
}

static char *changesuffix(char *name, char *suffix)
{
    char           *p, *r;

    if ((p = strrchr(name, '.')) == 0) {
        r = mustmalloc(strlen(name) + strlen(suffix) + 1);
        sprintf(r, "%s%s", name, suffix);
    } else {
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
    switch (ios) {
    case outimplied:
        /* Dropping the suffix for Z80..cheating! */
        tstore = strlen(filelist[number]) - strlen(suffix);

        if (!needsuffix)
            filelist[number][tstore] = 0;

        snprintf(buffer, sizeof(buffer), "%s %s %s", processor, extraargs,
            filelist[number]);
        filelist[number][tstore] = '.';
        break;
    case outspecified:
        outname = changesuffix(filelist[number], nextsuffix);
        snprintf(buffer,sizeof(buffer), "%s %s %s %s", processor, extraargs,
            src_is_original ? original_filenames[number] : filelist[number], outname);
        free(outname);
        break;
    case outspecified_flag:
        outname = changesuffix(filelist[number], nextsuffix);
        snprintf(buffer,sizeof(buffer), "%s %s %s -o %s", processor, extraargs,
            src_is_original ? original_filenames[number] : filelist[number], outname);
        free(outname);
        break;
    case filter:
        outname = changesuffix(filelist[number], nextsuffix);
        snprintf(buffer,sizeof(buffer), "%s %s < %s > %s", processor, extraargs,
            src_is_original ? original_filenames[number] : filelist[number], outname);
        free(outname);
        break;
    case filter_outspecified_flag:
        outname = changesuffix(filelist[number], nextsuffix);
        snprintf(buffer,sizeof(buffer), "%s %s < %s -o %s", processor, extraargs,
            src_is_original ? original_filenames[number] : filelist[number], outname);
        free(outname);
        break;
    }
    if (verbose) {
        printf("%s\n",buffer);
    }
    status = system(buffer);
    if (status != 0)
        errs = 1;
    else {
        /* Free up the allocated memory */
        outname = changesuffix(filelist[number], nextsuffix);
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
    char           *ext;

    if (peepholeopt) {
        if (IS_ASM(ASM_Z80ASM)) {
            asmline = "-eopt ";
        }
        ext = ".opt";
    } else {
        if (IS_ASM(ASM_Z80ASM)) {
            asmline = "-easm ";
        }
        ext = ".asm";
    }

    linkargs_mangle(linkargs);
    len = offs = zcc_asprintf(&temp, "%s %s -o%s%s %s%s%s%s%s%s", 
            linker, 
            c_linkopts, 
            linker_output_separate_arg ? " " : "", 
            outputfile,
            lateassemble ? asmline : "",
            (z80verbose && IS_ASM(ASM_Z80ASM)) ? "-v " : "",
            (relocate && z80verbose && IS_ASM(ASM_Z80ASM)) ? "-R " : "",
            linkargs,
            c_crt0,
            ext);
            
    for ( i = 0; i < nfiles; i++ ) {
        len += strlen(filelist[i]) + 5;
    }
    len++;
    
    /* So the total length we need is now in len, let's malloc and do it */
    cmdline = calloc(len, sizeof(char));
    strcpy(cmdline, temp);
            
    for (i = 0; i < nfiles; ++i) {
        if ((!lateassemble && hassuffix(filelist[i], c_extension)) || lateassemble) {
            offs += snprintf(cmdline + offs, len - offs," %s", filelist[i]);
        }
    }
    if (verbose)
        printf("%s\n", cmdline);
    status = system(cmdline);
    free(cmdline);
    free(temp);
    return (status);
}

int main(int argc, char **argv)
{
    int             i, gc;
    char           *ptr;
    char            config_filename[FILENAME_MAX+1];
    char            asmarg[4096];    /* Hell, that should be long enough! */
    char            buffer[LINEMAX + 1];    /* For reading in option file */
    FILE           *fp;

    asmargs = linkargs = cpparg = NULL;

    atexit(remove_temporary_files);
    
    add_option_to_compiler("");

    /* allocate enough pointers for all files, slight overestimate */
    filelist = mustmalloc(sizeof(char *) * argc);
    original_filenames =  mustmalloc(sizeof(char *) * argc);


    gc = 1;            /* Set for the first argument to scan for */
    if (argc == 1) {
        print_help_text();
        exit(1);
    }
    
    /* Setup the install prefix based on ZCCCFG */
    if ( ( ptr = getenv("ZCCCFG") ) != NULL ) {
#ifdef WIN32
        snprintf(config_filename, sizeof(config_filename),"%s\\..\\..\\", ptr);
#else
        snprintf(config_filename, sizeof(config_filename),"%s/../../", ptr);
#endif
        c_install_dir = strdup(config_filename);
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
        parse_option(strdup(c_options));
    }
    
    
    /* Now, let's parse the command line arguments */
    max_argc = argc;
    gargv = argv;        /* Point argv to start of command line */

    for (gargc = gc; gargc < argc; gargc++) {
        if (argv[gargc][0] == '-')
            parse_cmdline_arg(argv[gargc]);
        else
            add_file_to_process(argv[gargc]);
    }

    if ( c_print_specs ) {
        print_specs();
        exit(0);
    }
    
    
    if ( add_variant_args(c_subtype, c_subtype_array_num, c_subtype_array) == -1 ) {
        fprintf(stderr,"Cannot find definition for target -subtype=%s\n",c_subtype);
        exit(1);
    }
    if ( add_variant_args(c_clib, c_clib_array_num, c_clib_array) == -1 ) {
        fprintf(stderr,"Cannot find definition for -clib=%s\n",c_clib);
        exit(1);
    }
    
    /* We must have at least a crt file - we can rely on defaults for everything else */
    if ( c_crt0 == NULL ) {
        fprintf(stderr, "No CRT0 defined in configuration file <%s>\n",config_filename);
        exit(1);
    }
    
    
    configure_assembler();
    configure_compiler();
    
    configure_misc_options();
    
    configure_maths_library();
    
    if ( c_nostdlib == 0 ) {
        /* Add the startup library to the linker arguments */
        if ( c_startuplib && strlen(c_startuplib) ) {
            snprintf(buffer, sizeof(buffer), "-l%s ", c_startuplib);
            BuildOptions(&linkargs, buffer);
            /* Add the default cpp path */
            BuildOptions(&cpparg, c_incpath);
        }
    }
    

    if (preserve == NO) {
        if ((fp = fopen(DEFFILE, "w")) != NULL) {
            fclose(fp);
            if (remove(DEFFILE) < 0) {
                fprintf(stderr, "Cannot remove %s: File in use?\n", DEFFILE);
                exit(1);
            }          
        } else {
            fprintf(stderr, "Cannot open %s: File in use?\n", DEFFILE);
            exit(1);
        }
    }


    if ((fp = fopen(DEFFILE, "a")) != NULL) {
        fprintf(fp,"%s", zccopt ? zccopt : "");
        fclose(fp);
    } else {
        fprintf(stderr, "Could not create %s: File in use?\n", DEFFILE);
        exit(1);
    }
    

    if (nfiles <= 0) {
        print_help_text();
        exit(0);
    }
    
   



    /* Copy crt0 to temporary directory */
    copy_crt0_to_temp();   

    /* Parse through the files, handling each one in turn */
    for (i = 0; i < nfiles; i++) {
        switch (get_filetype_by_suffix(filelist[i])) {
        case CFILE:
            if ( compiler_type == CC_SDCC) {
                if (process(".c", ".i2", c_cpp_exe, cpparg, c_stylecpp, i, YES, YES))
                    exit(1);
                if (process(".i2", ".i", c_zpragma_exe, "", filter, i, YES, NO))
                    exit(1);
            } else {
                if (process(".c", ".i", c_cpp_exe, cpparg, c_stylecpp, i, YES, YES))
                    exit(1);
            }
            if (preprocessonly) {
                if (usetemp)
                    copy_output_files_to_destdir(".i");
                exit(0);
            }
        case PFILE:
            if (process(".i", ".asm", c_compiler, comparg, compiler_style, i, YES, NO))
                exit(1);
        case AFILE:
            switch (peepholeopt) {
            case 1:
                if (process(".asm", ".opt", c_copt_exe, c_coptrules1, filter, i, YES, NO))
                    exit(1);
                break;
            case 2:
                /* Double optimization! */
                if (process(".asm", ".op1", c_copt_exe, c_coptrules2, filter, i, YES, NO))
                    exit(1);

                if (process(".op1", ".opt", c_copt_exe, c_coptrules1, filter, i, YES, NO))
                    exit(1);
                break;
            case 3:
                /*
                 * Triple opt (last level adds routines but
                 * can save space..)
                 */
                if (process(".asm", ".op1", c_copt_exe, c_coptrules2, filter, i, YES, NO))
                    exit(1);
                if (process(".op1", ".op2",  c_copt_exe, c_coptrules1, filter, i, YES, NO))
                    exit(1);
                if (process(".op2", ".opt",  c_copt_exe, c_coptrules3, filter, i, YES, NO))
                    exit(1);
                break;
            default:
                BuildAsmLine(asmarg, sizeof(asmarg), "-easm");
                if (!assembleonly && !lateassemble)
                    if (process(".asm", c_extension, c_assembler, asmarg, assembler_style, i, YES, NO))
                        exit(1);
            }
        case OFILE:
            BuildAsmLine(asmarg, sizeof(asmarg), "-eopt");
            if (!assembleonly && !lateassemble)
                if (process(".opt", c_extension, c_assembler, asmarg, assembler_style, i, YES, NO))
                    exit(1);
            break;
        }
    }
    
    if (compileonly || assembleonly) {
        if (compileonly && !assembleonly) {
            if (usetemp)
                copy_output_files_to_destdir(c_extension);
        } else {
            if (usetemp)
                copy_output_files_to_destdir(peepholeopt ? ".opt" : ".asm");
        }
        exit(0);
    }

    /* Set the default name as necessary */
    if ( outputfile == NULL ) {
        outputfile = c_linker_output_file ? c_linker_output_file : defaultout;
    }


    if (linkthem(c_linker)) {
        exit(1);
    }

    if (createapp) {
        /* Building an application - run the appmake command on it */
        snprintf(buffer, sizeof(buffer), "%s %s -b %s -c %s", c_appmake_exe, appmakeargs ? appmakeargs : "", outputfile, c_crt0);
        if (verbose)
            printf("%s\n", buffer);
        if (system(buffer)) {
            fprintf(stderr, "Building application code failed\n");
            exit(1);
        }
    }
    
    if (mapon && usetemp) {
        char           *oldptr;

        strcpy(filenamebuf, outputfile);
        if ((oldptr = strrchr(filenamebuf, '.')))
            *oldptr = 0;
        if (copy_file(c_crt0, ".map", filenamebuf, ".map")) {
            fprintf(stderr, "Cannot copy map file\n");
            exit(1);
        }
    }
    exit(0);
}

int copy_file(char *name1, char *ext1, char *name2, char *ext2)
{
    char            buffer[LINEMAX + 1];
    char           *cmd;
    int             ret;
    
    snprintf(buffer, sizeof(buffer), "%s %s%s %s%s",c_copycmd, name1, ext1, name2, ext2);
#ifdef WIN32
    /* Argh....annoying */
    if ( strcmp(c_copycmd,"copy") == 0 ) {
         cmd = replace_str(buffer, "/", "\\");
    } else {
        cmd = strdup(buffer);
    }
#else
    cmd = strdup(buffer);
#endif
    if (verbose)
        printf("%s\n", buffer);
    ret = (system(cmd));
    free(cmd);
    return ret;
}



int get_filetype_by_suffix(char *name)
{
    char      *ext = strrchr(name,'.');
    
    if ( ext == NULL ) {
        return 0;
    }
    if (strcmp(ext, ".c") == 0)
        return CFILE;
    if (strcmp(ext, ".i") == 0)
        return PFILE;
    if (strcmp(ext, ".asm") == 0)
        return AFILE;
    if (strcmp(ext, ".opt") == 0)
        return OFILE;
    return 0;
}


int add_variant_args(char *wanted, int num_choices, char **choices)
{
    int  i;

    if ( wanted != NULL ) {
        size_t len = strlen(wanted);
        for ( i = 0; i < num_choices ; i++ ) {
            if ( strncmp(wanted, choices[i], len) == 0 && isspace(choices[i][len]) ) {
                parse_option(strdup(choices[i] + len));
                break;
            }
        }
        if ( i == num_choices ) {
            return -1;
        }
    }
    return 0;
}
    

void BuildAsmLine(char *dest, size_t destlen, char *prefix)
{
    size_t offs = strlen(dest);
       
    offs = snprintf(dest, destlen, "%s", asmargs ? asmargs : "");
    
    if (IS_ASM(ASM_Z80ASM)) {
        offs += snprintf(dest + offs, destlen - offs,"%s%s%s",
                        prefix,
                        z80verbose ? " -v " : "",
                        !symbolson ? " -ns " : "");
    }
    
    snprintf(dest + offs, destlen - offs,"%s", c_asmopts);
}



void SetBoolean(arg_t *arg, char *val)
{
    if ((arg->flags & AF_BOOL_TRUE)) {
        *(int *)arg->data = YES;
    } else {
        *(int *)arg->data = NO;
    }
}


void SetString(arg_t *argument, char *arg)
{
    char  *ptr = arg + 1;
    
    if ( strncmp(ptr,argument->name,strlen(argument->name)) == 0) {
        ptr += strlen(argument->name);
    }
    if ( *ptr == '=' ) {
        ptr++;
    }
    
    if ( strlen(ptr) ) {
        *(char **)argument->data = strdup(ptr);
    } else {
        /* Try the next argument up */
        if (gargc < max_argc && gargv[gargc + 1][0] != '-') {
            /* Aha...non option comes next... */
            gargc++;
            *(char **)argument->data = strdup(gargv[gargc]);
        } else {
            // No option given..
        }
    }
}

static char *expand_macros(char *arg)
{
    char  *ptr, *nval;
    char  *rep, *start;
    char  *value = strdup(arg);
    char   varname[300];
    
    
    start = value;
    while ( (ptr = strchr(start,'$')) != NULL ) {
        if ( *(ptr + 1) == '{' ) {
            char  *end = strchr(ptr+1,'}');
            
            if ( end != NULL ) {
                snprintf(varname, sizeof(varname), "%.*s", ( end - ptr - 2 ), ptr + 2);
                rep = getenv(varname);
                if ( rep == NULL ) {
                    rep = "";
                }
                
                snprintf(varname, sizeof(varname), "%.*s", end - ptr + 1, ptr);
                nval = replace_str(value, varname, rep);
                free(value);
                value = nval;
                start = value + (ptr - start); 
            }
        } else {
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
    
    if ( strncmp(ptr,argument->name,strlen(argument->name)) == 0) {
        ptr += strlen(argument->name);
    }
    if ( *ptr == '=' ) {
        ptr++;
    }
    val = strtol(ptr, &end, 10);
    
    if ( end != ptr ) {
        *(int *)argument->data = atoi(ptr);
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

void AddPreProc(arg_t *argument, char *arg)
{
    BuildOptions(&cpparg, arg);
}


void AddLinkLibrary(arg_t *argument, char *arg)
{
    BuildOptions_start(&linkargs, arg);
}

void AddLinkOption(arg_t *arg, char *val)
{
    BuildOptions_start(&linkargs, val);
}


/** \brief Append arg to *list
 */
void BuildOptions(char **list, char *arg)
{
    char           *val;
    char           *orig = *list;
    
    zcc_asprintf(&val, "%s%s ",orig ? orig : "",arg);
    
    free(orig);
    *list = val;
}

void BuildOptions_start(char **list, char *arg)
{
    char           *val;
    char           *orig = *list;
    
    zcc_asprintf(&val, "%s %s",arg,orig ? orig : "");
    
    free(orig);
    *list = val;
}



void add_option_to_compiler(char *arg)
{
    BuildOptions(&comparg, arg);
}

void add_file_to_process(char *arg)
{
    char            filen[FILENAME_MAX + 1];
    char           *ptr;
    int             j;
    
    if (isspace(arg[0]) || arg[0] == 0)
        return;
    
    /* Add this file to the list of original files */
    ptr = strdup(arg);
    original_filenames[nfiles] = ptr;

    if (usetemp) {
        /* Now work out the temorary filename */
        tempname(filen);
        j = strlen(arg);
        while (j && arg[j] != '.')
            j--;

        if (j == 0) {
            fprintf(stderr, "Unrecognised filetype\n");
            return;
        }
        strcat(filen, &arg[j]);
        
        /* Copy the file over */
        if (!hassuffix(arg, ".c")) {
            if (copy_file(arg, "", filen, "")) {
                fprintf(stderr, "Cannot copy input file\n");
                exit(1);
            }
        }
        filelist[nfiles++] = strdup(filen);
    } else {
        /* Not using temporary files.. */
        filelist[nfiles++] = strdup(arg);
        strcpy(filen, arg);
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
    printf("%s",version);
    printf("\nOptions:\n\n");

    while (cur->help) {
        printf("-%-15s %s\n", cur->name, cur->help);
        cur++;
    }

    exit(0);
}



void parse_cmdline_arg(char *arg)
{
    arg_t          *pargs = myargs;
    
    while (pargs->setfunc) {
        if ((pargs->flags & AF_MORE) ) {
            /* More info follows the option */
            if (strncmp(arg + 1, pargs->name, strlen(pargs->name)) == 0) {
                (*pargs->setfunc) (pargs, arg);
                return;
            }
        } else {
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
        if (strncmp(arg, pargs->name, strlen(pargs->name)) == 0 ) {
            char *val = arg + strlen(pargs->name);
            while (isspace(*val)) {
                val++;
            }
            KillEOL(val);
            (*pargs->setfunc) (pargs,val);
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
    snprintf(buf,sizeof(buf),".%s",c_extension_config && strlen(c_extension_config) ? c_extension_config : "o");
    c_extension = strdup(buf);
    
    if ( makelib ) {
        compileonly = YES;
    }

    if ( c_startup != -1 ) {
        write_zcc_defined("startup", c_startup);
    }
    
    /* We can't create an app and make a library.... */
    if (createapp && makelib) {
        createapp = NO;
    }

    /* We only have to do a late assembly hack for z80asm family */
    if (createapp && makeapp && IS_ASM(ASM_Z80ASM)) {
        lateassemble = YES;
    }
}

static void configure_maths_library()
{
    char   buf[1024];
    
    /* By convention, -lm refers to GENMATH, -lmz to Z88MATHLIB/ALTMATHLIB */
    
    if ( c_altmathlib ) {
        if ( strstr(linkargs,"-lmz ") != NULL ) {
            snprintf(buf, sizeof(buf),"-l%s ", c_altmathlib);
            linkargs = replace_str(linkargs, "-lmz ", buf);
            parse_option(c_altmathflags);
        }
    }
    
    if ( c_genmathlib ) {
        if ( strstr(linkargs,"-lm ") != NULL ) {
            snprintf(buf, sizeof(buf),"-l%s ", c_genmathlib);
            linkargs = replace_str(linkargs, "-lm ", buf);
        }    
    }
}

static void configure_assembler()
{
    char           *assembler = NULL;
    char           *linker = NULL;
    char           *ptr;
    int             type = ASM_Z80ASM;
    enum iostyle    style = outimplied;
    char           *name = c_assembler_type;

    if (strcasecmp(name, "z80asm") == 0) {
        type = ASM_Z80ASM;
        linker = c_z80asm_exe;
        assembler = c_z80asm_exe;
        if ( makelib ) {
            parse_cmdline_arg("-Ca-forcexlib");
        }
    } else if (strcasecmp(name, "mpm") == 0) {
        type = ASM_Z80ASM;
        linker = c_mpm_exe;
        assembler = c_mpm_exe;
    } else if (strcasecmp(name, "asxx") == 0) {
        type = ASM_ASXX;
        linker = c_aslink_exe;
        assembler = c_asz80_exe;
        c_asmopts = c_asz80opts;
        c_linkopts = c_aslinkopts;
    } else if (strcasecmp(name, "vasm") == 0) {
        type = ASM_VASM;
        linker = c_vlink_exe;
        assembler = c_vasm_exe;

        /* Switch config around */
        c_asmopts = c_vasmopts;
        c_linkopts = c_vlinkopts;
        
        style = outspecified_flag;
        linker_output_separate_arg = 1;
    } else if (strcasecmp(name, "binutils") == 0 ) {
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
    if ( strcmp(c_compiler_type,"sdcc") == 0 ) {
        compiler_type = CC_SDCC;
        snprintf(buf,sizeof(buf),"-mz80 --reserve-regs-iy --no-optsdcc-in-asm --c1mode --asm=%s",sdcc_assemblernames[assembler_type]);
        add_option_to_compiler(buf);
        preprocarg = " -DZ88DK_USES_SDCC=1";
        BuildOptions(&cpparg, preprocarg);
        if ( assembler_type == ASM_Z80ASM ) {
            parse_cmdline_arg("-Ca-sdcc");
        }
        c_compiler = c_sdcc_exe;
        snprintf(buf, sizeof(buf),"%s -E", c_sdcc_exe);
        c_cpp_exe = strdup(buf);
        c_stylecpp = outspecified_flag;
        compiler_style = filter_outspecified_flag;
    } else {
        preprocarg = " -DSCCZ80 -DSMALL_C";
        BuildOptions(&cpparg, preprocarg);
        /* Indicate to sccz80 what assembler we want */
        snprintf(buf,sizeof(buf),"-asm=%s",c_assembler_type);
        add_option_to_compiler(buf);
        if ( makelib ) {
            add_option_to_compiler("-make-lib");
        }
        if ( makeapp ) {
            add_option_to_compiler("-make-app");
        }
        c_compiler = c_sccz80_exe;
        compiler_style = outimplied;
    }
}



void PragmaDefine(arg_t *arg,char *val)
{
    char *ptr = val + strlen(arg->name) + 2;
    int   value = 0;
    char *eql;

    if ( (eql = strchr(ptr,'=') ) != NULL ) {
        *eql = 0;
        value = atoi(eql+1);
    }
    write_zcc_defined(ptr, value);
}

void write_zcc_defined(char *name, int value)
{
    add_zccopt("\nIF !DEFINED_%s\n",name);
    add_zccopt("\tdefc\tDEFINED_%s = 1\n",name);
    if (value) add_zccopt("\tdefc %s = %d\n",name,value);
    add_zccopt("ENDIF\n\n");
}

void PragmaNeed(arg_t *arg,char *val)
{
    char *ptr = val + strlen(arg->name) + 2;

    add_zccopt("\nIF !NEED_%s\n",ptr);
    add_zccopt("\tDEFINE\tNEED_%s\n",ptr);
    add_zccopt("ENDIF\n\n");
}


void PragmaBytes(arg_t *arg,char *val)
{
    char *ptr = val + strlen(arg->name) + 2;
    char *value;

    if ( (value = strchr(ptr,'=') ) != NULL ) {
        *value++ = 0;
    } else {
        return;
    }

    add_zccopt("\nIF NEED_%s\n",ptr);
    add_zccopt("\tDEFINED\tDEFINED_NEED_%s\n",ptr);
    add_zccopt("\tdefb\t%s\n",value);
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

/** \brief Copy any generated output files, back to the directory they came from
 */
void copy_output_files_to_destdir(char *suffix)
{
    int             j, k;
    char           *ptr1, *ptr2;

    for (j = 0; j < nfiles; j++) {
        ptr1 = changesuffix(filelist[j], suffix);
        if ( outputfile != NULL ) {
            ptr2 = strdup(outputfile);
        } else {
            ptr2 = changesuffix(original_filenames[j], suffix);
        }
        k = copy_file(ptr1, "", ptr2, "");
        free(ptr1);
        free(ptr2);
        if (k) {
            fprintf(stderr, "Couldn't copy output files\n");
            exit(1);
        }
    }
}



void remove_temporary_files(void)
{
    int             j;

    /* Show all error files */

    if (c_crt0)
        ShowErrors(c_crt0, 0);
    for (j = 0; j < nfiles; j++) {
        ShowErrors(filelist[j], original_filenames[j]);
    }

    if (cleanup && usetemp) {    /* Default is yes */
        for (j = 0; j < nfiles; j++) {
            remove_file_with_extension(filelist[j], ".i");
            remove_file_with_extension(filelist[j], ".2");
            remove_file_with_extension(filelist[j], ".asm");
            remove_file_with_extension(filelist[j], ".err");
            remove_file_with_extension(filelist[j], ".op1");
            remove_file_with_extension(filelist[j], ".op2");
            remove_file_with_extension(filelist[j], ".opt");
            if (c_extension) remove_file_with_extension(filelist[j], c_extension );
            remove_file_with_extension(filelist[j], ".sym");
        }
        if (crtcopied != 0) {
            remove_file_with_extension(c_crt0, ".asm");
            remove_file_with_extension(c_crt0, ".opt");
            remove_file_with_extension(c_crt0, ".err");
            if (c_extension) remove_file_with_extension(c_crt0, c_extension);
            remove_file_with_extension(c_crt0, ".map");
            remove_file_with_extension(c_crt0, ".sym");
        }
    } else if (usetemp == NO) {
        /* Remove crt0.o file for -notemp compiles */
        remove_file_with_extension(c_crt0, ".err");
        if (c_extension) remove_file_with_extension(c_crt0, c_extension);
    }
}


void remove_file_with_extension(char *file, char *ext)
{
    char           *temp;
    temp = changesuffix(file, ext);
    remove(temp);
    free(temp);    
}


void copy_crt0_to_temp(void)
{
    char            filen[FILENAME_MAX + 1];
    char           *oldptr, *newptr;

    if (compileonly || assembleonly || preprocessonly)
        return;
    if (usetemp) {
        tempname(filen);/* Temporary nane..get it in filen */
    } else {
        /*
         * If not using temporary file then the gumph goes into
         * crt0.#?
         */
        strcpy(filen, "crt0");
    }

    /*
     * Now to the copying the files over, used for both usetemp and
     * !usetemp
     */

    oldptr = c_crt0;
    if (copy_file(oldptr, ".opt", filen, ".opt") || copy_file(filen, ".opt", filen, ".asm")) {
        fprintf(stderr, "Cannot copy crt0 file\n");
        exit(1);
    }
    crtcopied = 1;
    newptr = mustmalloc(strlen(filen) + 1);
    strcpy(newptr, filen);
    c_crt0 = newptr;
}


void 
ShowErrors(char *filen, char *orig)
{
    char           *temp;
    char            buffer[LINEMAX + 1];
    char            buffer2[LINEMAX + 1];
    char            filenamebuf[LINEMAX + 1];
    int             j,linepos,fnpos,fnlen;
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
                strcpy(filenamebuf,strstr(buffer,"'") + strlen("'"));
                sprintf(strstr(filenamebuf,"'"),"");
                if ((linepos > 1) && ((fp2 = fopen(filenamebuf, "r")) != NULL)) {
                    for (j = 1; j < linepos; j++)
                        fgets(buffer2, LINEMAX, fp2);
                    fprintf(stderr, "                   ^ ---- %s",fgets(buffer2, LINEMAX, fp2));
                }
                fclose(fp2);
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
    char           *ptr;

    /* Predefined in 32-bit MS Visual C/C++ and Borland Builder C/C++ */
    if (ptr = getenv("TEMP")) {    /* Under Windows 95 usually
                     * C:\WINDOWS\TEMP */
        strcpy(filen, ptr);    /* Directory is not guaranteed to
                     * exist */
        tmpnam(filen + strlen(filen));    /* Adds strings like
                         * "\s3vvrm3t.",
                         * "\s3vvrm3t.1",
                         * "\s3vvrm3t.2" */
    } else
        tmpnam(filen);
    if (ptr = strrchr(filen, '.'))
        *ptr = '_';
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
    if (ptr = strrchr(filen, '.'))    /* than once without cleaning out
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
        snprintf(buf,buflen,"%s",arg+1);
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
            snprintf(buf,buflen,"%s/%s.cfg",cfgfile, arg+1);
            return (gc);
        } else {
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
        snprintf(buf,buflen,"%s",cfgfile);
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
        snprintf(buf,buflen,"%s/zcc.cfg",cfgfile);
    } else {
        // Fall back to a sensible default
        snprintf(buf, buflen, "%slib/config/zcc.cfg", c_install_dir);
    }
    return (gc);
}




/* Parse options - rewritten to use strtok cos that's nice and easy */
void parse_option(char *option)
{
    char           *ptr;
    
    if ( option != NULL ) {
        ptr = strtok(option, " \t\r\n");

        while (ptr != NULL) {
            if (ptr[0] == '-') {
                parse_cmdline_arg(ptr);
            } else {
                add_file_to_process(ptr);
            }
            ptr = strtok(NULL, " \r\n");
        }
    }
}

/* Check link arguments (-l) to -i for z80asm */
void linkargs_mangle(char *linkargs)
{
    char           *ptr = linkargs;

    if (IS_ASM(ASM_Z80ASM) ) {
        while ((ptr = strstr(linkargs, "-l")) != NULL) {
            ptr[1] = 'i';
        }
    }
}

void add_zccopt(char *fmt,...)
{
    char   buf[4096];
    size_t len = zccopt ? strlen(zccopt) : 0;
    size_t extra;
    va_list ap;

    va_start(ap, fmt);
    extra = vsnprintf(buf,sizeof(buf),fmt,ap);
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
    } else
        retlen = strlen(str);

    if ((ret = malloc(retlen + 1)) == NULL)
        return NULL;

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
    
    while ( pargs->setfunc ) {
        if ( pargs->defvalue ) {
            snprintf(buf,sizeof(buf),"%s %s",pargs->name, pargs->defvalue);
            parse_configfile_line(buf);
        }
        pargs++;
    }
}

static void print_specs()
{
    arg_t  *pargs = config;
    int     i;

    while ( pargs->setfunc ) {
        if ( (pargs->flags & AF_DEPRECATED) == 0 && pargs->setfunc == SetStringConfig ) {
            if ( *(char **)pargs->data != NULL && strlen(*(char **)pargs->data)) {
                printf("%-20s\t%s\n",pargs->name, *(char **)pargs->data);
            } else {
                printf("%-20s\t[undefined]\n",pargs->name);
            }
        } else if ( pargs->setfunc == AddArray ) {
            for ( i = 0; i < *pargs->num_ptr; i++ ) {
                printf("%-20s\t%s\n",pargs->name, (*(char ***)pargs->data)[i]);
            }
        }
        pargs++;
    }
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
         ( fp = fopen("/dev/null","w") ) != NULL 
#else
         ( fp = fopen("NUL","w") ) != NULL 
#endif
        ) {
        req = vfprintf(fp, fmt, ap);
        fclose(fp);
        ret = calloc(req + 1, sizeof(char));
        req = vsnprintf(ret, req + 1, fmt, saveap);    
        *s = ret;
    } else {
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

