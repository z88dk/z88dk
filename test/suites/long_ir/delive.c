/* [de-ret] and [de-call]: DE is not read by every `ret`, nor by every call.
 *
 * instr_effects used to answer YES to both, on two ABI facts that are true only
 * sometimes — the DE:HL long/float result, and an argument register. That one
 * over-claim throttled four rungs at once ([de-park], [ldsi-addr], [ldhi-addr],
 * [z80n-add-a]). Now the answer is per function for the return, and per call
 * target for the call, and this file pins BOTH directions of each.
 *
 * The WIN direction (DE dead, the rung fires) is a size result, measured on the
 * corpus; what a behavioural test can pin is the CONSERVATIVE direction, where
 * dropping a park or a widen pair produces a wrong answer. So every function
 * below that names a register is there because the value in DE has to survive:
 *
 *  - lsum, lmix   the function returns a LONG, so its `ret` really does hand
 *                 back DE:HL. Declare `ret` DE-dead for these and the high word
 *                 comes back as whatever the epilogue left in DE.
 *  - fcl_call     the callee is __z88dk_fastcall with a 4-byte parameter: the
 *                 argument rides DE:HL, so the call READS DE. (depark.c's fcmix
 *                 covers the same arm from the park side.)
 *  - sc1_call     __sdcccall(1) passes the 2nd argument in DE and returns two
 *                 bytes in DE. Both halves are conservative arms of the new
 *                 rules, and both are checked here on the CPUs that have the
 *                 convention.
 *  - fnptr_l      an INDIRECT fastcall with a long argument. Where no index
 *                 register is spare the lowerer dispatches it with a `ret` that
 *                 is a JUMP to the callee, with the argument sitting in DE —
 *                 the one `ret` in a function that is not a return at all
 *                 (xf_ret_dispatch keeps the whole function conservative).
 *
 * And the plain direction, where the new rules do fire and the answers must not
 * move: isum/imix return ints through frame-word loads (the 8085 park shape),
 * and they call stacked-ABI helpers, which take nothing in DE.
 *
 * `--opt-disable=de-ret,de-call` restores the old answers; delive_8085_keep is
 * that build, and it must agree with delive_8085 on every value.
 *
 * NOT pinned here, and deliberately said so: __preserves_regs(d,e) on a call
 * target. It is the third way a call can make DE matter, it is handled
 * (ci->preserved marks the target dirty), and no C definition in this tree can
 * express a callee that actually honours it — so the guard rests on the
 * emitter's own flag, not on a test.
 */
#include "test.h"

static unsigned int  g_w[6];
static unsigned long g_l;
static unsigned int  g_calls;

/* --- stacked-ABI helpers: nothing rides DE into these ------------------- */
static unsigned int add3(unsigned int a, unsigned int b, unsigned int c)
{
    g_calls++;
    return (unsigned int)(a + b + c);
}

static unsigned int mix2(unsigned int a, unsigned int b)
{
    return (unsigned int)((a << 3) ^ b);
}

/* --- the firing shape: an int return over frame-word loads -------------- */
static unsigned int isum(unsigned int a, unsigned int b, unsigned int c,
                         unsigned int d)
{
    unsigned int t1 = (unsigned int)(a + b);
    unsigned int t2 = (unsigned int)(c ^ d);
    unsigned int t3 = (unsigned int)(t1 | t2);
    unsigned int t4 = (unsigned int)(t2 + d);
    return (unsigned int)(t1 + t2 + t3 + t4);
}

/* The same, with a stacked call in the middle: DE is dead into add3, so the
   park around the slot load that follows it is droppable. */
static unsigned int imix(unsigned int a, unsigned int b, unsigned int c)
{
    unsigned int t1 = (unsigned int)(a + b);
    unsigned int t2 = add3(a, b, c);
    unsigned int t3 = mix2(t1, t2);
    return (unsigned int)(t1 + t2 + t3 + c);
}

/* --- the conservative arm: a LONG return really is DE:HL ---------------- */
static unsigned long lsum(unsigned int a, unsigned int b)
{
    return (unsigned long)a * 65536UL + (unsigned long)b;
}

/* A long return with word work in front of it, so the epilogue is reached with
   the pair genuinely live. */
static unsigned long lmix(unsigned int a, unsigned int b, unsigned int c)
{
    unsigned int t = (unsigned int)(a + b + c);
    unsigned long r = lsum(t, (unsigned int)(a ^ c));
    return r + (unsigned long)b;
}

/* --- the conservative arm: a fastcall long argument rides DE:HL --------- */
static unsigned long fcl(unsigned long v) __z88dk_fastcall
{
    return v + 0x00010001UL;
}

static unsigned long fcl_call(unsigned int hi, unsigned int lo)
{
    unsigned long v = (unsigned long)hi * 65536UL + (unsigned long)lo;
    return fcl(v) + fcl(v + 1UL);
}

/* --- the conservative arm: an indirect fastcall long argument ----------- */
static unsigned long (*g_fp)(unsigned long) __z88dk_fastcall = fcl;

static unsigned long fnptr_l(unsigned int hi, unsigned int lo)
{
    unsigned long v = (unsigned long)hi * 65536UL + (unsigned long)lo;
    return g_fp(v);
}

#if defined(__CPU_Z80__) || defined(__CPU_Z180__) || defined(__CPU_Z80N__) \
    || defined(__CPU_KC160__)
#define HAVE_SC1 1
/* __sdcccall(1): the 2nd argument is in DE and a 2-byte result comes back in
   DE. Both are conservative arms of the new rules. */
static int sc1_sub(int a, int b) __sdcccall(1);
static int sc1_sub(int a, int b) __sdcccall(1) { return a - b; }

static int sc1_call(int a, int b, int c)
{
    return sc1_sub(a, b) + sc1_sub(b, c) + sc1_sub(a, c);
}
#endif

static void test_delive(void)
{
    g_calls = 0;

    assertEqual(isum(1u, 2u, 4u, 8u), 50u);
    assertEqual(isum(0x1234u, 0x0011u, 0xF0F0u, 0x0F0Fu), 0x2151u);

    assertEqual(imix(3u, 5u, 7u), 109u);
    assertEqual(imix(100u, 200u, 300u), 4072u);
    assertEqual(g_calls, 2u);

    g_l = lsum(0x1234u, 0x5678u);
    assertEqual((unsigned int)(g_l >> 16), 0x1234u);
    assertEqual((unsigned int)g_l, 0x5678u);

    g_l = lmix(0x0102u, 0x0304u, 0x0506u);
    assertEqual((unsigned int)(g_l >> 16), 0x090Cu);
    assertEqual((unsigned int)g_l, 0x0708u);

    g_l = fcl_call(0x0001u, 0xFFFFu);
    assertEqual((unsigned int)(g_l >> 16), 0x0006u);
    assertEqual((unsigned int)g_l, 0x0001u);

    g_l = fnptr_l(0x00FFu, 0xFFFFu);
    assertEqual((unsigned int)(g_l >> 16), 0x0101u);
    assertEqual((unsigned int)g_l, 0x0000u);

    g_w[0] = isum(9u, 9u, 9u, 9u);
    g_w[1] = imix(9u, 9u, 9u);
    assertEqual((unsigned int)(g_w[0] + g_w[1]), 238u);

#ifdef HAVE_SC1
    assertEqual((unsigned int)sc1_call(100, 40, 7), 186u);
    assertEqual((unsigned int)sc1_call(0, 0, 0), 0u);
#endif
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("DE liveness at a return and at a call");
    suite_add_test(test_delive);
    return suite_run();
}
