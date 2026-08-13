/* Reduction write-back DE-home (fp; IR_NO_DECLEAN opts out). A reduction loop
 * that keeps a running sum in the DE pair while ALSO writing a function of that
 * sum back into the array each iteration (`a[i] = f(s)`) — the in-place transform
 * idiom (checksums-with-history, running normalisation, prefix scans, the
 * structbench struct-field walk). The write-back previously reverted the DE-home
 * (a word store stages the value through DE), spilling the sum to a TOS slot with
 * a per-field push/pop. Two DE-clean write-backs keep the sum resident:
 *   - a plain store of the sum / a slot value  (try_de_home_clean_store): address
 *     in HL from the BC/remat base, value from E/D or its slot via A.
 *   - a masked store `a[i] = s & K`  (fused mask+store): the mask op emits
 *     nothing and the store reads the sum from E/D, applies the const op through
 *     A, and writes it — the masked value never rides HL.
 *
 * Shapes: single-field and 3-field (struct) sums, plain / AND-masked / OR /
 * XOR write-backs. All 16-bit-masked so the checksum is width-independent; the
 * sp build (feature inert — fp-only) validates the ordinary path. Host-verified.
 * Traps: reading the sum from e/d in place, the fused mask not double-storing,
 * and the base recomputed from BC (`ld hl,bc`) rather than clobbering DE. */
#include "test.h"

#define RN 64
static unsigned rw_a[RN];
static int      rw_b[RN];
struct rw_pt { int x, y, z; };
static struct rw_pt rw_s[RN];

/* Single-field sum, plain write-back: a[i] = running sum. */
static unsigned red_plain(int n)
{
    unsigned s = 0; int i;
    for (i = 0; i < n; i++) { s = (s + rw_a[i]) & 0xffffu; rw_a[i] = s; }
    return s;
}
/* Single-field sum, AND-masked write-back: a[i] = s & 0x7fff. */
static unsigned red_mask(int n)
{
    unsigned s = 0; int i;
    for (i = 0; i < n; i++) { s = (s + rw_a[i]) & 0xffffu; rw_a[i] = s & 0x7fffu; }
    return s;
}
/* Single-field sum, OR-masked write-back: a[i] = s | 1. */
static unsigned red_or(int n)
{
    unsigned s = 0; int i;
    for (i = 0; i < n; i++) { s = (s + rw_a[i]) & 0xffffu; rw_a[i] = s | 1u; }
    return s;
}
/* Signed array, XOR write-back: b[i] = s ^ 0x55aa. */
static unsigned red_xor(int n)
{
    unsigned s = 0; int i;
    for (i = 0; i < n; i++) { s = (s + (unsigned)rw_b[i]) & 0xffffu;
                              rw_b[i] = (int)(s ^ 0x55aau); }
    return s;
}
/* 3-field struct walk with masked write-back (the structbench kernel). */
static unsigned red_struct(int n)
{
    unsigned s = 0; int i;
    for (i = 0; i < n; i++) {
        s = (s + (unsigned)rw_s[i].x + (unsigned)rw_s[i].y
               + (unsigned)rw_s[i].z) & 0xffffu;
        rw_s[i].z = (int)(s & 0x7fffu);
    }
    return s;
}

static void test_red_wb(void)
{
    unsigned chk = 0; int i;
    for (i = 0; i < RN; i++) {
        rw_a[i] = (unsigned)(i * 7u + 1u);
        rw_b[i] = i * 3 - 40;
        rw_s[i].x = i;  rw_s[i].y = i * 2 - 5;  rw_s[i].z = i * 3;
    }
    chk = (unsigned)((chk * 31u + red_plain(RN))  & 0xffffu);
    chk = (unsigned)((chk * 31u + rw_a[RN - 1])   & 0xffffu);
    chk = (unsigned)((chk * 31u + red_mask(RN))   & 0xffffu);
    chk = (unsigned)((chk * 31u + rw_a[RN / 2])   & 0xffffu);
    chk = (unsigned)((chk * 31u + red_or(RN))     & 0xffffu);
    chk = (unsigned)((chk * 31u + rw_a[1])        & 0xffffu);
    chk = (unsigned)((chk * 31u + red_xor(RN))    & 0xffffu);
    chk = (unsigned)((chk * 31u + (unsigned)rw_b[RN - 1]) & 0xffffu);
    chk = (unsigned)((chk * 31u + red_struct(RN)) & 0xffffu);
    chk = (unsigned)((chk * 31u + (unsigned)rw_s[RN - 1].z) & 0xffffu);
    Assert(chk == REDWB_CHK, "reduction write-back checksum (host-verified)");
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Reduction write-back DE-home");
    suite_add_test(test_red_wb);
    return suite_run();
}
