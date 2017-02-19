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

/* 
 *      Data used in this file only
 */

char Filenorig[FILENAME_LEN + 1];
unsigned int zorg; /* Origin for applications */

int smartprintf; /* Map printf -> miniprintf */
int makeshare; /* Do we want to make a shared library? */
int useshare; /* Use shared lib routines? */
int sharedfile; /* File contains routines which are to be
          * called via lib package - basically jimmy
          * the stack but that's it..
          */

int noaltreg; /* No alternate registers */
int standard_escapes = 0; /* \n = 10, \r = 13 */

/*
 * Some external data
 */

extern int gotocnt; /* No of gotos */
extern GOTO_TAB* gotoq; /* Pointer for gotoq */

void DispVersion(char*);
void SetMPM(char*);
void SetSmart(char*);
void UnSetSmart(char*);
void SetMakeShared(char*);
void SetUseShared(char*);
void SetAssembler(char* arg);
void SetOutExt(char* arg);

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
    litq = mymalloc(FNLITQ); /* literals, these 2 dumped end */
    dubq = mymalloc(FNLITQ); /* Doubles */
    tempq = mymalloc(LITABSZ); /* Temp strings... */
    glbq = mymalloc(LITABSZ); /* Used for glb lits, dumped now */
    symtab = SYM_CAST mymalloc(NUMGLBS * sizeof(SYMBOL));
    loctab = SYM_CAST mymalloc(NUMLOC * sizeof(SYMBOL));
    wqueue = WQ_CAST mymalloc(NUMWHILE * sizeof(WHILE_TAB));
    gotoq = (GOTO_TAB*)calloc(NUMGOTO, sizeof(GOTO_TAB));
    if (gotoq == NULL)
        OutOfMem();

    tagptr = tagtab = TAG_CAST mymalloc(NUMTAG * sizeof(TAG_SYMBOL));
    membptr = membtab = SYM_CAST mymalloc(NUMMEMB * sizeof(SYMBOL));

    swnext = SW_CAST mymalloc(NUMCASE * sizeof(SW_TAB));
    swend = swnext + (NUMCASE - 1);

    stage = mymalloc(STAGESIZE);
    stagelast = stage + STAGELIMIT;

    /* empty symbol table */
    glbptr = STARTGLB;
    while (glbptr < ENDGLB) {
        glbptr->name[0] = 0;
        ++glbptr;
    }

    glbcnt = 0; /* clear global symbols */
    locptr = STARTLOC; /* clear local symbols */
    wqptr = wqueue; /* clear while queue */
    gltptr = dubptr = 0; /* clear literal pools */
    *litq = 0; /* First entry in literal queue is zero */
    litptr = 1; /* So miniprintf search works */

    Zsp = /* stack ptr (relative) */
        errcnt = /* no errors */
        errstop = /* keep going after an error */
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

    stagenext = NULL_CHAR; /* direct output mode */

    input = /* no input file */
        inpt2 = /* or include file */
        saveout = /* no diverted output */
        output = NULL_FD; /* no open units */

    currfn = NULL_SYM; /* no function yet */
    macptr = cmode = 1; /* clear macro pool and enable preprocessing */
    ncomp = doinline = mathz88 = incfloat = compactcode = 0;
    cppcom = 0;
    dosigned = NO;
    useshare = makeshare = sharedfile = NO;
    smartprintf = YES;
    nxtlab = /* start numbers at lowest possible */
        ctext = /* don't include the C text as comments */
        errstop = /* don't stop after errors */
        verbose = 0;
    gotocnt = 0;
    defdenums = 0;
    doublestrings = 0;
    noaltreg = NO;
    shareoffset = SHAREOFFSET; /* Offset for shared libs */
    debuglevel = NO;
    assemtype = ASM_Z80ASM;
    outext = NULL;
    printflevel = 0;
    indexix = YES;
    useframe = NO;

    setup_sym(); /* define some symbols */
    /* Parse the command line options */
    atexit(MemCleanup); /* To free everything */
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
    dublab = getlabel(); /* and fn doubles*/
    openout(); /* get the output file */
    openin(); /* and initial input file */
    header(); /* intro code */
    parse(); /* process ALL input */
    /* dump literal queues, with label */
    /* litq starts from 1, so literp has to be -1 */
    dumplits(0, YES, litptr - 1, litlab, litq + 1);
    dumplits(1, YES, dubptr, dublab, dubq);
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
    if (inpt2 != NULL_FD)
        endinclude();
    if (input != NULL_FD)
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
            dodeclare(EXTERNAL, NULL_TAG, 0);
        } else if (amatch("static")) {
            dodeclare(LSTATIC, NULL_TAG, 0);
        } else if (amatch("typedef")) {
            dodeclare(TYPDEF, NULL_TAG, 0);
        } else if (dodeclare(STATIK, NULL_TAG, 0)) {
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

#ifndef SMALL_C
void
#endif

errsummary()
{
    /* see if anything left hanging... */
    if (ncmp) {
        error(E_BRACKET);
        nl();
    }
    if (verbose) {
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
        return NULL_CHAR;
    i = 0;
    str = str2 = gargv[n];
    while (++i < size && (*s++ = *str++))
        ;
    if (*str2 == '\0')
        return NULL_CHAR;
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
    dummy_sym[CINT] = addglb("0int", POINTER, CINT, 0, STATIK, 0, 0);
    dummy_sym[DOUBLE] = addglb("0dbl", POINTER, DOUBLE, 0, STATIK, 0, 0);
    dummy_sym[LONG] = addglb("0lng", POINTER, LONG, 0, STATIK, 0, 0);
    dummy_sym[CPTR] = addglb("0cpt", POINTER, CPTR, 0, STATIK, 0, 0);
    dummy_sym[VOID] = addglb("0vd", POINTER, VOID, 0, STATIK, 0, 0);
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

void dumpfns()
{
    int ident, type, storage;
    SYMBOL* ptr;
    FILE* fp;

    outstr("\n\n; --- Start of Scope Defns ---\n\n");

    if (!glbcnt)
        return;

    /* Start at the start! */
    glbptr = STARTGLB;

    ptr = STARTGLB;
    while (ptr < ENDGLB) {
        if (ptr->name[0] != 0 && ptr->name[0] != '0') {
            ident = ptr->ident;
            if (ident == FUNCTIONP)
                ident = FUNCTION;
            type = ptr->type;
            storage = ptr->storage;
            if (ident == FUNCTION && ptr->size != 0) {
                outfmt("\tdefc\t_%s=\t%d\n", ptr->name, ptr->size);
            } else {
                if (ident == FUNCTION && storage != LSTATIC) {
                    if (storage == EXTERNAL) {
                        if (ptr->flags & LIBRARY) {
                            GlobalPrefix(LIB);
                            if ((ptr->flags & SHARED) && useshare) {
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
        ++ptr;
    }

    if ((fp = fopen("zcc_opt.def", "a")) == NULL) {
        error(E_ZCCOPT);
    }

    if (incfloat) {
        fprintf(fp, "\nIF !NEED_floatpack\n");
        fprintf(fp, "\tDEFINE\tNEED_floatpack\n");
        fprintf(fp, "ENDIF\n\n");
    }
    if (mathz88) {
        fprintf(fp, "\nIF !NEED_mathz88\n");
        fprintf(fp, "\tDEFINE\tNEED_mathz88\n");
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

    switch (printflevel) {
    case 1:
        WriteDefined("ministdio", 0);
        break;
    case 2:
        WriteDefined("complexstdio", 0);
        break;
    case 3:
        WriteDefined("floatstdio", 0);
        break;
    }

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
    glbptr = STARTGLB;
    outstr("; --- Start of Static Variables ---\n\n");

    output_section("bss_compiler"); // output_section("bss");

    ptr = STARTGLB;
    while (ptr < ENDGLB) {
        if (ptr->name[0] != 0 && ptr->name[0] != '0') {
            ident = ptr->ident;
            type = ptr->type;
            storage = ptr->storage;
            if (ident != ENUM && type != ENUM && ident != MACRO && ident != FUNCTION && storage != EXTERNAL && storage != DECLEXTN && storage != EXTERNP && storage != LSTKEXT && storage != TYPDEF) {
                prefix();
                outname(ptr->name, 1);
                col();
                defstorage();
                outdec(ptr->size);
                nl();
            }
        }
        ++ptr;
    }

    /* Switch back to standard section */
    output_section("code_compiler"); // output_section("code");
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
            output_section("rodata_compiler"); // output_section("text");
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
        //output_section("code_compiler"); // output_section("code");
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
    if (nextarg(filenum, filen2, FILENAME_LEN) == NULL_CHAR)
        return;
    if ((fp = fopen(filen2, "r")) == NULL) {
        fprintf(stderr, "Cannot open source file: %s\n", filen2);
        exit(1);
    }
    fclose(fp); /* Close it again... */

    /* copy file name to string */
    strcpy(Filename, filen2);
    strcpy(Filenorig, filen2);
    changesuffix(filen2, (outext == NULL) ? ".asm" : outext); /* Change appendix to .asm */
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
            if (verbose)
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
    if (verbose) {
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
    if (verbose) {
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
    { "//", NO, SetCppComm, "Accept C++ style // comments" },
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
    { "shareoffset=", YES, SetShareOffset, "Define the shared offset (use with -make-shared" },
    { "version", NO, DispVersion, "Display the version of sccz80" },
    { "smartpf", NO, SetSmart, "Enable smart printf format handling" },
    { "no-smartpf", NO, UnSetSmart, "Disable smart printf format handling" },
    { "pflevel", YES, SetPfLevel, "Set the manual printf level" },
    { "debug=", YES, SetDebug, "Enable some extra logging" },
    { "asm=", YES, SetAssembler, "Set the assembler mode to use" },
    { "ext=", YES, SetOutExt, "Use this file extension for generated output" },
    { "asxx", NO, SetASXX, "Use asxx as the output format" },
    { "doublestr", NO, SetDoubleStrings, "Convert fp strings to values at runtime" },
    { "noaltreg", NO, SetNoAltReg, "Don't use alternate registers" },
#ifdef USEFRAME
    { "frameix", NO, SetFrameIX },
    { "frameiy", NO, SetFrameIY },
    { "noframe", NO, SetNoFrame },
#endif
    { "standard-escape-chars", NO, SetStandardEscape, "Use standard mappings for escape codes" },
    /* Compatibility Modes.. */
    { "f", NO, SetUnsigned, NULL },
    { "", 0, NULL, NULL }
};

#ifdef USEFRAME
void SetNoFrame(char* arg)
{
    useframe = NO;
    indexix = NO;
}

void SetFrameIX(char* arg)
{
    useframe = YES;
    indexix = YES;
}

void SetFrameIY(char* arg)
{
    useframe = YES;
    indexix = NO;
}
#endif

void SetStandardEscape(char* arg)
{
    standard_escapes = YES;
}

void SetDoubleStrings(char* arg)
{
    doublestrings = YES;
}

void SetNoAltReg(char* arg)
{
    noaltreg = YES;
}

void SetASXX(char* arg)
{
    assemtype = ASM_ASXX;
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

/* shareoffset= */

void SetShareOffset(char* arg)
{
    int num;
    num = 0;
    sscanf(arg + 12, "%d", &num);
    if (num != 0)
        shareoffset = num;
}

/* Flag whether we want to do "smart" mapping of printf -> miniprintf */

void UnSetSmart(char* arg)
{
    smartprintf = NO;
    printflevel = 2; /* Complex */
}

void SetSmart(char* arg)
{
    smartprintf = YES;
}

/* pflevel= */
void SetPfLevel(char* arg)
{
    int num;
    num = 0;
    sscanf(arg + 8, "%d", &num);
    if (num >= 1 && num <= 3)
        printflevel = num;
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
    mathz88 = YES;
}

void SetUnsigned(char* arg)
{
    dosigned = YES;
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

void SetCppComm(char* arg)
{
    cppcom = YES;
}

void SetDoInline(char* arg)
{
    doinline = YES;
}

void SetStopError(char* arg)
{
    errstop = YES;
}

void SetUseShared(char* arg)
{
    useshare = YES;
}

void SetSharedFile(char* arg)
{
    sharedfile = YES;
}

void SetMakeShared(char* arg)
{
    makeshare = YES;
}

void SetCompactCode(char* arg)
{
    compactcode = YES;
}

void SetCCode(char* arg)
{
    ctext = 1;
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
            assemtype = ASM_Z80ASM;
        } else if (strcmp(assembler, "asxx") == 0) {
            assemtype = ASM_ASXX;
        } else if (strcmp(assembler, "vasm") == 0) {
            assemtype = ASM_VASM;
        } else if (strcmp(assembler, "gnu") == 0) {
            assemtype = ASM_GNU;
        }
    }
}

void SetOutExt(char* arg)
{
    char temp[10];

    temp[0] = '.';
    strncpy(temp + 1, arg + 4, sizeof(temp) - 2);
    temp[sizeof(temp) - 1] = '\0';
    outext = strdup(temp);
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
    verbose = YES;
}

void ShowNotFunc(char* arg)
{
    fprintf(stderr, "Flag -%s is currently non-functional\n", arg);
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

void MemCleanup()
{
    if (litq) {
        free(litq);
        litq = 0;
    }
    if (dubq) {
        free(dubq);
        dubq = 0;
    }
    if (tempq) {
        free(tempq);
        tempq = 0;
    }
    if (glbq) {
        free(glbq);
        glbq = 0;
    }
    if (symtab) {
        free(symtab);
        symtab = 0;
    }
    if (loctab) {
        free(loctab);
        loctab = 0;
    }
    if (wqueue) {
        free(wqueue);
        wqueue = 0;
    }
    if (tagtab) {
        free(tagtab);
        tagtab = 0;
    }
    if (membtab) {
        free(membtab);
        membtab = 0;
    }
    if (swnext) {
        free(swnext);
        swnext = 0;
    }
    if (stage) {
        free(stage);
        stage = 0;
    }
    if (gotoq) {
        free(gotoq);
        gotoq = 0;
    }
}

/*
 *   Routine to keep DOG happy and avoid nastiness
 *   should really do this any case..so I'll let it
 *   pass!
 */

void* mymalloc(size_t size)
{
    void* ptr;

    if ((ptr = calloc(size, 1)) != NULL)
        return ptr;
    else
        OutOfMem();
    return 0; /* Sigh */
}

void OutOfMem()
{
    fprintf(stderr, "Out of memory...\n");
    exit(1);
}
