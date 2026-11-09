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

int unsigned iu = 21;
long unsigned int lui = 22;
int long il = 23;
char signed sc = -5;
short unsigned su = 25;

/* +test is org 0 and the stack sits at 0xff00. 0x2d is inside that crt. */
static __at(0xc000) unsigned char at_a;
const static __at(0xc001) unsigned char at_b = 0x5a;

__sfr __at 0x00 char io_port;

static int smallc_f(void) __smallc
{
    return 9;
}

static int preserves_g(void) __preserves_regs(b, c)
{
    return 8;
}

static int local_orders(void)
{
    const static int local = 13;
    volatile static int step = 1;
    typedef int Tloc;
    Tloc n = 4;

    Assert(local == 13, "local const static");
    Assert(step == 1, "local volatile static");
    Assert(sizeof(n) == 2, "block typedef");
    {
        typedef char Tloc;
        Tloc c = 2;

        Assert(sizeof(c) == 1, "inner typedef");
        n = n + c;
    }
    Assert(sizeof(n) == 2, "outer typedef remains");
    return local + step + n;
}

static int placed_orders(void)
{
    unsigned char saw;

    at_a = 0x3c;
    io_port = 0x5a;
    saw = io_port;
    return at_a == 0x3c && at_b == 0x5a && saw == io_port;
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
    Assert(iu == 21, "int unsigned");
    Assert(lui == 22, "long unsigned int");
    Assert(il == 23, "int long");
    Assert(sizeof(il) == 4, "int long width");
    Assert(sc < 0, "char signed");
    Assert(sizeof(sc) == 1, "char signed width");
    Assert(su == 25, "short unsigned");
    Assert(sizeof(su) == 2, "short unsigned width");
    Assert(smallc_f() == 9, "static __smallc");
    Assert(preserves_g() == 8, "static __preserves_regs");
    Assert(placed_orders() == 1, "at and sfr");
    Assert(local_orders() == 20, "local specifier order");
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
