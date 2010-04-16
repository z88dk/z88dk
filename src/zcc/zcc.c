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
 *      $Id: zcc.c,v 1.41 2010-04-16 00:46:51 dom Exp $
 */


#include        <stdio.h>
#include        <string.h>
#include        <stdlib.h>
#include        <ctype.h>
#include        "zcc.h"

#ifdef WIN32
#define strcasecmp(a,b) stricmp(a,b)
#endif

typedef struct arg_s arg_t;


/* All our function prototypes */

static void            AddComp(char *);
static void            AddToFileList(char *);

static void            ParseArgs(char *);
static void            SetBoolean(arg_t *arg, char *val);
static void            AddPreProc(arg_t *arg,char *);
static void            AddToPreProc(arg_t *arg,char *);
static void            AddToAssembler(arg_t *arg,char *);
static void            AddToLinker(arg_t *arg,char *);
static void            AddAppmake(arg_t *arg,char *);
static void            AddToAppmake(arg_t *arg,char *);
static void            AddLinkLibrary(arg_t *arg,char *);
static void            AddLinkOption(arg_t *arg,char *);
static void            DispInfo(void);
static void            DispVer(arg_t *arg,char *);
static void            SetPeepHole(arg_t *arg,char *);
static void            SetString(arg_t *arg,char *);
static void            SetLibMake(arg_t *arg,char *);
static void            SetShortObj(arg_t *arg,char *);
static void            SetLateAssemble(arg_t *arg,char *);
static void            SetAssembler(arg_t *arg,char *);

static void           *mustmalloc(size_t);
static int             hassuffix(char *, char *);
static char           *changesuffix(char *, char *);
static int             process(char *, char *, char *, char *, enum iostyle, int, int);
static int             linkthem(char *);
static int             FindSuffix(char *);
static void            BuildAsmLine(char *, char *);
static void            ParseArgs(char *);
static void            BuildOptions(char **, char *);
static void            BuildOptions_start(char **, char *);
static void            CopyOutFiles(char *);
static void            ParseOpts(char *);
static void            SetNormal(char *, int);
static void            SetOptions(char *, int);
static void            SetNumber(char *, int);
static void            SetConfig(char *, int);
static void            Deprecated(char *arg, int num);
static void            KillEOL(char *);

static void            CleanUpFiles(void);
static void            CleanFile(char *, char *);
static void            CopyCrt0(void);
static void            ShowErrors(char *, char *);
static int             CopyFile(char *, char *, char *, char *);
static void            tempname(char *);
static int             FindConfigFile(char *, int);
static void            parse_option(char *option);
static void            linkargs_mangle(char *linkargs);

/* Mode Options, used for parsing arguments */




static struct confs    myconf[] = {
    {"OPTIONS", NULL, SetOptions, NULL},
    {"Z80EXE", "ASSEMBLER", SetNormal, NULL},
    {"CPP", NULL, SetNormal, NULL},
    {"LINKER", NULL, SetNormal, NULL},
    {"COMPILER", NULL, SetNormal, NULL},
    {"COPTEXE", NULL, SetNormal, NULL},
    {"COPYCMD", NULL, SetNormal, NULL},
    {"INCPATH", NULL, SetNormal, NULL},
    {"COPTRULES1", NULL, SetNormal, NULL},
    {"COPTRULES2", NULL, SetNormal, NULL},
    {"COPTRULES3", NULL, SetNormal, NULL},
    {"CRT0", NULL, SetNormal, NULL},
    {"LINKOPTS", NULL, SetOptions, NULL},
    {"ASMOPTS", NULL, SetOptions, NULL},
    {"APPMAKE", NULL, SetNormal, NULL},
    {"Z88MATHLIB", NULL, SetNormal, NULL},
    {"Z88MATHFLG", NULL, SetNormal, NULL},
    {"STARTUPLIB", NULL, SetNormal, NULL},
    {"GENMATHLIB", NULL, SetNormal, NULL},
    {"STYLECPP", NULL, SetNumber, NULL},
    {"VASMOPTS", NULL, SetOptions, NULL},
    {"ASZ80OPTS", NULL, SetOptions, NULL},
    {"VLINKOPTS", NULL, SetOptions, NULL},
    {"ASLINKOPTS", NULL, SetOptions, NULL},
    {"MPMEXE", NULL, Deprecated, NULL},
    {"LIBPATH", NULL, Deprecated, NULL},
    {"", NULL, NULL}
};


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
static int             gargc;        /* Copies of argc and argv */
static char          **gargv;
/* filelist has to stay as ** because we change suffix all the time */
static int             nfiles = 0;
static char          **filelist;
static char          **orgfiles;    /* Original filenames... */
static char           *outputfile = NULL;
static char           *linkeroutputfile = NULL;
static char           *cpparg;
static char           *comparg;
static char           *linkargs;
static char           *asmargs;
static char           *appmakeargs;


static char            filenamebuf[FILENAME_MAX + 1];
static char            extension[5];

#define OBJEXT extension

#define ASM_Z80ASM 0
#define ASM_ASXX   1
#define ASM_VASM   2
static int             assembler_type = ASM_Z80ASM;
static enum iostyle    assembler_style = outimplied;
static int             linker_output_separate_arg = 0;

#define IS_ASM(x)  ( assembler_type == (x) )


static char           *defaultout = "a.bin";
static char           *defaultbin = "a.bin";


struct arg_s {
    char  *name;
    int    flags;
    void (*setfunc)(arg_t *arg, char *);
    void  *data;
    char  *help;   
};

#define AF_BOOL_TRUE      1
#define AF_BOOL_FALSE     2
#define AF_MORE           4


static arg_t     myargs[] = {
    {"z80-verb", AF_BOOL_TRUE, SetBoolean, &z80verbose, "Make the assembler more verbose"},
    {"cleanup",  AF_BOOL_TRUE, SetBoolean, &cleanup,     "(default) Cleanup temporary files"},
    {"no-cleanup", AF_BOOL_FALSE, SetBoolean, &cleanup,  "Don't cleanup temporary files"},
    {"make-lib", 0, SetLibMake, NULL, "Compile as if to make a library"},
    {"preserve", AF_BOOL_TRUE, SetBoolean, &preserve, "Don't remove zcc_opt.def and start of run"},
    {"make-app", 0, SetLateAssemble, NULL, "Create binary suitable for generated application"},
    {"create-app", AF_BOOL_TRUE, SetBoolean, &createapp, "Run appmake on the resulting binary to create emulator usable file"},
    {"usetemp", AF_BOOL_TRUE, SetBoolean, &usetemp, "(default) Use the temporary directory for intermediate files"},
    {"notemp", AF_BOOL_FALSE, SetBoolean, &usetemp, "Don't use the temporary directory for intermediate files"},
    {"asm", AF_MORE, SetAssembler, NULL, "Set the assembler type from the command line (z80asm, mpm, asxx, vasm"},
    {"Cp", AF_MORE, AddToPreProc, NULL, "Add an option to the preprocessor"},
    {"Ca", AF_MORE, AddToAssembler, NULL, "Add an option to the assembler"},
    {"Cl", AF_MORE, AddToLinker, NULL, "Add an option to the linker"},
    {"Cz", AF_MORE, AddToAppmake, NULL, "Add an option to appmake"},
    {"E", AF_BOOL_TRUE, SetBoolean, &preprocessonly, "Only preprocess files"},
    {"R", AF_BOOL_TRUE, SetBoolean, &relocate, "Generate relocatable code"},
    {"D", AF_MORE, AddPreProc, NULL, "Define a preprocessor option"},
    {"U", AF_MORE, AddPreProc, NULL, "Undefine a preprocessor option"},
    {"I", AF_MORE, AddPreProc, NULL, "Add an include directory for the preprocessor"},
    {"L", AF_MORE, AddLinkOption, NULL, "Add a library search path"},
    {"l", AF_MORE, AddLinkLibrary, NULL, "Add a library"},
    {"O", AF_MORE, SetPeepHole, NULL, "Set the peephole optimiser setting"},
    {"h", 0, DispVer, NULL, "Display this text"},
    {"v", AF_BOOL_TRUE, SetBoolean, &verbose, "Output all commands that are run (-vn suppresses)"},
    {"bn", AF_MORE, SetString, &linkeroutputfile,"Set the output file for the linker stage"},
    {"vn", AF_BOOL_FALSE, SetBoolean, &verbose, "Run the compile stages silently" },
    {"c", AF_BOOL_TRUE, SetBoolean, &compileonly, "Only compile the .c files to .o files"},
    {"a", AF_BOOL_TRUE, SetBoolean, &assembleonly,"Only compile the .c files to .asm/.opt files"},
    {"m", AF_BOOL_TRUE, SetBoolean, &mapon, "Generate an output map of the final executable"},
    {"s", AF_BOOL_TRUE, SetBoolean, &symbolson, "Generate a symbol map of the final executable"},
    {"o", AF_MORE, SetString, &outputfile, "Set the output files"},
    {"nt", 0, AddAppmake, NULL, "Set notruncate on the appmake options"},
    {"M",  0, SetShortObj, NULL, "Define the suffix of the object files (eg -Mo)"},
    {"+", NO, AddPreProc, NULL, NULL},    /* Strips // comments in vcpp */
    {"", 0, NULL, NULL}
};



/* Okay! Off we Go! */

void           *
mustmalloc(size_t n)
{
    void           *p;

    if ((p = malloc(n)) == 0) {
        fprintf(stderr, "malloc failed\n");
        exit(1);
    }
    return (p);
}

int 
hassuffix(char *name, char *suffix)
{
    int             nlen, slen;

    nlen = strlen(name);
    slen = strlen(suffix);

    if (slen > nlen)
        return (0);
    return (strcmp(&name[nlen - slen], suffix) == 0);
}

char           *
changesuffix(char *name, char *suffix)
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
process(suffix, nextsuffix, processor, extraargs, ios, number, needsuffix)
    char           *suffix, *nextsuffix, *processor, *extraargs;
    enum iostyle    ios;
    int             number;
    int             needsuffix;    /* Should dump suffix (z80) oi! */
{
    int             status, errs;
    int             tstore;
    char           *buffer, *outname;

    errs = 0;
    if (!hassuffix(filelist[number], suffix))
        return (0);

    switch (ios) {
    case outimplied:
        buffer = mustmalloc(strlen(processor) + strlen(extraargs) + strlen(filelist[number]) + 3);

        /* Dropping the suffix for Z80..cheating! */
        tstore = strlen(filelist[number]) - strlen(suffix);

        if (!needsuffix)
            filelist[number][tstore] = 0;

        sprintf(buffer, "%s %s %s", processor, extraargs,
            filelist[number]);
        filelist[number][tstore] = '.';
        break;
    case outspecified:
        outname = changesuffix(filelist[number], nextsuffix);
        buffer = mustmalloc(strlen(processor) + strlen(extraargs)
              + strlen(orgfiles[number]) + strlen(outname) + 4);
        sprintf(buffer, "%s %s %s %s", processor, extraargs,
            orgfiles[number], outname);
        free(outname);
        break;
    case outspecified_flag:
        outname = changesuffix(filelist[number], nextsuffix);
        buffer = mustmalloc(strlen(processor) + strlen(extraargs)
              + strlen(orgfiles[number]) + strlen(outname) + 4);
        sprintf(buffer, "%s %s %s -o %s", processor, extraargs,
            filelist[number], outname);
        free(outname);
        break;
    case filter:
        outname = changesuffix(filelist[number], nextsuffix);
        buffer = mustmalloc(strlen(processor) + strlen(extraargs)
              + strlen(filelist[number]) + strlen(outname) + 8);
        sprintf(buffer, "%s %s < %s > %s", processor, extraargs,
            filelist[number], outname);
        free(outname);
    }
    if (verbose)
        puts(buffer);
    status = system(buffer);
    if (status != 0)
        errs = 1;
    else {
        /* Free up the allocated memory */
        outname = changesuffix(filelist[number], nextsuffix);
        free(filelist[number]);
        filelist[number] = outname;
    }
    free(buffer);
    return (errs);
}

int 
linkthem(char *linker)
{
    int             i, n, status;
    char           *p;
    char           *asmline = "";    /* patch for z80asm */
    char           *ext;

    /* patch for z80asm */
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

    n = (strlen(linker) + 1);
    if (lateassemble)
        n += strlen(asmline);    /* patch for z80asm */
    n += (strlen("-nm -nv -o -R -M ") + strlen(outputfile));
    n += (strlen(linkargs) + 1);
    n += (strlen(myconf[CRT0].def) + strlen(ext) + 2);
    n += (2 * strlen(myconf[LINKOPTS].def));
    for (i = 0; i < nfiles; ++i) {
        n += strlen(filelist[i]);
    }
    p = mustmalloc(n);


    sprintf(p, "%s %s -o%s%s ", linker, myconf[LINKOPTS].def, linker_output_separate_arg ? " " : "", outputfile);
    if (lateassemble)    /* patch */
        strcat(p, asmline);    /* patch */
    if (z80verbose)
        strcat(p, "-v ");
    if (relocate) {
        if (lateassemble)
            fprintf(stderr, "Cannot relocate an application..\n");
        else
            strcat(p, "-R ");
    }
    linkargs_mangle(linkargs);
    strcat(p, linkargs);
    /*
     * Now insert the 0crt file (so main doesn't have to be the first
     * file linkargs last character is space..
     */
    strcat(p, myconf[CRT0].def);
    strcat(p, ext);

    for (i = 0; i < nfiles; ++i) {
        if ((!lateassemble && hassuffix(filelist[i], OBJEXT)) || lateassemble) {
            strcat(p, " ");
            //filelist[i][strlen(filelist[i]) - strlen(OBJEXT)] = '\0';
            strcat(p, filelist[i]);
        }
    }
    if (verbose)
        printf("%s\n", p);
    status = system(p);
    free(p);
    return (status);
}

int 
main(int argc, char **argv)
{
    int             i, gc;
    char            asmarg[4096];    /* Hell, that should be long enough! */
    char            buffer[LINEMAX + 1];    /* For reading in option file */
    FILE           *fp;

    if ((atexit(CleanUpFiles)) != 0)
        printf("Couldn't register atexit() routine\n");

    strcpy(buffer, "  ");

    AddComp(buffer + 1);
    asmargs = linkargs = cpparg = 0;

    /* allocate enough pointers for all files, slight overestimate */
    filelist = (char **) mustmalloc(sizeof(char *) * argc);
    orgfiles = (char **) mustmalloc(sizeof(char *) * argc);


    gc = 1;            /* Set for the first argument to scan for */
    if (argc == 1) {
        DispInfo();
        exit(1);
    }
    gc = FindConfigFile(argv[gc], gc);



    /* Okay, so now we read in the options file and get some info for us */
    if ((fp = fopen(filenamebuf, "r")) == NULL) {
        fprintf(stderr, "Can't open config file %s\n", filenamebuf);
        exit(1);
    }
    while (fgets(buffer, LINEMAX, fp) != NULL) {
        if (!isupper(buffer[0]))
            continue;
        ParseOpts(buffer);
    }
    fclose(fp);

    /*
     *      Check to see if we are missing any definitions, if we are
     *      exit..
     */
    for (i = Z80EXE; i <= GENMATHLIB; i++) {
        if (myconf[i].def == NULL) {
            fprintf(stderr, "Missing definition for %s\n", myconf[i].name);
            exit(1);
        }
    }


    /*
     *      Now, set the linkargs list up to initially consist of
     *      the startuplib
     */
    snprintf(buffer, sizeof(buffer), "-l%s ", myconf[STARTUPLIB].def);
    BuildOptions(&linkargs, buffer);

 

    /*
     *    Copy the .obj into the extension var (used for linking &c)
     */
    strcpy(extension, ".obj");



    /*
     * That's dealt with the options, so onto real stuff now!
     */


    /* Now, parse the default options list */
    if (myconf[OPTIONS].def != NULL) {
        parse_option(myconf[OPTIONS].def);
    }
    /* Parse the argument list */

    gargv = argv;        /* Point argv to start of command line */

    for (gargc = gc; gargc < argc; gargc++) {
        if (argv[gargc][0] == '-')
            ParseArgs(1 + argv[gargc]);
        else
            AddToFileList(argv[gargc]);
    }

    /*
     *      Add the default cpp path
     */
    BuildOptions(&cpparg, myconf[INCPATH].def);


    /*
     *      First thing we do is to remove the zcc_opt.def file
     *      This is written to by sccz80, but only if preserve isn't set
     *
     *      Done in this this dotty way to ensure we can write and
     *      also to avoid usage of access() - maybe it's not present
     *      on all systems..
     *      Apologies for the indentation here!
     *
     */
    if (preserve == NO) {
        if ((fp = fopen(DEFFILE, "w")) != NULL) {
            fclose(fp);
            if (remove(DEFFILE) < 0) {
                fprintf(stderr, "Cannot remove %s: File in use?\n", DEFFILE);
                exit(1);
            }
            /*
             *      It's the merry go round, here we try to open it again, so that
             *      if we specify non .c files compiling doesn't barf, ah, if only
             *      we could do a touch [filename]!
             */

            if ((fp = fopen(DEFFILE, "w")) != NULL)
                fclose(fp);
            else {
                fprintf(stderr, "Could not create %s: File in use?\n", DEFFILE);
                exit(1);
            }
        } else {
            fprintf(stderr, "Cannot open %s: File in use?\n", DEFFILE);
            exit(1);
        }
    }

    if (nfiles <= 0) {
        DispInfo();
        exit(0);
    }

    /* Kill \n on the end of certain option lines */
    KillEOL(myconf[LINKOPTS].def);
    KillEOL(myconf[ASMOPTS].def);

    /* We can't create an app and make a library.... */
    if (createapp && makelib)
        createapp = NO;

  

    /* We only have to do a late assembly hack for z80asm family */
    if (createapp && makeapp && IS_ASM(ASM_Z80ASM))
        lateassemble = YES;


    /*
     * Now, a little bit of trickery to allow many people to use zcc at
     * the same time (like they'd want to! But you never actually know!
     * Copy the z88_crt0.opt file over to /tmp or t: and use it as the
     * startup code...trickery ahoy!!!
     */
    CopyCrt0();       

    /* Parse through the files, handling each one in turn */
    for (i = 0; i < nfiles; i++) {
        switch (FindSuffix(filelist[i])) {
        case CFILE:
            if (process(".c", ".i", myconf[CPP].def, cpparg, (int) myconf[CPPSTYLE].def, i, YES))
                exit(1);
            if (preprocessonly) {
                if (usetemp)
                    CopyOutFiles(".i");
                exit(0);
            }
        case PFILE:
            if (process(".i", ".asm", myconf[COMPILER].def, comparg, outimplied, i, YES))
                exit(1);

        case AFILE:
            switch (peepholeopt) {
            case 1:
                if (process(".asm", ".opt", myconf[COPTEXE].def, myconf[COPTRULES1].def, filter, i, YES))
                    exit(1);
                break;
            case 2:
                /* Double optimization! */
                if (process(".asm", ".op1", myconf[COPTEXE].def, myconf[COPTRULES2].def, filter, i, YES))
                    exit(1);

                if (process(".op1", ".opt", myconf[COPTEXE].def, myconf[COPTRULES1].def, filter, i, YES))
                    exit(1);
                break;
            case 3:
                /*
                 * Triple opt (last level adds routines but
                 * can save space..)
                 */
                if (process(".asm", ".op1", myconf[COPTEXE].def, myconf[COPTRULES2].def, filter, i, YES))
                    exit(1);
                if (process(".op1", ".op2", myconf[COPTEXE].def, myconf[COPTRULES1].def, filter, i, YES))
                    exit(1);
                if (process(".op2", ".opt", myconf[COPTEXE].def, myconf[COPTRULES3].def, filter, i, YES))
                    exit(1);
                break;
            default:
                BuildAsmLine(asmarg, "-easm");
                if (!assembleonly && !lateassemble)
                    if (process(".asm", OBJEXT, myconf[Z80EXE].def, asmarg, assembler_style, i, YES))
                        exit(1);
            }
        case OFILE:
            BuildAsmLine(asmarg, "-eopt");
            if (!assembleonly && !lateassemble)
                if (process(".opt", OBJEXT, myconf[Z80EXE].def, asmarg, assembler_style, i, YES))
                    exit(1);
            break;
        }
    }
    if (compileonly || assembleonly) {
        if (compileonly && !assembleonly) {
            if (usetemp)
                CopyOutFiles(OBJEXT);
        } else {
            if (usetemp)
                CopyOutFiles(peepholeopt ? ".opt" : ".asm");
        }
        exit(0);
    }

    /*
     *      Set the default output file
     */
    if ( outputfile == NULL ) {
        outputfile = linkeroutputfile ? linkeroutputfile : defaultout;
        /*
         * If we're making an app, we want the default name to be a.bin not a.out
         */
        if (createapp ) {
            outputfile = defaultbin;
        }
    }

   

    /* Link them, if errors, atexit() deals with them! */

    if (linkthem(myconf[LINKER].def))
        exit(1);

    if (createapp) {
        /* Building an application - run the appmake command on it */
        snprintf(buffer, sizeof(buffer), "%s %s -b %s -c %s", myconf[APPMAKE].def, appmakeargs ? appmakeargs : "", outputfile, myconf[CRT0].def);
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
        if (CopyFile(myconf[CRT0].def, ".map", filenamebuf, ".map")) {
            fprintf(stderr, "Cannot copy map file\n");
            exit(1);
        }
    }
    exit(0);
}

int 
CopyFile(char *name1, char *ext1, char *name2, char *ext2)
{
    char            buffer[LINEMAX + 1];
    snprintf(buffer, sizeof(buffer), "%s %s%s %s%s", myconf[COPYCMD].def, name1, ext1, name2, ext2);
    if (verbose)
        printf("%s\n", buffer);
    return (system(buffer));
}



int 
FindSuffix(char *name)
{
    int             j;
    j = strlen(name);
    while (j && name[j] != '.')
        j--;

    if (!j)
        return 0;

    j++;
    if (strcmp(&name[j], ".c"))
        return CFILE;
    if (strcmp(&name[j], ".i"))
        return PFILE;
    if (strcmp(&name[j], ".asm"))
        return AFILE;
    if (strcmp(&name[j], ".opt"))
        return OFILE;
    return 0;
}


void 
BuildAsmLine(char *dest, char *prefix)
{
    if (asmargs)
        strcpy(dest, asmargs);
    else
        strcpy(dest, "");
    if (IS_ASM(ASM_Z80ASM)) {
        strcat(dest, prefix);
    }
    if (z80verbose)
        strcat(dest, " -v ");
    if (IS_ASM(ASM_Z80ASM)) {
        if (!symbolson) {
            strcat(dest, " -ns ");
        }
    }
    strcat(dest, myconf[ASMOPTS].def);
}

/*
 *      Compile library files
 */

void 
SetLibMake(arg_t *argument, char *arg)
{
    makelib = YES;
    compileonly = YES;    /* Get to object file */
    peepholeopt = 2;
    AddComp(arg);
}

void
SetBoolean(arg_t *arg, char *val)
{
    if ((arg->flags & AF_BOOL_TRUE)) {
        *(int *)arg->data = YES;
    } else {
        *(int *)arg->data = NO;
    }
}

void 
SetLateAssemble(arg_t *argument, char *arg)
{
    char           *temp = " -make-app";
    makeapp = YES;
    AddComp(temp + 1);
}



void 
SetString(arg_t *argument, char *arg)
{
    *filenamebuf = 0;
    sscanf(&arg[strlen(argument->name)], "%s", filenamebuf);
    *(char **)argument->data = filenamebuf;
    if (strlen(*(char **)argument->data) == 0) {
        *(char **)argument->data = NULL;
        /* Try the next argument up */
        if (gargv[gargc + 1][0] != '-') {
            /* Aha...non option comes next... */
            gargc++;
            *(char **)argument->data = gargv[gargc];
        }
    }
}

void 
SetPeepHole(arg_t *argument, char *arg)
{
    peepholeopt = arg[1] - '0';
}


void 
AddToAssembler(arg_t *argument, char *arg)
{
    BuildOptions(&asmargs, arg + 2);
    /*
     * If the linker and assembler are the same application then add
     * assembler options to the linker
     */
    if (strcmp(myconf[LINKER].def, myconf[Z80EXE].def) == 0) {
        BuildOptions(&linkargs, arg + 2);
    }
}

void 
AddToLinker(arg_t *argument, char *arg)
{
    BuildOptions(&linkargs, arg + 2);
}


void 
AddToAppmake(arg_t *argument, char *arg)
{
    BuildOptions(&appmakeargs, arg + 2);
}

void 
AddAppmake(arg_t *argument, char *arg)
{
    BuildOptions(&appmakeargs, arg - 1);
}


void 
AddToPreProc(arg_t *argument, char *arg)
{
    BuildOptions(&cpparg, arg + 2);
}

void 
AddPreProc(arg_t *argument, char *arg)
{
    BuildOptions(&cpparg, arg - 1);
}


void 
AddLinkLibrary(arg_t *argument, char *arg)
{
    char            buffer[LINEMAX + 1];    /* A little large! */
    /*
     * We still have the "problem" of switching between maths literals,
     * so if -lmz is supplied (custom lib) then add in the special option
     * this way we can be as generic as possible
     */
    if (strcmp(arg, "lmz") == 0) {
        parse_option(myconf[Z88MATHFLG].def);
        snprintf(buffer, sizeof(buffer), "-l%s ", myconf[Z88MATHLIB].def);
        BuildOptions_start(&linkargs, buffer);
        return;
    } else if (strcmp(arg, "lm") == 0) {
        snprintf(buffer, sizeof(buffer), "-l%s ", myconf[GENMATHLIB].def);
        BuildOptions_start(&linkargs, buffer);
        return;
    }
    /* Add on the necessary prefix for libraries */
    snprintf(buffer, sizeof(buffer), "-l%s ", arg + 1);
    BuildOptions_start(&linkargs, buffer);
}

void 
AddLinkOption(arg_t *arg, char *val)
{
    BuildOptions_start(&linkargs, val);
}


/*
 * This routine appends the option arg onto the arglist specified
 * by list - creating a long string in the process
 */

void 
BuildOptions(char **list, char *arg)
{
    char           *temparg;
    int             len;
    temparg = *list;

    len = 2 + strlen(arg) + (temparg ? strlen(temparg) : 0);
    temparg = realloc(temparg, len);
    if (temparg) {
        if (*list == 0)
            *temparg = 0;
        *list = temparg;
    } else {
        fprintf(stderr, "Out of memory\n");
        exit(1);
    }
    strcat(temparg, arg);
    strcat(temparg, " ");
}

void 
BuildOptions_start(char **list, char *arg)
{
    char           *temparg;
    int             len;
    char           *orig = *list;

    len = 2 + strlen(arg) + (orig ? strlen(orig) : 0);

    if ((temparg = malloc(len)) == NULL) {
        fprintf(stderr, "Out of memory\n");
        exit(1);
    }
    *list = temparg;    /* Set the pointer to the new string */
    strcpy(temparg, arg);
    strcat(temparg, " ");
    strcat(temparg, orig);

    free(orig);
}



void 
AddComp(char *arg)
{
    BuildOptions(&comparg, arg - 1);
}

void 
AddToFileList(char *arg)
{
    char            filen[FILENAME_MAX + 1];
    char           *ptr;
    int             j;
    if (isspace(arg[0]) || arg[0] == 0)
        return;
    /*
     *      First of all, copy the original filenames to orgfiles
     */
    ptr = mustmalloc(strlen(arg) + 1);
    strcpy(ptr, arg);
    orgfiles[nfiles] = ptr;
    /*
     *      Now, create a temporary filename, and copy from the original
     *      file, to the temporary file
     */
    if (usetemp) {
        tempname(filen);
        j = strlen(arg);
        while (j && arg[j] != '.')
            j--;

        if (j == 0) {
            fprintf(stderr, "Unrecognised filetype\n");
            return;
        }
        strcat(filen, &arg[j]);
        /*
         * Copy the file over
         */
        if (!hassuffix(arg, ".c")) {
            if (CopyFile(arg, "", filen, "")) {
                fprintf(stderr, "Cannot copy input file\n");
                exit(1);
            }
        }
    } else {
        /* Not using temporary files.. */
        strcpy(filen, arg);
    }
    /* Allocate space for it and dump it in the filelist */
    ptr = mustmalloc(strlen(filen) + 1);
    strcpy(ptr, filen);
    filelist[nfiles++] = ptr;
}

void 
DispVer(arg_t *arg, char *val)
{
    arg_t      *cur = &myargs[0];

    DispInfo();

    printf("\nOptions:\n\n");

    while (cur->help) {
        printf("-%-15s %s\n", cur->name, cur->help);
        cur++;
    }

    exit(0);
}


void 
SetShortObj(arg_t *arg,char *val)
{
    strcpy(extension, ".o");
}


void 
DispInfo(void)
{
    printf("zcc - Frontend for the z88dk Cross-C Compiler\n");
    printf(version);
}


void 
ParseArgs(char *arg)
{
    arg_t          *pargs;
    int             flag;

    pargs = myargs;
    flag = 0;

    while (pargs->setfunc) {
        if ((pargs->flags & AF_MORE) ) {
            /* More info follows the option */
            if (strncmp(arg, pargs->name, strlen(pargs->name)) == 0) {
                (*pargs->setfunc) (pargs, arg);
                flag = 1;
            }
        } else {
            if (strcmp(arg, pargs->name) == 0) {
                (*pargs->setfunc) (pargs, arg);
                flag = 1;
            }
        }
        if (flag)
            return;
        pargs++;
    }
    AddComp(arg);
}

void 
ParseOpts(char *arg)
{
    struct confs   *pargs;
    int             num = 0;
    pargs = myconf;

    while (pargs->setfunc) {
        if (strncmp(arg, pargs->name, strlen(pargs->name)) == 0 ||
            (pargs->alias && strncmp(arg, pargs->alias, strlen(pargs->alias)) == 0)) {
            (*pargs->setfunc) (arg, num);
            return;
        }
        num++;
        pargs++;
    }
    printf("Unrecognised config option: %s\n", arg);
    return;
}

/*
 * Set the pointer in the myconf structure to be for out inputted thing
 * malloc the space for it, and then flunk if die..
 */

void 
SetConfig(char *arg, int num)
{
    if (myconf[num].def == NULL) {
        myconf[num].def = (char *) mustmalloc(strlen(arg) + 1);
        strcpy(myconf[num].def, arg);
    } else {
        fprintf(stderr, "%s already defined as %s", myconf[num].name, myconf[num].def);
    }
}

/*
 * Set a number option, very nasty, force our integer (0-2) to be
 * a char * type (saves a lot of rewriting really..
 */

void 
SetNumber(char *arg, int num)
{
    char            name[LINEMAX + 1];
    int             style;
    sscanf(arg, "%s%d", name, &style);
    if (style)
        myconf[num].def = (char *) (style - 1);
}

/** \brief Handler for a deprecated option in the config file
 *
 *  \param arg - Argument
 *  \param num - Argument number to set
 */
static void 
Deprecated(char *arg, int num)
{
    /* Deprecated, ignore */
}

void 
SetNormal(char *arg, int num)
{
    char            name[LINEMAX + 1];
    char           *ptr, *ptr2;
    sscanf(arg, "%s %s", name, name);

    ptr = name;

    if ((ptr2 = strchr(ptr, '\n')))
        *ptr2 = 0;
    if ((ptr2 = strchr(ptr, '\r')))
        *ptr2 = 0;


    if (strncmp(name, myconf[num].name, strlen(myconf[num].name)) != 0) {
        SetConfig(ptr, num);
    }
}





static int 
SetAssemblerType(char *name)
{
    char           *assembler = NULL;
    char           *linker = NULL;
    char           *ptr;
    int             type = ASM_Z80ASM;
    enum iostyle    style = outimplied;

    if (strcasecmp(name, "z80asm") == 0) {
        type = ASM_Z80ASM;
        linker = "z80asm";
        assembler = "z80asm";
    } else if (strcasecmp(name, "mpm") == 0) {
        type = ASM_Z80ASM;
        linker = "mpm";
        assembler = "mpm";
    } else if (strcasecmp(name, "asxx") == 0) {
        type = ASM_ASXX;
        linker = "alink";
        assembler = "asz80";
        ptr = myconf[ASMOPTS].def;
        myconf[ASMOPTS].def = myconf[ASZ80OPTS].def ? myconf[ASZ80OPTS].def : strdup("");
        myconf[ASZ80OPTS].def = ptr;
        ptr = myconf[LINKOPTS].def;
        myconf[LINKOPTS].def = myconf[ASLINKOPTS].def ? myconf[ASLINKOPTS].def : strdup("");
        myconf[ASLINKOPTS].def = ptr;
    } else if (strcasecmp(name, "vasm") == 0) {
        type = ASM_VASM;
        linker = "vlink";
        assembler = "vasm";

        /* Switch config around */
        ptr = myconf[ASMOPTS].def;
        myconf[ASMOPTS].def = myconf[VASMOPTS].def ? myconf[VASMOPTS].def : strdup("");
        myconf[VASMOPTS].def = ptr;
        ptr = myconf[LINKOPTS].def;
        myconf[LINKOPTS].def = myconf[VLINKOPTS].def ? myconf[VLINKOPTS].def : strdup("");
        myconf[VLINKOPTS].def = ptr;

        printf("Assembler opts = %s\n", myconf[ASMOPTS].def);

        style = outspecified_flag;
        linker_output_separate_arg = 1;
    }
    assembler_type = type;
    assembler_style = style;
    if (assembler) {
        if (myconf[Z80EXE].def) {
            free(myconf[Z80EXE].def);
        }
        myconf[Z80EXE].def = strdup(assembler);
    }
    if (linker) {
        if (myconf[LINKER].def) {
            free(myconf[LINKER].def);
        }
        myconf[LINKER].def = strdup(linker);
    }
    return type;
}

void 
SetAssembler(arg_t *argument, char *val)
{
    /* Set the assembler type */
    SetAssemblerType(val + 4);

    /* Add to the compiler as well */
    AddComp(val);
}

void 
SetOptions(char *arg, int num)
{
    char            name[LINEMAX + 1];
    char           *ptr, *ptr2;
    sscanf(arg, "%s%s", name, name);

    ptr = &arg[strlen(myconf[num].name) + 1];
    while (*ptr && isspace(*ptr))
        ++ptr;

    if ((ptr2 = strchr(ptr, '\n')))
        *ptr2 = 0;
    if ((ptr2 = strchr(ptr, '\r')))
        *ptr2 = 0;


    if (strncmp(name, myconf[num].name, strlen(myconf[num].name)) != 0) {
        SetConfig(ptr, num);
    } else {
        myconf[num].def = "";
    }
}



/*
 * If there's a \n in the option line then kill it
 */


void 
KillEOL(char *str)
{
    char           *ptr;
    if ((ptr = strrchr(str, '\n')))
        *ptr = 0;
}

/*
 *      Function to copy the files from /tmp to where they should be..
 *      if we want to keep them that is!
 */

void 
CopyOutFiles(char *suffix)
{
    int             j, k;
    char           *ptr1, *ptr2;

    for (j = 0; j < nfiles; j++) {
        ptr1 = changesuffix(filelist[j], suffix);
        if ( outputfile != NULL ) {
            ptr2 = strdup(outputfile);
        } else {
            ptr2 = changesuffix(orgfiles[j], suffix);
        }
        k = CopyFile(ptr1, "", ptr2, "");
        free(ptr1);
        free(ptr2);
        if (k) {
            fprintf(stderr, "Couldn't copy output files\n");
            exit(1);
        }
    }
}



void 
CleanUpFiles(void)
{
    int             j;

    /* Show all error files */

    if (myconf[CRT0].def)
        ShowErrors(myconf[CRT0].def, 0);
    for (j = 0; j < nfiles; j++) {
        ShowErrors(filelist[j], orgfiles[j]);
    }

    if (cleanup && usetemp) {    /* Default is yes */

        /*
         * Remove the temporary files, if they don't exist, it
         * doesn't matter!
         */
        for (j = 0; j < nfiles; j++) {
            CleanFile(filelist[j], ".i");
            CleanFile(filelist[j], ".asm");
            CleanFile(filelist[j], ".err");
            CleanFile(filelist[j], ".op1");
            CleanFile(filelist[j], ".op2");
            CleanFile(filelist[j], ".opt");
            CleanFile(filelist[j], OBJEXT);
            CleanFile(filelist[j], ".sym");
        }
        /*
         * Remove all files associated with startup file, if
         * necessary
         */
        if ((myconf[CRT0].def != 0) && (crtcopied != 0)) {
            CleanFile(myconf[CRT0].def, ".asm");
            CleanFile(myconf[CRT0].def, ".opt");
            CleanFile(myconf[CRT0].def, ".err");
            CleanFile(myconf[CRT0].def, OBJEXT);
            CleanFile(myconf[CRT0].def, ".map");
            CleanFile(myconf[CRT0].def, ".sym");
        }
    } else if (usetemp == NO) {
        /* Remove crt0.o file for -notemp compiles */
        CleanFile(myconf[CRT0].def, OBJEXT);
    }
    for (j = OPTIONS; j <= GENMATHLIB; j++) {
        if (myconf[j].def && strlen(myconf[j].def)) {
            free(myconf[j].def);
            myconf[j].def = 0;
        }
    }
    if (filelist) {
        for (j = 0; j < nfiles; j++) {
            free(filelist[j]);
            free(orgfiles[j]);
        }
        free(filelist);
        filelist = NULL;
    }
    if (linkargs) {
        free(linkargs);
        linkargs = NULL;
    }
    if (comparg) {
        free(comparg);
        comparg = NULL;
    }
    if (cpparg) {
        free(cpparg);
        cpparg = NULL;
    }
}


void 
CleanFile(char *file, char *ext)
{
    char           *temp;
    temp = changesuffix(file, ext);
    remove(temp);
    free(temp);        /* Being nice for once! */
}

/*
 * Copy the crt0 file over to /tmp to allow for many instantations of
 * zcc at a time..
 */


void 
CopyCrt0(void)
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

    oldptr = myconf[CRT0].def;
    if (CopyFile(oldptr, ".opt", filen, ".opt") || CopyFile(filen, ".opt", filen, ".asm")) {
        fprintf(stderr, "Cannot copy crt0 file\n");
        exit(1);
    }
    crtcopied = 1;
    newptr = mustmalloc(strlen(filen) + 1);
    strcpy(newptr, filen);
    free(oldptr);        /* Free old startup */
    myconf[CRT0].def = newptr;
}

/*
 * Show the error file attached to file filen
 */


void 
ShowErrors(char *filen, char *orig)
{
    char           *temp;
    char            buffer[LINEMAX + 1];
    int             j;
    FILE           *fp;

    temp = changesuffix(filen, ".err");
    if ((fp = fopen(temp, "r")) != 0) {
        if (orig)
            fprintf(stderr, "Errors in source file %s:\n", orig);
        else {
            /* We're printing linking errors, better print a key! */
            fprintf(stderr, "Key to filenames:\n");
            for (j = 0; j < nfiles; j++) {
                fprintf(stderr, "%s = %s\n", filelist[j], orgfiles[j]);
            }
        }
        while (fgets(buffer, LINEMAX, fp) != NULL)
            fprintf(stderr, "%s", buffer);
        fclose(fp);

    }
    free(temp);        /* Free temp buffer */

}

/*
 * Separate this off into a function to make MSDOG modifications easier
 */

void 
tempname(char *filen)
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
    mktemp(filen);
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
 *    If ZCCCFG doesn't exist then we take the PREFIX
 */

int 
FindConfigFile(char *arg, int gc)
{
    FILE           *fp;
    char           *cfgfile;

    /* Scan for an option file on the command line */
    if (arg[0] == '+') {
        strcpy(filenamebuf, arg + 1);
        gc++;        /* Increment first arg to search from */
        if (strstr(arg, ".cfg") != NULL) {
            if ((fp = fopen(filenamebuf, "r")) != NULL) {
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
            strcpy(filenamebuf, cfgfile);
            strcat(filenamebuf, arg + 1);
            strcat(filenamebuf, ".cfg");
            return (gc);
        } else {
#ifdef __MSDOS__
            snprintf(filenamebuf, sizeof(filenamebuf), "%s\\lib\\config\\%s.cfg", PREFIX, arg + 1);
#else
#ifdef AMIGA
            snprintf(filenamebuf, sizeof(filenamebuf), "%slib/config/%s.cfg", PREFIX, arg + 1);
#else
            snprintf(filenamebuf, sizeof(filenamebuf), "%s/lib/config/%s.cfg", PREFIX, arg + 1);
#endif
#endif
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
        strcpy(filenamebuf, cfgfile);
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
        strcpy(filenamebuf, cfgfile);
        strcat(filenamebuf, "zcc.cfg");
    } else {
#if 1
#if defined(__MSDOS__) && defined(__TURBOC__)
        /* Both predefined by Borland's Turbo C/C++ and Borland C/C++ */
        snprintf(filenamebuf, sizeof(filenamebuf), "%s\\lib\\config\\zcc.cfg", PREFIX);
#else
        snprintf(filenamebuf, sizeof(filenamebuf), "%s/lib/config/zcc.cfg", PREFIX);
#endif
#else
        fprintf(stderr, "Couldn't find env variable ZCCCFG\n");
        exit(1);
#endif
    }
    return (gc);
}

#if defined(AMIGA) && defined(_DCC)
/* Dice has no snprintf */
#include <stdarg.h>
int 
snprintf(char *buffer, size_t bufsize, const char *format,...)
{
    va_list         argptr;
    int             num_chars;

    va_start(argptr, format);
    num_chars = vsprintf(buffer, format, argptr);
    va_end(argptr);

    return num_chars;
}
#endif



#if  defined(__MSDOS__) && defined(__TURBOC__)
/* Both predefined by Borland's Turbo C/C++ and Borland C/C++ */
int 
snprintf(char *buffer, size_t bufsize, const char *format,...)
{
    va_list         argptr;
    int             num_chars;

    va_start(argptr, format);
    num_chars = vsprintf(buffer, format, argptr);
    va_end(argptr);

    return num_chars;
}
#endif


/* Parse options - rewritten to use strtok cos that's nice and easy */
void 
parse_option(char *option)
{
    char           *ptr;

    ptr = strtok(option, " \t\r\n");

    while (ptr != NULL) {
        if (ptr[0] == '-') {
            ParseArgs(ptr + 1);
        } else {
            AddToFileList(ptr);
        }
        ptr = strtok(NULL, " \r\n");
    }
}

/* Check link arguments (-l) to -i for z80asm */
void 
linkargs_mangle(char *linkargs)
{
    char           *ptr = linkargs;

    if (IS_ASM(ASM_Z80ASM) && strstr(myconf[LINKER].def, "z80asm")) {
        while ((ptr = strstr(linkargs, "-l")) != NULL) {
            ptr[1] = 'i';
        }
    }
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
