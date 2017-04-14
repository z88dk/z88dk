/*
 *      Routines to initialise variables
 *      Split from decl.c 11/3/98 djm
 *
 *      14/3/99 djm Solved many problems with string initialisation
 *      char arrays in structs now initialised correctly, strings
 *      truncated if too long, all seems to be fine - hurrah!
 *
 *        2/2/02 djm - This file needs to rewritten to be more flexible
 * 
 *      3/2/02 djm - Unspecified structure members are now padded out
 *
 *      $Id: declinit.c,v 1.18 2016-07-15 12:45:18 pauloscustodio Exp $
 */

#include "ccdefs.h"

static void output_double_string_load(double value);

/*
 * initialise global object
 */
int initials(char* sname,
    int type, enum ident_type ident, int dim, int more,
    TAG_SYMBOL* tag, char zfar, char isconst)
{
    int size, desize = 0;
    int olddim = dim;
    if (cmatch('=')) {
        /* initialiser present */
        defstatic = 1; /* So no 2nd redefine djm */
        gltptr = 0;
        glblab = getlabel();
        if (dim == 0)
            dim = -1;
        switch (type) {
        case DOUBLE:
            size = 6;
            break;
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

        // We can only use rodata_compile (i.e. ROM if double string isn't enabled)
        if ( isconst && !c_double_strings )  {
            output_section(c_rodata_section);
        } else {
            output_section(c_data_section); // output_section("text");
        }
        prefix();
        outname(sname, YES);
        col();
        nl();

        if (cmatch('{')) {
            /* aggregate initialiser */
            if ((ident == POINTER || ident == VARIABLE) && type == STRUCT) {
                /* aggregate is structure or pointer to structure */
                dim = 0;
                olddim = 1;
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
                desize = dim < 0 ? abs(dim + 1) * tag->size : olddim * tag->size;
            } else { /* Handles unsized arrays of chars */
                dumpzero(size, dim);
                dim = dim < 0 ? abs(dim + 1) : olddim;
                cscale(type, tag, &dim);
                desize = dim;
            }
            dumplits(0, YES, gltptr, glblab, glbq);
        } else {
            if (!(ident == POINTER && type == CCHAR)) {
                dumplits(((size == 1) ? 0 : size), NO, gltptr, glblab, glbq);
                if (type != CCHAR) /* Already dumped by init? */
                    desize = dumpzero(size, dim);
                dim = dim < 0 ? abs(dim + 1) : olddim;
                cscale(type, tag, &dim);
                desize = dim;            
            }
        }
        output_section(c_code_section); // output_section("code");
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
int str_init(TAG_SYMBOL* tag)
{
    int dim, flag;
    int sz, usz, numelements = 0;
    SYMBOL* ptr;
    int nodata = NO;

    ptr = tag->ptr;
    while (ptr < tag->end) {
        numelements++;
        dim = ptr->size;
        sz = getstsize(ptr, NO);
        if (nodata == NO) {
            if (rcmatch('{')) {
                needchar('{');
                while (dim) {
                    if (ptr->type == STRUCT) {
                        if (ptr->ident == ARRAY)
                            /* array of struct */
                            needchar('{');
                        str_init(tag);
                        if (ptr->ident == ARRAY) {
                            --dim;
                            needchar('}');
                        }
                    } else {
                        init(sz, ptr->ident, &dim, 1, 1, 1);
                    }

                    if (cmatch(',') == 0)
                        break;
                    blanks();
                }
                needchar('}');
                dumpzero(sz, dim);
            } else {
                init(sz, ptr->ident, &dim, ptr->more, 1, 1);
            }
            /* Pad out afterwards */
        } else { /* Run out of data for this initialisation, set blank */
            defstorage();
            outdec(dim * getstsize(ptr, YES));
            nl();
        }

        usz = (ptr->size ? ptr->size : 1) * getstsize(ptr, YES);
        ++ptr;
        flag = NO;
        while (ptr->offset.i == 0 && ptr < tag->end) {
            if (getstsize(ptr, YES) * (ptr->size ? ptr->size : 1) > usz) {
                usz = getstsize(ptr, YES) * (ptr->size ? ptr->size : 1);
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
void agg_init(int size, int type, enum ident_type ident, int* dim, int more, TAG_SYMBOL* tag)
{
    int done = 0;
    while (*dim) {
        if (ident == ARRAY && type == STRUCT) {
            /* array of struct */
            if  ( done == 0 ) {
                needchar('{');
            } else if ( cmatch('{') == 0 ) {
                break;
            }
            str_init(tag);
            --*dim;
            needchar('}');
        } else {
            init(size, ident, dim, more, (ident == ARRAY && more == CCHAR), 0);
        }
        done++;
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
void init(int size, enum ident_type ident, int* dim, int more, int dump, int is_struct)
{
    double value;
    int    valtype;
    int sz; /* number of chars in queue */

    if ((sz = qstr(&value)) != -1) {
        sz++;
        if (ident == ARRAY && more == 0) {
            /* Dump the literals where they are, padding out as appropriate */
            if (*dim != -1 && sz > *dim) {
                /* Ooops, initialised to long a string! */
                warning(W_INIT2LONG);
                sz = *dim;
                gltptr = sz;
                *(glbq + sz - 1) = '\0'; /* Terminate string */
            }
            dumplits(((size == 1) ? 0 : size), NO, gltptr, glblab, glbq);
            *dim -= sz;
            gltptr = 0;
            dumpzero(size, *dim);
            return;
        } else {
            int32_t ivalue = value;
            /* Store the literals in the queue! */
            storeq(sz, glbq, &ivalue);
            gltptr = 0;
            defword();
            printlabel(litlab);
            outbyte('+');
            outdec(ivalue);
            nl();
            --*dim;
            return;
        }
    } else {
        /* djm, catch label names in structures (for (*name)() initialisation */
        char sname[NAMESIZE];
        SYMBOL *ptr;
        if (symname(sname) && strcmp(sname, "sizeof")) { /* We have got something.. */
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
        } else if (constexpr(&value, &valtype, 1)) {
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
                if ( size == 6 ) {
                    unsigned char  fa[6];
                    int      i;
                    /* It was a float, lets parse the float and then dump it */
                    if ( c_double_strings ) { 
                        output_double_string_load(value);
                    } else {
                        dofloat(value, fa, c_mathz88 ? 4 : 5, c_mathz88 ? 127 : 128);
                        defbyte();
                        for ( i = 0; i < 6; i++ ) {
                            if ( i ) outbyte(',');
                            outdec(fa[i]);
                        }
                    }
                } else  if (size == 4) {
                    /* there appears to be a bug in z80asm regarding defq */
                    defbyte();
                    outdec(((uint32_t)value % 65536UL) % 256);
                    outbyte(',');
                    outdec(((uint32_t)value % 65536UL) / 256);
                    outbyte(',');
                    outdec(((uint32_t)value / 65536UL) % 256);
                    outbyte(',');
                    outdec(((uint32_t)value / 65536UL) / 256);
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
                    dumpzero(size, (*dim) - 1);
                }

            } else {
                if ( size == 6 ) {
                    unsigned char  fa[6];
                    int            i;

                    decrement_double_ref_direct(value);
                    /* It was a float, lets parse the float and then dump it */
                      if ( c_double_strings ) {
                        output_double_string_load(value);
                    } else {
                        dofloat(value, fa, c_mathz88 ? 4 : 5, c_mathz88 ? 127 : 128);
                        for ( i = 0; i < 6; i++ ) {
                            stowlit(fa[i], 1);
                        }
                    }
                } else {
                    stowlit(value, size);
                }
            }
            --*dim;
        }
    }
}

/* Find the size of a member of a union/structure */

int getstsize(SYMBOL* ptr, char real)
{
    TAG_SYMBOL* tag;
    int ptrsize;

    tag = tagtab + ptr->tag_idx;

    ptrsize = ptr->flags & FARPTR ? 3 : 2;

#if 1
    if (ptr->ident == POINTER && real)
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

static void output_double_string_load(double value)
{
    int   dumplocation = getlabel();
    LVALUE lval;

    postlabel(dumplocation);
    defstorage(); outdec(6); nl();
    
    output_section("code_crt_init");
    lval.const_val = value;
    load_double_into_fa(&lval);
    immedlit(dumplocation); outdec(0); nl();
    callrts("dstore");
    output_section(c_data_section);
}