/* [IR_SLOTADDR] sp-mode slot-address reuse, widened from byte to WORD accesses.
 *
 * In sp mode a frame slot is addressed by `ld hl,nn / add hl,sp` (4 bytes) and
 * the two-byte walk that follows (`ld e,(hl) / inc hl / ld d,(hl)`) leaves HL
 * on the slot's HIGH byte. The lowerer now publishes that as an address belief
 * (cache_hl_addr_off) and consumes an in-range one with inc/dec hl, for the
 * word load/store paths as well as the byte ones.
 *
 * Two ways this goes wrong, and what pins each:
 *
 *  - adjacent    consecutive word slots read and written in sequence, which is
 *                what the reuse fires on. An off-by-one in the published
 *                offset (publishing the BASE where the walk ended on base+1,
 *                or vice versa) makes a later access read or write the wrong
 *                slot — a silent wrong answer, not a crash.
 *  - spanning    the same shape with a CALL and a branch between the accesses.
 *                A call clobbers HL, so the belief must be dropped; if it
 *                survives, the inc/dec walk starts from garbage. This is the
 *                half that must NOT fire.
 *  - wide_gap    slots further apart than the reuse cap (3, and 1 on gbz80).
 *                Must fall back to the full recompute; a cap that is too wide
 *                emits a long inc chain that is both bigger and wrong if the
 *                intervening distance was mis-derived.
 *  - byteword    byte and word accesses to the same frame interleaved, so the
 *                byte path (which already had the cache) and the newly-widened
 *                word path share one belief. A width confusion shows here.
 *
 * Self-verifying against constants computed the same way in 16-bit arithmetic,
 * no printf (it perturbs allocation and can mask exactly this class of bug).
 */
#include "test.h"

/* Derived independently, by mirroring each function in 16-bit modular
   arithmetic — NOT read back from this compiler's own output, or a
   consistently-wrong result would match itself. */
#define adjacent_expect 0x946eu
#define spanning_expect 0x6387u
#define wide_gap_expect 0x9857u
#define byteword_expect 0x12d9u

static unsigned int g_sink;
static unsigned int bump(unsigned int x) { g_sink += x; return x + 1u; }

/* Enough live words to force real frame slots rather than registers. */
static unsigned int adjacent(unsigned int seed)
{
    unsigned int a = seed, b = seed + 1u, c = seed + 2u, d = seed + 3u;
    unsigned int e = seed + 4u, f = seed + 5u, g = seed + 6u, h = seed + 7u;
    unsigned int i;
    for (i = 0; i < 4u; i++) {
        a += b; b += c; c += d; d += e;
        e += f; f += g; g += h; h += a;
    }
    return (unsigned int)(a ^ b ^ c ^ d ^ e ^ f ^ g ^ h);
}

/* A call between the accesses: the belief must not survive it. */
static unsigned int spanning(unsigned int seed)
{
    unsigned int a = seed, b = seed + 1u, c = seed + 2u, d = seed + 3u;
    unsigned int e = seed + 4u, f = seed + 5u, g = seed + 6u, h = seed + 7u;
    unsigned int i;
    for (i = 0; i < 3u; i++) {
        a += b;
        c = bump(c);            /* clobbers HL */
        d += e;
        if (a & 1u) f += g; else g += f;
        h = bump(h);
        b += h; e += c; g += d;
    }
    return (unsigned int)(a ^ b ^ c ^ d ^ e ^ f ^ g ^ h);
}

/* Slots deliberately far apart, so the reuse must decline. */
static unsigned int wide_gap(unsigned int seed)
{
    unsigned int v[12];
    unsigned int i, r = 0;
    for (i = 0; i < 12u; i++) v[i] = (unsigned int)(seed + i * 7u);
    /* touch opposite ends, alternating, so no two consecutive accesses are near */
    for (i = 0; i < 6u; i++) {
        v[i] += v[11u - i];
        v[11u - i] ^= v[i];
    }
    for (i = 0; i < 12u; i++) r = (unsigned int)(r * 3u + v[i]);
    return r;
}

/* Byte and word slots interleaved: the byte path already used the cache. */
static unsigned int byteword(unsigned int seed)
{
    unsigned char p = (unsigned char)seed, q = (unsigned char)(seed >> 3);
    unsigned int  x = seed + 11u, y = seed + 22u;
    unsigned char r = (unsigned char)(seed >> 5);
    unsigned int  i;
    for (i = 0; i < 5u; i++) {
        x += p; p = (unsigned char)(p + q);
        y ^= x; q = (unsigned char)(q + r);
        r = (unsigned char)(r + (unsigned char)y);
        x = (unsigned int)(x + r);
    }
    return (unsigned int)(x ^ y ^ p ^ q ^ r);
}

/* [carry] The belief must not outlive the HL it describes. A caller wrapping a
 * slot access in `push hl ... pop hl` to PRESERVE HL, or an `ex de,hl`, both
 * destroy the address while leaving the belief behind; the cross-BB carry then
 * walks it into a branch target as `inc/dec hl` on a garbage base. Reduced from
 * maskbench's bsearch_masked, where it first showed (three WRONG cells on vm1
 * in BENCH_MATRIX) — but it reproduces on z80, 8080, z180 and rabbit too, and
 * the whole long_ir suite passed 716/716 in BOTH frame modes with it present. */
#define NT 64
static int tab[NT];

static int bsearch_masked(int key, int mask)
{
    int lo = 0, hi = NT - 1;
    while (lo <= hi) {
        int mid = (lo + hi) >> 1;
        int v = tab[mid] & mask;
        if (v == key) return mid;
        if (v < key) lo = mid + 1;
        else         hi = mid - 1;
    }
    return -1;
}

static int carry_drive(void)
{
    int q, got, bad = 0, chk = 0;
    for (q = 0; q < NT; q++) tab[q] = q * 3;
    for (q = 0; q < NT; q++) {
        got = bsearch_masked(q * 3, 0x7ff);
        if (got != q) bad = 1;
        chk = chk + got;
    }
    if (bsearch_masked(1, 0x7ff) != -1) bad = 1;
    return bad ? -1 : chk;
}

static void test_slotaddr(void)
{
    assertEqual(adjacent(0x1234u), adjacent_expect);
    assertEqual(spanning(0x1234u), spanning_expect);
    assertEqual(wide_gap(0x1234u), wide_gap_expect);
    assertEqual(byteword(0x1234u), byteword_expect);
    assertEqual(carry_drive(), (NT * (NT - 1)) / 2);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("sp-mode slot address reuse (word paths)");
    suite_add_test(test_slotaddr);
    return suite_run();
}
