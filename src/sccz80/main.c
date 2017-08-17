/*
 *      Small C+ Compiler -
 *
 *      Main() part
 *
 *      $Id: main.c,v 1.42 2016-09-01 04:08:32 aralbrec Exp $
 */

#include "../config.h"
#include "ccdefs.h"

#if defined(__MSDOS__) && defined(__TURBOC__)
extern unsigned _stklen = 8192U; /* Default stack size 4096 bytes is too small. */
#endif

static char   *c_output_extension = "asm";


static int      gargc; /* global copies of command line args */
static char   **gargv;
static SYMBOL  *savecurr;    /* copy of currfn for #include */
static int      saveline;    /* copy of lineno  "    " */
static int      saveinfn;    /* copy of infunc  "    " */
static int      savestart;   /* copy of fnstart "    " */


char Filenorig[FILENAME_LEN + 1];

int c_makeshare; /* Do we want to make a shared library? */
int c_useshared; /* Use shared lib routines? */
int c_shared_file; /* File contains routines which are to be
          * called via lib package - basically jimmy
          * the stack but that's it..
          */

int c_notaltreg; /* No alternate registers */
int c_standard_escapecodes = 0; /* \n = 10, \r = 13 */
int c_disable_builtins = 0;

char *c_rodata_section = "rodata_compiler";
char *c_data_section = "data_compiler";
char *c_bss_section = "bss_compiler";
char *c_code_section = "code_compiler";
char *c_init_section = "code_crt_init";


#define OPT_BOOL         1
#define OPT_BOOL_FALSE   2
#define OPT_INT          4
#define OPT_STRING       8
#define OPT_ASSIGN       16
#define OPT_OR           32
#define OPT_FUNCTION     64
#define OPT_HEADER       128


typedef struct {
    const char     short_name;
    const char    *long_name;
    int            type;
    const char    *description;
    void          *value;
    intptr_t       data;
} option;


static void dumpfns(void);
static void dumpvars(void);
static void parse(void);
static void errsummary(void);
static char *nextarg(int n, char *s, int size);
static void setup_sym(void);
static void info(void);
static void openout(void);

static int parse_arguments(option *args, int argc, char **argv);
static void SetAssembler(option *arg, char* val);
static void SetDefine(option *arg, char *val);
static void SetUndefine(option *arg, char *val);
static void UnSetWarning(option *arg, char *val);
static void SetWarning(option *arg, char *val);
static void SetNoWarn(option *arg, char* val);
static void SetAllWarn(option *arg, char *val);
static void DispInfo(option *arg, char *val);
static void set_math_z88_parameters(option *opt, char *arg);

static void atexit_deallocate(void);


static option  sccz80_opts[] = {
    { 'v', "verbose", OPT_BOOL, "Be verbose", &c_verbose, 0 },
    { 'h', "help", OPT_FUNCTION|OPT_BOOL, "Show this help page", DispInfo, 0 },
    { 0, "", OPT_HEADER, "CPU Targetting:", NULL, 0 },
    { 0, "mz80-zxn", OPT_ASSIGN|OPT_INT, "Generate output for the z80-zxn", &c_cpu, CPU_Z80ZXN },
    { 0, "mz80", OPT_ASSIGN|OPT_INT, "Generate output for the z80", &c_cpu, CPU_Z80 },
    { 0, "mz180", OPT_ASSIGN|OPT_INT, "Generate output for the z180", &c_cpu, CPU_Z180 },
    { 0, "mr2k", OPT_ASSIGN|OPT_INT, "Generate output for the Rabbit 2000", &c_cpu, CPU_R2K },
    { 0, "mr3k", OPT_ASSIGN|OPT_INT, "Generate output for the Rabbit 3000", &c_cpu, CPU_R3K },
    { 0, "", OPT_HEADER, "Code generation options", NULL, 0 },
    { 0, "unsigned", OPT_BOOL, "Make all types unsigned", &c_default_unsigned, 0 },
    { 0, "do-inline", OPT_ASSIGN|OPT_INT, "Inlne some common functions", &c_doinline, ~0 },
    { 0, "inline-gint", OPT_OR, "Inline the l_gint call", &c_doinline, INLINE_GINT },
    { 0, "inline-pint", OPT_OR, "Inline the l_pint call", &c_doinline, INLINE_PINT },
    { 0, "disable-builtins", OPT_BOOL, "Disable builtin functions",&c_disable_builtins, 0},
    { 0, "doublestr", OPT_BOOL, "Store FP constants as strings", &c_double_strings, 0 },
    { 0, "math-z88", OPT_FUNCTION|OPT_BOOL, "(deprecated) Make FP constants match z88", &set_math_z88_parameters, 0 },
    { 0, "fp-exponent-bias", OPT_INT, "=<num> FP exponent bias (default: 128)", &c_fp_exponent_bias, 0 },
    { 0, "fp-mantissa-size", OPT_INT, "=<num> FP mantissa size (default: 5 bytes)", &c_fp_mantissa_bytes, 0 },
    
    { 0, "noaltreg", OPT_BOOL, "Try not to use the alternative register set", &c_notaltreg, 0 },
    { 0, "compact", OPT_BOOL, "Make all functions callee", &c_compact_code, 0},
    { 0, "standard-escape-chars", OPT_BOOL, "Use standard mappings for \\r and \\n", &c_standard_escapecodes, 0},
    { 0, "set-r2l-by-default", OPT_BOOL, "Use r->l calling convention by default", &c_use_r2l_calling_convention, 0 },
    { 0, "asm", OPT_FUNCTION, "=<name> Set the assembler output (z80asm,vasm,asxx,gnu)", SetAssembler, 0 },
    { 0, "constseg", OPT_STRING, "=<name> Set the const section name", &c_rodata_section, 0 },
    { 0, "codeseg", OPT_STRING, "=<name> Set the code section name", &c_code_section, 0 },
    { 0, "bssseg", OPT_STRING, "=<name> Set the bss section name", &c_bss_section, 0 },
    { 0, "dataseg", OPT_STRING, "=<name> Set the data section name", &c_data_section, 0 },
    { 0, "initseg", OPT_STRING, "=<name> Set the initialisation section name", &c_init_section, 0 },
#ifdef USEFRAME
    { 0, "", OPT_HEADER, "Framepointer configuration:", NULL, 0 },
    { 0, "frameix", OPT_ASSIGN|OPT_INT, "Use ix as the frame pointer", &c_framepointer_is_ix, 1},
    { 0, "frameiy", OPT_ASSIGN|OPT_INT, "Use iy as the frame pointer", &c_framepointer_is_ix, 0},
#endif
    { 0, "", OPT_HEADER, "Shared code generation:", NULL, 0 },
    { 0, "make-shared", OPT_BOOL, "This Library file is shared", &c_makeshare, 0 },
    { 0, "shared-file", OPT_BOOL, "All functions with this file are shared", &c_shared_file, 0 },
    { 0, "use-shared", OPT_BOOL, "Use shared library functions", &c_useshared, 0 },
    { 0, "share-offset", OPT_INT, "=<val> Define the shared offset (use with -make-shared)", &c_share_offset, 0 },


    { 0, "", OPT_HEADER, "Error/warning handling:", NULL, 0 },
    { 0, "stop-on-error", OPT_BOOL, "Stop on any error", &c_errstop, 0 },
    { 0, "Wnone", OPT_FUNCTION|OPT_BOOL, "Disable all warnings", SetNoWarn, 0 },
    { 0, "Wall", OPT_FUNCTION|OPT_BOOL, "Enable all warnings", SetAllWarn, 0 },
    { 0, "Wn", OPT_FUNCTION, "<num> Disable a warning", UnSetWarning, 0},
    { 0, "W", OPT_FUNCTION, "<num> Enable a warning",  SetWarning, 0 },
    
    { 0, "", OPT_HEADER, "Debugging options", NULL, 0 },
    { 0, "cc", OPT_BOOL, "Intersperse the assembler output with the source C code", &c_intermix_ccode, 0 },
    { 0, "debug", OPT_INT, "=<val> Enable some extra logging", &debuglevel, 0 },
    { 0, "ext", OPT_STRING, "=<ext> Set the file extension for the generated output", &c_output_extension, 0 },
    { 0, "D", OPT_FUNCTION, "Define a preprocessor directive", SetDefine, 0 },
    { 0, "U", OPT_FUNCTION, "Undefine a preprocessor directive" , SetUndefine, 0 },
    { 0, "", OPT_HEADER, "All options can be prefixed with either a single or double -", NULL, 0},
    { 0, "", OPT_HEADER, "Assignments can either be = or as next argument", NULL, 0},
    { 0 }
};




/*
 *
 *      Code...
 *
 */

/*
 *      Compiler begins execution here
 */
int main(int argc, char** argv)
{
    gargc = argc;
    gargv = argv;

    /* allocate space for arrays */
    litq = MALLOC(FNLITQ); /* literals, these 2 dumped end */
    dubq = MALLOC(FNLITQ); /* Doubles */
    tempq = MALLOC(LITABSZ); /* Temp strings... */
    glbq = MALLOC(LITABSZ); /* Used for glb lits, dumped now */
    symtab = NULL;
    loctab = MALLOC(NUMLOC * sizeof(SYMBOL));
    wqueue = MALLOC(NUMWHILE * sizeof(WHILE_TAB));
    gotoq = MALLOC(NUMGOTO * sizeof(GOTO_TAB));
    tagptr = tagtab =  MALLOC(NUMTAG * sizeof(TAG_SYMBOL));
    membptr = membtab =  MALLOC(NUMMEMB * sizeof(SYMBOL));

    swnext = MALLOC(NUMCASE * sizeof(SW_TAB));
    swend = swnext + (NUMCASE - 1);

    stage = MALLOC(STAGESIZE);
    stagelast = stage + STAGELIMIT;


    glbcnt = 0; /* clear global symbols */
    locptr = STARTLOC; /* clear local symbols */
    wqptr = wqueue; /* clear while queue */
    gltptr = dubptr = 0; /* clear literal pools */
    *litq = 0; /* First entry in literal queue is zero */
    litptr = 1; /* So miniprintf search works */

    Zsp = /* stack ptr (relative) */
        errcnt = /* no errors */
        c_errstop = /* keep going after an error */
        eof = /* not eof yet */
        swactive = /* not in switch */
        skiplevel = /* #if not encountered */
        iflevel = /* #if nesting level = 0 */
        ncmp = /* no open compound states */
        lastst = /* not first file to asm */
        fnstart = /* current "function" started at line 0 */
        lineno = /* no lines read from file */
        infunc = /* not in function now */
        0; /*  ...all set to zero.... */

    stagenext = NULL; /* direct output mode */

    input = /* no input file */
        inpt2 = /* or include file */
        saveout = /* no diverted output */
        output = NULL; /* no open units */

    currfn = NULL; /* no function yet */
    macptr = cmode = 1; /* clear macro pool and enable preprocessing */
    ncomp = c_doinline = c_mathz88 = need_floatpack = c_compact_code = 0;
    c_default_unsigned = NO;
    c_useshared = c_makeshare = c_shared_file = NO;
    nxtlab = 0;/* start numbers at lowest possible */
    c_intermix_ccode = 0; /* don't include the C text as comments */
    c_errstop =0;  /* don't stop after errors */
    c_verbose = 0;
    c_double_strings = 0;
    c_notaltreg = NO;
    c_share_offset = SHAREOFFSET; /* Offset for shared libs */
    debuglevel = NO;
    c_assembler_type = ASM_Z80ASM;
    c_framepointer_is_ix = -1;
    c_use_r2l_calling_convention = NO;

    setup_sym(); /* define some symbols */
    /* Parse the command line options */
    atexit(atexit_deallocate); /* To free everything */
    clear();
    filenum = 0;
    gargc = parse_arguments(sccz80_opts, argc, argv);
    clear();

    if (gargc == 0) {
        info();
        exit(1);
    }
    litlab = getlabel(); /* Get labels for function lits*/
    openout(); /* get the output file */
    openin(); /* and initial input file */
    header(); /* intro code */
    parse(); /* process ALL input */
    /* dump literal queues, with label */
    /* litq starts from 1, so literp has to be -1 */
    dumplits(0, YES, litptr - 1, litlab, litq + 1);
    write_double_queue();
    dumpvars();
    dumpfns();
    trailer(); /* follow-up code */
    closeout();
    errsummary(); /* summarize errors */
    if (errcnt)
        exit(1);
    exit(0);
}

/*
 *      Abort compilation
 */
void ccabort()
{
    if (inpt2 != NULL)
        endinclude();
    if (input != NULL)
        fclose(input);
    closeout();
    fprintf(stderr, "Compilation aborted\n");
    exit(1);
}

/*
 * Process all input text
 *
 * At this level, only static declarations,
 * defines, includes, and function
 * definitions are legal...
 */
void parse()
{
    while (eof == 0) { /* do until no more input */
        if (amatch("extern")) {
            dodeclare(EXTERNAL, NULL, 0);
        } else if (amatch("static")) {
            dodeclare(LSTATIC, NULL, 0);
        } else if (amatch("typedef")) {
            dodeclare(TYPDEF, NULL, 0);
        } else if (dodeclare(STATIK, NULL, 0)) {
            ;
        } else if (ch() == '#') {
            if (match("#asm")) {
                doasm();
            } else if (match("#include")) {
                doinclude();
            } else if (match("#define")) {
                addmac();
            } else {
                clear();
                blanks();
            }
        } else {
            newfunc();
        }
        blanks(); /* force eof if pending */
    }
}

/*
 *      Report errors for user
 */
void errsummary()
{
    /* see if anything left hanging... */
    if (ncmp) {
        error(E_BRACKET);
        nl();
    }
    if (c_verbose) {
        printf("Symbol table usage: %d\n", glbcnt);
        printf("Structures defined: %ld\n", (long)(tagptr - tagtab));
        printf("Members defined:    %ld\n", (long)(membptr - membtab));
        printf("There %s %d %s in compilation.\n", (errcnt == 1 ? "was" : "were"), errcnt, (errcnt == 1 ? "error" : "errors"));
    }
}

/*
 * places in s the n-th argument (up to "size"
 * bytes). If successful, returns s. Returns 0
 * if the n-th argument doesn't exist.
 */

char *nextarg(int n, char* s, int size)
{
    char* str;
    char* str2;
    int i;

    if (n < 0 || n >= gargc)
        return NULL;
    i = 0;
    str = str2 = gargv[n];
    while (++i < size && (*s++ = *str++))
        ;
    if (*str2 == '\0')
        return NULL;
    return s;
}

/*
 * make a few preliminary entries in the symbol table
 */

void setup_sym()
{
    defmac("Z80");
    defmac("SMALL_C");
    /* dummy symbols for pointers to char, int, double */
    /* note that the symbol names are not valid C variables */
    dummy_sym[0] = 0;
    dummy_sym[CCHAR] = addglb("0ch", POINTER, CCHAR, 0, STATIK, 0, 0);
    dummy_sym[CCHAR]->isassigned = YES;
    dummy_sym[CINT] = addglb("0int", POINTER, CINT, 0, STATIK, 0, 0);
    dummy_sym[CINT]->isassigned = YES;
    dummy_sym[DOUBLE] = addglb("0dbl", POINTER, DOUBLE, 0, STATIK, 0, 0);
    dummy_sym[DOUBLE]->isassigned = YES;
    dummy_sym[LONG] = addglb("0lng", POINTER, LONG, 0, STATIK, 0, 0);
    dummy_sym[LONG]->isassigned = YES;
    dummy_sym[CPTR] = addglb("0cpt", POINTER, CPTR, 0, STATIK, 0, 0);
    dummy_sym[CPTR]->isassigned = YES;
    dummy_sym[VOID] = addglb("0vd", POINTER, VOID, 0, STATIK, 0, 0);
    dummy_sym[VOID]->isassigned = YES;
}

void info()
{
    fputs(titlec, stderr);
    fputs(Version, stderr);
    fputs("\n(C) 1980-2016 Cain, Van Zandt, Hendrix, Yorston, Morris\n", stderr);
    fprintf(stderr, "Usage: %s [flags] [file]\n", gargv[0]);
}

/*
 ***********************************************************************
 *
 *
 *      Routines To Write Out Scope of labels and to Dump
 *      the static variables, also for dumping the literal pool
 *
 *
 ***********************************************************************
 */

static void dumpfns()
{
    int ident, type, storage;
    SYMBOL* ptr;
    FILE* fp;

    outstr("\n\n; --- Start of Scope Defns ---\n\n");

    if (!glbcnt)
        return;

    for ( ptr = symtab; ptr != NULL; ptr = ptr->hh.next ) {
        if (ptr->name[0] != '0' && ptr->ident != GOTOLABEL ) {
            ident = ptr->ident;
            if (ident == FUNCTIONP)
                ident = FUNCTION;
            type = ptr->type;
            storage = ptr->storage;
            if (type == PORT8 || type == PORT16 ) {
                outfmt("\tdefc\t_%s =\t%d\n", ptr->name, ptr->size);
            } else if (ident == FUNCTION && ptr->size != 0) {
                outfmt("\tdefc\t_%s =\t%d\n", ptr->name, ptr->size);
            } else {
                if (ident == FUNCTION && storage != LSTATIC) {
                    if (storage == EXTERNAL) {
                        if (ptr->flags & LIBRARY) {
                            GlobalPrefix(LIB);
                            if ((ptr->flags & SHARED) && c_useshared) {
                                outstr(ptr->name);
                                outstr("_sl\n");
                                GlobalPrefix(LIB);
                            }
                        } else {
                            GlobalPrefix(XREF);
                        }
                    } else {
                        if (ptr->offset.i == FUNCTION || ptr->storage == DECLEXTN) {
                            if (ptr->flags & LIBRARY) {
                                GlobalPrefix(XDEF);
                                outname(ptr->name, 1);
                                nl();
                            }
                            GlobalPrefix(XDEF);
                        } else
                            GlobalPrefix(XREF);
                    }
                    outname(ptr->name, dopref(ptr));
                    nl();
                } else {
                    if (storage == EXTERNP) {
                        outstr("\tdefc\t");
                        outname(ptr->name, 1);
                        ot("=\t");
                        outdec(ptr->size);
                        nl();
                    } else if (ident != ENUM && type != ENUM && ident != MACRO && storage != LSTATIC && storage != LSTKEXT && storage != TYPDEF && storage != STATIC_INITIALISED ) {
                        if (storage == EXTERNAL)
                            GlobalPrefix(XREF);
                        else
                            GlobalPrefix(XDEF);
                        outname(ptr->name, 1);
                        nl();
                    }
                }
            }
        }
    }

    if ((fp = fopen("zcc_opt.def", "a")) == NULL) {
        error(E_ZCCOPT);
    }

    if (need_floatpack) {
        fprintf(fp, "\nIF !NEED_floatpack\n");
        fprintf(fp, "\tDEFINE\tNEED_floatpack\n");
        fprintf(fp, "ENDIF\n\n");
    }
    if (c_mathz88) {
        fprintf(fp, "\nIF !NEED_c_mathz88\n");
        fprintf(fp, "\tDEFINE\tNEED_c_mathz88\n");
        fprintf(fp, "ENDIF\n\n");
    }
    /*
     * Now, we're gonna use #pragma define _FAR_PTR to indicate whether we need
     * far stuff - this has to go with a -D_FAR_PTR from the compile line
     * as well for everything to work just right, so if we find this then
     * we can indicate to the startup code via zcc_opt.def what the scam
     * is - this could be used for eg. to allocate space for file structures
     * etc
     */
    if ((ptr = findglb("_FAR_PTR")) && ptr->ident == MACRO) {
        fprintf(fp, "\nIF !NEED_farstartup\n");
        fprintf(fp, "\tDEFINE NEED_farstartup\n");
        fprintf(fp, "ENDIF\n\n");
    }

    if (printf_format_option) {
        fprintf(fp, "\nIF !DEFINED_CRT_printf_format\n");
        fprintf(fp, "\tdefc\tDEFINED_CRT_printf_format = 1\n");
        fprintf(fp, "\tdefc CRT_printf_format = 0x%08x\n", printf_format_option);
        fprintf(fp, "ELSE\n");
        fprintf(fp, "\tUNDEFINE temp_printf_format\n");
        fprintf(fp, "\tdefc temp_printf_format = CRT_printf_format\n");
        fprintf(fp, "\tUNDEFINE CRT_printf_format\n");
        fprintf(fp, "\tdefc CRT_printf_format = temp_printf_format | 0x%08x\n", printf_format_option);
        fprintf(fp, "ENDIF\n\n");
        fprintf(fp, "\nIF !NEED_printf\n");
        fprintf(fp, "\tDEFINE\tNEED_printf\n");
        fprintf(fp, "ENDIF\n\n");
    }

    if (scanf_format_option) {
        fprintf(fp, "\nIF !DEFINED_CRT_scanf_format\n");
        fprintf(fp, "\tdefc\tDEFINED_CRT_scanf_format = 1\n");
        fprintf(fp, "\tdefc CRT_scanf_format = 0x%08x\n", scanf_format_option);
        fprintf(fp, "ELSE\n");
        fprintf(fp, "\tUNDEFINE temp_scanf_format\n");
        fprintf(fp, "\tdefc temp_scanf_format = CRT_scanf_format\n");
        fprintf(fp, "\tUNDEFINE CRT_scanf_format\n");
        fprintf(fp, "\tdefc CRT_scanf_format = temp_scanf_format | 0x%08x\n", scanf_format_option);
        fprintf(fp, "ENDIF\n\n");
        fprintf(fp, "\nIF !NEED_scanf\n");
        fprintf(fp, "\tDEFINE\tNEED_scanf\n");
        fprintf(fp, "ENDIF\n\n");
    }
    fclose(fp);


    outstr("\n\n; --- End of Scope Defns ---\n\n");
}

/*
 * Dump a function into the zcc_opt.def file - this allows us to pass
 * important functions to the appstartup code so it can call them
 * when appropriate, we also XREF it so we don't have to do that in
 * the startup code
 */

void WriteDefined(char* sname, int value)
{
    FILE* fp;

    if ((fp = fopen("zcc_opt.def", "a")) == NULL) {
        error(E_ZCCOPT);
    }
    fprintf(fp, "\nIF !DEFINED_%s\n", sname);
    fprintf(fp, "\tdefc\tDEFINED_%s = 1\n", sname);
    fprintf(fp, "\tdefc %s = %d\n", sname, value);
    fprintf(fp, "ENDIF\n\n");
    fclose(fp);
}

/*
 */
void dumpvars()
{
    int ident, type, storage;
    SYMBOL* ptr;

    if (!glbcnt)
        return;

    /* Start at the start! */
    outstr("; --- Start of Static Variables ---\n\n");

    output_section(c_bss_section); // output_section("bss");

    for ( ptr = symtab; ptr != NULL; ptr = ptr->hh.next ) {
        if (ptr->name[0] != '0' && ptr->ident != GOTOLABEL) {
            ident = ptr->ident;
            type = ptr->type;
            storage = ptr->storage;
            if (ident != ENUM && type != ENUM && ident != MACRO && ident != FUNCTION && 
                storage != EXTERNAL && storage != DECLEXTN && storage != STATIC_INITIALISED && storage != EXTERNP && storage != LSTKEXT && storage != TYPDEF && 
                type != PORT8 && type != PORT16) {
                prefix();
                outname(ptr->name, 1);
                col();
                defstorage();
                outdec(ptr->size);
                nl();
            }
        }
    }

    /* Switch back to standard section */
    output_section(c_code_section); // output_section("code");
}

/*
 *      Dump the literal pool if it's not empty
 *      Modified by djm to be able to input which queue should be
 *      dumped..
 */
void dumplits(
    int size, int pr_label,
    int queueptr, int queuelab,
    unsigned char* queue)
{
    int j, k, lit;

    if (queueptr) {
        if (pr_label) {
            output_section(c_rodata_section); // output_section("text");
            prefix();
            queuelabel(queuelab);
            col();
            nl();
        }
        k = 0;
        while (k < queueptr) {
            /* pseudo-op to define byte */
            if (infunc)
                j = 1;
            else
                j = 10;
            if (size == 1)
                defbyte();
            else if (size == 4)
                deflong();
            else if (size == 0) {
                defmesg();
                j = 30;
            } else if ( size == 6 ) {
                defbyte();
                j = 6;
                size = 1;
            } else
                defword();
            while (j--) {
                if (size == 0) {
                    lit = getint(queue + k, 1);
                    if (lit >= 32 && lit <= 126 && lit != '"' && lit != '\\')
                        outbyte(lit);
                    else {
                        outstr("\"\n");
                        defbyte();
                        outdec(lit);
                        nl();
                        lit = 0;
                    }
                    k++;
                    if (j == 0 || k >= queueptr || lit == 0) {
                        if (lit)
                            outbyte('"');
                        nl();
                        break;
                    }
                } else {
                    outdec(getint(queue + k, size));
                    k += size;
                    if (j == 0 || k >= queueptr) {
                        nl(); /* need <cr> */
                        break;
                    }
                    outbyte(','); /* separate bytes */
                }
            }
        }
        //output_section(c_code_section); // output_section("code");
    }
    nl();
}

/*
 * dump zeroes for default initial value
 * (or rather, get loader to do it for us)
 */
int dumpzero(int size, int count)
{
    if (count <= 0)
        return (0);
    defstorage();
    outdec(size * count);
    nl();
    return (size * count);
}

/********************************************************************
 *
 *      Routines to open the assembly and C source files
 *
 ********************************************************************
 */

/*
 *      Get output filename
 */
void openout()
{
    char filen2[FILENAME_LEN + 1];
    char extension[FILENAME_LEN+1];

    snprintf(extension,sizeof(extension),".%s",c_output_extension);
    FILE* fp;
    clear(); /* erase line */
    output = 0; /* start with none */
    if (nextarg(filenum, filen2, FILENAME_LEN) == NULL)
        return;
    if ((fp = fopen(filen2, "r")) == NULL) {
        fprintf(stderr, "Cannot open source file: %s\n", filen2);
        exit(1);
    }
    fclose(fp); /* Close it again... */

    /* copy file name to string */
    strcpy(Filename, filen2);
    strcpy(Filenorig, filen2);
    changesuffix(filen2, extension); /* Change appendix to .asm */
    if ((output = fopen(filen2, "w")) == NULL && (!eof)) {
        fprintf(stderr, "Cannot open output file: %s\n", line);
        exit(1);
    }
    clear(); /* erase line */
}

/*
 *      Get (next) input file
 */
void openin()
{
    input = 0; /* none to start with */
    while (input == 0) { /* any above 1 allowed */
        clear(); /* clear line */
        if (eof)
            break; /* if user said none */
        /* Deleted hopefully irrelevant code */
        if (Filename[0] == '-') {
            if (ncomp == 0)
                info();
            exit(1);
        }
        if ((input = fopen(Filename, "r")) == NULL) {
            fprintf(stderr, "Can't open: %s\n", Filename);
            exit(1);
        } else {
            if (c_verbose)
                fprintf(stderr, "Compiling: %s\n", Filename);
            ncomp++;
            newfile();
        }
    }
    clear(); /* erase line */
}

/*
 *      Reset line count, etc.
 */
void newfile()
{
    lineno = /* no lines read */
        fnstart = /* no fn. start yet. */
        infunc = 0; /* therefore not in fn. */
    currfn = NULL; /* no fn. yet */
}

/*
 *      Open an include file
 */
void doinclude()
{
    char name[FILENAME_LEN + 1], *cp;

    blanks(); /* skip over to name */
    if (c_verbose) {
        toconsole();
        outstr(line);
        nl();
        tofile();
    }

    if (inpt2) {
        error(E_NEST);
    } else {
        /* ignore quotes or angle brackets round file name */
        strcpy(name, line + lptr);
        cp = name;
        if (*cp == '"' || *cp == '<') {
            name[strlen(name) - 1] = '\0';
            ++cp;
        }
        if ((inpt2 = fopen(cp, "r")) == NULL) {
            error(E_INCLUDE);
            closeout();
            exit(1);
        } else {
            saveline = lineno;
            savecurr = currfn;
            saveinfn = infunc;
            savestart = fnstart;
            newfile();
        }
    }
    clear(); /* clear rest of line */
    /* so next read will come from */
    /* new file (if open) */
}

/*
 *      Close an include file
 */
void endinclude()
{
    if (c_verbose) {
        toconsole();
        outstr("#end include\n");
        tofile();
    }

    inpt2 = 0;
    lineno = saveline;
    currfn = savecurr;
    infunc = saveinfn;
    fnstart = savestart;
}

/*
 *      Close the output file
 */
void closeout()
{
    tofile(); /* if diverted, return to file */
    if (output) {
        /* if open, close it */
        fclose(output);
    }
    output = 0; /* mark as closed */
}




static void set_option(option *arg, char *value)
{
    if ( arg->type & OPT_ASSIGN ) {
        if ( arg->type & (OPT_BOOL|OPT_INT) ) {
            *(int *)arg->value = arg->data;
        } else if ( arg->type & OPT_STRING ) {
            *(char *)arg->value = arg->data;
        }
    } else if (arg->type & OPT_OR ) {
            *(int *)arg->value |= arg->data;
    } else if ( arg->type & OPT_FUNCTION ) {
        void (*func)(option *arg, char *type) = arg->value;
        func(arg,value);
    } else if ( arg->type & OPT_BOOL ) {
        int  val = 1;
        if ( value != NULL ) {
            if ( toupper(*value) == 'N' || toupper(*value) == 'F' || *value == '0') {
                val = 0;
            }
        }
        *(int *)arg->value = val;
    } else if ( arg->type & OPT_BOOL_FALSE) {
        *(int *)arg->value = 0;
    } else if ( arg->type & OPT_INT ) {
        *(int *)arg->value = atoi(value);
    } else if ( arg->type & OPT_STRING ) {
        *(char **)arg->value = value;
    } 
}


int parse_arguments(option *args, int argc, char **argv)
{
    int    i;
    int    outargc = 0;

    for ( i = 1; i < argc; i++ ) {
        option *myarg;
        if ( argv[i][0] == '-') {
            char   *argstart = argv[i] + 1;

            /* Swallow the second - option */
            if  ( *argstart == '-' ) {
                argstart++;
            }
            for ( myarg = args ; myarg->description != NULL; myarg++ ) {
                if ( myarg->type & OPT_HEADER ) {
                    continue;
                }
                if ( strlen(argstart) == 1 && *argstart == myarg->short_name ) {
                    char *val = NULL;
                    if ( (myarg->type & (OPT_BOOL|OPT_BOOL_FALSE|OPT_ASSIGN|OPT_OR)) == 0 ) {
                        if ( ++i < argc ) {
                            val = argv[i];
                        } else {
                            fprintf(stderr, "Insufficient number of arguments supplied\n");
                            break;                       
                         }
                    }
                    set_option(myarg, val);
                    break;
                } else if ( myarg->long_name && strncmp(argstart, myarg->long_name, strlen(myarg->long_name)) == 0 ) {
                    char  *val = NULL;
                    if ( argstart[strlen(myarg->long_name)] == '=' ) {
                        val = argstart + strlen(myarg->long_name) + 1;
                    } else {
                        if ( strlen(argstart) > strlen(myarg->long_name) )  {
                             /* Try and take the value after the option (without the = sign) */
                             val = argstart + strlen(myarg->long_name);
                        } else if ( (myarg->type & (OPT_BOOL|OPT_BOOL_FALSE|OPT_ASSIGN|OPT_OR)) == 0 ) {
                            /* Otherwise it's the next argument */
                            if ( ++i < argc ) {
                                val = argv[i];
                            } else {
                                fprintf(stderr, "Insufficient number of arguments supplied\n");
                                break;
                            }
                        }
                    }
                    set_option(myarg, val);
                    break;
                }
            }
            if ( myarg->description == NULL ) {
                fprintf(stderr, "Unknown option %s\n",argv[i]);
            }
        } else {
            /* Copy unswallowed options */
            argv[outargc++] = argv[i];
        }
    }
    return outargc;
}




static void set_math_z88_parameters(option *opt, char *arg)
{
    c_fp_exponent_bias = 127;
    c_fp_mantissa_bytes = 4;
}


void UnSetWarning(option *arg, char* val)
{
    int num;
    num = 0;
    sscanf(val, "%d", &num);
    if (num < W_MAXIMUM)
        mywarn[num].suppress = 1;
}

void SetWarning(option *arg, char* val)
{
    int num;
    num = 0;
    sscanf(val, "%d", &num);
    if (num < W_MAXIMUM)
        mywarn[num].suppress = 0;
}



void SetNoWarn(option *arg, char* val)
{
    int i;
    for (i = 1; i < W_MAXIMUM; i++)
        mywarn[i].suppress = 1;
}

void SetAllWarn(option *arg, char* val)
{
    int i;
    for (i = 1; i < W_MAXIMUM; i++)
        mywarn[i].suppress = 0;
}




void SetDefine(option *arg, char* val)
{
    defmac(val);
}

void SetUndefine(option *arg, char* val)
{
    strcpy(line, val);
    delmac();
}

void SetAssembler(option *arg, char *assembler)
{

    if (strcmp(assembler, "z80asm") == 0 || strcmp(assembler, "mpm") == 0) {
        c_assembler_type = ASM_Z80ASM;
    } else if (strcmp(assembler, "asxx") == 0) {
        c_assembler_type = ASM_ASXX;
    } else if (strcmp(assembler, "vasm") == 0) {
        c_assembler_type = ASM_VASM;
    } else if (strcmp(assembler, "gnu") == 0) {
        c_assembler_type = ASM_GNU;
    }
}


void DispInfo(option *arg, char *val)
{
    option *cur = &sccz80_opts[0];
    info();

    printf("\nOptions:\n\n");

    while (cur->description) {
        if ( cur->type & OPT_HEADER ) {
            fprintf(stderr,"\n%s\n",cur->description);
        } else {
            char    shortopt[6];
            char    longopt[26];
            shortopt[0] = longopt[0] = 0;;
            if ( cur->short_name ) {
                snprintf(shortopt, sizeof(shortopt),"-%c", cur->short_name);
            }
            if ( cur->long_name ) {
                snprintf(longopt, sizeof(longopt),"-%s", cur->long_name);
            }
            fprintf(stderr,"%5s %-25s %s\n",shortopt,longopt,cur->description);
        }
        cur++;
    }
    exit(1);
}

void DispVersion(char* arg)
{
    info();
    exit(1);
}




/*
 *      This routine called via atexit to clean up memory
 */

void atexit_deallocate()
{
    FREENULL(litq);
    FREENULL(dubq);
    FREENULL(tempq);
    FREENULL(glbq);
    FREENULL(loctab);
    FREENULL(wqueue);
    FREENULL(tagtab);
    FREENULL(membtab);
    FREENULL(swnext);
    FREENULL(stage);
    FREENULL(gotoq);
}

void* mymalloc(size_t size)
{
    void* ptr;

    if ((ptr = calloc(size, 1)) != NULL)
        return ptr;
    else {
        fprintf(stderr, "Out of memory...\n");
        exit(1);
    }
    return 0; /* Sigh */
}
