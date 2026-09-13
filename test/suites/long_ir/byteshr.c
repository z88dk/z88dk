/* Constant-count byte >> on the CPUs with no CB prefix (ir_lower_cmp.inc.c,
 * gen_shr's byte tail).
 *
 * 8080 and 8085 have neither `srl a` nor `sra a` — 8085's undocumented ARHL is
 * the 16-bit `sra hl` only. `narrow_shr_kind` keeps a NARROWED int off that
 * path, but a natively byte-typed `*p >>= n` arrives with a width-1 dst on
 * every CPU regardless of narrowing, so the lowering emitted an instruction the
 * assembler rejects ("illegal identifier"). It was a build failure rather than
 * a miscompile, and no bench in the corpus reaches the shape.
 *
 * The 808x lowering is:
 *   logical      rrca/rlca + mask (what every CPU has, and 1 byte a step
 *                against `srl a`'s 2)
 *   arithmetic   the bias identity, branchless and clobbering only A:
 *                  sra(a,n) == ((a ^ 0x80) >>logical n) - (0x80 >> n)
 *
 * Exhaustive: all 256 byte values x counts 1..7, signed and unsigned, checked
 * against a 16-bit reference computed in int arithmetic (which never takes the
 * byte path). One assert per count so a failure names the count.
 */
#include "test.h"

static signed char   sbuf[1];
static unsigned char ubuf[1];
static signed char   *sp = sbuf;
static unsigned char *up = ubuf;

/* The shape that breaks is the POINTER read-modify-write: `*p >>= n` reaches
 * gen_shr with a width-1 dst on every CPU, narrowing or not. A plain
 * `static_byte >> n` does NOT — that one goes through ir_opt_narrow_byte, whose
 * narrow_shr_kind already declines for 808x, so it never took the broken path
 * and would not catch a regression here. One function per count so the count is
 * a constant. */
#define MK(n) \
    static void as##n(void) { *sp >>= (n); } \
    static void al##n(void) { *up >>= (n); }
MK(1) MK(2) MK(3) MK(4) MK(5) MK(6) MK(7)

/* Reference in int arithmetic: >> on an int is the 16-bit path, so this is
 * computed by different code from the byte lowering under test. */
static int ref_s(int v, int n) { int x = (int)(signed char)v;   return (int)(signed char)(x >> n); }
static int ref_u(int v, int n) { int x = (int)(unsigned char)v; return (int)(unsigned char)(x >> n); }

static int bad_s[8], bad_u[8];

static void run(void)
{
    int i, n;
    for (n = 0; n < 8; n++) { bad_s[n] = 0; bad_u[n] = 0; }
    for (i = 0; i < 256; i++) {
        sbuf[0] = (signed char)i;   as1(); if ((int)sbuf[0] != ref_s(i, 1)) bad_s[1]++;
        sbuf[0] = (signed char)i;   as2(); if ((int)sbuf[0] != ref_s(i, 2)) bad_s[2]++;
        sbuf[0] = (signed char)i;   as3(); if ((int)sbuf[0] != ref_s(i, 3)) bad_s[3]++;
        sbuf[0] = (signed char)i;   as4(); if ((int)sbuf[0] != ref_s(i, 4)) bad_s[4]++;
        sbuf[0] = (signed char)i;   as5(); if ((int)sbuf[0] != ref_s(i, 5)) bad_s[5]++;
        sbuf[0] = (signed char)i;   as6(); if ((int)sbuf[0] != ref_s(i, 6)) bad_s[6]++;
        sbuf[0] = (signed char)i;   as7(); if ((int)sbuf[0] != ref_s(i, 7)) bad_s[7]++;
        ubuf[0] = (unsigned char)i; al1(); if ((int)ubuf[0] != ref_u(i, 1)) bad_u[1]++;
        ubuf[0] = (unsigned char)i; al2(); if ((int)ubuf[0] != ref_u(i, 2)) bad_u[2]++;
        ubuf[0] = (unsigned char)i; al3(); if ((int)ubuf[0] != ref_u(i, 3)) bad_u[3]++;
        ubuf[0] = (unsigned char)i; al4(); if ((int)ubuf[0] != ref_u(i, 4)) bad_u[4]++;
        ubuf[0] = (unsigned char)i; al5(); if ((int)ubuf[0] != ref_u(i, 5)) bad_u[5]++;
        ubuf[0] = (unsigned char)i; al6(); if ((int)ubuf[0] != ref_u(i, 6)) bad_u[6]++;
        ubuf[0] = (unsigned char)i; al7(); if ((int)ubuf[0] != ref_u(i, 7)) bad_u[7]++;
    }
}

static void test_byteshr(void)
{
    run();
    assertEqual(bad_s[1], 0); assertEqual(bad_u[1], 0);
    assertEqual(bad_s[2], 0); assertEqual(bad_u[2], 0);
    assertEqual(bad_s[3], 0); assertEqual(bad_u[3], 0);
    assertEqual(bad_s[4], 0); assertEqual(bad_u[4], 0);
    assertEqual(bad_s[5], 0); assertEqual(bad_u[5], 0);
    assertEqual(bad_s[6], 0); assertEqual(bad_u[6], 0);
    assertEqual(bad_s[7], 0); assertEqual(bad_u[7], 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Byte >> const on CPUs without the CB shifts");
    suite_add_test(test_byteshr);
    return suite_run();
}
