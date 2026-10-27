/* Constant conversion on a 16-bit int.
 * An unsuffixed decimal that does not fit in signed int is long.
 * Signed overflow wraps in the result type, then a wider conversion
 * sign-extends. Unsigned widens by zero-extension. Division and
 * remainder convert both operands to that type first. A long argument
 * stays a long: default promotions do not narrow it.
 */
#include "test.h"
#include <stdio.h>
#include <string.h>

#define BUFFER_SIZE    16384
#define MAINBANK_ADDR  (65536 - BUFFER_SIZE * 2)

static unsigned int take_u(unsigned int x) { return x; }
static long take_l(long x) { return x; }
static long take_fast(int n, long v) __z88dk_fastcall { return v + n; }

static void expect(const char *got, const char *want, const char *msg)
{
    Assert(strcmp(got, want) == 0, (char *)msg);
}

void test_constpush(void)
{
    char buf[40];
    unsigned int n = 1000;
    long widened = MAINBANK_ADDR;

    Assert((long)(16384 * 2) == -32768L, "wrapped int sign-extends to long");
    Assert((65536 - 16384 * 2) == 98304L, "long minus wrapped int");
    Assert((1L + (3 - 5)) == -1L, "fitted negative widens signed");
    Assert((1L + (int)-1) == 0L, "cast negative widens signed");
    Assert((1L + (16384 * 2)) == -32767L, "add of wrapped int");
    Assert((long)(32767 + 1) == -32768L, "32767+1 wraps");
    Assert((long)32768 == 32768L, "decimal 32768 is long");
    Assert((long)0x8000 == 32768L, "hex 0x8000 is unsigned int");
    Assert((int)0x8000 < 0, "int cast of 0x8000 wraps negative");
    Assert((long)(signed char)200 == -56L, "signed char wraps");
    Assert((1L + (signed char)200) == -55L, "promoted signed char");
    Assert((1L + (unsigned char)200) == 201L, "promoted unsigned char");
    Assert((1L + 200) == 201L, "decimal 200 stays int");
    Assert((16384 * 2) < 0, "wrapped product is negative");
    Assert((long)((16384 * 2) / 2) == -16384L, "signed division of the wrap");
    Assert((long)(-(16384 * 2)) == -32768L, "negation of the wrap wraps again");
    Assert((long)((16384 * 2) >> 1) == -16384L, "arithmetic shift of the wrap");
    Assert((unsigned long)-1 == 4294967295UL, "unsigned long keeps all bits");
    Assert((long)32768U == 32768L, "32768U zero-extends to long");

    /* The operation runs in the common type. char promotes to signed int.
       An unsigned count does not change a signed right shift. */
    Assert((long)(-1 / 2u) == 32767L, "-1 / 2u");
    Assert((long)(-1 / 1u) == 65535L, "-1 / 1u");
    Assert((long)((16384 * 2) / 2u) == 16384L, "wrapped product / 2u");
    Assert((long)(-3 % 2u) == 1L, "-3 % 2u");
    Assert((long)((16384 * 2) % 3u) == 2L, "wrapped product % 3u");
    Assert((-1L) / 0x8000 == 0L, "(-1L) / 0x8000");
    Assert((long)((unsigned char)200 / (signed char)-2) == -100L, "promoted char division");
    Assert((-3 % 2) == -1, "signed remainder keeps the sign");
    Assert((1L + (-1 / 1u)) == 65536L, "unsigned quotient widens by zero");
    Assert((-1L) + 0x8000 == 32767L, "signed long plus 0x8000");
    Assert(((-2L) + 1u) < 0, "signed long plus unsigned int stays signed");
    Assert((-1L) < 1u, "(-1L) < 1u");
    Assert((-1L) < 0x8000, "(-1L) < 0x8000");
    Assert((long)((16384 * 2) >> 1u) == -16384L, "unsigned shift count stays arithmetic");
    Assert(((int)-1 >> 1u) == -1, "signed >> unsigned count");
    Assert(((unsigned char)200 >> 1) == 100, "unsigned char promotes before >>");
    Assert(((signed char)0x80 >> 1) == -64, "signed char >> stays arithmetic");
    Assert(((unsigned char)1 << 8) == 256, "unsigned char promotes before <<");
    Assert(((signed char)0x80 << 1) == -256, "signed char << promotes");
    Assert(((signed char)-2 / (unsigned char)2) == -1, "promoted char / unsigned char");
    Assert(((unsigned char)200 * (signed char)-2) == -400, "promoted char multiply");
    Assert((long)(200 * 200) == -25536L, "signed 200*200 wraps");
    Assert((long)(200u * 200u) == 40000L, "unsigned 200u*200u zero-extends");
    Assert((-1L) / 1UL == 4294967295UL, "(-1L) / 1UL");
    Assert((int)-1 / 2UL == 2147483647UL, "(int)-1 / 2UL");
    Assert(((unsigned long)-1 >> 1) == 2147483647UL, "logical >> of unsigned long");
    Assert(((unsigned long)-1 >> 1u) == 2147483647UL, "logical >> of unsigned long by unsigned");

    sprintf(buf, "%ld", (long)MAINBANK_ADDR);
    expect(buf, "98304", "%ld of 65536 - 16384*2");

    sprintf(buf, "%ld", (long)(65536 - 1));
    expect(buf, "65535", "%ld of 65536 - 1");

    sprintf(buf, "%ld", (long)(65536 - 65537));
    expect(buf, "-1", "%ld of 65536 - 65537");

    sprintf(buf, "%ld %ld", MAINBANK_ADDR, 1L);
    expect(buf, "98304 1", "a long beside 1L");

    sprintf(buf, "%ld", 65536L - 32768);
    expect(buf, "32768", "65536L - 32768, and 32768 is already long");

    sprintf(buf, "%ld", 1L);
    expect(buf, "1", "1L stays a long");

    sprintf(buf, "%lu", 65536);
    expect(buf, "65536", "65536 is a long");

    sprintf(buf, "%ld", 0 - 65536);
    expect(buf, "-65536", "0 - 65536");

    sprintf(buf, "%lu", 65536 - n);
    expect(buf, "64536", "a runtime subtraction is not folded early");

    sprintf(buf, "%u", (unsigned)MAINBANK_ADDR);
    expect(buf, "32768", "cast to unsigned int keeps the low 16 bits");

    sprintf(buf, "%u", 0x8000);
    expect(buf, "32768", "0x8000 is unsigned int");

    sprintf(buf, "%ld", (long)0x8000);
    expect(buf, "32768", "(long)0x8000 zero-extends");

    sprintf(buf, "%u", 32768U);
    expect(buf, "32768", "32768U stays unsigned int");

    sprintf(buf, "%ld", 32768);
    expect(buf, "32768", "decimal 32768 is pushed as long");

    sprintf(buf, "%ld", 40000);
    expect(buf, "40000", "decimal 40000 is pushed as long");

    sprintf(buf, "%ld", 65535);
    expect(buf, "65535", "decimal 65535 is pushed as long");

    sprintf(buf, "%ld", (long)(16384 * 2));
    expect(buf, "-32768", "(long) of the wrapped product");

    sprintf(buf, "%ld", (long)((16384 * 2) / 2));
    expect(buf, "-16384", "(long) of the wrapped quotient");

    sprintf(buf, "%ld", (long)(-(16384 * 2)));
    expect(buf, "-32768", "(long) of the wrapped negation");

    sprintf(buf, "%ld", (long)((16384 * 2) >> 1));
    expect(buf, "-16384", "(long) of the arithmetic shift");

    sprintf(buf, "%ld", 1L + (int)-1);
    expect(buf, "0", "1L + (int)-1");

    sprintf(buf, "%ld", 1L + (3 - 5));
    expect(buf, "-1", "1L + (3 - 5)");

    sprintf(buf, "%ld", 1L + (int)(3 - 5));
    expect(buf, "-1", "1L + (int)(3 - 5)");

    sprintf(buf, "%ld", 1L + (16384 * 2));
    expect(buf, "-32767", "1L + wrapped product");

    sprintf(buf, "%ld", (long)(32767 + 1));
    expect(buf, "-32768", "(long)(32767 + 1)");

    sprintf(buf, "%ld", (long)32768);
    expect(buf, "32768", "(long)32768");

    sprintf(buf, "%ld", (long)(signed char)200);
    expect(buf, "-56", "(long)(signed char)200");

    sprintf(buf, "%ld", 1L + (signed char)200);
    expect(buf, "-55", "1L + (signed char)200");

    sprintf(buf, "%lu", (unsigned long)-1);
    expect(buf, "4294967295", "(unsigned long)-1");

    Assert(take_u(MAINBANK_ADDR) == 32768, "prototype unsigned int narrows");
    Assert(take_l(MAINBANK_ADDR) == 98304L, "prototype long keeps 98304");
    Assert(widened == 98304L, "assignment to long keeps 98304");
    Assert(take_fast(1, MAINBANK_ADDR) == 98305L, "fastcall long stays 32 bits");
}

int suite_constpush(void)
{
    suite_setup("Const conversion");
    suite_add_test(test_constpush);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_constpush();
    exit(res);
}
