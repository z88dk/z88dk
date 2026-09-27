#include "test.h"
#include <stdlib.h>

/* Keep these values above the exact-integer range of an IEEE double.  The
   compiler must retain their integer bits until the expression is lowered. */
static const long long literal_static = 0x1234567800000000LL;
static const unsigned long long literal_unsigned_static = 0xfedcba9876543210ULL;
static const unsigned long long literal_expression_static =
    (0x0100000000000000ULL | 0xff);
static const double literal_promotion_static =
    (0x12345678L + 0.0) - 0x12345600L;
static const double literal_promotion_large = 0x12345678L + 0.0;
static const double literal_promotion_nested =
    (0x12345678L * 2.0) - 0x2468acf0L;
static const double literal_promotion_unsigned_wrap =
    (0xffffffffUL + 1UL) + 0.0;
static const double literal_promotion_negative_ll =
    (-0x100000001LL + 0.0) + 0x100000000LL;

void test_literal_storage(void)
{
    long long value = 0x1234567800000000LL;
    unsigned long long unsigned_value = 0xfedcba9876543210ULL;

    Assert(value == 0x1234567800000000LL, "local 64-bit literal");
    Assert(literal_static == 0x1234567800000000LL, "static 64-bit literal");
    Assert(literal_unsigned_static == 0xfedcba9876543210ULL,
           "static unsigned 64-bit literal");
    Assert(literal_expression_static == 0x01000000000000ffULL,
           "static folded 64-bit literal");
    Assert(literal_promotion_static == 120.0,
           "static mixed integer promotion preserves value");
    Assert((literal_promotion_large - 0x12345600L) == 120.0,
           "static mixed promotion preserves large final value");
    Assert(literal_promotion_nested == 0.0,
           "static nested mixed promotion preserves value");
    Assert(literal_promotion_unsigned_wrap == 0.0,
           "static unsigned wrap occurs before promotion");
    Assert(literal_promotion_negative_ll == -1.0,
           "static negative long long promotion preserves value");
    Assert(unsigned_value == 0xfedcba9876543210ULL,
           "unsigned 64-bit literal");
}

void test_literal_folding(void)
{
    Assert((0x1234567800000000LL - 1) == 0x12345677ffffffffLL,
           "64-bit constant subtraction");
    Assert((0x0100000000000000LL | 0xff) == 0x01000000000000ffLL,
           "64-bit constant bitwise or");
    Assert((0x0100000000000000LL >> 8) == 0x0001000000000000LL,
           "64-bit constant shift");
}

void test_literal_compare(void)
{
    long long value = 0x1234567800000000LL;

    Assert(value < 0x1234567800000001LL, "64-bit literal comparison");
    Assert(value != 0x1234567700000000LL, "64-bit literal inequality");
}

void test_literal_promotions(void)
{
    volatile long wide = 0x12345678L;
    volatile long negative = -0x12345678L;
    double mixed;

    Assert(wide + 1L == 0x12345679L, "long promotes integer expression");

    /* Both integer operands must be converted to the target floating type
       from their exact values.  Folding through a float host value rounds
       0x12345678 to 0x12345680 and produces 128 instead of 120. */
    mixed = (0x12345678L + 0.0) - 0x12345600L;
    Assert(mixed == 120.0, "folded integer-to-float promotion preserves value");

    /* The same conversion must also happen at the use site for a value that
       cannot be folded away. */
    mixed = (wide + 0.0) - 0x12345600L;
    Assert(mixed == 120.0, "runtime integer-to-float promotion preserves value");

    mixed = (-305419896L + 0.0) + 305419776L;
    Assert(mixed + 120.0 == 0.0, "signed integer promotion preserves value");

    mixed = (negative + 0.0) + 0x12345600L;
    Assert(mixed + 120.0 == 0.0,
           "signed hexadecimal promotion preserves value");

    Assert((0x12345678L + 0.0) > 0x12345600L,
           "mixed integer comparison preserves value");
}

void test_literal_promotion_edges(void)
{
    volatile long positive = 0x12345678L;
    volatile long negative_hex = -0x12345678L;
    volatile long negative_binary = -0b10010001101000101011001111000L;
    volatile long negative_octal = -02215053170L;
    volatile unsigned long unsigned_wrap = -0xffffffffUL;
    double mixed;

    Assert(negative_hex + 0x12345678L == 0L,
           "negative hexadecimal literal sign");
    Assert(negative_binary + 0x12345678L == 0L,
           "negative binary literal sign");
    Assert(negative_octal + 0x12345678L == 0L,
           "negative octal literal sign");
    Assert(unsigned_wrap == 1UL,
           "unsigned literal unary minus wraps in its type");

    /* Keep the oracle in the exact range of binary32: the source long is
       converted at the target use site, while the nearby hexadecimal value
       is exactly representable by both host zdouble test modes. */
    mixed = (0.0 + positive) - 0x12345600L;
    Assert(mixed == 120.0,
           "reversed signed integer promotion preserves value");

    mixed = (0x12345678L * 2.0) - 0x2468acf0L;
    Assert(mixed == 0.0,
           "multiplication integer promotion preserves value");
    mixed = (0x12345678L / 2.0) - 0x091a2b00L;
    Assert(mixed == 60.0,
           "division integer promotion preserves value");

    mixed = (0x100000001LL + 0.0) - 0x100000000LL;
    Assert(mixed == 1.0,
           "long long integer promotion preserves value");

    mixed = ((0x12345678L + 120L) * 2.0) - 0x2468acf0L;
    Assert(mixed == 240.0,
           "nested integer promotion preserves value");
    mixed = (0xffffffffUL + 1UL) + 0.0;
    Assert(mixed == 0.0,
           "unsigned wrap occurs before runtime promotion");
    mixed = (-0x100000001LL + 0.0) + 0x100000000LL;
    Assert(mixed == -1.0,
           "negative long long promotion preserves value");

}

int suite_literal(void)
{
    suite_setup("Integer Literal Tests");
    suite_add_test(test_literal_storage);
    suite_add_test(test_literal_folding);
    suite_add_test(test_literal_compare);
    suite_add_test(test_literal_promotions);
    suite_add_test(test_literal_promotion_edges);
    return suite_run();
}

int main(void)
{
    return suite_literal();
}
