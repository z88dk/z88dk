/* Issue #321. A folded long that fits in 16 bits is pushed as an int
 * on an untyped slot. An L suffix or a cast to long stays a long.
 * A value outside -32768..65535 stays a long. A runtime long stays a long.
 */
#include "test.h"
#include <stdio.h>
#include <string.h>

#define BUFFER_SIZE    16384
#define MAINBANK_ADDR  (65536 - BUFFER_SIZE * 2)

static unsigned int take_u(unsigned int x) { return x; }
static long take_l(long x) { return x; }

static void expect(const char *got, const char *want, const char *msg)
{
    Assert(strcmp(got, want) == 0, (char *)msg);
}

void test_constpush(void)
{
    char buf[40];
    unsigned int n = 1000;
    long widened = MAINBANK_ADDR;

    sprintf(buf, "%u", MAINBANK_ADDR);
    expect(buf, "32768", "%u of 65536 - 16384*2");

    sprintf(buf, "%u", 65536 - 1);
    expect(buf, "65535", "%u of 65536 - 1");

    sprintf(buf, "%d", 65536 - 65537);
    expect(buf, "-1", "%d of a folded long that fits in a signed int");

    sprintf(buf, "%u %u", MAINBANK_ADDR, 65536 - 1);
    expect(buf, "32768 65535", "two fitted constants share the argument count");

    sprintf(buf, "%u %ld", MAINBANK_ADDR, 1L);
    expect(buf, "32768 1", "a fitted int beside an explicit long");

    sprintf(buf, "%ld %u", 65536L - 32768, 7);
    expect(buf, "32768 7", "an L suffix stays a long beside an int");

    sprintf(buf, "%ld", (long)MAINBANK_ADDR);
    expect(buf, "32768", "a cast to long stays a long");

    sprintf(buf, "%ld", 1L);
    expect(buf, "1", "1L stays a long");

    sprintf(buf, "%lu", 65536);
    expect(buf, "65536", "65536 does not fit in 16 bits");

    sprintf(buf, "%ld", 0 - 65536);
    expect(buf, "-65536", "a folded long below -32768 stays a long");

    sprintf(buf, "%lu", 65536 - n);
    expect(buf, "64536", "a runtime long is not narrowed");

    sprintf(buf, "%u", (unsigned)MAINBANK_ADDR);
    expect(buf, "32768", "an unsigned cast is a 16-bit push");

    Assert(take_u(MAINBANK_ADDR) == 32768, "prototype unsigned int narrows");
    Assert(take_l(MAINBANK_ADDR) == 32768L, "prototype long keeps the value");
    Assert(widened == 32768L, "assignment to long keeps the folded value");
}

int suite_constpush(void)
{
    suite_setup("Const push width");
    suite_add_test(test_constpush);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_constpush();
    exit(res);
}
