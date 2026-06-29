/*
 * Handle initialisation
 */

#include "ccdefs.h"

static void output_double_string_load(double value);
static int init(Type *type, int dump, Node **out_node);
static int agg_init(Type *type, int isflexible, array **out_list);


/*
 * initialise global object
 *
 * If `out_init` is non-NULL, also build an AST representation of the
 * initializer alongside the data-section emit and return it via *out_init:
 *   - scalar init        → AST_LITERAL (or whatever init() built)
 *   - aggregate / struct → AST_INIT_LIST whose `stmts` are the elements
 *   - string init        → AST_INIT_LIST of char literals (current set)
 * If `out_init` is NULL, no AST is built (matches legacy behaviour for
 * callers that don't yet need it, e.g. file-scope globals).
 */
int initials(const char *dropname, Type *type, Node **out_init)
{
    int desize = 0;
    Node *node_local = NULL;
    Node **want = out_init ? &node_local : NULL;
    gltptr = 0;
    glblab = getlabel();

    if ( type->isconst ||
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
        array *items = NULL;
        array **iout = want ? &items : NULL;
        if ( type->kind == KIND_STRUCT || ( type->kind == KIND_PTR && type->ptr->kind == KIND_STRUCT)) {
            if ( type->kind == KIND_PTR ) {
                point();
            }
            desize = str_init(type->kind == KIND_STRUCT ? type->tag : type->ptr, iout);
        } else {
            // Aggregate initialiser
            desize = agg_init(type, 0, iout);
        }
        needchar('}');
        if (want) {
            node_local = ast_init_list(items);
        }
    } else {
        // Initialise a single one
        desize = init(type, 1, want);
    }
    gen_switch_section(currfn && currfn->flags & NONBANKED ? c_home_section : c_code_section);
    if (out_init) *out_init = node_local;
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
 * Pads out to the size of the structure.
 * If `out_list` is non-NULL, *out_list (allocated as needed) is populated
 * with one AST node per field in source order. Bit-field-packed fields
 * collapse to a single AST_LITERAL of the assembled word value.
 */
int str_init(Type *tag, array **out_list)
{
    int sz = 0;
    Type   *ptr;
    int     i;
    int     last_offset = -1;
    int     num_fields = tag->isstruct ? array_len(tag->fields) : 1;
    int     bitfield_value = 0;
    int     had_bitfield = 0;
    int     bitfield_first_idx = -1;

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
            if (had_bitfield == 0) bitfield_first_idx = i;
            had_bitfield = ptr->bit_size;
            add_bitfield(ptr, &bitfield_value);
            continue;
        }


        last_offset = ptr->offset;

        sz += ptr->size == -1 ? 0 : ptr->size;
        if ( ptr->kind == KIND_STRUCT ) {
            array *sub = NULL;
            array **subout = out_list ? &sub : NULL;
            needchar('{');
            str_init(ptr->tag, subout);
            needchar('}');
            if (out_list) {
                if (*out_list == NULL) *out_list = array_init(NULL);
                array_add(*out_list, ast_init_list(sub));
            }
        } else if ( ( ptr->kind == KIND_ARRAY && ptr->ptr->kind != KIND_CHAR ) ) {
            array *sub = NULL;
            array **subout = out_list ? &sub : NULL;
            needchar('{');
            agg_init(ptr, ptr->size == -1 && i == num_fields - 1, subout);
            needchar('}');
            if (out_list) {
                if (*out_list == NULL) *out_list = array_init(NULL);
                array_add(*out_list, ast_init_list(sub));
            }
        } else if ( ptr->kind == KIND_ARRAY && ptr->ptr->kind == KIND_CHAR ) {
            if ( rcmatch('{')) {
                array *sub = NULL;
                array **subout = out_list ? &sub : NULL;
                needchar('{');
                agg_init(ptr,0, subout);
                needchar('}');
                if (out_list) {
                    if (*out_list == NULL) *out_list = array_init(NULL);
                    array_add(*out_list, ast_init_list(sub));
                }
            } else {
                Node *elem = NULL;
                init(ptr,1, out_list ? &elem : NULL);
                if (out_list) {
                    if (*out_list == NULL) *out_list = array_init(NULL);
                    array_add(*out_list, elem);
                }
            }
        } else {
            Node *elem = NULL;
            init(ptr,1, out_list ? &elem : NULL);
            if (out_list) {
                if (*out_list == NULL) *out_list = array_init(NULL);
                array_add(*out_list, elem);
            }
        }
    }
    cmatch(',');   /* L3c-11: swallow now takes a KW_ id; commas use cmatch */

    // And output
    if ( had_bitfield ) {
        // We've finished a struct initialisation with a bitfield
        outfmt("\t%s\t0x%x\n", had_bitfield <= 8 ? "defb" : "defw", bitfield_value);
        sz += ((had_bitfield-1) / 8) + 1;
        /* AST: collapse the bit-packed run to a single literal of the
           assembled value. The Type used is rough — int is fine for
           narrow packs, the consumer will see a `(?bf 0xVAL)` shape. */
        if (out_list) {
            if (*out_list == NULL) *out_list = array_init(NULL);
            array_add(*out_list, ast_literal(type_int, (zdouble)bitfield_value));
        }
        (void)bitfield_first_idx;
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
 *
 * If `out_list` is non-NULL, *out_list (allocated as needed) is populated
 * with one AST node per element in source order. Nested aggregates / inner
 * structs become AST_INIT_LIST nodes.
 */
int agg_init(Type *type, int isflexible, array **out_list)
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
                /* AST: a `0` placeholder for an unused struct slot —
                   represent as an empty init-list. */
                if (out_list) {
                    if (*out_list == NULL) *out_list = array_init(NULL);
                    array_add(*out_list, ast_init_list(NULL));
                }
            } else if  ( done == 0 ) {
                needchar('{');
            } else if ( cmatch('{') == 0 ) {
                break;
            }
            {
                array *sub = NULL;
                array **subout = out_list ? &sub : NULL;
                size += str_init(type->ptr->tag, subout);
                if (out_list) {
                    if (*out_list == NULL) *out_list = array_init(NULL);
                    array_add(*out_list, ast_init_list(sub));
                }
            }
            dim--;
            needchar('}');
        } else if ( type->ptr && type->ptr->kind == KIND_ARRAY) {
            if ( type->ptr->ptr->kind != KIND_CHAR ) {
                array *sub = NULL;
                array **subout = out_list ? &sub : NULL;
                needchar('{');
                size += agg_init(type->ptr, isflexible, subout);
                needchar('}');
                if (out_list) {
                    if (*out_list == NULL) *out_list = array_init(NULL);
                    array_add(*out_list, ast_init_list(sub));
                }
            } else {
               char needbrace = 0;
               if ( cmatch('{') )
                   needbrace = 1;
               if ( rcmatch('"') ) {
                   Node *elem = NULL;
                   size += init(type->ptr,1, out_list ? &elem : NULL);
                   if (out_list) {
                       if (*out_list == NULL) *out_list = array_init(NULL);
                       array_add(*out_list, elem);
                   }
               } else {
                   array *sub = NULL;
                   array **subout = out_list ? &sub : NULL;
                   size += agg_init(type->ptr, isflexible, subout);
                   if (out_list) {
                       if (*out_list == NULL) *out_list = array_init(NULL);
                       array_add(*out_list, ast_init_list(sub));
                   }
               }
               if ( needbrace ) needchar('}');
            }
            dim--;
        } else {
            char needbrace = 0;
            if ( cmatch('{') )
               needbrace = 1;
            {
                Node *elem = NULL;
                if ( type->kind == KIND_ARRAY && type->ptr->kind == KIND_CHAR && rcmatch('"')) {
                    size += init(type,1, out_list ? &elem : NULL);
                } else {
                    size += init(type->ptr,1, out_list ? &elem : NULL);
                }
                if (out_list) {
                    if (*out_list == NULL) *out_list = array_init(NULL);
                    array_add(*out_list, elem);
                }
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
static int init(Type *type, int dump, Node **out_node)
{
    double value;
    zdouble zvalue = 0; /* full-precision mirror of `value` for the constdecl
                           path — a long long literal > 2^53 loses its low
                           bits as a plain double (see constexpr_z). */
    Kind   valtype;
    int sz = 0; /* number of chars in queue */
    int klptr, parencount;
    if (out_node) *out_node = NULL;

    if ((sz = qstr(&value)) != -1) {
        sz++;
        if ( type->kind == KIND_ARRAY ) {
            /* Dump the literals where they are, padding out as appropriate */
            int orig_sz = sz;
            unsigned char *str_bytes = NULL;
            if (type->len != -1 &&  sz > type->len) {
                /* Ooops, initialised to long a string! */
                warningfmt("overlong-initialization","Initialisation too long, truncating!");
                sz = type->len;
                gltptr = sz;
                *(glbq + sz - 1) = '\0'; /* Terminate string */
            }
            /* Capture string-init bytes for AST before dumplits clears glbq. */
            if (out_node) {
                str_bytes = malloc(sz);
                memcpy(str_bytes, glbq, sz);
            }
            dumplits(type->ptr->kind == KIND_CHAR ? 0 : type->ptr->size, NO, gltptr, glblab, glbq);
            gltptr = 0;
            if (out_node) {
                /* AST: list of char/element literals. For zero-padding
                   beyond the source, we only emit the source chars (the
                   data section has been padded already; the AST records
                   the source-form values). */
                array *chars = array_init(NULL);
                for (int k = 0; k < sz; k++) {
                    array_add(chars, ast_literal(type_int, (zdouble)(int)(str_bytes[k] & 0xff)));
                }
                free(str_bytes);
                *out_node = ast_init_list(chars);
            }
            (void)orig_sz;
            if ( type->len != -1 ) {
                dumpzero(type->size/ type->len, type->len - sz);
                return type->size;
            }
            type->size = sz;
            type->len = sz;
            return sz;
        } else if ( type->kind != KIND_PTR) {
            UT_string  *str;
            utstring_new(str);
            utstring_printf(str,"Can't assign char * to type: ");
            type_describe(type, str);
            errorfmt("%s", 1, utstring_body(str));
            utstring_free(str);
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
            /* AST: a string-pool reference. IR_LD_STR re-emits
               `i_<litlab>+offset` (matching the static defw above);
               ivalue is the pool offset set by storeq. The old code folded
               litlab+ivalue into a plain int, losing the label → it lowered
               to a bogus immediate (e.g. char* field got 17, not &"Hello"). */
            if (out_node) {
                *out_node = ast_str_lit(ivalue);
            }
            return 2;
        }
    } else {
        /* djm, catch label names in structures (for (*name)() initialisation */
        char sname[NAMESIZE];
        SYMBOL *ptr;
        int   gotref;

        if ( rmatch2("sizeof") || rmatch2("__builtin_offsetof")) {
            if ( constexpr(&value, &valtype, 1) ) {
                zvalue = value;   /* small; keep zvalue in sync for constdecl */
                goto constdecl;
            }
            errorfmt("Expecting a constant expression for static initialisation\n",1);
        }
        
        // Kill any casts
        if (rcmatch('(') ) {
            Type  *ctype;
            int klptr = lptr;
            lptr++;
            /* Phase L3c-8i: legacy ch() returned the next char (or
               0 for end-of-line / nothing left). The tokeniser
               equivalent is "not at EOF" — TK_EOF covers both
               file-end and the empty-line case. */
            if ( tk_peek_kind_at_lptr() != TK_EOF && (ctype = parse_expr_type()) != NULL ) {
                needchar(')');
            } else {
                lptr = klptr;
            }
        }

        gotref = cmatch('&');

        // Might be a cast afterwards as well
        parencount = 0;
        klptr = lptr;
again:
        if (rcmatch('(') ) {
            Type  *ctype;
            lptr++;
            /* Phase L3c-8i: legacy ch() returned the next char (or
               0 for end-of-line / nothing left). The tokeniser
               equivalent is "not at EOF" — TK_EOF covers both
               file-end and the empty-line case. */
            if ( tk_peek_kind_at_lptr() != TK_EOF && (ctype = parse_expr_type()) != NULL ) {
                needchar(')');
            } else {
                parencount++;
                goto again;
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
                            /* `&sym + N` — N is in elements, scale to
                               bytes by the pointee size. Previously
                               emitted `_sym + N` (raw byte offset)
                               regardless of element width, so e.g.
                               `int *p = arr + 3` emitted `_arr + 3`
                               instead of `_arr + 6`. The `[N]` branch
                               above already scales; this branch matches
                               that behaviour. */
                            int elem = 1;
                            if (ptype->kind == KIND_ARRAY && ptype->len > 0)
                                elem = ptype->size / ptype->len;
                            else if (ispointer(ptype) && ptype->ptr)
                                elem = ptype->ptr->size;
                            offset = (int)value * elem;
                        }
                    } else if ( cmatch('-') ) {
                        if ( constexpr(&value, &valtype, 1) ) {
                            int elem = 1;
                            if (ptype->kind == KIND_ARRAY && ptype->len > 0)
                                elem = ptype->size / ptype->len;
                            else if (ispointer(ptype) && ptype->ptr)
                                elem = ptype->ptr->size;
                            offset = (int)value * elem * -1;
                        }
                    }
                    defword();
                    outname(ptr->name, dopref(ptr));
                    outfmt(" + %d",offset);
                    nl();
                    if ( type->isfar ) {
                        defbyte(); outdec(0); nl();
                    }
                    /* AST: address-of-symbol initializer. Build
                       (addr <gv=ptr>) and add offset if non-zero. The
                       walker can re-emit `defw _name + offset`. */
                    if (out_node) {
                        Node *addr = ast_uop(OP_ADDR, ast_global_var(ptr, ptr->name));
                        if (offset != 0) {
                            *out_node = ast_binop(OP_ADD, addr,
                                                  ast_literal(type_int, (zdouble)offset));
                        } else {
                            *out_node = addr;
                        }
                    }
                } else if (ptr->type == KIND_ENUM) {
                    lptr = klptr;
                    constexpr(&value, &valtype, 1);
                    zvalue = value;   /* small; keep zvalue in sync for constdecl */
                    goto constdecl;
                } else {
                    errorfmt("Dodgy declaration (not pointer)", 0);
                    junk();
                }
                while ( parencount--) 
                    needchar(')');
            } else {
                errorfmt("Unknown symbol: %s", 1, sname);
                junk();
            }
        } else if (rcmatch('}')) {        
#if 0
            dumpzero(size,*dim);
#endif
            lptr = klptr;
            return 0;
        } else if ( lptr= klptr, constexpr_z(&zvalue, &valtype, 1)) {
            value = (double)zvalue;
constdecl:
            check_assign_range(type, value);
            /* AST: capture the constant init as a single AST_LITERAL of
               the declared type. zvalue (zdouble / long double) carries a
               64-bit long long literal unclipped on x86; `value` (double)
               would drop its low bits. (long double == double on macOS.) */
            if (out_node) {
                *out_node = ast_literal(type, zvalue);
            }
            if (dump) {
                /* struct member or array of pointer to char */
                if ( type->kind == KIND_DOUBLE ) {
                    unsigned char  fa[MAX_MANTISSA_SIZE + 1] = { 0 };
                    int      i;
                    /* parse the float constant and dump its bytes */
                    dofloat(c_maths_mode,value, fa);
                    defbyte();
                    for ( i = 0; i < c_fp_size; i++ ) {
                        if ( i ) outbyte(',');
                        outdec(fa[i]);
                    }
                } else if (type->kind == KIND_FLOAT16) {
                    unsigned char  fa[MAX_MANTISSA_SIZE + 1] = { 0 };
                    dofloat(MATHS_IEEE16, value, fa);
                    defword();
                    outdec(fa[1] << 8 | fa[0]);
                } else if (type->kind == KIND_LONGLONG ){
                    uint32_t val = (uint32_t)((int64_t)zvalue & 0xffffffff);
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
                    val = (uint32_t)(((int64_t)zvalue >> 32) & 0xffffffff);
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

                    /* parse the float constant and dump its bytes */
                    dofloat(c_maths_mode,value, fa);
                    for ( i = 0; i < c_fp_size; i++ ) {
                        stowlit(fa[i], 1);
                    }
                } else {
                    stowlit(value, type->size);
                }
            }
        } else {
            lptr = klptr;
            return 0; // Nothing parsed
        }
    } 
    return type->size;
}


