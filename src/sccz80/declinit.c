/*
 * Handle initialisation
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
    if ( (type->isconst && !c_double_strings) ||
        ( (ispointer(type) || type->kind == KIND_ARRAY) && 
		(type->ptr->isconst || (ispointer(type->ptr) && type->ptr->ptr->isconst) ) ) ) {
        output_section(c_rodata_section);
    } else {
        output_section(c_data_section);
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
    int     num_fields = tag->isstruct ? array_len(tag->fields) : 1;

    for ( i = 0; i < num_fields; i++ ) {
        if ( rcmatch('}')) {
            break;
        }
        if ( i != 0 ) needchar(',');
        ptr = array_get_byindex(tag->fields,i);
        sz += ptr->size;
        if ( ptr->kind == KIND_STRUCT ) {
            needchar('{');
            str_init(ptr->tag);
            needchar('}');
        } else if ( ( ptr->kind == KIND_ARRAY && ptr->ptr->kind != KIND_CHAR ) ) {
            needchar('{');
            agg_init(ptr);
            needchar('}');
        } else if ( ptr->kind == KIND_ARRAY && ptr->ptr->kind == KIND_CHAR ) {
            if ( rcmatch('{')) {
                needchar('{');
                agg_init(ptr);
                needchar('}');
            } else {
                init(ptr,1);
            }
        } else {
            init(ptr,1);
        }
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
        } else if ( type->ptr && type->ptr->kind == KIND_ARRAY) {
            if ( type->ptr->ptr->kind != KIND_CHAR ) {
                needchar('{');
                size += agg_init(type->ptr);
                needchar('}');
            } else {
               char needbrace = 0;
               if ( cmatch('{') ) 
                   needbrace = 1;
               if ( rcmatch('"') )
                   size += init(type->ptr,1);
               else 
                   size += agg_init(type->ptr);
               if ( needbrace ) needchar('}');
            }
        } else {
            char needbrace = 0;
            if ( cmatch('{') ) 
               needbrace = 1;
            size += init(type->ptr,1);
            if ( needbrace ) needchar('}');
        }
        done++;
        if (cmatch(',') == 0)
            break;
        blanks();
    }
    if ( type->len != -1 ) {
        size += dumpzero(1, type->size - size);
    } else {
        type->size = size;
        type->len = size / type->ptr->size;
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
                warningfmt("overlong-initialization","Initialisation too long, truncating!");
                sz = type->len;
                gltptr = sz;
                *(glbq + sz - 1) = '\0'; /* Terminate string */
            }
            dumplits(type->ptr->kind == KIND_CHAR ? 0 : type->ptr->size, NO, gltptr, glblab, glbq);
            gltptr = 0;
            if ( type->len != -1 ) {
                dumpzero(type->size/ type->len, type->len - sz);
                return type->size;
            }
            type->size = sz;
            type->len = sz;
            return sz;
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
        // TODO....
        /* djm, catch label names in structures (for (*name)() initialisation */
        char sname[NAMESIZE];
        SYMBOL *ptr;
        int gotref = cmatch('&');
        if (symname(sname) && strcmp(sname, "sizeof") != 0) { /* We have got something.. */
            if ((ptr = findglb(sname))) {
                Type *ptype = ptr->ctype;

                /* Actually found sommat..very good! */
                if ( ispointer(type)|| type->kind == KIND_ARRAY ) {
                    int offset = 0;

                    if ( rcmatch('[')) {
                        if ( gotref == 0 ) {
                            errorfmt("Initialiser element is not a compile-time constant",1);
                        }
                        while ( rcmatch('[')) {
                            if ( ispointer(ptype) || ptype->kind == KIND_ARRAY) {
                                double val;
                                Kind valtype;
                                needchar('[');
                                constexpr(&val, &valtype,  1);
                                needchar(']');
                                offset += ( ptype->size / ptype->len) * val;
                                ptype = ptype->ptr;
                            } else {
                                errorfmt("Cannot subscript a non-pointer", 1);
                                break;                                
                            }
                        }
                    }
                    defword();
                    outname(ptr->name, dopref(ptr));
                    outfmt(" + %d",offset);
                    nl();
                    if ( type->isfar ) {
                        defbyte(); outdec(0); nl();
                    }
                } else if (ptr->type == KIND_ENUM) {
                    value = ptr->size;
                    goto constdecl;
                } else {
                    errorfmt("Dodgy declaration (not pointer)", 0);
                    junk();
                }
            } else {
                errorfmt("Unknown symbol: %s", 1, sname);
                junk();
            }
        } else if (rcmatch('}')) {        
#if 0
            dumpzero(size,*dim);
#endif
            return 0;
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
        } else {
            return 0; // Nothing parsed
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
    immedlit(dumplocation,0); nl();
    callrts("dstore");
    output_section(c_data_section);
}
