/*
 *      Small C+ Compiler
 *      Split into parts 3/3/99 djm
 *
 *      This part deals with the evaluation of a constant
 */

#include "ccdefs.h"

#include <math.h>
#include "utlist.h"

static Type *get_member(Type *tag);


typedef struct elem_s {
    struct elem_s *next;
    Kind           kind;
    int            written;
    int            litlab;
    zdouble        value;
    unsigned char  fa[MAX_MANTISSA_SIZE + 1];      /* The parsed representation */
    char           str[60];    /* A raw string version */
} elem_t;

struct fp_decomposed {
    uint8_t   exponent;
    uint8_t   sign;
    uint8_t   mantissa[MAX_MANTISSA_SIZE + 1];
};

static elem_t    *bigconst_queue = NULL;


static int  hex(char c);
static int  pstr(LVALUE *lval);
static int  tstr(int32_t *val);
static int  fnumber(LVALUE *val);
static int  number(LVALUE *lval);

static void dofloat_ieee(double raw, unsigned char fa[]);
static void dofloat_ieee16(double raw, unsigned char fa[]);
static void dofloat_z80(double raw, unsigned char fa[]);
static void dofloat_mbfs(double raw, unsigned char fa[]);
static void dofloat_mbf40(double raw, unsigned char fa[]);
static void dofloat_mbf64(double raw, unsigned char fa[]);
static void dofloat_am9511(double raw, unsigned char fa[]);
static void decompose_float(double raw, struct fp_decomposed *fs);


/* Modified slightly to sort have two pools - one for strings and one
 * for doubles..
 */

int constant(LVALUE* lval)
{
    int32_t val;
    lval->val_type = KIND_INT;
    lval->ltype = type_int;
    lval->is_const = 1; /* assume constant will be found */
    if (fnumber(lval)) {
        load_constant(lval);
        lval->flags = FLAGS_NONE;
        return (1);
    } else if (number(lval) || pstr(lval)) {
        if (lval->val_type == KIND_LONG)
            vlongconst(lval->const_val);
        else
            vconst(lval->const_val);
        return (1);
    } else if (tstr(&val)) {
        lval->const_val = val;
        lval->is_const = 0; /* string address not constant */
        lval->ltype = make_pointer(c_default_unsigned ? type_uchar : type_char);
        lval->ptr_type = KIND_CHAR; 
        lval->val_type = KIND_INT;
        lval->flags = FLAGS_NONE;
        immedlit(litlab,lval->const_val);
        nl();
        return (1);
    } 
    lval->is_const = 0;
    return (0);
}

int fnumber(LVALUE *lval)
{
    int i,k; /* flag and mask */
    char minus; /* is if negative! */
    char* start; /* copy of pointer to starting point */
    char* s; /* points into source code */
    char* end;
    double dval;
    start = s = line + lptr; /* save starting point */
    k = 1;
    minus = 1;
    while (k) {
        k = 0;
        if (*s == '+') {
            ++s;
            k = 1;
        }
        if (*s == '-') {
            ++s;
            k = 1;
            minus = (-minus);
        }
    }

    while (*s == ' ') /* Ignore white space after sign */
        s++;

    while (numeric(*s))
        ++s;

    if (*s != '.' && (*s != 'e' && *s != 'f')) { /* Check that it is floating point */
        s++;
        return 0;
    }
    s++;
    if ( *s == '+' || *s == '-')
        ++s;
    while (numeric(*s))
        ++s;

    lptr = (s--) - line; /* save ending point */
    dval = strtod(start, &end);
    if (end == start)
        return 0;


    lptr = end - line;

    lval->val_type = KIND_DOUBLE;
    lval->ltype = type_double;

    if ( line[lptr] == 'f' ) {
        lptr++;
        if ( line[lptr] == '1' && line[lptr+1] == '6') {
            lptr+=2;
            lval->val_type = KIND_FLOAT16;
            lval->ltype = type_float16;
        }
    }
    for ( i = 0; i < buffer_fps_num; i++ ) 
        fprintf(buffer_fps[i], "%.*s", (int)(line+lptr-start), start);

    lval->const_val = dval;

    return (1); /* report success */
}


int number(LVALUE *lval)
{
    char c;
    int minus;
    int64_t k;
    int isunsigned = 0;

    k = minus = 1;
    while (k) {
        k = 0;
        if (cmatch('+'))
            k = 1;
        if (cmatch('-')) {
            minus = (-minus);
            k = 1;
        }
    }
    if (ch() == '0' && toupper(nch()) == 'X') {
        gch();
        gch();
        if (hex(ch()) == 0)
            return (0);
        while (hex(ch())) {
            c = inbyte();
            if (c <= '9')
                k = (k << 4) + (c - '0');
            else
                k = (k << 4) + ((c & 95) - '7');
        }
        lval->const_val = k;
        goto typecheck;
    }
    if (ch() == '0' && toupper(nch()) == 'B') {
        int c;
        gch();
        gch();
        if (ch() != '0' && ch() != '1')
            return (0);
        while (ch() == '0' || ch() == '1') {
            c = inbyte();
            k = (k << 1) + (c - '0');
        }
        lval->const_val = k;
        goto typecheck;
    }
    if (ch() == '0') {
        gch();
        while (numeric(ch())) {
            c = inbyte();
            if (c < '8')
                k = k * 8 + (c - '0');
        }
        lval->const_val = k;
        goto typecheck;
    }
    if (numeric(ch()) == 0)
        return (0);
    while (numeric(ch())) {
        c = inbyte();
        k = k * 10 + (c - '0');
    }
    if (minus < 0)
        k = (-k);
    lval->const_val = k;
typecheck:
    lval->val_type = KIND_CHAR;
    if ( lval->const_val >= 256 || lval->const_val < -127 ) {
        lval->val_type = KIND_INT;
    }
    if ( lval->const_val >= 65536 || lval->const_val < -32767 ) {
        lval->val_type = KIND_LONG;
    }
    if ( lval->const_val > UINT32_MAX || lval->const_val < INT32_MIN ) {
        lval->val_type = KIND_LONGLONG;
        if ( sizeof(long double) == sizeof(double)) {
            warningfmt("limited-range", "On this host, 64 bit constants may not be correct\n");
        }
    }
    lval->is_const = 1;

    while (checkws() == 0 && (rcmatch('L') || rcmatch('U') || rcmatch('S') || rcmatch('f'))) {
        if (cmatch('L')) {
            lval->val_type = KIND_LONG;
            if (cmatch('L'))
                lval->val_type = KIND_LONGLONG;
        }
        if (cmatch('U')) {
            isunsigned = 1;
            lval->const_val = (uint64_t)k;
        }
        if (cmatch('S'))
            isunsigned = 0;
        if (amatch("f16")) {
            lval->val_type = KIND_FLOAT16;
            lval->ltype = type_float16;
        }
        if (cmatch('f')) {
            lval->val_type = KIND_DOUBLE;
            lval->ltype = type_double;
        }
    }
    if ( lval->val_type == KIND_LONGLONG ) {
        if ( isunsigned )
            lval->ltype = type_ulonglong;
        else
            lval->ltype = type_longlong;
    } else if ( lval->val_type == KIND_LONG ) {
        if ( isunsigned )
            lval->ltype = type_ulong;
        else
            lval->ltype = type_long;
    } else {
        if ( isunsigned ) 
            lval->ltype = type_uint;
        else
            lval->ltype = type_int;
    }
    return (1);
}

int hex(char c)
{
    char c1;

    c1 = toupper(c);
    return ((c1 >= '0' && c1 <= '9') || (c1 >= 'A' && c1 <= 'F'));
}

/* djm, seems to load up literal address? */

void address(SYMBOL* ptr)
{
    immed();
    outname(ptr->name, dopref(ptr));
    nl();
    if ( ptr->ctype->kind == KIND_CPTR ) {
        const2(0);
    }
}

int pstr(LVALUE *lval)
{
    int k;

    lval->val_type = KIND_INT;
    if ( c_default_unsigned ) {
        lval->ltype = type_uint;
    } else {
        lval->ltype = type_int;
    }
    if (cmatch('\'')) {
        k = 0;
        while (ch() && ch() != '\'')
            k = (k & 255) * 256 + litchar();
        gch();
        lval->const_val = k;
        return (1);
    }
    return (0);
}

/* Scan in literals within function into temporary buffer and then
 * check to see if present elsewhere, if so do the merge as for doubles
 */

int tstr(int32_t* val)
{
    int k = 0;

    if (cmatch('"') == 0)
        return (0);
    do {
        while (ch() != '"') {
            if (ch() == 0)
                break;
            tempq[k] = litchar();
            k++; /* counter */
        }
        gch();
    } while (cmatch('"'));
    tempq[k] = 0;
    k++;
    return (storeq(k, tempq, val));
}

/*
 * Messed around with 5/5/99 djm to allow queues to start from 1
 * internally, but to the asm file show it to start from 0
 */

int storeq(int length, unsigned char* queue, int32_t* val)
{
    int j, k, len;
    /* Have stashed it in our temporary queue, we know the length, so lets
    * get checking to see if one exactly the same has already been placed
    * in there...
    */
    k = length;
    len = litptr - k; /* Amount of leeway to search through.. */
    j = 1; /* Literal queue starts from 1 not 0 now
                         * this allows scan for miniprintf to work
                         * correctly
                         */
    while (len >= j) {
        if (strncmp((char*)queue, (char*)litq + j, k) == 0) {
            *val = j - 1;
            return (1);
        } /*success!*/
        j++;
    }
    /* If we get here, then dump it in the queue as per normal... */
    *val = (int32_t)litptr - 1;
    for (j = 0; j < k; j++) {
        /* Have to dump it in our special queue here for function literals */
        if ((litptr + 1) >= FNMAX) {
            errorfmt("Literal Queue Overflow", 1);
        }
        *(litq + litptr) = *(queue + j);
        litptr++;
    }
    return (k);
}

int qstr(double *val)
{
    int cnt = 0;

    if (cmatch('"') == 0)
        return (-1);

    *val = gltptr;
    do {
        while (ch() != '"') {
            if (ch() == 0)
                break;
            cnt++;
            stowlit(litchar(), 1);
        }
        gch();
    } while (cmatch('"') || (cmatch('\\') && cmatch('"')));

    glbq[gltptr++] = 0;
    return (cnt);
}

/* store integer i of size size bytes in global var literal queue */
void stowlit(int value, int size)
{
    if ((gltptr + size) >= LITMAX) {
        errorfmt("Literal Queue Overflow", 1);
    }
    putint(value, glbq + gltptr, size);
    gltptr += size;
}

/* Return current literal char & bump lptr */
unsigned char litchar()
{
    int i, oct;

    if (ch() != '\\')
        return (gch());
    if (nch() == 0)
        return (gch());
    gch();
    switch (ch()) {
    case 'a': /* Bell */
        gch();
        return 7;
    case 'b': /* BS */
        gch();
        return 8;
    case 't': /* HT */
        gch();
        return 9;
    case 'r': /* LF */
        gch();
        return c_standard_escapecodes ? 13 : 10;
    case 'v': /* VT */
        gch();
        return 11;
    case 'f': /* FF */
        gch();
        return 12;
    case 'n': /* CR */
        gch();
        return c_standard_escapecodes ? 10 : 13;
    case '\"': /* " */
        gch();
        return 34;
    case '\'': /* ' */
        gch();
        return 39;
    case '\\': /* / */
        gch();
        return '\\';
    case '\?': /* ? */
        gch();
        return '\?';
    case 'l': /* LF (non standard)*/
        gch();
        return 10;
    case 'e':
        gch();
        return 27;
    }

    if (ch() != 'x' && (ch() < '0' || ch() > '7')) {
        warningfmt("parser","Unknown escape sequence \\%c", ch());
        return (gch());
    }
    if (ch() == 'x') {
        gch();
        oct = 0;
        i = 2;
        while (i-- > 0 && hex(ch())) {
            if (ch() <= '9')
                oct = (oct << 4) + (gch() - '0');
            else
                oct = (oct << 4) + ((gch() & 95) - '7');
        }
        if (isxdigit(ch())) {
            warningfmt("parser","Hex escape sequence out of range");
        }
        return ((char)oct);
    }

    i = 3;
    oct = 0;
    while (i-- > 0 && ch() >= '0' && ch() <= '7')
        oct = (oct << 3) + gch() - '0';
    if (i == 2)
        return (gch());
    else {
        return ((char)oct);
    }
}

/* Perform an offsetof(structure, member) */
void offset_of(LVALUE *lval)
{
    char   struct_name[NAMESIZE];
    char   memb_name[NAMESIZE];
    char   foundit = 0;

    memb_name[0] = struct_name[0] = 0;
    needchar('(');
    if ( symname(struct_name) ) {
        needchar(',');
        if ( symname(memb_name) ) {
            Type* tag = find_tag(struct_name);

            /* Consider typedefs */
            if ( tag == NULL ) {
                SYMBOL *ptr;
                
                if (((ptr = findloc(struct_name)) != NULL) || ((ptr = findstc(struct_name)) != NULL) || ((ptr = findglb(struct_name)) != NULL)) {
                    if ( ispointer(ptr->ctype) && ptr->ctype->ptr->kind == KIND_STRUCT ) {
                        tag = ptr->ctype->ptr->tag;
                    } else if ( ptr->ctype->kind == KIND_STRUCT ) {
                        tag = ptr->ctype->tag;
                    } else {
                        printf("%d\n",ptr->type);
                    }
                }
            }
            if ( tag != NULL ) {
                Type *member = find_tag_field(tag, memb_name);

                if ( member != NULL ) {
                    foundit = 1;
                    lval->const_val = member->offset;
                }
            }
        }
    }
    needchar(')');
    if ( foundit ) {
        lval->is_const = 1;
        lval->ltype = type_int;
        lval->val_type = KIND_INT;
        vconst(lval->const_val);
    } else {
        errorfmt("Cannot evaluate __builtin_offsetof(%s,%s)", 1, strlen(struct_name) ? struct_name : "<unknown>", strlen(memb_name) ? memb_name : "<unknown>");
    }


}

/* Perform a sizeof (works on variables as well */
void size_of(LVALUE* lval)
{
    char sname[NAMESIZE];
    int length;
    Type *type;
    SYMBOL *ptr;
    int          deref = 0;
    int     brackets = 0;

    if ( rcmatch('(')) {
        brackets = 1;
        needchar('(');        
    }
    while ( cmatch('*') ) {
        deref++;
    }
    lval->ltype = type_int;

    if ( (type = parse_expr_type()) != NULL ) {
        if ( deref && type->kind != KIND_PTR ) {
            UT_string *str;
            utstring_new(str);
            type_describe(type, str);
            errorfmt("sizeof expects a pointer but got %s", 1, utstring_body(str) );
            utstring_free(str);
            lval->const_val = 2;
            lval->is_const = 1;
            return;
        }
        while ( deref && type ) {
            Type *next = type->ptr;
            type = next;
            deref--;
        }
        if ( type == NULL ) {
            lval->const_val = 2;
            lval->is_const = 1;            
            errorfmt("Cannot dereference far enough, assuming size of 2",1);
        } else {
            lval->const_val = type->size;
        }
    } else if (cmatch('"')) { /* Check size of string */
        length = 1; /* Always at least one */
        do
        {
            while (!cmatch('"')) {
                length++;
                litchar();
            };
            /* Keep going for "concatenated" "strings" */
            if (!cmatch('"')) {
                break;
            }
            /* But correct the opening quotes */
            length--;
        } while (1);
        lval->const_val = length;
        if ( deref ) 
            lval->const_val = 1;
    } else if (symname(sname)) { /* Size of an object */
        Type *type;
        if (((ptr = findloc(sname)) != NULL) || ((ptr = findstc(sname)) != NULL) || ((ptr = findglb(sname)) != NULL)) {
            type = ptr->ctype;
            lval->const_val = type->size;
            
            if (type->kind != KIND_FUNC && ptr->ident != ID_MACRO) {
                if ( type->kind == KIND_PTR && type->ptr->kind == KIND_STRUCT ) {
                    type = type->ptr;
                }
                if (type->kind != KIND_STRUCT ) {
                } else {
                    Type *mptr;

                    /* We're a member of a structure */
                    do {
                        if ( (mptr = get_member(type->kind == KIND_STRUCT ? type->tag : type->ptr->tag) ) != NULL ) {
                            type = mptr;
                            if ( (mptr->kind == KIND_PTR || mptr->kind == KIND_CPTR) && deref ) {
                                // Do nothing
                            } else {
                                // tag_sym->size = numner of elements
                                lval->const_val = mptr->size;
                            }
                        } else {
                            lval->const_val = type->size;
                        }
                    } while ( mptr && ( (mptr->kind == KIND_STRUCT && rcmatch('.')) ||
                                      ( ispointer(mptr) && mptr->ptr->kind == KIND_STRUCT && rmatch2("->"))) );
                }
                /* Check for index operator on array */
                if (type->kind == KIND_ARRAY ) {
                    if (rcmatch('[')) {
                        double val;
                        Kind valtype;
                        needchar('[');
                        constexpr(&val, &valtype,  1);
                        needchar(']');
                        deref++;
                        lval->const_val = type->size / type->len;
                    }
                }
                while ( deref && type ) {
                    lval->const_val = type->size;
                    type = type->ptr;  
                    if ( type ) {
                        lval->const_val = type->size;
                    } 
                    deref--;                         
                }
            } else {
                lval->const_val = 2;
            }
        } else {
            errorfmt("Unknown symbol: %s", 1, sname);
        }
    }
    if ( brackets )
        needchar(')');
    lval->is_const = 1;
    lval->val_type = KIND_INT;
    vconst(lval->const_val);
}

static Type *get_member(Type *tag)
{
    char sname[NAMESIZE];
    Type *member;;

    if (cmatch('.') == NO && match("->") == NO)
        return NULL;

    if (symname(sname) && (member = find_tag_field(tag, sname))) {
        return member;
    }
    errorfmt("Unknown member: %s", 1, sname);
    return NULL;
}




void dofloat(enum maths_mode mode,double raw, unsigned char fa[])
{
    switch ( mode ) {
        case MATHS_IEEE:
            dofloat_ieee(raw, fa);
            break;
        case MATHS_MBFS:
            dofloat_mbfs(raw, fa);
            break;
        case MATHS_MBF40:
            dofloat_mbf40(raw, fa);
            break;
        case MATHS_MBF64:
            dofloat_mbf64(raw, fa);
            break;
        case MATHS_IEEE16:
            dofloat_ieee16(raw, fa);
            break;
        case MATHS_AM9511:
            dofloat_am9511(raw, fa);
            break;
        default:
            dofloat_z80(raw, fa);
            break;  
    }
}

static void pack32bit_float(uint32_t val, unsigned char fa[]) 
{
    fa[0] = val & 0xff;
    fa[1] = (val >> 8) & 0xff;
    fa[2] = (val >> 16) & 0xff;
    fa[3] = (val >> 24) & 0xff;
}

static void dofloat_ieee(double raw, unsigned char fa[])
{
    if ( isnan(raw)) {
        // quiet nan: 7FC00000
        // signalling nan: 7F800001
        pack32bit_float(0x7fc00000, fa);
        fa[0] = 0x00;
        fa[1] = 0x00;
        fa[2] = 0xc0;
        fa[3] = 0x7f;
    } else if ( isinf(raw) && raw > 0 ) {
        // positive infinity: 7F800000
        pack32bit_float(0x7f800000, fa);
        fa[0] = 0x00;
        fa[1] = 0x00;
        fa[2] = 0x80;
        fa[3] = 0x7f;
    } else if ( isinf(raw) && raw < 0 ) {
        // negative infinity: FF800000
        pack32bit_float(0xff800000, fa);
    } else {
        struct fp_decomposed fs = {0};
        uint32_t fp_value = 0;

        decompose_float(raw, &fs);
        
        // Bundle up mantissa
        fp_value = ( ( (uint32_t)fs.mantissa[4]) | ( ((uint32_t)fs.mantissa[5]) << 8) | (((uint32_t)fs.mantissa[6]) << 16))  & 0x007fffff;

        // And now the exponent
        fp_value |= (((uint32_t)fs.exponent) << 23);

        // And the sign bit
        fp_value |= fs.sign ? 0x80000000 : 0x00000000;
        pack32bit_float(fp_value, fa);
    }
}

static void dofloat_ieee16(double raw, unsigned char fa[])
{
    if ( isnan(raw)) {
        fa[0] = 0xff;
        fa[1] = 0xff;
    } else if ( isinf(raw) && raw > 0 ) {
        // positive infinity: 7c00
        fa[0] = 0x00;
        fa[1] = 0x7c;
    } else if ( isinf(raw) && raw < 0 ) {
        // positive infinity: 7c00
        fa[0] = 0x00;
        fa[1] = 0xfc;
    } else {
        struct fp_decomposed fs = {0};
        uint32_t fp_value = 0;
        int saved_exp = c_fp_exponent_bias;
        int saved_mant = c_fp_mantissa_bytes;

        c_fp_exponent_bias = 14;
        c_fp_mantissa_bytes = 2;
        decompose_float(raw, &fs);

        c_fp_exponent_bias = saved_exp;
        c_fp_mantissa_bytes = saved_mant;
        


        // Bundle up mantissa - it's only 10 bits
        fp_value = ((((uint32_t)fs.mantissa[6]) << 3) |  ((((uint32_t)fs.mantissa[5]) >> 5 ) & 0x07) ) & 0x3ff  ;

        // And now the exponent
        fp_value |= (((uint32_t)fs.exponent) << 10) & 0x7fc0;

        // And the sign bit
        fp_value |= fs.sign ? 0x8000 : 0x0000;
        fa[0] = fp_value & 0xff;
        fa[1] = (fp_value & 0xff00) >> 8;
    }
}

static void dofloat_mbfs(double raw, unsigned char fa[])
{
    struct fp_decomposed fs = {0};
    uint32_t fp_value = 0;

    decompose_float(raw, &fs);

    // Bundle up mantissa
    fp_value = ( ( (uint32_t)fs.mantissa[4]) | ( ((uint32_t)fs.mantissa[5]) << 8) | (((uint32_t)fs.mantissa[6]) << 16))  & 0x007fffff;

    // And now the exponent
    fp_value |= (((uint32_t)fs.exponent) << 24);

    // And the sign bit
    fp_value |= fs.sign ? 0x00800000 : 0x00000000;
    pack32bit_float(fp_value, fa);
}

static void dofloat_am9511(double raw, unsigned char fa[])
{
    struct fp_decomposed fs = {0};
    uint32_t fp_value = 0;

    if ( raw != 0.0 ) {
        decompose_float(raw, &fs);

        // Bundle up mantissa
        fp_value = (((uint32_t)fs.mantissa[4]) | ( ((uint32_t)fs.mantissa[5]) << 8) | (((uint32_t)fs.mantissa[6]) << 16)) | 0x00800000;

        // And now the exponent
        fp_value |= ((((uint32_t)fs.exponent) << 24) & 0x7f000000);

        // And the sign bit
        fp_value |= fs.sign ? 0x80000000 : 0x00000000;
    }
    pack32bit_float(fp_value, fa);
}


static void dofloat_mbf64(double raw, unsigned char fa[])
{
    struct fp_decomposed fs = {0};

    decompose_float(raw, &fs);

    memcpy(fa, fs.mantissa, 7);
    fa[6] |= fs.sign ? 0x80 : 00;
    fa[7] = fs.exponent;
}


static void dofloat_mbf40(double raw, unsigned char fa[])
{
    struct fp_decomposed fs = {0};

    decompose_float(raw, &fs);

    memcpy(fa, fs.mantissa + 3, 4);
    fa[3] |= fs.sign ? 0x80 : 00;
    fa[4] = fs.exponent;
}

static void dofloat_z80(double raw, unsigned char fa[])
{
    struct fp_decomposed fs = {0};
    int      offs = MAX_MANTISSA_SIZE - c_fp_mantissa_bytes;
    int      i;

    decompose_float(raw, &fs);


    for ( i = offs; i < MAX_MANTISSA_SIZE ; i++ ) {
        fa[i - offs + c_fp_fudge_offset] = fs.mantissa[i];
    }
    fa[i - offs -1 + c_fp_fudge_offset] |= fs.sign ? 0x80 : 0;
    fa[i - offs + c_fp_fudge_offset] = fs.exponent;
}


static void decompose_float(double raw, struct fp_decomposed *fs)
{
    double norm;
    double x = fabs(raw);
    double exp = log(x) / log(2);
    int i;
    int mant_bytes = c_fp_mantissa_bytes;
    int exp_bias = c_fp_exponent_bias;

    fs->sign = 0;
    fs->exponent = 0;

    for ( i = 0; i < MAX_MANTISSA_SIZE; i++ ) {
       fs->mantissa[i] = 0;
    }

    if (mant_bytes > MAX_MANTISSA_SIZE ) {
        mant_bytes = MAX_MANTISSA_SIZE;
    }

    if (x == 0.0) {
        memset(fs->mantissa, 0, MAX_MANTISSA_SIZE + 1);
        return;
    }

    if (floor(exp) == ceil(exp)) {
        exp = ceil(exp) + 1;
    } else {
        exp = ceil(exp);
    }

    norm = x / pow(2, exp);

    fs->exponent = (int)exp + exp_bias;
    for (i = 0; i < (mant_bytes * 2) + 1; i++) {
        double mult = norm * 16.;
        double res = floor(mult);
        unsigned char bit = res;

        if (i == 0 && raw > 0)
            bit -= 8;
        if (i == mant_bytes * 2) {
            if (bit > 7) {
                int carry = 1;
                for (i = MAX_MANTISSA_SIZE - mant_bytes; i < MAX_MANTISSA_SIZE; i++) {
                    int res = fs->mantissa[i] + carry;

                    fs->mantissa[i] = res % 256;
                    carry = res / 256;
                }
            }
            break;
        }
        if (i % 2 == 0) {
            fs->mantissa[(MAX_MANTISSA_SIZE-1) - i / 2] = (bit << 4);
        } else {
            fs->mantissa[(MAX_MANTISSA_SIZE-1) - i / 2] |= (bit & 0x0f);
        }
        norm = mult - res;
    }
    if ( raw < 0 ) {
        fs->sign = 1;
    }
}


elem_t *get_elem_for_fa(unsigned char fa[], double value) 
{
    elem_t  *elem;

    LL_FOREACH(bigconst_queue, elem ) {
        if ( elem->kind == KIND_DOUBLE && memcmp(elem->fa, fa, MAX_MANTISSA_SIZE) == 0 ) {
            return elem;
        }
    }
    elem = MALLOC(sizeof(*elem));
    elem->kind = KIND_DOUBLE;
    elem->litlab = getlabel();
    elem->value = value;
    elem->written = 0;
    memcpy(elem->fa, fa, MAX_MANTISSA_SIZE+1);
    LL_APPEND(bigconst_queue, elem);
    return elem;
}

void indicate_constant_written(int litlab)
{
    elem_t  *elem;

    LL_FOREACH(bigconst_queue, elem ) {
        if ( elem->litlab == litlab ) {
            elem->written = 1;
        }
    }
}

elem_t *get_elem_for_buf(char *str, double value) 
{
    elem_t  *elem;

    LL_FOREACH(bigconst_queue, elem ) {
        if ( elem->kind == KIND_DOUBLE && strcmp(elem->str, str) == 0 ) {
            return elem;
        }
    }
    elem = MALLOC(sizeof(*elem));
    elem->kind = KIND_DOUBLE;
    elem->litlab = getlabel();
    elem->value = value;
    elem->written = 0;
    strcpy(elem->str,str);
    LL_APPEND(bigconst_queue, elem);
    return elem;
}


elem_t *get_elem_for_llong(char buf[8]) 
{
    elem_t  *elem;

    LL_FOREACH(bigconst_queue, elem ) {
        if ( elem->kind == KIND_LONGLONG && memcmp(elem->fa, buf, 8) == 0 ) {
            return elem;
        }
    }
    elem = MALLOC(sizeof(*elem));
    elem->kind = KIND_LONGLONG;
    elem->litlab = getlabel();
    elem->written = 0;
    memcpy(elem->fa, buf, 8);
    LL_APPEND(bigconst_queue, elem);
    return elem;
}



void write_constant_queue(void)
{
    elem_t  *elem;

    LL_FOREACH(bigconst_queue, elem ) {
        if ( elem->written ) {
            gen_switch_section(c_rodata_section);
            prefix();
            queuelabel(elem->litlab);
            col();
            nl();
            if ( elem->kind == KIND_DOUBLE) {
                if ( c_double_strings ) {
                    defmesg(); outstr(elem->str); outstr("\"\n");
                    defbyte(); outdec(0); nl();
                } else {
                    char   buf[128];
                    int    i, offs;

                    for ( i = 0, offs = 0; i < c_fp_size; i++) {
                        offs += snprintf(buf + offs, sizeof(buf) - offs,"%s0x%02x", i != 0 ? "," : "", elem->fa[i]);
                    }
                    //outfmt("\t;%lf ref: %d written: %d\n",elem->value,elem->refcount, elem->written);
                    outfmt("\t;%Lf\n",elem->value);
                    outfmt("\tdefb\t%s\n", buf);
                }
            } else {
                char   buf[128];
                int    i, offs;
                for ( i = 0, offs = 0; i < 8; i++) {
                    offs += snprintf(buf + offs, sizeof(buf) - offs,"%s0x%02x", i != 0 ? "," : "", elem->fa[i]);
                }
                outfmt("\tdefb\t%s\n", buf);
            }
        }
    }
    nl();
}

void load_llong_into_acc(zdouble val)
{
    uint64_t v,l;
    char    buf[8];
    elem_t *elem;

    if ( val < 0 ) v = (uint64_t)(int64_t)val;
    else v = val;


    l = v & 0xffffffff;
    buf[0] = (l % 65536) % 256;
    buf[1] = (l % 65536) / 256;
    buf[2] = (l / 65536) % 256;
    buf[3] =  (l / 65536) / 256;
    l = (v >> 32) & 0xffffffff;
    buf[4] = (l % 65536) % 256;
    buf[5] = (l % 65536) / 256;
    buf[6] = (l / 65536) % 256;
    buf[7] =  (l / 65536) / 256;

    elem = get_elem_for_llong(buf);
    immedlit(elem->litlab,0);
    nl();
    callrts("l_i64_load");
}


void load_double_into_fa(LVALUE *lval)
{            
    unsigned char    fa[MAX_MANTISSA_SIZE+1] = {0};
    elem_t          *elem;
    memset(fa, 0, sizeof(fa));
    
    if ( c_double_strings ) {
        char  buf[40];
        snprintf(buf, sizeof(buf), "%Lf", lval->const_val);
        elem = get_elem_for_buf(buf, lval->const_val);
        immedlit(elem->litlab,0);
        nl();
        callrts("__atof2");
        WriteDefined("math_atof", 1);
    } else {
        dofloat(c_maths_mode,lval->const_val, fa);
        if ( lval->val_type == KIND_FLOAT16 ) {
            dofloat_ieee16(lval->const_val, fa);
            vconst(fa[1] << 8 | fa[0]);
        } else if ( c_fp_size == 4 ) {
            vconst(fa[1] << 8 | fa[0]);
            const2(fa[3] << 8 | fa[2]);
        } else {
            elem = get_elem_for_fa(fa,lval->const_val);
            immedlit(elem->litlab,0);
            nl();
            callrts("dload");
        }
    }
}
