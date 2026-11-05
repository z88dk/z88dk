/* [deadframe] with [autopush-param]: a __z88dk_fastcall word parameter whose
 * home is a slot is stored by the prologue `push hl`. When the body only uses
 * it in HL, that slot is never read, so the whole frame looks dead. The frame
 * must stay: dropping it kept the `push hl` but not the matching pop, and
 * `ret` returned into the argument.
 *
 * Every argument is the address of trap(), so a `ret` into the argument fails
 * the run at once instead of running away.
 *
 *  - add      return x + 3 (the shape of the report)
 *  - twice    return x + x
 *  - neg      return -x
 *  - ptr      a pointer parameter, return p + 1
 *  - sum      two calls in one expression, as in the report
 */
#include "test.h"
#include <stdio.h>

static void trap(void)
{
    printf("returned into the argument\n");
    exit(1);
}

static unsigned int add3(unsigned int x) __z88dk_fastcall { return x + 3; }
static unsigned int twice(unsigned int x) __z88dk_fastcall { return x + x; }
static int neg(int x) __z88dk_fastcall { return -x; }
static char *ptr1(char *p) __z88dk_fastcall { return p + 1; }

#define T ((unsigned int)trap)

static void test_add(void)
{
    Assert(add3(T) == T + 3, "add");
}

static void test_twice(void)
{
    Assert(twice(T) == T + T, "twice");
}

static void test_neg(void)
{
    Assert(neg((int)T) == -(int)T, "neg");
}

static void test_ptr(void)
{
    Assert(ptr1((char *)trap) == (char *)trap + 1, "ptr");
}

static unsigned int g;

static void test_sum(void)
{
    g = add3(T);
    g += add3(T);
    Assert(g == T + 3 + T + 3, "sum");
}

int suite_fcdeadframe(void)
{
    suite_setup("fc-deadframe");
    suite_add_test(test_add);
    suite_add_test(test_twice);
    suite_add_test(test_neg);
    suite_add_test(test_ptr);
    suite_add_test(test_sum);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_fcdeadframe();
    exit(res);
}
