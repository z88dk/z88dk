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
 *      3/12/98 djm
 *
 *      16/2/99 djm 
 *      Reworking so that we read a config file which tells us all we
 *      need to know about paths etc - removes the variable things
 *      from the executable - and makes it more portable - thanks
 *      to Dennis for suggesting this one!
 *
 *      28/2/99 djm
 *      Added an extra option CRT0 - this allows us to do wildcard
 *      compiles such that main() doesn't have to be in the first
 *      file. We also have the parameter COPYCMD which is whatever
 *      the commmand is for copy files (COPYCMD [source] [dest]),
 *      this is needed because the output file gets dumped in
 *      {zcc}/lib/{CRT0}.bin because Z80 doesn't like being 
 *      specified an output filename.
 *
 *      Also added the cleanup routines, these are a bit nasty, so
 *      perhaps we could create temporary files (using tmpnam) -
 *      but we'll leave that for the moment (till a later release!)
 *
 *      An unwanted side effect of the cleanup routines is that if
 *      you supply a filename which isn't .c and you compile all
 *      the way through then the file will be zapped - for safety
 *      don't use -cleanup if you have non .c files!
 *
 *      30/3/99
 *      Another rejig! This time we pass any unknown options through
 *      to the compiler - so we can support other maths targets
 *      without recompiling this thing all the time.
 *
 *      Also, all specific references to the Z88 are out - we use the
 *      config file to specify if what the flag is if -lmz is supplied
 *      All libraries are now linked in via their name after -l after
 *      being appended to the LIBPATH flag - so we don't have to
 *      specify ghastly long paths
 *
 *      I've dumped all the ** stuff for argument lists - now everything
 *      is appended to one whopper of a line in memory - makes the code
 *      quite a bit simpler - not possible for files since we change
 *      the suffices constantly
 *
 *      Just one slight problem still, this kit can't really be used
 *      on a multiuser system because we assemble in zlib - sorting
 *      this out might require a few changes to the system so that
 *      we link pre-compiled object files for the maths files
 *
 *      1/4/99 More changes, this time allowing us to preserve zcc_opt.def
 *      and to go the next stage and create applications, well, it would
 *      except for my misunderstanding of the -g flag in z80asm - I
 *      thought that it outputted .def files at link time of objects, but
 *      I can't quite get it do it...pesky kids!
 *
 *      5/4/99 z80asm it seems doesn't treat DEFVARS -1 statements 
 *      correctly if they aren't assembled together, so, a temporary
 *      patch to allow this to be done is not to assemble before linking
 *      (this ensures DEFVARS are treated correctly)
 *
 *      15/4/99 Fixed it so temporary files are created in /tmp where
 *      all the processing will take place, we can cleanup with a clear
 *      conscience..we can cleanup with a clear consience, if we specify
 *      -a the program won't compile because of the header file thing..
 *      Still dependent on zlib: but if Gunther implements -o function
 *      then I think we might be able to get around it...
 *
 *
 *      19/4/99 We now copy the crt0 file to /tmp so multiusers and also
 *      gets around removing the file problems..total bonus!
 *
 *      26/4/99 Tidied up a few things, made all errors printable, though
 *      we do use a bizarre method to do it!
 *
 *      29/4/99 Fixed output name to be a.bin for apps (default name)
 *
 *      3/5/99  Made -make-lib pass through -make-lib to compiler (now
 *      it accepts it, remove all references to .hdr files)
 *
 *      10/5/99 New option -notemp does all processing in the current
 *      directory (copies CRT0 files over to a.#?) map files copied over
 *      if required in the case of usetemp and requested.
 *
 *      18/5/99 -notemp copies over to crt0.#? instead of a.#?
 *
 *	12/1/2000 - Added -nt option for appmake to avoid page
 *	truncation when making an app
 *
 *	23/1/2000 - Adding kludge for z80asm and removing any '.'
 *	in the temporary name and replacing with '_'
 *
 *	27/1/2000 - Third level of optimization
 *
 *	28/1/2000 - Added MSDOS tmpnam() code and decided to make
 *	zcc Makefile compatible by allow the -o option to come in
 *	the next argument
 *
 *	31/1/2000 - Added the STYLECPP command, works for outspec'd
 *	dunno about the others..
 *
 *	17/4/2000 - Added in the ability to have a config directory
 *	and made the + operator a tad more useful in specifying machines
 *	within that directory
 *
 *	29/1/2001 - Added in -Ca flag to pass commands to assembler on
 *	assemble pass (matches -Cp for preprocessor)
 *
 *      $Id: zcc.c,v 1.24 2003-10-30 11:13:30 dom Exp $
 */


#include        <stdio.h>
#include        <string.h>
#include        <stdlib.h>
#include        <ctype.h>
#include        "zcc.h"



/* All our function prototypes */

void ParseArgs(char *);
void AddComp(char *);
void AddPreProc(char *);
void AddToPreProc(char *);
void AddToAssembler(char *);
void AddAppmake(char *);
void AddToAppmake(char *);
void AddLink(char *);
void DispInfo(void);
void DispVer(char *);
void SetVerbose(char *);
void SetCompileOnly(char *);
void SetAssembleOnly(char *);
void SetOutputMap(char *);
void SetOutputSym(char *);
void SetPeepHole(char *);
void AddToFileList(char *);
void SetPeepHole(char *);
void SetZ80Verb(char *);
void SetOutputFile(char *);
void SetCleanUp(char *);
void UnSetCleanUp(char *);
void SetPreProcessOnly(char *);
void SetShowErrs(char *);
void SetLibMake(char *);
void SetPreserve(char *);
void SetCreateApp(char *);
void SetShortObj(char *);
void SetLateAssemble(char *);

void *mustmalloc(int);
int  hassuffix(char *, char *);
char *changesuffix(char *, char *);
int  process(char *, char *, char *, char *, enum iostyle, int, int);
int  linkthem(char *);
int  main(int, char **);
int  FindSuffix(char *);
void BuildAsmLine(char *, char *);
void ParseArgs(char *);
void BuildOptions(char **, char *);
void BuildOptions_start(char **, char *);
void CopyOutFiles(char *);
void ParseOpts(char *);
void SetNormal(char *,int);
void SetOptions(char *,int);
void SetNumber(char *,int);
void SetConfig(char *, int);
void KillEOL(char *);

void CleanUpFiles(void);
void CleanFile(char *, char *);
void CopyCrt0(void);
void ShowErrors(char *,char *);
void SetTemp(char *);
void UnSetTemp(char *);
void SetRelocate(char *);
int CopyFile(char *,char *, char *, char *);
void tempname(char *);
int FindConfigFile(char *, int);
void parse_option(char *option);

/* Mode Options, used for parsing arguments */


struct args myargs[]= {
    {"z80-verb",NO,SetZ80Verb},
    {"cleanup",NO,SetCleanUp},
    {"no-cleanup",NO,UnSetCleanUp},
    {"make-lib",NO,SetLibMake},
    {"preserve",NO,SetPreserve},
    {"make-app",NO,SetLateAssemble},
    {"create-app",NO,SetCreateApp},
    {"usetemp",NO,SetTemp},
    {"notemp",NO,UnSetTemp},
	{"Cp",YES,AddToPreProc},
	{"Ca",YES,AddToAssembler},
    {"Cz",YES,AddToAppmake},
    {"E",NO,SetPreProcessOnly},
    {"R",NO,SetRelocate},
    {"D",YES,AddPreProc},
    {"U",YES,AddPreProc},
    {"I",YES,AddPreProc},
    {"l",YES,AddLink},
    {"O",YES,SetPeepHole},
    {"h",NO,DispVer},
    {"v",YES,SetVerbose},
    {"c",NO,SetCompileOnly},
    {"a",NO,SetAssembleOnly},
    {"m",NO,SetOutputMap},
    {"s",NO,SetOutputSym},
    {"o",YES,SetOutputFile},
	{"nt",NO,AddAppmake},
	{"M",NO,SetShortObj},
	{"+",NO,AddPreProc},	/* Strips // comments in vcpp */
    {"",0,0}
};


struct confs myconf[]={
        {"OPTIONS",SetOptions,NULL},
        {"Z80EXE",SetNormal,NULL},
        {"CPP",SetNormal,NULL},
        {"LINKER",SetNormal,NULL},
        {"COMPILER",SetNormal,NULL},
        {"COPTEXE",SetNormal,NULL},
        {"COPYCMD",SetNormal,NULL},
        {"INCPATH",SetNormal,NULL},
        {"COPTRULES1",SetNormal,NULL},
        {"COPTRULES2",SetNormal,NULL},
	{"COPTRULES3",SetNormal,NULL},
        {"CRT0",SetNormal,NULL},
        {"LIBPATH",SetNormal,NULL},
        {"LINKOPTS",SetOptions,NULL},
        {"ASMOPTS",SetOptions,NULL},
        {"APPMAKE",SetNormal,NULL},
        {"Z88MATHLIB",SetNormal,NULL},
        {"Z88MATHFLG",SetNormal,NULL},
        {"STARTUPLIB",SetNormal,NULL},
        {"GENMATHLIB",SetNormal,NULL},
	{"STYLECPP",SetNumber,NULL},
        {"",NULL,NULL}
};

/*
 * Oh, I know these could be chars, but I'm lazy!
 */

#if defined(__MSDOS__) && defined(__TURBOC__)
/* Both predefined by Borland's Turbo C/C++ and Borland C/C++ */
int     usetemp         = 0;
#else
int     usetemp         = 1;
#endif
int     preserve        = 0;    /* don't destroy zcc_opt */
int     createapp       = 0;    /* Go the next stage and create the app */
int     makelib         = 0;
int     lateassemble    = 0;
int     makeapp		= 0;
int     z80verbose      = 0;
int     cleanup         = 1;
int     assembleonly    = 0;
int     compileonly     = 0;
int     verbose         = 0;
int     peepholeopt     = 0;
int     symbolson       = 0;
int     mapon           = 0;
int     ncppargs        = 0;
int     preprocessonly  = 0;
int     relocate        = 0;
int     crtcopied       = 0; /* Copied the crt0 code over? */
int	gargc;		     /* Copies of argc and argv */
char	**gargv;	
/* filelist has to stay as ** because we change suffix all the time */
int     nfiles          = 0;
char    **filelist;
char    **orgfiles;             /* Original filenames... */
int     ncompargs       = 0;
char    *outputfile;
char    *cpparg;
char    *comparg;
char    *linkargs;
char	*asmargs;
char	*appmakeargs;

char    outfilename[FILENAME_MAX+1];
char	extension[5];

#define OBJEXT extension

/*
 * Default output binary filename - why mess with genius?!?!
 */

char    *defaultout="a.bin";
char    *defaultbin="a.bin";

/* Okay! Off we Go! */

void *mustmalloc(n)
        int     n;
{
        void    *p;

        if ((p = malloc(n)) == 0)
        {
                fprintf(stderr, "malloc failed\n");
                exit(1);
        }
        return (p);
}

int hassuffix(name, suffix)
        char    *name, *suffix;
{
        int     nlen, slen;

        nlen = strlen(name);
        slen = strlen(suffix);

        if (slen > nlen)
                return (0);
        return (strcmp(&name[nlen-slen], suffix) == 0);
}

char *changesuffix(name, suffix)
        char    *name, *suffix;
{
        char    *p, *r;

        if ((p = strrchr(name, '.')) == 0)
        {
                r = mustmalloc(strlen(name) + strlen(suffix) + 1);
                sprintf(r, "%s%s", name, suffix);
        }
        else
        {
                r = mustmalloc(p - name + strlen(suffix) + 1);
                r[0] = '\0';
                strncat(r, name, p - name);
                strcat(r, suffix);
        }
        return (r);
}

int process(suffix, nextsuffix, processor, extraargs, ios,number,needsuffix)
        char    *suffix, *nextsuffix, *processor, *extraargs;
        enum iostyle    ios;
        int     number;
        int     needsuffix;     /* Should dump suffix (z80) oi! */
{
        int     status, errs;
        int     tstore;
        char    *buffer, *outname;

        errs = 0;
         if (!hassuffix(filelist[number], suffix)) return(0);

         switch (ios) {
                case outimplied:
                        buffer = mustmalloc(strlen(processor) + strlen(extraargs)+ strlen(filelist[number]) + 3);

/* Dropping the suffix for Z80..cheating! */
                        tstore=strlen(filelist[number])-strlen(suffix);

                        if (!needsuffix)
                                filelist[number][tstore]=0;

                        sprintf(buffer, "%s %s %s", processor, extraargs,
                                filelist[number]);
                        filelist[number][tstore]='.';
                        break;
                case outspecified:
/* This is only used for preprocessor, so, a quicj change here and
 * there..
 */
                        outname = changesuffix(filelist[number], nextsuffix);
                        buffer = mustmalloc(strlen(processor) + strlen(extraargs)
                                + strlen(orgfiles[number]) + strlen(outname) + 4);
                        sprintf(buffer, "%s %s %s %s", processor, extraargs,
                                orgfiles[number], outname);
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
           if (verbose)         puts(buffer);
                status = system(buffer);
                if (status  != 0)
                        errs = 1;
                else {
/*
 * Free up the allocated memory
 */
                   outname = changesuffix(filelist[number], nextsuffix);
                   free(filelist[number]);
                   filelist[number]=outname;
                }
                free(buffer);
        return (errs);
}

int linkthem(linker)
        char    *linker;
{
        int     i, n, status;
        char    *p;
        char    *asmline;    /* patch for z80asm */

/* patch for z80asm */
        if (peepholeopt) 
                asmline="-eopt ";
        else
                asmline="-easm ";

        n = (strlen(myconf[LINKER].def) + 1);
        if (lateassemble)
                n+=strlen(asmline);     /* patch for z80asm */
        n += (strlen("-nm -nv -o -R -M ")+strlen(outputfile));
        n += (strlen(linkargs) + 1);
        n += (strlen(myconf[CRT0].def)+2 );
        n += (2*strlen(myconf[LINKOPTS].def));
        for (i = 0; i < nfiles; ++i)
        {
                        n += strlen(filelist[i]);
        }
        p = mustmalloc(n);


        sprintf(p, "%s %s -o%s ", linker,myconf[LINKOPTS].def,outputfile);
        if      (lateassemble)             /* patch */
                strcat(p,asmline);      /* patch */
        if      (z80verbose)
                strcat(p,"-v ");
        if      (relocate) {
                if (lateassemble) 
                    fprintf(stderr,"Cannot relocate an application..\n");
                else strcat(p,"-R ");
        }
        strcat(p,linkargs);
/* Now insert the 0crt file (so main doesn't have to be the first file
 * linkargs last character is space..
 */
        strcat(p,myconf[CRT0].def);

        for (i = 0; i < nfiles; ++i)
        {
                if ( (!lateassemble && hassuffix(filelist[i], OBJEXT) ) || lateassemble )
                {
                        strcat(p, " ");
                        filelist[i][strlen(filelist[i])-strlen(OBJEXT)]='\0';
                        strcat(p, filelist[i]);
                }
        }
        if (verbose)
                printf("%s\n", p);
        status = system(p);
        free(p);
        return (status);
}

int main(argc, argv)
        int     argc;
        char    **argv;
{
        int     i, gc;
        char    *temp,*temp2;
        char    asmarg[4096];      /* Hell, that should be long enough! */
        char    buffer[LINEMAX+1]; /* For reading in option file */
        FILE    *fp;

/*
 * Okay, the fun begins now, first of all, lets use atexit so we can
 * cleanup after ourselves..
 */

        if (( atexit(CleanUpFiles)) != 0)
		printf("Couldn't register atexit() routine\n");

        strcpy(buffer,"  ");

        AddComp(buffer+1);
        asmargs=linkargs=cpparg=0;

        /* allocate enough pointers for all files, slight overestimate */
        filelist = (char **)mustmalloc(sizeof(char *) * argc);
        orgfiles = (char **)mustmalloc(sizeof(char *) * argc);

/* Now, find the environmental variable ZCCFILE which contains the
 * filename of our config file..
 */
        gc=1;           /* Set for the first argument to scan for */

/*
 * If we only have one parameter, we don't want to go any further..
 * (Linux quite rightly baulks..)
 */
        if (argc == 1 ) { DispInfo(); exit(1); }

	gc=FindConfigFile(argv[gc],gc);



/*
 * Okay, so now we read in the options file and get some info for us
 */

        if ( (fp=fopen(outfilename,"r") ) == NULL )  
        {
                fprintf(stderr,"Can't open config file %s\n",outfilename);
                exit(1);
        }

        while (fgets(buffer,LINEMAX,fp) != NULL) 
        {
                if (!isupper(buffer[0])) continue;
                ParseOpts(buffer);
        }
        fclose(fp);

/*
 *      Check to see if we are missing any definitions, if we are
 *      exit..
 */

        for (i= Z80EXE ; i<= GENMATHLIB ; i++ ) {
                if ( myconf[i].def == 0 ) {
                        fprintf(stderr,"Missing definition for %s\n",myconf[i].name);
                        exit(1);
                }
        }

/*
 *      Now, set the linkargs list up to initially consist of
 *      the startuplib
 */
		snprintf(buffer,sizeof(buffer),"%s%s ",myconf[LIBPATH].def,myconf[STARTUPLIB].def);
		BuildOptions(&linkargs,buffer);

/*
 *      Set the default output file
 */

        outputfile=defaultout;
        strcpy(outfilename,defaultout);

/*
 *	Copy the .obj into the extension var (used for linking &c)
 */
	strcpy(extension,".obj");



/*
 * That's dealt with the options, so onto real stuff now!
 */


        /* Now, parse the default options list */
        if ( myconf[OPTIONS].def != NULL ) {
	    parse_option(myconf[OPTIONS].def);
        }

/* Parse the argument list */

	gargv=argv;	/* Point argv to start of command line */

        for (gargc=gc;gargc<argc;gargc++) {
                if (argv[gargc][0]=='-') ParseArgs(1+argv[gargc]);
                else AddToFileList(argv[gargc]);
        }

/*
 *      Add the default cpp path
 */
        BuildOptions(&cpparg,myconf[INCPATH].def);


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
      if ( preserve == 0 ) {
        if ( (fp=fopen(DEFFILE,"w")) != NULL ) {
                fclose(fp);
                if (remove(DEFFILE) < 0 ) {
                        fprintf(stderr,"Cannot remove %s: File in use?\n",DEFFILE);
                        exit(1);
                }
/*
 *      It's the merry go round, here we try to open it again, so that
 *      if we specify non .c files compiling doesn't barf, ah, if only
 *      we could do a touch [filename]!
 */

                if ( ( fp=fopen(DEFFILE,"w")) != NULL) fclose(fp);
                else { fprintf(stderr,"Could not create %s: File in use?\n",DEFFILE); exit(1); }


         } else {
                fprintf(stderr,"Cannot open %s: File in use?\n",DEFFILE);
                exit(1);
         }
      }


        if (nfiles <= 0) {
                DispInfo();
                exit(0);
        }

/*
 * Kill \n on the end of certain option lines
 */
        KillEOL(myconf[LINKOPTS].def);
        KillEOL(myconf[ASMOPTS].def);

	/* We can't create an app and make a library.... */
	if ( createapp && makelib )
		createapp = NO;

/*
 * If we're making an app, we want the default name to be a.bin not a.out
 */
        if (createapp && outputfile==defaultout ) 
                outputfile=defaultbin;

	if ( createapp && makeapp )
		lateassemble = YES;


/*
 * Now, a little bit of trickery to allow many people to use zcc at
 * the same time (like they'd want to! But you never actually know!
 * Copy the z88_crt0.opt file over to /tmp or t: and use it as the
 * startup code...trickery ahoy!!!
 */
        CopyCrt0();     /* Cop out and use a function to do it - main() is too large! */




/*
 * Parse through the files, handling each one in turn
 */

        for     (i=0;i<nfiles;i++) {
                 switch (FindSuffix(filelist[i])) {
                        case CFILE:
                        if (process(".c", ".i", myconf[CPP].def, cpparg, (int)myconf[CPPSTYLE].def,i,YES))  exit(1);
                        if (preprocessonly) {
                                if (usetemp) CopyOutFiles(".i");
                                exit(0);
                        }

                        case PFILE:
                        if (process(".i", ".asm", myconf[COMPILER].def, comparg, outimplied,i,YES))  exit(1);

                        case AFILE:
				switch(peepholeopt) {
				  case 1:
                                        if (process(".asm", ".opt", myconf[COPTEXE].def, myconf[COPTRULES1].def, filter,i,YES))  exit(1);
					break;
				  case 2:
/* Double optimization! */
                                        if (process(".asm", ".op1", myconf[COPTEXE].def, myconf[COPTRULES2].def, filter,i,YES))  exit(1);

                                        if (process(".op1", ".opt", myconf[COPTEXE].def, myconf[COPTRULES1].def, filter,i,YES))  exit(1);
					break;
				  case 3:
/* Triple opt (last level adds routines but can save space..) */
                                        if (process(".asm", ".op1", myconf[COPTEXE].def, myconf[COPTRULES2].def, filter,i,YES))  exit(1);
                                        if (process(".op1", ".op2", myconf[COPTEXE].def, myconf[COPTRULES1].def, filter,i,YES))  exit(1);
                                        if (process(".op2", ".opt", myconf[COPTEXE].def, myconf[COPTRULES3].def, filter,i,YES))  exit(1);
					break;
				default:
                                	BuildAsmLine(asmarg,"-easm");
                                	if (!assembleonly && !lateassemble)
                                        	if (process(".asm", OBJEXT, myconf[Z80EXE].def, asmarg , outimplied,i,NO)) exit(1);
                        }
                        case OFILE:
                        BuildAsmLine(asmarg,"-eopt");
                        if (!assembleonly && !lateassemble)
                                if (process(".opt", OBJEXT, myconf[Z80EXE].def, asmarg , outimplied,i,NO)) exit(1);
                        break;
                }
        }
        if (compileonly || assembleonly) {
				if (compileonly && !assembleonly ) {
						if (usetemp) CopyOutFiles(OBJEXT);
				} else {
						if (usetemp) CopyOutFiles(peepholeopt ? ".opt" : ".asm");
				}
				exit(0);
		}

/* Link them, if errors, atexit() deals with them! */

		if (linkthem(myconf[LINKER].def)) exit(1);

		if      (createapp ) {
/*
 * Building an application - run the appmake command on it
 */
            snprintf(buffer,sizeof(buffer),"%s %s -b %s -c %s",myconf[APPMAKE].def,appmakeargs ? appmakeargs : "",outputfile,myconf[CRT0].def);	
            if (verbose) 
                printf("%s\n",buffer);
            if (system(buffer) ){
                fprintf(stderr,"Building application code failed\n");
                exit(1);
            }
        }
        if (mapon && usetemp ) {
                char    *oldptr;
                if ( (oldptr=strrchr(outfilename,'.')) ) *oldptr=0;
                if (CopyFile(myconf[CRT0].def,".map",outfilename,".map") ){
                        fprintf(stderr,"Cannot copy map file\n");
                        exit(1);
                }
        }
        exit(0);
}

int CopyFile(char *name1,char *ext1, char *name2, char *ext2)
{
        char    buffer[LINEMAX+1];
		snprintf(buffer,sizeof(buffer),"%s %s%s %s%s",myconf[COPYCMD].def, name1,ext1,name2,ext2);
		if (verbose) printf("%s\n",buffer);
        return(system(buffer));
}



/* New djm Functions start here! */


int FindSuffix(char *name)
{
        int     j;
        j=strlen(name);
        while(j && name[j]!='.') j--;

        if      (!j) return 0;

        j++;
        if (strcmp(&name[j],".c")) return CFILE;
        if (strcmp(&name[j],".i")) return PFILE;
        if (strcmp(&name[j],".asm")) return AFILE;
        if (strcmp(&name[j],".opt")) return OFILE;
        return 0;
}


void BuildAsmLine(char *dest, char *prefix)
{
	if (asmargs)
		strcpy(dest,asmargs);
	else
		strcpy(dest,"");
        strcat(dest,prefix);
        if (z80verbose)
                strcat(dest," -v ");   
        if      (!symbolson)
                strcat(dest," -ns ");
        strcat(dest,myconf[ASMOPTS].def);
}

/*
 *      Compile library files
 */

void SetLibMake(char *arg)
{
	makelib=YES;
        compileonly=YES;        /* Get to object file */
        peepholeopt=2*YES;
        AddComp(arg);
}

void SetPreserve(char *arg)
{
        preserve=YES;
}

void SetCreateApp(char *arg)
{
        createapp=YES;
}

void SetLateAssemble(char *arg)
{
    makeapp = YES;
    AddComp("-make-app");
}

void SetCompileOnly(char *arg)
{
        compileonly=YES;
}

void SetAssembleOnly(char *arg)
{
        assembleonly=YES;
}

void SetOutputMap(char *arg)
{
        mapon=YES;
}

void SetOutputSym(char *arg)
{
        symbolson=YES;
}

void SetOutputFile(char *arg)
{
	*outfilename=0;
        sscanf(&arg[1],"%s",outfilename);
        outputfile=outfilename;
        if (!strlen(outputfile) ) {
/* Invalid filename specified (null) try next argument up */
		if ( gargv[gargc+1][0] != '-' ) {
		/* Aha...non option comes next... */
			gargc++;
			strncpy(outfilename,gargv[gargc],sizeof(outfilename));
		} else
                	outputfile=defaultout;
        }
}

void SetPeepHole(char *arg)
{
        if ((arg[1]) == '2') peepholeopt=2*YES;
        else if ((arg[1]) == '0' ) peepholeopt=NO;
        else peepholeopt=arg[1]-'0';
}

void SetTemp(char *arg)
{
#if !defined(__MSDOS__) || !defined(__TURBOC__)
/* Both predefined by Borland's Turbo C/C++ and Borland C/C++ */
		usetemp=YES;
#endif
}

void UnSetTemp(char *arg)
{
		usetemp=NO;
}


void SetPreProcessOnly(char *arg)
{
        preprocessonly=YES;
}

void SetZ80Verb(char *arg)
{
        z80verbose=YES;
}

void AddToAssembler(char *arg)
{
	BuildOptions(&asmargs,arg+2);
	BuildOptions(&linkargs,arg+2);
}

void AddToAppmake(char *arg)
{
	BuildOptions(&appmakeargs,arg+2);
}

void AddAppmake(char *arg)
{
    BuildOptions(&appmakeargs,arg-1);
}


void AddToPreProc(char *arg)
{
	BuildOptions(&cpparg,arg+2);
}

void AddPreProc(char *arg)
{
        BuildOptions(&cpparg,arg-1);
}

void SetCleanUp(char *arg)
{
        cleanup=YES;
}

void UnSetCleanUp(char *arg)
{
        cleanup=NO;
}

void AddLink(char *arg)
{
        char    buffer[LINEMAX+1];      /* A little large! */
/*
 * We still have the "problem" of switching between maths literals,
 * so if -lmz is supplied (custom lib) then add in the special option
 * this way we can be as generic as possible
 */
        if (strcmp(arg,"lmz")==0) {
			parse_option(myconf[Z88MATHFLG].def);
			snprintf(buffer,sizeof(buffer),"%s%s ",myconf[LIBPATH].def,myconf[Z88MATHLIB].def);
			BuildOptions_start(&linkargs,buffer);
		return;
	} else if (strcmp(arg,"lm") == 0 ) {
			snprintf(buffer,sizeof(buffer),"%s%s ",myconf[LIBPATH].def,myconf[GENMATHLIB].def);
			BuildOptions_start(&linkargs,buffer);
		return;
	}

/*
 * Dump the changing of -ls into -i - we'll change the setup in the
 * zlib: directory so all the libraries have simple names
 * Build what the option will be and stick it in..
 */
		snprintf(buffer,sizeof(buffer),"%s%s ",myconf[LIBPATH].def,arg+1);
		BuildOptions_start(&linkargs,buffer);

}

/*
 * This routine appends the option arg onto the arglist specified
 * by list - creating a long string in the process
 */

void BuildOptions(char **list, char *arg)
{
		char    *temparg;
		int     len;
        temparg=*list;

        len=2+strlen(arg)+( temparg ? strlen(temparg) : 0 );
        temparg=realloc(temparg,len);
        if (temparg) {
                if (*list==0) *temparg=0;
                *list=temparg;
        } else {
                fprintf(stderr,"Out of memory\n");
                exit(1);
        }
        strcat(temparg,arg);
        strcat(temparg," ");
}

void BuildOptions_start(char **list, char *arg)
{
     char      *temparg;
     int        len;
     char      *orig = *list;
 
     len = 2 + strlen(arg) + ( orig ? strlen(orig) : 0 );
 
     if ( ( temparg = malloc(len) ) == NULL ) {
         fprintf(stderr,"Out of memory\n");
         exit(1);
     }
 
     *list = temparg;  /* Set the pointer to the new string */
     strcpy(temparg,arg);
     strcat(temparg," ");
     strcat(temparg,orig);
 
     free(orig);
}



void AddComp(char *arg)
{
        BuildOptions(&comparg,arg-1);
}

void AddToFileList(char *arg)
{
        char    filen[FILENAME_MAX+1];
        char *ptr;
        int     j;
        if (isspace(arg[0]) || arg[0] == 0 ) return;
/*
 *      First of all, copy the original filenames to orgfiles
 */
        ptr=mustmalloc(strlen(arg)+1);
        strcpy(ptr,arg);
        orgfiles[nfiles] = ptr;
/*
 *      Now, create a temporary filename, and copy from the original
 *      file, to the temporary file
 */
		if (usetemp) {
                tempname(filen);
                j=strlen(arg);
                while(j && arg[j]!='.') j--;

                if      (j==0) {
                        fprintf(stderr,"Unrecognised filetype\n");
                        return;
                }
                strcat(filen,&arg[j]);
/*
 * Copy the file over
 */
                if (!hassuffix(arg,".c") ){
                        if (CopyFile(arg,"",filen,"")) {
                                fprintf(stderr,"Cannot copy input file\n");
                                exit(1);
                        }
                }
        } else {
/* Not using temporary files.. */
                strcpy(filen,arg);
        }
/* Allocate space for it and dump it in the filelist */
        ptr=mustmalloc(strlen(filen)+1);
        strcpy(ptr,filen);
        filelist[nfiles++] = ptr;
}

void SetVerbose(char *arg)
{
        if (arg[1] == 'n') verbose = NO;
        else verbose=YES;
}

void DispVer(char *arg)
{
        DispInfo();
        exit(0);
}

void SetRelocate(char *arg)
{
        relocate=YES;
}



void SetShortObj(char *arg)
{
	strcpy(extension,".o");
}


void DispInfo(void)
{
        printf("zcc - Frontend for the z88dk Cross-C Compiler\n");
        printf(version);
}


void ParseArgs(char *arg)
{
        struct args *pargs;
        int     flag;
        pargs=myargs;
        flag=0;
        while(pargs->setfunc)
        {
                switch(pargs->more) {

/* More info follows the initial thing.. */
                case YES:
                        if (strncmp(arg,pargs->name,strlen(pargs->name))==0) {
                                (*pargs->setfunc)(arg);
                                flag=1;
                        }
                        break;
                case NO:

                        if (strcmp(arg,pargs->name)==0) {
                                (*pargs->setfunc)(arg);
                                flag=1;
                        }
                }
                if (flag) return;
                pargs++;
        }
        AddComp(arg);
}

void ParseOpts(char *arg)
{
        struct confs *pargs;
        int     num=0;
        pargs=myconf;

        while(pargs->setfunc)
        {
                if (strncmp(arg,pargs->name,strlen(pargs->name))==0) {
                        (*pargs->setfunc)(arg,num);
                        return;
                }
                num++;
                pargs++;
        }
        printf("Unrecognised config option: %s\n",arg);
        return;
}

/* 
 * Set the pointer in the myconf structure to be for out inputted thing
 * malloc the space for it, and then flunk if die..
 */

void SetConfig(char *arg, int num)
{
        if (myconf[num].def == NULL ) {
                myconf[num].def=(char *) mustmalloc(strlen(arg)+1);
                strcpy(myconf[num].def,arg);
        } else {
                fprintf(stderr,"%s already defined as %s",myconf[num].name,myconf[num].def);
        }
}
        
/*
 * Set a number option, very nasty, force our integer (0-2) to be
 * a char * type (saves a lot of rewriting really.. 
 */

void SetNumber(char *arg,int num)
{
        char name[LINEMAX+1];
	int	style;
        sscanf(arg,"%s%d",name,&style);
		if (style) 
			myconf[num].def=(char *)(style-1);
}

void SetNormal(char *arg,int num)
{
        char name[LINEMAX+1];
	char *ptr,*ptr2;
        sscanf(arg,"%s%s",name,name);

	ptr = &arg[strlen(myconf[num].name)+1];
	while (*ptr && isspace(*ptr))
		++ptr;

	if ( ptr2 = strchr(ptr,'\n') )
		*ptr2 = 0;
	if ( ptr2 = strchr(ptr,'\r') )
		*ptr2 = 0;


        if (strncmp(name,myconf[num].name,strlen(myconf[num].name)) != 0 ) {
                SetConfig(ptr,num);
        } 
}

void SetOptions(char *arg,int num)
{
        char name[LINEMAX+1];
	char *ptr,*ptr2;
        sscanf(arg,"%s%s",name,name);

	ptr = &arg[strlen(myconf[num].name)+1];
	while (*ptr && isspace(*ptr))
		++ptr;

	if ( ptr2 = strchr(ptr,'\n') )
		*ptr2 = 0;
	if ( ptr2 = strchr(ptr,'\r') )
		*ptr2 = 0;


        if (strncmp(name,myconf[num].name,strlen(myconf[num].name)) != 0 ) {
                SetConfig(ptr,num);
        } else {
		myconf[num].def = "";
	}
}



/*
 * If there's a \n in the option line then kill it
 */


void KillEOL(char *str)
{
        char    *ptr;
        if ( (ptr=strrchr(str,'\n')) ) *ptr=0;
}

/*
 *      Function to copy the files from /tmp to where they should be..
 *      if we want to keep them that is!
 */

void CopyOutFiles(char *suffix)
{
        int     j,k;
        char    *ptr1,*ptr2;

        for     (j=0;j<nfiles;j++) {
                ptr1=changesuffix(filelist[j],suffix);
                ptr2=changesuffix(orgfiles[j],suffix);
                k=CopyFile(ptr1,"",ptr2,"");
                free(ptr1); free(ptr2);
                if (k) {
                        fprintf(stderr,"Couldn't copy output files\n");
                        exit(1);
                }
        }
}


/*
 *      Functions to clean up after the compiler - these are called
 *      courtesy of atexit()
 *
 *      Cleanup mem now in here as well - to avoid crashes!
 */


void CleanUpFiles(void)
{
        int j;
/*
 *      Show all error files..
 */

        if (myconf[CRT0].def) ShowErrors(myconf[CRT0].def,0);
        for     (j=0; j<nfiles; j++ ) {
                ShowErrors(filelist[j],orgfiles[j]);
        }

   if (cleanup && usetemp) {       /* Default is yes */

/*
 * Remove the temporary files, if they don't exist, it doesn't matter!
 */
        for (j=0; j<nfiles; j++ ) {
             CleanFile(filelist[j],".i");
             CleanFile(filelist[j],".asm");
             CleanFile(filelist[j],".err");
             CleanFile(filelist[j],".op1");
	     CleanFile(filelist[j],".op2");
             CleanFile(filelist[j],".opt");
             CleanFile(filelist[j],OBJEXT);
             CleanFile(filelist[j],".sym");
        }
/*
 * Remove all files associated with startup file, if necessary 
 */
        if ( (myconf[CRT0].def!=0) && (crtcopied!=0) ) {
                CleanFile(myconf[CRT0].def,".asm");
                CleanFile(myconf[CRT0].def,".opt");
                CleanFile(myconf[CRT0].def,".err");
                CleanFile(myconf[CRT0].def,OBJEXT);
                CleanFile(myconf[CRT0].def,".map");
                CleanFile(myconf[CRT0].def,".sym");
	}
   } else if (usetemp==NO) {
	/* Remove crt0.o file for -notemp compiles */
	CleanFile(myconf[CRT0].def,OBJEXT);
   }


        for (j = OPTIONS ; j<= GENMATHLIB; j++ ) {
                if (myconf[j].def && strlen(myconf[j].def) ) { free(myconf[j].def); myconf[j].def=0;}
        }
        if (filelist) {
                for (j=0; j<nfiles; j++ ) {
                        free(filelist[j]);
                        free(orgfiles[j]);
                }
                free(filelist);
                filelist=0;
        }
        if (linkargs) { free(linkargs) ; linkargs=0; }
        if (comparg) { free(comparg) ; comparg=0; }
        if (cpparg) { free(cpparg) ; cpparg=0; }


}


void CleanFile(char *file,char *ext)
{
        char *temp;
        temp=changesuffix(file,ext);
        remove(temp);
        free(temp);     /* Being nice for once! */
}

/*
 * Copy the crt0 file over to /tmp to allow for many instantations of
 * zcc at a time..
 */


void CopyCrt0(void)
{
        char    filen[FILENAME_MAX+1];
        char    *oldptr, *newptr;

        if (compileonly || assembleonly || preprocessonly) return;
		if (usetemp) {
                tempname(filen);  /* Temporary nane..get it in filen */
        } else {
/* If not using temporary file then the gumph goes into crt0.#? */
                strcpy(filen,"crt0");
        }

/* Now to the copying the files over, used for both usetemp and !usetemp*/

        oldptr=myconf[CRT0].def;
        if ( CopyFile(oldptr,".opt",filen,".opt") || CopyFile(filen,".opt",filen,".asm") ) {
                fprintf(stderr,"Cannot copy crt0 file\n");
                exit(1);
        }
        crtcopied=1;
        newptr=mustmalloc(strlen(filen)+1);
        strcpy(newptr,filen);
        free(oldptr);   /* Free old startup */
        myconf[CRT0].def=newptr;
}

/*
 * Show the error file attached to file filen
 */


void ShowErrors(char *filen, char *orig)
{
        char    *temp;
        char    buffer[LINEMAX+1];
        int     j;
        FILE    *fp;

        temp=changesuffix(filen,".err");
        if ( (fp=fopen(temp,"r") ) != 0 ) {
                if (orig) fprintf(stderr,"Errors in source file %s:\n",orig);
                else {
/* We're printing linking errors, better print a key! */
                        fprintf(stderr,"Key to filenames:\n");
                        for (j=0;j<nfiles;j++) {
                                fprintf(stderr,"%s = %s\n",filelist[j],orgfiles[j]);
                        }
                }
                while (fgets(buffer,LINEMAX,fp) != NULL )
                        fprintf(stderr,"%s",buffer);
                fclose(fp);

        }
        free(temp);     /* Free temp buffer */

}

/* Separate this off into a function to make MSDOG modifications
 * easier
 */

void tempname(char *filen)
{
	char	*ptr;

#ifdef _WIN32
/* Predefined in 32-bit MS Visual C/C++ and Borland Builder C/C++ */
	if(ptr=getenv("TEMP")){      /* Under Windows 95 usually C:\WINDOWS\TEMP */
		strcpy(filen,ptr);   /* Directory is not guaranteed to exist */
		tmpnam(filen+strlen(filen)); /* Adds strings like "\s3vvrm3t.", "\s3vvrm3t.1", "\s3vvrm3t.2" */
	}
	else
		tmpnam(filen);
#elif defined(__MSDOS__) && defined(__TURBOC__)
/* Both predefined by Borland's Turbo C/C++ and Borland C/C++ */

	if(ptr=getenv("TEMP")){      /* From MS-DOS 5, C:\TEMP, C:\DOS, C:\WINDOWS\TEMP or whatever or nothing */
		strcpy(filen,ptr);   /* Directory is not guaranteed to exist */
		strcat(filen,"\\");
		tmpnam(filen+strlen(filen)); /* Adds strings like TMP1.$$$, TMP2.$$$ */
	}                                /* Allways starts at TMP1.$$$. Does not */
	else                             /* check if file already exists. So is  */
		tmpnam(filen);               /* not suitable for executing zcc more  */
		if(ptr=strrchr(filen,'.'))   /* than once without cleaning out files.*/
			*ptr=0;  /* Don't want to risk too long filenames */

#else
	tmpnam(filen);  /* Temporary nane..get it in filen */
#endif
	while (ptr=strchr(filen,'.') )
		*ptr='_';
}

/*
 *	Find a config file to use:
 *
 *	Scheme is as follows:
 *	Use ZCCFILE for compatibility
 *	If not, use ZCCCFG/zcc.cfg
 *		or  ZCCCFG/argv[1]
 *	Or as a first resort argv[1]
 *	Returns gc (or exits)
 *
 *	If ZCCCFG doesn't exist then we take the PREFIX 
 */

int FindConfigFile(char *arg, int gc)
{
	FILE	*fp;
	char	*cfgfile;

/*
 * Scan for an option file on the command line
 */
        if ( arg[0]=='+' ) {
/*
 *      Trapped the +
 */
                strcpy(outfilename,arg+1);
                gc++;   /* Increment first arg to search from */
		if (strstr(arg,".cfg") != NULL ) {
			if	( (fp=fopen(outfilename,"r")) != NULL ) {
				/* Local config file */
				fclose(fp);
				return(gc);
			}
		}
		cfgfile=getenv("ZCCCFG");
		if	(cfgfile != NULL ) {
			if (strlen(cfgfile) > FILENAME_MAX) {
				fprintf(stderr,"Possibly corrupt env variable ZCCCFG\n");
                       		exit(1);
               		}
		/* Config file in config directory */
			strcpy(outfilename,cfgfile);
			strcat(outfilename,arg+1);
			strcat(outfilename,".cfg");
			return(gc);
		} else {
#ifdef __MSDOS__
		snprintf(outfilename,sizeof(outfilename),"%s\\lib\\config\\%s.cfg",PREFIX,arg+1);
#else
#ifdef AMIGA
		snprintf(outfilename,sizeof(outfilename),"%slib/config/%s.cfg",PREFIX,arg+1);
#else
		snprintf(outfilename,sizeof(outfilename),"%s/lib/config/%s.cfg",PREFIX,arg+1);
#endif
#endif
		}
		/* User supplied invalid config file, let it fall over
		   back when */
		return(gc);
        } 
/*
 * Okay, nowt specified so get the old style entry
 */
	cfgfile=getenv("ZCCFILE");
        if (cfgfile != NULL ) {
		if (strlen(cfgfile) > FILENAME_MAX) {
			fprintf(stderr,"Possibly corrupt env variable ZCCFILE\n");
                       	exit(1);
               	}
               	strcpy(outfilename,cfgfile);
		return  (gc);
	}
/*
 * Last resort! 
 * New style config take ZCCCFG/zcc.cfg
 */
	cfgfile=getenv("ZCCCFG");
	if (cfgfile !=NULL ) {
		if (strlen(cfgfile) > FILENAME_MAX) {
			fprintf(stderr,"Possibly corrupt env variable ZCCCFG\n");
                       	exit(1);
               	}
		strcpy(outfilename,cfgfile);
		strcat(outfilename,"zcc.cfg");
	} else {
#if 1
#if defined(__MSDOS__) && defined(__TURBOC__)
/* Both predefined by Borland's Turbo C/C++ and Borland C/C++ */
	    snprintf(outfilename,sizeof(outfilename),"%s\\lib\\config\\zcc.cfg",PREFIX);
#else
	    snprintf(outfilename,sizeof(outfilename),"%s/lib/config/zcc.cfg",PREFIX);
#endif
#else
		fprintf(stderr,"Couldn't find env variable ZCCCFG\n");
		exit(1);
#endif
	}
	return(gc);
}

#if defined(AMIGA) && defined(_DCC)
/* Dice has no snprintf */
#include <stdarg.h>
int snprintf(char * buffer, size_t bufsize, const char * format, ...)
{
	va_list argptr;
	int num_chars;

	va_start(argptr,format);
	num_chars = vsprintf(buffer, format, argptr);
	va_end(argptr);

	return num_chars;
}
#endif



#if  defined(__MSDOS__) && defined(__TURBOC__) 
/* Both predefined by Borland's Turbo C/C++ and Borland C/C++ */
int snprintf(char * buffer, size_t bufsize, const char * format, ...)
{
	va_list argptr;
	int num_chars;

	va_start(argptr,format);
	num_chars = vsprintf(buffer, format, argptr);
	va_end(argptr);

	return num_chars;
}
#endif


/* Parse options - rewritten to use strtok cos that's nice and easy */
void parse_option(char *option)
{
    char   *ptr;

    ptr = strtok(option," \t\r\n");

    while ( ptr != NULL ) {
	if ( ptr[0] == '-' ) {
	    ParseArgs(ptr+1);
	} else {
	    AddToFileList(ptr);
	}
	ptr = strtok(NULL," \r\n");
    }
}
