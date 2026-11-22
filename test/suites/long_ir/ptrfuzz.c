/* [fuzz-found] Miscompiles from a differential fuzzer (random pointer / alias
 * programs against gcc). Every case below gave a wrong answer; each comment
 * names the shape and the cause.
 *
 *  step_glob     `gp++` on a global pointer stepped one byte, not sizeof(*gp)
 *  step_elem     `*pa[0]++` / `ps[0]++`: a step on a pointer array element
 *                was refused, and with simplify's `+ 0` fold it reached the
 *                global path above
 *  step_deref    `(*ps[1])--`, `(**pp)++`, `(*s.p)++`: the step landed on the
 *                slot holding the pointer, not on what it points at
 *  store_deref   `*ps[1] = v`, `*s.p = v`, `ps[1][0] = v`: the same slip on
 *                the store side overwrote the pointer
 *  cse_alias     `a = *p ^ x` with p == &a: the binding E -> a named a value
 *                the store itself had changed
 *  cse_narrow    `x = E` into a narrower variable bound E -> x and lost bits
 *  dse_read      two stores through p with a direct read of the escaped local
 *                between them: the first store was deleted as dead
 *  remat_byte    a rematerialised constant read as a byte ALU operand used a
 *                slot it does not have (sp-1)
 *  remat_hl      the same constant read into A clobbered HL under a cached
 *                slot-address belief
 *  stack_byte    a word parked on the stack whose one use is a byte op
 *  synth_alias   a shared subexpression hoisted over a direct write to the
 *                escaped local its pointer read reaches
 */
#include "test.h"

static unsigned short arr[6];
static unsigned short *pa[2];
static unsigned short *gp;
static unsigned long larr[3];
static unsigned long *lgp;
static struct S { unsigned short v; unsigned short *p; } st, *sp;
static unsigned short g0 = 100;
static unsigned short gwr[4];

static void reset(void)
{
    unsigned k;
    for (k = 0; k < 6; k++) arr[k] = (unsigned short)(10 * (k + 1));
    st.v = 7; st.p = &arr[1]; sp = &st;
}

static void test_steps(void)
{
    unsigned short *lps[2];
    unsigned short *p;
    unsigned short **lpp;

    reset();
    gp = &arr[0];
    gp++;                      /* step_glob: int* */
    assertEqual(*gp, 20);
    ++gp;
    assertEqual(*gp, 30);
    gp--;
    assertEqual(*gp, 20);
    larr[0] = 1; larr[1] = 2; larr[2] = 3;
    lgp = &larr[0];
    ++lgp;                     /* step_glob: long* */
    assertEqual((int)*lgp, 2);
    assertEqual(*gp++, 20);
    assertEqual(*gp, 30);

    reset();
    pa[0] = &arr[0]; pa[1] = &arr[2];
    assertEqual(*pa[0]++, 10);     /* step_elem */
    assertEqual(*pa[0], 20);
    assertEqual(*++pa[1], 40);
    pa[0]--;
    assertEqual(*pa[0], 10);

    reset();
    lps[0] = &arr[0]; lps[1] = &arr[2];
    (*lps[1])--;               /* step_deref */
    assertEqual(arr[2], 29);
    assertEqual(lps[1] == &arr[2], 1);
    p = &arr[1]; lpp = &p;
    (**lpp)++;
    assertEqual(arr[1], 21);
    assertEqual(p == &arr[1], 1);
    (*st.p)++;
    assertEqual(arr[1], 22);
    (*sp->p)--;
    assertEqual(arr[1], 21);
    assertEqual(st.p == &arr[1], 1);
}

static void test_stores(void)
{
    unsigned short *lps[2];
    unsigned short *p;
    unsigned short **lpp;

    reset();
    lps[0] = &arr[0]; lps[1] = &arr[2];
    *lps[1] = 99;              /* store_deref */
    assertEqual(arr[2], 99);
    assertEqual(lps[1] == &arr[2], 1);
    lps[1][1] = 98;
    assertEqual(arr[3], 98);
    p = &arr[1]; lpp = &p;
    **lpp = 97;
    assertEqual(arr[1], 97);
    assertEqual(p == &arr[1], 1);
    *st.p = 96;
    assertEqual(arr[1], 96);
    assertEqual(st.p == &arr[1], 1);
    *sp->p = *st.p + 1;
    assertEqual(arr[1], 97);
    *lps[0] ^= 5;
    assertEqual(arr[0], 15);
}

static unsigned short alias_cse(void)
{
    unsigned short a = 1, b, c, x = 2;
    unsigned short *p = &a;
    a = (unsigned short)(*p ^ 2);
    b = (unsigned short)(*p ^ 2);      /* cse_alias: a changed above */
    c = (unsigned short)(*p ^ x);
    return (unsigned short)(a * 100 + b * 10 + c);
}

static unsigned short narrow_cse(unsigned short q)
{
    unsigned char x;
    unsigned short y;
    x = (unsigned char)(q + 258);      /* cse_narrow */
    y = (unsigned short)(q + 258);
    return (unsigned short)(x + y);
}

static unsigned short dse_read(void)
{
    unsigned short a = 2, b = 100;
    unsigned short *p = &a;
    *p = (unsigned short)((b ^ a) << 1);
    *p = (unsigned short)(b ^ a);      /* dse_read: reads a between */
    return a;
}

static unsigned char remat_byte(void)
{
    unsigned short b = 7, a = 1;
    unsigned short *q = &a;
    unsigned char x;
    x = (unsigned char)(((unsigned short)(b & (*q - 1))) << 1);
    return (unsigned char)(x + 1);
}

static unsigned char remat_hl(void)
{
    unsigned short a = 256, b = 0, c = 100;
    unsigned short *q = &b;
    unsigned short arr2[4];
    unsigned char x;
    arr2[0] = 7; arr2[1] = 1; arr2[2] = 2; arr2[3] = 100;
    x = (unsigned char)((*q & arr2[1]) + (2 ^ a));
    return (unsigned char)(x + (unsigned char)c);
}

static unsigned short stack_byte(unsigned short *ps0)
{
    unsigned char x = 255;
    unsigned short c = 2;
    ps0 = &c;
    x = (unsigned char)(((unsigned short)(g0 >> 3) + *ps0) << 1);
    return x;
}

static unsigned short synth_alias(void)
{
    unsigned short a = 40000, b = 40000, c = 0;
    unsigned short *q = &b, *pc = &c;
    unsigned short sink = 0;
    unsigned char i;
    for (i = 0; i < 2; i++) {
        sink = (unsigned short)(sink * 31 + ((255 | (*q | *pc)) + ((*q | *pc) >> 1)));
        c ^= (unsigned short)(a << 3);
    }
    return sink;
}


static unsigned short cse_self(void)
{
    unsigned short a = 2, b = 2;
    unsigned short *p = &a, *q = &b;
    unsigned short sink = 0;
    sink = (unsigned short)(sink * 31 + (((unsigned short)(*q | *p)) >> 1));
    sink = (unsigned short)(sink * 31 + (((unsigned short)(*q | *p)) >> 1));
    return sink;
}

static unsigned short de_stale_xor(unsigned short b, unsigned short a)
{
    unsigned short u = 3;
    unsigned short *keep = &u;
    a = (unsigned short)(b ^ (a | a));
    return (unsigned short)(a + *keep);
}

static unsigned short de_stale_sub(unsigned short *r)
{
    unsigned short sink;
    sink = *r;
    sink = (unsigned short)(sink * 31 + 0);
    return sink;
}

static unsigned short call_id(unsigned short *q) { return *q; }

static unsigned char idx_byte(unsigned short *rq)
{
    unsigned short arr3[4];
    unsigned short b = 1;
    unsigned short *r = &arr3[1];
    unsigned char out = 0;
    unsigned char i;
    arr3[0] = 0; arr3[1] = 100; arr3[2] = 256; arr3[3] = 1;
    for (i = 0; i < 2; i++) {
        arr3[2] = arr3[1];
        out = (unsigned char)(call_id(&b) ^ (unsigned short)(*r - 2));
    }
    (void)rq;
    return out;
}

static void test_alias_cases(void)
{
    assertEqual(alias_cse(), 311);
    assertEqual(narrow_cse(1), 3 + 259);
    assertEqual(dse_read(), 168);
    assertEqual(remat_byte(), 1);
    assertEqual(remat_hl(), 102);
    assertEqual(stack_byte(0), 28);
    assertEqual(synth_alias(), 63200u);
    assertEqual(cse_self(), 32);
    assertEqual(de_stale_xor(7, 100), 102);
    reset();
    assertEqual(de_stale_sub(&arr[1]), 620);
    assertEqual(idx_byte(0), 99);
}

void test_ptrfuzz(void)
{
    test_steps();
    test_stores();
    test_alias_cases();
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("pointer and alias cases found by a differential fuzzer");
    suite_add_test(test_ptrfuzz);
    return suite_run();
}
