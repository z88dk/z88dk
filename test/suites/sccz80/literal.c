#include "test.h"
#include <stdlib.h>

/* Keep these values above the exact-integer range of an IEEE double.  The
   compiler must retain their integer bits until the expression is lowered. */
static const long long literal_static = 0x1234567800000000LL;
static const unsigned long long literal_unsigned_static = 0xfedcba9876543210ULL;
static const unsigned long long literal_expression_static =
    (0x0100000000000000ULL | 0xff);

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

int suite_literal(void)
{
    suite_setup("Integer Literal Tests");
    suite_add_test(test_literal_storage);
    suite_add_test(test_literal_folding);
    suite_add_test(test_literal_compare);
    return suite_run();
}

int main(void)
{
    return suite_literal();
}
