/*
 *      Routines to declare a function
 *      Split from decl.c 11/3/98 djm
 *
 *      $Id: declfunc.c,v 1.15 2014-12-19 05:21:23 aralbrec Exp $
 */

#include "ccdefs.h"



extern void CleanGoto(void);

/** \brief Given an argument train, add in signature information to currfn
 *
 *  \param ptr - Last argument
 */
void StoreFunctionSignature(SYMBOL *ptr)
{
    SYMBOL *ptr2;
    int     j,k;

    /* Count the number of arguments that this function had */
    j = 1;
    ptr2 = ptr;
    while ( (ptr2=ptr2->offset.p) ) {
        j++; 
    }
    if ( j > MAXARGS ) {
        j = MAXARGS-1;
    }
    currfn->prototyped = j;    /* Set number of arguments */

    /* Now define them in currfn - list is in reverse order remember */
    while (j) {
        k = j;
        ptr2 = ptr;
        while (--k) {
            ptr2 = ptr2->offset.p; 
        }
        /* Okay, so now in ptr2 we have the SYMBOL for the argument */
        currfn->args[j] = CalcArgValue(ptr2->type, ptr2->ident, ptr2->flags);
        currfn->tagarg[j] = 0;
        /* Set the tag if necessary */
        if (ptr2->type == STRUCT) {
            currfn->tagarg[j]=ptr2->tag_idx;
        }
        j--;
    }

    /* Clear down remaining arguments */
    for ( j = (currfn->prototyped+1) ; j <= MAXARGS-1 ; j++) {
        currfn->args[j]=0;
        currfn->tagarg[j]=0;
    }
}

/*
 *      Function parsing here, we parse for prototyping and for
 *      declarations
 */

int AddNewFunc(
char *sname,
int type,
int storage,
char zfar,
char sign,
TAG_SYMBOL *otag,
int ident,
int32_t *addr)
{
    SYMBOL *ptr;
    int     more;
    char    simple;         /* Simple def () */
    more=0;

    /*
     *      First of all check to see if we have a number - this is
     *      external pointer type
     */

    if (number(addr)) return (EXTERNP);

    /*
     *      Now, check for simple prototyping, we can drop that
     *      back as well, we have to check for punctuation - ; or ,
     *      afterwards, so that we can know its not a function
     *      definitions
     */
    simple=NO;
    if ( cmatch(')') ) {
        if ( rcmatch(';') || rcmatch(',') ) return(storage);
        simple=YES;
    }

    ptrerror(ident) ;
    if ( ident == POINTER ) {
        /* function returning pointer needs dummy symbol */
        more = dummy_idx(type, otag) ;
        /*                type = (zfar ? CPTR : CINT ); */
        ident=FUNCTIONP;        /* func returning ptr */
    } else ident=FUNCTION;

    /*
     *      Okay, we've got rid of everything that could pop up apart
     *      from:
     *      - ANSI prototypes
     *      - Functions themselves (ANSI & K&R)
     *
     *      First call AddNewFunc(), if this returns 0 then we have defined
     *      a function (including code)
     */
    ptr=AddFuncCode(sname, type, ident,sign, zfar, storage, more,NO,simple,otag,addr);
       
    if (ptr==0) { /* Defined a function */
        /* trap external int blah() { } things */
        if (currfn->storage==EXTERNAL) currfn->storage=STATIK;
        return(0);
    } else {
        StoreFunctionSignature(ptr);
    }
    return(0);

}


/*
 *      Begin a function
 *
 * Called from "parse" this routine tries to make a function
 *      out of what follows.
 */
void newfunc()
{
        char n[NAMESIZE];               /* ptr => currfn */
        int32_t addr;

        if ( symname(n) == 0 ) {
                error(E_ILLEGAL);
                clear();        /* invalidate line */
                return;
        }
        warning(W_RETINT);
        AddFuncCode(n,CINT,FUNCTION,dosigned,0,STATIK,0,1,NO,0, &addr);
}

/*
 *      Add the function proper, this is called from newfunc()
 *      and also from AddNewFunc(), returns 0 if added a real
 *      function (code etc)
 */

#ifndef SMALL_C
SYMBOL *
#endif

AddFuncCode(char *n, char type, char ident, char sign,char zfar, int storage, int more, char check,char simple,TAG_SYMBOL *otag, int32_t *addr)
{
    unsigned char tvalue;           /* Used to hold protot value */
    char    typ;                    /* Temporary type */
    int     itag;

    itag=0;
    if (otag)
        itag=otag-tagtab;       /* tag number */

    lastst = 0;                     /* no last statement */
    locptr = STARTLOC ;             /* deallocate all locals */
    fnstart = lineno ;              /* remember where fn began */
    /*
     * Do some elementary checking before hand..
     */
    if (zfar && ident!=FUNCTIONP) { zfar=NO; warning(W_FAR); }
    if ( ( currfn=findglb(n) ) ) {
        /* already in symbol table ? */
        if ( currfn->ident != FUNCTION && currfn->ident != FUNCTIONP ) {
            /* already variable by that name */
            multidef();
        }
        else if ( currfn->offset.i == FUNCTION && !currfn->prototyped) {
            /* already function by that name */
            multidef();
        }
        else {
            /* we have what was earlier assumed to be a function */

            if (currfn->storage == EXTERNAL && currfn->flags&LIBRARY ) {
                /* Overwriting a lib function, is that what you wanted?!? Handy for
                 * compiling the library though!! Change type to local static to prevent
                 * being dumped in the scope list..
                 */
				if (makelib || storage == LSTATIC ) {
                    currfn->storage=LSTATIC;
				} else {
					currfn->storage=LIBOVER;
				} 
                currfn->offset.i=FUNCTION;
            } else {
                /*
                 * I'm not sure what *exactly* I was trying to achieve here djm 25/2/00
                 */
                if (currfn->storage != EXTERNAL && ( (currfn->flags&LIBRARY) != LIBRARY) ) {
                    currfn->flags&=(~LIBRARY);
                    currfn->size = 0;
                }
                currfn->offset.i = FUNCTION ;
                currfn->storage = storage;
            }
        }
    }
    /* if not in table, define as a function now */
    else {  
        typ=type;
        if (ident == FUNCTIONP) typ=(zfar ? CPTR : CINT );

        currfn = addglb(n, FUNCTION,  typ, FUNCTION, storage, more, 0);
        currfn->size=0;
        currfn->prototyped=0;
        currfn->flags= (sign&UNSIGNED) | (zfar&FARPTR);
        if (type == STRUCT) currfn->tagarg[0]=itag;
        /*
         *      Set our function prototype - what we are!
         *      args[0] is free for use
         */
        currfn->args[0]=CalcArgValue(type, ident, currfn->flags);

    }
    tvalue=CalcArgValue(type,ident,((sign&UNSIGNED) | (zfar&FARPTR)) );
    if ( currfn->args[0] != tvalue || (type==STRUCT && currfn->tagarg[0] != itag  )  ){
        char buffer[120];
        warning(W_DIFFTYPE);
        warning(W_DIFFTYPE2,ExpandArgValue(currfn->args[0],buffer,currfn->tagarg[0]));
        warning(W_DIFFTYPE3,ExpandArgValue(tvalue,buffer,itag) );

    }

    /* we had better see open paren for args... */
    if ( check && (cmatch('(') == 0) )
        error(E_PAREN);


    locptr = STARTLOC ;             /* "clear" local symbol table */
    undeclared = 0 ;                /* init arg count */


    /* Check to see if we are doing ANSI fn defs - must be a better way of
     * doing this! (Have an array and check by that?)           
     */
    if (CheckANSI()) {
        return( dofnansi(currfn, addr) ); /* So we can pass back result */
    }
    DoFnKR(currfn,simple);
    return(0);
}


/*
 * This is where we do K&R function definitions, make this into
 * a separate function and then it makes life a lot easier!!
 */


void DoFnKR(
SYMBOL *currfn,
char   simple)
{
    char n[NAMESIZE];
    SYMBOL *prevarg;       /* ptr to symbol table entry of most recent argument */
    SYMBOL *cptr;
    TAG_SYMBOL *otag ;     /* structure tag for structure argument */
    struct varid var;

    prevarg=0;
    Zsp=0;                  /* Reset stack pointer */
    undeclared=0;
    infunc=1;



    while ( !simple && cmatch(')') == 0 ) {    /* then count args */
        /* any legal name bumps arg count */
        if ( symname(n) ) {
            /* add link to argument chain */
            if ( (cptr=addloc(n,0,CINT,0,0)) )
                cptr->offset.p = prevarg ;
            prevarg = cptr ;
            ++undeclared ;
        }
        else {
            error(E_ARGNAME);
            junk();
        }
        blanks();
        /* if not closing paren, should be comma */
        if ( ch() != ')' && cmatch(',') == 0 ) {
            warning(W_EXPCOM);
        }
        if ( endst() ) break ;
    }

    Zsp = 0 ;                       /* preset stack ptr */

    while ( undeclared ) {
		char	regit=NO;
		if (amatch("register") ) regit=YES;
        /* Auto is be default in function defns, but someone might
         * try it on...
         */
		if (amatch("auto") ) warning(W_AUTO);

        otag=GetVarID(&var,STATIK);

        if (var.type==STRUCT) {
            getarg(STRUCT, otag,NO,0,0, var.zfar,NO) ;
        } else if (var.type || regit) {
			if (regit && var.type == NO ) var.type=CINT;
            getarg(var.type,NULL_TAG,NO,0,var.sign,var.zfar,NO);
        } else {
            error(E_BADARG) ;
            break ;
        }
    }
    /* Have finished K&R parsing */
    setlocvar(prevarg,currfn);
}



/** \brief Set the argument offsets for a function, then kick off compiling
 *  of the function
 *
 *  \param prevarg  - Last argument
 *  \param currfn   - Current function
 */
void setlocvar(SYMBOL *prevarg,SYMBOL *currfn)
{
    int lgh,where;
    int *iptr;
    SYMBOL *copyarg;
    int argnumber;
    char buffer2[120];
    unsigned char tester;

	lgh = 0;  /* Initialise it */
    if ( prevarg != NULL && currfn->prototyped == 0 ) {
        StoreFunctionSignature(prevarg);
    }

    argnumber=currfn->prototyped;
    /*
     *      If we have filled up our number of arguments, then pretend
     *      we don't have any..nasty, nasty
     */
    if (argnumber==(MAXARGS-1)) argnumber=0;
    else   if (argnumber) argnumber=1;
    /*
     *      Dump some info about defining the function etc
     */
    if (verbose){
        toconsole();
        outstr("Defining function: "); outstr(currfn->name); nl();
        tofile();
    }

    output_section("code_compiler");  // output_section("code");

    nl();prefix();outname(currfn->name,dopref(currfn));col();nl();  /* print function name */

    infunc=1;       /* In a function for sure! */
    copyarg=prevarg;

    if ( ( (currfn->flags&SHARED) && makeshare ) || sharedfile ) {
        /* Shared library definition, offset the stack */
        where= 2 +shareoffset;
    } else
        where = 2 ;
    /* If we use frame pointer we preserve previous framepointer on entry
     * to each function
     */
#ifdef USEFRAME
	if (useframe) where+=2;
#endif
    while ( prevarg ) {
        lgh = 2 ;      /* Default length */
        /* This is strange, previously double check for ->type */
        if ( prevarg->type == VOID && prevarg->ident != POINTER )
            lgh=0;
        if ( prevarg->type == LONG && prevarg->ident != POINTER )
            lgh=4;
        if ( prevarg->type == DOUBLE && prevarg->ident != POINTER )
            lgh=6;
		/* Far pointers */
		if ( (prevarg->flags&FARPTR)==FARPTR && prevarg->ident == POINTER)
			lgh=4;
        prevarg->size=lgh;
#ifdef CODSWALLOP
        /* All pointers are pushed onto the stack for functions as 4 bytes, if
         * needed, near pointers are padded out to compensate for this by dummy
         * loading with zero, this allows us to have one set of routines to
         * cope with this and hence solve a lot of duplication
         */
        if (prevarg->ident == POINTER && lpointer) lgh=4;
        prevarg->size=lgh;
#endif
        /*
         * Check the definition against prototypes here...
         */
        if (argnumber) {
            tester=CalcArgValue(prevarg->type,prevarg->ident,prevarg->flags);
            if (currfn->args[argnumber] != tester ) {
                if (currfn->args[argnumber] != PELLIPSES ) {
                    if (currfn->args[argnumber] == 0 ) {
                        warning(W_2MADECL);
                    } else {
                        if ( (currfn->args[argnumber]&PMASKSIGN) == (tester&PMASKSIGN) ) {
                            warning(W_SIGNARG);
                        } else {
                            error(E_ARGMIS1,currfn->name,currfn->prototyped-argnumber+1, ExpandArgValue(tester,buffer2,prevarg->tag_idx) );
                            error(E_ARGMIS2,ExpandArgValue(currfn->args[argnumber],buffer2, currfn->tagarg[argnumber]));
                        }
                    }
                }
            }
            argnumber++;
        }
        iptr = &prevarg->offset.i ;
        prevarg = prevarg->offset.p ;           /* follow ptr to prev. arg */
        *iptr = where ;                                         /* insert offset */
        where += lgh ;                                          /* calculate next offset */
    }
#ifdef USEFRAME
	pushframe();
#endif
	currfn->handled=YES;
    if (currfn->prototyped==1 && (currfn->flags&REGCALL) ) {
        /*
         * Fast call routine..
         */
        if (lgh==2) zpush();
        else if (lgh==4) lpush();
        else if (lgh==6) dpush();
        /* erk, if not matched, dodgy type! */
        copyarg->offset.i=-lgh;
        where=2;
    }

    stackargs=where;
    lstdecl=0;       /* Set number of local statics to zero */
    if ( statement() != STRETURN ) {
        if (lstdecl) postlabel(lstlab);
        lstdecl=0;
        /* do a statement, but if it's a return, skip */
        /* cleaning up the stack */
        leave(NO,NO) ;
    }
    CleanGoto();
    function_appendix(currfn);


#ifdef INBUILT_OPTIMIZER
    generate();
#endif
    infunc = 0 ;                    /* not in fn. any more */
}

/* djm Declare a function in the ansi style! */
#ifndef SMALL_C
SYMBOL *
#endif
dofnansi(SYMBOL *currfn, int32_t *addr)
{
        SYMBOL *prevarg;       /* ptr to symbol table entry of most recent argument */
        SYMBOL *argptr;        /* Temporary holder.. */
        TAG_SYMBOL *otag ;     /* structure tag for structure argument */
        struct  varid var;
        char    proto;

        locptr=STARTLOC;
        prevarg=0;
        Zsp=0;                  /* Reset stack pointer */
        undeclared=1;
        proto=YES;

        swallow("__TD__");      /* kludge to get round typedef problem */
	swallow("register");
/* Master loop, checking for end of function */

        while ( cmatch(')') == 0 ) {  
                if (amatch("...") ) {
/*
 * Found some ellipses, so, add it to the local symbol table and
 * then return..(after breaking, and checking for ; & , )
 */
                        if (proto == 1 ) warning(W_ELLIP);
                        needchar(')');
                        argptr=addloc("ellp",0,ELLIPSES,0,0);
                        argptr->offset.p = prevarg;
                        prevarg=argptr;
                        break;
                }
                otag=GetVarID(&var,STATIK);

                if (var.type==STRUCT) {
                        prevarg=getarg(STRUCT, otag,YES,prevarg,0, var.zfar,proto) ;
                } else if (var.type) {
                        prevarg=getarg(var.type,NULL_TAG,YES,prevarg,var.sign,var.zfar,proto);

                } else {
                        warning(W_EXPARG);
                        break;
                }
                proto++;
/* Now check for comma */
                if (ch() !=')' && cmatch(',') == 0) {
                        warning(W_EXPCOM);
                        break;
                }
        }
/*
 *      Check for semicolon - I think this should be enough, just
 *      have to have prototypes on separate lines - good practice
 *      in anycase!!
 */
        if (cmatch('@') ) {
            constexpr(addr,1);
        }

        if (cmatch(';') ) return (prevarg);
        setlocvar(prevarg,currfn);
        return (0);
}

/*
 *      Check to see if could be doing any ANSI style function definitions
 *
 *      Returns: YES - we are, NO - we're not
 */

int CheckANSI()
{
    if (rmatch("unsigned") || rmatch("signed") || rmatch("int") || rmatch("char") || rmatch("double") || rmatch("long") || rmatch("struct") || rmatch("union") || rmatch("void") || rmatch("far") || rmatch("near") || rmatch("const") || rmatch("volatile") || rmatch("__TD__") || rmatch("float") || rmatch("register") || rmatch("short") || rmatch("enum") || CheckTypDef() ) return (YES);
        return (NO);
}




/*
 *      Declare argument types
 *
 * called from "newfunc" this routine adds an entry in the
 *      local symbol table for each named argument
 */
#ifndef SMALL_C
SYMBOL *
#endif
getarg(
int typ ,               /* typ = CCHAR, CINT, DOUBLE or STRUCT */
TAG_SYMBOL *otag ,      /* structure tag for STRUCT type objects */
int deftype,            /* YES=ANSI -> addloc NO=K&R -> findloc */
SYMBOL *prevarg,        /* ptr to previous argument, only of use to ANSI */
char issigned,          /* YES=unsigned NO=signed */
char zfar,              /* FARPTR=far NO=near */
char proto)              /* YES=prototyping -> names not needed */
{
        char n[NAMESIZE] ;
        SYMBOL *argptr ;
        int legalname, ident, more ;
        int brkflag;            /* Needed to correctly break out for K&R*/
/*
 * This is of dubious need since prototyping came about, we could
 * inadvertently include fp packages if the user includes <math.h> but
 * didn't actually use them, we'll save the incfloat business for
 * static doubles and definitions of local doubles
 *
 *      if (typ == DOUBLE)
 *              incfloat=1;
 */
	argptr = NULL;

/* Only need while loop if K&R defs */

        while ( undeclared) {
                ident = get_ident() ;
                more =0;
                if ( (legalname=symname(n)) == 0 ) {
                        if (!proto) { illname(n); }
			else {
/*
 * Obligatory silly fake name
 */
                                sprintf(n,"sg6p_%d",proto);
				legalname=1;
			}
                }
                if ( ident == FUNCTIONP ) {
                           needtoken(")()");
                 /* function returning pointer needs dummy symbol */
                           more = dummy_idx(typ, otag) ;
                           typ = (zfar ? CPTR : CINT );
                } 
                else if ( ident == PTR_TO_FN ) {
                        needtoken(")()") ;
                        ident = POINTER ;
                }
                if ( cmatch('[') ) {    /* pointer ? */
                        ptrerror(ident) ;
                        /* it is a pointer, so skip all */
                        /* stuff between "[]" */
                        while ( inbyte() != ']' )
                                if ( endst() ) break;
                        /* add entry as pointer */
                        ident = (ident == POINTER) ? PTR_TO_PTR : POINTER ;
                }
                if ( legalname ) {
/*
 * For ANSI we need to add symbol name to local table - this CINT is  
 * temporary
 */
                        if (deftype) {
                                argptr=addloc(n,0,CINT,0,0);
                                argptr->offset.p = prevarg;
                        }
/*
 * If prototyping, then we can't find the name, but if we're prototyping
 * we have been defined as ANSI, therefore argptr already holds
 * the correct pointer - kinda neat!
 */
                        if ( proto || (argptr=findloc(n)) ) {
                                argptr->flags=(zfar&FARPTR)|(issigned&UNSIGNED);
                                /* add in details of the type of the name */
                                if ( ident == PTR_TO_PTR ) {
/* djm mods will be here for long pointer */
                                     //   argptr->flags = UNSIGNED |FARPTR ; /*unsigned*/
                                        argptr->ident = POINTER ;
					argptr->type = typ;
                                      //  argptr->type = ( (zfar&FARPTR) ? CPTR : CINT );
                                        argptr->more = dummy_idx(typ, otag) ;
                                }
                                else {
                                        argptr->more = more;
                                        argptr->ident = ident ;
                                        argptr->type = typ ;
                                }
                        }
                        else warning(W_EXPARG);
                        if ( otag ) {
                                argptr->tag_idx = otag - tagtab ;
                                argptr->ident = POINTER ;
                                argptr->type = STRUCT ;
                        }
                }
                brkflag=0;
                if (!deftype) {
                        --undeclared;   /* cnt down */
                        if ( endst() )
                                { brkflag=1; break; }
                       if ( cmatch(',') == 0 )
                                warning(W_EXPCOM) ;
                }
                if (brkflag || deftype) break;
        }
        if (deftype) return(argptr);
        ns();
        return(0);
}

