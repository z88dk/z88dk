/*
 *      Small C+ Compiler
 *
 *      Perform a function call
 *
 *      $Id: callfunc.c,v 1.7 2012-10-15 10:40:46 stefano Exp $
 */

/*
 * Local functions
 */

static int SetWatch(char *sym);
static int SetMiniFunc(unsigned char *arg);

/*
 *      External variables used
 */


extern int smartprintf;



/*
 *      Perform a function call
 *
 * called from heirb, this routine will either call
 *      the named function, or if the supplied ptr is
 *      zero, will call the contents of HL
 */

#include "ccdefs.h"





void callfunction(SYMBOL *ptr)
{
    int nargs, vconst, val,expr,argnumber ;
    int watcharg;   /* For watching printf etc */
    unsigned char minifunc;  /* Call cut down version */
    unsigned char protoarg;
	char preserve;	/* Preserve af when cleaningup */

    nargs=0;
    preserve=argnumber=0;
    watcharg=minifunc=0;
    blanks();       /* already saw open paren */
/*
 * djm, another fabulous kludge!!
 * we don't check return types or anything..beautiful!!
 */

    if (ptr && (strcmp(ptr->name,"asm")==0) ) {
/* We're calling asm("code") */
        doasmfunc(NO);
        return;
    }

    if (ptr && smartprintf)
        watcharg=SetWatch(ptr->name);

    while ( ch() != ')' ) {
        if(endst())break;
        argnumber++;
        if ( ptr ) {
            /* ordinary call */
            expr=expression(&vconst, &val);
			if ( expr == CARRY ) {
			    zcarryconv();
			    expr = CINT;
			}
            if (ptr->prototyped && (ptr->prototyped >= argnumber) ) {
                protoarg=ptr->args[ptr->prototyped-argnumber+1];
                if ( (protoarg!=PELLIPSES) && ( (protoarg != fnargvalue) || ((protoarg&7)==STRUCT) ) ) 
                    expr=ForceArgs(protoarg,fnargvalue,expr,ptr->tagarg[ptr->prototyped-argnumber+1]);
            }
            if ( (ptr->flags&REGCALL) && ptr->prototyped==1 ) {
/* fastcall of single expression */

            } else {
                if (argnumber==watcharg) {
                    if (ptr) debug(DBG_ARG1,"Caughtarg!! %s",litq+val+1);
                    minifunc=SetMiniFunc(litq+val+1);

                }
                if (expr==DOUBLE) {
                    dpush();
                    nargs += 6;
                }
/* Longs and (ahem) long pointers! */
                else if (expr == LONG || expr == CPTR || (expr==POINTER && lpointer)) {
                    if (!(fnflags&FARPTR) && expr != LONG ) const2(0);
                    lpush();

                    nargs += 4;
                } else {
                    zpush();
                    nargs += 2;
                }
            }
        }
        else { /* call to address in HL */
/*
 * What do you do about longs also long pointers, need to push under
 * stack...hmmmmm: parse for LONG & CPTR push onto stk
 * then check if doubles...should work.
 */

            zpush();        /* Push address */
            expr=expression(&vconst, &val);
			if ( expr == CARRY ) {
			    zcarryconv();
			    expr = CINT;
			}
            if (expr == LONG || expr == CPTR || (expr==POINTER && lpointer) ) {
			    swap();       /* MSW -> hl */
			    swapstk();    /* MSW -> stack, addr -> hl */
			    zpushde();    /* LSW -> stack, addr = hl */	
			    nargs += 4;                             
            }
            else if (expr==DOUBLE) {
                dpush2();
                nargs += 6;
				swapstk();
            } else {
                /* If we've only got one 2 byte argment, don't swap the stack */
                if ( rcmatch(',') || nargs != 0 ) {
                    swapstk();
                }
                nargs += 2;
            }
        }
        if (cmatch(',')==0) break;
    }
    needchar(')');

    if (ptr) debug(DBG_ARG2,"arg %d proto %d",argnumber,ptr->args[1]);

    if (ptr && ( ptr->prototyped != 0 )) {
        if ( (ptr->prototyped > argnumber) && (ptr->args[1]!=PVOID)  && (ptr->args[1] !=PELLIPSES) ) {
            warning(W_2FAFUNC);
        } else if ( (ptr->prototyped < argnumber)  && (ptr->args[1]!=PELLIPSES)) {
            warning(W_2MAFUNC);
        }
    }

    if ( ptr ) {
        /* Check to see if we have a variable number of arguments */
        if ( (ptr->prototyped) && ptr->args[1]==PELLIPSES ) {
            loadargc(nargs) ;
        }
        /* Watch arguments */
        if (watcharg || (ptr->flags&SHARED) || (ptr->flags&SHAREDC) ) {
			if ( (ptr->flags&SHARED) || (ptr->flags&SHAREDC)) preserve=YES;
			if (ptr->flags&SHAREDC) zclibcallop();
            else zcallop();
            switch(minifunc) {
            case 1:
                /* Mini function */
                break;
            case 3:
                /* Fp function */
                warning(W_FLTPRINTF);
            }
			if (minifunc > printflevel) printflevel=minifunc;
            outname(ptr->name,dopref(ptr));
            if ( (ptr->flags&SHARED) && useshare ) outstr("_sl");
			else if (ptr->flags&SHAREDC) outstr("_rst");
            nl();
        } else  zcall(ptr) ;
    } else {      
        callstk(nargs);
    }
/*
 *	Modify the stack after a function call
 *
 *	We should modify stack if:
 *	- __CALLEE__ isn't set
 *	- Function is __LIB__ even if compactcode is set
 *	- compactcode isn't set and __CALLEE__ isn't set
 */

	if ( (ptr && ptr->flags&CALLEE) || (compactcode && ptr == NULL)  || (compactcode && ( (ptr->flags&LIBRARY) == 0) ) ) {
		Zsp+=nargs;
	} else {
		/* If we have a frame pointer then ix holds it */
#ifdef USEFRAME
		if (useframe) {
			if (nargs) RestoreSP(preserve);
			Zsp+=nargs;
		} else
#endif
            Zsp=modstk(Zsp+nargs,YES,preserve);      /* clean up arguments - we know what type is MOOK */
	}
}

/*
 * Watcharg, return number of argument to watch - for printf etc
 */

static int SetWatch(char *sym)
{
        if ( strcmp(sym,"printf") == 0 ) return 1;
        if ( strcmp(sym,"fprintf") == 0 ) return 2;
        if ( strcmp(sym,"sprintf") == 0 ) return 2;
        if ( strcmp(sym,"vprintf") == 0 ) return 1;
        if ( strcmp(sym,"vfprintf") == 0 ) return 2;
        if ( strcmp(sym,"vsprintf") == 0 ) return 2;
        return 0;
}


/*
 *      djm routine to force arguments to switch type
 */

int ForceArgs(char dest, char src,int expr, char functab)
{
        char    did, dtype, disfar, dissign;
        char    sid, stype, sisfar, sissign;
        char    buffer[80];


        dtype=dest&7;           /* Lower 3 bits */
        did=(dest&56)/8;     /* Middle 3 bits */
        disfar=(dest&128);
        dissign=(dest&64);

        stype=src&7;           /* Lower 3 bits */
        sid=(src&56)/8;     /* Middle 3 bits */
        sisfar=(src&128);
        sissign=(src&64);

/*
 *      These checks need to be slightly more comprehensive me thinks
 */
        if (did == VARIABLE) {
                if ( sid == VARIABLE ) {
                        force(dtype,stype,dissign,sissign,0);
                } else {
/*
 * Converting pointer to integer/long
 */
                        warning(W_PTRINT);
/* Pointer is always unsigned */
                        force(dtype,( ( sisfar ) ? CPTR : CINT ),dissign,0,0);
                }
                if (dtype == CCHAR ) expr=CINT;
                else expr=dtype;


        } else {
/* Dealing with pointers.. a type mismatch!*/
                if ( ( (dtype != stype) && ( dtype != VOID) && (stype != VOID) && (stype != CPTR) ) || ( (dtype==stype) && (margtag != functab) )  ) {
                        debug(DBG_ARG3,"dtype=%d stype=%d margtab=%d functag=%d",dtype,stype,margtag,functab);
                        warning(W_PRELIM,currfn->name,lineno-fnstart);
                        warning(W_PTRTYP);
                        ExpandArgValue(dest,buffer,functab);
                        warning(W_PTRTYP1,buffer);
                        ExpandArgValue(src,buffer,margtag);
                        warning(W_PTRTYP2,buffer);
                } else if ( dtype==stype && did != sid ) {
                        warning(W_INTPTR);
                        expr=CINT;
                }

                if ( disfar ) {
                        if ( disfar != sisfar )  {
/* Widening a pointer - next line unneeded - done elsewhere*/
/*                                const2(0); */
                                expr=CPTR;
                        }
                } else {
/* destintation is near pointer */
                        if ( disfar != sisfar ) {
                                warning(W_PRELIM,currfn->name,lineno-fnstart);
                                warning(W_FARNR);
                                expr=CINT;
                        }
                }
        }
        return(expr);
}


/* Short routine to determine what printf version we need - mini
 * standard or floating (not written yet!)
 */

static int SetMiniFunc(unsigned char *arg)
{
        char    c;
        char    complex;

        complex=1;      /* mini printf */
        while ( (c=*arg++) ) {
                if (c != '%' ) continue;
                if (*arg == '%' ) {arg++; continue; }
                if ( *arg == '-' || *arg == '0' || *arg=='+' || *arg==' ' ) {
                        if (complex <= 2 ) complex=2;  /* Switch to standard */
                        while ( (c=*arg++) ) 
                                if (c=='d' || c=='i' || c=='o' || c=='u' || c=='c' || c=='s' || c=='e' || c=='E' || c=='f' || c=='g' || c=='G' || c=='p' || c=='n' ) break;
                }
                switch(*arg) {
                        case 'e':
                        case 'E':
                        case 'f':
                        case '.':
                        case 'g':
                        case 'G':
                                complex=3;
                                break;
                        case 'o':
                        case 'i':
                        case 'p':
                        case 'n':
                        case 'x':
                                if (complex<=2) complex=2;
                                break;
                }

        }
        return(complex);
}
