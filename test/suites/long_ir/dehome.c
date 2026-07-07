/* General DE-home co-design (default-on; IR_NO_DE_HOME opts out). In fp mode an
 * inlined integer binary search keeps a loop-carried NON-accumulate word (lo or
 * hi) resident in the DE pair across the whole loop, instead of a frame slot.
 * The region is kept DE-clean by: the (ix+d) byte-wise compare fold (loop test +
 * the v==key / v<key value compares), an `add hl,de` for the home-operand add
 * (mid = lo + hi), `ld hl,base; add hl,bc` for the indexed deref (table[mid]),
 * and `ex de,hl` for the home-def (hi = mid - 1 / lo = mid + 1).
 *
 * Each kernel is a distinct shape variation that the allocator homes in DE:
 *   bs_int   — hi is the home (hi = mid-1), signed bound, stride-2 int deref
 *   bs_lo    — flipped operand order (mid = hi+lo) so lo can be the home
 *   bs_uns   — unsigned array + unsigned compare
 *   bs_short — short (16-bit) element, signed
 * The asserts are width-independent (indices/returns fit 16-bit), so the sp
 * build (feature inert — it is fp-only) validates the ordinary path too. The
 * checksum is host-verified. Correctness traps: reading the home from e/d in
 * place, the `ex de,hl` home-def re-establishing DE, and the deref recomputed
 * from BC (`add hl,bc`) rather than clobbering DE. */
#include "test.h"

static int      dh_ai[128];
static unsigned dh_au[128];
static short    dh_as[128];

static int bs_int(int key)
{
    int lo = 0, hi = 127;
    while (lo <= hi) { int m = (lo + hi) >> 1; int v = dh_ai[m];
        if (v == key) return m; if (v < key) lo = m + 1; else hi = m - 1; }
    return -1;
}
static int bs_lo(int key)
{
    int lo = 0, hi = 127;
    while (lo <= hi) { int m = (hi + lo) >> 1; int v = dh_ai[m];
        if (v < key) lo = m + 1; else if (v > key) hi = m - 1; else return m; }
    return -1;
}
static int bs_uns(unsigned key)
{
    int lo = 0, hi = 127;
    while (lo <= hi) { int m = (lo + hi) >> 1; unsigned v = dh_au[m];
        if (v == key) return m; if (v < key) lo = m + 1; else hi = m - 1; }
    return -1;
}
static int bs_short(int key)
{
    int lo = 0, hi = 127;
    while (lo <= hi) { int m = (lo + hi) >> 1; int v = dh_as[m];
        if (v == key) return m; if (v < key) lo = m + 1; else hi = m - 1; }
    return -1;
}

static void test_de_home(void)
{
    int i;
    unsigned chk = 0;
    for (i = 0; i < 128; i++) {
        dh_ai[i] = i * 3 - 100;
        dh_au[i] = (unsigned)(i * 7u + 3u);
        dh_as[i] = (short)(i * 2 - 50);
    }
    for (i = -200; i < 500; i += 3) {
        chk = (unsigned)((chk * 31u + (unsigned)(bs_int(i) + 1)) & 0xffffu);
        chk = (unsigned)((chk * 31u + (unsigned)(bs_lo(i) + 1)) & 0xffffu);
    }
    for (i = 0; i < 1000; i += 7)
        chk = (unsigned)((chk * 31u + (unsigned)(bs_uns((unsigned)i) + 1)) & 0xffffu);
    for (i = -100; i < 300; i += 3)
        chk = (unsigned)((chk * 31u + (unsigned)(bs_short(i) + 1)) & 0xffffu);
    Assert(chk == 12235u, "DE-home binary-search checksum (host-verified)");
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("General DE-home binary search");
    suite_add_test(test_de_home);
    return suite_run();
}
