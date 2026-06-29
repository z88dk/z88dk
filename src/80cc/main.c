/*
 *      Small C+ Compiler -
 *
 *      Main() part
 *
 */

#include "../config.h"
#include "ccdefs.h"
#include "tokeniser.h"

#if defined(__MSDOS__) && defined(__TURBOC__)
extern unsigned _stklen = 8192U; /* Default stack size 4096 bytes is too small. */
#endif

static char   *c_output_extension = "asm";
static char   *c_output_file = NULL;
static char    c_debug_adb_file = 0;
static char    c_debug_adb_defc = 0;
       char    c_debug_entry_points = 0;
int     c_banked_style = BANKED_STYLE_REGULAR;


static int      gargc; /* global copies of command line args */
static char   **gargv;
static int      filenum; /* next argument to be used */

UT_string       *debug_utstr;
UT_string       *debug2_utstr;

static Type *type_double4 = &(Type){ KIND_DOUBLE, 4, 0, .len=1 }; 
static Type *type_double8 = &(Type){ KIND_DOUBLE, 8, 0, .len=1 }; 

char Filenorig[FILENAME_LEN + 1];


int c_notaltreg; /* No alternate registers */
/* Inert — tokeniser handles escapes per the C standard
   unconditionally. Retained as an accepted option for backwards
   command-line compatibility. */
int c_standard_escapecodes = 0;
int c_disable_builtins = 0;
int c_cline_directive = 0;
int c_cpu = CPU_Z80;
int c_params_offset = 2;
int c_old_diagnostic_fmt = 0;
/* The legacy emit-while-parsing path was removed in Phase H step 2.
   AST codegen via ast_codegen2.c is the only code generation mode.
   The shell ships the previous binary as the escape hatch if
   someone needs the old behaviour. */
int c_ast_print = 0;         /* 1 = print the AST per function and skip codegen */
int c_ast_print_types = 0;   /* 1 = decorate print_ast output with type info */
int c_use_ir = 0;            /* 1 = route function codegen through ir_build → ir_lower */
char *c_zcc_opt = "zcc_opt.def";

/* Settings for genmath + math48 */
int c_fp_mantissa_bytes = 5;
int c_fp_exponent_bias = 128;
int c_fp_fudge_offset = 0;    // Fudge offset for z88math - it starts pickup from FA+1
int c_fp_size = 6;

enum maths_mode c_maths_mode = MATHS_Z80;

uint32_t c_speed_optimisation = OPT_RSHIFT32|OPT_LSHIFT32;
uint32_t c_opt_disable = 0;

char *c_rodata_section = "rodata_compiler";
char *c_data_section = "data_compiler";
char *c_bss_section = "bss_compiler";
char *c_code_section = "code_compiler";
char *c_init_section = "code_crt_init";
char *c_home_section = "code_home";

#include "option.h"



static void dumpsymdebug(void);
static void dumpdebug(void);
static void dumpfns(void);
static void dumpvars(void);
static void parse(void);
static void errsummary(void);
static char *nextarg(int n, char *s, int size);
static void setup_sym(void);
static void info(void);
static void openout(void);

static void SetWarning(option *arg, char* val);
static void SetDefine(option *arg, char *val);
static void SetUndefine(option *arg, char *val);
static void SetIncludePath(option *arg, char *val);
static void DispInfo(option *arg, char *val);
static void opt_code_speed(option *arg, char* val);
static void opt_disable(option *arg, char *val);
static void atexit_deallocate(void);


static option  sccz80_opts[] = {
    { 'v', "verbose", OPT_BOOL, "Be verbose", &c_verbose, NULL, 0 },
    { 'h', "help", OPT_FUNCTION|OPT_BOOL, "Show this help page", NULL, DispInfo, 0 },
    { 'o', "output", OPT_STRING, "Set the output filename", &c_output_file, NULL, 0 },
    { 0, "", OPT_HEADER, "CPU Targetting:", NULL, NULL, 0 },
    { 0, "m8080", OPT_ASSIGN|OPT_INT, "Generate output for the i8080", &c_cpu, NULL, CPU_8080 },
    { 0, "m8085", OPT_ASSIGN|OPT_INT, "Generate output for the i8085", &c_cpu, NULL, CPU_8085 },
    { 0, "mez80_z80", OPT_ASSIGN|OPT_INT, "Generate output for the ez80 in z80 mode", &c_cpu, NULL, CPU_EZ80_Z80 },
    { 0, "mz80", OPT_ASSIGN|OPT_INT, "Generate output for the z80", &c_cpu, NULL, CPU_Z80 },
    { 0, "mz80n", OPT_ASSIGN|OPT_INT, "Generate output for the z80n", &c_cpu, NULL, CPU_Z80N },
    { 0, "mz180", OPT_ASSIGN|OPT_INT, "Generate output for the z180", &c_cpu, NULL, CPU_Z180 },
    { 0, "mr2ka", OPT_ASSIGN|OPT_INT, "Generate output for the Rabbit 2000A", &c_cpu, NULL, CPU_R2KA },
    { 0, "mr3k", OPT_ASSIGN|OPT_INT, "Generate output for the Rabbit 3000", &c_cpu, NULL, CPU_R3K },
    { 0, "mr4k", OPT_ASSIGN|OPT_INT, "Generate output for the Rabbit 4000", &c_cpu, NULL, CPU_R4K },
    { 0, "mr6k", OPT_ASSIGN|OPT_INT, "Generate output for the Rabbit 4000", &c_cpu, NULL, CPU_R4K|CPU_R6K },
    { 0, "mgbz80", OPT_ASSIGN|OPT_INT, "Generate output for the Gameboy CPU", &c_cpu, NULL, CPU_GBZ80 },
    { 0, "mkc160", OPT_ASSIGN|OPT_INT, "Generate output for the KC160", &c_cpu, NULL, CPU_KC160 },
    { 0, "", OPT_HEADER, "Code generation options", NULL, NULL, 0 },
    { 0, "unsigned", OPT_BOOL, "Make all types unsigned", &c_default_unsigned, NULL, 0 },
    { 0, "disable-builtins", OPT_BOOL|OPT_DOUBLE_DASH, "Disable builtin functions",&c_disable_builtins, NULL, 0},
    { 0, "params-offset", OPT_INT, "=<num> Base offset for the function parameters (default: 2)",&c_params_offset,NULL, 0},
    { 0, "doublestr", OPT_BOOL, "Store FP constants as strings", &c_double_strings, NULL, 0 },
    { 0, "math-z88", OPT_ASSIGN|OPT_INT, "(deprecated) Make FP constants match z88", &c_maths_mode, NULL, MATHS_Z88 },
    { 0, "banked-style=regular", OPT_ASSIGN|OPT_INT, "Use regular banked calling style", &c_banked_style, NULL, BANKED_STYLE_REGULAR },
    { 0, "banked-style=ti", OPT_ASSIGN|OPT_INT, "Use ticalc banked calling style", &c_banked_style, NULL, BANKED_STYLE_TICALC },
    
    { 0, "fp-exponent-bias", OPT_INT, "=<num> FP exponent bias (default: 128)", &c_fp_exponent_bias, NULL, 0 },
    { 0, "fp-mantissa-size", OPT_INT, "=<num> FP mantissa size (default: 5 bytes)", &c_fp_mantissa_bytes, NULL, 0 },
    { 0, "fp-mode=z80", OPT_ASSIGN|OPT_INT, "Use 48 bit doubles", &c_maths_mode, NULL, MATHS_Z80 },
    { 0, "fp-mode=ieee", OPT_ASSIGN|OPT_INT, "Use 32 bit IEEE doubles", &c_maths_mode, NULL, MATHS_IEEE },
    { 0, "fp-mode=mbf32", OPT_ASSIGN|OPT_INT, "Use 32 bit Microsoft Binary format", &c_maths_mode, NULL, MATHS_MBFS },
    { 0, "fp-mode=mbf40", OPT_ASSIGN|OPT_INT, "Use 40 bit Microsoft binary format", &c_maths_mode, NULL, MATHS_MBF40 },
    { 0, "fp-mode=mbf64", OPT_ASSIGN|OPT_INT, "Use 64 bit Microsoft binary format", &c_maths_mode, NULL, MATHS_MBF64 },
    { 0, "fp-mode=z88", OPT_ASSIGN|OPT_INT, "Use 40 bit z88 doubles", &c_maths_mode, NULL, MATHS_Z88 },
    { 0, "fp-mode=am9511", OPT_ASSIGN|OPT_INT, "Use 32 bit AM9511 doubles", &c_maths_mode, NULL, MATHS_AM9511 },
    
    { 0, "noaltreg", OPT_BOOL, "Try not to use the alternative register set", &c_notaltreg, NULL, 0 },
    { 0, "standard-escape-chars", OPT_BOOL, "Use standard mappings for \\r and \\n (inert — escapes are always standard)", &c_standard_escapecodes, NULL, 0},
    { 0, "set-r2l-by-default", OPT_BOOL, "Use r->l calling convention by default", &c_use_r2l_calling_convention, NULL, 0 },
    { 0, "constseg", OPT_STRING|OPT_DOUBLE_DASH, "=<name> Set the const section name", &c_rodata_section, NULL, 0 },
    { 0, "codeseg", OPT_STRING|OPT_DOUBLE_DASH, "=<name> Set the code section name", &c_code_section, NULL, 0 },
    { 0, "bssseg", OPT_STRING|OPT_DOUBLE_DASH, "=<name> Set the bss section name", &c_bss_section, NULL, 0 },
    { 0, "dataseg", OPT_STRING|OPT_DOUBLE_DASH, "=<name> Set the data section name", &c_data_section, NULL, 0 },
    { 0, "initseg", OPT_STRING|OPT_DOUBLE_DASH, "=<name> Set the initialisation section name", &c_init_section, NULL, 0 },
    { 0, "gcline", OPT_BOOL, "Generate C_LINE directives", &c_cline_directive, NULL, 0 },
    { 0, "opt-code-speed", OPT_FUNCTION|OPT_STRING|OPT_DOUBLE_DASH, "Optimise for speed not size", NULL, opt_code_speed, 0},
    { 0, "opt-disable", OPT_FUNCTION|OPT_STRING|OPT_DOUBLE_DASH, "=<list> Disable named AST optimiser passes (comma-separated). Names: all, fold, prop, simplify, typecheck, compoundify, strength-reduce, cse, cse-synth, licm, dse, dead-code, thread-jumps, demote-poststep, loop-reverse. Useful for bisecting miscompiles.", NULL, opt_disable, 0 },
    { 0, "ast-print", OPT_BOOL|OPT_DOUBLE_DASH, "(experimental) Build the AST per function, print it to stderr, and skip code generation", &c_ast_print, NULL, 0 },
    { 0, "ast-print-types", OPT_BOOL|OPT_DOUBLE_DASH, "(experimental) Decorate the AST print with type/qualifier/attribute info; implies --ast-print", &c_ast_print_types, NULL, 0 },
    { 0, "use-ir", OPT_BOOL|OPT_DOUBLE_DASH, "(experimental) Route function codegen through the new IR pipeline (ir_build → ir_lower). Phase 1 — most C constructs unsupported", &c_use_ir, NULL, 0 },
    { 0, "", OPT_HEADER, "Framepointer configuration (for debugging):", NULL, NULL, 0 },
    { 0, "frameix", OPT_ASSIGN|OPT_INT, "Use ix as the frame pointer", &c_framepointer_is_ix, NULL, 1},
    { 0, "frameiy", OPT_ASSIGN|OPT_INT, "Use iy as the frame pointer", &c_framepointer_is_ix, NULL, 0},
    { 0, "zcc-opt", OPT_STRING, "Location for zcc_opt.def", &c_zcc_opt, NULL, (intptr_t)(void *)"zcc_opt.def"},

    { 0, "", OPT_HEADER, "Error/warning handling:", NULL, NULL, 0 },
    { 0, "stop-on-error", OPT_BOOL, "Stop on any error", &c_errstop, NULL, 0 },
    { 0, "old-diagnostic-format", OPT_BOOL|OPT_DOUBLE_DASH, "Use old style diagnostic messages", &c_old_diagnostic_fmt, NULL, 0 },
#if 0
    { 0, "Wnone", OPT_FUNCTION|OPT_BOOL, "Disable all warnings", NULL, SetNoWarn, 0 },
    { 0, "Wall", OPT_FUNCTION|OPT_BOOL, "Enable all warnings", NULL, SetAllWarn, 0 },
    { 0, "Wn", OPT_FUNCTION, "<num> Disable a warning", NULL, UnSetWarning, 0},
#endif
    { 0, "W", OPT_FUNCTION, "<type> Enable a class of warnings", NULL,  SetWarning, 0 },
    { 0, "", OPT_HEADER, "Debugging options", NULL, NULL, 0 },
    { 0, "debug-sect", OPT_BOOL, "Create adb/cdb debug section", &c_debug_adb_file, NULL, 0 },
    { 0, "debug-defc", OPT_BOOL, "Create adb/cdb debug defc", &c_debug_adb_defc, NULL, 0 },
    { 0, "cc", OPT_BOOL, "Intersperse the assembler output with the source C code", &c_intermix_ccode, NULL, 0 },
    { 0, "intlog", OPT_INT, "=<val> Enable some extra logging", &debuglevel, NULL, 0 },
    { 0, "ext", OPT_STRING, "=<ext> Set the file extension for the generated output", &c_output_extension, NULL, 0 },
    { 0, "D", OPT_FUNCTION, "Define a preprocessor directive", NULL, SetDefine, 0 },
    { 0, "U", OPT_FUNCTION, "Undefine a preprocessor directive", NULL, SetUndefine, 0 },
    { 0, "I", OPT_FUNCTION, "Add an include path (forwarded to the preprocessor)", NULL, SetIncludePath, 0 },
    { 0, "c1mode", OPT_BOOL|OPT_DOUBLE_DASH, "Input is already preprocessed; skip the internal ucpp invocation", &c_c1mode, NULL, 0 },
    { 0, "lex-only", OPT_BOOL|OPT_DOUBLE_DASH, "Dump token stream from the internal tokeniser to stdout and exit (Phase L2)", &c_lex_only, NULL, 0 },
    { 0, "cpp", OPT_STRING|OPT_DOUBLE_DASH, "=<path> Override the preprocessor binary (default z88dk-ucpp)", &c_cpp_exe, NULL, 0 },
    { 0, "", OPT_HEADER, "Assignments can either be = or as next argument", NULL, NULL, 0},
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

    swnext = MALLOC(NUMCASE * sizeof(SW_TAB));
    swend = swnext + (NUMCASE - 1);

    glbcnt = 0; /* clear global symbols */
    locptr = STARTLOC; /* clear local symbols */
    wqptr = wqueue; /* clear while queue */
    gltptr = 0; /* clear literal pools */
    *litq = 0; /* First entry in literal queue is zero */
    litptr = 1; /* So miniprintf search works */

    Zsp = /* stack ptr (relative) */
        errcnt = /* no errors */
        c_errstop = /* keep going after an error */
        eof = /* not eof yet */
        ncmp = /* no open compound states */
        lastst = /* not first file to asm */
        lineno = /* no lines read from file */
        infunc = /* not in function now */
        0; /*  ...all set to zero.... */

    input = /* no input file */
        saveout = /* no diverted output */
        output = NULL; /* no open units */

    currfn = NULL; /* no function yet */
    cmode = 1; /* enable preprocessing-aware lex (whitespace/include handling) */
    ncomp = need_floatpack = 0;
    c_default_unsigned = NO;
    nxtlab = 0;/* start numbers at lowest possible */
    c_intermix_ccode = 0; /* don't include the C text as comments */
    c_errstop =0;  /* don't stop after errors */
    c_verbose = 0;
    c_double_strings = 0;
    c_notaltreg = NO;
    debuglevel = NO;
    c_framepointer_is_ix = -1;
    c_use_r2l_calling_convention = NO;

    /* The tokeniser singleton is shared across the whole process —
       setup_sym() feeds synthetic `#define` lines (Z80, SMALL_C)
       through the parser before any source file is open, so it
       must exist now. The filename is just a label for diagnostics;
       it's overwritten per-file once compilation starts. */
    current_tokeniser = tk_new_buffer("<command-line>", NULL, NULL);

    setup_sym(); /* define some symbols */
    /* Parse the command line options */
    atexit(atexit_deallocate); /* To free everything */
    clear();
    filenum = 0;
    gargc = option_parse(sccz80_opts, argc, argv);
    clear();

    if (gargc == 0) {
        info();
        exit(1);
    }

    if ( c_maths_mode == MATHS_IEEE ) {
        c_fp_size = 4;
        type_double = type_double4;
        c_fp_exponent_bias = 126;
        c_fp_mantissa_bytes = 3;
        WriteDefined("CLIB_32BIT_FLOATS", 1);
    } else if ( c_maths_mode == MATHS_MBFS ) {
        c_fp_size = 4;
        type_double = type_double4;
        c_fp_exponent_bias = 128;
        c_fp_mantissa_bytes = 3;
        WriteDefined("CLIB_32BIT_FLOATS", 1);
    } else if ( c_maths_mode == MATHS_MBF40 ) {
        c_fp_exponent_bias = 128;
        c_fp_mantissa_bytes = 4;
    } else if ( c_maths_mode == MATHS_MBF64 ) {
        c_fp_size = 8;
        type_double = type_double8;
        c_fp_exponent_bias = 128;
        c_fp_mantissa_bytes = 7;
        WriteDefined("CLIB_64BIT_FLOATS", 1);
    } else if ( c_maths_mode == MATHS_Z88 ) {
        c_fp_exponent_bias = 127;
        c_fp_mantissa_bytes = 4;
        c_fp_fudge_offset = 1;
    } else if ( c_maths_mode == MATHS_AM9511 ) {
        type_double = type_double4;
        c_fp_exponent_bias = 0;
        c_fp_mantissa_bytes = 3;
        c_fp_size = 4;
    }

    if ( c_debug_adb_file || c_debug_adb_defc ) {
        c_cline_directive = 1;
        if ( c_framepointer_is_ix == -1 ) {
            c_debug_entry_points = 1;
        }
    }


    if ( c_cpu == CPU_8080 ) {
        c_notaltreg = 1;
        c_framepointer_is_ix = -1;   /* no IX/IY on 8080 */
        WriteDefined("CPU_8080", 1);
    }

    if ( c_cpu == CPU_8085 ) {
        c_notaltreg = 1;
        c_framepointer_is_ix = -1;   /* no IX/IY on 8085 */
        WriteDefined("CPU_8085", 1);
    }

    if ( c_cpu == CPU_GBZ80 ) {
        c_notaltreg = 1;
        c_framepointer_is_ix = -1;   /* no IX/IY on GBZ80 */
        WriteDefined("CPU_GBZ80", 1);
    }

    utstring_new(debug_utstr);
    utstring_new(debug2_utstr);

    litlab = getlabel(); /* Get labels for function lits*/
    openout(); /* get the output file */
    openin(); /* and initial input file */
    gen_file_header(); /* intro code */
    parse(); /* process ALL input */




    gen_switch_section(c_bss_section);
    gen_switch_section(c_code_section);
    outstr("; --- Start of Optimiser additions ---\n\n");
    /* dump literal queues, with label */
    /* litq starts from 1, so literp has to be -1 */
    dumplits(0, YES, litptr - 1, litlab, litq + 1);
    write_constant_queue();
    dumpvars();
    dumpfns();

    if ( c_debug_adb_defc ) {
        dumpsymdebug();
    }
    if ( c_debug_adb_file ) {
        dumpdebug();
    }

    gen_file_footer(); /* follow-up code */
    closeout();
    errsummary(); /* summarize errors */
    if (errcnt)
        exit(1);
    exit(0);
}

/*
 *      Abort compilation
 */
void ccabort(void)
{
    if (input != NULL) {
        if (input_is_pipe) cpp_close(input);
        else               fclose(input);
        input = NULL;
    }
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
void parse(void)
{
    while (eof == 0) { /* do until no more input */
        if (swallow(KW_EXTERN)) {
            dodeclare(EXTERNAL);
        } else if (swallow(KW_STATIC)) {
            dodeclare(LSTATIC);
        } else if (swallow(KW_TYPEDEF)) {
            dodeclare(TYPDEF);
        } else if (dodeclare(STATIK)) {
            ;
        } else if ( swallow(KW_ADDRESSMOD)) {
            parse_addressmod();
        } else if (ch() == '#') {
            if (match("#asm")) {
                doasm();
            } else {
                clear();
                blanks();
            }
        } else {
            declare_func_kr();
        }
        blanks(); /* force eof if pending */
    }
}

/*
 *      Report errors for user
 */
void errsummary(void)
{
    /* see if anything left hanging... */
    if (ncmp) {
        errorfmt("Missing closing bracket", 0);
        nl();
    }
    if (c_verbose) {
        printf("Symbol table usage: %d\n", glbcnt);
        // printf("Structures defined: %ld\n", (long)(tagptr - tagtab));
        // printf("Members defined:    %ld\n", (long)(membptr - membtab));
        // printf("There %s %d %s in compilation.\n", (errcnt == 1 ? "was" : "were"), errcnt, (errcnt == 1 ? "error" : "errors"));
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

void setup_sym(void)
{
    /* Always-on macros: forwarded to the preprocessor so `#ifdef
       Z80` / `#ifdef SMALL_C` work in user code. sccz80 itself no
       longer maintains a macro table — ucpp handles all expansion
       and conditional compilation upstream. */
    cpp_add_arg("-DZ80");
    cpp_add_arg("-DSMALL_C");

    addglb("asm", asm_function("asm"), 0, KIND_LONG, 0, LSTATIC);
    addglb("__asm__", asm_function("__asm__"), 0, KIND_LONG, 0, LSTATIC);
}

void info(void)
{
    fputs(titlec, stderr);
    fputs(Version, stderr);
    fputs("\n(C) 1980-2026 Cain, Van Zandt, Hendrix, Yorston, z88dk\n", stderr);
    fprintf(stderr, "Usage: %s [flags] [file]\n", gargv[0]);
}


static void dumpdebug(void)
{
    const char *debug = utstring_body(debug_utstr);
    const char *end = NULL;

    gen_switch_section("__ADBDEBUG");
    while ( ( end = strchr(debug,'\n')) != NULL ) {
        defmesg();
        outfmt("%.*s\\n\"\n", end - debug, debug);
        debug = end+1;        
    }
}

static void dumpsymdebug(void)
{
    const char *debug = utstring_body(debug2_utstr);
    const char *end = NULL;

    while ( ( end = strchr(debug,'\n')) != NULL ) {
        outfmt("%.*s\n", end - debug, debug);
        debug = end+1;        
    }
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

static void dumpfns(void)
{
    int type, storage;
    SYMBOL* ptr;
    FILE* fp;

    outstr("\n\n; --- Start of Scope Defns ---\n\n");

    if (!glbcnt)
        return;

    for ( ptr = symtab; ptr != NULL; ptr = ptr->hh.next ) {
        if (ptr->name[0] != '0' && ptr->ctype ) {
            type = ptr->type;
            storage = ptr->storage;
            if ( type == KIND_ENUM )
                continue;
            if (ptr->ctype->kind == KIND_PORT8 || ptr->ctype->kind == KIND_PORT16 ) {
                outfmt("\tdefc\t_%s =\t%d\n", ptr->name, ptr->ctype->value);
            } else {
                if ( storage != LSTATIC && storage != TYPDEF ) {
                    GlobalPrefix();                    
                    outname(ptr->name, dopref(ptr)); nl();
                    debug_write_symbol(ptr);
                    if ( ptr->ctype->flags & BANKED && c_banked_style == BANKED_STYLE_TICALC) {
                         GlobalPrefix();
                         outstr(BANKED_SYMBOL_PREFIX);
                         outname(ptr->name, dopref(ptr)); nl();
                    }
                }
                if ( ptr->flags & ASSIGNED_ADDR ) {
                    outfmt("\tdefc\t"); outname(ptr->name,1); outfmt("\t= %d\n", ptr->ctype->value);
                } 
            }
        }
    }

    if ((fp = fopen(c_zcc_opt, "a")) == NULL) {
        errorfmt("Can't open zcc_opt.def file", 1);
    }

    if (need_floatpack) {
        fprintf(fp, "\nIF !NEED_floatpack\n");
        fprintf(fp, "\tDEFINE\tNEED_floatpack\n");
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

    if ((fp = fopen(c_zcc_opt, "a")) == NULL) {
        errorfmt("Can't open zcc_opt.def file", 1);
    }
    fprintf(fp, "\nIF !DEFINED_%s\n", sname);
    fprintf(fp, "\tdefc\tDEFINED_%s = 1\n", sname);
    fprintf(fp, "\tdefc %s = %d\n", sname, value);
    fprintf(fp, "ENDIF\n\n");
    fclose(fp);
}

/*
 */
void dumpvars(void)
{
    int ident, type, storage;
    SYMBOL* ptr;

    if (!glbcnt)
        return;

    /* Start at the start! */
    outstr("; --- Start of Static Variables ---\n\n");

    gen_switch_section(c_bss_section); // gen_switch_section("bss");

    for ( ptr = symtab; ptr != NULL; ptr = ptr->hh.next ) {
        if (ptr->name[0] != '0' ) {
            ident = ptr->ident;
            type = ptr->ctype ? ptr->ctype->kind : KIND_NONE;
            storage = ptr->storage;
            if ( ptr->initialised )
                continue;
            if ( ident == ID_ENUM || ident == ID_GOTOLABEL )
                continue;
            if ( type == KIND_FUNC || type == KIND_PORT8 || type == KIND_PORT16 )
                continue;
            if ( storage == TYPDEF ||  storage == EXTERNAL ) 
                continue;
            if ( type == KIND_ENUM )
                continue;
            if ( ptr->ctype->size == -1 )
                continue;
            if ( ptr->bss_section ) gen_switch_section(ptr->bss_section);
            prefix();
            outname(ptr->name, 1);
            col();
            defstorage();
            outdec(ptr->ctype->size);
            nl();
        }
    }

    /* Switch back to standard section */
    gen_switch_section(c_code_section); // gen_switch_section("code");
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
            gen_switch_section(c_rodata_section); // gen_switch_section("text");
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
            } else if ( size == 8 ) {
                defbyte();
                j = 8;
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
        //gen_switch_section(c_code_section); // gen_switch_section("code");
    }
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
void openout(void)
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

    if ( c_output_file != NULL ) {
        if ((output = fopen(c_output_file, "w")) == NULL && (!eof)) {
            fprintf(stderr, "Cannot open output file: %s\n", line);
            exit(1);
        }
    } else {
        strcpy(Filenorig, filen2);
        changesuffix(filen2, extension); /* Change appendix to .asm */
        if ((output = fopen(filen2, "w")) == NULL && (!eof)) {
            fprintf(stderr, "Cannot open output file: %s\n", line);
            exit(1);
        }
    }
    clear(); /* erase line */
}

/*
 *      Get (next) input file
 */
void openin(void)
{
    input = NULL; /* none to start with */
    while (input == NULL) { /* any above 1 allowed */
        clear(); /* clear line */
        if (eof)
            break; /* if user said none */
        /* Deleted hopefully irrelevant code */
        if (Filename[0] == '-') {
            if (ncomp == 0)
                info();
            exit(1);
        }
        /* Phase L1: when the input is a raw `.c` file (no --c1mode),
           spawn the preprocessor and read its stdout off a pipe.
           In --c1mode (typical driver-managed flow), open the file
           directly — the driver already ran ucpp. */
        if (c_c1mode) {
            if ((input = fopen(Filename, "r")) == NULL) {
                fprintf(stderr, "Can't open: %s\n", Filename);
                exit(1);
            }
            input_is_pipe = 0;
        } else {
            input = cpp_open(c_cpp_exe, Filename);
            if (input == NULL)
                exit(1);
            input_is_pipe = 1;
        }
        /* Phase L2: --lex-only drives the internal tokeniser over the
           preprocessed stream and dumps tokens to stdout. Bypasses
           the parser entirely. */
        if (c_lex_only) {
            Tokeniser *tk = tk_new(input, Filename);
            if (tk) {
                tk_dump_stream(tk, stdout);
                tk_free(tk);
            }
            if (input_is_pipe) cpp_close(input);
            else               fclose(input);
            exit(0);
        }
        /* Per-file tokeniser reset. The singleton is allocated once
           up at startup so setup_sym()'s synthetic `#define` lines
           have a buffer to feed; for each new source file we tear
           it down and re-allocate to clear lex state. */
        if (current_tokeniser) tk_free(current_tokeniser);
        current_tokeniser = tk_new_buffer(Filename, NULL, NULL);
        {
            unsigned char bombuf[4];
            unsigned char utf8bom[] = { 0xef, 0xbb, 0xbf };
            if (c_verbose)
                fprintf(stderr, "Compiling: %s\n", Filename);
            ncomp++;
            /* BOM-strip is only meaningful on a fopen'd file — pipes
               from ucpp never emit a BOM. (void)! to suppress warn
               unused result. */
            if (!input_is_pipe) {
                (void) !fread(bombuf, sizeof(char), 3, input);
                if ( memcmp(bombuf, utf8bom, 3) ) {
                    rewind(input);
                }
            }

            newfile();
        }
    }
    clear(); /* erase line */
}

/*
 *      Reset line count, etc.
 */
void newfile(void)
{
    lineno = /* no lines read */
        infunc = 0; /* therefore not in fn. */
    currfn = NULL; /* no fn. yet */
}

/*
 *      Close the output file
 */
void closeout(void)
{
    tofile(); /* if diverted, return to file */
    if (output) {
        /* if open, close it */
        fclose(output);
    }
    output = 0; /* mark as closed */
}




static void opt_code_speed(option *arg, char* val)
{
    char   *ptr = val - 1;

    c_speed_optimisation = 0;

    do {
        ptr++;
        if ( strncmp(ptr,"all",3) == 0 ) {
            c_speed_optimisation = ~0;
            break;
        } else if ( strncmp(ptr, "lshift32", 8) == 0 ) {
            c_speed_optimisation |= OPT_LSHIFT32;
        } else if ( strncmp(ptr, "rshift32", 8) == 0 ) {
            c_speed_optimisation |= OPT_RSHIFT32;
        } else if ( strncmp(ptr, "add32", 5) == 0 ) {
            c_speed_optimisation |= OPT_ADD32;
        } else if ( strncmp(ptr, "sub32", 5) == 0 ) {
            c_speed_optimisation |= OPT_SUB32;
        } else if ( strncmp(ptr, "sub16", 5) == 0 ) {
            c_speed_optimisation |= OPT_SUB16;
        } else if ( strncmp(ptr, "intcompare", 10) == 0 ) {
            c_speed_optimisation |= OPT_INT_COMPARE;
        } else if ( strncmp(ptr, "charcompare", 10) == 0 ) {
            c_speed_optimisation |= OPT_CHAR_COMPARE;
        } else if ( strncmp(ptr, "longcompare", 11) == 0 ) {
            c_speed_optimisation |= OPT_LONG_COMPARE;
        } else if ( strncmp(ptr, "ucharmult", 9) == 0 ) {
            c_speed_optimisation |= OPT_UCHAR_MULT;
        } else if ( strncmp(ptr, "floatconst", 10) == 0 ) {
            c_speed_optimisation |= OPT_DOUBLE_CONST;
        }
    } while ( (ptr = strchr(ptr, ',')) != NULL );
}



/* Parse --opt-disable=<csv> into the c_opt_disable bitmask. Each name
   in the list flips one bit; the special name "all" sets all bits.
   Unknown names are silently ignored — preserves forward compatibility
   when a pass gets renamed/removed. Match strings are prefix-tested
   against the longest distinguishing prefix so that e.g. "dead-code"
   doesn't get clobbered by a future "dead-store" name. */
static const struct { const char *name; uint32_t bit; } opt_disable_names[] = {
    { "all",             OPT_DISABLE_ALL },
    { "fold",            OPT_DISABLE_FOLD },
    { "prop",            OPT_DISABLE_PROP },
    { "simplify",        OPT_DISABLE_SIMPLIFY },
    { "typecheck",       OPT_DISABLE_TYPECHECK },
    { "compoundify",     OPT_DISABLE_COMPOUNDIFY },
    { "strength-reduce", OPT_DISABLE_STRENGTH_REDUCE },
    { "cse-synth",       OPT_DISABLE_CSE_SYNTH }, /* longer prefix first */
    { "cse",             OPT_DISABLE_CSE },
    { "licm",            OPT_DISABLE_LICM },
    { "dse",             OPT_DISABLE_DSE },
    { "dead-code",       OPT_DISABLE_DEAD_CODE },
    { "thread-jumps",    OPT_DISABLE_THREAD_JUMPS },
    { "demote-poststep", OPT_DISABLE_DEMOTE_POSTSTEP },
    { "loop-reverse",    OPT_DISABLE_LOOP_REVERSE },
};

static void opt_disable(option *arg, char *val)
{
    (void)arg;
    if (!val) return;
    char *ptr = val;
    while (*ptr) {
        /* Skip leading separators. */
        while (*ptr == ',' || *ptr == ' ') ptr++;
        if (!*ptr) break;
        size_t matched = 0;
        for (size_t i = 0; i < sizeof(opt_disable_names)/sizeof(opt_disable_names[0]); i++) {
            size_t n = strlen(opt_disable_names[i].name);
            if (strncmp(ptr, opt_disable_names[i].name, n) == 0
                && (ptr[n] == 0 || ptr[n] == ',' || ptr[n] == ' ')) {
                c_opt_disable |= opt_disable_names[i].bit;
                matched = n;
                break;
            }
        }
        if (matched == 0) {
            /* Unknown — advance to next separator. */
            while (*ptr && *ptr != ',' && *ptr != ' ') ptr++;
        } else {
            ptr += matched;
        }
    }
}

void SetDefine(option *arg, char* val)
{
    /* Forward to the preprocessor — ucpp owns macro expansion. */
    char buf[512];
    snprintf(buf, sizeof(buf), "-D%s", val);
    cpp_add_arg(buf);
}

void SetUndefine(option *arg, char* val)
{
    char buf[512];
    snprintf(buf, sizeof(buf), "-U%s", val);
    cpp_add_arg(buf);
}

void SetIncludePath(option *arg, char *val)
{
    /* sccz80's own #include is rarely used now (ucpp handles
       includes upstream when not in c1mode), so we just forward.
       In c1mode this is a no-op since no preprocessor runs. */
    char buf[1024];
    snprintf(buf, sizeof(buf), "-I%s", val);
    cpp_add_arg(buf);
}


void SetWarning(option *arg, char *value) 
{
    parse_warning_option(value);
}


void DispInfo(option *arg, char *val)
{
    option *cur = &sccz80_opts[0];
    info();

    option_list(cur);

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

void atexit_deallocate(void)
{
    FREENULL(litq);
    FREENULL(dubq);
    FREENULL(tempq);
    FREENULL(glbq);
    FREENULL(loctab);
    FREENULL(wqueue);
//    FREENULL(swnext);
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

