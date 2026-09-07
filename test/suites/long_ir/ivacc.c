/* A REASSIGNED value can take a BC home when BC is free over its window.
 *
 * Two BC gates used to leave a hole. bc_home_realizable demands
 * write_count == 1 (write-once); iv_home_realizable demands use_count >= 8
 * (hot). A value written many times and read once per write clears NEITHER, so
 * it landed in a frame slot and paid a round trip per term:
 *
 *     acc = acc + t; acc = acc + u; ...          an accumulator
 *     if (v > 255) v = 255; if (v < 0) v = 0;    a clamp chain
 *
 * The gate now admits such a value when its live range is call-free AND it WINS
 * its contention for BC — it out-earns the best candidate it would displace by
 * 3:1 (IR_IVACC). That puts a MULTIPLY-DEFINED value in BC, so every def has to
 * stamp BC coherently and the slot backing has to stay consistent outside the
 * home — which is what this file checks. The corpus proves the SIZE and TICK
 * wins (-608 B, 29/29 tick cells faster); this proves the VALUES.
 *
 * All three admission paths are exercised here, so a future widening cannot
 * silently break any of them (IR_IVWHY prints which):
 *   sat   no rival at all              -> ADMIT, both frame modes
 *   mix   contended, wins 3.5:1 in fp  -> ADMIT in fp, REFUSED in sp (2.99:1,
 *                                         just under the margin — and sp is
 *                                         exactly where the home cost bytes)
 *   pick  contended, loses             -> REFUSED, both modes
 *
 * Shapes covered: a clamp chain in both orders, a conditional-assignment
 * diamond, an accumulator over mixed-width terms, a reassigned parameter, and
 * a clamp whose result feeds a further reassignment. Every expected value is
 * computed to be independent of int width beyond 16 bits.
 */
#include "test.h"

static int  sbuf[8] = { 0, 7, -3, 100, -128, 127, 64, -64 };
static unsigned char ubuf[8] = { 0, 1, 200, 255, 128, 64, 33, 7 };

/* The predbench `sat` shape: a parameter clamped by a chain of reassignments,
   then a ternary that reassigns again. */
static int sat(int v)
{
    if (v > 255) v = 255;
    if (v < 0)   v = 0;
    return (v < 64) ? 64 : (v > 192 ? 192 : v);
}

/* The same clamps in the opposite order — the low clamp must not undo the
   high one. */
static int sat_rev(int v)
{
    if (v < 0)   v = 0;
    if (v > 255) v = 255;
    return v;
}

/* A conditional-assignment diamond: both arms define the same value, so the
   BC home must be stamped on each path and agree at the merge. */
static int pick(int a, int b)
{
    int r;
    if (a > b) r = a - b;
    else       r = b - a;
    if (r > 50) r = 50;
    return r;
}

/* An accumulator over terms of mixed width — the widthbench mix_char shape. */
static int mix(int k)
{
    int acc = 0;
    acc += sbuf[k & 7];
    acc += ubuf[k & 7];
    acc += (int)(signed char)(ubuf[k & 7] ^ 0x80u);
    acc += (int)(unsigned char)(sbuf[k & 7] + 3);
    return acc;
}

/* A reassigned PARAMETER: its incoming value lives in the caller frame, so a
   register home must not read a stale slot after the first write. */
static unsigned int step(unsigned int p)
{
    p = (unsigned int)(p + 1u);
    p = (unsigned int)(p * 3u);
    p = (unsigned int)(p ^ 0x00ffu);
    return p & 0xffffu;
}

/* A clamp feeding a further reassignment, so the value is live across both. */
static int chain(int v)
{
    int t = sat(v);
    t = t + 1;
    if (t > 100) t = 100;
    return t;
}

static void test_ivacc(void)
{
    /* sat: clamp to [0,255] then to [64,192]. */
    assertEqual(sat(-5),   64);
    assertEqual(sat(0),    64);
    assertEqual(sat(63),   64);
    assertEqual(sat(64),   64);
    assertEqual(sat(100), 100);
    assertEqual(sat(192), 192);
    assertEqual(sat(200), 192);
    assertEqual(sat(300), 192);   /* 300 -> 255 -> 192 */

    assertEqual(sat_rev(-5),   0);
    assertEqual(sat_rev(77),  77);
    assertEqual(sat_rev(300), 255);

    assertEqual(pick(10, 3),   7);
    assertEqual(pick(3, 10),   7);
    assertEqual(pick(200, 3), 50);   /* 197 clamped */

    /* mix, k=1: s=7, u=1, (schar)(1^0x80)=-127, (uchar)(7+3)=10 */
    assertEqual(mix(1), 7 + 1 + (-127) + 10);
    /* k=3: s=100, u=255, (schar)(255^0x80)=127, (uchar)(100+3)=103 */
    assertEqual(mix(3), 100 + 255 + 127 + 103);

    /* step: ((p+1)*3)^0xff, masked to 16 bits. p=1000 -> 3003 -> 3003^255 */
    assertEqual((int)step(1000u), (int)(((1000u + 1u) * 3u) ^ 0x00ffu));
    assertEqual((int)step(0u),    (int)((3u) ^ 0x00ffu));

    assertEqual(chain(-5),   65);   /* sat->64, +1 */
    assertEqual(chain(150), 100);   /* sat->150, +1=151, clamp 100 */
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Reassigned-value BC home (iv-acc)");
    suite_add_test(test_ivacc);
    return suite_run();
}
