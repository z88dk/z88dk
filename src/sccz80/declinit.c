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
static int init(Type *type, int dump);
static int agg_init(Type *type);




/*
 * initialise global object
 */
int initials(const char *dropname, Type *type)
{
    int desize = 0;
    gltptr = 0;
    glblab = getlabel();


    // We can only use rodata_compile (i.e. ROM if double string isn't enabled)
    if ( type->isconst && !c_double_strings )  {
        output_section(c_rodata_section);
    } else {
        output_section(c_data_section); // output_section("text");
    }
    prefix();
    outname(dropname, YES);
    col();
    nl();

    if (cmatch('{')) {
        if ( type->kind == KIND_STRUCT || ( type->kind == KIND_PTR && type->ptr->kind == KIND_STRUCT)) {
            if ( type->kind == KIND_PTR ) {
                point();
            }
            desize = str_init(type->kind == KIND_STRUCT ? type->tag : type->ptr);
        } else {
            // Aggregate initialiser
            desize = agg_init(type);
        }
        needchar('}');
    } else {
        // Initialise a single one
        desize = init(type, 1);
    }

    /* dump literal queue and fill tail of array with zeros */
    // if ((ident == ID_ARRAY && more == KIND_CHAR) || type == KIND_STRUCT) {
    //     if (type == KIND_STRUCT) {
    //         dumpzero(tag->size, dim);
    //         desize = dim < 0 ? abs(dim + 1) * tag->size : olddim * tag->size;
    //     } else { /* Handles unsized arrays of chars */
    //         dumpzero(size, dim);
    //         dim = dim < 0 ? abs(dim + 1) : olddim;
    //         cscale(type, tag, &dim);
    //         desize = dim;
    //     }
    //     dumplits(0, YES, gltptr, glblab, glbq);
    // } else {
    //     if (!(ident == POINTER && type == KIND_CHAR)) {
    //         dumplits(((size == 1) ? 0 : size), NO, gltptr, glblab, glbq);
    //         if (type != KIND_CHAR) /* Already dumped by init? */
    //             desize = dumpzero(size, dim);
    //         dim = dim < 0 ? abs(dim + 1) : olddim;
    //         cscale(type, tag, &dim);
    //         desize = dim;            
    //     }
    // }
    output_section(c_code_section); 

    return (desize);
}

/*
 * initialise structure (also called by init())
 * 
 * Pads out to the size of the structure
 */
int str_init(Type *tag)
{
    int sz = 0;
    Type   *ptr;
    int     i;

    for ( i = 0; i < array_len(tag->fields); i++ ) {
        if ( i != 0 ) needchar(',');
        ptr = array_get_byindex(tag->fields,i);
        sz += tag->fields->size;
        init(ptr,1);
    }
    // Pad out the union
    if ( sz < tag->size) {
        defstorage();
        outdec(tag->size - sz);
        nl();
    }
    return tag->size;
}


/*
 * initialise aggregate
 */
int agg_init(Type *type)
{
    int done = 0;
    int dim = type->len;
    int size = 0;

    while (dim) {
        if ( type->kind == KIND_ARRAY && type->ptr->kind == KIND_STRUCT ) {
            /* array of struct */
            if  ( done == 0 ) {
                needchar('{');
            } else if ( cmatch('{') == 0 ) {
                break;
            }
            size += str_init(type->ptr->tag);
            dim--;
            needchar('}');
        } else if ( type->ptr->kind == KIND_ARRAY ) {
            needchar('{');
            size += agg_init(type->ptr);
            needchar('}');
        } else {
            size += init(type->ptr,1);
        }
        done++;
        if (cmatch(',') == 0)
            break;
        blanks();
    }
    if ( type->len != -1 ) {
        size += dumpzero(1, type->size - size);
    }
    return size;
}

/*
 * evaluate one initialiser
 *
 * if dump is TRUE, dump literal immediately
 * save character string in litq to dump later
 * this is used for structures and arrays of pointers to char, so that the
 * struct or array is built immediately and the char strings are dumped later
 */
static int init(Type *type, int dump)
{
    double value;
    Kind   valtype;
    int sz; /* number of chars in queue */

    if ((sz = qstr(&value)) != -1) {
        sz++;
        if ( type->kind == KIND_ARRAY ) {
            /* Dump the literals where they are, padding out as appropriate */
            if (type->len != -1 &&  sz > type->len) {
                /* Ooops, initialised to long a string! */
                warning(W_INIT2LONG);
                sz = type->len;
                gltptr = sz;
                *(glbq + sz - 1) = '\0'; /* Terminate string */
            }
            dumplits(type->ptr->kind == KIND_CHAR ? 0 : type->ptr->size, NO, gltptr, glblab, glbq);
            gltptr = 0;
            if ( type->len != -1 ) {
                dumpzero(type->size/ type->len, type->len - sz);
            }
            return type->size;
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
            return 2;
        }
    } else {
        /* djm, catch label names in structures (for (*name)() initialisation */
        char sname[NAMESIZE];
        SYMBOL *ptr;
        if (symname(sname) && strcmp(sname, "sizeof")) { /* We have got something.. */
            if ((ptr = findglb(sname))) {
                /* Actually found sommat..very good! */
                if ( type->kind == KIND_PTR || type->kind == KIND_ARRAY ) {
                    defword();
                    outname(ptr->name, dopref(ptr));
                    nl();
                    if ( type->isfar ) {
                        defbyte(); outdec(0); nl();
                    }
                } else if (ptr->type == KIND_ENUM) {
                    value = ptr->size;
                    goto constdecl;
                } else {
                    error(E_DDECL);
                    junk();
                }
            } else {
                error(E_UNSYMB, sname);
                junk();
            }
        } else if (rcmatch('}')) {
#if 0
            dumpzero(size,*dim);
#endif
        } else if (constexpr(&value, &valtype, 1)) {
constdecl:
            if (dump) {
                /* struct member or array of pointer to char */
                if ( type->kind == KIND_DOUBLE ) {
                    unsigned char  fa[6];
                    int      i;
                    /* It was a float, lets parse the float and then dump it */
                    if ( c_double_strings ) { 
                        output_double_string_load(value);
                    } else {
                        dofloat(value, fa);
                        defbyte();
                        for ( i = 0; i < 6; i++ ) {
                            if ( i ) outbyte(',');
                            outdec(fa[i]);
                        }
                    }
                } else if (type->kind == KIND_LONG ){
                    /* there appears to be a bug in z80asm regarding defq */
                    defbyte();
                    outdec(((uint32_t)value % 65536UL) % 256);
                    outbyte(',');
                    outdec(((uint32_t)value % 65536UL) / 256);
                    outbyte(',');
                    outdec(((uint32_t)value / 65536UL) % 256);
                    outbyte(',');
                    outdec(((uint32_t)value / 65536UL) / 256);
                } else if (type->kind == KIND_CPTR) {
                    defbyte();
                    outdec(((uint32_t)value % 65536UL) % 256);
                    outbyte(',');
                    outdec(((uint32_t)value % 65536UL) / 256);
                    outbyte(',');
                    outdec(((uint32_t)value / 65536UL) % 256);
                } else {
                    if (type->kind == KIND_CHAR ) 
                        defbyte();
                    else
                        defword();
                    outdec(value);
                }
                nl();
                /* Dump out a train of zeros as appropriate */
                // if (ident == ID_ARRAY && more == 0) {
                //     dumpzero(size, (dim) - 1);
                // }

            } else {
                if ( type->kind == KIND_DOUBLE ) {
                    unsigned char  fa[6];
                    int            i;

                    decrement_double_ref_direct(value);
                    /* It was a float, lets parse the float and then dump it */
                      if ( c_double_strings ) {
                        output_double_string_load(value);
                    } else {
                        dofloat(value, fa);
                        for ( i = 0; i < 6; i++ ) {
                            stowlit(fa[i], 1);
                        }
                    }
                } else {
                    stowlit(value, type->size);
                }
            }
        }
    }
    return type->size;
}


static void output_double_string_load(double value)
{
    int   dumplocation = getlabel();
    LVALUE lval;

    postlabel(dumplocation);
    defstorage(); outdec(6); nl();
    
    output_section(c_init_section);
    lval.const_val = value;
    load_double_into_fa(&lval);
    immedlit(dumplocation); outdec(0); nl();
    callrts("dstore");
    output_section(c_data_section);
}
