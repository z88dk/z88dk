/********************************************************************
 *
 *      Small C+ Routines to Handle the Declaration of global
 *      variables (parsing of prototypes, function definitions etc)
 *
 *      Also routines to parse variables and add them into the 
 *      symbol table
 *
 *      Split into parts djm 3/3/99
 *
 *      $Id: declvar.c,v 1.1 2000-07-04 15:33:31 dom Exp $
 *
 *      The Declaration Routines
 *      (Oh they're so much fun!!)
 *
 *      16/3/99 djm A little bit of tidying up
 *
 *      18/3/99 djm Invented the GetVarID function to really clean up
 *      the code (much easier to read now!) sorted a little bug out
 *      with local statics which was causing their type size to be
 *      dumped after initialisation
 *
 *      29/3/99 djm Allowed pointers to functions return pointers...
 *
 ********************************************************************
 */

#include "ccdefs.h"



 

/*
 * test for global declarations/structure member declarations
 */

int dodeclare(storage, mtag, is_struct)
int storage ;
TAG_SYMBOL *mtag ;              /* tag of struct whose members are being declared, or zero */
int is_struct ;                 /* TRUE if struct member is being declared,                                    zero for union */
                                /* only matters if mtag is non-zero */
{
        struct varid var;       /* Our little structure for iding vars */
        TAG_SYMBOL *otag ;              /* tag of struct object being */
                                        /* declared */

        
        otag=GetVarID(&var,storage);

        if (var.type == NO) {
                if (storage==EXTERNAL) var.type=CINT;
                else return(0); /* fail */
        }
        if (var.type == STRUCT ) {
                declglb(STRUCT, storage, mtag, otag, is_struct,var.sign,var.zfar) ;
                return (1);
        } else {
                declglb(var.type,storage, mtag, NULL_TAG, is_struct,var.sign,var.zfar);
                return(1); 
        }
}


/*
 * define structure/union members
 * return pointer to new structure tag
 */

#ifndef SMALL_C
TAG_SYMBOL *
#endif

defstruct(sname, storage, is_struct)
char *sname ;
int storage ;
int is_struct ;
{
        int itag ;                              /* index of tag in tag symbol table */
        char nam[20];                           /* Dummy name */
        TAG_SYMBOL *ptr ;

        if ( tagptr >= ENDTAG ) {
                error(E_STROV) ;
        }
/* Create dummy symbol */
        /* add dummy symbol */
        itag = tagptr - tagtab ;
        sprintf(nam,"0st%d",itag);
        if (sname == 0 ) sname = nam;



        strcpy(tagptr->name, sname) ;
        tagptr->size = 0 ;
        tagptr->ptr = membptr ;

        /* increment tagptr to add tag to table */
        ptr = tagptr++ ;


        dummy_sym[NTYPE+1+itag] = addglb(nam,POINTER,STRUCT,0,STATIK,0,itag) ; 

        needchar('{') ;
        while ( dodeclare(storage, ptr, is_struct) )
                ;
        needchar('}') ;
        ptr->end = membptr ;
        return ptr ;
}

/*
 * declare an enum, ATP we have to parse between the curly brackets
 */

void defenum(char *sname, char storage)
{
        SYMBOL  *ptr;
        char    name[NAMEMAX];
        long    value;
/* Add it into the symbol table, we do not need to keep track of the
 * tag because we treat enums as constants
 */
        addglb(sname, ENUM, CINT, 0, storage, 0, 0);
        value=0;        /* initial constant */
        needchar('{');
        do {
                if (symname(name)==0)
                        illname(name);
                if ( cmatch('=') )
                        constexpr(&value);
                ptr=addglb(name,VARIABLE,ENUM,0,STATIK,0,0);
                ptr->size=value;
                value++;

        } while (cmatch(','));
        needchar('}');
}



/*
 * make a first stab at determining the ident of a variable
 */
int get_ident()
{
        if ( match("**") )
                return PTR_TO_PTR ;
        if ( match("*(*") )
                return PTR_TO_FNP;
        if ( cmatch('*') )
                return POINTER ;
        if ( match("(*") )
                return PTR_TO_FN ;
        return VARIABLE ;
}

/*
 * return correct index into dummy_sym
 */
int dummy_idx(typ, otag)
int typ ;
TAG_SYMBOL *otag ;
{
        if ( typ == STRUCT )
                return NTYPE + 1 + (otag-tagtab) ;
        else if (typ <= VOID ) return typ;
	else return CINT;
}

/*
 *      Declare a static variable (i.e. define for use)
 *
 *  makes an entry in the symbol table so subsequent
 *  references can call symbol by name
 */
void declglb(
int typ ,               /* typ is CCHAR, CINT, DOUBLE, STRUCT, LONG, */
int storage,
TAG_SYMBOL *mtag ,              /* tag of struct whose members are being declared, or zero */
TAG_SYMBOL *otag ,              /* tag of struct for object being declared */
int is_struct ,                 /* TRUE if struct member being declared, zero if union */
char sign ,                    /* TRUE if need signed */
char zfar )                      /* TRUE if far */
{
        char sname[NAMESIZE];
        int size, ident, more, itag, type, size_st;
        long addr;
        char    flagdef,match,ptrtofn;
        char    libdef,fastcall,callee;
        SYMBOL *myptr ;

        do {
                if ( endst() ) break;   /* do line */

                type = typ ;
                size = 1 ;                              /* assume 1 element */
                more =                                  /* assume dummy symbol not required */
                itag = 0 ;                              /* just for tidiness */
                flagdef=libdef=fastcall=callee=NO;


		match=ptrtofn=NO;

                while (blanks(),rcmatch('_') ) {
                        if (amatch("__APPFUNC__") ) { match=YES; flagdef=1; }
                        if (amatch("__LIB__") /* && libdef==0 */) {match=YES; libdef|=LIBRARY; }
                        if (amatch("__FASTCALL__") ) {match=YES; fastcall=REGCALL; }
                        if (amatch("__SHARED__") ) {match=YES; libdef|=SHARED; }
			if (amatch("__SHAREDC__") ) {match=YES; libdef|=SHAREDC; }
			if (amatch("__CALLEE__") ) {match=YES; callee=CALLEE; }
			if (match ==NO )break;
                }

                ident = get_ident() ;
                if (storage==TYPDEF && ident !=VARIABLE && mtag ==0 ) warning(W_TYPEDEF);

                if ( symname(sname) == 0 )      /* name ok? */
                        illname(sname) ;                     /* no... */

                if ( ident == PTR_TO_FNP ) {
                 /* function returning pointer needs dummy symbol */
                        more = dummy_idx(typ, otag) ;
                        type = (zfar ? CPTR : CINT );
                        size=0;
			ptrtofn=YES;
                } 
                else if ( ident == PTR_TO_FN ) {
                        ident = POINTER ;
			ptrtofn=YES;
                }
                else if ( cmatch('(') ) {
/*
 * Here we check for functions, but we can never have a pointer to
 * function because thats considered above. Which means as a very
 * nice side effect that we don't have to consider structs/unions
 * since they can't contain functions, only pointers to functions
 * this, understandably(!) makes the work here a lot, lot easier!
 */
                        storage=AddNewFunc(sname,type,storage,zfar,sign,otag,ident,&addr);
/*
 *      On return from AddNewFunc, storage will be:
 *      EXTERNP  = external pointer, in which case addr will be set
 *  !!    FUNCTION = have prototyped a function (NOT USED!)
 *      0        = have declared a function/!! prototyped ANSI
 *
 *      If 0, then we have to get the hell out of here, FUNCTION
 *      then gracefully loop round again, if EXTERNP, carry on with
 *      this function, anything else means that we've come up
 *      against a K&R style function definition () so carry on
 *      as normal!
 *
 *      If we had our function prefixed with __APPFUNC__ then we want
 *      to write it out to the zcc_opt.def file (this bloody thing
 *      is becoming invaluable for messaging!
 *
 *	__SHARED__ indicates in a library so preserve carry flag
 * 	(so we can test with iferror)
 *
 *	__CALLEE__ indicates that the function called cleans up
 *	the stack
 *
 *	__SHAREDC__ is indicates call by rst 8 but is unused..
 *	(old idea unused, but may yet be useful)
 */
                        if (flagdef) WriteDefined(sname,0);
                        if (currfn) {
				currfn->flags&=(~LIBRARY);
                                if (libdef) {
			//		currfn->flags|=LIBRARY;
                                        currfn->flags|=libdef;
                                }
				if (callee && (libdef&SHARED) != SHARED && \
				    (libdef&SHAREDC) != SHAREDC )
					currfn->flags|=callee;
                                if (fastcall) currfn->flags|=fastcall;
                        }
                        if (storage==0) {
				currfn=0;
				return;
			}
/*
 *      External pointer..check for the closing ')'
 */
                        if (storage==EXTERNP) {
                                needchar(')');
                        } else {
/*
 *  Must be a devilishly simple prototype! ();/, type...
 */
                                ptrerror(ident) ;
                                if ( ident == POINTER ) {
                                /* function returning pointer needs dummy symbol */
                                        more = dummy_idx(typ, otag) ;
                                        type = (zfar ? CPTR : CINT );
                                        ident=FUNCTIONP;
                                } else ident=FUNCTION;
                                size = 0 ;
                                
                        }
                }
                if (cmatch('[')) {         /* array? */
                        ptrerror(ident) ;
                        if ( ident == POINTER) {
                                /* array of pointers needs dummy symbol */
                                more = dummy_idx(typ, otag) ;
                                type = (zfar ? CPTR : CINT );
                        }
                        size = needsub() ;      /* get size */
                        if (size == 0 && ident == POINTER ) size=0;
                        ident = ARRAY;
			if ( ptrtofn ) needtoken(")()");
                }
		else if ( ptrtofn ) {
                        needtoken(")()") ;
		}
                else if ( ident == PTR_TO_PTR ) {
                        ident = POINTER ;
                        more = dummy_idx(typ, otag) ;
                        type = (zfar ? CPTR : CINT );
                }
/* Check to see if far has been defined when we haven't got a pointer */

                if (zfar && !(ident==POINTER || (ident==ARRAY && more) || (ident==FUNCTIONP && more))) {
                        warning(W_FAR);
                        zfar=NO;
                }

                if ( otag ) {
                        /* calculate index of object's tag in tag table */
                        itag = otag - tagtab ;
                }
                /* add symbol */
                if ( mtag == 0 ) {
                        /* this is a real variable, not a structure member */
                       if (typ == VOID && ident != FUNCTION && ident!=FUNCTIONP && ident != POINTER && ident != ARRAY ) {
                                warning(W_BADDECL);
                                typ=CINT;
                       }
                       myptr=addglb(sname, ident, type, 0, storage, more, itag) ;
/* What happens if we have an array which will be initialised? */

                        myptr->flags = ( sign | zfar | fastcall );

                        /* initialise variable (allocate storage space) */
                        /* defstatic to prevent repetition of def for declared statics */
                        defstatic=0;
                        myptr->size=0;   /* Set to zero.. */
                        if ( ident == FUNCTION || ident==FUNCTIONP ) {  
                                myptr->prototyped=0;
                                myptr->args[0]=CalcArgValue(typ,ident,myptr->flags);
                                myptr->ident=FUNCTION;
                                if (typ==STRUCT)
                                        myptr->tagarg[0]=itag;
                        }
                        if ( storage != EXTERNAL && ident != FUNCTION ) {
                            size_st=initials(sname, type, ident, size, more, otag, zfar) ;

                        if (storage == EXTERNP) 
                                myptr->size=addr;
                        else
                                myptr->size=size_st;
                        if (defstatic)
                                myptr->storage=DECLEXTN;
                        }

/*
 *      Set the return type of the function
 */
                        if ( ident == FUNCTION ) {
                                myptr->args[0]=CalcArgValue(type, FUNCTION, myptr->flags);
				myptr->flags|=callee;
			}
/* Make library routines so.. */
                        if ( storage == EXTERNAL && ident == FUNCTION )
                        {
                                myptr->handled=0;
				myptr->flags&=(~LIBRARY);
                                if (libdef)
					myptr->flags|=LIBRARY;
                                if (libdef==SHARED || libdef==SHAREDC){
				/* Shared can't be __CALLEE__ */
					myptr->flags&=(~CALLEE);
					myptr->flags|=libdef|LIBRARY;
				}
                                
                        }

                }
                else if ( is_struct ) {
                        if ( type==CINT && ident==VARIABLE ) BitFieldSwallow();
                        /* are adding structure member, mtag->size is offset */
                        myptr=addmemb(sname, ident, type, mtag->size, storage, more, itag) ;
                        myptr--;        /* addmemb returns myptr+1 */
                        myptr->flags = ( (sign&UNSIGNED) | (zfar&FARPTR) );
                        myptr->size = size;

                        /* store (correctly scaled) size of member in tag table entry */
                        /* 15/2/99 djm - screws up sizing of arrays -
                           quite obviously!! - removing */
                        if ( ident == POINTER) { /* || ident== ARRAY ) { */
                                type=(zfar ? CPTR : CINT);
                        }

                        cscale(type, otag, &size) ;
                        mtag->size += size ;

                }
                else {
                        /* are adding union member, offset is always zero */
                        myptr=addmemb(sname, ident, type, 0, storage, more, itag) ;
                        myptr--;
                        myptr->flags = ( (sign&UNSIGNED) | (zfar&FARPTR) );


                        /* store maximum member size in tag table entry */
                        if ( ident == POINTER || ident==ARRAY ) {
                                type=(zfar ? CPTR : CINT);
                        }
                        cscale(type, otag, &size) ;
                        if ( mtag->size < size )
                                mtag->size = size ;
                }
        } while ( cmatch(',') ) ;
        ns() ;
}

/*
 *      Declare local variables (i.e. define for use)
 *
 *  works just like "declglb" but modifies machine stack
 *  and adds symbol table entry with appropriate
 *  stack offset to find it again
 */
void declloc(
int typ ,                       /* typ is CCHAR, CINT DOUBLE or STRUCT, LONG  */
TAG_SYMBOL *otag ,      /* tag of struct for object being declared */
char sign,               /* Are we signed or not? */
char locstatic,         /* Is this as static local variable? */
char zfar)               /* Far pointer thing.. */
{
        char sname[NAMESIZE];
        char sname2[3*NAMESIZE];        /* More than enuff overhead! */
        SYMBOL *cptr ;
        int dsize,size, ident, more, itag, type, decltype ;


 /*       if ( swactive ) error(E_DECLSW) ; */
        if ( declared < 0 ) error(E_DECLST) ;
        do {
                if ( endst() ) break ;

                type = decltype = typ ;
                more =                                          /* assume dummy symbol not required */
                itag = 0 ;
                dsize=size = 1 ;
                ident = get_ident() ;

                if ( symname(sname) == 0 )
                        illname(sname) ;

                if ( ident == FUNCTIONP ) {
                           needtoken(")()");
                 /* function returning pointer needs dummy symbol */
                           more = dummy_idx(typ, otag) ;
                           type = (zfar ? CPTR : CINT );
                           dsize=size = (zfar ? 3 : 2 );
                } 

                if ( ident == PTR_TO_FN ) {
                        needtoken(")()") ;
                        ident = POINTER ;
                }


                if ( cmatch('[') ) {
                        ptrerror(ident) ;
                        if ( ident == POINTER ) {
                                /* array of pointers needs dummy symbol */
                                more = dummy_idx(typ, otag) ;
                                type = ( zfar ? CPTR : CINT );
                        }
                        dsize=size = needsub() ;
                        ident = ARRAY ;                 /* null subscript array is NOT a pointer */
                        cscale(type, otag, &size);
                }
                else if ( ident == PTR_TO_PTR ) {
                        ident = POINTER ;
                        more = dummy_idx(typ, otag) ;
                        type = (zfar ? CPTR : CINT ) ;
                        dsize=size = (zfar ? 3 : 2 );
                }
                else {
                        switch ( type ) {
                        case CCHAR :
                                size = 1 ;
                                break ;
                        case LONG :
                                size = 4;
                                break ;
                        case DOUBLE :
                                size = 6 ;
                                break ;
                        case STRUCT :
                                size = otag->size ;
                                break ;
                        default :
                                size = 2 ;
                        }
                }
/* Check to see if far has been defined when we haven't got a pointer */
                if (zfar && !(ident==POINTER || (ident==ARRAY && more))) {
                        warning(W_FAR);
                        zfar=NO;
                }
                       if (typ == VOID && ident != FUNCTION && ident != POINTER ) {
                       
                                warning(W_BADDECL);
                                typ=type=CINT;
                        }
                if (ident == POINTER) {
			decltype = ( zfar ? CPTR : CINT);
			size = ( zfar ? 3 : 2 );
		}

/*                declared += size ; Moved down djm */
                if ( otag )
                        itag = otag - tagtab ;
/* djm, add in local statics - use the global symbol table to ensure
 * that they will be placed in RAM and not in ROM
 */
                if (locstatic) {
                        strcpy(sname2,"st_");
                        strcat(sname2,currfn->name);
                        strcat(sname2,"_");
                        strcat(sname2,sname);
                        cptr=addglb(sname2,ident,type,0,LSTATIC,more,itag);
                        if (cptr) {
                                cptr->flags=( (sign&UNSIGNED) | (zfar&FARPTR));
                                cptr->size=size;
                        }
                        if (rcmatch('=') ) {
/*
 *      Insert the jump in...
 */
                                if (lstdecl++ == 0 ) {
                                        jump(lstlab=getlabel());
                                }
                                initials(sname2, type, ident, dsize, more, otag,zfar);
                                ns();
                                cptr->storage=LSTKEXT;
                                return;
                        } else if (ident==ARRAY && dsize == 0 ) {
				char *dosign="",*typ;
				typ=ExpandType(more,&dosign,otag-tagtab);
				warning(W_NULLARRAY,dosign,typ);
			}

                } else {
                        declared += size;
                        cptr = addloc(sname, ident, type, more, itag);
                        if ( cptr )
                                {
                                cptr->size=size;
                                cptr->offset.i = Zsp - declared ;
                                cptr->flags=( (sign&UNSIGNED) | (zfar&FARPTR) );
				if (cmatch('=') ) {
					int vconst, val, expr;
					char *before,*start;
					if (lstdecl) postlabel(lstlab);
					lstdecl=0;
					Zsp=modstk(Zsp-(declared-size),NO,NO);
					declared=0;
					setstage(&before,&start);
					expr=expression(&vconst,&val);
					clearstage(before,start);
					//conv type
					force(decltype,expr,0,0,0);
					StoreTOS(decltype);
                                }
			}
                }
        } while ( cmatch(',') ) ;
        ns() ;
}



/*
 *      Calculate a value for the arguments, this is kludgey but
 *      kinda nice at the same time
 *      bits 0-2 = type ; 3-5 = ident, 7-8=flags (signed & zfar)
 */

unsigned char CalcArgValue(char type, char ident, char flags)
{
        if (type==ELLIPSES) return PELLIPSES;
        if (type==VOID) flags&=MKSIGN;   /* remove sign from void */
        return( type+(ident*8)+((flags&MKDEF)*64) );
}

/*
 *	Expand the type into something nice
 */

char *ExpandType(int type, char **dosign, char tagidx)
{
	char	*typ;

        switch(type) {
                case DOUBLE:
                        typ="double ";
                        *dosign="";
                        break;
                case CINT:
                        typ="int ";
                        break;
                case CCHAR:
                        typ="char ";
                        break;
                case LONG:
                        typ="long ";
                        break;
                case CPTR:
                        typ="lptr ";
                        break;
                case STRUCT:
                        *dosign="struct ";
                        typ=(&tagtab[(int) tagidx])->name;
                        break;
                case VOID:
                        typ="void ";
                        *dosign="";
                        break;
                default:
                        typ="<unknown> ";
                        break;
        }
	return typ;
}



/*
 *      Expand the prototype byte out into what the variable actually 
 *      is..
 */

char *

ExpandArgValue(unsigned char value, char *buffer, char tagidx)
{
        char    ident, type, isfar, issigned;
        char    *id, *typ, *dofar, *dosign;

        type=value&7;           /* Lower 3 bits */
        ident=(value&56)/8;     /* Middle 3 bits */
        isfar=(value&128);
        issigned=(value&64);

        if (issigned) dosign="unsigned ";
        else dosign="signed ";

        if (isfar) dofar="far ";
        else dofar="";

	typ=ExpandType(type,&dosign,tagidx);

        switch(ident) {
                case POINTER:
                        id="*";
                        break;
                case FUNCTION:
                        id="fn";
                        break;
                case FUNCTIONP:
                        id="*fn";
                        break;
                case VARIABLE:
                case ARRAY:
                default:
                        id="";
                        break;
        }

        sprintf(buffer,"%s%s%s%s",dofar,dosign,typ,id);
        return (buffer);
}




/*
 * test for function returning/array of ptr to ptr (unsupported)
 */
void ptrerror(ident)
int ident ;
{
        if ( ident == PTR_TO_PTR )
                error(E_INDIRECTION) ;
}


/*
 *      Get required array size
 *
 * invoked when declared variable is followed by "["
 *      this routine makes subscript the absolute
 *      size of the array.
 */
int needsub()
{
        long num;

        if ( cmatch(']') ) return (0);   /* null size */
        if ( constexpr(&num) == 0 ) {
                num = 1 ;
        }
        else if ( num < 0 ) {
                error(E_NEGATIVE);
                num = (-num) ;
        }
        needchar(']') ;         /* force single dimension */
        return ((int) num) ;            /* and return size */
}


/*
 *      Get the type of variable, handles far, unsigned etc, this
 *      way is much neater and centralises things somewhat!
 *
 *      Returns otag for structure or 0 (can tell success via var.type)
 *
 *      djm 18/3/99
 */


TAG_SYMBOL *GetVarID(struct varid *var,char storage)
{
        TAG_SYMBOL *otag;
        char    sname[NAMEMAX];
        SYMBOL  *ptr;
        
        var->sign=dosigned;
        var->zfar=NO;
        var->type=NO;
        var->sflag=NO;

        if (swallow("const") )
                warning(W_CONST);
        else if (swallow("volatile") )
                warning(W_VOLATILE);

        if      (amatch("far") ) var->zfar=FARPTR;
        else if ( amatch("near") ) var->zfar=NO;

        if      (amatch("signed") ) { var->type=CINT; var->sign=NO; }
        else if (amatch("unsigned") ) { var->type=CINT; var->sign=YES; }

        if      (amatch("char") ) var->type=CCHAR;
        else if (amatch("int") ) var->type=CINT;
        else if (amatch("long") ) { swallow("int"); var->type=LONG; }
        else if (amatch("short") ) { swallow("int"); var->type=CINT; }
        else if (amatch("float") || amatch("double") ) { incfloat=1; var->type=DOUBLE; }
        else if (amatch("void") ) var->type=VOID;
        else if (amatch("enum") ) {
                if ( symname(sname) == 0 ) 
			sprintf(sname,"sc_i_enumb%d",defdenums++);
                ptr=findenum(sname);
                if ( ptr == 0 ) /* not defined */
                        defenum(sname,storage);
                var->type=CINT;
                var->sign=dosigned;
        }
        else if ( (var->sflag=amatch("struct")) || amatch("union") ) {
                 var->type=STRUCT;
                /* find structure tag */
                if ( storage==TYPDEF && rcmatch('{') ) 
                        return (defstruct(0, storage, var->sflag) );
                if ( symname(sname) == 0 )
                        illname(sname) ;
                if ( (otag=findtag(sname)) == 0 ) {
                        /* structure not previously defined */
                        if ( storage == NO ) 
                                error(E_UNSTR);
                        else
                                otag = defstruct(sname, storage, var->sflag) ;
                }
                return(otag);
        } else {
                SYMBOL *ptr;
                ptr=STARTGLB;
                while ( ptr <= ENDGLB ) {
                        if (ptr->name[0] && ptr->storage == TYPDEF && amatch(ptr->name) ) {
/* Found a typedef match */
                                var->sign=ptr->flags&UNSIGNED;
                                var->zfar=ptr->flags&FARPTR;
                                var->type=ptr->type;
                                if (var->type==STRUCT) return (tagtab+ptr->tag_idx);
                                else return(0);
                        }
                        ++ptr;
                }
        }
        return(0);
}

/*
 *      Swallow bitfield definition 
 */

void BitFieldSwallow()
{
        long    val;
        if      (cmatch(':')) {
                constexpr(&val);
                warning(W_BITFIELD);
        }
}
