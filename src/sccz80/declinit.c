/*
 *      Routines to initialise variables
 *      Split from decl.c 11/3/98 djm
 *
 *      14/3/99 djm Solved many problems with string initialisation
 *      char arrays in structs now initialised correctly, strings
 *      truncated if too long, all seems to be fine - hurrah!
 *
 *      $Id: declinit.c,v 1.1.1.1 2000-07-04 15:33:31 dom Exp $
 */

#include "ccdefs.h"


/*
 * initialise global object
 */
int initials(
char *sname ,
int type, int ident, int dim, int  more ,
TAG_SYMBOL *tag ,
char zfar)
{
        int size, desize ;

        if ( cmatch('=') ) {
                /* initialiser present */
                defstatic = 1;  /* So no 2nd redefine djm */
                gltptr = 0 ;
                glblab = getlabel() ;
                if ( dim == 0 ) dim = -1 ;
                size = (type == CINT) ? 2 : 1 ;
                if (type == LONG)  size = 4;

/* djm 10/10/98 Moved this line from below if stmt */
		if (asxx) ol(".area _TEXT");
                prefix(); outname(sname,1); nl();
                
                if ( cmatch('{') ) {
                        /* aggregate initialiser */
                        if ( (ident == POINTER || ident == VARIABLE) && type == STRUCT ) {
                                /* aggregate is structure or pointer to structure */
                                dim = 0 ;
                                if ( ident == POINTER ) point();
                                str_init(tag) ;
                        }
                        else {
                                /* aggregate is not struct or struct pointer */
                                agg_init(size, type, ident, &dim, more, tag) ;
                        }
                        needchar('}');
                }
                else {
                        /* single initialiser */
                        init(size, ident, &dim, more, 0,0) ;
                }


                /* dump literal queue and fill tail of array with zeros */
                if ( (ident == ARRAY && more == CCHAR) || type == STRUCT ) {
                        if ( type == STRUCT )
                                desize=dumpzero(tag->size, dim) ;
                        else
                                desize=dumpzero(size, dim) ;
                        dumplits(0, YES,gltptr,glblab,glbq) ;
                }
                else {
                        if ( !(ident == POINTER && type == CCHAR) ) 
                               dumplits(((size == 1) ? 0 : size ), NO,gltptr,glblab,glbq) ;
                        desize=dumpzero(size, dim) ;
                }
        }
        else {
		char *dosign, *typ;
		dosign="";
		if ( ident == ARRAY && (dim == 0 )  )  {
			typ=ExpandType(more,&dosign,(tag-tagtab));
			warning(W_NULLARRAY,dosign,typ);
		}
                /* no initialiser present, let loader insert zero */
                if ( ident == POINTER )
                        type = (zfar ? CPTR : CINT );
                cscale(type, tag, &dim) ;
                desize=dim;
        }               
                return(desize);
}





/*
 * initialise structure
 */
void str_init(tag)
TAG_SYMBOL *tag ;
{
        int dim ,flag;
        int sz, usz;
        SYMBOL *ptr ;

        ptr = tag->ptr ;
        while ( ptr < tag->end ) {
                dim=ptr->size;
		sz=getstsize(ptr);
		flag=0;
                init(sz, ptr->ident, &dim, ptr->more, 1,1) ;
		++ptr;
		/* This steps over union members */
		usz=sz;
		if (ptr->offset.i == 0 && ptr->size > usz) usz=ptr->size;
		while (ptr->offset.i == 0 && ptr <tag->end) {
			if (getstsize(ptr) > usz) {
				usz=getstsize(ptr);
				flag=1;
			}
                	++ptr ;
		}
		/* Pad out the union */
		if (usz != sz && flag ) { defstorage(); outdec(usz-sz); nl(); }
                if ( cmatch(',') == 0 && ptr != tag->end ) {
                        error(E_DATA) ;
                        break ;
                }
        }
}

/*
 * initialise aggregate
 */
void agg_init(size, type, ident, dim, more, tag)
int size, type, ident, *dim, more ;
TAG_SYMBOL *tag ;
{
        while ( *dim ) {
                if ( ident == ARRAY && type == STRUCT ) {
                        /* array of struct */
                        needchar('{') ;
                        str_init(tag) ;
                        --*dim ;
                        needchar('}') ;
                }
                else {
                        init(size, ident, dim, more, (ident == ARRAY && more == CCHAR),0 ) ;
                }
                if ( cmatch(',') == 0 ) break ;
        }
}


/*
 * evaluate one initialiser
 *
 * if dump is TRUE, dump literal immediately
 * save character string in litq to dump later
 * this is used for structures and arrays of pointers to char, so that the
 * struct or array is built immediately and the char strings are dumped later
 */
void init(size, ident, dim, more, dump, is_struct)
int size, ident, *dim, more, dump ,is_struct;
{
        long value ;
        int  sz;        /* number of chars in queue */
/*
 * djm 14/3/99 We have to rewrite this bit (ugh!) so that we store
 * our literal in a temporary queue, then if needed, we then dump
 * it out..
 */

        if ( (sz=qstr(&value) ) ) {
                sz++;
                if (ident == VARIABLE || (size != 1 && more != CCHAR) )
                        error(E_ASSIGN);
#ifdef DEBUG_INIT
                outstr("ident=");
                outdec(ident);
                outstr("size=");
                outdec(size);
                outstr("more=");
                outdec(more);
                outstr("dim=");
                outdec(*dim);
		outstr("sz=");
		outdec(sz);
                nl();
#endif
                if (ident == ARRAY && more == 0 ) {
/*
 * Dump the literals where they are, padding out as appropriate
 */
                        if (*dim != -1 && sz > *dim ) {
/*
 * Ooops, initialised to long a string!
 */
                                warning(W_INIT2LONG);
                                sz=*dim;
                                gltptr=sz;
                                *(glbq+sz-1)='\0'; /* Terminate string */
                        }
                        dumplits( ((size == 1) ? 0 : size ), NO,gltptr,glblab,glbq) ;
                        *dim-= sz;
                        gltptr=0;
                        dumpzero(size, *dim) ;
                } else {
/*
 * Store the literals in the queue!
 */
                        storeq(sz,glbq,&value);
                        gltptr=0;
                        defword() ;
                        printlabel(litlab) ;
                        outbyte('+') ;
                        outdec(value) ;
                        nl() ;
                        --*dim ;
                }
        }
        
/*
 * djm, catch label names in structures (for (*name)() initialisation
 */
        else {
                char sname[NAMEMAX+1];
                SYMBOL *ptr;
                if ( symname(sname) ) {      /* We have got something.. */
                        if ( (ptr = findglb(sname)) ) {
                        /* Actually found sommat..very good! */
                                if (ident==POINTER || (ident==ARRAY && more) ) {
                                        defword();
                                        outname(ptr->name,dopref(ptr));
                                        nl();
                                        --*dim;
                                } else if (ptr->type==ENUM) {
						value=ptr->size;
						goto constdecl;
				} else {
                                        error(E_DDECL);
                                }
                        } else 
                                error(E_UNSYMB,sname);
                }
                else if ( constexpr(&value) ) {
constdecl:
                        if ( ident == POINTER ) {
                        /* the only constant which can be assigned to a pointer is 0 */
                                if ( value != 0 )
                                        warning(W_ASSPTR) ;
                                size = 2 ;
                        }
                        if ( dump ) {
                        /* struct member or array of pointer to char */
                                if (size == 4) {
/* there appears to be a bug in z80asm regarding defl */
                                        defbyte();
                                        outdec((value%65536UL)%256);
                                        outbyte(',');
                                        outdec((value%65536UL)/256);
                                        outbyte(',');
                                        outdec((value/65536UL)%256);
                                        outbyte(',');
                                        outdec((value/65536UL)/256);
                                } else {
                                  if ( size == 1 ) defbyte() ;
                                  else defword() ;
                                  outdec(value) ;
                                }
                                nl() ;
                        }
                        else
                        stowlit(value, size) ;
                        --*dim ;
                }
        }
}

/* Find the size of a member of a union/structure */

int getstsize(SYMBOL *ptr)
{
	TAG_SYMBOL *tag;

	tag=tagtab+ptr->tag_idx;

	switch (ptr->type) {
		case STRUCT:
			return (tag->size);
		case DOUBLE:
			return (6);
		case LONG:
			return (4);
		case CPTR:	
			return (3);
		case CINT:
			return (2);
		default:
			return (1);
	}
}
