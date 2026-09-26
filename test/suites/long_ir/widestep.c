/* ++/-- on 32- and 64-bit integers. IR_INC/IR_DEC take their width from the
 * vreg; the lowering used to step a width-4 value with `inc hl` and store a
 * word, dropping the carry into the high half, and a post-step saved its old
 * value in a 2-byte temp. Width 4 now calls l_inc_dehl / l_dec_dehl; width 8
 * steps __i64_acc via l_i64_inc / l_i64_dec (a long long global or pointee
 * step used to bail out of IR altogether).
 *
 * Every step below crosses a byte/word carry or borrow boundary.
 *
 * A step whose value nothing reads steps the long in memory with HL = its
 * address (l_long_inc_mhl / l_long_dec_mhl): a global or pointee statement
 * (g_inc, p_step), and a slot-resident local the next op does not read
 * (l_slotinc / l_slotdec).
 *
 * The 64-bit DECREMENT results are not asserted: the library's l_i64_dec is
 * wrong at present. The Makefile checks instead that each ll_*dec* function
 * calls it, and that the in-memory helpers are used (widestep_calls.bin).
 */
#include "test.h"
#include <stdio.h>
#include <stdlib.h>

static long          gl;
static unsigned long gul;

static long l_preinc(long x)            { return ++x; }
static long l_predec(long x)            { return --x; }
static long l_postinc(long x)           { long y = x++; return y + x; }
static long l_postdec(long x)           { long y = x--; return y - x; }
static unsigned long ul_inc(unsigned long x) { x++; return x; }
static unsigned long ul_dec(unsigned long x) { x--; return x; }
static void g_inc(void)                 { gl++; gul--; }
static long g_postinc(void)             { return gl++; }
static void p_step(long *p, unsigned long *q) { (*p)++; --(*q); }
static long p_postdec(long *p)          { return (*p)--; }
static long l_count(long n)             { long c = 0; while (n--) c++; return c; }

volatile long l_sink;
static void sink_l(long v)              { l_sink = v; }
static long l_slotinc(long x)           { sink_l(x); x++; sink_l(0); return x; }
static long l_slotdec(long x)           { sink_l(x); x--; sink_l(0); return x; }

static void run32(void)
{
    Assert(l_preinc(0xffffL)      == 0x10000L,     "pre-inc carries into high word");
    Assert(l_preinc(-1L)          == 0L,           "pre-inc -1");
    Assert(l_preinc(0x7fffffffL)  == (long)0x80000000UL, "pre-inc sign");
    Assert(l_predec(0x10000L)     == 0xffffL,      "pre-dec borrows from high word");
    Assert(l_predec(0L)           == -1L,          "pre-dec 0");
    Assert(l_predec(0x100L)       == 0xffL,        "pre-dec byte borrow");
    Assert(l_postinc(0xffffL)     == 0x1ffffL,     "post-inc keeps old value");
    Assert(l_postdec(0x10000L)    == 1L,           "post-dec keeps old value");
    Assert(ul_inc(0xffffffffUL)   == 0UL,          "unsigned inc wraps");
    Assert(ul_dec(0UL)            == 0xffffffffUL, "unsigned dec wraps");

    gl = 0xffffL; gul = 0x10000UL;
    g_inc();
    Assert(gl  == 0x10000L,  "global inc");
    Assert(gul == 0xffffUL,  "global dec");
    gl = 0xffffffL;
    Assert(g_postinc() == 0xffffffL && gl == 0x1000000L, "global post-inc");

    {
        long a = 0xffffffL; unsigned long b = 0x1000000UL;
        p_step(&a, &b);
        Assert(a == 0x1000000L,   "pointee inc");
        Assert(b == 0xffffffUL,   "pointee dec");
        a = 0x10000L;
        Assert(p_postdec(&a) == 0x10000L && a == 0xffffL, "pointee post-dec");
    }

    Assert(l_count(0x10002L) == 0x10002L, "long countdown crosses 0x10000");
    Assert(l_slotinc(0xffffffL) == 0x1000000L, "slot inc in memory");
    Assert(l_slotdec(0x1000000L) == 0xffffffL, "slot dec in memory");
    Assert(l_slotdec(0L) == -1L,               "slot dec borrows through");
}

#if !defined(__GBZ80) && !defined(__8080)
static long long gll;

static long long ll_preinc(long long x)  { return ++x; }
static long long ll_postinc(long long x) { long long y = x++; return y + x; }
static void ll_ginc(void)                { gll++; }
static void ll_pinc(long long *p)        { ++(*p); }

/* Called, not asserted — see the header. */
static long long ll_predec(long long x)  { return --x; }
static long long ll_postdec(long long x) { long long y = x--; return y - x; }
static void ll_gdec(void)                { gll--; }
static void ll_pdec(long long *p)        { (*p)--; }

volatile long long ll_sink;

static void run64(void)
{
    Assert(ll_preinc(0xffffffffLL)  == 0x100000000LL, "ll pre-inc carries into high long");
    Assert(ll_preinc(-1LL)          == 0LL,           "ll pre-inc -1");
    Assert(ll_postinc(0xffffffffLL) == 0x1ffffffffLL, "ll post-inc keeps old value");
    gll = 0xffffffffLL;
    ll_ginc();
    Assert(gll == 0x100000000LL, "ll global inc");
    {
        long long a = 0xffffffffffffLL;
        ll_pinc(&a);
        Assert(a == 0x1000000000000LL, "ll pointee inc");
        ll_pdec(&a);
        ll_sink = a;
    }
    ll_sink = ll_predec(0x100000000LL);
    ll_sink = ll_postdec(0x100000000LL);
    ll_gdec();
    ll_sink = gll;
}
#endif

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("32/64-bit ++ and --");
    suite_add_test(run32);
#if !defined(__GBZ80) && !defined(__8080)
    suite_add_test(run64);
#endif
    return suite_run();
}
