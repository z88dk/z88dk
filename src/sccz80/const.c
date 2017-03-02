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

static int get_member_size(TAG_SYMBOL *ptr);;
static int32_t search_litq_for_doublestr(unsigned char *num);;
static void dofloat(double raw, unsigned char fa[6], int mant_bytes, int exp_bias);

/*
 * These two variables used whilst loading constants, makes things
 * a little easier to handle - type specifiers..
 */

char constype;
char conssign;

/* Modified slightly to sort have two pools - one for strings and one
 * for doubles..
 */

int constant(LVALUE* lval)
{
    constype = CINT;
    conssign = c_default_unsigned;
    lval->is_const = 1; /* assume constant will be found */
    if (fnumber(&lval->const_val)) {
        lval->val_type = DOUBLE;
        if (c_double_strings) {
            immedlit(litlab);
            outdec(lval->const_val);
            nl();
            callrts("__atof2");
            WriteDefined("math_atof", 1);
        } else {
            immedlit(dublab);
            outdec(lval->const_val);
            nl();
            callrts("dload");
        }
        lval->is_const = 0; /*  floating point not constant */
        lval->flags = FLAGS_NONE;
        return (1);
    } else if (number(&lval->const_val) || pstr(&lval->const_val)) {
        /* Insert int32_t stuff/int32_t pointer here? */
        if ((uint32_t)lval->const_val >= 65536LU)
            constype = LONG;

        lval->val_type = constype;
        lval->flags = (lval->flags & (~UNSIGNED)) | conssign;
        if (constype == LONG)
            vlongconst(lval->const_val);
        else
            vconst(lval->const_val);
        return (1);
    } else if (tstr(&lval->const_val)) {
        lval->is_const = 0; /* string address not constant */
        lval->ptr_type = CCHAR; /* djm 9/3/99 */
        lval->val_type = CINT;
        lval->flags = FLAGS_NONE;
        immedlit(litlab);
    } else {
        lval->is_const = 0;
        return (0);
    }
    outdec(lval->const_val);
    nl();
    return (1);
}

int fnumber(int32_t* val)
{
    unsigned char sum[6];
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
    dofloat(dval, sum, c_mathz88 ? 4 : 5, c_mathz88 ? 127 : 128);

    for ( i = 0; i < buffer_fps_num; i++ ) 
        fprintf(buffer_fps[i], "%.*s", (int)(end-start), start);
    lptr = end - line;

    /* get location for result & bump litptr */
    if (c_double_strings) {
        *val = stash_double_str(start, lptr + line);
        return (1);
    } else {
        *val = search_litq_for_doublestr(sum);
    }
    return (1); /* report success */
}

/* stash a double string in the literal pool */

int stash_double_str(char* start, char* end)
{
    int len;
    int32_t val;
    char* buf;

    len = end - start;

    if (*(start + len - 1) == ' ')
        len--;

    buf = malloc(len + 1);

    if (buf == NULL) {
        error(E_LITQOV); /* As good as any really.. */
    }
    strncpy(buf, start, len);
    *(buf + len) = 0;
    storeq(len + 1, (unsigned char*)buf, &val);
    FREENULL(buf);
    return (val);
}

/* Search through the literal queue searching for a match with our
 * number - saves space etc etc
 */

static int32_t search_litq_for_doublestr(unsigned char* num)
{
    unsigned char* tempdub;
    int dubleft, k, match;

    dubleft = dubptr;
    tempdub = dubq;
    while (dubleft) {
        /* Search through.... */
        match = 0;
        for (k = 0; k < 6; k++) {
            if (*tempdub++ == num[k])
                match++;
        }
        if (match == 6)
            return (dubptr - dubleft);
        dubleft -= 6;
    }
    /* Put it in the double queue now.. */
    if (dubptr + 6 >= FNMAX) {
        error(E_DBOV);
        return (0);
    }

    for (k = 0; k < 6; k++) {
        *tempdub++ = num[k];
    }
    dubptr += 6;
    return (dubptr - 6);
}

int number(int32_t* val)
{
    char c;
    int minus;
    int32_t k;
    /*
 * djm, set the type specifiers to normal
 */
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
        *val = k;
        goto typecheck;
    }
    if (ch() == '0') {
        gch();
        while (numeric(ch())) {
            c = inbyte();
            if (c < '8')
                k = k * 8 + (c - '0');
        }
        *val = k;
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
    *val = k;
typecheck:
    while (rcmatch('L') || rcmatch('U') || rcmatch('S')) {
        if (cmatch('L'))
            constype = LONG;
        if (cmatch('U'))
            conssign = YES; /* unsigned */
        if (cmatch('S'))
            conssign = NO;
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

int pstr(int32_t* val)
{
    int k;

    constype = CINT;
    conssign = c_default_unsigned;
    if (cmatch('\'')) {
        k = 0;
        while (ch() && ch() != '\'')
            k = (k & 255) * 256 + litchar();
        gch();
        *val = k;
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

int qstr(int32_t* val)
{
    int cnt = 0;

    if (cmatch('"') == 0)
        return (-1);

    *val = (int32_t)gltptr;
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
        if (match("**") || cmatch('*'))
            ident = POINTER;
        else
            ident = VARIABLE;

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
                    int val;
                    needchar('[');
                    constexpr(&val, 1);
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

static void dofloat(double raw, unsigned char fa[6], int mant_bytes, int exp_bias)
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
