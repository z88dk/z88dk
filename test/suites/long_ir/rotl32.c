/* 32-bit ROTATE_LEFT lowering (IR_ROTL, ir_lower_ops.inc.c gen_rotl).
 *
 * The lowering is a byte permutation of D/E/H/L (rot 8 / 16 / 24) plus up to
 * four single-bit rotates in whichever direction is shorter -- so a rotate by
 * 7 becomes "permute by 8, then rotate RIGHT one bit", and the wrapped bit is
 * the part that is easy to get wrong.
 *
 * The right-hand single-bit step used to shift the bit out and branch to put
 * it back (srl d / ... / jr nc,+2 / set 7,d). It now SEEDS the carry with
 * bit0 of L before the chain (ld a,l / rrca / rr d / ...), which is 2 bytes
 * shorter and branchless. This test pins that both directions still wrap
 * correctly for every rotate amount, since an off-by-one in the seed or a
 * dropped wrap bit is invisible on most inputs.
 *
 * Vectors are chosen so a lost wrap bit cannot hide: C = 1 puts a single set
 * bit at the bottom (it must appear at the top for any right step), B has the
 * MSB set, A is asymmetric across all four bytes.
 *
 * 8080/8085 are excluded from the fusion (ir_match.c rotl exclude_cpus -- no
 * CB-prefix shifts), so there the same expressions lower via the shift
 * helpers; this test covers that path too.
 *
 * Values are passed through a function so they stay runtime operands: a
 * constant argument would be folded and the lowering never exercised.
 * Self-verifying against constants computed off-target. No printf.
 */
#include "test.h"

typedef unsigned long u32;

#define ROTATE_LEFT(x, n)  (((x) << (n)) | ((x) >> (32 - (n))))
#define ROTATE_RIGHT(x, n) (((x) >> (n)) | ((x) << (32 - (n))))

static u32 l01(u32 x) { return ROTATE_LEFT(x, 1); }
static u32 l02(u32 x) { return ROTATE_LEFT(x, 2); }
static u32 l03(u32 x) { return ROTATE_LEFT(x, 3); }
static u32 l04(u32 x) { return ROTATE_LEFT(x, 4); }
static u32 l05(u32 x) { return ROTATE_LEFT(x, 5); }
static u32 l06(u32 x) { return ROTATE_LEFT(x, 6); }
static u32 l07(u32 x) { return ROTATE_LEFT(x, 7); }
static u32 l08(u32 x) { return ROTATE_LEFT(x, 8); }
static u32 l09(u32 x) { return ROTATE_LEFT(x, 9); }
static u32 l10(u32 x) { return ROTATE_LEFT(x, 10); }
static u32 l11(u32 x) { return ROTATE_LEFT(x, 11); }
static u32 l12(u32 x) { return ROTATE_LEFT(x, 12); }
static u32 l13(u32 x) { return ROTATE_LEFT(x, 13); }
static u32 l14(u32 x) { return ROTATE_LEFT(x, 14); }
static u32 l15(u32 x) { return ROTATE_LEFT(x, 15); }
static u32 l16(u32 x) { return ROTATE_LEFT(x, 16); }
static u32 l17(u32 x) { return ROTATE_LEFT(x, 17); }
static u32 l18(u32 x) { return ROTATE_LEFT(x, 18); }
static u32 l19(u32 x) { return ROTATE_LEFT(x, 19); }
static u32 l20(u32 x) { return ROTATE_LEFT(x, 20); }
static u32 l21(u32 x) { return ROTATE_LEFT(x, 21); }
static u32 l22(u32 x) { return ROTATE_LEFT(x, 22); }
static u32 l23(u32 x) { return ROTATE_LEFT(x, 23); }
static u32 l24(u32 x) { return ROTATE_LEFT(x, 24); }
static u32 l25(u32 x) { return ROTATE_LEFT(x, 25); }
static u32 l26(u32 x) { return ROTATE_LEFT(x, 26); }
static u32 l27(u32 x) { return ROTATE_LEFT(x, 27); }
static u32 l28(u32 x) { return ROTATE_LEFT(x, 28); }
static u32 l29(u32 x) { return ROTATE_LEFT(x, 29); }
static u32 l30(u32 x) { return ROTATE_LEFT(x, 30); }
static u32 l31(u32 x) { return ROTATE_LEFT(x, 31); }

static u32 r01(u32 x) { return ROTATE_RIGHT(x, 1); }
static u32 r05(u32 x) { return ROTATE_RIGHT(x, 5); }
static u32 r07(u32 x) { return ROTATE_RIGHT(x, 7); }
static u32 r08(u32 x) { return ROTATE_RIGHT(x, 8); }
static u32 r12(u32 x) { return ROTATE_RIGHT(x, 12); }
static u32 r15(u32 x) { return ROTATE_RIGHT(x, 15); }
static u32 r16(u32 x) { return ROTATE_RIGHT(x, 16); }
static u32 r17(u32 x) { return ROTATE_RIGHT(x, 17); }
static u32 r23(u32 x) { return ROTATE_RIGHT(x, 23); }
static u32 r24(u32 x) { return ROTATE_RIGHT(x, 24); }
static u32 r31(u32 x) { return ROTATE_RIGHT(x, 31); }

static void test_rotl32(void)
{
    /* vector A = 0x12345678 */
    Assert(l01(0x12345678UL) == 0x2468ACF0UL, "rotl1 A");
    Assert(l02(0x12345678UL) == 0x48D159E0UL, "rotl2 A");
    Assert(l03(0x12345678UL) == 0x91A2B3C0UL, "rotl3 A");
    Assert(l04(0x12345678UL) == 0x23456781UL, "rotl4 A");
    Assert(l05(0x12345678UL) == 0x468ACF02UL, "rotl5 A");
    Assert(l06(0x12345678UL) == 0x8D159E04UL, "rotl6 A");
    Assert(l07(0x12345678UL) == 0x1A2B3C09UL, "rotl7 A");
    Assert(l08(0x12345678UL) == 0x34567812UL, "rotl8 A");
    Assert(l09(0x12345678UL) == 0x68ACF024UL, "rotl9 A");
    Assert(l10(0x12345678UL) == 0xD159E048UL, "rotl10 A");
    Assert(l11(0x12345678UL) == 0xA2B3C091UL, "rotl11 A");
    Assert(l12(0x12345678UL) == 0x45678123UL, "rotl12 A");
    Assert(l13(0x12345678UL) == 0x8ACF0246UL, "rotl13 A");
    Assert(l14(0x12345678UL) == 0x159E048DUL, "rotl14 A");
    Assert(l15(0x12345678UL) == 0x2B3C091AUL, "rotl15 A");
    Assert(l16(0x12345678UL) == 0x56781234UL, "rotl16 A");
    Assert(l17(0x12345678UL) == 0xACF02468UL, "rotl17 A");
    Assert(l18(0x12345678UL) == 0x59E048D1UL, "rotl18 A");
    Assert(l19(0x12345678UL) == 0xB3C091A2UL, "rotl19 A");
    Assert(l20(0x12345678UL) == 0x67812345UL, "rotl20 A");
    Assert(l21(0x12345678UL) == 0xCF02468AUL, "rotl21 A");
    Assert(l22(0x12345678UL) == 0x9E048D15UL, "rotl22 A");
    Assert(l23(0x12345678UL) == 0x3C091A2BUL, "rotl23 A");
    Assert(l24(0x12345678UL) == 0x78123456UL, "rotl24 A");
    Assert(l25(0x12345678UL) == 0xF02468ACUL, "rotl25 A");
    Assert(l26(0x12345678UL) == 0xE048D159UL, "rotl26 A");
    Assert(l27(0x12345678UL) == 0xC091A2B3UL, "rotl27 A");
    Assert(l28(0x12345678UL) == 0x81234567UL, "rotl28 A");
    Assert(l29(0x12345678UL) == 0x02468ACFUL, "rotl29 A");
    Assert(l30(0x12345678UL) == 0x048D159EUL, "rotl30 A");
    Assert(l31(0x12345678UL) == 0x091A2B3CUL, "rotl31 A");

    /* vector B = 0x9E3779B9 */
    Assert(l01(0x9E3779B9UL) == 0x3C6EF373UL, "rotl1 B");
    Assert(l02(0x9E3779B9UL) == 0x78DDE6E6UL, "rotl2 B");
    Assert(l03(0x9E3779B9UL) == 0xF1BBCDCCUL, "rotl3 B");
    Assert(l04(0x9E3779B9UL) == 0xE3779B99UL, "rotl4 B");
    Assert(l05(0x9E3779B9UL) == 0xC6EF3733UL, "rotl5 B");
    Assert(l06(0x9E3779B9UL) == 0x8DDE6E67UL, "rotl6 B");
    Assert(l07(0x9E3779B9UL) == 0x1BBCDCCFUL, "rotl7 B");
    Assert(l08(0x9E3779B9UL) == 0x3779B99EUL, "rotl8 B");
    Assert(l09(0x9E3779B9UL) == 0x6EF3733CUL, "rotl9 B");
    Assert(l10(0x9E3779B9UL) == 0xDDE6E678UL, "rotl10 B");
    Assert(l11(0x9E3779B9UL) == 0xBBCDCCF1UL, "rotl11 B");
    Assert(l12(0x9E3779B9UL) == 0x779B99E3UL, "rotl12 B");
    Assert(l13(0x9E3779B9UL) == 0xEF3733C6UL, "rotl13 B");
    Assert(l14(0x9E3779B9UL) == 0xDE6E678DUL, "rotl14 B");
    Assert(l15(0x9E3779B9UL) == 0xBCDCCF1BUL, "rotl15 B");
    Assert(l16(0x9E3779B9UL) == 0x79B99E37UL, "rotl16 B");
    Assert(l17(0x9E3779B9UL) == 0xF3733C6EUL, "rotl17 B");
    Assert(l18(0x9E3779B9UL) == 0xE6E678DDUL, "rotl18 B");
    Assert(l19(0x9E3779B9UL) == 0xCDCCF1BBUL, "rotl19 B");
    Assert(l20(0x9E3779B9UL) == 0x9B99E377UL, "rotl20 B");
    Assert(l21(0x9E3779B9UL) == 0x3733C6EFUL, "rotl21 B");
    Assert(l22(0x9E3779B9UL) == 0x6E678DDEUL, "rotl22 B");
    Assert(l23(0x9E3779B9UL) == 0xDCCF1BBCUL, "rotl23 B");
    Assert(l24(0x9E3779B9UL) == 0xB99E3779UL, "rotl24 B");
    Assert(l25(0x9E3779B9UL) == 0x733C6EF3UL, "rotl25 B");
    Assert(l26(0x9E3779B9UL) == 0xE678DDE6UL, "rotl26 B");
    Assert(l27(0x9E3779B9UL) == 0xCCF1BBCDUL, "rotl27 B");
    Assert(l28(0x9E3779B9UL) == 0x99E3779BUL, "rotl28 B");
    Assert(l29(0x9E3779B9UL) == 0x33C6EF37UL, "rotl29 B");
    Assert(l30(0x9E3779B9UL) == 0x678DDE6EUL, "rotl30 B");
    Assert(l31(0x9E3779B9UL) == 0xCF1BBCDCUL, "rotl31 B");

    /* vector C = 0x00000001 */
    Assert(l01(0x00000001UL) == 0x00000002UL, "rotl1 C");
    Assert(l02(0x00000001UL) == 0x00000004UL, "rotl2 C");
    Assert(l03(0x00000001UL) == 0x00000008UL, "rotl3 C");
    Assert(l04(0x00000001UL) == 0x00000010UL, "rotl4 C");
    Assert(l05(0x00000001UL) == 0x00000020UL, "rotl5 C");
    Assert(l06(0x00000001UL) == 0x00000040UL, "rotl6 C");
    Assert(l07(0x00000001UL) == 0x00000080UL, "rotl7 C");
    Assert(l08(0x00000001UL) == 0x00000100UL, "rotl8 C");
    Assert(l09(0x00000001UL) == 0x00000200UL, "rotl9 C");
    Assert(l10(0x00000001UL) == 0x00000400UL, "rotl10 C");
    Assert(l11(0x00000001UL) == 0x00000800UL, "rotl11 C");
    Assert(l12(0x00000001UL) == 0x00001000UL, "rotl12 C");
    Assert(l13(0x00000001UL) == 0x00002000UL, "rotl13 C");
    Assert(l14(0x00000001UL) == 0x00004000UL, "rotl14 C");
    Assert(l15(0x00000001UL) == 0x00008000UL, "rotl15 C");
    Assert(l16(0x00000001UL) == 0x00010000UL, "rotl16 C");
    Assert(l17(0x00000001UL) == 0x00020000UL, "rotl17 C");
    Assert(l18(0x00000001UL) == 0x00040000UL, "rotl18 C");
    Assert(l19(0x00000001UL) == 0x00080000UL, "rotl19 C");
    Assert(l20(0x00000001UL) == 0x00100000UL, "rotl20 C");
    Assert(l21(0x00000001UL) == 0x00200000UL, "rotl21 C");
    Assert(l22(0x00000001UL) == 0x00400000UL, "rotl22 C");
    Assert(l23(0x00000001UL) == 0x00800000UL, "rotl23 C");
    Assert(l24(0x00000001UL) == 0x01000000UL, "rotl24 C");
    Assert(l25(0x00000001UL) == 0x02000000UL, "rotl25 C");
    Assert(l26(0x00000001UL) == 0x04000000UL, "rotl26 C");
    Assert(l27(0x00000001UL) == 0x08000000UL, "rotl27 C");
    Assert(l28(0x00000001UL) == 0x10000000UL, "rotl28 C");
    Assert(l29(0x00000001UL) == 0x20000000UL, "rotl29 C");
    Assert(l30(0x00000001UL) == 0x40000000UL, "rotl30 C");
    Assert(l31(0x00000001UL) == 0x80000000UL, "rotl31 C");

    Assert(r01(0x12345678UL) == 0x091A2B3CUL, "rotr1 A");
    Assert(r05(0x12345678UL) == 0xC091A2B3UL, "rotr5 A");
    Assert(r07(0x12345678UL) == 0xF02468ACUL, "rotr7 A");
    Assert(r08(0x12345678UL) == 0x78123456UL, "rotr8 A");
    Assert(r12(0x12345678UL) == 0x67812345UL, "rotr12 A");
    Assert(r15(0x12345678UL) == 0xACF02468UL, "rotr15 A");
    Assert(r16(0x12345678UL) == 0x56781234UL, "rotr16 A");
    Assert(r17(0x12345678UL) == 0x2B3C091AUL, "rotr17 A");
    Assert(r23(0x12345678UL) == 0x68ACF024UL, "rotr23 A");
    Assert(r24(0x12345678UL) == 0x34567812UL, "rotr24 A");
    Assert(r31(0x12345678UL) == 0x2468ACF0UL, "rotr31 A");

    Assert(r01(0x9E3779B9UL) == 0xCF1BBCDCUL, "rotr1 B");
    Assert(r05(0x9E3779B9UL) == 0xCCF1BBCDUL, "rotr5 B");
    Assert(r07(0x9E3779B9UL) == 0x733C6EF3UL, "rotr7 B");
    Assert(r08(0x9E3779B9UL) == 0xB99E3779UL, "rotr8 B");
    Assert(r12(0x9E3779B9UL) == 0x9B99E377UL, "rotr12 B");
    Assert(r15(0x9E3779B9UL) == 0xF3733C6EUL, "rotr15 B");
    Assert(r16(0x9E3779B9UL) == 0x79B99E37UL, "rotr16 B");
    Assert(r17(0x9E3779B9UL) == 0xBCDCCF1BUL, "rotr17 B");
    Assert(r23(0x9E3779B9UL) == 0x6EF3733CUL, "rotr23 B");
    Assert(r24(0x9E3779B9UL) == 0x3779B99EUL, "rotr24 B");
    Assert(r31(0x9E3779B9UL) == 0x3C6EF373UL, "rotr31 B");

    Assert(r01(0x00000001UL) == 0x80000000UL, "rotr1 C");
    Assert(r05(0x00000001UL) == 0x08000000UL, "rotr5 C");
    Assert(r07(0x00000001UL) == 0x02000000UL, "rotr7 C");
    Assert(r08(0x00000001UL) == 0x01000000UL, "rotr8 C");
    Assert(r12(0x00000001UL) == 0x00100000UL, "rotr12 C");
    Assert(r15(0x00000001UL) == 0x00020000UL, "rotr15 C");
    Assert(r16(0x00000001UL) == 0x00010000UL, "rotr16 C");
    Assert(r17(0x00000001UL) == 0x00008000UL, "rotr17 C");
    Assert(r23(0x00000001UL) == 0x00000200UL, "rotr23 C");
    Assert(r24(0x00000001UL) == 0x00000100UL, "rotr24 C");
    Assert(r31(0x00000001UL) == 0x00000002UL, "rotr31 C");

    /* Chained: rotating by n then by 32-n must be the identity, and the
       intermediate is a runtime value so neither step can be folded away. */
    Assert(l25(l07(0x12345678UL)) == 0x12345678UL, "rotl7 then rotl25 == identity");
    Assert(l20(l12(0x9E3779B9UL)) == 0x9E3779B9UL, "rotl12 then rotl20 == identity");
    Assert(r07(l07(0x00000001UL)) == 0x00000001UL, "rotl7 then rotr7 == identity");
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("32-bit rotate lowering (byte permute + bit rotate)");
    suite_add_test(test_rotl32);
    return suite_run();
}
