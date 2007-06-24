/*
 *      Small C+ Compiler -
 *
 *      Main() part
 *
 *      $Id: main.c,v 1.17 2007-06-24 14:42:48 dom Exp $
 */

#include "ccdefs.h"

#if defined(__MSDOS__) && defined(__TURBOC__)
extern unsigned _stklen=8192U; /* Default stack size 4096 bytes is too small. */
#endif



/* 
 *      Data used in this file only
 */

char Filenorig[FILENAME_LEN+1];
unsigned int zorg;      /* Origin for applications */

int     reqpag;         /* required bad pages */
int     defvars;
int     safedata;       /* amount of safe workspace required */
int     intuition;      /* Intuitiono to debug?!?!? */
int     smartprintf;    /* Map printf -> miniprintf */
int     expanded;       /* Do we need expanded Z88? */
int     ansistdio;      /* Complex ANSI stdio       */
int     startup;        /* Which startup to we want? app has it's own
                           but by using -startup= we can switch
                           between "BASIC" startups, eg for shell
                           etc..
                         */
int     makeshare;      /* Do we want to make a shared library? */
int     useshare;      /* Use shared lib routines? */
int	sharedfile;	/* File contains routines which are to be
			 * called via lib package - basically jimmy
			 * the stack but that's it..
			 */

int     noaltreg;       /* No alternate registers */
int     usempm;         /* We're using mpm */

/*
 * Some external data
 */


extern  int     gotocnt;        /* No of gotos */
extern  GOTO_TAB *gotoq;         /* Pointer for gotoq */



void    SetMPM(char *);
void    SetSmart(char *);
void    UnSetSmart(char *);
void    SetExpand(char *);
void    UnSetExpand(char *);
void    SetANSIstdio(char *);
void    SetMakeShared(char *);
void    SetUseShared(char *);


/*
 *
 *      Code...
 *
 */
 


/*
 *      Compiler begins execution here
 */
int main(int argc, char **argv)
{
        int     n;      /* Loop counter */
        gargc = argc ;
        gargv = argv ;
/*
 * Empty our mem ptrs
 */

        litq=dubq=tempq=glbq=0;
        symtab=loctab=0;
        wqueue=0;membptr=0;tagptr=0;swnext=0;stage=0;
        gotoq=0;

        /* allocate space for arrays */
        litq = mymalloc(FNLITQ) ;         /* literals, these 2 dumped end */
        dubq = mymalloc(FNLITQ) ;         /* Doubles */
        tempq = mymalloc(LITABSZ) ;        /* Temp strings... */
        glbq  = mymalloc(LITABSZ) ;        /* Used for glb lits, dumped now */
        symtab = SYM_CAST mymalloc(NUMGLBS*sizeof(SYMBOL)) ;
        loctab = SYM_CAST mymalloc(NUMLOC*sizeof(SYMBOL)) ;
        wqueue = WQ_CAST mymalloc(NUMWHILE*sizeof(WHILE_TAB)) ;
        gotoq= (GOTO_TAB *)calloc(NUMGOTO,sizeof(GOTO_TAB));
	if (gotoq==NULL) OutOfMem();

        tagptr = tagtab = TAG_CAST mymalloc(NUMTAG*sizeof(TAG_SYMBOL)) ;
        membptr = membtab = SYM_CAST mymalloc(NUMMEMB*sizeof(SYMBOL)) ;

        swnext = SW_CAST mymalloc(NUMCASE*sizeof(SW_TAB)) ;
        swend = swnext + (NUMCASE-1) ;

        stage = mymalloc(STAGESIZE) ;
        stagelast = stage+STAGELIMIT ;

        /* empty symbol table */
        glbptr = STARTGLB;
        while ( glbptr < ENDGLB ) {
                glbptr->name[0] = 0 ;
                ++glbptr ;
        }

        glbcnt = 0 ;                    /* clear global symbols */
        locptr = STARTLOC ;             /* clear local symbols */
        wqptr = wqueue ;                /* clear while queue */
        gltptr=dubptr=0 ;               /* clear literal pools */
        *litq=0;         /* First entry in literal queue is zero */
        litptr=1;       /* So miniprintf search works */

        Zsp =                   /* stack ptr (relative) */
        errcnt =                /* no errors */
        errstop =               /* keep going after an error */
        eof =                   /* not eof yet */
        swactive =              /* not in switch */
        skiplevel =             /* #if not encountered */
        iflevel =               /* #if nesting level = 0 */
        ncmp =                  /* no open compound states */
        lastst =                /* not first file to asm */
        fnstart =               /* current "function" started at line 0 */
        lineno =                /* no lines read from file */
        infunc =                /* not in function now */
                        0 ;             /*  ...all set to zero.... */

        stagenext = NULL_CHAR ; /* direct output mode */

        input =                                 /* no input file */
        inpt2 =                                 /* or include file */
        saveout =                               /* no diverted output */
        output = NULL_FD ;              /* no open units */

        currfn = NULL_SYM ;             /* no function yet */
        macptr = cmode = 1 ;    /* clear macro pool and enable preprocessing */
        ncomp=doinline=mathz88 = incfloat= compactcode =0;
        intuition=zorg=lpointer=cppcom=appz88=0;
        dosigned=NO;
        ansistdio=makelib=useshare=makeshare=sharedfile=NO;
        smartprintf=expanded=YES;
        startup=0;                      /* Which startup do we want? */
        nxtlab =                        /* start numbers at lowest possible */
        ctext =                         /* don't include the C text as comments */
        errstop =                       /* don't stop after errors */
        verbose = 0;
        gotocnt=0;
	defdenums=0;
	doublestrings = 0;
	noaltreg = NO;
        safedata=reqpag = -1;
	shareoffset=SHAREOFFSET;	/* Offset for shared libs */
	debuglevel=NO;
	farheapsz=-1;			/* Size of far heap */
	asxx=NO;
    usempm = NO;
	printflevel=0;
#ifdef USEFRAME
	indexix=YES;
	useframe=NO;
#endif

        /*
         *      compiler body
         */
        setup_sym() ;   /* define some symbols */
/* Parse the command line options */
        atexit(MemCleanup);     /* To free everything */
        clear();
        filenum=0;
        for (n=1;n<argc;n++) {
                if (argv[n][0]=='-') ParseArgs(1+argv[n]);
                else {filenum=n; break;}
        }
        clear();

        if (filenum == 0)
        {
                info();
                exit(1);
        }
        litlab=getlabel();              /* Get labels for function lits*/
        dublab=getlabel();              /* and fn doubles*/
        openout();              /* get the output file */
        openin();               /* and initial input file */
        header();               /* intro code */
        parse();                /* process ALL input */
        /* dump literal queues, with label */
        /* litq starts from 1, so literp has to be -1 */
        dumplits(0, YES,litptr-1,litlab,litq+1) ;
        dumplits(1, YES,dubptr,dublab,dubq) ;
        dumpvars();
        dumpfns();
        trailer();              /* follow-up code */
        closeout();
        errsummary();   /* summarize errors */
        if (errcnt) exit(1);
        exit(0);
}


/*
 *      Abort compilation
 */

#ifndef SMALL_C
void 
#endif

ccabort()
{
        if ( inpt2 != NULL_FD )
                endinclude();
        if ( input != NULL_FD )
                fclose(input);
        closeout();
        fprintf(stderr,"Compilation aborted\n");
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
        while ( eof == 0 ) {            /* do until no more input */
                if ( amatch("extern") )
                        dodeclare(EXTERNAL, NULL_TAG, 0) ;
                else if (amatch("static"))
                        dodeclare(LSTATIC, NULL_TAG, 0) ;
                else if (amatch("typedef"))
                        dodeclare(TYPDEF,NULL_TAG,0) ;
                else if (dodeclare(STATIK, NULL_TAG, 0) ) ;
                else if ( ch() == '#' ) {
                        if (match("#asm")) doasm();
                        else if (match("#include")) doinclude() ;
                        else if (match("#define") ) addmac() ;
                        else 
                        {
                                clear();
                                blanks();
                        }
                }
                else newfunc();
                blanks();       /* force eof if pending */
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
        if (ncmp) { error(E_BRACKET); nl(); }
                /* open compound statement ... */
        if (verbose){
                printf("Symbol table usage: %d\n",glbcnt);
                printf("Structures defined: %ld\n",(long)(tagptr-tagtab));
                printf("Members defined:    %ld\n",(long)(membptr-membtab));
                printf("There %s %d %s in compilation.\n", (errcnt==1 ? "was" : "were"),errcnt, (errcnt==1 ? "error" : "errors") );
        }
}


/*
 * places in s the n-th argument (up to "size"
 * bytes). If successful, returns s. Returns 0
 * if the n-th argument doesn't exist.
 */

#ifndef SMALL_C
char *
#endif

nextarg(int n, char *s, int size)
{
        char *str;
        char *str2;
        int i;

        if ( n < 1 || n >= gargc ) return NULL_CHAR ;
        i = 0 ;
        str = str2 =gargv[n] ;
        while ( ++i < size && (*s++ = *str++) )
                ;
        if (*str2 == '\0' ) return NULL_CHAR;
        return s ;
}


/*
 * make a few preliminary entries in the symbol table
 */

#ifndef SMALL_C
void
#endif

setup_sym()
{
        defmac("Z80") ;
        defmac("SMALL_C") ;
        /* dummy symbols for pointers to char, int, double */
        /* note that the symbol names are not valid C variables */
        dummy_sym[0] = 0 ;
        dummy_sym[CCHAR] = addglb("0ch", POINTER, CCHAR, 0, STATIK, 0,0) ;
        dummy_sym[CINT] = addglb("0int", POINTER, CINT, 0, STATIK, 0,0) ;
        dummy_sym[DOUBLE] = addglb("0dbl", POINTER,DOUBLE,0,STATIK, 0,0) ;
        dummy_sym[LONG] = addglb("0lng", POINTER, LONG, 0, STATIK, 0,0) ;
        dummy_sym[CPTR] = addglb("0cpt", POINTER, CPTR, 0, STATIK, 0,0) ;
        dummy_sym[VOID] = addglb("0vd", POINTER, VOID, 0 , STATIK, 0,0) ;
}

#ifndef SMALL_C
void
#endif

info()
{
        fputs(titlec,stderr);
        fputs(Version,stderr);
        fputs("\n(C) 1980-2004 Cain, Van Zandt, Hendrix, Yorston, Morris\n",stderr);
        fprintf(stderr,"Usage: %s [flags] [file]\n",gargv[0]);
        
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


/*
 *      Write out the header file! - djm
 */

#ifdef HEADFILE
void dohdrfi()
{
        char file2[FILENAME_LEN+1];
        char    *file3;
        if (verbose)
                fputs("Writing header file\n",stderr);
        clear();
        strcpy(file2,Filenorig);
        changesuffix(file2,".hdr");
        file3=file2;
        while (*file3=='"') file3++;
        if ((output=fopen(file3,"w")) != NULL )
        {
                dumpfns();
                fclose(output);
                output=0;
        }
        else {
                fprintf(stderr,"Cannot open output file: %s\n",file3);
        }
}
#endif


/* djm write out the header file */

#ifndef SMALL_C
void 
#endif

dumpfns()
{
    int ident,type,storage;
    SYMBOL *ptr;
    FILE    *fp;

#ifdef HEADERFILE
    outstr(";\tHeader file for file:\t");
    outstr(Filename);
    outstr("\n;\n;\tEven if empty do not delete!!!\n");
    outstr(";\n;\t***START OF HEADER DEFNS***\n\n");
#else
    outstr("\n\n; --- Start of Scope Defns ---\n\n");
#endif
    if (!glbcnt)
        return;

/* Start at the start! */
    glbptr=STARTGLB;

    ptr=STARTGLB;
    while (ptr < ENDGLB) {
        if (ptr->name[0] != 0 && ptr->name[0] != '0' ) {
            ident=ptr->ident;
			if (ident==FUNCTIONP) ident=FUNCTION;
            type =ptr->type;
            storage=ptr->storage;
            if ( ident == FUNCTION && ptr->size != 0 ) {
                outstr("\tdefc\t");
                outname(ptr->name,1);
                ot("=\t");
                outdec(ptr->size);
                nl();
            } else {
                if (ident == FUNCTION && storage!=LSTATIC ) {
                    if (storage==EXTERNAL) {
                        if (ptr->flags&LIBRARY) {
                            GlobalPrefix(LIB);
                            if ( (ptr->flags&SHARED) && useshare ){
                                outstr(ptr->name); outstr("_sl\n");
                                GlobalPrefix(LIB);
                            }
                        } else {
                            GlobalPrefix(XREF);
                        }
                    } else {
                        if (ptr->offset.i == FUNCTION || ptr->storage==DECLEXTN )
                            GlobalPrefix(XDEF);
                        else
                            GlobalPrefix(XREF);
                    }
                    outname(ptr->name,dopref(ptr));
                    nl();
                } else {
                    if (storage == EXTERNP) {
                        GlobalPrefix(XDEF);
                        outname(ptr->name,1);
                        nl();
                        outstr("\tdefc\t");
                        outname(ptr->name,1);
                        ot("=\t");
                        outdec(ptr->size);
                        nl();
                    } else  if (ident != ENUM && type !=ENUM && ident != MACRO && storage != LSTATIC && storage != LSTKEXT && storage!=TYPDEF ) {
                        if (storage == EXTERNAL)
                            GlobalPrefix(XREF);
                        else 
                            GlobalPrefix(XDEF);
                        outname(ptr->name,1);
                        nl();
                    }
                }
            }
        }
        ++ptr;
    }
/*
 *      If a module requires floating point then previously we wrote
 *      it out to the header file. However, if the module didn't
 *      contain main() then important routines wouldn't be included.
 *      So, if main didn't need float, but ours did we couldn't
 *      compile correctly.
 *
 *      The solution was to separate startup code, and then define
 *      a new file to which all the math type headers would be
 *      appended.
 *
 *      This file is zcc_opt.def in the source code directory.
 *
 */

    if ( (fp=fopen("zcc_opt.def","a")) == NULL ) {
        error(E_ZCCOPT);
    }
/* Now output the org */
    if (zorg) {
        fprintf(fp,"\tDEFINE DEFINED_myzorg\n");
        fprintf(fp,"\tdefc myzorg = %u\n",zorg);
    }
    if (appz88) {
        int k,value=0;
        fprintf(fp,"\nIF !NEED_appstartup\n");
        fprintf(fp,"\tDEFINE\tNEED_appstartup\n");
        if (safedata != -1 )
            fprintf(fp,"\tdefc safedata = %d\n",safedata);
        if (intuition)
            fprintf(fp,"\tdefc intuition = 1\n");
        if (farheapsz != -1) {
            fprintf(fp,"\tDEFINE DEFINED_farheapsz\n");
            fprintf(fp,"\tdefc farheapsz = %d\n",farheapsz);
        }
 
        if (reqpag != -1 ) {
            fprintf(fp,"\tdefc reqpag = %d\n",reqpag);
            value=reqpag;
        }
        else {
/*
 * Consider the malloc pool as well, if defined we need 32 (standard) +
 * size of malloc - this is a little kludgy, hence the tuning command
 * line option
 */
            if ( (k=findmac("HEAPSIZE"))) {
                sscanf(&macq[k],"%d",&value);
                if (value != 0 ) value/=256;
            }
            value+=32;
            fprintf(fp,"\tdefc reqpag = %d\n",value);
        }
        if (value > 32) expanded=YES;
        fprintf(fp,"\tdefc NEED_expanded = %d\n",expanded);
        fprintf(fp,"ENDIF\n\n");

    }
    if (incfloat) {
        fprintf(fp,"\nIF !NEED_floatpack\n");
        fprintf(fp,"\tDEFINE\tNEED_floatpack\n");
        fprintf(fp,"ENDIF\n\n");
    }
    if (mathz88) {
        fprintf(fp,"\nIF !NEED_mathz88\n");
        fprintf(fp,"\tDEFINE\tNEED_mathz88\n");
        fprintf(fp,"ENDIF\n\n");
    }
    if (lpointer) {
        fprintf(fp,"\nIF !NEED_farpointer\n");
        fprintf(fp,"\tDEFINE NEED_farpointer\n");
        fprintf(fp,"ENDIF\n\n");
    }
    if (startup) {
        fprintf(fp,"\nIF !DEFINED_startup\n");
        fprintf(fp,"\tDEFINE DEFINED_startup\n");
        fprintf(fp,"\tdefc startup=%d\n",startup);
        fprintf(fp,"ENDIF\n\n");
    }
/*
 * Now, we're gonna use #pragma define _FAR_PTR to indicate whether we need
 * far stuff - this has to go with a -D_FAR_PTR from the compile line
 * as well for everything to work just right, so if we find this then
 * we can indicate to the startup code via zcc_opt.def what the scam
 * is - this could be used for eg. to allocate space for file structures
 * etc
 */
    if ( (ptr=findglb("_FAR_PTR")) && ptr->ident==MACRO ) {
        fprintf(fp,"\nIF !NEED_farstartup\n");
        fprintf(fp,"\tDEFINE NEED_farstartup\n");
        fprintf(fp,"ENDIF\n\n");
    }

    fclose(fp);

	if ( defvars != 0 )
		WriteDefined("defvarsaddr",defvars);

	switch(printflevel) {
    case 1:  
        WriteDefined("ministdio",0);
        break;
    case 2:
        WriteDefined("complexstdio",0);
        break;
    case 3:
        WriteDefined("floatstdio",0);
        break;
	}
 

/*
 * DO_inline is obsolete, but it may have a use sometime..
 */
    if (doinline)
        outstr("\tDEFINE\tDO_inline\n");
    outstr("\n\n; --- End of Scope Defns ---\n\n");
}

/*
 * Dump some text into the zcc_opt.def, this allows us to define some
 * things that the startup code might need
 */

void PragmaOutput(char *ptr)
{
        char *text;
        FILE *fp;

        text = strchr(ptr,' ');
        if ( text == NULL ) text = strchr(ptr,'\t');

        if ( text != NULL ) {
                *text = 0;
                text++;
                if ( (fp=fopen("zcc_opt.def","a")) == NULL ) {
                        error(E_ZCCOPT);
                }
                fprintf(fp,"\nIF NEED_%s\n",ptr);
                fprintf(fp,"\tdefm\t\"%s\"\n",text);
		fprintf(fp,"\tdefc DEFINED_NEED_%s = 1\n",ptr);
                fprintf(fp,"ENDIF\n\n");
                fclose(fp);
        }
}

/* Dump some bytes into the zcc_opt.def file */

void PragmaBytes(int flag)
{
    FILE   *fp;
    char   sname[NAMESIZE];
    long    value;
    int     count;

    if ( symname(sname) ) {
	if ( (fp=fopen("zcc_opt.def","a")) == NULL ) {
	    error(E_ZCCOPT);
	}
	fprintf(fp,"\nIF NEED_%s\n",sname);
	if ( flag ) 
	    fprintf(fp,"\tdefc DEFINED_NEED_%s = 1\n",sname);

	/* Now, do the numbers */
	count=0;
	while ( !cmatch(';') ) {
	    if ( count == 0 )
		fprintf(fp,"\n\tdefb\t");
	    else
		fprintf(fp,",");
	    if ( number(&value) ) {
		fprintf(fp,"%ld",value);
	    } else {
		warning(W_EXPARG);
	    }
	    if ( rcmatch(';') ) {
		break;
	    }
	    needchar(',');
	    count++;
	    if ( count == 9 ) count=0;
	}
	fprintf(fp,"\nENDIF\n");
	fclose(fp);
	needchar(';');
    }
}	





/*
 * Dump a function into the zcc_opt.def file - this allows us to pass
 * important functions to the appstartup code so it can call them
 * when appropriate, we also XREF it so we don't have to do that in
 * the startup code
 */

void WriteDefined(char *sname, int value)
{
        FILE *fp;

        if ( (fp=fopen("zcc_opt.def","a")) == NULL ) {
                error(E_ZCCOPT);
        }
        fprintf(fp,"\nIF !DEFINED_%s\n",sname);
        fprintf(fp,"\tdefc\tDEFINED_%s = 1\n",sname);
	if (value) fprintf(fp,"\tdefc %s = %d\n",sname,value);
        fprintf(fp,"ENDIF\n\n");
        fclose(fp);
}




/*
 * Dump the DEFVAR statement out - will also be for DEFDATA..eventually!
 */

#ifndef SMALL_C
void
#endif

dumpvars()
{
        int ident,type,storage;
        SYMBOL *ptr;

        if (!glbcnt)
                return;

/* Start at the start! */
        glbptr=STARTGLB;
        outstr("; --- Start of Static Variables ---\n\n");
/* Two different handlings, if an application then use defvars construct
 * if not, then just drop em using defs!
 *
 * Even more handlings...if asz80 used we dump into data sectio
 */

	if (asxx)
		ol(".area _BSS");

        if (appz88 && !asxx ) {
                outstr("DEFVARS\t");
#if 0
                if (defvars) outdec(defvars);
                else outstr("-1");
                outstr("\n{\n");
#else
		outstr("-1\n{\n");
#endif
	}
        ptr=STARTGLB;
        while (ptr < ENDGLB)
        {
                if (ptr->name[0] != 0 && ptr->name[0] != '0' )
                {
                        ident=ptr->ident;
                        type =ptr->type;
                        storage=ptr->storage;
                        if (ident !=ENUM && type !=ENUM && ident != MACRO && ident != FUNCTION && storage != EXTERNAL && storage != DECLEXTN && storage != EXTERNP && storage != LSTKEXT && storage!=TYPDEF )
                        {
                        if (!appz88) prefix();
                        outname(ptr->name,1);
			col();
                        if (appz88 && !asxx) outstr("\n\tds.b\t");
                        else  defstorage();
                        outdec(ptr->size);
                        nl();
                        }
                }
        ++ptr;
        }

        if (appz88 && !asxx) outstr("}\n");      /* close defvars statement */
}

/*
 *      Dump the literal pool if it's not empty
 *      Modified by djm to be able to input which queue should be
 *      dumped..
 */


void dumplits(
    int size, int pr_label ,
    int queueptr,int queuelab,
    unsigned char *queue)
{
    int j, k,lit ;

    if ( queueptr ) {
        if ( pr_label ) {
			if (asxx) ol(".area _TEXT");
            prefix(); queuelabel(queuelab) ;
            col() ; nl();
        }
        k = 0 ;
        while ( k < queueptr ) {
            /* pseudo-op to define byte */
            if (infunc) j=1;
            else j=10;
            if (size == 1) defbyte();
            else if (size == 4) deflong();
            else if (size == 0 ) { defmesg(); j=30; }
            else defword();
            while ( j-- ) {
                if (size==0) {
                    lit=getint(queue+k,1);
                    if (lit >= 32 && lit <= 126  && lit != '"' ) outbyte(lit);
                    else {
						if (asxx) {
							outstr("\"\n");
							defbyte();
							outdec(lit);
							nl();
							lit=0;
						} else {
                            /* Now z80asm */
                            if ( usempm ) {
                                outstr("\",");
                            } else {
                                outstr("\"&");
                            }
                            outdec(lit);
                            if (lit) {
                                if ( usempm ) {
                                    outstr(",\"");
                                } else {
                                    outstr("&\"");
                                }
                            }
						}
                    }
                    k++;
                    if ( j == 0 || k >=queueptr || lit == 0 ) {
                        if (lit) outbyte('"');
                        nl();
                        break;
                    }
                } else {
                    outdec(getint(queue+k, size));
                    k += size ;
                    if ( j == 0 || k >= queueptr ) {
                        nl();           /* need <cr> */
                        break;
                    }
                    outbyte(',');   /* separate bytes */
                }
            }
        }
    }
    nl();
}



/*
 * dump zeroes for default initial value
 * (or rather, get loader to do it for us)
 */
int dumpzero(int size, int count)
{
        if (count <= 0) return (0);
        defstorage() ;
        outdec(size*count) ;
/*        outstr("dumpzero"); */
        nl();
        return(size*count);
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
        char filen2[FILENAME_LEN+1];
        FILE *fp;
        clear() ;               /* erase line */
        output = 0 ;    /* start with none */
        if ( nextarg(filenum, filen2, FILENAME_LEN) == NULL_CHAR ) return ;
/* For weird reasons, output is opened before input, so have to check
 * input exists beforehand..
 */
        if ( ( fp=fopen(filen2,"r")) == NULL )
                {
                fprintf(stderr,"Cannot open source file: %s\n",filen2);
                exit(1);
                }
        fclose(fp);     /* Close it again... */

        /* copy file name to string */
        strcpy(Filename,filen2) ;
        strcpy(Filenorig,filen2);
        changesuffix(filen2,".asm"); /* Change appendix to .asm */
        if ( (output=fopen(filen2, "w")) == NULL && (!eof) ) {
                fprintf(stderr,"Cannot open output file: %s\n",line);
                exit(1);
        }
        clear() ;                       /* erase line */
}

/*
 *      Get (next) input file
 */
void openin()
{
        input = 0 ;                             /* none to start with */
        while ( input == 0 ) {  /* any above 1 allowed */
                clear() ;                       /* clear line */
                if ( eof ) break ;      /* if user said none */
/* Deleted hopefully irrelevant code */
                if (Filename[0] == '-')
                {
                        if (ncomp==0)
                                info();
                        exit(1);
                }
                if ( (input=fopen(Filename,"r")) == NULL ) {
                        fprintf(stderr,"Can't open: %s\n",Filename);                         exit(1);
                }
                else {
                        if (verbose)
                           fprintf(stderr,"Compiling: %s\n",Filename);
                        ncomp++;
                        newfile() ;
                }
        }
        clear();                /* erase line */
}

/*
 *      Reset line count, etc.
 */
void newfile()
{
        lineno  =                               /* no lines read */
        fnstart =                               /* no fn. start yet. */
        infunc  = 0 ;                   /* therefore not in fn. */
        currfn  = NULL ;                /* no fn. yet */
}

/*
 *      Open an include file
 */
void doinclude()
{
        char name[FILENAME_LEN+1], *cp ;

        blanks();       /* skip over to name */
        if (verbose)
        {
        toconsole();
        outstr(line); nl();
        tofile();
        }

        if ( inpt2 )
                error(E_NEST);
        else {
                /* ignore quotes or angle brackets round file name */
                strcpy(name, line+lptr) ;
                cp = name ;
                if ( *cp == '"' || *cp == '<' ) {
                        name[strlen(name)-1] = '\0' ;
                        ++cp ;
                }
                if ( (inpt2=fopen(cp, "r") ) == NULL ) {
                        error(E_INCLUDE) ;
                        closeout();
                        exit(1);
                }
                else {
                        saveline = lineno ;
                        savecurr = currfn ;
                        saveinfn = infunc ;
                        savestart = fnstart ;
                        newfile() ;
                }
        }
        clear();                /* clear rest of line */
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

        inpt2  = 0 ;
        lineno  = saveline ;
        currfn  = savecurr ;
        infunc  = saveinfn ;
        fnstart = savestart ;
}

/*
 *      Close the output file
 */
void closeout()
{
        tofile() ;      /* if diverted, return to file */
        if ( output ) {
                /* if open, close it */
                fclose(output) ;
        }
        output = 0 ;            /* mark as closed */
}

/*      
 *      Deals With parsing of command line options
 *
 *      djm 3/12/98
 *
 */






struct args {
        char *name;
        char more;
        void (*setfunc)(char *);
};


struct args myargs[]= {
        {"math-z88",NO,SetMathZ88},
        {"unsigned",NO,SetUnsigned},
        {"//",NO,SetCppComm},
        {"make-app",NO,SetMakeApp},
        {"do-inline",NO,SetDoInline},
        {"stop-error",NO,SetStopError},
        {"far-pointers",NO,SetFarPtrs},	/* Obsolete..but maybe useful*/
        {"make-lib",NO,SetNoHeader},
        {"make-shared",NO,SetMakeShared},
	{"shared-file",NO,SetSharedFile},
        {"use-shared",NO,SetUseShared},
        {"Wnone",NO,SetNoWarn},
        {"compact",NO,SetCompactCode},
        {"cc",NO,SetCCode},
        {"verbose",NO,SetVerbose},
        {"D",YES,SetDefine},
        {"U",YES,SetUndefine},
        {"h",NO,DispInfo},
        {"v",NO,SetVerbose},
        {"Wall",NO,SetAllWarn},
        {"Wn",YES,UnSetWarning},
        {"W",YES,SetWarning},
        {"zorg=",YES,SetOrg},
        {"reqpag=",YES,SetReqPag},
        {"defvars=",YES,SetDefVar},
        {"safedata=",YES,SetSafeData},
        {"startup=",YES,SetStartUp},
	{"shareoffset=",YES,SetShareOffset},
        {"version",NO,DispInfo},
        {"intuition",NO,SetIntuition},
        {"smartpf",NO,SetSmart},
        {"no-smartpf",NO,UnSetSmart},
	{"pflevel",YES,SetPfLevel},
        {"expandz88",NO,SetExpand},
        {"no-expandz88",NO,UnSetExpand},
        {"ANSI-stdio",NO,SetANSIstdio},
	{"farheap=",YES,SetFarHeap},
	{"debug=",YES,SetDebug},
	{"asxx",NO,SetASXX},
	{"doublestr",NO,SetDoubleStrings},
	{"noaltreg",NO,SetNoAltReg},
#ifdef USEFRAME
	{"frameix",NO,SetFrameIX},
	{"frameiy",NO,SetFrameIY},
	{"noframe",NO,SetNoFrame},
#endif
/* Compatibility Modes.. */
        {"f",NO,SetUnsigned},
        {"l",NO,SetFarPtrs},
        {"mpm",NO,SetMPM},
        {"",0}
        };

#ifdef USEFRAME
void SetNoFrame(char *arg)
{
	useframe=NO;
	indexix=NO;
}

void SetFrameIX(char *arg)
{
	useframe=YES;
	indexix=YES;
}

void SetFrameIY(char *arg)
{
	useframe=YES;
	indexix=NO;
}
#endif

void SetMPM(char *arg)
{
    usempm = YES;
}

void SetDoubleStrings(char *arg)
{
    doublestrings = YES;
}

void SetNoAltReg(char *arg)
{
    noaltreg = YES;
}

void SetASXX(char *arg)
{
	asxx=YES;
}

/* farheap= */

void SetFarHeap(char *arg)
{
        int    num;
        num=0;
        sscanf(arg+8,"%d",&num);
        if    (num!=0) 
                farheapsz=num;
}

/* debug= */

void SetDebug(char *arg)
{
        int    num;
        num=0;
        sscanf(arg+6,"%d",&num);
        if    (num!=0) 
                debuglevel=num;
}


/* shareoffset= */

void SetShareOffset(char *arg)
{
        int    num;
        num=0;
        sscanf(arg+12,"%d",&num);
        if    (num!=0) 
                shareoffset=num;
}


/* startup= */

void SetStartUp(char *arg)
{
        int    num;
        num=0;
        sscanf(arg+8,"%d",&num);
                startup=num;
#if 0
        if (startup==2) appz88=YES; /* Flag that we want app startup gunk*/
#endif
}


/* ANSI stdio - proper filepointers and the ilk */

void SetANSIstdio(char *arg)
{
        ansistdio=YES;
}

/* Do we need an expanded Z88? */
 

void UnSetExpand(char *arg)
{
        expanded=NO;
}

void SetExpand(char *arg)
{
        expanded=YES;
}


/* Flag whether we want to do "smart" mapping of printf -> miniprintf */

void UnSetSmart(char *arg)
{
        smartprintf=NO;
	printflevel=2;	/* Complex */
}

void SetSmart(char *arg)
{
        smartprintf=YES;
}

/* pflevel= */
void SetPfLevel(char *arg)
{
        int    num;
        num=0;
        sscanf(arg+8,"%d",&num);
	if (num>=1 && num<=3)
		printflevel=num;
}


/* Flag out that we want some debugging boy! */

void SetIntuition(char *arg)
{
        intuition=YES;
}


void UnSetWarning(char *arg)
{
        int    num;
        num=0;
        sscanf(arg+2,"%d",&num);
        if    (num<W_MAXIMUM) 
                mywarn[num].suppress=1;
}

/* defvars= */

void SetDefVar(char *arg)
{
        int    num;
        num=0;
        sscanf(arg+8,"%d",&num);
        if    (num!=0) 
                defvars=num;
}

/* safedata= */

void SetSafeData(char *arg)
{
        int    num;
        num=0;
        sscanf(arg+9,"%d",&num);
        if    (num!=0) 
                safedata=num;
}

void SetWarning(char *arg)
{
        int    num;
        num=0;
        sscanf(arg+1,"%d",&num);
        if    (num<W_MAXIMUM) 
                mywarn[num].suppress=0;
}

/* zorg= */

void SetOrg(char *arg)
{
        unsigned int    num;
        num=0;
#if 0
        appz88=1;
#endif
        sscanf(arg+5,"%u",&num);
        if    (num>=0 && num <= 65535U )
                zorg=num;
}

/* reqpag= */


void SetReqPag(char *arg)
{
        int    num;
        num=-1;
#if 0
        appz88=1;
#endif
        sscanf(arg+7,"%d",&num);
        if    (num >= 0 && num <= 160) 
                reqpag=num;
}



void SetMathZ88(char *arg)
{
        mathz88=YES;
}

void SetUnsigned(char *arg)
{
        dosigned=YES;
}

void SetNoWarn(char *arg)
{
        int     i;
        for     (i=1;i<W_MAXIMUM; i++)
                mywarn[i].suppress=1;
}


void SetAllWarn(char *arg)
{
        int     i;
        for     (i=1;i<W_MAXIMUM; i++)
                mywarn[i].suppress=0;
}



void SetCppComm(char *arg)
{
        cppcom=YES;
}

void SetMakeApp(char *arg)
{
        appz88=YES;
}

void SetDoInline(char *arg)
{
        doinline=YES;
}

void SetStopError(char *arg)
{
        errstop=YES;
}

void SetFarPtrs(char *arg)
{
        ShowNotFunc(arg);
        lpointer=YES;
}

void SetUseShared(char *arg)
{
        useshare=YES;
}

void SetSharedFile(char *arg)
{
        sharedfile=YES;
}

void SetMakeShared(char *arg)
{
        makeshare=YES;
        makelib=YES;
}

void SetNoHeader(char *arg)
{
        makelib=YES;
}

void SetCompactCode(char *arg)
{
        compactcode=YES;
}

void SetCCode(char *arg)
{
        ctext=1;
}

void SetDefine(char *arg)
{
        defmac(arg+1);
}

void SetUndefine(char *arg)
{
        strcpy(line,arg+1);
        delmac();
}

void DispInfo(char *arg)
{
        info(); 
        exit(1);
}

void SetVerbose(char *arg)
{
        verbose=YES;
}


void ShowNotFunc(char *arg)
{
        fprintf(stderr,"Flag -%s is currently non-functional\n",arg);
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
        printf("Unrecognised argument: %s\n",arg);
}

/*
 *      This routine called via atexit to clean up memory
 */

void MemCleanup()
{
        if (litq) { free(litq); litq=0; }
        if (dubq) { free(dubq); dubq=0;}
        if (tempq) { free(tempq); tempq=0;}
        if (glbq) { free(glbq); glbq=0; }
        if (symtab) { free(symtab); symtab=0; }
        if (loctab) { free(loctab); loctab=0; }
        if (wqueue) { free(wqueue); wqueue=0; }
        if (tagtab) { free(tagtab); tagtab=0; }
        if (membtab) { free(membtab); membtab=0; }
        if (swnext) { free(swnext); swnext=0; }
        if (stage) { free(stage); stage=0; }
        if (gotoq) { free(gotoq); gotoq=0; }
}

/*
 *	Routine to keep DOG happy and avoid nastiness
 *	should really do this any case..so I'll let it
 *	pass!
 */

void *mymalloc(size_t size)
{
	void *ptr;

	if	( (ptr=calloc(size,1)) != NULL ) return ptr;
	else OutOfMem();
	return 0;	/* Sigh */
}

void OutOfMem()
{
	fprintf(stderr,"Out of memory...\n");
	exit(1);
}

