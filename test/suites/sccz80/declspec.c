#include "test.h"
#include <stdlib.h>

/* Storage class and type qualifiers may appear in any order. */

static int one(void)
{
    return 1;
}

static int two(void)
{
    return 2;
}

const static int z = 5;
int const static w = 6;
static const int s = 7;
const unsigned static int u = 8;
volatile static int q = 9;

const typedef int cinti;
static cinti ct = 10;
typedef const int cinti2;
static cinti2 ct2 = 11;

const static int (*ops[])(void) = { one, two };

const extern int ext_value;
const int ext_value = 12;

static int local_orders(void)
{
    const static int local = 13;
    volatile static int step = 1;

    Assert(local == 13, "local const static");
    Assert(step == 1, "local volatile static");
    return local + step;
}

void test_declspec(void)
{
    Assert(z == 5, "const static int");
    Assert(w == 6, "int const static");
    Assert(s == 7, "static const int");
    Assert(u == 8, "const unsigned static");
    Assert(q == 9, "volatile static");
    Assert(ct == 10, "const typedef");
    Assert(ct2 == 11, "typedef const");
    Assert(ops[0]() == 1, "const static function pointer");
    Assert(ops[1]() == 2, "const static function pointer 2");
    Assert(ext_value == 12, "const extern");
    Assert(local_orders() == 14, "local specifier order");
}

int suite_declspec(void)
{
    suite_setup("Declaration specifier order");
    suite_add_test(test_declspec);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_declspec();
    exit(res);
}
