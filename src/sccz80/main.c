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

static char   *c_output_extension = ".asm";


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

char *c_rodata_section = "rodata_compiler";
char *c_data_section = "data_compiler";
char *c_bss_section = "bss_compiler";
char *c_code_section = "code_compiler";

/*
 * Some external data
 */

static void dumpfns(void);
static void dumpvars(void);
static void DispVersion(char*);
static void SetMakeShared(char*);
static void SetUseShared(char*);
static void SetAssembler(char* arg);
static void SetOutExt(char* arg);
static void parse(void);
static void errsummary(void);
static char *nextarg(int n, char *s, int size);
static void setup_sym(void);
static void info(void);
static void openout(void);
static void set_cpu(char *arg);
static void SetNoWarn(char *arg);
static void SetMathZ88(char *arg);
static void SetUnsigned(char *arg);
static void SetDoInline(char *arg);
static void SetStopError(char *arg);
static void SetCompactCode(char *arg);
static void SetCCode(char *arg);
static void SetDefine(char *arg);
static void SetUndefine(char *arg);
static void DispInfo(char *arg);
static void SetVerbose(char *arg);
static void UnSetWarning(char *arg);
static void SetWarning(char *arg);
static void SetAllWarn(char *arg);
static void SetShareOffset(char *);
static void SetDoubleStrings(char *);
static void SetNoAltReg(char *);
static void SetSharedFile(char *);
static void SetDebug(char *);
static void SetASXX(char *);
#ifdef USEFRAME
static void SetFrameIX(char *);
static void SetFrameIY(char *);
static void SetNoFrame(char *);
#endif
static void SetStandardEscape(char *);
static void set_default_r2l(char *arg);
static void atexit_deallocate(void);
static void set_rodata_section(char *arg);
static void set_data_section(char *arg);
static void set_code_section(char *arg);
static void set_bss_section(char *arg);


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
    int n; /* Loop counter */
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
    c_framepointer_is_ix = YES;
    c_useframepointer = NO;
    c_use_r2l_calling_convention = NO;

    setup_sym(); /* define some symbols */
    /* Parse the command line options */
    atexit(atexit_deallocate); /* To free everything */
    clear();
    filenum = 0;
    for (n = 1; n < argc; n++) {
        if (argv[n][0] == '-')
            ParseArgs(1 + argv[n]);
        else {
            filenum = n;
            break;
        }
    }
    clear();

    if (filenum == 0) {
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

    if (n < 1 || n >= gargc)
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
                    } else if (ident != ENUM && type != ENUM && ident != MACRO && storage != LSTATIC && storage != LSTKEXT && storage != TYPDEF) {
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
                storage != EXTERNAL && storage != DECLEXTN && storage != EXTERNP && storage != LSTKEXT && storage != TYPDEF && 
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
    changesuffix(filen2, c_output_extension); /* Change appendix to .asm */
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

struct args {
    char* name;
    char more;
    void (*setfunc)(char*);
    char* help;
};

struct args myargs[] = {
    { "math-z88", NO, SetMathZ88, "Enable machine native maths mode" },
    { "unsigned", NO, SetUnsigned, "Make all types unsigned" },
    { "do-inline", NO, SetDoInline, "Inline certain common functions" },
    { "stop-error", NO, SetStopError, "Stop when an error is received" },
    { "make-shared", NO, SetMakeShared, "This Library file is shared" },
    { "shared-file", NO, SetSharedFile, "All functions within this file are shared" },
    { "use-shared", NO, SetUseShared, "Used shared library functions" },
    { "Wnone", NO, SetNoWarn, "Disable all warnings" },
    { "compact", NO, SetCompactCode, "Enable caller cleanup for all functions" },
    { "cc", NO, SetCCode, "Intersperse the assembler output with the source c code" },
    { "verbose", NO, SetVerbose, "Be more verbose" },
    { "D", YES, SetDefine, "Define a preprocessor directive" },
    { "U", YES, SetUndefine, "Undefine a preprocessor directive" },
    { "h", NO, DispInfo, "Displays this text" },
    { "v", NO, SetVerbose, "Be more verbose" },
    { "Wall", NO, SetAllWarn, "Enable all warnings" },
    { "Wn", YES, UnSetWarning, "Unset a warning" },
    { "W", YES, SetWarning, "Set a warning" },
    { "c_share_offset=", YES, SetShareOffset, "Define the shared offset (use with -make-shared" },
    { "version", NO, DispVersion, "Display the version of sccz80" },
    { "debug=", YES, SetDebug, "Enable some extra logging" },
    { "asm=", YES, SetAssembler, "Set the assembler mode to use" },
    { "ext=", YES, SetOutExt, "Use this file extension for generated output" },
    { "asxx", NO, SetASXX, "Use asxx as the output format" },
    { "doublestr", NO, SetDoubleStrings, "Convert fp strings to values at runtime" },
    { "noaltreg", NO, SetNoAltReg, "Don't use alternate registers" },
#ifdef USEFRAME
    { "frameix", NO, SetFrameIX, "Use ix as the framepointer" },
    { "frameiy", NO, SetFrameIY, "Use iy as the framepointer" },
    { "noframe", NO, SetNoFrame, "Don't use a framepointer (default)" },
#endif
    { "standard-escape-chars", NO, SetStandardEscape, "Use standard mappings for escape codes" },
    { "set-r2l-by-default", NO, set_default_r2l, "Use r2l calling by default"},
    { "m", YES, set_cpu, "Set the target CPU (z80, z180, r2k, r3k)"},
    { "-constseg=",YES, set_rodata_section, "Set the const section name"},
    { "-codeseg=",YES, set_code_section, "Set the code section name"},
    { "-bssseg=",YES, set_bss_section, "Set the BSS section name"},
    { "-dataseg=",YES, set_data_section, "Set the data section name"},
    
    /* Compatibility Modes.. */
    { "f", NO, SetUnsigned, NULL },
    { "", 0, NULL, NULL }
};


static void set_rodata_section(char *arg)
{
    char *ptr = strchr(arg,'=');
    c_rodata_section = strdup(ptr + 1);
}

static void set_data_section(char *arg)
{
    char *ptr = strchr(arg,'=');
    c_data_section = strdup(ptr + 1);
}
static void set_code_section(char *arg)
{
    char *ptr = strchr(arg,'=');
    c_code_section = strdup(ptr + 1);
}
static void set_bss_section(char *arg)
{
    char *ptr = strchr(arg,'=');
    c_bss_section = strdup(ptr + 1);
}



#ifdef USEFRAME
static void SetNoFrame(char* arg)
{
    c_useframepointer = NO;
    c_framepointer_is_ix = NO;
}

static void SetFrameIX(char* arg)
{
    c_useframepointer = YES;
    c_framepointer_is_ix = YES;
}

static void SetFrameIY(char* arg)
{
    c_useframepointer = YES;
    c_framepointer_is_ix = NO;
}
#endif

static void set_cpu(char *arg)
{
    if ( strcmp(arg,"mz80") == 0) {
        c_cpu = CPU_Z80;
    } else if ( strcmp(arg, "mz180") == 0 ) {
        c_cpu = CPU_Z180;
    } else if ( strcmp(arg, "mr2k") == 0 ) {
        c_cpu = CPU_R2K;
    } else if ( strcmp(arg, "mr3k") == 0 ) {
        c_cpu = CPU_R3K;
    }
}

void SetStandardEscape(char* arg)
{
    c_standard_escapecodes = YES;
}

void SetDoubleStrings(char* arg)
{
    c_double_strings = YES;
}

void SetNoAltReg(char* arg)
{
    c_notaltreg = YES;
}

void SetASXX(char* arg)
{
    c_assembler_type = ASM_ASXX;
}

/* debug= */

void SetDebug(char* arg)
{
    int num;
    num = 0;
    sscanf(arg + 6, "%d", &num);
    if (num != 0)
        debuglevel = num;
}

/* c_share_offset= */

void SetShareOffset(char* arg)
{
    int num;
    num = 0;
    sscanf(arg + 12, "%d", &num);
    if (num != 0)
        c_share_offset = num;
}


void UnSetWarning(char* arg)
{
    int num;
    num = 0;
    sscanf(arg + 2, "%d", &num);
    if (num < W_MAXIMUM)
        mywarn[num].suppress = 1;
}

void SetWarning(char* arg)
{
    int num;
    num = 0;
    sscanf(arg + 1, "%d", &num);
    if (num < W_MAXIMUM)
        mywarn[num].suppress = 0;
}

void SetMathZ88(char* arg)
{
    c_mathz88 = YES;
}

void SetUnsigned(char* arg)
{
    c_default_unsigned = YES;
}

void SetNoWarn(char* arg)
{
    int i;
    for (i = 1; i < W_MAXIMUM; i++)
        mywarn[i].suppress = 1;
}

void SetAllWarn(char* arg)
{
    int i;
    for (i = 1; i < W_MAXIMUM; i++)
        mywarn[i].suppress = 0;
}


void SetDoInline(char* arg)
{
    c_doinline = YES;
}

void SetStopError(char* arg)
{
    c_errstop = YES;
}

void SetUseShared(char* arg)
{
    c_useshared = YES;
}

void SetSharedFile(char* arg)
{
    c_shared_file = YES;
}

void SetMakeShared(char* arg)
{
    c_makeshare = YES;
}

void SetCompactCode(char* arg)
{
    c_compact_code = YES;
}

void SetCCode(char* arg)
{
    c_intermix_ccode = 1;
}

void SetDefine(char* arg)
{
    defmac(arg + 1);
}

void SetUndefine(char* arg)
{
    strcpy(line, arg + 1);
    delmac();
}

void SetAssembler(char* arg)
{
    char assembler[128];

    if (1 == sscanf(arg + 4, "%s", assembler)) {
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
}

void SetOutExt(char* arg)
{
    char temp[10];

    temp[0] = '.';
    strncpy(temp + 1, arg + 4, sizeof(temp) - 2);
    temp[sizeof(temp) - 1] = '\0';
    c_output_extension = strdup(temp);
}

void DispInfo(char* arg)
{
    struct args* cur = &myargs[0];
    info();

    printf("\nOptions:\n\n");

    while (cur->setfunc) {
        if (cur->help) {
            fprintf(stderr, "-%-25s %s\n", cur->name, cur->help);
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

void SetVerbose(char* arg)
{
    c_verbose = YES;
}

void ShowNotFunc(char* arg)
{
    fprintf(stderr, "Flag -%s is currently non-functional\n", arg);
}


static void set_default_r2l(char *arg)
{
    c_use_r2l_calling_convention = YES;
}

void ParseArgs(char* arg)
{
    struct args* pargs;
    int flag;
    pargs = myargs;
    flag = 0;
    while (pargs->setfunc) {
        switch (pargs->more) {

        /* More info follows the initial thing.. */
        case YES:
            if (strncmp(arg, pargs->name, strlen(pargs->name)) == 0) {
                (*pargs->setfunc)(arg);
                flag = 1;
            }
            break;
        case NO:

            if (strcmp(arg, pargs->name) == 0) {
                (*pargs->setfunc)(arg);
                flag = 1;
            }
        }
        if (flag)
            return;
        pargs++;
    }
    printf("Unrecognised argument: %s\n", arg);
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
