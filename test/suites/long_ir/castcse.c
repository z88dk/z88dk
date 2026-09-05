/* Two casts of the SAME subexpression to DIFFERENT types are NOT the same
 * expression.
 *
 * A cast's value is its target type, but nodes_equivalent() compared only the
 * operand for OP_CAST, so `(unsigned char)(v >> 3)` and `(unsigned int)(v >> 3)`
 * looked identical and ast_cse replaced the second with the FIRST — the wider
 * read came back truncated to the narrower one's 8 bits (207 instead of 35535).
 * Exactly the bfcse.c bug one node type along: same operand, different width.
 *
 * IT ONLY BITES WHEN BOTH CASTS APPEAR IN ONE FUNCTION. Either cast alone is
 * correct, because ast_cse needs a second occurrence to fold against — a
 * single-cast version of this test passes with the bug present.
 *
 * Covered here: narrow-then-wide and wide-then-narrow (order must not matter),
 * a signedness-only difference at equal width, and a long destination. All
 * arithmetic is masked so the checksums hold on a 16-bit-int target.
 * --opt-disable=cse also masks it.
 */
#include "test.h"

static unsigned long src = 0x12345678UL;
static unsigned int  seed = 0xBEEFu;

/* Narrow cast first, then the wide one: the wide read must NOT inherit the
   byte. 0x12345678>>3 = 0x02468ACF -> byte 0xCF, word 0x8ACF. */
static unsigned int narrow_then_wide(void)
{
    unsigned long v = src;
    unsigned char b = (unsigned char)(v >> 3);
    unsigned int  w = (unsigned int)(v >> 3);
    return (unsigned int)((w ^ (unsigned int)b) & 0xffffu);   /* 0x8ACF ^ 0xCF */
}

/* Wide cast first: the narrow one must not inherit the word either. */
static unsigned int wide_then_narrow(void)
{
    unsigned long v = src;
    unsigned int  w = (unsigned int)(v >> 5);
    unsigned char b = (unsigned char)(v >> 5);
    return (unsigned int)((w ^ (unsigned int)b) & 0xffffu);
}

/* Same WIDTH, different signedness — the type test must look past size alone.
   0xBEEF's low byte is 0xEF: as unsigned 239, as signed -17. */
static int sign_differs(void)
{
    unsigned int x = seed;
    unsigned char u = (unsigned char)(x & 0xffu);
    signed char   s = (signed char)(x & 0xffu);
    return (int)u + (int)s;                       /* 239 + (-17) = 222 */
}

/* A long destination beside an int one, same operand. */
static unsigned int long_and_int(void)
{
    unsigned int x = seed;
    unsigned long l = (unsigned long)(x >> 4);    /* 0x0BEE */
    unsigned int  i = (unsigned int)(x >> 4);     /* 0x0BEE */
    return (unsigned int)((l & 0xffffUL) ^ (unsigned long)i);  /* 0 */
}

/* The single-cast control: correct even with the bug present, so a pass here
   proves nothing on its own — it pins that the fix did not break the plain case. */
static unsigned int single_cast(void)
{
    unsigned long v = src;
    return (unsigned int)(v >> 3);                /* 0x8ACF */
}

static void test_castcse(void)
{
    assertEqual(narrow_then_wide(), 0x8ACFu ^ 0xCFu);
    assertEqual(wide_then_narrow(), 0xA2B3u ^ 0xB3u);
    assertEqual((unsigned int)sign_differs(), 222u);
    assertEqual(long_and_int(), 0u);
    assertEqual(single_cast(), 0x8ACFu);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Cast-type CSE equivalence");
    suite_add_test(test_castcse);
    return suite_run();
}
