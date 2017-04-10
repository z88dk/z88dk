/*
 *      Small C+ Compiler
 *      Split into parts 3/3/99 djm
 *
 *      This part deals with the evaluation of a constant
 *
 *      $Id: const.c,v 1.26 2016-08-26 05:45:05 aralbrec Exp $
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

#include <math.h>
#include "lib/utlist.h"

static int get_member_size(TAG_SYMBOL *ptr);;



typedef struct elem_s {
    struct elem_s *next;
    int            refcount;
    int            litlab;
    double         value;
    unsigned char  fa[6];      /* The parsed representation */
    char           str[60];    /* A raw string version */
} elem_t;


static elem_t    *double_queue = NULL;


/* Modified slightly to sort have two pools - one for strings and one
 * for doubles..
 */

int constant(LVALUE* lval)
{
    int32_t val;
    lval->val_type = CINT;
    lval->flags &= ~UNSIGNED;
    lval->flags |= c_default_unsigned ? UNSIGNED : 0;
    lval->is_const = 1; /* assume constant will be found */
    if (fnumber(lval)) {
        load_double_into_fa(lval);
        lval->val_type = DOUBLE;
        lval->flags = FLAGS_NONE;
        return (1);
    } else if (number(lval) || pstr(lval)) {
        if (lval->val_type == LONG)
            vlongconst(lval->const_val);
        else
            vconst(lval->const_val);
        return (1);
    } else if (tstr(&val)) {
        lval->const_val = val;
        lval->is_const = 0; /* string address not constant */
        lval->ptr_type = CCHAR; /* djm 9/3/99 */
        lval->val_type = CINT;
        lval->flags = FLAGS_NONE;
        immedlit(litlab);
        outdec(lval->const_val);
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

    if (*s != '.' && *s != 'e') { /* Check that it is floating point */
        s++;
        return 0;
    }
    while (numeric(*s))
        ++s;
    lptr = (s--) - line; /* save ending point */

    dval = strtod(start, &end);
    if (end == start)
        return 0;

    for ( i = 0; i < buffer_fps_num; i++ ) 
        fprintf(buffer_fps[i], "%.*s", (int)(end-start), start);
    lptr = end - line;

    lval->const_val = dval;

    return (1); /* report success */
}


int number(LVALUE *lval)
{
    char c;
    int minus;
    int32_t k;

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
    lval->val_type = CINT;
    if ( lval->const_val >= 65536 || lval->const_val < -32767 ) {
        lval->val_type = LONG;
    }
    while (rcmatch('L') || rcmatch('U') || rcmatch('S')) {
        if (cmatch('L'))
            lval->val_type = LONG;
        if (cmatch('U'))
            lval->flags |= UNSIGNED;
        if (cmatch('S'))
            lval->flags &= ~UNSIGNED;
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
    /* djm if we're using int32_t pointers, use of e=0 means absolute address,
 * this covers up a bit of a problem in deref() which can't distinguish
 * between ptrtoptr and ptr
 */
    if (ptr->flags & FARPTR) {
        const2(0);
    }
}

int pstr(LVALUE *lval)
{
    int k;

    lval->val_type = CINT;
    lval->flags &= ~UNSIGNED;
    lval->flags |= c_default_unsigned ? UNSIGNED : 0;
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
            error(E_LITQOV);
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
        error(E_LITQOV);
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
    }

    if (ch() != 'x' && (ch() < '0' || ch() > '7')) {
        warning(W_ESCAPE, ch());
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
            warning(W_HEXESCAPE_TOO_LONG);
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

/* Perform a sizeof (works on variables as well */
/* FIXME: Should also dereference pointers... */
void size_of(LVALUE* lval)
{
    char sname[NAMESIZE];
    int length;
    TAG_SYMBOL* otag;
    SYMBOL* ptr;
    struct varid var;
    enum ident_type ident;

    needchar('(');
    otag = GetVarID(&var, NO);
    if (var.type != NO) {
        ident = var.ident;
        if ( ident == POINTER && cmatch('*') ) {

        } else {
            if (match("**") || cmatch('*'))
                ident = POINTER;
            else
                ident = VARIABLE;
        }
        if (otag && ident == VARIABLE)
            lval->const_val = otag->size;
        if (ident == POINTER) {
            lval->const_val = (var.zfar ? 3 : 2);
        } else {
            switch (var.type) {
            case CCHAR:
                lval->const_val = 1;
                break;
            case CINT:
                lval->const_val = 2;
                break;
            case LONG:
                lval->const_val = 4;
                break;
            case DOUBLE:
                lval->const_val = 6;
                break;
            case STRUCT:
                lval->const_val = get_member_size(otag);
                if (lval->const_val == 0)
                    lval->const_val = otag->size;
            }
        }
    } else if (cmatch('"')) { /* Check size of string */
        length = 1; /* Always at least one */
        while (!cmatch('"')) {
            length++;
            litchar();
        };
        lval->const_val = length;
    } else if (symname(sname)) { /* Size of an object */
        if (((ptr = findloc(sname)) != NULL) || ((ptr = findstc(sname)) != NULL) || ((ptr = findglb(sname)) != NULL)) {
            /* Actually found sommat..very good! */
            if (ptr->ident != FUNCTION && ptr->ident != MACRO) {
                if (ptr->type != STRUCT) {
                    lval->const_val = ptr->size;
                } else {
                    lval->const_val = get_member_size(tagtab + ptr->tag_idx);
                    if (lval->const_val == 0)
                        lval->const_val = ptr->size;
                }
                /* Check for index operator on array */
                if (ptr->ident == ARRAY && rcmatch('[')) {
                    double val;
                    int valtype;
                    needchar('[');
                    constexpr(&val, &valtype,  1);
                    needchar(']');
                    lval->const_val = get_type_size(ptr->type, tagtab + ptr->tag_idx);
                }
            } else {
                warning(W_SIZEOF);
                /* good enough default? */
                lval->const_val = 2;
            }
        }
    }
    needchar(')');
    lval->is_const = 1;
    lval->val_type = CINT;
    lval->ident = VARIABLE;
    vconst(lval->const_val);
}

static int get_member_size(TAG_SYMBOL* ptr)
{
    char sname[NAMESIZE];
    SYMBOL* ptr2;
    if (cmatch('.') == NO && match("->") == NO)
        return (0);

    if (symname(sname) && (ptr2 = findmemb(ptr, sname)))
        return ptr2->size;
    error(E_UNMEMB, sname);
    return (0);
}

void dofloat(double raw, unsigned char fa[6], int mant_bytes, int exp_bias)
{
    double norm;
    double x = fabs(raw);
    double exp = log(x) / log(2);
    int i;

    if (x == 0.0) {
        fa[0] = fa[1] = fa[2] = fa[3] = fa[4] = fa[5] = 0;
        return;
    }

    if (floor(exp) == ceil(exp)) {
        exp = ceil(exp) + 1;
    } else {
        exp = ceil(exp);
    }

    norm = x / pow(2, exp);

    fa[5] = (int)exp + exp_bias;
    for (i = 0; i < (mant_bytes * 2) + 1; i++) {
        double mult = norm * 16.;
        double res = floor(mult);
        unsigned char bit = res;

        if (i == 0 && raw > 0)
            bit -= 8;
        if (i == mant_bytes * 2) {
            if (bit > 7) {
                int carry = 1;
                for (i = 5 - mant_bytes; i < 5; i++) {
                    int res = fa[i] + carry;

                    fa[i] = res % 256;
                    carry = res / 256;
                }
            }
            break;
        }
        if (i % 2 == 0) {
            fa[4 - i / 2] = (bit << 4);
        } else {
            fa[4 - i / 2] |= (bit & 0x0f);
        }
        norm = mult - res;
    }
}


elem_t *get_elem_for_fa(unsigned char fa[6], double value) 
{
    elem_t  *elem;

    LL_FOREACH(double_queue, elem ) {
        if ( memcmp(elem->fa, fa, 6) == 0 ) {
            return elem;
        }
    }
    elem = MALLOC(sizeof(*elem));
    elem->refcount = 0;
    elem->litlab = getlabel();
    elem->value = value;
    memcpy(elem->fa, fa, 6);
    LL_APPEND(double_queue, elem);
    return elem;
}

elem_t *get_elem_for_buf(char *str, double value) 
{
    elem_t  *elem;

    LL_FOREACH(double_queue, elem ) {
        if ( strcmp(elem->str, str) == 0 ) {
            return elem;
        }
    }
    elem = MALLOC(sizeof(*elem));
    elem->litlab = getlabel();
    elem->refcount = 0;
    elem->value = value;
    strcpy(elem->str,str);
    LL_APPEND(double_queue, elem);
    return elem;
}



void write_double_queue(void)
{
    elem_t  *elem;

    LL_FOREACH(double_queue, elem ) {
        if ( elem->refcount ) {
            output_section(c_rodata_section); // output_section("text");
            prefix();
            queuelabel(elem->litlab);
            col();
            nl();
            if ( c_double_strings ) {
                defmesg(); outstr(elem->str); outstr("\"\n");
                defbyte(); outdec(0); nl();
            } else {
                //outfmt("\t;%lf ref: %d\n",elem->value,elem->refcount);
                outfmt("\t;%lf\n",elem->value,elem->refcount);
                outfmt("\tdefb\t%d,%d,%d,%d,%d,%d\n", elem->fa[0], elem->fa[1], elem->fa[2], elem->fa[3], elem->fa[4], elem->fa[5]);
            }
        }
    }
    nl();
}

void decrement_double_ref_direct(double value)
{
    LVALUE lval;

    lval.const_val = value;

    decrement_double_ref(&lval);
}

void decrement_double_ref(LVALUE *lval)
{   
    unsigned char    fa[6];
    elem_t          *elem;
    if ( c_double_strings ) {
        char  buf[40];
        snprintf(buf, sizeof(buf), "%lf", lval->const_val);
        elem = get_elem_for_buf(buf,lval->const_val);
        elem->refcount--;
    } else {
        dofloat(lval->const_val, fa, c_mathz88 ? 4 : 5, c_mathz88 ? 127 : 128);
        elem = get_elem_for_fa(fa,lval->const_val);
        elem->refcount--;
    }
}

void load_double_into_fa(LVALUE *lval)
{            
    unsigned char    fa[6];
    elem_t          *elem;

    fa[0] = fa[1] = fa[2] = fa[3] = fa[4] = fa[5] = 0;

    if ( c_double_strings ) {
        char  buf[40];
        snprintf(buf, sizeof(buf), "%lf", lval->const_val);
        elem = get_elem_for_buf(buf, lval->const_val);
        elem->refcount++;
        immedlit(elem->litlab);
        outdec(0);
        nl();
        callrts("__atof2");
        WriteDefined("math_atof", 1);
    } else {
        dofloat(lval->const_val, fa, c_mathz88 ? 4 : 5, c_mathz88 ? 127 : 128);

        elem = get_elem_for_fa(fa,lval->const_val);
        elem->refcount++;
        immedlit(elem->litlab);
        outdec(0);
        nl();
        callrts("dload");
    }
}
