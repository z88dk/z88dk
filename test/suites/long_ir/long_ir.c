/* IR long-arithmetic isolation test.
 *
 * Each `long_*_*` function does ONE long op and returns the result.
 * `main` collects them and asserts every result. Compiled with
 * -Cc--use-ir so each `long_*_*` function exercises the IR's long
 * lowering. main is on legacy (variadic printf, l_longjmp from
 * Assert all bail) but reads the IR-produced longs via cross-call.
 *
 * The _Float16 / double tests (test_float16 / test_double) need the
 * float libraries linked — run this suite with `--math32 --math16`
 * (math32 also sets -fp-mode=ieee so `double` is the IR-supported
 * width-4 IEEE-32 format; without it doubles are 6-byte and bail to the
 * walker, which would need genmath linked instead).
 */

#include "test.h"
#include <string.h>   /* memset/memcpy → __builtin_* (const-count inline) */

/* ---- Add ----------------------------------------------------------- */
long long_add_vv(long a, long b) { return a + b; }
long long_add_vc(long a)         { return a + 0x11223344L; }

/* ---- Sub ----------------------------------------------------------- */
long long_sub_vv(long a, long b) { return a - b; }
long long_sub_vc(long a)         { return a - 0x11223344L; }

/* ---- And / Or / Xor ------------------------------------------------ */
long long_and_vv(long a, long b) { return a & b; }
long long_and_vc(long a)         { return a & 0xff00ff00L; }
long long_or_vv (long a, long b) { return a | b; }
long long_or_vc (long a)         { return a | 0x00ff00ffL; }
long long_xor_vv(long a, long b) { return a ^ b; }
long long_xor_vc(long a)         { return a ^ 0xaaaaaaaaL; }

/* ---- Unary --------------------------------------------------------- */
long long_not(long a) { return ~a; }
long long_neg(long a) { return -a; }

/* ---- Compound-assign on long locals (MD5 FF macro pattern) -------- */
long long_compound(long aa, long bb, long cc, long dd, long ee)
{
    long a = aa, b = bb, c = cc, d = dd;
    a += (b & c) | (~b & d) + ee + 0x11223344L;
    a = (a << 7) | (a >> 25);
    a += b;
    return a;
}

/* ---- Width conversions --------------------------------------------- */
long long_cast_uchar(unsigned char b) { return (long)b; }   /* ZX 1→4 */
long long_cast_schar(signed char b)   { return (long)b; }   /* SX 1→4 */
long long_cast_uint (unsigned int x)  { return (long)x; }   /* ZX 2→4 */
long long_cast_sint (signed int x)    { return (long)x; }   /* SX 2→4 */
int  int_cast_long  (long x)          { return (int)x; }    /* TRUNC 4→2 */
unsigned char uchar_cast_long(long x) { return (unsigned char)x; } /* TRUNC 4→1 */

/* ---- Single FF-macro mirror -------------------------------------- */
long long_ff_one(long *buf, long *in_ptr)
{
    long a = buf[0];
    long b = buf[1];
    long c = buf[2];
    long d = buf[3];
    a += ((b & c) | (~b & d)) + *in_ptr + 0x11223344L;
    a = (a << 7) | (a >> 25);
    a += b;
    buf[0] += a;
    return a;
}

/* ---- Big-BB stress test ------------------------------------------- */
/* Single basic block with many sequential long ops — same shape as
   MD5Transform's body. With BB-level interference, every temp gets
   its own slot. */
long long_big_bb(long a, long b, long c, long d)
{
    long t1 = (a & b) | (~a & c);
    long t2 = t1 + d;
    long t3 = t2 + 0x11223344L;
    long t4 = t3 ^ a;
    long t5 = t4 << 5;
    long t6 = t5 | (t4 >> 27);
    return t6 + b;
}

/* ---- Shifts (const count only) ------------------------------------- */
long long_shl_1 (long a) { return a << 1; }
long long_shl_8 (long a) { return a << 8; }
long long_shl_16(long a) { return a << 16; }
long long_shl_24(long a) { return a << 24; }
long long_shl_5 (long a) { return a << 5; }     /* MD5 ROTATE_LEFT */

long long_shr_1 (long a) { return ((unsigned long)a) >> 1; }
long long_shr_8 (long a) { return ((unsigned long)a) >> 8; }
long long_shr_16(long a) { return ((unsigned long)a) >> 16; }
long long_shr_24(long a) { return ((unsigned long)a) >> 24; }
long long_shr_27(long a) { return ((unsigned long)a) >> 27; }   /* ROTATE_LEFT byproduct */

/* ---- Early return inside a loop (IR build) -------------------------
 * A void `return;` desugared inside while/for arrives with retval set
 * to an empty AST_COMPOUND_STMT (the parser's noop wrap), not NULL;
 * ir_build used to call build_expr on it and bail SILENTLY to the
 * walker (dstar_gencon left/right/up/down). These exercise the fixed
 * path — each must IR-lower and compute correctly. */

/* void return inside while(1) — the exact crash shape */
int cf_counter;
void cf_count_to(int n) { cf_counter = 0; while (1) { if (cf_counter >= n) return; cf_counter++; } }

/* void return inside for(;;) */
void cf_count_for(int n) { cf_counter = 0; for (;;) { if (cf_counter == n) return; cf_counter++; } }

/* value return inside a for loop (linear search) */
int cf_find(int *a, int n, int key) { int i; for (i = 0; i < n; i++) { if (a[i] == key) return i; } return -1; }

/* ---- Inlined const-count memset / memcpy (IR_MEMSET / IR_MEMCPY) ---
 * memset/memcpy with a const count are lowered inline by ir_build: tiny
 * counts unroll, larger ones use an overlapping-`ldir` (memset) / `ldir`
 * (memcpy) fill. Each wrapper returns dst (memset/memcpy semantics), so
 * these also exercise the inline op's return-value path. */
unsigned char m_a[40];
unsigned char m_b[40];
unsigned char m_big[300];

void *ms5  (void *p)          { return memset(p, 0xAB, 5);   } /* unroll */
void *ms20 (void *p)          { return memset(p, 0xCD, 20);  } /* djnz   */
void *ms280(void *p)          { return memset(p, 0x5A, 280); }/* ldir   */
void *mc3  (void *d, void *s) { return memcpy(d, s, 3);      } /* unroll */
void *mc20 (void *d, void *s) { return memcpy(d, s, 20);     } /* ldir   */

/* strcpy/strchr — variable-length inline loops (IR_STRCPY/IR_STRCHR) */
char *scpy   (char *d, char *s) { return strcpy(d, s);   }
char *schr_c (char *s)          { return strchr(s, 'l');  } /* literal char */
char *schr_v (char *s, int c)   { return strchr(s, c);    } /* variable char */
char *schr_nul(char *s)         { return strchr(s, 0);    } /* find the NUL  */

static void test_meminline(void)
{
    int i;
    void *r;

    /* memset — small (unrolled) */
    for (i = 0; i < 40; i++) m_a[i] = 0;
    r = ms5(m_a);
    Assert(r == (void *)m_a, "memset small ret = dst");
    for (i = 0; i < 5; i++) Assert(m_a[i] == 0xAB, "memset small fill");
    Assert(m_a[5] == 0, "memset small no overrun");

    /* memset — large (overlapping ldir), offset start to catch off-by-one */
    for (i = 0; i < 40; i++) m_a[i] = 0;
    r = ms20(m_a + 8);
    Assert(r == (void *)(m_a + 8), "memset large ret = dst");
    Assert(m_a[7] == 0, "memset large no underrun");
    for (i = 8; i < 28; i++) Assert(m_a[i] == 0xCD, "memset large fill");
    Assert(m_a[28] == 0, "memset large no overrun");

    /* memset — large (ldir, N>=256) */
    for (i = 0; i < 300; i++) m_big[i] = 0;
    r = ms280(m_big + 4);
    Assert(r == (void *)(m_big + 4), "memset ldir ret = dst");
    Assert(m_big[3] == 0, "memset ldir no underrun");
    for (i = 4; i < 284; i++) Assert(m_big[i] == 0x5A, "memset ldir fill");
    Assert(m_big[284] == 0, "memset ldir no overrun");

    /* memcpy — small (unrolled) */
    for (i = 0; i < 40; i++) { m_a[i] = 0; m_b[i] = (unsigned char)(i + 1); }
    r = mc3(m_a, m_b);
    Assert(r == (void *)m_a, "memcpy small ret = dst");
    for (i = 0; i < 3; i++) Assert(m_a[i] == (unsigned char)(i + 1), "memcpy small");
    Assert(m_a[3] == 0, "memcpy small no overrun");

    /* memcpy — large (ldir) */
    for (i = 0; i < 40; i++) m_a[i] = 0;
    r = mc20(m_a + 4, m_b);
    Assert(r == (void *)(m_a + 4), "memcpy large ret = dst");
    Assert(m_a[3] == 0, "memcpy large no underrun");
    for (i = 0; i < 20; i++) Assert(m_a[4 + i] == (unsigned char)(i + 1), "memcpy large");
    Assert(m_a[24] == 0, "memcpy large no overrun");
}

char sbuf[16];

static void test_strinline(void)
{
    char *r;
    int i;

    /* strcpy — copies through the NUL, returns dst */
    for (i = 0; i < 16; i++) sbuf[i] = 0x7e;   /* sentinel */
    r = scpy(sbuf, "hello");
    Assert(r == sbuf, "strcpy ret = dst");
    Assert(sbuf[0]=='h' && sbuf[1]=='e' && sbuf[2]=='l'
        && sbuf[3]=='l' && sbuf[4]=='o', "strcpy bytes");
    Assert(sbuf[5] == 0, "strcpy copies NUL");
    Assert(sbuf[6] == 0x7e, "strcpy stops at NUL");
    r = scpy(sbuf, "");
    Assert(sbuf[0] == 0, "strcpy empty");

    /* strchr — literal char */
    scpy(sbuf, "hello");
    Assert(schr_c(sbuf) == sbuf + 2, "strchr literal found");   /* first 'l' */

    /* strchr — variable char */
    Assert(schr_v(sbuf, 'o') == sbuf + 4, "strchr var found");
    Assert(schr_v(sbuf, 'z') == (char *)0, "strchr var not found");

    /* strchr — search for the NUL terminator */
    Assert(schr_nul(sbuf) == sbuf + 5, "strchr NUL");
}

/* ---- CSE of an array-typed subexpression (backgammon update bug) ---
 * `mv[k].pos` is an int[4] member; used several times it is hoisted by
 * the AST CSE pass. The hoisted "value" is the array's first-element
 * address, so the synthesized temp must decay KIND_ARRAY → pointer (as
 * LICM already did). Before the fix the temp was a KIND_ARRAY local that
 * neither IR build nor the walker could allocate → fatal. */
struct { int pos[4], mov[4]; } mv[3];

int cse_arr_compute(int k)
{
    int n, sum = 0;
    for (n = 0; n < 4; n++) {
        sum += mv[k].pos[n];
        sum += mv[k].pos[n] * mv[k].mov[n];
        sum -= mv[k].mov[n];
    }
    return sum;
}

static void test_cse_array(void)
{
    int i;
    int p[4] = { 2, 3, 5, 7 };
    int m[4] = { 1, 4, 6, 8 };
    for (i = 0; i < 4; i++) { mv[1].pos[i] = p[i]; mv[1].mov[i] = m[i]; }
    Assert(cse_arr_compute(1) == 98, "CSE array-base hoist");
}

/* ---- Byte-width assignment overrun (charbench crc8 miscompile) -----
 * A byte (width-1) local that gets an int-promoted value — via compound
 * assign (`c ^= *p`), plain assign from a wide expr (`c = (...)<<1 ^ k`),
 * or a wide decl init — used to store 2 bytes into the 1-byte slot,
 * clobbering the adjacent local. The fix builds the RHS at natural width
 * and truncates (IR_CONV_TRUNC) into the byte slot. These mirror the
 * crc8_ccitt / schar_mix loops that exposed it. */
unsigned char ro_crc8(unsigned char *d, unsigned int len)
{
    unsigned char c = 0xFFU;
    unsigned char *e = d + len;
    while (d < e) {
        c ^= *d++;                                              /* byte compound-assign */
        c = (c & 0x80U) ? ((unsigned char)(c << 1) ^ 0x07U)
                        : (unsigned char)(c << 1);              /* plain-assign from wide */
    }
    return c;
}

signed char ro_smix(signed char *d, unsigned int len)
{
    signed char acc = -1;
    signed char *e = d + len;
    while (d < e) {
        signed char b = *d++;                                   /* byte decl from deref */
        if (b < 0) acc = (signed char)(acc - b);
        else       acc = (signed char)(acc + b);
        acc = (signed char)((acc << 1) ^ b);
    }
    return acc;
}

static void test_byte_overrun(void)
{
    /* local byte array + a guard local: the overrun used to clobber the
       byte accumulator's neighbour (here the call-result / guard). */
    unsigned char buf[10] = { 0x31,0x41,0x59,0x26,0x53,0x58,0x97,0x93,0x23,0x84 };
    unsigned int guard = 0xBEEF;
    unsigned char crc = ro_crc8(buf, 10);                 /* byte decl from call */
    Assert(guard == 0xBEEF, "byte assign no adjacent-local clobber");
    Assert(crc == 52, "byte crc8 (compound + wide-assign)");
    Assert((unsigned char)ro_smix((signed char *)buf, 10) == 2, "signed byte mix");
}

/* ---- Pointer-increment stride (regex ++test miscompile) -----------
 * `++p` / `p++` on a pointer LOCAL must advance by sizeof(*p), not 1.
 * A bare-local step used to emit IR_INC (+1) regardless of pointee size,
 * so walking a struct array (`++test` over 6-byte structs) read garbage.
 * char* (stride 1) was unaffected, which is why it slipped through. */
struct pstride { int x; int y; int z; };   /* 6 bytes on z80 */
struct pstride ps_arr[4];
int ps_ints[4];

static void test_ptr_stride(void)
{
    struct pstride *p;
    int *q;
    int i, sum;

    for (i = 0; i < 4; i++) { ps_arr[i].x = i + 1; ps_arr[i].y = 99; ps_arr[i].z = 77; }
    for (i = 0; i < 4; i++) ps_ints[i] = (i + 1) * 10;

    /* struct* pre-increment (the exact regex shape) */
    p = ps_arr; sum = 0;
    for (i = 0; i < 4; i++) { sum += p->x; ++p; }
    Assert(sum == 10, "struct* pre-increment stride");   /* 1+2+3+4 */

    /* struct* post-increment */
    p = ps_arr; sum = 0;
    for (i = 0; i < 4; i++) { sum += p->x; p++; }
    Assert(sum == 10, "struct* post-increment stride");

    /* int* increment — stride 2 (was also +1 before the fix) */
    q = ps_ints; sum = 0;
    for (i = 0; i < 4; i++) { sum += *q; ++q; }
    Assert(sum == 100, "int* increment stride");          /* 10+20+30+40 */
}

static void test_ctrlflow(void)
{
    int arr[5];
    arr[0]=10; arr[1]=20; arr[2]=30; arr[3]=40; arr[4]=50;

    cf_count_to(7);   Assert(cf_counter == 7, "void return in while(1)");
    cf_count_for(13); Assert(cf_counter == 13, "void return in for(;;)");
    Assert(cf_find(arr, 5, 30) == 2,  "value return in for (found)");
    Assert(cf_find(arr, 5, 99) == -1, "value return in for (not found)");
}

static void test_add(void)
{
    Assert(long_add_vv(0x12345678L, 0x9abc0001L) == (long)0xacf05679L, "add 1");
    Assert(long_add_vv(0xfffffffeL, 0x00000003L) == 0x00000001L,         "add overflow");
    Assert(long_add_vv(0x00010000L, 0x00010000L) == 0x00020000L,         "add carry");
    Assert(long_add_vc(0x00000001L) == 0x11223345L,                       "add vc");
}

static void test_sub(void)
{
    Assert(long_sub_vv(0xacf05679L, 0x9abc0001L) == 0x12345678L,         "sub 1");
    Assert(long_sub_vv(0x00000001L, 0x00000003L) == (long)0xfffffffeL,   "sub borrow");
    Assert(long_sub_vc(0x11223345L) == 0x00000001L,                       "sub vc");
}

static void test_bitwise(void)
{
    Assert(long_and_vv(0xffff0000L, 0x0000ffffL) == 0x00000000L,         "and 1");
    Assert(long_and_vv(0xa5a5a5a5L, 0x5a5a5a5aL) == 0x00000000L,         "and 2");
    Assert(long_and_vv(0xa5a5a5a5L, 0xa5a5a5a5L) == (long)0xa5a5a5a5L,   "and 3");
    Assert(long_and_vc(0x12345678L) == 0x12005600L,                       "and vc");
    Assert(long_or_vv(0x12340000L, 0x00005678L) == 0x12345678L,           "or 1");
    Assert(long_or_vc(0x12340000L) == 0x12ff00ffL,                        "or vc");
    Assert(long_xor_vv(0xa5a5a5a5L, 0x5a5a5a5aL) == (long)0xffffffffL,   "xor 1");
    Assert(long_xor_vc(0x55555555L) == (long)0xffffffffL,                "xor vc");
}

static void test_unary(void)
{
    Assert(long_not(0x00000000L)         == (long)0xffffffffL, "not 1");
    Assert(long_not((long)0xaaaaaaaaL)   == 0x55555555L,        "not 2");
    Assert(long_neg(0x00000001L)         == (long)0xffffffffL, "neg 1");
    Assert(long_neg(0x80000000L)         == (long)0x80000000L, "neg 2");
}

static void test_compound(void)
{
    Assert(long_compound(0x12345678L, (long)0x9abcdef0L, 0x11223344L,
                          0x55667788L, (long)0x99aabbccL)
           == (long)0xcc7146f1L, "compound");
}

static void test_casts(void)
{
    Assert(long_cast_uchar(0xab)         == 0x000000abL,        "uchar→long");
    Assert(long_cast_schar((signed char)-1)
                                         == (long)0xffffffffL, "schar→long");
    Assert(long_cast_uint(0xabcd)        == 0x0000abcdL,       "uint→long");
    Assert(long_cast_sint(-1)            == (long)0xffffffffL, "sint→long");
    Assert(int_cast_long(0x12345678L)    == (int)0x5678,        "long→int");
    Assert(uchar_cast_long(0x12345678L)  == 0x78,               "long→uchar");
}

static void test_ff_one(void)
{
    long buf[4] = { 0x12345678L, (long)0x9abcdef0L,
                     0x11223344L, 0x55667788L };
    long in_val = (long)0x99aabbccL;
    long ret = long_ff_one(buf, &in_val);
    /* Recompute on host:
         a = 0x12345678
         b = 0x9abcdef0
         c = 0x11223344
         d = 0x55667788
         in = 0x99aabbcc
         a += ((b&c)|(~b&d)) + *in + 0x11223344
         a = (a<<7)|(a>>25)
         a += b
       (host C does this; we'll bake the expected value below.) */
    Assert(ret == (long)0xcc7946f9L, "ff_one_ret");
    Assert(buf[0] == (long)0xdead9d71L, "ff_one_buf0");
}

static void test_big_bb(void)
{
    /* Hand-computed:
         a = 0x12345678, b = 0xaabbccdd, c = 0x5a5a5a5a, d = 0x00010001
         ~a = 0xedcba987
         a & b = 0x02304458
         ~a & c = 0x48181a02
         t1 = (a&b) | (~a&c) = 0x4a385e5a
         t2 = t1 + d = 0x4a395e5b
         t3 = t2 + 0x11223344 = 0x5b5b919f
         t4 = t3 ^ a = 0x496fc7e7
         t5 = t4 << 5 = (0x496fc7e7 << 5) = 0x2DF8FCE0 (truncated to 32 bits)
                       Full: 0x92DF8FCE0, low 32 = 0x2DF8FCE0
         t4 >> 27 = 0x496fc7e7 >> 27 = 0x9 (0100 1001 0110 1111 ... >> 27 = 9)
         t6 = t5 | (t4 >> 27) = 0x2DF8FCE9
         result = t6 + b = 0x2DF8FCE9 + 0xaabbccdd = 0xd8b4c9c6
    */
    Assert(long_big_bb(0x12345678L, (long)0xaabbccddL,
                        0x5a5a5a5aL, 0x00010001L)
           == (long)0xdfe109c6L, "big bb");
}

static void test_shifts(void)
{
    Assert(long_shl_1(0x80000001L)  == (long)0x00000002L,                "shl 1");
    Assert(long_shl_8(0x000000ffL)  == 0x0000ff00L,                       "shl 8");
    Assert(long_shl_16(0x0000ffffL) == (long)0xffff0000L,                "shl 16");
    Assert(long_shl_24(0x000000ffL) == (long)0xff000000L,                "shl 24");
    Assert(long_shl_5(0x00000003L)  == 0x00000060L,                       "shl 5");

    Assert(long_shr_1 (0xff000000L) == 0x7f800000L,                       "shr 1");
    Assert(long_shr_8 (0xff000000L) == 0x00ff0000L,                       "shr 8");
    Assert(long_shr_16(0xff000000L) == 0x0000ff00L,                       "shr 16");
    Assert(long_shr_24(0xff000000L) == 0x000000ffL,                       "shr 24");
    Assert(long_shr_27(0x80000000L) == 0x00000010L,                       "shr 27");
}

/* ---- _Float16 (math16) IR helper-call lowering --------------------
   Each does ONE _Float16 op so the IR emits the l_f16_* helper call
   (left pushed, right in HL, result HL). Requires --math16 at link.
   f16bits() takes the address of its param -> bails to the walker,
   yielding a reinterpret of the result's raw IEEE-half bits without an
   f16->int conversion (not yet lowered in the IR). */
_Float16 f16_add (_Float16 a, _Float16 b) { return a + b; }
_Float16 f16_sub (_Float16 a, _Float16 b) { return a - b; }
_Float16 f16_mul (_Float16 a, _Float16 b) { return a * b; }
_Float16 f16_div (_Float16 a, _Float16 b) { return a / b; }
_Float16 f16_expr(_Float16 a, _Float16 b, _Float16 c) { return a * b - c; }
/* int<->_Float16 conversions (l_f16_*2f / l_f16_f2*) — IR-lowered. */
int      f16_to_i (_Float16 x) { return (int)x; }
long     f16_to_l (_Float16 x) { return (long)x; }
_Float16 i_to_f16 (int x)      { return (_Float16)x; }
_Float16 l_to_f16 (long x)     { return (_Float16)x; }
/* _Float16 comparisons (l_f16_{lt,le,gt,ge,eq,ne}) — IR-lowered, each
   returns the int bool (0/1) in HL. f16_pick exercises a compare as an
   `if` condition. */
int f16_lt  (_Float16 a, _Float16 b) { return a <  b; }
int f16_le  (_Float16 a, _Float16 b) { return a <= b; }
int f16_gt  (_Float16 a, _Float16 b) { return a >  b; }
int f16_ge  (_Float16 a, _Float16 b) { return a >= b; }
int f16_eq  (_Float16 a, _Float16 b) { return a == b; }
int f16_ne  (_Float16 a, _Float16 b) { return a != b; }
int f16_pick(_Float16 a, _Float16 b) { if (a < b) return 111; return 222; }
_Float16 f16_neg(_Float16 a) { return -a; }   /* sign-bit XOR */
/* compound-assign across local / *ptr / global LHS shapes */
_Float16 gf16;
_Float16 f16_caddl(_Float16 a, _Float16 b) { a += b; return a; }
_Float16 f16_cmull(_Float16 a, _Float16 b) { a *= b; return a; }
void     f16_csubp(_Float16 *p, _Float16 b) { *p -= b; }
void     f16_caddg(_Float16 b) { gf16 += b; }

/* ---- width-4 double (l_f32_*, only under --math32 / -fp-mode=ieee;
   otherwise these bail to the walker and still compute correctly) ---- */
double d_add (double a, double b) { return a + b; }
double d_sub (double a, double b) { return a - b; }
double d_mul (double a, double b) { return a * b; }
double d_div (double a, double b) { return a / b; }
int    d_lt  (double a, double b) { return a <  b; }
int    d_eq  (double a, double b) { return a == b; }
double i_to_d(int x)  { return (double)x; }
double l_to_d(long x) { return (double)x; }
int    d_to_i(double x) { return (int)x; }
long   d_to_l(double x) { return (long)x; }
double d_caddl(double a, double b) { a += b; return a; }
double d_cdivl(double a, double b) { a /= b; return a; }
double d_id  (double a)           { return a; }            /* param->return */
double d_id2 (double a, double b) { return b; }            /* 2nd of 2 params */
double gd6;
double d_locrt (double a, double b) { double x; x = a; x = x + b; return x; }
double d_globrt(double a)           { gd6 = a; return gd6; }
double d_ptrrt (double *p, double a){ *p = a; return *p; }
double d_litc  (void)               { return 2.5; }         /* double literal (pool @ 6-byte) */

/* ---- long long (width-8 __i64_acc, IR acc-int tier) ----------------
 * Wide call & return use the stuffed-pointer ABI (Phase 2), so each
 * helper keeps `long long` internal — int/long in, int/long out — and
 * is fully IR-native. Exercises l_i64_* arith/compare/convert + the
 * shared IR_ACC_* layer (acc holds RHS, address-in-BC store). */
int  ll_add (int a, int b) { long long x = a, y = b; return (int)(x + y); }
int  ll_sub (int a, int b) { return (int)((long long)a - (long long)b); }
int  ll_mul (int a, int b) { return (int)((long long)a * (long long)b); }
int  ll_div (int a, int b) { return (int)((long long)a / (long long)b); }
int  ll_mod (int a, int b) { return (int)((long long)a % (long long)b); }
int  ll_and (int a, int b) { return (int)((long long)a & (long long)b); }
int  ll_or  (int a, int b) { return (int)((long long)a | (long long)b); }
int  ll_xor (int a, int b) { return (int)((long long)a ^ (long long)b); }
int  ll_lt  (int a, int b) { return (long long)a <  (long long)b; }
int  ll_le  (int a, int b) { return (long long)a <= (long long)b; }
int  ll_gt  (int a, int b) { return (long long)a >  (long long)b; }
int  ll_ge  (int a, int b) { return (long long)a >= (long long)b; }
int  ll_eq  (int a, int b) { return (long long)a == (long long)b; }
int  ll_ne  (int a, int b) { return (long long)a != (long long)b; }
int  ll_ult (unsigned a, unsigned b)
                           { return (unsigned long long)a < (unsigned long long)b; }
/* genuine 64-bit: 100000*100000 = 1e10; /1e6 = 10000 (a 32-bit-truncated
 * product would give 1410065408/1e6 = 1410). */
int  ll_big (void)         { long long x = 100000; x = x * x; return (int)(x / 1000000); }
/* named local reassign — exercises the wide ll MOV / slot path */
int  ll_locrt(int a, int b){ long long x = a; x = x * (long long)b; return (int)x; }
/* long -> ll -> long, through a >16-bit value (slong2i64 / s64_toi32) */
long ll_lrt (long a)       { long long x = a; return (long)(x + 1); }

/* Phase 2 — long long crossing the call boundary (stuffed-pointer return,
 * wide stack-push args). These are fully IR-native (ll params + returns). */
long long ll_passthru(long long x)            { return x; }          /* ll param + ll return */
long long ll_addll  (long long a, long long b){ return a + b; }      /* 2 ll args + ll return */
long long ll_litbig (void)                    { return 1000000000LL; }/* ll literal (32-bit) */
long long ll_litpool(void)                    { return 10000000000LL; }/* >32-bit literal (pool) */
int  ll_shl (int a, int n) { return (int)((long long)a << n); }      /* l_i64_asl */
int  ll_shr (int a, int n) { return (int)((long long)a >> n); }      /* l_i64_asr */
/* 64-bit round-trip shift (variable count, no const-fold): a<<40>>40 = a */
int  ll_shlr(int a, int sh){ long long x = a; return (int)((x << sh) >> sh); }
unsigned ll_ushr(int sh)   { long long x = -1; return (unsigned)((unsigned long long)x >> sh); }
int  ll_neg1(void)         { long long x = -1; return (int)x; }      /* negative ll literal sign-extend */
int  ll_cshl(int a, int n) { long long x = a; x <<= n; return (int)x; }      /* compound <<= */
int  ll_cushr(int n) { unsigned long long x = 0xFFFFFFFFFFFFFFFFULL; x >>= n; return (unsigned)x; } /* compound unsigned >>= */

/* Build/read _Float16 from raw IEEE-half bits (no double->f16 convert,
   so the test needs only --math16, not the default-double library). */
static _Float16 mkf16(unsigned bits) { _Float16 x; *(unsigned short *)&x = (unsigned short)bits; return x; }
static unsigned f16bits(_Float16 x)  { return *(unsigned short *)&x; }

static void test_float16(void)
{
    _Float16 a = mkf16(0x4200);   /* 3.0 */
    _Float16 b = mkf16(0x4400);   /* 4.0 */
    _Float16 two = mkf16(0x4000); /* 2.0 */
    Assert(f16bits(f16_add(a, b))       == 0x4700u, "f16 3+4=7");
    Assert(f16bits(f16_sub(a, b))       == 0xBC00u, "f16 3-4=-1");
    Assert(f16bits(f16_mul(a, b))       == 0x4A00u, "f16 3*4=12");
    Assert(f16bits(f16_div(b, two))     == 0x4000u, "f16 4/2=2");
    Assert(f16bits(f16_expr(a, b, two)) == 0x4900u, "f16 3*4-2=10");
    /* int<->_Float16 conversions */
    Assert(f16bits(i_to_f16(5))     == 0x4500u, "int 5 -> f16 5.0");
    Assert(f16bits(i_to_f16(-3))    == 0xC200u, "int -3 -> f16 -3.0");
    Assert(f16bits(l_to_f16(7L))    == 0x4700u, "long 7 -> f16 7.0");
    Assert(f16_to_i(mkf16(0x4700))  == 7,       "f16 7.0 -> int 7");
    Assert(f16_to_i(mkf16(0xC500))  == -5,      "f16 -5.0 -> int -5");
    Assert(f16_to_l(mkf16(0x4A00))  == 12L,     "f16 12.0 -> long 12");
    Assert(f16_to_i(f16_mul(a, b))  == 12,      "3*4 -> int 12");
    Assert(f16_to_i(i_to_f16(-9))   == -9,      "int->f16->int -9");
    /* comparisons (3.0 vs 4.0) — exact 0/1 results */
    Assert(f16_lt(a, b) == 1, "f16 3<4");
    Assert(f16_lt(b, a) == 0, "f16 !(4<3)");
    Assert(f16_le(a, a) == 1, "f16 3<=3");
    Assert(f16_gt(b, a) == 1, "f16 4>3");
    Assert(f16_ge(a, a) == 1, "f16 3>=3");
    Assert(f16_eq(a, a) == 1, "f16 3==3");
    Assert(f16_eq(a, b) == 0, "f16 !(3==4)");
    Assert(f16_ne(a, b) == 1, "f16 3!=4");
    Assert(f16_pick(a, b) == 111, "f16 if a<b");
    Assert(f16_pick(b, a) == 222, "f16 if !(a<b)");
    /* unary negate (sign-bit flip): -3.0 = 0xC200, -(-3.0)=3.0 */
    Assert(f16bits(f16_neg(a))          == 0xC200u, "f16 -(3.0)");
    Assert(f16bits(f16_neg(mkf16(0xC200))) == 0x4200u, "f16 -(-3.0)");
    /* compound-assign: local, *ptr, global */
    Assert(f16bits(f16_caddl(a, b)) == 0x4700u, "f16 a+=b -> 7");
    Assert(f16bits(f16_cmull(a, b)) == 0x4A00u, "f16 a*=b -> 12");
    {
        _Float16 v = mkf16(0x4700);   /* 7.0 */
        f16_csubp(&v, b);             /* 7 - 4 = 3 */
        Assert(f16bits(v) == 0x4200u, "f16 *p-=b -> 3");
    }
    gf16 = mkf16(0x4200);             /* 3.0 */
    f16_caddg(b);                     /* 3 + 4 = 7 */
    Assert(f16bits(gf16) == 0x4700u, "f16 g+=b -> 7");
}

static void test_double(void)
{
    /* Verified through int<->double conversions so no bit-pattern math
       is needed; exercises l_f32_* arith, compare, and conversions. */
    Assert(d_to_i(d_id(i_to_d(7)))   == 7, "dbl id param->ret");
    Assert(d_to_i(d_id2(i_to_d(3), i_to_d(9))) == 9, "dbl id2 2nd param");
    Assert(d_to_i(d_add(i_to_d(3), i_to_d(4)))  == 7,  "dbl 3+4=7");
    Assert(d_to_i(d_sub(i_to_d(3), i_to_d(4)))  == -1, "dbl 3-4=-1");
    Assert(d_to_i(d_mul(i_to_d(3), i_to_d(4)))  == 12, "dbl 3*4=12");
    Assert(d_to_i(d_div(i_to_d(20), i_to_d(4))) == 5,  "dbl 20/4=5");
    Assert(d_lt(i_to_d(3), i_to_d(4)) == 1,            "dbl 3<4");
    Assert(d_lt(i_to_d(4), i_to_d(3)) == 0,            "dbl !(4<3)");
    Assert(d_eq(i_to_d(5), i_to_d(5)) == 1,            "dbl 5==5");
    Assert(d_to_l(d_add(l_to_d(100000L), l_to_d(1L))) == 100001L, "dbl 1e5+1");
    Assert(d_to_l(l_to_d(70000L)) == 70000L, "dbl->long 70000");
    Assert(d_to_l(i_to_d(-5))     == -5L,    "dbl->long -5");
    Assert(d_to_i(i_to_d(-9)) == -9,                   "dbl int rt -9");
    Assert(d_to_i(d_caddl(i_to_d(3), i_to_d(4)))  == 7, "dbl a+=b -> 7");
    Assert(d_to_i(d_cdivl(i_to_d(20), i_to_d(4))) == 5, "dbl a/=b -> 5");
    Assert(d_to_i(d_locrt(i_to_d(3), i_to_d(4)))  == 7, "dbl local x=a;x=x+b");
    Assert(d_to_i(d_globrt(i_to_d(5)))            == 5, "dbl global g=a");
    {
        double pv;
        Assert(d_to_i(d_ptrrt(&pv, i_to_d(8)))    == 8, "dbl *p=a");
    }
    Assert(d_to_i(d_add(d_litc(), d_litc())) == 5, "dbl literal 2.5+2.5=5");
}

static void test_longlong(void)
{
    /* All helpers keep long long internal (int/long boundary) — verified
       through int<->ll conversions so no 64-bit literal math is needed. */
    Assert(ll_add(3, 4)   == 7,   "ll 3+4=7");
    Assert(ll_add(-3, -4) == -7,  "ll -3+-4=-7 (sign-extend)");
    Assert(ll_sub(3, 4)   == -1,  "ll 3-4=-1");
    Assert(ll_mul(6, 7)   == 42,  "ll 6*7=42");
    Assert(ll_div(20, 4)  == 5,   "ll 20/4=5");
    Assert(ll_div(-20, 3) == -6,  "ll -20/3=-6 (signed)");
    Assert(ll_mod(20, 7)  == 6,   "ll 20%7=6");
    Assert(ll_and(0x0f, 0x33) == 0x03, "ll &");
    Assert(ll_or (0x0f, 0x30) == 0x3f, "ll |");
    Assert(ll_xor(0x0f, 0x33) == 0x3c, "ll ^");
    Assert(ll_lt(3, 4)    == 1,   "ll 3<4");
    Assert(ll_lt(-5, 3)   == 1,   "ll -5<3 (signed)");
    Assert(ll_lt(4, 3)    == 0,   "ll !(4<3)");
    Assert(ll_le(4, 4)    == 1,   "ll 4<=4");
    Assert(ll_gt(5, 3)    == 1,   "ll 5>3");
    Assert(ll_ge(3, 4)    == 0,   "ll !(3>=4)");
    Assert(ll_eq(5, 5)    == 1,   "ll 5==5");
    Assert(ll_ne(5, 6)    == 1,   "ll 5!=6");
    Assert(ll_ult(1, 2)   == 1,   "ll 1<2 (unsigned)");
    Assert(ll_big()       == 10000, "ll 1e5*1e5/1e6=1e4 (64-bit product)");
    Assert(ll_locrt(7, 6) == 42,  "ll local x=a;x=x*b");
    Assert(ll_lrt(70000L) == 70001L, "ll long->ll->long 70000+1");
    /* Phase 2: stuffed-pointer return + wide-arg call boundary. */
    Assert((int)ll_passthru((long long)12345) == 12345, "ll passthru param+ret");
    Assert((int)ll_addll((long long)100, (long long)200) == 300, "ll args a+b=300");
    Assert((int)(ll_litbig() / 100000LL) == 10000, "ll literal 1e9/1e5=1e4");
    Assert((int)ll_addll(ll_passthru((long long)7), (long long)35) == 42, "ll nested call");
    Assert(ll_shl(3, 4)   == 48, "ll 3<<4=48");
    Assert(ll_shr(160, 2) == 40, "ll 160>>2=40");
    Assert(ll_shlr(5, 40) == 5,  "ll 5<<40>>40=5 (64-bit shift)");
    Assert(ll_ushr(60)    == 15, "ll (u)-1>>60=15 (logical)");
    Assert(ll_neg1()      == -1, "ll x=-1 sign-extend");
    Assert(ll_cshl(3, 4)  == 48, "ll x<<=4 -> 48");
    Assert(ll_cushr(60)   == 15, "ll x>>=60 (u) -> 15");
    Assert((int)(ll_litpool() / 1000000000LL) == 10, "ll >32-bit literal pool 1e10/1e9");
}

int suite_long_ir(void)
{
    suite_setup("long IR ops");
    suite_add_test(test_add);
    suite_add_test(test_sub);
    suite_add_test(test_bitwise);
    suite_add_test(test_unary);
    suite_add_test(test_shifts);
    suite_add_test(test_compound);
    suite_add_test(test_casts);
    suite_add_test(test_ff_one);
    suite_add_test(test_big_bb);
    suite_add_test(test_meminline);
    suite_add_test(test_strinline);
    suite_add_test(test_cse_array);
    suite_add_test(test_byte_overrun);
    suite_add_test(test_ptr_stride);
    suite_add_test(test_ctrlflow);
    suite_add_test(test_float16);
    suite_add_test(test_double);
    suite_add_test(test_longlong);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    res += suite_long_ir();
    exit(res);
}
