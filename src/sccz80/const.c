/*
 *      Small C+ Compiler
 *      Split into parts 3/3/99 djm
 *
 *      This part deals with the evaluation of a constant
 *
 *      $Id: const.c,v 1.10 2002-01-26 22:10:19 dom Exp $
 *
 *      7/3/99 djm - fixed minor problem in fnumber, which prevented
 *      fp numbers from working properly! Also added a ifdef UNSURE
 *      around exponent-- for -math-z88
 *
 *      29/1/2001 djm - added ability to dump string literals and have
 *      them sorted out at compile time
 *
 *      26/1/2002 djm - Exponent code uncommented now. This works, but
 *      there may be accuracy issues due to method used for -ve exponents
 *
 */

#include "ccdefs.h"

/*
 * These two variables used whilst loading constants, makes things
 * a little easier to handle - type specifiers..
 */

char    constype;
char    conssign;

/* Modified slightly to sort have two pools - one for strings and one
 * for doubles..
 */

int constant(lval)
LVALUE *lval ;
{
        constype=CINT;
        conssign=dosigned;
        lval->is_const = 1 ;            /* assume constant will be found */
        if ( fnumber(&lval->const_val) ) {
                lval->val_type=DOUBLE;
		if ( doublestrings ) {
		    immedlit(litlab);
		    outdec(lval->const_val); nl();
		    callrts("__atof2");
                    WriteDefined("math_atof",1);
		} else {
		    immedlit(dublab);
		    outdec(lval->const_val); nl();
		    callrts("dload");
		}
                lval->is_const = 0 ;                    /*  floating point not constant */
                lval->flags=0;
                return(1);
        }
        else if ( number(&lval->const_val) || pstr(&lval->const_val) ) {
/* Insert long stuff/long pointer here? */
		if ( (unsigned long )lval->const_val >= 65536LU )
			constype = LONG;

                lval->val_type = constype ;
                lval->flags = (lval->flags&MKSIGN)|conssign;
                if (constype == LONG) vlongconst(lval->const_val);
                else vconst(lval->const_val);
                return(1);
        }
        else if ( tstr(&lval->const_val) ) {
                lval->is_const = 0 ;                    /* string address not constant */
                lval->ptr_type=CCHAR;   /* djm 9/3/99 */
                lval->val_type=CINT;
                lval->flags=0;
                immedlit(litlab);
        }
        else {
                lval->is_const = 0 ;
                return(0);       
        }
        outdec(lval->const_val);
        nl();
        return(1);
}


int fnumber(long *val)
{
    unsigned char sum[6];
    unsigned char sum2[6];
    unsigned char scale[6];
    unsigned char frcn[6];
    unsigned char dig1[6];
    unsigned char dig2[6];
    unsigned char dig3[6];
    int k;                  /* flag and mask */
    unsigned char minus;     /* is if negative! */
    char *start;    /* copy of pointer to starting point */
    char *s;             /* points into source code */
    char *dp1;	    /* First number after dp */
    char *end;
    

    if (mathz88) {             /* Z88 Representation of 0.1 */
	frcn[0] = 0;
	frcn[1] = 205;
	frcn[2] = frcn[3]=204;
	frcn[4] = 76;
	frcn[5] = 125;
    } else {                   /* Generic representation of 0.1 */
	frcn[0] = 205;
	frcn[1] = frcn[2] = frcn[3] = 204;
	frcn[4] = 76;
	frcn[5] = 125;            
    }

    start = s = line+lptr;      /* save starting point */
    k = 1;
    minus = 1;
    while(k) {
	k=0;
	if(*s == '+') {
	    ++s; k=1;
	}
	if(*s == '-') {
	    ++s; k=1; minus=(-minus);
	}
    }
        
    while (*s==' ')   /* Ignore white space after sign */
	s++;

    while ( numeric(*s) )
	++s ;

    if ( *s != '.' || *s != 'e' ) {   /* Check that it is floating point */
	s++;
	return 0;
    }
    dp1 = ++s;
    while ( numeric(*s) )
	++s ;
    lptr = (s--) - line ;           /* save ending point */

    end = s;

    sum[0]=sum[1]=sum[2]=sum[3]=sum[4]=sum[5]='\0';
    sum2[0]=sum2[1]=sum2[2]=sum2[3]=sum2[4]=sum2[5]='\0';

    memcpy(dig3,frcn,6);	/* Copy 0.1 dig3 */
    s = dp1;
    /* Deals with the decimal place */
    while ( numeric(*s) && s <= end) {
	qfloat((*s-'0'),dig1);   /* 0-9 */
	fltmult(dig3,dig1);      /* * 0.1 */
	fltadd(dig1,sum2);
	fltmult(frcn,dig3);
	s++;
    }
    s = --dp1;	/* Now points to dp */

    qfloat(1,scale);              /* Now do numbers after decimal place */
    while ( --s >= start ) {
	qfloat((*s-'0'),dig1);
	fltmult(scale,dig1);
	fltadd(dig1,sum);
	qfloat(10,dig2);
	fltmult(dig2,scale);
    }
    fltadd(sum2,sum);


    if( cmatch('e') ) {                       /* interpret exponent */
	int neg;                        /* nonzero if exp is negative */
	long expon;                     /* the exponent */

	if( number(&expon) == 0 ) {
	    error(E_EXPON);
	    expon=0;
	}
	if( expon < 0 ) {
	    neg=1; 
	    expon=(-expon);
	} else {
	    neg = 0;
	}
	if( expon > 38 ) {
	    error(E_FLOATING);
	    expon=0;
	}
	/* Now find the scaling factor. We find 10**expon */
	if ( neg == 0 ) {
	    qfloat(1,scale);
	    k = 32;
	    while( k ) {
		memcpy(sum2,scale,6);	/* Copy scale */
		fltmult(sum2,scale);    /* scale * scale */
		if( k & expon) {
		    qfloat(10,sum2);      /* scale *= 10 */
		    fltmult(sum2,scale);
		}
		k >>= 1;
	    }
	} else {   /* Negative exponenent find 0.1 ** expon */
	    memcpy(scale,frcn,6);               /* 0.1 */
	    for ( k = 1; k < expon; k++ ) {
		fltmult(frcn,scale);            /* *0.1 */
	    }		   
	    neg = 0;
	}
	/* Now we can just multiply to find the number */
	fltmult(scale,sum);
    }


    /* Not sure if this bit is necessary - dom 26/1/2002 */
    if ( minus != 1) 
	sum[4]=sum[4]|128;

    /* Z88 FP numbers have exp+127, gen has +128 (bad?) */
    if (mathz88) 
	--sum[5];

    /* get location for result & bump litptr */
    if ( doublestrings ) {
	*val = stash_double_str( start, lptr+line);
	return (1);
    } else {
	*val = searchdub(sum);
    }
    return(1) ;      /* report success */
}


/* stash a double string in the literal pool */

int stash_double_str(char *start, char *end)
{
    int  len;
    long val;
    char  *buf;

    len = end-start;

    if (*(start+len-1) == ' ') len--;

    buf = malloc(len+1);

    if (buf == NULL ) {
	error(E_LITQOV);  /* As good as any really.. */
    }
    strncpy(buf,start,len);
    *(buf+len)=0;
    storeq(len+1,buf,&val);
    free(buf);
    return(val);
}



/* Search through the literal queue searching for a match with our
 * number - saves space etc etc
 */

int searchdub(char *num)
{
        char *tempdub;
        int dubleft, k,match;
        
        dubleft=dubptr;
        tempdub=dubq;
        while( dubleft ){
                /* Search through.... */
                match=0;
                for ( k = 0 ; k < 6 ; k++) {
                        if (*tempdub++ == num[k]) match++;
                }
                if (match == 6 ) return (dubptr-dubleft);
                 dubleft -= 6;
        }
/* Put it in the double queue now.. */
        if ( dubptr+6 >= FNMAX ) {
                error(E_DBOV);
                return(0);
        }

        for (k=0 ; k< 6 ; k++){
                *tempdub++=num[k];
        }
        dubptr += 6;
        return (dubptr-6);
}



int number(val)
long *val;
{
        char c ;
        int minus;
        long  k ;
/*
 * djm, set the type specifiers to normal
 */
        k = minus = 1 ;
        while ( k ) {
                k = 0 ;
                if ( cmatch('+') ) k = 1 ;
                if ( cmatch('-') ) {
                        minus = (-minus) ;
                        k = 1 ;
                }
        }
        if( ch() == '0' && raise(nch()) == 'X' ) {
                gch() ;
                gch() ;
                if ( hex(ch()) == 0 ) return(0) ;
                while ( hex(ch()) ) {
                        c = inbyte() ;
                        if ( c <= '9' )
                                k = (k << 4) + (c-'0') ;
                        else
                                k = (k << 4) + ((c&95) - '7') ;
                }
                *val = k ;
		goto typecheck;
        }
        if( ch() == '0' ) {
		gch();
		while ( numeric(ch()) ) {
			c=inbyte();
			if (c<'8') k=k*8+(c-'0');
		}
		*val=k;
		goto typecheck;
	}
        if ( numeric(ch()) == 0 )
                return(0);
        while ( numeric(ch()) ) {
                c = inbyte() ;
                k = k*10+(c-'0') ;
        }
        if ( minus < 0 ) k = (-k) ;
        *val = k ;
typecheck:
	while ( rcmatch('L') || rcmatch('U') || rcmatch ('S') ) {
        	if ( cmatch('L') ) constype=LONG;
        	if ( cmatch('U') ) conssign=YES;        /* unsigned */
        	if ( cmatch('S') ) conssign=NO;
	}
        return(1) ;
}

int hex(char c)
{
        char c1 ;

        c1 = raise(c) ;
        return( (c1>='0' && c1<='9') || (c1>='A' && c1<='F') ) ;
}

/* djm, seems to load up literal address? */

void address(ptr)
SYMBOL *ptr ;
{
        immed() ;
        outname(ptr->name,dopref(ptr)) ;
        nl();
/* djm if we're using long pointers, use of e=0 means absolute address,
 * this covers up a bit of a problem in deref() which can't distinguish
 * between ptrtoptr and ptr
 */
        if (ptr->flags&FARPTR) { const2(0); }
}

int pstr(long *val)
{
        int k ;

        constype=CINT;
        constype=dosigned;
        if (cmatch('\'')) {
                k = 0 ;
                while ( ch() != 39 )
                        k = (k&255)*256 + litchar() ;
                ++lptr ;
                *val = k ;
                return(1) ;
        }
        return(0) ;
}

/* Scan in literals within function into temporary buffer and then
 * check to see if present elsewhere, if so do the merge as for doubles
 */

int tstr(long *val)
{
        int k,j;

        j=k=0;
        if ( cmatch('"') == 0 ) return(0) ;
        do {
                while ( ch() !='"' ) {
                        if ( ch() == 0 ) break ;
                        tempq[k]=litchar();
                        k++;    /* counter */
                }
                gch();
        } while (cmatch('"'));
        tempq[k]= 0;
        k++;
        return(storeq(k,tempq,val));
}

/*
 * Messed around with 5/5/99 djm to allow queues to start from 1
 * internally, but to the asm file show it to start from 0
 */

int storeq(int length, unsigned char *queue,long *val)
{
        int     j,k,len;
/* Have stashed it in our temporary queue, we know the length, so lets
 * get checking to see if one exactly the same has already been placed
 * in there...
 */
        k=length;
        len=litptr-k;   /* Amount of leeway to search through.. */
        j=1;            /* Literal queue starts from 1 not 0 now
                         * this allows scan for miniprintf to work
                         * correctly
                         */
        while (len >= j) {
                if (strncmp(queue,litq+j,k) == 0) {*val=j-1; return(1);} /*success!*/
                j++;
        }
/* If we get here, then dump it in the queue as per normal... */
        *val=(long) litptr-1;
        for (j=0; j<k; j++) {
/* Have to dump it in our special queue here for function literals */
                if ( (litptr+1) >= FNMAX ) {
                        error(E_LITQOV);
                }
                *(litq+litptr)=*(queue+j);
                litptr++ ;
        }
        return(k);
}


int qstr(long *val)
{
        int cnt=0;

        if ( cmatch('"') == 0 ) return(0) ;
	*val=(long)gltptr;
        do {
                while ( ch() !='"' ) {
                        if ( ch() == 0 ) break ;
			cnt++;
			stowlit(litchar(),1);
                }
		gch();
        } while ( (cmatch('\\') && cmatch('"') ) || cmatch('"'));
        glbq[gltptr++]= 0;
        return(cnt);
}

/*
 * Messed around with 5/5/99 djm to allow queues to start from 1
 * internally, but to the asm file show it to start from 0
        int cnt;
        cnt=0;
        if ( cmatch('"') == 0 ) return(0) ;
        *val = (long) gltptr ;
        while ( ch() != '"' ) {
                if ( ch() == 0 ) break ;
                cnt++;
                stowlit(litchar(), 1) ;
        }
        gch() ;
        glbq[gltptr++] = 0 ;
        return(cnt);
*/


/* store integer i of size size bytes in global var literal queue */
void stowlit(value, size)
int value, size ;
{
        if ( (gltptr+size) >= LITMAX ) {
                error(E_LITQOV);
        }
        putint(value, glbq+gltptr, size);
        gltptr += size ;
}




/* Return current literal char & bump lptr */
char litchar()
{
        int i, oct ;

        if ( ch() != 92 ) return(gch()) ;
        if ( nch() == 0 ) return(gch()) ;
        gch() ;
        switch( ch() ) {
		case 'a': {++lptr; return  7;} /* Bell */
                case 'b': {++lptr; return  8;} /* BS */
                case 't': {++lptr; return  9;} /* HT */
                case 'r': {++lptr; return 10;} /* LF */
		case 'v': {++lptr; return 11;} /* VT */
		case 'f': {++lptr; return 12;} /* FF */
                case 'n': {++lptr; return 13;} /* CR */
                case 34 : {++lptr; return 34;} /* "  */
                case 39 : {++lptr; return 39;} /* '  */
		case '\\': {++lptr; return '\\';}/* /  */
		case '\?': {++lptr; return '\?';}/* ?  */
                case 'l': {++lptr; return 10;} /* LF (non standard)*/
        }
	if (ch() != 'x' && (ch()<'0' || ch()>'7')) {
		warning(W_ESCAPE,ch());
		return(gch());
	}
	if (ch() == 'x') {
		gch();
		oct=0; i=2;
        	while ( i-- > 0 && hex(ch()) ) {
                        if ( ch() <= '9' )
                                oct = (oct << 4) + (gch()-'0') ;
                        else
                                oct = (oct << 4) + ((gch()&95) - '7') ;
		}
		return(oct);
	}

        i=3; oct=0;
        while ( i-- > 0 && ch() >= '0' && ch() <= '7' )
                oct=(oct<<3)+gch()-'0';
        if(i==2)return(gch());
        else return(oct);
}

/*
 * find size of type (on variable now as well)
 */
#ifndef SMALL_C
void 
#endif
size_of(lval)
LVALUE *lval ;
{
        char sname[NAMESIZE] ;
        int  length;
        TAG_SYMBOL *otag ;
        SYMBOL *ptr;
        struct varid var;
        char    ident;


        needchar('(') ;
        otag=GetVarID(&var,NO);
        if (var.type != NO ) {
                if ( match("**") || cmatch('*') ) ident=POINTER;
                else ident=VARIABLE;

                if ( otag && ident==VARIABLE ) lval->const_val =otag->size;
                if ( ident == POINTER ) {
                        lval->const_val = (var.zfar ?  3 : 2);
                } else {
                      switch(var.type) {
                                case CCHAR:
                                        lval->const_val=1;
                                        break;
                                case CINT:
                                        lval->const_val=2;
                                        break;
                                case LONG:
                                        lval->const_val=4;
                                        break;
                                case DOUBLE:
                                        lval->const_val=6;
					break;
				case STRUCT:
					lval->const_val=GetMembSize(otag);
					if (lval->const_val == 0 ) lval->const_val=otag->size;
                       }
                }
/*
 * djm mod to do sizeof on string
 */
        } else if ( cmatch('"') ) {
                length=1;       /* Always terminated by a \0 */
                while (!cmatch('"')) {
                        length++;
                        litchar();
                } ;
                lval->const_val=length;
        } else if ( symname(sname) ) {
/*
 * djm mod to do sizeof on an array etc
 * Can also handle element of structure
 */
                        if ( (ptr = findglb(sname)) || (ptr=findloc(sname)) || (ptr=findstc(sname)) ) {
                        /* Actually found sommat..very good! */
                            if ( ptr->ident!=FUNCTION && ptr->ident!=MACRO) {
				if (ptr->type!=STRUCT){
					lval->const_val=ptr->size;
				} else {
					lval->const_val=GetMembSize(tagtab+ptr->tag_idx);
					if (lval->const_val == 0 ) lval->const_val=ptr->size;
				}
                             } else {
                                 warning(W_SIZEOF);
                                /* good enough default? */
                                lval->const_val=2;
                             }
                        }

        }
done:
        needchar(')') ;
        lval->is_const = 1 ;
        lval->val_type = CINT ;
        lval->ident=VARIABLE;
        vconst(lval->const_val) ;
}

int GetMembSize(TAG_SYMBOL *ptr)
{
	char	sname[NAMEMAX];
	SYMBOL *ptr2;
	if (cmatch('.') == NO && match("->") == NO ) return 0;

	if (symname(sname) && (ptr2=findmemb(ptr,sname)) ) 
		return ptr2->size;
	error(E_UNMEMB,sname);
	return(0);
}
