/*
 * Handle initialisation
 */

#include "ccdefs.h"

static void output_double_string_load(double value);
static int init(Type *type, int dump);
static int agg_init(Type *type, int isflexible);


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
		(type->ptr->isconst || ((ispointer(type->ptr) || type->ptr->kind == KIND_ARRAY) && type->ptr->ptr->isconst) ) ) ) {
        gen_switch_section(get_section_name(type->namespace,c_rodata_section));
    } else {
        gen_switch_section(get_section_name(type->namespace,c_data_section));
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
            desize = agg_init(type, 0);
        }
        needchar('}');
    } else {
        // Initialise a single one
        desize = init(type, 1);
    }

    gen_switch_section(c_code_section); 
    return (desize);
}

static int add_bitfield(Type *bitfield, int *value)
{
    Kind valtype;
    double cvalue;

    // Early return if we have a designated initialiser
    if ( rcmatch('.') ) return 0;

    if (constexpr(&cvalue, &valtype, 0)) {
        int ival = ((int)cvalue & (( 1 << bitfield->bit_size) - 1)) << bitfield->bit_offset;
        check_assign_range(bitfield, cvalue);
        *value |= ival;
    } else {
        errorfmt("Expected a constant value for bitfield assignment", 1);
    }
    return 1;
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
    int     last_offset = -1;
    int     num_fields = tag->isstruct ? array_len(tag->fields) : 1;
    int     bitfield_value = 0;
    int     had_bitfield = 0;

    for ( i = 0; i < num_fields; i++ ) {
        ptr = array_get_byindex(tag->fields,i);

        if ( rcmatch('}')) {
            break;
        }
        if ( i != 0 ) needchar(',');



        if ( ptr->offset == last_offset ) {
            had_bitfield += ptr->bit_size;
            if ( add_bitfield(ptr, &bitfield_value) ) {
                continue;
            }
        } else if ( had_bitfield ) {
            sz = ptr->offset;
            // We've finished a byte/word of bitfield, we should dump it
            outfmt("\t%s\t0x%x\n", had_bitfield <= 8 ? "defb" : "defw", bitfield_value);
            had_bitfield = 0;
            bitfield_value = 0;
        }

        if ( rcmatch('.') && isalpha(line[lptr+1]) ) {
            char declname[NAMESIZE];
            int     j, bfsize = ptr->size;
            Type   *ptr2 = NULL;


            // Start of an initialiser
            needchar('.');
            symname(declname);   

            for ( j = 0; j < num_fields; j++ ) {
                ptr2 = array_get_byindex(tag->fields, j);

                if ( strcmp(ptr2->name, declname) == 0 ) {
                    if ( j < i ) {
                        errorfmt("Only forward referenced designated specifiers are supported", 1);
                    } else {
                        int skip = ptr2->offset - ptr->offset;
                        // We've found a symbol
                        needchar('=');

                        // Storage space
                        if ( skip > 0 && had_bitfield == 0) {
                            defstorage(); outdec(skip); nl();
                            sz += skip;
                        }
                        i = j;
                        ptr = ptr2;
                        break;
                    }
                } else {
                    ptr2 = NULL;
                }
            }
            if ( ptr2 == NULL ) {
                errorfmt("Unknown structure member %s", 1, declname);
            }

            if ( ptr->bit_size == 0 ) {
                if ( had_bitfield ) {
                    sz += bfsize;
                    // We've finished a byte/word of bitfield, we should dump it
                    outfmt("\t%s\t0x%x\n", had_bitfield <= 8 ? "defb" : "defw", bitfield_value);
                    had_bitfield = 0;
                    bitfield_value = 0;
                }
            }
        }



        if ( ptr->bit_size ) {
            sz = ptr->offset;
            last_offset = ptr->offset;
            had_bitfield = ptr->bit_size;
            add_bitfield(ptr, &bitfield_value);
            continue;
        }


        last_offset = ptr->offset;

        sz += ptr->size == -1 ? 0 : ptr->size;
        if ( ptr->kind == KIND_STRUCT ) {
            needchar('{');
            str_init(ptr->tag);
            needchar('}');
        } else if ( ( ptr->kind == KIND_ARRAY && ptr->ptr->kind != KIND_CHAR ) ) {
            needchar('{');
            agg_init(ptr, ptr->size == -1 && i == num_fields - 1);
            needchar('}');
        } else if ( ptr->kind == KIND_ARRAY && ptr->ptr->kind == KIND_CHAR ) {
            if ( rcmatch('{')) {
                needchar('{');
                agg_init(ptr,0);
                needchar('}');
            } else {
                init(ptr,1);
            }
        } else {
            init(ptr,1);
        }
    }
    swallow(",");

    // And output 
    if ( had_bitfield ) {
        // We've finished a struct initialisation with a bitfield
        outfmt("\t%s\t0x%x\n", had_bitfield <= 8 ? "defb" : "defw", bitfield_value);
        sz += ((had_bitfield-1) / 8) + 1;
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
int agg_init(Type *type, int isflexible)
{
    int done = 0;
    int dim = type->len;
    int size = 0;

    while (dim) {
        if ( rcmatch('}')) {
            break;
        }
        if ( type->kind == KIND_ARRAY && type->ptr->kind == KIND_STRUCT ) {
            /* array of struct */
            if ( rcmatch('0') ) {
                needchar('0');
                if ( rcmatch('}') ) break;
            } else if  ( done == 0 ) {
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
                size += agg_init(type->ptr, isflexible);
                needchar('}');
            } else {
               char needbrace = 0;
               if ( cmatch('{') ) 
                   needbrace = 1;
               if ( rcmatch('"') )
                   size += init(type->ptr,1);
               else 
                   size += agg_init(type->ptr, isflexible);
               if ( needbrace ) needchar('}');
            }
            dim--;
        } else {
            char needbrace = 0;
            if ( cmatch('{') ) 
               needbrace = 1;
            if ( type->kind == KIND_ARRAY && type->ptr->kind == KIND_CHAR && rcmatch('"')) {
                size += init(type,1);
            } else {
                size += init(type->ptr,1);
            }
            if ( needbrace ) needchar('}');
            dim--;
        }
        done++;
        if (cmatch(',') == 0)
            break;
        blanks();
    }
    if ( type->len != -1 ) {
        size += dumpzero(1, type->size - size);
    } else if ( !isflexible ) {
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
    int sz = 0; /* number of chars in queue */

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
        /* djm, catch label names in structures (for (*name)() initialisation */
        char sname[NAMESIZE];
        SYMBOL *ptr;
        int   gotref;

        if ( rmatch2("sizeof") || rmatch2("__builtin_offsetof")) {
            if ( constexpr(&value, &valtype, 1) ) {
                goto constdecl;
            }
            errorfmt("Expecting a constant expression for static initialisation\n",1);
        } 
        
        // Kill any casts
        if (rcmatch('(') ) {
            Type  *ctype;
            int klptr = lptr;
            lptr++;
            if ( ch() && (ctype = parse_expr_type()) != NULL ) {
                needchar(')');
            } else {
                lptr = klptr;
            }
        }

        gotref = cmatch('&');

        // Might be a cast afterwards as well
        if (rcmatch('(') ) {
            Type  *ctype;
            int klptr = lptr;
            lptr++;
            if ( ch() && (ctype = parse_expr_type()) != NULL ) {
                needchar(')');
            } else {
                lptr = klptr;
            }
        }


        if (symname(sname) ) {
            if ((ptr = findglb(sname))) {
                Type *ptype = ptr->ctype;

                /* Actually found sommat..very good! */
                if ( ispointer(type)|| type->kind == KIND_ARRAY ) {
                    int offset = 0;
                    Type *as_struct_ptype = ptype;
                    /* this is &xx.yy.zz kind of deal */
                    while (as_struct_ptype->kind == KIND_STRUCT && rcmatch('.')) {
                        cmatch('.');
                        char subname[NAMESIZE];
                        Type *member = NULL;
                        if (symname(subname) && (member = find_tag_field(as_struct_ptype->tag, subname))) {
                            offset += member->offset;
                        } else {
                            errorfmt("Tag <%s> not found in struct", 1, subname);
                        }
                        as_struct_ptype = member;
                    }

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
                    } else if ( cmatch('+') ) {                      
                        if ( constexpr(&value, &valtype, 1) ) {
                            offset = value;
                        }
                    } else if ( cmatch('-') ) {                      
                        if ( constexpr(&value, &valtype, 1) ) {
                            offset = value * -1;
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
            check_assign_range(type, value);
            if (dump) {
                /* struct member or array of pointer to char */
                if ( type->kind == KIND_DOUBLE ) {
                    unsigned char  fa[MAX_MANTISSA_SIZE + 1] = { 0 };
                    int      i;
                    /* It was a float, lets parse the float and then dump it */
                    if ( c_double_strings ) { 
                        output_double_string_load(value);
                    } else {
                        dofloat(c_maths_mode,value, fa);
                        defbyte();
                        for ( i = 0; i < c_fp_size; i++ ) {
                            if ( i ) outbyte(',');
                            outdec(fa[i]);
                        }
                    }
                } else if (type->kind == KIND_FLOAT16) {
                    unsigned char  fa[MAX_MANTISSA_SIZE + 1] = { 0 };
                    dofloat(MATHS_IEEE16, value, fa);
                    defword();
                    outdec(fa[1] << 8 | fa[0]);
                } else if (type->kind == KIND_LONGLONG ){
                    uint32_t val = (uint32_t)((int64_t)value & 0xffffffff);
                    /* there appears to be a bug in z80asm regarding defq */
                    defbyte();
                    outdec(((uint32_t)val % 65536UL) % 256);
                    outbyte(',');
                    outdec(((uint32_t)val % 65536UL) / 256);
                    outbyte(',');
                    outdec(((uint32_t)val / 65536UL) % 256);
                    outbyte(',');
                    outdec(((uint32_t)val / 65536UL) / 256);
                    nl();
                    val = (uint32_t)(((int64_t)value >> 32) & 0xffffffff);
                    defbyte();
                    outdec(((uint32_t)val % 65536UL) % 256);
                    outbyte(',');
                    outdec(((uint32_t)val % 65536UL) / 256);
                    outbyte(',');
                    outdec(((uint32_t)val / 65536UL) % 256);
                    outbyte(',');
                    outdec(((uint32_t)val / 65536UL) / 256);
                } else if (type->kind == KIND_LONG ){
                    uint32_t val = (int32_t)(int64_t)value;
                    /* there appears to be a bug in z80asm regarding defq */
                    defbyte();
                    outdec(((uint32_t)val % 65536UL) % 256);
                    outbyte(',');
                    outdec(((uint32_t)val % 65536UL) / 256);
                    outbyte(',');
                    outdec(((uint32_t)val / 65536UL) % 256);
                    outbyte(',');
                    outdec(((uint32_t)val / 65536UL) / 256);
                } else if (type->kind == KIND_CPTR) {
                    uint32_t val = (int32_t)(int64_t)value;
                    defbyte();
                    outdec(((uint32_t)val % 65536UL) % 256);
                    outbyte(',');
                    outdec(((uint32_t)val % 65536UL) / 256);
                    outbyte(',');
                    outdec(((uint32_t)val / 65536UL) % 256);
                } else if ( type->kind == KIND_ACCUM16 ) {
                    uint16_t val = ((int16_t)((value) / (1.0 / 256.0) + ((value) >= 0 ? 0.5 : -0.5)));
                    defword();
                    outdec(val);
                } else if ( type->kind == KIND_ACCUM32) {
                    uint32_t val = ((int32_t)((value) / (1.0 / 65536.0) + ((value) >= 0 ? 0.5 : -0.5)));
                    defbyte();
                    outdec(((uint32_t)val % 65536UL) % 256);
                    outbyte(',');
                    outdec(((uint32_t)val % 65536UL) / 256);
                    outbyte(',');
                    outdec(((uint32_t)val / 65536UL) % 256);
                    outbyte(',');
                    outdec(((uint32_t)val / 65536UL) / 256);
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

                    /* It was a float, lets parse the float and then dump it */
                      if ( c_double_strings ) {
                        output_double_string_load(value);
                    } else {
                        dofloat(c_maths_mode,value, fa);
                        for ( i = 0; i < c_fp_size; i++ ) {
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

    lval.val_type = KIND_DOUBLE;

    postlabel(dumplocation);
    defstorage(); outdec(6); nl();
    
    gen_switch_section(c_init_section);
    lval.const_val = value;
    lval.val_type = KIND_DOUBLE;
    lval.ltype = type_double;
    load_constant(&lval);
    immedlit(dumplocation,0); nl();
    callrts("dstore");
    gen_switch_section(c_data_section);
}
