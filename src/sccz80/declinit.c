/*
 *      Routines to initialise variables
 *      Split from decl.c 11/3/98 djm
 *
 *      14/3/99 djm Solved many problems with string initialisation
 *      char arrays in structs now initialised correctly, strings
 *      truncated if too long, all seems to be fine - hurrah!
 *
 *	2/2/02 djm - This file needs to rewritten to be more flexible
 * 
 *      3/2/02 djm - Unspecified structure members are now padded out
 *
 *      $Id: declinit.c,v 1.14 2009-09-06 18:58:37 dom Exp $
 */

#include "ccdefs.h"


/*
 * initialise global object
 */
int initials(char *sname,
             int type, int ident, int dim, int more,
             TAG_SYMBOL * tag, char zfar)
{
    int size, desize = 0;
    int olddim = dim;


    if (cmatch('=')) {
        /* initialiser present */
        defstatic = 1;		/* So no 2nd redefine djm */
        gltptr = 0;
        glblab = getlabel();
        if (dim == 0)
            dim = -1;
        switch (type) {
        case CCHAR:
            size = 1;
            break;
        case LONG:
            size = 4;
            break;
        case CINT:
        default:
            size = 2;
        }
	    
        output_section("text");
        prefix();
        outname(sname, YES);
        col();
        nl();

        if (cmatch('{')) {
            /* aggregate initialiser */
            if ((ident == POINTER || ident == VARIABLE) && type == STRUCT) {
                /* aggregate is structure or pointer to structure */
                dim = 0; olddim = 1;
                if (ident == POINTER)
                    point();
                str_init(tag);
            } else {
                /* aggregate is not struct or struct pointer */
                agg_init(size, type, ident, &dim, more, tag);
            }
            needchar('}');
        } else {
            /* single initialiser */
            init(size, ident, &dim, more, 0, 0);
        }


        /* dump literal queue and fill tail of array with zeros */
        if ((ident == ARRAY && more == CCHAR) || type == STRUCT) {
            if (type == STRUCT) {
                dumpzero(tag->size, dim);
                desize = dim < 0 ? abs(dim+1)*tag->size : olddim * tag->size;
            } else { /* Handles unsized arrays of chars */
                dumpzero(size, dim);
                dim = dim < 0 ? abs(dim+1) : olddim;
                cscale(type,tag,&dim);
                desize = dim;
            }
            dumplits(0, YES, gltptr, glblab, glbq);
        } else {
            if (!(ident == POINTER && type == CCHAR)) {
                dumplits(((size == 1) ? 0 : size), NO, gltptr, glblab,glbq);
                if ( type != CCHAR )  /* Already dumped by init? */
                    desize = dumpzero(size, dim);
                dim = dim < 0 ? abs(dim+1) : olddim;
                cscale(type,tag,&dim);
                desize = dim;
            }             
        }
        output_section("code");
    } else {
        char *dosign, *typ;
        dosign = "";
        if (ident == ARRAY && (dim == 0)) {
            typ = ExpandType(more, &dosign, (tag - tagtab));
            warning(W_NULLARRAY, dosign, typ);
        }
        /* no initialiser present, let loader insert zero */
        if (ident == POINTER)
            type = (zfar ? CPTR : CINT);
        cscale(type, tag, &dim);
        desize = dim;
    }
    return (desize);
}





/*
 * initialise structure
 */
int str_init(TAG_SYMBOL *tag)
{
    int dim, flag;
    int sz, usz, numelements = 0;
    SYMBOL *ptr;
    int     nodata = NO;

    ptr = tag->ptr;
    while (ptr < tag->end) {
        numelements++;
        dim = ptr->size;
        sz = getstsize(ptr,NO);
        if ( nodata == NO ) {
            if ( rcmatch('{') ) {
                needchar('{');
                while (dim) {
                    if ( ptr->type == STRUCT ) {
                        if ( ptr->ident == ARRAY )
                        /* array of struct */
                            needchar('{');
                        str_init(tag);
                        if ( ptr->ident == ARRAY ) {
                            --dim;
                            needchar('}');
                        }
                    } else {
                        init(sz, ptr->ident, &dim, 1, 1,1);
                    }

                    if (cmatch(',') == 0)
                        break;
                    blanks();
                }
                needchar('}');
                dumpzero(sz,dim);
            } else {
                init(sz, ptr->ident, &dim, ptr->more, 1, 1);
            }
            /* Pad out afterwards */
        } else {  /* Run out of data for this initialisation, set blank */ 
            defstorage();
            outdec(dim * getstsize(ptr,YES));
            nl();		
        }



        usz = (ptr->size ? ptr->size : 1 ) * getstsize(ptr,YES);
        ++ptr;
        flag = NO;
        while (ptr->offset.i == 0 && ptr < tag->end) {
            if (getstsize(ptr,YES) * (ptr->size ? ptr->size : 1 )  > usz) {
                usz = getstsize(ptr,YES) * (ptr->size ? ptr->size : 1 ) ;
                flag = YES;
            }
            ++ptr;

        }

        /* Pad out the union */
        if (usz != sz && flag) {
            defstorage();
            outdec(usz - sz);
            nl();
        }
        if (cmatch(',') == 0 && ptr != tag->end) {
            nodata = YES;	   
        }
    }
    return numelements;
}

/*
 * initialise aggregate
 */
void agg_init(int size, int type, int ident, int *dim, int more, TAG_SYMBOL *tag)
{
    while (*dim) {
	if (ident == ARRAY && type == STRUCT) {
	    /* array of struct */
	    needchar('{');
	    str_init(tag);
	    --*dim;
	    needchar('}');
	} else {
	    init(size, ident, dim, more, (ident == ARRAY && more == CCHAR),0);
	}
	
	if (cmatch(',') == 0)
	    break;	
	blanks();
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
void init(int size, int ident, int *dim, int more, int dump, int is_struct)
{
    int32_t value;
    int     sz;			/* number of chars in queue */
/*
 * djm 14/3/99 We have to rewrite this bit (ugh!) so that we store
 * our literal in a temporary queue, then if needed, we then dump
 * it out..
 */

    if ((sz = qstr(&value)) != -1 ) {
        sz++;
#if 0
        if (ident == VARIABLE || (size != 1 && more != CCHAR))
            error(E_ASSIGN);
#endif
#ifdef INIT_TEST
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
        if (ident == ARRAY && more == 0) {
/*
 * Dump the literals where they are, padding out as appropriate
 */
            if (*dim != -1 && sz > *dim) {
/*
 * Ooops, initialised to long a string!
 */
                warning(W_INIT2LONG);
                sz = *dim;
                gltptr = sz;
                *(glbq + sz - 1) = '\0';	/* Terminate string */
            }
            dumplits(((size == 1) ? 0 : size), NO, gltptr, glblab, glbq);
            *dim -= sz;
            gltptr = 0;
            dumpzero(size, *dim);
            return;
        } else {
/*
 * Store the literals in the queue!
 */
            storeq(sz, glbq, &value);
            gltptr = 0;
            defword();
            printlabel(litlab);
            outbyte('+');
            outdec(value);
            nl();
            --*dim;
            return;
        }
    }
/*
 * djm, catch label names in structures (for (*name)() initialisation
 */
    else {
        char sname[NAMEMAX + 1];
        SYMBOL *ptr;
        if (symname(sname)  && strcmp(sname,"sizeof") ) {	/* We have got something.. */
            if ((ptr = findglb(sname))) {
                /* Actually found sommat..very good! */
                if (ident == POINTER || (ident == ARRAY && more)) {
                    defword();
                    outname(ptr->name, dopref(ptr));
                    nl();
                    --*dim;
                } else if (ptr->type == ENUM) {
                    value = ptr->size;
                    goto constdecl;
                } else {
                    error(E_DDECL);
                }
            } else
                error(E_UNSYMB, sname);
        } else if (rcmatch('}')) {
#if 0
            dumpzero(size,*dim);
#endif
        } else if (constexpr(&value, 1)) {
        constdecl:
            if (ident == POINTER) {
                /* 24/1/03 dom - We want to be able to assign values to
                   pointers or they're a bit useless..
                */
#if 0
                /* the only constant which can be assigned to a pointer is 0 */
                if (value != 0)
                    warning(W_ASSPTR);
#endif
                size = 2;
                dump = YES;
            }
            if (dump) {
                /* struct member or array of pointer to char */
                if (size == 4) {
/* there appears to be a bug in z80asm regarding defl */
                    defbyte();
                    outdec((value % 65536UL) % 256);
                    outbyte(',');
                    outdec((value % 65536UL) / 256);
                    outbyte(',');
                    outdec((value / 65536UL) % 256);
                    outbyte(',');
                    outdec((value / 65536UL) / 256);
                } else {
                    if (size == 1)
                        defbyte();
                    else
                        defword();
                    outdec(value);
                }
                nl();
                /* Dump out a train of zeros as appropriate */
                if (ident == ARRAY && more == 0) {		 
                    dumpzero(size,(*dim)-1);
                }

            } else
                stowlit(value, size);
            --*dim;
        }
    }
}

/* Find the size of a member of a union/structure */

int getstsize(SYMBOL * ptr,char real)
{
    TAG_SYMBOL *tag;
    int         ptrsize;

    tag = tagtab + ptr->tag_idx;

    ptrsize = ptr->flags&FARPTR ? 3 : 2;

#if 1
    if ( ptr->ident == POINTER && real)
	return ptrsize;
#endif

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
